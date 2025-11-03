Return-Path: <kvm+bounces-61856-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id C6BF4C2D367
	for <lists+kvm@lfdr.de>; Mon, 03 Nov 2025 17:44:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id B61EF4E594B
	for <lists+kvm@lfdr.de>; Mon,  3 Nov 2025 16:44:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E57BF3191DA;
	Mon,  3 Nov 2025 16:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kwTwneeu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA728315D5A
	for <kvm@vger.kernel.org>; Mon,  3 Nov 2025 16:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762188271; cv=none; b=gf2SkYC2sYIHggAhIOUGW1TL/UpXWupEpr+R+mX9UiAlPCQaVeN5FgY3udwfsqjIxAct0xk/LwIIg+xre7RMSqKY38OVVmQ5g8g/i+7PWUfe8D7ANqDFmioR3cLhBDBpCMlwQqkr2O8tPT0GnFJNcU6qxbHttaAK6MHjRXFpxfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762188271; c=relaxed/simple;
	bh=w2feD2ttgeXkYR55jPw9Y7SXgsX+KQU5PqxDgw8kmJU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=K4/2SxanJdVSi9nvhXE/0PQeeYg4/Hr3HmqlkhZMPrgqq1Pgj+sv+fu4gUlcY2meVkuAqP4p+aeFw0rYcVncgEIrzc1c+ZTzcmfaKgb8V0JWOHqmmJGifCi6ZgYaOpgdwyPXS7FuRdGi1pIAMUtmsPuahAu52mvLIBUvKmE3OI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kwTwneeu; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-295c64cb951so212655ad.0
        for <kvm@vger.kernel.org>; Mon, 03 Nov 2025 08:44:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762188269; x=1762793069; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=usZ/GjzUptuHMzqFuSlgFzDClkHAfq8dzjjPtBKSebs=;
        b=kwTwneeuOvqrvHonTtml9vbU+0ufkOsTpY+BGRIDM7SF52N42RLcjIsm3PUpZjxV+Q
         dddQ4wFULIVxkY5HN3pJMYN62EB1epgRbosPVlmNx7s4IsthwoTF/pMoNqELy0Pih+VY
         QmGwZPynqRjaiSM4HEJu+J4icnw3CI13tpxfDmii3Lg4JRkgN2Rrez2JuB7lart8D3Rq
         LuHg7xSx7+6TjqKHrd1uXmRN3NIGmflJF/c56d6VrU9viBxxVbLMPokHzrfTbKKH1GoV
         ub5jvqbkpR5S5LN2/xwivq9zZ/VHsmdKmwG6tzrj9yaZMJWUhrRYGGnP/CyqJVk4V/Gs
         3U3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762188269; x=1762793069;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=usZ/GjzUptuHMzqFuSlgFzDClkHAfq8dzjjPtBKSebs=;
        b=tBfPCTbx+A3wGLWfAd7LY4X8e4MhEemwjR307LR3ayF7tho9E67Lx2o5Jeh5f0FaE6
         pNOJT6cz5UptnB3HCaKe5WVhO/fqmBtRlY+LoGloKsBJ6ll9jz2685b45dRcauSAguS5
         eTrZ82NJpPNzxgKRpWzsqCZpwxLZ0Mp888mz+G2EF3DbRbMeEEX9On6hCsIBUCHgXNaM
         r99gLPP0JcBo+HGDXE6hZ+JLd1rOah/ZGYBraTb0WDTT6sRG224TP4oaLN4PUddWg1WE
         wn6059S4FJKyQ24KUtlPz/1KbS77UHQEinNVJ7iGu+ZnhXYBr8ulrNoaNiEk0BrKcO1B
         50JA==
X-Gm-Message-State: AOJu0YyuxzD5Xt0FudhgQ63stT0FRewzkbtWfjoQO0ovbVMnqAliYZOH
	tzEj0ZJf8mtRcSqIOr5tynlIyZ4JlxfKaVjd/SGTNm4LZ+ImHE4/1f1Lt/bwUsr0POH4lela/0D
	ibQGQHaL61OEf9l8arR9/Vi0S8hBEJ2BPNYD458kW
X-Gm-Gg: ASbGncvMiEx6A3xOJy1dq1sh2a0KaZhrZXmSgD939Gl0cO80OSNZVITPtPC2tlbouJ1
	DuHX03wzvHAaFBwW9Jql3uE2u54GMUaAFjpeLqMdGw3uULXj5IsiEpJY2XOjY3r/NFU1K9qH9e2
	K7QYSnRY+Z3t0MzGWA9WRVsY2ahjp9rM2Hjexot4dzH5+bJ4KC7HJt5szdymxcsxQmW0jyrPWai
	gQsPqdV1oMJMTe8PVvqLbOa33A6/mVPoM6Bg5LaroQzf8ePuSo3KyR8SdZX1dbrWYw/pG9eN3cg
	4tciPeHb4558BfLJSLSEptSw4lvZ
