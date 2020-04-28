Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3A1E1BB674
	for <lists+kvm@lfdr.de>; Tue, 28 Apr 2020 08:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726486AbgD1GXu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Apr 2020 02:23:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726476AbgD1GXs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Apr 2020 02:23:48 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F22DC03C1AC;
        Mon, 27 Apr 2020 23:23:48 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id o185so9831090pgo.3;
        Mon, 27 Apr 2020 23:23:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Z/xnjPHU7knLcRgYbx+btpyqMQDl/s3pOWwSvfXVlgY=;
        b=owxHs7l+7A+uG8W0bVjbMfuIkY0quDeo1nvLcYHFdKmpo5XJQfHvtmZ1jd5MWPRsw6
         +OjGdofLDy52FXwA5IGP2fVFuq1gMV5exS4ccAieDFsgCBwguKlGq82Z1Fu2J7rPIiYH
         T1guNkdrkigC2+nHLPL1DxkS19lQL+hP7aUYP/AcXwYV8mQAPAUSj50Yx+csLe/SM7dK
         TueH9pYExYqnHMGep4s9vDm1jXcv2/m46bzvnuRvbvrmfzyZVXUy5stPOd2Im/707YNe
         Fx2/zaieEEVTuzum3ABd0HDM9tLGHktp7QXzJts05AObtRn/hMDXr31vIGn9Y6shMGED
         1F8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Z/xnjPHU7knLcRgYbx+btpyqMQDl/s3pOWwSvfXVlgY=;
        b=Uh0lG7hjvgCB5dioWZmfoc7l7FfY+J2KIo2MNPJIqoyj3azG2C422mjO2t6bhrkGvB
         aii/4YBCr2pXHeuMQ3D7cRJgMHx0r5yafGJBEwkCGW8NIBz/aReWYle7MICUS5ZBAO5m
         YU1fBSHKPYHPmU9Fnxo1hVwBejPHWm3vu7SJE7clSrpTE3D3+bz90lz2kA7+dYM3hcQs
         9E2rJQ9iBviSt8msD90b9Swa0XT0MbdtIlWpu+Z/rcsa4aNbmIfA3zdvHjo5JJ6p+K+H
         EstYnhU8BV61LA94p7BtP0oalrOgsqFYxzqTckvFQ0ZlokWUrQY/Vo6KXQHtfyALJedp
         Potw==
X-Gm-Message-State: AGi0PuYpNLCVBdjjfHcums6oIYKfqUe+CkXCRqOEk2cRTEWS79SDvIVn
        rDNT82vGPI1OoAmk0E98UZidwiv8
X-Google-Smtp-Source: APiQypLOFFWPsFWGiJ0Efux7mcQE7puOEXXe+W6xOaW1QMsCNAY5wPE6v6hyQDcnjFZuJv2R9e7pQQ==
X-Received: by 2002:a62:3607:: with SMTP id d7mr27935128pfa.245.1588055027847;
        Mon, 27 Apr 2020 23:23:47 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id u188sm14183071pfu.33.2020.04.27.23.23.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 Apr 2020 23:23:47 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Haiwei Li <lihaiwei@tencent.com>
Subject: [PATCH v4 3/7] KVM: X86: Introduce more exit_fastpath_completion enum values
Date:   Tue, 28 Apr 2020 14:23:25 +0800
Message-Id: <1588055009-12677-4-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1588055009-12677-1-git-send-email-wanpengli@tencent.com>
References: <1588055009-12677-1-git-send-email-wanpengli@tencent.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Introduce another two exit_fastpath_completion enum values.

- EXIT_FASTPATH_REENTER_GUEST complete fastpath and there is no other stuff
                              prevents enter guest again immediately.
- EXIT_FASTPATH_NOP           kvm will still go through it's full run loop,
                              but it would skip invoking the exit handler.
They will be used by later patch, in addition, adds a fastpath_t typedef since
enum lines are a bit long.

Tested-by: Haiwei Li <lihaiwei@tencent.com>
Cc: Haiwei Li <lihaiwei@tencent.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/include/asm/kvm_host.h | 3 +++
 arch/x86/kvm/svm/svm.c          | 9 ++++-----
 arch/x86/kvm/vmx/vmx.c          | 9 ++++-----
 arch/x86/kvm/x86.c              | 4 ++--
 arch/x86/kvm/x86.h              | 2 +-
 5 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 7cd68d1..1535484 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -188,7 +188,10 @@ enum {
 enum exit_fastpath_completion {
 	EXIT_FASTPATH_NONE,
 	EXIT_FASTPATH_SKIP_EMUL_INS,
+	EXIT_FASTPATH_REENTER_GUEST,
+	EXIT_FASTPATH_NOP,
 };
+typedef enum exit_fastpath_completion fastpath_t;
 
 struct x86_emulate_ctxt;
 struct x86_exception;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 1e7220e..26f623f 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2911,8 +2911,7 @@ static void svm_get_exit_info(struct kvm_vcpu *vcpu, u64 *info1, u64 *info2)
 	*info2 = control->exit_info_2;
 }
 
