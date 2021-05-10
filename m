Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0BE937926A
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 17:19:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234947AbhEJPUU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 11:20:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234648AbhEJPSy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 May 2021 11:18:54 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7502C06175F
        for <kvm@vger.kernel.org>; Mon, 10 May 2021 07:48:41 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id o14-20020a05620a130eb02902ea53a6ef80so11709100qkj.6
        for <kvm@vger.kernel.org>; Mon, 10 May 2021 07:48:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=pXf+wxEHe7OgFZweagRPX8zYZei+f+6Ny/B00rMUo8Y=;
        b=kdxiaN5tbOjVAa/SmKd17sTlrKysTv+CTVq7HDDGmRnKvOknp7DCMROGUuxsuYbMgJ
         hmtkw84JovY2kusL7hmM7XMii4LrevXiRtv528IiVINfN+2hYtl2na+zo+F2mar1TXAw
         R9T/wG0yWvAYo7s8p66FhH3OmJs2/X5huT7g6vc7bqnCo8GiuJnigtoAZU5DmdoWNIkv
         Q7Qf2vhrulnU0GRsTGQ/uO4O65nOVrcqHt+RW6Da2zzWjsIwx3QZ6ei+5MxDs3amkFR8
         LgjNj0AIcCORaVvf3n6qOwhhkuYAmzqAQYvKf57wj8VuwoWfQoGnF45P2WvEd9vwlJmg
         3wgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=pXf+wxEHe7OgFZweagRPX8zYZei+f+6Ny/B00rMUo8Y=;
        b=nIsKkS++AkIGIFzC2w7JGVGYMpLqurN2bGiiLedpnxjg+DxKsNzOUvJ2yZqJd2OCDd
         ZlSmH2Hk4iLcxc+HgyWgmISrwcNWZMBvw79o71iZuxqP/GVBpvcXu5igevctqalg1p4X
         bY3QsakwTfoWeCGjFWkUoj2Lz5Nfwm/rK0ZusJWhog3+l4xk3m/F+UOB17FZ+Ioo9ywN
         39r1fe4QCNfprUwwuH6wiizotlOCkFPrOjBrKnoeyzcpWxHDTQ89sS2U+ptOlipYjlep
         MHfleysQ72/pBfEkUmu8GJTo2ZeW9zo1yPrN+DQrQWTUI63HLXPjHRrvo8ePC3ppTJzQ
         perg==
X-Gm-Message-State: AOAM531Cey4kraLBAXXE/olVUndmHztdbfYeNh2NA+mg2/O+Zz9dI1TK
        WSDrP+yxnU/J0snaieXAzOk4NB8Jh7GQtnkE
X-Google-Smtp-Source: ABdhPJwVpttdjaULEKJDQIArIBE5aXJOXZGGdyJ3sSezasaeoOCNo+3rXOaYTQWzCE144HM78JTFpH23eeAlzni9
X-Received: from aaronlewis1.sea.corp.google.com ([2620:15c:100:202:3396:9513:fac0:8ec7])
 (user=aaronlewis job=sendgmr) by 2002:a0c:e30c:: with SMTP id
 s12mr24109312qvl.47.1620658120802; Mon, 10 May 2021 07:48:40 -0700 (PDT)
Date:   Mon, 10 May 2021 07:48:33 -0700
In-Reply-To: <20210510144834.658457-1-aaronlewis@google.com>
Message-Id: <20210510144834.658457-2-aaronlewis@google.com>
Mime-Version: 1.0
References: <20210510144834.658457-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.31.1.607.g51e8a6a459-goog
Subject: [PATCH v6 1/2] kvm: x86: Allow userspace to handle emulation errors
From:   Aaron Lewis <aaronlewis@google.com>
To:     david.edmondson@oracle.com, seanjc@google.com, jmattson@google.com
Cc:     kvm@vger.kernel.org, Aaron Lewis <aaronlewis@google.com>
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
Reviewed-by: David Edmondson <david.edmondson@oracle.com>
---
 Documentation/virt/kvm/api.rst  | 19 +++++++++++++++++
 arch/x86/include/asm/kvm_host.h |  6 ++++++
 arch/x86/kvm/x86.c              | 37 +++++++++++++++++++++++++++++----
 include/uapi/linux/kvm.h        | 23 ++++++++++++++++++++
 tools/include/uapi/linux/kvm.h  | 23 ++++++++++++++++++++
 5 files changed, 104 insertions(+), 4 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 307f2fcf1b02..17668d3e1cb7 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6233,6 +6233,25 @@ KVM_RUN_BUS_LOCK flag is used to distinguish between them.
 This capability can be used to check / enable 2nd DAWR feature provided
 by POWER10 processor.
 
+7.24 KVM_CAP_EXIT_ON_EMULATION_FAILURE
+--------------------------------------
+
+:Architectures: x86
+:Parameters: args[0] whether the feature should be enabled or not
+
+When this capability is enabled, an emulation failure will result in an exit
+to userspace with KVM_INTERNAL_ERROR (except when the emulator was invoked
+to handle a VMware backdoor instruction). Furthermore, KVM will now provide up
+to 15 instruction bytes for any exit to userspace resulting from an emulation
+failure.  When these exits to userspace occur use the emulation_failure struct
+instead of the internal struct.  They both have the same layout, but the
+emulation_failure struct matches the content better.  It also explicitly
+defines the 'flags' field which is used to describe the fields in the struct
+that are valid (ie: if KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES is
+set in the 'flags' field then both 'insn_size' and 'insn_bytes' have valid data
+in them.)
+
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
index eca63625aee4..703bcc93b129 100644
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
@@ -7119,8 +7124,33 @@ void kvm_inject_realmode_interrupt(struct kvm_vcpu *vcpu, int irq, int inc_eip)
 }
 EXPORT_SYMBOL_GPL(kvm_inject_realmode_interrupt);
 
