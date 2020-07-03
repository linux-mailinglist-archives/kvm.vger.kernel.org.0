Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73F0E21399A
	for <lists+kvm@lfdr.de>; Fri,  3 Jul 2020 13:51:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726236AbgGCLvU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jul 2020 07:51:20 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:5056 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726063AbgGCLvT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 3 Jul 2020 07:51:19 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 063BYXw4039310
        for <kvm@vger.kernel.org>; Fri, 3 Jul 2020 07:51:18 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 320yr6e2ff-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 03 Jul 2020 07:51:18 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 063Bl4Dk093500
        for <kvm@vger.kernel.org>; Fri, 3 Jul 2020 07:51:17 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 320yr6e2ev-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Jul 2020 07:51:17 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 063BojYZ001316;
        Fri, 3 Jul 2020 11:51:15 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 31wwch6s09-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Jul 2020 11:51:14 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 063BpCBN59572280
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 3 Jul 2020 11:51:12 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D2CE711C04C;
        Fri,  3 Jul 2020 11:51:12 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 774C511C058;
        Fri,  3 Jul 2020 11:51:12 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.9.164])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  3 Jul 2020 11:51:12 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     frankja@linux.ibm.com, thuth@redhat.com, david@redhat.com
Subject: [kvm-unit-tests PATCH v1 3/4] lib/alloc_page: move get_order and is_power_of_2 to a bitops.h
Date:   Fri,  3 Jul 2020 13:51:08 +0200
Message-Id: <20200703115109.39139-4-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200703115109.39139-1-imbrenda@linux.ibm.com>
References: <20200703115109.39139-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-03_06:2020-07-02,2020-07-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 cotscore=-2147483648 clxscore=1015 spamscore=0 suspectscore=2 adultscore=0
 phishscore=0 mlxlogscore=946 priorityscore=1501 bulkscore=0
 impostorscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2007030078
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The functions get_order and is_power_of_2 are simple and should
probably be in a header, like similar simple functions in bitops.h

Since they concern bit manipulation, the logical place for them is in
bitops.h

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
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

