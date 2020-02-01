Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3744214F9F5
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2020 19:58:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727546AbgBAS4c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Feb 2020 13:56:32 -0500
Received: from mga05.intel.com ([192.55.52.43]:37515 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726976AbgBASw2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 1 Feb 2020 13:52:28 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Feb 2020 10:52:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,390,1574150400"; 
   d="scan'208";a="248075465"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga002.jf.intel.com with ESMTP; 01 Feb 2020 10:52:25 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 12/61] KVM: x86: Drop redundant boot cpu checks on SSBD feature bits
Date:   Sat,  1 Feb 2020 10:51:29 -0800
Message-Id: <20200201185218.24473-13-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200201185218.24473-1-sean.j.christopherson@intel.com>
References: <20200201185218.24473-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop redundnant checks when "emulating" SSBD feature across vendors,
i.e. advertising the AMD variant when running on an Intel CPU and vice
versa.  Both SPEC_CTRL_SSBD and AMD_SSBD are already defined in the
leaf-specific feature masks and are *not* forcefully set by the kernel,
i.e. will already be set in the entry when supported by the host.

Functionally, this changes nothing, but the redundant check is
confusing, especially when considering future patches that will further
differentiate between "real" and "emulated" feature bits.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/cpuid.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index fd04f17d1836..52f0af4e10d5 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -405,8 +405,7 @@ static inline void do_cpuid_7_mask(struct kvm_cpuid_entry2 *entry)
 			entry->edx |= F(SPEC_CTRL);
 		if (boot_cpu_has(X86_FEATURE_STIBP))
 			entry->edx |= F(INTEL_STIBP);
-		if (boot_cpu_has(X86_FEATURE_SPEC_CTRL_SSBD) ||
-		    boot_cpu_has(X86_FEATURE_AMD_SSBD))
+		if (boot_cpu_has(X86_FEATURE_AMD_SSBD))
 			entry->edx |= F(SPEC_CTRL_SSBD);
 		/*
 		 * We emulate ARCH_CAPABILITIES in software even
@@ -780,8 +779,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
 			entry->ebx |= F(AMD_IBRS);
 		if (boot_cpu_has(X86_FEATURE_STIBP))
 			entry->ebx |= F(AMD_STIBP);
-		if (boot_cpu_has(X86_FEATURE_SPEC_CTRL_SSBD) ||
-		    boot_cpu_has(X86_FEATURE_AMD_SSBD))
+		if (boot_cpu_has(X86_FEATURE_SPEC_CTRL_SSBD))
 			entry->ebx |= F(AMD_SSBD);
 		if (!boot_cpu_has_bug(X86_BUG_SPEC_STORE_BYPASS))
 			entry->ebx |= F(AMD_SSB_NO);
-- 
2.24.1

