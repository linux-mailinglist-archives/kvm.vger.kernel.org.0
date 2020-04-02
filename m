Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B46F219BD66
	for <lists+kvm@lfdr.de>; Thu,  2 Apr 2020 10:16:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387721AbgDBIQY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Apr 2020 04:16:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:49378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387574AbgDBIQY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Apr 2020 04:16:24 -0400
Received: from aquarius.haifa.ibm.com (nesher1.haifa.il.ibm.com [195.110.40.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F074D206F6;
        Thu,  2 Apr 2020 08:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585815383;
        bh=jxX8zNXGWAksHrGOsQVTIOOhLq7/MR35pRNCX6fWCos=;
        h=From:To:Cc:Subject:Date:From;
        b=BqgoIuUHpNdmRSH98YK6zhpsptJiDZILd8lnD1NxEG6YImrDeiUj8YmwIukQQTRqt
         Uw9RQW7bSFWCdoxvxs7/lfLWoRkU5cO24QB+HajjW1mte71fCGBjq/jjU629/X9AYV
         baIRQbtXFwwgByK5TUXM0mI2E31fAj+mY+BLP+c0=
From:   Mike Rapoport <rppt@kernel.org>
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        maobibo <maobibo@loongson.cn>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mike Rapoport <rppt@kernel.org>,
        Mike Rapoport <rppt@linux.ibm.com>
Subject: [PATCH] mips: define pud_index() regardless of page table folding
Date:   Thu,  2 Apr 2020 11:16:14 +0300
Message-Id: <20200402081614.5696-1-rppt@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Mike Rapoport <rppt@linux.ibm.com>

Commit 31168f033e37 ("mips: drop __pXd_offset() macros that duplicate
pXd_index() ones") is correct that pud_index() & __pud_offset() are the
same when pud_index() is actually provided, however it does not take into
account the __PAGETABLE_PUD_FOLDED case. This has broken MIPS KVM
compilation because it relied on availability of pud_index().

Define pud_index() regardless of page table folded. It will evaluate to
actual index for 4-level pagetables and to 0 for folded PUD level.

Link: https://lore.kernel.org/lkml/20200331154749.5457-1-pbonzini@redhat.com
Reported-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
---
 arch/mips/include/asm/pgtable-64.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/mips/include/asm/pgtable-64.h b/arch/mips/include/asm/pgtable-64.h
index f92716cfa4f4..ee5dc0c145b9 100644
--- a/arch/mips/include/asm/pgtable-64.h
+++ b/arch/mips/include/asm/pgtable-64.h
@@ -172,6 +172,8 @@
 
 extern pte_t invalid_pte_table[PTRS_PER_PTE];
 
+#define pud_index(address)	(((address) >> PUD_SHIFT) & (PTRS_PER_PUD - 1))
+
 #ifndef __PAGETABLE_PUD_FOLDED
 /*
  * For 4-level pagetables we defines these ourselves, for 3-level the
@@ -210,8 +212,6 @@ static inline void p4d_clear(p4d_t *p4dp)
 	p4d_val(*p4dp) = (unsigned long)invalid_pud_table;
 }
 
-#define pud_index(address)	(((address) >> PUD_SHIFT) & (PTRS_PER_PUD - 1))
-
 static inline unsigned long p4d_page_vaddr(p4d_t p4d)
 {
 	return p4d_val(p4d);
-- 
2.25.1

