Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64893217FDA
	for <lists+kvm@lfdr.de>; Wed,  8 Jul 2020 08:51:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729906AbgGHGvK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jul 2020 02:51:10 -0400
Received: from mga11.intel.com ([192.55.52.93]:5284 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729892AbgGHGvJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jul 2020 02:51:09 -0400
IronPort-SDR: h4zrsJfYtxpecB3ni5xPoH+BVJd0juJXCv4lk/n5elCkmqURouRVyDCNqnIu5iiI10lxoCi6ic
 E3DqqyY5HP/w==
X-IronPort-AV: E=McAfee;i="6000,8403,9675"; a="145852072"
X-IronPort-AV: E=Sophos;i="5.75,326,1589266800"; 
   d="scan'208";a="145852072"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2020 23:51:08 -0700
IronPort-SDR: 4lbBsFV7nN11/3UqXxGLNIutYQjfxSCXVwOOSQKk6g7/LwJnt6kCLz28cNVW88qKeoHHcb2QBg
 Vgj4fPjZ56ww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,326,1589266800"; 
   d="scan'208";a="457399146"
Received: from lxy-dell.sh.intel.com ([10.239.159.21])
  by orsmga005.jf.intel.com with ESMTP; 07 Jul 2020 23:51:05 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v3 3/8] KVM: X86: Introduce kvm_check_cpuid()
Date:   Wed,  8 Jul 2020 14:50:49 +0800
Message-Id: <20200708065054.19713-4-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20200708065054.19713-1-xiaoyao.li@intel.com>
References: <20200708065054.19713-1-xiaoyao.li@intel.com>
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
index 0e3a23c2ea55..a825878b7f84 100644
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
2.18.4

