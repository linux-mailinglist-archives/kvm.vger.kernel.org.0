Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8F6E1376AA
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2020 20:07:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727709AbgAJTHK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jan 2020 14:07:10 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:54708 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727448AbgAJTHK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jan 2020 14:07:10 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00AJ489v101370;
        Fri, 10 Jan 2020 19:06:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=MhOBiFDMMT29+VAIydrH0CPWpq+g29L7+unCxWM/Z+4=;
 b=X1C81cDBcc6zBx6wUvH97zlln5XYqhJFsBOzb+NhMu64yTJ8Y8Ddy524aVvfH91E2Qwi
 EljaT9eUhxVKyGw4JjWxSb2yVC/mWh5WpPBjBUcU5l0qypsatrtNjo2B4bFLqkzAS4ZU
 //fove2KpjDxt5esFfPNHqMA0hYyEegwsYbmO3xnMXnnv3japqx+0vkuq4+PHVpY+jEP
 ORAuknMDIv/gMEQhR2dx4O/iyOVJNAtA6pHnGJSYJ7EhlkgPpyvtAUE1Gov3iuBwlMqO
 3A3dMgroQeS2mRnxqfGduppkRINZ/5FXuG1dYndFA0HqcQVNMwCYuN11vKw6EJkeJvSk fQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2xajnqm1kv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Jan 2020 19:06:48 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00AJ3rAK183505;
        Fri, 10 Jan 2020 19:04:48 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2xedhyptut-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Jan 2020 19:04:48 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00AJ4lHr021020;
        Fri, 10 Jan 2020 19:04:47 GMT
Received: from paddy.uk.oracle.com (/10.175.192.165)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 10 Jan 2020 11:04:47 -0800
From:   Joao Martins <joao.m.martins@oracle.com>
To:     linux-nvdimm@lists.01.org
Cc:     Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Ira Weiny <ira.weiny@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Liran Alon <liran.alon@oracle.com>,
        Nikita Leshenko <nikita.leshchenko@oracle.com>,
        Barret Rhoden <brho@google.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Matthew Wilcox <willy@infradead.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH RFC 02/10] mm: Handle pmd entries in follow_pfn()
Date:   Fri, 10 Jan 2020 19:03:05 +0000
Message-Id: <20200110190313.17144-3-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200110190313.17144-1-joao.m.martins@oracle.com>
References: <20200110190313.17144-1-joao.m.martins@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9496 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=518
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001100154
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9496 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=574 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001100154
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When follow_pfn hits a pmd_huge() it won't return a valid PFN
given it's usage of follow_pte(). Fix that up to pass a @pmdpp
and thus allow callers to get the pmd pointer. If we encounter
such a huge page, we calculate the pfn offset to the PMD
accordingly.

This allows KVM to handle 2M hugepage pfns on VM_PFNMAP vmas.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 mm/memory.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index cfc3668bddeb..db99684d2cb3 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4366,6 +4366,7 @@ EXPORT_SYMBOL(follow_pte_pmd);
 int follow_pfn(struct vm_area_struct *vma, unsigned long address,
 	unsigned long *pfn)
 {
+	pmd_t *pmdpp = NULL;
 	int ret = -EINVAL;
 	spinlock_t *ptl;
 	pte_t *ptep;
@@ -4373,10 +4374,14 @@ int follow_pfn(struct vm_area_struct *vma, unsigned long address,
 	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)))
 		return ret;
 
-	ret = follow_pte(vma->vm_mm, address, &ptep, &ptl);
+	ret = follow_pte_pmd(vma->vm_mm, address, NULL,
+			     &ptep, &pmdpp, &ptl);
 	if (ret)
 		return ret;
-	*pfn = pte_pfn(*ptep);
+	if (pmdpp)
+		*pfn = pmd_pfn(*pmdpp) + ((address & ~PMD_MASK) >> PAGE_SHIFT);
+	else
+		*pfn = pte_pfn(*ptep);
 	pte_unmap_unlock(ptep, ptl);
 	return 0;
 }
-- 
2.17.1

