Return-Path: <kvm+bounces-72062-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AO2kJxiLoGnekgQAu9opvQ
	(envelope-from <kvm+bounces-72062-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 19:04:08 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 182A41AD34F
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 19:04:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id ACB8231EB142
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 17:48:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA869332909;
	Thu, 26 Feb 2026 17:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dhY4QFkx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B79B33262E
	for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 17:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772128085; cv=none; b=hgD2Qt0zTa1oCXwawjM90aRJ2cMQmn8QCrnMfEubFtL2JBJodWqpIQ+EfoJ3jQh304qxUK6IMeqztFyFQJdG/7BfOA6tt2dHyqM2PiWXyKF5F/YZawf/QYAlSa1Th9PdOrsHKP9deQvBpL0SJOe3+YzTBVYI8tsO7J4BjMIHcjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772128085; c=relaxed/simple;
	bh=pLwlIYRVarPprriFd1+p91arq0phHaBROhJiNGtDzG4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HfzyuWCmIEhnZuGcHtBeKKR/Cop5YVbWIvGpS7LYlf0/3zv4AHqSh5DACYOMcRZdYak4ESo5fUnV1L7gcFp84zRP72CfICV0jNTW2M8e4jpILBk2VW76idEW9O2jqq4u8ATG6rpiW11sicqobmN1ElpKosowqbN2WZyY7oR/Vl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dhY4QFkx; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-359462377a1so493316a91.2
        for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 09:48:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772128082; x=1772732882; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YToQm8Rgx9xCen2GsgbKUz+NArcF+XV9oeQ/EMGpxps=;
        b=dhY4QFkxzBwUinmUEU14gbGtZPV4pI4m4l4e1gqpvKhBloohu5f/bHTtIrbtOKZp6H
         bmuW7rFOUnHc1ZU5vrJhTT2dKFHjysmCaZ3iQbuQ/My2j+irOwSUM6crfIinkSQfwg74
         fJrBzJAbiGUS2VviDi032/KDYjmP0Y/YzdBWB90aowaVAU2cM7m/yeSkLYpTJ5Cj1D40
         ufMDdbpWKDJ7Jtg9aL1IKh7DaBqyxgxEhEA8ovLtdaISgXcPMkd/a66cPb2D95aTmTp3
         n9G+G8U2wb7kuMScxdRQC6hDXyew9nVJ8fv3pQkOw0bcf6J3Qe/ws42OIAmOCyUcI5bT
         8FnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772128082; x=1772732882;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YToQm8Rgx9xCen2GsgbKUz+NArcF+XV9oeQ/EMGpxps=;
        b=R7PMLmkn8LB657agRzyVbq0vTcgWDJQB8VGyt+tL3GZ/1ScwwAowmBn4Ng5x7mYhRH
         6yMi3DgpCcQT4PUB0Ympy8yld/PrFPtEeqfS87IccIRA0wDw8RVqOg+/MHLakxsJG/11
         I2AhFIi53sT3Y3eKohXj+pHJEsMc6ppsKlIGrwwM19AE6pKY80Mnwv3szmo3HAS4d7He
         UKmJI2UxMRXIfwf00JbHF1AlmTY3U/kXh3/hEpER7AyvlubxbKb2PAtT2Km4jODd0XED
         DXpiy2Xd3GBByLtTM4CVkB4LbtVFEuRzNAD2HQUPwTpc+iLh1afaOqvKIfCQeRmQikCh
         loLw==
X-Forwarded-Encrypted: i=1; AJvYcCXeenUQWOSxDLTIfeH6zIxIPzebopTczYRW6irUvHD+ijxrrp/Uf9Qg4yr64eoxiFFY+hU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyNv60q/YAXOpadH6faETAA7p57VxVTkCxg7mXnnTfO1vTLC58j
	icTPxxN/Sl2ptDopufniiQDMQVw7SUc2dOAkd+O5XSXRJLfI5OoimNVhu4Fe1lwAj3vnJYG0xW2
	LSnEwvw==
X-Received: from pjdn33.prod.google.com ([2002:a17:90a:2ca4:b0:358:eb1a:7aa])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1d4f:b0:34a:47d0:9a82
 with SMTP id 98e67ed59e1d1-35965cdad17mr6039a91.23.1772128082258; Thu, 26 Feb
 2026 09:48:02 -0800 (PST)
Date: Thu, 26 Feb 2026 09:47:55 -0800
In-Reply-To: <7a22294b-1150-4c55-a95a-ea918cfb9b76@acm.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260223215118.2154194-1-bvanassche@acm.org> <20260223215118.2154194-2-bvanassche@acm.org>
 <aZ3r5_P74tUJm2oF@google.com> <7a22294b-1150-4c55-a95a-ea918cfb9b76@acm.org>
Message-ID: <aaCHS5ZRuW-QJkK7@google.com>
Subject: Re: [PATCH 01/62] kvm: Make pi_enable_wakeup_handler() easier to analyze
From: Sean Christopherson <seanjc@google.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Will Deacon <will@kernel.org>, Boqun Feng <boqun@kernel.org>, Waiman Long <longman@redhat.com>, 
	linux-kernel@vger.kernel.org, Marco Elver <elver@google.com>, 
	Christoph Hellwig <hch@lst.de>, Steven Rostedt <rostedt@goodmis.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, Nathan Chancellor <nathan@kernel.org>, Kees Cook <kees@kernel.org>, 
	Jann Horn <jannh@google.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72062-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[16];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.999];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[ycombinator.com:url,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,acm.org:email]