-static int handle_exit(struct kvm_vcpu *vcpu,
-	enum exit_fastpath_completion exit_fastpath)
+static int handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	struct kvm_run *kvm_run = vcpu->run;
@@ -3342,7 +3341,7 @@ static void svm_cancel_injection(struct kvm_vcpu *vcpu)
 	svm_complete_interrupts(svm);
 }
 
-static enum exit_fastpath_completion svm_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
+static fastpath_t svm_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
 {
 	if (!is_guest_mode(vcpu) && vcpu->arch.apicv_active &&
 	    to_svm(vcpu)->vmcb->control.exit_code == SVM_EXIT_MSR &&
@@ -3354,9 +3353,9 @@ static enum exit_fastpath_completion svm_exit_handlers_fastpath(struct kvm_vcpu
 
 void __svm_vcpu_run(unsigned long vmcb_pa, unsigned long *regs);
 
-static enum exit_fastpath_completion svm_vcpu_run(struct kvm_vcpu *vcpu)
+static fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 {
-	enum exit_fastpath_completion exit_fastpath;
+	fastpath_t exit_fastpath;
 	struct vcpu_svm *svm = to_svm(vcpu);
 
 	svm->vmcb->save.rax = vcpu->arch.regs[VCPU_REGS_RAX];
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index f207004..e12a42e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5881,8 +5881,7 @@ void dump_vmcs(void)
  * The guest has exited.  See if we can fix it or if we need userspace
  * assistance.
  */
-static int vmx_handle_exit(struct kvm_vcpu *vcpu,
-	enum exit_fastpath_completion exit_fastpath)
+static int vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	u32 exit_reason = vmx->exit_reason;
@@ -6583,7 +6582,7 @@ void vmx_update_host_rsp(struct vcpu_vmx *vmx, unsigned long host_rsp)
 	}
 }
 
-static enum exit_fastpath_completion vmx_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
+static fastpath_t vmx_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
 {
 	if (!is_guest_mode(vcpu) && vcpu->arch.apicv_active) {
 		switch (to_vmx(vcpu)->exit_reason) {
@@ -6599,9 +6598,9 @@ static enum exit_fastpath_completion vmx_exit_handlers_fastpath(struct kvm_vcpu
 
 bool __vmx_vcpu_run(struct vcpu_vmx *vmx, unsigned long *regs, bool launched);
 
-static enum exit_fastpath_completion vmx_vcpu_run(struct kvm_vcpu *vcpu)
+static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 {
-	enum exit_fastpath_completion exit_fastpath;
+	fastpath_t exit_fastpath;
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	unsigned long cr3, cr4;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 856b6fc2..df38b40 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1609,7 +1609,7 @@ static int handle_fastpath_set_x2apic_icr_irqoff(struct kvm_vcpu *vcpu, u64 data
 	return 1;
 }
 
-enum exit_fastpath_completion handle_fastpath_set_msr_irqoff(struct kvm_vcpu *vcpu)
+fastpath_t handle_fastpath_set_msr_irqoff(struct kvm_vcpu *vcpu)
 {
 	u32 msr = kvm_rcx_read(vcpu);
 	u64 data;
@@ -8168,7 +8168,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	bool req_int_win =
 		dm_request_for_irq_injection(vcpu) &&
 		kvm_cpu_accept_dm_intr(vcpu);
-	enum exit_fastpath_completion exit_fastpath;
+	fastpath_t exit_fastpath;
 
 	bool req_immediate_exit = false;
 
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 7b5ed8e..2f02dc0 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -274,7 +274,7 @@ bool kvm_mtrr_check_gfn_range_consistency(struct kvm_vcpu *vcpu, gfn_t gfn,
 bool kvm_vector_hashing_enabled(void);
 int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 			    int emulation_type, void *insn, int insn_len);
-enum exit_fastpath_completion handle_fastpath_set_msr_irqoff(struct kvm_vcpu *vcpu);
+fastpath_t handle_fastpath_set_msr_irqoff(struct kvm_vcpu *vcpu);
 
 extern u64 host_xcr0;
 extern u64 supported_xcr0;
-- 
2.7.4

