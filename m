Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CE007D4FEE
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 14:38:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231815AbjJXMi1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 08:38:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233400AbjJXMiR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 08:38:17 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E1D4FDA;
        Tue, 24 Oct 2023 05:38:14 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A69F12F4;
        Tue, 24 Oct 2023 05:38:55 -0700 (PDT)
Received: from [10.1.196.40] (e121345-lin.cambridge.arm.com [10.1.196.40])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0A4D03F64C;
        Tue, 24 Oct 2023 05:38:12 -0700 (PDT)
Message-ID: <611ef809-248f-424e-993c-f5727ed2e18c@arm.com>
Date:   Tue, 24 Oct 2023 13:38:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] iommu: Introduce a rb_tree for looking up device
Content-Language: en-GB
To:     Huang Jiaqing <jiaqing.huang@intel.com>, joro@8bytes.org,
        will@kernel.org, dwmw2@infradead.org, baolu.lu@linux.intel.com,
        linux-kernel@vger.kernel.org, iommu@lists.linux.dev
Cc:     jacob.jun.pan@linux.intel.com, kevin.tian@intel.com,
        yi.y.sun@intel.com, kvm@vger.kernel.org
References: <20231024084124.11155-1-jiaqing.huang@intel.com>
From:   Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <20231024084124.11155-1-jiaqing.huang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/10/2023 9:41 am, Huang Jiaqing wrote:
> The existing IO page fault handler locates the PCI device by calling
> pci_get_domain_bus_and_slot(), which searches the list of all PCI
> devices until the desired PCI device is found. This is inefficient
> because the algorithm efficiency of searching a list is O(n). In the
> critical path of handling an IO page fault, this is not performance
> friendly given that I/O page fault handling patch is performance
> critical, and parallel heavy dsa_test may cause cpu stuck due to
> the low efficiency and lock competition in current path.
> 
> To improve the performance of the IO page fault handler, replace
> pci_get_domain_bus_and_slot() with a local red-black tree. A red-black
> tree is a self-balancing binary search tree, which means that the
> average time complexity of searching a red-black tree is O(log(n)). This
> is significantly faster than O(n), so it can significantly improve the
> performance of the IO page fault handler.
> 
> In addition, we can only insert the affected devices (those that have IO
> page fault enabled) into the red-black tree. This can further improve
> the performance of the IO page fault handler.

Have we had the rbtree vs. xarray debate for this one yet? :)

However, how many devices do we actually expect to be sharing the same 
queue? If it's a small number then it's quite possible that tracking 
separate per-queue sets of devices is the real win here, and a simple 
list without the additional overheads of more complex structures could 
still be sufficient.

Thanks,
Robin.