+static void prepare_emulation_failure_exit(struct kvm_vcpu *vcpu)
+{
+	struct x86_emulate_ctxt *ctxt = vcpu->arch.emulate_ctxt;
+	u32 insn_size = ctxt->fetch.end - ctxt->fetch.data;
+	struct kvm_run *run = vcpu->run;
+
+	run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
+	run->emulation_failure.suberror = KVM_INTERNAL_ERROR_EMULATION;
+	run->emulation_failure.ndata = 0;
+	run->emulation_failure.flags = 0;
+
+	if (insn_size) {
+		run->emulation_failure.ndata = 3;
+		run->emulation_failure.flags |=
+			KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES;
+		run->emulation_failure.insn_size = insn_size;
+		memset(run->emulation_failure.insn_bytes, 0x90,
+		       sizeof(run->emulation_failure.insn_bytes));
+		memcpy(run->emulation_failure.insn_bytes,
+		       ctxt->fetch.data, insn_size);
+	}
+}
+
 static int handle_emulation_failure(struct kvm_vcpu *vcpu, int emulation_type)
 {
+	struct kvm *kvm = vcpu->kvm;
+
 	++vcpu->stat.insn_emulation_fail;
 	trace_kvm_emulate_insn_failed(vcpu);
 
@@ -7129,10 +7159,9 @@ static int handle_emulation_failure(struct kvm_vcpu *vcpu, int emulation_type)
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
index f6afee209620..1bca5d066e3c 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -279,6 +279,9 @@ struct kvm_xen_exit {
 /* Encounter unexpected vm-exit reason */
 #define KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON	4
 
+/* Flags that describe what fields in emulation_failure hold valid data. */
+#define KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES (1ULL << 0)
+
 /* for KVM_RUN, returned by mmap(vcpu_fd, offset=0) */
 struct kvm_run {
 	/* in */
@@ -382,6 +385,25 @@ struct kvm_run {
 			__u32 ndata;
 			__u64 data[16];
 		} internal;
+		/*
+		 * KVM_INTERNAL_ERROR_EMULATION
+		 *
+		 * "struct emulation_failure" is an overlay of "struct internal"
+		 * that is used for the KVM_INTERNAL_ERROR_EMULATION sub-type of
+		 * KVM_EXIT_INTERNAL_ERROR.  Note, unlike other internal error
+		 * sub-types, this struct is ABI!  It also needs to be backwards
+		 * compatible with "struct internal".  Take special care that
+		 * "ndata" is correct, that new fields are enumerated in "flags",
+		 * and that each flag enumerates fields that are 64-bit aligned
+		 * and sized (so that ndata+internal.data[] is valid/accurate).
+		 */
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
@@ -1078,6 +1100,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_DIRTY_LOG_RING 192
 #define KVM_CAP_X86_BUS_LOCK_EXIT 193
 #define KVM_CAP_PPC_DAWR1 194
+#define KVM_CAP_EXIT_ON_EMULATION_FAILURE 195
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
index f6afee209620..1bca5d066e3c 100644
--- a/tools/include/uapi/linux/kvm.h
+++ b/tools/include/uapi/linux/kvm.h
@@ -279,6 +279,9 @@ struct kvm_xen_exit {
 /* Encounter unexpected vm-exit reason */
 #define KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON	4
 
+/* Flags that describe what fields in emulation_failure hold valid data. */
+#define KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES (1ULL << 0)
+
 /* for KVM_RUN, returned by mmap(vcpu_fd, offset=0) */
 struct kvm_run {
 	/* in */
@@ -382,6 +385,25 @@ struct kvm_run {
 			__u32 ndata;
 			__u64 data[16];
 		} internal;
+		/*
+		 * KVM_INTERNAL_ERROR_EMULATION
+		 *
+		 * "struct emulation_failure" is an overlay of "struct internal"
+		 * that is used for the KVM_INTERNAL_ERROR_EMULATION sub-type of
+		 * KVM_EXIT_INTERNAL_ERROR.  Note, unlike other internal error
+		 * sub-types, this struct is ABI!  It also needs to be backwards
+		 * compatible with "struct internal".  Take special care that
+		 * "ndata" is correct, that new fields are enumerated in "flags",
+		 * and that each flag enumerates fields that are 64-bit aligned
+		 * and sized (so that ndata+internal.data[] is valid/accurate).
+		 */
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
@@ -1078,6 +1100,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_DIRTY_LOG_RING 192
 #define KVM_CAP_X86_BUS_LOCK_EXIT 193
 #define KVM_CAP_PPC_DAWR1 194
+#define KVM_CAP_EXIT_ON_EMULATION_FAILURE 195
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.31.1.607.g51e8a6a459-goog

