Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 425766BF4CC
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 23:00:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230359AbjCQV7l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 17:59:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbjCQV7i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 17:59:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3E7037B73
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 14:58:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679090319;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pOoNggaNrRU0x9UPOrR6/pBGLjWwIZnTfEp906MOxHQ=;
        b=YsER/Tb+znqBvxWe2+jtIq9XBK6L3cBlCUIkmc2i33JoSol9DsQBSDHh4m9FPUQGgT0lVk
        rhystcivFcivDtpnjCX2nKei/uX55hF5kHJ/N3TsVBtOnlWKdaQbmWasdI2c7pZrqkIo98
        YGt8dH+bzpDdObZn2yTybTROHLJ0Ubs=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-629-YX4NQYbdNXeznwHWnhT6qg-1; Fri, 17 Mar 2023 17:58:38 -0400
X-MC-Unique: YX4NQYbdNXeznwHWnhT6qg-1
Received: by mail-io1-f70.google.com with SMTP id u23-20020a6be917000000b007532ab65c70so2996101iof.12
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 14:58:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679090317;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pOoNggaNrRU0x9UPOrR6/pBGLjWwIZnTfEp906MOxHQ=;
        b=xRh5dYDlDf9uoa/HJtb2XtkMzyp+T5wjYHvUHnAyVxQgSzltVGhCZSJvRTKgq+VgY3
         xKSBnPtF78Fm+WzHqyeXkEzqybkJWcXWhrRLCATUqkxxIyT4vv8jZ8IBqaBBwruTNaqs
         lhpxcEDLOE63Tw3qOVtI3utmrtfmt8mnIi6AJqHwbXbouFeun5m1BdJcqNdei+gXX1V0
         Xay0pyqk70ihpFR61PbeMFdx+yVGws0Dviow6CRIXOAttKVbh8rT53xdFzJcqOt1VsWT
         +yixmM/MDd2ZwDioPbKzz63JTeN/x9Ewjgfka65HwD6xc4CCX/BJrcANgTE8IRi0FDCe
         j72w==
X-Gm-Message-State: AO0yUKXdnMCgs9DKnYbQiim6LiXycTb3As/xEHHnTqDiNLBh4ZYx1eCX
        kAHxaRJusznM+RU6A6sDHbXZ2IzXn1kFlSfTCrWR+YFln6Fw5iFadjWcyRqV5VFr8LRck6PvBZi
        LZ3ieXxomBlik
X-Received: by 2002:a05:6e02:550:b0:323:d3ab:8f3c with SMTP id i16-20020a056e02055000b00323d3ab8f3cmr109529ils.17.1679090317669;
        Fri, 17 Mar 2023 14:58:37 -0700 (PDT)
X-Google-Smtp-Source: AK7set9VVVPJI7uenkc0uouzZj+lprsl9rrHy1K7vPeTJcTp+oi7cJhm4bIy7aWKArni6GiKxTzF7g==
X-Received: by 2002:a05:6e02:550:b0:323:d3ab:8f3c with SMTP id i16-20020a056e02055000b00323d3ab8f3cmr109509ils.17.1679090317295;
        Fri, 17 Mar 2023 14:58:37 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id g2-20020a92c7c2000000b003159b6d97d6sm894668ilk.52.2023.03.17.14.58.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 14:58:36 -0700 (PDT)
Date:   Fri, 17 Mar 2023 15:58:35 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Reinette Chatre <reinette.chatre@intel.com>
Cc:     jgg@nvidia.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        tglx@linutronix.de, darwi@linutronix.de, kvm@vger.kernel.org,
        dave.jiang@intel.com, jing2.liu@intel.com, ashok.raj@intel.com,
        fenghua.yu@intel.com, tom.zanussi@linux.intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 7/8] vfio/pci: Support dynamic MSI-x
Message-ID: <20230317155835.79165907.alex.williamson@redhat.com>
In-Reply-To: <591ce11f4a33e022fc9242324ebdc077202bedaf.1678911529.git.reinette.chatre@intel.com>
References: <cover.1678911529.git.reinette.chatre@intel.com>
        <591ce11f4a33e022fc9242324ebdc077202bedaf.1678911529.git.reinette.chatre@intel.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 15 Mar 2023 13:59:27 -0700
Reinette Chatre <reinette.chatre@intel.com> wrote:

