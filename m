Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEBB36A9908
	for <lists+kvm@lfdr.de>; Fri,  3 Mar 2023 15:05:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231229AbjCCOFM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Mar 2023 09:05:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbjCCOFJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Mar 2023 09:05:09 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 13ABA61536;
        Fri,  3 Mar 2023 06:05:08 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 21A121762;
        Fri,  3 Mar 2023 06:05:51 -0800 (PST)
Received: from [10.1.39.22] (e122027.cambridge.arm.com [10.1.39.22])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5A8B23F93E;
        Fri,  3 Mar 2023 06:05:04 -0800 (PST)
Message-ID: <e4306163-e972-f8b0-d7ce-87f1777d4958@arm.com>
Date:   Fri, 3 Mar 2023 14:05:02 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [RFC PATCH 10/28] arm64: RME: Allocate/free RECs to match vCPUs
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
 <20230127112932.38045-11-steven.price@arm.com>
 <20230213200857.00007575@gmail.com>
From:   Steven Price <steven.price@arm.com>
In-Reply-To: <20230213200857.00007575@gmail.com>
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

On 13/02/2023 18:08, Zhi Wang wrote:
> On Fri, 27 Jan 2023 11:29:14 +0000
> Steven Price <steven.price@arm.com> wrote:
> 
>> The RMM maintains a data structure known as the Realm Execution Context
>> (or REC). It is similar to struct kvm_vcpu and tracks the state of the
>> virtual CPUs. KVM must delegate memory and request the structures are
>> created when vCPUs are created, and suitably tear down on destruction.
>>
> 
> It would be better to leave some pointers to the spec here. It really saves
> time for reviewers. 

Fair enough. I wasn't sure how often to repeat the link to the spec, but
a few more times wouldn't hurt ;)

>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>>  arch/arm64/include/asm/kvm_emulate.h |   2 +
>>  arch/arm64/include/asm/kvm_host.h    |   3 +
>>  arch/arm64/include/asm/kvm_rme.h     |  10 ++
>>  arch/arm64/kvm/arm.c                 |   1 +
>>  arch/arm64/kvm/reset.c               |  11 ++
>>  arch/arm64/kvm/rme.c                 | 144 +++++++++++++++++++++++++++
>>  6 files changed, 171 insertions(+)
>>
>> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
>> index 5a2b7229e83f..285e62914ca4 100644
>> --- a/arch/arm64/include/asm/kvm_emulate.h
>> +++ b/arch/arm64/include/asm/kvm_emulate.h
>> @@ -504,6 +504,8 @@ static inline enum realm_state kvm_realm_state(struct kvm *kvm)
>>  
>>  static inline bool vcpu_is_rec(struct kvm_vcpu *vcpu)
>>  {
>> +	if (static_branch_unlikely(&kvm_rme_is_available))
>> +		return vcpu->arch.rec.mpidr != INVALID_HWID;
>>  	return false;
>>  }
>>  
>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>> index 04347c3a8c6b..ef497b718cdb 100644
>> --- a/arch/arm64/include/asm/kvm_host.h
>> +++ b/arch/arm64/include/asm/kvm_host.h
>> @@ -505,6 +505,9 @@ struct kvm_vcpu_arch {
>>  		u64 last_steal;
>>  		gpa_t base;
>>  	} steal;
>> +
>> +	/* Realm meta data */
>> +	struct rec rec;
> 
> I think the name of the data structure "rec" needs a prefix, it is too common
> and might conflict with the private data structures in the other modules. Maybe
> rme_rec or realm_rec?

struct realm_rec seems like a good choice. I agree 'rec' without context
is somewhat ambiguous.

