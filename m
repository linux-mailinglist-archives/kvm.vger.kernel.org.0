Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 633254E2C7A
	for <lists+kvm@lfdr.de>; Mon, 21 Mar 2022 16:41:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350399AbiCUPls (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Mar 2022 11:41:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350396AbiCUPlr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Mar 2022 11:41:47 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8774B5BD2F
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 08:40:21 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 403B71042;
        Mon, 21 Mar 2022 08:40:21 -0700 (PDT)
Received: from [10.1.32.145] (e121487-lin.cambridge.arm.com [10.1.32.145])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 53F973F73D;
        Mon, 21 Mar 2022 08:40:20 -0700 (PDT)
Subject: Re: [kvmtool PATCH 2/2] aarch64: Add support for MTE
To:     Alexandru Elisei <alexandru.elisei@arm.com>, will@kernel.org,
        kvm@vger.kernel.org, julien.thierry.kdev@gmail.com,
        linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com,
        steven.price@arm.com
References: <20220321152820.246700-1-alexandru.elisei@arm.com>
 <20220321152820.246700-3-alexandru.elisei@arm.com>
From:   Vladimir Murzin <vladimir.murzin@arm.com>
Message-ID: <3cf3b621-5a07-5c06-cb9f-f9c776b6717d@arm.com>
Date:   Mon, 21 Mar 2022 15:40:18 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20220321152820.246700-3-alexandru.elisei@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alexandru,

On 3/21/22 3:28 PM, Alexandru Elisei wrote:
> MTE has been supported in Linux since commit 673638f434ee ("KVM: arm64:
> Expose KVM_ARM_CAP_MTE"), add support for it in kvmtool.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  arm/aarch32/include/kvm/kvm-arch.h        |  3 +++
>  arm/aarch64/include/kvm/kvm-arch.h        |  1 +
>  arm/aarch64/include/kvm/kvm-config-arch.h |  2 ++
>  arm/aarch64/kvm.c                         | 13 +++++++++++++
>  arm/include/arm-common/kvm-config-arch.h  |  1 +
>  arm/kvm.c                                 |  3 +++
>  6 files changed, 23 insertions(+)
> 
> diff --git a/arm/aarch32/include/kvm/kvm-arch.h b/arm/aarch32/include/kvm/kvm-arch.h
> index bee2fc255a82..5616b27e257e 100644
> --- a/arm/aarch32/include/kvm/kvm-arch.h
> +++ b/arm/aarch32/include/kvm/kvm-arch.h
> @@ -5,6 +5,9 @@
>  
>  #define kvm__arch_get_kern_offset(...)	0x8000
>  
> +struct kvm;
> +static inline void kvm__arch_enable_mte(struct kvm *kvm) {}
> +
>  #define ARM_MAX_MEMORY(...)	ARM_LOMAP_MAX_MEMORY
>  
>  #define MAX_PAGE_SIZE	SZ_4K
> diff --git a/arm/aarch64/include/kvm/kvm-arch.h b/arm/aarch64/include/kvm/kvm-arch.h
> index 5e5ee41211ed..9124f6919d0f 100644
> --- a/arm/aarch64/include/kvm/kvm-arch.h
> +++ b/arm/aarch64/include/kvm/kvm-arch.h
> @@ -6,6 +6,7 @@
>  struct kvm;
>  unsigned long long kvm__arch_get_kern_offset(struct kvm *kvm, int fd);
>  int kvm__arch_get_ipa_limit(struct kvm *kvm);
> +void kvm__arch_enable_mte(struct kvm *kvm);
>  
>  #define ARM_MAX_MEMORY(kvm)	({					\
>  	u64 max_ram;							\
> diff --git a/arm/aarch64/include/kvm/kvm-config-arch.h b/arm/aarch64/include/kvm/kvm-config-arch.h
> index 04be43dfa9b2..11250365d8d5 100644
> --- a/arm/aarch64/include/kvm/kvm-config-arch.h
> +++ b/arm/aarch64/include/kvm/kvm-config-arch.h
> @@ -6,6 +6,8 @@
>  			"Run AArch32 guest"),				\
>  	OPT_BOOLEAN('\0', "pmu", &(cfg)->has_pmuv3,			\
>  			"Create PMUv3 device"),				\
> +	OPT_BOOLEAN('\0', "mte", &(cfg)->has_mte,			\
> +			"Enable memory tagging extension"),		\
>  	OPT_U64('\0', "kaslr-seed", &(cfg)->kaslr_seed,			\
>  			"Specify random seed for Kernel Address Space "	\
>  			"Layout Randomization (KASLR)"),
> diff --git a/arm/aarch64/kvm.c b/arm/aarch64/kvm.c
> index 56a0aedc263d..46548f8ee96e 100644
> --- a/arm/aarch64/kvm.c
> +++ b/arm/aarch64/kvm.c
> @@ -81,3 +81,16 @@ int kvm__get_vm_type(struct kvm *kvm)
>  
>  	return KVM_VM_TYPE_ARM_IPA_SIZE(ipa_bits);
>  }
> +
> +void kvm__arch_enable_mte(struct kvm *kvm)
> +{
> +	struct kvm_enable_cap cap = {
> +		.cap = KVM_CAP_ARM_MTE,
> +	};
> +
> +	if (!kvm__supports_extension(kvm, KVM_CAP_ARM_MTE))
> +		die("MTE capability is not supported");
> +
> +	if (ioctl(kvm->vm_fd, KVM_ENABLE_CAP, &cap))
> +		die_perror("KVM_ENABLE_CAP(KVM_CAP_ARM_MTE)");
> +}
> diff --git a/arm/include/arm-common/kvm-config-arch.h b/arm/include/arm-common/kvm-config-arch.h
> index 5734c46ab9e6..16e8d500a71b 100644
> --- a/arm/include/arm-common/kvm-config-arch.h
> +++ b/arm/include/arm-common/kvm-config-arch.h
> @@ -9,6 +9,7 @@ struct kvm_config_arch {
>  	bool		virtio_trans_pci;
>  	bool		aarch32_guest;
>  	bool		has_pmuv3;
> +	bool		has_mte;
>  	u64		kaslr_seed;
>  	enum irqchip_type irqchip;
>  	u64		fw_addr;
> diff --git a/arm/kvm.c b/arm/kvm.c
> index 80d233f13d0b..f2db93953778 100644
> --- a/arm/kvm.c
> +++ b/arm/kvm.c
> @@ -86,6 +86,9 @@ void kvm__arch_init(struct kvm *kvm, const char *hugetlbfs_path, u64 ram_size)
>  	/* Create the virtual GIC. */
>  	if (gic__create(kvm, kvm->cfg.arch.irqchip))
>  		die("Failed to create virtual GIC");
> +
> +	if (kvm->cfg.arch.has_mte)
> +		kvm__arch_enable_mte(kvm);
>  }

Can we enable it unconditionally if KVM_CAP_ARM_MTE is supported like we do for
PAC and SVE?

Cheers
Vladimir
