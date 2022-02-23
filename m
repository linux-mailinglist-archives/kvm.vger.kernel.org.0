Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F8DF4C0BED
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 06:25:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238229AbiBWFZv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 00:25:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238249AbiBWFZg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 00:25:36 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE7516B096
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 21:24:32 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id s133-20020a252c8b000000b0062112290d0bso26612868ybs.23
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 21:24:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=CYYrqCq/zRkZaGiiFDeL2WZqXbaiwLweAdvv3KPw30Q=;
        b=gttTspcTbeOxem9vIHTEp8HxBKLNL6kOKKunFMomQY7gQjAmmA7zLLKeW3pD5BHCG4
         n+cavMcNG3z81q2MsF1OUm8LD7b7lNc/CiICe2jeX2JuESrjhWO3zBSCqlZo0v8ri/13
         wSpPkKBkIUU4Lon1cqB6YDkf8UKIBOe6n1yOTYHkccD+ZHQbtAOffPifXTCZr0f1Etmj
         7oxfXxlKJ56Y/Q570Q0HNRmXemUr5RxMgLdTEadmhWn3pzJBdmkD+yWBtTx1hkL9PZjC
         s4h9v+aGt/9IsWDNJnCTYuoYPrr3fqgrmkUg8lETXm3ikW63y2HAoRDcoo7ArQV+H7ZF
         BqDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=CYYrqCq/zRkZaGiiFDeL2WZqXbaiwLweAdvv3KPw30Q=;
        b=iTqhGO8V+NfdYd64PFstHiSwJWVW84GIIjMRnbH3xSurvg4NN1Hr2CzSQ3tlrwAo4c
         MgGTy0pfDmprVrMmJuehENKh0S0TFjJ1YtH4agpN21z2lT5uYx8IElOKxWpgZpVd9i+E
         AKuSySE3TozrfgVU70TXb3tBCYZVM0NM5/vm7CAidNPEj35bCwFD7xR49OsAyWKtGz91
         EKBORCHVf0SSC4s2pcYVbIirAuiYZqznHwX7BkbQbBLs9ulu8Y2aV3ydktPm2EBpOEOw
         WnlqtGeOe24/YPeq91zgznZBDfU0K63zk1ur3oBTk4yS8rnAapBYM0jxAwANlSWxHh48
         f2Tg==
X-Gm-Message-State: AOAM532ejSGrBccG5K0OjC8LecvWhrX/YUoo1qqZeB1oL5KBq2ZFnXQ5
        d5R91GqovP/f1pRXMN6F5jPn3EnFUE4K
X-Google-Smtp-Source: ABdhPJyHSwIU1ypDJg3UAIk4OCagkwsYrp4hfbAB5svLD0KoToAB7kgIvdsaPCw4R5P2Bj++u4Uv/BXKWrDE
X-Received: from js-desktop.svl.corp.google.com ([2620:15c:2cd:202:ccbe:5d15:e2e6:322])
 (user=junaids job=sendgmr) by 2002:a81:9842:0:b0:2cb:86f2:560d with SMTP id
 p63-20020a819842000000b002cb86f2560dmr27884434ywg.375.1645593859219; Tue, 22
 Feb 2022 21:24:19 -0800 (PST)
Date:   Tue, 22 Feb 2022 21:21:51 -0800
In-Reply-To: <20220223052223.1202152-1-junaids@google.com>
Message-Id: <20220223052223.1202152-16-junaids@google.com>
Mime-Version: 1.0
References: <20220223052223.1202152-1-junaids@google.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [RFC PATCH 15/47] kvm: asi: Restricted address space for VM execution
From:   Junaid Shahid <junaids@google.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com,
        pjt@google.com, oweisse@google.com, alexandre.chartre@oracle.com,
        rppt@linux.ibm.com, dave.hansen@linux.intel.com,
        peterz@infradead.org, tglx@linutronix.de, luto@kernel.org,
        linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

An ASI restricted address space is added for KVM. It is currently only
enabled for Intel CPUs. The ASI hooks have been setup to do an L1D
cache flush and MDS clear when entering the restricted address space.

The hooks are also meant to stun and unstun the sibling hyperthread
when exiting and entering the restricted address space. Internally,
we do have a full stunning implementation available, but it hasn't
yet been determined whether it is fully compatible with the upstream
core scheduling implementation, so it is not included in this patch
series and instead this patch just includes corresponding stub
functions to demonstrate where the stun/unstun would happen.

Signed-off-by: Junaid Shahid <junaids@google.com>


