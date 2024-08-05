Return-Path: <kvm+bounces-23238-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BCF78947F7B
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 18:40:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 72C1F283F6A
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 16:40:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7727515E5C1;
	Mon,  5 Aug 2024 16:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eRmxFC6C"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 398A315B97E
	for <kvm@vger.kernel.org>; Mon,  5 Aug 2024 16:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722876001; cv=none; b=krSOAcbzSz3NFAcvZeHiea/P2/Asrvva4FgSKL2IV/h4rXwnl9IjZnnYKMPjpZTIDRTF/nhlTgid2/Yi3AXDQAVhr0Og18ShjfOiCOW1vXOQVUv6+s6hy5qoxt9IvkbJFxZKqzLXDQs7e6ZbcjoYE29rTTDE8+XjOwfL80pKI6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722876001; c=relaxed/simple;
	bh=HE21Lk/g+GMpOYIkhNOouGn5ag+Wle5EMn3XmDNoy7Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ilMFr2er1xh0dAVoiODY4MkpJlOiKxf4exiSoXmIn55quOayeuFTRR78tmrmP/+GB1MNWmlRMIRPlHDPT3pjtLYrZ9PMUILfKx+AzwUG5gFVuNefYCdLuTERHzKWGQ8ydk/Xt8JUVjlAOASoCi++3Xiqq8tBZ7aOB4wEczWOIFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eRmxFC6C; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1fc5e651bcdso115208115ad.3
        for <kvm@vger.kernel.org>; Mon, 05 Aug 2024 09:40:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722875999; x=1723480799; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ywc7mA19HQNew9CX+pCE+Mpdd424HVzC6RLmLNPXyBU=;
        b=eRmxFC6CuBfa4q/kJ8JApqdnUG076bDEP3b8Zs+VOtQ89PSzbs81TNXKPVBcNXnpGN
         7swrRSWE0vSD+CMQs9ciXM5fqguotQHAPGGPsbQPsE7qeQz4j6Lw4VdwNOMbLxHdU0+/
         1irxjvbDdB/GxNpwcfjCLqiGgUU/9U9C5e2H3+VkFI1VCt09jCpNb/niDW+nIHVAFQlN
         JNQOZn3wGYmxeDmqQEgyzmUEtE5wKKSBYdSlIh6iiNx6kejq2UlUKhqDwuFNHvsz2vbZ
         rWwBZq7AoGRXUp+u0Yc4Gbs4zheiy9KVBUTx1Xg7Fb42JM04HKh39m86C3Z26YcCsX6p
         xsBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722875999; x=1723480799;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Ywc7mA19HQNew9CX+pCE+Mpdd424HVzC6RLmLNPXyBU=;
        b=phhe4SxGutbUnTldN5FZunOxECnsg5eTXnqEPk2Fn708fkNpoBraQXtZ1r3fsa1tJa
         hAKw64X/lI4obUNEVu6WXYtwQXDEDSpqhy9+Ndte44nip7dYNZXUa/g0Ck0+JmHXu4j/
         GrutS29wJbzaO2+H5p+Ut6OI2fkjyVHlR1UdgIsfubiPrzbcQBfiNcLapSlDAzDrSdS4
         wusMNFvDmLpNnlf/o5mByh71b0pRWaTHm3kyxPZAJNjraKQP48C48KwsRBLQtGfTEqBn
         vT43iPKo8Ff5oEU7aT58kCVuM0nfxNJu7WlaVVR7rQS/1gDK943jOTpTUVjYRQeb8QqI
         gA2g==
X-Gm-Message-State: AOJu0Yz6NxtNUbJDk/3/ZcwZhqEW3GoWag+n652qXeq5tRweh7YIg5Hb
	vhZ8sT0SbMTPEgHeC9lFc1thP2lveIURVekFAwndXjad/fOaQNHIGMynRIquMVIOzRkHYmFPLZz
	XCQ==
