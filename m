Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D496A1C75D5
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 18:11:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730159AbgEFQLE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 12:11:04 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:46508 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730126AbgEFQLB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 May 2020 12:11:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588781459;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=8Mt6G6BJwDu44gd1957c98ihTzD3Zg/wUvVRyY82XSk=;
        b=XFHDJXrU3bK8lXjGnAQqKO0hW0EPZFC3VJKDqYZva+wuxGkTADqNwAKvEKX+xyzyZ39k7d
        bE80xefG2DPWxmYGpweffl0VjVzwjit9sQHXy+gmT5BUKHp0UYRb9LVpjHyelP+hPi5lLr
        CyzaO1paV5ouJPu23RnppyMuLh1xb30=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-252-zDzPutfFMQeZouX-OnUhqg-1; Wed, 06 May 2020 12:10:54 -0400
X-MC-Unique: zDzPutfFMQeZouX-OnUhqg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C16988014C0;
        Wed,  6 May 2020 16:10:53 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 02859165F6;
        Wed,  6 May 2020 16:10:52 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     wanpengli@tencent.com, linxl3@wangsu.com,
        Haiwei Li <lihaiwei@tencent.com>
Subject: [PATCH 3/7] KVM: X86: Introduce more exit_fastpath_completion enum values
Date:   Wed,  6 May 2020 12:10:44 -0400
Message-Id: <20200506161048.28840-4-pbonzini@redhat.com>
In-Reply-To: <20200506161048.28840-1-pbonzini@redhat.com>
References: <20200506161048.28840-1-pbonzini@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Adds a fastpath_t typedef since enum lines are a bit long, and replace
EXIT_FASTPATH_SKIP_EMUL_INS with two new exit_fastpath_completion enum values.

- EXIT_FASTPATH_EXIT_HANDLED  kvm will still go through it's full run loop,
                              but it would skip invoking the exit handler.

- EXIT_FASTPATH_REENTER_GUEST complete fastpath, guest can be re-entered
                              without invoking the exit handler or going
                              back to vcpu_run

Tested-by: Haiwei Li <lihaiwei@tencent.com>
Cc: Haiwei Li <lihaiwei@tencent.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
Message-Id: <1588055009-12677-4-git-send-email-wanpengli@tencent.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  4 +++-
 arch/x86/kvm/svm/svm.c          | 15 +++++++--------
 arch/x86/kvm/vmx/vmx.c          | 26 ++++++++++++++++++--------
 arch/x86/kvm/x86.c              | 19 ++++++++++---------
 arch/x86/kvm/x86.h              |  2 +-
 5 files changed, 39 insertions(+), 27 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index cf6b0aff86c3..35a915787559 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -182,8 +182,10 @@ enum {
 
 enum exit_fastpath_completion {
 	EXIT_FASTPATH_NONE,
-	EXIT_FASTPATH_SKIP_EMUL_INS,
+	EXIT_FASTPATH_REENTER_GUEST,
+	EXIT_FASTPATH_EXIT_HANDLED,
 };
+typedef enum exit_fastpath_completion fastpath_t;
 
 struct x86_emulate_ctxt;
 struct x86_exception;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index beab68dcbb7c..56c04d85ab60 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2890,8 +2890,7 @@ static void svm_get_exit_info(struct kvm_vcpu *vcpu, u64 *info1, u64 *info2)
 	*info2 = control->exit_info_2;
 }
 
-static int handle_exit(struct kvm_vcpu *vcpu,
-	enum exit_fastpath_completion exit_fastpath)
+static int handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	struct kvm_run *kvm_run = vcpu->run;
@@ -2949,10 +2948,10 @@ static int handle_exit(struct kvm_vcpu *vcpu,
 		       __func__, svm->vmcb->control.exit_int_info,
 		       exit_code);
 
