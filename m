Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0F6D6A6BF1
	for <lists+kvm@lfdr.de>; Wed,  1 Mar 2023 12:55:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbjCALzZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Mar 2023 06:55:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbjCALzY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Mar 2023 06:55:24 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4D64032522;
        Wed,  1 Mar 2023 03:55:23 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 47D752F4;
        Wed,  1 Mar 2023 03:56:06 -0800 (PST)
Received: from [10.57.16.41] (unknown [10.57.16.41])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CE9183F587;
        Wed,  1 Mar 2023 03:55:19 -0800 (PST)
Message-ID: <04adb31d-06c5-b274-62c6-4f19dc681513@arm.com>
Date:   Wed, 1 Mar 2023 11:55:17 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [RFC PATCH 06/28] arm64: RME: ioctls to create and configure
 realms
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
 <20230127112932.38045-7-steven.price@arm.com>
 <20230213181044.00004994@gmail.com>
From:   Steven Price <steven.price@arm.com>
In-Reply-To: <20230213181044.00004994@gmail.com>
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

On 13/02/2023 16:10, Zhi Wang wrote:
> On Fri, 27 Jan 2023 11:29:10 +0000
> Steven Price <steven.price@arm.com> wrote:
> 
>> Add the KVM_CAP_ARM_RME_CREATE_FD ioctl to create a realm. This involves
>> delegating pages to the RMM to hold the Realm Descriptor (RD) and for
>> the base level of the Realm Translation Tables (RTT). A VMID also need
>> to be picked, since the RMM has a separate VMID address space a
>> dedicated allocator is added for this purpose.
>>
>> KVM_CAP_ARM_RME_CONFIG_REALM is provided to allow configuring the realm
>> before it is created.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>>  arch/arm64/include/asm/kvm_rme.h |  14 ++
>>  arch/arm64/kvm/arm.c             |  19 ++
>>  arch/arm64/kvm/mmu.c             |   6 +
>>  arch/arm64/kvm/reset.c           |  33 +++
>>  arch/arm64/kvm/rme.c             | 357 +++++++++++++++++++++++++++++++
>>  5 files changed, 429 insertions(+)
>>
>> diff --git a/arch/arm64/include/asm/kvm_rme.h b/arch/arm64/include/asm/kvm_rme.h
>> index c26bc2c6770d..055a22accc08 100644
>> --- a/arch/arm64/include/asm/kvm_rme.h
>> +++ b/arch/arm64/include/asm/kvm_rme.h
>> @@ -6,6 +6,8 @@
>>  #ifndef __ASM_KVM_RME_H
>>  #define __ASM_KVM_RME_H
>>  
>> +#include <uapi/linux/kvm.h>
>> +
>>  enum realm_state {
>>  	REALM_STATE_NONE,
>>  	REALM_STATE_NEW,
>> @@ -15,8 +17,20 @@ enum realm_state {
>>  
>>  struct realm {
>>  	enum realm_state state;
>> +
>> +	void *rd;
>> +	struct realm_params *params;
>> +
>> +	unsigned long num_aux;
>> +	unsigned int vmid;
>> +	unsigned int ia_bits;
>>  };
>>  
> 
> Maybe more comments for this structure?

Agreed, this series is a bit light on comments. I'll try to improve for v2.

<snip>

> 
> Just curious. Wouldn't it be better to use IDR as this is ID allocation? There
> were some efforts to change the use of bitmap allocation to IDR before.

I'm not sure it makes much difference really. This matches KVM's
vmid_map, but here things are much more simple as there's no support for
the likes of VMID rollover (the number of Realm VMs is just capped at
the number of VMIDs).

IDR provides a lot of functionality we don't need, but equally I don't
think performance or memory usage are really a concern here.

Steve

>> +/* Protects access to rme_vmid_bitmap */
>> +static DEFINE_SPINLOCK(rme_vmid_lock);
>> +static unsigned long *rme_vmid_bitmap;
>> +
>> +static int rme_vmid_init(void)
>> +{
>> +	unsigned int vmid_count = 1 << kvm_get_vmid_bits();
>> +
>> +	rme_vmid_bitmap = bitmap_zalloc(vmid_count, GFP_KERNEL);
>> +	if (!rme_vmid_bitmap) {
>> +		kvm_err("%s: Couldn't allocate rme vmid bitmap\n", __func__);
>> +		return -ENOMEM;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int rme_vmid_reserve(void)
>> +{
>> +	int ret;
>> +	unsigned int vmid_count = 1 << kvm_get_vmid_bits();
>> +
>> +	spin_lock(&rme_vmid_lock);
>> +	ret = bitmap_find_free_region(rme_vmid_bitmap, vmid_count, 0);
>> +	spin_unlock(&rme_vmid_lock);
>> +
>> +	return ret;
>> +}
>> +
>> +static void rme_vmid_release(unsigned int vmid)
>> +{
>> +	spin_lock(&rme_vmid_lock);
>> +	bitmap_release_region(rme_vmid_bitmap, vmid, 0);
>> +	spin_unlock(&rme_vmid_lock);
>> +}
>> +
>> +static int kvm_create_realm(struct kvm *kvm)
>> +{
>> +	struct realm *realm = &kvm->arch.realm;
>> +	int ret;
>> +
>> +	if (!kvm_is_realm(kvm) || kvm_realm_state(kvm) != REALM_STATE_NONE)
>> +		return -EEXIST;
>> +
>> +	ret = rme_vmid_reserve();
>> +	if (ret < 0)
>> +		return ret;
>> +	realm->vmid = ret;
>> +
>> +	ret = realm_create_rd(kvm);
>> +	if (ret) {
>> +		rme_vmid_release(realm->vmid);
>> +		return ret;
>> +	}
>> +
>> +	WRITE_ONCE(realm->state, REALM_STATE_NEW);
>> +
>> +	/* The realm is up, free the parameters.  */
>> +	free_page((unsigned long)realm->params);
>> +	realm->params = NULL;
>> +
>> +	return 0;
>> +}
>> +
>> +static int config_realm_hash_algo(struct realm *realm,
>> +				  struct kvm_cap_arm_rme_config_item *cfg)
>> +{
>> +	switch (cfg->hash_algo) {
>> +	case KVM_CAP_ARM_RME_MEASUREMENT_ALGO_SHA256:
>> +		if (!rme_supports(RMI_FEATURE_REGISTER_0_HASH_SHA_256))
>> +			return -EINVAL;
>> +		break;
>> +	case KVM_CAP_ARM_RME_MEASUREMENT_ALGO_SHA512:
>> +		if (!rme_supports(RMI_FEATURE_REGISTER_0_HASH_SHA_512))
>> +			return -EINVAL;
>> +		break;
>> +	default:
>> +		return -EINVAL;
>> +	}
>> +	realm->params->measurement_algo = cfg->hash_algo;
>> +	return 0;
>> +}
>> +
>> +static int config_realm_sve(struct realm *realm,
>> +			    struct kvm_cap_arm_rme_config_item *cfg)
>> +{
>> +	u64 features_0 = realm->params->features_0;
>> +	int max_sve_vq = u64_get_bits(rmm_feat_reg0,
>> +				      RMI_FEATURE_REGISTER_0_SVE_VL);
>> +
>> +	if (!rme_supports(RMI_FEATURE_REGISTER_0_SVE_EN))
>> +		return -EINVAL;
>> +
>> +	if (cfg->sve_vq > max_sve_vq)
>> +		return -EINVAL;
>> +
>> +	features_0 &= ~(RMI_FEATURE_REGISTER_0_SVE_EN |
>> +			RMI_FEATURE_REGISTER_0_SVE_VL);
>> +	features_0 |= u64_encode_bits(1, RMI_FEATURE_REGISTER_0_SVE_EN);
>> +	features_0 |= u64_encode_bits(cfg->sve_vq,
>> +				      RMI_FEATURE_REGISTER_0_SVE_VL);
>> +
>> +	realm->params->features_0 = features_0;
>> +	return 0;
>> +}
>> +
>> +static int kvm_rme_config_realm(struct kvm *kvm, struct kvm_enable_cap *cap)
>> +{
>> +	struct kvm_cap_arm_rme_config_item cfg;
>> +	struct realm *realm = &kvm->arch.realm;
>> +	int r = 0;
>> +
>> +	if (kvm_realm_state(kvm) != REALM_STATE_NONE)
>> +		return -EBUSY;
>> +
>> +	if (copy_from_user(&cfg, (void __user *)cap->args[1], sizeof(cfg)))
>> +		return -EFAULT;
>> +
>> +	switch (cfg.cfg) {
>> +	case KVM_CAP_ARM_RME_CFG_RPV:
>> +		memcpy(&realm->params->rpv, &cfg.rpv, sizeof(cfg.rpv));
>> +		break;
>> +	case KVM_CAP_ARM_RME_CFG_HASH_ALGO:
>> +		r = config_realm_hash_algo(realm, &cfg);
>> +		break;
>> +	case KVM_CAP_ARM_RME_CFG_SVE:
>> +		r = config_realm_sve(realm, &cfg);
>> +		break;
>> +	default:
>> +		r = -EINVAL;
>> +	}
>> +
>> +	return r;
>> +}
>> +
>> +int kvm_realm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
>> +{
>> +	int r = 0;
>> +
>> +	switch (cap->args[0]) {
>> +	case KVM_CAP_ARM_RME_CONFIG_REALM:
>> +		r = kvm_rme_config_realm(kvm, cap);
>> +		break;
>> +	case KVM_CAP_ARM_RME_CREATE_RD:
>> +		if (kvm->created_vcpus) {
>> +			r = -EBUSY;
>> +			break;
>> +		}
>> +
>> +		r = kvm_create_realm(kvm);
>> +		break;
>> +	default:
>> +		r = -EINVAL;
>> +		break;
>> +	}
>> +
>> +	return r;
>> +}
>> +
>> +void kvm_destroy_realm(struct kvm *kvm)
>> +{
>> +	struct realm *realm = &kvm->arch.realm;
>> +	struct kvm_pgtable *pgt = kvm->arch.mmu.pgt;
>> +	unsigned int pgd_sz;
>> +	int i;
>> +
>> +	if (realm->params) {
>> +		free_page((unsigned long)realm->params);
>> +		realm->params = NULL;
>> +	}
>> +
>> +	if (kvm_realm_state(kvm) == REALM_STATE_NONE)
>> +		return;
>> +
>> +	WRITE_ONCE(realm->state, REALM_STATE_DYING);
>> +
>> +	rme_vmid_release(realm->vmid);
>> +
>> +	if (realm->rd) {
>> +		phys_addr_t rd_phys = virt_to_phys(realm->rd);
>> +
>> +		if (WARN_ON(rmi_realm_destroy(rd_phys)))
>> +			return;
>> +		if (WARN_ON(rmi_granule_undelegate(rd_phys)))
>> +			return;
>> +		free_page((unsigned long)realm->rd);
>> +		realm->rd = NULL;
>> +	}
>> +
>> +	pgd_sz = kvm_pgd_pages(pgt->ia_bits, pgt->start_level);
>> +	for (i = 0; i < pgd_sz; i++) {
>> +		phys_addr_t pgd_phys = kvm->arch.mmu.pgd_phys + i * PAGE_SIZE;
>> +
>> +		if (WARN_ON(rmi_granule_undelegate(pgd_phys)))
>> +			return;
>> +	}
>> +
>> +	kvm_free_stage2_pgd(&kvm->arch.mmu);
>> +}
>> +
>> +int kvm_init_realm_vm(struct kvm *kvm)
>> +{
>> +	struct realm_params *params;
>> +
>> +	params = (struct realm_params *)get_zeroed_page(GFP_KERNEL);
>> +	if (!params)
>> +		return -ENOMEM;
>> +
>> +	params->features_0 = create_realm_feat_reg0(kvm);
>> +	kvm->arch.realm.params = params;
>> +	return 0;
>> +}
>> +
>>  int kvm_init_rme(void)
>>  {
>> +	int ret;
>> +
>>  	if (PAGE_SIZE != SZ_4K)
>>  		/* Only 4k page size on the host is supported */
>>  		return 0;
>> @@ -43,6 +394,12 @@ int kvm_init_rme(void)
>>  		/* Continue without realm support */
>>  		return 0;
>>  
>> +	ret = rme_vmid_init();
>> +	if (ret)
>> +		return ret;
>> +
>> +	WARN_ON(rmi_features(0, &rmm_feat_reg0));
>> +
>>  	/* Future patch will enable static branch kvm_rme_is_available */
>>  
>>  	return 0;
> 

