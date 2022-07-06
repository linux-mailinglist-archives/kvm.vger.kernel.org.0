Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5385F568DF8
	for <lists+kvm@lfdr.de>; Wed,  6 Jul 2022 17:50:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234654AbiGFPsX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jul 2022 11:48:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233460AbiGFPsA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jul 2022 11:48:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F2BA12BB2B
        for <kvm@vger.kernel.org>; Wed,  6 Jul 2022 08:40:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657122051;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EQWobngqBe6IZBHiTe5Vq583Hw8uyiCzbasFlNmig+o=;
        b=GZycegSsSUEO5Sj6jqD8oELKl4Jdk57r0Win4RiNGTgkkqTqKNjZ87BrFOypzpemjpFAtK
        iYQXyBfJm1d+bVYHOgOpht0c+6WcZX16azhhlM2FL0ebHlZoPg7ctyoVspM+pQgJpPWol4
        DA8z9lDywhzL3aWUCXKJUgXd/f9475Q=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-350-0rNkbeOpPKCTBamOVGhh-w-1; Wed, 06 Jul 2022 11:40:49 -0400
X-MC-Unique: 0rNkbeOpPKCTBamOVGhh-w-1
Received: by mail-io1-f71.google.com with SMTP id bw12-20020a056602398c00b00675895c2e24so8275946iob.19
        for <kvm@vger.kernel.org>; Wed, 06 Jul 2022 08:40:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=EQWobngqBe6IZBHiTe5Vq583Hw8uyiCzbasFlNmig+o=;
        b=IotJbKmKJ2hOBIKs0X2nru+Gzv267MwKuQcJKD5xG86/LPPTtxdo4XiTxIo2Q/IOQ0
         hBQNALVybrVofFrikHJcqeuS6RjdMag0asg9Bvo04BQGJwhqM4so/PWkbKXiFDBFn8CI
         oUr18uCmK8kjh764jitjRNLSOa7CTedcU5Fm0clXb437dYFBooDIfqzOZpNXYZM5nWBh
         2Rn/9yeE40rXRPSQ2orSr1fi4H5BRhUYm7QRSPt5YmntxK4sKhCjIAKP7eaKfkBjL4E+
         bGeceeziC+i/wL/Mb9oCtusLuP97JlOO1n/Q/7t6U+vdqCh2cpuQ74/aQfIjghoap6sq
         M4Fw==
X-Gm-Message-State: AJIora8Q6dYZ1nog0w+Ak9awmVM3oP8pbWiTAlxyJE5WxyAfTQU3k0bC
        xYjrwC5lkaBRswIdh5Ex4uQr9lK4BAEvslOpfV0m/d50UQWUoJLWFjKLm9fW/q6LwQgcNS6DzY9
        nZ0cPfIID6HF1
X-Received: by 2002:a92:a041:0:b0:2d7:7935:effa with SMTP id b1-20020a92a041000000b002d77935effamr23000469ilm.222.1657122046801;
        Wed, 06 Jul 2022 08:40:46 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1t7pHOM4PDCPwuJ5q92vRgbxmezrBziN8I+uRP0y5FKdg39CYK7WijNHV4L2+SG99cOmuGmhg==
X-Received: by 2002:a92:a041:0:b0:2d7:7935:effa with SMTP id b1-20020a92a041000000b002d77935effamr23000448ilm.222.1657122046476;
        Wed, 06 Jul 2022 08:40:46 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id a17-20020a056e0208b100b002d955fab9dbsm14702119ilt.23.2022.07.06.08.40.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jul 2022 08:40:46 -0700 (PDT)
Date:   Wed, 6 Jul 2022 09:40:09 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Abhishek Sahu <abhsahu@nvidia.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Kevin Tian <kevin.tian@intel.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <linux-pci@vger.kernel.org>
Subject: Re: [PATCH v4 6/6] vfio/pci: Add support for virtual PME
Message-ID: <20220706094009.6726cf6a.alex.williamson@redhat.com>
In-Reply-To: <20220701110814.7310-7-abhsahu@nvidia.com>
References: <20220701110814.7310-1-abhsahu@nvidia.com>
        <20220701110814.7310-7-abhsahu@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 1 Jul 2022 16:38:14 +0530
