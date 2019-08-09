Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5141487F44
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 18:15:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437215AbfHIQPh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 12:15:37 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:52928 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2437131AbfHIQPJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 9 Aug 2019 12:15:09 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 12CD33031EC0;
        Fri,  9 Aug 2019 19:01:31 +0300 (EEST)
Received: from localhost.localdomain (unknown [89.136.169.210])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 63105305B7A0;
        Fri,  9 Aug 2019 19:01:30 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Tamas K Lengyel <tamas@tklengyel.com>,
        Mathieu Tarral <mathieu.tarral@protonmail.com>,
        =?UTF-8?q?Samuel=20Laur=C3=A9n?= <samuel.lauren@iki.fi>,
        Patrick Colp <patrick.colp@oracle.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Weijiang Yang <weijiang.yang@intel.com>, Zhang@vger.kernel.org,
        Yu C <yu.c.zhang@intel.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [RFC PATCH v6 68/92] kvm: x86: emulate a guest page table walk on SPT violations due to A/D bit updates
Date:   Fri,  9 Aug 2019 19:00:23 +0300
Message-Id: <20190809160047.8319-69-alazar@bitdefender.com>
In-Reply-To: <20190809160047.8319-1-alazar@bitdefender.com>
References: <20190809160047.8319-1-alazar@bitdefender.com>
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

CC: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/include/asm/kvm_host.h  |  2 +-
 arch/x86/include/asm/kvmi_host.h |  6 ++++++
 arch/x86/kvm/kvmi.c              | 34 +++++++++++++++++++++++++++++++-
 arch/x86/kvm/mmu.c               | 11 +++++++++--
 arch/x86/kvm/x86.c               |  6 +++---
 include/linux/kvmi.h             |  3 +++
 virt/kvm/kvmi.c                  | 31 +++++++++++++++++++++++++++--
 7 files changed, 84 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 2392678dde46..79f3aa6928e5 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1425,7 +1425,7 @@ gpa_t kvm_mmu_gva_to_gpa_fetch(struct kvm_vcpu *vcpu, gva_t gva,
 gpa_t kvm_mmu_gva_to_gpa_write(struct kvm_vcpu *vcpu, gva_t gva,
 			       struct x86_exception *exception);
 gpa_t kvm_mmu_gva_to_gpa_system(struct kvm_vcpu *vcpu, gva_t gva,
-				struct x86_exception *exception);
+				u32 access, struct x86_exception *exception);
 
 void kvm_vcpu_deactivate_apicv(struct kvm_vcpu *vcpu);
 
diff --git a/arch/x86/include/asm/kvmi_host.h b/arch/x86/include/asm/kvmi_host.h
index 3f066e7feee2..73369874f3a8 100644
--- a/arch/x86/include/asm/kvmi_host.h
+++ b/arch/x86/include/asm/kvmi_host.h
@@ -16,6 +16,7 @@ bool kvmi_monitored_msr(struct kvm_vcpu *vcpu, u32 msr);
 bool kvmi_cr_event(struct kvm_vcpu *vcpu, unsigned int cr,
 		   unsigned long old_value, unsigned long *new_value);
 void kvmi_xsetbv_event(struct kvm_vcpu *vcpu);
+bool kvmi_update_ad_flags(struct kvm_vcpu *vcpu);
 
 #else /* CONFIG_KVM_INTROSPECTION */
 
@@ -40,6 +41,11 @@ static inline void kvmi_xsetbv_event(struct kvm_vcpu *vcpu)
 {
 }
 
+static inline bool kvmi_update_ad_flags(struct kvm_vcpu *vcpu)
+{
+	return false;
+}
+
 #endif /* CONFIG_KVM_INTROSPECTION */
 
 #endif /* _ASM_X86_KVMI_HOST_H */
diff --git a/arch/x86/kvm/kvmi.c b/arch/x86/kvm/kvmi.c
index 9d66c7d6c953..5312f179af9c 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -465,7 +465,7 @@ void kvmi_arch_breakpoint_event(struct kvm_vcpu *vcpu, u64 gva, u8 insn_len)
 	u32 action;
 	u64 gpa;
 
