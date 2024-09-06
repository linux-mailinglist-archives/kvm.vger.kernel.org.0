Return-Path: <kvm+bounces-26018-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 072B896F911
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2024 18:13:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7D36A1F23F47
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2024 16:13:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06DF71D365E;
	Fri,  6 Sep 2024 16:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3lAiFnmG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB1081D2F4C
	for <kvm@vger.kernel.org>; Fri,  6 Sep 2024 16:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725639222; cv=none; b=DjJlxVfVLHp98VW30UwsWmNhPxtt5LiW8DxFHtb++ovV35umx1fNlgo+uegqx2X9UB6/DKjPL//kcU1T310RjPGs0mMU/ruZGjV93kSscTJocauqLPvCce+FtLKO9DK8UHL1bvpMecAGxzZrmkiRWfui2oG4eE6IA+wnMcV4Kzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725639222; c=relaxed/simple;
	bh=+x634zBFuV2NUv5lbr5fTvF9szHg0etS1D4EhFX0ECw=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=nVKadWUdE5XVwiaoxTA4UDs57N7fD5H5a2vNq9owTa9XTtpgnZxJw/71RrhqL1Q4oi1wBavJcSjLqHmnetBYdrwB7072iYqH++hAIL7daj9x08BEOpaBOwnPA4tmyjZ+guLDr18J4EC/r7I9+AzEzRPmsw4n6u7fML08ISPRCoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3lAiFnmG; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-718d61a1a27so1244771b3a.0
        for <kvm@vger.kernel.org>; Fri, 06 Sep 2024 09:13:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725639220; x=1726244020; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yJzsXPh0EHCgHEeLHThIM9+IFn7kBcp7EsZmnAI38/4=;
        b=3lAiFnmGGSHYFivRDSSpt9ZiiR0MA+5E8fCOWfbiyQckkyaq5m0CzdKyEmKyCjjwD1
         COcRqLrlYz6ssPDISSJHsZYnANNxe9ou04tPv3F7iEz3jjrGQhwHGfSHp20jEyE0x3bT
         G6JUP4pl8ThmEmqp7V93wKxvyKEk5X1xHPxjJ525tqTm2Jc8PxGEYWC03FU9ktPy7WkS
         809IBYVd4KglX5CUYr8F3pFlkLeT0GXwfbAyu3DZwpC/31KX6qWJnfsg9UuqyY2qow5R
         sOjKQYw/cF8H0bWMPd5qyTp3JGF2OXA/TsRkjS31GFu02+EiicRl6GfVFOTBfthLSq9U
         PHmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725639220; x=1726244020;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yJzsXPh0EHCgHEeLHThIM9+IFn7kBcp7EsZmnAI38/4=;
        b=NWGXTPa3c9UHcTti/PCP4JBt51pAtDfw5/vaV3dNF9nts2EaoJXcQIGy/k4ewZCZxK
         eCrW1kT1ry7eoheXjps1H9SKynOmiZRcZP1tQxoT5CxR/liLbRMb3S+M0KA+WZa1vXq0
         n9E49Gi7XQiMrxpOHVYhaX0xCnMGqP19vAWjSKdx4mBSbRdLIJZiNXX24GhjksfxZ1Ql
         wv5LN0k18fD3rh0TaazVZiBK6iHKEQaWRu7znrGXua4QNVMa1Sdejok0a2joIJLM3bD9
         V87ToOZgcSldpWO1Wx5j8tRmXGUha2ODhlruAZ/U0cdjIWiTucoSTA4UaKQb3kIOxMTa
         ET/A==
X-Gm-Message-State: AOJu0Yz25YQfz4sxGe/Fg8Ua3rT+M4IJ4H3rJMJPN5jqc/k6DGEVjnAi
	o6vXpbwcM8zeKq/GVNZrze9s21KEr4ugm95pcbfRACSwi+1Nju1I38mdI/D06cbLQCQKo+DD2PS
	dfw==
X-Google-Smtp-Source: AGHT+IH/Xd3lVO5TxYk6jzwtY+ApltZnGGIM0GzqmbtRPDoVKosOVJ0aQB4RhG15eVjyAjCEdo5XRkC3FU0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:320b:b0:706:3421:740d with SMTP id
 d2e1a72fcca58-718d5ded3b3mr6499b3a.1.1725639219752; Fri, 06 Sep 2024 09:13:39
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  6 Sep 2024 09:13:37 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.46.0.469.g59c65b2a67-goog
Message-ID: <20240906161337.1118412-1-seanjc@google.com>
Subject: [PATCH] KVM: x86: Forcibly leave nested if RSM to L2 hits shutdown
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+988d9efcdf137bc05f66@syzkaller.appspotmail.com, 
	Zheyu Ma <zheyuma97@gmail.com>, Kishen Maloor <kishen.maloor@intel.com>
Content-Type: text/plain; charset="UTF-8"

Leave nested mode before synthesizing shutdown (a.k.a. TRIPLE_FAULT) if
RSM fails when resuming L2 (a.k.a. guest mode).  Architecturally, shutdown
on RSM occurs _before_ the transition back to guest mode on both Intel and
AMD.

On Intel, per the SDM pseudocode, SMRAM state is loaded before critical
VMX state:

  restore state normally from SMRAM;
  ...
  CR4.VMXE := value stored internally;
  IF internal storage indicates that the logical processor had been in
     VMX operation (root or non-root)
  THEN
     enter VMX operation (root or non-root);
     restore VMX-critical state as defined in Section 32.14.1;
     ...
     restore current VMCS pointer;
  FI;

