Return-Path: <kvm+bounces-32771-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 90CB39DC3ED
	for <lists+kvm@lfdr.de>; Fri, 29 Nov 2024 13:19:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 93F592825DF
	for <lists+kvm@lfdr.de>; Fri, 29 Nov 2024 12:18:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5AA819CC08;
	Fri, 29 Nov 2024 12:18:52 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EC7B14D6ED;
	Fri, 29 Nov 2024 12:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732882732; cv=none; b=f5yPIGi28a13qBDLaIfkWPcFE7NPcIbB8x5QDQ5sc+0Yiixhm2qfd84JFnZiwz1nASsDfXL5kNuWKdiemmiu1lCn+RKKfOm+qhHhns91aTDT1JsGipAxz/JGHHzVTPCAnIANn2edpsAPgHLkvXlPEAFkKR4dAvevp4yA2fpHfks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732882732; c=relaxed/simple;
	bh=S1SlKkreV2kXr/504QUZVWFLWq7GfnQZ0OTPf6lsLW0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=He1QdD20Fdn2xi3A1mH5CktcwHA1uEITODTdUVg7OPzLgs1aCzxxDqDBBs1NYD7YqpxuUpYswBWta/LoxdeqOyyRgzAJbDUGOVlTqMzUP5U3spSDXre6zmpVcT6kMkDbjsQ7ktWJehp/cc5NbcIGTeqUetNFkMWkVwJJgJuM1i8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7FD6712FC;
	Fri, 29 Nov 2024 04:19:12 -0800 (PST)
Received: from [10.57.92.242] (unknown [10.57.92.242])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7A0613F5A1;
	Fri, 29 Nov 2024 04:18:38 -0800 (PST)
Message-ID: <7d1d4893-f798-4e44-aad0-1d0071e30b05@arm.com>
Date: Fri, 29 Nov 2024 12:18:36 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 18/43] arm64: RME: Handle realm enter/exit
To: Suzuki K Poulose <suzuki.poulose@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>
References: <20241004152804.72508-1-steven.price@arm.com>
 <20241004152804.72508-19-steven.price@arm.com>
 <c44aeac6-4fe1-4199-962d-5fbbc5a591de@arm.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <c44aeac6-4fe1-4199-962d-5fbbc5a591de@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Suzuki,

Sorry for the very slow response to this. Coming back to this I'm having
doubts, see below.

On 17/10/2024 14:00, Suzuki K Poulose wrote:
> On 04/10/2024 16:27, Steven Price wrote:
>> Entering a realm is done using a SMC call to the RMM. On exit the
>> exit-codes need to be handled slightly differently to the normal KVM
>> path so define our own functions for realm enter/exit and hook them
>> in if the guest is a realm guest.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
...
>> diff --git a/arch/arm64/kvm/rme-exit.c b/arch/arm64/kvm/rme-exit.c
>> new file mode 100644
>> index 000000000000..e96ea308212c
>> --- /dev/null
>> +++ b/arch/arm64/kvm/rme-exit.c
...
>> +static int rec_exit_ripas_change(struct kvm_vcpu *vcpu)
>> +{
>> +    struct kvm *kvm = vcpu->kvm;
>> +    struct realm *realm = &kvm->arch.realm;
>> +    struct realm_rec *rec = &vcpu->arch.rec;
>> +    unsigned long base = rec->run->exit.ripas_base;
>> +    unsigned long top = rec->run->exit.ripas_top;
>> +    unsigned long ripas = rec->run->exit.ripas_value;
>> +    unsigned long top_ipa;
>> +    int ret;
>> +
>> +    if (!realm_is_addr_protected(realm, base) ||
>> +        !realm_is_addr_protected(realm, top - 1)) {
>> +        kvm_err("Invalid RIPAS_CHANGE for %#lx - %#lx, ripas: %#lx\n",
>> +            base, top, ripas);
>> +        return -EINVAL;
>> +    }
>> +
>> +    kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_page_cache,
>> +                   kvm_mmu_cache_min_pages(vcpu->arch.hw_mmu));
> 
> I think we also need to filter the request for RIPAS_RAM, by consulting
> if the "range" is backed by a memslot or not. If they are not, we should
> reject the request with a response flag set in run.enter.flags.

It's an interesting API question. At the moment there is no requirement
to have an active memslot to set the RIPAS - this is true both during
the setup by the VMM and at run time.

In theory a VMM can create/destroy memslots while the guest is running.
So absense of a memslot doesn't actually imply that the RIPAS change
should be rejected. Obviously with realms this is tricky because when
destroying a memslot that's in use KVM would rip those pages out from
the guest and it would require guest cooperation to restore those pages
(transition to RIPAS_EMPTY and back to RIPAS_RAM). But it's not
something that has been prohibited so far.

On the other hand this is a clear way for a (malicious/buggy) guest to
use a fair bit of RAM by transitioning to RIPAS_RAM (sparse) pages not
in a memslot and forcing KVM to allocate the RTT pages to delegate to
the RMM. But we do exit to the VMM, so this is solvable in the VMM (by
killing a misbehaving guest). The number of pages this would consume per
exit is also fairly small.

So my instinct is that we shouldn't impose that requirement.

Any thoughts?

> As for EMPTY requests, if the guest wants to explicitly mark any range
> as EMPTY, it doesn't matter, as long as it is within the protected IPA.
> (even though they may be EMPTY in the first place).
> 
>> +    write_lock(&kvm->mmu_lock);
>> +    ret = realm_set_ipa_state(vcpu, base, top, ripas, &top_ipa);
>> +    write_unlock(&kvm->mmu_lock);
>> +
>> +    WARN(ret && ret != -ENOMEM,
>> +         "Unable to satisfy RIPAS_CHANGE for %#lx - %#lx, ripas:
>> %#lx\n",
>> +         base, top, ripas);
>> +
>> +    /* Exit to VMM to complete the change */
>> +    kvm_prepare_memory_fault_exit(vcpu, base, top_ipa - base, false,
>> false,
>> +                      ripas == RMI_RAM);
> 
> Again this may only be need if the range is backed by a memslot ?
> Otherwise the VMM has nothing to do.

