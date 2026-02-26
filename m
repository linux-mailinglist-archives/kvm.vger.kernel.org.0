Return-Path: <kvm+bounces-72008-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iBqEENteoGlViwQAu9opvQ
	(envelope-from <kvm+bounces-72008-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 15:55:23 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E25F1A80F9
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 15:55:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B9EEE300A386
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 14:50:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0581436CDE7;
	Thu, 26 Feb 2026 14:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="rbCWqsHs"
X-Original-To: kvm@vger.kernel.org
Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4035C3D7D8D;
	Thu, 26 Feb 2026 14:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772117394; cv=none; b=jBaeA8c/a8ZTry8ki37Et7BhD+Rb9Jy8xthziycszA1OJmmaOdzxstqcEbuKQmrdr19Z36oQUxHyIsLYcjMVTr9QrpdAaxF/XmXrfhDcrBDusJ2jS+L3CrMqpGcwPRLwMLAMkAqCzuyjKcv1WE9j4atddT5EPiVNyPKSbV8R1vM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772117394; c=relaxed/simple;
	bh=/15qPyBuQ3dXpDw8Gn7bjA123PLklU0X7oz6AxFesOg=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=cwYaAzkzFqgJYP7nq8ZJfqI4eQktMOtIfwaPOS2KHP8mOJwZ8jFKBnvFR93hNK3CJXZMMaLnsCcAEgl077SxiwrJPB0FNuAh9xoXdQ2p6C+0SiRGK/J2ohi/JwC7Xfk2xwdFFIGoNwVkeyzEF4j+m9mHdqOplD/9DTx7XRdZJ/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=fail (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=rbCWqsHs reason="key not found in DNS"; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Received: from [192.168.10.111] (p865013-ipoe.ipoe.ocn.ne.jp [153.242.222.12])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 61QEhMY7067270
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Thu, 26 Feb 2026 23:43:40 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=8U6yxzdjHPJtMPBuIvp6F14KKaiWFcbdjaF+l9vhFiI=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=From:Message-ID:To:Subject:Date;
        s=rs20250326; t=1772117020; v=1;
        b=rbCWqsHs8qkR6pEdW97cLAFO0Ot06Rag+z/McXKclYvbL+T77+rFesyNtzSiVXvH
         7jF3qzzM6bnqtpmwPbdKeansx5vJoCirV9AN+Z2gkS14Baf1Vfsz1ihODsx1/43h
         q/GygGV7h8fymcUC8xP2ah9xzOrzU25GEIt89iWGLpEFXsZ1E4KX4C9G+gtU13aU
         Wnt/4+y0At3KxDSjC3JmAs0zeqtmf+hF19RVvKsxaZ2Cb5MOOiuYei0/OuHwSGZP
         O5LyQvp9qqTax+U+eF1HOVuwg/K1KxvT6ZR4xMvb+hoKfRW4bWnvza/8JdWLWE/g
         poBoZEw7feXAlNJmErX89Q==
Message-ID: <fbcadab4-676b-44e4-8afa-b8bd095f8981@rsg.ci.i.u-tokyo.ac.jp>
Date: Thu, 26 Feb 2026 23:43:21 +0900
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Subject: Re: [PATCH v3 1/2] KVM: arm64: PMU: Introduce FIXED_COUNTERS_ONLY
To: Oliver Upton <oupton@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu
 <yuzenghui@huawei.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Kees Cook <kees@kernel.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
        Shuah Khan <shuah@kernel.org>, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org, devel@daynix.com, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <20260225-hybrid-v3-0-46e8fe220880@rsg.ci.i.u-tokyo.ac.jp>
 <20260225-hybrid-v3-1-46e8fe220880@rsg.ci.i.u-tokyo.ac.jp>
 <aaA0gn9O8QAf9Gpu@kernel.org>
Content-Language: en-US
In-Reply-To: <aaA0gn9O8QAf9Gpu@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.36 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	DMARC_POLICY_SOFTFAIL(0.10)[u-tokyo.ac.jp : SPF not aligned (relaxed),none];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[20];
	TAGGED_FROM(0.00)[bounces-72008-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	R_DKIM_PERMFAIL(0.00)[rsg.ci.i.u-tokyo.ac.jp:s=rs20250326];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[rsg.ci.i.u-tokyo.ac.jp:~];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[odaki@rsg.ci.i.u-tokyo.ac.jp,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-0.909];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[rsg.ci.i.u-tokyo.ac.jp:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 8E25F1A80F9
X-Rspamd-Action: no action

On 2026/02/26 20:54, Oliver Upton wrote:
> Hi Akihiko,
> 
> On Wed, Feb 25, 2026 at 01:31:15PM +0900, Akihiko Odaki wrote:
>> @@ -629,6 +629,8 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>>   		kvm_vcpu_load_vhe(vcpu);
>>   	kvm_arch_vcpu_load_fp(vcpu);
>>   	kvm_vcpu_pmu_restore_guest(vcpu);
>> +	if (test_bit(KVM_ARCH_FLAG_PMU_V3_FIXED_COUNTERS_ONLY, &vcpu->kvm->arch.flags))
>> +		kvm_make_request(KVM_REQ_CREATE_PMU, vcpu);
> 
> We only need to set the request if the vCPU has migrated to a different
> PMU implementation, no?

Indeed. I was too lazy to implement such a check since it won't affect 
performance unless the new feature is requested, but having one may be 
still nice.

> 
>>   	if (kvm_arm_is_pvtime_enabled(&vcpu->arch))
>>   		kvm_make_request(KVM_REQ_RECORD_STEAL, vcpu);
>>   
>> @@ -1056,6 +1058,9 @@ static int check_vcpu_requests(struct kvm_vcpu *vcpu)
>>   		if (kvm_check_request(KVM_REQ_RELOAD_PMU, vcpu))
>>   			kvm_vcpu_reload_pmu(vcpu);
>>   
>> +		if (kvm_check_request(KVM_REQ_CREATE_PMU, vcpu))
>> +			kvm_vcpu_create_pmu(vcpu);
>> +
> 
> My strong preference would be to squash the migration handling into
> kvm_vcpu_reload_pmu(). It is already reprogramming PMU events in
> response to other things.

Can you share a reason for that?

In terms of complexity, I don't think it will help reducing complexity 
since the only common things between kvm_vcpu_reload_pmu() and 
kvm_vcpu_create_pmu() are the enumeration of enabled counters, which is 
simple enough.

In terms of performance, I guess it is better to keep 
kvm_vcpu_create_pmu() small since it is triggered for each migration.

> 
>>   		if (kvm_check_request(KVM_REQ_RESYNC_PMU_EL0, vcpu))
>>   			kvm_vcpu_pmu_restore_guest(vcpu);
>>   
>> @@ -1516,7 +1521,8 @@ static int kvm_setup_vcpu(struct kvm_vcpu *vcpu)
>>   	 * When the vCPU has a PMU, but no PMU is set for the guest
>>   	 * yet, set the default one.
>>   	 */
>> -	if (kvm_vcpu_has_pmu(vcpu) && !kvm->arch.arm_pmu)
>> +	if (kvm_vcpu_has_pmu(vcpu) && !kvm->arch.arm_pmu &&
>> +	    !test_bit(KVM_ARCH_FLAG_PMU_V3_FIXED_COUNTERS_ONLY, &kvm->arch.flags))
>>   		ret = kvm_arm_set_default_pmu(kvm);
> 
> I'd rather just initialize it to a default than have to deal with the
> field being sometimes null.

I agree. I'll change this with the next version.

> 
>> -static bool kvm_pmu_counter_is_enabled(struct kvm_pmc *pmc)
>> +static u64 kvm_pmu_enabled_counter_mask(struct kvm_vcpu *vcpu)
>>   {
>> -	struct kvm_vcpu *vcpu = kvm_pmc_to_vcpu(pmc);
>> -	unsigned int mdcr = __vcpu_sys_reg(vcpu, MDCR_EL2);
>> +	u64 mask = 0;
>>   
>> -	if (!(__vcpu_sys_reg(vcpu, PMCNTENSET_EL0) & BIT(pmc->idx)))
>> -		return false;
>> +	if (__vcpu_sys_reg(vcpu, MDCR_EL2) & MDCR_EL2_HPME)
>> +		mask |= kvm_pmu_hyp_counter_mask(vcpu);
>>   
>> -	if (kvm_pmu_counter_is_hyp(vcpu, pmc->idx))
>> -		return mdcr & MDCR_EL2_HPME;
>> +	if (kvm_vcpu_read_pmcr(vcpu) & ARMV8_PMU_PMCR_E)
>> +		mask |= ~kvm_pmu_hyp_counter_mask(vcpu);
>>   
>> -	return kvm_vcpu_read_pmcr(vcpu) & ARMV8_PMU_PMCR_E;
>> +	return __vcpu_sys_reg(vcpu, PMCNTENSET_EL0) & mask;
>> +}
>> +
>> +static bool kvm_pmu_counter_is_enabled(struct kvm_pmc *pmc)
>> +{
>> +	struct kvm_vcpu *vcpu = kvm_pmc_to_vcpu(pmc);
>> +
>> +	return kvm_pmu_enabled_counter_mask(vcpu) & BIT(pmc->idx);
>>   }
> 
> You're churning a good bit of code, this needs to happen in a separate
> patch (if at all).

It makes sense. The next version will have a separate patch for this.

> 
>> @@ -689,6 +710,14 @@ static void kvm_pmu_create_perf_event(struct kvm_pmc *pmc)
>>   	int eventsel;
>>   	u64 evtreg;
>>   
>> +	if (!arm_pmu) {
>> +		arm_pmu = kvm_pmu_probe_armpmu(vcpu->cpu);
> 
> kvm_pmu_probe_armpmu() takes a global mutex, I'm not sure that's what we
> want.
> 
> What prevents us from opening a PERF_TYPE_RAW event and allowing perf to
> work out the right PMU for this CPU?

Unfortunately perf does not seem to have a capability to switch to the 
right PMU. tools/perf/Documentation/intel-hybrid.txt says the perf tool 
creates events for each PMU in a hybird configuration, for example.

> 
>> +		if (!arm_pmu) {
>> +			vcpu_set_on_unsupported_cpu(vcpu);
> 
> At this point it seems pretty late to flag the CPU as unsupported. Maybe
> instead we can compute the union cpumask for all the PMU implemetations
> the VM may schedule on.

This is just a safe guard and it is a responsibility of the userspace to 
schedule the VCPU properly. It is conceptually same with what 
kvm_arch_vcpu_load() does when migrating to an unsupported CPU.

> 
>> @@ -1249,6 +1299,10 @@ int kvm_arm_pmu_v3_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
>>   		irq = vcpu->arch.pmu.irq_num;
>>   		return put_user(irq, uaddr);
>>   	}
>> +	case KVM_ARM_VCPU_PMU_V3_FIXED_COUNTERS_ONLY:
>> +		lockdep_assert_held(&vcpu->kvm->arch.config_lock);
>> +		if (test_bit(KVM_ARCH_FLAG_PMU_V3_FIXED_COUNTERS_ONLY, &vcpu->kvm->arch.flags))
>> +			return 0;
> 
> We don't need a getter for this, userspace should remember how it
> provisioned the VM.

The getter is useful for debugging and testing. The selftest will use it 
to query the current state.

Regards,
Akihiko Odaki

