Return-Path: <kvm+bounces-72171-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AO1vG8fCoWkVwQQAu9opvQ
	(envelope-from <kvm+bounces-72171-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 17:13:59 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C7BBE1BAA29
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 17:13:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A82F331EC357
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 16:06:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEBCA44BC8B;
	Fri, 27 Feb 2026 16:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4U5oaeTo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C61243D51A
	for <kvm@vger.kernel.org>; Fri, 27 Feb 2026 16:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772208385; cv=none; b=quSG+ZEC3w/G7346jbtpATsvn5DZaP4SMwRRZBB6gCacHcQR/tTTIzFonMt9nNBgycm1pmBfxa1o9kf41JQO1TSGjqCqz5eun583exOYIYVcdpSBT2mIXPnPoJimbw/dzlRkQGZNDsyXIFoeMGTOvgDO9Ts2x3LLwGpFdL9/2JA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772208385; c=relaxed/simple;
	bh=YxsXvIvfh76VzhK6UXSp7c2YfOWFOfSgaHE4CY/huLc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sejyJTrZy336T7Nx4U6VDuWnuT1Zl+jnmZ7XxHuE8NO2PvxSVrcCpwubYbtSqL7N+l3H8RbXtPNtqeagQVO2Vj4/IpV8jBjr2uYIfnLWDUAIpH9hKFsEXYB/Tg07+kSI03SVGksE32DnJ7ns9YqZ23GK8RwA3kmlQNyTq1CKEfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4U5oaeTo; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3568090851aso11407991a91.1
        for <kvm@vger.kernel.org>; Fri, 27 Feb 2026 08:06:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772208383; x=1772813183; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dLi6oTrN62qdRvWLksa/GdFl3MRGUGFNAoGOySxgx7k=;
        b=4U5oaeToYfkWk0d6gzPreNxI1WFMZ9ygUR94p2MyI9kMkeuW5MclSNzVCEcyP9TNxr
         xY5aZvc/I1w7MsiMxE3Lpolo8z7BG89orpad7vJynep1h5hDq6YTA3p0bMXPbJgcDMWW
         61sdpbHRLlvL11FTpANuqiu8VE8YXBVSwmJ8xNTYCBJWBVJF9iaOkZ1uImVsoWEaImco
         xLn43kHUQqvYd7w+oCP+TxfSCsTEHo496BYk5qg+4rCRy/KLyd51dgxV5w+GEa6GnKyU
         vyK0uLLpJQepplAF5xjMUNNu2cN3hkMpfSBVjMVKTEFCCFcfhv4M1RHjPr5C299ugyxE
         r7Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772208383; x=1772813183;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dLi6oTrN62qdRvWLksa/GdFl3MRGUGFNAoGOySxgx7k=;
        b=DOowFT/Q7sgbTrVqD9Wj+CZwrMAM5IwvXNx+XLwgeu3mHxHKVVTJ5Km3UbJZimhlVC
         6QP17j+g1xsm4psQ1Udq+cFwoOxnrM3I1ppPJqdaHa8I1jocKYay6Uw2WA5Ffj9DO9ct
         unMU897w14XQPXyRmj629MGiKEb1y4zk0X00HsPBRrGFP5eIGfKCYlvfBb4blv1se3oL
         BY7Xj+ZhM4QDE6tUdcKLe+aGX95H8ewIaj3vZYOzxT8H+kxc/LwauXbZg/mjaYXvXMiw
         THmjq61iTi6pkWY0tgRdi5WxqXbnVUt7qqF3Gp82EeCwyoRTbXbYrg+3UB+RRzzoEuiY
         g2zA==
X-Forwarded-Encrypted: i=1; AJvYcCWnI5bkRIuq7HU/j4mh3EKY532Th0fr0vQG6l757l2OheGTe8rnboatCe922yAx7q9qOMw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxD8sj86jJrcD0mae0Mbh0/Lol7ONPRkkjnY4h2S+xePeWsk3SQ
	xJLuPWBi71CAchqM3Vb3Qxg6GPszW+OLVZYvwn170ogYVGXHG22tSzcG7R7+vzt9zuTKirOi671
	LpZ73NA==
X-Received: from pjuz24.prod.google.com ([2002:a17:90a:d798:b0:358:f5eb:36b3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:558d:b0:335:2eef:4ca8
 with SMTP id 98e67ed59e1d1-35965cfbad1mr3744854a91.33.1772208382843; Fri, 27
 Feb 2026 08:06:22 -0800 (PST)
Date: Fri, 27 Feb 2026 08:06:21 -0800
In-Reply-To: <20260227011306.3111731-4-yosry@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260227011306.3111731-1-yosry@kernel.org> <20260227011306.3111731-4-yosry@kernel.org>
Message-ID: <aaG_o58_0aHT8Xjg@google.com>
Subject: Re: [PATCH 3/3] KVM: x86: Check for injected exceptions before
 queuing a debug exception
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72171-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[4];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: C7BBE1BAA29
X-Rspamd-Action: no action

On Fri, Feb 27, 2026, Yosry Ahmed wrote:
> On KVM_SET_GUEST_DEBUG, if a #DB or #BP is injected with
> KVM_GUESTDBG_INJECT_DB or KVM_GUESTDBG_INJECT_BP, KVM fails with -EBUSY
> if there is an existing pending exception. This was introduced in
> commit 4f926bf29186 ("KVM: x86: Polish exception injection via
> KVM_SET_GUEST_DEBUG") to avoid a warning in kvm_queue_exception(),
> presumably to avoid overriding a pending exception.
> 
> This added another (arguably nice) property, if there's a pending
> exception, KVM_SET_GUEST_DEBUG cannot cause a #DF or triple fault.
> However, if an exception is injected, KVM_SET_GUEST_DEBUG will cause
> a #DF or triple fault in the guest, as kvm_multiple_exception() combines
> them.

First off, this patch looks good irrespective of nested crud.  Disallowing injection
of #DB/#BP while there's already an injected exception aligns with architectural
behavior; KVM needs to finish delivering the exception and thus "complete" the
instruction before queueing a new exception.

As for nested, I _was_ going to say that, assuming the original motivation for
this patch is to avoid triggering a nested VM-Exit while nested_run_pending=1,
this is incomplete.  E.g. if the #BP or #DB itself is being intercepted by L1,
then queueing the exception will incorrectly deliver the nested VM-Exit before
nested VM-Enter completes.  I.e. I _thought_ we would also need:

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index db3f393192d9..fdbd272027ed 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12526,6 +12526,9 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
        if (vcpu->arch.guest_state_protected)
                return -EINVAL;
 
+       if (vcpu->arch.nested_run_pending)
+               return -EBUSY;
+
        vcpu_load(vcpu);
 
        if (dbg->control & (KVM_GUESTDBG_INJECT_DB | KVM_GUESTDBG_INJECT_BP)) {

But that isn't actually the case, because {svm,vmx}_check_nested_events() blocks
exceptions and VM-Exits while nested_run_pending=1.  Off-list, I had rejected
modifying nested_vmx_triple_fault() to drop the triple fault like so:

@@ -5191,6 +5191,9 @@ void __nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
 
 static void nested_vmx_triple_fault(struct kvm_vcpu *vcpu)
 {
+       if (to_vmx(vcpu)->nested.nested_run_pending)
+               return;
+
        kvm_clear_request(KVM_REQ_TRIPLE_FAULT, vcpu);
        nested_vmx_vmexit(vcpu, EXIT_REASON_TRIPLE_FAULT, 0, 0);
 }

because "That would largely defeat the entire purpose of the WARN. The whole point
is to detect bugs where KVM synthesizes a VM-Exit before completing nested VM-Enter.
It should be impossible for nested_{vmx,svm}_triple_fault() to be called with
nested_run_pending=true."

Given the above, that argument doesn't hold up at first glance, because blocking
the triple fault if nested_run_pending=1 would be consistent with how other "synchronous"
events are handled by nVMX and nSVM.  But after staring at this a bit, unless I'm
forgetting something (entirely possible), I actually think {svm,vmx}_check_nested_events()
are wrong, because I stand behind my quoted statement: it should be impossible for
KVM to synthesize a synchronous event before completing nested VM-Enter.

Blocking pending and injected exceptions was added by bfcf83b1444d ("KVM: nVMX:
Fix trying to cancel vmlauch/vmresume"), and unfortunately neither the changelog
nor Lore[1] provides any details as to what exactly prompted the fix.  I _suspect_
it was either syzkaller induced, or the manifestation of other bugs in KVM's
exception handling.

Finally getting to the point, in theory, I _think_ KVM should actually WARN on
all cases where it temporarily blocks a synchronous event due to a pending nested
VM-Enter (see below diff for the basic gist).  However, that would open the
floodgates to syzkaller, because KVM_SET_VCPU_EVENTS can obviously stuff events,
KVM_X86_SET_MCE can queue a #MC, etc.

I _think_ we might be able to get away with rejecting KVM_SET_VCPU_EVENTS if
nested_run_pending=1, without breaking userspace?  Google's VMM is insane and does
KVM_SET_VCPU_EVENTS before KVM_SET_NESTED_STATE, but in real usage, i.e. outside
of selftests, (I hope) no VMM will restore into a "live" vCPU.

So instead of patch 1, I want to try either (a) blocking KVM_SET_VCPU_EVENTS,
KVM_X86_SET_MCE, and KVM_SET_GUEST_DEBUG if nested_run_pending=1, *and* follow-up
with the below WARN-spree, or (b) add a separate flag, e.g. nested_run_in_progress
or so, that is set with nested_run_pending, but cleared on an exit to userspace,
and then WARN on _that_, i.e. so that we can detect KVM bugs (the whole point of
the WARN) and hopefully stop playing this losing game of whack-a-mole with syzkaller.

I think I'm leaning toward (b)?  Except for KVM_SET_GUEST_DEBUG, where userspace
is trying to interpose on the guest, restricting ioctls doesn't really add any
value in practice.  Yeah, in theory it could _maybe_ prevent userspace from shooting
itself in the foot, but practically speaking, if userspace is restoring state into
a vCPU with nested_run_pending=1, it's either playing on expert mode or is already
completely broken.

My only hesitation with (b) is that KVM wouldn't be entirely consistent, since
vmx_unhandleable_emulation_required() _does_ explicitly reject a "userspace did
something stupid with nested_run_pending=1" case.  So from that perspective, part
of me wants to get greedy and try for (a).

[1] https://lore.kernel.org/all/?q=%22KVM:%20nVMX:%20Fix%20trying%20to%20cancel%20vmlauch%22

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index de90b104a0dd..d624e4db704a 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1605,14 +1605,14 @@ static int svm_check_nested_events(struct kvm_vcpu *vcpu)
        }
 
        if (vcpu->arch.exception_vmexit.pending) {
-               if (block_nested_exceptions)
+               if (WARN_ON_ONCE(block_nested_exceptions))
                         return -EBUSY;
                nested_svm_inject_exception_vmexit(vcpu);
                return 0;
        }
 
        if (vcpu->arch.exception.pending) {
-               if (block_nested_exceptions)
+               if (WARN_ON_ONCE(block_nested_exceptions))
                        return -EBUSY;
                return 0;
        }
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 248635da6766..a223c5e86188 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4336,7 +4336,7 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
         */
        if (vcpu->arch.exception_vmexit.pending &&
            !vmx_is_low_priority_db_trap(&vcpu->arch.exception_vmexit)) {
-               if (block_nested_exceptions)
+               if (WARN_ON_ONCE(block_nested_exceptions))
                        return -EBUSY;
 
                nested_vmx_inject_exception_vmexit(vcpu);
@@ -4345,13 +4345,13 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
 
        if (vcpu->arch.exception.pending &&
            !vmx_is_low_priority_db_trap(&vcpu->arch.exception)) {
-               if (block_nested_exceptions)
+               if (WARN_ON_ONCE(block_nested_exceptions))
                        return -EBUSY;
                goto no_vmexit;
        }
 
        if (vmx->nested.mtf_pending) {
-               if (block_nested_events)
+               if (WARN_ON_ONCE(block_nested_exceptions))
                        return -EBUSY;
                nested_vmx_update_pending_dbg(vcpu);
                nested_vmx_vmexit(vcpu, EXIT_REASON_MONITOR_TRAP_FLAG, 0, 0);
@@ -4359,7 +4359,7 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
        }
 
        if (vcpu->arch.exception_vmexit.pending) {
-               if (block_nested_exceptions)
+               if (WARN_ON_ONCE(block_nested_exceptions))
                        return -EBUSY;
 
                nested_vmx_inject_exception_vmexit(vcpu);
@@ -4367,7 +4367,7 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
        }
 
        if (vcpu->arch.exception.pending) {
-               if (block_nested_exceptions)
+               if (WARN_ON_ONCE(block_nested_exceptions))
                        return -EBUSY;
                goto no_vmexit;
        }


