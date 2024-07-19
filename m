Return-Path: <kvm+bounces-21955-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 335EE937B43
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 18:49:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 651221C21FF9
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 16:49:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E571914659D;
	Fri, 19 Jul 2024 16:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="npQFT0qY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86146210FF;
	Fri, 19 Jul 2024 16:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721407764; cv=none; b=K4Qxzc1Ma65ZfiigkpXjZ5sribl0l98YRgV0L5URR72fcyHvVlWC8mJDoinuKAN9LCdQULhU95Gy1DcRidH/DzNxajGoL3Jo7qJJqPuis9qvQTeSGn4avCttpHALOpkLXdnV1fk1DO/ZITfYg2oRsph5WVAs8zP+Yva/id9tvNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721407764; c=relaxed/simple;
	bh=Ay7YLk0kb8KpRf931hlGEDl/5+VIFgInenHsPYEjR2c=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:Content-Type; b=s6XwnckBSSND3wN69A31xO9yABqOYyF4RPX1+HuyYmSBQ8KDiSXXZo65CFBHLargmbrxZ3E3iByI3PeyRkO/l//WOP314ddwIjey0ozKr3xDW1V1/j0DW0roIPzxkenhbLoS5jNiElpEm6PYhpAF+I84zkDyxBWvDRwXkHEekmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=npQFT0qY; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4266f3e0df8so13859435e9.2;
        Fri, 19 Jul 2024 09:49:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721407761; x=1722012561; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:from:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xG5wbJzMV5qdHFSnbFt+QXGY3BJvPU7gNdCNvPvDdNQ=;
        b=npQFT0qYy+sBirIaBvY1HPUfU3zZ3M/jdwBp2FnhOgkxAyGli4Pk2JMDCO7bg110e3
         DI7Z3hzRhXtVfZQgnUzS7vlWweL1HSoahgnHdP+hhBlV+G6ecSbOkPm2gHafg5sCQCE/
         FlROYJsQNv5QQaLyrpnG33s2viDNUeJ64RcVaclHdcmTRiMtIPAbqxa+vawcdoz4+C5b
         h69yDY5I4os83KRr0VVfMpPTAqcZmx07eXUphPm4xmhJZ6GSvdKBbhQR8ivTPOHlA4Vk
         AWNl3vpBSwXn9Nt+L2KThKYmSMialZP8+EanveWS9tsWmJuvsRzsC0pTdM28EPyH346z
         4tMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721407761; x=1722012561;
        h=content-transfer-encoding:cc:to:subject:from:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=xG5wbJzMV5qdHFSnbFt+QXGY3BJvPU7gNdCNvPvDdNQ=;
        b=FvTv5XPlsbdxL2v+94ridBuqhlgpsxo3NFLbx1iREJRQnKs630IrhFkcgDpKxaKHwR
         bppt9VPDQR08rKtlVAJFr02CwddII+ViYyRKrrU+GqaI/E0hf2XHQFZE9hm/MXKCBdVa
         vYpLcCOxJ5KhdedbPiPo4LxEaYvZHGVhmwVOBZzzat1OhD5mcwH0yy+tizJuSnl9xl95
         lv6GmLyrSKeeZOpyTQWUzV9et8q2uNAyfIn7guB3vHMNM9HeSB3KBixwgyU0d27BrO4R
         SU4sdPtCr26TvGlu7HG9svnELlcBpjKrldGYAp6XIL6s+2ZxJzanUmqiLDgpIG+QaLWR
         2DvA==
X-Forwarded-Encrypted: i=1; AJvYcCWKFbdYNAlsltvPJaYjdmr5lqbdW4xFT9nO3tBOMSsHk5njnf1EKjxCzTnRjlYTCjBUTOlw2ZriBLbOqxtnSnsqlm9reMAfm9+O5K+q
X-Gm-Message-State: AOJu0Yymx6S0DG2e6JRleDsbDk0SyUbt/CG0ps+Ku2CC61eycFRK0dI1
	kJ90oSPM2gt4a66COfeGEx1uMYRdD7EcPLoibeAkd9tg317/1gvVta5atHMK
