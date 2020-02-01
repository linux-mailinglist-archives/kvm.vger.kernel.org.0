Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19F9114F9FD
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2020 19:58:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727605AbgBAS5H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Feb 2020 13:57:07 -0500
Received: from mga01.intel.com ([192.55.52.88]:57278 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726971AbgBASw2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 1 Feb 2020 13:52:28 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Feb 2020 10:52:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,390,1574150400"; 
   d="scan'208";a="248075461"
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
Subject: [PATCH 11/61] KVM: x86: Drop the explicit @index from do_cpuid_7_mask()
Date:   Sat,  1 Feb 2020 10:51:28 -0800
Message-Id: <20200201185218.24473-12-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200201185218.24473-1-sean.j.christopherson@intel.com>
References: <20200201185218.24473-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop the index param from do_cpuid_7_mask() and instead switch on the
entry's index, which is guaranteed to be set by do_host_cpuid().

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/cpuid.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index b626893a11d5..fd04f17d1836 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -346,7 +346,7 @@ static int __do_cpuid_func_emulated(struct kvm_cpuid_entry2 *entry,
 	return 0;
 }
 
-static inline void do_cpuid_7_mask(struct kvm_cpuid_entry2 *entry, int index)
+static inline void do_cpuid_7_mask(struct kvm_cpuid_entry2 *entry)
 {
 	unsigned f_invpcid = kvm_x86_ops->invpcid_supported() ? F(INVPCID) : 0;
 	unsigned f_mpx = kvm_mpx_supported() ? F(MPX) : 0;
@@ -380,7 +380,7 @@ static inline void do_cpuid_7_mask(struct kvm_cpuid_entry2 *entry, int index)
 	const u32 kvm_cpuid_7_1_eax_x86_features =
 		F(AVX512_BF16);
 
-	switch (index) {
+	switch (entry->index) {
 	case 0:
 		entry->eax = min(entry->eax, 1u);
 		entry->ebx &= kvm_cpuid_7_0_ebx_x86_features;
@@ -573,7 +573,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
 	case 7: {
 		int i;
 
-		do_cpuid_7_mask(entry, 0);
+		do_cpuid_7_mask(entry);
 
 		for (i = 1; i <= entry->eax; i++) {
 			if (*nent >= maxnent)
@@ -582,7 +582,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
 			do_host_cpuid(&entry[i], function, i);
 			++*nent;
 
-			do_cpuid_7_mask(&entry[i], i);
+			do_cpuid_7_mask(&entry[i]);
 		}
 		break;
 	}
-- 
2.24.1

