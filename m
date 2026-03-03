Return-Path: <kvm+bounces-72489-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uG/nMflFpmlyNQAAu9opvQ
	(envelope-from <kvm+bounces-72489-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 03:22:49 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 51FA91E7F7B
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 03:22:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7C7EC3090EDA
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 02:22:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC42B3750D4;
	Tue,  3 Mar 2026 02:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="V8ZjeqdM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB72F3750CC
	for <kvm@vger.kernel.org>; Tue,  3 Mar 2026 02:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772504551; cv=none; b=XaDp2p1TggQoHo21H1aGB1bcRfC4K5KX7BrkAh4Z2GacvCj6zOr+X9Pg4Gm0r1gD/5nmEfeNt+uMwHoaPLaCzZvSSrX1+p1koR4y6LeMbyeYaeWh7U13VgHPO4QduJ+dqm1V0SZjTl4tT50acMMwD0fMNZBaYR4DXUqZmROmoFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772504551; c=relaxed/simple;
	bh=gf+2BiY/yfU9/1YNczOQ/IYDeZ7anIWZ83BCs8n4Yr4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Jcjf+EL9RVH/1tQFg936Gy6UZNlkF+B4xt5CZXg0Y27+HR4cmzgYs6URS9PA0PkriPsRVYYXp7XhaacEDKQsrrwq47oYFvPDP1MxwKaSejoRaT6/sJ3oXtA0P6NEw1r/xRFt11R8fRCF8WI3l/GLkm5l59F2E53Hvk61utr3qgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=V8ZjeqdM; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-358e425c261so4352759a91.3
        for <kvm@vger.kernel.org>; Mon, 02 Mar 2026 18:22:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772504549; x=1773109349; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=MQvQrkte+OWOvYaFeGeQ3JIRUHTtvoopnhw6ppPf9PY=;
        b=V8ZjeqdMQvIqeMEt38AgNsqAXgUzlkFgRiW/yPcBuYI1rNx1UySxQ3PKc7lNMRIHAq
         3um8PQ820Pc2mEDG4tjOfltJfOts9F9vjOKhDHNCDmNvUoxbZrO/mdWe2nhWBvYp5O3K
         LketIIKF7K+8rqTEXTYDNrWEKtKbpCMIAdLe8sXLeLSwSr1yEbW5yx/P9jzRYHZZsisL
         xnI5DixGaiUEm0pcViSKB0OJgiP17pM41c7h4nmzUG5tII6b0nPKnRbxK20xpXZO1aim
         Z1qEQq9QZtUb6rdtXvG2atc8c+cZOsZOCu4Qez4QwRF8blKt9L470BT0/9LViJQTq6Zt
         wgSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772504549; x=1773109349;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MQvQrkte+OWOvYaFeGeQ3JIRUHTtvoopnhw6ppPf9PY=;
        b=RBBmM9otzMx5YTEySE5QqPPw0R0lT6F2vE/z7cuvib3BSnuVQjufl3X9nX/7jUBByv
         WGBjwnUdRPZQE/cUG5CueBOjpzXMGRRgqwq73tx2ScbVHFonhiOaHf75t9pjGZoftImu
         eW2XbaZDgsK4IwfsWc90eJGuHEa9ncyuqTccX7bMb6afeuNodAX4hWe7EIJkod2tSvRI
         ZPh/2e6K/Kh3LSwmGfD5ouBAnSCtuo5Sc/SNvv51yI6f/g4HfxkIB/ArF1gQhA+XMaZa
         5ruF7eptR13++XrgDQ1oU0MXomvCmMYi4vrL+7GO6M3NIBr9+fhKvpTJZIx1R/OqjG9l
         kSYQ==
X-Forwarded-Encrypted: i=1; AJvYcCUdtXakNYPjhpNxwhwTpWLuYk9cJuZLhbwWXjLlRItiTjpWJEdag0blz+Q+dkj1GKseZ2E=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7dvMt3UEV/nFDpfM/fnOXftJp1u7nABSTWoWyQqfO04S+4Udi
	H7r/o6Ls1ZPwj5cZyH8UItwYZnKlLbYT0P5djJwbxe6dfEWO+SGzpNyugClY7lTNv5PEvzBDCAh
	NZuWVBw==
X-Received: from pjbdw2.prod.google.com ([2002:a17:90b:942:b0:358:f01f:25f3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3d46:b0:359:120f:d3aa
 with SMTP id 98e67ed59e1d1-35965c40c42mr12513063a91.14.1772504549141; Mon, 02
 Mar 2026 18:22:29 -0800 (PST)
Date: Mon, 2 Mar 2026 18:22:27 -0800
In-Reply-To: <20260228033328.2285047-5-chengkev@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260228033328.2285047-1-chengkev@google.com> <20260228033328.2285047-5-chengkev@google.com>
Message-ID: <aaZF43PdvrZvIaXn@google.com>
Subject: Re: [PATCH V4 4/4] KVM: SVM: Raise #UD if VMMCALL instruction is not intercepted
From: Sean Christopherson <seanjc@google.com>
To: Kevin Cheng <chengkev@google.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	yosry@kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Queue-Id: 51FA91E7F7B
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72489-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

+Vitaly

On Sat, Feb 28, 2026, Kevin Cheng wrote:
> The AMD APM states that if VMMCALL instruction is not intercepted, the
> instruction raises a #UD exception.
> 
> Create a vmmcall exit handler that generates a #UD if a VMMCALL exit
> from L2 is being handled by L0, which means that L1 did not intercept
> the VMMCALL instruction. The exception to this is if the exiting
> instruction was for Hyper-V L2 TLB flush hypercalls as they are handled
> by L0.

*sigh*

Except this changelog doesn't capture *any* of the subtlety.  And were it not for
an internal bug discussion, I would have literally no clue WTF is going on.

There's not generic missed #UD bug, because this code in recalc_intercepts()
effectively disables the VMMCALL intercept in vmcb02 if the intercept isn't set
in vmcb12.

	/*
	 * We want to see VMMCALLs from a nested guest only when Hyper-V L2 TLB
	 * flush feature is enabled.
	 */
	if (!nested_svm_l2_tlb_flush_enabled(&svm->vcpu))
		vmcb_clr_intercept(c, INTERCEPT_VMMCALL);

I.e. the only bug *knowingly* being fixed, maybe, is an edge case where Hyper-V
TLB flushes are enabled for L2 and the hypercall is something other than one of
the blessed Hyper-V hypercalls.  But in that case, it's not at all clear to me
that synthesizing a #UD into L2 is correct.  I can't find anything in the TLFS
(not surprising), so I guess anything goes?

Vitaly,

The scenario in question is where HV_X64_NESTED_DIRECT_FLUSH is enabled, L1 doesn't
intercept VMMCALL, and L2 executes VMMCALL with something other than one of the
Hyper-V TLB flush hypercalls.  The proposed change is to synthesize #UD (which
is what happens if HV_X64_NESTED_DIRECT_FLUSH isn't enable).  Does that sound
sane?  Should KVM instead return an error.

As for bugs that are *unknowingly* being fixed, intercepting VMMCALL and manually
injecting a #UD effectively fixes a bad interaction with KVM's asinine
KVM_X86_QUIRK_FIX_HYPERCALL_INSN.  If KVM doesn't intercept VMMCALL while L2
is active (L1 doesn't wants to intercept VMMCALL and the Hyper-V L2 TLB flush
hypercall is disabled), then L2 will hang on the VMMCALL as KVM will intercept
the #UD, then "emulate" VMMCALL by trying to fixup the opcode and restarting the
instruction.

That can be "fixed" by disabling the quirk, or by hacking the fixup like so:

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index db3f393192d9..3f6d9950f8f8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10506,17 +10506,22 @@ static int emulator_fix_hypercall(struct x86_emulate_ctxt *ctxt)
         * If the quirk is disabled, synthesize a #UD and let the guest pick up
         * the pieces.
         */
-       if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_FIX_HYPERCALL_INSN)) {
-               ctxt->exception.error_code_valid = false;
-               ctxt->exception.vector = UD_VECTOR;
-               ctxt->have_exception = true;
-               return X86EMUL_PROPAGATE_FAULT;
-       }
+       if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_FIX_HYPERCALL_INSN))
+               goto inject_ud;
 
        kvm_x86_call(patch_hypercall)(vcpu, instruction);
 
