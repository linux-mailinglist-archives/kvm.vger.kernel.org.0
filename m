Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E8C8404963
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 13:38:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235981AbhIILjK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 07:39:10 -0400
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:55840 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234507AbhIILjJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Sep 2021 07:39:09 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R571e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=houwenlong93@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0UnnCL45_1631187477;
Received: from localhost(mailfrom:houwenlong93@linux.alibaba.com fp:SMTPD_---0UnnCL45_1631187477)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 09 Sep 2021 19:37:58 +0800
From:   Hou Wenlong <houwenlong93@linux.alibaba.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        "H. Peter Anvin" <hpa@zytor.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Avi Kivity <avi@redhat.com>,
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT))
Subject: [PATCH 1/3] kvm: x86: Introduce hypercall x86 ops for handling hypercall not in cpl0
Date:   Thu,  9 Sep 2021 19:37:54 +0800
Message-Id: <08ea9fdfb711a3ce40ec5538f7c27da729fbfa2d.1631186996.git.houwenlong93@linux.alibaba.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1631186996.git.houwenlong93@linux.alibaba.com>
References: <cover.1631186996.git.houwenlong93@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Per Intel's SDM, use vmcall instruction in non VMX operation for cpl3
it should trigger a #UD. And in VMX root operation, it should
trigger a #GP for cpl3. So hypervisor could inject such exceptions
for guest cpl3 to act like host.

Per AMD's APM, no cpl check for vmmcall instruction. But use it
in host can trigger a #UD, so hypervisor is suitable to inject a #UD.

Fixes: 07708c4af1346 ("KVM: x86: Disallow hypercalls for guest callers in rings > 0")
Signed-off-by: Hou Wenlong <houwenlong93@linux.alibaba.com>
---
 arch/x86/include/asm/kvm-x86-ops.h | 1 +
 arch/x86/include/asm/kvm_host.h    | 1 +
 arch/x86/kvm/svm/svm.c             | 5 +++++
 arch/x86/kvm/vmx/vmx.c             | 9 +++++++++
 arch/x86/kvm/x86.c                 | 6 +++---
 5 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index cefe1d81e2e8..00a8b8c80cb0 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -60,6 +60,7 @@ KVM_X86_OP_NULL(update_emulated_instruction)
 KVM_X86_OP(set_interrupt_shadow)
 KVM_X86_OP(get_interrupt_shadow)
 KVM_X86_OP(patch_hypercall)
+KVM_X86_OP(handle_hypercall_fail)
 KVM_X86_OP(set_irq)
 KVM_X86_OP(set_nmi)
 KVM_X86_OP(queue_exception)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f8f48a7ec577..3548c8047820 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1369,6 +1369,7 @@ struct kvm_x86_ops {
 	u32 (*get_interrupt_shadow)(struct kvm_vcpu *vcpu);
 	void (*patch_hypercall)(struct kvm_vcpu *vcpu,
 				unsigned char *hypercall_addr);
+	void (*handle_hypercall_fail)(struct kvm_vcpu *vcpu);
 	void (*set_irq)(struct kvm_vcpu *vcpu);
 	void (*set_nmi)(struct kvm_vcpu *vcpu);
 	void (*queue_exception)(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 1a70e11f0487..1a8615bb35db 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3944,6 +3944,11 @@ svm_patch_hypercall(struct kvm_vcpu *vcpu, unsigned char *hypercall)
 	hypercall[2] = 0xd9;
 }
 
+static void svm_handl_hypercall_fail(struct kvm_vcpu *vcpu)
+{
+	kvm_queue_exception(vpcu, UD_VECTOR);
+}
+
 static int __init svm_check_processor_compat(void)
 {
 	return 0;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 0c2c0d5ae873..3bd66eb46309 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4921,6 +4921,14 @@ vmx_patch_hypercall(struct kvm_vcpu *vcpu, unsigned char *hypercall)
 	hypercall[2] = 0xc1;
 }
 
+static void vmx_handle_hypercall_fail(struct kvm_vcpu *vcpu)
+{
+	if (to_vmx(vcpu)->nested.vmxon)
+		kvm_queue_exception_e(vcpu, GP_VECTOR, 0);
+	else
+		kvm_queue_exception(vcpu, UD_VECTOR);
+}
+
 /* called to set cr0 as appropriate for a mov-to-cr0 exit. */
 static int handle_set_cr0(struct kvm_vcpu *vcpu, unsigned long val)
 {
@@ -7606,6 +7614,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.set_interrupt_shadow = vmx_set_interrupt_shadow,
 	.get_interrupt_shadow = vmx_get_interrupt_shadow,
 	.patch_hypercall = vmx_patch_hypercall,
+	.handle_hypercall_fail = vmx_handle_hypercall_fail,
 	.set_irq = vmx_inject_irq,
 	.set_nmi = vmx_inject_nmi,
 	.queue_exception = vmx_queue_exception,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 28ef14155726..4e2836b94a01 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8665,8 +8665,8 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 	}
 
 	if (static_call(kvm_x86_get_cpl)(vcpu) != 0) {
-		ret = -KVM_EPERM;
-		goto out;
+		static_call(kvm_x86_handle_hypercall_fail)(vcpu);
+		return 1;
 	}
 
 	ret = -KVM_ENOSYS;
@@ -8727,7 +8727,7 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 		ret = -KVM_ENOSYS;
 		break;
 	}
-out:
+
 	if (!op_64_bit)
 		ret = (u32)ret;
 	kvm_rax_write(vcpu, ret);
-- 
2.31.1

