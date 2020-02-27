Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB3F6172B49
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2020 23:31:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730264AbgB0Wav (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Feb 2020 17:30:51 -0500
Received: from mga04.intel.com ([192.55.52.120]:35152 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729850AbgB0Wav (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Feb 2020 17:30:51 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Feb 2020 14:30:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,493,1574150400"; 
   d="scan'208";a="385312250"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga004.jf.intel.com with ESMTP; 27 Feb 2020 14:30:49 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] KVM: VMX: Always VMCLEAR in-use VMCSes during crash with kexec support
Date:   Thu, 27 Feb 2020 14:30:45 -0800
Message-Id: <20200227223047.13125-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200227223047.13125-1-sean.j.christopherson@intel.com>
References: <20200227223047.13125-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

VMCLEAR all in-use VMCSes during a crash, even if kdump's NMI shootdown
interrupted a KVM update of the percpu in-use VMCS list.

Because NMIs are not blocked by disabling IRQs, it's possible that
crash_vmclear_local_loaded_vmcss() could be called while the percpu list
of VMCSes is being modified, e.g. in the middle of list_add() in
vmx_vcpu_load_vmcs().  This potential corner case was called out in the
original commit[*], but the analysis of its impact was wrong.

Skipping the VMCLEARs is wrong because it all but guarantees that a
loaded, and therefore cached, VMCS will live across kexec and corrupt
memory in the new kernel.  Corruption will occur because the CPU's VMCS
cache is non-coherent, i.e. not snooped, and so the writeback of VMCS
memory on its eviction will overwrite random memory in the new kernel.
The VMCS will live because the NMI shootdown also disables VMX, i.e. the
in-progress VMCLEAR will #UD, and existing Intel CPUs do not flush the
VMCS cache on VMXOFF.

Furthermore, interrupting list_add() and list_del() is safe due to
crash_vmclear_local_loaded_vmcss() using forward iteration.  list_add()
ensures the new entry is not visible to forward iteration unless the
entire add completes, via WRITE_ONCE(prev->next, new).  A bad "prev"
pointer could be observed if the NMI shootdown interrupted list_del() or
list_add(), but list_for_each_entry() does not consume ->prev.

In addition to removing the temporary disabling of VMCLEAR, move the
list_del() from __loaded_vmcs_clear() to loaded_vmcs_init() so that the
VMCS is deleted from the list only after it's been VMCLEAR'd.  Deleting
the VMCS before VMCLEAR would allow a race where the NMI shootdown could
arrive between list_del() and vmcs_clear() and thus neither flow would
execute a successful VMCLEAR.

Update the smp_*() comments related to the list manipulation, and
opportunistically reword them to improve clarity.

[*] https://patchwork.kernel.org/patch/1675731/#3720461

Fixes: 8f536b7697a0 ("KVM: VMX: provide the vmclear function and a bitmap to support VMCLEAR in kdump")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 79 +++++++++++-------------------------------
 arch/x86/kvm/vmx/vmx.h |  2 +-
 2 files changed, 22 insertions(+), 59 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index a04017bdae05..2648b2214407 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -654,53 +654,39 @@ static int vmx_set_guest_msr(struct vcpu_vmx *vmx, struct shared_msr_entry *msr,
 	return ret;
 }
 
-void loaded_vmcs_init(struct loaded_vmcs *loaded_vmcs)
+void loaded_vmcs_init(struct loaded_vmcs *loaded_vmcs, bool in_use)
 {
 	vmcs_clear(loaded_vmcs->vmcs);
 	if (loaded_vmcs->shadow_vmcs && loaded_vmcs->launched)
 		vmcs_clear(loaded_vmcs->shadow_vmcs);
+
+	if (in_use) {
+		list_del(&loaded_vmcs->loaded_vmcss_on_cpu_link);
+
+		/*
+		 * Ensure deleting loaded_vmcs from its current percpu list
+		 * completes before setting loaded_vmcs->vcpu to -1, otherwise
+		 * a different cpu can see vcpu == -1 first and add loaded_vmcs
+		 * to its percpu list before it's deleted from this cpu's list.
+		 * Pairs with the smp_rmb() in vmx_vcpu_load_vmcs().
+		 */
+		smp_wmb();
+	}
+
 	loaded_vmcs->cpu = -1;
 	loaded_vmcs->launched = 0;
 }
 
 #ifdef CONFIG_KEXEC_CORE
-/*
- * This bitmap is used to indicate whether the vmclear
- * operation is enabled on all cpus. All disabled by
- * default.
- */
-static cpumask_t crash_vmclear_enabled_bitmap = CPU_MASK_NONE;
-
-static inline void crash_enable_local_vmclear(int cpu)
-{
-	cpumask_set_cpu(cpu, &crash_vmclear_enabled_bitmap);
-}
-
-static inline void crash_disable_local_vmclear(int cpu)
-{
-	cpumask_clear_cpu(cpu, &crash_vmclear_enabled_bitmap);
-}
-
-static inline int crash_local_vmclear_enabled(int cpu)
-{
-	return cpumask_test_cpu(cpu, &crash_vmclear_enabled_bitmap);
-}
-
 static void crash_vmclear_local_loaded_vmcss(void)
 {
 	int cpu = raw_smp_processor_id();
 	struct loaded_vmcs *v;
 
-	if (!crash_local_vmclear_enabled(cpu))
-		return;
-
 	list_for_each_entry(v, &per_cpu(loaded_vmcss_on_cpu, cpu),
 			    loaded_vmcss_on_cpu_link)
 		vmcs_clear(v->vmcs);
 }
-#else
-static inline void crash_enable_local_vmclear(int cpu) { }
-static inline void crash_disable_local_vmclear(int cpu) { }
 #endif /* CONFIG_KEXEC_CORE */
 
 static void __loaded_vmcs_clear(void *arg)
@@ -712,19 +698,8 @@ static void __loaded_vmcs_clear(void *arg)
 		return; /* vcpu migration can race with cpu offline */
 	if (per_cpu(current_vmcs, cpu) == loaded_vmcs->vmcs)
 		per_cpu(current_vmcs, cpu) = NULL;
-	crash_disable_local_vmclear(cpu);
-	list_del(&loaded_vmcs->loaded_vmcss_on_cpu_link);
 
-	/*
-	 * we should ensure updating loaded_vmcs->loaded_vmcss_on_cpu_link
-	 * is before setting loaded_vmcs->vcpu to -1 which is done in
-	 * loaded_vmcs_init. Otherwise, other cpu can see vcpu = -1 fist
-	 * then adds the vmcs into percpu list before it is deleted.
-	 */
-	smp_wmb();
-
-	loaded_vmcs_init(loaded_vmcs);
-	crash_enable_local_vmclear(cpu);
+	loaded_vmcs_init(loaded_vmcs, true);
 }
 
 void loaded_vmcs_clear(struct loaded_vmcs *loaded_vmcs)
@@ -1343,18 +1318,17 @@ void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu)
 	if (!already_loaded) {
 		loaded_vmcs_clear(vmx->loaded_vmcs);
 		local_irq_disable();
-		crash_disable_local_vmclear(cpu);
 
 		/*
-		 * Read loaded_vmcs->cpu should be before fetching
-		 * loaded_vmcs->loaded_vmcss_on_cpu_link.
-		 * See the comments in __loaded_vmcs_clear().
+		 * Ensure loaded_vmcs->cpu is read before adding loaded_vmcs to
+		 * this cpu's percpu list, otherwise it may not yet be deleted
+		 * from its previous cpu's percpu list.  Pairs with the
+		 * smb_wmb() in loaded_vmcs_init().
 		 */
 		smp_rmb();
 
 		list_add(&vmx->loaded_vmcs->loaded_vmcss_on_cpu_link,
 			 &per_cpu(loaded_vmcss_on_cpu, cpu));
-		crash_enable_local_vmclear(cpu);
 		local_irq_enable();
 	}
 