> This series depends on "deliver page faults to user space" patch-set:
> https://lore.kernel.org/linux-iommu/20230928042734.16134-1-baolu.lu@linux.intel.com/
> 
> Signed-off-by: Huang Jiaqing <jiaqing.huang@intel.com>
> ---
>   drivers/iommu/io-pgfault.c | 104 ++++++++++++++++++++++++++++++++++++-
>   include/linux/iommu.h      |  16 ++++++
>   2 files changed, 118 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/iommu/io-pgfault.c b/drivers/iommu/io-pgfault.c
> index 1dbacc4fdf72..68e85dc6b1b6 100644
> --- a/drivers/iommu/io-pgfault.c
> +++ b/drivers/iommu/io-pgfault.c
> @@ -7,6 +7,7 @@
>   
>   #include <linux/iommu.h>
>   #include <linux/list.h>
> +#include <linux/pci.h>
>   #include <linux/sched/mm.h>
>   #include <linux/slab.h>
>   #include <linux/workqueue.h>
> @@ -392,6 +393,55 @@ int iopf_queue_discard_partial(struct iopf_queue *queue)
>   }
>   EXPORT_SYMBOL_GPL(iopf_queue_discard_partial);
>   
> +static int iopf_queue_pci_rbtree_insert(struct iopf_queue *queue, struct pci_dev *pdev)
> +{
> +	int ret;
> +	struct rb_node **new, *parent = NULL;
> +	struct iommu_fault_param *iopf_param = iopf_get_dev_fault_param(&pdev->dev);
> +
> +	if (!iopf_param)
> +		return -ENODEV;
> +
> +	down_write(&queue->pci_dev_sem);
> +	new = &(queue->pci_dev_rbtree.rb_node);
> +	while (*new) {
> +		struct iommu_fault_param *this = container_of(*new, struct iommu_fault_param, node);
> +		struct pci_dev *this_pdev = to_pci_dev(this->dev);
> +		s16 result = RB_NODE_CMP(pdev->bus->number, pdev->devfn, this_pdev->bus->number, this_pdev->devfn);
> +
> +		parent = *new;
> +		if (result < 0)
> +			new = &((*new)->rb_left);
> +		else if (result > 0)
> +			new = &((*new)->rb_right);
> +		else {
> +			ret = -EEXIST;
> +			goto err_unlock;
> +		}
> +	}
> +
> +	rb_link_node(&iopf_param->node, parent, new);
> +	rb_insert_color(&iopf_param->node, &queue->pci_dev_rbtree);
> +
> +	up_write(&queue->pci_dev_sem);
> +	return 0;
> +err_unlock:
> +	up_write(&queue->pci_dev_sem);
> +	iopf_put_dev_fault_param(iopf_param);
> +	return ret;
> +}
> +
> +/* Caller must have inserted iopf_param by calling iopf_queue_pci_rbtree_insert() */
> +static void iopf_queue_pci_rbtree_remove(struct iopf_queue *queue, struct iommu_fault_param *iopf_param)
> +{
> +	down_write(&queue->pci_dev_sem);
> +	rb_erase(&iopf_param->node, &queue->pci_dev_rbtree);
> +	up_write(&queue->pci_dev_sem);
> +
> +	/* paired with iopf_queue_pci_rbtree_insert() */
> +	iopf_put_dev_fault_param(iopf_param);
> +}
> +
>   /**
>    * iopf_queue_add_device - Add producer to the fault queue
>    * @queue: IOPF queue
> @@ -434,7 +484,13 @@ int iopf_queue_add_device(struct iopf_queue *queue, struct device *dev)
>   	mutex_unlock(&param->lock);
>   	mutex_unlock(&queue->lock);
>   
> -	return ret;
> +	if (ret)
> +		return ret;
> +
> +	if (dev_is_pci(dev))
> +		return iopf_queue_pci_rbtree_insert(queue, to_pci_dev(dev));
> +
> +	return 0;
>   }
>   EXPORT_SYMBOL_GPL(iopf_queue_add_device);
>   
> @@ -486,7 +542,13 @@ int iopf_queue_remove_device(struct iopf_queue *queue, struct device *dev)
>   	mutex_unlock(&param->lock);
>   	mutex_unlock(&queue->lock);
>   
> -	return ret;
> +	if (ret)
> +		return ret;
> +
> +	if (dev_is_pci(dev))
> +		iopf_queue_pci_rbtree_remove(queue, fault_param);
> +
> +	return 0;
>   }
>   EXPORT_SYMBOL_GPL(iopf_queue_remove_device);
>   
> @@ -519,6 +581,9 @@ struct iopf_queue *iopf_queue_alloc(const char *name)
>   	INIT_LIST_HEAD(&queue->devices);
>   	mutex_init(&queue->lock);
>   
> +	queue->pci_dev_rbtree = RB_ROOT;
> +	init_rwsem(&queue->pci_dev_sem);
> +
>   	return queue;
>   }
>   EXPORT_SYMBOL_GPL(iopf_queue_alloc);
> @@ -544,3 +609,38 @@ void iopf_queue_free(struct iopf_queue *queue)
>   	kfree(queue);
>   }
>   EXPORT_SYMBOL_GPL(iopf_queue_free);
> +
> +/**
> + * iopf_queue_find_pdev - Lookup pci device in iopf_queue rbtree
> + * @queue: IOPF queue
> + * @bus: bus number of pci device to lookup
> + * @devfn: devfn of pci device to lookup
> + *
> + * Return: the pci device on success and NULL on not found.
> + */
> +struct pci_dev *iopf_queue_find_pdev(struct iopf_queue *queue, u8 bus, u8 devfn)
> +{
> +	struct iommu_fault_param *data = NULL;
> +	struct pci_dev *pdev = NULL;
> +	struct rb_node *node;
> +
> +	down_read(&queue->pci_dev_sem);
> +
> +	node = queue->pci_dev_rbtree.rb_node;
> +	while (node) {
> +		data = container_of(node, struct iommu_fault_param, node);
> +		pdev = to_pci_dev(data->dev);
> +		s16 result = RB_NODE_CMP(bus, devfn, pdev->bus->number, pdev->devfn);
> +
> +		if (result < 0)
> +			node = node->rb_left;
> +		else if (result > 0)
> +			node = node->rb_right;
> +		else
> +			break;
> +	}
> +	up_read(&queue->pci_dev_sem);
> +
> +	return node ? pdev : NULL;
> +}
> +EXPORT_SYMBOL_GPL(iopf_queue_find_pdev);
> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index bcec7e91dfc4..b29bbb0d1843 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -136,11 +136,15 @@ struct iopf_group {
>    * @wq: the fault workqueue
>    * @devices: devices attached to this queue
>    * @lock: protects the device list
> + * @pci_dev_rbtree: pci devices for looking up
> + * @pci_dev_sem: protects the rb_tree
>    */
>   struct iopf_queue {
>   	struct workqueue_struct *wq;
>   	struct list_head devices;
>   	struct mutex lock;
> +	struct rb_root pci_dev_rbtree;
> +	struct rw_semaphore pci_dev_sem;
>   };
>   
>   /* iommu fault flags */
> @@ -483,6 +487,8 @@ struct iommu_device {
>   	u32 max_pasids;
>   };
>   
> +#define RB_NODE_CMP(bus1, devfn1, bus2, devfn2) ((s16)(PCI_DEVID(bus1, devfn1) - PCI_DEVID(bus2, devfn2)))
> +
>   /**
>    * struct iommu_fault_param - per-device IOMMU fault data
>    * @lock: protect pending faults list
> @@ -494,6 +500,7 @@ struct iommu_device {
>    * @partial: faults that are part of a Page Request Group for which the last
>    *           request hasn't been submitted yet.
>    * @faults: holds the pending faults which needs response
> + * @node: pci device tracking node(lookup by (bus, devfn))
>    */
>   struct iommu_fault_param {
>   	struct mutex lock;
> @@ -505,6 +512,7 @@ struct iommu_fault_param {
>   
>   	struct list_head partial;
>   	struct list_head faults;
> +	struct rb_node node;
>   };
>   
>   /**
> @@ -1286,6 +1294,8 @@ int iopf_queue_discard_dev_pasid(struct device *dev, ioasid_t pasid);
>   struct iopf_queue *iopf_queue_alloc(const char *name);
>   void iopf_queue_free(struct iopf_queue *queue);
>   int iopf_queue_discard_partial(struct iopf_queue *queue);
> +struct pci_dev *iopf_queue_find_pdev(struct iopf_queue *queue,
> +				u8 bus, u8 devfn);
>   void iopf_free_group(struct iopf_group *group);
>   int iommu_report_device_fault(struct device *dev, struct iopf_fault *evt);
>   int iommu_page_response(struct device *dev, struct iommu_page_response *msg);
> @@ -1321,6 +1331,12 @@ static inline int iopf_queue_discard_partial(struct iopf_queue *queue)
>   	return -ENODEV;
>   }
>   
> +static inline struct pci_dev *iopf_queue_find_pdev(struct iopf_queue *queue,
> +						u8 bus, u8 devfn)
> +{
> +	return NULL;
> +}
> +
>   static inline void iopf_free_group(struct iopf_group *group)
>   {
>   }
