Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84BA914FA00
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2020 19:58:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727754AbgBAS5I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Feb 2020 13:57:08 -0500
Received: from mga01.intel.com ([192.55.52.88]:57278 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726893AbgBASw1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 1 Feb 2020 13:52:27 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Feb 2020 10:52:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,390,1574150400"; 
   d="scan'208";a="248075446"
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
Subject: [PATCH 06/61] KVM: x86: Move CPUID 0xD.1 handling out of the index>0 loop
Date:   Sat,  1 Feb 2020 10:51:23 -0800
Message-Id: <20200201185218.24473-7-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200201185218.24473-1-sean.j.christopherson@intel.com>
References: <20200201185218.24473-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Mov the sub-leaf 1 handling for CPUID 0xD out of the index>0 loop so
that the loop only handles index>2.  Sub-leafs 2+ have identical
semantics, whereas sub-leaf 1 is effectively a feature sub-leaf.

Moving sub-leaf 1 out of the loop does duplicate a bit of code, but
the nent/maxnent code will be consolidated in a future patch, and
duplicating the clear of ECX/EDX is arguably a good thing as the reasons
for clearing said registers are completely different.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/cpuid.c | 37 ++++++++++++++++++++++---------------
 1 file changed, 22 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index e5cf1e0cf84a..fc8540596386 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -653,26 +653,33 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
 		if (!supported)
 			break;
 
-		for (idx = 1, i = 1; idx < 64; ++idx) {
+		if (*nent >= maxnent)
+			goto out;
+
+		do_host_cpuid(&entry[1], function, 1);
+		++*nent;
+
+		entry[1].eax &= kvm_cpuid_D_1_eax_x86_features;
+		cpuid_mask(&entry[1].eax, CPUID_D_1_EAX);
+		if (entry[1].eax & (F(XSAVES)|F(XSAVEC)))
+			entry[1].ebx = xstate_required_size(supported, true);
+		else
+			entry[1].ebx = 0;
+		/* Saving XSS controlled state via XSAVES isn't supported. */
+		entry[1].ecx = 0;
+		entry[1].edx = 0;
+
+		for (idx = 2, i = 2; idx < 64; ++idx) {
 			u64 mask = ((u64)1 << idx);
+
 			if (*nent >= maxnent)
 				goto out;
 
 			do_host_cpuid(&entry[i], function, idx);
-			if (idx == 1) {
-				entry[i].eax &= kvm_cpuid_D_1_eax_x86_features;
-				cpuid_mask(&entry[i].eax, CPUID_D_1_EAX);
-				entry[i].ebx = 0;
-				if (entry[i].eax & (F(XSAVES)|F(XSAVEC)))
-					entry[i].ebx =
-						xstate_required_size(supported,
-								     true);
-			} else {
-				if (entry[i].eax == 0 || !(supported & mask))
-					continue;
-				if (WARN_ON_ONCE(entry[i].ecx & 1))
-					continue;
-			}
+			if (entry[i].eax == 0 || !(supported & mask))
+				continue;
+			if (WARN_ON_ONCE(entry[i].ecx & 1))
+				continue;
 			entry[i].ecx = 0;
 			entry[i].edx = 0;
 			++*nent;
-- 
2.24.1

