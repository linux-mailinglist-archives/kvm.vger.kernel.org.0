Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 825A0CB150
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2019 23:39:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388548AbfJCVjP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Oct 2019 17:39:15 -0400
Received: from mga09.intel.com ([134.134.136.24]:52653 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388127AbfJCVjB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Oct 2019 17:39:01 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Oct 2019 14:38:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,253,1566889200"; 
   d="scan'208";a="186051641"
Received: from linksys13920.jf.intel.com (HELO rpedgeco-DESK5.jf.intel.com) ([10.54.75.11])
  by orsmga008.jf.intel.com with ESMTP; 03 Oct 2019 14:38:57 -0700
From:   Rick Edgecombe <rick.p.edgecombe@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-mm@kvack.org, luto@kernel.org, peterz@infradead.org,
        dave.hansen@intel.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, keescook@chromium.org
Cc:     kristen@linux.intel.com, deneen.t.dock@intel.com,
        Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: [RFC PATCH 10/13] x86/mm: Add NR page bit for KVM XO
Date:   Thu,  3 Oct 2019 14:23:57 -0700
Message-Id: <20191003212400.31130-11-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191003212400.31130-1-rick.p.edgecombe@intel.com>
References: <20191003212400.31130-1-rick.p.edgecombe@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add _PAGE_BIT_NR and _PAGE_NR, the values of which are determined
dynamically at boot. This page type is only valid after checking for for
the KVM XO CPUID bit.

Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
 arch/x86/include/asm/pgtable_types.h | 11 +++++++++++
 arch/x86/mm/init.c                   |  3 +++
 2 files changed, 14 insertions(+)

diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
index b5e49e6bac63..d3c92c992089 100644
--- a/arch/x86/include/asm/pgtable_types.h
+++ b/arch/x86/include/asm/pgtable_types.h
@@ -30,6 +30,14 @@
 #define _PAGE_BIT_PKEY_BIT3	62	/* Protection Keys, bit 4/4 */
 #define _PAGE_BIT_NX		63	/* No execute: only valid after cpuid check */
 
+#if defined(CONFIG_KVM_XO) && !defined(__ASSEMBLY__)
+extern unsigned int __pgtable_kvmxo_bit;
+/* KVM based not-readable: only valid after cpuid check */
+#define _PAGE_BIT_NR		(__pgtable_kvmxo_bit)
+#else /* defined(CONFIG_KVM_XO) && !defined(__ASSEMBLY__) */
+#define _PAGE_BIT_NR		0
+#endif /* defined(CONFIG_KVM_XO) && !defined(__ASSEMBLY__) */
+
 #define _PAGE_BIT_SPECIAL	_PAGE_BIT_SOFTW1
 #define _PAGE_BIT_CPA_TEST	_PAGE_BIT_SOFTW1
 #define _PAGE_BIT_SOFT_DIRTY	_PAGE_BIT_SOFTW3 /* software dirty tracking */
@@ -39,6 +47,9 @@
 /* - if the user mapped it with PROT_NONE; pte_present gives true */
 #define _PAGE_BIT_PROTNONE	_PAGE_BIT_GLOBAL
 
+#define _PAGE_NR	(pgtable_kvmxo_enabled() ? \
+			(_AT(pteval_t, 1) << _PAGE_BIT_NR) : 0)
+
 #define _PAGE_PRESENT	(_AT(pteval_t, 1) << _PAGE_BIT_PRESENT)
 #define _PAGE_RW	(_AT(pteval_t, 1) << _PAGE_BIT_RW)
 #define _PAGE_USER	(_AT(pteval_t, 1) << _PAGE_BIT_USER)
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index fd10d91a6115..7298156a76d5 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -195,6 +195,9 @@ static void __init probe_page_size_mask(void)
 		__supported_pte_mask |= _PAGE_GLOBAL;
 	}
 
+	if (pgtable_kvmxo_enabled())
+		__supported_pte_mask |= _PAGE_NR;
+
 	/* By the default is everything supported: */
 	__default_kernel_pte_mask = __supported_pte_mask;
 	/* Except when with PTI where the kernel is mostly non-Global: */
-- 
2.17.1

