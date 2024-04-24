Return-Path: <kvm+bounces-15850-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CC808B10DD
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 19:23:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BD6A228A442
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 17:23:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D51016D4D6;
	Wed, 24 Apr 2024 17:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WpNryyjv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD3EA160794
	for <kvm@vger.kernel.org>; Wed, 24 Apr 2024 17:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713979414; cv=none; b=lKGurPaZEQXqK7yRmf35IoLmLS10ZiKHxkoiYSmUDk6U93j0jdqNvclFSAOIXjheW4CmzjrXyRCVcVw1yKR/Xt/T2W9cR+d+VjaJcWnIRPfagdsrCdD5zY870nTJHJK89ngg8S22V401xN1K3Xr9HV2X5XCWE8wRSOtGpO457ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713979414; c=relaxed/simple;
	bh=P0oeJnxbTvn6pPPOyFFSDDnkr9guCkdiyf02byNplKI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VEOYC0pkNuRFi/VEE2VTCTXsPgxYesIVg/oxtMnP/Jjktzlp6aq4ZsJNjuJRrx6dnhp2l11Fgx2N2OhdkXbegHK+I34jx+Nb58WQ0vdGD5N+oXm92Igh6lZq+thEyNbupLg5RzXhtO8KFO4cp7lFtEyZW4nw2ACgFYLsf8Stkvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WpNryyjv; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2a473ba0632so177348a91.0
        for <kvm@vger.kernel.org>; Wed, 24 Apr 2024 10:23:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713979412; x=1714584212; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZO0d6wOTbBKxXnynFNVxHpThLpJ4G8Z760Bc6T07xNM=;
        b=WpNryyjvdaorIf+gazL8cCW91faGXyAhVlMeoFxLdbfJeAB7+rB/d2tUL9vhKPqCD8
         s1Vo4+UsHJQXC0vfItz/QCUHGmNV2kzkj6hIUP61htN8Tq2Ku1tIbT8e5KEVItgODH9D
         CtBoZR7qwGGwPVYtasvFfDMco9Y2hAT0ozt+mMZ/5RQSg2CJyFnpA3xpLI3ka8AaLh1f
         Tf/GH//IMBLVvQ/jy0/UAsMSgb9JJNapy07SVHD3M/At0qQBCusgzWKghbTjT4f1L9SH
         zII9OkN/BQqgR69WQx1+bZY9KiJe383kPQNPtkxYsuvnDkDPX0GDtdgn/RD7EXvgVnMw
         vYnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713979412; x=1714584212;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ZO0d6wOTbBKxXnynFNVxHpThLpJ4G8Z760Bc6T07xNM=;
        b=HCn1J7AlExA+6Fc04nMavDUtPnC4+Ls4Ud8tS4D73PvhrVxJSLQZ/u25MrjrPS7B+B
         3IUQz6+/Z9gbdlydKycQC6jGlxtZYGwbbOtjgSbWtOnTVN49Qo5SLMR8WiEneQugk+6l
         SrjFrUuYZ3Hb3vMDFUINBXYPoLPmdcyK3JqNS3PgOS34+q6MYNwY0+LL17xRxHX08+eA
         CMuJV0BBR5YfEMN4n2Ac8wS4oLWiu1yjt7cyhRDkSQu02cWQz971/sizva7PgLB4Atjc
         jgFLhLsNV2/SM4XXRF2DKhGXEkKpnR/SJZ8hzwybJgCIOEKVitiOgpLf76B8jUGB06Bb
         ITyA==
X-Forwarded-Encrypted: i=1; AJvYcCU1EvmPP2q2oRhT2W2aWEUQRtideFNYV5TlMnjVBTrmrI/E16oceTE2T12u6gc24H8VB84fhm5kMhPG1S/a+f3QauUZ
X-Gm-Message-State: AOJu0Yzt73WvKciMBYGKhRPXqrulCy2l/F+UpYe9rlpHsAa+fgJ48++V
	FqgxnU0t6A4lhUPOLZcBccm6MUAN8iSsIydePIZ9FUJLHr6sG8rVKMhNqCO/d/QvGy6sYiXg1kz
	HUA==
