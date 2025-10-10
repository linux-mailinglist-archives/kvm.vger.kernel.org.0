Return-Path: <kvm+bounces-59785-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id C526DBCE9BA
	for <lists+kvm@lfdr.de>; Fri, 10 Oct 2025 23:22:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 938214F4635
	for <lists+kvm@lfdr.de>; Fri, 10 Oct 2025 21:22:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C27F302140;
	Fri, 10 Oct 2025 21:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jjrWbxPk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3755125A2A5
	for <kvm@vger.kernel.org>; Fri, 10 Oct 2025 21:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760131350; cv=none; b=WEBgqzi2u08eynG/vRLeucQkK6p4Wr4mQqTevp8u1l0MbRE+KKi5Ly3Z4/dRCX67EGeq/QpfzO7k5NKKVa6d9IybPq5/WBwYT6lUOA30wa7GRQOakdcfc3ljT23fXiUa54n+o5G+Xhvl0TTDj3YPgxcDkVfDXw7clbz2k0wNV00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760131350; c=relaxed/simple;
	bh=HcEXFEAy/qzmTWrOXWoo5CzokXjpX8OzQ4vdVA2kNrc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=S457VzS/dVRyZ6BzaUbPiV3QloWIX+fD0xAyw6nTqlQgNrfvUtLtY907ZL1Zygm3Suu/zu/8JFJNdLbGAvsCoFn6w9pnwHDOrGwflZaWP/oYrL0zXCYbZREd16xEbsubJFAJNcLsuUcUcur6CS0YrV5Ls3VHaYGdKrATIsUogn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jjrWbxPk; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b57c2371182so5910827a12.1
        for <kvm@vger.kernel.org>; Fri, 10 Oct 2025 14:22:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760131348; x=1760736148; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rdFXM/hgo1mPdHvbx4RdYRc/pDTPEkDaK62wXh4JGEE=;
        b=jjrWbxPk+Hptc7dOmXQm3xTpf6jI50o15VP38oK9O2pU5b8ERZ4wF5UhDhc6vIzrCo
         7STNU2MK0GDTC4ygA7RJwR/oJP6u8D94il5t4Cu4yed3kt0PwjlBVU+croPJHBVWM2wu
         LJW8qxEwkGM9DbPRu8fiIV5VLgfo83pI324AMEE0KTcdGppACHPJB4iysak62ylN5tbB
         MKOiZDEqCYP1H+z+EB3s4/zu3dqfE8EAWNOB/us+MsIwVgswPlbwvJMq8ndVAuX7H6Hv
         pQNspw0klnUWINzizkKoJwMPxDMSn7cQ60TCWDEt/h6m+JrZiX2p6j9C57b4F4XohXBr
         zZXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760131348; x=1760736148;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rdFXM/hgo1mPdHvbx4RdYRc/pDTPEkDaK62wXh4JGEE=;
        b=bTSx0cSElxh9NX2MUDtqHzjDAFS+HN+TLS87TL/kfnOO3HrWofzwTZwlwRzWOfz6c6
         mDA43XuTSd65zcTsYFtfY60xGhs6WuGOsSQmMkxiINdohT96WOvEDxaxvzn5qp2taWI8
         J/Ius9l+3yDP0VpX7dl7yL6XtQj34P3n2bbc9fZlZfA9KHqPYmsPeqacXPPthmuiHOWq
         ujrp0l8UqBQAuFF8webIKdOfbMQAZuUMlJCp1A61L9lzyOQw2eV+MHMWfYsYhLjXuhF0
         cCDMbsUtRgv52zLhICtB1s/lfX02RdAq3lEeSw5nJnYMDGNKpMQqMjVoQHehJytXGdZJ
         jOHg==
X-Forwarded-Encrypted: i=1; AJvYcCXE2H2gc7Qz4op6oC+Yta9eCrp0IanBdeTCP9juB4zGN88KLmOX+TF3Nqke10NZm+fNoJ0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxaR0zCei0AuhlZhQbFF5ceXadJ6Z3vygTEd35YF/ygPmLJ1iOn
	rBDxGxlj11lIHn4goiFHVYCie4GasaxZZzoHueuzB2LlKH7f3mXOpe5djvu9FdFI3Xy+v5lHC2e
	YZdTTow==
X-Google-Smtp-Source: AGHT+IHuNb8zVGze8C/o0DPHnEZLtusaEFA9ZVq7HkIghIBk1maNB3NWQZhl8i/TI+1a1rgry6LylbBsxcE=
X-Received: from pjbfh3.prod.google.com ([2002:a17:90b:343:b0:330:b9e9:7acc])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:52cc:b0:30a:4874:5397
 with SMTP id 98e67ed59e1d1-33b511185e2mr18434763a91.9.1760131348473; Fri, 10
 Oct 2025 14:22:28 -0700 (PDT)
Date: Fri, 10 Oct 2025 14:22:26 -0700
In-Reply-To: <68e85e503ae05_29801003f@dwillia2-mobl4.notmuch>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250324140849.2099723-1-chao.gao@intel.com> <Z_g-UQoZ8fQhVD_2@google.com>
 <aObtM-7S0UfIRreU@google.com> <68e85e503ae05_29801003f@dwillia2-mobl4.notmuch>
Message-ID: <aOl5EutrdL_OlVOO@google.com>
Subject: Re: VMXON for TDX (was: Re: [PATCH] KVM: VMX: Flush shadow VMCS on
 emergency reboot)
