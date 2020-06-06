Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 998B91F04F3
	for <lists+kvm@lfdr.de>; Sat,  6 Jun 2020 06:36:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726203AbgFFEgj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 6 Jun 2020 00:36:39 -0400
Received: from [192.146.154.243] ([192.146.154.243]:59784 "EHLO
        mcp01.nutanix.com" rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725931AbgFFEgj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 6 Jun 2020 00:36:39 -0400
X-Greylist: delayed 557 seconds by postgrey-1.27 at vger.kernel.org; Sat, 06 Jun 2020 00:36:39 EDT
Received: from C02Z20B5LVDL.corp.nutanix.com (unknown [10.150.245.9])
        by mcp01.nutanix.com (Postfix) with ESMTP id A26EB102CA91;
        Sat,  6 Jun 2020 04:27:18 +0000 (UTC)
From:   Eiichi Tsukata <eiichi.tsukata@nutanix.com>
To:     pbonzini@redhat.com, sean.j.christopherson@intel.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     felipe.franciosi@nutanix.com, rkrcmar@redhat.com,
        Eiichi Tsukata <eiichi.tsukata@nutanix.com>
Subject: [RFC PATCH] KVM: x86: Fix APIC page invalidation race
Date:   Sat,  6 Jun 2020 13:26:27 +0900
Message-Id: <20200606042627.61070-1-eiichi.tsukata@nutanix.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit b1394e745b94 ("KVM: x86: fix APIC page invalidation") tried to
fix inappropriate APIC page invalidation by re-introducing arch specific
kvm_arch_mmu_notifier_invalidate_range() and calling it from
kvm_mmu_notifier_invalidate_range_start. But threre could be the
following race because VMCS APIC address cache can be updated
*before* it is unmapped.

Race:
  (Invalidator) kvm_mmu_notifier_invalidate_range_start()
  (Invalidator) kvm_make_all_cpus_request(kvm, KVM_REQ_APIC_PAGE_RELOAD)
  (KVM VCPU) vcpu_enter_guest()
  (KVM VCPU) kvm_vcpu_reload_apic_access_page()
  (Invalidator) actually unmap page

Symptom:
  The above race can make Guest OS see already freed page and Guest OS
will see broken APIC register values. Especially, Windows OS checks
LAPIC modification so it can cause BSOD crash with BugCheck
CRITICAL_STRUCTURE_CORRUPTION (109). These symptoms are the same as we
previously saw in https://bugzilla.kernel.org/show_bug.cgi?id=197951 and
we are currently seeing in
https://bugzilla.redhat.com/show_bug.cgi?id=1751017.

To prevent Guest OS from accessing already freed page, this patch calls
kvm_arch_mmu_notifier_invalidate_range() from
kvm_mmu_notifier_invalidate_range() instead of ..._range_start().

Fixes: b1394e745b94 ("KVM: x86: fix APIC page invalidation")
Signed-off-by: Eiichi Tsukata <eiichi.tsukata@nutanix.com>
---
 arch/x86/kvm/x86.c       |  7 ++-----
 include/linux/kvm_host.h |  4 ++--
 virt/kvm/kvm_main.c      | 26 ++++++++++++++++----------
 3 files changed, 20 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c17e6eb9ad43..1700aade39d1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8150,9 +8150,8 @@ static void vcpu_load_eoi_exitmap(struct kvm_vcpu *vcpu)
 	kvm_x86_ops.load_eoi_exitmap(vcpu, eoi_exit_bitmap);
 }
 
