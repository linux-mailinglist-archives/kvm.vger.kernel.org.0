Return-Path: <kvm+bounces-16772-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 308E48BD833
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 01:33:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B28441F21A9D
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 23:33:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 527C115CD7D;
	Mon,  6 May 2024 23:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KsFFjHCe"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45A7015B0ED
	for <kvm@vger.kernel.org>; Mon,  6 May 2024 23:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715038401; cv=none; b=tP9L7kycgsh9vX7bh3QmJpnys8Z/dbqY8pjBUYLmoKCrb0kaUsdRXNLHVaZT/qFP0YfWbyeEJtx/Um/dNqo62Rr3aTS9mf121Sseru/vAiMm/pfL8fbNFvq3ia4nXYliN1g4W7gGt3jOmDpUfAzq35wnxPiX5GDo8kSWB7dzpFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715038401; c=relaxed/simple;
	bh=eYF/5LBlojZTPQk7R6ARo4QRGpN0U8rhB702OyWsxic=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GeAaXeifBrpSA89kioCFCBu9y/A9MPDgRSpSyl9eCG/yDVrDoibrq8BQuOc+OYkkvP+988AXTvg5+1C6AzgjzSTAEJt2N1Su0EnM9+MjeG7cgQ6q18beVMaL0KlS3M6g7prmMNNTG1MQBMctMmVWl/s8HL4KdCLRTRoRZrQwRT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KsFFjHCe; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2a473ba0632so2963561a91.0
        for <kvm@vger.kernel.org>; Mon, 06 May 2024 16:33:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715038399; x=1715643199; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=naRWxGi0DISf7tT9GtjLPuvLnh/f9UY/0yCGnr5vVNE=;
        b=KsFFjHCett/cyiLbo77Bl4y2+hlSJWzdbJK+h9kEUy0IkFkvT8gEdJDnd7wcUbxU5y
         hGbmmuPSQ9kMkhXnjJ4NQGhtM1NO1JT3UixX4eIrwCN0Fwb3YLUujXa/9uyVwJNBuftK
         tKAg/TXALwPWJmt24Myx3M0Vthb4Exf8YcUgelqBf134/46yenxU1uCstiliMYgl2y9q
         rcQzlxFkkkjTZuAQ/T1NjoXTFlvBmx5mVUMggZqxx67vVBPL8dtL//cnK2pZMmI8DWxg
         Wq7HJyWnbACIAHAyodF22vKlgHlI94QpgflbqQGUH3vrv0XMRvlVcqyl9A2Tv/l4fleC
         MahQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715038399; x=1715643199;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=naRWxGi0DISf7tT9GtjLPuvLnh/f9UY/0yCGnr5vVNE=;
        b=DqkBLz9NNW+dm3fJgMg9A3JQnRBB9yF5SgIcgM9defVT7TVzqf49q7AZLHB9CL6swr
         KAbMhMcXbHA5BU+/oUvQaaKxij2rxXa++aZlIcRRTTwP/Uhy7zGcel1LMDf66PCTgOG+
         Wj3mbf+f9nF4MATb1Yf8j4dzrNpDtSj1qcIsn519lijyjZXgVhLe2M5mC+mWYMkuGUXh
         oTT6y/HOoO2wh3C+ym9YFm+3umfgo2qDAqpdYXX4QLFq6UWBQq4/PuVKstwlXkzyfWs8
         8juXBW6rpZINQjl7oh8cY4u/uNyJ6EB13FWjymxn+nGLMIGPvoqeC3aaRdaWSPOpOUst
         wlMQ==
X-Forwarded-Encrypted: i=1; AJvYcCVay1/o6FxfK+E4xZl8UmQkfj+HGVOi+s8oW6veat8rD90szMMZlDd+T7Xuv/xB5wdMtJ8INMVaCAhendQqSFK0+y/f
X-Gm-Message-State: AOJu0YxXvubPoDNfUXcGlScZx23zEKFjpUWOQAH2Ni6mPBWRCPVOHMVR
	gGJ09w2ZG66WuFCFr6ZT+yDIHn5ojfx4jDrOkhkxQIp7OHmZlScOKkvJCLoc7mVMs7pX1f8khp5
	D8g==
