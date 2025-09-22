Return-Path: <kvm+bounces-58363-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 74D2AB8F556
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 09:46:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2F5803AC555
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 07:46:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F00042F60C2;
	Mon, 22 Sep 2025 07:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="I2flsy/b"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EE37182B4;
	Mon, 22 Sep 2025 07:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758527206; cv=none; b=ebJ6H6hY6uwXXXJZRM8q9B8QNH8n6FVpOO3XETQrNuAHCrLQ0iogs90AbdJgZH79FJP5kQOt4XdxoI3SzEdACEo8PcGqg8aqSE250VrpFQrIbK+yikDM33r523NDluVcxs04H8WzutvCCd4jG8WzRgs6XyK5K0T1LByAOQmzg1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758527206; c=relaxed/simple;
	bh=OsMg3MN5TISzpxmH61wHFj+M6YuHHWi4M2vXXj+Sy7c=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=hbYFrec/6YuFI+SVlNuOUykUrlyirViuLe4uLMtkGLGXhpekFP2wR/l3v9Z1iORiSZu3xTS0kxS8vc8b4K76EwOqoRrYdyX5jByJlHkeLDfaERATZpyf2ZvFWlD8QNl12o5RlbXpPbwATFyEgSqyVBDKJ16g1UFj3I5F1uyOoI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=I2flsy/b; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758527204; x=1790063204;
  h=message-id:date:mime-version:subject:from:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=OsMg3MN5TISzpxmH61wHFj+M6YuHHWi4M2vXXj+Sy7c=;
  b=I2flsy/bcXOw5AOw7+MPIzTY4M1BkoEungAeitmPKbbssjBsF88drOjs
   kZkdrWOO/z4jiNwiXvr6ShPmiKnA1jx1TRllsclgi8hwmVIKp0WT67ThK
   YzZNHVn6KfbCgX+RaZtNdUzYsKFO8wAg7yrat378eemZhUUiIjybJ/gIU
   WOGM/Wz91TsI5n+xLLf83kTflnIcqiLVvyEPSK1OscHUHky4pS8QfFKzl
   JbtcFKueDt3/GZdCERziOc9g6cSlQDkMDZe8AphYaFANb08McfL9KsqHb
   Rim4/zevS/lEymZA0xzY01mcRdeLTJUKvyAiGxmlizJESgYDiGXoRcZy6
   g==;
X-CSE-ConnectionGUID: uR3ONqPSSgupAvUnM3oFdg==
X-CSE-MsgGUID: iiwYixXRSDS2b0IPXVR6Aw==
X-IronPort-AV: E=McAfee;i="6800,10657,11560"; a="60900963"
X-IronPort-AV: E=Sophos;i="6.18,284,1751266800"; 
   d="scan'208";a="60900963"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 00:46:43 -0700
X-CSE-ConnectionGUID: HxVEPtk8Sx6g+4KrqgZMUQ==
X-CSE-MsgGUID: U7wrw6ylT8GsugZel8EpFg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,284,1751266800"; 
   d="scan'208";a="175540003"
Received: from unknown (HELO [10.238.0.107]) ([10.238.0.107])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 00:46:41 -0700
Message-ID: <b12cac74-5a08-4338-bbab-510860e11a30@linux.intel.com>
Date: Mon, 22 Sep 2025 15:46:37 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 21/51] KVM: x86/mmu: WARN on attempt to check
 permissions for Shadow Stack #PF
From: Binbin Wu <binbin.wu@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
 Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, Chao Gao <chao.gao@intel.com>,
 Xiaoyao Li <xiaoyao.li@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>,
 Zhang Yi Z <yi.z.zhang@linux.intel.com>, Xin Li <xin@zytor.com>
References: <20250919223258.1604852-1-seanjc@google.com>
 <20250919223258.1604852-22-seanjc@google.com>
 <8b91ca86-6301-4645-a9c2-c2de3a16327c@linux.intel.com>
Content-Language: en-US
In-Reply-To: <8b91ca86-6301-4645-a9c2-c2de3a16327c@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 9/22/2025 3:17 PM, Binbin Wu wrote:
>
>
> On 9/20/2025 6:32 AM, Sean Christopherson wrote:
>> Add PFERR_SS_MASK, a.k.a. Shadow Stack access, and WARN if KVM attempts to
>> check permissions for a Shadow Stack access as KVM hasn't been taught to
>> understand the magic Writable=0,Dirty=0 combination that is required for
Typo:

Writable=0,Dirty=0 -> Writable=0,Dirty=1

>> Shadow Stack accesses, and likely will never learn.  There are no plans to
>> support Shadow Stacks with the Shadow MMU, and the emulator rejects all
>> instructions that affect Shadow Stacks, i.e. it should be impossible for
>> KVM to observe a #PF due to a shadow stack access.
>>
>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>
> Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
>
>> ---
>>   arch/x86/include/asm/kvm_host.h | 1 +
>>   arch/x86/kvm/mmu.h              | 2 +-
>>   2 files changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index 7a7e6356a8dd..554d83ff6135 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -267,6 +267,7 @@ enum x86_intercept_stage;
>>   #define PFERR_RSVD_MASK        BIT(3)
>>   #define PFERR_FETCH_MASK    BIT(4)
>>   #define PFERR_PK_MASK        BIT(5)
>> +#define PFERR_SS_MASK        BIT(6)
>>   #define PFERR_SGX_MASK        BIT(15)
>>   #define PFERR_GUEST_RMP_MASK    BIT_ULL(31)
>>   #define PFERR_GUEST_FINAL_MASK    BIT_ULL(32)
>> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
>> index b4b6860ab971..f63074048ec6 100644
>> --- a/arch/x86/kvm/mmu.h
>> +++ b/arch/x86/kvm/mmu.h
>> @@ -212,7 +212,7 @@ static inline u8 permission_fault(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
>>         fault = (mmu->permissions[index] >> pte_access) & 1;
>>   -    WARN_ON(pfec & (PFERR_PK_MASK | PFERR_RSVD_MASK));
>> +    WARN_ON_ONCE(pfec & (PFERR_PK_MASK | PFERR_SS_MASK | PFERR_RSVD_MASK));
>>       if (unlikely(mmu->pkru_mask)) {
>>           u32 pkru_bits, offset;
>
>


