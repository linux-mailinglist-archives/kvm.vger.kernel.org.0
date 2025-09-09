Return-Path: <kvm+bounces-57125-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 40D5AB50555
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 20:33:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DA97A172E52
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 18:33:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9736F35FC39;
	Tue,  9 Sep 2025 18:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="K0XYalmI"
X-Original-To: kvm@vger.kernel.org
Received: from terminus.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD09A302CAB;
	Tue,  9 Sep 2025 18:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757442669; cv=none; b=VVORG+NyNFhw3u7s7SfwW2CA/1YOygQzBySqtWidNtrUCdKnWTtxiDjlemW1cQwKNGY3EOPjEjD0THRMyh8KMuLuAcCX4ClNv44HaBC0/XZ7DI89a1byXrou58Sg6bSMJ7Yi0K9We4hG5AXHyk/QY3LRiQSmdhjTUQ9ZdK8cM/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757442669; c=relaxed/simple;
	bh=sfspnZ2Xc2kJrFia0AEmuo7v4zNy/L4pJcSHT2DDcEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EnwGi/Xm6B+GVlOfcYDR/OCoWA3+dRQ9t8fRhom++I1GlqhmfcyFExYClXHgWhrWjMzEMFSy0wctFdaSl51OqQ+4NEvHPdpfPDvNcMk8TLB1dyqaOoD9OxpOKmLvHUiVLZPJ/DgzEAc9Qy2lvaYapkdnAVvsyV00LJED4QlFCKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=K0XYalmI; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 589ISSD41542432
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Tue, 9 Sep 2025 11:28:38 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 589ISSD41542432
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025082201; t=1757442519;
	bh=VNqB3TSQtWjm3nTUpaiiCNmmIt4N6RO62SGzcJafqTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K0XYalmIS1uPRvoH9QT4rdaZNgD7TlcWwAMi105/AZuIXlG+KazrqQpNOVCh3UJD2
	 35rcqk5TDE/DbC6P5R08BLn8gwF55lXku3ke1rXbwq2Q8Gj13jXkV2mFr7JT6mAyI2
	 1zS6jamxihp/awKQQ0aqvqUshvdslpBL0Lpb4yyg+8ZMatfPOzGdx8eZKsVBdrN32u
	 /STpPCnrH+ES0wKIQgNW6WpXo/SomJDNKLvcGJb3+Uy2foM3lPZC3j0UYkv/hrZpaQ
	 nvIZ4sXrIMSSTT5MrEK2bpvinUDiTy2KLWS1dV31bM3zQRLflD6iNWdXWZZxlbdLJS
	 Z5rVJOG4thPwA==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-pm@vger.kernel.org
Cc: seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, rafael@kernel.org, pavel@kernel.org,
        brgerst@gmail.com, xin@zytor.com, david.kaplan@amd.com,
        peterz@infradead.org, andrew.cooper3@citrix.com,
        kprateek.nayak@amd.com, arjan@linux.intel.com, chao.gao@intel.com,
        rick.p.edgecombe@intel.com, dan.j.williams@intel.com
Subject: [RFC PATCH v1 5/5] KVM: Remove kvm_rebooting and its references
Date: Tue,  9 Sep 2025 11:28:25 -0700
Message-ID: <20250909182828.1542362-6-xin@zytor.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250909182828.1542362-1-xin@zytor.com>
References: <20250909182828.1542362-1-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Drop kvm_rebooting and all related uses.  Virtualization is now disabled
immediately before a CPU shuts down, eliminating any chance of executing
virtualization instructions during reboot.

Signed-off-by: Xin Li (Intel) <xin@zytor.com>
---
 arch/x86/kvm/svm/vmenter.S | 42 ++++++++++++--------------------------
 arch/x86/kvm/vmx/tdx.c     |  4 +---
 arch/x86/kvm/vmx/vmenter.S |  2 --
 arch/x86/kvm/x86.c         |  8 ++------
 include/linux/kvm_host.h   |  1 -
 virt/kvm/kvm_main.c        | 15 ++------------
 6 files changed, 18 insertions(+), 54 deletions(-)