---
 arch/x86/include/asm/kvm_host.h |  2 +
 arch/x86/kvm/vmx/vmx.c          | 41 ++++++++++++-----
 arch/x86/kvm/x86.c              | 81 ++++++++++++++++++++++++++++++++-
 include/linux/kvm_host.h        |  2 +
 4 files changed, 113 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 555f4de47ef2..98cbd6447e3e 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1494,6 +1494,8 @@ struct kvm_x86_ops {
 	int (*complete_emulated_msr)(struct kvm_vcpu *vcpu, int err);
 
 	void (*vcpu_deliver_sipi_vector)(struct kvm_vcpu *vcpu, u8 vector);
+
+	void (*flush_sensitive_cpu_state)(struct kvm_vcpu *vcpu);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 0dbf94eb954f..e0178b57be75 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -47,6 +47,7 @@
 #include <asm/spec-ctrl.h>
 #include <asm/virtext.h>
 #include <asm/vmx.h>
+#include <asm/asi.h>
 
 #include "capabilities.h"
 #include "cpuid.h"
@@ -300,7 +301,7 @@ static int vmx_setup_l1d_flush(enum vmx_l1d_flush_state l1tf)
 	else
 		static_branch_disable(&vmx_l1d_should_flush);
 
-	if (l1tf == VMENTER_L1D_FLUSH_COND)
+	if (l1tf == VMENTER_L1D_FLUSH_COND && !boot_cpu_has(X86_FEATURE_ASI))
 		static_branch_enable(&vmx_l1d_flush_cond);
 	else
 		static_branch_disable(&vmx_l1d_flush_cond);
@@ -6079,6 +6080,8 @@ static noinstr void vmx_l1d_flush(struct kvm_vcpu *vcpu)
 	if (static_branch_likely(&vmx_l1d_flush_cond)) {
 		bool flush_l1d;
 
+		VM_BUG_ON(vcpu->kvm->asi);
+
 		/*
 		 * Clear the per-vcpu flush bit, it gets set again
 		 * either from vcpu_run() or from one of the unsafe
@@ -6590,16 +6593,31 @@ static fastpath_t vmx_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
 	}
 }
 
-static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
-					struct vcpu_vmx *vmx)
+static void vmx_flush_sensitive_cpu_state(struct kvm_vcpu *vcpu)
 {
-	kvm_guest_enter_irqoff();
-
 	/* L1D Flush includes CPU buffer clear to mitigate MDS */
 	if (static_branch_unlikely(&vmx_l1d_should_flush))
 		vmx_l1d_flush(vcpu);
 	else if (static_branch_unlikely(&mds_user_clear))
 		mds_clear_cpu_buffers();
+}
+
+static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
+					struct vcpu_vmx *vmx)
+{
+	unsigned long cr3;
+
+	kvm_guest_enter_irqoff();
+
+	vmx_flush_sensitive_cpu_state(vcpu);
+
+	asi_enter(vcpu->kvm->asi);
+
+	cr3 = __get_current_cr3_fast();
+	if (unlikely(cr3 != vmx->loaded_vmcs->host_state.cr3)) {
+		vmcs_writel(HOST_CR3, cr3);
+		vmx->loaded_vmcs->host_state.cr3 = cr3;
+	}
 
 	if (vcpu->arch.cr2 != native_read_cr2())
 		native_write_cr2(vcpu->arch.cr2);
@@ -6609,13 +6627,16 @@ static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
 
 	vcpu->arch.cr2 = native_read_cr2();
 
+	VM_WARN_ON_ONCE(vcpu->kvm->asi && !is_asi_active());
+	asi_set_target_unrestricted();
+
 	kvm_guest_exit_irqoff();
 }
 
 static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	unsigned long cr3, cr4;
