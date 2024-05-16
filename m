Return-Path: <kvm+bounces-17537-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B545C8C788F
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 16:43:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2A7D0B21A5C
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 14:43:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0B5414B971;
	Thu, 16 May 2024 14:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tmR3h53g"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5B1E1487E1
	for <kvm@vger.kernel.org>; Thu, 16 May 2024 14:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715870585; cv=none; b=lHLXJ4r7Eca8dW4Eq416tcoEGTkXuZa25H+D7o+vVCfkI5UFPGw3RrhT1cUIpQUezMUnVB4VldtZaTWnQ/ZdqljP3k3cJKJvIh2CXZespkYQekFYq4KtgzQQvWIC7++xzus8+sXgGih4JgLoxorn4KQ8QWsCXuNzWOd4xGJub/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715870585; c=relaxed/simple;
	bh=8riy7heOl4++APz40BP4z5UOenBVFzksbUbLZvmj/ro=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=q+LazUkw1naAAn7yfkNKQPLuPcRf5/XA23Pk112nWBmQg9nI4EflfQW1HpWI1AH3VhcFQe0her/ZVAagf08A/ypVr3Gk90v9qZUHN3+igL0HCGwVKofzJS7x2PxnsiUdIcNeFfg9ILHxwy5Dx+o4A4BjJKU6PAwRFOo3z1ab8M8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tmR3h53g; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1ecd9a80d84so68808095ad.0
        for <kvm@vger.kernel.org>; Thu, 16 May 2024 07:43:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715870583; x=1716475383; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=14IL7CrrslTsTRZJKgKh3jedpCPpSOvWG6h4FuG3j7k=;
        b=tmR3h53gW6I8/LIpc19+vUamc9HhB87vAmQ2GA0+cpxXHDx6QMvO+qtBrDK7UOUY++
         Cdor9KgcFqyJ7/fVHuTt6Z27BkB1wXQPqXeT9NYuAsFvtwQJUBXjm/BEvsE+rBi+4frs
         rXeXKvfdL6gUXsxUd38D47FuETG+E/r8nnipEcTHgemungmh3885vimv76eTNi5Em/ks
         TNuJI5/udveV1QBgRrTkMbQ0/W9sD8UzHxtTQ6oLxIvyegxcct1lRZs7NHG0ok83tC5j
         JTAK4v2o9wJwbKkmubteyygx4emUyBhpb7BuGQ5bHEeCG1vEAym1pLiTOBygtwfdDiOF
         ZSpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715870583; x=1716475383;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=14IL7CrrslTsTRZJKgKh3jedpCPpSOvWG6h4FuG3j7k=;
        b=wWsDgfk1Lazcy5hJKc8tcJ+0erfAdvoHmTDGeImUO2KCv7LZoLjGzYLgSadRv57uCO
         +VrBEkUme7POKBNSfJzgaS6kWuOVJyoNCMlTcPu0gXUykpcwBfTz2on0KgrhzpSOFT9P
         gS84GjD6PCupfxZyRvJHJldNR5PADY5JDi4FfB+PWmbXcKurkpPd2dTd1cbkE9/y1d5H
         h+rB7EYESbFkgevacPSBr8CBqg1muj40neA1FD+iPSFMX+EBJjl4vQpGnE1IDc5ukOMI
         Ncptiqp65tVryjafyeUL5W2q8a4ex9pqc5sIuR+sAeLF64QyWSdY/R5VxbdnFMPhejw5
         n/fA==
X-Forwarded-Encrypted: i=1; AJvYcCVXuMjkoGWggt2bA0WSR6mYkVsl7nuPrYBrf/yjpxbC1wsF6DdsXYOIw2qvkpubRem1qGrntysogA4RgcMttBTh6ATB
X-Gm-Message-State: AOJu0YzhqrH5SHUKrBAYhfhOwwpI6MCvBVXBwKJssN4LtvSHHj5aKAhP
	VezjoHf2yrinmM1PPOSycZqeM8G0AykIHxQRy7UrsKWglk0RE1veGvivLMz3iryAZFtAFSS3vtF
	MKA==
X-Google-Smtp-Source: AGHT+IHSiDA64iI3XfiWglUYLYFEusoIG63LOrq7HIjE4w99t1sJ4BYgoAmXrm2NNj1vVHrAFT7OXoRQVy8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:c40f:b0:1e2:3051:81a9 with SMTP id
 d9443c01a7336-1ef42e6c1b5mr7298125ad.2.1715870582774; Thu, 16 May 2024
 07:43:02 -0700 (PDT)
Date: Thu, 16 May 2024 07:43:01 -0700
In-Reply-To: <f77496b0-ee94-4690-803f-44650706640f@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240219074733.122080-1-weijiang.yang@intel.com>
 <20240219074733.122080-25-weijiang.yang@intel.com> <ZjLRnisdUgeYgg8i@google.com>
 <83bb5f3f-a374-4b0e-a26d-9a9d88561bbe@intel.com> <f77496b0-ee94-4690-803f-44650706640f@intel.com>
Message-ID: <ZkYbdaW-2p9wHwEL@google.com>
Subject: Re: [PATCH v10 24/27] KVM: x86: Enable CET virtualization for VMX and
 advertise to userspace
