Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26C013620CB
	for <lists+kvm@lfdr.de>; Fri, 16 Apr 2021 15:22:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235707AbhDPNT1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Apr 2021 09:19:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244154AbhDPNSs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Apr 2021 09:18:48 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F586C06138F
        for <kvm@vger.kernel.org>; Fri, 16 Apr 2021 06:18:23 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id g12-20020a056a001a0cb0290249be0baf34so4339383pfv.16
        for <kvm@vger.kernel.org>; Fri, 16 Apr 2021 06:18:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=dRdITr/WAmVG+vGnM9+wlguJ2Mdi3htGhTv4Io0hgA8=;
        b=CZXAojx61Q/unYRZ5zqN2+IWMvwl2CU/NpA9fhYVkraHC9oASxluDjY/PTA3QGZms+
         zgakCmMPhuT17N1rWYHVAJcHoE4ZwWHYvajUnyda2dnS5SD8MftRzr2zaXFPf76EoAbl
         486S857tTSCQJks0hkkYuRIQTpw5RR1EKfEez3Li0wNbRzjww+BRuAVkeWLETjYjdr0H
         NahfCJEop043yTifJ+xj/UBBJsm+mrq7vlVSzrglGupq7Eynr/aYEE7q8tez6J6Wj9RX
         qpBU9a3Cw8N5npn/rAkvl48mHUAiAMEtw1dcVGU0o9/x+swhpixqnl+Hrg8Abel62kse
         elCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=dRdITr/WAmVG+vGnM9+wlguJ2Mdi3htGhTv4Io0hgA8=;
        b=fn+/djdfi3/MtFV8T4FVGKo8dJC0/DdhlTI3qPVPPsY0VOnGo/4xwuR2xyuuTy+3nH
         StyMVoXSMNC/QDWnhewe8aBcNoNMsAOjENeBYjIXJNZDNjN41qu1zjL3HAw48RDrIiIo
         x7ZA4No8Sad/6EdecUgIv9XxTxfgpJPG0EbnQU3Ssz/X4NENbePZHkRcIeWzBkLgG4Tb
         9WqjOu5TNL4O9mRSnSCdMvIu5t4HdToUP2+eyrKC3yeDEANs4HOn1ah5vZRniGtjngiU
         pplM8ZeYR9CzZvEed1TOuzcm/Pq5WQUqRB8ah+HT2J62ybu6psrtlt6qt6MfzRcXHX/n
         2z5Q==
X-Gm-Message-State: AOAM531S7tdcaE0/mi+MMn4FPZsHBKnHSm8ZvzIe4aLFWFhh7tXkFx7J
        K4ENb/uLUlqvVVgMsvpHXgzN1sBoEhJTP9Cf
X-Google-Smtp-Source: ABdhPJyKo0cpr7DC5vTQCQ82ICNsJ2RqFNCBII1Zd4iplZUrouzgxBri9bJtFsgoI+9hzNnIomXrLg9miKXr7NCU
X-Received: from aaronlewis1.sea.corp.google.com ([2620:15c:100:202:d536:4bae:c7e2:ec6a])
 (user=aaronlewis job=sendgmr) by 2002:a17:903:3106:b029:e9:15e8:250e with
 SMTP id w6-20020a1709033106b02900e915e8250emr9686942plc.33.1618579103064;
 Fri, 16 Apr 2021 06:18:23 -0700 (PDT)
