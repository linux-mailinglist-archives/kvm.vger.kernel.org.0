Return-Path: <kvm+bounces-28358-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EF0D5997AB2
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 04:50:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 21685B21F9B
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 02:50:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 024C6188000;
	Thu, 10 Oct 2024 02:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CT6KP/IM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 930873716D
	for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 02:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728528598; cv=none; b=KrNalggpeB+HopNDXC4XQZchK8t+e07YcgRUXschmUTA0S0U6FPgwloNHgmtHNDa0FO8UoKnSDANxUK+A+YrEQ13NShrGKi758kDiL2ZEfc8D/AP3pVX1bdSaIt6lfcVUp5mrH02Do8Ko85kGRToyvkrqPULmvcb7igTp6XwgvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728528598; c=relaxed/simple;
	bh=jF7zRIl6J0ZC7ElkWWerDseFvVW3fSJv93rA4dwkcj4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VnIigLoTOj2MOsVy0//8Unc5Rb4UCTuQGgsHltzXE1Bc5A44Q8RkCw8fnUda3BvLNPcVdWDAxk4BhjhpkXZlnsSmCicZe8zmMUGtckQyMHGwXxXYL8cB3bAzF5kiJC8zqnH68QzBXUorWWc4GBhYgXA7LMJR2Jb4bFEWzgXEuuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CT6KP/IM; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e0b8fa94718so681060276.0
        for <kvm@vger.kernel.org>; Wed, 09 Oct 2024 19:49:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728528595; x=1729133395; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bApE1fjODWFyyKziF9jfIyrrFjDdYcQB0NvVCBgzqpo=;
        b=CT6KP/IMTtTCg4gqXYscxyAyv0u1IQFLuGrtEG3aI99N0C+mbC8NQaaxAGLAisd11B
         1wxql+6Y46ctGDk9xnlaqOHAStNt9E7NvI9+bzaeDs37rNlRFFVLDsTIxA38oPMrAC1H
         gxKaXGBKojOuyKFlFVr3C+ve//4CD3hwqNK9rgeur6aAZ7A0wMv7WucUvxufX2R5Twxp
         VJQfOHdRdg4h6QdIw0+zdQd6NcIFD4OFxMZisBFxJXpPmvqyk+LAMT/yNSZfIzSaCFfk
         iHyyUeU8MS3UPUbVgyYrMvuWE6oygr+ltDsJVIgZiG8dlTdpFAPW3s5xlrPsMRShJqtK
         hVXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728528595; x=1729133395;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bApE1fjODWFyyKziF9jfIyrrFjDdYcQB0NvVCBgzqpo=;
        b=pYcbKK7V/GRcbWRUH4m/kRyW61yEHaugPnNuFi0adv4En8/PVx0hi9gBwtkNczL4kC
         bJ8QBFkyFWLvT5il1utx+oSI0N7MpoUtncg6Y4e1h8xmdcrZhk0lvulrTspo5vo1t9ND
         EZosVJjceJhn07ZyQRyrkFpcWxCrhgpEHGv9Yz0qjk/3RU2vvljprBLXCJKnujzzoL0b
         YApPNhLvSqcnVqFPe1widN6mnDRXyNABpJBkW9bEE0Rnza4N2jWUd86WTSAhEnPURTik
         BN3nyqnNULVef2ncrpP03O8InOsYlnW3Tu9JrTLylVbD8iGF02GDddqE9uxw5PgWvpgL
         s3lw==
X-Forwarded-Encrypted: i=1; AJvYcCUdlu9BWdYRnNc3aT1gDQ1vwG0WIIg1QwElMrlvLqIaVoKnCUH7TCL80IsDVG4T91jxxpg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzKYCWN8jG3BLU83JbFllblAlGYc4oL2n2rijnBHBU6YkLHBCk/
	iyX4e0UtpUe2u5bgHZSo3rq82cBxXQRvB6QcB48X9QTVnIt3D/K7GXoeQ62GQ/n7VbpmciFf6N+
	3gg==
X-Google-Smtp-Source: AGHT+IGaHWlQPOd/H4tPlrFVArAf0K+GTrCmAoxIcM3p3xNOYLN56SF0aqiV85G3menN0q5PzabxBYS5lFQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a5b:a4c:0:b0:e28:f454:7de5 with SMTP id
 3f1490d57ef6-e28fe52740fmr53105276.6.1728528595591; Wed, 09 Oct 2024 19:49:55
 -0700 (PDT)
Date: Wed, 9 Oct 2024 19:49:54 -0700
In-Reply-To: <5618d029-769a-4690-a581-2df8939f26a9@samsung.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240727102732.960974693@infradead.org> <20240727105030.226163742@infradead.org>
 <CGME20240828223802eucas1p16755f4531ed0611dc4871649746ea774@eucas1p1.samsung.com>
 <5618d029-769a-4690-a581-2df8939f26a9@samsung.com>