-	gpa = kvm_mmu_gva_to_gpa_system(vcpu, gva, NULL);
+	gpa = kvm_mmu_gva_to_gpa_system(vcpu, gva, 0, NULL);
 
 	action = kvmi_msg_send_bp(vcpu, gpa, insn_len);
 	switch (action) {
@@ -822,6 +822,38 @@ u8 kvmi_arch_relax_page_access(u8 old, u8 new)
 	return ret;
 }
 
+bool kvmi_update_ad_flags(struct kvm_vcpu *vcpu)
+{
+	struct x86_exception exception = { };
+	struct kvmi *ikvm;
+	bool ret = false;
+	gva_t gva;
+	gpa_t gpa;
+
+	ikvm = kvmi_get(vcpu->kvm);
+	if (!ikvm)
+		return false;
+
+	gva = kvm_mmu_fault_gla(vcpu);
+
+	if (gva == ~0ull) {
+		kvmi_warn_once(ikvm, "%s: cannot perform translation\n",
+			       __func__);
+		goto out;
+	}
+
+	gpa = kvm_mmu_gva_to_gpa_system(vcpu, gva, PFERR_WRITE_MASK, NULL);
+	if (gpa == UNMAPPED_GVA)
+		gpa = kvm_mmu_gva_to_gpa_system(vcpu, gva, 0, &exception);
+
+	ret = (gpa != UNMAPPED_GVA);
+
+out:
+	kvmi_put(vcpu->kvm);
+
+	return ret;
+}
+
 static const struct {
 	unsigned int allow_bit;
 	enum kvm_page_track_mode track_mode;
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index c2f863797495..65b6acba82da 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -40,7 +40,9 @@
 #include <linux/uaccess.h>
 #include <linux/hash.h>
 #include <linux/kern_levels.h>
+#include <linux/kvmi.h>
 
+#include <asm/kvmi_host.h>
 #include <asm/page.h>
 #include <asm/pat.h>
 #include <asm/cmpxchg.h>
@@ -5960,8 +5962,13 @@ int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gva_t cr2, u64 error_code,
 	 */
 	if (vcpu->arch.mmu->direct_map &&
 	    (error_code & PFERR_NESTED_GUEST_PAGE) == PFERR_NESTED_GUEST_PAGE) {
-		kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(cr2));
-		return 1;
+		if (kvmi_tracked_gfn(vcpu, gpa_to_gfn(cr2))) {
+			if (kvmi_update_ad_flags(vcpu))
+				return 1;
+		} else {
+			kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(cr2));
+			return 1;
+		}
 	}
 
 	/*
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index dd10f9e0c054..2c06de73a784 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5175,9 +5175,9 @@ gpa_t kvm_mmu_gva_to_gpa_write(struct kvm_vcpu *vcpu, gva_t gva,
 
 /* uses this to access any guest's mapped memory without checking CPL */
 gpa_t kvm_mmu_gva_to_gpa_system(struct kvm_vcpu *vcpu, gva_t gva,
-				struct x86_exception *exception)
+				u32 access, struct x86_exception *exception)
 {
-	return vcpu->arch.walk_mmu->gva_to_gpa(vcpu, gva, 0, exception);
+	return vcpu->arch.walk_mmu->gva_to_gpa(vcpu, gva, access, exception);
 }
 
 static int kvm_read_guest_virt_helper(gva_t addr, void *val, unsigned int bytes,
@@ -8904,7 +8904,7 @@ int kvm_arch_vcpu_ioctl_translate(struct kvm_vcpu *vcpu,
 	vcpu_load(vcpu);
 
 	idx = srcu_read_lock(&vcpu->kvm->srcu);
-	gpa = kvm_mmu_gva_to_gpa_system(vcpu, vaddr, NULL);
+	gpa = kvm_mmu_gva_to_gpa_system(vcpu, vaddr, 0, NULL);
 	srcu_read_unlock(&vcpu->kvm->srcu, idx);
 	tr->physical_address = gpa;
 	tr->valid = gpa != UNMAPPED_GVA;
diff --git a/include/linux/kvmi.h b/include/linux/kvmi.h
index 69db02795fc0..10cd6c6412d2 100644
--- a/include/linux/kvmi.h
+++ b/include/linux/kvmi.h
@@ -21,6 +21,7 @@ bool kvmi_hypercall_event(struct kvm_vcpu *vcpu);
 bool kvmi_queue_exception(struct kvm_vcpu *vcpu);
 void kvmi_trap_event(struct kvm_vcpu *vcpu);
 bool kvmi_descriptor_event(struct kvm_vcpu *vcpu, u8 descriptor, u8 write);
+bool kvmi_tracked_gfn(struct kvm_vcpu *vcpu, gfn_t gfn);
 bool kvmi_single_step(struct kvm_vcpu *vcpu, gpa_t gpa, int *emulation_type);
 void kvmi_handle_requests(struct kvm_vcpu *vcpu);
 void kvmi_stop_ss(struct kvm_vcpu *vcpu);
@@ -36,6 +37,8 @@ static inline void kvmi_uninit(void) { }
 static inline void kvmi_create_vm(struct kvm *kvm) { }
 static inline void kvmi_destroy_vm(struct kvm *kvm) { }
 static inline int kvmi_vcpu_init(struct kvm_vcpu *vcpu) { return 0; }
+static inline bool kvmi_tracked_gfn(struct kvm_vcpu *vcpu, gfn_t gfn)
+			{ return false; }
 static inline bool kvmi_breakpoint_event(struct kvm_vcpu *vcpu, u64 gva,
 					 u8 insn_len)
 			{ return true; }
diff --git a/virt/kvm/kvmi.c b/virt/kvm/kvmi.c
index 14eadc3b9ca9..ca146ffec061 100644
--- a/virt/kvm/kvmi.c
+++ b/virt/kvm/kvmi.c
@@ -193,6 +193,33 @@ static bool kvmi_restricted_access(struct kvmi *ikvm, gpa_t gpa, u8 access)
 	return false;
 }
 
+bool is_tracked_gfn(struct kvmi *ikvm, gfn_t gfn)
+{
+	struct kvmi_mem_access *m;
+
+	read_lock(&ikvm->access_tree_lock);
+	m = __kvmi_get_gfn_access(ikvm, gfn);
+	read_unlock(&ikvm->access_tree_lock);
+
+	return !!m;
+}
+
+bool kvmi_tracked_gfn(struct kvm_vcpu *vcpu, gfn_t gfn)
+{
+	struct kvmi *ikvm;
+	bool ret;
+
+	ikvm = kvmi_get(vcpu->kvm);
+	if (!ikvm)
+		return false;
+
+	ret = is_tracked_gfn(ikvm, gfn);
+
+	kvmi_put(vcpu->kvm);
+
+	return ret;
+}
+
 static void kvmi_clear_mem_access(struct kvm *kvm)
 {
 	void **slot;
@@ -1681,7 +1708,7 @@ static int write_custom_data_to_page(struct kvm_vcpu *vcpu, gva_t gva,
 	struct page *page;
 	gpa_t gpa;
 
-	gpa = kvm_mmu_gva_to_gpa_system(vcpu, gva, NULL);
+	gpa = kvm_mmu_gva_to_gpa_system(vcpu, gva, 0, NULL);
 	if (gpa == UNMAPPED_GVA)
 		return -KVM_EINVAL;
 
@@ -1738,7 +1765,7 @@ static int restore_backup_data_to_page(struct kvm_vcpu *vcpu, gva_t gva,
 	struct page *page;
 	gpa_t gpa;
 
-	gpa = kvm_mmu_gva_to_gpa_system(vcpu, gva, NULL);
+	gpa = kvm_mmu_gva_to_gpa_system(vcpu, gva, 0, NULL);
 	if (gpa == UNMAPPED_GVA)
 		return -KVM_EINVAL;
 
