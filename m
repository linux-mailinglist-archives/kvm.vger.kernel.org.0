Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE0644E5058
	for <lists+kvm@lfdr.de>; Wed, 23 Mar 2022 11:31:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243543AbiCWKdN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Mar 2022 06:33:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243563AbiCWKcr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Mar 2022 06:32:47 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4EB606EB0A
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 03:31:18 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 14282D6E;
        Wed, 23 Mar 2022 03:31:18 -0700 (PDT)
Received: from [10.1.36.148] (e121487-lin.cambridge.arm.com [10.1.36.148])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C90D13F73B;
        Wed, 23 Mar 2022 03:31:16 -0700 (PDT)
Message-ID: <7e5ebae0-db08-ad87-0fa9-26da048a9b72@arm.com>
Date:   Wed, 23 Mar 2022 10:31:15 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [kvmtool PATCH 2/2] aarch64: Add support for MTE
Content-Language: en-US
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     will@kernel.org, kvm@vger.kernel.org,
        julien.thierry.kdev@gmail.com,
        linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com,
        steven.price@arm.com
References: <20220321152820.246700-1-alexandru.elisei@arm.com>
 <20220321152820.246700-3-alexandru.elisei@arm.com>
 <3cf3b621-5a07-5c06-cb9f-f9c776b6717d@arm.com>
 <Yjiw/mdfLyMW2gFh@monolith.localdoman>