diff --git a/arch/x86/kvm/svm/vmenter.S b/arch/x86/kvm/svm/vmenter.S
index 235c4af6b692..d530f62679b9 100644
--- a/arch/x86/kvm/svm/vmenter.S
+++ b/arch/x86/kvm/svm/vmenter.S
@@ -145,7 +145,6 @@ SYM_FUNC_START(__svm_vcpu_run)
 	 */
 	mov SVM_vmcb01_pa(%_ASM_DI), %_ASM_AX
 1:	vmload %_ASM_AX
-2:
 
 	/* Get svm->current_vmcb->pa into RAX. */
 	mov SVM_current_vmcb(%_ASM_DI), %_ASM_AX
@@ -173,8 +172,8 @@ SYM_FUNC_START(__svm_vcpu_run)
 	VM_CLEAR_CPU_BUFFERS
 
 	/* Enter guest mode */
-3:	vmrun %_ASM_AX
-4:
+2:	vmrun %_ASM_AX
+
 	/* Pop @svm to RAX while it's the only available register. */
 	pop %_ASM_AX
 
@@ -200,13 +199,11 @@ SYM_FUNC_START(__svm_vcpu_run)
 	mov %_ASM_AX, %_ASM_DI
 
 	mov SVM_vmcb01_pa(%_ASM_DI), %_ASM_AX
-5:	vmsave %_ASM_AX
-6:
+3:	vmsave %_ASM_AX
 
 	/* Restores GSBASE among other things, allowing access to percpu data.  */
 	pop %_ASM_AX
-7:	vmload %_ASM_AX
-8:
+4:	vmload %_ASM_AX
 
 	/* IMPORTANT: Stuff the RSB immediately after VM-Exit, before RET! */
 	FILL_RETURN_BUFFER %_ASM_AX, RSB_CLEAR_LOOPS, X86_FEATURE_RSB_VMEXIT
@@ -269,23 +266,12 @@ SYM_FUNC_START(__svm_vcpu_run)
 	RESTORE_GUEST_SPEC_CTRL_BODY
 	RESTORE_HOST_SPEC_CTRL_BODY (%_ASM_SP)
 
-10:	cmpb $0, _ASM_RIP(kvm_rebooting)
-	jne 2b
-	ud2
-30:	cmpb $0, _ASM_RIP(kvm_rebooting)
-	jne 4b
-	ud2
-50:	cmpb $0, _ASM_RIP(kvm_rebooting)
-	jne 6b
-	ud2
-70:	cmpb $0, _ASM_RIP(kvm_rebooting)
-	jne 8b
-	ud2
-
-	_ASM_EXTABLE(1b, 10b)
-	_ASM_EXTABLE(3b, 30b)
-	_ASM_EXTABLE(5b, 50b)
-	_ASM_EXTABLE(7b, 70b)
+5:	ud2
+
+	_ASM_EXTABLE(1b, 5b)
+	_ASM_EXTABLE(2b, 5b)
+	_ASM_EXTABLE(3b, 5b)
+	_ASM_EXTABLE(4b, 5b)
 
 SYM_FUNC_END(__svm_vcpu_run)
 
@@ -343,7 +329,7 @@ SYM_FUNC_START(__svm_sev_es_vcpu_run)
 
 	/* Enter guest mode */
 1:	vmrun %rax
-2:
+
 	/* IMPORTANT: Stuff the RSB immediately after VM-Exit, before RET! */
 	FILL_RETURN_BUFFER %rax, RSB_CLEAR_LOOPS, X86_FEATURE_RSB_VMEXIT
 
@@ -365,11 +351,9 @@ SYM_FUNC_START(__svm_sev_es_vcpu_run)
 	RESTORE_GUEST_SPEC_CTRL_BODY
 	RESTORE_HOST_SPEC_CTRL_BODY %sil
 
-3:	cmpb $0, kvm_rebooting(%rip)
-	jne 2b
-	ud2
+2:	ud2
 
