Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A5202F79D0
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 13:42:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732923AbhAOMlJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 07:41:09 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:64060 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387497AbhAOMkX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 Jan 2021 07:40:23 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10FCXLxD064885;
        Fri, 15 Jan 2021 07:37:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=U+ku+qamBIPAaG7KR7o0+FylIBPOLGdubc5b6jJ22EM=;
 b=MDQSHMixnVDdgQrUrnbI34ThsLlfnf9bO4zuKkfr8SQLRdpa+nDIUwxIMHPym9kVRpGR
 AU/+cgsGaMITdV1/arQRdo/jiia+tLWqZB0nTrlZ3KpLitYt1Ev3FLSTKOCN6RQbBejQ
 QbRCOT5/qlVd9AW+frQbt1mOK9BpxscqJ/DDpIEj7l5QGZAOCh56sPI/SwF/VkKX6YId
 sVyqK7GWFtTb7Cr79NQtCTTjxjXFmuso3fFv9JOxpJ9ihQg3QLa5NJs39IsRdC4idNyX
 LOrbnM1mjKNvw5HPt7JgAB5QqsagMJHBeQIaKzbEjuKEsIHctq69AsgVGCzx01Jpgp9/ +w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 363akfh8g1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 Jan 2021 07:37:39 -0500
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10FCXoUd066830;
        Fri, 15 Jan 2021 07:37:38 -0500
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 363akfh8f4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 Jan 2021 07:37:38 -0500
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10FCbaac026135;
        Fri, 15 Jan 2021 12:37:36 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma05fra.de.ibm.com with ESMTP id 35y448byvv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 Jan 2021 12:37:36 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10FCbX4142664270
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Jan 2021 12:37:34 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C83E6AE053;
        Fri, 15 Jan 2021 12:37:33 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 61B46AE045;
        Fri, 15 Jan 2021 12:37:33 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.4.167])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 15 Jan 2021 12:37:33 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        pbonzini@redhat.com, cohuck@redhat.com, lvivier@redhat.com,
        nadav.amit@gmail.com, krish.sadhukhan@oracle.com
Subject: [kvm-unit-tests PATCH v2 04/11] lib/asm: Fix definitions of memory areas
Date:   Fri, 15 Jan 2021 13:37:23 +0100
Message-Id: <20210115123730.381612-5-imbrenda@linux.ibm.com>
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

Fix the definitions of the memory areas.

Bring the headers in line with the rest of the asm headers, by having the
appropriate #ifdef _ASM$ARCH_ guarding the headers.

Fixes: d74708246bd9 ("lib/asm: Add definitions of memory areas")

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 lib/asm-generic/memory_areas.h |  9 ++++-----
 lib/arm/asm/memory_areas.h     | 11 +++--------
 lib/arm64/asm/memory_areas.h   | 11 +++--------
 lib/powerpc/asm/memory_areas.h | 11 +++--------
 lib/ppc64/asm/memory_areas.h   | 11 +++--------
 lib/s390x/asm/memory_areas.h   | 13 ++++++-------
 lib/x86/asm/memory_areas.h     | 27 ++++++++++++++++-----------
 lib/alloc_page.h               |  3 +++
 lib/alloc_page.c               |  4 +---
 9 files changed, 42 insertions(+), 58 deletions(-)

diff --git a/lib/asm-generic/memory_areas.h b/lib/asm-generic/memory_areas.h
index 927baa7..3074afe 100644
--- a/lib/asm-generic/memory_areas.h
+++ b/lib/asm-generic/memory_areas.h
@@ -1,11 +1,10 @@
-#ifndef MEMORY_AREAS_H
-#define MEMORY_AREAS_H
+#ifndef __ASM_GENERIC_MEMORY_AREAS_H__
+#define __ASM_GENERIC_MEMORY_AREAS_H__
 
 #define AREA_NORMAL_PFN 0
 #define AREA_NORMAL_NUMBER 0
-#define AREA_NORMAL 1
+#define AREA_NORMAL (1 << AREA_NORMAL_NUMBER)
 
-#define AREA_ANY -1
-#define AREA_ANY_NUMBER 0xff
+#define MAX_AREAS 1
 
 #endif
