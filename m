Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC82415F99B
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2020 23:28:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728206AbgBNW1s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Feb 2020 17:27:48 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:57722 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728190AbgBNW1r (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Feb 2020 17:27:47 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01EMOQwt140482;
        Fri, 14 Feb 2020 17:27:42 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y4j897ny6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Feb 2020 17:27:41 -0500
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 01EMQPA0144752;
        Fri, 14 Feb 2020 17:27:41 -0500
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y4j897nxj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Feb 2020 17:27:41 -0500
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 01EMRBsq019920;
        Fri, 14 Feb 2020 22:27:40 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma04dal.us.ibm.com with ESMTP id 2y5bc0cd9x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Feb 2020 22:27:40 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01EMRb6B57540952
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Feb 2020 22:27:37 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 47335136093;
        Fri, 14 Feb 2020 22:27:37 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4A879136091;
        Fri, 14 Feb 2020 22:27:36 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.114.17.106])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 14 Feb 2020 22:27:36 +0000 (GMT)
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
        Will Deacon <will@kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v2 39/42] example for future extension: mm:gup/writeback: add callbacks for inaccessible pages: error cases
Date:   Fri, 14 Feb 2020 17:26:55 -0500
Message-Id: <20200214222658.12946-40-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200214222658.12946-1-borntraeger@de.ibm.com>
References: <20200214222658.12946-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-14_08:2020-02-14,2020-02-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=942
 impostorscore=0 priorityscore=1501 spamscore=0 adultscore=0 mlxscore=0
 malwarescore=0 phishscore=0 clxscore=1015 lowpriorityscore=0
 suspectscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002140165
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Claudio Imbrenda <imbrenda@linux.ibm.com>

This is a potential extension to do error handling if we fail to
make the page accessible if we know what others need.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 mm/gup.c            | 17 ++++++++++++-----
 mm/page-writeback.c |  6 +++++-
 2 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index a1c15d029f7c..354bcfbd844b 100644
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
@@ -276,7 +274,12 @@ static struct page *follow_page_pte(struct vm_area_struct *vma,
 			page = ERR_PTR(-ENOMEM);
 			goto out;
 		}
-		arch_make_page_accessible(page);
+		ret = arch_make_page_accessible(page);
+		if (ret) {
+			put_page(page);
+			page = ERR_PTR(ret);
+			goto out;
+		}
 	}
 	if (flags & FOLL_TOUCH) {
 		if ((flags & FOLL_WRITE) &&
@@ -1920,7 +1923,11 @@ static int gup_pte_range(pmd_t pmd, unsigned long addr, unsigned long end,
 
 		VM_BUG_ON_PAGE(compound_head(page) != head, page);
 
-		arch_make_page_accessible(page);
+		ret = arch_make_page_accessible(page);
+		if (ret) {
+			put_page(head);
+			goto pte_unmap;
+		}
 		SetPageReferenced(page);
 		pages[*nr] = page;
 		(*nr)++;
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 4c020e4ae71c..558d7063c117 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2807,7 +2807,11 @@ int __test_set_page_writeback(struct page *page, bool keep_write)
 		inc_zone_page_state(page, NR_ZONE_WRITE_PENDING);
 	}
 	unlock_page_memcg(page);
-	arch_make_page_accessible(page);
+	/*
+	 * If writeback has been triggered on a page that cannot be made
+	 * accessible, it is too late.
+	 */
+	WARN_ON(arch_make_page_accessible(page));
 	return ret;
 
 }
-- 
2.25.0

