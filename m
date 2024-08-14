Return-Path: <kvm+bounces-24200-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B1D7C9524A4
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 23:22:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5F6252839AC
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 21:22:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5916B1C8232;
	Wed, 14 Aug 2024 21:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qhKSx0Q0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3831B13DDB8
	for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 21:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723670550; cv=none; b=lTUPkCjB+MdasTYYVRw0MZLx/S6iy5+Gw49ZFmp4uW89t9OB55vwJmEUmBF+XMDl+Unlk5vh9zwxrWV8Lou48ZnoyroaZx44G0ynEZc3+pAat4kr8Y+h89daOGNNFI3sCSFGFM9V4I8TZQi4Q/nFKXOVXjQfTsaYCb69BtqwVg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723670550; c=relaxed/simple;
	bh=6TyAxGB4hhgPojX/Q4fkTFm1Tc99561d1DlmtwmN4zM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fq2pv6WF76aDK6GbkqNl10+/mZ3/BBMiSCRpObQ8g+AGZaRH/i1cgBX0HrvU7FNbyxN5cv8EfGaYAnAAoY5+ekVw47k1nrzTbZ9Zs9M7MG3H3iwpBRcUOnnv2UEMDCU8/cFzCyQrG9Rtpu/H2vhwA457SoWvMzeG6EtDuVwkFmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qhKSx0Q0; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e1159159528so1974812276.1
        for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 14:22:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723670548; x=1724275348; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=K1d2+MmPye2ZO3UyB0Pr8PJZD9IaRp0nT/Dg8kYuZDY=;
        b=qhKSx0Q0VLS6Iijo8sL3QuFeeJGmy6BdneCHr6jWbP9hp5iJ2KIn1Rp25tnFSR6Jsr
         749LE7Ys1d0TjVDRAChWz5Fi4Lz/ygkpfl8vAmCau4zmZIcLU01LumW4R9y4e4nqkchA
         esKM6FtV3bARWlbpd60O29rxF17xg7JQ/DXFOVhMDV49EXPYJngV2hItv+zQAWLxuWuK
         +NDrn8IkmktrOji7XagkPCL7WpVU+fa6OT74zBR80e5gEdTKIa37ROEK2AdagYmwiGnC
         Uu12umnNpJeoXE77efjW0YUh3C/T9+/yjDyC1IrVXQ/W8hC6HB+wgaVemcxcUIeyxaZW
         19Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723670548; x=1724275348;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=K1d2+MmPye2ZO3UyB0Pr8PJZD9IaRp0nT/Dg8kYuZDY=;
        b=ob9MgYSDVnPntoOgNoHOrKMHw8UYJrpZ9+bisLpYnlVn3u2UnrxjgUgjLYOdWPUUeP
         /ng6TQfmt4AG6ia48fh9YQstA+ma7gSY8A8+4HDjDqXUwRCCfldiep7khyloS4DdR12w
         S7mriy9rLq+VKa6hbMgOknaDjgv7v9CBGpnda7H3n893w0QZZxkdeUD4iYPjOptnzIXR
         bYjCYrTQxExsyKgZpapYzDZ0K32AT6Qn5zXzsrc+mlVcA+nU0V3IdO/1RjMpejrrsF3G
         oymjD8pWvqZnCF91ijB5In+1Ri22+81cpUNb892VhoRtQPCwLo1I3PvsapYILEv9PLum
         FlZQ==
X-Forwarded-Encrypted: i=1; AJvYcCWFstD5C8IMzi5Xi+5LC7jpIR3ory8o0jVEtvoVilLewjOnvilBzjbEQO6beUAxX2I7gZY=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywq85OQX514q/6RCERXG3UwOr885d219wq5S8zM7oo0xlj5GAN0
	qK17dw4NfYwBK1CbySd7t/K2OoSd/vUjUuWqY4PVoiA5bvzjHwCE9MgTGFaHoo6oBqoDvytR5kc
	rVQ==
