Return-Path: <kvm+bounces-15994-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 007748B2D3D
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 00:44:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 83E0B1F2123E
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 22:44:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC482156230;
	Thu, 25 Apr 2024 22:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SOnByfDX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC0BE1482ED
	for <kvm@vger.kernel.org>; Thu, 25 Apr 2024 22:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714085034; cv=none; b=sEPSqngNfomlp2HrEHmECsdzBEPruuZ8ds8dyaDUOY2zVOBxBt0w45KBcG5xwInDYRYmHHUMG9uSvaVECP40fEiKmNxPPs5EsZIMPdQ46uQEO+AOR4bnGrcXc5UOcU/4wbicLgkxPgW0IZ/iidYxaZlp0JhPAh6KEyNbcJseXIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714085034; c=relaxed/simple;
	bh=H9ptPffD72a6EE/F8GmAJPbH4Hs3FnnZrATVgQncKMk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YORvSxjeGIOciQxCBfdrXDFs0HBmkhFeC8HqZF/jlaDSs02bOmTJRHSI+toK6Z3FdqQHVapTWVLrg3Dc7tcBSl/p8LlSKcOB+q7XRWC0Ge16x68vG24Bgb+WinoHPEb7CUkHivVMVja9JziSNXUQjH82cMr/M6QgTDmqHHK9Lkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SOnByfDX; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-618596c23b4so26536387b3.0
        for <kvm@vger.kernel.org>; Thu, 25 Apr 2024 15:43:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714085032; x=1714689832; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NrglaiEx1K/p7eLezRNfFqqwp5tC5DyM7fbQ8fng/Qs=;
        b=SOnByfDXjE3qVf99fyP9uKuHBKKXqKWTgbMj/XXbcKiR+p4z6wUr+k6S8N0j+KSNCI
         PHUj53dvMjKRTvhXtR7qUXduEmyXey/QW3c4KMYDnlSK0sVcStISn6Zgd98GntVzGS7J
         z/muwndBoOYmroz9go2oGcGQnp8tFXRYpuX5KXfEoHWufm6Wowkh0tPpiqaHdAu1bO9c
         t+BHU2v+gD5H60Ce6aTcsd5gUpLtx+tDG6vFw1/9tD6k7x0jBucqYGlCCr22rf3ZPxDc
         wOVLAb1hkh/yV0TytGecpv075Bxro+T35ymKjDSRirlFbpWXcrX9kKbqUrD9bIzn/S1e
         0z9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714085032; x=1714689832;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NrglaiEx1K/p7eLezRNfFqqwp5tC5DyM7fbQ8fng/Qs=;
        b=EctZAlOZtEaSPnSigCZJaVDiz2JqchyK6Oy2HprQP+KdOoGXi9dnkdUPU31ZaF2pog
         4upAbWmukf4DvdKRYBBDSLDoIBUlg/GKyiVmZJBz0gwKwGmrICvtkj6sqy4Isqd2hwmN
         D1OYFWc/LTKjearSIpg2WsgiWULftLUzEz0ad8HuNL6Ug4aRa7XZYcQBZJz3Ir04DbDO
         JhrvsAoeUM7R67NYOhxLL/QJDTHijzFRkf7JGlPXgWwucUIYvqcy8uKUIFFv2UCXlypg
         MivQ4H+nJRP2krFpIdNTKxGeYirPiz6Tf83++R/Yn+9KHYreyS9fQv0R0NkspYMxDWAB
         Z0pA==
X-Forwarded-Encrypted: i=1; AJvYcCUsHCGXMK0VwZPy3ti448ozdJ78yZ5Ja4CSmeMWuhySGsjhpBzJf6ImSwXYn6MxwnI2rAzHHqiclLHgtu/PYsQmHVL3
X-Gm-Message-State: AOJu0YxZlemTLMccQi9OG0LI5/yNcYlHcHxyJ98dQZkVONg1dAZpoxJ6
	2p6jpcM3UsedKKoXBjNeevPsjbKQ5SlsE1i8Y6nceQgXUAvaE99MQuV/T1DWFKiKG8vlL7NQ1GY
	t2A==
X-Google-Smtp-Source: AGHT+IE0l8k5q6IRZWoxVpxZFQN5YmWjoxKGFyyO2KChppLOxrZxf2iMNWv7d/ZYxr9xghhup9Fmi2GUOUI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:ab6e:0:b0:dda:c566:dadd with SMTP id
 u101-20020a25ab6e000000b00ddac566daddmr110183ybi.4.1714085031720; Thu, 25 Apr
 2024 15:43:51 -0700 (PDT)
