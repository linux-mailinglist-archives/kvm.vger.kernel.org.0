Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDF87244BAB
	for <lists+kvm@lfdr.de>; Fri, 14 Aug 2020 17:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728337AbgHNPKX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Aug 2020 11:10:23 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:30718 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727850AbgHNPKT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Aug 2020 11:10:19 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07EF3V3k016284
        for <kvm@vger.kernel.org>; Fri, 14 Aug 2020 11:10:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=dUdHmWFUddAXcHGFwi5UlX6qA/V5LF8DgbKQj8Ll+Ec=;
 b=kAPWZWrsl3S0h9bhAn8e0Iy29/54ucDyvC2T0XHs/p/gQo6ODfoCFjAp4T3EzPJvqM4j
 tSbnedKcKjCYe0Df6uUeenfHPVvJkBiOI8SY0qa4MdjezuWRqCOcdzqMhVXPo9vfPUis
 VpGfmj3NCpN2nqK8t17ImgAAlyUzmWKmwssgczT8Yid2TxAQEuJkjq/k/hRUrOPvTkqP
 b6PkLEuoUbLEYJJJrO7MWK9u5hJlcvGON6ZyPjt3DtzyrZg4Q9HFG5Tei+F7yXFOazzJ
 kWuVpv10oW6dF2b9q11+Iu2pVlllZWWVbQvvGBnPEzDNrIWukvzPFxkvgU5gPuUFrioz Xw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32w24j7cvv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 14 Aug 2020 11:10:18 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 07EF3WMJ016309
        for <kvm@vger.kernel.org>; Fri, 14 Aug 2020 11:10:18 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32w24j7cu1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Aug 2020 11:10:18 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07EF27vC026841;
        Fri, 14 Aug 2020 15:10:15 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 32skaheras-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Aug 2020 15:10:15 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07EFAC8713238572
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Aug 2020 15:10:12 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AFD29A4053;
        Fri, 14 Aug 2020 15:10:12 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 484F1A4051;
        Fri, 14 Aug 2020 15:10:12 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.4.223])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 14 Aug 2020 15:10:12 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, lvivier@redhat.com
Subject: [kvm-unit-tests RFC v1 4/5] lib/alloc.h: remove align_min from struct alloc_ops
Date:   Fri, 14 Aug 2020 17:10:08 +0200
Message-Id: <20200814151009.55845-5-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200814151009.55845-1-imbrenda@linux.ibm.com>
References: <20200814151009.55845-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-14_09:2020-08-14,2020-08-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=878
 phishscore=0 lowpriorityscore=0 suspectscore=2 spamscore=0
 priorityscore=1501 impostorscore=0 malwarescore=0 clxscore=1015
 bulkscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008140114
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove align_min from struct alloc_ops.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 lib/alloc.h      | 1 -
 lib/alloc_page.c | 1 -
 lib/alloc_phys.c | 9 +++++----
 lib/vmalloc.c    | 1 -
 4 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/lib/alloc.h b/lib/alloc.h
index 9b4b634..db90b01 100644
--- a/lib/alloc.h
+++ b/lib/alloc.h
@@ -25,7 +25,6 @@
 struct alloc_ops {
 	void *(*memalign)(size_t alignment, size_t size);
 	void (*free)(void *ptr);
-	size_t align_min;
 };
 
 extern struct alloc_ops *alloc_ops;
diff --git a/lib/alloc_page.c b/lib/alloc_page.c
index 0e720ad..d3ade58 100644
--- a/lib/alloc_page.c
+++ b/lib/alloc_page.c
@@ -325,7 +325,6 @@ void *alloc_page()
 static struct alloc_ops page_alloc_ops = {
 	.memalign = memalign_pages,
 	.free = free_pages,
-	.align_min = PAGE_SIZE,
 };
 
 /*
diff --git a/lib/alloc_phys.c b/lib/alloc_phys.c
index 72e20f7..a4d2bf2 100644
--- a/lib/alloc_phys.c
+++ b/lib/alloc_phys.c
@@ -29,8 +29,8 @@ static phys_addr_t base, top;
 static void *early_memalign(size_t alignment, size_t size);
 static struct alloc_ops early_alloc_ops = {
 	.memalign = early_memalign,
-	.align_min = DEFAULT_MINIMUM_ALIGNMENT
 };
+static size_t align_min;
 
 struct alloc_ops *alloc_ops = &early_alloc_ops;
 
@@ -39,8 +39,7 @@ void phys_alloc_show(void)
 	int i;
 
 	spin_lock(&lock);
-	printf("phys_alloc minimum alignment: %#" PRIx64 "\n",
-		(u64)early_alloc_ops.align_min);
+	printf("phys_alloc minimum alignment: %#" PRIx64 "\n", (u64)align_min);
 	for (i = 0; i < nr_regions; ++i)
 		printf("%016" PRIx64 "-%016" PRIx64 " [%s]\n",
 			(u64)regions[i].base,
@@ -64,7 +63,7 @@ void phys_alloc_set_minimum_alignment(phys_addr_t align)
 {
 	assert(align && !(align & (align - 1)));
 	spin_lock(&lock);
-	early_alloc_ops.align_min = align;
+	align_min = align;
 	spin_unlock(&lock);
 }
 
@@ -83,6 +82,8 @@ static phys_addr_t phys_alloc_aligned_safe(phys_addr_t size,
 		top_safe = MIN(top_safe, 1ULL << 32);
 
 	assert(base < top_safe);
+	if (align < align_min)
+		align = align_min;
 
 	addr = ALIGN(base, align);
 	size += addr - base;
diff --git a/lib/vmalloc.c b/lib/vmalloc.c
index 55b7a74..bcb9bf5 100644
--- a/lib/vmalloc.c
+++ b/lib/vmalloc.c
@@ -188,7 +188,6 @@ static void vm_free(void *mem)
 static struct alloc_ops vmalloc_ops = {
 	.memalign = vm_memalign,
 	.free = vm_free,
-	.align_min = PAGE_SIZE,
 };
 
 void __attribute__((__weak__)) find_highmem(void)
-- 
2.26.2

