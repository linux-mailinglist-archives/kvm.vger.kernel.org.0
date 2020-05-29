Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D87181E78DC
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 10:56:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbgE2Iz7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 04:55:59 -0400
Received: from mga02.intel.com ([134.134.136.20]:46106 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726970AbgE2Iz4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 May 2020 04:55:56 -0400
IronPort-SDR: z+EcFfXcW8lda6OgSZ7maX+wCuD0hjQigql7EnJKNG0+S+0la9ofYoBQS6s6cQAvMQQwmxP8Oe
 b418owTUOUxQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2020 01:55:55 -0700
IronPort-SDR: Vmk2E08nkiC8LnZvQG21cS7ipj7HVCCNZIwh3JYqaUxKeEQVhaVYDrdgKwbwGMKGE3gbt7lIBU
 3BXJbYGNsQ6g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,448,1583222400"; 
   d="scan'208";a="311188332"
Received: from lxy-dell.sh.intel.com ([10.239.159.21])
  by FMSMGA003.fm.intel.com with ESMTP; 29 May 2020 01:55:53 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH 3/6] KVM: X86: Introduce kvm_check_cpuid()
Date:   Fri, 29 May 2020 16:55:42 +0800
Message-Id: <20200529085545.29242-4-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.18.2
In-Reply-To: <20200529085545.29242-1-xiaoyao.li@intel.com>
References: <20200529085545.29242-1-xiaoyao.li@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use kvm_check_cpuid() to validate if userspace provides legal cpuid
settings and call it before KVM updates CPUID.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
Is the check of virutal address width really necessary?
KVM doesn't check other bits at all. I guess the policy is that KVM allows
illegal CPUID settings as long as it doesn't break host kernel. Userspace
takes the consequences itself if it sets bogus CPUID settings that breaks
its guest.
But why vaddr_bits is special? It seems illegal vaddr_bits won't break host
kernel.
---
 arch/x86/kvm/cpuid.c | 54 ++++++++++++++++++++++++++++----------------
 arch/x86/kvm/cpuid.h |  2 +-
 2 files changed, 35 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 795bbaf37110..c8cb373056f1 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -54,7 +54,26 @@ static u32 xstate_required_size(u64 xstate_bv, bool compacted)
 
 #define F feature_bit
 
-int kvm_update_cpuid(struct kvm_vcpu *vcpu)
+static int kvm_check_cpuid(struct kvm_vcpu *vcpu)
+{
+	struct kvm_cpuid_entry2 *best;
+
+	/*
+	 * The existing code assumes virtual address is 48-bit or 57-bit in the
+	 * canonical address checks; exit if it is ever changed.
+	 */
+	best = kvm_find_cpuid_entry(vcpu, 0x80000008, 0);
+	if (best) {
+		int vaddr_bits = (best->eax & 0xff00) >> 8;
+
+		if (vaddr_bits != 48 && vaddr_bits != 57 && vaddr_bits != 0)
+			return -EINVAL;
+	}
+
+	return 0;
+}
+
+void kvm_update_cpuid(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpuid_entry2 *best;
 	struct kvm_lapic *apic = vcpu->arch.apic;
@@ -96,18 +115,6 @@ int kvm_update_cpuid(struct kvm_vcpu *vcpu)
 		     cpuid_entry_has(best, X86_FEATURE_XSAVEC)))
 		best->ebx = xstate_required_size(vcpu->arch.xcr0, true);
 
-	/*
-	 * The existing code assumes virtual address is 48-bit or 57-bit in the
-	 * canonical address checks; exit if it is ever changed.
-	 */
-	best = kvm_find_cpuid_entry(vcpu, 0x80000008, 0);
-	if (best) {
-		int vaddr_bits = (best->eax & 0xff00) >> 8;
-
-		if (vaddr_bits != 48 && vaddr_bits != 57 && vaddr_bits != 0)
-			return -EINVAL;
-	}
-
 	best = kvm_find_cpuid_entry(vcpu, KVM_CPUID_FEATURES, 0);
 	if (kvm_hlt_in_guest(vcpu->kvm) && best &&
 		(best->eax & (1 << KVM_FEATURE_PV_UNHALT)))
@@ -127,7 +134,6 @@ int kvm_update_cpuid(struct kvm_vcpu *vcpu)
 	kvm_mmu_reset_context(vcpu);
 
 	kvm_pmu_refresh(vcpu);
-	return 0;
 }
 
 static int is_efer_nx(void)
@@ -205,12 +211,16 @@ int kvm_vcpu_ioctl_set_cpuid(struct kvm_vcpu *vcpu,
 		vcpu->arch.cpuid_entries[i].padding[2] = 0;
 	}
 	vcpu->arch.cpuid_nent = cpuid->nent;
+	r = kvm_check_cpuid(vcpu);
+	if (r) {
+		vcpu->arch.cpuid_nent = 0;
+		goto out;
+	}
+
 	cpuid_fix_nx_cap(vcpu);
 	kvm_apic_set_version(vcpu);
 	kvm_x86_ops.cpuid_update(vcpu);
-	r = kvm_update_cpuid(vcpu);
-	if (r)
-		vcpu->arch.cpuid_nent = 0;
+	kvm_update_cpuid(vcpu);
 
 out:
 	vfree(cpuid_entries);
@@ -231,11 +241,15 @@ int kvm_vcpu_ioctl_set_cpuid2(struct kvm_vcpu *vcpu,
 			   cpuid->nent * sizeof(struct kvm_cpuid_entry2)))
 		goto out;
 	vcpu->arch.cpuid_nent = cpuid->nent;
+	r = kvm_check_cpuid(vcpu);
+	if (r) {
+		vcpu->arch.cpuid_nent = 0;
+		goto out;
+	}
+
 	kvm_apic_set_version(vcpu);
 	kvm_x86_ops.cpuid_update(vcpu);
-	r = kvm_update_cpuid(vcpu);
-	if (r)
-		vcpu->arch.cpuid_nent = 0;
+	kvm_update_cpuid(vcpu);
 out:
 	return r;
 }
diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index 05434cd9342f..f136de1debad 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -9,7 +9,7 @@
 extern u32 kvm_cpu_caps[NCAPINTS] __read_mostly;
 void kvm_set_cpu_caps(void);
 
-int kvm_update_cpuid(struct kvm_vcpu *vcpu);
+void kvm_update_cpuid(struct kvm_vcpu *vcpu);
 struct kvm_cpuid_entry2 *kvm_find_cpuid_entry(struct kvm_vcpu *vcpu,
 					      u32 function, u32 index);
 int kvm_dev_ioctl_get_cpuid(struct kvm_cpuid2 *cpuid,
-- 
2.18.2

