Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79EDF155D8A
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 19:17:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727872AbgBGSRA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 13:17:00 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:40632 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727763AbgBGSQ5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Feb 2020 13:16:57 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 15E91305D36B;
        Fri,  7 Feb 2020 20:16:42 +0200 (EET)
Received: from host.bbu.bitdefender.biz (unknown [195.210.4.22])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 054EE305207C;
        Fri,  7 Feb 2020 20:16:42 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [RFC PATCH v7 77/78] KVM: introspection: emulate a guest page table walk on SPT violations due to A/D bit updates
Date:   Fri,  7 Feb 2020 20:16:35 +0200
Message-Id: <20200207181636.1065-78-alazar@bitdefender.com>
In-Reply-To: <20200207181636.1065-1-alazar@bitdefender.com>
References: <20200207181636.1065-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
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
 arch/x86/kvm/kvmi.c              | 33 ++++++++++++++++++++++++++++++++
 arch/x86/kvm/mmu/mmu.c           | 11 +++++++++--
 include/linux/kvmi_host.h        |  3 +++
 virt/kvm/introspection/kvmi.c    | 26 +++++++++++++++++++++++++
 5 files changed, 73 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvmi_host.h b/arch/x86/include/asm/kvmi_host.h
index 2e4eff501c0a..4c2188dc4a2b 100644
--- a/arch/x86/include/asm/kvmi_host.h
+++ b/arch/x86/include/asm/kvmi_host.h
@@ -61,6 +61,7 @@ bool kvmi_descriptor_event(struct kvm_vcpu *vcpu, u8 descriptor, u8 write);
 bool kvmi_msr_event(struct kvm_vcpu *vcpu, struct msr_data *msr);
 bool kvmi_monitor_msrw_intercept(struct kvm_vcpu *vcpu, u32 msr, bool enable);
 bool kvmi_msrw_intercept_originator(struct kvm_vcpu *vcpu);
+bool kvmi_update_ad_flags(struct kvm_vcpu *vcpu);
 
 #else /* CONFIG_KVM_INTROSPECTION */
 
@@ -83,6 +84,7 @@ static inline bool kvmi_monitor_msrw_intercept(struct kvm_vcpu *vcpu, u32 msr,
 					       bool enable) { return false; }
 static inline bool kvmi_msrw_intercept_originator(struct kvm_vcpu *vcpu)
 				{ return false; }
+bool kvmi_update_ad_flags(struct kvm_vcpu *vcpu) { return false; }
 
 #endif /* CONFIG_KVM_INTROSPECTION */
 
diff --git a/arch/x86/kvm/kvmi.c b/arch/x86/kvm/kvmi.c
index 7b02bc82dbd7..229543ee90e6 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -1133,3 +1133,36 @@ gpa_t kvmi_arch_cmd_translate_gva(struct kvm_vcpu *vcpu, gva_t gva)
 {
 	return kvm_mmu_gva_to_gpa_system(vcpu, gva, 0, NULL);
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
+	gva = kvm_x86_ops->fault_gla(vcpu);
+	if (gva == ~0ull) {
+		kvmi_warn_once(kvmi, "%s: cannot perform translation\n",
+			       __func__);
+		goto out;
+	}
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
index d28b7425c4f1..603776f9bd84 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5675,8 +5675,15 @@ int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gva_t cr2, u64 error_code,
 	 */
 	if (vcpu->arch.mmu->direct_map &&
 	    (error_code & PFERR_NESTED_GUEST_PAGE) == PFERR_NESTED_GUEST_PAGE) {
-		kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(cr2));
-		return 1;
+		gfn_t gfn = gpa_to_gfn(cr2);
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
index 723a902f4b89..9a9cd7e1f75e 100644
--- a/include/linux/kvmi_host.h
+++ b/include/linux/kvmi_host.h
@@ -97,6 +97,7 @@ bool kvmi_enter_guest(struct kvm_vcpu *vcpu);
 bool kvmi_vcpu_running_singlestep(struct kvm_vcpu *vcpu);
 void kvmi_singlestep_done(struct kvm_vcpu *vcpu);
 void kvmi_singlestep_failed(struct kvm_vcpu *vcpu);
+bool kvmi_tracked_gfn(struct kvm_vcpu *vcpu, gfn_t gfn);
 
 #else
 
@@ -117,6 +118,8 @@ static inline bool kvmi_vcpu_running_singlestep(struct kvm_vcpu *vcpu)
 			{ return false; }
 static void kvmi_singlestep_done(struct kvm_vcpu *vcpu) { }
 static void kvmi_singlestep_failed(struct kvm_vcpu *vcpu) { }
+static inline bool kvmi_tracked_gfn(struct kvm_vcpu *vcpu, gfn_t gfn)
+			{ return false; }
 
 #endif /* CONFIG_KVM_INTROSPECTION */
 
diff --git a/virt/kvm/introspection/kvmi.c b/virt/kvm/introspection/kvmi.c
index 5bb3e1252242..8f3de6be6413 100644
--- a/virt/kvm/introspection/kvmi.c
+++ b/virt/kvm/introspection/kvmi.c
@@ -1380,3 +1380,29 @@ void kvmi_singlestep_failed(struct kvm_vcpu *vcpu)
 	kvmi_singlestep_event(vcpu, false);
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
