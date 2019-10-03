Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93621CB14B
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2019 23:39:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388622AbfJCVjP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Oct 2019 17:39:15 -0400
Received: from mga09.intel.com ([134.134.136.24]:52655 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388128AbfJCVjB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Oct 2019 17:39:01 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Oct 2019 14:38:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,253,1566889200"; 
   d="scan'208";a="186051644"
Received: from linksys13920.jf.intel.com (HELO rpedgeco-DESK5.jf.intel.com) ([10.54.75.11])
  by orsmga008.jf.intel.com with ESMTP; 03 Oct 2019 14:38:58 -0700
From:   Rick Edgecombe <rick.p.edgecombe@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-mm@kvack.org, luto@kernel.org, peterz@infradead.org,
        dave.hansen@intel.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, keescook@chromium.org
Cc:     kristen@linux.intel.com, deneen.t.dock@intel.com,
        Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: [RFC PATCH 11/13] x86, ptdump: Add NR bit to page table dump
Date:   Thu,  3 Oct 2019 14:23:58 -0700
Message-Id: <20191003212400.31130-12-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191003212400.31130-1-rick.p.edgecombe@intel.com>
References: <20191003212400.31130-1-rick.p.edgecombe@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add printing of the NR permission to the page table dump code.

Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
 arch/x86/mm/dump_pagetables.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/mm/dump_pagetables.c b/arch/x86/mm/dump_pagetables.c
index ab67822fd2f4..8932aa9e3a9e 100644
--- a/arch/x86/mm/dump_pagetables.c
+++ b/arch/x86/mm/dump_pagetables.c
@@ -182,7 +182,7 @@ static void printk_prot(struct seq_file *m, pgprot_t prot, int level, bool dmsg)
 
 	if (!(pr & _PAGE_PRESENT)) {
 		/* Not present */
-		pt_dump_cont_printf(m, dmsg, "                              ");
+		pt_dump_cont_printf(m, dmsg, "                                 ");
 	} else {
 		if (pr & _PAGE_USER)
 			pt_dump_cont_printf(m, dmsg, "USR ");
@@ -219,6 +219,10 @@ static void printk_prot(struct seq_file *m, pgprot_t prot, int level, bool dmsg)
 			pt_dump_cont_printf(m, dmsg, "NX ");
 		else
 			pt_dump_cont_printf(m, dmsg, "x  ");
+		if (pr & _PAGE_NR)
+			pt_dump_cont_printf(m, dmsg, "NR ");
+		else
+			pt_dump_cont_printf(m, dmsg, "r  ");
 	}
 	pt_dump_cont_printf(m, dmsg, "%s\n", level_name[level]);
 }
-- 
2.17.1