X-Google-Smtp-Source: AGHT+IGk22I5Zm9JWeZ0jIjjfQGNFuQ8EV+gfy0X29ux27YZyMYhCpJEYPbf/cX2HNZzz4lJb6EeFQ==
X-Received: by 2002:adf:e58c:0:b0:367:8a2f:a6dc with SMTP id ffacd0b85a97d-368316f9cc7mr6049563f8f.44.1721407760410;
        Fri, 19 Jul 2024 09:49:20 -0700 (PDT)
Received: from [192.168.178.20] (dh207-42-168.xnet.hr. [88.207.42.168])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3687868ac3asm2055105f8f.27.2024.07.19.09.49.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Jul 2024 09:49:20 -0700 (PDT)
Message-ID: <c42bff52-1058-4bff-be90-5bab45ed57be@gmail.com>
Date: Fri, 19 Jul 2024 18:49:16 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
From: Mirsad Todorovac <mtodorovac69@gmail.com>
Subject: =?UTF-8?Q?=5BBUG=5D_arch/x86/kvm/vmx/pmu=5Fintel=2Ec=3A54=3A_error?=
 =?UTF-8?B?OiBkZXJlZmVyZW5jZSBvZiBOVUxMIOKAmHBtY+KAmSBbQ1dFLTQ3Nl0=?=
To: kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
 Like Xu <likexu@tencent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi,

In the build of 6.10.0 from stable tree, the following error was detected.

You see that the function get_fixed_pmc() can return NULL pointer as a result
if msr is outside of [base, base + pmu->nr_arch_fixed_counters) interval.

kvm_pmu_request_counter_reprogram(pmc) is then called with that NULL pointer
as the argument, which expands to .../pmu.h

#define pmc_to_pmu(pmc)   (&(pmc)->vcpu->arch.pmu)

which is a NULL pointer dereference in that speculative case.

arch/x86/kvm/vmx/pmu_intel.c
----------------------------
 37 static void reprogram_fixed_counters(struct kvm_pmu *pmu, u64 data)
 38 {
 39         struct kvm_pmc *pmc;
 40         u64 old_fixed_ctr_ctrl = pmu->fixed_ctr_ctrl;
 41         int i;
 42 
 43         pmu->fixed_ctr_ctrl = data;
 44         for (i = 0; i < pmu->nr_arch_fixed_counters; i++) {
 45                 u8 new_ctrl = fixed_ctrl_field(data, i);
 46                 u8 old_ctrl = fixed_ctrl_field(old_fixed_ctr_ctrl, i);
 47 
 48                 if (old_ctrl == new_ctrl)
 49                         continue;
 50 
 51 →               pmc = get_fixed_pmc(pmu, MSR_CORE_PERF_FIXED_CTR0 + i);
 52 
 53                 __set_bit(KVM_FIXED_PMC_BASE_IDX + i, pmu->pmc_in_use);
 54 →               kvm_pmu_request_counter_reprogram(pmc);
 55         }
 56 }
----------------------------

arch/x86/kvm/vmx/../pmu.h
-------------------------
 11 #define pmc_to_pmu(pmc)   (&(pmc)->vcpu->arch.pmu)
.
.
.
152 /* returns fixed PMC with the specified MSR */
153 static inline struct kvm_pmc *get_fixed_pmc(struct kvm_pmu *pmu, u32 msr)
154 {
155         int base = MSR_CORE_PERF_FIXED_CTR0;
156 
157         if (msr >= base && msr < base + pmu->nr_arch_fixed_counters) {
158                 u32 index = array_index_nospec(msr - base,
159                                                pmu->nr_arch_fixed_counters);
160 
161                 return &pmu->fixed_counters[index];
162         }
163 
164         return NULL;
165 }
.
.
.
228 static inline void kvm_pmu_request_counter_reprogram(struct kvm_pmc *pmc)
229 {
230         set_bit(pmc->idx, pmc_to_pmu(pmc)->reprogram_pmi);
231         kvm_make_request(KVM_REQ_PMU, pmc->vcpu);
232 }
.
.
.
-------------------------
76d287b2342e1
Offending commits are: 76d287b2342e1 and 4fa5843d81fdc.

I am not familiar with this subset of code, so I do not know the right code to implement
for the case get_fixed_pmc(pmu, MSR_CORE_PERF_FIXED_CTR0 + i) returns NULL.

Hope this helps.

Best regards,
Mirsad Todorovac

