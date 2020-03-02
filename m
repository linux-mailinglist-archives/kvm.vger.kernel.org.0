Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F4C117689D
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 00:58:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727518AbgCBX5b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 18:57:31 -0500
Received: from mga02.intel.com ([134.134.136.20]:25524 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727489AbgCBX53 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 18:57:29 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Mar 2020 15:57:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,509,1574150400"; 
   d="scan'208";a="243384719"
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
Subject: [PATCH v2 32/66] KVM: x86: Handle UMIP emulation CPUID adjustment in VMX code
Date:   Mon,  2 Mar 2020 15:56:35 -0800
Message-Id: <20200302235709.27467-33-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200302235709.27467-1-sean.j.christopherson@intel.com>
References: <20200302235709.27467-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the CPUID adjustment for UMIP emulation into VMX code to eliminate
an instance of the undesirable "unsigned f_* = *_supported ? F(*) : 0"
pattern in the common CPUID handling code.

No functional change intended.

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/cpuid.c   | 2 --
 arch/x86/kvm/vmx/vmx.c | 2 ++
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 983eec22d2f5..35451ea0a690 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -339,7 +339,6 @@ static int __do_cpuid_func_emulated(struct kvm_cpuid_array *array, u32 func)
 
 static inline void do_cpuid_7_mask(struct kvm_cpuid_entry2 *entry)
 {
-	unsigned f_umip = kvm_x86_ops->umip_emulated() ? F(UMIP) : 0;
 	unsigned f_intel_pt = kvm_x86_ops->pt_supported() ? F(INTEL_PT) : 0;
 	unsigned f_la57;
 	unsigned f_pku = kvm_x86_ops->pku_supported() ? F(PKU) : 0;
@@ -382,7 +381,6 @@ static inline void do_cpuid_7_mask(struct kvm_cpuid_entry2 *entry)
 		cpuid_entry_mask(entry, CPUID_7_ECX);
 		/* Set LA57 based on hardware capability. */
 		entry->ecx |= f_la57;
-		entry->ecx |= f_umip;
 		entry->ecx |= f_pku;
 		/* PKU is not yet implemented for shadow paging. */
 		if (!tdp_enabled || !boot_cpu_has(X86_FEATURE_OSPKE))
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 67958c27b7c0..f4efc45810b8 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7131,6 +7131,8 @@ static void vmx_set_supported_cpuid(struct kvm_cpuid_entry2 *entry)
 			cpuid_entry_set(entry, X86_FEATURE_MPX);
 		if (boot_cpu_has(X86_FEATURE_INVPCID) && cpu_has_vmx_invpcid())
 			cpuid_entry_set(entry, X86_FEATURE_INVPCID);
+		if (vmx_umip_emulated())
+			cpuid_entry_set(entry, X86_FEATURE_UMIP);
 		break;
 	default:
 		break;
-- 
2.24.1