Assuming the above, then the VMM would be the one to kill a misbehaving
guest, so would need a notification.

Thanks,
Steve

>> +
>> +    return 0;
>> +}
>> +
>> +static void update_arch_timer_irq_lines(struct kvm_vcpu *vcpu)
>> +{
>> +    struct realm_rec *rec = &vcpu->arch.rec;
>> +
>> +    __vcpu_sys_reg(vcpu, CNTV_CTL_EL0) = rec->run->exit.cntv_ctl;
>> +    __vcpu_sys_reg(vcpu, CNTV_CVAL_EL0) = rec->run->exit.cntv_cval;
>> +    __vcpu_sys_reg(vcpu, CNTP_CTL_EL0) = rec->run->exit.cntp_ctl;
>> +    __vcpu_sys_reg(vcpu, CNTP_CVAL_EL0) = rec->run->exit.cntp_cval;
>> +
>> +    kvm_realm_timers_update(vcpu);
>> +}
>> +
>> +/*
>> + * Return > 0 to return to guest, < 0 on error, 0 (and set
>> exit_reason) on
>> + * proper exit to userspace.
>> + */
>> +int handle_rec_exit(struct kvm_vcpu *vcpu, int rec_run_ret)
>> +{
>> +    struct realm_rec *rec = &vcpu->arch.rec;
>> +    u8 esr_ec = ESR_ELx_EC(rec->run->exit.esr);
>> +    unsigned long status, index;
>> +
>> +    status = RMI_RETURN_STATUS(rec_run_ret);
>> +    index = RMI_RETURN_INDEX(rec_run_ret);
>> +
>> +    /*
>> +     * If a PSCI_SYSTEM_OFF request raced with a vcpu executing, we
>> might
>> +     * see the following status code and index indicating an attempt
>> to run
>> +     * a REC when the RD state is SYSTEM_OFF.  In this case, we just
>> need to
>> +     * return to user space which can deal with the system event or
>> will try
>> +     * to run the KVM VCPU again, at which point we will no longer
>> attempt
>> +     * to enter the Realm because we will have a sleep request
>> pending on
>> +     * the VCPU as a result of KVM's PSCI handling.
>> +     */
>> +    if (status == RMI_ERROR_REALM && index == 1) {
>> +        vcpu->run->exit_reason = KVM_EXIT_UNKNOWN;
>> +        return 0;
>> +    }
>> +
>> +    if (rec_run_ret)
>> +        return -ENXIO;
>> +
>> +    vcpu->arch.fault.esr_el2 = rec->run->exit.esr;
>> +    vcpu->arch.fault.far_el2 = rec->run->exit.far;
>> +    vcpu->arch.fault.hpfar_el2 = rec->run->exit.hpfar;
>> +
>> +    update_arch_timer_irq_lines(vcpu);
>> +
>> +    /* Reset the emulation flags for the next run of the REC */
>> +    rec->run->enter.flags = 0;
>> +
>> +    switch (rec->run->exit.exit_reason) {
>> +    case RMI_EXIT_SYNC:
>> +        return rec_exit_handlers[esr_ec](vcpu);
>> +    case RMI_EXIT_IRQ:
>> +    case RMI_EXIT_FIQ:
>> +        return 1;
>> +    case RMI_EXIT_PSCI:
>> +        return rec_exit_psci(vcpu);
>> +    case RMI_EXIT_RIPAS_CHANGE:
>> +        return rec_exit_ripas_change(vcpu);
>> +    }
>> +
>> +    kvm_pr_unimpl("Unsupported exit reason: %u\n",
>> +              rec->run->exit.exit_reason);
>> +    vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
>> +    return 0;
>> +}
>> diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
>> index 1fa9991d708b..4c0751231810 100644
>> --- a/arch/arm64/kvm/rme.c
>> +++ b/arch/arm64/kvm/rme.c
>> @@ -899,6 +899,25 @@ void kvm_destroy_realm(struct kvm *kvm)
>>       kvm_free_stage2_pgd(&kvm->arch.mmu);
>>   }
>>   +int kvm_rec_enter(struct kvm_vcpu *vcpu)
>> +{
>> +    struct realm_rec *rec = &vcpu->arch.rec;
>> +
>> +    switch (rec->run->exit.exit_reason) {
>> +    case RMI_EXIT_HOST_CALL:
>> +    case RMI_EXIT_PSCI:
>> +        for (int i = 0; i < REC_RUN_GPRS; i++)
>> +            rec->run->enter.gprs[i] = vcpu_get_reg(vcpu, i);
>> +        break;
>> +    }
> 
> As mentioned in the patch following (MMIO emulation support), we may be
> able to do this unconditionally for all REC entries, to cover ourselves
> from missing out other cases. The RMM is in charge of taking the
> appropriate action anyways to copy the results back.
> 
> Suzuki
> 
>> +
>> +    if (kvm_realm_state(vcpu->kvm) != REALM_STATE_ACTIVE)
>> +        return -EINVAL;
>> +
>> +    return rmi_rec_enter(virt_to_phys(rec->rec_page),
>> +                 virt_to_phys(rec->run));
>> +}
>> +
>>   static void free_rec_aux(struct page **aux_pages,
>>                unsigned int num_aux)
>>   {


