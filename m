Return-Path: <kvm+bounces-36068-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E235AA1736C
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 21:07:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 684801884E27
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 20:07:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 037841EF0AE;
	Mon, 20 Jan 2025 20:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0QjON+rQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oa1-f73.google.com (mail-oa1-f73.google.com [209.85.160.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 946EE1AAA23
	for <kvm@vger.kernel.org>; Mon, 20 Jan 2025 20:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737403649; cv=none; b=jTtmQCKZ5AU4ImnEeTOjLTTZB1p/6e58q64mUFjVCl0O9+EDWjkgcABXbtUgV3LQXFVnwJU62GQA0GjVzKUx30oyxb4IgMUYRSsehNagJkgLoOMQIZj63pdJT4lgJog+rvt8/SVgOx0kADgGmIS6yxrz+bmY96wOhukshhh6HHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737403649; c=relaxed/simple;
	bh=NH+aeZcweZIlJCTgdkU6lz2lcBTtsiR2fKteyRUQTIk=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=JxG3wun9MnCmLD2UIHDWZ0OJVS+TxFsXeCIn5Mha+Z1s3qK8JdMCKt2jViH/FHN/Up2+c3d1m7kAANwALEOTWOIzh/cA0yR46jk5SD6UE1EV/ZCMWTvVf+I6vAgJexVNwV3dc9U6XIhDTbkR+PviEJTCFn3fOwnkgGmGwLF3BFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0QjON+rQ; arc=none smtp.client-ip=209.85.160.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-oa1-f73.google.com with SMTP id 586e51a60fabf-2a75cda3961so1120824fac.0
        for <kvm@vger.kernel.org>; Mon, 20 Jan 2025 12:07:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737403646; x=1738008446; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=znQc5ya/qrfgVRfkMEA3QWNUiFjrxeYAddx1iowMLag=;
        b=0QjON+rQ08DDQbUxWvW8Xky58Q1f5tjZ3GmoHfRkxnRChwTwUNQcHa1CN1rI26BVrI
         FWHvBDJRkHWuXNzN6ROp6D1JUyR16Wr8Fe/kfbMCuT5+IZI/Xs49oY3wyj/7ATl/FBPx
         CH4Q7efB5J80wPVHOnk7PASnHXq1JH59mrdJvWZl5oW6KQZHxEnEMxT69pESKyPMV7Kt
         RmRx/QSR335NM/6L7sKS53xmaziF61aYXdgVeMlA435HO78Sp7JuNRbN7lmLgafDBWms
         73gNumEc69ReSdY2j1MXtC1cYswkOutUCFowq4yOMxHGqT2A4q+FKj+kn/01RAnKWZlH
         cN0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737403646; x=1738008446;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=znQc5ya/qrfgVRfkMEA3QWNUiFjrxeYAddx1iowMLag=;
        b=jBPNK0PFTWEhyhI35oEkjKBvFQc4RcA1IkTRGr7uczf0ZbFCrWkTsiE9L561IsayPQ
         Z8PSNbwBXIEtVah3zUgI+Fivhno3QAO1/fdOU8UES6k9LIunLpAcMB+2gEdyv1hQL+pL
         nYZdzQrJyu2VRopSjZwhHgzqhwy7iMRHo1PXgYH14dCFQF0ztkO8NsUUNTbBzJ4bCVjJ
         dJw7jJ+k2rHhouJzMx15b8QXqrR08VxCbRJFDR+QDaCyBUqjwOFYTNZ4/6m+QRhsZ48L
         M24+WYgTFUaBshmLd3PunHgSXrBovKlnaQXIbYZmHKAaX7Hui0JsI9mjIUqbU4kPP2vM
         +ZSA==
X-Gm-Message-State: AOJu0Yy7OvPnCjwHK92tl68QedVvF/SmEYWkfMMPM3BzgC2poYoKT6nn
	0J8zqW028GNINhnqatQZ/b16LKqWWkJgtqjBsSjIeXy51h6HwyiqmbBo/GRzPrTjGwSQ/d0VXYp
	8imCSB/EtnsQzZEyjFBWlBQ==
X-Google-Smtp-Source: AGHT+IFk0S/i7d7lkEKdU5r4pixQlkDdqhsfVj9yDj+hasgnv0qQnXftROdcmiB2uPqsBshOy5Qiy9r6hWstZDGkcA==
X-Received: from oabhf8.prod.google.com ([2002:a05:6870:7a08:b0:27c:f4f:5a84])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6870:2a46:b0:29e:2422:49e2 with SMTP id 586e51a60fabf-2b1c0c54eb1mr8715363fac.31.1737403646677;
 Mon, 20 Jan 2025 12:07:26 -0800 (PST)
Date: Mon, 20 Jan 2025 20:07:25 +0000
In-Reply-To: <Z37VMzbCZEKkDOmP@google.com> (message from Sean Christopherson
 on Wed, 8 Jan 2025 11:42:43 -0800)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-ID: <gsnth65t2qrm.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v2 6/6] KVM: x86: selftests: Test PerfMonV2
From: Colton Lewis <coltonlewis@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, mizhang@google.com, ljr.kernel@gmail.com, 
	jmattson@google.com, aaronlewis@google.com, pbonzini@redhat.com, 
	shuah@kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Sean Christopherson <seanjc@google.com> writes:

> On Wed, Sep 18, 2024, Colton Lewis wrote:
>> Test PerfMonV2, which defines global registers to enable multiple
>> performance counters with a single MSR write, in its own function.

>> If the feature is available, ensure the global control register has
>> the ability to start and stop the performance counters and the global
>> status register correctly flags an overflow by the associated counter.

>> Signed-off-by: Colton Lewis <coltonlewis@google.com>
>> ---
>>   .../selftests/kvm/x86_64/pmu_counters_test.c  | 53 +++++++++++++++++++
>>   1 file changed, 53 insertions(+)

>> diff --git a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c  
>> b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
>> index cf2941cc7c4c..a90df8b67a19 100644
>> --- a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
>> +++ b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
>> @@ -763,10 +763,63 @@ static void guest_test_core_events(void)
>>   	}
>>   }

