Return-Path: <kvm+bounces-48177-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C411ACB878
	for <lists+kvm@lfdr.de>; Mon,  2 Jun 2025 17:42:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B3AF7402EC4
	for <lists+kvm@lfdr.de>; Mon,  2 Jun 2025 15:18:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D63D22D9E7;
	Mon,  2 Jun 2025 15:14:54 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D526122D780;
	Mon,  2 Jun 2025 15:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748877293; cv=none; b=fV9a6BlVTvCMrBqUXmvklbxvvNcp5uU6ydgpvEsN3VrjwlVg1/HnYi8ehPgZBpUoG+0AtQi+TCHcrD/9ZARyiB6Te4I2Oz4G1CB4rPM34A1AeNmVcIDzq+dDv6HXIZfXrdolYKP6rBBUIu70AADawt/gtQvDjZtJ7aWG/S8oFq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748877293; c=relaxed/simple;
	bh=Szo9uGF0rg5w3SBDMgWbGMqvVdF5MMEJIQ0W/n76qhE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=i0gq/WByOk20mvmZ4Fw4EwTboOmlEWZNb6ftMoISz03JBBrtk8JfQAUpWDdPx8OG9hiDlgrMOhBdslCURLrHG2jqr6bG8gaPHcU3oFvvjObNVWCHYzO17Z7v3rt5DtZGC0YU2KmNV4CKLpmh4yyIYbpZAYqqoXgmm4en2CDfbF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id ABBED1424;
	Mon,  2 Jun 2025 08:14:34 -0700 (PDT)
Received: from [10.57.64.248] (unknown [10.57.64.248])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 22FDA3F5A1;
	Mon,  2 Jun 2025 08:14:46 -0700 (PDT)
Message-ID: <673853c4-b7b0-4a7f-915e-37646ae8cf6f@arm.com>
Date: Mon, 2 Jun 2025 16:14:45 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 16/43] arm64: RME: Handle realm enter/exit
To: "Emi Kisanuki (Fujitsu)" <fj0570is@fujitsu.com>,
 "'kvm@vger.kernel.org'" <kvm@vger.kernel.org>,
 "'kvmarm@lists.linux.dev'" <kvmarm@lists.linux.dev>
Cc: 'Catalin Marinas' <catalin.marinas@arm.com>,
 'Marc Zyngier' <maz@kernel.org>, 'Will Deacon' <will@kernel.org>,
 'James Morse' <james.morse@arm.com>, 'Oliver Upton'
 <oliver.upton@linux.dev>, 'Suzuki K Poulose' <suzuki.poulose@arm.com>,
 'Zenghui Yu' <yuzenghui@huawei.com>,
 "'linux-arm-kernel@lists.infradead.org'"
 <linux-arm-kernel@lists.infradead.org>,
 "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
 'Joey Gouly' <joey.gouly@arm.com>,
 'Alexandru Elisei' <alexandru.elisei@arm.com>,
 'Christoffer Dall' <christoffer.dall@arm.com>,
 'Fuad Tabba' <tabba@google.com>,
 "'linux-coco@lists.linux.dev'" <linux-coco@lists.linux.dev>,
 'Ganapatrao Kulkarni' <gankulkarni@os.amperecomputing.com>,
 'Gavin Shan' <gshan@redhat.com>,
 'Shanker Donthineni' <sdonthineni@nvidia.com>,
 'Alper Gun' <alpergun@google.com>,
 "'Aneesh Kumar K . V'" <aneesh.kumar@kernel.org>
References: <20250416134208.383984-1-steven.price@arm.com>
 <20250416134208.383984-17-steven.price@arm.com>
 <TYCPR01MB11463D8002D90705A7F860B85C366A@TYCPR01MB11463.jpnprd01.prod.outlook.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <TYCPR01MB11463D8002D90705A7F860B85C366A@TYCPR01MB11463.jpnprd01.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 29/05/2025 05:52, Emi Kisanuki (Fujitsu) wrote:
> Hello, I comment below.

Hi Emi,

>> Subject: [PATCH v8 16/43] arm64: RME: Handle realm enter/exit
>>
>> Entering a realm is done using a SMC call to the RMM. On exit the exit-codes
>> need to be handled slightly differently to the normal KVM path so define our own
>> functions for realm enter/exit and hook them in if the guest is a realm guest.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---

[..]

