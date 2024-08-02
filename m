Return-Path: <kvm+bounces-23123-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DFBC94641E
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 21:53:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 915631C219CB
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 19:53:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80D5213A404;
	Fri,  2 Aug 2024 19:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QMmrmz1H"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3290D1369B0
	for <kvm@vger.kernel.org>; Fri,  2 Aug 2024 19:51:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722628293; cv=none; b=ts83TpFfFFzn7w6C8K7H7C+mGgr4gcsW6zYO3QEsLUCfGFtrUETFEq/fqsZj0RC6QuzOPxtANH71qoAJsy06c7nRrh1Aqv40OuLkRsmkgn6P7E5npaSOHw2tik/JP3TY70RjhpPCXtUxXd+1RFIiVsezFb6UFSonbCCE1Eo4Ppk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722628293; c=relaxed/simple;
	bh=mqE0o9zRwOx1Mn/Z6tsZ+L0NFQbPg40KmGQ99XrGl84=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NVt9AIDSmUmdg3+L6gv7+fJX9YYZAUfmFyQfOyPotLS8wDsWy4Bu3bskCdqPWwmqGRRUyAiyuzE3dnBzKF4Z+e402Q/FnMtpuv+f0mvUU8nC1HdwH5AcjMxbEkBTl4lmVGd40AZIlfWLk5LLseIPTjI0hkfl55SM9ONZ5iyNm1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QMmrmz1H; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1fc6db23c74so85327765ad.0
        for <kvm@vger.kernel.org>; Fri, 02 Aug 2024 12:51:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722628291; x=1723233091; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=nbb8wMxDZTZlGNXuFp2fO6u+E/pERXdN8QklXoMJTsY=;
        b=QMmrmz1HJQVD/3afA/OZM4byS7A4t0tDwa96junvLXjETMtlfpsxI/k0o1g2EjAWmG
         ZRtz8sWCitc8VPrmvrpdbYMJGbcR0Ao2GogV8gD4TtWElUgSAIw+v+86xCeZuhEReUe8
         GtAUaEuG7n1ux6Y8VgyPaxCu/R2IXLu3lMUjcO/gmsWTpyXgIV810ML+l+ZOqEgqeVj8
         Vm8wyfKq724oBn9g21HxhKVnV633B02qrh60uzZIKynAzEbx4S1g5m/EthBtBsKE3OFB
         Q/VRIaBQuafAXKoXGM68fXkk1j9dL8J2CshKVfoKw62HeOQ7Ihmw3q2qzbvzS/C/s1oM
         amMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722628291; x=1723233091;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nbb8wMxDZTZlGNXuFp2fO6u+E/pERXdN8QklXoMJTsY=;
        b=ONDOf0NS07QvJXVUYroD7NPVLxGzWu3JSkBcIwwj/VNbvKLsIZZvYywMkHYlpztkFo
         jMI6ajKr2xjDwlGJTbGsfVs5QtoIL1wetId5MiwxFJrLHHu2S69885tzvvqzi491MG1t
         GYbUKDMZgbrgptRq6UQAAT1djBB4SOp9M8N6Q9Bs68jtMiWG8mtTixzFYdOQ/o+pZzud
         5yVM2cfgNAl/57k/gQHosCD89lwbu64zfbIMy9aCfXEOC79e93lVlcsiRX06Sj2rxQ/V
         z0iXjeI/kgRjU6K+sAxNYnhAaDprIGR8w4pClynQrJ7s2XCqIM69EskdEyUoyTvXA9Az
         SV/A==
X-Gm-Message-State: AOJu0YypHPCLOtqhDt24sHc38Kqg2GdmRtslGZHDCTx/VZHhj558PlbQ
	To5F6Go0oWlBaz4gRgnTL43oAAy5rw+RxuovQ5ZIwHl0+e3LgaqnM99cAuSq9XgM/Wcrp0msPYt
	fgg==
X-Google-Smtp-Source: AGHT+IEeAJQqKfvBQKb2VjxpO0q2I+GKyZiMO8d1EwpY/xEJMhUHvJjVefCWVqCWyOQEcOEK5i7Edt5hsBM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:c38c:b0:1fb:7f2c:5642 with SMTP id
 d9443c01a7336-1ff5730306cmr2707885ad.4.1722628291438; Fri, 02 Aug 2024
 12:51:31 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  2 Aug 2024 12:51:20 -0700
In-Reply-To: <20240802195120.325560-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240802195120.325560-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc2.264.g509ed76dc8-goog
Message-ID: <20240802195120.325560-6-seanjc@google.com>
Subject: [PATCH 5/5] KVM: x86: Add fastpath handling of HLT VM-Exits
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Add a fastpath for HLT VM-Exits by immediately re-entering the guest if
it has a pending wake event.  When virtual interrupt delivery is enabled,
i.e. when KVM doesn't need to manually inject interrupts, this allows KVM
to stay in the fastpath run loop when a vIRQ arrives between the guest
doing CLI and STI;HLT.  Without AMD's Idle HLT-intercept support, the CPU
generates a HLT VM-Exit even though KVM will immediately resume the guest.

