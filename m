Return-Path: <kvm+bounces-23260-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 307569483BC
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 22:54:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 543311C20F57
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 20:54:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1537216BE38;
	Mon,  5 Aug 2024 20:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NFxZimmP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE6C08469
	for <kvm@vger.kernel.org>; Mon,  5 Aug 2024 20:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722891255; cv=none; b=aWHgicgZVGFOKTJDYP5w4qmbqv/NZC/H+0HpZerAtGtpmnhpLRBearWS/6KV4zs0gkaJDcJ9JbHfZRNP3GKnoaWDAnuDvQRC4Q/Y0Vzf2aM0UGjyJ26/B9Yhp1hyROETSje7viDWRfQ1kC6BPEBcKgpmyESEAzGKWEm31R3EjjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722891255; c=relaxed/simple;
	bh=4K6QTR6HvNRPQ7887+ZOCG9zsjAWM1Dl8u50rzFuCt8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UhPwcXplSZIKmjowYeKuhFKmE8DJ/XS3FXnNFWFHokEsJ88noAL3fjmzTb5GXKzm7oFbEdZm1VrRDhKg7b4SPrtBSXMWJkd3Wp3AZQiVqycdVMeNHsA9v6eWK3d4+pw2sfPkfWuEUUSYFiYCYNbJMaE7rumXfQkqSlaEUffpZ64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NFxZimmP; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e0be1808a36so6675763276.1
        for <kvm@vger.kernel.org>; Mon, 05 Aug 2024 13:54:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722891253; x=1723496053; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NMlpeHo+HyY4kal0mMvXGCf6/Wgtc0+eV5pFZe1YOkg=;
        b=NFxZimmPaArlkQJfBHjNs3otTKq/FFuCaQD2vN8KvNSOfjT2d7wUDj8+pqK8uFnyYX
         FuG95kFwa5bVumzinX6Qtt7+5Rof4HOfrndMdINh5WCzbclyxya7d286Oo5KhNnkDv0e
         c2KOgi6NAMSgp097r4NwO3OxTq8ZvZl0GFXblAkHqyCZ8JXUifMJNFOw1erX58XHv+gO
         MzWm8l2ATZUkb3Rt8KH/AmRc1PyIQT4x0OiVtjo2MAI2Pk/uSI6prkvyBqVXgV0NsKzO
         uJGh7D9aexNcdwAz77ViO7Glcrf4R0uJvEkkGG0Cj+vPPDCL6hwKFK/yEQOprKX9w/a1
         ZCIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722891253; x=1723496053;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=NMlpeHo+HyY4kal0mMvXGCf6/Wgtc0+eV5pFZe1YOkg=;
        b=UuZCizRoTWV+bkZlccbvRaO4PKANeuXihtAsYG6oVw3/kBGIsVuCnNh4c84/Si2amF
         or34F95YQdTRzUplOUiQUEk7PsRz/0lmEXNWqyuj5HlwVp7fPJRn2r9bdMkIW28KH7jo
         83I8KNFGF/GfX8AkR7Kk2q0R6rZFmWmRJsjMb2s0wHCA2cTtgcW5g0SEuduwfObHPKof
         MwcO3tJsXDDQ1xs3BLxjOs/gdIGaXV5LFa1oSCjkENzl1iya226q4/LqXfjTnSje0ojF
         vl2MgLF4hCr03wESX+HzZ0dQwixf0KHpuuBEwSruZMZuYCYz1DCvroBqcG8CvUZuc31n
         mRkQ==
X-Gm-Message-State: AOJu0Yw19oPiE/fElWHDenSKZWhnuycNpYHrcXAmehFNoA3RH0AnR61S
	h2qvnBy40t2vqrc68C8dCi47Zh8EEFfwNajHv04VK+R9tzz79GjIUycPSGWW4lzVNPcqDXHn/yo
	U8Q==
X-Google-Smtp-Source: AGHT+IH5AyNFdYN4/Gz/qGAS0tjwBQNkFLZjkGowb/SR6Kr7Xn6v/UbkFeCWwxD/z7GlyKyujyrajh9pOz8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:c08:b0:e0b:bafe:a7f3 with SMTP id
 3f1490d57ef6-e0bde428581mr567572276.11.1722891252816; Mon, 05 Aug 2024
 13:54:12 -0700 (PDT)
Date: Mon, 5 Aug 2024 13:54:11 -0700
In-Reply-To: <b6569c6d40317e957cff9309dcfe943d72544b60.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240802151608.72896-1-mlevitsk@redhat.com> <20240802151608.72896-2-mlevitsk@redhat.com>
 <Zq0A9R5R_MAFrqTP@google.com> <cdb61fa7cc5cfe69b030493ea566cbf40f3ec2e1.camel@redhat.com>
 <ZrEAXVhH3w6Q0tIy@google.com> <b6569c6d40317e957cff9309dcfe943d72544b60.camel@redhat.com>
