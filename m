Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2C4316A572
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2020 12:46:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727689AbgBXLqR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Feb 2020 06:46:17 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:17442 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727673AbgBXLqR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 Feb 2020 06:46:17 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01OBclDL107748;
        Mon, 24 Feb 2020 06:46:13 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yb18ukkg7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Feb 2020 06:46:13 -0500
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 01OBdEkn109251;
        Mon, 24 Feb 2020 06:46:12 -0500
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yb18ukkfm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Feb 2020 06:46:12 -0500
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 01OBZA7U015270;
        Mon, 24 Feb 2020 11:41:11 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma03wdc.us.ibm.com with ESMTP id 2yaux6330y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Feb 2020 11:41:11 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01OBf9mH55116216
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Feb 2020 11:41:09 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9E5DA28058;
        Mon, 24 Feb 2020 11:41:09 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 82CC22805A;
        Mon, 24 Feb 2020 11:41:09 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.114.17.106])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 24 Feb 2020 11:41:09 +0000 (GMT)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
        Will Deacon <will@kernel.org>
Subject: [PATCH v4 01/36] mm/gup/writeback: add callbacks for inaccessible pages
Date:   Mon, 24 Feb 2020 06:40:32 -0500
Message-Id: <20200224114107.4646-2-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200224114107.4646-1-borntraeger@de.ibm.com>
References: <20200224114107.4646-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-24_02:2020-02-21,2020-02-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 phishscore=0
 spamscore=0 suspectscore=2 bulkscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=815 impostorscore=0 adultscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002240099
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Claudio Imbrenda <imbrenda@linux.ibm.com>

With the introduction of protected KVM guests on s390 there is now a
concept of inaccessible pages. These pages need to be made accessible
before the host can access them.

While cpu accesses will trigger a fault that can be resolved, I/O
accesses will just fail.  We need to add a callback into architecture
code for places that will do I/O, namely when writeback is started or
when a page reference is taken.

This is not only to enable paging, file backing etc, it is also
necessary to protect the host against a malicious user space. For
example a bad QEMU could simply start direct I/O on such protected
memory.  We do not want userspace to be able to trigger I/O errors and
thus we the logic is "whenever somebody accesses that page (gup) or
doing I/O, make sure that this page can be accessed. When the guest
tries to access that page we will wait in the page fault handler for
writeback to have finished and for the page_ref to be the expected
value.

On s390x the function is not supposed to fail, so it is ok to use a
WARN_ON on failure. If we ever need some more finegrained handling
we can tackle this when we know the details.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Acked-by: Will Deacon <will@kernel.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 include/linux/gfp.h |  6 ++++++
 mm/gup.c            | 15 ++++++++++++---
 mm/page-writeback.c |  5 +++++
 3 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index e5b817cb86e7..be2754841369 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -485,6 +485,12 @@ static inline void arch_free_page(struct page *page, int order) { }
 #ifndef HAVE_ARCH_ALLOC_PAGE
 static inline void arch_alloc_page(struct page *page, int order) { }
 #endif
+#ifndef HAVE_ARCH_MAKE_PAGE_ACCESSIBLE
+static inline int arch_make_page_accessible(struct page *page)
+{
+	return 0;
+}
+#endif
 
 struct page *
 __alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order, int preferred_nid,
diff --git a/mm/gup.c b/mm/gup.c
index 1b521e0ac1de..354bcfbd844b 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -193,6 +193,7 @@ static struct page *follow_page_pte(struct vm_area_struct *vma,
 	struct page *page;
 	spinlock_t *ptl;
 	pte_t *ptep, pte;
+	int ret;
 
 	/* FOLL_GET and FOLL_PIN are mutually exclusive. */
 	if (WARN_ON_ONCE((flags & (FOLL_PIN | FOLL_GET)) ==
@@ -250,8 +251,6 @@ static struct page *follow_page_pte(struct vm_area_struct *vma,
 		if (is_zero_pfn(pte_pfn(pte))) {
 			page = pte_page(pte);
 		} else {
-			int ret;
-
 			ret = follow_pfn_pte(vma, address, ptep, flags);
 			page = ERR_PTR(ret);
 			goto out;
@@ -259,7 +258,6 @@ static struct page *follow_page_pte(struct vm_area_struct *vma,
 	}
 
 	if (flags & FOLL_SPLIT && PageTransCompound(page)) {
-		int ret;
 		get_page(page);
 		pte_unmap_unlock(ptep, ptl);
 		lock_page(page);
@@ -276,6 +274,12 @@ static struct page *follow_page_pte(struct vm_area_struct *vma,
 			page = ERR_PTR(-ENOMEM);
 			goto out;
 		}
+		ret = arch_make_page_accessible(page);
+		if (ret) {
+			put_page(page);
+			page = ERR_PTR(ret);
+			goto out;
+		}
 	}
 	if (flags & FOLL_TOUCH) {
 		if ((flags & FOLL_WRITE) &&
@@ -1919,6 +1923,11 @@ static int gup_pte_range(pmd_t pmd, unsigned long addr, unsigned long end,
 
 		VM_BUG_ON_PAGE(compound_head(page) != head, page);
 
+		ret = arch_make_page_accessible(page);
+		if (ret) {
+			put_page(head);
+			goto pte_unmap;
+		}
 		SetPageReferenced(page);
 		pages[*nr] = page;
 		(*nr)++;
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 2caf780a42e7..558d7063c117 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2807,6 +2807,11 @@ int __test_set_page_writeback(struct page *page, bool keep_write)
 		inc_zone_page_state(page, NR_ZONE_WRITE_PENDING);
 	}
 	unlock_page_memcg(page);
+	/*
+	 * If writeback has been triggered on a page that cannot be made
+	 * accessible, it is too late.
+	 */
+	WARN_ON(arch_make_page_accessible(page));
 	return ret;
 
 }
-- 
2.25.0