Date:   Fri, 16 Apr 2021 06:18:19 -0700
Message-Id: <20210416131820.2566571-1-aaronlewis@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.1.368.gbe11c130af-goog
Subject: [PATCH 1/2] kvm: x86: Allow userspace to handle emulation errors
From:   Aaron Lewis <aaronlewis@google.com>
To:     david.edmondson@oracle.com
Cc:     jmattson@google.com, seanjc@google.com, kvm@vger.kernel.org,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a fallback mechanism to the in-kernel instruction emulator that
allows userspace the opportunity to process an instruction the emulator
was unable to.  When the in-kernel instruction emulator fails to process
an instruction it will either inject a #UD into the guest or exit to
userspace with exit reason KVM_INTERNAL_ERROR.  This is because it does
not know how to proceed in an appropriate manner.  This feature lets
userspace get involved to see if it can figure out a better path
forward.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
Change-Id: If9876bc73d26f6c3ff9a8bce177c2fc6f160e629
---
 Documentation/virt/kvm/api.rst  | 16 ++++++++++++++++
 arch/x86/include/asm/kvm_host.h |  6 ++++++
 arch/x86/kvm/x86.c              | 33 +++++++++++++++++++++++++++++----
 include/uapi/linux/kvm.h        | 20 ++++++++++++++++++++
 tools/include/uapi/linux/kvm.h  | 20 ++++++++++++++++++++
 5 files changed, 91 insertions(+), 4 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 307f2fcf1b02..f8278e893fbe 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6233,6 +6233,22 @@ KVM_RUN_BUS_LOCK flag is used to distinguish between them.
 This capability can be used to check / enable 2nd DAWR feature provided
 by POWER10 processor.
 
+7.24 KVM_CAP_EXIT_ON_EMULATION_FAILURE
+--------------------------------------
+
+:Architectures: x86
+:Parameters: args[0] whether the feature should be enabled or not
+
+With this capability enabled, the in-kernel instruction emulator packs the exit
+struct of KVM_INTERNAL_ERROR with the instruction length and instruction bytes
+when an error occurs while emulating an instruction.  This allows userspace to
+then take a look at the instruction and see if it is able to handle it more
+gracefully than the in-kernel emulator.
+
+When this capability is enabled use the emulation_failure struct instead of the
+internal struct for the exit struct.  They have the same layout, but the
+emulation_failure struct matches the content better.
+
 8. Other capabilities.
 ======================
 
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3768819693e5..07235d08e976 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1049,6 +1049,12 @@ struct kvm_arch {
 	bool exception_payload_enabled;
 
 	bool bus_lock_detection_enabled;
+	/*
+	 * If exit_on_emulation_error is set, and the in-kernel instruction
+	 * emulator fails to emulate an instruction, allow userspace
+	 * the opportunity to look at it.
+	 */
+	bool exit_on_emulation_error;
 
 	/* Deflect RDMSR and WRMSR to user space when they trigger a #GP */
 	u32 user_space_msr_mask;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index eca63625aee4..f9a207f815fb 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3771,6 +3771,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_X86_USER_SPACE_MSR:
 	case KVM_CAP_X86_MSR_FILTER:
 	case KVM_CAP_ENFORCE_PV_FEATURE_CPUID:
+	case KVM_CAP_EXIT_ON_EMULATION_FAILURE:
 		r = 1;
 		break;
 #ifdef CONFIG_KVM_XEN
@@ -5357,6 +5358,10 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 			kvm->arch.bus_lock_detection_enabled = true;
 		r = 0;
 		break;
+	case KVM_CAP_EXIT_ON_EMULATION_FAILURE:
+		kvm->arch.exit_on_emulation_error = cap->args[0];
+		r = 0;
+		break;
 	default:
 		r = -EINVAL;
 		break;
@@ -7119,8 +7124,29 @@ void kvm_inject_realmode_interrupt(struct kvm_vcpu *vcpu, int irq, int inc_eip)
 }
 EXPORT_SYMBOL_GPL(kvm_inject_realmode_interrupt);
 
+static void prepare_emulation_failure_exit(struct kvm_vcpu *vcpu)
+{
+	struct x86_emulate_ctxt *ctxt = vcpu->arch.emulate_ctxt;
+	u64 insn_size = ctxt->fetch.end - ctxt->fetch.data;
+	struct kvm *kvm = vcpu->kvm;
+
+	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
+	vcpu->run->emulation_failure.suberror = KVM_INTERNAL_ERROR_EMULATION;
+	vcpu->run->emulation_failure.ndata = 0;
+	if (kvm->arch.exit_on_emulation_error && insn_size > 0) {
+		vcpu->run->emulation_failure.ndata = 3;
+		vcpu->run->emulation_failure.flags =
+			KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES;
+		vcpu->run->emulation_failure.insn_size = insn_size;
+		memcpy(vcpu->run->emulation_failure.insn_bytes,
+		       ctxt->fetch.data, sizeof(ctxt->fetch.data));
+	}
+}
+
 static int handle_emulation_failure(struct kvm_vcpu *vcpu, int emulation_type)
 {
+	struct kvm *kvm = vcpu->kvm;
+
 	++vcpu->stat.insn_emulation_fail;
 	trace_kvm_emulate_insn_failed(vcpu);
 
@@ -7129,10 +7155,9 @@ static int handle_emulation_failure(struct kvm_vcpu *vcpu, int emulation_type)
 		return 1;
 	}
 
