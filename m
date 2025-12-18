Return-Path: <kvm+bounces-66200-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id EA1D9CCA003
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 02:44:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 83EE8301CEB1
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 01:44:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E18026B75B;
	Thu, 18 Dec 2025 01:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xwJSVb5w"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD95B267AF6
	for <kvm@vger.kernel.org>; Thu, 18 Dec 2025 01:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766022287; cv=none; b=GlVgpliR4eQFRSuF5j/GtLCI0TiB25ASOC0J9H2Zj1nuovQV0Zj1+3E23SrEsG/98EyP3XEGBecENHhYQuWv++2zDAgZLkOSc3c/1VTdLnlmQlAjR+Q0r/EwUucqhZpGy5uUklQAe0B6/TDp00mkV0DGwLJ9r2zp9sxp21rXta0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766022287; c=relaxed/simple;
	bh=LaBM3Pn65otIp/csDeYzkbqgC1Ny8b0EFTpIoFsrFVs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=naM9CeuG9zyKRHBmJpolCG+0OHeE2ljBkbQi3usOnJ7AdhEuEjKIWIdJUD7SgW9Wyh/izdAwWq5vevBA4cn1HxkCUmtG8yiJ/APwPiDiFJxuw+z8DIxf1CE7qdoY/ly+3IkeJ7QpOXJkLks4WqWAK+0JiVD7wuR3W6rbX9rm+Uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xwJSVb5w; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34c48a76e75so278158a91.1
        for <kvm@vger.kernel.org>; Wed, 17 Dec 2025 17:44:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766022285; x=1766627085; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=q6ebwR/Vue4SkDVzpOcpgl8A11+SbAzBAvHEuPdOdMY=;
        b=xwJSVb5wFPKshjQKV0x8JBxiKNB30m1VsMQ2zF51QyiO+YSowrD0MIXGxj85LTAp/a
         l0BcaCTGUjxQ/zRV9il1QQFj0FQbnjFFW05UZHYJ/IlNhRohoghuAgSA4Y98nB5K5s3r
         v79khSPPD3upmrG/eiRfDz27Ok7HxSIMD19iAhgh0S4cPannU12pwbZJQLlkWPLlL6Hj
         wCq6ubChi2JXf/ddayt8exif3/PY89dQWzAYCzg2jaMdWfrt3n82dw8EUhBeFjJI4T39
         fNHBWmABoez8virolUcbuV674wFhAskYRm7uv8qYzWF+xhME/x0yQ3SC8lb90+DZa5Yd
         8ItQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766022285; x=1766627085;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=q6ebwR/Vue4SkDVzpOcpgl8A11+SbAzBAvHEuPdOdMY=;
        b=MghxYZF7CX9TXyqDfD0xQmY05cU8M5k8Be+vbaQGekB2Q1zDnOaBHfiYqz2/d94jUI
         GZI/Y8uj1zijnUtrfV8CN0k2HnufDjsI1dD42wLrcDXovml0h4N0qE72MPd2tppRFJNv
         8lI2znl9GYWSZhnIBn2hy61KQtb/iZhLAeex7n9Ng56fY3binxGswHy4hOQLOC1qzm84
         Beny4gE/+LieEtdn8i+6cgIQ7Ofhp3mOjMkaIqXnsTPub9oDhdmn1vLcdJRiZvsjkL81
         7MfFAFdcDHZltLsGA38uMRr/Z1RYj2P3/9o1vJQj0dvidifh/h0Ce05z0l6t9eNkTr4O
         h84w==
X-Gm-Message-State: AOJu0Yw3sK71LS+qNacU+m0wzc6G6JZsJ8NkImXMgElf+PNY41vDryR2
	KmIoUSkkXWPsnJ3KqaeaJzChBC5L6suKxq14lR/7O1gmNKj3p4xmhdbwzMXR5Rux/W8tsunwAbM
	IGIxX7A==