X-Google-Smtp-Source: AGHT+IFs+i74UEsPKiI4HBGk0AHRpY3oPKbKNmcPl4IvOaPQn9Rz7GlwRRaoVvhFaH16oJIE3DvbsmkRkuVoBFJNKRQ=
X-Received: by 2002:a17:902:e84d:b0:271:9873:80d9 with SMTP id
 d9443c01a7336-295f8cc34f0mr347465ad.7.1762188268555; Mon, 03 Nov 2025
 08:44:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250901160930.1785244-1-pbonzini@redhat.com> <20250901160930.1785244-5-pbonzini@redhat.com>
 <CAGtprH-63eMtsU6TMeYrR8bi=-83sve=ObgdVzSv0htGf-kX+A@mail.gmail.com>
 <811dc6c51bb4dfdc19d434f535f8b75d43fde213.camel@intel.com>
 <ec07b62e266aa95d998c725336e773b8bc78225d.camel@intel.com>
 <114b9d1593f1168072c145a0041c3bfe62f67a37.camel@intel.com>
 <CAGtprH9uhdwppnQxNUBKmA4DwXn3qwTShBMoDALxox4qmvF6_g@mail.gmail.com> <3cc285fc5f376763b7a0b02700ac4520e95cf4d6.camel@intel.com>
In-Reply-To: <3cc285fc5f376763b7a0b02700ac4520e95cf4d6.camel@intel.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Mon, 3 Nov 2025 08:44:16 -0800
X-Gm-Features: AWmQ_bnpejAZPjxey9qNJ4qVNIQOpviEighDn8xmxts_7VWMUGm00GjcWVLHS1I
Message-ID: <CAGtprH9jc9Xu83_K1g0dbTtPKYx=oODz8aeqbKOtpHYsAgg5yg@mail.gmail.com>
Subject: Re: [PATCH 4/7] x86/kexec: Disable kexec/kdump on platforms with TDX
 partial write erratum
To: "Huang, Kai" <kai.huang@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, 
	"ashish.kalra@amd.com" <ashish.kalra@amd.com>, "Hansen, Dave" <dave.hansen@intel.com>, 
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "Williams, Dan J" <dan.j.williams@intel.com>, 
	"kas@kernel.org" <kas@kernel.org>, "seanjc@google.com" <seanjc@google.com>, 
	"dwmw@amazon.co.uk" <dwmw@amazon.co.uk>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"mingo@redhat.com" <mingo@redhat.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>, 
	"nik.borisov@suse.com" <nik.borisov@suse.com>, "Chatre, Reinette" <reinette.chatre@intel.com>, 
	"hpa@zytor.com" <hpa@zytor.com>, "peterz@infradead.org" <peterz@infradead.org>, 
	"sagis@google.com" <sagis@google.com>, "Chen, Farrah" <farrah.chen@intel.com>, 
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "bp@alien8.de" <bp@alien8.de>, 
	"tglx@linutronix.de" <tglx@linutronix.de>, "Gao, Chao" <chao.gao@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 28, 2025 at 2:31=E2=80=AFAM Huang, Kai <kai.huang@intel.com> wr=
ote:
>
> On Mon, 2025-10-27 at 17:07 -0700, Vishal Annapurve wrote:
> > On Mon, Oct 27, 2025 at 2:28=E2=80=AFPM Huang, Kai <kai.huang@intel.com=
> wrote:
> > >
> > > On Mon, 2025-10-27 at 16:23 +0000, Edgecombe, Rick P wrote:
> > > > On Mon, 2025-10-27 at 00:50 +0000, Huang, Kai wrote:
> > > > > >
> > > > > > IIUC, kernel doesn't donate any of it's available memory to TDX=
 module
> > > > > > if TDX is not actually enabled (i.e. if "kvm.intel.tdx=3Dy" ker=
nel
> > > > > > command line parameter is missing).
> > > > >
> > > > > Right (for now KVM is the only in-kernel TDX user).
> > > > >
> > > > > >
> > > > > > Why is it unsafe to allow kexec/kdump if "kvm.intel.tdx=3Dy" is=
 not
> > > > > > supplied to the kernel?
> > > > >
> > > > > It can be relaxed.  Please see the above quoted text from the cha=
ngelog:
> > > > >
> > > > >  > It's feasible to further relax this limitation, i.e., only fai=
l kexec
> > > > >  > when TDX is actually enabled by the kernel.  But this is still=
 a half
> > > > >  > measure compared to resetting TDX private memory so just do th=
e simplest
> > > > >  > thing for now.
> > > >
> > > > I think KVM could be re-inserted with different module params? As i=
n, the two
> > > > in-tree users could be two separate insertions of the KVM module. T=
hat seems
> > > > like something that could easily come up in the real world, if a us=
er re-inserts
> > > > for the purpose of enabling TDX. I think the above quote was talkin=
g about
> > > > another way of checking if it's enabled.
> > >
> > > Yes exactly.  We need to look at module status for that.
> >
> > So, the right thing to do is to declare the host platform as affected
> > by PW_MCE_BUG only if TDX module is initialized, does that sound
> > correct?
>
> I was thinking something like this:
>
> https://lore.kernel.org/lkml/20250416230259.97989-1-kai.huang@intel.com/

This seems to be an important thing to make progress on. IMO,
disabling kexec/kdump even if the host doesn't plan to use TDX
functionality but wants to keep the build config enabled is a
regression.

I think explicitly doing TDX module initialization[1] ideally needs
something like the above series from Kai and possibly resetting the
PAMT memory during kexec/kdump at least on SPR/EMR CPUs. Otherwise
it's effectively impossible to enable CONFIG_INTEL_TDX_HOST and have
kexec/kdump working on the host even if no confidential workloads are
scheduled on such SPR/EMR hosts.

[1] https://lore.kernel.org/kvm/20251010220403.987927-4-seanjc@google.com/

