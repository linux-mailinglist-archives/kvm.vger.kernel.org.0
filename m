Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 158A56C7660
	for <lists+kvm@lfdr.de>; Fri, 24 Mar 2023 04:50:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231189AbjCXDub (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 23:50:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230430AbjCXDu3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 23:50:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9649510F7
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 20:49:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679629786;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tvUYLbQ5ItZ7YGhfcbwRlMUBJivNVLYqKMadR4fNk5g=;
        b=RG+1BLtWSqvPsEXgXopS7TorjGLwIVLn5+lxULrusXHJHKLdkVI/xmlesHXplbHvYm6wO5
        0MQOu+j+szbJKwQgGN0tcabCMGLBMYcWQsgVHXV5oflabDNhipqMVOsvIyQ3dVi7hq/Cy+
        hnhQ8QiSZd4n1X3AVq1kj5QJu60OR1s=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-177-Yku8FumZM9WP71IPGTrXFQ-1; Thu, 23 Mar 2023 23:49:45 -0400
X-MC-Unique: Yku8FumZM9WP71IPGTrXFQ-1
Received: by mail-pl1-f198.google.com with SMTP id s11-20020a170902a50b00b001a1f8fc0d2cso487326plq.15
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 20:49:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679629784;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tvUYLbQ5ItZ7YGhfcbwRlMUBJivNVLYqKMadR4fNk5g=;
        b=ehEfol/qFfedoFqPsRFiye+con/h0IShs/BXre2HItCNSJJuRNWHADfY0hji9bMw7U
         SlH4g3tgk7TEu+STm9Lez9Qlqxe2YkA7JnA/udXGmLiviVkCokrztHlfOYGawHi+ajpS
         IsVJIPPbdxdj7v/FzDPiEhfrxQDQ28+M0ArdaBvWKVU0E5gow7uSyRIECT/qzwkmIlDb
         +gRmdMfnkvP1eE4F2BwutJ0iWvWFtHyWoSbjT/wXkWPT5olo3avnarWp5TmB4XWsjN/D
         CCFM6DDWgfPzT90tmA7sOkFaRt4j2HdvKczUhlbxECr72876ZPKopbYrxeAjsqm4WTMN
         hgvw==
X-Gm-Message-State: AO0yUKV3gH8/PRZrdKrWNa7kF0pIdq3TPfLKOthvne95of0DweY5v3lV
        6GW1mTwowOcPmYHXfA0InDdPpSl9UgtHN1cbzT37LVDxzS9Dtr2bSD+n+5DC8zhXmXeDdtOQMev
        kU94ow8rHFM3n
X-Received: by 2002:a05:6a20:131c:b0:d9:c0fe:17ca with SMTP id g28-20020a056a20131c00b000d9c0fe17camr1377710pzh.16.1679629784226;
        Thu, 23 Mar 2023 20:49:44 -0700 (PDT)
X-Google-Smtp-Source: AK7set9jvo39PB6TeNlOHJ5XW5HW9YLQwg1N6J3rrirOctyXgU8nBNprbs5zVYrlhDXL7BhSRGvnhw==
X-Received: by 2002:a05:6a20:131c:b0:d9:c0fe:17ca with SMTP id g28-20020a056a20131c00b000d9c0fe17camr1377695pzh.16.1679629783909;
        Thu, 23 Mar 2023 20:49:43 -0700 (PDT)
Received: from [10.72.13.198] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id q8-20020a656848000000b005034a57b963sm12467895pgt.58.2023.03.23.20.49.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Mar 2023 20:49:43 -0700 (PDT)
Message-ID: <78c7511a-deab-7e95-fde1-5317a568cf97@redhat.com>
Date:   Fri, 24 Mar 2023 11:49:32 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.0
Subject: Re: [PATCH v3 8/8] vdpa_sim: add support for user VA
Content-Language: en-US
To:     Stefano Garzarella <sgarzare@redhat.com>,
        virtualization@lists.linux-foundation.org
Cc:     kvm@vger.kernel.org, stefanha@redhat.com,
        linux-kernel@vger.kernel.org, eperezma@redhat.com,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>,
        netdev@vger.kernel.org
References: <20230321154228.182769-1-sgarzare@redhat.com>
 <20230321154804.184577-1-sgarzare@redhat.com>
 <20230321154804.184577-4-sgarzare@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20230321154804.184577-4-sgarzare@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


在 2023/3/21 23:48, Stefano Garzarella 写道:
> The new "use_va" module parameter (default: true) is used in
> vdpa_alloc_device() to inform the vDPA framework that the device
> supports VA.
>
> vringh is initialized to use VA only when "use_va" is true and the
> user's mm has been bound. So, only when the bus supports user VA
> (e.g. vhost-vdpa).
>
> vdpasim_mm_work_fn work is used to serialize the binding to a new
> address space when the .bind_mm callback is invoked, and unbinding
> when the .unbind_mm callback is invoked.
>
> Call mmget_not_zero()/kthread_use_mm() inside the worker function
> to pin the address space only as long as needed, following the
> documentation of mmget() in include/linux/sched/mm.h:
>
>    * Never use this function to pin this address space for an
>    * unbounded/indefinite amount of time.
>
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
>
> Notes:
>      v3:
>      - called mmget_not_zero() before kthread_use_mm() [Jason]
>        As the documentation of mmget() in include/linux/sched/mm.h says:
>      
>        * Never use this function to pin this address space for an
>        * unbounded/indefinite amount of time.
>      
>        I moved mmget_not_zero/kthread_use_mm inside the worker function,
>        this way we pin the address space only as long as needed.
>        This is similar to what vfio_iommu_type1_dma_rw_chunk() does in
>        drivers/vfio/vfio_iommu_type1.c
>      - simplified the mm bind/unbind [Jason]
>      - renamed vdpasim_worker_change_mm_sync() [Jason]
>      - fix commit message (s/default: false/default: true)
>      v2:
>      - `use_va` set to true by default [Eugenio]
>      - supported the new unbind_mm callback [Jason]
>      - removed the unbind_mm call in vdpasim_do_reset() [Jason]
>      - avoided to release the lock while call kthread_flush_work() since we
>        are now using a mutex to protect the device state
>
>   drivers/vdpa/vdpa_sim/vdpa_sim.h |  1 +
>   drivers/vdpa/vdpa_sim/vdpa_sim.c | 80 +++++++++++++++++++++++++++++++-
>   2 files changed, 79 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.h b/drivers/vdpa/vdpa_sim/vdpa_sim.h
> index 4774292fba8c..3a42887d05d9 100644
> --- a/drivers/vdpa/vdpa_sim/vdpa_sim.h
> +++ b/drivers/vdpa/vdpa_sim/vdpa_sim.h
> @@ -59,6 +59,7 @@ struct vdpasim {
>   	struct vdpasim_virtqueue *vqs;
>   	struct kthread_worker *worker;
>   	struct kthread_work work;
> +	struct mm_struct *mm_bound;
>   	struct vdpasim_dev_attr dev_attr;
>   	/* mutex to synchronize virtqueue state */
>   	struct mutex mutex;
> diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
> index ab4cfb82c237..23c891cdcd54 100644
> --- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
> +++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
> @@ -35,10 +35,44 @@ module_param(max_iotlb_entries, int, 0444);
>   MODULE_PARM_DESC(max_iotlb_entries,
>   		 "Maximum number of iotlb entries for each address space. 0 means unlimited. (default: 2048)");
>   
> +static bool use_va = true;
> +module_param(use_va, bool, 0444);
> +MODULE_PARM_DESC(use_va, "Enable/disable the device's ability to use VA");
> +
>   #define VDPASIM_QUEUE_ALIGN PAGE_SIZE
>   #define VDPASIM_QUEUE_MAX 256
>   #define VDPASIM_VENDOR_ID 0
>   
> +struct vdpasim_mm_work {
> +	struct kthread_work work;
> +	struct vdpasim *vdpasim;
> +	struct mm_struct *mm_to_bind;
> +	int ret;
> +};
> +
> +static void vdpasim_mm_work_fn(struct kthread_work *work)
> +{
> +	struct vdpasim_mm_work *mm_work =
> +		container_of(work, struct vdpasim_mm_work, work);
> +	struct vdpasim *vdpasim = mm_work->vdpasim;
> +
> +	mm_work->ret = 0;
> +
> +	//TODO: should we attach the cgroup of the mm owner?
> +	vdpasim->mm_bound = mm_work->mm_to_bind;
> +}
> +
> +static void vdpasim_worker_change_mm_sync(struct vdpasim *vdpasim,
> +					  struct vdpasim_mm_work *mm_work)
> +{
> +	struct kthread_work *work = &mm_work->work;
> +
> +	kthread_init_work(work, vdpasim_mm_work_fn);
> +	kthread_queue_work(vdpasim->worker, work);
> +
> +	kthread_flush_work(work);
> +}
> +
>   static struct vdpasim *vdpa_to_sim(struct vdpa_device *vdpa)
>   {
>   	return container_of(vdpa, struct vdpasim, vdpa);
> @@ -59,8 +93,10 @@ static void vdpasim_queue_ready(struct vdpasim *vdpasim, unsigned int idx)
>   {
>   	struct vdpasim_virtqueue *vq = &vdpasim->vqs[idx];
>   	uint16_t last_avail_idx = vq->vring.last_avail_idx;
> +	bool va_enabled = use_va && vdpasim->mm_bound;
>   
> -	vringh_init_iotlb(&vq->vring, vdpasim->features, vq->num, true, false,
> +	vringh_init_iotlb(&vq->vring, vdpasim->features, vq->num, true,
> +			  va_enabled,
>   			  (struct vring_desc *)(uintptr_t)vq->desc_addr,
>   			  (struct vring_avail *)
>   			  (uintptr_t)vq->driver_addr,
> @@ -130,8 +166,20 @@ static const struct vdpa_config_ops vdpasim_batch_config_ops;
>   static void vdpasim_work_fn(struct kthread_work *work)
>   {
>   	struct vdpasim *vdpasim = container_of(work, struct vdpasim, work);
> +	struct mm_struct *mm = vdpasim->mm_bound;
> +
> +	if (mm) {
> +		if (!mmget_not_zero(mm))
> +			return;


Do we need to check use_va here.

Other than this

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks


> +		kthread_use_mm(mm);
> +	}
>   
>   	vdpasim->dev_attr.work_fn(vdpasim);
> +
> +	if (mm) {
> +		kthread_unuse_mm(mm);
> +		mmput(mm);
> +	}
>   }
>   
>   struct vdpasim *vdpasim_create(struct vdpasim_dev_attr *dev_attr,
> @@ -162,7 +210,7 @@ struct vdpasim *vdpasim_create(struct vdpasim_dev_attr *dev_attr,
>   	vdpa = __vdpa_alloc_device(NULL, ops,
>   				   dev_attr->ngroups, dev_attr->nas,
>   				   dev_attr->alloc_size,
> -				   dev_attr->name, false);
> +				   dev_attr->name, use_va);
>   	if (IS_ERR(vdpa)) {
>   		ret = PTR_ERR(vdpa);
>   		goto err_alloc;
> @@ -582,6 +630,30 @@ static int vdpasim_set_map(struct vdpa_device *vdpa, unsigned int asid,
>   	return ret;
>   }
>   
> +static int vdpasim_bind_mm(struct vdpa_device *vdpa, struct mm_struct *mm)
> +{
> +	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
> +	struct vdpasim_mm_work mm_work;
> +
> +	mm_work.vdpasim = vdpasim;
> +	mm_work.mm_to_bind = mm;
> +
> +	vdpasim_worker_change_mm_sync(vdpasim, &mm_work);
> +
> +	return mm_work.ret;
> +}
> +
> +static void vdpasim_unbind_mm(struct vdpa_device *vdpa)
> +{
> +	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
> +	struct vdpasim_mm_work mm_work;
> +
> +	mm_work.vdpasim = vdpasim;
> +	mm_work.mm_to_bind = NULL;
> +
> +	vdpasim_worker_change_mm_sync(vdpasim, &mm_work);
> +}
> +
>   static int vdpasim_dma_map(struct vdpa_device *vdpa, unsigned int asid,
>   			   u64 iova, u64 size,
>   			   u64 pa, u32 perm, void *opaque)
> @@ -678,6 +750,8 @@ static const struct vdpa_config_ops vdpasim_config_ops = {
>   	.set_group_asid         = vdpasim_set_group_asid,
>   	.dma_map                = vdpasim_dma_map,
>   	.dma_unmap              = vdpasim_dma_unmap,
> +	.bind_mm		= vdpasim_bind_mm,
> +	.unbind_mm		= vdpasim_unbind_mm,
>   	.free                   = vdpasim_free,
>   };
>   
> @@ -712,6 +786,8 @@ static const struct vdpa_config_ops vdpasim_batch_config_ops = {
>   	.get_iova_range         = vdpasim_get_iova_range,
>   	.set_group_asid         = vdpasim_set_group_asid,
>   	.set_map                = vdpasim_set_map,
> +	.bind_mm		= vdpasim_bind_mm,
> +	.unbind_mm		= vdpasim_unbind_mm,
>   	.free                   = vdpasim_free,
>   };
>   

