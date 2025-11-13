Return-Path: <kvm+bounces-63060-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F0CB1C5A4DA
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 23:20:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 525EB3A86A9
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 22:20:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2063632573C;
	Thu, 13 Nov 2025 22:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RSOr3G2H"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02FEB3164D0
	for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 22:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763072422; cv=none; b=PTa2dPGjw1asnX/BQQ+mbX526usy/QJKbl4tiu5sSvn2rVoORHblfzUsuVtaIrDk6REhwGOD6fTPf02virl+QmNT/9C/obR/pSFWhGU93PU3HzHuVvqJAwfDTiGxAita2aSX9tQZBzQN1TOjfQ8iAX44jeR+F6TOiWBX04F6w5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763072422; c=relaxed/simple;
	bh=APzDKF9oHYTOy76CW6cEyWnyacXI6Vs76WPJ4CCxHbc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bEItNY1M9UFmvFzaJO6gen83zc1KvMUKSEsCSB5+Pw8UtOiByLBlVtcTlHOnZUU0latoGlVuCJ1Ksp/FHxKGMoFs2RlizuUWMx28nGWwoQYZo4S1HuRLvH9GS5Nm4QjBwV2f8VbpADvkOT+IrGlxEUvU3lm9nF2HSJ0sYro26EE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RSOr3G2H; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-297dde580c8so38612675ad.1
        for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 14:20:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763072420; x=1763677220; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ev7akF6cAophO73bjgScc9ft8R5juoXLSv57+/Q1ASY=;
        b=RSOr3G2Hf2BGcUeOZ7h5qZy1uut4YuDOypFq9JwLcGhlhrjD+wwimmjGBQYdE2roRZ
         myvygJipA29kw8hJh8ex098c+cFPAuaSuNeo00fjmh4vfemOaimjRCy7UPvKywzAbhBC
         qWGjHvHZcVWpgyA931UU+9DSPENipFeVj6KAwX14W1MkdWr26qjIHkNBFIlSGFVp882E
         piqavsyLxSM2yYW+2V0LFi9IY7n67nDCTbZHeGhaE0oydHcIuWoe+UhqiZdRi3pYdGEL
         LIA32KstzgfC1tWVRIR2VJro2MuDpvCS/v0TZ/pi4Gt8CIFZgJD0Keqqe8o8Pg6bSeHh
         QIKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763072420; x=1763677220;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Ev7akF6cAophO73bjgScc9ft8R5juoXLSv57+/Q1ASY=;
        b=oaYmATIbJge+l77sEtPHsPItEW60hiG6ScFBec7aFmHbEvBckblvkO+FgXcMfQ9JDh
         dZGp76/LpTilWX8HvIWQCSgLVGBYJnmYPyH+Vy0+mujlGwC5AaImIvAQ7bUor5sfH1z6
         MGTJ7jSZ/xV3xwYAMAXGXLN/qKRCIwGZHwR6DOb7D6B/heoFqAjSE2l/c22NBqMDmsUa
         FjvL8Sh6Onpqlx8ow3JW/38WFlfMdatLZyza9HPlRh8WeqQk15zWbHXTj5w5AwXpsLzH
         v2j0jHJfFwrUSJBfDMmgOPk+4d6a6b+SHVP2bIhayHAduygKQ4LPScLLVKWSvDvtwXnZ
         iPEg==
X-Forwarded-Encrypted: i=1; AJvYcCU0ax9WgVxDrT/qeDc2NgDuAaeFCgiF7Jf2Sm0T888qgt85u+2U+/b32qnN6cNGin4yjno=@vger.kernel.org
X-Gm-Message-State: AOJu0YwuWJCtp+fWwy5KmbfFnMtIH6sJYyGEahtie8kOunyZJLijWlst
	SFVr7aTxFgg6J/chEjO9kfA818xQ1nzQ5k5OUgoL5IFDpAbG/ofOV9Zsehg7XTWQ5sP7sHkhnHQ
	eql1CRQ==
X-Google-Smtp-Source: AGHT+IET41UbD4YkeDvpm8DYHBAzULOxW9ET30nnd5usL+DvzPcUxvpRRhSfznBBCARAbW8xQG8ATyaGwNA=
X-Received: from plek20.prod.google.com ([2002:a17:903:4514:b0:297:e91a:4704])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:da8a:b0:298:8ec:9991
 with SMTP id d9443c01a7336-2986a73b83amr7109365ad.37.1763072420279; Thu, 13
 Nov 2025 14:20:20 -0800 (PST)
Date: Thu, 13 Nov 2025 14:20:18 -0800
In-Reply-To: <9EF391B5-71E8-4A9C-BD55-B78B5DEE5638@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251026201911.505204-1-xin@zytor.com> <9EF391B5-71E8-4A9C-BD55-B78B5DEE5638@zytor.com>
Message-ID: <aRZZoqxwTBa_16HU@google.com>
Subject: Re: [PATCH v9 00/22] Enable FRED with KVM VMX
From: Sean Christopherson <seanjc@google.com>
To: Xin Li <xin@zytor.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, pbonzini@redhat.com, corbet@lwn.net, 
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, luto@kernel.org, 
	peterz@infradead.org, andrew.cooper3@citrix.com, chao.gao@intel.com, 
	hch@infradead.org, sohil.mehta@intel.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 06, 2025, Xin Li wrote:
>=20
> > On Oct 26, 2025, at 1:18=E2=80=AFPM, Xin Li (Intel) <xin@zytor.com> wro=
te:
> > Although FRED and CET supervisor shadow stacks are independent CPU
> > features, FRED unconditionally includes FRED shadow stack pointer
> > MSRs IA32_FRED_SSP[0123], and IA32_FRED_SSP0 is just an alias of the
> > CET MSR IA32_PL0_SSP.  IOW, the state management of MSR IA32_PL0_SSP
> > becomes an overlap area, and Sean requested that FRED virtualization
> > to land after CET virtualization [1].
> >=20
> > With CET virtualization now merged in v6.18, the path is clear to submi=
t
> > the FRED virtualization patch series :).
>=20
> Sean, what is the plan for the FRED patch series?

Review and merge it asap.  Unfortunately, "asap" isn't all that soon, mostl=
y
because I've been bogged down with non-upstream stuff.  I'm hoping to dive =
in
next week (but take that with a grain of salt; I've more or less said that =
exact
thing to someone else for other patches for three weeks running).

