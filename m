Return-Path: <kvm+bounces-64506-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FF4FC85978
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 15:57:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 62F874EBC03
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 14:54:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9D5F326D4A;
	Tue, 25 Nov 2025 14:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TBHk/d4H"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FC6B32573D
	for <kvm@vger.kernel.org>; Tue, 25 Nov 2025 14:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764082465; cv=none; b=peWa1dYNVBdbonkWaSp11fiSY4TGvU6g+lI2lRixupAeW/ubqqY3MvfuZ0Ap5UYwX1N5ES52rnXXLa5Jvf/BXX2Cf6SQqacUTovVQF465TiUmI+PuL0YT1kNq4jyLx9ZuGUiIHAbcovVwJwEiMMtRJj8CTiz1lSwOLhKZHB41Yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764082465; c=relaxed/simple;
	bh=RBpMUvotZ0GUM18c8sJcSQSxSVaPFG+PLiwq5ohfJFk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KSKvSIBUJyioFs/TCwnOhEZaGH6G11Yysg+0YCM1MXHRGsv8OjoT1GxPx2u7wfyIfHzANOm90MSkVDutMyukXJw3TugG12emEYUC9QltJ9W5+6OYsQIX0CA3Lcgu6eaZ9Puq40ft1cAlsi0VTBfGkgZliDxpRGz2WnylLtw5CDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TBHk/d4H; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-343daf0f38aso5804893a91.3
        for <kvm@vger.kernel.org>; Tue, 25 Nov 2025 06:54:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764082464; x=1764687264; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+AUAIh8PkiaBGBRwBOtLUCDWyGqYaBFI6Phm6LlRrAc=;
        b=TBHk/d4Hzhgnxw9+PYdy8Msp1lJ2z0rRIwpaIKPvpMiCQpuv8jvmn6c8stwP/R08Y8
         vbJPrDvhrZG2NveaGSowBEkn75s+IS3aGIQreQ7yoG80DwH2wmwucThL7z480cf4Q+do
         7BbdXHp4sHlhyFai2ErLd7Sz8muuda4AyVDWQuM+i0qVJ0+6DMnh2L0z3c7F3VBqVf55
         Rr65Rmm1eVh9Nn2reQ67V6q9BI50p9tLFY9ONLZXWnb8VUUKD/y7BMuyVwsmD4kmW6wO
         NSoONUbrjUQ9LUj1wFPRxwVl9IEwBA7KBY+XreDlSlT94AMsy7oubodqy3/pBZQcTvlk
         5jFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764082464; x=1764687264;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=+AUAIh8PkiaBGBRwBOtLUCDWyGqYaBFI6Phm6LlRrAc=;
        b=wkpCUuaJ3CCGpzwZ9iaFjOkRidb7oPMVLnALIHVMc7+JUVi9ykUZAZVsSZpxf2ArAd
         Lq+xUfBFsEqf1CHVvmygdiSgjfUzilbHzZv77q5U3EZtNoprsgbLFqwcl0Fo2nzN2Ah0
         1KBnjCKZ+4X/dZ8Pb80ITyCdfsADb3GkQ9wCiTnc3ElBtiKqgjI//JvTQM5JELQRiBJ5
         pxn2g0KtUfsDZQ3knQtel51MizV3Brk7BDUJV9bxqMdoaEZJzINBczUvUTDJ89/HNVzW
         V3gPwyWqL6tUYk/3FS8RBx/mztLiNxYC7udu65NY6g9TPKHDJlE83Z+4sg3iTQphyTJ1
         bkjQ==
X-Forwarded-Encrypted: i=1; AJvYcCV7pKpPnkYkXPGuASMaByvWnggJ1fLLt3Dk7tso6kcep4/qb4i0w8+s/P/7zGn4vXKBGmE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxlgO9WO1Y/85CrAGdubprdJ9un/6CBLvj47+Y5ugmK5fNH516d
	ymsG07iBTFbXJe3FYnUchTESOf8fLdlkna0KBUwiMCuh07NhBNZGuEIFCRdnzZmSriI37eNFWLI
	4kUP9pA==
