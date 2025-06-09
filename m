Return-Path: <kvm+bounces-48740-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FA7EAD20C6
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 16:23:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D3D12188BA15
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 14:23:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A45625C83C;
	Mon,  9 Jun 2025 14:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ix7v20EQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE0F9253944
	for <kvm@vger.kernel.org>; Mon,  9 Jun 2025 14:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749478990; cv=none; b=jd+mQaNl4GqTiGnoLpwQb+7Zp3OmLSOcPSgItcr2dtbUnJj0t1uwfT62+ajO8b29X23urj5YRQIrktXJOXUyKOrSwMLJOhUkd9RqxSwpzQDuLHEOVzABD39gSkLAkx0t7sbuTP/MnRxzUn6pPFOBBdDSN3ybF4lxyk1U6gbwKwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749478990; c=relaxed/simple;
	bh=Jj+Yt9zXtcRCfSDm7whUQ4ZIZ5JHddO5KlLP+fvfba4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=AQGNFcQJtpSdtPe+UMmKjVxBW4G6OCOgRZ5QRgZ+f9dixcuXUAIGz46HvFnDA7InHxKMKoFjUF23Fozl9vmEtlP2eeLVQUl/7kriEdDip1D4ncdZl0GetXz8ZYdewyMTNzI5XH+TmpaciPm0mipUKJwLj1lEySoLevGK5q2Tb8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ix7v20EQ; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2349fe994a9so31735955ad.1
        for <kvm@vger.kernel.org>; Mon, 09 Jun 2025 07:23:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749478988; x=1750083788; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7lLdTQdrM0ytHOS+CAmb5K/o5KQV3Zi0TqZM7kL4ZL0=;
        b=Ix7v20EQCfltUmRpI92FuSjgKVl5h/4BCa1w5LbO4E0rgxLmFWkosid6fR3GrVQNMw
         RS63T+ia7uv8xbcGvqglfCT/B2llC0OodQhdhBRJ/M9w1M7QLg2JJ3HBw/XKZsNVLTkB
         OpzQ37+0M4mX2jRiCe1COGqXnBjHIUJo/slqYGWZeiX4J4diRJ5TuhiX3YPTGnLApK78
         Qvl/LA/RlE3lz7o/duivPunW3TtyZebIvHenfFGSdwvjhHifrjRcRXBkyCqDr4bZiZI+
         BCwYn7DekeGjzLc9DVZRdopPgWtSdFyH6+bluN2AdSWy3tLeLFKmA5yZut4LV7KKu7KO
         BuMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749478988; x=1750083788;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=7lLdTQdrM0ytHOS+CAmb5K/o5KQV3Zi0TqZM7kL4ZL0=;
        b=vC4bj1pibBz+fhDWnrVtHB0i6XAqU1jHu0B43J2qJrRka3tHHI3ediCGddkmu8NPMU
         bxPvLPRAykYr3dspoaupAt5DoAscyWVq4oJ263VKwUCBM7ZCw+Kl6J14RCrh3MClEMI7
         bt7n7lWbQKOJ8bGGm+Wa18YW+aURGOFV8dkZ06YmjY7BcaJM82Fl8rP6H+ukOK4bmHgk
         XEMahElyUFK6gRTTnFGSiVnvXCGnQs3vdu0ZMt+6xP2ITYAEhhYbMk2J37VFR1WxSR3z
         tXSavQmTmWOf4I7bvy2NGBJ+5yPABjGyMNgnGXnGiJwVy3kTvX8bWHQbAu7E75q35RUJ
         wa+w==
X-Forwarded-Encrypted: i=1; AJvYcCUOYX2rQ0MweZj6UiJS+RqD08XQwuGT269L0/ulIAW7RG6vCzNXTH5KhR/eAIKwYqRChMA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyDtNhrzgVsIy8FJ57Dw7QgkYY1iM/2leEPo8vRxmXphi8WnQdz
	b6oSXivRUQXhgTYVLFztMwUtMmE2l55LVYFVO/pat1VjYPIabPNkqlDl2AB3e14s7J69WYeMVYz
	21fw4wA==
X-Google-Smtp-Source: AGHT+IEXWjGA+7EHOmgVdxQCVZsaeyZ/Yk7vf9FpuYgFPmjBt1Dx/ah2+gxQKH2vNCJYIKyguPOQGlf/Vfs=
X-Received: from pjuj14.prod.google.com ([2002:a17:90a:d00e:b0:311:485b:d057])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5345:b0:311:ffe8:20e9
 with SMTP id 98e67ed59e1d1-31347308c79mr21849041a91.17.1749478988192; Mon, 09
 Jun 2025 07:23:08 -0700 (PDT)
