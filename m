Return-Path: <kvm+bounces-58043-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 234D1B866C9
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 20:34:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CD61B3B89B6
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 18:34:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 594962D2384;
	Thu, 18 Sep 2025 18:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1GaimBi1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10BE334BA47
	for <kvm@vger.kernel.org>; Thu, 18 Sep 2025 18:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758220437; cv=none; b=fFshZqzFgof/Z8dSzka/aDT7TudGZOcdK3uckcOr9Y0fwLD2Veyr4V0Xls5g5gZbwRmNevL97A+52PzMMtWKM+wIyZ5eNUnEfx2CTFF1ZHSidvg9FqZSUq4iRQbcuSG1uWTss79SSjY+moHMMo/2+TH0BikH8Cp4QQjf5FZWkE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758220437; c=relaxed/simple;
	bh=rGgzPspASGJVJIThn7LM4l4ujHwd+jyQakrkEO6u8Ew=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=c/8/8IYdW/L/QQsLLugfyKXJ9CGhu2aUw5gh3k47Un4AJw73Ml8HGy7cYZGIDrKQgpjQBtmPiYHAi5mfKjkKPrNK8OdHjlFt4PURTt8soBr2cQOooz5K6H6V3l2emRQwgdt60XzssXnya9TRm5zN7gCBvCbnJtfsOlEg4Qk1ypg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1GaimBi1; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2681642efd9so11423345ad.2
        for <kvm@vger.kernel.org>; Thu, 18 Sep 2025 11:33:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758220435; x=1758825235; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pHdJjQUuryIm3Vk6lxOFx1M53k3mTAPjJw6HIOjsd4k=;
        b=1GaimBi141ozqm8njdfaxaOSoWr1L6eECmQdbAP4XPvK7oB+EOMbRN166B4zhspTIQ
         3H/WeKO0QPrzf9SmqflgECMwBKlK+7JhQpVN2Z12pBGQot6jgadGYu9dF/KGbyvGD+FJ
         QVK8555lDotqHXo4k6S2R8Bxn/so/iQWa8ruPcoN2IlH9eE3jaUHhCX4RU4RUY6UPRD8
         effHiQ6Rl+rf2P02msS5PJLiLzt74UhlglotvBM8SMH4khXNVpyIAwYz5yplnotkBH+W
         XLdYpnwBHdPc6Jn5Fo58/vJr4Vd2swoPazGOp5Nsr3UNngajCWpOoUNGxx6RQBnEeMlc
         +RHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758220435; x=1758825235;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=pHdJjQUuryIm3Vk6lxOFx1M53k3mTAPjJw6HIOjsd4k=;
        b=rAtqUypZ1W9d0Ju3mIrdhVh/4lvIEQCxhnw0wEwvIHT8ukjjZqZVQaKq19ea5bHc7e
         B8fGQOea/EgiCraMdOpKmUnm1kWJiVH24N1FQORlgJMX7SoBLxJS5hw1Fsd8SYr8RqNc
         xCyflC2dvs0UEzAdxEJ7qKGGXcPH+GZONdwd0aC7vxPhk1sUczKuviQLH0I33OMmokI1
         NkNZjBx3ra8GFvwimUQQwLgzMnEhuXveO7augLxi/XJywHCMpui1RW2jsPOLRKuuEb4B
         zcgkNaWQ4xSrF9i7lUc+QsmVMk6PEUQOMtgVOnjm46YMr3+Ai8PN6zPVjrAW3b9pWdUg
         UrSg==
X-Forwarded-Encrypted: i=1; AJvYcCURjI++eHLzxOr0qh4GqLKiP2Ahyp1Ak1y5PQVKxynbpHGLrze+w3AK54Vx1KsKAusN5t8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwafeFjRRekbab91KrBdk63NsZJSr+pMFgUSIvSA6GhNw6J0q15
	TOdL13ypng1PEOToPgZCLJJiRX+BDWzHkaRLBXJhvtpYD/oRnZju+rPyF6RfRnTNKVzjoGxSyIa
	rfxoAuQ==
X-Google-Smtp-Source: AGHT+IFNL0E9YAfZAuC4ZsAXPdxqtlaj1AIgHNwy38eW6V1gHOqhGuMfUj8oOAzgl5akVwviDROkvO3dTxE=
X-Received: from plbkg13.prod.google.com ([2002:a17:903:60d:b0:263:a081:54b2])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:1b6c:b0:266:3098:666
 with SMTP id d9443c01a7336-269ba4edb9cmr8095425ad.32.1758220435419; Thu, 18
 Sep 2025 11:33:55 -0700 (PDT)