X-Google-Smtp-Source: AGHT+IFVdGY0Y8CICjJjkQNm8G7tr0LJBvFQGZgnwAzw3Vs3/H1kG0dT3dJGoY8axS4Ic1zPBmJpOeSP2u8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:3685:b0:2b2:9855:2852 with SMTP id
 mj5-20020a17090b368500b002b298552852mr32798pjb.5.1715038399442; Mon, 06 May
 2024 16:33:19 -0700 (PDT)
Date: Mon, 6 May 2024 16:33:17 -0700
In-Reply-To: <038379acaf26dd942a744290bde0fc772084dbe9.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240219074733.122080-1-weijiang.yang@intel.com>
 <20240219074733.122080-25-weijiang.yang@intel.com> <ZjLNEPwXwPFJ5HJ3@google.com>
 <e39f609f-314b-43c7-b297-5c01e90c023a@intel.com> <038379acaf26dd942a744290bde0fc772084dbe9.camel@intel.com>
Message-ID: <ZjlovaBlLicFb6Z_@google.com>
Subject: Re: [PATCH v10 24/27] KVM: x86: Enable CET virtualization for VMX and
 advertise to userspace
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: Weijiang Yang <weijiang.yang@intel.com>, Chao Gao <chao.gao@intel.com>, 
	Dave Hansen <dave.hansen@intel.com>, "x86@kernel.org" <x86@kernel.org>, 
	"peterz@infradead.org" <peterz@infradead.org>, "john.allen@amd.com" <john.allen@amd.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "mlevitsk@redhat.com" <mlevitsk@redhat.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 06, 2024, Rick P Edgecombe wrote:
> On Mon, 2024-05-06 at 17:19 +0800, Yang, Weijiang wrote:
> > On 5/2/2024 7:15 AM, Sean Christopherson wrote:
> > > On Sun, Feb 18, 2024, Yang Weijiang wrote:
> > > > @@ -696,6 +697,20 @@ void kvm_set_cpu_caps(void)
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0kvm_cpu_cap_set(X86_FEATURE_INTEL_STIBP);
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (boot_cpu_has(X8=
6_FEATURE_AMD_SSBD))
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0kvm_cpu_cap_set(X86_FEATURE_SPEC_CTRL_SSBD);
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/*
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * Don't use boot_cpu_ha=
s() to check availability of IBT because
> > > > the
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * feature bit is cleare=
d in boot_cpu_data when ibt=3Doff is applied
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * in host cmdline.
> > > I'm not convinced this is a good reason to diverge from the host kern=
el.=C2=A0
> > > E.g.  PCID and many other features honor the host setup, I don't see =
what
> > > makes IBT special.
> >=20
> > This is mostly based on our user experience and the hypothesis for clou=
d
> > computing: When we evolve host kernels, we constantly encounter issues =
when
> > kernel IBT is on, so we have to disable kernel IBT by adding ibt=3Doff.=
 But
> > we need to test the CET features in VM, if we just simply refer to host
> > boot cpuid data, then IBT cannot be enabled in VM which makes CET featu=
res
> > incomplete in guest.
> >=20
> > I guess in cloud computing, it could run into similar dilemma. In this
> > case, the tenant cannot benefit the feature just because of host SW
> > problem. I know currently KVM except LA57 always honors host feature
> > configurations, but in CET case, there could be divergence wrt honoring
> > host configuration as long as there's no quirk for the feature.
> >=20
> > But I think the issue is still open for discussion...
>=20
> I think the back and forth I remembered was actually around SGX IBT, but =
I did
> find this thread:
> https://lore.kernel.org/lkml/20231128085025.GA3818@noisy.programming.kick=
s-ass.net/
>=20
> Disabling kernel IBT enforcement without disabling KVM IBT seems worthwhi=
le. But
> the solution is to not to not honor host support. It is to have kernel IB=
T not
> clear the feature flag and instead clear something else. This can be done
> independently of the KVM series.

Hmm, I don't disagree, but I'm not sure it makes sense to wait on that disc=
ussion
to exempt IBT from the "it must be supported in the host" rule.  I suspect =
that
tweaking the handling X86_FEATURE_IBT of will open a much larger can of wor=
ms,
as overhauling feature flag handling is very much on the x86 maintainers to=
do
list.

IMO, the odds of there being a hardware bug that necessitates hard disablin=
g IBT
are lower than the odds of KVM support for CET landing well before the feat=
ure
stuff is sorted out.

