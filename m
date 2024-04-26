Return-Path: <kvm+bounces-16082-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A2C38B4101
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 23:01:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8F819B21F51
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 21:01:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CFB32C84F;
	Fri, 26 Apr 2024 21:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TIUMIXbY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B36DE13AF2
	for <kvm@vger.kernel.org>; Fri, 26 Apr 2024 21:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714165279; cv=none; b=KXNlPMomtLle0A88wtF+AYujK1qK822yL6z5p+f/2YwGrGAKd0h+ozAx0c+cqBrmweg2ifZHqdGHjqXEii2UWxsa6zcY2x45wjbAqju6QNNTCmko+v0r8zZlPaGU9vLkCBhEZY5n/kSvyCyLgiygjVvcr3YDdlf7wUelwhjpicQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714165279; c=relaxed/simple;
	bh=Epgqxdq6VeKfWm6FHSwQentwf1ljWjufcF9ZlxxH/zs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Rj2r5OzPLNLzOzs9Lhx5M4Z9J6ALJlGRcfQwCLknQ8YEHCjaAGTSv17560/BKI0qU43wI3y4c1sbkWQWLSB82LOha3bbk18v4Qw5S06MZcPdztXYuV9EXnFx2sB+NkaB4PnA2GzSMj5MId0IwvYer3F8AAE3KqWzKTulG4dwd1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TIUMIXbY; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc6ceade361so6228936276.0
        for <kvm@vger.kernel.org>; Fri, 26 Apr 2024 14:01:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714165277; x=1714770077; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rX0i2xw++nNStPTG6piEEy7HbW3SzcjMZwsGSn414eg=;
        b=TIUMIXbYRCVflBm7/+ULBgjacgak6chXRNPWD3qG3Z1b2/u//1QgVq8Y9mSJD4aJJD
         7i/k7HRByOFNgIw6ldaJ4XWbfqplJauY1T4TyDuevjctno/mbEEuVz/veLIHMkmP201w
         2hQMIyAWurT/uUWVZfkxOdYC+n/7oyRJu7yIgfrFKor2gWkDVoHLK+EuR2ihDi2sPNqO
         qKqJPsbpj5+wb+KugWzJ8r/B+jAT2zDHeUuFN/DUdUZPmw2HZhu4nmn51rDIkzFMHSXt
         rDxpkOdjqzwS5PceHt2p6pB+002H+WXE3D/BetVhlN1JKKfD9WfpQUh3srqHRuBzJsXi
         ZhWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714165277; x=1714770077;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rX0i2xw++nNStPTG6piEEy7HbW3SzcjMZwsGSn414eg=;
        b=u1OUWfHMyN6hrBGoYCmjqOko0IeuU0g5DXc54Wf/4HJD2VdRK/CTu0f+pFn+EVr6yL
         qzoaFntmGOkaARA8hqTYTzbs8Relkeyl1NGEG5OInJe9Ykiokt0lTbKroKvgQcItc573
         NImH8Bg0s433bUFkDdhxR6r6JExDrpUMlwvhMdc+l3QwhW4j4AsREZsqeCidiz/pMFDV
         LyKbx8usgBoUbRzS6dP+54K5gw2eOpWw6IGmtbAiWSRCT8XFii4oh3rWI3rxm2eT/Jf8
         /rDL0l0rLWKrxd37aBYMLBL1NnN5cp3YUWLGeD+gPqc1971rddqzytRPbshaj42r9rxs
         ysqQ==
X-Forwarded-Encrypted: i=1; AJvYcCWg/WiDC2dNJaNO/z4MzZ4BMpAtrN68noEelKK/RFkGSEVKybAcRjjT5GV59S8YNc2TKVyKOtFnTY/gFle4VAf3nAbi
X-Gm-Message-State: AOJu0YxVe+gQAPwHLR7U8GbXCDOsSqexozSJBy6o6bJj9aP/OMaSgj0J
	DqOWg0re+lDLyGCcO+xLm0vIXKRtYepf5N5Xk2Qzls741NWLjpfosgyRs52skdrMxcylJ9asokK
	r3g==
X-Google-Smtp-Source: AGHT+IHZ7zlgATaoEjItXpt0+lPhLVgOPB/c7agI1QcpZna9x6zfw+NEeQKeuz1kND81TiK/MoMeDXdYc/0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:154b:b0:dc7:68b5:4f21 with SMTP id
 r11-20020a056902154b00b00dc768b54f21mr1113542ybu.9.1714165276709; Fri, 26 Apr
 2024 14:01:16 -0700 (PDT)
Date: Fri, 26 Apr 2024 14:01:15 -0700
In-Reply-To: <20240307163541.92138-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240307163541.92138-1-dmatlack@google.com>
Message-ID: <ZiwWG4iHQYREwFP2@google.com>
Subject: Re: [PATCH v2] KVM: Mark a vCPU as preempted/ready iff it's scheduled
 out while running