>> +static void guest_test_perfmon_v2(void)
>> +{
>> +	uint64_t i;
>> +	uint64_t eventsel = ARCH_PERFMON_EVENTSEL_OS |
>> +		ARCH_PERFMON_EVENTSEL_ENABLE |
>> +		AMD_ZEN_CORE_CYCLES;

> Hmm.  I like the extra coverage, but I think the guts of this test belong  
> is
> common code, because the core logic is the same across Intel and AMD (I  
> think),
> only the MSRs are different.

> Maybe a library helper that takes in the MSRs as parameters?  Not sure.

I'll explore some other options

> I suspect it'll take some back and forth to figure out how best to  
> validate these
> more "advanced" behaviors, so maybe skip this patch for the next  
> version?  I.e.
> land basic AMD coverage and then we can figure out how to test global  
> control and
> status.

Sure

>> +	bool core_ext = this_cpu_has(X86_FEATURE_PERF_CTR_EXT_CORE);
>> +	uint64_t sel_msr_base = core_ext ? MSR_F15H_PERF_CTL : MSR_K7_EVNTSEL0;
>> +	uint64_t cnt_msr_base = core_ext ? MSR_F15H_PERF_CTR : MSR_K7_PERFCTR0;
>> +	uint64_t msr_step = core_ext ? 2 : 1;
>> +	uint8_t nr_counters = guest_nr_core_counters();
>> +	bool perfmon_v2 = this_cpu_has(X86_FEATURE_PERFMON_V2);

> Zero reason to capture this in a local variable.

Will delete

>> +	uint64_t sel_msr;
>> +	uint64_t cnt_msr;
>> +
>> +	if (!perfmon_v2)
>> +		return;
>> +
>> +	for (i = 0; i < nr_counters; i++) {
>> +		sel_msr = sel_msr_base + msr_step * i;
>> +		cnt_msr = cnt_msr_base + msr_step * i;
>> +
>> +		/* Ensure count stays 0 when global register disables counter. */
>> +		wrmsr(MSR_AMD64_PERF_CNTR_GLOBAL_CTL, 0);
>> +		wrmsr(sel_msr, eventsel);
>> +		wrmsr(cnt_msr, 0);
>> +		__asm__ __volatile__("loop ." : "+c"((int){NUM_LOOPS}));
>> +		GUEST_ASSERT(!_rdpmc(i));
>> +
>> +		/* Ensure counter is >0 when global register enables counter. */
>> +		wrmsr(MSR_AMD64_PERF_CNTR_GLOBAL_CTL, BIT_ULL(i));
>> +		__asm__ __volatile__("loop ." : "+c"((int){NUM_LOOPS}));
>> +		wrmsr(MSR_AMD64_PERF_CNTR_GLOBAL_CTL, 0);
>> +		GUEST_ASSERT(_rdpmc(i));
>> +
>> +		/* Ensure global status register flags a counter overflow. */
>> +		wrmsr(cnt_msr, -1);
>> +		wrmsr(MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR, 0xff);
>> +		wrmsr(MSR_AMD64_PERF_CNTR_GLOBAL_CTL, BIT_ULL(i));
>> +		__asm__ __volatile__("loop ." : "+c"((int){NUM_LOOPS}));
>> +		wrmsr(MSR_AMD64_PERF_CNTR_GLOBAL_CTL, 0);
>> +		GUEST_ASSERT(rdmsr(MSR_AMD64_PERF_CNTR_GLOBAL_STATUS) &
>> +			     BIT_ULL(i));
>> +
>> +		/* Ensure global status register flag is cleared correctly. */
>> +		wrmsr(MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR, BIT_ULL(i));
>> +		GUEST_ASSERT(!(rdmsr(MSR_AMD64_PERF_CNTR_GLOBAL_STATUS) &
>> +			     BIT_ULL(i)));
>> +	}
>> +}
>> +
>> +
>>   static void guest_test_core_counters(void)
>>   {
>>   	guest_test_rdwr_core_counters();
>>   	guest_test_core_events();
>> +	guest_test_perfmon_v2();
>>   	GUEST_DONE();
>>   }

>> --
>> 2.46.0.662.g92d0881bb0-goog