-int kvm_arch_mmu_notifier_invalidate_range(struct kvm *kvm,
-		unsigned long start, unsigned long end,
-		bool blockable)
+void kvm_arch_mmu_notifier_invalidate_range(struct kvm *kvm,
+					    unsigned long start, unsigned long end)
 {
 	unsigned long apic_address;
 
@@ -8163,8 +8162,6 @@ int kvm_arch_mmu_notifier_invalidate_range(struct kvm *kvm,
 	apic_address = gfn_to_hva(kvm, APIC_DEFAULT_PHYS_BASE >> PAGE_SHIFT);
 	if (start <= apic_address && apic_address < end)
 		kvm_make_all_cpus_request(kvm, KVM_REQ_APIC_PAGE_RELOAD);
-
-	return 0;
 }
 
 void kvm_vcpu_reload_apic_access_page(struct kvm_vcpu *vcpu)
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 131cc1527d68..92efa39ea3d7 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1406,8 +1406,8 @@ static inline long kvm_arch_vcpu_async_ioctl(struct file *filp,
 }
 #endif /* CONFIG_HAVE_KVM_VCPU_ASYNC_IOCTL */
 
-int kvm_arch_mmu_notifier_invalidate_range(struct kvm *kvm,
-		unsigned long start, unsigned long end, bool blockable);
+void kvm_arch_mmu_notifier_invalidate_range(struct kvm *kvm,
+					    unsigned long start, unsigned long end);
 
 #ifdef CONFIG_HAVE_KVM_VCPU_RUN_PID_CHANGE
 int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 731c1e517716..77aa91fb08d2 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -155,10 +155,9 @@ static void kvm_uevent_notify_change(unsigned int type, struct kvm *kvm);
 static unsigned long long kvm_createvm_count;
 static unsigned long long kvm_active_vms;
 
-__weak int kvm_arch_mmu_notifier_invalidate_range(struct kvm *kvm,
-		unsigned long start, unsigned long end, bool blockable)
+__weak void kvm_arch_mmu_notifier_invalidate_range(struct kvm *kvm,
+						   unsigned long start, unsigned long end)
 {
-	return 0;
 }
 
 bool kvm_is_zone_device_pfn(kvm_pfn_t pfn)
@@ -384,6 +383,18 @@ static inline struct kvm *mmu_notifier_to_kvm(struct mmu_notifier *mn)
 	return container_of(mn, struct kvm, mmu_notifier);
 }
 
+static void kvm_mmu_notifier_invalidate_range(struct mmu_notifier *mn,
+					      struct mm_struct *mm,
+					      unsigned long start, unsigned long end)
+{
+	struct kvm *kvm = mmu_notifier_to_kvm(mn);
+	int idx;
+
+	idx = srcu_read_lock(&kvm->srcu);
+	kvm_arch_mmu_notifier_invalidate_range(kvm, start, end);
+	srcu_read_unlock(&kvm->srcu, idx);
+}
+
 static void kvm_mmu_notifier_change_pte(struct mmu_notifier *mn,
 					struct mm_struct *mm,
 					unsigned long address,
@@ -408,7 +419,6 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
 {
 	struct kvm *kvm = mmu_notifier_to_kvm(mn);
 	int need_tlb_flush = 0, idx;
-	int ret;
 
 	idx = srcu_read_lock(&kvm->srcu);
 	spin_lock(&kvm->mmu_lock);
@@ -425,14 +435,9 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
 		kvm_flush_remote_tlbs(kvm);
 
 	spin_unlock(&kvm->mmu_lock);
-
-	ret = kvm_arch_mmu_notifier_invalidate_range(kvm, range->start,
-					range->end,
-					mmu_notifier_range_blockable(range));
-
 	srcu_read_unlock(&kvm->srcu, idx);
 
-	return ret;
+	return 0;
 }
 
 static void kvm_mmu_notifier_invalidate_range_end(struct mmu_notifier *mn,
@@ -538,6 +543,7 @@ static void kvm_mmu_notifier_release(struct mmu_notifier *mn,
 }
 
 static const struct mmu_notifier_ops kvm_mmu_notifier_ops = {
+	.invalidate_range	= kvm_mmu_notifier_invalidate_range,
 	.invalidate_range_start	= kvm_mmu_notifier_invalidate_range_start,
 	.invalidate_range_end	= kvm_mmu_notifier_invalidate_range_end,
 	.clear_flush_young	= kvm_mmu_notifier_clear_flush_young,
-- 
2.21.3