Abhishek Sahu <abhsahu@nvidia.com> wrote:

> If the PCI device is in low power state and the device requires
> wake-up, then it can generate PME (Power Management Events). Mostly
> these PME events will be propagated to the root port and then the
> root port will generate the system interrupt. Then the OS should
> identify the device which generated the PME and should resume
> the device.
> 
> We can implement a similar virtual PME framework where if the device
> already went into the runtime suspended state and then there is any
> wake-up on the host side, then it will send the virtual PME
> notification to the guest. This virtual PME will be helpful for the cases
> where the device will not be suspended again if there is any wake-up
> triggered by the host. Following is the overall approach regarding
> the virtual PME.
> 
> 1. Add one more event like VFIO_PCI_ERR_IRQ_INDEX named
>    VFIO_PCI_PME_IRQ_INDEX and do the required code changes to get/set
>    this new IRQ.
> 
> 2. From the guest side, the guest needs to enable eventfd for the
>    virtual PME notification.
> 
> 3. In the vfio-pci driver, the PME support bits are currently
>    virtualized and set to 0. We can set PME capability support for all
>    the power states. This PME capability support is independent of the
>    physical PME support.
> 
> 4. The PME enable (PME_En bit in Power Management Control/Status
>    Register) and PME status (PME_Status bit in Power Management
>    Control/Status Register) are also virtualized currently.
>    The write support for PME_En bit can be enabled.
> 
> 5. The PME_Status bit is a write-1-clear bit where the write with
>    zero value will have no effect and write with 1 value will clear the
>    bit. The write for this bit will be trapped inside
>    vfio_pm_config_write() similar to PCI_PM_CTRL write for PM_STATES.
> 
> 6. When the host gets a request for resuming the device other than from
>    low power exit feature IOCTL, then PME_Status bit will be set.
>    According to [PCIe v5 7.5.2.2],
>      "PME_Status - This bit is Set when the Function would normally
>       generate a PME signal. The value of this bit is not affected by
>       the value of the PME_En bit."
> 
>    So even if PME_En bit is not set, we can set PME_Status bit.
> 
> 7. If the guest has enabled PME_En and registered for PME events
>    through eventfd, then the usage count will be incremented to prevent
>    the device to go into the suspended state and notify the guest through
>    eventfd trigger.
> 
> The virtual PME can help in handling physical PME also. When
> physical PME comes, then also the runtime resume will be called. If
> the guest has registered for virtual PME, then it will be sent in this
> case also.
> 
> * Implementation for handling the virtual PME on the hypervisor:
> 
> If we take the implementation in Linux OS, then during runtime suspend
> time, then it calls __pci_enable_wake(). It internally enables PME
> through pci_pme_active() and also enables the ACPI side wake-up
> through platform_pci_set_wakeup(). To handle the PME, the hypervisor has
> the following two options:
> 
> 1. Create a virtual root port for the VFIO device and trigger
>    interrupt when the PME comes. It will call pcie_pme_irq() which will
>    resume the device.
> 
> 2. Create a virtual ACPI _PRW resource and associate it with the device
>    itself. In _PRW, any GPE (General Purpose Event) can be assigned for
>    the wake-up. When PME comes, then GPE can be triggered by the
>    hypervisor. GPE interrupt will call pci_acpi_wake_dev() function
>    internally and it will resume the device.

Do we really need to implement PME emulation in the kernel or is it
sufficient for userspace to simply register a one-shot eventfd when
SET'ing the low power feature and QEMU can provide the PME emulation
based on that signaling?  Thanks,

Alex

