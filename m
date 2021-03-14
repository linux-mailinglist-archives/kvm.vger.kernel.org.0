Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6C1833A5EF
	for <lists+kvm@lfdr.de>; Sun, 14 Mar 2021 17:01:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234474AbhCNQBa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 14 Mar 2021 12:01:30 -0400
Received: from mga14.intel.com ([192.55.52.115]:7174 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234179AbhCNQAy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 14 Mar 2021 12:00:54 -0400
IronPort-SDR: s7u4HrHnd/9m1zbkgGeLU/gvK6uJukiWpheC097AbSwYh0PQsDSN1SbAkhvwlLtbr3a3MpZWjt
 O0hnlxkiqbsg==
X-IronPort-AV: E=McAfee;i="6000,8403,9923"; a="188360757"
X-IronPort-AV: E=Sophos;i="5.81,248,1610438400"; 
   d="scan'208";a="188360757"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2021 09:00:54 -0700
IronPort-SDR: tSWF4xTilbwCjte2i9mLapEA/7s8OmtQeOwIzyXokZTkuULis4MTgGT1qfbp/2JAzhYnZsloHU
 1B/fX/aqF4XA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,248,1610438400"; 
   d="scan'208";a="439530734"
Received: from clx-ap-likexu.sh.intel.com ([10.239.48.108])
  by FMSMGA003.fm.intel.com with ESMTP; 14 Mar 2021 09:00:51 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        x86@kernel.org, wei.w.wang@intel.com, linux-kernel@vger.kernel.org,
        Like Xu <like.xu@linux.intel.com>
Subject: [PATCH v4 10/11] KVM: x86: Refine the matching and clearing logic for supported_xss
Date:   Sun, 14 Mar 2021 23:52:23 +0800
Message-Id: <20210314155225.206661-11-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210314155225.206661-1-like.xu@linux.intel.com>
References: <20210314155225.206661-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Refine the code path of the existing clearing of supported_xss in this way:
initialize the supported_xss with the filter of KVM_SUPPORTED_XSS mask and
update its value in a bit clear manner (rather than bit setting).

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 5 +++--
 arch/x86/kvm/x86.c     | 6 +++++-
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 03c0faf16a7d..14ed3251376f 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7302,9 +7302,10 @@ static __init void vmx_set_cpu_caps(void)
 		kvm_cpu_cap_set(X86_FEATURE_UMIP);
 
 	/* CPUID 0xD.1 */
-	supported_xss = 0;
-	if (!cpu_has_vmx_xsaves())
+	if (!cpu_has_vmx_xsaves()) {
 		kvm_cpu_cap_clear(X86_FEATURE_XSAVES);
+		supported_xss = 0;
+	}
 
 	/* CPUID 0x80000001 */
 	if (!cpu_has_vmx_rdtscp())
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4bcf5b130e38..171605dcbd65 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -205,6 +205,8 @@ static struct kvm_user_return_msrs __percpu *user_return_msrs;
 				| XFEATURE_MASK_BNDCSR | XFEATURE_MASK_AVX512 \
 				| XFEATURE_MASK_PKRU)
 
+#define KVM_SUPPORTED_XSS     0
+
 u64 __read_mostly host_efer;
 EXPORT_SYMBOL_GPL(host_efer);
 
@@ -10450,8 +10452,10 @@ int kvm_arch_hardware_setup(void *opaque)
 
 	rdmsrl_safe(MSR_EFER, &host_efer);
 
-	if (boot_cpu_has(X86_FEATURE_XSAVES))
+	if (boot_cpu_has(X86_FEATURE_XSAVES)) {
 		rdmsrl(MSR_IA32_XSS, host_xss);
+		supported_xss = host_xss & KVM_SUPPORTED_XSS;
+	}
 
 	r = ops->hardware_setup();
 	if (r != 0)
-- 
2.29.2