X-Google-Smtp-Source: AGHT+IFLb/Jkoz6d/O3InlajLJrijyFnYCvcvHzvKbQYg9xjqAw0YfXYb31XQor7r51QWkPYwn7+3vaqaj0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:f187:b0:2a5:57ec:2658 with SMTP id
 bv7-20020a17090af18700b002a557ec2658mr11546pjb.6.1713979412050; Wed, 24 Apr
 2024 10:23:32 -0700 (PDT)
Date: Wed, 24 Apr 2024 10:23:30 -0700
In-Reply-To: <26073e608fc450c6c0dcfe1f5cb1590f14c71e96.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1711035400.git.reinette.chatre@intel.com>
 <6fae9b07de98d7f56b903031be4490490042ff90.camel@intel.com>
 <Ziku9m_1hQhJgm_m@google.com> <26073e608fc450c6c0dcfe1f5cb1590f14c71e96.camel@intel.com>
Message-ID: <ZilAEhUS-mmgjBK8@google.com>
Subject: Re: [PATCH V4 0/4] KVM: x86: Make bus clock frequency for vAPIC timer configurable
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: "jmattson@google.com" <jmattson@google.com>, Chao Gao <chao.gao@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "vkuznets@redhat.com" <vkuznets@redhat.com>, 
	Vishal Annapurve <vannapurve@google.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Reinette Chatre <reinette.chatre@intel.com>, Erdem Aktas <erdemaktas@google.com>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "mlevitsk@redhat.com" <mlevitsk@redhat.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 24, 2024, Rick P Edgecombe wrote:
> On Wed, 2024-04-24 at 09:13 -0700, Sean Christopherson wrote:
> > On Tue, Apr 16, 2024, Rick P Edgecombe wrote:
> > > On Thu, 2024-03-21 at 09:37 -0700, Reinette Chatre wrote:
> > > >=20
> > > > Summary
> > > > -------
> > > > Add KVM_CAP_X86_APIC_BUS_FREQUENCY capability to configure the APIC
> > > > bus clock frequency for APIC timer emulation.
> > > > Allow KVM_ENABLE_CAPABILITY(KVM_CAP_X86_APIC_BUS_FREQUENCY) to set =
the
> > > > frequency in nanoseconds. When using this capability, the user spac=
e
> > > > VMM should configure CPUID leaf 0x15 to advertise the frequency.
> > >=20
> > > Looks good to me and...
> > > Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> > >=20
> > > The only thing missing is actually integrating it into TDX qemu patch=
es and
> > > testing the resulting TD. I think we are making a fair assumption tha=
t the
> > > problem should be resolved based on the analysis, but we have not act=
ually
> > > tested that part. Is that right?
> >=20
> > Please tell me that Rick is wrong, and that this actually has been test=
ed with
> > a TDX guest.=C2=A0 I don't care _who_ tested it, or with what VMM it ha=
s been
> > tested, but _someone_ needs to verify that this actually fixes the TDX =
issue.
>=20
> It is in the process of getting a TDX test developed (or rather updated).
> Agreed, it requires verification that it fixes the original TDX issue. Th=
at is
> why I raised it.
>=20
> Reinette was working on this internally and some iterations were happenin=
g, but
> we are trying to work on the public list as much as possible per your ear=
lier
> comments. So that is why she posted it.

I have no problem posting "early", but Documentation/process/maintainer-kvm=
-x86.rst
clearly states under Testing that:

  If you can't fully test a change, e.g. due to lack of hardware, clearly s=
tate
  what level of testing you were able to do, e.g. in the cover letter.

I was assuming that this was actually *fully* tested, because nothing sugge=
sts
otherwise.  And _that_ is a problem, e.g. I was planning on applying this s=
eries
for 6.10, which would have made for quite the mess if it turns out that thi=
s
doesn't actually solve the TDX problem.

> There was at least some level of TDX integration in the past. I'm not sur=
e what
> exactly was tested, but we are going to re-verify it with the latest ever=
ything.

Honest question, is it a big lift to re-test the QEMU+KVM TDX changes, e.g.=
 to
verify this new capability actually does what we hope it does?  If testing =
is a
big lift, what are the pain points?  Or perhaps a better question is, is th=
ere
anything we (both upstream people, and end users like Google) can do to mak=
e
re-testing less awful?

