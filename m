Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9911253162F
	for <lists+kvm@lfdr.de>; Mon, 23 May 2022 22:50:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239017AbiEWQl6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 May 2022 12:41:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238979AbiEWQl5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 May 2022 12:41:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B7E7327141
        for <kvm@vger.kernel.org>; Mon, 23 May 2022 09:41:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653324114;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sAs6g7sMF7OBlriuTlB3cYHXU+r8YVmZ6Sgf2guFvRo=;
        b=iw8DB58lQWxRD4HU9zWprLix7Nfjb4aRUFYVcoozh2LtuJbqaA/xZ1NT8c/Cqfzs7VmT+F
        GXHHl4ZRIax6Pn97x+3pv50qEtNcFv5hRW9A2ZEBsZZXS8wvUFjPHyBdnZblUCepwRsdub
        qLLLZHx9F9e4lm1aGeYbSZWPJSZBg6I=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-495-D3El4y2SO9e6XNqA9byZwQ-1; Mon, 23 May 2022 12:41:53 -0400
X-MC-Unique: D3El4y2SO9e6XNqA9byZwQ-1
Received: by mail-io1-f70.google.com with SMTP id t1-20020a056602140100b0065393cc1dc3so8481529iov.5
        for <kvm@vger.kernel.org>; Mon, 23 May 2022 09:41:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sAs6g7sMF7OBlriuTlB3cYHXU+r8YVmZ6Sgf2guFvRo=;
        b=xwu4BOWzEYYPzvhAxAIroXK4AuOc1mW/Hs8BU+JZaF9XxaY7EYChNES2DN/WiMkES+
         Xf+OiM1AIeWSlO9EwOohip2FHLCMkVBSM/m9Q2FGJKjgKKpu3bXX4yMes6C0RjEuTpyu
         ao58i4W1SXkGzO3K7kpOGBohAx56CFuRAlSetUqncTUxjVoEUyXDSlR3s+JoOMw3aKq/
         1xAKLA35pNoJJL2Ex3dw3JcLJK7yocuuQ9ymO3uSqauyblyjCTWwTMOkEdL+vGfJ5qme
         gHF2sDBA+AzL0dZs5Kln4qJRpuBYsVAXXxVbCY06TiLbRnIP2/YryDJjJPnWnrsKg7fz
         tukA==
X-Gm-Message-State: AOAM533PacBD8cpHhTte8Qc7LzrO6GhKv+0KHpUbR/wkpVFgfOwMSo1+
        vN/SXCdWRI6jV/e/fzQfYRsGj694vi2B7Pv+cOiy7z+mdBosbrs4MCW6ZkoiPI+gvvB4oTG/2xm
        p2gluQv38nuQn
X-Received: by 2002:a02:946e:0:b0:32b:5b56:e9d9 with SMTP id a101-20020a02946e000000b0032b5b56e9d9mr12231729jai.215.1653324112723;
        Mon, 23 May 2022 09:41:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy0Vdh0gEXUoEVcPYLYvYqedUbLPZHhNUCcTKWD+WKTjLf5J7cfQcsTjT5lGyQdCBO2l1yd0A==
X-Received: by 2002:a02:946e:0:b0:32b:5b56:e9d9 with SMTP id a101-20020a02946e000000b0032b5b56e9d9mr12231711jai.215.1653324112354;
        Mon, 23 May 2022 09:41:52 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id p36-20020a056638192400b0032e30badd18sm2828931jal.178.2022.05.23.09.41.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 May 2022 09:41:51 -0700 (PDT)
Date:   Mon, 23 May 2022 10:41:50 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     zhenyuw@linux.intel.com, zhi.a.wang@intel.com
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>, jgg@nvidia.com,
        cohuck@redhat.com, borntraeger@linux.ibm.com,
        jjherne@linux.ibm.com, akrowiak@linux.ibm.com, pasic@linux.ibm.com,
        hch@infradead.org, intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kevin Tian <kevin.tian@intel.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v3 1/1] vfio: remove VFIO_GROUP_NOTIFY_SET_KVM