>>  };
>>  
>>  /*
>> diff --git a/arch/arm64/include/asm/kvm_rme.h b/arch/arm64/include/asm/kvm_rme.h
>> index eea5118dfa8a..4b219ebe1400 100644
>> --- a/arch/arm64/include/asm/kvm_rme.h
>> +++ b/arch/arm64/include/asm/kvm_rme.h
>> @@ -6,6 +6,7 @@
>>  #ifndef __ASM_KVM_RME_H
>>  #define __ASM_KVM_RME_H
>>  
>> +#include <asm/rmi_smc.h>
>>  #include <uapi/linux/kvm.h>
>>  
>>  enum realm_state {
>> @@ -29,6 +30,13 @@ struct realm {
>>  	unsigned int ia_bits;
>>  };
>>  
>> +struct rec {
>> +	unsigned long mpidr;
>> +	void *rec_page;
>> +	struct page *aux_pages[REC_PARAMS_AUX_GRANULES];
>> +	struct rec_run *run;
>> +};
>> +
> 
> It is better to leave some comments for above members or pointers to the spec,
> that saves a lot of time for review.

Will add comments.

>>  int kvm_init_rme(void);
>>  u32 kvm_realm_ipa_limit(void);
>>  
>> @@ -36,6 +44,8 @@ int kvm_realm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap);
>>  int kvm_init_realm_vm(struct kvm *kvm);
>>  void kvm_destroy_realm(struct kvm *kvm);
>>  void kvm_realm_destroy_rtts(struct realm *realm, u32 ia_bits, u32 start_level);
>> +int kvm_create_rec(struct kvm_vcpu *vcpu);
>> +void kvm_destroy_rec(struct kvm_vcpu *vcpu);
>>  
>>  #define RME_RTT_BLOCK_LEVEL	2
>>  #define RME_RTT_MAX_LEVEL	3
>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>> index badd775547b8..52affed2f3cf 100644
>> --- a/arch/arm64/kvm/arm.c
>> +++ b/arch/arm64/kvm/arm.c
>> @@ -373,6 +373,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>>  	/* Force users to call KVM_ARM_VCPU_INIT */
>>  	vcpu->arch.target = -1;
>>  	bitmap_zero(vcpu->arch.features, KVM_VCPU_MAX_FEATURES);
>> +	vcpu->arch.rec.mpidr = INVALID_HWID;
>>  
>>  	vcpu->arch.mmu_page_cache.gfp_zero = __GFP_ZERO;
>>  
>> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
>> index 9e71d69e051f..0c84392a4bf2 100644
>> --- a/arch/arm64/kvm/reset.c
>> +++ b/arch/arm64/kvm/reset.c
>> @@ -135,6 +135,11 @@ int kvm_arm_vcpu_finalize(struct kvm_vcpu *vcpu, int feature)
>>  			return -EPERM;
>>  
>>  		return kvm_vcpu_finalize_sve(vcpu);
>> +	case KVM_ARM_VCPU_REC:
>> +		if (!kvm_is_realm(vcpu->kvm))
>> +			return -EINVAL;
>> +
>> +		return kvm_create_rec(vcpu);
>>  	}
>>  
>>  	return -EINVAL;
>> @@ -145,6 +150,11 @@ bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu)
>>  	if (vcpu_has_sve(vcpu) && !kvm_arm_vcpu_sve_finalized(vcpu))
>>  		return false;
>>  
>> +	if (kvm_is_realm(vcpu->kvm) &&
>> +	    !(vcpu_is_rec(vcpu) &&
>> +	      READ_ONCE(vcpu->kvm->arch.realm.state) == REALM_STATE_ACTIVE))
>> +		return false;
> 
> That's why it is better to introduce the realm state in the previous patches so
> that people can really get the idea of the states at this stage.
> 
>> +
>>  	return true;
>>  }
>>  
>> @@ -157,6 +167,7 @@ void kvm_arm_vcpu_destroy(struct kvm_vcpu *vcpu)
>>  	if (sve_state)
>>  		kvm_unshare_hyp(sve_state, sve_state + vcpu_sve_state_size(vcpu));
>>  	kfree(sve_state);
>> +	kvm_destroy_rec(vcpu);
>>  }
>>  
>>  static void kvm_vcpu_reset_sve(struct kvm_vcpu *vcpu)
>> diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
>> index f7b0e5a779f8..d79ed889ca4d 100644
>> --- a/arch/arm64/kvm/rme.c
>> +++ b/arch/arm64/kvm/rme.c
>> @@ -514,6 +514,150 @@ void kvm_destroy_realm(struct kvm *kvm)
>>  	kvm_free_stage2_pgd(&kvm->arch.mmu);
>>  }
>>  
>> +static void free_rec_aux(struct page **aux_pages,
>> +			 unsigned int num_aux)
>> +{
>> +	unsigned int i;
>> +
>> +	for (i = 0; i < num_aux; i++) {
>> +		phys_addr_t aux_page_phys = page_to_phys(aux_pages[i]);
>> +
>> +		if (WARN_ON(rmi_granule_undelegate(aux_page_phys)))
>> +			continue;
>> +
>> +		__free_page(aux_pages[i]);
>> +	}
>> +}
>> +
>> +static int alloc_rec_aux(struct page **aux_pages,
>> +			 u64 *aux_phys_pages,
>> +			 unsigned int num_aux)
>> +{
>> +	int ret;
>> +	unsigned int i;
>> +
>> +	for (i = 0; i < num_aux; i++) {
>> +		struct page *aux_page;
>> +		phys_addr_t aux_page_phys;
>> +
>> +		aux_page = alloc_page(GFP_KERNEL);
>> +		if (!aux_page) {
>> +			ret = -ENOMEM;
>> +			goto out_err;
>> +		}
>> +		aux_page_phys = page_to_phys(aux_page);
>> +		if (rmi_granule_delegate(aux_page_phys)) {
>> +			__free_page(aux_page);
>> +			ret = -ENXIO;
>> +			goto out_err;
>> +		}
>> +		aux_pages[i] = aux_page;
>> +		aux_phys_pages[i] = aux_page_phys;
>> +	}
>> +
>> +	return 0;
>> +out_err:
>> +	free_rec_aux(aux_pages, i);
>> +	return ret;
>> +}
>> +
>> +int kvm_create_rec(struct kvm_vcpu *vcpu)
>> +{
>> +	struct user_pt_regs *vcpu_regs = vcpu_gp_regs(vcpu);
>> +	unsigned long mpidr = kvm_vcpu_get_mpidr_aff(vcpu);
>> +	struct realm *realm = &vcpu->kvm->arch.realm;
>> +	struct rec *rec = &vcpu->arch.rec;
>> +	unsigned long rec_page_phys;
>> +	struct rec_params *params;
>> +	int r, i;
>> +
>> +	if (kvm_realm_state(vcpu->kvm) != REALM_STATE_NEW)
>> +		return -ENOENT;
>> +
>> +	/*
>> +	 * The RMM will report PSCI v1.0 to Realms and the KVM_ARM_VCPU_PSCI_0_2
>> +	 * flag covers v0.2 and onwards.
>> +	 */
>> +	if (!test_bit(KVM_ARM_VCPU_PSCI_0_2, vcpu->arch.features))
>> +		return -EINVAL;
>> +
>> +	BUILD_BUG_ON(sizeof(*params) > PAGE_SIZE);
>> +	BUILD_BUG_ON(sizeof(*rec->run) > PAGE_SIZE);
>> +
>> +	params = (struct rec_params *)get_zeroed_page(GFP_KERNEL);
>> +	rec->rec_page = (void *)__get_free_page(GFP_KERNEL);
>> +	rec->run = (void *)get_zeroed_page(GFP_KERNEL);
>> +	if (!params || !rec->rec_page || !rec->run) {
>> +		r = -ENOMEM;
>> +		goto out_free_pages;
>> +	}
>> +
>> +	for (i = 0; i < ARRAY_SIZE(params->gprs); i++)
>> +		params->gprs[i] = vcpu_regs->regs[i];
>> +
>> +	params->pc = vcpu_regs->pc;
>> +
>> +	if (vcpu->vcpu_id == 0)
>> +		params->flags |= REC_PARAMS_FLAG_RUNNABLE;
>> +
>> +	rec_page_phys = virt_to_phys(rec->rec_page);
>> +
>> +	if (rmi_granule_delegate(rec_page_phys)) {
>> +		r = -ENXIO;
>> +		goto out_free_pages;
>> +	}
>> +
> 
> Wouldn't it be better to extend the alloc_rec_aux() to allocate and delegate
> pages above? so that you can same some gfps and rmi_granuale_delegates().

I don't think it's really an improvement. There's only the one
rmi_granule_delegate() call (for the REC page itself). The RecParams and
RecRun pages are not delegated because they are shared with the host. It
would also hide the structure setup within the new
alloc_rec_aux_and_rec() function.

>> +	r = alloc_rec_aux(rec->aux_pages, params->aux, realm->num_aux);
>> +	if (r)
>> +		goto out_undelegate_rmm_rec;
>> +
>> +	params->num_rec_aux = realm->num_aux;
>> +	params->mpidr = mpidr;
>> +
>> +	if (rmi_rec_create(rec_page_phys,
>> +			   virt_to_phys(realm->rd),
>> +			   virt_to_phys(params))) {
>> +		r = -ENXIO;
>> +		goto out_free_rec_aux;
>> +	}
>> +
>> +	rec->mpidr = mpidr;
>> +
>> +	free_page((unsigned long)params);
>> +	return 0;
>> +
>> +out_free_rec_aux:
>> +	free_rec_aux(rec->aux_pages, realm->num_aux);
>> +out_undelegate_rmm_rec:
>> +	if (WARN_ON(rmi_granule_undelegate(rec_page_phys)))
>> +		rec->rec_page = NULL;
>> +out_free_pages:
>> +	free_page((unsigned long)rec->run);
>> +	free_page((unsigned long)rec->rec_page);
>> +	free_page((unsigned long)params);
>> +	return r;
>> +}
>> +
>> +void kvm_destroy_rec(struct kvm_vcpu *vcpu)
>> +{
>> +	struct realm *realm = &vcpu->kvm->arch.realm;
>> +	struct rec *rec = &vcpu->arch.rec;
>> +	unsigned long rec_page_phys;
>> +
>> +	if (!vcpu_is_rec(vcpu))
>> +		return;
>> +
>> +	rec_page_phys = virt_to_phys(rec->rec_page);
>> +
>> +	if (WARN_ON(rmi_rec_destroy(rec_page_phys)))
>> +		return;
>> +	if (WARN_ON(rmi_granule_undelegate(rec_page_phys)))
>> +		return;
>> +
> 
> The two returns above feels off. What is the reason to skip the below page
> undelegates?

The reason is the usual: if we fail to undelegate then the pages have to
be leaked. I'll add some comments. However it does look like I've got
the order wrong here, if the undelegate fails for rec_page_phys it's
possible that we might still be able to free the rec_aux pages (although
something has gone terribly wrong for that to be the case).

I'll change the order to:

  /* If the REC destroy fails, leak all pages relating to the REC */
  if (WARN_ON(rmi_rec_destroy(rec_page_phys)))
	return;

  free_rec_aux(rec->aux_pages, realm->num_aux);

  /* If the undelegate fails then leak the REC page */
  if (WARN_ON(rmi_granule_undelegate(rec_page_phys)))
	return;

  free_page((unsigned long)rec->rec_page);

If the rmi_rec_destroy() call has failed then the RMM should prevent the
undelegate so there's little point trying.

Steve

>> +	free_rec_aux(rec->aux_pages, realm->num_aux);
>> +	free_page((unsigned long)rec->rec_page);
>> +}
>> +
>>  int kvm_init_realm_vm(struct kvm *kvm)
>>  {
>>  	struct realm_params *params;
> 

