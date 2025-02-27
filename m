Return-Path: <kvm+bounces-39608-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 41B8EA485A2
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 17:49:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B42A6188A28A
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 16:44:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B47BD1B85D1;
	Thu, 27 Feb 2025 16:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sV9MPrcz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52E031B21AC
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 16:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740674645; cv=none; b=bvGwP5VjzVULtUMzpDNbdE4VT+jR4naCpfzLxcdon1tc78qUYo7b/Qt0yuMRCSWJht/T4p340U54AM04bFjYZosDOeR/3xgJErJD9nU1B/iO5mQY1SOK/7/Nj9UFOLveNMWFQIy/hCo13Yd4qrli9bQuMm5CoG5ZKqP7Dne2j7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740674645; c=relaxed/simple;
	bh=fB6w7SixAEXD/myhXo99GjY8ysGqb9qy7aUzN37BOJI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=twUT0B8URbLO6309vFhgio03y4L7XdyvbuPNnaNBYWmowUdG20VY4wUoaVauVXxgNezgHBz10hCHiHm1/0s7pK87ZFsJESZ0t0uD5O2tgWzdixXbqzucq6ObEzq6K3EHC7hT2vFc4Iyt57P03h6r3qyO+/ZABaHAf/r+5sSf57U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sV9MPrcz; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2feb8d29740so388733a91.1
        for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 08:44:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740674643; x=1741279443; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/JYB8oqoHOpfjOcYGs25VQ09uupMqax+pANsHT7Jb3g=;
        b=sV9MPrczf/OH2eRBMcbqd/3Q9N8Gy14BewsPtX4mbiWxM/82Lp95dU2vXVmUSKOgGI
         VFLmoJV2+dqLgWrvERXHh8TWkERvMGQ3WZFs3wavjfCTYuN1QmF6YZHPuvgEimSinUmU
         nIVHzy4r3FhkT/UVePWfgHaHSC+aDltxvscU3On3CAbTQMufkc2S1XSWHO45wy21wUYp
         GYrqQX3ION6kWCh0zFIvR0fLKnDH5PK6GdkmUcNgiA6Cmg1B6V8+YFN3dXJH6ssvv0B3
         dVkQeidtGtSMIDZ024VsYJlTU2eYlqIHZg0+7YWCf+aSsrcjNqG/1zcA3Pyr7n2IOmee
         3INA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740674643; x=1741279443;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/JYB8oqoHOpfjOcYGs25VQ09uupMqax+pANsHT7Jb3g=;
        b=AkNy+bSdXIvZyrN6q3PylX+tedR/+G3Q5v8EPLn8Le1o4oFRj+u69F9qnBOhzholHL
         wKVT5F9GPKcyII8WYEfrSIzG+20PYQnSSiGxxGvCnzFzn+gglOsqlp78AEy+M1vCZjHD
         DXLHEF16Oo9y24ie6WeYbE2L2/chWQheDLmQ5F/ZUYd4+eUFXBgO3wFucgxn/uqVmzAI
         o9/ySR8mxwF1P8h/+FrzJA7mOd97kg4o3qR42qvYAIOIM262D/hq+w8HiKqFubi/q1UQ
         LyJs564GcEcoAwmd62K0okfvVSrY356/3UwP5HWU14Sy149QyWyk7IXEh0s/nQmpgSe8
         +YHQ==
X-Forwarded-Encrypted: i=1; AJvYcCUn0SqrCYUQUha/eemcfCVYBimOrsN+pzyXgpGrNSg4PP1Nxx16ei6A/fciF84VbGDdLLo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yze22AsbG7QUvRrUH8dyf0hWBKDcJ3PcsONSIbR+nf7w8VwGyiy
	/JVUawrYZr3YiFaY4ZAIJC+/mk2gfcDq0IWNW7ULnYPPAq+aehbLYOt4erEQmr/HCNvSXuQfBCT
	EzA==
