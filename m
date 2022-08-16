Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 515935954DE
	for <lists+kvm@lfdr.de>; Tue, 16 Aug 2022 10:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232434AbiHPIVW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Aug 2022 04:21:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232793AbiHPIUh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Aug 2022 04:20:37 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E65A64A107;
        Mon, 15 Aug 2022 23:04:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
        Message-ID:Sender:Reply-To:Content-ID:Content-Description;
        bh=SVRLcL3c7t4xux2inMx+BQpiWgYVYAAoRoR2FuDT7Po=; b=FPLQsd26E6o6WLCt+bSUPdpcHx
        H9fzOawMmwXCUd6JIc6pq2/MNU1uf5NZ2Os9nxttup0lT0c4jxRMTQKFbNWofQ0IN0EnSWcJaszbl
        A8a7kl5zECeBVavX2dn/B1mow7kwwxRrg42YLrY7VF9sS2PP7tK1kUwLnzcWtzURl7WrQuAv79IFO
        H1EnwIKP7LTF6YGEZaOKj0g1ueoX8KZsKmaodtWIJuFzNkjkyg6tXxMmnVPk7UcMdVcJdsF4SgHJc
        RZD/IEmYkCXZPZTBt1e9BPJ2ArqPF1daq3tYalwzMuWQno/XcatUU/YXa1LwAlYi5ZnOkmFcuDGGe
        l0ygrUzQ==;
Received: from [2601:1c0:6280:3f0::a6b3]
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oNpgs-00D70J-NI; Tue, 16 Aug 2022 06:04:38 +0000
Message-ID: <5530ed1f-90ec-ce84-2348-80e484fa48cb@infradead.org>
Date:   Mon, 15 Aug 2022 23:04:35 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] vfio-pci/zdev: require KVM to be built-in
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, linux-kernel@vger.kernel.org
Cc:     kernel test robot <lkp@intel.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
References: <20220814215154.32112-1-rdunlap@infradead.org>
 <663c7595-1c18-043e-5f12-b0ce880b84bf@linux.ibm.com>
From:   Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <663c7595-1c18-043e-5f12-b0ce880b84bf@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi--

On 8/15/22 02:43, Pierre Morel wrote:
> Thank you Randy for this good catch.
> However forcing KVM to be include statically in the kernel when using VFIO_PCI extensions is not a good solution for us I think.
> 
> I suggest we better do something like:
> 
> ----
> 
> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
> index 6287a843e8bc..1733339cc4eb 100644
> --- a/arch/s390/include/asm/kvm_host.h
> +++ b/arch/s390/include/asm/kvm_host.h
> @@ -1038,7 +1038,7 @@ static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
>  #define __KVM_HAVE_ARCH_VM_FREE
>  void kvm_arch_free_vm(struct kvm *kvm);
> 
> -#ifdef CONFIG_VFIO_PCI_ZDEV_KVM
> +#if defined(CONFIG_VFIO_PCI_ZDEV_KVM) || defined(CONFIG_VFIO_PCI_ZDEV_KVM_MODULE)

This all looks good except for the line above.
It should be:

#if IS_ENABLED(CONFIG_VFIO_PCI_ZDEV_KVM)

Thanks.


>  int kvm_s390_pci_register_kvm(struct zpci_dev *zdev, struct kvm *kvm);
>  void kvm_s390_pci_unregister_kvm(struct zpci_dev *zdev);
>  #else
> diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
> index f9d0c908e738..bbc375b028ef 100644
> --- a/drivers/vfio/pci/Kconfig
> +++ b/drivers/vfio/pci/Kconfig
> @@ -45,9 +45,9 @@ config VFIO_PCI_IGD
>  endif
> 
>  config VFIO_PCI_ZDEV_KVM
> -       bool "VFIO PCI extensions for s390x KVM passthrough"
> +       def_tristate y
> +       prompt "VFIO PCI extensions for s390x KVM passthrough"
>         depends on S390 && KVM
> -       default y
>         help
>           Support s390x-specific extensions to enable support for enhancements
>           to KVM passthrough capabilities, such as interpretive execution of
> 
> ----
> 
> What do you think? It seems to me it solves the problem, what do you think?
> 
> Regards,
> Pierre


-- 
~Randy
