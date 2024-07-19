Return-Path: <kvm+bounces-21964-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 39F10937CCC
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 21:02:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DBC43281942
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 19:02:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8900D148307;
	Fri, 19 Jul 2024 19:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cY9/sNgy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDD475664;
	Fri, 19 Jul 2024 19:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721415729; cv=none; b=oMcVpM9tM4h9GcrQyy0nflvp0Sp0aak4oExHskja8o19pTGYBkmsI0URMJdlZSdq6+/C2O40jM85HejVIw+jkJBXH39pJncRtquRvmmyRPu/v1UdtjGX9wC/3aZPLDGnMUkEme7Txg7vkY8i4J848BKjiYMEsrj8lCEAvXlGydE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721415729; c=relaxed/simple;
	bh=H4EdbgJa4+2qW09CQL7FhrjDOkJ0RweZMDKVnWKK++w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=h5/ru4Wk9Z+xRbvp7PzhaddjuRfS9z3hCezP0oqWBHegSVLwxkODFkzcdcdrM3yflCMZT3vzoJ/y9MZ04fEJBnSIKLnNTEfSqUyRej6YnvcgEpcbC1NWG/nKhXkasVeFAMaAP8lCiZRfKmPOeYCUz45VYgs2bqSLB+THdd6o32s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cY9/sNgy; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-427d2c8c632so14014235e9.2;
        Fri, 19 Jul 2024 12:02:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721415726; x=1722020526; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5S0CuXGuZZT8X03+fwdPOZCye8UpeZHy9Q9kMoFfG9s=;
        b=cY9/sNgyZHSbcyKy5/ChGqWeyN5sONSePnO+QOkz6nstgXX5NB3WfornW1rv2GyVZv
         yNG6bgp/pb6mINL87tmJFKF7eA/bKHzI7kfpFecsE+ZxivRplEUtYnt8wJSAz8GusNrQ
         vGZU1d+NTBG8QJJK8VUcB0bo3bc4USZe45KLOPJtvWyPBIhLrOmhlCWnampLYsuy+tvZ
         qNzx7DSrXnDgO0tuteFV1020frT96jzmit+egoTqWW5x9ZjGSuJdMKQk5701jK99i2H6
         rcwNJotVXa5cUhG9CINQwT3F+PFs4A0Mx5lQ24aQ4QVHOOLxPYiuL1UgZCdUdwMc1e+j
         5HWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721415726; x=1722020526;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5S0CuXGuZZT8X03+fwdPOZCye8UpeZHy9Q9kMoFfG9s=;
        b=BRjpQkOTL6JWg0InmukYqHl7E6mJEDKTrOsZk4aE22YiCDRvf5+V9+W6jStNU/l9xl
         3TBJZgEl+rzu3M/3SwDQsr9lGuinMn+39b3N3fDTYHGjwXHOchMy+TNcOeTVb0StcobT
         vdngIe7yQjUT6e/VfOLWv1vtoreK5xtgpuzY5bjc+qcBqOtWd+V8s6ziZOXNfuhOfyy7
         /jIvInv+JBEczNFdUOnV+EVK4kQZLyIq3twaVjTOeu8v+qWkmakLzVfwIG0rLIJwJdwf
         uoR7ZGgLMRsA1w4Lw6E+Xv6Ddtg8JXtgKuqlqggWmykJTYcUw5dxj6B3Q3uiWhkbWb8q
         2dog==
X-Forwarded-Encrypted: i=1; AJvYcCVd3SFECPRCnpNedz/GqrfQtH+lTI9nc3/Ng8HuFeZckcWkrim0NKSLQh5wHFaBTkajVBH348whQ4dVz4htUUmU6kWxWNu6XoT/H+aL
X-Gm-Message-State: AOJu0YwqOuV2FXhhS3ej+d/xZRGUA73G3yi6bBcR8BWqG0QR8c6W2o5J
	ByzG98l3vplEnoBcwiUtweNoBt3F1AReyQ7neGhJq0EafUPOsW5T
X-Google-Smtp-Source: AGHT+IHABVSTNrAgjqvTk1Y8L5wM5y8ZMQj3zmPNzPQW5FCTkjxg1v4PuGEHQxt11eAHzqZIxWKwqQ==
X-Received: by 2002:a05:600c:3152:b0:426:5c02:2d6 with SMTP id 5b1f17b1804b1-427c2cba2aemr65194075e9.16.1721415726157;
        Fri, 19 Jul 2024 12:02:06 -0700 (PDT)