X-Google-Smtp-Source: AGHT+IEOIYr+WARtcaV756FZH6EZp/J2PAYEJSqogTwiyMdCgxXOovE9wE+cOpuJ042H6bq3Z8rxYsgTo8g=
X-Received: from pjbcz3.prod.google.com ([2002:a17:90a:d443:b0:34c:c8a4:313f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2542:b0:343:eb40:8dca
 with SMTP id 98e67ed59e1d1-34abd75ba02mr18039870a91.19.1766022284893; Wed, 17
 Dec 2025 17:44:44 -0800 (PST)
Date: Wed, 17 Dec 2025 17:44:43 -0800
In-Reply-To: <3bac29b9-4c49-4e5d-997e-9e4019a2fceb@grsecurity.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250915215432.362444-1-minipli@grsecurity.net>
 <176314469132.1828515.1099412303366772472.b4-ty@google.com>
 <15788499-87c6-4e57-b3ae-86d3cc61a278@grsecurity.net> <aRufV8mPlW3uKMo4@google.com>
 <083276ef-ff1b-4ac3-af19-3f73b1581d39@grsecurity.net> <0274322e-e28c-4511-a565-6bb85bfade8b@grsecurity.net>
 <3bac29b9-4c49-4e5d-997e-9e4019a2fceb@grsecurity.net>
Message-ID: <aUNci6Oy1EXXoQuY@google.com>
Subject: Re: [kvm-unit-tests PATCH v2 0/4] Better backtraces for leaf functions
From: Sean Christopherson <seanjc@google.com>
To: Mathias Krause <minipli@grsecurity.net>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Andrew Jones <andrew.jones@linux.dev>, 
	Eric Auger <eric.auger@redhat.com>, Thomas Huth <thuth@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Nov 21, 2025, Mathias Krause wrote:
> On 18.11.25 02:47, Mathias Krause wrote:
> > On 18.11.25 02:33, Mathias Krause wrote:
> > [...]
> > Bleh, I just noticed, f01ea38a385a ("x86: Better backtraces for leaf
> > functions") broke vmx_sipi_signal_test too :(
> > 
> > Looking into it!
> 
> Finally found it. It's register corruption within both host and guest.
> 
> It's not related to f01ea38a385a at all but, apparently, it actually
> exposes it, likely because of the enforced stack frame setup, making the
> code rely on (a corrupted) RBP instead of the properly restored (because
> VMCS managed) RSP.
> 
> The core issue is, 'regs' being a singleton, used by multiple CPUs, so
> all SMP VMX tests concurrently making use of vmx_enter_guest() are
> potentially affected.

*sigh*

I'm not going to type out the first dozen words that escaped my mouth when
reading this.  I happen to like my job :-)

> When the first vCPU calls vmx_enter_guest() to launch a guest, it'll use
> 'regs' to load the guest registers but also store its host register
> state. Now, if while that vCPU is running, another vCPU gets launched
> via vmx_enter_guest(), it'll load the previous vCPU's host register
> values as guest register state and store its host registers in 'regs'.
> 
> Depending on which vCPU returns first, it'll either load the other
> vCPU's host registers effectively "switching threads" or, if it's the
> vCPU that called vmx_enter_guest() last, it'll resume just fine. Either
> way, the next vCPU returning will run with the guest register values.
> 
> The latter is what happens with vmx_sipi_signal_test, causing the crash.
> 
> I read a lot of vmx.c and vmx_test.c in the last few days and it's
> really not meant to be used concurrently by multiple guests. vmx_test.c
> has quite some hacks to work around obvious limitations (allocating
> dedicated stacks for APs) but state variables like 'launched',
> 'in_guest', 'guest_finished', 'hypercall_field' and 'regs' are shared
> but really meant to be used only by a single thread.

You're much more generous than me in your description.  

> I hacked up something to verify my theory and made 'regs' "per-cpu". It
> needs quite some code churn and I'm not all that happy with it. IMHO,
> 'regs' and lots of the other VMX management state should be part of some
> vcpu struct or something. In fact, struct vmx_test already has a
> 'guest_regs' but using it won't work, as we need offsetable absolute
> memory references for the inline ASM in vmx_enter_guest() to work as it
> cannot make use of register-based memory references at all. (My hack
> uses a global 'scratch_regs' with mutual exclusion on its usage.)

So, much to my chagrin, I started coding away before reading your entire mail
(I got through the paragraph about 'regs' getting clobbered, and then came back
to the rest later; that was a mistake).

I had the exact same idea about making regs per-CPU, but without the quotes.
Of course, because I didn't read your entire mail, converting only regs to be
per-CPU didn't help.  It actually made things worse (TIL the INIT test shares
a VMCS between CPUs... WTF).

After making launch and in_guest per-CPU, and using RAX to communicate hypercalls,
I've got everything passing (module one unsolvable SIPI wart; see below).  I need
to write changelogs and squash a few fixups, but overall it ended up being a nice
cleanuped (de-duplicating the VMX vs. SVM GPR handling drops a lot of code).  I'm
tempted to delete a blank lines just to get to net negative LoC :-D

 lib/x86/smp.h       |  32 ++++++++++++++++++++++++++++++++
 lib/x86/virt.h      |  61 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 x86/Makefile.common |  14 ++++++++++++++
 x86/realmode.c      |   3 +++
 x86/svm.c           |  19 ++++++++-----------
 x86/svm.h           |  61 +++++++++----------------------------------------------------
 x86/svm_tests.c     |   5 +++--
 x86/vmx.c           | 122 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++----------------------------------------------------------------
 x86/vmx.h           |  72 +++---------------------------------------------------------------------
 x86/vmx_tests.c     | 104 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++------------------------------------------------
 10 files changed, 247 insertions(+), 246 deletions(-)

> To see the register corruption, one could start the vmx_sipi_signal_test
> test with -s -S, attach gdb to it and add a watch for regs.rax. Stepping
> through the test will clearly show how 'regs' get overwritten wrongly.

The test itself is also flawed.  On top of this race that you spotted:

 @@ -9985,11 +9985,11 @@ static void vmx_sipi_signal_test(void)                
       /* update CR3 on AP */                                                  
       on_cpu(1, update_cr3, (void *)read_cr3());                              
                                                                               
 +     vmx_set_test_stage(0);                                                  
 +                                                                             
       /* start AP */                                                          
       on_cpu_async(1, sipi_test_ap_thread, NULL);                             
                                                                               
 -     vmx_set_test_stage(0);                                                  
 -                                                                             
       /* BSP enter guest */                                                   
       enter_guest();                                                          
  }                                

