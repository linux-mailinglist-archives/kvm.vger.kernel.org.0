Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F35C4119E6E
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2019 23:44:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729776AbfLJWoX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Dec 2019 17:44:23 -0500
Received: from mga09.intel.com ([134.134.136.24]:9123 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728532AbfLJWoV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Dec 2019 17:44:21 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Dec 2019 14:44:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,301,1571727600"; 
   d="scan'208";a="413279336"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga005.fm.intel.com with ESMTP; 10 Dec 2019 14:44:19 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jun Nakajima <jun.nakajima@intel.com>
Subject: [PATCH 3/4] KVM: x86: Drop special XSAVE handling from guest_cpuid_has()
Date:   Tue, 10 Dec 2019 14:44:15 -0800
Message-Id: <20191210224416.10757-4-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191210224416.10757-1-sean.j.christopherson@intel.com>
References: <20191210224416.10757-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that KVM prevents setting host-reserved CR4 bits, drop the dedicated
XSAVE check in guest_cpuid_has() in favor of open coding similar checks
in the SVM/VMX XSAVES enabling flows.

Note, checking boot_cpu_has(X86_FEATURE_XSAVE) in the XSAVES flows is
technically redundant with respect to the CR4 reserved bit checks, e.g.
XSAVES #UDs if CR4.OSXSAVE=0 and arch.xsaves_enabled is consumed if and
only if CR4.OXSAVE=1 in guest.  Keep (add?) the explicit boot_cpu_has()
checks to help document KVM's usage of arch.xsaves_enabled.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/cpuid.h   | 4 ----
 arch/x86/kvm/svm.c     | 1 +
 arch/x86/kvm/vmx/vmx.c | 1 +
 3 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index d78a61408243..b82ae4d3dc71 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -93,10 +93,6 @@ static __always_inline bool guest_cpuid_has(struct kvm_vcpu *vcpu, unsigned x86_
 {
 	int *reg;
 
-	if (x86_feature == X86_FEATURE_XSAVE &&
-			!static_cpu_has(X86_FEATURE_XSAVE))
-		return false;
-
 	reg = guest_cpuid_get_register(vcpu, x86_feature);
 	if (!reg)
 		return false;
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 8f1b715dfde8..ba23f18b2eee 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -5913,6 +5913,7 @@ static void svm_cpuid_update(struct kvm_vcpu *vcpu)
 	struct vcpu_svm *svm = to_svm(vcpu);
 
 	vcpu->arch.xsaves_enabled = guest_cpuid_has(vcpu, X86_FEATURE_XSAVE) &&
+				    boot_cpu_has(X86_FEATURE_XSAVE) &&
 				    boot_cpu_has(X86_FEATURE_XSAVES);
 
 	/* Update nrips enabled cache */
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 51e3b27f90ed..74c6e70e5863 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4048,6 +4048,7 @@ static void vmx_compute_secondary_exec_control(struct vcpu_vmx *vmx)
 	if (vmx_xsaves_supported()) {
 		/* Exposing XSAVES only when XSAVE is exposed */
 		bool xsaves_enabled =
+			boot_cpu_has(X86_FEATURE_XSAVE) &&
 			guest_cpuid_has(vcpu, X86_FEATURE_XSAVE) &&
 			guest_cpuid_has(vcpu, X86_FEATURE_XSAVES);
 
-- 
2.24.0

