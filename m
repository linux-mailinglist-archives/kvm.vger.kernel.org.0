Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9C582F79EA
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 13:44:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388163AbhAOMiZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 07:38:25 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:56396 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388156AbhAOMiY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 Jan 2021 07:38:24 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10FCXL9q064925;
        Fri, 15 Jan 2021 07:37:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=tNB5DOg1+LA2S8QenBB0AS6ag93/IuE9xib+YRp3LaQ=;
 b=K5Zpkz9HJp/SQj20QKnw4H27mM58rx2236C+63hCrBSF26PHrYq21bLceLIynyd/Welc
 9zMm4wJNo43lypSLa++A6gAaMIDq4OkkVeKc2lHqSt0kPfD00caoZoVVGtH0HH3jVKRq
 svp2zHDsI2/Sw29/N+X83ot2MJpZDphpPNJrYxhY1qCPGyyW0swqc3nX7o4VYsxIWOaX
 x8B9Se4dlS6bs5CUgrQekRfcJGb9P8B0SlSixpxMfjs9OTQ/7H69M594bEOd7YlwRocm
 F/XIFlvZbcqWBh9UsspoIz2GIIlEIFinCtbHoZ8pzZpTPuPwmMFdspO1QG3KZ2m3Nmfs pg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 363akfh8h6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 Jan 2021 07:37:40 -0500
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10FCXPkt065313;
        Fri, 15 Jan 2021 07:37:40 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 363akfh8fv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 Jan 2021 07:37:40 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10FC8Cmr014079;
        Fri, 15 Jan 2021 12:37:37 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 35ydrdf9nj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 Jan 2021 12:37:37 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10FCbZpc39780772
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Jan 2021 12:37:35 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 72B3DAE056;
        Fri, 15 Jan 2021 12:37:35 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0880BAE051;
        Fri, 15 Jan 2021 12:37:35 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.4.167])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 15 Jan 2021 12:37:34 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        pbonzini@redhat.com, cohuck@redhat.com, lvivier@redhat.com,
        nadav.amit@gmail.com, krish.sadhukhan@oracle.com
Subject: [kvm-unit-tests PATCH v2 07/11] lib/alloc_page: Optimization to skip known empty freelists
Date:   Fri, 15 Jan 2021 13:37:26 +0100
Message-Id: <20210115123730.381612-8-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210115123730.381612-1-imbrenda@linux.ibm.com>
References: <20210115123730.381612-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-15_07:2021-01-15,2021-01-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 suspectscore=0
 priorityscore=1501 impostorscore=0 lowpriorityscore=0 phishscore=0
 mlxscore=0 malwarescore=0 clxscore=1015 adultscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101150077
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Keep track of the largest block order available in each area, and do not
search past it when looking for free memory.

This will avoid needlessly scanning the freelists for the largest block
orders, which will be empty in most cases.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 lib/alloc_page.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/lib/alloc_page.c b/lib/alloc_page.c
index 7d1fa85..37f28ce 100644
--- a/lib/alloc_page.c
+++ b/lib/alloc_page.c
@@ -31,6 +31,8 @@ struct mem_area {
 	pfn_t top;
 	/* Per page metadata, each entry is a combination *_MASK and order */
 	u8 *page_states;
+	/* Highest block order available in this area */
+	u8 max_order;
 	/* One freelist for each possible block size, up to NLISTS */
 	struct linked_list freelists[NLISTS];
 };
@@ -104,6 +106,8 @@ static void split(struct mem_area *a, void *addr)
 		assert(a->page_states[idx + i] == order);
 		a->page_states[idx + i] = order - 1;
 	}
+	if ((order == a->max_order) && (is_list_empty(a->freelists + order)))
+		a->max_order--;
 	order--;
 	/* add the first half block to the appropriate free list */
 	list_add(a->freelists + order, addr);
@@ -127,13 +131,13 @@ static void *page_memalign_order(struct mem_area *a, u8 al, u8 sz)
 	order = sz > al ? sz : al;
 
 	/* search all free lists for some memory */
-	for ( ; order < NLISTS; order++) {
+	for ( ; order <= a->max_order; order++) {
 		p = a->freelists[order].next;
 		if (!is_list_empty(p))
 			break;
 	}
 	/* out of memory */
-	if (order >= NLISTS)
+	if (order > a->max_order)
 		return NULL;
 
 	/*
@@ -201,6 +205,8 @@ static bool coalesce(struct mem_area *a, u8 order, pfn_t pfn, pfn_t pfn2)
 	}
 	/* finally add the newly coalesced block to the appropriate freelist */
 	list_add(a->freelists + order + 1, pfn_to_virt(pfn));
+	if (order + 1 > a->max_order)
+		a->max_order = order + 1;
 	return true;
 }
 
@@ -438,6 +444,7 @@ static void _page_alloc_init_area(u8 n, pfn_t start_pfn, pfn_t top_pfn)
 	a->page_states = pfn_to_virt(start_pfn);
 	a->base = start_pfn + table_size;
 	a->top = top_pfn;
+	a->max_order = 0;
 	npages = top_pfn - a->base;
 	assert((a->base - start_pfn) * PAGE_SIZE >= npages);
 
@@ -472,6 +479,8 @@ static void _page_alloc_init_area(u8 n, pfn_t start_pfn, pfn_t top_pfn)
 		/* initialize the metadata and add to the freelist */
 		memset(a->page_states + (i - a->base), order, BIT(order));
 		list_add(a->freelists + order, pfn_to_virt(i));
+		if (order > a->max_order)
+			a->max_order = order;
 	}
 	/* finally mark the area as present */
 	areas_mask |= BIT(n);
-- 
2.26.2

