Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C452F11EE55
	for <lists+kvm@lfdr.de>; Sat, 14 Dec 2019 00:16:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726676AbfLMXQx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Dec 2019 18:16:53 -0500
Received: from mail-pg1-f201.google.com ([209.85.215.201]:36798 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726623AbfLMXQx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Dec 2019 18:16:53 -0500
Received: by mail-pg1-f201.google.com with SMTP id i8so413911pgs.3
        for <kvm@vger.kernel.org>; Fri, 13 Dec 2019 15:16:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=xjYmNb72gCDQoOxyawfUy83RJ3n3NXNDv6WXi3DJ9ek=;
        b=uDZfI/QLdib1AEBzkULNEbF2poe1XnVp3r1mEx0IlQUWY2U73s/GuMxKrkF6OvN/p9
         +CB1pINuaZ0m3lHom19RKt09f2C2q7qHyuIrcR5jZ8ocnqOnGF7tIYjCQNuI70Xk2h/o
         KXztJAz7+Rgq1SgReQ/t81GuFbkrP+Desv97two4rYblnC8HD7dmA4xEupH4YdezV8XI
         vx5YaMEHKQmf1eq4ytGsJEhan3LDi//TAEGKjySUpBHSJadXQl8TGL2GDo3Zua5Up9/E
         HJD+SvApJ1u5G5dEr4Uh1lOTlNdBhjkMOoCxmMxy6qnf4LfCFCL14Sil0UXJtu2fdLtn
         QgGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=xjYmNb72gCDQoOxyawfUy83RJ3n3NXNDv6WXi3DJ9ek=;
        b=WyLUAeCUCd7MF5kmCM6bxwRyYbGnzO1CmA4+a7Pj2RAsh985ceH3jxzcMo/kvgW0aP
         69MPZYtd0qfvg2z3D9wAFiLRPbmYENwXkn0mkG885+NFtXM90VpRIejqDs3SyHy9vEMf
         oDuDOH4TCcHj428clZWtUAsnq8UAFnysU1kF2UgvJQkSep9po2IBJ4UF7OIrbHwVm0cv
         M+QjR9v826vIusBWTK058AL5dDfRyufDl6bzGq6T378sYAaXUWqBeUUxHcsEeOVUdRyF
         dNQk1tMzudKGSv9UITeaW1h1DUvGti4Yk9vPrg+dTnAyuhR0fFtiMQ2IsGanFpcxpQA6
         nzIw==
X-Gm-Message-State: APjAAAVaZzEYN0W97OVyJuIBpUHAfCb8K4J8I4bt/gvm9stMBsNXBF3R
        2jj/D59hDq+qerVDmDgli64HqrbdMqMEHtbsT+0dhlYvDM92gNHC3jixZX9wJqEAHE2gMffdUv1
        Mj0Etv87RqRbNC4BrAVacY2l48QXKJAkieZLwYuIxcs9IfP3kOVjlcdgS7rd730k=
X-Google-Smtp-Source: APXvYqzcVKT9/gi0FFAIwQ1WgaAGy3X8BVBnHkoTs5iVZvmH6jgkB7igCKmSB1yge/yjPaUYSB74AehkbNZd4w==
X-Received: by 2002:a63:1502:: with SMTP id v2mr2270718pgl.376.1576279010915;
 Fri, 13 Dec 2019 15:16:50 -0800 (PST)
Date:   Fri, 13 Dec 2019 15:16:46 -0800
Message-Id: <20191213231646.88015-1-jmattson@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.1.735.g03f4e72817-goog
Subject: [PATCH] kvm: x86: Add logical CPU to KVM_EXIT_FAIL_ENTRY info
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

More often than not, a failed VM-entry in a production environment is
the result of a defective CPU (at least, insofar as Intel x86 is
concerned). To aid in identifying the bad hardware, add the logical
CPU to the information provided to userspace on a KVM exit with reason
KVM_EXIT_FAIL_ENTRY. The presence of this additional information is
indicated by a new capability, KVM_CAP_FAILED_ENTRY_CPU.

Signed-off-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
Reviewed-by: Oliver Upton <oupton@google.com>
---
 Documentation/virt/kvm/api.txt | 1 +
 arch/x86/kvm/svm.c             | 1 +
 arch/x86/kvm/vmx/vmx.c         | 2 ++
 arch/x86/kvm/x86.c             | 1 +
 include/uapi/linux/kvm.h       | 2 ++
 5 files changed, 7 insertions(+)

diff --git a/Documentation/virt/kvm/api.txt b/Documentation/virt/kvm/api.txt
index ebb37b34dcfc..6e5d92406b65 100644
--- a/Documentation/virt/kvm/api.txt
+++ b/Documentation/virt/kvm/api.txt
@@ -4245,6 +4245,7 @@ hardware_exit_reason.
 		/* KVM_EXIT_FAIL_ENTRY */
 		struct {
 			__u64 hardware_entry_failure_reason;
+			__u32 cpu; /* if KVM_CAP_FAILED_ENTRY_CPU */
 		} fail_entry;
 
 If exit_reason is KVM_EXIT_FAIL_ENTRY, the vcpu could not be run due
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 122d4ce3b1ab..4d06b2413c63 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -4980,6 +4980,7 @@ static int handle_exit(struct kvm_vcpu *vcpu)
 		kvm_run->exit_reason = KVM_EXIT_FAIL_ENTRY;
 		kvm_run->fail_entry.hardware_entry_failure_reason
 			= svm->vmcb->control.exit_code;
+		kvm_run->fail_entry.cpu = raw_smp_processor_id();
 		dump_vmcb(vcpu);
 		return 0;
 	}
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index e3394c839dea..4d540b1c08e0 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5846,6 +5846,7 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu)
 		vcpu->run->exit_reason = KVM_EXIT_FAIL_ENTRY;
 		vcpu->run->fail_entry.hardware_entry_failure_reason
 			= exit_reason;
+		vcpu->run->fail_entry.cpu = vmx->loaded_vmcs->cpu;
 		return 0;
 	}
 
@@ -5854,6 +5855,7 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu)
 		vcpu->run->exit_reason = KVM_EXIT_FAIL_ENTRY;
 		vcpu->run->fail_entry.hardware_entry_failure_reason
 			= vmcs_read32(VM_INSTRUCTION_ERROR);
+		vcpu->run->fail_entry.cpu = vmx->loaded_vmcs->cpu;
 		return 0;
 	}
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index cf917139de6b..9e89a32056d1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3273,6 +3273,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_GET_MSR_FEATURES:
 	case KVM_CAP_MSR_PLATFORM_INFO:
 	case KVM_CAP_EXCEPTION_PAYLOAD:
+	case KVM_CAP_FAILED_ENTRY_CPU:
 		r = 1;
 		break;
 	case KVM_CAP_SYNC_REGS:
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index f0a16b4adbbd..09ba7174456d 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -277,6 +277,7 @@ struct kvm_run {
 		/* KVM_EXIT_FAIL_ENTRY */
 		struct {
 			__u64 hardware_entry_failure_reason;
+			__u32 cpu;
 		} fail_entry;
 		/* KVM_EXIT_EXCEPTION */
 		struct {
@@ -1009,6 +1010,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_PPC_GUEST_DEBUG_SSTEP 176
 #define KVM_CAP_ARM_NISV_TO_USER 177
 #define KVM_CAP_ARM_INJECT_EXT_DABT 178
+#define KVM_CAP_FAILED_ENTRY_CPU 179
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.24.1.735.g03f4e72817-goog

