Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58ACD11EF12
	for <lists+kvm@lfdr.de>; Sat, 14 Dec 2019 01:20:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726678AbfLNAUT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Dec 2019 19:20:19 -0500
Received: from mail-pl1-f202.google.com ([209.85.214.202]:42496 "EHLO
        mail-pl1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726590AbfLNAUS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Dec 2019 19:20:18 -0500
Received: by mail-pl1-f202.google.com with SMTP id b3so2140878plr.9
        for <kvm@vger.kernel.org>; Fri, 13 Dec 2019 16:20:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=iYjRSLM/149x9A6g7cj2JAFrBIGaPeMK4MkKkb0OcHo=;
        b=BKk1ZzWN7AJEO0OwzObETGLBBPvFRcZkvdQAgsOlQF6/6vj87G9B+NA0fDDKcPBTqp
         Ui8YwSbvJcTl05rToJ2R2ulHd3xgTv7qPkVoXlFf7BA0e8bLDfibF253t7VZHZuUrWO+
         cWYhVt6MoaAhu+kOZd+A+eBGHHtDXvJ8hBIjJ6wATiMoSZTQ9RDd6DRQ6aiRwfSZszw3
         9eZsJCKm5TDZbX5H3ZbWRB/jd0s9j6MBqm/H6RMEyh5wCPfINNX4of+7CUdrnDooBu9j
         /Ibncbm1Jd74xU3DAZohldT1S5dvChKWKCQPmXA91qk8Z4oorfCxcoLKYevJJe250+M6
         59dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=iYjRSLM/149x9A6g7cj2JAFrBIGaPeMK4MkKkb0OcHo=;
        b=LHKvZifpjrYy+L4CphLu8GcO+WDkTVWZbT1KamgKy9Qu5rq6pXwj99o5CAlDH2UBY3
         u57kHb1KjCG9RirvA++RzrI5ZN68oxHshCqV5AWiQBGIiP82la7FXOrtVlpPkHAWaS8T
         tj/gYRy5w9/gnBrfSN+qBZ8AJa6FAwl9KqDtAAyMTKTb7+/SLpegDy3RpsyBkdwVYmrl
         W/2euc/ikZ2z7KVOXNymz2k6y69wW/Db+0nGUXrh6DvO9125TwxISWGkfRhvCGqlhfb5
         UmurtRGJhA33AOaM7+ZHc61Y1DiknVW+UZ1V3Vf2AcnJBuJTZDKDPD8U7+vGB9UdJF+D
         We9Q==
X-Gm-Message-State: APjAAAU2X8SH9/BwtwcGkEYx4cjajJ+G7EexPW/yQEK6Dffl5cg1Y2mp
        HDSAa5oQ5VYTmoFIQy7QypoZtq3OThY7CokBw7VsO+lxnF6rmloyzSTOnhIMf8ilut3f0nRFUXd
        +/jw9Yms8YI7PsQ9FjH0er5wjgHW7xnK42Pr6Jr8HySShEQc04RCX6vExstCxTTU=
X-Google-Smtp-Source: APXvYqxmR2lJ2RJ6lXNZWujx4zLl7bYEr5vocTMscxqqRqxNopWUxCdH3bm5nZQekevV0yC/N7d6+F8GjcoXUQ==
X-Received: by 2002:a63:28c7:: with SMTP id o190mr2503762pgo.394.1576282817946;
 Fri, 13 Dec 2019 16:20:17 -0800 (PST)
Date:   Fri, 13 Dec 2019 16:20:14 -0800
Message-Id: <20191214002014.144430-1-jmattson@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.1.735.g03f4e72817-goog
Subject: [PATCH v2] kvm: x86: Add logical CPU to KVM_EXIT_FAIL_ENTRY info
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>,
        Oliver Upton <oupton@google.com>,
        Liran Alon <liran.alon@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>
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
Reviewed-by: Oliver Upton <oupton@google.com>
Cc: Liran Alon <liran.alon@oracle.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
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
index 122d4ce3b1ab..e07c5ce3ac93 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -4980,6 +4980,7 @@ static int handle_exit(struct kvm_vcpu *vcpu)
 		kvm_run->exit_reason = KVM_EXIT_FAIL_ENTRY;
 		kvm_run->fail_entry.hardware_entry_failure_reason
 			= svm->vmcb->control.exit_code;
+		kvm_run->fail_entry.cpu = vcpu->cpu;
 		dump_vmcb(vcpu);
 		return 0;
 	}
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index e3394c839dea..17d1a1676fc0 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5846,6 +5846,7 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu)
 		vcpu->run->exit_reason = KVM_EXIT_FAIL_ENTRY;
 		vcpu->run->fail_entry.hardware_entry_failure_reason
 			= exit_reason;
+		vcpu->run->fail_entry.cpu = vcpu->cpu;
 		return 0;
 	}
 
@@ -5854,6 +5855,7 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu)
 		vcpu->run->exit_reason = KVM_EXIT_FAIL_ENTRY;
 		vcpu->run->fail_entry.hardware_entry_failure_reason
 			= vmcs_read32(VM_INSTRUCTION_ERROR);
+		vcpu->run->fail_entry.cpu = vcpu->cpu;
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