+	unsigned long cr4;
 
 	/* Record the guest's net vcpu time for enforced NMI injections. */
 	if (unlikely(!enable_vnmi &&
@@ -6657,12 +6678,6 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	if (kvm_register_is_dirty(vcpu, VCPU_REGS_RIP))
 		vmcs_writel(GUEST_RIP, vcpu->arch.regs[VCPU_REGS_RIP]);
 
-	cr3 = __get_current_cr3_fast();
-	if (unlikely(cr3 != vmx->loaded_vmcs->host_state.cr3)) {
-		vmcs_writel(HOST_CR3, cr3);
-		vmx->loaded_vmcs->host_state.cr3 = cr3;
-	}
-
 	cr4 = cr4_read_shadow();
 	if (unlikely(cr4 != vmx->loaded_vmcs->host_state.cr4)) {
 		vmcs_writel(HOST_CR4, cr4);
@@ -7691,6 +7706,8 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.complete_emulated_msr = kvm_complete_insn_gp,
 
 	.vcpu_deliver_sipi_vector = kvm_vcpu_deliver_sipi_vector,
+
+	.flush_sensitive_cpu_state = vmx_flush_sensitive_cpu_state,
 };
 
 static __init void vmx_setup_user_return_msrs(void)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e50e97ac4408..dd07f677d084 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -81,6 +81,7 @@
 #include <asm/emulate_prefix.h>
 #include <asm/sgx.h>
 #include <clocksource/hyperv_timer.h>
+#include <asm/asi.h>
 
 #define CREATE_TRACE_POINTS
 #include "trace.h"
@@ -297,6 +298,8 @@ EXPORT_SYMBOL_GPL(supported_xcr0);
 
 static struct kmem_cache *x86_emulator_cache;
 
+static int __read_mostly kvm_asi_index;
+
 /*
  * When called, it means the previous get/set msr reached an invalid msr.
  * Return true if we want to ignore/silent this failed msr access.
@@ -8620,6 +8623,50 @@ static struct notifier_block pvclock_gtod_notifier = {
 };
 #endif
 
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+
+/*
+ * We have an HT-stunning implementation available internally,
+ * but it is yet to be determined if it is fully compatible with the
+ * upstream core scheduling implementation. So leaving it out for now
+ * and just leaving these stubs here.
+ */
+static void stun_sibling(void) { }
+static void unstun_sibling(void) { }
+
+/*
+ * This function must be fully re-entrant and idempotent.
+ * Though the idempotency requirement could potentially be relaxed for stuff
+ * like stats where complete accuracy is not needed.
+ */
+static void kvm_pre_asi_exit(void)
+{
+	stun_sibling();
+}
+
+/*
+ * This function must be fully re-entrant and idempotent.
+ * Though the idempotency requirement could potentially be relaxed for stuff
+ * like stats where complete accuracy is not needed.
+ */
+static void kvm_post_asi_enter(void)
+{
+	struct kvm_vcpu *vcpu = raw_cpu_read(*kvm_get_running_vcpus());
+
+	kvm_x86_ops.flush_sensitive_cpu_state(vcpu);
+
+	unstun_sibling();
+}
+
+#endif
+
+static const struct asi_hooks kvm_asi_hooks = {
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+	.pre_asi_exit = kvm_pre_asi_exit,
+	.post_asi_enter = kvm_post_asi_enter
+#endif
+};
+
 int kvm_arch_init(void *opaque)
 {
 	struct kvm_x86_init_ops *ops = opaque;
@@ -8674,6 +8721,15 @@ int kvm_arch_init(void *opaque)
 	if (r)
 		goto out_free_percpu;
 
+	if (ops->runtime_ops->flush_sensitive_cpu_state) {
+		r = asi_register_class("KVM", ASI_MAP_STANDARD_NONSENSITIVE,
+				       &kvm_asi_hooks);
+		if (r < 0)
+			goto out_mmu_exit;
+
+		kvm_asi_index = r;
+	}
+
 	kvm_timer_init();
 
 	perf_register_guest_info_callbacks(&kvm_guest_cbs);
@@ -8694,6 +8750,8 @@ int kvm_arch_init(void *opaque)
 
 	return 0;
 
+out_mmu_exit:
+	kvm_mmu_module_exit();
 out_free_percpu:
 	free_percpu(user_return_msrs);
 out_free_x86_emulator_cache:
@@ -8720,6 +8778,11 @@ void kvm_arch_exit(void)
 	irq_work_sync(&pvclock_irq_work);
 	cancel_work_sync(&pvclock_gtod_work);
 #endif
+	if (kvm_asi_index > 0) {
+		asi_unregister_class(kvm_asi_index);
+		kvm_asi_index = 0;
+	}
+
 	kvm_x86_ops.hardware_enable = NULL;
 	kvm_mmu_module_exit();
 	free_percpu(user_return_msrs);
@@ -11391,11 +11454,26 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	INIT_DELAYED_WORK(&kvm->arch.kvmclock_sync_work, kvmclock_sync_fn);
 
 	kvm_apicv_init(kvm);
+
+	if (kvm_asi_index > 0) {
+		ret = asi_init(kvm->mm, kvm_asi_index, &kvm->asi);
+		if (ret)
+			goto error;
+	}
+
 	kvm_hv_init_vm(kvm);
 	kvm_mmu_init_vm(kvm);
 	kvm_xen_init_vm(kvm);
 
-	return static_call(kvm_x86_vm_init)(kvm);
+	ret = static_call(kvm_x86_vm_init)(kvm);
+	if (ret)
+		goto error;
+
+	return 0;
+error:
+	kvm_page_track_cleanup(kvm);
+	asi_destroy(kvm->asi);
+	return ret;
 }
 
 int kvm_arch_post_init_vm(struct kvm *kvm)
@@ -11549,6 +11627,7 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 	kvm_page_track_cleanup(kvm);
 	kvm_xen_destroy_vm(kvm);
 	kvm_hv_destroy_vm(kvm);
+	asi_destroy(kvm->asi);
 }
 
 static void memslot_rmap_free(struct kvm_memory_slot *slot)
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index c310648cc8f1..9dd63ed21f75 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -38,6 +38,7 @@
 
 #include <asm/kvm_host.h>
 #include <linux/kvm_dirty_ring.h>
+#include <asm/asi.h>
 
 #ifndef KVM_MAX_VCPU_IDS
 #define KVM_MAX_VCPU_IDS KVM_MAX_VCPUS
@@ -551,6 +552,7 @@ struct kvm {
 	 */
 	struct mutex slots_arch_lock;
 	struct mm_struct *mm; /* userspace tied to this vm */
+	struct asi *asi;
 	struct kvm_memslots __rcu *memslots[KVM_ADDRESS_SPACE_NUM];
 	struct kvm_vcpu *vcpus[KVM_MAX_VCPUS];
 
-- 
2.35.1.473.g83b2b277ed-goog

