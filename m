Return-Path: <kvm+bounces-57647-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 52BB2B588F3
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 02:14:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 07D03206F47
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 00:14:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9492422615;
	Tue, 16 Sep 2025 00:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SA9Tc5Yo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 231B01096F
	for <kvm@vger.kernel.org>; Tue, 16 Sep 2025 00:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757981634; cv=none; b=YVujTjEq6ESOm9ZZ/EOEmnWTzvssesUgkcjdcPw7JWbWDNQk6eXGicdNs7RNlVBYkoRo77aJOp3NhYBNAEOCm/7tT/GjLB1ufh6gXqmw8odE+M5VrhVIlO5SVV/0JdED5rGMrEmB2kuXvih04C+o3hnx8apJPlxiRdLnbeSIFcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757981634; c=relaxed/simple;
	bh=Y6aeNJnaolX37VehaP4qnzCMnjNw1Q2SpvYlZIDNE0U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=eK5ZkvxPV13cP1WsqWfqc7VSiB4MqSIFpbjFweaVKH4vRORULVr086yR4cE8+AUhWuH0QUpIk3k7XPhG4GUy1P2dJU6EV1hjeYhHtAKEeryJ04IXy4uax73oiVL3VZxcB7QrXVcWVVUsGgpvgVjAuhPU5RMb0rY/PawhZC0qjn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SA9Tc5Yo; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32e3c3e748dso1379240a91.2
        for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 17:13:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757981632; x=1758586432; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pLma1EMBXmcUy+LxV91Tk5MyygROV10MsjDTBjfMODU=;
        b=SA9Tc5YofhyzfudpbeR2GYCKGjFq7EG+u3Y7kDhZ+LDteUQ/KWNIGXf/HPu72YgVrq
         Mf93/Li61QGKmaF60ktazrEg13Ppbz+t0k3RKrfCyCWXpfCbE4V7X56omieZj5zUqdyE
         hj/Fcx7lo0H4AqsAeBWPJDwp3FcfYu9v+iTy+BNjQPplXi2OzmjpDbdC+8P6ZFXKCirt
         o1OAcT2N/BCs8wMORGe79ZDg7Ro+SRRSzHtY6b7hRVr1iNChzN/7P5YWDIighFa9E6hF
         wSw+TE1F246Aquaw4JHyy0OxTJ4l7i6GXguxwDZJgLqShfPsritcJqw6hIoB7q4nkb6G
         iScA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757981632; x=1758586432;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pLma1EMBXmcUy+LxV91Tk5MyygROV10MsjDTBjfMODU=;
        b=ov9aIVHX8M1SBJH6cqPnqWxTOpCakv3FWGqLa69t+2XtuBZuXPn4uveIHbnTXB1EJp
         NnuiTw6kLmBRH5AYfZfQv5S90mnKZApsL2kOw8KhD0qy+wjRwnzTkm5hPEsDyBVlB9m5
         fd3b5b9ovV9/yG4qR97P0pHMO7IhgQ8SmWt/EF25roJ4Mkgj08mrgVQeRiF+d9TR8mkO
         C/xnCzcO9G2gy1PqKHiYXftfGPnA/yvrqpJglO/+OaRK5Wwa2O8geW7tPV/jJUX5kBT5
         ICpOM2/OVW5ByjnaFYzP8IhvEyI2P8f7iqo3PXhBi5D/eCEE4PD5ma06D0U+KHWztWrC
         IPZg==
X-Forwarded-Encrypted: i=1; AJvYcCWlPMx09s0sAMZt8ybJuYn4x0OovpaXveYooffTgC2SaTvVC6wMmafiWcdUPgoWkntUQV4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwO4X+fg21ckYrIxhCYvRO/PMcswp4XmBB114ZQJBICyR0Fu4fx
	/TwMtXTZNPNyG38R5xoZRI0EUy/cwSp08HcMhAffg206M3iUHV9d4dGs+fDgyy5NIDQcPZlHa9U
	UvtuuFQ==
X-Google-Smtp-Source: AGHT+IGcpCEO/Kg51rUjXJwIHwSkP5vIXEkIPrqHW50Z2n50pv7XGe60HIlTZ9j0n4/dregdhjVWZBpMxWg=
X-Received: from pjvv5.prod.google.com ([2002:a17:90b:5885:b0:32b:58d1:a610])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:38d2:b0:32b:baaa:21b0
 with SMTP id 98e67ed59e1d1-32de4eabfbamr16559780a91.6.1757981632455; Mon, 15
 Sep 2025 17:13:52 -0700 (PDT)