> 
> Signed-off-by: Abhishek Sahu <abhsahu@nvidia.com>
> ---
>  drivers/vfio/pci/vfio_pci_config.c | 39 +++++++++++++++++++++------
>  drivers/vfio/pci/vfio_pci_core.c   | 43 ++++++++++++++++++++++++------
>  drivers/vfio/pci/vfio_pci_intrs.c  | 18 +++++++++++++
>  include/linux/vfio_pci_core.h      |  2 ++
>  include/uapi/linux/vfio.h          |  1 +
>  5 files changed, 87 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
> index 21a4743d011f..a06375a03758 100644
> --- a/drivers/vfio/pci/vfio_pci_config.c
> +++ b/drivers/vfio/pci/vfio_pci_config.c
> @@ -719,6 +719,20 @@ static int vfio_pm_config_write(struct vfio_pci_core_device *vdev, int pos,
>  	if (count < 0)
>  		return count;
>  
> +	/*
> +	 * PME_STATUS is write-1-clear bit. If PME_STATUS is 1, then clear the
> +	 * bit in vconfig. The PME_STATUS is in the upper byte of the control
> +	 * register and user can do single byte write also.
> +	 */
> +	if (offset <= PCI_PM_CTRL + 1 && offset + count > PCI_PM_CTRL + 1) {
> +		if (le32_to_cpu(val) &
> +		    (PCI_PM_CTRL_PME_STATUS >> (offset - PCI_PM_CTRL) * 8)) {
> +			__le16 *ctrl = (__le16 *)&vdev->vconfig
> +					[vdev->pm_cap_offset + PCI_PM_CTRL];
> +			*ctrl &= ~cpu_to_le16(PCI_PM_CTRL_PME_STATUS);
> +		}
> +	}
> +
>  	if (offset == PCI_PM_CTRL) {
>  		pci_power_t state;
>  
> @@ -771,14 +785,16 @@ static int __init init_pci_cap_pm_perm(struct perm_bits *perm)
>  	 * the user change power state, but we trap and initiate the
>  	 * change ourselves, so the state bits are read-only.
>  	 *
> -	 * The guest can't process PME from D3cold so virtualize PME_Status
> -	 * and PME_En bits. The vconfig bits will be cleared during device
> -	 * capability initialization.
> +	 * The guest can't process physical PME from D3cold so virtualize
> +	 * PME_Status and PME_En bits. These bits will be used for the
> +	 * virtual PME between host and guest. The vconfig bits will be
> +	 * updated during device capability initialization. PME_Status is
> +	 * write-1-clear bit, so it is read-only. We trap and update the
> +	 * vconfig bit manually during write.
>  	 */
>  	p_setd(perm, PCI_PM_CTRL,
>  	       PCI_PM_CTRL_PME_ENABLE | PCI_PM_CTRL_PME_STATUS,
> -	       ~(PCI_PM_CTRL_PME_ENABLE | PCI_PM_CTRL_PME_STATUS |
> -		 PCI_PM_CTRL_STATE_MASK));
> +	       ~(PCI_PM_CTRL_STATE_MASK | PCI_PM_CTRL_PME_STATUS));
>  
>  	return 0;
>  }
> @@ -1454,8 +1470,13 @@ static void vfio_update_pm_vconfig_bytes(struct vfio_pci_core_device *vdev,
>  	__le16 *pmc = (__le16 *)&vdev->vconfig[offset + PCI_PM_PMC];
>  	__le16 *ctrl = (__le16 *)&vdev->vconfig[offset + PCI_PM_CTRL];
>  
> -	/* Clear vconfig PME_Support, PME_Status, and PME_En bits */
> -	*pmc &= ~cpu_to_le16(PCI_PM_CAP_PME_MASK);
> +	/*
> +	 * Set the vconfig PME_Support bits. The PME_Status is being used for
> +	 * virtual PME support and is not dependent upon the physical
> +	 * PME support.
> +	 */
> +	*pmc |= cpu_to_le16(PCI_PM_CAP_PME_MASK);
> +	/* Clear vconfig PME_Support and PME_En bits */
>  	*ctrl &= ~cpu_to_le16(PCI_PM_CTRL_PME_ENABLE | PCI_PM_CTRL_PME_STATUS);
>  }
>  
> @@ -1582,8 +1603,10 @@ static int vfio_cap_init(struct vfio_pci_core_device *vdev)
>  		if (ret)
>  			return ret;
>  
> -		if (cap == PCI_CAP_ID_PM)
> +		if (cap == PCI_CAP_ID_PM) {
> +			vdev->pm_cap_offset = pos;
>  			vfio_update_pm_vconfig_bytes(vdev, pos);
> +		}
>  
>  		prev = &vdev->vconfig[pos + PCI_CAP_LIST_NEXT];
>  		pos = next;
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index 1ddaaa6ccef5..6c1225bc2aeb 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -319,14 +319,35 @@ static int vfio_pci_core_runtime_resume(struct device *dev)
>  	 *   the low power state or closed the device.
>  	 * - If there is device access on the host side.
>  	 *
> -	 * For the second case, check if re-entry to the low power state is
> -	 * allowed. If not, then increment the usage count so that runtime PM
> -	 * framework won't suspend the device and set the 'pm_runtime_resumed'
> -	 * flag.
> +	 * For the second case:
> +	 * - The virtual PME_STATUS bit will be set. If PME_ENABLE bit is set
> +	 *   and user has registered for virtual PME events, then send the PME
> +	 *   virtual PME event.
> +	 * - Check if re-entry to the low power state is not allowed.
> +	 *
> +	 * For the above conditions, increment the usage count so that
> +	 * runtime PM framework won't suspend the device and set the
> +	 * 'pm_runtime_resumed' flag.
>  	 */
> -	if (vdev->pm_runtime_engaged && !vdev->pm_runtime_reentry_allowed) {
> -		pm_runtime_get_noresume(dev);
> -		vdev->pm_runtime_resumed = true;
> +	if (vdev->pm_runtime_engaged) {
> +		bool pme_triggered = false;
> +		__le16 *ctrl = (__le16 *)&vdev->vconfig
> +				[vdev->pm_cap_offset + PCI_PM_CTRL];
> +
> +		*ctrl |= cpu_to_le16(PCI_PM_CTRL_PME_STATUS);
> +		if (le16_to_cpu(*ctrl) & PCI_PM_CTRL_PME_ENABLE) {
> +			mutex_lock(&vdev->igate);
> +			if (vdev->pme_trigger) {
> +				pme_triggered = true;
> +				eventfd_signal(vdev->pme_trigger, 1);
> +			}
> +			mutex_unlock(&vdev->igate);
> +		}
> +
> +		if (!vdev->pm_runtime_reentry_allowed || pme_triggered) {
> +			pm_runtime_get_noresume(dev);
> +			vdev->pm_runtime_resumed = true;
> +		}
>  	}
>  	up_write(&vdev->memory_lock);
>  
> @@ -586,6 +607,10 @@ void vfio_pci_core_close_device(struct vfio_device *core_vdev)
>  		eventfd_ctx_put(vdev->req_trigger);
>  		vdev->req_trigger = NULL;
>  	}
> +	if (vdev->pme_trigger) {
> +		eventfd_ctx_put(vdev->pme_trigger);
> +		vdev->pme_trigger = NULL;
> +	}
>  	mutex_unlock(&vdev->igate);
>  }
>  EXPORT_SYMBOL_GPL(vfio_pci_core_close_device);
> @@ -639,7 +664,8 @@ static int vfio_pci_get_irq_count(struct vfio_pci_core_device *vdev, int irq_typ
>  	} else if (irq_type == VFIO_PCI_ERR_IRQ_INDEX) {
>  		if (pci_is_pcie(vdev->pdev))
>  			return 1;
> -	} else if (irq_type == VFIO_PCI_REQ_IRQ_INDEX) {
> +	} else if (irq_type == VFIO_PCI_REQ_IRQ_INDEX ||
> +		   irq_type == VFIO_PCI_PME_IRQ_INDEX) {
>  		return 1;
>  	}
>  
> @@ -985,6 +1011,7 @@ long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
>  		switch (info.index) {
>  		case VFIO_PCI_INTX_IRQ_INDEX ... VFIO_PCI_MSIX_IRQ_INDEX:
>  		case VFIO_PCI_REQ_IRQ_INDEX:
> +		case VFIO_PCI_PME_IRQ_INDEX:
>  			break;
>  		case VFIO_PCI_ERR_IRQ_INDEX:
>  			if (pci_is_pcie(vdev->pdev))
> diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
> index 1a37db99df48..db4180687a74 100644
> --- a/drivers/vfio/pci/vfio_pci_intrs.c
> +++ b/drivers/vfio/pci/vfio_pci_intrs.c
> @@ -639,6 +639,17 @@ static int vfio_pci_set_req_trigger(struct vfio_pci_core_device *vdev,
>  					       count, flags, data);
>  }
>  
> +static int vfio_pci_set_pme_trigger(struct vfio_pci_core_device *vdev,
> +				    unsigned index, unsigned start,
> +				    unsigned count, uint32_t flags, void *data)
> +{
> +	if (index != VFIO_PCI_PME_IRQ_INDEX || start != 0 || count > 1)
> +		return -EINVAL;
> +
> +	return vfio_pci_set_ctx_trigger_single(&vdev->pme_trigger,
> +					       count, flags, data);
> +}
> +
>  int vfio_pci_set_irqs_ioctl(struct vfio_pci_core_device *vdev, uint32_t flags,
>  			    unsigned index, unsigned start, unsigned count,
>  			    void *data)
> @@ -688,6 +699,13 @@ int vfio_pci_set_irqs_ioctl(struct vfio_pci_core_device *vdev, uint32_t flags,
>  			break;
>  		}
>  		break;
> +	case VFIO_PCI_PME_IRQ_INDEX:
> +		switch (flags & VFIO_IRQ_SET_ACTION_TYPE_MASK) {
> +		case VFIO_IRQ_SET_ACTION_TRIGGER:
> +			func = vfio_pci_set_pme_trigger;
> +			break;
> +		}
> +		break;
>  	}
>  
>  	if (!func)
> diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
> index 18cc83b767b8..ee2646d820c2 100644
> --- a/include/linux/vfio_pci_core.h
> +++ b/include/linux/vfio_pci_core.h
> @@ -102,6 +102,7 @@ struct vfio_pci_core_device {
>  	bool			bar_mmap_supported[PCI_STD_NUM_BARS];
>  	u8			*pci_config_map;
>  	u8			*vconfig;
> +	u8			pm_cap_offset;
>  	struct perm_bits	*msi_perm;
>  	spinlock_t		irqlock;
>  	struct mutex		igate;
> @@ -133,6 +134,7 @@ struct vfio_pci_core_device {
>  	int			ioeventfds_nr;
>  	struct eventfd_ctx	*err_trigger;
>  	struct eventfd_ctx	*req_trigger;
> +	struct eventfd_ctx	*pme_trigger;
>  	struct list_head	dummy_resources_list;
>  	struct mutex		ioeventfds_lock;
>  	struct list_head	ioeventfds_list;
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 7e00de5c21ea..08170950d655 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -621,6 +621,7 @@ enum {
>  	VFIO_PCI_MSIX_IRQ_INDEX,
>  	VFIO_PCI_ERR_IRQ_INDEX,
>  	VFIO_PCI_REQ_IRQ_INDEX,
> +	VFIO_PCI_PME_IRQ_INDEX,
>  	VFIO_PCI_NUM_IRQS
>  };
>  

