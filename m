Return-Path: <kvm+bounces-62352-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id C8010C41646
	for <lists+kvm@lfdr.de>; Fri, 07 Nov 2025 20:09:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id E452E4E73EF
	for <lists+kvm@lfdr.de>; Fri,  7 Nov 2025 19:09:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EFB82D7805;
	Fri,  7 Nov 2025 19:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="w9jQ924h"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1BD326CE3F
	for <kvm@vger.kernel.org>; Fri,  7 Nov 2025 19:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762542547; cv=none; b=EguVoNZvC6GMI35MaR3aXWgo8IgQChFrLje0bB8sn1iLRfxrfyEGrDYGrPsUiqfdK7kK+17Xwh9u6TiVzJmEneCfDK5YklmDzAs9huZkEkMBA4F2IVPo73fPdwkz+Q2iFqRSfxpkw5Z1sW+eBMtScIn7hYqQngezMA5bYhSzOmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762542547; c=relaxed/simple;
	bh=8Sh01qsQnFqXTjo/cJT7q03gWfer8OL1PrCWFV7VHIA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=c5dPPQSvgFwmUOtS2se/AOI57zGuzns0EYAj2hj4S5pl4ykbXVTIw5SL2PTqwMNPmd94Wms7Cra9HSJPdJItLTPhynzrEHXxA+eAj7ex523GBgqEpwDgZ6hqfDxIlbL+V95wj/e28fjCOmCoa1bAD89o5ltwdX5hzJl2MCPhfXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=w9jQ924h; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-340c07119bfso2541246a91.2
        for <kvm@vger.kernel.org>; Fri, 07 Nov 2025 11:09:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762542545; x=1763147345; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=X77mgdPoU1VHaudK74YxkC46spvrpO5NvEWTm3wV9vw=;
        b=w9jQ924hxBWCZu74pfwvP2w2UALLbIuD8d/t+P0BXcMZ+g5GYzf6FEpau8MYO0etbv
         Bizl4Dvtw7fi7vLeb/b1eUueeaLevKmQ/BZqeCSWc0JBLWd8pqm3hBJXteFtVvJvOVzw
         OUAppJqvrazDwOvBXWyrPsPNXt7W4hxH0kNOc+xXgR3jso67oHQfVwlP52XwHdj6q+Uh
         Ot7B5w34uyoAVA7hmgxRvtlvaLvXduLRJ0ToJFdXBXajD47iZgBqqKs2W/58/wSndkgD
         kdRn3bdmWcqTACG/pF57ncxnPG2l7cMTArwFghG4NHLoLtmNrWExh+EWKotJFPP11Dz3
         chWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762542545; x=1763147345;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=X77mgdPoU1VHaudK74YxkC46spvrpO5NvEWTm3wV9vw=;
        b=lLXMaTV638q8Bw98PV3fNql1wiIt9JJq4vWHuu+GukpnOh3DP13BnEcXpgXGoL0cjG
         188aYLmkoMa5LF0yqV/ELt4DdfJftlQTsyr4eTYyb9ONCvbgA95wppBKRTH9eR15/DDy
         G1ywUpeEu98XiARIZwOceJ687dSiyInh4V7wj38GfHOzdRmUuzShS/hjep/TKmUvMgVU
         cHFv+YGLouxHxZVrBZbl7itp5a3mWuBnuE0qBSMGrghYS4MUfQ1cpwX8j+hi7g41B7Wm
         Nk1mWHT2pUV8H/KX7NubqhRE91et6PmtnvDuA9EL1S+5as2s3R90mRQyM8GNdrB07DPw
         Owtg==
X-Forwarded-Encrypted: i=1; AJvYcCWYffEEURD/3eUbz4kY8PNEHget8+k/cWBhOOL5e4/KHQDfT5OVodRZHJ5r1OBVy+oEwrI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyiF7qKTZDhHV8QBvTvGAWBrGR1sFicva13hJj54ASXPuxG+ghJ
	0xS9a9W5OOfVwa1PlR2FpkzClXa8QqYUG1cIE9Om84zY8NNjBFyoX075HlN5VXcSnw5C7eNObdr
	uqYIjiQ==
