Return-Path: <kvm+bounces-1504-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 189AF7E869E
	for <lists+kvm@lfdr.de>; Sat, 11 Nov 2023 00:32:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9D0F4280E90
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 23:32:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C99C03D3B1;
	Fri, 10 Nov 2023 23:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pH1ih8R0"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B0073D3A8
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 23:32:26 +0000 (UTC)
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB4AA118
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 15:32:25 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id 98e67ed59e1d1-2801b74012bso2831773a91.3
        for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 15:32:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699659145; x=1700263945; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Tud+bE186sEsTxHnGJN71rG4VKdLayo1gy2hjFesKXo=;
        b=pH1ih8R0gEt84XNCahVJccdH8jBsBAFpo8sYOdXNuIPta0YPRUFusmOj+MJZAkOC6q
         LgvU/exO0XVKqXgNMqZ4DBZNTkxgRXc9G4753AM5DjYehxhRtM2eCKxa4TBv/5OkoCRL
         tiOxsbJ7YbQIvgyFLF4jRyLdFqdpPT5ws2jWC3qHNTBr9TKUp3/ctwkOJvhdL48+3gTk
         h7uQJVAAgzIsDCyEwsUhZov6dLL5ONoQeAAkDJZDlpqXrsTsjwDBcAWm2t0xpCe1hEyG
         TmI24jX3gseNeOQfyQ5eZ0Ck0uDrzLwDDPLuPtLFij+Has07fsOuK6prAKe5TYTkpXZp
         Br+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699659145; x=1700263945;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Tud+bE186sEsTxHnGJN71rG4VKdLayo1gy2hjFesKXo=;
        b=w3pgebS9lMYzKkH0GFg8QPWxARb3CE6HA5RT9h3k8LjZPFBO8E6f/VhdZNusMtMm39
         LJ3kak4pjaJPPZZSMaono3232bPOInsOHkYrpZ5dKYug7Iqs99VN+7cdhvyB0a3FEClt
         7My/rRQzIQqmoCiQaC/JQNeJoH5LE9+LlOvyCfWidxD242ZN1SAfANFAS7K9Kgt8E9AY
         BDfaouVMDXrevF+V16kdGOHktSRa/eOfHnKIu2tZsUZHIAMdJj+7D34VJdRQDET/cVCN
         9rpg+TJKM9dxn8dlb6urp3hnSQCnQlUvP/qRXPjMyGbq4G/+jdD8yBT8N0P2hK5wRJdE
         xT9Q==
X-Gm-Message-State: AOJu0YzdIZ6C/mbRTxUenDaVFq4YwFhlLAp2pahFJlb0Ed+M/paLsdGy
	bm3yP7dVpPQAaWoW1cC7IA688eW+AsQ=
X-Google-Smtp-Source: AGHT+IEz36FDQxHFQYczhAwfBEtZdSCXT45UtKu5D5kiPgzi5oc2oI9EOh4sP8lTZoE1+eCT6h8tB8F0d4s=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:364c:b0:27f:fb7e:2ae3 with SMTP id
 nh12-20020a17090b364c00b0027ffb7e2ae3mr115243pjb.2.1699659145268; Fri, 10 Nov
 2023 15:32:25 -0800 (PST)
Date: Fri, 10 Nov 2023 15:32:23 -0800
In-Reply-To: <c85ffcdc-bf0a-4047-a29d-0ee1b595a227@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231110021306.1269082-1-seanjc@google.com> <20231110021306.1269082-9-seanjc@google.com>
 <c85ffcdc-bf0a-4047-a29d-0ee1b595a227@linux.intel.com>
Message-ID: <ZU69h65HwvnpjhjX@google.com>
Subject: Re: [PATCH v8 08/26] KVM: x86/pmu: Disallow "fast" RDPMC for
 architectural Intel PMUs
From: Sean Christopherson <seanjc@google.com>
To: Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kan Liang <kan.liang@linux.intel.com>, Jim Mattson <jmattson@google.com>, 
	Jinrong Liang <cloudliang@tencent.com>, Aaron Lewis <aaronlewis@google.com>, 
	Like Xu <likexu@tencent.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 10, 2023, Dapeng Mi wrote:
> On 11/10/2023 10:12 AM, Sean Christopherson wrote:
> > Inject #GP on RDPMC if the "fast" flag is set for architectural Intel
> > PMUs, i.e. if the PMU version is non-zero.  Per Intel's SDM, and confir=
med
> > on bare metal, the "fast" flag is supported only for non-architectural
> > PMUs, and is reserved for architectural PMUs.
> >=20
> >    If the processor does not support architectural performance monitori=
ng
> >    (CPUID.0AH:EAX[7:0]=3D0), ECX[30:0] specifies the index of the PMC t=
o be
> >    read. Setting ECX[31] selects =E2=80=9Cfast=E2=80=9D read mode if su=
pported. In this mode,
> >    RDPMC returns bits 31:0 of the PMC in EAX while clearing EDX to zero=
.
> >=20
> >    If the processor does support architectural performance monitoring
> >    (CPUID.0AH:EAX[7:0] =E2=89=A0 0), ECX[31:16] specifies type of PMC w=
hile ECX[15:0]
> >    specifies the index of the PMC to be read within that type. The foll=
owing
> >    PMC types are currently defined:
> >    =E2=80=94 General-purpose counters use type 0. The index x (to read =
IA32_PMCx)
> >      must be less than the value enumerated by CPUID.0AH.EAX[15:8] (thu=
s
> >      ECX[15:8] must be zero).
> >    =E2=80=94 Fixed-function counters use type 4000H. The index x (to re=
ad
> >      IA32_FIXED_CTRx) can be used if either CPUID.0AH.EDX[4:0] > x or
> >      CPUID.0AH.ECX[x] =3D 1 (thus ECX[15:5] must be 0).
> >    =E2=80=94 Performance metrics use type 2000H. This type can be used =
only if
> >      IA32_PERF_CAPABILITIES.PERF_METRICS_AVAILABLE[bit 15]=3D1. For thi=
s type,
> >      the index in ECX[15:0] is implementation specific.
> >=20
> > WARN if KVM ever actually tries to complete RDPMC for a non-architectur=
al
> > PMU as KVM doesn't support such PMUs, i.e. kvm_pmu_rdpmc() should rejec=
t
> > the RDPMC before getting to the Intel code.
> >=20
> > Fixes: f5132b01386b ("KVM: Expose a version 2 architectural PMU to a gu=
ests")
> > Fixes: 67f4d4288c35 ("KVM: x86: rdpmc emulation checks the counter inco=
rrectly")
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >   arch/x86/kvm/vmx/pmu_intel.c | 14 +++++++++++++-
> >   1 file changed, 13 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.=
c
> > index c6ea128ea7c8..80255f86072e 100644
> > --- a/arch/x86/kvm/vmx/pmu_intel.c
> > +++ b/arch/x86/kvm/vmx/pmu_intel.c
> > @@ -61,7 +61,19 @@ static struct kvm_pmc *intel_pmc_idx_to_pmc(struct k=
vm_pmu *pmu, int pmc_idx)
> >   static u32 intel_rdpmc_get_masked_idx(struct kvm_pmu *pmu, u32 idx)
> >   {
> > -	return idx & ~(INTEL_RDPMC_FIXED | INTEL_RDPMC_FAST);
> > +	/*
> > +	 * Fast RDPMC is only supported on non-architectural PMUs, which KVM
> > +	 * doesn't support.
> > +	 */
> > +	if (WARN_ON_ONCE(!pmu->version))

Gah, this WARN fires when the emulator pre-checks RDPMC via emulator_check_=
pmc()
-> kvm_pmu_is_valid_rdpmc_ecx.  I suspect I missed the splat due to split-l=
ock
detection spamming my kernel log (I'm running a sliiiightly old OVMF build)=
.

If this is the only issue with v8, I'll just drop the WARN and the changelo=
g
paragraph when applying.

