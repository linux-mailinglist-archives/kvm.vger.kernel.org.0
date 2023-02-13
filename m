Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A0CD694D01
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 17:35:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230367AbjBMQfl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 11:35:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbjBMQfi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 11:35:38 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52909D4;
        Mon, 13 Feb 2023 08:35:37 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id j17so4637733ioa.9;
        Mon, 13 Feb 2023 08:35:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1676306136;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2rlnKFgrRUm8Uq6241EeorSyjCYr9c9HFlGFvXdOyL8=;
        b=pwEvTbpuPD909QsbFce8wQK8GLxAqY/YRJ8l5yTI2LF1etbDxBJyppNy1pw3sccpMT
         V/hOgCwIYM24FniVQ3CFzjUAQczUHEZS/y/O/cG6gtnPs5aSOCNiUnpISn6jHLMt3av8
         UACyMYfr25ionq5s0vVIHsFkKSb/5mxhx/FDrQClY4po/ISPFHwrr+7VpWuXkDmRfg8E
         Kl+bVUQ9A5mxRhQveagrtS9J5Xexml9HYe3uEVQFQUUos0sJFLWTtBUa6H4qkml0YroF
         prnTaAGzt9AKzQcMQbv++KTD7xkPmuNIK5G/pKJIhAlOPXRSY5Rgj9YAL+D9MCyNHQ1o
         WvPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676306136;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2rlnKFgrRUm8Uq6241EeorSyjCYr9c9HFlGFvXdOyL8=;
        b=obya8nGwyOOvksygmpu5Zltlwf9g+swiSLyUM2u9IxU5nX8Fb5VLtZpg2nV/jAuElf
         sXoj81xaFAbORuHZ2ViMCgoxthLUjsi4ThOn2fuLkddjlKPC16GovscBQujQ3hdSEav0
         MnTlMp8IffgUKLAQBsr+bZTdk+VMwHlyd9Gp7Y0YgJQLQmC7b18Dzd7i4+pw9IIAeGZM
         kal+qPJ3b/OSbwe1w1VLkHrZ5+uOQY2oLKksm7tQkNIpkEbYTCbIbL81QOUyaxMnrsDt
         nC7JfCuEoPk5SkgHE1qH5YoIwpxbOBW3EPBCsY42ewSeSvQ+kL7B+P49Xn7hzmK7clSR
         CpDw==
X-Gm-Message-State: AO0yUKXWD69YYM+OuQcZU2cNcc+CnhBYs2LCFqt/EGCF7oy8DYallW6C
        faqTxh2oBh4U6KqZEyJ3NIM=
X-Google-Smtp-Source: AK7set8mRhRxVIVEf9OHVXJ6AT7dvTcgh2wGFkhbQuyPdTKuJ72bGM96bYuK7fsFHHVXsPTbWCfkQA==
X-Received: by 2002:a6b:7d4c:0:b0:715:f031:a7f5 with SMTP id d12-20020a6b7d4c000000b00715f031a7f5mr16953693ioq.1.1676306136640;
        Mon, 13 Feb 2023 08:35:36 -0800 (PST)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id g5-20020a02c545000000b0038a6ae38ceasm4206262jaj.26.2023.02.13.08.35.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Feb 2023 08:35:36 -0800 (PST)
Date:   Mon, 13 Feb 2023 18:35:30 +0200
From:   Zhi Wang <zhi.wang.linux@gmail.com>
To:     Steven Price <steven.price@arm.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Joey Gouly <joey.gouly@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev
Subject: Re: [RFC PATCH 07/28] arm64: kvm: Allow passing machine type in KVM
 creation
Message-ID: <20230213183530.00006d35@gmail.com>
In-Reply-To: <20230127112932.38045-8-steven.price@arm.com>
References: <20230127112248.136810-1-suzuki.poulose@arm.com>
        <20230127112932.38045-1-steven.price@arm.com>
        <20230127112932.38045-8-steven.price@arm.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 27 Jan 2023 11:29:11 +0000
Steven Price <steven.price@arm.com> wrote:

> Previously machine type was used purely for specifying the physical
> address size of the guest. Reserve the higher bits to specify an ARM
> specific machine type and declare a new type 'KVM_VM_TYPE_ARM_REALM'
> used to create a realm guest.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>  arch/arm64/kvm/arm.c     | 13 +++++++++++++
>  arch/arm64/kvm/mmu.c     |  3 ---
>  arch/arm64/kvm/reset.c   |  3 ---
>  include/uapi/linux/kvm.h | 19 +++++++++++++++----
>  4 files changed, 28 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 50f54a63732a..badd775547b8 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -147,6 +147,19 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>  {
>  	int ret;
>  
> +	if (type & ~(KVM_VM_TYPE_ARM_MASK | KVM_VM_TYPE_ARM_IPA_SIZE_MASK))
> +		return -EINVAL;
> +
> +	switch (type & KVM_VM_TYPE_ARM_MASK) {
> +	case KVM_VM_TYPE_ARM_NORMAL:
> +		break;
> +	case KVM_VM_TYPE_ARM_REALM:
> +		kvm->arch.is_realm = true;

It is better to let this call fail when !kvm_rme_is_available? It is
strange to be able to create a VM with REALM type in a system doesn't
support RME.

> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
>  	ret = kvm_share_hyp(kvm, kvm + 1);
>  	if (ret)
>  		return ret;
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index d0f707767d05..22c00274884a 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -709,9 +709,6 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
>  	u64 mmfr0, mmfr1;
>  	u32 phys_shift;
>  
> -	if (type & ~KVM_VM_TYPE_ARM_IPA_SIZE_MASK)
> -		return -EINVAL;
> -
>  	phys_shift = KVM_VM_TYPE_ARM_IPA_SIZE(type);
>  	if (is_protected_kvm_enabled()) {
>  		phys_shift = kvm_ipa_limit;
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index c165df174737..9e71d69e051f 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -405,9 +405,6 @@ int kvm_arm_setup_stage2(struct kvm *kvm, unsigned long type)
>  	if (kvm_is_realm(kvm))
>  		ipa_limit = kvm_realm_ipa_limit();
>  
> -	if (type & ~KVM_VM_TYPE_ARM_IPA_SIZE_MASK)
> -		return -EINVAL;
> -
>  	phys_shift = KVM_VM_TYPE_ARM_IPA_SIZE(type);
>  	if (phys_shift) {
>  		if (phys_shift > ipa_limit ||
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index fec1909e8b73..bcfc4d58dc19 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -898,14 +898,25 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_S390_SIE_PAGE_OFFSET 1
>  
>  /*
> - * On arm64, machine type can be used to request the physical
> - * address size for the VM. Bits[7-0] are reserved for the guest
> - * PA size shift (i.e, log2(PA_Size)). For backward compatibility,
> - * value 0 implies the default IPA size, 40bits.
> + * On arm64, machine type can be used to request both the machine type and
> + * the physical address size for the VM.
> + *
> + * Bits[11-8] are reserved for the ARM specific machine type.
> + *
> + * Bits[7-0] are reserved for the guest PA size shift (i.e, log2(PA_Size)).
> + * For backward compatibility, value 0 implies the default IPA size, 40bits.
>   */
> +#define KVM_VM_TYPE_ARM_SHIFT		8
> +#define KVM_VM_TYPE_ARM_MASK		(0xfULL << KVM_VM_TYPE_ARM_SHIFT)
> +#define KVM_VM_TYPE_ARM(_type)		\
> +	(((_type) << KVM_VM_TYPE_ARM_SHIFT) & KVM_VM_TYPE_ARM_MASK)
> +#define KVM_VM_TYPE_ARM_NORMAL		KVM_VM_TYPE_ARM(0)
> +#define KVM_VM_TYPE_ARM_REALM		KVM_VM_TYPE_ARM(1)
> +
>  #define KVM_VM_TYPE_ARM_IPA_SIZE_MASK	0xffULL
>  #define KVM_VM_TYPE_ARM_IPA_SIZE(x)		\
>  	((x) & KVM_VM_TYPE_ARM_IPA_SIZE_MASK)
> +
>  /*
>   * ioctls for /dev/kvm fds:
>   */

