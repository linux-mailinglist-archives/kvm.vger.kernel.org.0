Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 984C044619D
	for <lists+kvm@lfdr.de>; Fri,  5 Nov 2021 10:51:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232910AbhKEJyN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Nov 2021 05:54:13 -0400
Received: from mail.xenproject.org ([104.130.215.37]:56594 "EHLO
        mail.xenproject.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232883AbhKEJyK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Nov 2021 05:54:10 -0400
Received: from xenbits.xenproject.org ([104.239.192.120])
        by mail.xenproject.org with esmtp (Exim 4.92)
        (envelope-from <pdurrant@amazon.com>)
        id 1mivsR-00048c-Jd; Fri, 05 Nov 2021 09:51:15 +0000
Received: from host86-165-42-146.range86-165.btcentralplus.com ([86.165.42.146] helo=debian.home)
        by xenbits.xenproject.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <pdurrant@amazon.com>)
        id 1mivsR-00088M-BO; Fri, 05 Nov 2021 09:51:15 +0000
From:   Paul Durrant <pdurrant@amazon.com>
To:     kvm@vger.kernel.org
Cc:     Paul Durrant <pdurrant@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH v2 2/2] KVM: x86: Make sure KVM_CPUID_FEATURES really are KVM_CPUID_FEATURES
Date:   Fri,  5 Nov 2021 09:51:01 +0000
Message-Id: <20211105095101.5384-3-pdurrant@amazon.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211105095101.5384-1-pdurrant@amazon.com>
References: <20211105095101.5384-1-pdurrant@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently when kvm_update_cpuid_runtime() runs, it assumes that the
KVM_CPUID_FEATURES leaf is located at 0x40000001. This is not true,
however, if Hyper-V support is enabled. In this case the KVM leaves will
be offset.

This patch introdues as new 'kvm_cpuid_base' field into struct
kvm_vcpu_arch to track the location of the KVM leaves and function
kvm_update_kvm_cpuid_base() (called from kvm_set_cpuid()) to locate the
leaves using the 'KVMKVMKVM\0\0\0' signature (which is now given a
definition in kvm_para.h). Adjustment of KVM_CPUID_FEATURES will hence now
target the correct leaf.

NOTE: A new for_each_possible_hypervisor_cpuid_base() macro is intoduced
      into processor.h to avoid having duplicate code for the iteration
      over possible hypervisor base leaves.

Signed-off-by: Paul Durrant <pdurrant@amazon.com>
---
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Wanpeng Li <wanpengli@tencent.com>
Cc: Jim Mattson <jmattson@google.com>
Cc: Joerg Roedel <joro@8bytes.org>

v2:
 - Added new for_each_possible_hypervisor_cpuid_base() macro
 - Added KVM_SIGNATURE definition
 - Other amendments as requested by Sean
