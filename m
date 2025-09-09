Return-Path: <kvm+bounces-57127-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FA9AB5055B
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 20:33:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3C0D71C676AA
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 18:34:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32F78362999;
	Tue,  9 Sep 2025 18:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="iolL6evk"
X-Original-To: kvm@vger.kernel.org
Received: from terminus.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D5DB362081;
	Tue,  9 Sep 2025 18:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757442674; cv=none; b=ZHY4Bu402d81K+tRmYZMIzuO/7QuVkU/Nd+cW8WLJDI38OHa2PHzS4955B5xRVXW71PbHicoIMsTe8AzmxCav4soQfrZetVaf40r6Mx9An/TfUPiJuSkrt5aB62OR3lMuBwt+wYeIEjGxhKi2AXr1JysxqkywqKadhhKE33XFdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757442674; c=relaxed/simple;
	bh=rCuNZpNo4vvaRbDLqyXW6DuvOYK5RqaHCMq65AAhVGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fB6pXAOgTgU9uR72kMAbEuhKKiNpt2/n0PvG6Yps1+BeLiH0zEIEONQ22cNryKxif+fE3zbGa5YFoJ29J3/uxi0xsrmF3+qmL88R5SOzvq4S15rOOFPD4MGuKyoEr/xzShotevZygndVeG67fWb7cCqRTWzcFgP/otYthrJg02k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=iolL6evk; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 589ISSD21542432
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Tue, 9 Sep 2025 11:28:36 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 589ISSD21542432
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025082201; t=1757442517;
	bh=0tnUFvh61+MMtnKH7S5FxrOTVk/h3Y9UuNbq1gRi4z4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iolL6evkSJ6PuDR7AWbE4YwpBwQRobOJRUXhYCZWo5l+O9oOn7NBzrrd0M5lR1+mR
	 EVHyULL8jyS6WRAIkDWkBdWNMkVryIKGw1NNPE/j8QdnWtdbR4E/4eBchIrD99Xv7N
	 vfn1jQhMTifadcQqz0a5bk+TaXkY9zYEU4lIjVEsUxEl8WPo6QTHANvbHfblOwsqQW
	 3EZ/ah7UHz163WP2ztywc7MDIST+VNk3CcuSs+MrmaC/3b7Z+kCaM5cX3/+M4ESNKy
	 S/sFIw6WIVqkci8OHmX05HrZzyHpmGpCs15HHyts/QH9GUgxCcUkpGwW79NKnyo6Ga
	 hFRQLLNQ+TYLw==
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
Subject: [RFC PATCH v1 3/5] x86/shutdown, KVM: VMX: Move VMCLEAR of VMCSs to cpu_disable_virtualization()
Date: Tue,  9 Sep 2025 11:28:23 -0700
Message-ID: <20250909182828.1542362-4-xin@zytor.com>
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

Relocate the VMCLEAR of VMCSs from KVM to cpu_disable_virtualization() in
x86.  This eliminates the need to call cpu_emergency_disable_virtualization()
before cpu_disable_virtualization() and prepares for removing the emergency
reboot callback that calls into KVM from the CPU reboot path.

Signed-off-by: Xin Li (Intel) <xin@zytor.com>
---
 arch/x86/include/asm/processor.h |  1 +
 arch/x86/kernel/cpu/common.c     | 34 ++++++++++++++++++++++++++++++++
 arch/x86/kernel/crash.c          |  3 ---
 arch/x86/kernel/reboot.c         |  7 +++----
 arch/x86/kernel/smp.c            |  6 ------
 arch/x86/kvm/vmx/vmcs.h          |  5 ++++-
 arch/x86/kvm/vmx/vmx.c           | 34 +++-----------------------------
 7 files changed, 45 insertions(+), 45 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 0bfd4eb1e9e2..d8a28c57248d 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -230,6 +230,7 @@ void init_cpu_devs(void);
 void get_cpu_vendor(struct cpuinfo_x86 *c);
 extern void early_cpu_init(void);
 extern void identify_secondary_cpu(unsigned int cpu);
+extern struct list_head* get_loaded_vmcss_on_cpu(int cpu);
 extern void cpu_enable_virtualization(void);
 extern void cpu_disable_virtualization(void);
 extern void print_cpu_info(struct cpuinfo_x86 *);
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 39b9be9a2fb1..73abacf57ed4 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1950,6 +1950,18 @@ union vmxon_vmcs {
 };
 
 static DEFINE_PER_CPU_PAGE_ALIGNED(union vmxon_vmcs, vmxon_vmcs);
