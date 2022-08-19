Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18C6759A776
	for <lists+kvm@lfdr.de>; Fri, 19 Aug 2022 23:11:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351948AbiHSVKz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Aug 2022 17:10:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352232AbiHSVKp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Aug 2022 17:10:45 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17671E0952;
        Fri, 19 Aug 2022 14:10:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
        Message-ID:Sender:Reply-To:Content-ID:Content-Description;
        bh=ellEIQ/+GNYDRYLpWlIUIo1Eul6LQaRbVXjP6iRTirs=; b=XQwEujfqC0AcayKnvv7DpGt04l
        9S7EkC0IAKEM3GOleiakbuaa7XSseNVr7EWtF9QsJWioT0ocvzeVF5SGh7cZg06LXQiBfAVB6D0Mb
        8LFX8U4AYFH9EIkpAsvpxFRORrw0mAn2gW6tTTZNsZgDS33LZyIGUAh/utDBYBYJRWERrgJhUsW5w
        P7KD+yivkqKgYyRAsHb89HpsDqeIbCTVnngN/T/mLUjMyhfK9PYKENqWvrOD9qZHk/W8gx0sehWqE
        0MLgrlVq1JSEsRUlXLGoRYbZnMKXKvxWO0BFGBQkcQklQMmCve8PEf/djbNKodc5XGNR+S1UcQf3Z
        E8xnC49w==;
Received: from [2601:1c0:6280:3f0::a6b3]
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oP9GM-00CHUE-8S; Fri, 19 Aug 2022 21:10:42 +0000
Message-ID: <0bea8b2c-3345-e475-01f7-fd9c44096244@infradead.org>
Date:   Fri, 19 Aug 2022 14:10:38 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2] KVM: s390: pci: Hook to access KVM lowlevel from VFIO
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, mjrosato@linux.ibm.com
Cc:     linux-kernel@vger.kernel.org, lkp@intel.com,
        borntraeger@linux.ibm.com, farman@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org, gor@linux.ibm.com,
        hca@linux.ibm.com, schnelle@linux.ibm.com, frankja@linux.ibm.com,
        alex.williamson@redhat.com, cohuck@redhat.com
References: <20220819122945.9309-1-pmorel@linux.ibm.com>
From:   Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20220819122945.9309-1-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/19/22 05:29, Pierre Morel wrote:
> We have a cross dependency between KVM and VFIO when using
> s390 vfio_pci_zdev extensions for PCI passthrough
> To be able to keep both subsystem modular we add a registering
> hook inside the S390 core code.
> 
> This fixes a build problem when VFIO is built-in and KVM is built
> as a module.
> 
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Reported-by: kernel test robot <lkp@intel.com>
> Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
> Reviewed-by: Niklas Schnelle <schnelle@linux.ibm.com>
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> Fixes: 09340b2fca007 ("KVM: s390: pci: add routines to start/stop interpretive execution")
> Cc: <stable@vger.kernel.org>

Acked-by: Randy Dunlap <rdunlap@infradead.org> # build-tested

Thanks.

