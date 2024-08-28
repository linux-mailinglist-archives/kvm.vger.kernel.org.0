Return-Path: <kvm+bounces-25301-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DD0C9634A5
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 00:24:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 932D81C2155B
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 22:24:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E4811AD9C6;
	Wed, 28 Aug 2024 22:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="H48H5uRx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f74.google.com (mail-io1-f74.google.com [209.85.166.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA1D9165F13
	for <kvm@vger.kernel.org>; Wed, 28 Aug 2024 22:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724883869; cv=none; b=W15MRFZQPwzIhgnF3N4fSsIx4+VHenPGDqPjE+Kt5qGCREtr03R7XyfyEBtybSHQA0ddsDlna7AdSfcvoMgQONqxKTUFW5Nrlx9gvus6LnPtH/ykD2N5rfU8NCUu3w1riTAjMbC1TnvPX+BNO7F7NUl1z3D/fRCLyoJCWArkNEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724883869; c=relaxed/simple;
	bh=/FVBdNtyaC5/bdSNVZaY3QGe9cC/Griq4Pzf7uJBcy8=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=P4kCQvi5/JTpHGP1fsODEBWiCcMWp6YTab5kFjzuUGsmPW75ME6r464+V86exY9CzSbLS/KCETqe3dX+0b1TRABUq9U9TWNgBjXAmYAbGhDHu4YPzSVhC7XliN8KzkXfRG7ZjC3fplMKiNdGSum59fCjo7Fpj2k3k830KSi3O6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=H48H5uRx; arc=none smtp.client-ip=209.85.166.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-io1-f74.google.com with SMTP id ca18e2360f4ac-8252a16781eso9151939f.0
        for <kvm@vger.kernel.org>; Wed, 28 Aug 2024 15:24:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724883866; x=1725488666; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=XHYhCs2O0yksxmyMVfjDVF3TT+HeTKA+kiWxfmzqVoQ=;
        b=H48H5uRxHrZB2x5tq3W9zLw2vlvJ7aBzqWapTkqRC+sXcxqQgg+ny3/oxORd/U60E9
         xzGMgK0aM7MynVCc6D8Rf2rmRho482ugpXvUmlxDWKpq9DAm+Z1LvYbDPInLkfjFPpkq
         qbXswWRUBNmW2Am6MOqFPoKXrbbtmTPqFN0yMZ/CKeR6SaOy+b85Pn/b9w6ODnAulogm
         Mpx9CZeQkNYDA9JuAwyjk/RV8AVN09ODD9I6HPWo7e6A2ldezjzVh5rP155mETJkrng8
         UdfY7O5Kh/8yrH3oHeKpGqbvYeMImU1zWijz+ETNqdbMtrg8dyzvkSvoL7ecjBlxuHcF
         GbDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724883866; x=1725488666;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XHYhCs2O0yksxmyMVfjDVF3TT+HeTKA+kiWxfmzqVoQ=;
        b=O/WAC+u7kSBxHqNcT+7YEr9E6JRqmyVoAlZEz0p3w67XQZUTFMet6/iO7D/5yRl8cW
         f4pCtALT+sq0WjGmwSPits5iGRoFcNYej23FB/ASjZt19So7GSQTX5h3ymMgPGiH9uzT
         r6EyCwSCd7S47KIyeNalejEk2f3vSKvk2NObdE42hz6/Q962GAPOSA/JWYNoOxkKVlAw
         B1QazvTNMSY6tAmt3VhiXHZsnlJx+cOvSsiiMtJmzRyFTnfs+a93wZMz85cee+C3AYoU
         2GJZ6jXDLCW9/6Lq3SBLcMrLkYKpjMwDLzjMJxZkrYkcfOcrn03S7axSjzKssSmZFL5Q
         whLA==
X-Gm-Message-State: AOJu0YwfnVnJ25oBJmJqO0I89NzAgxmLF8DJvIHkUTFg0B3UMqk6Zx11
	ZtU+O8Q+3BbQjYf9VE752a0ODRmSGJ0cA1Y2e27JUAn5PEjTJ0CAWntDu6ynoQpivri6iY4N/+2
	7+pHFgBixHKuHt9NK9rTuYg==
X-Google-Smtp-Source: AGHT+IFAhFfXyvt/CVO3KY8mV4BysnqtTjALoNCbyGNLAs/zZGUsWcIBtru/tMbAOpFzv3usnbCpVSZ5gXqQ1gaknw==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:6638:25c4:b0:4b9:b122:d07d with
 SMTP id 8926c6da1cb9f-4ced00465eemr27266173.4.1724883866023; Wed, 28 Aug 2024
 15:24:26 -0700 (PDT)
Date: Wed, 28 Aug 2024 22:24:25 +0000
In-Reply-To: <Zs0BSCb_Khyxg08x@google.com> (message from Mingwei Zhang on Mon,
 26 Aug 2024 22:27:20 +0000)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-ID: <gsntjzg09tgm.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH 2/6] KVM: x86: selftests: Define AMD PMU CPUID leaves
From: Colton Lewis <coltonlewis@google.com>
To: Mingwei Zhang <mizhang@google.com>
Cc: kvm@vger.kernel.org, ljr.kernel@gmail.com, jmattson@google.com, 
	aaronlewis@google.com, seanjc@google.com, pbonzini@redhat.com, 
	shuah@kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Hi Mingwei, thanks for reviewing!