This snippet is also broken:

	vmx_set_test_stage(1);

	/* AP enter guest */
	enter_guest();

because the BSP can think the AP has entered WFS before it has even attempted
VMLAUNCH.  It's "fine" so long as there are host CPUs available, but the test
fails 100% for me if I run KUT in a VM with e.g. j<number of CPUs>, and on an
Ivybridge server CPU, it fails pretty consistently.  No idea why, maybe a slower
nested VM-Enter path?  E.g. the test passes on EMR even if I run with j<2x CPUs>.

Unfortunately, I can't think of any way to fix that problem.  To recognize the
SIPI, the AP needs to do VM-Enter with a WFS activity state, and I'm struggling
to think of a way to atomically write software-visible state at the time of VM-Enter.
E.g. in theory, the test could peek at the LAUNCHED field in the VMCS, but that
would require reverse engineering the VMCS layout for every CPU.  If KVM emulated
any VM-wide MSRs, maybe we could throw one in the MSR load list?  But all the ones
I can think of, e.g. Hyper-V's partition-wide MSRs, aren't guaranteed to be available.

Anywho, now that I know what to look for, I can ignore false failures easily enough.
If someone cares enough to come up with a clever fix, then yay.  Otherwise, I'll
just deal with the intermittent failures (or maybe nuke and pave).

As for this patch, I'll write changelogs and get a series posted with the backtrace
and realmode patch at the end.