Date: Thu, 18 Sep 2025 11:33:53 -0700
In-Reply-To: <76499c2e-8ca9-4e5f-9a34-96eec19a5f6d@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250805202224.1475590-1-seanjc@google.com> <20250805202224.1475590-5-seanjc@google.com>
 <424e2aaa-04df-4c7e-a7f9-c95f554bd847@intel.com> <849dd787-8821-41f1-8eef-26ede3032d90@linux.intel.com>
 <c4bc61da-c42c-453d-b484-f970b99cb616@zytor.com> <fbdcca61-e9c4-47fc-b629-7a46ad35cd24@intel.com>
 <aLcEMCMDRCEZnmdH@google.com> <76499c2e-8ca9-4e5f-9a34-96eec19a5f6d@intel.com>
Message-ID: <aMxQkRhuEi-SduTH@google.com>
Subject: Re: [PATCH v3 4/6] KVM: x86: Add support for RDMSR/WRMSRNS w/
 immediate on Intel
From: Sean Christopherson <seanjc@google.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Xin Li <xin@zytor.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Borislav Petkov <bp@alien8.de>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 03, 2025, Xiaoyao Li wrote:
> On 9/2/2025 10:50 PM, Sean Christopherson wrote:
> > On Mon, Sep 01, 2025, Xiaoyao Li wrote:
> > > On 9/1/2025 3:04 PM, Xin Li wrote:
> > > > On 8/31/2025 11:34 PM, Binbin Wu wrote:
> > > > > > We need to inject #UD for !guest_cpu_has(X86_FEATURE_MSR_IMM)
> > > > > >=20
> > > > >=20
> > > > > Indeed.
> > > >=20
> > > > Good catch!
> > > >=20
> > > > >=20
> > > > > There is a virtualization hole of this feature for the accesses t=
o the
> > > > > MSRs not intercepted. IIUIC, there is no other control in VMX for=
 this
> > > > > feature. If the feature is supported in hardware, the guest will =
succeed
> > > > > when it accesses to the MSRs not intercepted even when the featur=
e is not
> > > > > exposed to the guest, but the guest will get #UD when access to t=
he MSRs
> > > > > intercepted if KVM injects #UD.
> > > >=20
> > > > hpa mentioned this when I just started the work.=C2=A0 But I manage=
d to forget
> > > > it later... Sigh!
> > > >=20
> > > > >=20
> > > > > But I guess this is the guest's fault by not following the CPUID,
> > > > > KVM should
> > > > > still follow the spec?
> > > >=20
> > > > I think we should still inject #UD when a MSR is intercepted by KVM=
.
> >=20
> > Hmm, no, inconsistent behavior (from the guest's perspective) is likely=
 worse
> > than eating with the virtualization hole.
>=20
> Then could we document this design decision somewhere?

Yeah, Documentation/virt/kvm/x86/errata.rst would be the place for that.

> I believe people won't stop wondering why not inject #UD when no guest
> CPUID, when reading the code.
>=20
> > Practically speaking, the only guest that's going to be surprised by th=
e
> > hole is a guest that's fuzzing opcodes, and a guest that's fuzzing opco=
des
> > at CPL0 isn't is going to create an inherently unstable environment no
> > matter what.
> >=20
> > Though that raises the question of whether or not KVM should emulate WR=
MSRNS and
> > whatever the official name for the "RDMSR with immediate" instruction i=
s (I can't
> > find it in the SDM).
>=20
> do you mean because guest might be able to use immediate form of MSR acce=
ss
> even if the CPUID doesn't advertise it, should KVM emulate it on platform
> doesn't support it, to make sure immediate form of MSR access is always
> supported?

No, I'm calling out that as implemented, KVM doesn't support emulating WRMS=
RNS
at all.  Most of me just doesn't care.  The only way to encounter WRMSRNS w=
ould
be to disable unrestricted guest and execute WRMSRNS in an odd context, or =
to
force emulation.  Adding emulation support just for forced emulation is abs=
urd,
and adding WRMSRNS emulation for !URG is almost as ridiculous.