Date: Thu, 25 Apr 2024 15:43:50 -0700
In-Reply-To: <b605722ac1ffb0ffdc1d3a4702d4e987a5639399.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <ZiaWMpNm30DD1A-0@google.com> <3771fee103b2d279c415e950be10757726a7bd3b.camel@intel.com>
 <Zib76LqLfWg3QkwB@google.com> <6e83e89f145aee496c6421fc5a7248aae2d6f933.camel@intel.com>
 <d0563f077a7f86f90e72183cf3406337423f41fe.camel@intel.com>
 <ZifQiCBPVeld-p8Y@google.com> <61ec08765f0cd79f2d5ea1e2acf285ea9470b239.camel@intel.com>
 <9c6119dacac30750defb2b799f1a192c516ac79c.camel@intel.com>
 <ZiqFQ1OSFM4OER3g@google.com> <b605722ac1ffb0ffdc1d3a4702d4e987a5639399.camel@intel.com>
Message-ID: <Zircphag9i1h-aAK@google.com>
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
Content-Type: text/plain; charset="us-ascii"

On Thu, Apr 25, 2024, Kai Huang wrote:
> On Thu, 2024-04-25 at 09:30 -0700, Sean Christopherson wrote:
> > On Tue, Apr 23, 2024, Kai Huang wrote:
> > And anecdotally, I know of at least one crash in our production environment where
> > a VMX instruction hit a seemingly spurious #UD, i.e. it's not impossible for a
> > ucode bug or hardware defect to cause problems.  That's obviously _extremely_
> > unlikely, but that's why I emphasized that sanity checking CR4.VMXE is cheap.
> 
> Yeah I agree it could happen although very unlikely.
> 
> But just to be sure:
> 
> I believe the #UD itself doesn't crash the kernel/machine, but should be
> the kernel unable to handle #UD in such case?

Correct, the #UD is likely not (immediately) fatal.
> 
> If so, I am not sure whether the CR4.VMX check can make the kernel any
> safer, because we can already handle the #UD for the SEAMCALL instruction.

It's not about making the kernel safer, it's about helping triage/debug issues.

> Yeah we can clearly dump message saying "CPU isn't in VMX operation" and
> return failure if we have the check, but if we don't, the worst situation
> is we might mistakenly report "CPU isn't in VMX operation" (currently code
> just treats #UD as CPU not in VMX operation) when CPU doesn't
> IA32_VMX_PROCBASED_CTLS3[5].
> 
> And for the IA32_VMX_PROCBASED_CTLS3[5] we can easily do some pre-check in
> KVM code during module loading to rule out this case.
>
> And in practice, I even believe the BIOS cannot turn on TDX if the
> IA32_VMX_PROCBASED_CTLS3[5] is not supported.  I can check on this.

Eh, I wouldn't worry about that too much.  The only reason I brought up that
check was to call out that we can't *know* with 100% certainty that SEAMCALL
failed due to the CPU not being post-VMXON.

> > Practically speaking it costs nothing, so IMO it's worth adding even if the odds
> > of it ever being helpful are one-in-and-million.
> 
> I think we will need to do below at somewhere for the common SEAMCALL
> function:
> 
> 	unsigned long flags;
> 	int ret = -EINVAL;
> 
> 	local_irq_save(flags);
> 
> 	if (WARN_ON_ONCE(!(__read_cr4() & X86_CR4_VMXE)))
> 		goto out;
> 
> 	ret = seamcall();
> out:
> 	local_irq_restore(flags);
> 	return ret;
> 
> to make it IRQ safe.
>
> And the odd is currently the common SEAMCALL functions, a.k.a,
> __seamcall() and seamcall() (the latter is a mocro actually), both return
> u64, so if we want to have such CR4.VMX check code in the common code, we
> need to invent a new error code for it.

Oh, I wasn't thinking that we'd check CR4.VMXE before *every* SEAMCALL, just
before the TDH.SYS.LP.INIT call, i.e. before the one that is most likely to fail
due to a software bug that results in the CPU not doing VMXON before enabling
TDX.

Again, my intent is to add a simple, cheap, and targeted sanity check to help
deal with potential failures in code that historically has been less than rock
solid, and in function that has a big fat assumption that the caller has done
VMXON on the CPU.

> That being said, although I agree it can make the code a little bit
> clearer, I am not sure whether it can make the code any safer -- even w/o
> it, the worst case is to incorrectly report "CPU is not in VMX operation",
> but shouldn't crash kernel etc.