Date: Mon, 15 Sep 2025 17:13:50 -0700
In-Reply-To: <20250913050643.GA50691@k08j02272.eu95sqa>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <c10fb477105231e62da28f12c94c5452fa1eff74.1757662000.git.houwenlong.hwl@antgroup.com>
 <aMPbNBofTCFGTCs6@intel.com> <20250912093822.GA10794@k08j02272.eu95sqa>
 <20250912141132.GA85606@k08j02272.eu95sqa> <aMQw67a7Ku7wXTXO@google.com> <20250913050643.GA50691@k08j02272.eu95sqa>
Message-ID: <aMirvo9Xly5fVmbY@google.com>
Subject: Re: [PATCH] KVM: x86: Remove outdated comments and code in kvm_on_user_return()
From: Sean Christopherson <seanjc@google.com>
To: Hou Wenlong <houwenlong.hwl@antgroup.com>
Cc: Chao Gao <chao.gao@intel.com>, kvm@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Sat, Sep 13, 2025, Hou Wenlong wrote:
> On Fri, Sep 12, 2025 at 07:40:43AM -0700, Sean Christopherson wrote:
> > On Fri, Sep 12, 2025, Hou Wenlong wrote:
> > > On Fri, Sep 12, 2025 at 05:38:22PM +0800, Hou Wenlong wrote:
> > > > On Fri, Sep 12, 2025 at 04:35:00PM +0800, Chao Gao wrote:
> > > > > On Fri, Sep 12, 2025 at 03:35:29PM +0800, Hou Wenlong wrote:
> > > > > >The commit a377ac1cd9d7b ("x86/entry: Move user return notifier out of
> > > > > >loop") moved fire_user_return_notifiers() into the section with
> > > > > >interrupts disabled, so the callback kvm_on_user_return() cannot be
> > > > > >interrupted by kvm_arch_disable_virtualization_cpu() now. Therefore,
> > > > > >remove the outdated comments and local_irq_save()/local_irq_restore()
> > > > > >code in kvm_on_user_return().
> > > > > >
> > > > > >Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
> > > > > >---
> > > > > > arch/x86/kvm/x86.c | 16 +++++-----------
> > > > > > 1 file changed, 5 insertions(+), 11 deletions(-)
> > > > > >
> > > > > >diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > > > >index 33fba801b205..10afbacb1851 100644
> > > > > >--- a/arch/x86/kvm/x86.c
> > > > > >+++ b/arch/x86/kvm/x86.c
> > > > > >@@ -568,18 +568,12 @@ static void kvm_on_user_return(struct user_return_notifier *urn)
> > > > > > 	struct kvm_user_return_msrs *msrs
> > > > > > 		= container_of(urn, struct kvm_user_return_msrs, urn);
> > > > > > 	struct kvm_user_return_msr_values *values;
> > > > > >-	unsigned long flags;
> > > > > >
> > > > > >-	/*
> > > > > >-	 * Disabling irqs at this point since the following code could be
> > > > > >-	 * interrupted and executed through kvm_arch_disable_virtualization_cpu()
> > > > > >-	 */
> > > > > >-	local_irq_save(flags);
> > > > > >-	if (msrs->registered) {
> > > > > >-		msrs->registered = false;
> > > > > >-		user_return_notifier_unregister(urn);
> > > > > >-	}
> > > > > >-	local_irq_restore(flags);
> > > > > >+	lockdep_assert_irqs_disabled();
> > > > > 
> > > > > kvm_offline_cpu() may call into this function. But I am not sure if interrupts
> > > > > are disabled in that path.
> > > > >
> > > > Thanks for pointing that out. I see that interrupts are enabled in the
> > > > callback during the CPU offline test. I'll remove the
> > > > lockdep_assert_irqs_disabled() here.
> > > >
> > > 
> > > Upon a second look, can we just disable interrupts in kvm_cpu_offline()?
> > > The other paths that call kvm_disable_virtualization_cpu() are all in an
> > > interrupt-disabled state, although it seems that
> > > kvm_disable_virtualization_cpu() cannot be reentered.
> > 
> > Why do we care?  I.e. what is the motivation for changing this code?  I'm hesitant
> > to touch this code without good reason given its fragility and subtlety.
> Hi, Sean.
> 
> I'm just reworking the shared MSRs part in our inner multi-KVM. First, I
> noticed that the comment mentions that kvm_on_user_return() can be
> interrupted or reentered, which is a little confusing to me. Then, I
> found that the comment is outdated, so I decided to remove it and also
> make changes to the code. I agree that this code is fragile, maybe
> just change the comment?

I'm not opposed to making changes, I just don't want to do so without reason.
"This is ridiculously confusing" is a good enough reason :-)  Hmm, and disabling
IRQs in that path might technically be a bug fix.

