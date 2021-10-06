Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9F754244AA
	for <lists+kvm@lfdr.de>; Wed,  6 Oct 2021 19:40:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239509AbhJFRms (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Oct 2021 13:42:48 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:53560 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238932AbhJFRmg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 Oct 2021 13:42:36 -0400
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 8B96A3086400;
        Wed,  6 Oct 2021 20:31:25 +0300 (EEST)
Received: from localhost (unknown [91.199.104.28])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 73A973064495;
        Wed,  6 Oct 2021 20:31:25 +0300 (EEST)
X-Is-Junk-Enabled: fGZTSsP0qEJE2AIKtlSuFiRRwg9xyHmJ
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Mathieu Tarral <mathieu.tarral@protonmail.com>,
        Tamas K Lengyel <tamas@tklengyel.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v12 76/77] KVM: introspection: emulate a guest page table walk on SPT violations due to A/D bit updates
Date:   Wed,  6 Oct 2021 20:31:12 +0300
Message-Id: <20211006173113.26445-77-alazar@bitdefender.com>
In-Reply-To: <20211006173113.26445-1-alazar@bitdefender.com>
References: <20211006173113.26445-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Mihai Donțu <mdontu@bitdefender.com>

On SPT page faults caused by guest page table walks, use the existing
guest page table walk code to make the necessary adjustments to the A/D
bits and return to guest. This effectively bypasses the x86 emulator
who was making the wrong modifications leading one OS (Windows 8.1 x64)
to triple-fault very early in the boot process with the introspection
enabled.

With introspection disabled, these faults are handled by simply removing
the protection from the affected guest page and returning to guest.

Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/include/asm/kvmi_host.h |  2 ++
 arch/x86/kvm/kvmi.c              | 30 ++++++++++++++++++++++++++++++
 arch/x86/kvm/mmu/mmu.c           | 12 ++++++++++--
 include/linux/kvmi_host.h        |  3 +++
 virt/kvm/introspection/kvmi.c    | 26 ++++++++++++++++++++++++++
 5 files changed, 71 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvmi_host.h b/arch/x86/include/asm/kvmi_host.h
index 045bc885f007..5a1700d36b67 100644
--- a/arch/x86/include/asm/kvmi_host.h
+++ b/arch/x86/include/asm/kvmi_host.h
@@ -78,6 +78,7 @@ bool kvmi_descriptor_event(struct kvm_vcpu *vcpu, u8 descriptor, bool write);
 bool kvmi_msr_event(struct kvm_vcpu *vcpu, struct msr_data *msr);
 bool kvmi_monitor_msrw_intercept(struct kvm_vcpu *vcpu, u32 msr, bool enable);
 bool kvmi_msrw_intercept_originator(struct kvm_vcpu *vcpu);
+bool kvmi_update_ad_flags(struct kvm_vcpu *vcpu);
 
 #else /* CONFIG_KVM_INTROSPECTION */
 
@@ -103,6 +104,7 @@ static inline bool kvmi_monitor_msrw_intercept(struct kvm_vcpu *vcpu, u32 msr,
 					       bool enable) { return false; }
 static inline bool kvmi_msrw_intercept_originator(struct kvm_vcpu *vcpu)
 				{ return false; }
+static inline bool kvmi_update_ad_flags(struct kvm_vcpu *vcpu) { return false; }
 
 #endif /* CONFIG_KVM_INTROSPECTION */
 
diff --git a/arch/x86/kvm/kvmi.c b/arch/x86/kvm/kvmi.c
index 58c2debd8815..ce387c8a1367 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -1102,3 +1102,33 @@ void kvmi_arch_stop_singlestep(struct kvm_vcpu *vcpu)
 {
 	static_call(kvm_x86_control_singlestep)(vcpu, false);
 }