X-Google-Smtp-Source: AGHT+IHeXYJ6EuXxi7hKv7alTHkax3aUyhjr3AuIuyBJK0UiU+zN8QBcM1YXFltOHqLsEiVFRgye4A5+mXw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:523:b0:e02:f35c:d398 with SMTP id
 3f1490d57ef6-e116cab25cfmr16532276.0.1723670548143; Wed, 14 Aug 2024 14:22:28
 -0700 (PDT)
Date: Wed, 14 Aug 2024 14:22:26 -0700
In-Reply-To: <67f05b7fee1c81ef4b4be62785cfd9a36df9e4c0.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-26-rick.p.edgecombe@intel.com> <ZrtEvEh4UJ6ZbPq5@chao-email>
 <efc22d22-9cb6-41f7-a703-e96cbaf0aca7@intel.com> <Zrv+uHq2/mm4H58x@chao-email>
 <ZrwFWiSQc6pRHrCG@google.com> <ZryLE+wNxhYHpyIP@chao-email>
 <Zryyqe6ibAR9h-yq@google.com> <67f05b7fee1c81ef4b4be62785cfd9a36df9e4c0.camel@intel.com>
Message-ID: <Zr0gEupQ7-Vsj3di@google.com>
Subject: Re: [PATCH 25/25] KVM: x86: Add CPUID bits missing from KVM_GET_SUPPORTED_CPUID
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: Chao Gao <chao.gao@intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>, Kai Huang <kai.huang@intel.com>, 
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 14, 2024, Rick P Edgecombe wrote:
> On Wed, 2024-08-14 at 06:35 -0700, Sean Christopherson wrote:
> > > One scenario where "fixed-1" bits can help is: we discover a security=
 issue
> > > and
> > > release a microcode update to expose a feature indicating which CPUs =
are
> > > vulnerable. if the TDX module allows the VMM to configure the feature=
 as 0
> > > (i.e., not vulnerable) on vulnerable CPUs, a TD might incorrectly ass=
ume
> > > it's
> > > not vulnerable, creating a security issue.
> > >=20
> > > I think in above case, the TDX module has to add a "fixed-1" bit. An =
example
> > > of
> > > such a feature is RRSBA in the IA32_ARCH_CAPABILITIES MSR.
> >=20
> > That would be fine, I would classify that as reasonable.=C2=A0 However,=
 that
> > scenario
> > doesn't really work in practice, at least not the way Intel probably ho=
pes it
> > plays out.=C2=A0 For the new fixed-1 bit to provide value, it would req=
uire a guest
> > reboot and likely a guets kernel upgrade.
>=20
> If we allow "reasonable" fixed bits, we need to decide how to handle any =
that
> KVM sees but doesn't know about. Not filtering them is simpler to impleme=
nt.
> Filtering them seems a little more controlled to me.
>=20
> It might depend on how reasonable, "reasonable" turns out. Maybe we give =
not
> filtering a try and see how it goes. If we run into a problem, we can fil=
ter new
> bits from that point, and add a quirk for whatever the issue is. I'm stil=
l on
> the fence.

As I see it, it's ultimately unlikely to be KVM's problem.  If Intel ships =
a
TDX-Module that does bad things, and someone's setup breaks when they upgra=
de to
that TDX-Module, then their gripe is with Intel.  KVM can't do anything to =
remedy
the problem.

If the upgrade breaks a setup because it confuses _KVM_, then I'll care, bu=
t I
suspect/hope that won't happen in practice, purely because KVM has so littl=
e
visiblity into the guest, i.e. doesn't care what is/isn't advertised to the=
 guest.

FWIW, AMD has effectively gone the "fixed-1" route for a few things[*], e.g=
. KVM
can't intercept XCR0 or XSS writes.  And while I detest the behavior, I hav=
en't
refused to merge support for SEV-ES+.  I just grumble every time it comes u=
p :-)

[*] https://lore.kernel.org/all/ZUQvNIE9iU5TqJfw@google.com

