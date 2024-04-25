Return-Path: <kvm+bounces-15947-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DCE6B8B2697
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 18:35:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9490028361D
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 16:35:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 112F914A0A9;
	Thu, 25 Apr 2024 16:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uIWgP6Qs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09FA41DFEF
	for <kvm@vger.kernel.org>; Thu, 25 Apr 2024 16:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714062920; cv=none; b=O96RFxFc3fy52XnMnHZM6f+tDxKgElfh2DiQVLxCXT131LH+lZoS7/M3LTRkAcSv1r06CoprQQbNLAP6pzkB7rTjS66q9wX0JbFf2rhD5cA7nTv1cOmPBTH/XFn/davBycrXhVFTLK34TWvYrpWwO5VqwnLgZ9xwpgtl2zPABHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714062920; c=relaxed/simple;
	bh=dfA1iqsHmwcVH8MfYLO4K4e8Yerq1ZHi5NAVK6KwaXI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=L/Qqb9bx0A+B0a63DyG+A/lDsoqFp8Nr4LxHlm+0w35k+PrnAX72lrQheVvgk2yvRPCSAu2zrV7eNU+vnJKOLkRA7qqDEneKumHTYi/C/zNnvWbWg/Wp2/cicGyMcvM95yY5gpernvGoukjECv2+m4MadituGrcQx3kXMcKr+nU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uIWgP6Qs; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-5e4df21f22dso1147546a12.0
        for <kvm@vger.kernel.org>; Thu, 25 Apr 2024 09:35:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714062918; x=1714667718; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=u932lKLbGLFQ6zm6AiyBiCEaift/XnvzEKBxqemXR7g=;
        b=uIWgP6QsJHqg1AgWUl0x+vgqUZFI2tykvnkOstv9RKpCScKtMUhP+Fqh10LaPkT8m/
         vNbLHUIKWhjl112a44tG9MAX64ccI8/uQjF+PKqy7fB4BIvo+LLfXJsfyPh6QnVPvfKu
         ANtnnsudHbx/2obUtm5We9vlZBRatX2eoRl7w4ZVs1Idd24aPCXY6WaJ7MiDantZGnqE
         CRjPzH1h4MxwZFoqsMyeaKDrjTdeLqCeK5AkfLCTghnMm4taNaN1k++QVF1eG3yJXCBd
         umGc9Z8L4rjrWvAb8NTuHbapVa9Th+RsSCPcHRFbqMByMVv5P2pHIDa9Gve2vw/loPWB
         iMXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714062918; x=1714667718;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=u932lKLbGLFQ6zm6AiyBiCEaift/XnvzEKBxqemXR7g=;
        b=q0QJqSN52njd61DY/q3LHfVmovcY9z/WD4iX64KufrF2YCgECwQ+UYvPw3wK8CaTfk
         Cb8VOlA05iKt2b8V2gxJCF7N7CF6me0BXRtCMSMEmUU8yZUqYIHtJUFFLYRXEgNKGLqr
         XYD9VS+cdVuQ+0bmNZcSGTwI6tuIbyj1vfxCnUGYWg8wBuuM7xQAgDHP9NfnwCvxrKWt
         9PbUXldHieizB1KubNCiLxrff27wLkS88myTleC+aLVXS1SGx3FsjepOpjuuNOLxWLSQ
         fjJML3eOgJIEaBfPRJSDegw6f2vrCJhXMzuuE18stciKC4W6pDygyGzGeEcyEIpsqa+K
         cVtQ==
X-Forwarded-Encrypted: i=1; AJvYcCV+iNj7znyJ0ht7Nj/GgXYQtcHGMn1+1hwlFZ8h33/GopembgVB+ahYBaVVr2cMVoeZbDbVqzSG1czARF1PazPeB5MX
X-Gm-Message-State: AOJu0Yz4T6STtzNx+YZQ9jkgSgCDCu2yx+Np35rkjZLefkZEdAG55QT0
	m6EAR6NP5opdfcIH4MD6STDoM8KXGdEo+g9WAzuarvsIv8i3tyE3edrgezRnDmLmfljdsQ011G3
	CMw==
X-Google-Smtp-Source: AGHT+IHQ9u1LNsktEkdgaBMoBrPtiOz7/kYuk232G91drjOvevfaSQ+lgCrMcf/kb361yyUjTEF0KfxRg4c=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:c68e:b0:2ac:39d9:dd2e with SMTP id
 n14-20020a17090ac68e00b002ac39d9dd2emr5104pjt.0.1714062918213; Thu, 25 Apr
 2024 09:35:18 -0700 (PDT)
