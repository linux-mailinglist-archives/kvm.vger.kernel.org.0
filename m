Return-Path: <kvm+bounces-21956-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DD0A937B79
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 19:21:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B71A71F22862
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 17:21:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D799146A66;
	Fri, 19 Jul 2024 17:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2CirpjcA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0CC8250EC
	for <kvm@vger.kernel.org>; Fri, 19 Jul 2024 17:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721409664; cv=none; b=ijtKduP1g4A/Qusgd9qH23K71vFprqEvJ/cVwpuZyZBPYIaStfV/WjeYJbiZnef0EmxNNVKQatSa4n4RUemRMNGcgcL0cgoCT+8pUqzBvEGemb62MT2sgYpb6ada7Ksqg06wwfFre3ynbdOaqE65TY/uPdk8VUFES+8DBQpNVIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721409664; c=relaxed/simple;
	bh=osByLjgR/fd6V0XvMDC5JBZP/STCt/rb3qDyiTeNnK4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LeCjkUUfCXtfUhDDMBoNUV4L23wNFfEzmBWdsSiDFQ8KHqqXUi9gR5fhlw8gC4cDf1imtWLvr90qwdpfo/gYuQybo4LQZDXwqYMdjc4OygQAPgADqcs6GBHFxKBY81TN6sgLcsLcNtOomFdowgQ2vdW+6ed1qdfk6aqsQEB4S28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2CirpjcA; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-664aa55c690so56587727b3.2
        for <kvm@vger.kernel.org>; Fri, 19 Jul 2024 10:21:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721409662; x=1722014462; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=269jqe/jzjyYpBV+uTwg3PKS+HXAo3qpFrECBrOEtQ8=;
        b=2CirpjcAoni+MNfKoVFS95lB8VX63EFEZJ9CFhqCUFrkz+MGJE5k5U46PUyRJ6C2fC
         SgBmOKMKEg0Bb/lNS4zMyR/07kRT6CtR09ng9099LoQZeSIqIhlfxItAyuF/DOcefla+
         C+PBMNbHUQ//jWAXAvNZbTdQGf9vu8Pq5bMUm0Rc0vwmNYGdM8TtYSm41bXw0DBQPljN
         qqY6wIY0GOzNZmy+DoXnxj2VHRwiF3vxyUdZledvh/jmLdo27bHGhXCGbVnVGFVGa4L9
         jB+592E2L7k4+k7H7/m62QPTLO3gU4V+rhM4glm/WeVmb7xYw4dzaO38xCecTm4Gqb3m
         qmrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721409662; x=1722014462;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=269jqe/jzjyYpBV+uTwg3PKS+HXAo3qpFrECBrOEtQ8=;
        b=o0D25h3Z2j7b5LsqrZ5kzoc+eipqF+IK7nAMcl5wlV78bsSG729d9sHIXPPTmpSZQd
         yz4Kb9ieiEl06xiJYlTsialzZhhaSm0//fC2ZwaIwM7I/CwxSp94994YNVUiTt0pSS9T
         XLvNVhyI5sYt5/daoHDeXlJ970gXYfVZq6JBZX/+w1vLl9MiYbMgJ73Ye71q04L768m4
         kYDyqgOdGLGgi5ZQDxWgVCfOYV06Fnb3bZnPe3CfhqcqokD7VYOJCJcXhzyrI3tu7dMB
         CezToLlAsJZlUYecNnpqI4TbbBAQtJliT/ftitaUAm/iCigCw3eBbsoHEh9xXUgPWw1b
         dVNg==
X-Gm-Message-State: AOJu0YxOWBqluiBIkYUpfDda1RBB5a5UEG0jqAufY+uQqg4Zu+15RvPs
	r5BbpuF2OgA/5I5O5cECOsGkPIVx3QR2gS7GcjIk/ItWcg1Da8ilasUEydiQNq+4wizX3nda/9m
	8Jg==
X-Google-Smtp-Source: AGHT+IGUzOVThZ8xIg7bwHKaFQkUCNm4Xs+fuFoDhB2WRhkv0OaE4A7mGU07OFxXWS7Ocj7WmHxourXW2n8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:2d8a:b0:627:a787:abf4 with SMTP id
 00721157ae682-66a675dbfdcmr133157b3.3.1721409661902; Fri, 19 Jul 2024
 10:21:01 -0700 (PDT)
Date: Fri, 19 Jul 2024 10:21:00 -0700
In-Reply-To: <c42bff52-1058-4bff-be90-5bab45ed57be@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <c42bff52-1058-4bff-be90-5bab45ed57be@gmail.com>
Message-ID: <ZpqgfETiBXfBfFqU@google.com>
Subject: Re: [BUG] =?utf-8?Q?arch=2Fx86=2Fkvm=2Fvmx?= =?utf-8?Q?=2Fpmu=5Fintel=2Ec=3A54=3A_error=3A_dereference_of_NULL_?=
 =?utf-8?B?4oCYcG1j4oCZ?= [CWE-476]