+/*
+ * We maintain a per-CPU linked-list of VMCS loaded on that CPU. This is needed
+ * when a CPU is brought down, and we need to VMCLEAR all VMCSs loaded on it.
+ */
+static DEFINE_PER_CPU(struct list_head, loaded_vmcss_on_cpu);
+
+/* Export an accessor rather than the raw data */
+struct list_head* get_loaded_vmcss_on_cpu(int cpu)
+{
+	return &per_cpu(loaded_vmcss_on_cpu, cpu);
+}
+EXPORT_SYMBOL_GPL(get_loaded_vmcss_on_cpu);
 
 /*
  * Executed during the CPU startup phase to execute VMXON to enable VMX. This
@@ -1975,6 +1987,8 @@ void cpu_enable_virtualization(void)
 		return;
 	}
 
+	INIT_LIST_HEAD(get_loaded_vmcss_on_cpu(cpu));
+
 	memset(this_cpu_ptr(&vmxon_vmcs), 0, PAGE_SIZE);
 
 	/*
@@ -2002,6 +2016,18 @@ void cpu_enable_virtualization(void)
 	intel_pt_handle_vmx(0);
 }
 
+static __always_inline void vmclear(void *p)
+{
+	u64 pa = __pa(p);
+	asm volatile ("vmclear %0" : : "m"(pa) : "cc");
+}
+
+struct loaded_vmcs_basic {
+	struct list_head loaded_vmcss_on_cpu_link;
+	struct vmcs_hdr *vmcs;
+	struct vmcs_hdr *shadow_vmcs;
+};
+
 /*
  * Because INIT interrupts are blocked during VMX operation, this function
  * must be called just before a CPU shuts down to ensure it can be brought
@@ -2016,6 +2042,7 @@ void cpu_enable_virtualization(void)
 void cpu_disable_virtualization(void)
 {
 	int cpu = raw_smp_processor_id();
+	struct loaded_vmcs_basic *v;
 
 	if (!is_vmx_supported())
 		return;
@@ -2025,6 +2052,13 @@ void cpu_disable_virtualization(void)
 		return;
 	}
 
+	list_for_each_entry(v, get_loaded_vmcss_on_cpu(cpu),
+			    loaded_vmcss_on_cpu_link) {
+		vmclear(v->vmcs);
+		if (v->shadow_vmcs)
+			vmclear(v->shadow_vmcs);
+	}
+
 	asm goto("1: vmxoff\n\t"
 		 _ASM_EXTABLE(1b, %l[fault])
 		 ::: "cc", "memory" : fault);
diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
index 772c6d350b50..e5b374587be2 100644
--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -111,9 +111,6 @@ void native_machine_crash_shutdown(struct pt_regs *regs)
 
 	crash_smp_send_stop();
 
-	/* Kept to VMCLEAR loaded VMCSs */
-	cpu_emergency_disable_virtualization();
-
 	/*
 	 * Disable Intel PT to stop its logging
 	 */
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 7433e634018f..d8c3e2d8481f 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -633,7 +633,7 @@ static void native_machine_emergency_restart(void)
 	unsigned short mode;
 
 	if (reboot_emergency)
-		emergency_reboot_disable_virtualization();
+		nmi_shootdown_cpus_on_restart();
 
 	tboot_shutdown(TB_SHUTDOWN_REBOOT);
 
@@ -876,9 +876,6 @@ static int crash_nmi_callback(unsigned int val, struct pt_regs *regs)
 	if (shootdown_callback)
 		shootdown_callback(cpu, regs);
 
-	/* Kept to VMCLEAR loaded VMCSs */
-	cpu_emergency_disable_virtualization();
-
 	atomic_dec(&waiting_for_crash_ipi);
 
 	/* Disable virtualization, usually this is an AP */
@@ -955,6 +952,8 @@ void nmi_shootdown_cpus(nmi_shootdown_cb callback)
 
 static inline void nmi_shootdown_cpus_on_restart(void)
 {
+	local_irq_disable();
+
 	if (!crash_ipi_issued)
 		nmi_shootdown_cpus(NULL);
 }
diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index eb6a389ba1a9..b4f50c88e7e2 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -124,9 +124,6 @@ static int smp_stop_nmi_callback(unsigned int val, struct pt_regs *regs)
 	if (raw_smp_processor_id() == atomic_read(&stopping_cpu))
 		return NMI_HANDLED;
 
-	/* Kept to VMCLEAR loaded VMCSs */
-	cpu_emergency_disable_virtualization();
-
 	stop_this_cpu(NULL);
 
 	return NMI_HANDLED;
@@ -139,9 +136,6 @@ DEFINE_IDTENTRY_SYSVEC(sysvec_reboot)
 {
 	apic_eoi();
 
-	/* Kept to VMCLEAR loaded VMCSs */
-	cpu_emergency_disable_virtualization();
-
 	stop_this_cpu(NULL);
 }
 