Date: Thu, 25 Apr 2024 09:35:16 -0700
In-Reply-To: <61ec08765f0cd79f2d5ea1e2acf285ea9470b239.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <22b19d11-056c-402b-ac19-a389000d6339@intel.com>
 <ZiKoqMk-wZKdiar9@google.com> <deb9ccacc4da04703086d7412b669806133be047.camel@intel.com>
 <ZiaWMpNm30DD1A-0@google.com> <3771fee103b2d279c415e950be10757726a7bd3b.camel@intel.com>
 <Zib76LqLfWg3QkwB@google.com> <6e83e89f145aee496c6421fc5a7248aae2d6f933.camel@intel.com>
 <d0563f077a7f86f90e72183cf3406337423f41fe.camel@intel.com>
 <ZifQiCBPVeld-p8Y@google.com> <61ec08765f0cd79f2d5ea1e2acf285ea9470b239.camel@intel.com>
Message-ID: <ZiqGRErxDJ1FE8iA@google.com>
Subject: Re: [PATCH v19 023/130] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
From: Sean Christopherson <seanjc@google.com>
To: Kai Huang <kai.huang@intel.com>
Cc: Tina Zhang <tina.zhang@intel.com>, Hang Yuan <hang.yuan@intel.com>, 
	Bo2 Chen <chen.bo@intel.com>, "sagis@google.com" <sagis@google.com>, 
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Erdem Aktas <erdemaktas@google.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, 
	"isaku.yamahata@linux.intel.com" <isaku.yamahata@linux.intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 23, 2024, Kai Huang wrote:
> On Tue, 2024-04-23 at 08:15 -0700, Sean Christopherson wrote:
> > Presumably that approach relies on something blocking onlining CPUs whe=
n TDX is
> > active.  And if that's not the case, the proposed patches are buggy.
>=20
> The current patch ([PATCH 023/130] KVM: TDX: Initialize the TDX module
> when loading the KVM intel kernel module) indeed is buggy, but I don't
> quite follow why we need to block onlining CPU  when TDX is active?

I was saying that based on my reading of the code, either (a) the code is b=
uggy
or (b) something blocks onlining CPUs when TDX is active.  Sounds like the =
answer
is (a).

> There's no hard things that prevent us to do so.  KVM just need to do
> VMXON + tdx_cpu_enable() inside kvm_online_cpu().
>=20
> >=20
> > > Btw, the ideal (or probably the final) plan is to handle tdx_cpu_enab=
le()
> > > in TDX's own CPU hotplug callback in the core-kernel and hide it from=
 all
> > > other in-kernel TDX users. =C2=A0
> > >=20
> > > Specifically:
> > >=20
> > > 1) that callback, e.g., tdx_online_cpu() will be placed _before_ any =
in-
> > > kernel TDX users like KVM's callback.
> > > 2) In tdx_online_cpu(), we do VMXON + tdx_cpu_enable() + VMXOFF, and
> > > return error in case of any error to prevent that cpu from going onli=
ne.
> > >=20
> > > That makes sure that, if TDX is supported by the platform, we basical=
ly
> > > guarantees all online CPUs are ready to issue SEAMCALL (of course, th=
e in-
> > > kernel TDX user still needs to do VMXON for it, but that's TDX user's
> > > responsibility).
> > >=20
> > > But that obviously needs to move VMXON to the core-kernel.
> >=20
> > It doesn't strictly have to be core kernel per se, just in code that si=
ts below
> > KVM, e.g. in a seperate module called VAC[*] ;-)
> >=20
> > [*] https://lore.kernel.org/all/ZW6FRBnOwYV-UCkY@google.com
>=20
> Could you elaborate why vac.ko is necessary?
>=20
> Being a module natually we will need to handle module init and exit.  But
> TDX cannot be disabled and re-enabled after initialization, so in general
> the vac.ko doesn't quite fit for TDX.
>=20
> And I am not sure what's the fundamental difference between managing TDX
> module in a module vs in the core-kernel from KVM's perspective.

VAC isn't strictly necessary.  What I was saying is that it's not strictly
necessary for the core kernel to handle VMXON either.  I.e. it could be don=
e in
something like VAC, or it could be done in the core kernel.

The important thing is that they're handled by _one_ entity.  What we have =
today
is probably the worst setup; VMXON is handled by KVM, but TDX.SYS.LP.INIT i=
s
handled by core kernel (sort of).