-	_ASM_EXTABLE(1b, 3b)
+	_ASM_EXTABLE(1b, 2b)
 
 SYM_FUNC_END(__svm_sev_es_vcpu_run)
 #endif /* CONFIG_KVM_AMD_SEV */
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 66744f5768c8..cfe5f8b63973 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -2052,10 +2052,8 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
 	 * Handle TDX SW errors, including TDX_SEAMCALL_UD, TDX_SEAMCALL_GP and
 	 * TDX_SEAMCALL_VMFAILINVALID.
 	 */
-	if (unlikely((vp_enter_ret & TDX_SW_ERROR) == TDX_SW_ERROR)) {
-		KVM_BUG_ON(!kvm_rebooting, vcpu->kvm);
+	if (unlikely((vp_enter_ret & TDX_SW_ERROR) == TDX_SW_ERROR))
 		goto unhandled_exit;
-	}
 
 	if (unlikely(tdx_failed_vmentry(vcpu))) {
 		/*
diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
index 0a6cf5bff2aa..3457b5e1f856 100644
--- a/arch/x86/kvm/vmx/vmenter.S
+++ b/arch/x86/kvm/vmx/vmenter.S
@@ -293,8 +293,6 @@ SYM_INNER_LABEL_ALIGN(vmx_vmexit, SYM_L_GLOBAL)
 	RET
 
 .Lfixup:
-	cmpb $0, _ASM_RIP(kvm_rebooting)
-	jne .Lvmfail
 	ud2
 .Lvmfail:
 	/* VM-Fail: set return value to 1 */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8b9f64770684..1abc4550fd76 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -687,15 +687,11 @@ static void drop_user_return_notifiers(void)
 
 /*
  * Handle a fault on a hardware virtualization (VMX or SVM) instruction.
- *
- * Hardware virtualization extension instructions may fault if a reboot turns
- * off virtualization while processes are running.  Usually after catching the
- * fault we just panic; during reboot instead the instruction is ignored.
  */
 noinstr void kvm_spurious_fault(void)
 {
-	/* Fault while not rebooting.  We want the trace. */
-	BUG_ON(!kvm_rebooting);
+	/* We want the trace. */
+	BUG_ON(true);
 }
 EXPORT_SYMBOL_GPL(kvm_spurious_fault);
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 151305b33bce..2d9c306db4f0 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2276,7 +2276,6 @@ static inline bool kvm_check_request(int req, struct kvm_vcpu *vcpu)
 
 #ifdef CONFIG_KVM_GENERIC_HARDWARE_ENABLING
 extern bool enable_virt_at_load;
-extern bool kvm_rebooting;
 #endif
 
 extern unsigned int halt_poll_ns;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 6e86c6a45a71..0037761c1a51 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5559,9 +5559,6 @@ bool enable_virt_at_load = true;
 module_param(enable_virt_at_load, bool, 0444);
 EXPORT_SYMBOL_GPL(enable_virt_at_load);
 
-__visible bool kvm_rebooting;
-EXPORT_SYMBOL_GPL(kvm_rebooting);
-
 static DEFINE_PER_CPU(bool, virtualization_enabled);
 static DEFINE_MUTEX(kvm_usage_lock);
 static int kvm_usage_count;
@@ -5610,18 +5607,10 @@ static int kvm_offline_cpu(unsigned int cpu)
 static void kvm_shutdown(void)
 {
 	/*
-	 * Disable hardware virtualization and set kvm_rebooting to indicate
-	 * that KVM has asynchronously disabled hardware virtualization, i.e.
-	 * that relevant errors and exceptions aren't entirely unexpected.
-	 * Some flavors of hardware virtualization need to be disabled before
-	 * transferring control to firmware (to perform shutdown/reboot), e.g.
-	 * on x86, virtualization can block INIT interrupts, which are used by
-	 * firmware to pull APs back under firmware control.  Note, this path
-	 * is used for both shutdown and reboot scenarios, i.e. neither name is
-	 * 100% comprehensive.
+	 * Note, this path is used for both shutdown and reboot scenarios, i.e.
+	 * neither name is 100% comprehensive.
 	 */
 	pr_info("kvm: exiting hardware virtualization\n");
-	kvm_rebooting = true;
 	on_each_cpu(kvm_disable_virtualization_cpu, NULL, 1);
 }
 
-- 
2.51.0


