Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A8D717688D
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 00:57:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727526AbgCBX5b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 18:57:31 -0500
Received: from mga02.intel.com ([134.134.136.20]:25520 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727487AbgCBX53 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 18:57:29 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Mar 2020 15:57:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,509,1574150400"; 
   d="scan'208";a="243384725"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga006.jf.intel.com with ESMTP; 02 Mar 2020 15:57:22 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v2 34/66] KVM: x86: Handle RDTSCP CPUID adjustment in VMX code
Date:   Mon,  2 Mar 2020 15:56:37 -0800
Message-Id: <20200302235709.27467-35-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200302235709.27467-1-sean.j.christopherson@intel.com>
References: <20200302235709.27467-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the clearing of the RDTSCP CPUID bit into VMX, which has a separate
VMCS control to enable RDTSCP in non-root, to eliminate an instance of
the undesirable "unsigned f_* = *_supported ? F(*) : 0" pattern in the
common CPUID handling code.  Drop ->rdtscp_supported() since CPUID
adjustment was the last remaining user.

No functional change intended.

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/cpuid.c   | 3 +--
 arch/x86/kvm/vmx/vmx.c | 4 ++++
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 9c2e20a76ca8..f39efc9d640b 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -424,7 +424,6 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 	unsigned f_gbpages = 0;
 	unsigned f_lm = 0;
 #endif
-	unsigned f_rdtscp = kvm_x86_ops->rdtscp_supported() ? F(RDTSCP) : 0;
 	unsigned f_xsaves = kvm_x86_ops->xsaves_supported() ? F(XSAVES) : 0;
 	unsigned f_intel_pt = kvm_x86_ops->pt_supported() ? F(INTEL_PT) : 0;
 
@@ -446,7 +445,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		F(MTRR) | F(PGE) | F(MCA) | F(CMOV) |
 		F(PAT) | F(PSE36) | 0 /* Reserved */ |
 		f_nx | 0 /* Reserved */ | F(MMXEXT) | F(MMX) |
-		F(FXSR) | F(FXSR_OPT) | f_gbpages | f_rdtscp |
+		F(FXSR) | F(FXSR_OPT) | f_gbpages | F(RDTSCP) |
 		0 /* Reserved */ | f_lm | F(3DNOWEXT) | F(3DNOW);
 	/* cpuid 1.ecx */
 	const u32 kvm_cpuid_1_ecx_x86_features =
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 49a1cac7bf0c..3bcb09b5efac 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7139,6 +7139,10 @@ static void vmx_set_supported_cpuid(struct kvm_cpuid_entry2 *entry)
 		    boot_cpu_has(X86_FEATURE_OSPKE))
 			cpuid_entry_set(entry, X86_FEATURE_PKU);
 		break;
+	case 0x80000001:
+		if (!cpu_has_vmx_rdtscp())
+			cpuid_entry_clear(entry, X86_FEATURE_RDTSCP);
+		break;
 	default:
 		break;
 	}
-- 
2.24.1

