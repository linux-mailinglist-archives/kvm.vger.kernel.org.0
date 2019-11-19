Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7220101975
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2019 07:36:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727495AbfKSGgl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Nov 2019 01:36:41 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:41449 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726023AbfKSGgl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Nov 2019 01:36:41 -0500
Received: by mail-pg1-f193.google.com with SMTP id 207so3499275pge.8;
        Mon, 18 Nov 2019 22:36:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=mUsgHBil/Lo3OlLi4dMluLwGf3lqB7AGOtuRDY2yI2M=;
        b=eUNzbHt2jiY3ChCfeaUCmUn8kMYSAosJnf+drBsys0bmjLyD0wqR71H71iFtpqbjwn
         4O8Hbmfxb75CgOUbyFIqyzucWvcXhjJDtVapTMVagrJB+1Tuh6abncBcoKYZIHUs51qx
         yZSRLyshSCcuQOAvTDrL5ufWR56QHSDzEvSl6YcEQFp9rzcA8keJ+pvw/sj2i9XOdG3V
         jeeLdymY3vWmX5VKu6BD7iITNU4nMtmg4IUEWEIhmKxxzG8aOuc9v8/6kFDzluRi88Oo
         E1m5EbFiZ7hGkzI8XIvBBrQYxgHkJ75Z8aJecKGL2BCn/y28aGqro0OCO8kD43AY8FQn
         fK1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=mUsgHBil/Lo3OlLi4dMluLwGf3lqB7AGOtuRDY2yI2M=;
        b=C5yjwxql1OaPJBM3PJRrXsrGmoZvd7s9WlRSZT4zoDqje7QqI2BzgUJO32dwN2EKqi
         3f/jtO8ii9SF4Rp1c0lBlIzZmpk3zpZjSNsVmn6P6QgRK96dZAJoxAXycXXLKF3YWSzI
         suWvAvdmyE1uXfTCxmxpWvxZpYKTkrJoo5E26FfzofxaZ4Qdt21SRam3jYR+yry0p41W
         C4KUeUPptpZfZMFRMke5jN4jHX4afcvtt2mHQ7oNvM+LcUX5oI95w4TEdSjHThtjgNzL
         IITK9hMTGZiIpzTprB7MHCWbzzXFVZpzLxbfnx4CvPYmw8X3Z1PDw8Wz47LzOUKkmfyN
         RuaA==
X-Gm-Message-State: APjAAAXhRsNiU9c1FpTEF5LJXto3SOdCd7Gx7nbD5j9QKtn1mqYfCeGc
        5U9oAZiFkwLWzZipW73gL5AlDUOS
X-Google-Smtp-Source: APXvYqwRTvaGRgxh3GFLqHSGTFW7iPYjnWWLmi+jQS7q6nFRqxN27P1m0ntEs/wR0YzmC6SxLxJ0cQ==
X-Received: by 2002:a63:4556:: with SMTP id u22mr2515624pgk.2.1574145398636;
        Mon, 18 Nov 2019 22:36:38 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id e17sm22994274pgg.5.2019.11.18.22.36.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 18 Nov 2019 22:36:38 -0800 (PST)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH v2 1/2] KVM: VMX: FIXED+PHYSICAL mode single target IPI fastpath
Date:   Tue, 19 Nov 2019 14:36:28 +0800
Message-Id: <1574145389-12149-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

ICR and TSCDEADLINE MSRs write cause the main MSRs write vmexits in 
our product observation, multicast IPIs are not as common as unicast 
IPI like RESCHEDULE_VECTOR and CALL_FUNCTION_SINGLE_VECTOR etc.

This patch tries to optimize x2apic physical destination mode, fixed 
delivery mode single target IPI by delivering IPI to receiver as soon 
as possible after sender writes ICR vmexit to avoid various checks 
when possible, especially when running guest w/ --overcommit cpu-pm=on
or guest can keep running, IPI can be injected to target vCPU by 
posted-interrupt immediately.

