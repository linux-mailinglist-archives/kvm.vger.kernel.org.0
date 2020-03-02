Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEF7A1768DB
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 01:00:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727527AbgCCAAR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 19:00:17 -0500
Received: from mga02.intel.com ([134.134.136.20]:25520 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727413AbgCBX51 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 18:57:27 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Mar 2020 15:57:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,509,1574150400"; 
   d="scan'208";a="243384656"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga006.jf.intel.com with ESMTP; 02 Mar 2020 15:57:21 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v2 11/66] KVM: x86: Drop the explicit @index from do_cpuid_7_mask()
Date:   Mon,  2 Mar 2020 15:56:14 -0800
Message-Id: <20200302235709.27467-12-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200302235709.27467-1-sean.j.christopherson@intel.com>
References: <20200302235709.27467-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop the index param from do_cpuid_7_mask() and instead switch on the
entry's index, which is guaranteed to be set by do_host_cpuid().

No functional change intended.

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
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

