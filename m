Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 004E92FE98D
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 13:02:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730616AbhAUMCK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jan 2021 07:02:10 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:20206 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728218AbhAULTQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Jan 2021 06:19:16 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10LB2Bp6085099;
        Thu, 21 Jan 2021 06:18:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=kQyHjz/G9CDjM2bVCv5AXxuqpPGa1wPvklE7QzVEDEI=;
 b=M4ouzfSn5hX4v4vTclTGzB4EOF/Zt4TSvLjqvfrcykDs4KbDH81Q+su+RbMoUxJg0Ml5
 ZD1Vfkej/QNRsDsLCeCKqze12LBQshgrfW9TR50e3U8P76n2PuHOgs/z8uNqUwtga29Z
 pTgeHGTssZzWGVlL3PPnrh48nn3ygrbFFwJldnHRakvMxveuTUMGMZ7aAnsDj6tZLX7E
 Yg/pCmAHSwshDX2uD0/Uq66QnCK2RVHDKpZazJrs8ZZpjUVDWSQq2kO5JYs8RNKpbdcN
 d4FwAbBTAqGXp6zIOyAtQuK0ytVMphNSHtFL56sm6E+IEoL45P7d4nFRCV1LDYZC/VF/ Jg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3678ba8j3q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jan 2021 06:18:31 -0500
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10LB2RMF087302;
        Thu, 21 Jan 2021 06:18:31 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3678ba8j2e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jan 2021 06:18:31 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10LBI5Ad016168;
        Thu, 21 Jan 2021 11:18:29 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 3668pask57-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jan 2021 11:18:28 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10LBIK8B29294854
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jan 2021 11:18:20 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9D879AE051;
        Thu, 21 Jan 2021 11:18:26 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 21649AE058;
        Thu, 21 Jan 2021 11:18:26 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.4.167])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 21 Jan 2021 11:18:26 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, david@redhat.com, thuth@redhat.com,
        frankja@linux.ibm.com, cohuck@redhat.com, lvivier@redhat.com,
        nadav.amit@gmail.com, krish.sadhukhan@oracle.com,
        dmatlack@google.com, seanjc@google.com
Subject: [kvm-unit-tests PATCH v1 1/2] x86: smap: fix the test to work with new allocator
Date:   Thu, 21 Jan 2021 12:18:07 +0100
Message-Id: <20210121111808.619347-2-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210121111808.619347-1-imbrenda@linux.ibm.com>
References: <20210121111808.619347-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-21_04:2021-01-21,2021-01-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 impostorscore=0 adultscore=0 malwarescore=0
 mlxlogscore=999 spamscore=0 bulkscore=0 suspectscore=0 mlxscore=0
 clxscore=1015 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2101210056
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The test used to simply take a chunk of memory and use it, hoping the
memory allocator would never touch it. The memory area used was exactly
at the beginning of the 16M boundary.

The new allocator stores metadata information there, and causes the
test to fail.

This patch uses the new features of the allocator to properly reserve
a memory block. To make things easier and cleaner, the memory area used
is now smaller and starts at 8M.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reported-by: David Matlack <dmatlack@google.com>
---
 x86/smap.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/x86/smap.c b/x86/smap.c
index 5782c4a..ac2c8d5 100644
--- a/x86/smap.c
+++ b/x86/smap.c
@@ -1,4 +1,5 @@
 #include "libcflat.h"
+#include <alloc_page.h>
 #include "x86/desc.h"
 #include "x86/processor.h"
 #include "x86/vm.h"
@@ -44,7 +45,7 @@ asm ("pf_tss:\n"
         "jmp pf_tss\n\t");
 
 
-#define USER_BASE	(1 << 24)
+#define USER_BASE	(1 << 23)
 #define USER_VAR(v)	(*((__typeof__(&(v))) (((unsigned long)&v) + USER_BASE)))
 #define USER_ADDR(v)   ((void *)((unsigned long)(&v) + USER_BASE))
 
@@ -101,13 +102,15 @@ int main(int ac, char **av)
 	setup_alt_stack();
 	set_intr_alt_stack(14, pf_tss);
 
-	// Map first 16MB as supervisor pages
+	if (reserve_pages(USER_BASE, USER_BASE >> 12))
+		report_abort("Could not reserve memory");
+	// Map first 8MB as supervisor pages
 	for (i = 0; i < USER_BASE; i += PAGE_SIZE) {
 		*get_pte(phys_to_virt(read_cr3()), phys_to_virt(i)) &= ~PT_USER_MASK;
 		invlpg((void *)i);
 	}
 
-	// Present the same 16MB as user pages in the 16MB-32MB range
+	// Present the same 8MB as user pages in the 8MB-16MB range
 	for (i = USER_BASE; i < 2 * USER_BASE; i += PAGE_SIZE) {
 		*get_pte(phys_to_virt(read_cr3()), phys_to_virt(i)) &= ~USER_BASE;
 		invlpg((void *)i);
-- 
2.26.2

