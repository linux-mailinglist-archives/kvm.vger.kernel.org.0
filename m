Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14A446A9910
	for <lists+kvm@lfdr.de>; Fri,  3 Mar 2023 15:05:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231281AbjCCOFu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Mar 2023 09:05:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231318AbjCCOFh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Mar 2023 09:05:37 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 47550618BE;
        Fri,  3 Mar 2023 06:05:23 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2CFB4143D;
        Fri,  3 Mar 2023 06:06:06 -0800 (PST)
Received: from [10.1.39.22] (e122027.cambridge.arm.com [10.1.39.22])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9B10E3F93E;
        Fri,  3 Mar 2023 06:05:15 -0800 (PST)
Message-ID: <4eca4c83-db1f-02fb-8401-39548abfadb7@arm.com>
Date:   Fri, 3 Mar 2023 14:05:13 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [RFC PATCH 13/28] arm64: RME: Allow VMM to set RIPAS
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
 <20230127112932.38045-14-steven.price@arm.com>
 <20230217150724.00006820@gmail.com>
From:   Steven Price <steven.price@arm.com>
In-Reply-To: <20230217150724.00006820@gmail.com>
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

On 17/02/2023 13:07, Zhi Wang wrote:
> On Fri, 27 Jan 2023 11:29:17 +0000
> Steven Price <steven.price@arm.com> wrote:
> 
>> Each page within the protected region of the realm guest can be marked
>> as either RAM or EMPTY. Allow the VMM to control this before the guest
>> has started and provide the equivalent functions to change this (with
>> the guest's approval) at runtime.
>>
> 
> The above is just the purpose of this patch. It would be better to have one
> more paragraph to describe what this patch does (building RTT and set IPA
> state in the RTT) and explain something might confuse people, for example
> the spare page.

I'll improve the commit message.

> The spare page is really confusing. When reading __alloc_delegated_page()
> , it looks like a mechanism to cache a delegated page for the realm. But later
> in the teardown path, it looks like a workaround. What if the allocation of 
> the spare page failed in the RTT tear down path? 

Yeah the spare_page is a bit messy. Ultimately the idea is that rather
than having to delegate a page to the RMM temporarily just for breaking
up a block mapping which is going to be freed, we keep one spare for the
purpose. This also reduces the chance of an allocation failure while
trying to free memory.

One area of confusion, and something that might be worth revisiting, is
that the spare_page is also used opportunistically in
realm_create_rtt_levels(). Again this makes sense in the case where a
temporary page is needed when creating a block mapping, but the code
doesn't distinguish between this and just creating RTTs for normal mappings.

This leads to the rather unfortunate situation that it's not actually
possible to rely on there being a spare_page and therefore this is
pre-populated in kvm_realm_unmap_range(), but with a possibility that
allocation failure could occur resulting in the function failing (which
is 'handled' by a WARN_ON).

> I understand this must be a temporary solution. It would be really nice to
> have a big picture or some basic introduction to the future plan. 

Sadly I don't currently have a "big picture" plan at the moment. I am
quite tempted to split spare_page into two:

 * A 'guaranteed' spare page purely for destroying block mappings. This
would be allocated when the realm is created and only used for the
purpose of tearing down mappings.

 * A temporary spare page used as a minor optimisation during block
mapping creation - rather than immediately freeing the page back when
folding we can hold on to it with the assumption that it's likely to be
useful for creating further mappings in the same call.

However, to be honest, this is all a bit academic because as it stands
block mappings can't really be used. But when we switch over to using
the memfd approach hopefully huge pages can be translated to block mappings.

Steve

>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>>  arch/arm64/include/asm/kvm_rme.h |   4 +
>>  arch/arm64/kvm/rme.c             | 288 +++++++++++++++++++++++++++++++
>>  2 files changed, 292 insertions(+)
>>
>> diff --git a/arch/arm64/include/asm/kvm_rme.h b/arch/arm64/include/asm/kvm_rme.h
>> index 4b219ebe1400..3e75cedaad18 100644
>> --- a/arch/arm64/include/asm/kvm_rme.h
>> +++ b/arch/arm64/include/asm/kvm_rme.h
>> @@ -47,6 +47,10 @@ void kvm_realm_destroy_rtts(struct realm *realm, u32 ia_bits, u32 start_level);
>>  int kvm_create_rec(struct kvm_vcpu *vcpu);
>>  void kvm_destroy_rec(struct kvm_vcpu *vcpu);
>>  
>> +int realm_set_ipa_state(struct kvm_vcpu *vcpu,
>> +			unsigned long addr, unsigned long end,
>> +			unsigned long ripas);
>> +
>>  #define RME_RTT_BLOCK_LEVEL	2
>>  #define RME_RTT_MAX_LEVEL	3
>>  
>> diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
>> index d79ed889ca4d..b3ea79189839 100644
>> --- a/arch/arm64/kvm/rme.c
>> +++ b/arch/arm64/kvm/rme.c
>> @@ -73,6 +73,58 @@ static int rmi_check_version(void)
>>  	return 0;
>>  }
>>  
>> +static phys_addr_t __alloc_delegated_page(struct realm *realm,
>> +					  struct kvm_mmu_memory_cache *mc, gfp_t flags)
>> +{
>> +	phys_addr_t phys = PHYS_ADDR_MAX;
>> +	void *virt;
>> +
>> +	if (realm->spare_page != PHYS_ADDR_MAX) {
>> +		swap(realm->spare_page, phys);
>> +		goto out;
>> +	}
>> +
>> +	if (mc)
>> +		virt = kvm_mmu_memory_cache_alloc(mc);
>> +	else
>> +		virt = (void *)__get_free_page(flags);
>> +
>> +	if (!virt)
>> +		goto out;
>> +
>> +	phys = virt_to_phys(virt);
>> +
>> +	if (rmi_granule_delegate(phys)) {
>> +		free_page((unsigned long)virt);
>> +
>> +		phys = PHYS_ADDR_MAX;
>> +	}
>> +
>> +out:
>> +	return phys;
>> +}
>> +
>> +static phys_addr_t alloc_delegated_page(struct realm *realm,
>> +					struct kvm_mmu_memory_cache *mc)
>> +{
>> +	return __alloc_delegated_page(realm, mc, GFP_KERNEL);
>> +}
>> +
>> +static void free_delegated_page(struct realm *realm, phys_addr_t phys)
>> +{
>> +	if (realm->spare_page == PHYS_ADDR_MAX) {
>> +		realm->spare_page = phys;
>> +		return;
>> +	}
>> +
>> +	if (WARN_ON(rmi_granule_undelegate(phys))) {
>> +		/* Undelegate failed: leak the page */
>> +		return;
>> +	}
>> +
>> +	free_page((unsigned long)phys_to_virt(phys));
>> +}
>> +
>>  static void realm_destroy_undelegate_range(struct realm *realm,
>>  					   unsigned long ipa,
>>  					   unsigned long addr,
>> @@ -220,6 +272,30 @@ static int realm_rtt_create(struct realm *realm,
>>  	return rmi_rtt_create(phys, virt_to_phys(realm->rd), addr, level);
>>  }
>>  
>> +static int realm_create_rtt_levels(struct realm *realm,
>> +				   unsigned long ipa,
>> +				   int level,
>> +				   int max_level,
>> +				   struct kvm_mmu_memory_cache *mc)
>> +{
>> +	if (WARN_ON(level == max_level))
>> +		return 0;
>> +
>> +	while (level++ < max_level) {
>> +		phys_addr_t rtt = alloc_delegated_page(realm, mc);
>> +
>> +		if (rtt == PHYS_ADDR_MAX)
>> +			return -ENOMEM;
>> +
>> +		if (realm_rtt_create(realm, ipa, level, rtt)) {
>> +			free_delegated_page(realm, rtt);
>> +			return -ENXIO;
>> +		}
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>>  static int realm_tear_down_rtt_range(struct realm *realm, int level,
>>  				     unsigned long start, unsigned long end)
>>  {
>> @@ -309,6 +385,206 @@ void kvm_realm_destroy_rtts(struct realm *realm, u32 ia_bits, u32 start_level)
>>  	realm_tear_down_rtt_range(realm, start_level, 0, (1UL << ia_bits));
>>  }
>>  
>> +void kvm_realm_unmap_range(struct kvm *kvm, unsigned long ipa, u64 size)
>> +{
>> +	u32 ia_bits = kvm->arch.mmu.pgt->ia_bits;
>> +	u32 start_level = kvm->arch.mmu.pgt->start_level;
>> +	unsigned long end = ipa + size;
>> +	struct realm *realm = &kvm->arch.realm;
>> +	phys_addr_t tmp_rtt = PHYS_ADDR_MAX;
>> +
>> +	if (end > (1UL << ia_bits))
>> +		end = 1UL << ia_bits;
>> +	/*
>> +	 * Make sure we have a spare delegated page for tearing down the
>> +	 * block mappings. We must use Atomic allocations as we are called
>> +	 * with kvm->mmu_lock held.
>> +	 */
>> +	if (realm->spare_page == PHYS_ADDR_MAX) {
>> +		tmp_rtt = __alloc_delegated_page(realm, NULL, GFP_ATOMIC);
>> +		/*
>> +		 * We don't have to check the status here, as we may not
>> +		 * have a block level mapping. Delay any error to the point
>> +		 * where we need it.
>> +		 */
>> +		realm->spare_page = tmp_rtt;
>> +	}
>> +
>> +	realm_tear_down_rtt_range(&kvm->arch.realm, start_level, ipa, end);
>> +
>> +	/* Free up the atomic page, if there were any */
>> +	if (tmp_rtt != PHYS_ADDR_MAX) {
>> +		free_delegated_page(realm, tmp_rtt);
>> +		/*
>> +		 * Update the spare_page after we have freed the
>> +		 * above page to make sure it doesn't get cached
>> +		 * in spare_page.
>> +		 * We should re-write this part and always have
>> +		 * a dedicated page for handling block mappings.
>> +		 */
>> +		realm->spare_page = PHYS_ADDR_MAX;
>> +	}
>> +}
>> +
>> +static int set_ipa_state(struct kvm_vcpu *vcpu,
>> +			 unsigned long ipa,
>> +			 unsigned long end,
>> +			 int level,
>> +			 unsigned long ripas)
>> +{
>> +	struct kvm *kvm = vcpu->kvm;
>> +	struct realm *realm = &kvm->arch.realm;
>> +	struct rec *rec = &vcpu->arch.rec;
>> +	phys_addr_t rd_phys = virt_to_phys(realm->rd);
>> +	phys_addr_t rec_phys = virt_to_phys(rec->rec_page);
>> +	unsigned long map_size = rme_rtt_level_mapsize(level);
>> +	int ret;
>> +
>> +	while (ipa < end) {
>> +		ret = rmi_rtt_set_ripas(rd_phys, rec_phys, ipa, level, ripas);
>> +
>> +		if (!ret) {
>> +			if (!ripas)
>> +				kvm_realm_unmap_range(kvm, ipa, map_size);
>> +		} else if (RMI_RETURN_STATUS(ret) == RMI_ERROR_RTT) {
>> +			int walk_level = RMI_RETURN_INDEX(ret);
>> +
>> +			if (walk_level < level) {
>> +				ret = realm_create_rtt_levels(realm, ipa,
>> +							      walk_level,
>> +							      level, NULL);
>> +				if (ret)
>> +					return ret;
>> +				continue;
>> +			}
>> +
>> +			if (WARN_ON(level >= RME_RTT_MAX_LEVEL))
>> +				return -EINVAL;
>> +
>> +			/* Recurse one level lower */
>> +			ret = set_ipa_state(vcpu, ipa, ipa + map_size,
>> +					    level + 1, ripas);
>> +			if (ret)
>> +				return ret;
>> +		} else {
>> +			WARN(1, "Unexpected error in %s: %#x\n", __func__,
>> +			     ret);
>> +			return -EINVAL;
>> +		}
>> +		ipa += map_size;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int realm_init_ipa_state(struct realm *realm,
>> +				unsigned long ipa,
>> +				unsigned long end,
>> +				int level)
>> +{
>> +	unsigned long map_size = rme_rtt_level_mapsize(level);
>> +	phys_addr_t rd_phys = virt_to_phys(realm->rd);
>> +	int ret;
>> +
>> +	while (ipa < end) {
>> +		ret = rmi_rtt_init_ripas(rd_phys, ipa, level);
>> +
>> +		if (RMI_RETURN_STATUS(ret) == RMI_ERROR_RTT) {
>> +			int cur_level = RMI_RETURN_INDEX(ret);
>> +
>> +			if (cur_level < level) {
>> +				ret = realm_create_rtt_levels(realm, ipa,
>> +							      cur_level,
>> +							      level, NULL);
>> +				if (ret)
>> +					return ret;
>> +				/* Retry with the RTT levels in place */
>> +				continue;
>> +			}
>> +
>> +			/* There's an entry at a lower level, recurse */
>> +			if (WARN_ON(level >= RME_RTT_MAX_LEVEL))
>> +				return -EINVAL;
>> +
>> +			realm_init_ipa_state(realm, ipa, ipa + map_size,
>> +					     level + 1);
>> +		} else if (WARN_ON(ret)) {
>> +			return -ENXIO;
>> +		}
>> +
>> +		ipa += map_size;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int find_map_level(struct kvm *kvm, unsigned long start, unsigned long end)
>> +{
>> +	int level = RME_RTT_MAX_LEVEL;
>> +
>> +	while (level > get_start_level(kvm) + 1) {
>> +		unsigned long map_size = rme_rtt_level_mapsize(level - 1);
>> +
>> +		if (!IS_ALIGNED(start, map_size) ||
>> +		    (start + map_size) > end)
>> +			break;
>> +
>> +		level--;
>> +	}
>> +
>> +	return level;
>> +}
>> +
>> +int realm_set_ipa_state(struct kvm_vcpu *vcpu,
>> +			unsigned long addr, unsigned long end,
>> +			unsigned long ripas)
>> +{
>> +	int ret = 0;
>> +
>> +	while (addr < end) {
>> +		int level = find_map_level(vcpu->kvm, addr, end);
>> +		unsigned long map_size = rme_rtt_level_mapsize(level);
>> +
>> +		ret = set_ipa_state(vcpu, addr, addr + map_size, level, ripas);
>> +		if (ret)
>> +			break;
>> +
>> +		addr += map_size;
>> +	}
>> +
>> +	return ret;
>> +}
>> +
>> +static int kvm_init_ipa_range_realm(struct kvm *kvm,
>> +				    struct kvm_cap_arm_rme_init_ipa_args *args)
>> +{
>> +	int ret = 0;
>> +	gpa_t addr, end;
>> +	struct realm *realm = &kvm->arch.realm;
>> +
>> +	addr = args->init_ipa_base;
>> +	end = addr + args->init_ipa_size;
>> +
>> +	if (end < addr)
>> +		return -EINVAL;
>> +
>> +	if (kvm_realm_state(kvm) != REALM_STATE_NEW)
>> +		return -EBUSY;
>> +
>> +	while (addr < end) {
>> +		int level = find_map_level(kvm, addr, end);
>> +		unsigned long map_size = rme_rtt_level_mapsize(level);
>> +
>> +		ret = realm_init_ipa_state(realm, addr, addr + map_size, level);
>> +		if (ret)
>> +			break;
>> +
>> +		addr += map_size;
>> +	}
>> +
>> +	return ret;
>> +}
>> +
>>  /* Protects access to rme_vmid_bitmap */
>>  static DEFINE_SPINLOCK(rme_vmid_lock);
>>  static unsigned long *rme_vmid_bitmap;
>> @@ -460,6 +736,18 @@ int kvm_realm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
>>  
>>  		r = kvm_create_realm(kvm);
>>  		break;
>> +	case KVM_CAP_ARM_RME_INIT_IPA_REALM: {
>> +		struct kvm_cap_arm_rme_init_ipa_args args;
>> +		void __user *argp = u64_to_user_ptr(cap->args[1]);
>> +
>> +		if (copy_from_user(&args, argp, sizeof(args))) {
>> +			r = -EFAULT;
>> +			break;
>> +		}
>> +
>> +		r = kvm_init_ipa_range_realm(kvm, &args);
>> +		break;
>> +	}
>>  	default:
>>  		r = -EINVAL;
>>  		break;
> 

