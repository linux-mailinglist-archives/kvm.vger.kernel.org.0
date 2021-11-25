Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B50F45D18E
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 01:21:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352649AbhKYAYM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 19:24:12 -0500
Received: from mga18.intel.com ([134.134.136.126]:32610 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347122AbhKYAYK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 19:24:10 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10178"; a="222281260"
X-IronPort-AV: E=Sophos;i="5.87,261,1631602800"; 
   d="scan'208";a="222281260"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 16:20:59 -0800
X-IronPort-AV: E=Sophos;i="5.87,261,1631602800"; 
   d="scan'208";a="675042074"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 16:20:59 -0800
From:   isaku.yamahata@intel.com
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [RFC PATCH v3 02/59] x86/mtrr: mask out keyid bits from variable mtrr mask register
Date:   Wed, 24 Nov 2021 16:19:45 -0800
Message-Id: <890780d3db0c2458b7ffa83636cbf214162e1e3d.1637799475.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1637799475.git.isaku.yamahata@intel.com>
References: <cover.1637799475.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

This is a preparation for TDX support. TDX repurposes high bits of physcial
address to private key ID similarly to MKTME.
IA32_TME_ACTIVATE.MK_TME_KEYID_BITS has same meaning for both TDX
disabled/enable for compatibility.

MTRR calculates mask based on available physical address bits.  MKTME
repurpose high bit of physical address to key id for key id.  CPUID MAX_PA
remains same and the bits stolen for key id is controlled IA32_TME_ACTIVATE
MSR bit 35:32.  Because Key ID bits shouldn't affects memory cachability,
MTRR mask should exclude bits repourposed for Key ID.  It's OS
responsibility to maintain cache coherency.  detect_tme @
arch/x86/kernel/cpu/intel.c detects tme and destract it from total usable
physical bits. This patch adds same logic needed for MTRR.

Co-developed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kernel/cpu/mtrr/mtrr.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/x86/kernel/cpu/mtrr/mtrr.c b/arch/x86/kernel/cpu/mtrr/mtrr.c
index 2746cac9d8a9..79eaf6ed20a6 100644
--- a/arch/x86/kernel/cpu/mtrr/mtrr.c
+++ b/arch/x86/kernel/cpu/mtrr/mtrr.c
@@ -713,6 +713,15 @@ void __init mtrr_bp_init(void)
 			     boot_cpu_data.x86_stepping == 0x4))
 				phys_addr = 36;
 
+			if (boot_cpu_has(X86_FEATURE_TME)) {
+				u64 tme_activate;
+
+				rdmsrl(MSR_IA32_TME_ACTIVATE, tme_activate);
+				if (TME_ACTIVATE_LOCKED(tme_activate) &&
+				    TME_ACTIVATE_ENABLED(tme_activate)) {
+					phys_addr -= TME_ACTIVATE_KEYID_BITS(tme_activate);
+				}
+			}
 			size_or_mask = SIZE_OR_MASK_BITS(phys_addr);
 			size_and_mask = ~size_or_mask & 0xfffff00000ULL;
 		} else if (boot_cpu_data.x86_vendor == X86_VENDOR_CENTAUR &&
-- 
2.25.1

