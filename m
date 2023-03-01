Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F1BB6A6BF3
	for <lists+kvm@lfdr.de>; Wed,  1 Mar 2023 12:55:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbjCALzj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Mar 2023 06:55:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbjCALzh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Mar 2023 06:55:37 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 77FAC3C78D;
        Wed,  1 Mar 2023 03:55:32 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5B3152F4;
        Wed,  1 Mar 2023 03:56:15 -0800 (PST)
Received: from [10.57.16.41] (unknown [10.57.16.41])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E39BE3F587;
        Wed,  1 Mar 2023 03:55:28 -0800 (PST)
Message-ID: <6a2c0db1-a8c8-1c21-5b14-e12067ad3ead@arm.com>
Date:   Wed, 1 Mar 2023 11:55:25 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [RFC PATCH 07/28] arm64: kvm: Allow passing machine type in KVM
 creation
Content-Language: en-GB
To:     Zhi Wang <zhi.wang.linux@gmail.com>
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
References: <20230127112248.136810-1-suzuki.poulose@arm.com>
 <20230127112932.38045-1-steven.price@arm.com>
 <20230127112932.38045-8-steven.price@arm.com>
 <20230213183530.00006d35@gmail.com>
From:   Steven Price <steven.price@arm.com>
In-Reply-To: <20230213183530.00006d35@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/02/2023 16:35, Zhi Wang wrote:
> On Fri, 27 Jan 2023 11:29:11 +0000
> Steven Price <steven.price@arm.com> wrote:
> 
>> Previously machine type was used purely for specifying the physical
>> address size of the guest. Reserve the higher bits to specify an ARM
>> specific machine type and declare a new type 'KVM_VM_TYPE_ARM_REALM'
>> used to create a realm guest.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>>  arch/arm64/kvm/arm.c     | 13 +++++++++++++
>>  arch/arm64/kvm/mmu.c     |  3 ---
>>  arch/arm64/kvm/reset.c   |  3 ---
>>  include/uapi/linux/kvm.h | 19 +++++++++++++++----
>>  4 files changed, 28 insertions(+), 10 deletions(-)
>>
>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>> index 50f54a63732a..badd775547b8 100644
>> --- a/arch/arm64/kvm/arm.c
>> +++ b/arch/arm64/kvm/arm.c
>> @@ -147,6 +147,19 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>>  {
>>  	int ret;
>>  
>> +	if (type & ~(KVM_VM_TYPE_ARM_MASK | KVM_VM_TYPE_ARM_IPA_SIZE_MASK))
>> +		return -EINVAL;
>> +
>> +	switch (type & KVM_VM_TYPE_ARM_MASK) {
>> +	case KVM_VM_TYPE_ARM_NORMAL:
>> +		break;
>> +	case KVM_VM_TYPE_ARM_REALM:
>> +		kvm->arch.is_realm = true;
> 
> It is better to let this call fail when !kvm_rme_is_available? It is
> strange to be able to create a VM with REALM type in a system doesn't
> support RME.

Good point - I'll add a check here.

Thanks,

Steve

>> +		break;
>> +	default:
>> +		return -EINVAL;
>> +	}
>> +
>>  	ret = kvm_share_hyp(kvm, kvm + 1);
>>  	if (ret)
>>  		return ret;
>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>> index d0f707767d05..22c00274884a 100644
>> --- a/arch/arm64/kvm/mmu.c
>> +++ b/arch/arm64/kvm/mmu.c
>> @@ -709,9 +709,6 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
>>  	u64 mmfr0, mmfr1;
>>  	u32 phys_shift;
>>  
>> -	if (type & ~KVM_VM_TYPE_ARM_IPA_SIZE_MASK)
>> -		return -EINVAL;
>> -
>>  	phys_shift = KVM_VM_TYPE_ARM_IPA_SIZE(type);
>>  	if (is_protected_kvm_enabled()) {
>>  		phys_shift = kvm_ipa_limit;
>> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
>> index c165df174737..9e71d69e051f 100644
>> --- a/arch/arm64/kvm/reset.c
>> +++ b/arch/arm64/kvm/reset.c
>> @@ -405,9 +405,6 @@ int kvm_arm_setup_stage2(struct kvm *kvm, unsigned long type)
>>  	if (kvm_is_realm(kvm))
>>  		ipa_limit = kvm_realm_ipa_limit();
>>  
>> -	if (type & ~KVM_VM_TYPE_ARM_IPA_SIZE_MASK)
>> -		return -EINVAL;
>> -
>>  	phys_shift = KVM_VM_TYPE_ARM_IPA_SIZE(type);
>>  	if (phys_shift) {
>>  		if (phys_shift > ipa_limit ||
>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>> index fec1909e8b73..bcfc4d58dc19 100644
>> --- a/include/uapi/linux/kvm.h
>> +++ b/include/uapi/linux/kvm.h
>> @@ -898,14 +898,25 @@ struct kvm_ppc_resize_hpt {
>>  #define KVM_S390_SIE_PAGE_OFFSET 1
>>  
>>  /*
>> - * On arm64, machine type can be used to request the physical
>> - * address size for the VM. Bits[7-0] are reserved for the guest
>> - * PA size shift (i.e, log2(PA_Size)). For backward compatibility,
>> - * value 0 implies the default IPA size, 40bits.
>> + * On arm64, machine type can be used to request both the machine type and
>> + * the physical address size for the VM.
>> + *
>> + * Bits[11-8] are reserved for the ARM specific machine type.
>> + *
>> + * Bits[7-0] are reserved for the guest PA size shift (i.e, log2(PA_Size)).
>> + * For backward compatibility, value 0 implies the default IPA size, 40bits.
>>   */
>> +#define KVM_VM_TYPE_ARM_SHIFT		8
>> +#define KVM_VM_TYPE_ARM_MASK		(0xfULL << KVM_VM_TYPE_ARM_SHIFT)
>> +#define KVM_VM_TYPE_ARM(_type)		\
>> +	(((_type) << KVM_VM_TYPE_ARM_SHIFT) & KVM_VM_TYPE_ARM_MASK)
>> +#define KVM_VM_TYPE_ARM_NORMAL		KVM_VM_TYPE_ARM(0)
>> +#define KVM_VM_TYPE_ARM_REALM		KVM_VM_TYPE_ARM(1)
>> +
>>  #define KVM_VM_TYPE_ARM_IPA_SIZE_MASK	0xffULL
>>  #define KVM_VM_TYPE_ARM_IPA_SIZE(x)		\
>>  	((x) & KVM_VM_TYPE_ARM_IPA_SIZE_MASK)
>> +
>>  /*
>>   * ioctls for /dev/kvm fds:
>>   */
> 

