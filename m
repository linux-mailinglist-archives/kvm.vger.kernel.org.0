Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14E752131E9
	for <lists+kvm@lfdr.de>; Fri,  3 Jul 2020 04:50:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726367AbgGCCut (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jul 2020 22:50:49 -0400
Received: from mga11.intel.com ([192.55.52.93]:53669 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726122AbgGCCut (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jul 2020 22:50:49 -0400
IronPort-SDR: Aav8GaqXIaqNER9VWFwb2NFsiCOth6Hqo+2nA4nYOa3ANCbXNn24UvtUvdHXqczpAPfDiB2LUB
 3y2FEe3hyuCw==
X-IronPort-AV: E=McAfee;i="6000,8403,9670"; a="145215352"
X-IronPort-AV: E=Sophos;i="5.75,306,1589266800"; 
   d="scan'208";a="145215352"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2020 19:50:48 -0700
IronPort-SDR: Ryb+uzj/cdSPq8TexoPl9iNgw04qYNPy19LxT5VOX6zyKwUJoYX0+4sZNWy2y3R5g991PZRcnk
 2RCWfuWfRHnQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,306,1589266800"; 
   d="scan'208";a="296082778"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by orsmga002.jf.intel.com with ESMTP; 02 Jul 2020 19:50:48 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Xiong Zhang <xiong.y.zhang@intel.com>,
        Wayne Boyer <wayne.boyer@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Jun Nakajima <jun.nakajima@intel.com>
Subject: [PATCH] KVM: x86/mmu: Add capability to zap only sptes for the affected memslot
Date:   Thu,  2 Jul 2020 19:50:47 -0700
Message-Id: <20200703025047.13987-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce a new capability, KVM_CAP_MEMSLOT_ZAP_CONTROL, to allow
userspace to control the memslot zapping behavior on a per-VM basis.
x86's default behavior is to zap all SPTEs, including the root shadow
page, across all memslots.  While effective, the nuke and pave approach
isn't exactly performant, especially for large VMs and/or VMs that
heavily utilize RO memslots for MMIO devices, e.g. option ROMs.

On a vanilla VM with 6gb of RAM, the targeted zap reduces the number of
EPT violations during boot by ~14% with THP enabled in the host, and by
~7% with THP disabled in the host.  On a much more custom VM with 32gb
and a significant amount of memslot zapping, this can reduce the number
of EPT violations by 50% during guest boot, and improve boot time by
as much as 25%.

Keep the current x86 memslot zapping behavior as the default, as there's
an unresolved bug that pops up when zapping only the affected memslot,
and the exact conditions that trigger the bug are not fully known.  See
https://patchwork.kernel.org/patch/10798453 for details.

Implement the capability as a set of flags so that other architectures
might be able to use the capability without having to conform to x86's
semantics.

Cc: Xiong Zhang <xiong.y.zhang@intel.com>
Cc: Wayne Boyer <wayne.boyer@intel.com>
Cc: Zhenyu Wang <zhenyuw@linux.intel.com>
Cc: Jun Nakajima <jun.nakajima@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 Documentation/virt/kvm/api.rst  | 21 +++++++++++++++++++++
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/mmu/mmu.c          | 21 ++++++++++++++++++++-
 arch/x86/kvm/x86.c              | 10 ++++++++++
 include/uapi/linux/kvm.h        |  4 ++++
 5 files changed, 57 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 426f94582b7a..4b7b48e9a376 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -5843,6 +5843,27 @@ controlled by the kvm module parameter halt_poll_ns. This capability allows
 the maximum halt time to specified on a per-VM basis, effectively overriding
 the module parameter for the target VM.
 
+7.21 KVM_CAP_MEMSLOT_ZAP_CONTROL
+--------------------------------
+
+:Architectures: x86
+:Target: VM
+:Parameters: args[0] controls which flags are enabled/disabled
+:Returns: 0 on success; -1 on error
+
+Valid flags are::
+
+  #define KVM_ZAP_ONLY_MEMSLOT_SPTES   (1 << 0)
+
+This capability allows userspace to control the shadow PTE zapping behavior
+when a memslot is deleted or moved via KVM_SET_USER_MEMORY_REGION.  By default,
+x86 zaps all SPTEs across all memslots, which can negatively impact performance
+but may be necessary for functional correctness for certain configurations.
+
+If KVM_ZAP_ONLY_MEMSLOT_SPTES is set, KVM zaps only the leaf/last SPTEs for the
+deleted/moved memslot.  Upper level SPTEs are retained, as are SPTEs for other
+memslots.
+
 8. Other capabilities.
 ======================
 
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f852ee350beb..6803681238f5 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1002,6 +1002,8 @@ struct kvm_arch {
 	bool guest_can_read_msr_platform_info;
 	bool exception_payload_enabled;
 
+	bool zap_only_memslot_sptes;
+
 	struct kvm_pmu_event_filter *pmu_event_filter;
 	struct task_struct *nx_lpage_recovery_thread;
 };
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 3dd0af7e7515..45edcf5dcd50 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5806,11 +5806,30 @@ static bool kvm_has_zapped_obsolete_pages(struct kvm *kvm)
 	return unlikely(!list_empty_careful(&kvm->arch.zapped_obsolete_pages));
 }
 
+static void kvm_mmu_zap_memslot(struct kvm *kvm, struct kvm_memory_slot *slot)
+{
+	bool flush;
+
+	/*
+	 * Zapping non-leaf SPTEs, a.k.a. not-last SPTEs, isn't required, worst
+	 * case scenario we'll have unused shadow pages lying around until they
+	 * are recycled due to age or when the VM is destroyed.
+	 */
+	spin_lock(&kvm->mmu_lock);
+	flush = slot_handle_all_level(kvm, slot, kvm_zap_rmapp, true);
+	if (flush)
+		kvm_flush_remote_tlbs(kvm);
+	spin_unlock(&kvm->mmu_lock);
+}
+
 static void kvm_mmu_invalidate_zap_pages_in_memslot(struct kvm *kvm,
 			struct kvm_memory_slot *slot,
 			struct kvm_page_track_notifier_node *node)
 {
-	kvm_mmu_zap_all_fast(kvm);
+	if (kvm->arch.zap_only_memslot_sptes)
+		kvm_mmu_zap_memslot(kvm, slot);
+	else
+		kvm_mmu_zap_all_fast(kvm);
 }
 
 void kvm_mmu_init_vm(struct kvm *kvm)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 00c88c2f34e4..3e07c9e4daac 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3471,6 +3471,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_MSR_PLATFORM_INFO:
 	case KVM_CAP_EXCEPTION_PAYLOAD:
 	case KVM_CAP_SET_GUEST_DEBUG:
+	case KVM_CAP_MEMSLOT_ZAP_CONTROL:
 		r = 1;
 		break;
 	case KVM_CAP_SYNC_REGS:
@@ -4984,6 +4985,15 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		kvm->arch.exception_payload_enabled = cap->args[0];
 		r = 0;
 		break;
+	case KVM_CAP_MEMSLOT_ZAP_CONTROL:
+		r = -EINVAL;
+		if (cap->args[0] & ~(u64)KVM_ZAP_ONLY_MEMSLOT_SPTES)
+			break;
+
+		kvm->arch.zap_only_memslot_sptes = cap->args[0] &
+						   KVM_ZAP_ONLY_MEMSLOT_SPTES;
+		r = 0;
+		break;
 	default:
 		r = -EINVAL;
 		break;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 4fdf30316582..5f75c348ceed 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1031,6 +1031,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_PPC_SECURE_GUEST 181
 #define KVM_CAP_HALT_POLL 182
 #define KVM_CAP_ASYNC_PF_INT 183
+#define KVM_CAP_MEMSLOT_ZAP_CONTROL 184
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -1685,4 +1686,7 @@ struct kvm_hyperv_eventfd {
 #define KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE    (1 << 0)
 #define KVM_DIRTY_LOG_INITIALLY_SET            (1 << 1)
 
+/* Flags for KVM_CAP_MEMSLOT_ZAP_CONTROL */
+#define KVM_ZAP_ONLY_MEMSLOT_SPTES	(1 << 0)
+
 #endif /* __LINUX_KVM_H */
-- 
2.26.0