AMD's APM is both less clearcut and more explicit.  Because AMD CPUs save
VMCB and guest state in SMRAM itself, given the lack of anything in the
APM to indicate a shutdown in guest mode is possible, a straightforward
reading of the clause on invalid state is that _what_ state is invalid is
irrelevant, i.e. all roads lead to shutdown.

  An RSM causes a processor shutdown if an invalid-state condition is
  found in the SMRAM state-save area.

This fixes a bug found by syzkaller where synthesizing shutdown for L2
led to a nested VM-Exit (if L1 is intercepting shutdown), which in turn
caused KVM to complain about trying to cancel a nested VM-Enter (see
commit 759cbd59674a ("KVM: x86: nSVM/nVMX: set nested_run_pending on VM
entry which is a result of RSM").

Note, Paolo pointed out that KVM shouldn't set nested_run_pending until
after loading SMRAM state.  But as above, that's only half the story, KVM
shouldn't transition to guest mode either.  Unfortunately, fixing that
mess requires rewriting the nVMX and nSVM RSM flows to not piggyback
their nested VM-Enter flows, as executing the nested VM-Enter flows after
loading state from SMRAM would clobber much of said state.

For now, add a FIXME to call out that transitioning to guest mode before
loading state from SMRAM is wrong.

Link: https://lore.kernel.org/all/CABgObfYaUHXyRmsmg8UjRomnpQ0Jnaog9-L2gMjsjkqChjDYUQ@mail.gmail.com
Reported-by: syzbot+988d9efcdf137bc05f66@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/0000000000007a9acb06151e1670@google.com
Reported-by: Zheyu Ma <zheyuma97@gmail.com>
Closes: https://lore.kernel.org/all/CAMhUBjmXMYsEoVYw_M8hSZjBMHh24i88QYm-RY6HDta5YZ7Wgw@mail.gmail.com
Analyzed-by: Michal Wilczynski <michal.wilczynski@intel.com>
Cc: Kishen Maloor <kishen.maloor@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/smm.c | 24 +++++++++++++++++++-----
 arch/x86/kvm/x86.c |  6 ------
 arch/x86/kvm/x86.h |  6 ++++++
 3 files changed, 25 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/smm.c b/arch/x86/kvm/smm.c
index 00e3c27d2a87..85241c0c7f56 100644
--- a/arch/x86/kvm/smm.c
+++ b/arch/x86/kvm/smm.c
@@ -624,17 +624,31 @@ int emulator_leave_smm(struct x86_emulate_ctxt *ctxt)
 #endif
 
 	/*
-	 * Give leave_smm() a chance to make ISA-specific changes to the vCPU
-	 * state (e.g. enter guest mode) before loading state from the SMM
-	 * state-save area.
+	 * FIXME: When resuming L2 (a.k.a. guest mode), the transition to guest
+	 * mode should happen _after_ loading state from SMRAM.  However, KVM
+	 * piggybacks the nested VM-Enter flows (which is wrong for many other
+	 * reasons), and so nSVM/nVMX would clobber state that is loaded from
+	 * SMRAM and from the VMCS/VMCB.
 	 */
 	if (kvm_x86_call(leave_smm)(vcpu, &smram))
 		return X86EMUL_UNHANDLEABLE;
 
 #ifdef CONFIG_X86_64
 	if (guest_cpuid_has(vcpu, X86_FEATURE_LM))
-		return rsm_load_state_64(ctxt, &smram.smram64);
+		ret = rsm_load_state_64(ctxt, &smram.smram64);
 	else
 #endif
-		return rsm_load_state_32(ctxt, &smram.smram32);
+		ret = rsm_load_state_32(ctxt, &smram.smram32);
+
+	/*
+	 * If RSM fails and triggers shutdown, architecturally the shutdown
+	 * occurs *before* the transition to guest mode.  But due to KVM's
+	 * flawed handling of RSM to L2 (see above), the vCPU may already be
+	 * in_guest_mode().  Force the vCPU out of guest mode before delivering
+	 * the shutdown, so that L1 enters shutdown instead of seeing a VM-Exit
+	 * that architecturally shouldn't be possible.
+	 */
+	if (ret != X86EMUL_CONTINUE && is_guest_mode(vcpu))
+		kvm_leave_nested(vcpu);
+	return ret;
 }
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7aecf5b4c148..d00fd0d611bb 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -833,12 +833,6 @@ static void kvm_queue_exception_vmexit(struct kvm_vcpu *vcpu, unsigned int vecto
 	ex->payload = payload;
 }
 
-/* Forcibly leave the nested mode in cases like a vCPU reset */
-static void kvm_leave_nested(struct kvm_vcpu *vcpu)
-{
-	kvm_x86_ops.nested_ops->leave_nested(vcpu);
-}
-
 static void kvm_multiple_exception(struct kvm_vcpu *vcpu,
 		unsigned nr, bool has_error, u32 error_code,
 	        bool has_payload, unsigned long payload, bool reinject)
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index bab6f9c4a790..a84c48ef5278 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -109,6 +109,12 @@ static inline unsigned int __shrink_ple_window(unsigned int val,
 void kvm_service_local_tlb_flush_requests(struct kvm_vcpu *vcpu);
 int kvm_check_nested_events(struct kvm_vcpu *vcpu);
 
+/* Forcibly leave the nested mode in cases like a vCPU reset */
+static inline void kvm_leave_nested(struct kvm_vcpu *vcpu)
+{
+	kvm_x86_ops.nested_ops->leave_nested(vcpu);
+}
+
 static inline bool kvm_vcpu_has_run(struct kvm_vcpu *vcpu)
 {
 	return vcpu->arch.last_vmentry_cpu != -1;

base-commit: 12680d7b8ac4db2eba6237a21a93d2b0e78a52a6
-- 
2.46.0.469.g59c65b2a67-goog