X-Google-Smtp-Source: AGHT+IETpqfOMbQHciADtekePteXvnv9DlqX36J6TK/HCkOjyABlfnd9wiI8RuLemzKsnOn3SU1gXUo19c0=
X-Received: from pjnm17.prod.google.com ([2002:a17:90a:8591:b0:340:53bc:56cb])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3bcc:b0:343:7714:4caa
 with SMTP id 98e67ed59e1d1-3475ebe7401mr2637894a91.3.1764082463841; Tue, 25
 Nov 2025 06:54:23 -0800 (PST)
Date: Tue, 25 Nov 2025 06:54:22 -0800
In-Reply-To: <718b02d4cfa56a65cb2383a0e57ca988defc036b.camel@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251107093239.67012-1-amit@kernel.org> <20251107093239.67012-2-amit@kernel.org>
 <aR913X8EqO6meCqa@google.com> <db6a57eb67620d1b41d702baf16142669cc26e5c.camel@amd.com>
 <4102ede9-4bf7-4c0a-a303-5ed4d9cca762@citrix.com> <718b02d4cfa56a65cb2383a0e57ca988defc036b.camel@amd.com>
Message-ID: <aSXDHq4vUdB8Zqsv@google.com>
Subject: Re: [PATCH v6 1/1] x86: kvm: svm: set up ERAPS support for guests
From: Sean Christopherson <seanjc@google.com>
To: Amit Shah <Amit.Shah@amd.com>
Cc: "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>, "corbet@lwn.net" <corbet@lwn.net>, 
	"pawan.kumar.gupta@linux.intel.com" <pawan.kumar.gupta@linux.intel.com>, 
	"kai.huang@intel.com" <kai.huang@intel.com>, "jpoimboe@kernel.org" <jpoimboe@kernel.org>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, 
	"daniel.sneddon@linux.intel.com" <daniel.sneddon@linux.intel.com>, Thomas Lendacky <Thomas.Lendacky@amd.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "mingo@redhat.com" <mingo@redhat.com>, 
	"dwmw@amazon.co.uk" <dwmw@amazon.co.uk>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"tglx@linutronix.de" <tglx@linutronix.de>, Babu Moger <Babu.Moger@amd.com>, 
	Sandipan Das1 <Sandipan.Das@amd.com>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "hpa@zytor.com" <hpa@zytor.com>, 
	"peterz@infradead.org" <peterz@infradead.org>, "bp@alien8.de" <bp@alien8.de>, 
	"boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>, David Kaplan <David.Kaplan@amd.com>, 
	"x86@kernel.org" <x86@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 25, 2025, Amit Shah wrote:
> On Mon, 2025-11-24 at 16:40 +0000, Andrew Cooper wrote:
> > > > So punting on emulating RAP clearing because it's too hard is not
> > > > an option.=C2=A0 And AFAICT, it's not even that hard.
> > > I didn't mean on punting it in the "it's too hard" sense, but in the
> > > sense that we don't know all the details of when hardware decides to =
do a
> > > flush; and even if triggers are mentioned in this APM today, future
> > > changes to microcode or APM docs might reveal more triggers that we n=
eed
> > > to emulate and account for.=C2=A0 There's no way to track such change=
s, so my
> > > thinking is that we should be conservative and not assume anything.
> >=20
> > But this *is* the problem.=C2=A0 The APM says that OSes can depend on t=
his
> > property for safety, and does not provide enough information for
> > Hypervisors to make it safe.
>=20
> That's certainly true - that's driving my reluctance to perform the
> emulation or in enabling it for cases that aren't completely clear.

Uh, I think you're misunderstanding what Andrew and I are saying.  Doing no=
thing
is the worst option.

> > ERAPS is a bad spec.=C2=A0 It should not have gotten out of the door.
> >=20
> > A better spec would say "clears the RAP on any MOV to CR3" and
> > nothing else.
> >=20
> > The fact that it might happen microarchitecturally in other cases doesn=
't
> > matter; what matters is what OSes can architecturally depend on, and ri=
ght
> > now that that explicitly includes "unspecified cases in NDA documents".
>=20
> To be honest, I haven't seen the mention of those unspecified cases or
> NDA documents.
>=20
> However, at least for the case of an NPT guest, the hypervisor does not
> need to do anything special (other than handle nested guests as this
> patch does).

How on earth do you come to that conclusion?  I'm genuinely baffled as to w=
hy
you think it's safe to completely ignore RAP clears that are architecturall=
y
supposed to happen from the guest's perspective.=20

