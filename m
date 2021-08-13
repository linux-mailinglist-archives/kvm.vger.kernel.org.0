Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3796A3EB198
	for <lists+kvm@lfdr.de>; Fri, 13 Aug 2021 09:38:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239506AbhHMHiD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Aug 2021 03:38:03 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:45558 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239498AbhHMHiC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 13 Aug 2021 03:38:02 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17D7ZL1o022910;
        Fri, 13 Aug 2021 03:37:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=6wsSJUpFw8hagatPWCSSpQjiNM5xmlAXezXDQEdcvMA=;
 b=jf2JOKZPLv0lp8TABSTDuut1d4tvXsELaLgzdSEURj89kIjWJVs710BJmRfIrX3FLw6U
 sSMild+tvW3txnEWtT0oFTfRDkn+Dw88dXmjfv8qvQoyG5pspJpQm8suA4UIqdpSnGzp
 yavq/BuanQYiVkrsAFkVsKPMhbWRrJUPiqyf1PYOyYp/3Eq8XZtt8QlwDL2hIl6Zuu0R
 rIzCZdwaQs1VyeKwUC4eKc3RUh9AtUiN8DddOCCjkIJ2vqi0VERg+0es9SK/FcudOSvw
 lN/4QNBlEHusfJ6Pe3hhX0WavobPXXOr1a0NtKSLUmcgWpQbhNx/PIn3kmrnlk7FjZvq jQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3accugkr18-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Aug 2021 03:37:36 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17D7ZNIC023175;
        Fri, 13 Aug 2021 03:37:35 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3accugkr0a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Aug 2021 03:37:35 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17D7MnKp024987;
        Fri, 13 Aug 2021 07:37:33 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 3ad4kqh5h2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Aug 2021 07:37:33 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17D7bUE354854100
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Aug 2021 07:37:30 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A898342052;
        Fri, 13 Aug 2021 07:37:30 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5D1DE4203F;
        Fri, 13 Aug 2021 07:37:30 +0000 (GMT)
Received: from t46lp67.lnxne.boe (unknown [9.152.108.100])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 13 Aug 2021 07:37:30 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH 1/8] s390x: lib: Extend bitops
Date:   Fri, 13 Aug 2021 07:36:08 +0000
Message-Id: <20210813073615.32837-2-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210813073615.32837-1-frankja@linux.ibm.com>
References: <20210813073615.32837-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ZXhHsFOb40ANnis52xofg0GZkUV_A__O
X-Proofpoint-ORIG-GUID: rdNfxx_hugVG-8gPg7ybge2MszAMt5Ai
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-13_01:2021-08-12,2021-08-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 spamscore=0 mlxlogscore=999 clxscore=1015 impostorscore=0
 bulkscore=0 priorityscore=1501 malwarescore=0 mlxscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108130044
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Bit setting and clearing is never bad to have.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/asm/bitops.h | 102 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 102 insertions(+)

diff --git a/lib/s390x/asm/bitops.h b/lib/s390x/asm/bitops.h
index 792881ec..f5612855 100644
--- a/lib/s390x/asm/bitops.h
+++ b/lib/s390x/asm/bitops.h
@@ -17,6 +17,78 @@
 
 #define BITS_PER_LONG	64
 
+static inline unsigned long *bitops_word(unsigned long nr,
+					 const volatile unsigned long *ptr)
+{
+	unsigned long addr;
+
+	addr = (unsigned long)ptr + ((nr ^ (nr & (BITS_PER_LONG - 1))) >> 3);
+	return (unsigned long *)addr;
+}
+
+static inline unsigned long bitops_mask(unsigned long nr)
+{
+	return 1UL << (nr & (BITS_PER_LONG - 1));
+}
+
+static inline uint64_t laog(volatile unsigned long *ptr, uint64_t mask)
+{
+	uint64_t old;
+
+	/* load and or 64bit concurrent and interlocked */
+	asm volatile(
+		"	laog	%[old],%[mask],%[ptr]\n"
+		: [old] "=d" (old), [ptr] "+Q" (*ptr)
+		: [mask] "d" (mask)
+		: "memory", "cc" );
+	return old;
+}
+
+static inline uint64_t lang(volatile unsigned long *ptr, uint64_t mask)
+{
+	uint64_t old;
+
+	/* load and and 64bit concurrent and interlocked */
+	asm volatile(
+		"	lang	%[old],%[mask],%[ptr]\n"
+		: [old] "=d" (old), [ptr] "+Q" (*ptr)
+		: [mask] "d" (mask)
+		: "memory", "cc" );
+	return old;
+}
+
+static inline void set_bit(unsigned long nr,
+			   const volatile unsigned long *ptr)
+{
+	uint64_t mask = bitops_mask(nr);
+	uint64_t *addr = bitops_word(nr, ptr);
+
+	laog(addr, mask);
+}
+
+static inline void set_bit_inv(unsigned long nr,
+			       const volatile unsigned long *ptr)
+{
+	return set_bit(nr ^ (BITS_PER_LONG - 1), ptr);
+}
+
+static inline void clear_bit(unsigned long nr,
+			     const volatile unsigned long *ptr)
+{
+	uint64_t mask = bitops_mask(nr);
+	uint64_t *addr = bitops_word(nr, ptr);
+
+	lang(addr, ~mask);
+}
+
+static inline void clear_bit_inv(unsigned long nr,
+				 const volatile unsigned long *ptr)
+{
+	return clear_bit(nr ^ (BITS_PER_LONG - 1), ptr);
+}
+
+/* non-atomic bit manipulation functions */
+
 static inline bool test_bit(unsigned long nr,
 			    const volatile unsigned long *ptr)
 {
@@ -33,4 +105,34 @@ static inline bool test_bit_inv(unsigned long nr,
 	return test_bit(nr ^ (BITS_PER_LONG - 1), ptr);
 }
 
+static inline void __set_bit(unsigned long nr,
+			     const volatile unsigned long *ptr)
+{
+	uint64_t mask = bitops_mask(nr);
+	uint64_t *addr = bitops_word(nr, ptr);
+
+	*addr |= mask;
+}
+
+static inline void __set_bit_inv(unsigned long nr,
+				 const volatile unsigned long *ptr)
+{
+	return __set_bit(nr ^ (BITS_PER_LONG - 1), ptr);
+}
+
+static inline void __clear_bit(unsigned long nr,
+			       const volatile unsigned long *ptr)
+{
+	uint64_t mask = bitops_mask(nr);
+	uint64_t *addr = bitops_word(nr, ptr);
+
+	*addr &= ~mask;
+}
+
+static inline void __clear_bit_inv(unsigned long nr,
+				   const volatile unsigned long *ptr)
+{
+	return __clear_bit(nr ^ (BITS_PER_LONG - 1), ptr);
+}
+
 #endif
-- 
2.30.2