@@ -2290,17 +2264,6 @@ static int hardware_enable(void)
 	INIT_LIST_HEAD(&per_cpu(blocked_vcpu_on_cpu, cpu));
 	spin_lock_init(&per_cpu(blocked_vcpu_on_cpu_lock, cpu));
 
-	/*
-	 * Now we can enable the vmclear operation in kdump
-	 * since the loaded_vmcss_on_cpu list on this cpu
-	 * has been initialized.
-	 *
-	 * Though the cpu is not in VMX operation now, there
-	 * is no problem to enable the vmclear operation
-	 * for the loaded_vmcss_on_cpu list is empty!
-	 */
-	crash_enable_local_vmclear(cpu);
-
 	kvm_cpu_vmxon(phys_addr);
 	if (enable_ept)
 		ept_sync_global();
@@ -2603,7 +2566,7 @@ int alloc_loaded_vmcs(struct loaded_vmcs *loaded_vmcs)
 
 	loaded_vmcs->shadow_vmcs = NULL;
 	loaded_vmcs->hv_timer_soft_disabled = false;
-	loaded_vmcs_init(loaded_vmcs);
+	loaded_vmcs_init(loaded_vmcs, false);
 
 	if (cpu_has_vmx_msr_bitmap()) {
 		loaded_vmcs->msr_bitmap = (unsigned long *)
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index e64da06c7009..a0a93b2a238e 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -493,7 +493,7 @@ struct vmcs *alloc_vmcs_cpu(bool shadow, int cpu, gfp_t flags);
 void free_vmcs(struct vmcs *vmcs);
 int alloc_loaded_vmcs(struct loaded_vmcs *loaded_vmcs);
 void free_loaded_vmcs(struct loaded_vmcs *loaded_vmcs);
-void loaded_vmcs_init(struct loaded_vmcs *loaded_vmcs);
+void loaded_vmcs_init(struct loaded_vmcs *loaded_vmcs, bool in_use);
 void loaded_vmcs_clear(struct loaded_vmcs *loaded_vmcs);
 
 static inline struct vmcs *alloc_vmcs(bool shadow)
-- 
2.24.1

