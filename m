Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B206C294A32
	for <lists+kvm@lfdr.de>; Wed, 21 Oct 2020 11:10:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437392AbgJUJKc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Oct 2020 05:10:32 -0400
Received: from mga07.intel.com ([134.134.136.100]:58974 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389165AbgJUJKb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Oct 2020 05:10:31 -0400
IronPort-SDR: SIewW4vD0mhnJb2JKQqctZwUfnJR9vkp0/dGKSg9K19LJ1URoFDv67mye5IvktEQo/B+wS9f2w
 MKJ5mzZRC3mg==
X-IronPort-AV: E=McAfee;i="6000,8403,9780"; a="231530449"
X-IronPort-AV: E=Sophos;i="5.77,400,1596524400"; 
   d="scan'208";a="231530449"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2020 02:10:30 -0700
IronPort-SDR: mFj6Z322wev9vhOMbOvSrMmhooGvkHCL0qrIppIhgpDels7hgTBn9qLkCLfO94n0tD5vcS3oNM
 XPqduvd+EoxQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,400,1596524400"; 
   d="scan'208";a="522682423"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by fmsmga006.fm.intel.com with ESMTP; 21 Oct 2020 02:10:28 -0700
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     sean.j.christopherson@intel.com, pbonzini@redhat.com,
        xiaoyao.li@intel.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org
Cc:     kvm@vger.kernel.org, robert.hu@intel.com,
        Robert Hoo <robert.hu@linux.intel.com>
Subject: [PATCH v2 2/7] kvm: x86: Extract kvm_xcr0_update_cpuid() from kvm_update_cpuid_runtime()
Date:   Wed, 21 Oct 2020 17:10:05 +0800
Message-Id: <1603271410-71343-3-git-send-email-robert.hu@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1603271410-71343-1-git-send-email-robert.hu@linux.intel.com>
References: <1603271410-71343-1-git-send-email-robert.hu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

And let __kvm_set_xcr() call kvm_xcr0_update_cpuid() instead of whole
kvm_update_cpuid_runtime()

Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
---
 arch/x86/kvm/cpuid.c | 22 ++++++++++++++++++++++
 arch/x86/kvm/cpuid.h |  2 ++
 arch/x86/kvm/x86.c   |  2 +-
 3 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index b6dd4ee..6d5cd03 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -87,6 +87,28 @@ void kvm_apic_base_update_cpuid(struct kvm_vcpu *vcpu, bool set)
 	guest_cpuid_change(vcpu, 1, 0, X86_FEATURE_APIC, set);
 }
 
+
+void kvm_xcr0_update_cpuid(struct kvm_vcpu *vcpu)
+{
+	struct kvm_cpuid_entry2 *e;
+
+	e = kvm_find_cpuid_entry(vcpu, 0xD, 0);
+	if (!e) {
+		vcpu->arch.guest_supported_xcr0 = 0;
+	} else {
+		vcpu->arch.guest_supported_xcr0 =
+			(e->eax | ((u64)e->edx << 32)) & supported_xcr0;
+		e->ebx = xstate_required_size(vcpu->arch.xcr0, false);
+	}
+
+	e = kvm_find_cpuid_entry(vcpu, 0xD, 1);
+	if (!e)
+		return;
+	if (cpuid_entry_has(e, X86_FEATURE_XSAVES) ||
+	    cpuid_entry_has(e, X86_FEATURE_XSAVEC))
+		e->ebx = xstate_required_size(vcpu->arch.xcr0, true);
+}
+
 void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpuid_entry2 *best;
diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index ef4cb9c..845544e 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -10,6 +10,8 @@
 void kvm_set_cpu_caps(void);
 
 void kvm_apic_base_update_cpuid(struct kvm_vcpu *vcpu, bool set);
+void kvm_xcr0_update_cpuid(struct kvm_vcpu *vcpu);
+
 void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu);
 struct kvm_cpuid_entry2 *kvm_find_cpuid_entry(struct kvm_vcpu *vcpu,
 					      u32 function, u32 index);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 58fa354..cd41bec 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -944,7 +944,7 @@ static int __kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
 	vcpu->arch.xcr0 = xcr0;
 
 	if ((xcr0 ^ old_xcr0) & XFEATURE_MASK_EXTEND)
-		kvm_update_cpuid_runtime(vcpu);
+		kvm_xcr0_update_cpuid(vcpu);
 	return 0;
 }
 
-- 
1.8.3.1