> Recently introduced pci_msix_alloc_irq_at() and pci_msix_free_irq()
> enables an individual MSI-X index to be allocated and freed after
> MSI-X enabling.
> 
> Support dynamic MSI-X by keeping the association between allocated
> interrupt and vfio interrupt context. Allocate new context together
> with the new interrupt if no interrupt context exist for an MSI-X
> interrupt. Similarly, release an interrupt with its context.
> 
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> ---
> 
> Guidance is appreciated on expectations regarding maintaining
> existing error behavior. Earlier patch introduced the
> vfio_irq_ctx_range_allocated() helper to maintain existing error
> behavior. Now, this helper needs to be disabled for MSI-X. User
> space not wanting to dynamically allocate MSI-X interrupts, but
> providing invalid range when providing a new ACTION will now
> obtain new interrupts or new failures (potentially including freeing
> of existing interrupts) if the allocation of the new interrupts fail.
> 
>  drivers/vfio/pci/vfio_pci_intrs.c | 101 ++++++++++++++++++++++++------
>  1 file changed, 83 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
> index b375a12885ba..954a70575802 100644
> --- a/drivers/vfio/pci/vfio_pci_intrs.c
> +++ b/drivers/vfio/pci/vfio_pci_intrs.c
> @@ -55,6 +55,18 @@ struct vfio_pci_irq_ctx *vfio_irq_ctx_get(struct vfio_pci_core_device *vdev,
>  	return xa_load(&vdev->ctx, index);
>  }
>  
> +static void vfio_irq_ctx_free(struct vfio_pci_core_device *vdev,
> +			      unsigned long index)
> +{
> +	struct vfio_pci_irq_ctx *ctx;
> +
> +	ctx = xa_load(&vdev->ctx, index);
> +	if (ctx) {
> +		xa_erase(&vdev->ctx, index);
> +		kfree(ctx);
> +	}
> +}

The only places calling this have a known valid ctx, so it seems
redundant that we xa_load it again.  Should ctx be a function arg to
reduce this to simply xa_erase() + kfree()?

