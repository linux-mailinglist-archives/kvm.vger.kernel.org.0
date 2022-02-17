Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 959084BAD1E
	for <lists+kvm@lfdr.de>; Fri, 18 Feb 2022 00:15:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbiBQXP0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Feb 2022 18:15:26 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:42706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbiBQXPZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Feb 2022 18:15:25 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A06832B7605
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 15:15:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645139664;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cbnvbc3fsHmXHX+qkuLBQ8KJ8n5Rlnoh3IJADqcgMiQ=;
        b=jQxrL1PNcaWa+pMoSQOT5ljOIgdrfdDIRwdVDDDFcfh6vXnDpLeGt4AAVOIAN+k5qvaaRY
        gQ4+QLlImvzwV346tRftI/UsPNn3wZnGm0QFvL0ApWOTBdFc/3X6+qk7KYGxAVtQAPxtRY
        CoRbLmeUaO/sj+tngfINqBDUdFLvb+Y=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-619-Qm_2f1oqP5KSkCoSU5eEaQ-1; Thu, 17 Feb 2022 18:14:23 -0500
X-MC-Unique: Qm_2f1oqP5KSkCoSU5eEaQ-1
Received: by mail-il1-f198.google.com with SMTP id p16-20020a927410000000b002be8797ac0bso2899517ilc.7
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 15:14:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=cbnvbc3fsHmXHX+qkuLBQ8KJ8n5Rlnoh3IJADqcgMiQ=;
        b=vGsJRHl7yHddUyzBoGn0RyHrSXv/WQoNXi+D1/X/A9oyhMQw3+jGLQ4X5Sm+nG+Ug6
         eyV/pm+wdQ6rUMjqoEHge6fcTNjYilX+tNXaxLwg2f9TZUb4YNQZevxVDnNg3bXNduPV
         0ovTFSzrB9gCE+8fjlN5HpFphqMWwKg6zVKAf/FMLz9dAoEyRUyZtDPP+W/PXb+ybJG4
         F38KkIIviuDA/YU7rPAiSnRp2HmPF5uhOY/HNOeoE2wS46fpPqZhyHTva8+xEQ3RuV1N
         JQKJ7L8rl69/Rc9hnnE9DR1aGfjYteYe9uB6PDUqLA8v+sUwLYtGAsdzBYhI1ADMXjbi
         TzOw==
X-Gm-Message-State: AOAM531lOH3JHzDa9BMoGfRpud25KS+NARqNF4TCK9pQqHt7J4sc1UoK
        pTCvU77us5G4GFOJgRb4M45YTfHZG6+P6yvQG4if+4gLqRTxoxjC43fMm2USOJvYfRJ5QxSUaQv
        TuQsgv+TD+TXt
X-Received: by 2002:a05:6638:12d6:b0:314:3e89:58db with SMTP id v22-20020a05663812d600b003143e8958dbmr3325376jas.216.1645139662316;
        Thu, 17 Feb 2022 15:14:22 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzYE3q8jS5VDryDylvqVHq+LTf5McaTWOUTQOMzTPWtDASW3mAJ36djui+NZWt45ANx653jKA==
X-Received: by 2002:a05:6638:12d6:b0:314:3e89:58db with SMTP id v22-20020a05663812d600b003143e8958dbmr3325360jas.216.1645139661966;
        Thu, 17 Feb 2022 15:14:21 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id j14sm2565897ilc.62.2022.02.17.15.14.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Feb 2022 15:14:21 -0800 (PST)
Date:   Thu, 17 Feb 2022 16:14:20 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Abhishek Sahu <abhsahu@nvidia.com>
Cc:     <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v2 4/5] vfio/pci: Invalidate mmaps and block the
 access in D3hot power state
Message-ID: <20220217161420.7232eab6.alex.williamson@redhat.com>
In-Reply-To: <20220124181726.19174-5-abhsahu@nvidia.com>
References: <20220124181726.19174-1-abhsahu@nvidia.com>
        <20220124181726.19174-5-abhsahu@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 24 Jan 2022 23:47:25 +0530
Abhishek Sahu <abhsahu@nvidia.com> wrote:

> According to [PCIe v5 5.3.1.4.1] for D3hot state
> 
>  "Configuration and Message requests are the only TLPs accepted by a
>   Function in the D3Hot state. All other received Requests must be
>   handled as Unsupported Requests, and all received Completions may
>   optionally be handled as Unexpected Completions."
> 
> Currently, if the vfio PCI device has been put into D3hot state and if
> user makes non-config related read/write request in D3hot state, these
> requests will be forwarded to the host and this access may cause
> issues on a few systems.
> 
> This patch leverages the memory-disable support added in commit
> 'abafbc551fdd ("vfio-pci: Invalidate mmaps and block MMIO access on
> disabled memory")' to generate page fault on mmap access and
> return error for the direct read/write. If the device is D3hot state,
> then the error needs to be returned for all kinds of BAR
> related access (memory, IO and ROM). Also, the power related structure
> fields need to be protected so we can use the same 'memory_lock' to
> protect these fields also. For the few cases, this 'memory_lock' will be
> already acquired by callers so introduce a separate function
> vfio_pci_set_power_state_locked(). The original
> vfio_pci_set_power_state() now contains the code to do the locking
> related operations.
> 
> Signed-off-by: Abhishek Sahu <abhsahu@nvidia.com>
> ---
>  drivers/vfio/pci/vfio_pci_core.c | 47 +++++++++++++++++++++++++-------
>  drivers/vfio/pci/vfio_pci_rdwr.c | 20 ++++++++++----
>  2 files changed, 51 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index ee2fb8af57fa..38440d48973f 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -201,11 +201,12 @@ static void vfio_pci_probe_power_state(struct vfio_pci_core_device *vdev)
>  }
>  
>  /*
> - * pci_set_power_state() wrapper handling devices which perform a soft reset on
> - * D3->D0 transition.  Save state prior to D0/1/2->D3, stash it on the vdev,
> - * restore when returned to D0.  Saved separately from pci_saved_state for use
> - * by PM capability emulation and separately from pci_dev internal saved state
> - * to avoid it being overwritten and consumed around other resets.
> + * vfio_pci_set_power_state_locked() wrapper handling devices which perform a
> + * soft reset on D3->D0 transition.  Save state prior to D0/1/2->D3, stash it
> + * on the vdev, restore when returned to D0.  Saved separately from
> + * pci_saved_state for use by PM capability emulation and separately from
> + * pci_dev internal saved state to avoid it being overwritten and consumed
> + * around other resets.
>   *
>   * There are few cases where the PCI power state can be changed to D0
>   * without the involvement of this API. So, cache the power state locally
> @@ -215,7 +216,8 @@ static void vfio_pci_probe_power_state(struct vfio_pci_core_device *vdev)
>   * The memory taken for saving this PCI state needs to be freed to
>   * prevent memory leak.
>   */
> -int vfio_pci_set_power_state(struct vfio_pci_core_device *vdev, pci_power_t state)
> +static int vfio_pci_set_power_state_locked(struct vfio_pci_core_device *vdev,
> +					   pci_power_t state)
>  {
>  	struct pci_dev *pdev = vdev->pdev;
>  	bool needs_restore = false, needs_save = false;
> @@ -260,6 +262,26 @@ int vfio_pci_set_power_state(struct vfio_pci_core_device *vdev, pci_power_t stat
>  	return ret;
>  }
>  
> +/*
> + * vfio_pci_set_power_state() takes all the required locks to protect
> + * the access of power related variables and then invokes
> + * vfio_pci_set_power_state_locked().
> + */
> +int vfio_pci_set_power_state(struct vfio_pci_core_device *vdev,
> +			     pci_power_t state)
> +{
> +	int ret;
> +
> +	if (state >= PCI_D3hot)
> +		vfio_pci_zap_and_down_write_memory_lock(vdev);
> +	else
> +		down_write(&vdev->memory_lock);
> +
> +	ret = vfio_pci_set_power_state_locked(vdev, state);
> +	up_write(&vdev->memory_lock);
> +	return ret;
> +}
> +
>  int vfio_pci_core_enable(struct vfio_pci_core_device *vdev)
>  {
>  	struct pci_dev *pdev = vdev->pdev;
> @@ -354,7 +376,7 @@ void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
>  	 * in running the logic needed for D0 power state. The subsequent
>  	 * runtime PM API's will put the device into the low power state again.
>  	 */
> -	vfio_pci_set_power_state(vdev, PCI_D0);
> +	vfio_pci_set_power_state_locked(vdev, PCI_D0);
>  
>  	/* Stop the device from further DMA */
>  	pci_clear_master(pdev);
> @@ -967,7 +989,7 @@ long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
>  		 * interaction. Update the power state in vfio driver to perform
>  		 * the logic needed for D0 power state.
>  		 */
> -		vfio_pci_set_power_state(vdev, PCI_D0);
> +		vfio_pci_set_power_state_locked(vdev, PCI_D0);
>  		up_write(&vdev->memory_lock);
>  
>  		return ret;
> @@ -1453,6 +1475,11 @@ static vm_fault_t vfio_pci_mmap_fault(struct vm_fault *vmf)
>  		goto up_out;
>  	}
>  
> +	if (vdev->power_state >= PCI_D3hot) {
> +		ret = VM_FAULT_SIGBUS;
> +		goto up_out;
> +	}
> +
>  	/*
>  	 * We populate the whole vma on fault, so we need to test whether
>  	 * the vma has already been mapped, such as for concurrent faults
> @@ -1902,7 +1929,7 @@ int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev)
>  	 * be able to get to D3.  Therefore first do a D0 transition
>  	 * before enabling runtime PM.
>  	 */
> -	vfio_pci_set_power_state(vdev, PCI_D0);
> +	vfio_pci_set_power_state_locked(vdev, PCI_D0);
>  	pm_runtime_allow(&pdev->dev);
>  
>  	if (!disable_idle_d3)
> @@ -2117,7 +2144,7 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
>  		 * interaction. Update the power state in vfio driver to perform
>  		 * the logic needed for D0 power state.
>  		 */
> -		vfio_pci_set_power_state(cur, PCI_D0);
> +		vfio_pci_set_power_state_locked(cur, PCI_D0);
>  		if (cur == cur_mem)
>  			is_mem = false;
>  		if (cur == cur_vma)
> diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
> index 57d3b2cbbd8e..e97ba14c4aa0 100644
> --- a/drivers/vfio/pci/vfio_pci_rdwr.c
> +++ b/drivers/vfio/pci/vfio_pci_rdwr.c
> @@ -41,8 +41,13 @@
>  static int vfio_pci_iowrite##size(struct vfio_pci_core_device *vdev,		\
>  			bool test_mem, u##size val, void __iomem *io)	\
>  {									\
> +	down_read(&vdev->memory_lock);					\
> +	if (vdev->power_state >= PCI_D3hot) {				\
> +		up_read(&vdev->memory_lock);				\
> +		return -EIO;						\
> +	}								\
> +									\

The reason that we only set test_mem for MMIO BARs is that systems are
generally more lenient about probing unresponsive I/O port space to
support legacy use cases.  Have you found cases where access to an I/O
port BAR when the device is either in D3hot+ or I/O port is disabled in
the command register triggers a system fault?  If not it seems we could
roll the power_state check into __vfio_pci_memory_enabled(), if so then
we probably need to improve our coverage of access to disabled I/O port
BARs beyond only the power_state check.  Thanks,

Alex

>  	if (test_mem) {							\
> -		down_read(&vdev->memory_lock);				\
>  		if (!__vfio_pci_memory_enabled(vdev)) {			\
>  			up_read(&vdev->memory_lock);			\
>  			return -EIO;					\
> @@ -51,8 +56,7 @@ static int vfio_pci_iowrite##size(struct vfio_pci_core_device *vdev,		\
>  									\
>  	vfio_iowrite##size(val, io);					\
>  									\
> -	if (test_mem)							\
> -		up_read(&vdev->memory_lock);				\
> +	up_read(&vdev->memory_lock);					\
>  									\
>  	return 0;							\
>  }
> @@ -68,8 +72,13 @@ VFIO_IOWRITE(64)
>  static int vfio_pci_ioread##size(struct vfio_pci_core_device *vdev,		\
>  			bool test_mem, u##size *val, void __iomem *io)	\
>  {									\
> +	down_read(&vdev->memory_lock);					\
> +	if (vdev->power_state >= PCI_D3hot) {				\
> +		up_read(&vdev->memory_lock);				\
> +		return -EIO;						\
> +	}								\
> +									\
>  	if (test_mem) {							\
> -		down_read(&vdev->memory_lock);				\
>  		if (!__vfio_pci_memory_enabled(vdev)) {			\
>  			up_read(&vdev->memory_lock);			\
>  			return -EIO;					\
> @@ -78,8 +87,7 @@ static int vfio_pci_ioread##size(struct vfio_pci_core_device *vdev,		\
>  									\
>  	*val = vfio_ioread##size(io);					\
>  									\
> -	if (test_mem)							\
> -		up_read(&vdev->memory_lock);				\
> +	up_read(&vdev->memory_lock);					\
>  									\
>  	return 0;							\
>  }