Mingwei Zhang <mizhang@google.com> writes:

> On Tue, Aug 13, 2024, Colton Lewis wrote:
>> This defined the CPUID calls to determine what extensions and
>> properties are available. AMD reference manual names listed below.

>> * PerfCtrExtCore (six core counters instead of four)
>> * PerfCtrExtNB (four counters for northbridge events)
>> * PerfCtrExtL2I (four counters for L2 cache events)
>> * PerfMonV2 (support for registers to control multiple
>>    counters with a single register write)
>> * LbrAndPmcFreeze (support for freezing last branch recorded stack on
>>    performance counter overflow)
>> * NumPerfCtrCore (number of core counters)
>> * NumPerfCtrNB (number of northbridge counters)

>> Signed-off-by: Colton Lewis <coltonlewis@google.com>
>> ---
>>   tools/testing/selftests/kvm/include/x86_64/processor.h | 7 +++++++
>>   1 file changed, 7 insertions(+)

>> diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h  
>> b/tools/testing/selftests/kvm/include/x86_64/processor.h
>> index a0c1440017bb..9d87b5f8974f 100644
>> --- a/tools/testing/selftests/kvm/include/x86_64/processor.h
>> +++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
>> @@ -183,6 +183,9 @@ struct kvm_x86_cpu_feature {
>>   #define	X86_FEATURE_GBPAGES		KVM_X86_CPU_FEATURE(0x80000001, 0, EDX, 26)
>>   #define	X86_FEATURE_RDTSCP		KVM_X86_CPU_FEATURE(0x80000001, 0, EDX, 27)
>>   #define	X86_FEATURE_LM			KVM_X86_CPU_FEATURE(0x80000001, 0, EDX, 29)
>> +#define	X86_FEATURE_PERF_CTR_EXT_CORE	KVM_X86_CPU_FEATURE(0x80000001,  
>> 0, ECX, 23)
>> +#define	X86_FEATURE_PERF_CTR_EXT_NB	KVM_X86_CPU_FEATURE(0x80000001, 0,  
>> ECX, 24)
>> +#define	X86_FEATURE_PERF_CTR_EXT_L2I	KVM_X86_CPU_FEATURE(0x80000001, 0,  
>> ECX, 28)

> You won't be testing Northbridge counters and L2I counters, so these two
> could be optional to the patch.

That's correct. Since it was a small thing to include I thought it best
to include and save someone in the future from digging through the
reference manual again.

When you say "optional" is that an endorsement of deleting?

>>   #define	X86_FEATURE_INVTSC		KVM_X86_CPU_FEATURE(0x80000007, 0, EDX, 8)
>>   #define	X86_FEATURE_RDPRU		KVM_X86_CPU_FEATURE(0x80000008, 0, EBX, 4)
>>   #define	X86_FEATURE_AMD_IBPB		KVM_X86_CPU_FEATURE(0x80000008, 0, EBX,  
>> 12)
>> @@ -195,6 +198,8 @@ struct kvm_x86_cpu_feature {
>>   #define	X86_FEATURE_VGIF		KVM_X86_CPU_FEATURE(0x8000000A, 0, EDX, 16)
>>   #define X86_FEATURE_SEV			KVM_X86_CPU_FEATURE(0x8000001F, 0, EAX, 1)
>>   #define X86_FEATURE_SEV_ES		KVM_X86_CPU_FEATURE(0x8000001F, 0, EAX, 3)
>> +#define	X86_FEATURE_PERF_MON_V2		KVM_X86_CPU_FEATURE(0x80000022, 0,  
>> EAX, 0)

> Let's use X86_FEATURE_PERFMON_V2 instead.

Done

>> +#define	X86_FEATURE_PERF_LBR_PMC_FREEZE	KVM_X86_CPU_FEATURE(0x80000022,  
>> 0, EAX, 2)

> You don't use this feature, do you? If not, this can be optional for the
> patch.

Correct again, included for the same reasoning above.


>>   /*
>>    * KVM defined paravirt features.
>> @@ -281,6 +286,8 @@ struct kvm_x86_cpu_property {
>>   #define X86_PROPERTY_GUEST_MAX_PHY_ADDR		 
>> KVM_X86_CPU_PROPERTY(0x80000008, 0, EAX, 16, 23)
>>   #define X86_PROPERTY_SEV_C_BIT			KVM_X86_CPU_PROPERTY(0x8000001F, 0,  
>> EBX, 0, 5)
>>   #define X86_PROPERTY_PHYS_ADDR_REDUCTION	 
>> KVM_X86_CPU_PROPERTY(0x8000001F, 0, EBX, 6, 11)
>> +#define X86_PROPERTY_NUM_PERF_CTR_CORE		 
>> KVM_X86_CPU_PROPERTY(0x80000022, 0, EBX, 0, 3)
>> +#define X86_PROPERTY_NUM_PERF_CTR_NB		KVM_X86_CPU_PROPERTY(0x80000022,  
>> 0, EBX, 10, 15)


> ditto.
>>   #define X86_PROPERTY_MAX_CENTAUR_LEAF		KVM_X86_CPU_PROPERTY(0xC0000000,  
>> 0, EAX, 0, 31)

>> --
>> 2.46.0.76.ge559c4bf1a-goog


