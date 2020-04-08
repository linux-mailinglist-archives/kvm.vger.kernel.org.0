Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BB301A1B74
	for <lists+kvm@lfdr.de>; Wed,  8 Apr 2020 07:07:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726855AbgDHFHc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Apr 2020 01:07:32 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:54140 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727349AbgDHFHc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Apr 2020 01:07:32 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 038553bq013448;
        Wed, 8 Apr 2020 05:07:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=jtenwkhxJwQP2uq2B69E8Rt6lQLXw7OMtcgth/iQeLE=;
 b=rRyPLGp4AV4NTgpv3HbnBcQ7xi+6GgDMb68GyvXgeEhCjSMF6ysWqwYzf7YpGW/uJiQW
 Fl8krSNYEc/p+LC9gyJHE1S5WR1iuo0vMrP3nJHdB8saF1Jw3mo2oqfIgWRhYKvPF1p7
 Uw2FQ74MmTPitiYxcvgIQ0kbhOLcwOuoFK5RFTT3vpoyc/2D0JHD7bMk8ZvhhaJGCrSm
 wC7lni75F9GI7ehsae7NyFMzWCwJjHBVrugyTPdblSdk89Z5pO5iQ3RDD2uiPIcdPfTJ
 ktNEWQUDZ2W1eLam26fvFBy1P/ka5AIDkRC8dGg8z918WC1UQ3hSAKntgBBIJe8Lk9lZ sg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 3091m39155-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Apr 2020 05:07:19 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03851WCB100753;
        Wed, 8 Apr 2020 05:05:18 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 3091m2hv20-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Apr 2020 05:05:18 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03855H45007452;
        Wed, 8 Apr 2020 05:05:17 GMT
Received: from monad.ca.oracle.com (/10.156.75.81)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 07 Apr 2020 22:05:17 -0700
From:   Ankur Arora <ankur.a.arora@oracle.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     peterz@infradead.org, hpa@zytor.com, jpoimboe@redhat.com,
        namit@vmware.com, mhiramat@kernel.org, jgross@suse.com,
        bp@alien8.de, vkuznets@redhat.com, pbonzini@redhat.com,
        boris.ostrovsky@oracle.com, mihai.carabas@oracle.com,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org,
        virtualization@lists.linux-foundation.org,
        Ankur Arora <ankur.a.arora@oracle.com>
Subject: [RFC PATCH 13/26] x86/alternatives: Split __text_poke()
Date:   Tue,  7 Apr 2020 22:03:10 -0700
Message-Id: <20200408050323.4237-14-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200408050323.4237-1-ankur.a.arora@oracle.com>
References: <20200408050323.4237-1-ankur.a.arora@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9584 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 spamscore=0 adultscore=0 suspectscore=0 mlxlogscore=873
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004080037
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9584 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0
 impostorscore=0 malwarescore=0 lowpriorityscore=0 mlxlogscore=934
 priorityscore=1501 clxscore=1015 bulkscore=0 phishscore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004080037
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Separate __text_poke() into map, memcpy and unmap portions,
(__text_poke_map(), __text_do_poke() and __text_poke_unmap().)

Do this to separate the non-reentrant bits from the reentrant
__text_do_poke(). __text_poke_map()/_unmap() modify poking_mm,
poking_addr and do the pte-mapping and thus are non-reentrant.