X-Rspamd-Queue-Id: 182A41AD34F
X-Rspamd-Action: no action

On Tue, Feb 24, 2026, Bart Van Assche wrote:
> On 2/24/26 10:20 AM, Sean Christopherson wrote:
> > For the scope, please use:
> > 
> >     KVM: VMX:
> > 
> > On Mon, Feb 23, 2026, Bart Van Assche wrote:
> > > The Clang thread-safety analyzer does not support comparing expressions
> > > that use per_cpu(). Hence introduce a new local variable to capture the
> > > address of a per-cpu spinlock. This patch prepares for enabling the
> > > Clang thread-safety analyzer.
> > > 
> > > Cc: Sean Christopherson <seanjc@google.com>
> > > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > > Cc: kvm@vger.kernel.org
> > > Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> > > ---
> > >   arch/x86/kvm/vmx/posted_intr.c | 7 ++++---
> > >   1 file changed, 4 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
> > > index 4a6d9a17da23..f8711b7b85a8 100644
> > > --- a/arch/x86/kvm/vmx/posted_intr.c
> > > +++ b/arch/x86/kvm/vmx/posted_intr.c
> > > @@ -164,6 +164,7 @@ static void pi_enable_wakeup_handler(struct kvm_vcpu *vcpu)
> > >   	struct pi_desc *pi_desc = vcpu_to_pi_desc(vcpu);
> > >   	struct vcpu_vt *vt = to_vt(vcpu);
> > >   	struct pi_desc old, new;
> > > +	raw_spinlock_t *wakeup_lock;
> > >   	lockdep_assert_irqs_disabled();
> > > @@ -179,11 +180,11 @@ static void pi_enable_wakeup_handler(struct kvm_vcpu *vcpu)
> > >   	 * entirety of the sched_out critical section, i.e. the wakeup handler
> > >   	 * can't run while the scheduler locks are held.
> > >   	 */
> > > -	raw_spin_lock_nested(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu),
> > > -			     PI_LOCK_SCHED_OUT);
> > > +	wakeup_lock = &per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu);
> > 
> > Addressing this piecemeal doesn't seem maintainable in the long term.  The odds
> > of unintentionally regressing the coverage with a cleanup are rather high.  Or
> > we'll end up with confused and/or grumpy developers because they're required to
> > write code in a very specific way because of what are effectively shortcomings
> > in the compiler.
> 
> I think it's worth mentioning that the number of patches similar to the
> above is small. If I remember correctly, I only encountered two similar
> cases in the entire kernel tree.