---
 arch/x86/include/asm/kvm_host.h      |  1 +
 arch/x86/include/asm/processor.h     |  5 ++-
 arch/x86/include/uapi/asm/kvm_para.h |  1 +
 arch/x86/kernel/kvm.c                |  2 +-
 arch/x86/kvm/cpuid.c                 | 46 ++++++++++++++++++++++++----
 5 files changed, 47 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 88fce6ab4bbd..21133ffa23e9 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -725,6 +725,7 @@ struct kvm_vcpu_arch {
 
 	int cpuid_nent;
 	struct kvm_cpuid_entry2 *cpuid_entries;
+	u32 kvm_cpuid_base;
 
 	u64 reserved_gpa_bits;
 	int maxphyaddr;
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 9ad2acaaae9b..726318cda082 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -807,11 +807,14 @@ static inline u32 amd_get_nodes_per_socket(void)	{ return 0; }
 static inline u32 amd_get_highest_perf(void)		{ return 0; }
 #endif
 
+#define for_each_possible_hypervisor_cpuid_base(function) \
+	for (function = 0x40000000; function < 0x40010000; function += 0x100)
+
 static inline uint32_t hypervisor_cpuid_base(const char *sig, uint32_t leaves)
 {
 	uint32_t base, eax, signature[3];
 
-	for (base = 0x40000000; base < 0x40010000; base += 0x100) {
+	for_each_possible_hypervisor_cpuid_base(base) {
 		cpuid(base, &eax, &signature[0], &signature[1], &signature[2]);
 
 		if (!memcmp(sig, signature, 12) &&
diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
index 5146bbab84d4..6e64b27b2c1e 100644
--- a/arch/x86/include/uapi/asm/kvm_para.h
+++ b/arch/x86/include/uapi/asm/kvm_para.h
@@ -8,6 +8,7 @@
  * should be used to determine that a VM is running under KVM.
  */
 #define KVM_CPUID_SIGNATURE	0x40000000
+#define KVM_SIGNATURE "KVMKVMKVM\0\0\0"
 
 /* This CPUID returns two feature bitmaps in eax, edx. Before enabling
  * a particular paravirtualization, the appropriate feature bit should
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index b656456c3a94..c97859170286 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -755,7 +755,7 @@ static noinline uint32_t __kvm_cpuid_base(void)
 		return 0;	/* So we don't blow up on old processors */
 
 	if (boot_cpu_has(X86_FEATURE_HYPERVISOR))
-		return hypervisor_cpuid_base("KVMKVMKVM\0\0\0", 0);
+		return hypervisor_cpuid_base(KVM_SIGNATURE, 0);
 
 	return 0;
 }
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 41529c168e91..e19dabf1848b 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -99,11 +99,45 @@ static int kvm_check_cpuid(struct kvm_cpuid_entry2 *entries, int nent)
 	return 0;
 }
 
-void kvm_update_pv_runtime(struct kvm_vcpu *vcpu)
+static void kvm_update_kvm_cpuid_base(struct kvm_vcpu *vcpu)
 {
-	struct kvm_cpuid_entry2 *best;
+	u32 function;
+	struct kvm_cpuid_entry2 *entry;
+
+	vcpu->arch.kvm_cpuid_base = 0;
+
+	for_each_possible_hypervisor_cpuid_base(function) {
+		entry = kvm_find_cpuid_entry(vcpu, function, 0);
+
+		if (entry) {
+			u32 signature[3];
+
+			signature[0] = entry->ebx;
+			signature[1] = entry->ecx;
+			signature[2] = entry->edx;
+
+			BUILD_BUG_ON(sizeof(signature) > sizeof(KVM_SIGNATURE));
+			if (!memcmp(signature, KVM_SIGNATURE, sizeof(signature))) {
+				vcpu->arch.kvm_cpuid_base = function;
+				break;
+			}
+		}
+	}
+}
+
+struct kvm_cpuid_entry2 *kvm_find_kvm_cpuid_features(struct kvm_vcpu *vcpu)
+{
+	u32 base = vcpu->arch.kvm_cpuid_base;
+
+	if (!base)
+		return NULL;
+
+	return kvm_find_cpuid_entry(vcpu, base | KVM_CPUID_FEATURES, 0);
+}
 
-	best = kvm_find_cpuid_entry(vcpu, KVM_CPUID_FEATURES, 0);
+void kvm_update_pv_runtime(struct kvm_vcpu *vcpu)
+{
+	struct kvm_cpuid_entry2 *best = kvm_find_kvm_cpuid_features(vcpu);
 
 	/*
 	 * save the feature bitmap to avoid cpuid lookup for every PV
@@ -142,7 +176,7 @@ void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
 		     cpuid_entry_has(best, X86_FEATURE_XSAVEC)))
 		best->ebx = xstate_required_size(vcpu->arch.xcr0, true);
 
-	best = kvm_find_cpuid_entry(vcpu, KVM_CPUID_FEATURES, 0);
+	best = kvm_find_kvm_cpuid_features(vcpu);
 	if (kvm_hlt_in_guest(vcpu->kvm) && best &&
 		(best->eax & (1 << KVM_FEATURE_PV_UNHALT)))
 		best->eax &= ~(1 << KVM_FEATURE_PV_UNHALT);
@@ -252,6 +286,7 @@ static int kvm_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
     vcpu->arch.cpuid_entries = e2;
     vcpu->arch.cpuid_nent = nent;
 
+    kvm_update_kvm_cpuid_base(vcpu);
     kvm_update_cpuid_runtime(vcpu);
     kvm_vcpu_after_set_cpuid(vcpu);
 
@@ -872,8 +907,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		}
 		break;
 	case KVM_CPUID_SIGNATURE: {
-		static const char signature[12] = "KVMKVMKVM\0\0";
-		const u32 *sigptr = (const u32 *)signature;
+		const u32 *sigptr = (const u32 *)KVM_SIGNATURE;
 		entry->eax = KVM_CPUID_FEATURES;
 		entry->ebx = sigptr[0];
 		entry->ecx = sigptr[1];
-- 
2.20.1