Testing on Xeon Skylake server:

The virtual IPI latency from sender send to receiver receive reduces 
more than 200+ cpu cycles.

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
v1 -> v2:
 * add tracepoint
 * Instead of a separate vcpu->fast_vmexit, set exit_reason
   to vmx->exit_reason to -1 if the fast path succeeds.
 * move the "kvm_skip_emulated_instruction(vcpu)" to vmx_handle_exit
 * moving the handling into vmx_handle_exit_irqoff()

 arch/x86/include/asm/kvm_host.h |  4 ++--
 arch/x86/include/uapi/asm/vmx.h |  1 +
 arch/x86/kvm/svm.c              |  4 ++--
 arch/x86/kvm/vmx/vmx.c          | 40 +++++++++++++++++++++++++++++++++++++---
 arch/x86/kvm/x86.c              |  5 +++--
 5 files changed, 45 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 898ab9e..0daafa9 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1084,7 +1084,7 @@ struct kvm_x86_ops {
 	void (*tlb_flush_gva)(struct kvm_vcpu *vcpu, gva_t addr);
 
 	void (*run)(struct kvm_vcpu *vcpu);
-	int (*handle_exit)(struct kvm_vcpu *vcpu);
+	int (*handle_exit)(struct kvm_vcpu *vcpu, u32 *vcpu_exit_reason);
 	int (*skip_emulated_instruction)(struct kvm_vcpu *vcpu);
 	void (*set_interrupt_shadow)(struct kvm_vcpu *vcpu, int mask);
 	u32 (*get_interrupt_shadow)(struct kvm_vcpu *vcpu);
@@ -1134,7 +1134,7 @@ struct kvm_x86_ops {
 	int (*check_intercept)(struct kvm_vcpu *vcpu,
 			       struct x86_instruction_info *info,
 			       enum x86_intercept_stage stage);
-	void (*handle_exit_irqoff)(struct kvm_vcpu *vcpu);
+	void (*handle_exit_irqoff)(struct kvm_vcpu *vcpu, u32 *vcpu_exit_reason);
 	bool (*mpx_supported)(void);
 	bool (*xsaves_supported)(void);
 	bool (*umip_emulated)(void);
diff --git a/arch/x86/include/uapi/asm/vmx.h b/arch/x86/include/uapi/asm/vmx.h
index 3eb8411..b33c6e1 100644
--- a/arch/x86/include/uapi/asm/vmx.h
+++ b/arch/x86/include/uapi/asm/vmx.h
@@ -88,6 +88,7 @@
 #define EXIT_REASON_XRSTORS             64
 #define EXIT_REASON_UMWAIT              67
 #define EXIT_REASON_TPAUSE              68
+#define EXIT_REASON_NEED_SKIP_EMULATED_INSN -1
 
 #define VMX_EXIT_REASONS \
 	{ EXIT_REASON_EXCEPTION_NMI,         "EXCEPTION_NMI" }, \
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index d02a73a..c8e063a 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -4929,7 +4929,7 @@ static void svm_get_exit_info(struct kvm_vcpu *vcpu, u64 *info1, u64 *info2)
 	*info2 = control->exit_info_2;
 }
 
-static int handle_exit(struct kvm_vcpu *vcpu)
+static int handle_exit(struct kvm_vcpu *vcpu, u32 *vcpu_exit_reason)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	struct kvm_run *kvm_run = vcpu->run;
@@ -6187,7 +6187,7 @@ static int svm_check_intercept(struct kvm_vcpu *vcpu,
 	return ret;
 }
 
-static void svm_handle_exit_irqoff(struct kvm_vcpu *vcpu)
+static void svm_handle_exit_irqoff(struct kvm_vcpu *vcpu, u32 *vcpu_exit_reason)
 {
 
 }
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 621142e5..b98198d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5792,7 +5792,7 @@ void dump_vmcs(void)
  * The guest has exited.  See if we can fix it or if we need userspace
  * assistance.
  */
-static int vmx_handle_exit(struct kvm_vcpu *vcpu)
+static int vmx_handle_exit(struct kvm_vcpu *vcpu, u32 *vcpu_exit_reason)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	u32 exit_reason = vmx->exit_reason;
@@ -5878,7 +5878,10 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu)
 		}
 	}
 