Message-ID: <ZrE78zQYU95o6QCq@google.com>
Subject: Re: [PATCH v2 1/2] KVM: x86: relax canonical check for some x86
 architectural msrs
From: Sean Christopherson <seanjc@google.com>
To: mlevitsk@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Ingo Molnar <mingo@redhat.com>, x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Chao Gao <chao.gao@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 05, 2024, mlevitsk@redhat.com wrote:
> =D0=A3 =D0=BF=D0=BD, 2024-08-05 =D1=83 09:39 -0700, Sean Christopherson =
=D0=BF=D0=B8=D1=88=D0=B5:
> > On Mon, Aug 05, 2024, mlevitsk@redhat.com=C2=A0wrote:
> > > =D0=A3 =D0=BF=D1=82, 2024-08-02 =D1=83 08:53 -0700, Sean Christophers=
on =D0=BF=D0=B8=D1=88=D0=B5:
> > > > > > > Checking kvm_cpu_cap_has() is wrong.=C2=A0 What the _host_ su=
pports is irrelevant,
> > > > > > > what matters is what the guest CPU supports, i.e. this should=
 check guest CPUID.
> > > > > > > Ah, but for safety, KVM also needs to check kvm_cpu_cap_has()=
 to prevent faulting
> > > > > > > on a bad load into hardware.=C2=A0 Which means adding a "gove=
rned" feature until my
> > > > > > > CPUID rework lands.
> > >=20
> > > Well the problem is that we passthrough these MSRs, and that means th=
at the guest
> > > can modify them at will, and only ucode can prevent it from doing so.
> > >=20
> > > So even if the 5 level paging is disabled in the guest's CPUID, but h=
ost supports it,
> > > nothing will prevent the guest to write non canonical value to one of=
 those MSRs,=C2=A0
> > > and later KVM during migration or just KVM_SET_SREGS will fail.
> > =C2=A0
> > Ahh, and now I recall the discussions around the virtualization holes w=
ith LA57.
> >=20
> > > Thus I used kvm_cpu_cap_has on purpose to make KVM follow the actual =
ucode
> > > behavior.
> >=20
> > I'm leaning towards having KVM do the right thing when emulation happen=
s to be
> > triggered.=C2=A0 If KVM checks kvm_cpu_cap_has() instead of guest_cpu_c=
ap_has() (looking
> > at the future), then KVM will extend the virtualization hole to MSRs th=
at are
> > never passed through, and also to the nested VMX checks.=C2=A0 Or I sup=
pose we could
> > add separate helpers for passthrough MSRs vs. non-passthrough, but that=
 seems
> > like it'd add very little value and a lot of maintenance burden.
> >=20
> > Practically speaking, outside of tests, I can't imagine the guest will =
ever care
> > if there is inconsistent behavior with respect to loading non-canonical=
 values
> > into MSRs.
> >=20
>=20
> Hi,
>=20
> If we weren't allowing the guest (and even nested guest assuming that L1
> hypervisor allows it) to write these MSRs directly, I would have agreed w=
ith
> you, but we do allow this.
>=20
> This means that for example a L2, even a malicious L2, can on purpose wri=
te
> non canonical value to one of these MSRs, and later on, KVM could kill th=
e L0
                                                                           =
  L1?
> due to canonical check.

Ugh, right, if L1 manually saves/restores MSRs and happens to trigger emula=
tion
on WRMSR at the 'wrong" time.

Host userspace save/restore would suffer the same problem.  We could grant =
host
userspace accesses an exception, but that's rather pointless.

> Or L1 (not Linux, because it only lets canonical GS_BASE/FS_BASE), allow =
the
> untrusted userspace to write any value to say GS_BASE, thus allowing
> malicious L1 userspace to crash L1 (also a security violation).

FWIW, I don't think this is possible.  WR{FS,GS}BASE and other instructions=
 that
load FS/GS.base honor CR4.LA57, it's only WRMSR that does not.

> IMHO if we really want to do it right, we need to disable pass-though of
> these MSRs if ucode check is more lax than our check, that is if L1 is
> running without 5 level paging enabled but L0 does have it supported.
>
> I don't know if this configuration is common, and thus how much this will
> affect performance.

MSR_FS_BASE and SR_KERNEL_GS_BASE are hot spots when WR{FS,GS}BASE are unsu=
pported,
or if the guest kernels doesn't utilize those instructions.

All in all, I agree it's not worth trying to plug the virtualization hole f=
or MSRs,
especially since mimicking hardware yields much simpler code overall.  E.g.=
 add
a dedicated MSR helper, and have that one check kvm_cpu_cap_has(), includin=
g in
VM-Entry flows, but keep the existing is_noncanonical_address() for all non=
-WRMSR
path.

Something like this?

static inline bool is_noncanonical_msr_value(u64 la)
{
	u8 virt_addr_bits =3D kvm_cpu_cap_has(X86_FEATURE_LA57) ? 57 : 48;

	return !__is_canonical_address(la, virt_addr_bits);
}