From:   Vladimir Murzin <vladimir.murzin@arm.com>
In-Reply-To: <Yjiw/mdfLyMW2gFh@monolith.localdoman>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/21/22 5:08 PM, Alexandru Elisei wrote:
> Hi,
> 
> On Mon, Mar 21, 2022 at 03:40:18PM +0000, Vladimir Murzin wrote:
>> Hi Alexandru,
>>
>> On 3/21/22 3:28 PM, Alexandru Elisei wrote:
>>> MTE has been supported in Linux since commit 673638f434ee ("KVM: arm64:
>>> Expose KVM_ARM_CAP_MTE"), add support for it in kvmtool.
>>>
>>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
>>> ---
>>>   arm/aarch32/include/kvm/kvm-arch.h        |  3 +++
>>>   arm/aarch64/include/kvm/kvm-arch.h        |  1 +
>>>   arm/aarch64/include/kvm/kvm-config-arch.h |  2 ++
>>>   arm/aarch64/kvm.c                         | 13 +++++++++++++
>>>   arm/include/arm-common/kvm-config-arch.h  |  1 +
>>>   arm/kvm.c                                 |  3 +++
>>>   6 files changed, 23 insertions(+)
>>>
>>> diff --git a/arm/aarch32/include/kvm/kvm-arch.h b/arm/aarch32/include/kvm/kvm-arch.h
>>> index bee2fc255a82..5616b27e257e 100644
>>> --- a/arm/aarch32/include/kvm/kvm-arch.h
>>> +++ b/arm/aarch32/include/kvm/kvm-arch.h
>>> @@ -5,6 +5,9 @@
>>>   
>>>   #define kvm__arch_get_kern_offset(...)	0x8000
>>>   
>>> +struct kvm;
>>> +static inline void kvm__arch_enable_mte(struct kvm *kvm) {}
>>> +
>>>   #define ARM_MAX_MEMORY(...)	ARM_LOMAP_MAX_MEMORY
>>>   
>>>   #define MAX_PAGE_SIZE	SZ_4K
>>> diff --git a/arm/aarch64/include/kvm/kvm-arch.h b/arm/aarch64/include/kvm/kvm-arch.h
>>> index 5e5ee41211ed..9124f6919d0f 100644
>>> --- a/arm/aarch64/include/kvm/kvm-arch.h
>>> +++ b/arm/aarch64/include/kvm/kvm-arch.h
>>> @@ -6,6 +6,7 @@
>>>   struct kvm;
>>>   unsigned long long kvm__arch_get_kern_offset(struct kvm *kvm, int fd);
>>>   int kvm__arch_get_ipa_limit(struct kvm *kvm);
>>> +void kvm__arch_enable_mte(struct kvm *kvm);
>>>   
>>>   #define ARM_MAX_MEMORY(kvm)	({					\
>>>   	u64 max_ram;							\
>>> diff --git a/arm/aarch64/include/kvm/kvm-config-arch.h b/arm/aarch64/include/kvm/kvm-config-arch.h
>>> index 04be43dfa9b2..11250365d8d5 100644
>>> --- a/arm/aarch64/include/kvm/kvm-config-arch.h
>>> +++ b/arm/aarch64/include/kvm/kvm-config-arch.h
>>> @@ -6,6 +6,8 @@
>>>   			"Run AArch32 guest"),				\
>>>   	OPT_BOOLEAN('\0', "pmu", &(cfg)->has_pmuv3,			\
>>>   			"Create PMUv3 device"),				\
>>> +	OPT_BOOLEAN('\0', "mte", &(cfg)->has_mte,			\
>>> +			"Enable memory tagging extension"),		\
>>>   	OPT_U64('\0', "kaslr-seed", &(cfg)->kaslr_seed,			\
>>>   			"Specify random seed for Kernel Address Space "	\
>>>   			"Layout Randomization (KASLR)"),
>>> diff --git a/arm/aarch64/kvm.c b/arm/aarch64/kvm.c
>>> index 56a0aedc263d..46548f8ee96e 100644
>>> --- a/arm/aarch64/kvm.c
>>> +++ b/arm/aarch64/kvm.c
>>> @@ -81,3 +81,16 @@ int kvm__get_vm_type(struct kvm *kvm)
>>>   
>>>   	return KVM_VM_TYPE_ARM_IPA_SIZE(ipa_bits);
>>>   }
>>> +
>>> +void kvm__arch_enable_mte(struct kvm *kvm)
>>> +{
>>> +	struct kvm_enable_cap cap = {
>>> +		.cap = KVM_CAP_ARM_MTE,
>>> +	};
>>> +
>>> +	if (!kvm__supports_extension(kvm, KVM_CAP_ARM_MTE))
>>> +		die("MTE capability is not supported");
>>> +
>>> +	if (ioctl(kvm->vm_fd, KVM_ENABLE_CAP, &cap))
>>> +		die_perror("KVM_ENABLE_CAP(KVM_CAP_ARM_MTE)");
>>> +}
>>> diff --git a/arm/include/arm-common/kvm-config-arch.h b/arm/include/arm-common/kvm-config-arch.h
>>> index 5734c46ab9e6..16e8d500a71b 100644
>>> --- a/arm/include/arm-common/kvm-config-arch.h
>>> +++ b/arm/include/arm-common/kvm-config-arch.h
>>> @@ -9,6 +9,7 @@ struct kvm_config_arch {
>>>   	bool		virtio_trans_pci;
>>>   	bool		aarch32_guest;
>>>   	bool		has_pmuv3;
>>> +	bool		has_mte;
>>>   	u64		kaslr_seed;
>>>   	enum irqchip_type irqchip;
>>>   	u64		fw_addr;
>>> diff --git a/arm/kvm.c b/arm/kvm.c
>>> index 80d233f13d0b..f2db93953778 100644
>>> --- a/arm/kvm.c
>>> +++ b/arm/kvm.c
>>> @@ -86,6 +86,9 @@ void kvm__arch_init(struct kvm *kvm, const char *hugetlbfs_path, u64 ram_size)
>>>   	/* Create the virtual GIC. */
>>>   	if (gic__create(kvm, kvm->cfg.arch.irqchip))
>>>   		die("Failed to create virtual GIC");
>>> +
>>> +	if (kvm->cfg.arch.has_mte)
>>> +		kvm__arch_enable_mte(kvm);
>>>   }
>>
>> Can we enable it unconditionally if KVM_CAP_ARM_MTE is supported like we do for
>> PAC and SVE?
> 
> I thought about that, the reason I chose to enable it based a kvmtool
> command line option, instead of always being enabled if available, is
> because of the overhead of sanitising the MTE tags on each stage 2 data
> abort. Steven, am I overreacting and that overhead is negligible?
> 
> Also, as far as I know, PAC and SVE incur basically no overhead in KVM
> until the guest starts to use those features.
> 
> Do you have a specific reason for wanting MTE to always be enabled if
> available? I'm happy to be convinced to make MTE enabled by default, I
> don't have preference either way.

Well, automatically enabling if available would align with what we do 
for other features in kvmtool and Linux itself - we tend to default y 
for new features, even MTE, thus improving chances to get reports back 
early if something (even performance) goes wrong. Just my 2p.

Cheers
Vladimir

> 
> Thanks,
> Alex