+
+bool kvmi_update_ad_flags(struct kvm_vcpu *vcpu)
+{
+	struct kvm_introspection *kvmi;
+	bool ret = false;
+	gva_t gva;
+	gpa_t gpa;
+
+	kvmi = kvmi_get(vcpu->kvm);
+	if (!kvmi)
+		return false;
+
+	gva = static_call(kvm_x86_fault_gla)(vcpu);
+	if (gva == ~0ull)
+		goto out;
+
+	gpa = kvm_mmu_gva_to_gpa_system(vcpu, gva, PFERR_WRITE_MASK, NULL);
+	if (gpa == UNMAPPED_GVA) {
+		struct x86_exception exception = { };
+
+		gpa = kvm_mmu_gva_to_gpa_system(vcpu, gva, 0, &exception);
+	}
+
+	ret = (gpa != UNMAPPED_GVA);
+
+out:
+	kvmi_put(vcpu->kvm);
+
+	return ret;
+}
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c90683284098..d0a8ac891bc2 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -43,6 +43,7 @@
 #include <linux/hash.h>
 #include <linux/kern_levels.h>
 #include <linux/kthread.h>
+#include <linux/kvmi_host.h>
 
 #include <asm/page.h>
 #include <asm/memtype.h>
@@ -5333,8 +5334,15 @@ int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 error_code,
 	 */
 	if (vcpu->arch.mmu->direct_map &&
 	    (error_code & PFERR_NESTED_GUEST_PAGE) == PFERR_NESTED_GUEST_PAGE) {
-		kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(cr2_or_gpa));
-		return 1;
+		gfn_t gfn = gpa_to_gfn(cr2_or_gpa);
+
+		if (kvmi_tracked_gfn(vcpu, gfn)) {
+			if (kvmi_update_ad_flags(vcpu))
+				return 1;
+		} else {
+			kvm_mmu_unprotect_page(vcpu->kvm, gfn);
+			return 1;
+		}
 	}
 
 	/*
diff --git a/include/linux/kvmi_host.h b/include/linux/kvmi_host.h
index ec38e434c8e9..90647bb2a570 100644
--- a/include/linux/kvmi_host.h
+++ b/include/linux/kvmi_host.h
@@ -83,6 +83,7 @@ bool kvmi_breakpoint_event(struct kvm_vcpu *vcpu, u64 gva, u8 insn_len);
 bool kvmi_vcpu_running_singlestep(struct kvm_vcpu *vcpu);
 void kvmi_singlestep_done(struct kvm_vcpu *vcpu);
 void kvmi_singlestep_failed(struct kvm_vcpu *vcpu);
+bool kvmi_tracked_gfn(struct kvm_vcpu *vcpu, gfn_t gfn);
 
 #else
 
@@ -101,6 +102,8 @@ static inline bool kvmi_vcpu_running_singlestep(struct kvm_vcpu *vcpu)
 			{ return false; }
 static inline void kvmi_singlestep_done(struct kvm_vcpu *vcpu) { }
 static inline void kvmi_singlestep_failed(struct kvm_vcpu *vcpu) { }
+static inline bool kvmi_tracked_gfn(struct kvm_vcpu *vcpu, gfn_t gfn)
+			{ return false; }
 
 #endif /* CONFIG_KVM_INTROSPECTION */
 
diff --git a/virt/kvm/introspection/kvmi.c b/virt/kvm/introspection/kvmi.c
index 4ed145421d69..8ef7b3a4ef51 100644
--- a/virt/kvm/introspection/kvmi.c
+++ b/virt/kvm/introspection/kvmi.c
@@ -1237,3 +1237,29 @@ void kvmi_singlestep_failed(struct kvm_vcpu *vcpu)
 	kvmi_handle_singlestep_exit(vcpu, false);
 }
 EXPORT_SYMBOL(kvmi_singlestep_failed);
+
+static bool __kvmi_tracked_gfn(struct kvm_introspection *kvmi, gfn_t gfn)
+{
+	u8 ignored_access;
+
+	if (kvmi_get_gfn_access(kvmi, gfn, &ignored_access))
+		return false;
+
+	return true;
+}
+
+bool kvmi_tracked_gfn(struct kvm_vcpu *vcpu, gfn_t gfn)
+{
+	struct kvm_introspection *kvmi;
+	bool ret;
+
+	kvmi = kvmi_get(vcpu->kvm);
+	if (!kvmi)
+		return false;
+
+	ret = __kvmi_tracked_gfn(kvmi, gfn);
+
+	kvmi_put(vcpu->kvm);
+
+	return ret;
+}
