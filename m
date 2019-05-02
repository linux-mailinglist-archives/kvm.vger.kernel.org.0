Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BBE61240A
	for <lists+kvm@lfdr.de>; Thu,  2 May 2019 23:20:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726150AbfEBVU2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 May 2019 17:20:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48234 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725995AbfEBVU2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 May 2019 17:20:28 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 540242D7ED;
        Thu,  2 May 2019 21:20:27 +0000 (UTC)
Received: from maximlenovopc.usersys.redhat.com (unknown [10.35.206.58])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 714415C1B4;
        Thu,  2 May 2019 21:20:18 +0000 (UTC)
Message-ID: <f1f471e0b734413e6c0f7a8bb1a03041b1d12d6d.camel@redhat.com>
Subject: Re: [PATCH v2 08/10] nvme/pci: implement the mdev external queue
 allocation interface
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     "Heitke, Kenneth" <kenneth.heitke@intel.com>,
        linux-nvme@lists.infradead.org
Cc:     Fam Zheng <fam@euphon.net>, Keith Busch <keith.busch@intel.com>,
        Sagi Grimberg <sagi@grimberg.me>, kvm@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Liang Cunming <cunming.liang@intel.com>,
        Wolfram Sang <wsa@the-dreams.de>, linux-kernel@vger.kernel.org,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Jens Axboe <axboe@fb.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        John Ferlan <jferlan@redhat.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Liu Changpeng <changpeng.liu@intel.com>,
        "Paul E . McKenney" <paulmck@linux.ibm.com>,
        Amnon Ilan <ailan@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Nicolas Ferre <nicolas.ferre@microchip.com>
Date:   Fri, 03 May 2019 00:20:17 +0300
In-Reply-To: <63a499c3-25be-5c5b-5822-124854945279@intel.com>
References: <20190502114801.23116-1-mlevitsk@redhat.com>
         <20190502114801.23116-9-mlevitsk@redhat.com>
         <63a499c3-25be-5c5b-5822-124854945279@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Thu, 02 May 2019 21:20:27 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2019-05-02 at 15:12 -0600, Heitke, Kenneth wrote:
> 
> On 5/2/2019 5:47 AM, Maxim Levitsky wrote:
> > Note that currently the number of hw queues reserved for mdev,
> > has to be pre determined on module load.
> > 
> > (I used to allocate the queues dynamicaly on demand, but
> > recent changes to allocate polled/read queues made
> > this somewhat difficult, so I dropped this for now)
> > 
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > ---
> >   drivers/nvme/host/pci.c  | 375 ++++++++++++++++++++++++++++++++++++++-
> >   drivers/nvme/mdev/host.c |  46 ++---
> >   drivers/nvme/mdev/io.c   |  46 +++--
> >   drivers/nvme/mdev/mmio.c |   3 -
> >   4 files changed, 421 insertions(+), 49 deletions(-)
> > 
> > diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
> > index 282f28c851c1..87507e710374 100644
> > --- a/drivers/nvme/host/pci.c
> > +++ b/drivers/nvme/host/pci.c
> > @@ -23,6 +23,7 @@
> >   #include <linux/io-64-nonatomic-lo-hi.h>
> >   #include <linux/sed-opal.h>
> >   #include <linux/pci-p2pdma.h>
> > +#include "../mdev/mdev.h"
> >   
> >   #include "trace.h"
> >   #include "nvme.h"
> > @@ -32,6 +33,7 @@
> >   
> >   #define SGES_PER_PAGE	(PAGE_SIZE / sizeof(struct nvme_sgl_desc))
> >   
> > +#define USE_SMALL_PRP_POOL(nprps) ((nprps) < (256 / 8))
> >   /*
> >    * These can be higher, but we need to ensure that any command doesn't
> >    * require an sg allocation that needs more than a page of data.
> > @@ -83,12 +85,24 @@ static int poll_queues = 0;
> >   module_param_cb(poll_queues, &queue_count_ops, &poll_queues, 0644);
> >   MODULE_PARM_DESC(poll_queues, "Number of queues to use for polled IO.");
> >   
> > +static int mdev_queues;
> > +#ifdef CONFIG_NVME_MDEV
> > +module_param_cb(mdev_queues, &queue_count_ops, &mdev_queues, 0644);
> > +MODULE_PARM_DESC(mdev_queues, "Number of queues to use for mediated VFIO");
> > +#endif
> > +
> >   struct nvme_dev;
> >   struct nvme_queue;
> >   
> >   static void nvme_dev_disable(struct nvme_dev *dev, bool shutdown);
> >   static bool __nvme_disable_io_queues(struct nvme_dev *dev, u8 opcode);
> >   
> > +#ifdef CONFIG_NVME_MDEV
> > +static void nvme_ext_queue_reset(struct nvme_dev *dev, u16 qid);
> > +#else
> > +static void nvme_ext_queue_reset(struct nvme_dev *dev, u16 qid) {}
> > +#endif
> > +
> >   /*
> >    * Represents an NVM Express device.  Each nvme_dev is a PCI function.
> >    */
> > @@ -103,6 +117,7 @@ struct nvme_dev {
> >   	unsigned online_queues;
> >   	unsigned max_qid;
> >   	unsigned io_queues[HCTX_MAX_TYPES];
> > +	unsigned int mdev_queues;
> >   	unsigned int num_vecs;
> >   	int q_depth;
> >   	u32 db_stride;
> > @@ -110,6 +125,7 @@ struct nvme_dev {
> >   	unsigned long bar_mapped_size;
> >   	struct work_struct remove_work;
> >   	struct mutex shutdown_lock;
> > +	struct mutex ext_dev_lock;
> >   	bool subsystem;
> >   	u64 cmb_size;
> >   	bool cmb_use_sqes;
> > @@ -172,6 +188,16 @@ static inline struct nvme_dev *to_nvme_dev(struct
> > nvme_ctrl *ctrl)
> >   	return container_of(ctrl, struct nvme_dev, ctrl);
> >   }
> >   
> > +/* Simplified IO descriptor for MDEV use */
> > +struct nvme_ext_iod {
> > +	struct list_head link;
> > +	u32 user_tag;
> > +	int nprps;
> > +	struct nvme_ext_data_iter *saved_iter;
> > +	dma_addr_t first_prplist_dma;
> > +	__le64 *prpslists[NVME_MAX_SEGS];
> > +};
> > +
> >   /*
> >    * An NVM Express queue.  Each device has at least two (one for admin
> >    * commands and one for I/O commands).
> > @@ -196,15 +222,26 @@ struct nvme_queue {
> >   	u16 qid;
> >   	u8 cq_phase;
> >   	unsigned long flags;
> > +
> >   #define NVMEQ_ENABLED		0
> >   #define NVMEQ_SQ_CMB		1
> >   #define NVMEQ_DELETE_ERROR	2
> >   #define NVMEQ_POLLED		3
> > +#define NVMEQ_EXTERNAL		4
> > +
> >   	u32 *dbbuf_sq_db;
> >   	u32 *dbbuf_cq_db;
> >   	u32 *dbbuf_sq_ei;
> >   	u32 *dbbuf_cq_ei;
> >   	struct completion delete_done;
> > +
> > +	/* queue passthrough for external use */
> > +	struct {
> > +		int inflight;
> > +		struct nvme_ext_iod *iods;
> > +		struct list_head free_iods;
> > +		struct list_head used_iods;
> > +	} ext;
> >   };
> >   
> >   /*
> > @@ -255,7 +292,7 @@ static inline void _nvme_check_size(void)
> >   
> >   static unsigned int max_io_queues(void)
> >   {
> > -	return num_possible_cpus() + write_queues + poll_queues;
> > +	return num_possible_cpus() + write_queues + poll_queues + mdev_queues;
> >   }
> >   
> >   static unsigned int max_queue_count(void)
> > @@ -1066,6 +1103,7 @@ static irqreturn_t nvme_irq(int irq, void *data)
> >   	 * the irq handler, even if that was on another CPU.
> >   	 */
> >   	rmb();
> > +
> >   	if (nvmeq->cq_head != nvmeq->last_cq_head)
> >   		ret = IRQ_HANDLED;
> >   	nvme_process_cq(nvmeq, &start, &end, -1);
> > @@ -1553,7 +1591,11 @@ static void nvme_init_queue(struct nvme_queue *nvmeq,
> > u16 qid)
> >   	memset((void *)nvmeq->cqes, 0, CQ_SIZE(nvmeq->q_depth));
> >   	nvme_dbbuf_init(dev, nvmeq, qid);
> >   	dev->online_queues++;
> > +
> >   	wmb(); /* ensure the first interrupt sees the initialization */
> > +
> > +	if (test_bit(NVMEQ_EXTERNAL, &nvmeq->flags))
> > +		nvme_ext_queue_reset(nvmeq->dev, qid);
> >   }
> >   
> >   static int nvme_create_queue(struct nvme_queue *nvmeq, int qid, bool
> > polled)
> > @@ -1759,7 +1801,7 @@ static int nvme_create_io_queues(struct nvme_dev *dev)
> >   	}
> >   
> >   	max = min(dev->max_qid, dev->ctrl.queue_count - 1);
> > -	if (max != 1 && dev->io_queues[HCTX_TYPE_POLL]) {
> > +	if (max != 1) {
> >   		rw_queues = dev->io_queues[HCTX_TYPE_DEFAULT] +
> >   				dev->io_queues[HCTX_TYPE_READ];
> >   	} else {
> > @@ -2095,14 +2137,23 @@ static int nvme_setup_irqs(struct nvme_dev *dev,
> > unsigned int nr_io_queues)
> >   	 * Poll queues don't need interrupts, but we need at least one IO
> >   	 * queue left over for non-polled IO.
> >   	 */
> > -	this_p_queues = poll_queues;
> > +	this_p_queues = poll_queues + mdev_queues;
> >   	if (this_p_queues >= nr_io_queues) {
> >   		this_p_queues = nr_io_queues - 1;
> >   		irq_queues = 1;
> >   	} else {
> >   		irq_queues = nr_io_queues - this_p_queues + 1;
> >   	}
> > +
> > +	if (mdev_queues > this_p_queues) {
> > +		mdev_queues = this_p_queues;
> > +		this_p_queues = 0;
> > +	} else {
> > +		this_p_queues -= mdev_queues;
> > +	}
> > +
> >   	dev->io_queues[HCTX_TYPE_POLL] = this_p_queues;
> > +	dev->mdev_queues = mdev_queues;
> >   
> >   	/* Initialize for the single interrupt case */
> >   	dev->io_queues[HCTX_TYPE_DEFAULT] = 1;
> > @@ -2170,7 +2221,8 @@ static int nvme_setup_io_queues(struct nvme_dev *dev)
> >   
> >   	dev->num_vecs = result;
> >   	result = max(result - 1, 1);
> > -	dev->max_qid = result + dev->io_queues[HCTX_TYPE_POLL];
> > +	dev->max_qid = result + dev->io_queues[HCTX_TYPE_POLL] +
> > +			dev->mdev_queues;
> >   
> >   	/*
> >   	 * Should investigate if there's a performance win from allocating
> > @@ -2193,10 +2245,11 @@ static int nvme_setup_io_queues(struct nvme_dev
> > *dev)
> >   		nvme_suspend_io_queues(dev);
> >   		goto retry;
> >   	}
> > -	dev_info(dev->ctrl.device, "%d/%d/%d default/read/poll queues\n",
> > +	dev_info(dev->ctrl.device, "%d/%d/%d/%d default/read/poll/mdev
> > queues\n",
> >   					dev->io_queues[HCTX_TYPE_DEFAULT],
> >   					dev->io_queues[HCTX_TYPE_READ],
> > -					dev->io_queues[HCTX_TYPE_POLL]);
> > +					dev->io_queues[HCTX_TYPE_POLL],
> > +					dev->mdev_queues);
> >   	return 0;
> >   }
> >   
> > @@ -2623,6 +2676,301 @@ static void nvme_remove_dead_ctrl_work(struct
> > work_struct *work)
> >   	nvme_put_ctrl(&dev->ctrl);
> >   }
> >   
> > +#ifdef CONFIG_NVME_MDEV
> > +static void nvme_ext_free_iod(struct nvme_dev *dev, struct nvme_ext_iod
> > *iod)
> > +{
> > +	int i = 0, max_prp, nprps = iod->nprps;
> > +	dma_addr_t dma = iod->first_prplist_dma;
> > +
> > +	if (iod->saved_iter) {
> > +		iod->saved_iter->release(iod->saved_iter);
> > +		iod->saved_iter = NULL;
> > +	}
> > +
> > +	if (--nprps < 2) {
> > +		goto out;
> > +	} else if (USE_SMALL_PRP_POOL(nprps)) {
> > +		dma_pool_free(dev->prp_small_pool, iod->prpslists[0], dma);
> > +		goto out;
> > +	}
> > +
> > +	max_prp = (dev->ctrl.page_size >> 3) - 1;
> > +	while (nprps > 0) {
> > +		if (i > 0) {
> > +			dma = iod->prpslists[i - 1][max_prp];
> > +			if (nprps == 1)
> > +				break;
> > +		}
> > +		dma_pool_free(dev->prp_page_pool, iod->prpslists[i++], dma);
> > +		nprps -= max_prp;
> > +	}
> > +out:
> > +	iod->nprps = -1;
> > +	iod->first_prplist_dma = 0;
> > +	iod->user_tag = 0xDEADDEAD;
> > +}
> > +
> > +static int nvme_ext_setup_iod(struct nvme_dev *dev, struct nvme_ext_iod
> > *iod,
> > +			      struct nvme_common_command *cmd,
> > +			      struct nvme_ext_data_iter *iter)
> > +{
> > +	int ret, i, j;
> > +	__le64 *prp_list;
> > +	dma_addr_t prp_dma;
> > +	struct dma_pool *pool;
> > +	int max_prp = (dev->ctrl.page_size >> 3) - 1;
> > +
> > +	iod->saved_iter = iter && iter->release ? iter : NULL;
> > +	iod->nprps = iter ? iter->count : 0;
> > +	cmd->dptr.prp1 = 0;
> > +	cmd->dptr.prp2 = 0;
> > +	cmd->metadata = 0;
> > +
> > +	if (!iter)
> > +		return 0;
> > +
> > +	/* put first pointer*/
> > +	cmd->dptr.prp1 = cpu_to_le64(iter->host_iova);
> > +	if (iter->count == 1)
> > +		return 0;
> > +
> > +	ret = iter->next(iter);
> > +	if (ret)
> > +		goto error;
> > +
> > +	/* if only have one more pointer, put it to second data pointer*/
> > +	if (iter->count == 1) {
> > +		cmd->dptr.prp2 = cpu_to_le64(iter->host_iova);
> > +		return 0;
> > +	}
> > +
> > +	pool = USE_SMALL_PRP_POOL(iter->count) ?  dev->prp_small_pool :
> > +						  dev->prp_page_pool;
> > +
> > +	/* Allocate prp lists as needed and fill them */
> > +	for (i = 0 ; i < NVME_MAX_SEGS && iter->count ; i++) {
> > +		prp_list = dma_pool_alloc(pool, GFP_ATOMIC, &prp_dma);
> > +		if (!prp_list) {
> > +			ret = -ENOMEM;
> > +			goto error;
> > +		}
> > +
> > +		iod->prpslists[i++] = prp_list;
> > +
> > +		if (i == 1) {
> > +			iod->first_prplist_dma = prp_dma;
> > +			cmd->dptr.prp2 = cpu_to_le64(prp_dma);
> > +			j = 0;
> > +		} else {
> > +			prp_list[0] = iod->prpslists[i - 1][max_prp];
> > +			iod->prpslists[i - 1][max_prp] = prp_dma;
> > +			j = 1;
> > +		}
> > +
> > +		while (j <= max_prp && iter->count) {
> > +			prp_list[j++] = iter->host_iova;
> > +			ret = iter->next(iter);
> > +			if (ret)
> > +				goto error;
> > +		}
> > +	}
> > +
> > +	if (iter->count) {
> > +		ret = -ENOSPC;
> > +		goto error;
> > +	}
> > +	return 0;
> > +error:
> > +	iod->nprps -= iter->count;
> > +	nvme_ext_free_iod(dev, iod);
> > +	return ret;
> > +}
> > +
> > +static int nvme_ext_queues_available(struct nvme_ctrl *ctrl)
> > +{
> > +	struct nvme_dev *dev = to_nvme_dev(ctrl);
> > +	unsigned int ret = 0, qid;
> > +	unsigned int first_mdev_q = dev->online_queues - dev->mdev_queues;
> > +
> > +	for (qid = first_mdev_q; qid < dev->online_queues; qid++) {
> > +		struct nvme_queue *nvmeq = &dev->queues[qid];
> > +
> > +		if (!test_bit(NVMEQ_EXTERNAL, &nvmeq->flags))
> > +			ret++;
> > +	}
> > +	return ret;
> > +}
> > +
> > +static void nvme_ext_queue_reset(struct nvme_dev *dev, u16 qid)
> > +{
> > +	struct nvme_queue *nvmeq = &dev->queues[qid];
> > +	struct nvme_ext_iod *iod, *tmp;
> > +
> > +	list_for_each_entry_safe(iod, tmp, &nvmeq->ext.used_iods, link) {
> > +		if (iod->saved_iter && iod->saved_iter->release) {
> > +			iod->saved_iter->release(iod->saved_iter);
> > +			iod->saved_iter = NULL;
> > +			list_move(&iod->link, &nvmeq->ext.free_iods);
> > +		}
> > +	}
> > +
> > +	nvmeq->ext.inflight = 0;
> > +}
> > +
> > +static int nvme_ext_queue_alloc(struct nvme_ctrl *ctrl, u16 *ret_qid)
> > +{
> > +	struct nvme_dev *dev = to_nvme_dev(ctrl);
> > +	struct nvme_queue *nvmeq;
> > +	int ret = 0, qid, i;
> > +	unsigned int first_mdev_q = dev->online_queues - dev->mdev_queues;
> > +
> > +	mutex_lock(&dev->ext_dev_lock);
> > +
> > +	/* find a polled queue to allocate */
> > +	for (qid = dev->online_queues - 1 ; qid >= first_mdev_q ; qid--) {
> > +		nvmeq = &dev->queues[qid];
> > +		if (!test_bit(NVMEQ_EXTERNAL, &nvmeq->flags))
> > +			break;
> > +	}
> > +
> > +	if (qid < first_mdev_q) {
> > +		ret = -ENOSPC;
> > +		goto out;
> > +	}
> > +
> > +	INIT_LIST_HEAD(&nvmeq->ext.free_iods);
> > +	INIT_LIST_HEAD(&nvmeq->ext.used_iods);
> > +
> > +	nvmeq->ext.iods =
> > +		vzalloc_node(sizeof(struct nvme_ext_iod) * nvmeq->q_depth,
> > +			     dev_to_node(dev->dev));
> > +
> > +	if (!nvmeq->ext.iods) {
> > +		ret = -ENOMEM;
> > +		goto out;
> > +	}
> > +
> > +	for (i = 0 ; i < nvmeq->q_depth ; i++)
> > +		list_add_tail(&nvmeq->ext.iods[i].link, &nvmeq->ext.free_iods);
> > +
> > +	set_bit(NVMEQ_EXTERNAL, &nvmeq->flags);
> > +	*ret_qid = qid;
> > +out:
> > +	mutex_unlock(&dev->ext_dev_lock);
> > +	return ret;
> > +}
> > +
> > +static void nvme_ext_queue_free(struct nvme_ctrl *ctrl, u16 qid)
> > +{
> > +	struct nvme_dev *dev = to_nvme_dev(ctrl);
> > +	struct nvme_queue *nvmeq;
> > +
> > +	mutex_lock(&dev->ext_dev_lock);
> > +	nvmeq = &dev->queues[qid];
> > +
> > +	if (WARN_ON(!test_bit(NVMEQ_EXTERNAL, &nvmeq->flags)))
> > +		return;
> 
> This condition is probably not expected to happen (since its a warning)
> but do you need to unlock the ext_dev_lock before returning?

This is true, I will fix this. This used to be BUG_ON, but due to checkpatch.pl
complains I turned them all to WARN_ON, and missed this.

Thanks,
	Best regards,
		Maxim Levitsky


> 
> > +
> > +	nvme_ext_queue_reset(dev, qid);
> > +
> > +	vfree(nvmeq->ext.iods);
> > +	nvmeq->ext.iods = NULL;
> > +	INIT_LIST_HEAD(&nvmeq->ext.free_iods);
> > +	INIT_LIST_HEAD(&nvmeq->ext.used_iods);
> > +
> > +	clear_bit(NVMEQ_EXTERNAL, &nvmeq->flags);
> > +	mutex_unlock(&dev->ext_dev_lock);
> > +}
> > +
> > +static int nvme_ext_queue_submit(struct nvme_ctrl *ctrl, u16 qid, u32
> > user_tag,
> > +				 struct nvme_command *command,
> > +				 struct nvme_ext_data_iter *iter)
> > +{
> > +	struct nvme_dev *dev = to_nvme_dev(ctrl);
> > +	struct nvme_queue *nvmeq = &dev->queues[qid];
> > +	struct nvme_ext_iod *iod;
> > +	int ret;
> > +
> > +	if (WARN_ON(!test_bit(NVMEQ_EXTERNAL, &nvmeq->flags)))
> > +		return -EINVAL;
> > +
> > +	if (list_empty(&nvmeq->ext.free_iods))
> > +		return -1;
> > +
> > +	iod = list_first_entry(&nvmeq->ext.free_iods,
> > +			       struct nvme_ext_iod, link);
> > +
> > +	list_move(&iod->link, &nvmeq->ext.used_iods);
> > +
> > +	command->common.command_id = cpu_to_le16(iod - nvmeq->ext.iods);
> > +	iod->user_tag = user_tag;
> > +
> > +	ret = nvme_ext_setup_iod(dev, iod, &command->common, iter);
> > +	if (ret) {
> > +		list_move(&iod->link, &nvmeq->ext.free_iods);
> > +		return ret;
> > +	}
> > +
> > +	nvmeq->ext.inflight++;
> > +	nvme_submit_cmd(nvmeq, command, true);
> > +	return 0;
> > +}
> > +
> > +static int nvme_ext_queue_poll(struct nvme_ctrl *ctrl, u16 qid,
> > +			       struct nvme_ext_cmd_result *results,
> > +			       unsigned int max_len)
> > +{
> > +	struct nvme_dev *dev = to_nvme_dev(ctrl);
> > +	struct nvme_queue *nvmeq = &dev->queues[qid];
> > +	u16 old_head;
> > +	int i, j;
> > +
> > +	if (WARN_ON(!test_bit(NVMEQ_EXTERNAL, &nvmeq->flags)))
> > +		return -EINVAL;
> > +
> > +	if (nvmeq->ext.inflight == 0)
> > +		return -1;
> > +
> > +	old_head = nvmeq->cq_head;
> > +
> > +	for (i = 0 ; nvme_cqe_pending(nvmeq) && i < max_len ; i++) {
> > +		u16 status = le16_to_cpu(nvmeq->cqes[nvmeq->cq_head].status);
> > +		u16 tag = le16_to_cpu(nvmeq->cqes[nvmeq->cq_head].command_id);
> > +
> > +		results[i].status = status >> 1;
> > +		results[i].tag = (u32)tag;
> > +		nvme_update_cq_head(nvmeq);
> > +	}
> > +
> > +	if (old_head != nvmeq->cq_head)
> > +		nvme_ring_cq_doorbell(nvmeq);
> > +
> > +	for (j = 0 ; j < i ; j++)  {
> > +		u16 tag = results[j].tag & 0xFFFF;
> > +		struct nvme_ext_iod *iod = &nvmeq->ext.iods[tag];
> > +
> > +		if (WARN_ON(tag >= nvmeq->q_depth || iod->nprps == -1))
> > +			continue;
> > +
> > +		results[j].tag = iod->user_tag;
> > +		nvme_ext_free_iod(dev, iod);
> > +		list_move(&iod->link, &nvmeq->ext.free_iods);
> > +		nvmeq->ext.inflight--;
> > +	}
> > +
> > +	WARN_ON(nvmeq->ext.inflight < 0);
> > +	return i;
> > +}
> > +
> > +static bool nvme_ext_queue_full(struct nvme_ctrl *ctrl, u16 qid)
> > +{
> > +	struct nvme_dev *dev = to_nvme_dev(ctrl);
> > +	struct nvme_queue *nvmeq = &dev->queues[qid];
> > +
> > +	return nvmeq->ext.inflight < nvmeq->q_depth - 1;
> > +}
> > +#endif
> > +
> >   static int nvme_pci_reg_read32(struct nvme_ctrl *ctrl, u32 off, u32 *val)
> >   {
> >   	*val = readl(to_nvme_dev(ctrl)->bar + off);
> > @@ -2652,13 +3000,25 @@ static const struct nvme_ctrl_ops nvme_pci_ctrl_ops
> > = {
> >   	.name			= "pcie",
> >   	.module			= THIS_MODULE,
> >   	.flags			= NVME_F_METADATA_SUPPORTED |
> > -				  NVME_F_PCI_P2PDMA,
> > +				  NVME_F_PCI_P2PDMA |
> > +				  NVME_F_MDEV_SUPPORTED |
> > +				  NVME_F_MDEV_DMA_SUPPORTED,
> > +
> >   	.reg_read32		= nvme_pci_reg_read32,
> >   	.reg_write32		= nvme_pci_reg_write32,
> >   	.reg_read64		= nvme_pci_reg_read64,
> >   	.free_ctrl		= nvme_pci_free_ctrl,
> >   	.submit_async_event	= nvme_pci_submit_async_event,
> >   	.get_address		= nvme_pci_get_address,
> > +
> > +#ifdef CONFIG_NVME_MDEV
> > +	.ext_queues_available	= nvme_ext_queues_available,
> > +	.ext_queue_alloc	= nvme_ext_queue_alloc,
> > +	.ext_queue_free		= nvme_ext_queue_free,
> > +	.ext_queue_submit	= nvme_ext_queue_submit,
> > +	.ext_queue_poll		= nvme_ext_queue_poll,
> > +	.ext_queue_full		= nvme_ext_queue_full,
> > +#endif
> >   };
> >   
> >   static int nvme_dev_map(struct nvme_dev *dev)
> > @@ -2747,6 +3107,7 @@ static int nvme_probe(struct pci_dev *pdev, const
> > struct pci_device_id *id)
> >   	INIT_WORK(&dev->ctrl.reset_work, nvme_reset_work);
> >   	INIT_WORK(&dev->remove_work, nvme_remove_dead_ctrl_work);
> >   	mutex_init(&dev->shutdown_lock);
> > +	mutex_init(&dev->ext_dev_lock);
> >   
> >   	result = nvme_setup_prp_pools(dev);
> >   	if (result)
> > diff --git a/drivers/nvme/mdev/host.c b/drivers/nvme/mdev/host.c
> > index 5766bad7e909..6590946b86c2 100644
> > --- a/drivers/nvme/mdev/host.c
> > +++ b/drivers/nvme/mdev/host.c
> > @@ -48,19 +48,21 @@ static struct nvme_mdev_hctrl
> > *nvme_mdev_hctrl_create(struct nvme_ctrl *ctrl)
> >   		return NULL;
> >   	}
> >   
> > +	hctrl = kzalloc_node(sizeof(*hctrl), GFP_KERNEL,
> > +			     dev_to_node(ctrl->dev));
> > +	if (!hctrl)
> > +		return NULL;
> > +
> >   	nr_host_queues = ctrl->ops->ext_queues_available(ctrl);
> >   	max_lba_transfer = ctrl->max_hw_sectors >> (PAGE_SHIFT - 9);
> >   
> >   	if (nr_host_queues == 0) {
> >   		dev_info(ctrl->dev,
> >   			 "no support for mdev - no mdev reserved queues
> > available");
> > +		kfree(hctrl);
> >   		return NULL;
> >   	}
> >   
> > -	hctrl = kzalloc_node(sizeof(*hctrl), GFP_KERNEL,
> > -			     dev_to_node(ctrl->dev));
> > -	if (!hctrl)
> > -		return NULL;
> >   
> >   	kref_init(&hctrl->ref);
> >   	mutex_init(&hctrl->lock);
> > @@ -180,6 +182,24 @@ void nvme_mdev_hctrl_hqs_unreserve(struct
> > nvme_mdev_hctrl *hctrl,
> >   	mutex_unlock(&hctrl->lock);
> >   }
> >   
> > +/* Check if IO passthrough is supported for given IO optcode */
> > +bool nvme_mdev_hctrl_hq_check_op(struct nvme_mdev_hctrl *hctrl, u8 optcode)
> > +{
> > +	switch (optcode) {
> > +	case nvme_cmd_flush:
> > +	case nvme_cmd_read:
> > +	case nvme_cmd_write:
> > +		/* these are mandatory*/
> > +		return true;
> > +	case nvme_cmd_write_zeroes:
> > +		return (hctrl->oncs & NVME_CTRL_ONCS_WRITE_ZEROES);
> > +	case nvme_cmd_dsm:
> > +		return (hctrl->oncs & NVME_CTRL_ONCS_DSM);
> > +	default:
> > +		return false;
> > +	}
> > +}
> > +
> >   /* Allocate a host IO queue */
> >   int nvme_mdev_hctrl_hq_alloc(struct nvme_mdev_hctrl *hctrl)
> >   {
> > @@ -204,23 +224,7 @@ bool nvme_mdev_hctrl_hq_can_submit(struct
> > nvme_mdev_hctrl *hctrl, u16 qid)
> >   	return hctrl->nvme_ctrl->ops->ext_queue_full(hctrl->nvme_ctrl, qid);
> >   }
> >   
> > -/* Check if IO passthrough is supported for given IO optcode */
> > -bool nvme_mdev_hctrl_hq_check_op(struct nvme_mdev_hctrl *hctrl, u8 optcode)
> > -{
> > -	switch (optcode) {
> > -	case nvme_cmd_flush:
> > -	case nvme_cmd_read:
> > -	case nvme_cmd_write:
> > -		/* these are mandatory*/
> > -		return true;
> > -	case nvme_cmd_write_zeroes:
> > -		return (hctrl->oncs & NVME_CTRL_ONCS_WRITE_ZEROES);
> > -	case nvme_cmd_dsm:
> > -		return (hctrl->oncs & NVME_CTRL_ONCS_DSM);
> > -	default:
> > -		return false;
> > -	}
> > -}
> > +
> >   
> >   /* Submit a IO passthrough command */
> >   int nvme_mdev_hctrl_hq_submit(struct nvme_mdev_hctrl *hctrl,
> > diff --git a/drivers/nvme/mdev/io.c b/drivers/nvme/mdev/io.c
> > index a731196d0365..59837540fec2 100644
> > --- a/drivers/nvme/mdev/io.c
> > +++ b/drivers/nvme/mdev/io.c
> > @@ -11,14 +11,16 @@
> >   #include <linux/ktime.h>
> >   #include "priv.h"
> >   
> > +
> >   struct io_ctx {
> >   	struct nvme_mdev_hctrl *hctrl;
> >   	struct nvme_mdev_vctrl *vctrl;
> >   
> >   	const struct nvme_command *in;
> > -	struct nvme_command out;
> >   	struct nvme_mdev_vns *ns;
> >   	struct nvme_ext_data_iter udatait;
> > +
> > +	struct nvme_command out;
> >   	struct nvme_ext_data_iter *kdatait;
> >   
> >   	ktime_t last_io_t;
> > @@ -28,6 +30,20 @@ struct io_ctx {
> >   	unsigned int arb_burst;
> >   };
> >   
> > +/* Check if we need to read a command from the admin queue */
> > +static bool nvme_mdev_adm_needs_processing(struct io_ctx *ctx)
> > +{
> > +	if (!timeout(ctx->last_admin_poll_time,
> > +		     ctx->vctrl->now, ctx->admin_poll_rate_ms))
> > +		return false;
> > +
> > +	if (nvme_mdev_vsq_has_data(ctx->vctrl, &ctx->vctrl->vsqs[0]))
> > +		return true;
> > +
> > +	ctx->last_admin_poll_time = ctx->vctrl->now;
> > +	return false;
> > +}
> > +
> >   /* Handle read/write command.*/
> >   static int nvme_mdev_io_translate_rw(struct io_ctx *ctx)
> >   {
> > @@ -229,6 +245,7 @@ static int nvme_mdev_io_translate_cmd(struct io_ctx
> > *ctx)
> >   	}
> >   }
> >   
> > +/* process a user submission queue */
> >   static bool nvme_mdev_io_process_sq(struct io_ctx *ctx, u16 sqid)
> >   {
> >   	struct nvme_vsq *vsq = &ctx->vctrl->vsqs[sqid];
> > @@ -275,7 +292,13 @@ static bool nvme_mdev_io_process_sq(struct io_ctx *ctx,
> > u16 sqid)
> >   	return true;
> >   }
> >   
> > -/* process host replies to the passed through commands */
> > +/* process a user completion queue */
> > +static void nvme_mdev_io_process_cq(struct io_ctx *ctx, u16 cqid)
> > +{
> > +	nvme_mdev_vcq_process(ctx->vctrl, cqid, true);
> > +}
> > +
> > +/* process hardware completion queue */
> >   static int nvme_mdev_io_process_hwq(struct io_ctx *ctx, u16 hwq)
> >   {
> >   	int n, i;
> > @@ -301,22 +324,9 @@ static int nvme_mdev_io_process_hwq(struct io_ctx *ctx,
> > u16 hwq)
> >   	return n;
> >   }
> >   
> > -/* Check if we need to read a command from the admin queue */
> > -static bool nvme_mdev_adm_needs_processing(struct io_ctx *ctx)
> > -{
> > -	if (!timeout(ctx->last_admin_poll_time,
> > -		     ctx->vctrl->now, ctx->admin_poll_rate_ms))
> > -		return false;
> > -
> > -	if (nvme_mdev_vsq_has_data(ctx->vctrl, &ctx->vctrl->vsqs[0]))
> > -		return true;
> > -
> > -	ctx->last_admin_poll_time = ctx->vctrl->now;
> > -	return false;
> > -}
> >   
> >   /* do polling till one of events stops it */
> > -static void nvme_mdev_io_maintask(struct io_ctx *ctx)
> > +static void nvme_mdev_io_polling_loop(struct io_ctx *ctx)
> >   {
> >   	struct nvme_mdev_vctrl *vctrl = ctx->vctrl;
> >   	u16 i, cqid, sqid, hsqcnt;
> > @@ -353,7 +363,7 @@ static void nvme_mdev_io_maintask(struct io_ctx *ctx)
> >   		/* process the completions from the guest*/
> >   		cqid = 1;
> >   		for_each_set_bit_from(cqid, vctrl->vcq_en, MAX_VIRTUAL_QUEUES)
> > -			nvme_mdev_vcq_process(vctrl, cqid, true);
> > +			nvme_mdev_io_process_cq(ctx, cqid);
> >   
> >   		/* process the completions from the hardware*/
> >   		for (i = 0 ; i < hsqcnt ; i++)
> > @@ -470,7 +480,7 @@ static int nvme_mdev_io_polling_thread(void *data)
> >   		if (kthread_should_stop())
> >   			break;
> >   
> > -		nvme_mdev_io_maintask(&ctx);
> > +		nvme_mdev_io_polling_loop(&ctx);
> >   	}
> >   
> >   	_DBG(ctx.vctrl, "IO: iothread stopped\n");
> > diff --git a/drivers/nvme/mdev/mmio.c b/drivers/nvme/mdev/mmio.c
> > index cf03c1f22f4c..a80962bf4a3d 100644
> > --- a/drivers/nvme/mdev/mmio.c
> > +++ b/drivers/nvme/mdev/mmio.c
> > @@ -54,9 +54,6 @@ static const struct vm_operations_struct
> > nvme_mdev_mmio_dbs_vm_ops = {
> >   bool nvme_mdev_mmio_db_check(struct nvme_mdev_vctrl *vctrl,
> >   			     u16 qid, u16 size, u16 db)
> >   {
> > -	if (get_current() != vctrl->iothread)
> > -		lockdep_assert_held(&vctrl->lock);
> > -
> >   	if (db < size)
> >   		return true;
> >   	if (qid == 0) {
> > 