diff --git a/lib/arm/asm/memory_areas.h b/lib/arm/asm/memory_areas.h
index 927baa7..c723310 100644
--- a/lib/arm/asm/memory_areas.h
+++ b/lib/arm/asm/memory_areas.h
@@ -1,11 +1,6 @@
-#ifndef MEMORY_AREAS_H
-#define MEMORY_AREAS_H
+#ifndef _ASMARM_MEMORY_AREAS_H_
+#define _ASMARM_MEMORY_AREAS_H_
 
-#define AREA_NORMAL_PFN 0
-#define AREA_NORMAL_NUMBER 0
-#define AREA_NORMAL 1
-
-#define AREA_ANY -1
-#define AREA_ANY_NUMBER 0xff
+#include <asm-generic/memory_areas.h>
 
 #endif
diff --git a/lib/arm64/asm/memory_areas.h b/lib/arm64/asm/memory_areas.h
index 927baa7..18e8ca8 100644
--- a/lib/arm64/asm/memory_areas.h
+++ b/lib/arm64/asm/memory_areas.h
@@ -1,11 +1,6 @@
-#ifndef MEMORY_AREAS_H
-#define MEMORY_AREAS_H
+#ifndef _ASMARM64_MEMORY_AREAS_H_
+#define _ASMARM64_MEMORY_AREAS_H_
 
-#define AREA_NORMAL_PFN 0
-#define AREA_NORMAL_NUMBER 0
-#define AREA_NORMAL 1
-
-#define AREA_ANY -1
-#define AREA_ANY_NUMBER 0xff
+#include <asm-generic/memory_areas.h>
 
 #endif
diff --git a/lib/powerpc/asm/memory_areas.h b/lib/powerpc/asm/memory_areas.h
index 927baa7..76d1738 100644
--- a/lib/powerpc/asm/memory_areas.h
+++ b/lib/powerpc/asm/memory_areas.h
@@ -1,11 +1,6 @@
-#ifndef MEMORY_AREAS_H
-#define MEMORY_AREAS_H
+#ifndef _ASMPOWERPC_MEMORY_AREAS_H_
+#define _ASMPOWERPC_MEMORY_AREAS_H_
 
-#define AREA_NORMAL_PFN 0
-#define AREA_NORMAL_NUMBER 0
-#define AREA_NORMAL 1
-
-#define AREA_ANY -1
-#define AREA_ANY_NUMBER 0xff
+#include <asm-generic/memory_areas.h>
 
 #endif
diff --git a/lib/ppc64/asm/memory_areas.h b/lib/ppc64/asm/memory_areas.h
index 927baa7..b9fd46b 100644
--- a/lib/ppc64/asm/memory_areas.h
+++ b/lib/ppc64/asm/memory_areas.h
@@ -1,11 +1,6 @@
-#ifndef MEMORY_AREAS_H
-#define MEMORY_AREAS_H
+#ifndef _ASMPPC64_MEMORY_AREAS_H_
+#define _ASMPPC64_MEMORY_AREAS_H_
 
-#define AREA_NORMAL_PFN 0
-#define AREA_NORMAL_NUMBER 0
-#define AREA_NORMAL 1
-
-#define AREA_ANY -1
-#define AREA_ANY_NUMBER 0xff
+#include <asm-generic/memory_areas.h>
 
 #endif
diff --git a/lib/s390x/asm/memory_areas.h b/lib/s390x/asm/memory_areas.h
index 4856a27..827bfb3 100644
--- a/lib/s390x/asm/memory_areas.h
+++ b/lib/s390x/asm/memory_areas.h
@@ -1,16 +1,15 @@
-#ifndef MEMORY_AREAS_H
-#define MEMORY_AREAS_H
+#ifndef _ASMS390X_MEMORY_AREAS_H_
+#define _ASMS390X_MEMORY_AREAS_H_
 
-#define AREA_NORMAL_PFN BIT(31-12)
+#define AREA_NORMAL_PFN (1 << 19)
 #define AREA_NORMAL_NUMBER 0
-#define AREA_NORMAL 1
+#define AREA_NORMAL (1 << AREA_NORMAL_NUMBER)
 
 #define AREA_LOW_PFN 0
 #define AREA_LOW_NUMBER 1
