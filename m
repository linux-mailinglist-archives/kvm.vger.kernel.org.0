Return-Path: <kvm+bounces-48178-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C9FFAACB7FA
	for <lists+kvm@lfdr.de>; Mon,  2 Jun 2025 17:34:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 94AC21BC4528
	for <lists+kvm@lfdr.de>; Mon,  2 Jun 2025 15:21:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34A6B2253B0;
	Mon,  2 Jun 2025 15:16:50 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44DA21FF61E;
	Mon,  2 Jun 2025 15:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748877409; cv=none; b=JbJ4bzkp6PrZyoSaIBkatA76Jq5HB8+J1lp4AfdzF8KvPgOMtBLgCq/guNcj2PjI6EzZWsx4g/E0R2dQcMyUk4R3anUiTnJ78JTu6p2yeJnITRNVnngtC5YFHPspifT/5gqWJR1E8o+6OhunXy+8wyuI9p4aXB+sprjYbFes29E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748877409; c=relaxed/simple;
	bh=/+njjjjeknWT+7eViUtPJz6TBdiNujnF97CGeFdxBgk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pKUfmBttYHvrprnGR1+6sNGMzxXHhuvMJhVKxgLvbFyPSkG5fPdwJpzQaAcyuI4i+ccaKTly/+gEi3+XEs2HeTNpFus/EDlc3ZnUSXckDCfQtnHwQvBYQh4bEQoJOvfOGyGn5FTNXLYdPctNTSfciW6oQBCGUD2h2Bu3qUvkyLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AC8071424;
	Mon,  2 Jun 2025 08:16:30 -0700 (PDT)
Received: from [10.57.47.191] (unknown [10.57.47.191])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 0BC4E3F5A1;
	Mon,  2 Jun 2025 08:16:43 -0700 (PDT)
Message-ID: <8a4c285e-2b6f-44f0-b1d8-0b5a6f6b6581@arm.com>
Date: Mon, 2 Jun 2025 16:16:43 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 16/43] arm64: RME: Handle realm enter/exit
Content-Language: en-GB
To: Steven Price <steven.price@arm.com>,
 "Emi Kisanuki (Fujitsu)" <fj0570is@fujitsu.com>,
 "'kvm@vger.kernel.org'" <kvm@vger.kernel.org>,
 "'kvmarm@lists.linux.dev'" <kvmarm@lists.linux.dev>
Cc: 'Catalin Marinas' <catalin.marinas@arm.com>,
 'Marc Zyngier' <maz@kernel.org>, 'Will Deacon' <will@kernel.org>,
 'James Morse' <james.morse@arm.com>, 'Oliver Upton'
 <oliver.upton@linux.dev>, 'Zenghui Yu' <yuzenghui@huawei.com>,
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
 <673853c4-b7b0-4a7f-915e-37646ae8cf6f@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <673853c4-b7b0-4a7f-915e-37646ae8cf6f@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 02/06/2025 16:14, Steven Price wrote:
> On 29/05/2025 05:52, Emi Kisanuki (Fujitsu) wrote:
>> Hello, I comment below.
> 
> Hi Emi,
> 
>>> Subject: [PATCH v8 16/43] arm64: RME: Handle realm enter/exit
>>>
>>> Entering a realm is done using a SMC call to the RMM. On exit the exit-codes
>>> need to be handled slightly differently to the normal KVM path so define our own
>>> functions for realm enter/exit and hook them in if the guest is a realm guest.
>>>
>>> Signed-off-by: Steven Price <steven.price@arm.com>
>>> ---
> 
> [..]
> 
>>> +/*
>>> + * Return > 0 to return to guest, < 0 on error, 0 (and set exit_reason)
>>> +on
>>> + * proper exit to userspace.
>>> + */
>>> +int handle_rec_exit(struct kvm_vcpu *vcpu, int rec_run_ret) {
>>> +	struct realm_rec *rec = &vcpu->arch.rec;
>>> +	u8 esr_ec = ESR_ELx_EC(rec->run->exit.esr);
>>> +	unsigned long status, index;
>>> +
>>> +	status = RMI_RETURN_STATUS(rec_run_ret);
>>> +	index = RMI_RETURN_INDEX(rec_run_ret);
>>> +
>>> +	/*
>>> +	 * If a PSCI_SYSTEM_OFF request raced with a vcpu executing, we
>>> might
>>> +	 * see the following status code and index indicating an attempt to run
>>> +	 * a REC when the RD state is SYSTEM_OFF.  In this case, we just need
>>> to
>>> +	 * return to user space which can deal with the system event or will try
>>> +	 * to run the KVM VCPU again, at which point we will no longer attempt
>>> +	 * to enter the Realm because we will have a sleep request pending on
>>> +	 * the VCPU as a result of KVM's PSCI handling.
>>> +	 */
>>> +	if (status == RMI_ERROR_REALM && index == 1) {
>>> +		vcpu->run->exit_reason = KVM_EXIT_UNKNOWN;
>>> +		return 0;
>>> +	}
>> Running kvm-unit-tests-cca selftest(smp) test in quick succession may trigger these conditions, resulting in the following error logs.
>>   Error: KVM exit reason: 0 ("KVM_EXIT_UNKNOWN")
>>
>> Since KVM_EXIT_UNKNOWN is used when no specific exit reason applies, I think it would be better to make it identifiable as an error.
>> How about adding and setting a new ARM64 exit_reason value to indicate that the PSCI_SYSTEM_OFF request is conflicting with a running vcpu?
> 
> Aneesh pointed this out to me off-list. We agreed that KVM_EXIT_SHUTDOWN
> was more appropriate here. I'll make the change for v9.

Sounds good to me

Cheers
Suzuki


