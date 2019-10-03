Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 140C7CB14F
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2019 23:39:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388504AbfJCVjO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Oct 2019 17:39:14 -0400
Received: from mga09.intel.com ([134.134.136.24]:52651 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387909AbfJCVjB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Oct 2019 17:39:01 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Oct 2019 14:38:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,253,1566889200"; 
   d="scan'208";a="186051647"
Received: from linksys13920.jf.intel.com (HELO rpedgeco-DESK5.jf.intel.com) ([10.54.75.11])
  by orsmga008.jf.intel.com with ESMTP; 03 Oct 2019 14:38:58 -0700
From:   Rick Edgecombe <rick.p.edgecombe@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-mm@kvack.org, luto@kernel.org, peterz@infradead.org,
        dave.hansen@intel.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, keescook@chromium.org
Cc:     kristen@linux.intel.com, deneen.t.dock@intel.com,
        Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: [RFC PATCH 12/13] mmap: Add XO support for KVM XO
Date:   Thu,  3 Oct 2019 14:23:59 -0700
Message-Id: <20191003212400.31130-13-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191003212400.31130-1-rick.p.edgecombe@intel.com>
References: <20191003212400.31130-1-rick.p.edgecombe@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The KVM XO feature enables the ability to create execute-only virtual
memory. Use this feature to create XO memory when PROT_EXEC and not
PROT_READ, as the behavior in the case of protection keys for userspace
and some arm64 platforms.

In the case of the ability to create execute only memory with protection
keys AND the ability to create native execute only memory, use the KVM
XO method of creating execute only memory to save a protection key.

Set the values of the __P100 and __S100 in protection_map during boot
instead of statically because the actual KVM XO bit in the PTE is
determinted at boot time and so can't be known at compile time.

Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
 arch/x86/include/asm/pgtable_types.h |  2 ++
 arch/x86/kernel/head64.c             |  3 +++
 mm/mmap.c                            | 30 +++++++++++++++++++++++-----
 3 files changed, 30 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
index d3c92c992089..fe976b4f0132 100644
--- a/arch/x86/include/asm/pgtable_types.h
+++ b/arch/x86/include/asm/pgtable_types.h
@@ -176,6 +176,8 @@ enum page_cache_mode {
 					 _PAGE_ACCESSED | _PAGE_NX)
 #define PAGE_READONLY_EXEC	__pgprot(_PAGE_PRESENT | _PAGE_USER |	\
 					 _PAGE_ACCESSED)
+#define PAGE_EXECONLY		__pgprot(_PAGE_PRESENT | _PAGE_USER |	\
+					 _PAGE_ACCESSED | _PAGE_NR)
 
 #define __PAGE_KERNEL_EXEC						\
 	(_PAGE_PRESENT | _PAGE_RW | _PAGE_DIRTY | _PAGE_ACCESSED | _PAGE_GLOBAL)
diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 7091702a7bec..69772b6e1810 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -133,6 +133,9 @@ static void __head check_kvmxo_support(unsigned long physaddr)
 
 	*fixup_int(&__pgtable_kvmxo_enabled, physaddr) = 1;
 	*fixup_int(&__pgtable_kvmxo_bit, physaddr) = physbits;
+
+	protection_map[4] = PAGE_EXECONLY;
+	protection_map[12] = PAGE_EXECONLY;
 }
 #else /* CONFIG_KVM_XO */
 static void __head check_kvmxo_support(unsigned long physaddr) { }
diff --git a/mm/mmap.c b/mm/mmap.c
index 7e8c3e8ae75f..034ffa0255b2 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1379,6 +1379,29 @@ static inline bool file_mmap_ok(struct file *file, struct inode *inode,
 	return true;
 }
 
+static inline int get_pkey(unsigned long flags)
+{
+	const unsigned long p_xo = pgprot_val(protection_map[4]);
+	const unsigned long p_xr = pgprot_val(protection_map[5]);
+	const unsigned long s_xo = pgprot_val(protection_map[12]);
+	const unsigned long s_xr = pgprot_val(protection_map[13]);
+	int pkey;
+
+	/* Prefer non-pkey XO capability if available, to save a pkey */
+
+	if (flags & MAP_PRIVATE && (p_xo != p_xr))
+		return 0;
+
+	if (flags & MAP_SHARED && (s_xo != s_xr))
+		return 0;
+
+	pkey = execute_only_pkey(current->mm);
+	if (pkey < 0)
+		pkey = 0;
+
+	return pkey;
+}
+
 /*
  * The caller must hold down_write(&current->mm->mmap_sem).
  */
@@ -1440,11 +1463,8 @@ unsigned long do_mmap(struct file *file, unsigned long addr,
 			return -EEXIST;
 	}
 
-	if (prot == PROT_EXEC) {
-		pkey = execute_only_pkey(mm);
-		if (pkey < 0)
-			pkey = 0;
-	}
+	if (prot == PROT_EXEC)
+		pkey = get_pkey(flags);
 
 	/* Do simple checking here so the lower-level routines won't have
 	 * to. we assume access permissions have been handled by the open
-- 
2.17.1

