Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24A9915F99C
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2020 23:28:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728190AbgBNW1s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Feb 2020 17:27:48 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:62606 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728187AbgBNW1r (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Feb 2020 17:27:47 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01EMP19d004936;
        Fri, 14 Feb 2020 17:27:44 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y5g8cchmd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Feb 2020 17:27:43 -0500
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 01EMPNm4006033;
        Fri, 14 Feb 2020 17:27:43 -0500
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y5g8cchk8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Feb 2020 17:27:42 -0500
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 01EMP6Ha015199;
        Fri, 14 Feb 2020 22:27:41 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma01wdc.us.ibm.com with ESMTP id 2y5bc01xjb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Feb 2020 22:27:41 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01EMRcFL58982806
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Feb 2020 22:27:38 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5E0E1136096;
        Fri, 14 Feb 2020 22:27:38 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 62341136091;
        Fri, 14 Feb 2020 22:27:37 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.114.17.106])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 14 Feb 2020 22:27:37 +0000 (GMT)
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
Subject: [PATCH v2 40/42] example for future extension: mm:gup/writeback: add callbacks for inaccessible pages: source indication
Date:   Fri, 14 Feb 2020 17:26:56 -0500
Message-Id: <20200214222658.12946-41-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200214222658.12946-1-borntraeger@de.ibm.com>
References: <20200214222658.12946-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-14_08:2020-02-14,2020-02-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=2 clxscore=1015
 mlxlogscore=999 lowpriorityscore=0 phishscore=0 priorityscore=1501
 mlxscore=0 spamscore=0 bulkscore=0 adultscore=0 impostorscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002140165
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Claudio Imbrenda <imbrenda@linux.ibm.com>

We might want to do different things depending on where we are coming
from.

Cc: Will Deacon <will@kernel.org>
Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
[borntraeger@de.ibm.com: patch description]
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 include/linux/gfp.h | 8 +++++++-
 mm/gup.c            | 4 ++--
 mm/page-writeback.c | 2 +-
 3 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index be2754841369..a15fcb361e7c 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -485,8 +485,14 @@ static inline void arch_free_page(struct page *page, int order) { }
 #ifndef HAVE_ARCH_ALLOC_PAGE
 static inline void arch_alloc_page(struct page *page, int order) { }
 #endif
+enum access_type {
+	MAKE_ACCESSIBLE_GENERIC,
+	MAKE_ACCESSIBLE_GET,
+	MAKE_ACCESSIBLE_GET_FAST,
+	MAKE_ACCESSIBLE_WRITEBACK
+};
 #ifndef HAVE_ARCH_MAKE_PAGE_ACCESSIBLE
-static inline int arch_make_page_accessible(struct page *page)
+static inline int arch_make_page_accessible(struct page *page, int where)
 {
 	return 0;
 }
diff --git a/mm/gup.c b/mm/gup.c
index 354bcfbd844b..ce962c155724 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -274,7 +274,7 @@ static struct page *follow_page_pte(struct vm_area_struct *vma,
 			page = ERR_PTR(-ENOMEM);
 			goto out;
 		}
-		ret = arch_make_page_accessible(page);
+		ret = arch_make_page_accessible(page, MAKE_ACCESSIBLE_GET);
 		if (ret) {
 			put_page(page);
 			page = ERR_PTR(ret);
@@ -1923,7 +1923,7 @@ static int gup_pte_range(pmd_t pmd, unsigned long addr, unsigned long end,
 
 		VM_BUG_ON_PAGE(compound_head(page) != head, page);
 
-		ret = arch_make_page_accessible(page);
+		ret = arch_make_page_accessible(page, MAKE_ACCESSIBLE_GET_FAST);
 		if (ret) {
 			put_page(head);
 			goto pte_unmap;
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 558d7063c117..f85148e59800 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2811,7 +2811,7 @@ int __test_set_page_writeback(struct page *page, bool keep_write)
 	 * If writeback has been triggered on a page that cannot be made
 	 * accessible, it is too late.
 	 */
-	WARN_ON(arch_make_page_accessible(page));
+	WARN_ON(arch_make_page_accessible(page, MAKE_ACCESSIBLE_WRITEBACK));
 	return ret;
 
 }
-- 
2.25.0