X-Google-Smtp-Source: AGHT+IGH7LL6GV2gLbWjUzWfRR4A8LykKgi383PZhU1U0IWxftK363fN1GI5ZstiN7+YwdfTqgRZ/o9SlrQ=
X-Received: from pjbdt5.prod.google.com ([2002:a17:90a:fa45:b0:341:7640:eb1e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3811:b0:340:29ce:f7fa
 with SMTP id 98e67ed59e1d1-3436cb7ae1emr293287a91.7.1762542545053; Fri, 07
 Nov 2025 11:09:05 -0800 (PST)
Date: Fri, 7 Nov 2025 11:09:03 -0800
In-Reply-To: <599eb00e-a034-4809-8f5a-893597016133@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251106101138.2756175-1-binbin.wu@linux.intel.com>
 <aQ1kG5u8GPdEwoEy@intel.com> <599eb00e-a034-4809-8f5a-893597016133@linux.intel.com>
Message-ID: <aQ5Dz4UznE9a0N2-@google.com>
Subject: Re: [PATCH] KVM: x86: Add a help to dedup loading guest/host XCR0 and XSS
From: Sean Christopherson <seanjc@google.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: Chao Gao <chao.gao@intel.com>, pbonzini@redhat.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 07, 2025, Binbin Wu wrote:
>=20
>=20
> On 11/7/2025 11:14 AM, Chao Gao wrote:
> > s/help/helper in the subject.
> >=20
> > On Thu, Nov 06, 2025 at 06:11:38PM +0800, Binbin Wu wrote:
> > > Add and use a helper, kvm_load_xfeatures(), to dedup the code that lo=
ads
> > > guest/host xfeatures by passing XCR0 and XSS values accordingly.
> > >=20
> > > No functional change intended.
> > >=20
> > > Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
> > Reviewed-by: Chao Gao <chao.gao@intel.com>
> >=20
> > <snip>
> >=20
> > > @@ -11406,7 +11391,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *=
vcpu)
> > > 	vcpu->mode =3D OUTSIDE_GUEST_MODE;
> > > 	smp_wmb();
> > >=20
> > > -	kvm_load_host_xfeatures(vcpu);
> > > +	kvm_load_xfeatures(vcpu, kvm_host.xcr0, kvm_host.xss);
> > Nit: given that xcr0/xss are either guest or host values, would it be s=
lightly
> > better for this helper to accept a boolean (e.g., bool load_guest) to c=
onvey
> > that the API loads guest (or host) values rather than arbitrary xcr0/xs=
s
> > values? like fpu_swap_kvm_fpstate().
>=20
> Make sense.

I don't love passing true/false, but I Xiaoyao does make a good a point tha=
t
subtly requiring the caller to pass vcpu->arch.xcr0 vs. kvm_host.xcr0 is we=
ird
and confusing.

> > static void kvm_load_xfeatures(struct kvm_vcpu *vcpu, bool load_guest)
> > {
> > 	u64 xcr0 =3D load_guest ? vcpu->arch.xcr0 : kvm_host.xcr0;
> > 	u64 xss  =3D load_guest ? vcpu->arch.ia32_xss : kvm_host.xss;
>=20
> Since they are only used once, I even want to open code them as:=20

+100, I find your version much more intuitive.

> static void kvm_load_xfeatures(struct kvm_vcpu *vcpu, bool load_guest)
> {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (vcpu->arch.guest_state_protected)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return;
>=20
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (kvm_is_cr4_bit_set(vcpu, X86_CR4_OSXSAVE)=
) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (vcpu->arch.xc=
r0 !=3D kvm_host.xcr0)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 xsetbv(XCR_XFEATURE_ENABLED_MASK,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0load_guest ? vcpu->arch.xcr0 : kvm_ho=
st.xcr0);
>=20
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (guest_cpu_cap=
_has(vcpu, X86_FEATURE_XSAVES) &&
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 vcp=
u->arch.ia32_xss !=3D kvm_host.xss)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 wrmsrq(MSR_IA32_XSS,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0load_guest ? vcpu->arch.ia32_xss : kv=
m_host.xss);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> }
>=20
> >=20
> > 	if (vcpu->arch.guest_state_protected)
> > 		return;
> >=20
> > > 	/*
> > > 	 * Sync xfd before calling handle_exit_irqoff() which may
> > >=20
> > > base-commit: a996dd2a5e1ec54dcf7d7b93915ea3f97e14e68a
> > > prerequisite-patch-id: 9aafd634f0ab2033d7b032e227d356777469e046
> > > prerequisite-patch-id: 656ce1f5aa97c77a9cf6125713707a5007b2c7ba
> > > prerequisite-patch-id: d6328b8c0fdb8593bb534ab7378821edcf9f639d
> > > prerequisite-patch-id: c7f36d1cedc4ae6416223d2225460944629b3d4f
> > > --=20
> > > 2.46.0
> > >=20
> > >=20
>=20