From: Sean Christopherson <seanjc@google.com>
To: David Matlack <dmatlack@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Mar 07, 2024, David Matlack wrote:
> Mark a vCPU as preempted/ready if-and-only-if it's scheduled out while
> running. i.e. Do not mark a vCPU preempted/ready if it's scheduled out
> during a non-KVM_RUN ioctl() or when userspace is doing KVM_RUN with
> immediate_exit.
> 
> Commit 54aa83c90198 ("KVM: x86: do not set st->preempted when going back
> to user space") stopped marking a vCPU as preempted when returning to
> userspace, but if userspace then invokes a KVM vCPU ioctl() that gets
> preempted, the vCPU will be marked preempted/ready. This is arguably
> incorrect behavior since the vCPU was not actually preempted while the
> guest was running, it was preempted while doing something on behalf of
> userspace.
> 
> This commit also avoids KVM dirtying guest memory after userspace has
> paused vCPUs, e.g. for Live Migration, which allows userspace to collect
> the final dirty bitmap before or in parallel with saving vCPU state
> without having to worry about saving vCPU state triggering writes to
> guest memory.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
> v2:
>  - Drop Google-specific "PRODKERNEL: " shortlog prefix
> 
> v1: https://lore.kernel.org/kvm/20231218185850.1659570-1-dmatlack@google.com/
> 
>  include/linux/kvm_host.h | 1 +
>  virt/kvm/kvm_main.c      | 5 ++++-
>  2 files changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 7e7fd25b09b3..5b2300614d22 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -378,6 +378,7 @@ struct kvm_vcpu {
>  		bool dy_eligible;
>  	} spin_loop;
>  #endif
> +	bool wants_to_run;
>  	bool preempted;
>  	bool ready;
>  	struct kvm_vcpu_arch arch;
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index ff588677beb7..3da1b2e3785d 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -4438,7 +4438,10 @@ static long kvm_vcpu_ioctl(struct file *filp,
>  				synchronize_rcu();
>  			put_pid(oldpid);
>  		}
> +		vcpu->wants_to_run = !vcpu->run->immediate_exit;

>  		r = kvm_arch_vcpu_ioctl_run(vcpu);
> +		vcpu->wants_to_run = false;
> +
>  		trace_kvm_userspace_exit(vcpu->run->exit_reason, r);
>  		break;
>  	}
> @@ -6312,7 +6315,7 @@ static void kvm_sched_out(struct preempt_notifier *pn,
>  {
>  	struct kvm_vcpu *vcpu = preempt_notifier_to_vcpu(pn);
>  
> -	if (current->on_rq) {
> +	if (current->on_rq && vcpu->wants_to_run) {
>  		WRITE_ONCE(vcpu->preempted, true);
>  		WRITE_ONCE(vcpu->ready, true);
>  	}
> 
> base-commit: 687d8f4c3dea0758afd748968d91288220bbe7e3

Long story short, I was playing around with wants_to_run for a few hairbrained
ideas, and realized that there's a TOCTOU bug here.  Userspace can toggle
run->immediate_exit at will, e.g. can clear it after the kernel loads it to
compute vcpu->wants_to_run.

That's not fatal for this use case, since userspace would only be shooting itself
in the foot, but it leaves a very dangerous landmine, e.g. if something else in
KVM keys off of vcpu->wants_to_run to detect that KVM is in its run loop, i.e.
relies on wants_to_run being set if KVM is in its core run loop.

To address that, I think we should have all architectures check wants_to_run, not
immediate_exit.  And loading immediate_exit needs to be done with READ_ONCE().

E.g. for x86 (every other arch has similar code)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e9ef1fa4b90b..1a2f6bf14fb2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11396,7 +11396,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 
        kvm_vcpu_srcu_read_lock(vcpu);
        if (unlikely(vcpu->arch.mp_state == KVM_MP_STATE_UNINITIALIZED)) {
-               if (kvm_run->immediate_exit) {
+               if (!vcpu->wants_to_run) {
                        r = -EINTR;
                        goto out;
                }
@@ -11474,7 +11474,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
                WARN_ON_ONCE(vcpu->mmio_needed);
        }
 
-       if (kvm_run->immediate_exit) {
+       if (!vcpu->wants_to_run) {
                r = -EINTR;
                goto out;
        }
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f9b9ce0c3cd9..0c0aae224000 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1497,9 +1497,7 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
                                        struct kvm_guest_debug *dbg);
 int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu);
 
-void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu);
-
-void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
+void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu, bool sched_in);
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu);
 int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id);
 int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 9501fbd5dfd2..4384bbdba65c 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4410,7 +4410,7 @@ static long kvm_vcpu_ioctl(struct file *filp,
                                synchronize_rcu();
                        put_pid(oldpid);
                }
-               vcpu->wants_to_run = !vcpu->run->immediate_exit;
+               vcpu->wants_to_run = !READ_ONCE(vcpu->run->immediate_exit);
                r = kvm_arch_vcpu_ioctl_run(vcpu);
                vcpu->wants_to_run = false;


---

Hmm, and we should probably go a step further and actively prevent using
immediate_exit from the kernel, e.g. rename it to something scary like:

diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 2190adbe3002..9c5fe1dae744 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -196,7 +196,11 @@ struct kvm_xen_exit {
 struct kvm_run {
        /* in */
        __u8 request_interrupt_window;
+#ifndef __KERNEL__
        __u8 immediate_exit;
+#else
+       __u8 hidden_do_not_touch;
+#endif
        __u8 padding1[6];
 
        /* out */


