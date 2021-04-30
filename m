Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D57F336FC8E
	for <lists+kvm@lfdr.de>; Fri, 30 Apr 2021 16:38:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232992AbhD3Oiq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Apr 2021 10:38:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232776AbhD3Oiq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Apr 2021 10:38:46 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6505C06174A
        for <kvm@vger.kernel.org>; Fri, 30 Apr 2021 07:37:57 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id k19-20020a17090aaa13b0290155dbdb3d87so3980090pjq.4
        for <kvm@vger.kernel.org>; Fri, 30 Apr 2021 07:37:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=d3hjGySdpM9UxSZKS8LI85s6ABUvlsW8K+gGAeHFH8s=;
        b=CD80udlBLO1SbI/OGasmDvuiDcLOWsVPAuiDA6hd1ge9Uj3GroPfJx/18L7C733H+w
         +rv9WImJXx7VU/QcbNGjc+OUagkiJ+2zWqAN2GPZbVbOaRUm8mN6BNi/iW2gUDbjG3Fe
         VrzOc2aQGHDEsMoKM0dZfou7Pa9biUplPtrifGLVQa7WYRznqrkCGvGcSBKYlP3HJvaA
         talmZB8/8FyfVA+ri0OBbWCh6aoSuD6wQCRuMOCjhDhmCO/Vx74+cYYHBN3UIuZSUCJ+
         LeEM9K5EHN6XagRR/GbZxhXrgw41qU5aYTwka7SdvRgc7LD8UDFwcn3kJN3jNnu3RqGZ
         t/uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=d3hjGySdpM9UxSZKS8LI85s6ABUvlsW8K+gGAeHFH8s=;
        b=l5x7W0SJl7jup61oPwZAPiFxpg0125gttMNtBIlJaa8kBVlB+3zDoC44TPaXE2IMJ4
         Dc/93krw1UrkAnlJQDofaPpMW57mp8W4slWIX7y2GWJ27476OnEgpDPQRQNvtONv8DZV
         v/lvVZJzDHA9gG7bOv/boF4/lNWLA11Hz5qbE7Pc8pIrp86/nqNwDwjyZtnPUkcH4ag4
         Bk8gsKZz12RYEMpbGydBrDA0yY92JLXYCPd14oyUIGuBclsHlG12+iZTQwZuvSxPqnjv
         iwc3RSRTVPwtTrAfB7kkMPzrue9kTxClsfYNtt/seg2VNeA+nQInQ4f9vHUW7s8AjSsI
         flQQ==
X-Gm-Message-State: AOAM530zMn79x2xMYXbBjipLf/Yf+V9zX5zDP32rU+3HEqd9b2Xj+ORW
        VZ92bepq6jGOupA1Do+r+SExLW5T7Mdv0+in
X-Google-Smtp-Source: ABdhPJwFfLzv8WBV/URCk0HRwZMWg5UdEnjMy+i9t5IaY0wJKhSyBPbt2/1gwMG6in+eu7m0GZJ6Ckwdm30mtMq8
X-Received: from aaronlewis1.sea.corp.google.com ([2620:15c:100:202:250e:2425:2e40:acc])
 (user=aaronlewis job=sendgmr) by 2002:a05:6a00:1687:b029:253:f417:4dba with
 SMTP id k7-20020a056a001687b0290253f4174dbamr5222256pfc.5.1619793477365; Fri,
 30 Apr 2021 07:37:57 -0700 (PDT)
Date:   Fri, 30 Apr 2021 07:37:50 -0700
In-Reply-To: <20210430143751.1693253-1-aaronlewis@google.com>
Message-Id: <20210430143751.1693253-2-aaronlewis@google.com>
Mime-Version: 1.0
References: <20210430143751.1693253-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.31.1.527.g47e6f16901-goog
Subject: [PATCH v5 1/2] kvm: x86: Allow userspace to handle emulation errors
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
---
 Documentation/virt/kvm/api.rst  | 21 +++++++++++++++++++
 arch/x86/include/asm/kvm_host.h |  6 ++++++
 arch/x86/kvm/x86.c              | 37 +++++++++++++++++++++++++++++----
 include/uapi/linux/kvm.h        | 23 ++++++++++++++++++++
 tools/include/uapi/linux/kvm.h  | 23 ++++++++++++++++++++
 5 files changed, 106 insertions(+), 4 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 307f2fcf1b02..ed77835eab54 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6233,6 +6233,27 @@ KVM_RUN_BUS_LOCK flag is used to distinguish between them.
 This capability can be used to check / enable 2nd DAWR feature provided
 by POWER10 processor.
 
+7.24 KVM_CAP_EXIT_ON_EMULATION_FAILURE
+--------------------------------------
+
+:Architectures: x86
+:Parameters: args[0] whether the feature should be enabled or not
+
+When this capability is enabled the in-kernel instruction emulator packs
+the exit struct of KVM_INTERNAL_ERROR with the instruction length and
+instruction bytes when an error occurs while emulating an instruction.  This
+will also happen when the emulation type is set to EMULTYPE_SKIP, but with this
+capability enabled this becomes the default behavior regarless of how the
+emulation type is set unless it is a VMware #GP; in that case a #GP is injected
+and KVM does not exit to userspace.
+
+When this capability is enabled use the emulation_failure struct instead of the
+internal struct for the exit struct.  They have the same layout, but the
+emulation_failure struct matches the content better.  It also explicitly defines
+the 'flags' field which is used to describe the fields in the struct that are
+valid (ie: if KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES is set in the
+'flags' field then 'insn_size' and 'insn_bytes' has valid data in them.)
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
2.31.1.527.g47e6f16901-goog