+       if (is_guest_mode(vcpu) && !memcmp(instruction, ctxt->fetch.data, 3))
+               goto inject_ud;
+
        return emulator_write_emulated(ctxt, rip, instruction, 3,
                &ctxt->exception);
+
+inject_ud:
+       ctxt->exception.error_code_valid = false;
+       ctxt->exception.vector = UD_VECTOR;
+       ctxt->have_exception = true;
+       return X86EMUL_PROPAGATE_FAULT;
 }
 
 static int dm_request_for_irq_injection(struct kvm_vcpu *vcpu)
--

But that's extremely convoluted for no purpose that I can see.  Not intercepting
VMMCALL requires _more_ code and is overall more complex.

So unless I'm missing something, I'm going to tack on this to fix the L2 infinite
loop, and then figure out what to do about Hyper-V, pending Vitaly's input.

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 45d1496031a7..a55af647649c 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -156,13 +156,6 @@ void recalc_intercepts(struct vcpu_svm *svm)
                        vmcb_clr_intercept(c, INTERCEPT_VINTR);
        }
 
-       /*
-        * We want to see VMMCALLs from a nested guest only when Hyper-V L2 TLB
-        * flush feature is enabled.
-        */
-       if (!nested_svm_l2_tlb_flush_enabled(&svm->vcpu))
-               vmcb_clr_intercept(c, INTERCEPT_VMMCALL);
-
        for (i = 0; i < MAX_INTERCEPT; i++)
                c->intercepts[i] |= g->intercepts[i];
 