>> +/*
>> + * Return > 0 to return to guest, < 0 on error, 0 (and set exit_reason)
>> +on
>> + * proper exit to userspace.
>> + */
>> +int handle_rec_exit(struct kvm_vcpu *vcpu, int rec_run_ret) {
>> +	struct realm_rec *rec = &vcpu->arch.rec;
>> +	u8 esr_ec = ESR_ELx_EC(rec->run->exit.esr);
>> +	unsigned long status, index;
>> +
>> +	status = RMI_RETURN_STATUS(rec_run_ret);
>> +	index = RMI_RETURN_INDEX(rec_run_ret);
>> +
>> +	/*
>> +	 * If a PSCI_SYSTEM_OFF request raced with a vcpu executing, we
>> might
>> +	 * see the following status code and index indicating an attempt to run
>> +	 * a REC when the RD state is SYSTEM_OFF.  In this case, we just need
>> to
>> +	 * return to user space which can deal with the system event or will try
>> +	 * to run the KVM VCPU again, at which point we will no longer attempt
>> +	 * to enter the Realm because we will have a sleep request pending on
>> +	 * the VCPU as a result of KVM's PSCI handling.
>> +	 */
>> +	if (status == RMI_ERROR_REALM && index == 1) {
>> +		vcpu->run->exit_reason = KVM_EXIT_UNKNOWN;
>> +		return 0;
>> +	}
> Running kvm-unit-tests-cca selftest(smp) test in quick succession may trigger these conditions, resulting in the following error logs.
>  Error: KVM exit reason: 0 ("KVM_EXIT_UNKNOWN")
> 
> Since KVM_EXIT_UNKNOWN is used when no specific exit reason applies, I think it would be better to make it identifiable as an error.
> How about adding and setting a new ARM64 exit_reason value to indicate that the PSCI_SYSTEM_OFF request is conflicting with a running vcpu?

Aneesh pointed this out to me off-list. We agreed that KVM_EXIT_SHUTDOWN
was more appropriate here. I'll make the change for v9.

Thanks,
Steve

> Best Regards,
> Emi Kisanuki
>> +
>> +	if (rec_run_ret)
>> +		return -ENXIO;
>> +
>> +	vcpu->arch.fault.esr_el2 = rec->run->exit.esr;
>> +	vcpu->arch.fault.far_el2 = rec->run->exit.far;
>> +	vcpu->arch.fault.hpfar_el2 = rec->run->exit.hpfar;
>> +
>> +	update_arch_timer_irq_lines(vcpu);
>> +
>> +	/* Reset the emulation flags for the next run of the REC */
>> +	rec->run->enter.flags = 0;
>> +
>> +	switch (rec->run->exit.exit_reason) {
>> +	case RMI_EXIT_SYNC:
>> +		return rec_exit_handlers[esr_ec](vcpu);
>> +	case RMI_EXIT_IRQ:
>> +	case RMI_EXIT_FIQ:
>> +		return 1;
>> +	case RMI_EXIT_PSCI:
>> +		return rec_exit_psci(vcpu);
>> +	case RMI_EXIT_RIPAS_CHANGE:
>> +		return rec_exit_ripas_change(vcpu);
>> +	}
>> +
>> +	kvm_pr_unimpl("Unsupported exit reason: %u\n",
>> +		      rec->run->exit.exit_reason);
>> +	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
>> +	return 0;
>> +}
>> diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c index
>> 33eb793d8bdb..bee9dfe12e03 100644
>> --- a/arch/arm64/kvm/rme.c
>> +++ b/arch/arm64/kvm/rme.c
>> @@ -863,6 +863,25 @@ void kvm_destroy_realm(struct kvm *kvm)
>>  	kvm_free_stage2_pgd(&kvm->arch.mmu);
>>  }
>>
>> +int kvm_rec_enter(struct kvm_vcpu *vcpu) {
>> +	struct realm_rec *rec = &vcpu->arch.rec;
>> +
>> +	switch (rec->run->exit.exit_reason) {
>> +	case RMI_EXIT_HOST_CALL:
>> +	case RMI_EXIT_PSCI:
>> +		for (int i = 0; i < REC_RUN_GPRS; i++)
>> +			rec->run->enter.gprs[i] = vcpu_get_reg(vcpu, i);
>> +		break;
>> +	}
>> +
>> +	if (kvm_realm_state(vcpu->kvm) != REALM_STATE_ACTIVE)
>> +		return -EINVAL;
>> +
>> +	return rmi_rec_enter(virt_to_phys(rec->rec_page),
>> +			     virt_to_phys(rec->run));
>> +}
>> +
>>  static void free_rec_aux(struct page **aux_pages,
>>  			 unsigned int num_aux)
>>  {
>> --
>> 2.43.0
>>
> 


