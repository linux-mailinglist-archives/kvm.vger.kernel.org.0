Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FEC214F9E9
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2020 19:57:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727258AbgBAS4G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Feb 2020 13:56:06 -0500
Received: from mga01.intel.com ([192.55.52.88]:57278 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727137AbgBASwa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 1 Feb 2020 13:52:30 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Feb 2020 10:52:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,390,1574150400"; 
   d="scan'208";a="248075568"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga002.jf.intel.com with ESMTP; 01 Feb 2020 10:52:26 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 46/61] KVM: x86: Remove the unnecessary loop on CPUID 0x7 sub-leafs
Date:   Sat,  1 Feb 2020 10:52:03 -0800
Message-Id: <20200201185218.24473-47-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200201185218.24473-1-sean.j.christopherson@intel.com>
References: <20200201185218.24473-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Explicitly handle CPUID 0x7 sub-leaf 1.  The kernel is currently aware
of exactly one feature in CPUID 0x7.1,  which means there is room for
another 127 features before CPUID 0x7.2 will see the light of day, i.e.
the looping is likely to be dead code for years to come.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/cpuid.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 7362e5238799..47f61f4497fb 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -533,11 +533,9 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		if (boot_cpu_has(X86_FEATURE_AMD_SSBD))
 			cpuid_entry_set(entry, X86_FEATURE_SPEC_CTRL_SSBD);
 
-		for (i = 1, max_idx = entry->eax; i <= max_idx; i++) {
-			if (WARN_ON_ONCE(i > 1))
-				break;
-
-			entry = do_host_cpuid(array, function, i);
+		/* KVM only supports 0x7.0 and 0x7.1, capped above via min(). */
+		if (entry->eax == 1) {
+			entry = do_host_cpuid(array, function, 1);
 			if (!entry)
 				goto out;
 
-- 
2.24.1