-	if (exit_reason < kvm_vmx_max_exit_handlers
+	if (*vcpu_exit_reason == EXIT_REASON_NEED_SKIP_EMULATED_INSN) {
+		kvm_skip_emulated_instruction(vcpu);
+		return 1;
+	} else if (exit_reason < kvm_vmx_max_exit_handlers
 	    && kvm_vmx_exit_handlers[exit_reason]) {
 #ifdef CONFIG_RETPOLINE
 		if (exit_reason == EXIT_REASON_MSR_WRITE)
@@ -6223,7 +6226,36 @@ static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu)
 }
 STACK_FRAME_NON_STANDARD(handle_external_interrupt_irqoff);
 
-static void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
+static u32 handle_ipi_fastpath(struct kvm_vcpu *vcpu)
+{
+	u32 index;
+	u64 data;
+	int ret = 0;
+
+	if (lapic_in_kernel(vcpu) && apic_x2apic_mode(vcpu->arch.apic)) {
+		/*
+		 * fastpath to IPI target, FIXED+PHYSICAL which is popular
+		 */
+		index = kvm_rcx_read(vcpu);
+		data = kvm_read_edx_eax(vcpu);
+
+		if (((index - APIC_BASE_MSR) << 4 == APIC_ICR) &&
+			((data & KVM_APIC_DEST_MASK) == APIC_DEST_PHYSICAL) &&
+			((data & APIC_MODE_MASK) == APIC_DM_FIXED)) {
+
+			trace_kvm_msr_write(index, data);
+			kvm_lapic_set_reg(vcpu->arch.apic, APIC_ICR2, (u32)(data >> 32));
+			ret = kvm_lapic_reg_write(vcpu->arch.apic, APIC_ICR, (u32)data);
+
+			if (ret == 0)
+				return EXIT_REASON_NEED_SKIP_EMULATED_INSN;
+		}
+	}
+
+	return ret;
+}
+
+static void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu, u32 *exit_reason)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
@@ -6231,6 +6263,8 @@ static void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
 		handle_external_interrupt_irqoff(vcpu);
 	else if (vmx->exit_reason == EXIT_REASON_EXCEPTION_NMI)
 		handle_exception_nmi_irqoff(vmx);
+	else if (vmx->exit_reason == EXIT_REASON_MSR_WRITE)
+		*exit_reason = handle_ipi_fastpath(vcpu);
 }
 
 static bool vmx_has_emulated_msr(int index)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 991dd01..a53bce3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7981,6 +7981,7 @@ EXPORT_SYMBOL_GPL(__kvm_request_immediate_exit);
 static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 {
 	int r;
+	u32 exit_reason = 0;
 	bool req_int_win =
 		dm_request_for_irq_injection(vcpu) &&
 		kvm_cpu_accept_dm_intr(vcpu);
@@ -8226,7 +8227,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	vcpu->mode = OUTSIDE_GUEST_MODE;
 	smp_wmb();
 
-	kvm_x86_ops->handle_exit_irqoff(vcpu);
+	kvm_x86_ops->handle_exit_irqoff(vcpu, &exit_reason);
 
 	/*
 	 * Consume any pending interrupts, including the possible source of
@@ -8270,7 +8271,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		kvm_lapic_sync_from_vapic(vcpu);
 
 	vcpu->arch.gpa_available = false;
-	r = kvm_x86_ops->handle_exit(vcpu);
+	r = kvm_x86_ops->handle_exit(vcpu, &exit_reason);
 	return r;
 
 cancel_injection:
-- 
2.7.4

