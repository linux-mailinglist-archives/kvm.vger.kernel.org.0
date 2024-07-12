Return-Path: <kvm+bounces-21536-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EDA192FEBA
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 18:44:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9A08E1C22A4F
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 16:44:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60292176AA5;
	Fri, 12 Jul 2024 16:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QHC8gYrl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A1941DFD2
	for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 16:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720802660; cv=none; b=f+E8D3xzuKDJFHdWedWM9hXijh5xU4igk7e+8CnSoOEey6PI8I4BHTRXsDg6ZnugDeyNIGEEnSarkgeCPBHdmQZMp9WyZIH0RuZBQop+WSVW47V9famE3BXR5E5ZnwbhysPs8cYRrE6SuMOEOb5jd2qQFmSOxfnYOlOIsBqsHhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720802660; c=relaxed/simple;
	bh=R/VQL6TZWIMbWV7Oz6zjIUUzEa4X1DiUdsIcFW8Fp1w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qsRk9przj2MLi75WlKBZT2lbA4eiJYoPkiIgmRyXVQZ0ESZS44TSNeA8rMTKGUU/ILsiUFCewbhaAD/Z4aw74fFaI1LjvnSG3xsD1+GXVhQsrDNLxqjkX2oGJ0V00VAhrLMPIY5H73lIlRsA4Tj+uumcnWHybrDxFXyzRTdfYco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QHC8gYrl; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e035949cc4eso4180708276.1
        for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 09:44:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720802658; x=1721407458; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=e2/8S8obzkiJSotbtrvsa+xr/94yI9iIKCvWVMV27e0=;
        b=QHC8gYrlS3+gE0K3dMytxBL3oeQhSDnznrj3T9WHNaGqHy/0CdIU6wWfCOKhl2c2BX
         Z/D0bZ5A1GbaZVsxb+wsgCfGolZR4OEa4bce/xeGqpygknXarZmEZDj9tDtJn7vKRfoL
         l4V3yUywB0f54xbF+1BqM9veHkPyT9A8Z6/LF/U6QstuOSegffmopcQt/A+f7UIxss4h
         ipvjch3MAYTWYPt6Bf5kEX5dmBv7v3q1aeS53upZLY69PdhNzU1HsGSdWYyQSeQIzsta
         JgTX+Ebt93mIdkefreHiCj3Yif9oFVb1ow18S6ABxW/4YmyKk1bfupunefgQ6mjHVkt4
         vqMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720802658; x=1721407458;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=e2/8S8obzkiJSotbtrvsa+xr/94yI9iIKCvWVMV27e0=;
        b=gghMky9Tndt9tgGg4CN07VkeoA2Fjb6WWhm/SsoPucbWrfo48/Egzk0CdxpDRDDYY7
         svOgjahEeWoU54GhqPXa8o2cGQ1iq0dsBMS2fKjgmnllFfCQ8c8Xm886DzDypHkLTCLG
         8j+pKGCNSMxtRx3xtO9/Lm11MxBjdxSm16D4GqW4LqqdJIHjiQYGG2kZDjQ8YcN2rQJm
         YPyurUdxRNRDshCj2xACqsDyGPURAvuk/lxHTAmyYushebBVGuSZTZpY1SL5MFfBB7vu
         QVHMO0mlreLEi7cSypuNz+4JiUYb9vYgoqX/4oQULR7PrTmS5PSrYw8/zX069TDjy05h
         +DPg==
X-Forwarded-Encrypted: i=1; AJvYcCWdcnER1Fv73SfpaO0a0ZWEY6DyAe7R3UorzStVtWw2NUZCVaXT1QdsgHab0IbEqcdttFoZTrqbUUfRC2sg3yMwiSXw
X-Gm-Message-State: AOJu0YzdlwsvG7d1g8w5dhbA3EvTLaa//TM8o7GQdA/S53yk/w3pUE+T
	FSWa68Q7HkglvGG8MdXNd7DI+w9n4SQHnPnpSBj8oHBd5Z4g8MLFAySOuQ6sTMW/1Ss23RTg0VV
	aMw==
X-Google-Smtp-Source: AGHT+IF/KOJ6Gpolu2Ub9nHa1DDJ0KD5nKpBN5oi+4bnQG+a/r7jBG5lYmOuxqEj5AFxHhdkEOevPVEs1hM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:a07:b0:e03:5dfe:45bb with SMTP id
 3f1490d57ef6-e041b14c6a3mr810243276.12.1720802658285; Fri, 12 Jul 2024
 09:44:18 -0700 (PDT)
Date: Fri, 12 Jul 2024 09:44:16 -0700
In-Reply-To: <20240712122408.3f434cc5@rorschach.local.home>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240403140116.3002809-1-vineeth@bitbyteword.org>
 <ZjJf27yn-vkdB32X@google.com> <CAO7JXPgbtFJO6fMdGv3jf=DfiCNzcfi4Hgfn3hfotWH=FuD3zQ@mail.gmail.com>
 <CAO7JXPhMfibNsX6Nx902PRo7_A2b4Rnc3UP=bpKYeOuQnHvtrw@mail.gmail.com>
 <66912820.050a0220.15d64.10f5@mx.google.com> <19ecf8c8-d5ac-4cfb-a650-cf072ced81ce@efficios.com>
 <20240712122408.3f434cc5@rorschach.local.home>
Message-ID: <ZpFdYFNfWcnq5yJM@google.com>
Subject: Re: [RFC PATCH v2 0/5] Paravirt Scheduling (Dynamic vcpu priority management)
From: Sean Christopherson <seanjc@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Joel Fernandes <joel@joelfernandes.org>, 
	Vineeth Remanan Pillai <vineeth@bitbyteword.org>, Ben Segall <bsegall@google.com>, 
	Borislav Petkov <bp@alien8.de>, Daniel Bristot de Oliveira <bristot@redhat.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	"H . Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>, 
	Mel Gorman <mgorman@suse.de>, Paolo Bonzini <pbonzini@redhat.com>, Andy Lutomirski <luto@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, 
	Valentin Schneider <vschneid@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, Wanpeng Li <wanpengli@tencent.com>, 
	Suleiman Souhlal <suleiman@google.com>, Masami Hiramatsu <mhiramat@kernel.org>, himadrics@inria.fr, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	graf@amazon.com, drjunior.org@gmail.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Jul 12, 2024, Steven Rostedt wrote:
> On Fri, 12 Jul 2024 10:09:03 -0400
> Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> 
> > > 
> > > Steven Rostedt told me, what we instead need is a tracepoint callback in a
> > > driver, that does the boosting.  
> > 
> > I utterly dislike changing the system behavior through tracepoints. They were
> > designed to observe the system, not modify its behavior. If people start abusing
> > them, then subsystem maintainers will stop adding them. Please don't do that.
> > Add a notifier or think about integrating what you are planning to add into the
> > driver instead.
> 
> I tend to agree that a notifier would be much better than using
> tracepoints, but then I also think eBPF has already let that cat out of
> the bag. :-p
> 
> All we need is a notifier that gets called at every VMEXIT.

Why?  The only argument I've seen for needing to hook VM-Exit is so that the
host can speculatively boost the priority of the vCPU when deliverying an IRQ,
but (a) I'm unconvinced that is necessary, i.e. that the vCPU needs to be boosted
_before_ the guest IRQ handler is invoked and (b) it has almost no benefit on
modern hardware that supports posted interrupts and IPI virtualization, i.e. for
which there will be no VM-Exit.