Yeah, it's definitely not a deal-breaker to work around this in KVM, especially
if this is one of the few things blocking -Wthread-safety.

> Regarding why the above patch is necessary, I don't think that it is
> fair to blame the compiler in this case. The macros that implement
> per_cpu() make it impossible for the compiler to conclude that the
> pointers passed to the raw_spin_lock_nested() and raw_spin_unlock()
> calls are identical:

Well rats, that pretty much makes it infeasible to solve the underlying problem.

> /*
>  * Add an offset to a pointer.  Use RELOC_HIDE() to prevent the compiler
>  * from making incorrect assumptions about the pointer value.
>  */
> #define SHIFT_PERCPU_PTR(__p, __offset)				\
> 	RELOC_HIDE(PERCPU_PTR(__p), (__offset))
> 
> #define RELOC_HIDE(ptr, off)					\
> ({								\
> 	unsigned long __ptr;					\
> 	__asm__ ("" : "=r"(__ptr) : "0"(ptr));			\
> 	(typeof(ptr)) (__ptr + (off));				\
> })
> 
> By the way, the above patch is not the only possible solution for
> addressing the thread-safety warning Clang reports for this function.
> Another possibility is adding __no_context_analysis to the function
> definition. Is the latter perhaps what you prefer?

Hmm, I'd prefer to keep the analysis, even though it's a bit of a pain.  We already
went through quite some effort to preserve lockdep for this lock; compared to that,
forcing use of local variables is hardly anything.

My only concern is lack of enforcement and documentation.  I fiddled with a bunch
of ideas, but mostly of them flamed out because of the aformentioned lockdep
shenanigans.  E.g. forcing use of guard() or scoped_guard() doesn't Just Work.

The best idea I came up with is to rename the global variable to something scary,
and then define a CLASS() so that it's syntactically all but impossible to feed
the the result of per_cpu() directly into lock() or unlock().