X-Google-Smtp-Source: AGHT+IGw5yzNreu/xypo2hwjbTNx8tGBWmfy+nhlosdcH+FG5or9oFqBfp6TM2HlecegwTm2+w+cuJ+tpv4=
X-Received: from pjbsd5.prod.google.com ([2002:a17:90b:5145:b0:2fc:3022:36b4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:d008:b0:2ea:3f34:f18f
 with SMTP id 98e67ed59e1d1-2fe7e33d416mr11321462a91.19.1740674643568; Thu, 27
 Feb 2025 08:44:03 -0800 (PST)
Date: Thu, 27 Feb 2025 08:44:02 -0800
In-Reply-To: <946fc0f5-4306-4aa9-9b63-f7ccbaff8003@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241118123948.4796-1-kalyazin@amazon.com> <Z6u-WdbiW3n7iTjp@google.com>
 <a7080c07-0fc5-45ce-92f7-5f432a67bc63@amazon.com> <Z7X2EKzgp_iN190P@google.com>
 <6eddd049-7c7a-406d-b763-78fa1e7d921b@amazon.com> <Z7d5HT7FpE-ZsHQ9@google.com>
 <f820b630-13c1-4164-baa8-f5e8231612d1@amazon.com> <Z75nRwSBxpeMwbsR@google.com>
 <946fc0f5-4306-4aa9-9b63-f7ccbaff8003@amazon.com>
Message-ID: <Z8CWUiAYVvNKqzfK@google.com>
Subject: Re: [RFC PATCH 0/6] KVM: x86: async PF user
From: Sean Christopherson <seanjc@google.com>
To: Nikita Kalyazin <kalyazin@amazon.com>
Cc: pbonzini@redhat.com, corbet@lwn.net, tglx@linutronix.de, mingo@redhat.com, 
	bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, rostedt@goodmis.org, 
	mhiramat@kernel.org, mathieu.desnoyers@efficios.com, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, jthoughton@google.com, david@redhat.com, 
	peterx@redhat.com, oleg@redhat.com, vkuznets@redhat.com, gshan@redhat.com, 
	graf@amazon.de, jgowans@amazon.com, roypat@amazon.co.uk, derekmn@amazon.com, 
	nsaenz@amazon.es, xmarcalx@amazon.com
Content-Type: text/plain; charset="us-ascii"

On Wed, Feb 26, 2025, Nikita Kalyazin wrote:
> On 26/02/2025 00:58, Sean Christopherson wrote:
> > On Fri, Feb 21, 2025, Nikita Kalyazin wrote:
> > > On 20/02/2025 18:49, Sean Christopherson wrote:
> > > > On Thu, Feb 20, 2025, Nikita Kalyazin wrote:
> > > > > On 19/02/2025 15:17, Sean Christopherson wrote:
> > > > > > On Wed, Feb 12, 2025, Nikita Kalyazin wrote:
> > > > > > The conundrum with userspace async #PF is that if userspace is given only a single
> > > > > > bit per gfn to force an exit, then KVM won't be able to differentiate between
> > > > > > "faults" that will be handled synchronously by the vCPU task, and faults that
> > > > > > usersepace will hand off to an I/O task.  If the fault is handled synchronously,
> > > > > > KVM will needlessly inject a not-present #PF and a present IRQ.
> > > > > 
> > > > > Right, but from the guest's point of view, async PF means "it will probably
> > > > > take a while for the host to get the page, so I may consider doing something
> > > > > else in the meantime (ie schedule another process if available)".
> > > > 
> > > > Except in this case, the guest never gets a chance to run, i.e. it can't do
> > > > something else.  From the guest point of view, if KVM doesn't inject what is
> > > > effectively a spurious async #PF, the VM-Exiting instruction simply took a (really)
> > > > long time to execute.
> > > 
> > > Sorry, I didn't get that.  If userspace learns from the
> > > kvm_run::memory_fault::flags that the exit is due to an async PF, it should
> > > call kvm run immediately, inject the not-present PF and allow the guest to
> > > reschedule.  What do you mean by "the guest never gets a chance to run"?
> > 
> > What I'm saying is that, as proposed, the API doesn't precisely tell userspace
                                                                         ^^^^^^^^^
                                                                         KVM
> > an exit happened due to an "async #PF".  KVM has absolutely zero clue as to
> > whether or not userspace is going to do an async #PF, or if userspace wants to
> > intercept the fault for some entirely different purpose.
> 
> Userspace is supposed to know whether the PF is async from the dedicated
> flag added in the memory_fault structure:
> KVM_MEMORY_EXIT_FLAG_ASYNC_PF_USER.  It will be set when KVM managed to
> inject page-not-present.  Are you saying it isn't sufficient?

Gah, sorry, typo.  The API doesn't tell *KVM* that userfault exit is due to an
async #PF.

> > Unless the remote page was already requested, e.g. by a different vCPU, or by a
> > prefetching algorithim.
> > 
> > > Conversely, if the page content is available, it must have already been
> > > prepopulated into guest memory pagecache, the bit in the bitmap is cleared
> > > and no exit to userspace occurs.
> > 
> > But that doesn't happen instantaneously.  Even if the VMM somehow atomically
> > receives the page and marks it present, it's still possible for marking the page
> > present to race with KVM checking the bitmap.
> 
> That looks like a generic problem of the VM-exit fault handling.  Eg when

Heh, it's a generic "problem" for faults in general.  E.g. modern x86 CPUs will
take "spurious" page faults on write accesses if a PTE is writable in memory but
the CPU has a read-only mapping cached in its TLB.

It's all a matter of cost.  E.g. pre-Nehalem Intel CPUs didn't take such spurious
read-only faults as they would re-walk the in-memory page tables, but that ended
up being a net negative because the cost of re-walking for all read-only faults
outweighed the benefits of avoiding spurious faults in the unlikely scenario the
fault had already been fixed.

For a spurious async #PF + IRQ, the cost could be signficant, e.g. due to causing
unwanted context switches in the guest, in addition to the raw overhead of the
faults, interrupts, and exits.

> one vCPU exits, userspace handles the fault and races setting the bitmap
> with another vCPU that is about to fault the same page, which may cause a
> spurious exit.
> 
> On the other hand, is it malignant?  The only downside is additional
> overhead of the async PF protocol, but if the race occurs infrequently, it
> shouldn't be a problem.

When it comes to uAPI, I want to try and avoid statements along the lines of
"IF 'x' holds true, then 'y' SHOULDN'T be a problem".  If this didn't impact uAPI,
I wouldn't care as much, i.e. I'd be much more willing iterate as needed.

I'm not saying we should go straight for a complex implementation.  Quite the
opposite.  But I do want us to consider the possible ramifications of using a
single bit for all userfaults, so that we can at least try to design something
that is extensible and won't be a pain to maintain.

