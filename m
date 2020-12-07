Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 274C42D1B37
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 21:50:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727670AbgLGUs4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 15:48:56 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:42606 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727571AbgLGUsy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Dec 2020 15:48:54 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 5E409305D48B;
        Mon,  7 Dec 2020 22:46:26 +0200 (EET)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 3B6A53072784;
        Mon,  7 Dec 2020 22:46:26 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v11 80/81] KVM: introspection: emulate a guest page table walk on SPT violations due to A/D bit updates
Date:   Mon,  7 Dec 2020 22:46:21 +0200
Message-Id: <20201207204622.15258-81-alazar@bitdefender.com>
In-Reply-To: <20201207204622.15258-1-alazar@bitdefender.com>
References: <20201207204622.15258-1-alazar@bitdefender.com>
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
index 31500d3ff69d..0502293bd0c9 100644
--- a/arch/x86/include/asm/kvmi_host.h
+++ b/arch/x86/include/asm/kvmi_host.h
@@ -77,6 +77,7 @@ bool kvmi_descriptor_event(struct kvm_vcpu *vcpu, u8 descriptor, bool write);
 bool kvmi_msr_event(struct kvm_vcpu *vcpu, struct msr_data *msr);
 bool kvmi_monitor_msrw_intercept(struct kvm_vcpu *vcpu, u32 msr, bool enable);
 bool kvmi_msrw_intercept_originator(struct kvm_vcpu *vcpu);
+bool kvmi_update_ad_flags(struct kvm_vcpu *vcpu);
 
 #else /* CONFIG_KVM_INTROSPECTION */
 
@@ -102,6 +103,7 @@ static inline bool kvmi_monitor_msrw_intercept(struct kvm_vcpu *vcpu, u32 msr,
 					       bool enable) { return false; }
 static inline bool kvmi_msrw_intercept_originator(struct kvm_vcpu *vcpu)
 				{ return false; }
+static inline bool kvmi_update_ad_flags(struct kvm_vcpu *vcpu) { return false; }
 
 #endif /* CONFIG_KVM_INTROSPECTION */
 
diff --git a/arch/x86/kvm/kvmi.c b/arch/x86/kvm/kvmi.c
index b010d2369756..6dc5df59f274 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -1099,3 +1099,33 @@ void kvmi_arch_stop_singlestep(struct kvm_vcpu *vcpu)
 {
 	kvm_x86_ops.control_singlestep(vcpu, false);
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
+	gva = kvm_x86_ops.fault_gla(vcpu);
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
index f79cf58a27dc..204e44d4e465 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -43,6 +43,7 @@
 #include <linux/hash.h>
 #include <linux/kern_levels.h>
 #include <linux/kthread.h>
+#include <linux/kvmi_host.h>
 
 #include <asm/page.h>
 #include <asm/memtype.h>
@@ -5184,8 +5185,15 @@ int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 error_code,
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
index 4f9da76c6777..0474d85b54a4 100644
--- a/virt/kvm/introspection/kvmi.c
+++ b/virt/kvm/introspection/kvmi.c
@@ -1236,3 +1236,29 @@ void kvmi_singlestep_failed(struct kvm_vcpu *vcpu)
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