Received: from [192.168.178.20] (dh207-42-168.xnet.hr. [88.207.42.168])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-36878811899sm2305364f8f.116.2024.07.19.12.02.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Jul 2024 12:02:05 -0700 (PDT)
Message-ID: <70137930-fea1-4d45-b453-e6ae984c4b2b@gmail.com>
Date: Fri, 19 Jul 2024 21:02:01 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: =?UTF-8?Q?Re=3A_=5BBUG=5D_arch/x86/kvm/vmx/pmu=5Fintel=2Ec=3A54=3A_?=
 =?UTF-8?Q?error=3A_dereference_of_NULL_=E2=80=98pmc=E2=80=99_=5BCWE-476=5D?=
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
 linux-kernel@vger.kernel.org, Like Xu <likexu@tencent.com>
References: <c42bff52-1058-4bff-be90-5bab45ed57be@gmail.com>
 <ZpqgfETiBXfBfFqU@google.com>
Content-Language: en-US
From: Mirsad Todorovac <mtodorovac69@gmail.com>
In-Reply-To: <ZpqgfETiBXfBfFqU@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 7/19/24 19:21, Sean Christopherson wrote:
> On Fri, Jul 19, 2024, Mirsad Todorovac wrote:
>> Hi,
>>
>> In the build of 6.10.0 from stable tree, the following error was detected.
>>
>> You see that the function get_fixed_pmc() can return NULL pointer as a result
>> if msr is outside of [base, base + pmu->nr_arch_fixed_counters) interval.
>>
>> kvm_pmu_request_counter_reprogram(pmc) is then called with that NULL pointer
>> as the argument, which expands to .../pmu.h
>>
>> #define pmc_to_pmu(pmc)   (&(pmc)->vcpu->arch.pmu)
>>
>> which is a NULL pointer dereference in that speculative case.
> 
> I'm somewhat confused.  Did you actually hit a BUG() due to a NULL-pointer
> dereference, are you speculating that there's a bug, or did you find some speculation
> issue with the CPU?
> 
> It should be impossible for get_fixed_pmc() to return NULL in this case.  The
> loop iteration is fully controlled by KVM, i.e. 'i' is guaranteed to be in the
> ranage [0..pmu->nr_arch_fixed_counters).
> 
> And the input @msr is "MSR_CORE_PERF_FIXED_CTR0 +i", so the if-statement expands to:
> 
> 	if (MSR_CORE_PERF_FIXED_CTR0 + [0..pmu->nr_arch_fixed_counters) >= MSR_CORE_PERF_FIXED_CTR0 &&
> 	    MSR_CORE_PERF_FIXED_CTR0 + [0..pmu->nr_arch_fixed_counters) < MSR_CORE_PERF_FIXED_CTR0 + pmu->nr_arch_fixed_counters)
> 
> i.e. is guaranteed to evaluate true.
> 
> Am I missing something?

Hi Sean,

Thank you for replying promptly.

Perhaps I should have provided the GCC error report in the first place. It seems that GCC 12.3.0
cannot track dependencies that deep, so it assumes that code

157         if (msr >= base && msr < base + pmu->nr_arch_fixed_counters) {
158                 u32 index = array_index_nospec(msr - base,
159                                                pmu->nr_arch_fixed_counters);
160 
161                 return &pmu->fixed_counters[index];
162         }
163 
164         return NULL;

can end up returning NULL, resulting in NULL pointer dereference.

The analyzer sees pmu->nr_arch_fixed_counters, but I am not sure that GCC can search
changes that deep.

Maybe if clause in arch/x86/kvm/vmx/../pmu.h:157 is always true, but GCC cannot see that?

Best regards,
Mirsad Todorovac

---------------------------------------------------------------------------------------
In file included from arch/x86/kvm/vmx/capabilities.h:9,
                 from arch/x86/kvm/vmx/vmcs.h:12,
                 from arch/x86/kvm/vmx/vmcs12.h:7,
                 from arch/x86/kvm/vmx/hyperv.h:6,
                 from arch/x86/kvm/vmx/nested.h:6,
                 from arch/x86/kvm/vmx/pmu_intel.c:20:
arch/x86/kvm/vmx/../pmu.h: In function ‘kvm_pmu_request_counter_reprogram’:
arch/x86/kvm/vmx/../pmu.h:11:34: error: dereference of NULL ‘pmc’ [CWE-476] [-Werror=analyzer-null-dereference]
   11 | #define pmc_to_pmu(pmc)   (&(pmc)->vcpu->arch.pmu)
      |                             ~~~~~^~~~~~
arch/x86/kvm/vmx/../pmu.h:230:27: note: in expansion of macro ‘pmc_to_pmu’
  230 |         set_bit(pmc->idx, pmc_to_pmu(pmc)->reprogram_pmi);
      |                           ^~~~~~~~~~
  ‘reprogram_fixed_counters’: events 1-4
    |
    |arch/x86/kvm/vmx/pmu_intel.c:37:13:
    |   37 | static void reprogram_fixed_counters(struct kvm_pmu *pmu, u64 data)
    |      |             ^~~~~~~~~~~~~~~~~~~~~~~~
    |      |             |
    |      |             (1) entry to ‘reprogram_fixed_counters’
    |......
    |   44 |         for (i = 0; i < pmu->nr_arch_fixed_counters; i++) {
    |      |                     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    |      |                       |
    |      |                       (2) following ‘true’ branch...
    |   45 |                 u8 new_ctrl = fixed_ctrl_field(data, i);
    |      |                 ~~ ~~~~~~~~
    |      |                 |  |
    |      |                 |  (4) following ‘false’ branch...
    |      |                 (3) ...to here
    |
  ‘reprogram_fixed_counters’: event 5
    |
    |arch/x86/kvm/vmx/../pmu.h:17:54:
    |   17 | #define fixed_ctrl_field(ctrl_reg, idx) (((ctrl_reg) >> ((idx)*4)) & 0xf)
    |      |                                                      ^~
    |      |                                                      |
    |      |                                                      (5) ...to here
arch/x86/kvm/vmx/pmu_intel.c:45:31: note: in expansion of macro ‘fixed_ctrl_field’
    |   45 |                 u8 new_ctrl = fixed_ctrl_field(data, i);
    |      |                               ^~~~~~~~~~~~~~~~
    |
  ‘reprogram_fixed_counters’: event 6
    |
    |   46 |                 u8 old_ctrl = fixed_ctrl_field(old_fixed_ctr_ctrl, i);
    |      |                    ^~~~~~~~
    |      |                    |
    |      |                    (6) following ‘false’ branch...
    |
  ‘reprogram_fixed_counters’: event 7
    |
    |arch/x86/kvm/vmx/../pmu.h:17:54:
    |   17 | #define fixed_ctrl_field(ctrl_reg, idx) (((ctrl_reg) >> ((idx)*4)) & 0xf)
    |      |                                                      ^~
    |      |                                                      |
    |      |                                                      (7) ...to here
arch/x86/kvm/vmx/pmu_intel.c:46:31: note: in expansion of macro ‘fixed_ctrl_field’
    |   46 |                 u8 old_ctrl = fixed_ctrl_field(old_fixed_ctr_ctrl, i);
    |      |                               ^~~~~~~~~~~~~~~~
    |
  ‘reprogram_fixed_counters’: events 8-9
    |
    |   48 |                 if (old_ctrl == new_ctrl)
    |      |                    ^
    |      |                    |
    |      |                    (8) following ‘false’ branch...
    |......
    |   51 |                 pmc = get_fixed_pmc(pmu, MSR_CORE_PERF_FIXED_CTR0 + i);
    |      |                 ~~~ 
    |      |                 |
    |      |                 (9) ...to here
    |
  ‘reprogram_fixed_counters’: events 10-12
    |
    |arch/x86/kvm/vmx/../pmu.h:157:12:
    |  157 |         if (msr >= base && msr < base + pmu->nr_arch_fixed_counters) {
    |      |            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    |      |            |            |                  |
    |      |            |            |                  (11) ...to here
    |      |            |            (12) following ‘false’ branch...
    |      |            (10) following ‘true’ branch...
    |
  ‘reprogram_fixed_counters’: events 13-14
    |
    |arch/x86/kvm/vmx/pmu_intel.c:51:23:
    |   51 |                 pmc = get_fixed_pmc(pmu, MSR_CORE_PERF_FIXED_CTR0 + i);
    |      |                       ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    |      |                       |
    |      |                       (13) ...to here
    |......
    |   54 |                 kvm_pmu_request_counter_reprogram(pmc);
    |      |                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    |      |                 |
    |      |                 (14) calling ‘kvm_pmu_request_counter_reprogram’ from ‘reprogram_fixed_counters’
    |
    +--> ‘kvm_pmu_request_counter_reprogram’: event 15
           |
           |arch/x86/kvm/vmx/../pmu.h:228:20:
           |  228 | static inline void kvm_pmu_request_counter_reprogram(struct kvm_pmc *pmc)
           |      |                    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
           |      |                    |
           |      |                    (15) entry to ‘kvm_pmu_request_counter_reprogram’
           |
         ‘kvm_pmu_request_counter_reprogram’: event 16
           |
           |   11 | #define pmc_to_pmu(pmc)   (&(pmc)->vcpu->arch.pmu)
           |      |                             ~~~~~^~~~~~
           |      |                                  |
           |      |                                  (16) dereference of NULL ‘pmc’
arch/x86/kvm/vmx/../pmu.h:230:27: note: in expansion of macro ‘pmc_to_pmu’
           |  230 |         set_bit(pmc->idx, pmc_to_pmu(pmc)->reprogram_pmi);
           |      |                           ^~~~~~~~~~
           |
cc1: all warnings being treated as errors


>> arch/x86/kvm/vmx/pmu_intel.c
>> ----------------------------
>>  37 static void reprogram_fixed_counters(struct kvm_pmu *pmu, u64 data)
>>  38 {
>>  39         struct kvm_pmc *pmc;
>>  40         u64 old_fixed_ctr_ctrl = pmu->fixed_ctr_ctrl;
>>  41         int i;
>>  42 
>>  43         pmu->fixed_ctr_ctrl = data;
>>  44         for (i = 0; i < pmu->nr_arch_fixed_counters; i++) {
>>  45                 u8 new_ctrl = fixed_ctrl_field(data, i);
>>  46                 u8 old_ctrl = fixed_ctrl_field(old_fixed_ctr_ctrl, i);
>>  47 
>>  48                 if (old_ctrl == new_ctrl)
>>  49                         continue;
>>  50 
>>  51 →               pmc = get_fixed_pmc(pmu, MSR_CORE_PERF_FIXED_CTR0 + i);
>>  52 
>>  53                 __set_bit(KVM_FIXED_PMC_BASE_IDX + i, pmu->pmc_in_use);
>>  54 →               kvm_pmu_request_counter_reprogram(pmc);
>>  55         }
>>  56 }
>> ----------------------------
>>
>> arch/x86/kvm/vmx/../pmu.h
>> -------------------------
>>  11 #define pmc_to_pmu(pmc)   (&(pmc)->vcpu->arch.pmu)
>> .
>> .
>> .
>> 152 /* returns fixed PMC with the specified MSR */
>> 153 static inline struct kvm_pmc *get_fixed_pmc(struct kvm_pmu *pmu, u32 msr)
>> 154 {
>> 155         int base = MSR_CORE_PERF_FIXED_CTR0;
>> 156 
>> 157         if (msr >= base && msr < base + pmu->nr_arch_fixed_counters) {
>> 158                 u32 index = array_index_nospec(msr - base,
>> 159                                                pmu->nr_arch_fixed_counters);
>> 160 
>> 161                 return &pmu->fixed_counters[index];
>> 162         }
>> 163 
>> 164         return NULL;
>> 165 }
>> .
>> .
>> .
>> 228 static inline void kvm_pmu_request_counter_reprogram(struct kvm_pmc *pmc)
>> 229 {
>> 230         set_bit(pmc->idx, pmc_to_pmu(pmc)->reprogram_pmi);
>> 231         kvm_make_request(KVM_REQ_PMU, pmc->vcpu);
>> 232 }
>> .
>> .
>> .
>> -------------------------
>> 76d287b2342e1
>> Offending commits are: 76d287b2342e1 and 4fa5843d81fdc.
>>
>> I am not familiar with this subset of code, so I do not know the right code to implement
>> for the case get_fixed_pmc(pmu, MSR_CORE_PERF_FIXED_CTR0 + i) returns NULL.
>>
>> Hope this helps.
>>
>> Best regards,
>> Mirsad Todorovac

