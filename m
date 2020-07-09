Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22F7621976C
	for <lists+kvm@lfdr.de>; Thu,  9 Jul 2020 06:34:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726345AbgGIEef (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jul 2020 00:34:35 -0400
Received: from mga14.intel.com ([192.55.52.115]:10037 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726064AbgGIEed (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jul 2020 00:34:33 -0400
IronPort-SDR: sMSv29CgqYvNu8i9zT9mpfrXgfsD6rKRNxOtAUrepesbR6yxb4B64XJ7RhdePWJmAFKZLnTDRN
 kYT8AWPJRMbA==
X-IronPort-AV: E=McAfee;i="6000,8403,9676"; a="147011557"
X-IronPort-AV: E=Sophos;i="5.75,330,1589266800"; 
   d="scan'208";a="147011557"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2020 21:34:32 -0700
IronPort-SDR: s5+Nc2Hd4qIoq29QJ3YPqtF4T0P4sFUnBje4bUB87DrB+/Dq6dAtnKB+G5BwWge7/k+LhroWw3
 DlG/tg/jKq1w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,330,1589266800"; 
   d="scan'208";a="297942864"
Received: from lxy-dell.sh.intel.com ([10.239.159.21])
  by orsmga002.jf.intel.com with ESMTP; 08 Jul 2020 21:34:30 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v4 1/5] KVM: x86: Introduce kvm_check_cpuid()
Date:   Thu,  9 Jul 2020 12:34:22 +0800
Message-Id: <20200709043426.92712-2-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20200709043426.92712-1-xiaoyao.li@intel.com>
References: <20200709043426.92712-1-xiaoyao.li@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use kvm_check_cpuid() to validate if userspace provides legal cpuid
settings and call it before KVM take any action to update CPUID or
update vcpu states based on given CPUID settings.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/kvm/cpuid.c | 55 ++++++++++++++++++++++++++++----------------
 arch/x86/kvm/cpuid.h |  2 +-
 2 files changed, 36 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index eebd66f86abe..1a053022a961 100644
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
@@ -98,18 +117,6 @@ int kvm_update_cpuid(struct kvm_vcpu *vcpu)
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
@@ -131,7 +138,6 @@ int kvm_update_cpuid(struct kvm_vcpu *vcpu)
 	kvm_pmu_refresh(vcpu);
 	vcpu->arch.cr4_guest_rsvd_bits =
 	    __cr4_reserved_bits(guest_cpuid_has, vcpu);
-	return 0;
 }
 
 static int is_efer_nx(void)
@@ -206,11 +212,16 @@ int kvm_vcpu_ioctl_set_cpuid(struct kvm_vcpu *vcpu,
 		vcpu->arch.cpuid_entries[i].padding[2] = 0;
 	}
 	vcpu->arch.cpuid_nent = cpuid->nent;
+	r = kvm_check_cpuid(vcpu);
+	if (r) {
+		vcpu->arch.cpuid_nent = 0;
+		kvfree(cpuid_entries);
+		goto out;
+	}
+
 	cpuid_fix_nx_cap(vcpu);
 	kvm_x86_ops.cpuid_update(vcpu);
-	r = kvm_update_cpuid(vcpu);
-	if (r)
-		vcpu->arch.cpuid_nent = 0;
+	kvm_update_cpuid(vcpu);
 
 	kvfree(cpuid_entries);
 out:
@@ -231,10 +242,14 @@ int kvm_vcpu_ioctl_set_cpuid2(struct kvm_vcpu *vcpu,
 			   cpuid->nent * sizeof(struct kvm_cpuid_entry2)))
 		goto out;
 	vcpu->arch.cpuid_nent = cpuid->nent;
-	kvm_x86_ops.cpuid_update(vcpu);
-	r = kvm_update_cpuid(vcpu);
-	if (r)
+	r = kvm_check_cpuid(vcpu);
+	if (r) {
 		vcpu->arch.cpuid_nent = 0;
+		goto out;
+	}
+
+	kvm_x86_ops.cpuid_update(vcpu);
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
2.18.4