This allows __text_do_poke() to be safely called from an INT3
context with __text_poke_map()/_unmap() being called at the
start and the end of the patching of a call-site instead of
doing that for each stage of the three patching stages.

Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---
 arch/x86/kernel/alternative.c | 46 +++++++++++++++++++++++++----------
 1 file changed, 33 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 0344e49a4ade..337aad8c2521 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -805,13 +805,12 @@ void __init_or_module text_poke_early(void *addr, const void *opcode,
 __ro_after_init struct mm_struct *poking_mm;
 __ro_after_init unsigned long poking_addr;
 
-static void __text_poke(void *addr, const void *opcode, size_t len)
+static void __text_poke_map(void *addr, size_t len,
+			    temp_mm_state_t *prev_mm, pte_t **ptep)
 {
 	bool cross_page_boundary = offset_in_page(addr) + len > PAGE_SIZE;
 	struct page *pages[2] = {NULL};
-	temp_mm_state_t prev;
-	unsigned long flags;
-	pte_t pte, *ptep;
+	pte_t pte;
 	pgprot_t pgprot;
 
 	/*
@@ -836,8 +835,6 @@ static void __text_poke(void *addr, const void *opcode, size_t len)
 	 */
 	BUG_ON(!pages[0] || (cross_page_boundary && !pages[1]));
 
-	local_irq_save(flags);
-
 	/*
 	 * Map the page without the global bit, as TLB flushing is done with
 	 * flush_tlb_mm_range(), which is intended for non-global PTEs.
@@ -849,30 +846,42 @@ static void __text_poke(void *addr, const void *opcode, size_t len)
 	 * unlocked. This does mean that we need to be careful that no other
 	 * context (ex. INT3 handler) is simultaneously writing to this pte.
 	 */
-	ptep = __get_unlocked_pte(poking_mm, poking_addr);
+	*ptep = __get_unlocked_pte(poking_mm, poking_addr);
 	/*
 	 * This must not fail; preallocated in poking_init().
 	 */
-	VM_BUG_ON(!ptep);
+	VM_BUG_ON(!*ptep);
 
 	pte = mk_pte(pages[0], pgprot);
-	set_pte_at(poking_mm, poking_addr, ptep, pte);
+	set_pte_at(poking_mm, poking_addr, *ptep, pte);
 
 	if (cross_page_boundary) {
 		pte = mk_pte(pages[1], pgprot);
-		set_pte_at(poking_mm, poking_addr + PAGE_SIZE, ptep + 1, pte);
+		set_pte_at(poking_mm, poking_addr + PAGE_SIZE, *ptep + 1, pte);
 	}
 
 	/*
 	 * Loading the temporary mm behaves as a compiler barrier, which
 	 * guarantees that the PTE will be set at the time memcpy() is done.
 	 */
-	prev = use_temporary_mm(poking_mm);
+	*prev_mm = use_temporary_mm(poking_mm);
+}
 
+/*
+ * Do the actual poke. Needs to be re-entrant as this can be called
+ * via INT3 context as well.
+ */
+static void __text_do_poke(unsigned long offset, const void *opcode, size_t len)
+{
 	kasan_disable_current();
-	memcpy((u8 *)poking_addr + offset_in_page(addr), opcode, len);
+	memcpy((u8 *)poking_addr + offset, opcode, len);
 	kasan_enable_current();
+}
 
+static void __text_poke_unmap(void *addr, const void *opcode, size_t len,
+			      temp_mm_state_t *prev_mm, pte_t *ptep)
+{
+	bool cross_page_boundary = offset_in_page(addr) + len > PAGE_SIZE;
 	/*
 	 * Ensure that the PTE is only cleared after the instructions of memcpy
 	 * were issued by using a compiler barrier.
@@ -888,7 +897,7 @@ static void __text_poke(void *addr, const void *opcode, size_t len)
 	 * instruction that already allows the core to see the updated version.
 	 * Xen-PV is assumed to serialize execution in a similar manner.
 	 */
-	unuse_temporary_mm(prev);
+	unuse_temporary_mm(*prev_mm);
 
 	/*
 	 * Flushing the TLB might involve IPIs, which would require enabled
@@ -903,7 +912,18 @@ static void __text_poke(void *addr, const void *opcode, size_t len)
 	 * fundamentally screwy; there's nothing we can really do about that.
 	 */
 	BUG_ON(memcmp(addr, opcode, len));
+}
 
+static void __text_poke(void *addr, const void *opcode, size_t len)
+{
+	temp_mm_state_t prev_mm;
+	unsigned long flags;
+	pte_t *ptep;
+
+	local_irq_save(flags);
+	__text_poke_map(addr, len, &prev_mm, &ptep);
+	__text_do_poke(offset_in_page(addr), opcode, len);
+	__text_poke_unmap(addr, opcode, len, &prev_mm, ptep);
 	local_irq_restore(flags);
 }
 
-- 
2.20.1

