Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABABB17688E
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 00:57:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727545AbgCBX5d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 18:57:33 -0500
Received: from mga02.intel.com ([134.134.136.20]:25524 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727496AbgCBX5a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 18:57:30 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Mar 2020 15:57:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,509,1574150400"; 
   d="scan'208";a="243384731"
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
Subject: [PATCH v2 36/66] KVM: x86: Handle GBPAGE CPUID adjustment for EPT in VMX code
Date:   Mon,  2 Mar 2020 15:56:39 -0800
Message-Id: <20200302235709.27467-37-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200302235709.27467-1-sean.j.christopherson@intel.com>
References: <20200302235709.27467-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the clearing of the GBPAGE CPUID bit into VMX to eliminate an
instance of the undesirable "unsigned f_* = *_supported ? F(*) : 0"
pattern in the common CPUID handling code, and to pave the way toward
eliminating ->get_lpage_level().

No functional change intended.

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/cpuid.c   | 3 +--
 arch/x86/kvm/vmx/vmx.c | 2 ++
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 84b9a488a443..aacfd6af774a 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -416,8 +416,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 	int r, i, max_idx;
 	unsigned f_nx = is_efer_nx() ? F(NX) : 0;
 #ifdef CONFIG_X86_64
-	unsigned f_gbpages = (kvm_x86_ops->get_lpage_level() == PT_PDPE_LEVEL)
-				? F(GBPAGES) : 0;
+	unsigned f_gbpages = F(GBPAGES);
 	unsigned f_lm = F(LM);
 #else
 	unsigned f_gbpages = 0;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 1a4ac20797a4..131f4b88d307 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7145,6 +7145,8 @@ static void vmx_set_supported_cpuid(struct kvm_cpuid_entry2 *entry)
 	case 0x80000001:
 		if (!cpu_has_vmx_rdtscp())
 			cpuid_entry_clear(entry, X86_FEATURE_RDTSCP);
+		if (enable_ept && !cpu_has_vmx_ept_1g_page())
+			cpuid_entry_clear(entry, X86_FEATURE_GBPAGES);
 		break;
 	default:
 		break;
-- 
2.24.1

