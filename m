Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CA6D7ACB8
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2019 17:49:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730681AbfG3PtW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Jul 2019 11:49:22 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:30596 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728325AbfG3PtW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 30 Jul 2019 11:49:22 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6UFlJq2092714
        for <kvm@vger.kernel.org>; Tue, 30 Jul 2019 11:49:21 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2u2qvt2qv2-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 30 Jul 2019 11:49:21 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pasic@linux.ibm.com>;
        Tue, 30 Jul 2019 16:49:19 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 30 Jul 2019 16:49:16 +0100
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x6UFnF7345154438
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Jul 2019 15:49:15 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DAC5F11C05B;
        Tue, 30 Jul 2019 15:49:15 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AA06811C04A;
        Tue, 30 Jul 2019 15:49:15 +0000 (GMT)
Received: from oc2783563651 (unknown [9.152.224.193])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 30 Jul 2019 15:49:15 +0000 (GMT)
Date:   Tue, 30 Jul 2019 17:49:10 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Eric Farman <farman@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH RFC UNTESTED] vfio-ccw: indirect access to translated
 cps
In-Reply-To: <20190726100617.19718-1-cohuck@redhat.com>
References: <20190726100617.19718-1-cohuck@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19073015-0008-0000-0000-000003024340
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19073015-0009-0000-0000-0000226FE5A8
Message-Id: <20190730174910.47930494.pasic@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-30_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907300163
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 26 Jul 2019 12:06:17 +0200
Cornelia Huck <cohuck@redhat.com> wrote:

> We're currently keeping a single area for translated channel
> programs in our private structure, which is filled out when
> we are translating a channel program we have been given by
> user space and marked invalid again when we received an final
> interrupt for that I/O.
> 
> Unfortunately, properly tracking the lifetime of that cp is
> not easy: failures may happen during translation or right when
> it is sent to the hardware, unsolicited interrupts may trigger
> a deferred condition code, a halt/clear request may be issued
> while the I/O is supposed to be running, or a reset request may
> come in from the side. The _PROCESSING state and the ->initialized
> flag help a bit, but not enough.
> 
> We want to have a way to figure out whether we actually have a cp
> currently in progress, so we can update/free only when applicable.
> Points to keep in mind:
> - We will get an interrupt after a cp has been submitted iff ssch
>   finished with cc 0.
> - We will get more interrupts for a cp if the interrupt status is
>   not final.
> - We can have only one cp in flight at a time.
> 
> Let's decouple the actual area in the private structure from the
> means to access it: Only after we have successfully submitted a
> cp (ssch with cc 0), update the pointer in the private structure
> to point to the area used. Therefore, the interrupt handler won't
> access the cp if we don't actually expect an interrupt pertaining
> to it.
> 
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> ---
> 
> Just hacked this up to get some feedback, did not actually try it
> out. Not even sure if this is a sensible approach; if not, let's
> blame it on the heat and pretend it didn't happen :)
> 

Do not multiple threads access this new cp pointer (and at least one of
them writes)? If that is the case, it smells like a data race to me.

Besides the only point of converting cp to a pointer seems to be
policing access to cp_area (which used to be cp). I.e. if it is
NULL: don't touch it, otherwise: go ahead. We can do that with a single
bit, we don't need a pointer for that.

Could we convert initialized into some sort of cp.status that
tracks/controls access and responsibilities? By working with bits we
could benefit from the atomicity of bit-ops -- if I'm not wrong.

> I also thought about having *two* translation areas and switching
> the pointer between them; this might be too complicated, though?

We only have one channel program at a time or? I can't see the benefit
of having two areas.

Sorry I didn't intend to open a huge discussion, as I'm on vacation
starting Thursday -- means expect delays. If the rest of the bunch
happens to see this differently, please feel free to not seek my consent.

Regards,
Halil


