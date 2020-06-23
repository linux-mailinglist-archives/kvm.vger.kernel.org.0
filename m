Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8505205187
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 13:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732631AbgFWL66 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 07:58:58 -0400
Received: from mga05.intel.com ([192.55.52.43]:58474 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732527AbgFWL62 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jun 2020 07:58:28 -0400
IronPort-SDR: tqdGzSN4x9sCI0yup7rqEkzSOjTUwLGGy5Mm/0bA0iPjabKp7gUYG+936uWmILZFLQdUdY1hvK
 ueWkGvvIaotg==
X-IronPort-AV: E=McAfee;i="6000,8403,9660"; a="228710077"
X-IronPort-AV: E=Sophos;i="5.75,271,1589266800"; 
   d="scan'208";a="228710077"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2020 04:58:28 -0700
IronPort-SDR: s78wnkn+VxwlYV3SKItfIWz3h3BnNDeC9GXiVcgPn9rsECjv3/j6pcIctfSQ3q0y6uwuZHOaC5
 o4qGW6E1e8sQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,271,1589266800"; 
   d="scan'208";a="285745544"
Received: from lxy-dell.sh.intel.com ([10.239.159.21])
  by orsmga007.jf.intel.com with ESMTP; 23 Jun 2020 04:58:25 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v2 3/7] KVM: X86: Introduce kvm_check_cpuid()
Date:   Tue, 23 Jun 2020 19:58:12 +0800
Message-Id: <20200623115816.24132-4-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.18.2
In-Reply-To: <20200623115816.24132-1-xiaoyao.li@intel.com>
References: <20200623115816.24132-1-xiaoyao.li@intel.com>
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
index 0164dac95ef5..67e5c68fdb45 100644
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
@@ -202,12 +208,16 @@ int kvm_vcpu_ioctl_set_cpuid(struct kvm_vcpu *vcpu,
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
 
 	kvfree(cpuid_entries);
 out:
@@ -228,11 +238,15 @@ int kvm_vcpu_ioctl_set_cpuid2(struct kvm_vcpu *vcpu,
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