diff --git a/arch/x86/kvm/vmx/vmcs.h b/arch/x86/kvm/vmx/vmcs.h
index da5631924432..10cbfd567dec 100644
--- a/arch/x86/kvm/vmx/vmcs.h
+++ b/arch/x86/kvm/vmx/vmcs.h
@@ -52,8 +52,12 @@ struct vmcs_controls_shadow {
  * Track a VMCS that may be loaded on a certain CPU. If it is (cpu!=-1), also
  * remember whether it was VMLAUNCHed, and maintain a linked list of all VMCSs
  * loaded on this CPU (so we can clear them if the CPU goes down).
+ *
+ * Note, the first three members must be a list_head and two pointers, please
+ * refer to struct loaded_vmcs_basic defined in arch/x86/kernel/cpu/common.c.
  */
 struct loaded_vmcs {
+	struct list_head loaded_vmcss_on_cpu_link;
 	struct vmcs *vmcs;
 	struct vmcs *shadow_vmcs;
 	int cpu;
@@ -65,7 +69,6 @@ struct loaded_vmcs {
 	ktime_t entry_time;
 	s64 vnmi_blocked_time;
 	unsigned long *msr_bitmap;
-	struct list_head loaded_vmcss_on_cpu_link;
 	struct vmcs_host_state host_state;
 	struct vmcs_controls_shadow controls_shadow;
 };
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 26af0a8ae08f..b033288e645a 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -469,11 +469,6 @@ noinline void invept_error(unsigned long ext, u64 eptp)
 }
 
 DEFINE_PER_CPU(struct vmcs *, current_vmcs);
-/*
- * We maintain a per-CPU linked-list of VMCS loaded on that CPU. This is needed
- * when a CPU is brought down, and we need to VMCLEAR all VMCSs loaded on it.
- */
-static DEFINE_PER_CPU(struct list_head, loaded_vmcss_on_cpu);
 
 static DECLARE_BITMAP(vmx_vpid_bitmap, VMX_NR_VPIDS);
 static DEFINE_SPINLOCK(vmx_vpid_lock);
@@ -676,26 +671,6 @@ static int vmx_set_guest_uret_msr(struct vcpu_vmx *vmx,
 
 void vmx_emergency_disable_virtualization_cpu(void)
 {
-	int cpu = raw_smp_processor_id();
-	struct loaded_vmcs *v;
-
-	kvm_rebooting = true;
-
-	/*
-	 * Note, CR4.VMXE can be _cleared_ in NMI context, but it can only be
-	 * set in task context.  If this races with VMX is disabled by an NMI,
-	 * VMCLEAR and VMXOFF may #UD, but KVM will eat those faults due to
-	 * kvm_rebooting set.
-	 */
-	if (!(__read_cr4() & X86_CR4_VMXE))
-		return;
-
-	list_for_each_entry(v, &per_cpu(loaded_vmcss_on_cpu, cpu),
-			    loaded_vmcss_on_cpu_link) {
-		vmcs_clear(v->vmcs);
-		if (v->shadow_vmcs)
-			vmcs_clear(v->shadow_vmcs);
-	}
 }
 
 static void __loaded_vmcs_clear(void *arg)
@@ -1388,7 +1363,7 @@ void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu)
 		smp_rmb();
 
 		list_add(&vmx->loaded_vmcs->loaded_vmcss_on_cpu_link,
-			 &per_cpu(loaded_vmcss_on_cpu, cpu));
+			 get_loaded_vmcss_on_cpu(cpu));
 		local_irq_enable();
 	}
 
@@ -2754,7 +2729,7 @@ static void vmclear_local_loaded_vmcss(void)
 	int cpu = raw_smp_processor_id();
 	struct loaded_vmcs *v, *n;
 
-	list_for_each_entry_safe(v, n, &per_cpu(loaded_vmcss_on_cpu, cpu),
+	list_for_each_entry_safe(v, n, get_loaded_vmcss_on_cpu(cpu),
 				 loaded_vmcss_on_cpu_link)
 		__loaded_vmcs_clear(v);
 }
@@ -8441,11 +8416,8 @@ int __init vmx_init(void)
 	if (r)
 		goto err_l1d_flush;
 
-	for_each_possible_cpu(cpu) {
-		INIT_LIST_HEAD(&per_cpu(loaded_vmcss_on_cpu, cpu));
-
+	for_each_possible_cpu(cpu)
 		pi_init_cpu(cpu);
-	}
 
 	vmx_check_vmcs12_offsets();
 
-- 
2.51.0