What's your timeline for enabling -Wthread-safety?  E.g. are you trying to land
it in 7.1?  7.2+?  I'd be happy to formally post the below and get it landed in
the N-1 kernel (assuming Paolo is also comfortable landing the patch in 7.0 if
you're targeting 7.1).

---
From: Sean Christopherson <seanjc@google.com>
Date: Thu, 26 Feb 2026 07:21:52 -0800
Subject: [PATCH] KVM: VMX: Force wakeup_vcpus_on_cpu_lock to be captured in
 local variable

Wrap wakeup_vcpus_on_cpu_lock in a CLASS() and append "do_not_use" to the
per-CPU symbol to effectively force lock()+unlock() paths to capture the
per-CPU lock in a local variable.  Clang's thread-safety analyzer doesn't
support comparing lock() vs. unlock() expressions that use separate
per_cpu() invocations (-Wthread-safety generates false-positves), as the
kernel's per_cpu() implementation deliberately hides the resolved address
from the compiler, specifically to prevent the compiler from reasoning
about the symbol.  I.e. per_cpu() is a victim of its own success.

Link: https://lore.kernel.org/all/a2ebde260608230500o3407b108hc03debb9da6e62c@mail.gmail.com
Link: https://news.ycombinator.com/item?id=18050983
Suggested-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/posted_intr.c | 30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
index 4a6d9a17da23..e08faaeab12f 100644
--- a/arch/x86/kvm/vmx/posted_intr.c
+++ b/arch/x86/kvm/vmx/posted_intr.c
@@ -31,7 +31,21 @@ static DEFINE_PER_CPU(struct list_head, wakeup_vcpus_on_cpu);
  * CPU.  IRQs must be disabled when taking this lock, otherwise deadlock will
  * occur if a wakeup IRQ arrives and attempts to acquire the lock.
  */
-static DEFINE_PER_CPU(raw_spinlock_t, wakeup_vcpus_on_cpu_lock);
+static DEFINE_PER_CPU(raw_spinlock_t, wakeup_vcpus_on_cpu_lock__do_not_touch);
+
+/*
+ * Route accesses to the lock through a CLASS() to effectively force users to
+ * capture the lock in a local variable.  The kernel's per_cpu() implementation
+ * deliberately obfuscates the address of the data to prevent the compiler from
+ * making incorrect assumptions about the symbol.  However, hiding the address
+ * triggers false-positive thread-safety warnings if lock() vs. unlock() are
+ * called with different per_cpu() invocations, because the compiler can't tell
+ * its the same lock under the hood.
+ */
+DEFINE_CLASS(pi_wakeup_vcpus_lock, raw_spinlock_t *,
+	     lockdep_assert_not_held(_T),
+	     &per_cpu(wakeup_vcpus_on_cpu_lock__do_not_touch, cpu),
+	     int cpu);
 
 #define PI_LOCK_SCHED_OUT SINGLE_DEPTH_NESTING
 
@@ -90,7 +104,7 @@ void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
 	 * current pCPU if the task was migrated.
 	 */
 	if (pi_desc->nv == POSTED_INTR_WAKEUP_VECTOR) {
-		raw_spinlock_t *spinlock = &per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu);
+		CLASS(pi_wakeup_vcpus_lock, spinlock)(cpu);
 
 		/*
 		 * In addition to taking the wakeup lock for the regular/IRQ
@@ -165,6 +179,8 @@ static void pi_enable_wakeup_handler(struct kvm_vcpu *vcpu)
 	struct vcpu_vt *vt = to_vt(vcpu);
 	struct pi_desc old, new;
 
+	CLASS(pi_wakeup_vcpus_lock, spinlock)(vcpu->cpu);
+
 	lockdep_assert_irqs_disabled();
 
 	/*
@@ -179,11 +195,10 @@ static void pi_enable_wakeup_handler(struct kvm_vcpu *vcpu)
 	 * entirety of the sched_out critical section, i.e. the wakeup handler
 	 * can't run while the scheduler locks are held.
 	 */
-	raw_spin_lock_nested(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu),
-			     PI_LOCK_SCHED_OUT);
+	raw_spin_lock_nested(spinlock, PI_LOCK_SCHED_OUT);
 	list_add_tail(&vt->pi_wakeup_list,
 		      &per_cpu(wakeup_vcpus_on_cpu, vcpu->cpu));
-	raw_spin_unlock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
+	raw_spin_unlock(spinlock);
 
 	WARN(pi_test_sn(pi_desc), "PI descriptor SN field set before blocking");
 
@@ -254,9 +269,10 @@ void pi_wakeup_handler(void)
 {
 	int cpu = smp_processor_id();
 	struct list_head *wakeup_list = &per_cpu(wakeup_vcpus_on_cpu, cpu);
-	raw_spinlock_t *spinlock = &per_cpu(wakeup_vcpus_on_cpu_lock, cpu);
 	struct vcpu_vt *vt;
 
+	CLASS(pi_wakeup_vcpus_lock, spinlock)(cpu);
+
 	raw_spin_lock(spinlock);
 	list_for_each_entry(vt, wakeup_list, pi_wakeup_list) {
 
@@ -269,7 +285,7 @@ void pi_wakeup_handler(void)
 void __init pi_init_cpu(int cpu)
 {
 	INIT_LIST_HEAD(&per_cpu(wakeup_vcpus_on_cpu, cpu));
-	raw_spin_lock_init(&per_cpu(wakeup_vcpus_on_cpu_lock, cpu));
+	raw_spin_lock_init(&per_cpu(wakeup_vcpus_on_cpu_lock__do_not_touch, cpu));
 }
 
 void pi_apicv_pre_state_restore(struct kvm_vcpu *vcpu)

base-commit: 183bb0ce8c77b0fd1fb25874112bc8751a461e49
--