> 
> ---
>  drivers/s390/cio/vfio_ccw_drv.c     | 19 +++++++++++--------
>  drivers/s390/cio/vfio_ccw_fsm.c     | 25 +++++++++++++++++--------
>  drivers/s390/cio/vfio_ccw_ops.c     | 11 +++++++----
>  drivers/s390/cio/vfio_ccw_private.h |  6 ++++--
>  4 files changed, 39 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
> index 9208c0e56c33..059b88c94378 100644
> --- a/drivers/s390/cio/vfio_ccw_drv.c
> +++ b/drivers/s390/cio/vfio_ccw_drv.c
> @@ -86,10 +86,13 @@ static void vfio_ccw_sch_io_todo(struct work_struct *work)
>  
>  	is_final = !(scsw_actl(&irb->scsw) &
>  		     (SCSW_ACTL_DEVACT | SCSW_ACTL_SCHACT));
> -	if (scsw_is_solicited(&irb->scsw)) {
> -		cp_update_scsw(&private->cp, &irb->scsw);
> -		if (is_final && private->state == VFIO_CCW_STATE_CP_PENDING)
> -			cp_free(&private->cp);
> +	if (scsw_is_solicited(&irb->scsw) && private->cp) {
> +		cp_update_scsw(private->cp, &irb->scsw);
> +		if (is_final && private->state == VFIO_CCW_STATE_CP_PENDING) {
> +			struct channel_program *cp = private->cp;
> +			private->cp = NULL;
> +			cp_free(cp);
> +		}
>  	}
>  	mutex_lock(&private->io_mutex);
>  	memcpy(private->io_region->irb_area, irb, sizeof(*irb));
> @@ -129,9 +132,9 @@ static int vfio_ccw_sch_probe(struct subchannel *sch)
>  	if (!private)
>  		return -ENOMEM;
>  
> -	private->cp.guest_cp = kcalloc(CCWCHAIN_LEN_MAX, sizeof(struct ccw1),
> +	private->cp_area.guest_cp = kcalloc(CCWCHAIN_LEN_MAX, sizeof(struct ccw1),
>  				       GFP_KERNEL);
> -	if (!private->cp.guest_cp)
> +	if (!private->cp_area.guest_cp)
>  		goto out_free;
>  
>  	private->io_region = kmem_cache_zalloc(vfio_ccw_io_region,
> @@ -174,7 +177,7 @@ static int vfio_ccw_sch_probe(struct subchannel *sch)
>  		kmem_cache_free(vfio_ccw_cmd_region, private->cmd_region);
>  	if (private->io_region)
>  		kmem_cache_free(vfio_ccw_io_region, private->io_region);
> -	kfree(private->cp.guest_cp);
> +	kfree(private->cp_area.guest_cp);
>  	kfree(private);
>  	return ret;
>  }
> @@ -191,7 +194,7 @@ static int vfio_ccw_sch_remove(struct subchannel *sch)
>  
>  	kmem_cache_free(vfio_ccw_cmd_region, private->cmd_region);
>  	kmem_cache_free(vfio_ccw_io_region, private->io_region);
> -	kfree(private->cp.guest_cp);
> +	kfree(private->cp_area.guest_cp);
>  	kfree(private);
>  
>  	return 0;
> diff --git a/drivers/s390/cio/vfio_ccw_fsm.c b/drivers/s390/cio/vfio_ccw_fsm.c
> index 49d9d3da0282..543d007ddc46 100644
> --- a/drivers/s390/cio/vfio_ccw_fsm.c
> +++ b/drivers/s390/cio/vfio_ccw_fsm.c
> @@ -18,7 +18,8 @@
>  #define CREATE_TRACE_POINTS
>  #include "vfio_ccw_trace.h"
>  
> -static int fsm_io_helper(struct vfio_ccw_private *private)
> +static int fsm_io_helper(struct vfio_ccw_private *private,
> +			 struct channel_program *cp)
>  {
>  	struct subchannel *sch;
>  	union orb *orb;
> @@ -31,7 +32,7 @@ static int fsm_io_helper(struct vfio_ccw_private *private)
>  
>  	spin_lock_irqsave(sch->lock, flags);
>  
> -	orb = cp_get_orb(&private->cp, (u32)(addr_t)sch, sch->lpm);
> +	orb = cp_get_orb(cp, (u32)(addr_t)sch, sch->lpm);
>  	if (!orb) {
>  		ret = -EIO;
>  		goto out;
> @@ -47,6 +48,7 @@ static int fsm_io_helper(struct vfio_ccw_private *private)
>  		 */
>  		sch->schib.scsw.cmd.actl |= SCSW_ACTL_START_PEND;
>  		ret = 0;
> +		private->cp = cp;
>  		private->state = VFIO_CCW_STATE_CP_PENDING;
>  		break;
>  	case 1:		/* Status pending */
> @@ -236,31 +238,38 @@ static void fsm_io_request(struct vfio_ccw_private *private,
>  	if (scsw->cmd.fctl & SCSW_FCTL_START_FUNC) {
>  		orb = (union orb *)io_region->orb_area;
>  
> +		/* I/O already in progress? Should not happen (bug in FSM?). */
> +		if (private->cp) {
> +			io_region->ret_code = -EBUSY;
> +			errstr = "cp in progress";
> +			goto err_out;
> +		}
>  		/* Don't try to build a cp if transport mode is specified. */
>  		if (orb->tm.b) {
>  			io_region->ret_code = -EOPNOTSUPP;
>  			errstr = "transport mode";
>  			goto err_out;
>  		}
> -		io_region->ret_code = cp_init(&private->cp, mdev_dev(mdev),
> -					      orb);
> +		io_region->ret_code = cp_init(&private->cp_area,
> +					      mdev_dev(mdev), orb);
>  		if (io_region->ret_code) {
>  			errstr = "cp init";
>  			goto err_out;
>  		}
>  
> -		io_region->ret_code = cp_prefetch(&private->cp);
> +		io_region->ret_code = cp_prefetch(&private->cp_area);
>  		if (io_region->ret_code) {
>  			errstr = "cp prefetch";
> -			cp_free(&private->cp);
> +			cp_free(&private->cp_area);
>  			goto err_out;
>  		}
>  
>  		/* Start channel program and wait for I/O interrupt. */
> -		io_region->ret_code = fsm_io_helper(private);
> +		io_region->ret_code = fsm_io_helper(private,
> +						    &private->cp_area);
>  		if (io_region->ret_code) {
>  			errstr = "cp fsm_io_helper";
> -			cp_free(&private->cp);
> +			cp_free(&private->cp_area);
>  			goto err_out;
>  		}
>  		return;
> diff --git a/drivers/s390/cio/vfio_ccw_ops.c b/drivers/s390/cio/vfio_ccw_ops.c
> index 5eb61116ca6f..5ad6a7b672bd 100644
> --- a/drivers/s390/cio/vfio_ccw_ops.c
> +++ b/drivers/s390/cio/vfio_ccw_ops.c
> @@ -58,13 +58,14 @@ static int vfio_ccw_mdev_notifier(struct notifier_block *nb,
>  	if (action == VFIO_IOMMU_NOTIFY_DMA_UNMAP) {
>  		struct vfio_iommu_type1_dma_unmap *unmap = data;
>  
> -		if (!cp_iova_pinned(&private->cp, unmap->iova))
> +		if (!cp_iova_pinned(&private->cp_area, unmap->iova))
>  			return NOTIFY_OK;
>  
>  		if (vfio_ccw_mdev_reset(private->mdev))
>  			return NOTIFY_BAD;
>  
> -		cp_free(&private->cp);
> +		private->cp = NULL;
> +		cp_free(&private->cp_area);
>  		return NOTIFY_OK;
>  	}
>  
> @@ -139,7 +140,8 @@ static int vfio_ccw_mdev_remove(struct mdev_device *mdev)
>  		/* The state will be NOT_OPER on error. */
>  	}
>  
> -	cp_free(&private->cp);
> +	private->cp = NULL;
> +	cp_free(&private->cp_area);
>  	private->mdev = NULL;
>  	atomic_inc(&private->avail);
>  
> @@ -180,7 +182,8 @@ static void vfio_ccw_mdev_release(struct mdev_device *mdev)
>  		/* The state will be NOT_OPER on error. */
>  	}
>  
> -	cp_free(&private->cp);
> +	private->cp = NULL;
> +	cp_free(&private->cp_area);
>  	vfio_unregister_notifier(mdev_dev(mdev), VFIO_IOMMU_NOTIFY,
>  				 &private->nb);
>  
> diff --git a/drivers/s390/cio/vfio_ccw_private.h b/drivers/s390/cio/vfio_ccw_private.h
> index f1092c3dc1b1..e792a20202c3 100644
> --- a/drivers/s390/cio/vfio_ccw_private.h
> +++ b/drivers/s390/cio/vfio_ccw_private.h
> @@ -68,7 +68,8 @@ int vfio_ccw_register_async_dev_regions(struct vfio_ccw_private *private);
>   * @region: additional regions for other subchannel operations
>   * @cmd_region: MMIO region for asynchronous I/O commands other than START
>   * @num_regions: number of additional regions
> - * @cp: channel program for the current I/O operation
> + * @cp_area: channel program memory area
> + * @cp: pointer to channel program for the current I/O operation
>   * @irb: irb info received from interrupt
>   * @scsw: scsw info
>   * @io_trigger: eventfd ctx for signaling userspace I/O results
> @@ -87,7 +88,8 @@ struct vfio_ccw_private {
>  	struct ccw_cmd_region	*cmd_region;
>  	int num_regions;
>  
> -	struct channel_program	cp;
> +	struct channel_program cp_area;
> +	struct channel_program	*cp;
>  	struct irb		irb;
>  	union scsw		scsw;
>  