Message-ID: <ZwdA0sbA2tJA3IKh@google.com>
Subject: Re: [PATCH 17/24] sched/fair: Implement delayed dequeue
From: Sean Christopherson <seanjc@google.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Peter Zijlstra <peterz@infradead.org>, mingo@redhat.com, juri.lelli@redhat.com, 
	vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org, 
	bsegall@google.com, mgorman@suse.de, vschneid@redhat.com, 
	linux-kernel@vger.kernel.org, kprateek.nayak@amd.com, 
	wuyun.abel@bytedance.com, youssefesmat@chromium.org, tglx@linutronix.de, 
	efault@gmx.de, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

+KVM

On Thu, Aug 29, 2024, Marek Szyprowski wrote:
> On 27.07.2024 12:27, Peter Zijlstra wrote:
> > Extend / fix 86bfbb7ce4f6 ("sched/fair: Add lag based placement") by
> > noting that lag is fundamentally a temporal measure. It should not be
> > carried around indefinitely.
> >
> > OTOH it should also not be instantly discarded, doing so will allow a
> > task to game the system by purposefully (micro) sleeping at the end of
> > its time quantum.
> >
> > Since lag is intimately tied to the virtual time base, a wall-time
> > based decay is also insufficient, notably competition is required for
> > any of this to make sense.
> >
> > Instead, delay the dequeue and keep the 'tasks' on the runqueue,
> > competing until they are eligible.
> >
> > Strictly speaking, we only care about keeping them until the 0-lag
> > point, but that is a difficult proposition, instead carry them around
> > until they get picked again, and dequeue them at that point.
> >
> > Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> 
> This patch landed recently in linux-next as commit 152e11f6df29 
> ("sched/fair: Implement delayed dequeue"). In my tests on some of the 
> ARM 32bit boards it causes a regression in rtcwake tool behavior - from 
> time to time this simple call never ends:
> 
> # time rtcwake -s 10 -m on
> 
> Reverting this commit (together with its compile dependencies) on top of 
> linux-next fixes this issue. Let me know how can I help debugging this 
> issue.

This commit broke KVM's posted interrupt handling (and other things), and the root
cause may be the same underlying issue.

TL;DR: Code that checks task_struct.on_rq may be broken by this commit.

KVM's breakage boils down to the preempt notifiers, i.e. kvm_sched_out(), being
invoked with current->on_rq "true" after KVM has explicitly called schedule().
kvm_sched_out() uses current->on_rq to determine if the vCPU is being preempted
(voluntarily or not, doesn't matter), and so waiting until some later point in
time to call __block_task() causes KVM to think the task was preempted, when in
reality it was not.

  static void kvm_sched_out(struct preempt_notifier *pn,
 			  struct task_struct *next)
  {
	struct kvm_vcpu *vcpu = preempt_notifier_to_vcpu(pn);

	WRITE_ONCE(vcpu->scheduled_out, true);

	if (current->on_rq && vcpu->wants_to_run) {  <================
		WRITE_ONCE(vcpu->preempted, true);
		WRITE_ONCE(vcpu->ready, true);
	}
	kvm_arch_vcpu_put(vcpu);
	__this_cpu_write(kvm_running_vcpu, NULL);
  }

KVM uses vcpu->preempted for a variety of things, but the most visibly problematic
is waking a vCPU from (virtual) HLT via posted interrupt wakeup.  When a vCPU
HLTs, KVM ultimate calls schedule() to schedule out the vCPU until it receives
a wake event.

When a device or another vCPU can post an interrupt as a wake event, KVM mucks
with the blocking vCPU's posted interrupt descriptor so that posted interrupts
that should be wake events get delivered on a dedicated host IRQ vector, so that
KVM can kick and wake the target vCPU.

But when vcpu->preempted is true, KVM suppresses posted interrupt notifications,
knowing that the vCPU will be scheduled back in.  Because a vCPU (task) can be
preempted while KVM is emulating HLT, KVM keys off vcpu->preempted to set PID.SN,
and doesn't exempt the blocking case.  In short, KVM uses vcpu->preempted, i.e.
current->on_rq, to differentiate between the vCPU getting preempted and KVM
executing schedule().

As a result, the false positive for vcpu->preempted causes KVM to suppress posted
interrupt notifications and the target vCPU never gets its wake event.


Peter,

Any thoughts on how best to handle this?  The below hack-a-fix resolves the issue,
but it's obviously not appropriate.  KVM uses vcpu->preempted for more than just
posted interrupts, so KVM needs equivalent functionality to current->on-rq as it
was before this commit.

@@ -6387,7 +6390,7 @@ static void kvm_sched_out(struct preempt_notifier *pn,
 
        WRITE_ONCE(vcpu->scheduled_out, true);
 
-       if (current->on_rq && vcpu->wants_to_run) {
+       if (se_runnable(&current->se) && vcpu->wants_to_run) {
                WRITE_ONCE(vcpu->preempted, true);
                WRITE_ONCE(vcpu->ready, true);
        }