-	if (exit_fastpath == EXIT_FASTPATH_SKIP_EMUL_INS) {
-		kvm_skip_emulated_instruction(vcpu);
+	if (exit_fastpath != EXIT_FASTPATH_NONE)
 		return 1;
-	} else if (exit_code >= ARRAY_SIZE(svm_exit_handlers)
+
+	if (exit_code >= ARRAY_SIZE(svm_exit_handlers)
 	    || !svm_exit_handlers[exit_code]) {
 		vcpu_unimpl(vcpu, "svm: unexpected exit reason 0x%x\n", exit_code);
 		dump_vmcb(vcpu);
@@ -3321,7 +3320,7 @@ static void svm_cancel_injection(struct kvm_vcpu *vcpu)
 	svm_complete_interrupts(svm);
 }
 
-static enum exit_fastpath_completion svm_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
+static fastpath_t svm_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
 {
 	if (!is_guest_mode(vcpu) &&
 	    to_svm(vcpu)->vmcb->control.exit_code == SVM_EXIT_MSR &&
@@ -3333,9 +3332,9 @@ static enum exit_fastpath_completion svm_exit_handlers_fastpath(struct kvm_vcpu
 
 void __svm_vcpu_run(unsigned long vmcb_pa, unsigned long *regs);
 
-static enum exit_fastpath_completion svm_vcpu_run(struct kvm_vcpu *vcpu)
+static fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 {
-	enum exit_fastpath_completion exit_fastpath;
+	fastpath_t exit_fastpath;
 	struct vcpu_svm *svm = to_svm(vcpu);
 
 	svm->vmcb->save.rax = vcpu->arch.regs[VCPU_REGS_RAX];
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index ad57c4744b99..215ae9682da1 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5900,8 +5900,7 @@ void dump_vmcs(void)
  * The guest has exited.  See if we can fix it or if we need userspace
  * assistance.
  */
-static int vmx_handle_exit(struct kvm_vcpu *vcpu,
-	enum exit_fastpath_completion exit_fastpath)
+static int vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	u32 exit_reason = vmx->exit_reason;
@@ -6008,10 +6007,8 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu,
 		}
 	}
 
-	if (exit_fastpath == EXIT_FASTPATH_SKIP_EMUL_INS) {
-		kvm_skip_emulated_instruction(vcpu);
+	if (exit_fastpath != EXIT_FASTPATH_NONE)
 		return 1;
-	}
 
 	if (exit_reason >= kvm_vmx_max_exit_handlers)
 		goto unexpected_vmexit;
@@ -6602,7 +6599,7 @@ void vmx_update_host_rsp(struct vcpu_vmx *vmx, unsigned long host_rsp)
 	}
 }
 
-static enum exit_fastpath_completion vmx_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
+static fastpath_t vmx_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
 {
 	switch (to_vmx(vcpu)->exit_reason) {
 	case EXIT_REASON_MSR_WRITE:
@@ -6614,12 +6611,13 @@ static enum exit_fastpath_completion vmx_exit_handlers_fastpath(struct kvm_vcpu
 
 bool __vmx_vcpu_run(struct vcpu_vmx *vmx, unsigned long *regs, bool launched);
 
-static enum exit_fastpath_completion vmx_vcpu_run(struct kvm_vcpu *vcpu)
+static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 {
-	enum exit_fastpath_completion exit_fastpath;
+	fastpath_t exit_fastpath;
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	unsigned long cr3, cr4;
 
+reenter_guest:
 	/* Record the guest's net vcpu time for enforced NMI injections. */
 	if (unlikely(!enable_vnmi &&
 		     vmx->loaded_vmcs->soft_vnmi_blocked))
@@ -6798,6 +6796,18 @@ static enum exit_fastpath_completion vmx_vcpu_run(struct kvm_vcpu *vcpu)
 		return EXIT_FASTPATH_NONE;
 
 	exit_fastpath = vmx_exit_handlers_fastpath(vcpu);
+	if (exit_fastpath == EXIT_FASTPATH_REENTER_GUEST) {
+		if (!kvm_vcpu_exit_request(vcpu)) {
+			/*
+			 * FIXME: this goto should be a loop in vcpu_enter_guest,
+			 * but it would incur the cost of a retpoline for now.
+			 * Revisit once static calls are available.
+			 */
+			goto reenter_guest;
+		}
+		exit_fastpath = EXIT_FASTPATH_EXIT_HANDLED;
+	}
+
 	return exit_fastpath;
 }
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 999275795bba..98e5b79063b7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1616,27 +1616,28 @@ static int handle_fastpath_set_x2apic_icr_irqoff(struct kvm_vcpu *vcpu, u64 data
 	return 1;
 }
 
-enum exit_fastpath_completion handle_fastpath_set_msr_irqoff(struct kvm_vcpu *vcpu)
+fastpath_t handle_fastpath_set_msr_irqoff(struct kvm_vcpu *vcpu)
 {
 	u32 msr = kvm_rcx_read(vcpu);
 	u64 data;
-	int ret = 0;
+	fastpath_t ret = EXIT_FASTPATH_NONE;
 
 	switch (msr) {
 	case APIC_BASE_MSR + (APIC_ICR >> 4):
 		data = kvm_read_edx_eax(vcpu);
-		ret = handle_fastpath_set_x2apic_icr_irqoff(vcpu, data);
+		if (!handle_fastpath_set_x2apic_icr_irqoff(vcpu, data)) {
+			kvm_skip_emulated_instruction(vcpu);
+			ret = EXIT_FASTPATH_EXIT_HANDLED;
+               }
 		break;
 	default:
-		return EXIT_FASTPATH_NONE;
+		break;
 	}
 
-	if (!ret) {
+	if (ret != EXIT_FASTPATH_NONE)
 		trace_kvm_msr_write(msr, data);
-		return EXIT_FASTPATH_SKIP_EMUL_INS;
-	}
 
-	return EXIT_FASTPATH_NONE;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(handle_fastpath_set_msr_irqoff);
 
@@ -8174,7 +8175,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	bool req_int_win =
 		dm_request_for_irq_injection(vcpu) &&
 		kvm_cpu_accept_dm_intr(vcpu);
-	enum exit_fastpath_completion exit_fastpath;
+	fastpath_t exit_fastpath;
 
 	bool req_immediate_exit = false;
 
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index e02fe28254b6..6eb62e97e59f 100644
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
2.18.2