Date: Mon, 9 Jun 2025 07:23:06 -0700
In-Reply-To: <4a66adfa-fc10-4668-9986-55f6cf231988@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20211207095230.53437-1-jiangshanlai@gmail.com>
 <51bb6e75-4f0a-e544-d2e4-ff23c5aa2f49@redhat.com> <4a66adfa-fc10-4668-9986-55f6cf231988@zytor.com>
Message-ID: <aEbuSmAf4aAHztwC@google.com>
Subject: Re: [PATCH] KVM: X86: Raise #GP when clearing CR0_PG in 64 bit mode
From: Sean Christopherson <seanjc@google.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Lai Jiangshan <jiangshanlai@gmail.com>, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Lai Jiangshan <laijs@linux.alibaba.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, 
	Wanpeng Li <wanpengli@tencent.com>, Jim Mattson <jmattson@google.com>, 
	Joerg Roedel <joro@8bytes.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 06, 2025, H. Peter Anvin wrote:
> On 2021-12-09 09:55, Paolo Bonzini wrote:
> > On 12/7/21 10:52, Lai Jiangshan wrote:
> > > From: Lai Jiangshan <laijs@linux.alibaba.com>
> > >=20
> > > In the SDM:
> > > If the logical processor is in 64-bit mode or if CR4.PCIDE =3D 1, an
> > > attempt to clear CR0.PG causes a general-protection exception (#GP).
> > > Software should transition to compatibility mode and clear CR4.PCIDE
> > > before attempting to disable paging.
> > >=20
> > > Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
> > > ---
> > > =C2=A0 arch/x86/kvm/x86.c | 3 ++-
> > > =C2=A0 1 file changed, 2 insertions(+), 1 deletion(-)
> > >=20
> > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > index 00f5b2b82909..78c40ac3b197 100644
> > > --- a/arch/x86/kvm/x86.c
> > > +++ b/arch/x86/kvm/x86.c
> > > @@ -906,7 +906,8 @@ int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned
> > > long cr0)
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 !load_pdptrs(v=
cpu, kvm_read_cr3(vcpu)))
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return 1;
> > > -=C2=A0=C2=A0=C2=A0 if (!(cr0 & X86_CR0_PG) && kvm_read_cr4_bits(vcpu=
, X86_CR4_PCIDE))
> > > +=C2=A0=C2=A0=C2=A0 if (!(cr0 & X86_CR0_PG) &&
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (is_64_bit_mode(vcpu) || =
kvm_read_cr4_bits(vcpu,
> > > X86_CR4_PCIDE)))
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return 1;
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 static_call(kvm_x86_set_cr0)(vcpu, cr0=
);
> > >=20
> >=20
> > Queued, thanks.
> >=20
>=20
> Have you actually checked to see what real CPUs do in this case?

I have now, and EMR at least behaves as the SDM describes.  Why do you ask?


kvm_intel: Clearing CR0.PG faulted (vector =3D 13)


diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index f79604bc0127..f90ad464ab7e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8637,6 +8637,23 @@ void vmx_exit(void)
        kvm_x86_vendor_exit();
 }
=20
+static noinline void vmx_disable_paging(void)
+{
+       unsigned long cr0 =3D native_read_cr0();
+       long vector =3D -1;
+
+       asm volatile("1: mov %1, %%cr0\n\t"
+                    "   mov %2, %%cr0\n\t"
+                    "2:"
+                    _ASM_EXTABLE_FAULT(1b, 2b)
+                    : "+a" (vector)
+                    : "r" (cr0 & ~X86_CR0_PG), "r" (cr0)
+                    : "cc", "memory" );
+
+       pr_warn("Clearing CR0.PG %s (vector =3D %ld)\n",
+               vector < 0 ? "succeeded" : "faulted", vector);
+}
+
 int __init vmx_init(void)
 {
        int r, cpu;
@@ -8644,6 +8661,8 @@ int __init vmx_init(void)
        if (!kvm_is_vmx_supported())
                return -EOPNOTSUPP;
=20
+       vmx_disable_paging();
+
        /*
         * Note, hv_init_evmcs() touches only VMX knobs, i.e. there's nothi=
ng
         * to unwind if a later step fails.


