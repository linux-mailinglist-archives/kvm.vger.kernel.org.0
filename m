Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C2B74E67AA
	for <lists+kvm@lfdr.de>; Thu, 24 Mar 2022 18:21:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352198AbiCXRXK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Mar 2022 13:23:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243445AbiCXRXI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Mar 2022 13:23:08 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9ADBA986F6
        for <kvm@vger.kernel.org>; Thu, 24 Mar 2022 10:21:36 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 577CA1515;
        Thu, 24 Mar 2022 10:21:36 -0700 (PDT)
Received: from [10.1.39.159] (e121487-lin.cambridge.arm.com [10.1.39.159])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6CE0F3F73B;
        Thu, 24 Mar 2022 10:21:35 -0700 (PDT)
Message-ID: <089fe68e-4679-4bdb-6b13-4e51c08c032a@arm.com>
Date:   Thu, 24 Mar 2022 17:21:34 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [kvmtool PATCH v2 2/2] aarch64: Add support for MTE
Content-Language: en-US
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        catalin.marinas@arm.com, steven.price@arm.com
References: <20220324113942.24217-1-alexandru.elisei@arm.com>
 <20220324113942.24217-3-alexandru.elisei@arm.com>
 <cd1c3fef-e508-b003-9bc0-1166c931967d@arm.com>
 <Yjylw3jpc0Sy5+On@monolith.localdoman>
From:   Vladimir Murzin <vladimir.murzin@arm.com>
In-Reply-To: <Yjylw3jpc0Sy5+On@monolith.localdoman>
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

On 3/24/22 5:09 PM, Alexandru Elisei wrote:
> Hi,
> 
> On Thu, Mar 24, 2022 at 02:19:58PM +0000, Vladimir Murzin wrote:
>> Hi Alexandru,
>>
>> On 3/24/22 11:39 AM, Alexandru Elisei wrote:
>>> MTE has been supported in Linux since commit 673638f434ee ("KVM: arm64:
>>> Expose KVM_ARM_CAP_MTE"), add support for it in kvmtool. MTE is enabled by
>>> default.
>>>
>>> Enabling the MTE capability incurs a cost, both in time (for each
>>> translation fault the tags need to be cleared), and in space (the tags need
>>> to be saved when a physical page is swapped out). This overhead is expected
>>> to be negligible for most users, but for those cases where they matter
>>> (like performance benchmarks), a --disable-mte option has been added.
>>>
>>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
>>> ---
>>>    arm/aarch32/include/kvm/kvm-arch.h        |  3 +++
>>>    arm/aarch64/include/kvm/kvm-arch.h        |  1 +
>>>    arm/aarch64/include/kvm/kvm-config-arch.h |  2 ++
>>>    arm/aarch64/kvm.c                         | 23 +++++++++++++++++++++++
>>>    arm/include/arm-common/kvm-config-arch.h  |  1 +
>>>    arm/kvm.c                                 |  2 ++
>>>    6 files changed, 32 insertions(+)
>>>
>>> diff --git a/arm/aarch32/include/kvm/kvm-arch.h b/arm/aarch32/include/kvm/kvm-arch.h
>>> index bee2fc255a82..5616b27e257e 100644
>>> --- a/arm/aarch32/include/kvm/kvm-arch.h
>>> +++ b/arm/aarch32/include/kvm/kvm-arch.h
>>> @@ -5,6 +5,9 @@
>>>    #define kvm__arch_get_kern_offset(...)	0x8000
>>> +struct kvm;
>>> +static inline void kvm__arch_enable_mte(struct kvm *kvm) {}
>>> +
>>>    #define ARM_MAX_MEMORY(...)	ARM_LOMAP_MAX_MEMORY
>>>    #define MAX_PAGE_SIZE	SZ_4K
>>> diff --git a/arm/aarch64/include/kvm/kvm-arch.h b/arm/aarch64/include/kvm/kvm-arch.h
>>> index 5e5ee41211ed..9124f6919d0f 100644
>>> --- a/arm/aarch64/include/kvm/kvm-arch.h
>>> +++ b/arm/aarch64/include/kvm/kvm-arch.h
>>> @@ -6,6 +6,7 @@
>>>    struct kvm;
>>>    unsigned long long kvm__arch_get_kern_offset(struct kvm *kvm, int fd);
>>>    int kvm__arch_get_ipa_limit(struct kvm *kvm);
>>> +void kvm__arch_enable_mte(struct kvm *kvm);
>>>    #define ARM_MAX_MEMORY(kvm)	({					\
>>>    	u64 max_ram;							\
>>> diff --git a/arm/aarch64/include/kvm/kvm-config-arch.h b/arm/aarch64/include/kvm/kvm-config-arch.h
>>> index 04be43dfa9b2..df4a15ff00a7 100644
>>> --- a/arm/aarch64/include/kvm/kvm-config-arch.h
>>> +++ b/arm/aarch64/include/kvm/kvm-config-arch.h
>>> @@ -6,6 +6,8 @@
>>>    			"Run AArch32 guest"),				\
>>>    	OPT_BOOLEAN('\0', "pmu", &(cfg)->has_pmuv3,			\
>>>    			"Create PMUv3 device"),				\
>>> +	OPT_BOOLEAN('\0', "disable-mte", &(cfg)->mte_disabled,		\
>>> +			"Disable Memory Tagging Extension capability"),	\
>>>    	OPT_U64('\0', "kaslr-seed", &(cfg)->kaslr_seed,			\
>>>    			"Specify random seed for Kernel Address Space "	\
>>>    			"Layout Randomization (KASLR)"),
>>> diff --git a/arm/aarch64/kvm.c b/arm/aarch64/kvm.c
>>> index 56a0aedc263d..1035171a00f0 100644
>>> --- a/arm/aarch64/kvm.c
>>> +++ b/arm/aarch64/kvm.c
>>> @@ -81,3 +81,26 @@ int kvm__get_vm_type(struct kvm *kvm)
>>>    	return KVM_VM_TYPE_ARM_IPA_SIZE(ipa_bits);
>>>    }
>>> +
>>> +void kvm__arch_enable_mte(struct kvm *kvm)
>>> +{
>>> +	struct kvm_enable_cap cap = {
>>> +		.cap = KVM_CAP_ARM_MTE,
>>> +	};
>>> +
>>> +	if (kvm->cfg.arch.mte_disabled) {
>>> +		pr_debug("MTE capability disabled by user");
>>> +		return;
>>> +	}
>>
>> Nitpick:  I'd move that bellow capability check, so it'd appear only in
>> setups which support MTE
> 
> I have no problem moving it, but I'm curious why you think it would be
> useful. If the user disables MTE from kvmtool's command line doesn't that
> mean that they aren't interested if the host supports it? It looks a bit
> unexpected to me for kvmtool to check if the host supports MTE when the
> user doesn't want to enable the cap.

It is probably matters of taste (so nitpick). I'm thinking if somebody has
scripts with --disable-mte which runs on zoo of hardware - we would output
"MTE capability disabled by user" even on those which do no support MTE at
all... "MTE capability not present", IMO, would look nicer on those machines

Anyway, it is not a show stopper ;)

Cheers
Vladimir