> ---
>  arch/s390/include/asm/kvm_host.h | 17 ++++++-----------
>  arch/s390/kvm/pci.c              | 12 ++++++++----
>  arch/s390/pci/Makefile           |  2 +-
>  arch/s390/pci/pci_kvm_hook.c     | 11 +++++++++++
>  drivers/vfio/pci/vfio_pci_zdev.c |  8 ++++++--
>  5 files changed, 32 insertions(+), 18 deletions(-)
>  create mode 100644 arch/s390/pci/pci_kvm_hook.c
> 
> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
> index f39092e0ceaa..b1e98a9ed152 100644
> --- a/arch/s390/include/asm/kvm_host.h
> +++ b/arch/s390/include/asm/kvm_host.h
> @@ -1038,16 +1038,11 @@ static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
>  #define __KVM_HAVE_ARCH_VM_FREE
>  void kvm_arch_free_vm(struct kvm *kvm);
>  
> -#ifdef CONFIG_VFIO_PCI_ZDEV_KVM
> -int kvm_s390_pci_register_kvm(struct zpci_dev *zdev, struct kvm *kvm);
> -void kvm_s390_pci_unregister_kvm(struct zpci_dev *zdev);
> -#else
> -static inline int kvm_s390_pci_register_kvm(struct zpci_dev *dev,
> -					    struct kvm *kvm)
> -{
> -	return -EPERM;
> -}
> -static inline void kvm_s390_pci_unregister_kvm(struct zpci_dev *dev) {}
> -#endif
> +struct zpci_kvm_hook {
> +	int (*kvm_register)(void *opaque, struct kvm *kvm);
> +	void (*kvm_unregister)(void *opaque);
> +};
> +
> +extern struct zpci_kvm_hook zpci_kvm_hook;
>  
>  #endif
> diff --git a/arch/s390/kvm/pci.c b/arch/s390/kvm/pci.c
> index 4946fb7757d6..bb8c335d17b9 100644
> --- a/arch/s390/kvm/pci.c
> +++ b/arch/s390/kvm/pci.c
> @@ -431,8 +431,9 @@ static void kvm_s390_pci_dev_release(struct zpci_dev *zdev)
>   * available, enable them and let userspace indicate whether or not they will
>   * be used (specify SHM bit to disable).
>   */
> -int kvm_s390_pci_register_kvm(struct zpci_dev *zdev, struct kvm *kvm)
> +static int kvm_s390_pci_register_kvm(void *opaque, struct kvm *kvm)
>  {
> +	struct zpci_dev *zdev = opaque;
>  	int rc;
>  
>  	if (!zdev)
> @@ -510,10 +511,10 @@ int kvm_s390_pci_register_kvm(struct zpci_dev *zdev, struct kvm *kvm)
>  	kvm_put_kvm(kvm);
>  	return rc;
>  }
> -EXPORT_SYMBOL_GPL(kvm_s390_pci_register_kvm);
>  
> -void kvm_s390_pci_unregister_kvm(struct zpci_dev *zdev)
> +static void kvm_s390_pci_unregister_kvm(void *opaque)
>  {
> +	struct zpci_dev *zdev = opaque;
>  	struct kvm *kvm;
>  
>  	if (!zdev)
> @@ -566,7 +567,6 @@ void kvm_s390_pci_unregister_kvm(struct zpci_dev *zdev)
>  
>  	kvm_put_kvm(kvm);
>  }
> -EXPORT_SYMBOL_GPL(kvm_s390_pci_unregister_kvm);
>  
>  void kvm_s390_pci_init_list(struct kvm *kvm)
>  {
> @@ -678,6 +678,8 @@ int kvm_s390_pci_init(void)
>  
>  	spin_lock_init(&aift->gait_lock);
>  	mutex_init(&aift->aift_lock);
> +	zpci_kvm_hook.kvm_register = kvm_s390_pci_register_kvm;
> +	zpci_kvm_hook.kvm_unregister = kvm_s390_pci_unregister_kvm;
>  
>  	return 0;
>  }
> @@ -685,6 +687,8 @@ int kvm_s390_pci_init(void)
>  void kvm_s390_pci_exit(void)
>  {
>  	mutex_destroy(&aift->aift_lock);
> +	zpci_kvm_hook.kvm_register = NULL;
> +	zpci_kvm_hook.kvm_unregister = NULL;
>  
>  	kfree(aift);
>  }
> diff --git a/arch/s390/pci/Makefile b/arch/s390/pci/Makefile
> index bf557a1b789c..5ae31ca9dd44 100644
> --- a/arch/s390/pci/Makefile
> +++ b/arch/s390/pci/Makefile
> @@ -5,5 +5,5 @@
>  
>  obj-$(CONFIG_PCI)	+= pci.o pci_irq.o pci_dma.o pci_clp.o pci_sysfs.o \
>  			   pci_event.o pci_debug.o pci_insn.o pci_mmio.o \
> -			   pci_bus.o
> +			   pci_bus.o pci_kvm_hook.o
>  obj-$(CONFIG_PCI_IOV)	+= pci_iov.o
> diff --git a/arch/s390/pci/pci_kvm_hook.c b/arch/s390/pci/pci_kvm_hook.c
> new file mode 100644
> index 000000000000..ff34baf50a3e
> --- /dev/null
> +++ b/arch/s390/pci/pci_kvm_hook.c
> @@ -0,0 +1,11 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * VFIO ZPCI devices support
> + *
> + * Copyright (C) IBM Corp. 2022.  All rights reserved.
> + *	Author(s): Pierre Morel <pmorel@linux.ibm.com>
> + */
> +#include <linux/kvm_host.h>
> +
> +struct zpci_kvm_hook zpci_kvm_hook;
> +EXPORT_SYMBOL_GPL(zpci_kvm_hook);
> diff --git a/drivers/vfio/pci/vfio_pci_zdev.c b/drivers/vfio/pci/vfio_pci_zdev.c
> index e163aa9f6144..0cbdcd14f1c8 100644
> --- a/drivers/vfio/pci/vfio_pci_zdev.c
> +++ b/drivers/vfio/pci/vfio_pci_zdev.c
> @@ -151,7 +151,10 @@ int vfio_pci_zdev_open_device(struct vfio_pci_core_device *vdev)
>  	if (!vdev->vdev.kvm)
>  		return 0;
>  
> -	return kvm_s390_pci_register_kvm(zdev, vdev->vdev.kvm);
> +	if (zpci_kvm_hook.kvm_register)
> +		return zpci_kvm_hook.kvm_register(zdev, vdev->vdev.kvm);
> +
> +	return -ENOENT;
>  }
>  
>  void vfio_pci_zdev_close_device(struct vfio_pci_core_device *vdev)
> @@ -161,5 +164,6 @@ void vfio_pci_zdev_close_device(struct vfio_pci_core_device *vdev)
>  	if (!zdev || !vdev->vdev.kvm)
>  		return;
>  
> -	kvm_s390_pci_unregister_kvm(zdev);
> +	if (zpci_kvm_hook.kvm_unregister)
> +		zpci_kvm_hook.kvm_unregister(zdev);
>  }

-- 
~Randy