X-Google-Smtp-Source: AGHT+IGRko//56tXyMRSJ8j69mUWEOi2LMbbrj+Ftas3deyNzWD/2yj+xZuP7RgnRzRJ2BLaUzriDIev9Us=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:bb89:b0:1fc:52f7:a229 with SMTP id
 d9443c01a7336-1ff57274af1mr5475025ad.4.1722875999386; Mon, 05 Aug 2024
 09:39:59 -0700 (PDT)
Date: Mon, 5 Aug 2024 09:39:57 -0700
In-Reply-To: <cdb61fa7cc5cfe69b030493ea566cbf40f3ec2e1.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240802151608.72896-1-mlevitsk@redhat.com> <20240802151608.72896-2-mlevitsk@redhat.com>
 <Zq0A9R5R_MAFrqTP@google.com> <cdb61fa7cc5cfe69b030493ea566cbf40f3ec2e1.camel@redhat.com>
Message-ID: <ZrEAXVhH3w6Q0tIy@google.com>
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
> =D0=A3 =D0=BF=D1=82, 2024-08-02 =D1=83 08:53 -0700, Sean Christopherson =
=D0=BF=D0=B8=D1=88=D0=B5:
> > > > > > > > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > > > > > > > index a6968eadd418..3582f0bb7644 100644
> > > > > > > > > --- a/arch/x86/kvm/x86.c
> > > > > > > > > +++ b/arch/x86/kvm/x86.c
> > > > > > > > > @@ -1844,7 +1844,16 @@ static int __kvm_set_msr(struct kv=
m_vcpu *vcpu, u32 index, u64 data,
> > > > > > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0case MSR_=
KERNEL_GS_BASE:
> > > > > > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0case MSR_=
CSTAR:
> > > > > > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0case MSR_=
LSTAR:
> > > > > > > > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (is_noncanonical_address(data, vcpu)=
)
> > > > > > > > > +
> > > > > > > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/*
> > > > > > > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * Both AMD and Intel cpus allow values=
 which
> > > > > > > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * are canonical in the 5 level paging =
mode but are not
> > > > > > > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * canonical in the 4 level paging mode=
 to be written
> > > > > > > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * to the above MSRs, as long as the ho=
st CPU supports
> > > > > > > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * 5 level paging, regardless of the st=
ate of the CR4.LA57.
> > > > > > > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
> > > > > > > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (!__is_canonical_address(data,
> > > > > > > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0kvm_cpu_cap_has(X86_FEATURE_LA57) ? 57 : 48))
> > > > >=20
> > > > > Please align indentation.
> > > > >=20
> > > > > Checking kvm_cpu_cap_has() is wrong.=C2=A0 What the _host_ suppor=
ts is irrelevant,
> > > > > what matters is what the guest CPU supports, i.e. this should che=
ck guest CPUID.
> > > > > Ah, but for safety, KVM also needs to check kvm_cpu_cap_has() to =
prevent faulting
> > > > > on a bad load into hardware.=C2=A0 Which means adding a "governed=
" feature until my
> > > > > CPUID rework lands.
>=20
> Well the problem is that we passthrough these MSRs, and that means that t=
he guest
> can modify them at will, and only ucode can prevent it from doing so.
>=20
> So even if the 5 level paging is disabled in the guest's CPUID, but host =
supports it,
> nothing will prevent the guest to write non canonical value to one of tho=
se MSRs,=C2=A0
> and later KVM during migration or just KVM_SET_SREGS will fail.
=20
Ahh, and now I recall the discussions around the virtualization holes with =
LA57.

> Thus I used kvm_cpu_cap_has on purpose to make KVM follow the actual ucod=
e
> behavior.

I'm leaning towards having KVM do the right thing when emulation happens to=
 be
triggered.  If KVM checks kvm_cpu_cap_has() instead of guest_cpu_cap_has() =
(looking
at the future), then KVM will extend the virtualization hole to MSRs that a=
re
never passed through, and also to the nested VMX checks.  Or I suppose we c=
ould
add separate helpers for passthrough MSRs vs. non-passthrough, but that see=
ms
like it'd add very little value and a lot of maintenance burden.

Practically speaking, outside of tests, I can't imagine the guest will ever=
 care
if there is inconsistent behavior with respect to loading non-canonical val=
ues
into MSRs.