From: Sean Christopherson <seanjc@google.com>
To: Weijiang Yang <weijiang.yang@intel.com>
Cc: pbonzini@redhat.com, dave.hansen@intel.com, x86@kernel.org, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, peterz@infradead.org, 
	chao.gao@intel.com, rick.p.edgecombe@intel.com, mlevitsk@redhat.com, 
	john.allen@amd.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 16, 2024, Weijiang Yang wrote:
> On 5/6/2024 5:41 PM, Yang, Weijiang wrote:
> > On 5/2/2024 7:34 AM, Sean Christopherson wrote:
> > > On Sun, Feb 18, 2024, Yang Weijiang wrote:
> > > > @@ -665,7 +665,7 @@ void kvm_set_cpu_caps(void)
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 F(AVX512_VPO=
PCNTDQ) | F(UMIP) | F(AVX512_VBMI2) | F(GFNI) |
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 F(VAES) | F(=
VPCLMULQDQ) | F(AVX512_VNNI) | F(AVX512_BITALG) |
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 F(CLDEMOTE) =
| F(MOVDIRI) | F(MOVDIR64B) | 0 /*WAITPKG*/ |
> > > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 F(SGX_LC) | F(BUS_LOCK_=
DETECT)
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 F(SGX_LC) | F(BUS_LOCK_=
DETECT) | F(SHSTK)
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 );
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* Set LA57 based on hardware capabi=
lity. */
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (cpuid_ecx(7) & F(LA57))
> > > > @@ -683,7 +683,8 @@ void kvm_set_cpu_caps(void)
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 F(SPEC_CTRL_=
SSBD) | F(ARCH_CAPABILITIES) | F(INTEL_STIBP) |
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 F(MD_CLEAR) =
| F(AVX512_VP2INTERSECT) | F(FSRM) |
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 F(SERIALIZE)=
 | F(TSXLDTRK) | F(AVX512_FP16) |
> > > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 F(AMX_TILE) | F(AMX_INT=
8) | F(AMX_BF16) | F(FLUSH_L1D)
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 F(AMX_TILE) | F(AMX_INT=
8) | F(AMX_BF16) | F(FLUSH_L1D) |
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 F(IBT)
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 );
> > > ...
> > >=20
> > > > @@ -7977,6 +7993,18 @@ static __init void vmx_set_cpu_caps(void)
> > > > =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (cpu_has_vmx_waitpkg())
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 kvm_cpu_cap_=
check_and_set(X86_FEATURE_WAITPKG);
> > > > +
> > > > +=C2=A0=C2=A0=C2=A0 /*
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0 * Disable CET if unrestricted_guest is un=
supported as KVM doesn't
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0 * enforce CET HW behaviors in emulator. O=
n platforms with
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0 * VMX_BASIC[bit56] =3D=3D 0, inject #CP a=
t VMX entry with error code
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0 * fails, so disable CET in this case too.
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0 */
> > > > +=C2=A0=C2=A0=C2=A0 if (!cpu_has_load_cet_ctrl() || !enable_unrestr=
icted_guest ||
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 !cpu_has_vmx_basic_no_h=
w_errcode()) {
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 kvm_cpu_cap_clear(X86_F=
EATURE_SHSTK);
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 kvm_cpu_cap_clear(X86_F=
EATURE_IBT);
> > > > +=C2=A0=C2=A0=C2=A0 }
> > > Oh!=C2=A0 Almost missed it.=C2=A0 This patch should explicitly kvm_cp=
u_cap_clear()
> > > X86_FEATURE_SHSTK and X86_FEATURE_IBT.=C2=A0 We *know* there are upco=
ming AMD CPUs
> > > that support at least SHSTK, so enumerating support for common code w=
ould yield
> > > a version of KVM that incorrectly advertises support for SHSTK.
> > >=20
> > > I hope to land both Intel and AMD virtualization in the same kernel r=
elease, but
> > > there are no guarantees that will happen.=C2=A0 And explicitly cleari=
ng both SHSTK and
> > > IBT would guard against IBT showing up in some future AMD CPU in adva=
nce of KVM
> > > gaining full support.
> >=20
> > Let me be clear on this, you want me to disable SHSTK/IBT with
> > kvm_cpu_cap_clear() unconditionally for now in this patch, and wait unt=
il
> > both AMD's SVM patches and this series are ready for guest CET, then re=
move
> > the disabling code in this patch for final merge, am I right?

No, allow it to be enabled for VMX, but explicitly disable it for SVM, i.e.

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 4aaffbf22531..b3df12af4ee6 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5125,6 +5125,10 @@ static __init void svm_set_cpu_caps(void)
        kvm_caps.supported_perf_cap =3D 0;
        kvm_caps.supported_xss =3D 0;
=20
+       /* KVM doesn't yet support CET virtualization for SVM. */
+       kvm_cpu_cap_clear(X86_FEATURE_SHSTK);
+       kvm_cpu_cap_clear(X86_FEATURE_IBT);
+
        /* CPUID 0x80000001 and 0x8000000A (SVM features) */
        if (nested) {
                kvm_cpu_cap_set(X86_FEATURE_SVM);

Then the SVM series can simply delete those lines when all is ready.