Message-ID: <20220523104150.49c001f8.alex.williamson@redhat.com>
In-Reply-To: <20220519183311.582380-2-mjrosato@linux.ibm.com>
References: <20220519183311.582380-1-mjrosato@linux.ibm.com>
        <20220519183311.582380-2-mjrosato@linux.ibm.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Hi Zhi & Zhenyu,

Please review gvt changes below, I'd prefer to get your ack included.
Thanks!

Alex

On Thu, 19 May 2022 14:33:11 -0400
Matthew Rosato <mjrosato@linux.ibm.com> wrote:

> Rather than relying on a notifier for associating the KVM with
> the group, let's assume that the association has already been
> made prior to device_open.  The first time a device is opened
> associate the group KVM with the device.
> 
> This fixes a user-triggerable oops in GVT.
> 
> Reviewed-by: Tony Krowiak <akrowiak@linux.ibm.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>  drivers/gpu/drm/i915/gvt/gtt.c        |  4 +-
>  drivers/gpu/drm/i915/gvt/gvt.h        |  3 -
>  drivers/gpu/drm/i915/gvt/kvmgt.c      | 82 ++++++--------------------
>  drivers/s390/crypto/vfio_ap_ops.c     | 35 ++---------
>  drivers/s390/crypto/vfio_ap_private.h |  3 -
>  drivers/vfio/vfio.c                   | 83 ++++++++++-----------------
>  include/linux/vfio.h                  |  6 +-
>  7 files changed, 57 insertions(+), 159 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/gvt/gtt.c b/drivers/gpu/drm/i915/gvt/gtt.c
> index 9c5cc2800975..b4f69364f9a1 100644
> --- a/drivers/gpu/drm/i915/gvt/gtt.c
> +++ b/drivers/gpu/drm/i915/gvt/gtt.c
> @@ -51,7 +51,7 @@ static int preallocated_oos_pages = 8192;
>  
>  static bool intel_gvt_is_valid_gfn(struct intel_vgpu *vgpu, unsigned long gfn)
>  {
> -	struct kvm *kvm = vgpu->kvm;
> +	struct kvm *kvm = vgpu->vfio_device.kvm;
>  	int idx;
>  	bool ret;
>  
> @@ -1185,7 +1185,7 @@ static int is_2MB_gtt_possible(struct intel_vgpu *vgpu,
>  
>  	if (!vgpu->attached)
>  		return -EINVAL;
> -	pfn = gfn_to_pfn(vgpu->kvm, ops->get_pfn(entry));
> +	pfn = gfn_to_pfn(vgpu->vfio_device.kvm, ops->get_pfn(entry));
>  	if (is_error_noslot_pfn(pfn))
>  		return -EINVAL;
>  	return PageTransHuge(pfn_to_page(pfn));
> diff --git a/drivers/gpu/drm/i915/gvt/gvt.h b/drivers/gpu/drm/i915/gvt/gvt.h
> index 2af4c83e733c..aee1a45da74b 100644
> --- a/drivers/gpu/drm/i915/gvt/gvt.h
> +++ b/drivers/gpu/drm/i915/gvt/gvt.h
> @@ -227,9 +227,6 @@ struct intel_vgpu {
>  	struct mutex cache_lock;
>  
>  	struct notifier_block iommu_notifier;
> -	struct notifier_block group_notifier;
> -	struct kvm *kvm;
> -	struct work_struct release_work;
>  	atomic_t released;
>  
>  	struct kvm_page_track_notifier_node track_node;
> diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
> index 7655ffa97d51..e2f6c56ab342 100644
> --- a/drivers/gpu/drm/i915/gvt/kvmgt.c
> +++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
> @@ -228,8 +228,6 @@ static void intel_gvt_cleanup_vgpu_type_groups(struct intel_gvt *gvt)
>  	}
>  }
>  
> -static void intel_vgpu_release_work(struct work_struct *work);
> -
>  static void gvt_unpin_guest_page(struct intel_vgpu *vgpu, unsigned long gfn,
>  		unsigned long size)
>  {
> @@ -761,23 +759,6 @@ static int intel_vgpu_iommu_notifier(struct notifier_block *nb,
>  	return NOTIFY_OK;
>  }
>  
> -static int intel_vgpu_group_notifier(struct notifier_block *nb,
> -				     unsigned long action, void *data)
> -{
> -	struct intel_vgpu *vgpu =
> -		container_of(nb, struct intel_vgpu, group_notifier);
> -
> -	/* the only action we care about */
> -	if (action == VFIO_GROUP_NOTIFY_SET_KVM) {
> -		vgpu->kvm = data;
> -
> -		if (!data)
> -			schedule_work(&vgpu->release_work);
> -	}
> -
> -	return NOTIFY_OK;
> -}
> -
>  static bool __kvmgt_vgpu_exist(struct intel_vgpu *vgpu)
>  {
>  	struct intel_vgpu *itr;
> @@ -789,7 +770,7 @@ static bool __kvmgt_vgpu_exist(struct intel_vgpu *vgpu)
>  		if (!itr->attached)
>  			continue;
>  
> -		if (vgpu->kvm == itr->kvm) {
> +		if (vgpu->vfio_device.kvm == itr->vfio_device.kvm) {
>  			ret = true;
>  			goto out;
>  		}
> @@ -806,7 +787,6 @@ static int intel_vgpu_open_device(struct vfio_device *vfio_dev)
>  	int ret;
>  
>  	vgpu->iommu_notifier.notifier_call = intel_vgpu_iommu_notifier;
> -	vgpu->group_notifier.notifier_call = intel_vgpu_group_notifier;
>  
>  	events = VFIO_IOMMU_NOTIFY_DMA_UNMAP;
>  	ret = vfio_register_notifier(vfio_dev, VFIO_IOMMU_NOTIFY, &events,
> @@ -817,38 +797,32 @@ static int intel_vgpu_open_device(struct vfio_device *vfio_dev)
>  		goto out;
>  	}
>  
> -	events = VFIO_GROUP_NOTIFY_SET_KVM;
> -	ret = vfio_register_notifier(vfio_dev, VFIO_GROUP_NOTIFY, &events,
> -				     &vgpu->group_notifier);
> -	if (ret != 0) {
> -		gvt_vgpu_err("vfio_register_notifier for group failed: %d\n",
> -			ret);
> -		goto undo_iommu;
> -	}
> -
>  	ret = -EEXIST;
>  	if (vgpu->attached)
> -		goto undo_register;
> +		goto undo_iommu;
>  
>  	ret = -ESRCH;
> -	if (!vgpu->kvm || vgpu->kvm->mm != current->mm) {
> +	if (!vgpu->vfio_device.kvm ||
> +	    vgpu->vfio_device.kvm->mm != current->mm) {
>  		gvt_vgpu_err("KVM is required to use Intel vGPU\n");
> -		goto undo_register;
> +		goto undo_iommu;
>  	}
>  
> +	kvm_get_kvm(vgpu->vfio_device.kvm);
> +
>  	ret = -EEXIST;
>  	if (__kvmgt_vgpu_exist(vgpu))
> -		goto undo_register;
> +		goto undo_iommu;
>  
>  	vgpu->attached = true;
> -	kvm_get_kvm(vgpu->kvm);
>  
>  	kvmgt_protect_table_init(vgpu);
>  	gvt_cache_init(vgpu);
>  
>  	vgpu->track_node.track_write = kvmgt_page_track_write;
>  	vgpu->track_node.track_flush_slot = kvmgt_page_track_flush_slot;
> -	kvm_page_track_register_notifier(vgpu->kvm, &vgpu->track_node);
> +	kvm_page_track_register_notifier(vgpu->vfio_device.kvm,
> +					 &vgpu->track_node);
>  
>  	debugfs_create_ulong(KVMGT_DEBUGFS_FILENAME, 0444, vgpu->debugfs,
>  			     &vgpu->nr_cache_entries);
> @@ -858,10 +832,6 @@ static int intel_vgpu_open_device(struct vfio_device *vfio_dev)
>  	atomic_set(&vgpu->released, 0);
>  	return 0;
>  
> -undo_register:
> -	vfio_unregister_notifier(vfio_dev, VFIO_GROUP_NOTIFY,
> -				 &vgpu->group_notifier);
> -
>  undo_iommu:
>  	vfio_unregister_notifier(vfio_dev, VFIO_IOMMU_NOTIFY,
>  				 &vgpu->iommu_notifier);
> @@ -880,8 +850,9 @@ static void intel_vgpu_release_msi_eventfd_ctx(struct intel_vgpu *vgpu)
>  	}
>  }
>  
> -static void __intel_vgpu_release(struct intel_vgpu *vgpu)
> +static void intel_vgpu_close_device(struct vfio_device *vfio_dev)
>  {
> +	struct intel_vgpu *vgpu = vfio_dev_to_vgpu(vfio_dev);
>  	struct drm_i915_private *i915 = vgpu->gvt->gt->i915;
>  	int ret;
>  
> @@ -898,35 +869,19 @@ static void __intel_vgpu_release(struct intel_vgpu *vgpu)
>  	drm_WARN(&i915->drm, ret,
>  		 "vfio_unregister_notifier for iommu failed: %d\n", ret);
>  
> -	ret = vfio_unregister_notifier(&vgpu->vfio_device, VFIO_GROUP_NOTIFY,
> -				       &vgpu->group_notifier);
> -	drm_WARN(&i915->drm, ret,
> -		 "vfio_unregister_notifier for group failed: %d\n", ret);
> -
>  	debugfs_remove(debugfs_lookup(KVMGT_DEBUGFS_FILENAME, vgpu->debugfs));
>  
> -	kvm_page_track_unregister_notifier(vgpu->kvm, &vgpu->track_node);
> -	kvm_put_kvm(vgpu->kvm);
> +	kvm_page_track_unregister_notifier(vgpu->vfio_device.kvm,
> +					   &vgpu->track_node);
>  	kvmgt_protect_table_destroy(vgpu);
>  	gvt_cache_destroy(vgpu);
>  
>  	intel_vgpu_release_msi_eventfd_ctx(vgpu);
>  
> -	vgpu->kvm = NULL;
>  	vgpu->attached = false;
> -}
> -
> -static void intel_vgpu_close_device(struct vfio_device *vfio_dev)
> -{
> -	__intel_vgpu_release(vfio_dev_to_vgpu(vfio_dev));
> -}
> -
> -static void intel_vgpu_release_work(struct work_struct *work)
> -{
> -	struct intel_vgpu *vgpu =
> -		container_of(work, struct intel_vgpu, release_work);
>  
> -	__intel_vgpu_release(vgpu);
> +	if (vgpu->vfio_device.kvm)
> +		kvm_put_kvm(vgpu->vfio_device.kvm);
>  }
>  
>  static u64 intel_vgpu_get_bar_addr(struct intel_vgpu *vgpu, int bar)
> @@ -1675,7 +1630,6 @@ static int intel_vgpu_probe(struct mdev_device *mdev)
>  		return PTR_ERR(vgpu);
>  	}
>  
> -	INIT_WORK(&vgpu->release_work, intel_vgpu_release_work);
>  	vfio_init_group_dev(&vgpu->vfio_device, &mdev->dev,
>  			    &intel_vgpu_dev_ops);
>  
> @@ -1713,7 +1667,7 @@ static struct mdev_driver intel_vgpu_mdev_driver = {
>  
>  int intel_gvt_page_track_add(struct intel_vgpu *info, u64 gfn)
>  {
> -	struct kvm *kvm = info->kvm;
> +	struct kvm *kvm = info->vfio_device.kvm;
>  	struct kvm_memory_slot *slot;
>  	int idx;
>  
> @@ -1743,7 +1697,7 @@ int intel_gvt_page_track_add(struct intel_vgpu *info, u64 gfn)
>  
>  int intel_gvt_page_track_remove(struct intel_vgpu *info, u64 gfn)
>  {
> -	struct kvm *kvm = info->kvm;
> +	struct kvm *kvm = info->vfio_device.kvm;
>  	struct kvm_memory_slot *slot;
>  	int idx;
>  
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index e8914024f5b1..a7d2a95796d3 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -1284,25 +1284,6 @@ static void vfio_ap_mdev_unset_kvm(struct ap_matrix_mdev *matrix_mdev)
>  	}
>  }
>  
> -static int vfio_ap_mdev_group_notifier(struct notifier_block *nb,
> -				       unsigned long action, void *data)
> -{
> -	int notify_rc = NOTIFY_OK;
> -	struct ap_matrix_mdev *matrix_mdev;
> -
> -	if (action != VFIO_GROUP_NOTIFY_SET_KVM)
> -		return NOTIFY_OK;
> -
> -	matrix_mdev = container_of(nb, struct ap_matrix_mdev, group_notifier);
> -
> -	if (!data)
> -		vfio_ap_mdev_unset_kvm(matrix_mdev);
> -	else if (vfio_ap_mdev_set_kvm(matrix_mdev, data))
> -		notify_rc = NOTIFY_DONE;
> -
> -	return notify_rc;
> -}
> -
>  static struct vfio_ap_queue *vfio_ap_find_queue(int apqn)
>  {
>  	struct device *dev;
> @@ -1402,11 +1383,10 @@ static int vfio_ap_mdev_open_device(struct vfio_device *vdev)
>  	unsigned long events;
>  	int ret;
>  
> -	matrix_mdev->group_notifier.notifier_call = vfio_ap_mdev_group_notifier;
> -	events = VFIO_GROUP_NOTIFY_SET_KVM;
> +	if (!vdev->kvm)
> +		return -EINVAL;
>  
> -	ret = vfio_register_notifier(vdev, VFIO_GROUP_NOTIFY, &events,
> -				     &matrix_mdev->group_notifier);
> +	ret = vfio_ap_mdev_set_kvm(matrix_mdev, vdev->kvm);
>  	if (ret)
>  		return ret;
>  
> @@ -1415,12 +1395,11 @@ static int vfio_ap_mdev_open_device(struct vfio_device *vdev)
>  	ret = vfio_register_notifier(vdev, VFIO_IOMMU_NOTIFY, &events,
>  				     &matrix_mdev->iommu_notifier);
>  	if (ret)
> -		goto out_unregister_group;
> +		goto err_kvm;
>  	return 0;
>  
> -out_unregister_group:
> -	vfio_unregister_notifier(vdev, VFIO_GROUP_NOTIFY,
> -				 &matrix_mdev->group_notifier);
> +err_kvm:
> +	vfio_ap_mdev_unset_kvm(matrix_mdev);
>  	return ret;
>  }
>  
> @@ -1431,8 +1410,6 @@ static void vfio_ap_mdev_close_device(struct vfio_device *vdev)
>  
>  	vfio_unregister_notifier(vdev, VFIO_IOMMU_NOTIFY,
>  				 &matrix_mdev->iommu_notifier);
> -	vfio_unregister_notifier(vdev, VFIO_GROUP_NOTIFY,
> -				 &matrix_mdev->group_notifier);
>  	vfio_ap_mdev_unset_kvm(matrix_mdev);
>  }
>  
> diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
> index 648fcaf8104a..a26efd804d0d 100644
> --- a/drivers/s390/crypto/vfio_ap_private.h
> +++ b/drivers/s390/crypto/vfio_ap_private.h
> @@ -81,8 +81,6 @@ struct ap_matrix {
>   * @node:	allows the ap_matrix_mdev struct to be added to a list
>   * @matrix:	the adapters, usage domains and control domains assigned to the
>   *		mediated matrix device.
> - * @group_notifier: notifier block used for specifying callback function for
> - *		    handling the VFIO_GROUP_NOTIFY_SET_KVM event
>   * @iommu_notifier: notifier block used for specifying callback function for
>   *		    handling the VFIO_IOMMU_NOTIFY_DMA_UNMAP even
>   * @kvm:	the struct holding guest's state
> @@ -94,7 +92,6 @@ struct ap_matrix_mdev {
>  	struct vfio_device vdev;
>  	struct list_head node;
>  	struct ap_matrix matrix;
> -	struct notifier_block group_notifier;
>  	struct notifier_block iommu_notifier;
>  	struct kvm *kvm;
>  	crypto_hook pqap_hook;
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index cfcff7764403..831fc722e3f8 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -1083,10 +1083,21 @@ static struct file *vfio_device_open(struct vfio_device *device)
>  
>  	mutex_lock(&device->dev_set->lock);
>  	device->open_count++;
> -	if (device->open_count == 1 && device->ops->open_device) {
> -		ret = device->ops->open_device(device);
> -		if (ret)
> -			goto err_undo_count;
> +	if (device->open_count == 1) {
> +		/*
> +		 * Here we pass the KVM pointer with the group under the read
> +		 * lock.  If the device driver will use it, it must obtain a
> +		 * reference and release it during close_device.
> +		 */
> +		down_read(&device->group->group_rwsem);
> +		device->kvm = device->group->kvm;
> +
> +		if (device->ops->open_device) {
> +			ret = device->ops->open_device(device);
> +			if (ret)
> +				goto err_undo_count;
> +		}
> +		up_read(&device->group->group_rwsem);
>  	}
>  	mutex_unlock(&device->dev_set->lock);
>  
> @@ -1119,10 +1130,14 @@ static struct file *vfio_device_open(struct vfio_device *device)
>  
>  err_close_device:
>  	mutex_lock(&device->dev_set->lock);
> +	down_read(&device->group->group_rwsem);
>  	if (device->open_count == 1 && device->ops->close_device)
>  		device->ops->close_device(device);
>  err_undo_count:
>  	device->open_count--;
> +	if (device->open_count == 0 && device->kvm)
> +		device->kvm = NULL;
> +	up_read(&device->group->group_rwsem);
>  	mutex_unlock(&device->dev_set->lock);
>  	module_put(device->dev->driver->owner);
>  err_unassign_container:
> @@ -1315,9 +1330,13 @@ static int vfio_device_fops_release(struct inode *inode, struct file *filep)
>  
>  	mutex_lock(&device->dev_set->lock);
>  	vfio_assert_device_open(device);
> +	down_read(&device->group->group_rwsem);
>  	if (device->open_count == 1 && device->ops->close_device)
>  		device->ops->close_device(device);
> +	up_read(&device->group->group_rwsem);
>  	device->open_count--;
> +	if (device->open_count == 0)
> +		device->kvm = NULL;
>  	mutex_unlock(&device->dev_set->lock);
>  
>  	module_put(device->dev->driver->owner);
> @@ -1726,8 +1745,8 @@ EXPORT_SYMBOL_GPL(vfio_file_enforced_coherent);
>   * @file: VFIO group file
>   * @kvm: KVM to link
>   *
> - * The kvm pointer will be forwarded to all the vfio_device's attached to the
> - * VFIO file via the VFIO_GROUP_NOTIFY_SET_KVM notifier.
> + * When a VFIO device is first opened the KVM will be available in
> + * device->kvm if one was associated with the group.
>   */
>  void vfio_file_set_kvm(struct file *file, struct kvm *kvm)
>  {
> @@ -1738,8 +1757,6 @@ void vfio_file_set_kvm(struct file *file, struct kvm *kvm)
>  
>  	down_write(&group->group_rwsem);
>  	group->kvm = kvm;
> -	blocking_notifier_call_chain(&group->notifier,
> -				     VFIO_GROUP_NOTIFY_SET_KVM, kvm);
>  	up_write(&group->group_rwsem);
>  }
>  EXPORT_SYMBOL_GPL(vfio_file_set_kvm);
> @@ -2006,7 +2023,8 @@ static int vfio_register_iommu_notifier(struct vfio_group *group,
>  	struct vfio_iommu_driver *driver;
>  	int ret;
>  
> -	down_read(&group->group_rwsem);
> +	lockdep_assert_held_read(&group->group_rwsem);
> +
>  	container = group->container;
>  	driver = container->iommu_driver;
>  	if (likely(driver && driver->ops->register_notifier))
> @@ -2014,7 +2032,6 @@ static int vfio_register_iommu_notifier(struct vfio_group *group,
>  						     events, nb);
>  	else
>  		ret = -ENOTTY;
> -	up_read(&group->group_rwsem);
>  
>  	return ret;
>  }
> @@ -2026,7 +2043,8 @@ static int vfio_unregister_iommu_notifier(struct vfio_group *group,
>  	struct vfio_iommu_driver *driver;
>  	int ret;
>  
> -	down_read(&group->group_rwsem);
> +	lockdep_assert_held_read(&group->group_rwsem);
> +
>  	container = group->container;
>  	driver = container->iommu_driver;
>  	if (likely(driver && driver->ops->unregister_notifier))
> @@ -2034,47 +2052,10 @@ static int vfio_unregister_iommu_notifier(struct vfio_group *group,
>  						       nb);
>  	else
>  		ret = -ENOTTY;
> -	up_read(&group->group_rwsem);
>  
>  	return ret;
>  }
>  
> -static int vfio_register_group_notifier(struct vfio_group *group,
> -					unsigned long *events,
> -					struct notifier_block *nb)
> -{
> -	int ret;
> -	bool set_kvm = false;
> -
> -	if (*events & VFIO_GROUP_NOTIFY_SET_KVM)
> -		set_kvm = true;
> -
> -	/* clear known events */
> -	*events &= ~VFIO_GROUP_NOTIFY_SET_KVM;
> -
> -	/* refuse to continue if still events remaining */
> -	if (*events)
> -		return -EINVAL;
> -
> -	ret = blocking_notifier_chain_register(&group->notifier, nb);
> -	if (ret)
> -		return ret;
> -
> -	/*
> -	 * The attaching of kvm and vfio_group might already happen, so
> -	 * here we replay once upon registration.
> -	 */
> -	if (set_kvm) {
> -		down_read(&group->group_rwsem);
> -		if (group->kvm)
> -			blocking_notifier_call_chain(&group->notifier,
> -						     VFIO_GROUP_NOTIFY_SET_KVM,
> -						     group->kvm);
> -		up_read(&group->group_rwsem);
> -	}
> -	return 0;
> -}
> -
>  int vfio_register_notifier(struct vfio_device *device,
>  			   enum vfio_notify_type type, unsigned long *events,
>  			   struct notifier_block *nb)
> @@ -2090,9 +2071,6 @@ int vfio_register_notifier(struct vfio_device *device,
>  	case VFIO_IOMMU_NOTIFY:
>  		ret = vfio_register_iommu_notifier(group, events, nb);
>  		break;
> -	case VFIO_GROUP_NOTIFY:
> -		ret = vfio_register_group_notifier(group, events, nb);
> -		break;
>  	default:
>  		ret = -EINVAL;
>  	}
> @@ -2114,9 +2092,6 @@ int vfio_unregister_notifier(struct vfio_device *device,
>  	case VFIO_IOMMU_NOTIFY:
>  		ret = vfio_unregister_iommu_notifier(group, nb);
>  		break;
> -	case VFIO_GROUP_NOTIFY:
> -		ret = blocking_notifier_chain_unregister(&group->notifier, nb);
> -		break;
>  	default:
>  		ret = -EINVAL;
>  	}
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index 45b287826ce6..aa888cc51757 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -36,6 +36,8 @@ struct vfio_device {
>  	struct vfio_device_set *dev_set;
>  	struct list_head dev_set_list;
>  	unsigned int migration_flags;
> +	/* Driver must reference the kvm during open_device or never touch it */
> +	struct kvm *kvm;
>  
>  	/* Members below here are private, not for driver use */
>  	refcount_t refcount;
> @@ -155,15 +157,11 @@ extern int vfio_dma_rw(struct vfio_device *device, dma_addr_t user_iova,
>  /* each type has independent events */
>  enum vfio_notify_type {
>  	VFIO_IOMMU_NOTIFY = 0,
> -	VFIO_GROUP_NOTIFY = 1,
>  };
>  
>  /* events for VFIO_IOMMU_NOTIFY */
>  #define VFIO_IOMMU_NOTIFY_DMA_UNMAP	BIT(0)
>  
> -/* events for VFIO_GROUP_NOTIFY */
> -#define VFIO_GROUP_NOTIFY_SET_KVM	BIT(0)
> -
>  extern int vfio_register_notifier(struct vfio_device *device,
>  				  enum vfio_notify_type type,
>  				  unsigned long *required_events,