-	if (emulation_type & EMULTYPE_SKIP) {
-		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
-		vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
-		vcpu->run->internal.ndata = 0;
+	if (kvm->arch.exit_on_emulation_error ||
+	    (emulation_type & EMULTYPE_SKIP)) {
+		prepare_emulation_failure_exit(vcpu);
 		return 0;
 	}
 
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index f6afee209620..7c77099235b2 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -279,6 +279,17 @@ struct kvm_xen_exit {
 /* Encounter unexpected vm-exit reason */
 #define KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON	4
 
+/*
+ * When using the suberror KVM_INTERNAL_ERROR_EMULATION, these flags are used
+ * to describe what is contained in the exit struct.  The flags are used to
+ * describe it's contents, and the contents should be in ascending numerical
+ * order of the flag values.  For example, if the flag
+ * KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES is set, the instruction
+ * length and instruction bytes would be expected to show up first because this
+ * flag has the lowest numerical value (1) of all the other flags.
+ */
+#define KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES (1ULL << 0)
+
 /* for KVM_RUN, returned by mmap(vcpu_fd, offset=0) */
 struct kvm_run {
 	/* in */
@@ -382,6 +393,14 @@ struct kvm_run {
 			__u32 ndata;
 			__u64 data[16];
 		} internal;
+		/* KVM_EXIT_INTERNAL_ERROR, too (not 2) */
+		struct {
+			__u32 suberror;
+			__u32 ndata;
+			__u64 flags;
+			__u8  insn_size;
+			__u8  insn_bytes[15];
+		} emulation_failure;
 		/* KVM_EXIT_OSI */
 		struct {
 			__u64 gprs[32];
@@ -1078,6 +1097,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_DIRTY_LOG_RING 192
 #define KVM_CAP_X86_BUS_LOCK_EXIT 193
 #define KVM_CAP_PPC_DAWR1 194
+#define KVM_CAP_EXIT_ON_EMULATION_FAILURE 195
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
index f6afee209620..7c77099235b2 100644
--- a/tools/include/uapi/linux/kvm.h
+++ b/tools/include/uapi/linux/kvm.h
@@ -279,6 +279,17 @@ struct kvm_xen_exit {
 /* Encounter unexpected vm-exit reason */
 #define KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON	4
 
+/*
+ * When using the suberror KVM_INTERNAL_ERROR_EMULATION, these flags are used
+ * to describe what is contained in the exit struct.  The flags are used to
+ * describe it's contents, and the contents should be in ascending numerical
+ * order of the flag values.  For example, if the flag
+ * KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES is set, the instruction
+ * length and instruction bytes would be expected to show up first because this
+ * flag has the lowest numerical value (1) of all the other flags.
+ */
+#define KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES (1ULL << 0)
+
 /* for KVM_RUN, returned by mmap(vcpu_fd, offset=0) */
 struct kvm_run {
 	/* in */
@@ -382,6 +393,14 @@ struct kvm_run {
 			__u32 ndata;
 			__u64 data[16];
 		} internal;
+		/* KVM_EXIT_INTERNAL_ERROR, too (not 2) */
+		struct {
+			__u32 suberror;
+			__u32 ndata;
+			__u64 flags;
+			__u8  insn_size;
+			__u8  insn_bytes[15];
+		} emulation_failure;
 		/* KVM_EXIT_OSI */
 		struct {
 			__u64 gprs[32];
@@ -1078,6 +1097,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_DIRTY_LOG_RING 192
 #define KVM_CAP_X86_BUS_LOCK_EXIT 193
 #define KVM_CAP_PPC_DAWR1 194
+#define KVM_CAP_EXIT_ON_EMULATION_FAILURE 195
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.31.1.368.gbe11c130af-goog

