Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 676C0215C19
	for <lists+kvm@lfdr.de>; Mon,  6 Jul 2020 18:43:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729692AbgGFQne (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jul 2020 12:43:34 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:6646 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729553AbgGFQnd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 6 Jul 2020 12:43:33 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 066GXPww126088
        for <kvm@vger.kernel.org>; Mon, 6 Jul 2020 12:43:32 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3247j48eh8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 06 Jul 2020 12:43:32 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 066GXWLE126824
        for <kvm@vger.kernel.org>; Mon, 6 Jul 2020 12:43:31 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3247j48eg5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Jul 2020 12:43:31 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 066GOa4E008328;
        Mon, 6 Jul 2020 16:43:28 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma05fra.de.ibm.com with ESMTP id 322hd81920-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Jul 2020 16:43:28 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 066GhQcM63897894
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 6 Jul 2020 16:43:26 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 842AA11C04A;
        Mon,  6 Jul 2020 16:43:26 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1CC2211C04C;
        Mon,  6 Jul 2020 16:43:26 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.9.164])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  6 Jul 2020 16:43:26 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     frankja@linux.ibm.com, thuth@redhat.com, david@redhat.com,
        drjones@redhat.com
Subject: [kvm-unit-tests PATCH v2 3/4] lib/alloc_page: move get_order and is_power_of_2 to a bitops.h
Date:   Mon,  6 Jul 2020 18:43:23 +0200
Message-Id: <20200706164324.81123-4-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200706164324.81123-1-imbrenda@linux.ibm.com>
References: <20200706164324.81123-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-06_15:2020-07-06,2020-07-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1015
 impostorscore=0 priorityscore=1501 malwarescore=0 suspectscore=2
 mlxlogscore=999 cotscore=-2147483648 spamscore=0 phishscore=0 bulkscore=0
 adultscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2007060120
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The functions get_order and is_power_of_2 are simple and should
probably be in a header, like similar simple functions in bitops.h

Since they concern bit manipulation, the logical place for them is in
bitops.h

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
---
 lib/alloc_page.h |  1 -
 lib/bitops.h     | 10 ++++++++++
 lib/libcflat.h   |  5 -----
 lib/alloc.c      |  1 +
 lib/alloc_page.c |  5 -----
 5 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/lib/alloc_page.h b/lib/alloc_page.h
index d9aceb7..88540d1 100644
--- a/lib/alloc_page.h
+++ b/lib/alloc_page.h
@@ -15,6 +15,5 @@ void *alloc_pages(unsigned int order);
 void free_page(void *page);
 void free_pages(void *mem, size_t size);
 void free_pages_by_order(void *mem, unsigned int order);
-unsigned int get_order(size_t size);
 
 #endif
diff --git a/lib/bitops.h b/lib/bitops.h
index b310a22..308aa86 100644
--- a/lib/bitops.h
+++ b/lib/bitops.h
@@ -74,4 +74,14 @@ static inline unsigned long fls(unsigned long word)
 }
 #endif
 
+static inline bool is_power_of_2(unsigned long n)
+{
+	return n && !(n & (n - 1));
+}
+
+static inline unsigned int get_order(size_t size)
+{
+	return size ? fls(size) + !is_power_of_2(size) : 0;
+}
+
 #endif
diff --git a/lib/libcflat.h b/lib/libcflat.h
index 7092af2..ec0f58b 100644
--- a/lib/libcflat.h
+++ b/lib/libcflat.h
@@ -147,11 +147,6 @@ do {									\
 	}								\
 } while (0)
 
-static inline bool is_power_of_2(unsigned long n)
-{
-	return n && !(n & (n - 1));
-}
-
 /*
  * One byte per bit, a ' between each group of 4 bits, and a null terminator.
  */
diff --git a/lib/alloc.c b/lib/alloc.c
index 6c89f98..9d89d24 100644
--- a/lib/alloc.c
+++ b/lib/alloc.c
@@ -1,4 +1,5 @@
 #include "alloc.h"
+#include "bitops.h"
 #include "asm/page.h"
 #include "bitops.h"
 
diff --git a/lib/alloc_page.c b/lib/alloc_page.c
index f16eaad..fa3c527 100644
--- a/lib/alloc_page.c
+++ b/lib/alloc_page.c
@@ -175,8 +175,3 @@ void page_alloc_ops_enable(void)
 {
 	alloc_ops = &page_alloc_ops;
 }
-
-unsigned int get_order(size_t size)
-{
-	return is_power_of_2(size) ? fls(size) : fls(size) + 1;
-}
-- 
2.26.2