From: Sean Christopherson <seanjc@google.com>
To: Mirsad Todorovac <mtodorovac69@gmail.com>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org, Like Xu <likexu@tencent.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 19, 2024, Mirsad Todorovac wrote:
> Hi,
>=20
> In the build of 6.10.0 from stable tree, the following error was detected=
.
>=20
> You see that the function get_fixed_pmc() can return NULL pointer as a re=
sult
> if msr is outside of [base, base + pmu->nr_arch_fixed_counters) interval.
>=20
> kvm_pmu_request_counter_reprogram(pmc) is then called with that NULL poin=
ter
> as the argument, which expands to .../pmu.h
>=20
> #define pmc_to_pmu(pmc)   (&(pmc)->vcpu->arch.pmu)
>=20
> which is a NULL pointer dereference in that speculative case.

I'm somewhat confused.  Did you actually hit a BUG() due to a NULL-pointer
dereference, are you speculating that there's a bug, or did you find some s=
peculation
issue with the CPU?

It should be impossible for get_fixed_pmc() to return NULL in this case.  T=
he
loop iteration is fully controlled by KVM, i.e. 'i' is guaranteed to be in =
the
ranage [0..pmu->nr_arch_fixed_counters).

And the input @msr is "MSR_CORE_PERF_FIXED_CTR0 +i", so the if-statement ex=
pands to:

	if (MSR_CORE_PERF_FIXED_CTR0 + [0..pmu->nr_arch_fixed_counters) >=3D MSR_C=
ORE_PERF_FIXED_CTR0 &&
	    MSR_CORE_PERF_FIXED_CTR0 + [0..pmu->nr_arch_fixed_counters) < MSR_CORE=
_PERF_FIXED_CTR0 + pmu->nr_arch_fixed_counters)

i.e. is guaranteed to evaluate true.

Am I missing something?

> arch/x86/kvm/vmx/pmu_intel.c
> ----------------------------
>  37 static void reprogram_fixed_counters(struct kvm_pmu *pmu, u64 data)
>  38 {
>  39         struct kvm_pmc *pmc;
>  40         u64 old_fixed_ctr_ctrl =3D pmu->fixed_ctr_ctrl;
>  41         int i;
>  42=20
>  43         pmu->fixed_ctr_ctrl =3D data;
>  44         for (i =3D 0; i < pmu->nr_arch_fixed_counters; i++) {
>  45                 u8 new_ctrl =3D fixed_ctrl_field(data, i);
>  46                 u8 old_ctrl =3D fixed_ctrl_field(old_fixed_ctr_ctrl, =
i);
>  47=20
>  48                 if (old_ctrl =3D=3D new_ctrl)
>  49                         continue;
>  50=20
>  51 =E2=86=92               pmc =3D get_fixed_pmc(pmu, MSR_CORE_PERF_FIXE=
D_CTR0 + i);
>  52=20
>  53                 __set_bit(KVM_FIXED_PMC_BASE_IDX + i, pmu->pmc_in_use=
);
>  54 =E2=86=92               kvm_pmu_request_counter_reprogram(pmc);
>  55         }
>  56 }
> ----------------------------
>=20
> arch/x86/kvm/vmx/../pmu.h
> -------------------------
>  11 #define pmc_to_pmu(pmc)   (&(pmc)->vcpu->arch.pmu)
> .
> .
> .
> 152 /* returns fixed PMC with the specified MSR */
> 153 static inline struct kvm_pmc *get_fixed_pmc(struct kvm_pmu *pmu, u32 =
msr)
> 154 {
> 155         int base =3D MSR_CORE_PERF_FIXED_CTR0;
> 156=20
> 157         if (msr >=3D base && msr < base + pmu->nr_arch_fixed_counters=
) {
> 158                 u32 index =3D array_index_nospec(msr - base,
> 159                                                pmu->nr_arch_fixed_cou=
nters);
> 160=20
> 161                 return &pmu->fixed_counters[index];
> 162         }
> 163=20
> 164         return NULL;
> 165 }
> .
> .
> .
> 228 static inline void kvm_pmu_request_counter_reprogram(struct kvm_pmc *=
pmc)
> 229 {
> 230         set_bit(pmc->idx, pmc_to_pmu(pmc)->reprogram_pmi);
> 231         kvm_make_request(KVM_REQ_PMU, pmc->vcpu);
> 232 }
> .
> .
> .
> -------------------------
> 76d287b2342e1
> Offending commits are: 76d287b2342e1 and 4fa5843d81fdc.
>=20
> I am not familiar with this subset of code, so I do not know the right co=
de to implement
> for the case get_fixed_pmc(pmu, MSR_CORE_PERF_FIXED_CTR0 + i) returns NUL=
L.
>=20
> Hope this helps.
>=20
> Best regards,
> Mirsad Todorovac