From: Sean Christopherson <seanjc@google.com>
To: dan.j.williams@intel.com
Cc: Chao Gao <chao.gao@intel.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Oct 09, 2025, dan.j.williams@intel.com wrote:
> Hey, while we on the topic of being off topic about that branch, I
> mentioned to Chao that I was looking to post patches for a simple VMX
> module. He pointed me here to say "I think Sean is already working on
> it". This posting would be to save you the trouble of untangling that
> branch, at least in the near term.
> 
> Here's the work-in-progress shortlog:
> 
> Chao Gao (2):
>       x86/virt/tdx: Move TDX per-CPU initialization into tdx_enable()
>       coco/tdx-host: Introduce a "tdx_host" device
> 
> Dan Williams (5):
>       x86/virt/tdx: Drop KVM_INTEL dependency
>       x86/reboot: Convert cpu_emergency_disable_virtualization() to notifier chain

I don't actually think we want a notifier chain, because the order matters.  I
think what we want instead if a daisy-chain of notifiers (I swear I'm not trying
to troll y'all).  If we go with a standard notifier chain, there will be a hidden
dependency on KVM's notifier running first (to do VMCLEAR) and what you appear to
be calling vmx.ko's notifier running second.

>       x86/reboot: Introduce CONFIG_VIRT_X86
>       KVM: VMX: Rename vmx_init() to kvm_vmx_init()
>       KVM: VMX: Move VMX from kvm_intel.ko to vmx.ko

Spoiler for the wall of text below, but I don't think it makes sense to have a
vmx.ko, or an intermediate module of any kind.

> I can put the finishing touches on it and send it out against
> kvm-x86/next after -rc1 is out, or hold off if your extraction is going
> ok.

It went ok, but it's dead in the water.

> At least my approach to the VMX module leaves VMCS clearing with KVM.

Yes, I came to this conclusion as well.

TL;DR: I don't think we should pursue my idea (read: pipe dream) of extracting
       all core virtualization functionality to allow multiple hypervisors.  It's
       not _that_ hard (my "not 6 months of work" statement still holds true),
       but it raises a number of policy-related questions and would add non-trivial
       complexity, for no immediate benefit (and potential no benefit even in the
       long run).

For all intents and purposes, moving the VMCS tracking to a central module commits
to fully supporting multiple in-kernel hypervisors.   After extracting/rebasing
almost all of the internal code, I realized that fully supporting another hypervisor
without actually having another hypervisor in-hand (and that we want to support
upstream), is an absurd amount of churn and complexity for no practical benefit.

For the internal implementation, we had punted on a few key annoyances because they
were way out-of-scope for our use case.  Sadly, it's not even the hardware side of
things that adds the most complexity, it's all the paravirt crud.  Specifically,
KVM's support for various Hyper-V features, e.g. Hyper-V's Enlightened VMCS (eVMCS),
used when KVM is running as a VM on a Hyper-V, or on KVM emulating Hyper-V.

Whether or not to use eVMCS is in some ways a system wide policy decision (currently
it's a KVM module param), because the control state is per CPU.  Our internal approach
was to limit support for multple KVM modules to bare metal kernel configurations,
but that doesn't really fly when trying to make a truly generic hypervisor framework.
I'm pretty sure we could solve that by having KVM purge the eVMCS pointer when a
vCPU is scheduled out (to avoid another hypervisor unintentionally use KVM's eVMCS),
but that's a whole new pile of complexity, especially if we tried to have proactive
clearing limited to eVMCS (currently, KVM lazily does VMCLEAR via an IPI shootdown
if a VMCS needs to be migrated to a different pCPU; it's easy enough to have KVM
eagerly do VMCLEAR (on sched out), but it's not obvious that it'd be a performance
win).

There are a few other things of a similar nature, where it's not _too_ hard to
massage some piece of functionality into common infrastructure, but as I was
mentally working through them, I kept thinking "this isn't going to end well".

When we were specifically targeting multiple KVM instances, it wasn't anywhere
near as scary.  Because while each KVM instance could obviously run different
code, the general architecture and wants of each active hypervisor would be the
same.

E.g. whether or not to enable SNP's new ciphertext hiding features, and how many
ASIDs to reserve for SNP+ VMs, is another system wide policy decision that is a
non-issue when the goal is purely to be able to run different versions of the same
hypervisor.  But it's less clear cut how that should be handled when the "other"
hypervisor is an unknown, faceless entity.

Ditto for the "obvious" things like the user-return MSR framework.  That "needs"
to be system wide because the current value in hardware is per-CPU, but in quotes
because it presupposes that another hypervisor would even want to play the same
games.

So, while it's definitely doable to separate the core virtualization bits from
KVM, I think the added complexity (in code and in the mental model) would make
it all _extremely_ premature infrastructure.

> Main goal is not regress any sequencing around VMX.

Ya, that requires some care.

A big takeaway/revelation for me from after going through the above exercise of
trying and failing (well, giving up) to extract _all_ system-wide virtualization
functionality is that not only is trying to generically support other hypervisors
undesirable, if we commit to NOT doing that, then we really can special case the
low level VMXON + EFER.SVME logic.

What I mean by that is we don't need a fully generic, standalone module to provide
VMXON+VMXOFF, we only need common tracking.  KVM is the only module user, and TDX
is a super special snowflake that already needs to provide a pile of its own
functionality.  KVM (obviously) already has the necessary hooks to handle things
like CPU bringup/teardown and reboot, and adding them to the TDX subystem code is
easy enough.

And more importantly, except for VMXON+VMXOFF, the _only_ requirements TDX brings
to the table are one-shot, unidirectional things (e.g. TDH_SYS_LP_INIT).  I.e.
there's no need for multi-user notifier chains, because the core code can blast
VMXOFF in an emergency, and clean reboots can be easily handled through syscore.

I've got patches that appear to work (writing the code didn't take long at all
once I pieced together the idea).  I'll post an RFC and we can go from there.

