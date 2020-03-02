Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5035A1768F8
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 01:01:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727485AbgCCAB3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 19:01:29 -0500
Received: from mga02.intel.com ([134.134.136.20]:25519 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727234AbgCBX50 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 18:57:26 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Mar 2020 15:57:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,509,1574150400"; 
   d="scan'208";a="243384668"
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
Subject: [PATCH v2 15/66] KVM: x86: Refactor CPUID 0x4 and 0x8000001d handling
Date:   Mon,  2 Mar 2020 15:56:18 -0800
Message-Id: <20200302235709.27467-16-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200302235709.27467-1-sean.j.christopherson@intel.com>
References: <20200302235709.27467-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Refactoring the sub-leaf handling for CPUID 0x4/0x8000001d to eliminate
a one-off variable and its associated brackets.

No functional change intended.

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/cpuid.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 5044a595799f..d75d539da759 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -545,20 +545,16 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
 		break;
 	/* functions 4 and 0x8000001d have additional index. */
 	case 4:
-	case 0x8000001d: {
-		int cache_type;
-
-		/* read more entries until cache_type is zero */
-		for (i = 1; ; ++i) {
-			cache_type = entry[i - 1].eax & 0x1f;
-			if (!cache_type)
-				break;
-
+	case 0x8000001d:
+		/*
+		 * Read entries until the cache type in the previous entry is
+		 * zero, i.e. indicates an invalid entry.
+		 */
+		for (i = 1; entry[i - 1].eax & 0x1f; ++i) {
 			if (!do_host_cpuid(&entry[i], nent, maxnent, function, i))
 				goto out;
 		}
 		break;
-	}
 	case 6: /* Thermal management */
 		entry->eax = 0x4; /* allow ARAT */
 		entry->ebx = 0;
-- 
2.24.1

