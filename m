Return-Path: <kvm+bounces-27691-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 91DE998A99F
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2024 18:19:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2841E1C23283
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2024 16:19:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EEF0192D97;
	Mon, 30 Sep 2024 16:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ETSlSepj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6298B1E507
	for <kvm@vger.kernel.org>; Mon, 30 Sep 2024 16:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727713182; cv=none; b=FiEmtCfEFLXSi2k45BALpEOnvdgUGWjipbo6Zm5EP8sguQr6Bb+cuNkK7SPIax/n81/UxUYlQhlhrldCA6uPhc0YFrZ9uujS37AcNG0FwmGrQL1dkDFfy2oUcsvqgo8DbGK7lVFiP7cyb/JvCARieZkfNzzibDzGlpDYZEX/OkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727713182; c=relaxed/simple;
	bh=RQmbciJp+3HvVOT4BZZm0kN1UG2KYPfBnDMMw4gg9Wg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XWbXXygKOdWz49YljZVyH1q+6hnDv/byRby1x34CS4kaaMsFk2XSXma8Q/R1Ds87GK8u3ST/b0vL75Uh8Y7FqcG9hG2rQ4JNJ3m1o4TvDEfJlTfYWvDUkRCN7yTqDDWb8R4V/CKjbpdSeF/enDSCn49BV9+I1obRTcE8aUx8m3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ETSlSepj; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-7db6dbaca2cso5758618a12.0
        for <kvm@vger.kernel.org>; Mon, 30 Sep 2024 09:19:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1727713181; x=1728317981; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=REWAk9yOZ/oV5DFOSR0fdNCr64LBBiwPareu4SRJi5Y=;
        b=ETSlSepjaP+Ja4j09nXgBKKNZphifIdG2dgqqROxeND7gVvjp9YKLTmPWNX1s9Ecjl
         ufPoYuNrMotUXS1lTGOXww3oxm6YLoNDU898Xfkfk4l3yyhSuenfy4S6sHQq5QM2a5GS
         ZYVqoBsRguA25rBoGdBsbrjkgtXpnjMljK3eApKrePzhuWoR8xKiEV3+ug50YpJLUcNq
         FHXR9R4so5nxZIMxY8ynw+lJ4T2hP4zY0Q8Bh/K8t1N/MWT0r0T6RqsiKlPImVSqa+kj
         Bc1WIjr41uoaZbhB9CFcMh4xPE0ChyVt6ASlFH1E1MlLDxHBOpGNKggWTpaWuyujWfBI
         uZAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727713181; x=1728317981;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=REWAk9yOZ/oV5DFOSR0fdNCr64LBBiwPareu4SRJi5Y=;
        b=oZTS66ZZH0hL0ZPBzfA2NRimXeeBCvnxj0+zr++fJiwpo1br6EdcsJE9iEiflzis9z
         Ab+POwiZ7YZGa2i6UPWWL+AhBOjPD8RWW/XqkYNV6XM5+/xufK/IpLl8lIpxDCqnf4SB
         aWNJxuzvu22VEroHKeZtmg2WCsB1TnJVzI9rAfx1FkdDWBQBFtaJ31s2JI4witraiwqe
         jMmU7fM2rzEObyTmI41sMc725ZvcuyEQ5XWuhMgkpQ1Mq44P3lSMu+oTRocMhhnvkUZx
         FPlhuFkvm5+zOg+CSxs9LrGJJxRgxWUQS671E12+j7nfN5ERRAKYypHxMhTE2Rm7FGY9
         qKSQ==
X-Forwarded-Encrypted: i=1; AJvYcCWKqPMQ2jthphCSC2tTf8dEGMEdKd5E6j8BssN+SBnF+gROB2HOM/7jDS2WtfXuIl0QvJg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy8mKLXLBDG3oN/xzR/VbDCfDQo192PVRmCVmHkdU5ieWcvEBEh
	2ledrQE4tpaupP3f9vfAlUDvIgrvw7yzfL+g81HwfOnWLWLk7x0Y1J91WTKn0JZ4vtxMtK4Dwkd
	7eA==
X-Google-Smtp-Source: AGHT+IHkNqpgIOhZDhQLlT+HB+EF4VbjJnvLgjGrAFw/cN8YVeiOCtV2Yk4NeWEWfkYzuZMUGCpEPJE8NW0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:2482:0:b0:7cb:c8c3:3811 with SMTP id
 41be03b00d2f7-7e6db03fe9bmr15004a12.5.1727713180514; Mon, 30 Sep 2024
 09:19:40 -0700 (PDT)
Date: Mon, 30 Sep 2024 09:19:38 -0700
In-Reply-To: <CALMp9eSd49O_J=hJKdE0QAcYFY1N1cxG1rKDJH-GUZL7i_VJig@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240913173242.3271406-1-jmattson@google.com> <CALMp9eSd49O_J=hJKdE0QAcYFY1N1cxG1rKDJH-GUZL7i_VJig@mail.gmail.com>
Message-ID: <ZvrPmnUeNHXaS7_E@google.com>
Subject: Re: [PATCH v4 0/3] Distinguish between variants of IBPB
From: Sean Christopherson <seanjc@google.com>
To: Jim Mattson <jmattson@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, 
	Josh Poimboeuf <jpoimboe@kernel.org>, Sandipan Das <sandipan.das@amd.com>, 
	Kai Huang <kai.huang@intel.com>, x86@kernel.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 27, 2024, Jim Mattson wrote:
> On Fri, Sep 13, 2024 at 10:32=E2=80=AFAM Jim Mattson <jmattson@google.com=
> wrote:
> >
> > Prior to Zen4, AMD's IBPB did not flush the RAS (or, in Intel
> > terminology, the RSB). Hence, the older version of AMD's IBPB was not
> > equivalent to Intel's IBPB. However, KVM has been treating them as
> > equivalent, synthesizing Intel's CPUID.(EAX=3D7,ECX=3D0):EDX[bit 26] on=
 any
> > platform that supports the synthetic features X86_FEATURE_IBPB and
> > X86_FEATURE_IBRS.
> >
> > Equivalence also requires a previously ignored feature on the AMD side,
> > CPUID Fn8000_0008_EBX[IBPB_RET], which is enumerated on Zen4.
> >
> > v4: Added "guaranteed" to X86_FEATURE_IBPB comment [Pawan]
> >     Changed logic for deducing AMD IBPB features from Intel IBPB featur=
es
> >     in kvm_set_cpu_caps [Tom]
> >     Intel CPUs that suffer from PBRSB can't claim AMD_IBPB_RET [myself]
> >
> > v3: Pass through IBPB_RET from hardware to userspace. [Tom]
> >     Derive AMD_IBPB from X86_FEATURE_SPEC_CTRL rather than
> >     X86_FEATURE_IBPB. [Tom]
> >     Clarify semantics of X86_FEATURE_IBPB.
> >
> > v2: Use IBPB_RET to identify semantic equality. [Venkatesh]
> >
> > Jim Mattson (3):
> >   x86/cpufeatures: Define X86_FEATURE_AMD_IBPB_RET
> >   KVM: x86: Advertise AMD_IBPB_RET to userspace
> >   KVM: x86: AMD's IBPB is not equivalent to Intel's IBPB
>=20
> Oops. I forgot to include the v3 responses:
>=20
> > For the series:
> >
> > Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
>=20
> and
>=20
> > Assuming this goes through the KVM tree:
> >
> > Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
>=20
> The only substantive change was to patch 3/3.
>=20
> Sean: Are you willing to take this through KVM/x86?

Yep, and I can fixup the reviews when applying.

