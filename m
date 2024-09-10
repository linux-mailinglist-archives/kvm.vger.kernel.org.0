Return-Path: <kvm+bounces-26320-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D3754973E22
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 19:07:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9C1EC288B50
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 17:07:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08EA81A4F0F;
	Tue, 10 Sep 2024 17:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lv+sN86g"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1B6D1A3BDE
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 17:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725987987; cv=none; b=WNSR/KGtO8jqpBGYYljLQn4tKTquleQucK6fWQeabFj6wKzg9lO+knRZQPK7EhIkFvTo6lDuJP3Asujiul9EATlhZ6pCZibNMnSXLJtBObzde2LWI9twhbVODuuyfZfwj3016UVHLiuFr7XJAkaHCY6lDtBw5ViCDZeWa6sQ2gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725987987; c=relaxed/simple;
	bh=K1zMb74fLs/3b55dFPaW8pZ6BoPzNIUNMZnJvQ2/+yk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WIWkU/lvE3alCauQwdy2lZc/eKHPcrB7xm5wjuSwG437Ge8BdAigM92+dVdQ1A0xCO8l4RXV/Yo5GOa2p9QFk73Q78QC4z+6mFjef1w9JBn6HMOOsATBF4qbE1fVoN89/jr5+4woe3y1Mu1qm/RBhVPUbI0fvJRIHlcBqv9zy6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lv+sN86g; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6b47ff8a5c4so195587807b3.2
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 10:06:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725987985; x=1726592785; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bO8RJUCEv3T+MW3ZwzmCcUtuhGy0JOcrONU3LjeHDvk=;
        b=lv+sN86gDiTEFvuC4QMNZ05yijGfMBX00czh5+weyS1Tl/o0doWV3iTVXkIgUyBVLh
         dJcZVD9Va+FggUBJGL9D4QXT5Ps+N6F8f/V6fJ5/dHziqLFxHuYzOqaAJ2BAnf3eOc0v
         VyeMNwkPcyxCxqcpyJIlL9OokaKAYmXaNHyjnNmbVUx9Q2HPDWDDylBmsB/ajCtRoyqo
         doBYZzkqXmNpdQR440Ijeml+usc6W0nendmnVtSAdHt5UUR9RASExLPyC/l8tqPe9i9v
         Ph2eBrzyG5w8Wge7RhcbyWokbtrtH1N6IDXy3Nt+0gam7vcLTjP3U7x7DLMBxJdY0LDC
         w5UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725987985; x=1726592785;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=bO8RJUCEv3T+MW3ZwzmCcUtuhGy0JOcrONU3LjeHDvk=;
        b=DXlQZVbWG5QnS24nhre1pTWqcIrdZe3UhxKECWgWwmsUFQ5YxJOEcwG+CP2EHxotOV
         CJwqXjdgzdcIn0/FOSHLn3pTyLiB+FWQB8jeR05HWQOtD/I+Jg/UxJIofaxwIwGteVwm
         5Gzx9Sy/t8NJKRXxBIwKyKQ3zfWh5Bd31StLwGvE4gzMaITKv55RG3n/kYP4NnS0DkUE
         KUXWpqhE2lLauy2ByZRQrWao2NQJ2IRjQqTziuu16WxrCCodT9NaX4/2sPypYIYnoVqh
         FFMpS14M786N7PGmt1VmaGelQGLfH8Zmo302l0IfwvL8QHqVcLwogl7TNKeDo+Rd1g4N
         Q2dQ==
X-Forwarded-Encrypted: i=1; AJvYcCUj5jR78DaGwxPedWcwaQGwc7wL6s8n37c19IT8PnKEI8XcTm4qiH2gxlQQy5tDS2sHlOA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyR/7bY79y9uicMvvHrWmuIBU7Rxj28vFT4RnbqJZH8E920R9D5
	XiWzkJhglbb1Hu5uZ3RbolY56HgqI1Q8+Do5v/ThDfYHbI+b14er5SKLUjs21LdcDJP8fKi9AMG
	sXQ==
X-Google-Smtp-Source: AGHT+IEyaU7HwD8P1kj9fZKH///TZKTxYleYQe9/4U+rzcNrsW+wdQjOiMgd4p7gsiXUIRaKzhvpQ4gUL4g=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:2c11:b0:690:8ad7:55f9 with SMTP id
 00721157ae682-6db44d6c217mr1835277b3.2.1725987984610; Tue, 10 Sep 2024
 10:06:24 -0700 (PDT)
Date: Tue, 10 Sep 2024 10:06:23 -0700
In-Reply-To: <1cd7516391a4c51890c5b0c60a6f149b00cae3af.camel@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240626073719.5246-1-amit@kernel.org> <Zn7gK9KZKxBwgVc_@google.com>
 <CALMp9eSfZsGTngMSaWbFrdvMoWHyVK_SWf9W1Ps4BFdwAzae_g@mail.gmail.com>
 <52d965101127167388565ed1520e1f06d8492d3b.camel@kernel.org>
 <DS7PR12MB57665C3E8A7F0AF59E034B3C94D32@DS7PR12MB5766.namprd12.prod.outlook.com>
 <Zow3IddrQoCTgzVS@google.com> <ZpTeuJHgwz9u8d_k@t470s.drde.home.arpa>
 <ZpbFvTUeB3gMIKiU@google.com> <1cd7516391a4c51890c5b0c60a6f149b00cae3af.camel@kernel.org>
Message-ID: <ZuB8j02laOrxq-ji@google.com>
Subject: Re: [PATCH v2] KVM: SVM: let alternatives handle the cases when RSB
 filling is required
From: Sean Christopherson <seanjc@google.com>
To: Amit Shah <amit@kernel.org>
Cc: David Kaplan <David.Kaplan@amd.com>, Jim Mattson <jmattson@google.com>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "x86@kernel.org" <x86@kernel.org>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>, 
	"mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "hpa@zytor.com" <hpa@zytor.com>, 
	Kim Phillips <kim.phillips@amd.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 22, 2024, Amit Shah wrote:
> On Tue, 2024-07-16 at 12:10 -0700, Sean Christopherson wrote:
> > FWIW, I feel the same way about all the other post-VM-Exit mitigations,
> > they just don't stand out in the same way because the entire mitigation
> > sequence is absent on one vendor the other, i.e. they don't look wrong =
at
> > first glance.=C2=A0 But if KVM could have a mostly unified VM-Enter =3D=
> VM-Exit
> > assembly code, I would happliy eat a dead NOP/JMP or three.=C2=A0 Now t=
hat I
> > look at it, that actually seems very doable...
>=20
> Sure.  I think some of the fallacy there is also to treat VMX and SVM
> as similar (while not treating the Arm side as similar).

Bringing ARM into the picture is little more than whataboutism.  KVM x86 an=
d KVM
arm64 _can't_ share assembly.  They _can't_ share things like MSR intercept=
ion
tracking because MSRs are 100% an x86-only concept.  The fact that sharing =
code
across x86 and ARM is challenging doesn't have any bearing on whether or no=
t
VMX and SVM can/should share code.

> They are different implementations, with several overlapping details - bu=
t
> it's perilous to think everything maps the same across vendors.

I never said everything maps the same.  The point I am trying to make is th=
at
there is significant value _for KVM_ in having common code between architec=
tures,
and between vendors within an architecture.  I can provide numerous example=
s
where something was implemented/fixed in vendor/arch code, and then later i=
t was
discovered that the feature/fix was also wanted/needed in other vendor/arch=
 code.