> +
>  static void vfio_irq_ctx_free_all(struct vfio_pci_core_device *vdev)
>  {
>  	struct vfio_pci_irq_ctx *ctx;
> @@ -430,33 +442,63 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
>  {
>  	struct pci_dev *pdev = vdev->pdev;
>  	struct vfio_pci_irq_ctx *ctx;
> +	struct msi_map msix_map = {};
>  	struct eventfd_ctx *trigger;
> +	bool new_ctx;
>  	int irq, ret;
>  	u16 cmd;
>  
>  	ctx = vfio_irq_ctx_get(vdev, vector);
> -	if (!ctx)
> +	/* Only MSI-X allows dynamic allocation. */
> +	if (!msix && !ctx)
>  		return -EINVAL;
> +
>  	irq = pci_irq_vector(pdev, vector);
> +	/* Context and interrupt are always allocated together. */
> +	WARN_ON((ctx && irq == -EINVAL) || (!ctx && irq != -EINVAL));
>  
> -	if (ctx->trigger) {
> +	if (ctx && ctx->trigger) {
>  		irq_bypass_unregister_producer(&ctx->producer);
>  
>  		cmd = vfio_pci_memory_lock_and_enable(vdev);
>  		free_irq(irq, ctx->trigger);
> +		if (msix) {
> +			msix_map.index = vector;
> +			msix_map.virq = irq;
> +			pci_msix_free_irq(pdev, msix_map);
> +			irq = -EINVAL;
> +		}
>  		vfio_pci_memory_unlock_and_restore(vdev, cmd);
>  		kfree(ctx->name);
>  		eventfd_ctx_put(ctx->trigger);
>  		ctx->trigger = NULL;
> +		if (msix) {
> +			vfio_irq_ctx_free(vdev, vector);
> +			ctx = NULL;
> +		}
>  	}
>  
>  	if (fd < 0)
>  		return 0;
>  
> +	if (!ctx) {
> +		ret = vfio_irq_ctx_alloc_single(vdev, vector);
> +		if (ret)
> +			return ret;
> +		ctx = vfio_irq_ctx_get(vdev, vector);

This suggests vfio_irq_ctx_alloc_single() should return ctx.

> +		if (!ctx) {
> +			ret = -EINVAL;
> +			goto out_free_ctx;
> +		}
> +		new_ctx = true;
> +	}
> +
>  	ctx->name = kasprintf(GFP_KERNEL_ACCOUNT, "vfio-msi%s[%d](%s)",
>  			      msix ? "x" : "", vector, pci_name(pdev));
> -	if (!ctx->name)
> -		return -ENOMEM;
> +	if (!ctx->name) {
> +		ret = -ENOMEM;
> +		goto out_free_ctx;
> +	}
>  
>  	trigger = eventfd_ctx_fdget(fd);
>  	if (IS_ERR(trigger)) {
> @@ -464,25 +506,38 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
>  		goto out_free_name;
>  	}
>  
> -	/*
> -	 * The MSIx vector table resides in device memory which may be cleared
> -	 * via backdoor resets. We don't allow direct access to the vector
> -	 * table so even if a userspace driver attempts to save/restore around
> -	 * such a reset it would be unsuccessful. To avoid this, restore the
> -	 * cached value of the message prior to enabling.
> -	 */
>  	cmd = vfio_pci_memory_lock_and_enable(vdev);
>  	if (msix) {
> -		struct msi_msg msg;
> -
> -		get_cached_msi_msg(irq, &msg);
> -		pci_write_msi_msg(irq, &msg);
> +		if (irq == -EINVAL) {
> +			msix_map = pci_msix_alloc_irq_at(pdev, vector, NULL);

It looks to me like we need to support MSI-X with both NORESIZE
behavior and dynamic allocation based on pci_msix_can_alloc_dyn().
It's not entirely clear to me where this is and isn't supported, but
the existence of the test helper suggests we can't assume support.


> +			if (msix_map.index < 0) {
> +				vfio_pci_memory_unlock_and_restore(vdev, cmd);
> +				ret = msix_map.index;
> +				goto out_put_eventfd_ctx;
> +			}
> +			irq = msix_map.virq;
> +		} else {
> +			/*
> +			 * The MSIx vector table resides in device memory which
> +			 * may be cleared via backdoor resets. We don't allow
> +			 * direct access to the vector table so even if a
> +			 * userspace driver attempts to save/restore around
> +			 * such a reset it would be unsuccessful. To avoid
> +			 * this, restore the cached value of the message prior
> +			 * to enabling.
> +			 */
> +			struct msi_msg msg;
> +
> +			get_cached_msi_msg(irq, &msg);
> +			pci_write_msi_msg(irq, &msg);
> +		}

I don't follow when this latter branch is ever taken in the new flow.
It's stated earlier that ctx and irq are coupled, and I believe so is
trigger.  So if we had a previous ctx and irq (and trigger), we removed
it and irq is now always -EINVAL here.  Thanks,

Alex

>  	}
>  
>  	ret = request_irq(irq, vfio_msihandler, 0, ctx->name, trigger);
> -	vfio_pci_memory_unlock_and_restore(vdev, cmd);
>  	if (ret)
> -		goto out_put_eventfd_ctx;
> +		goto out_free_irq_locked;
> +
> +	vfio_pci_memory_unlock_and_restore(vdev, cmd);
>  
>  	ctx->producer.token = trigger;
>  	ctx->producer.irq = irq;
> @@ -498,11 +553,21 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
>  
>  	return 0;
>  
> +out_free_irq_locked:
> +	if (msix && new_ctx) {
> +		msix_map.index = vector;
> +		msix_map.virq = irq;
> +		pci_msix_free_irq(pdev, msix_map);
> +	}
> +	vfio_pci_memory_unlock_and_restore(vdev, cmd);
>  out_put_eventfd_ctx:
>  	eventfd_ctx_put(trigger);
>  out_free_name:
>  	kfree(ctx->name);
>  	ctx->name = NULL;
> +out_free_ctx:
> +	if (msix && new_ctx)
> +		vfio_irq_ctx_free(vdev, vector);
>  	return ret;
>  }
>  
> @@ -512,7 +577,7 @@ static int vfio_msi_set_block(struct vfio_pci_core_device *vdev, unsigned start,
>  	int i, ret = 0;
>  	unsigned int j;
>  
> -	if (!vfio_irq_ctx_range_allocated(vdev, start, count))
> +	if (!msix && !vfio_irq_ctx_range_allocated(vdev, start, count))
>  		return -EINVAL;
>  
>  	for (i = 0, j = start; i < count && !ret; i++, j++) {