I think the main reason this got especially confusing is that commit a377ac1cd9d7
("x86/entry: Move user return notifier out of loop") somewhat inadvertantly fixed
the underlying issue that was papered over by 1650b4ebc99d ("KVM: Disable irq while
unregistering user notifier").

And then commit 9a798b1337af ("KVM: Register cpuhp and syscore callbacks when
enabling hardware") removed KVM's "normal" path use of IPIs to enable/disable
virtualization.

As a result, KVM is left with a rather uncommon corner case of reboot being the
only way for kvm_on_user_return() to be interrupted.  For the life of me, I can't
tell whether or not CPU (un)hotplug paths run with IRQs disabled.  I know at
least some run in task context, but I've no idea if that applies to CPUHP_AP_KVM_ONLINE.

So, looking at this (yet) again, I'm in favor of doing as you suggest and saving
IRQs in both kvm_online_cpu() and kvm_offline_cpu().  If IRQs aren't guarnateed
to be disabled, I _think_ that's technically a bug fix, because virtualization_enabled
could be stale (with respect to the actual state of hardware) when read from IRQ
context.

Something like this?

---
 arch/x86/kvm/x86.c  | 12 +++++++-----
 virt/kvm/kvm_main.c | 10 ++++++++--
 2 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c78acab2ff3f..067cb66e9c18 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -582,18 +582,20 @@ static void kvm_on_user_return(struct user_return_notifier *urn)
 	struct kvm_user_return_msrs *msrs
 		= container_of(urn, struct kvm_user_return_msrs, urn);
 	struct kvm_user_return_msr_values *values;
-	unsigned long flags;
 
 	/*
-	 * Disabling irqs at this point since the following code could be
-	 * interrupted and executed through kvm_arch_disable_virtualization_cpu()
+	 * Assert that IRQs are disabled.  KVM disables virtualization via IPI
+	 * callback on reboot, and this code isn't safe for re-entrancy, e.g.
+	 * receiving the IRQ after checking "registered" would lead to double
+	 * deletion of KVM's notifier.
 	 */
-	local_irq_save(flags);
+	lockdep_assert_irqs_disabled();
+
 	if (msrs->registered) {
 		msrs->registered = false;
 		user_return_notifier_unregister(urn);
 	}
-	local_irq_restore(flags);
+
 	for (slot = 0; slot < kvm_nr_uret_msrs; ++slot) {
 		values = &msrs->values[slot];
 		if (values->host != values->curr) {
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index fee108988028..1b7d59adc390 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5581,6 +5581,8 @@ __weak void kvm_arch_disable_virtualization(void)
 
 static int kvm_enable_virtualization_cpu(void)
 {
+	lockdep_assert_irqs_disabled();
+
 	if (__this_cpu_read(virtualization_enabled))
 		return 0;
 
@@ -5596,6 +5598,8 @@ static int kvm_enable_virtualization_cpu(void)
 
 static int kvm_online_cpu(unsigned int cpu)
 {
+	guard(irqsave)();
+
 	/*
 	 * Abort the CPU online process if hardware virtualization cannot
 	 * be enabled. Otherwise running VMs would encounter unrecoverable
@@ -5606,6 +5610,8 @@ static int kvm_online_cpu(unsigned int cpu)
 
 static void kvm_disable_virtualization_cpu(void *ign)
 {
+	lockdep_assert_irqs_disabled();
+
 	if (!__this_cpu_read(virtualization_enabled))
 		return;
 
@@ -5616,6 +5622,8 @@ static void kvm_disable_virtualization_cpu(void *ign)
 
 static int kvm_offline_cpu(unsigned int cpu)
 {
+	guard(irqsave)();
+
 	kvm_disable_virtualization_cpu(NULL);
 	return 0;
 }
@@ -5649,7 +5657,6 @@ static int kvm_suspend(void)
 	 * dropped all locks (userspace tasks are frozen via a fake signal).
 	 */
 	lockdep_assert_not_held(&kvm_usage_lock);
-	lockdep_assert_irqs_disabled();
 
 	kvm_disable_virtualization_cpu(NULL);
 	return 0;
@@ -5658,7 +5665,6 @@ static int kvm_suspend(void)
 static void kvm_resume(void)
 {
 	lockdep_assert_not_held(&kvm_usage_lock);
-	lockdep_assert_irqs_disabled();
 
 	WARN_ON_ONCE(kvm_enable_virtualization_cpu());
 }

base-commit: 14298d819d5a6b7180a4089e7d2121ca3551dc6c
--