Note, on bare metal, it's relatively uncommon for a modern guest kernel to
actually trigger this scenario, as the window between the guest checking
for a wake event and committing to HLT is quite small.  But in a nested
environment, the timings change significantly, e.g. rudimentary testing
showed that ~50% of HLT exits where HLT-polling was successful would be
serviced by this fastpath, i.e. ~50% of the time that a nested vCPU gets
a wake event before KVM schedules out the vCPU, the wake event was pending
even before the VM-Exit.

Link: https://lore.kernel.org/all/20240528041926.3989-3-manali.shukla@amd.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 13 +++++++++++--
 arch/x86/kvm/vmx/vmx.c |  2 ++
 arch/x86/kvm/x86.c     | 23 ++++++++++++++++++++++-
 arch/x86/kvm/x86.h     |  1 +
 4 files changed, 36 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index c115d26844f7..64381ff63034 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4144,12 +4144,21 @@ static int svm_vcpu_pre_run(struct kvm_vcpu *vcpu)
 
 static fastpath_t svm_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
 {
+	struct vcpu_svm *svm = to_svm(vcpu);
+
 	if (is_guest_mode(vcpu))
 		return EXIT_FASTPATH_NONE;
 
-	if (to_svm(vcpu)->vmcb->control.exit_code == SVM_EXIT_MSR &&
-	    to_svm(vcpu)->vmcb->control.exit_info_1)
+	switch (svm->vmcb->control.exit_code) {
+	case SVM_EXIT_MSR:
+		if (!svm->vmcb->control.exit_info_1)
+			break;
 		return handle_fastpath_set_msr_irqoff(vcpu);
+	case SVM_EXIT_HLT:
+		return handle_fastpath_hlt(vcpu);
+	default:
+		break;
+	}
 
 	return EXIT_FASTPATH_NONE;
 }
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index f18c2d8c7476..f6382750fbf0 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7265,6 +7265,8 @@ static fastpath_t vmx_exit_handlers_fastpath(struct kvm_vcpu *vcpu,
 		return handle_fastpath_set_msr_irqoff(vcpu);
 	case EXIT_REASON_PREEMPTION_TIMER:
 		return handle_fastpath_preemption_timer(vcpu, force_immediate_exit);
+	case EXIT_REASON_HLT:
+		return handle_fastpath_hlt(vcpu);
 	default:
 		return EXIT_FASTPATH_NONE;
 	}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 46686504cd47..eb5ea963698f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11373,7 +11373,10 @@ static int __kvm_emulate_halt(struct kvm_vcpu *vcpu, int state, int reason)
 	 */
 	++vcpu->stat.halt_exits;
 	if (lapic_in_kernel(vcpu)) {
-		vcpu->arch.mp_state = state;
+		if (kvm_vcpu_has_events(vcpu))
+			vcpu->arch.pv.pv_unhalted = false;
+		else
+			vcpu->arch.mp_state = state;
 		return 1;
 	} else {
 		vcpu->run->exit_reason = reason;
@@ -11398,6 +11401,24 @@ int kvm_emulate_halt(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_emulate_halt);
 
+fastpath_t handle_fastpath_hlt(struct kvm_vcpu *vcpu)
+{
+	int ret;
+
+	kvm_vcpu_srcu_read_lock(vcpu);
+	ret = kvm_emulate_halt(vcpu);
+	kvm_vcpu_srcu_read_unlock(vcpu);
+
+	if (!ret)
+		return EXIT_FASTPATH_EXIT_USERSPACE;
+
+	if (kvm_vcpu_running(vcpu))
+		return EXIT_FASTPATH_REENTER_GUEST;
+
+	return EXIT_FASTPATH_EXIT_HANDLED;
+}
+EXPORT_SYMBOL_GPL(handle_fastpath_hlt);
+
 int kvm_emulate_ap_reset_hold(struct kvm_vcpu *vcpu)
 {
 	int ret = kvm_skip_emulated_instruction(vcpu);
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 50596f6f8320..5185ab76fdd2 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -334,6 +334,7 @@ int x86_decode_emulated_instruction(struct kvm_vcpu *vcpu, int emulation_type,
 int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 			    int emulation_type, void *insn, int insn_len);
 fastpath_t handle_fastpath_set_msr_irqoff(struct kvm_vcpu *vcpu);
+fastpath_t handle_fastpath_hlt(struct kvm_vcpu *vcpu);
 
 extern struct kvm_caps kvm_caps;
 extern struct kvm_host_values kvm_host;
-- 
2.46.0.rc2.264.g509ed76dc8-goog