-#define AREA_LOW 2
+#define AREA_LOW (1 << AREA_LOW_NUMBER)
 
-#define AREA_ANY -1
-#define AREA_ANY_NUMBER 0xff
+#define MAX_AREAS 2
 
 #define AREA_DMA31 AREA_LOW
 
diff --git a/lib/x86/asm/memory_areas.h b/lib/x86/asm/memory_areas.h
index 952f5bd..e84016f 100644
--- a/lib/x86/asm/memory_areas.h
+++ b/lib/x86/asm/memory_areas.h
@@ -1,21 +1,26 @@
-#ifndef MEMORY_AREAS_H
-#define MEMORY_AREAS_H
+#ifndef _ASM_X86_MEMORY_AREAS_H_
+#define _ASM_X86_MEMORY_AREAS_H_
 
 #define AREA_NORMAL_PFN BIT(36-12)
 #define AREA_NORMAL_NUMBER 0
-#define AREA_NORMAL 1
+#define AREA_NORMAL (1 << AREA_NORMAL_NUMBER)
 
-#define AREA_PAE_HIGH_PFN BIT(32-12)
-#define AREA_PAE_HIGH_NUMBER 1
-#define AREA_PAE_HIGH 2
+#define AREA_HIGH_PFN BIT(32-12)
+#define AREA_HIGH_NUMBER 1
+#define AREA_HIGH (1 << AREA_HIGH_NUMBER)
 
-#define AREA_LOW_PFN 0
+#define AREA_LOW_PFN BIT(24-12)
 #define AREA_LOW_NUMBER 2
-#define AREA_LOW 4
+#define AREA_LOW (1 << AREA_LOW_NUMBER)
 
-#define AREA_PAE (AREA_PAE | AREA_LOW)
+#define AREA_LOWEST_PFN 0
+#define AREA_LOWEST_NUMBER 3
+#define AREA_LOWEST (1 << AREA_LOWEST_NUMBER)
 
-#define AREA_ANY -1
-#define AREA_ANY_NUMBER 0xff
+#define MAX_AREAS 4
+
+#define AREA_DMA24 AREA_LOWEST
+#define AREA_DMA32 (AREA_LOWEST | AREA_LOW)
+#define AREA_PAE36 (AREA_LOWEST | AREA_LOW | AREA_HIGH)
 
 #endif
diff --git a/lib/alloc_page.h b/lib/alloc_page.h
index 816ff5d..b6aace5 100644
--- a/lib/alloc_page.h
+++ b/lib/alloc_page.h
@@ -10,6 +10,9 @@
 
 #include <asm/memory_areas.h>
 
+#define AREA_ANY -1
+#define AREA_ANY_NUMBER 0xff
+
 /* Returns true if the page allocator has been initialized */
 bool page_alloc_initialized(void);
 
diff --git a/lib/alloc_page.c b/lib/alloc_page.c
index 685ab1e..ed0ff02 100644
--- a/lib/alloc_page.c
+++ b/lib/alloc_page.c
@@ -19,8 +19,6 @@
 #define NLISTS ((BITS_PER_LONG) - (PAGE_SHIFT))
 #define PFN(x) ((uintptr_t)(x) >> PAGE_SHIFT)
 
-#define MAX_AREAS	6
-
 #define ORDER_MASK	0x3f
 #define ALLOC_MASK	0x40
 #define SPECIAL_MASK	0x80
@@ -509,7 +507,7 @@ void page_alloc_init_area(u8 n, uintptr_t base_pfn, uintptr_t top_pfn)
 		return;
 	}
 #ifdef AREA_HIGH_PFN
-	__page_alloc_init_area(AREA_HIGH_NUMBER, AREA_HIGH_PFN), base_pfn, &top_pfn);
+	__page_alloc_init_area(AREA_HIGH_NUMBER, AREA_HIGH_PFN, base_pfn, &top_pfn);
 #endif
 	__page_alloc_init_area(AREA_NORMAL_NUMBER, AREA_NORMAL_PFN, base_pfn, &top_pfn);
 #ifdef AREA_LOW_PFN
-- 
2.26.2

