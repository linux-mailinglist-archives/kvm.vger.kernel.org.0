Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 364C44BF511
	for <lists+kvm@lfdr.de>; Tue, 22 Feb 2022 10:49:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230325AbiBVJtt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Feb 2022 04:49:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230301AbiBVJtq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Feb 2022 04:49:46 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 666CBC087C;
        Tue, 22 Feb 2022 01:49:20 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21M8tYGA010593;
        Tue, 22 Feb 2022 09:49:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=eFVlPDp5pED+YArMELvZ8SC2+nwVFqE36E9fdxi8Nu4=;
 b=bJuKocpcXX4gs9t1ENG5P4qwHgPvGmwgj39Yt7klpp+jCV289zD1CaJFQPhzbsPtVrS+
 uclYQjwzZbTZ+ehuwxWNJ5TD9AemGNT0gs1M+oXSdiSLWSaUqMaKmWC7Ijc3v+C3mFXO
 sFw/KQgKjxA5r6t1f59lEqJeYUtAXkDw6TZBbkD3sMl70sYoQ3sItNyHUSaz4OCRYj4d
 j5TmoNqU6ex2gDiAet5cn1+xDS4X6dMHKGTeOHug/PouWkF8XRlCX9UMWIyil5nCYR0F
 pIdY8BLyiOejl7yGRE3Mlt3fJbeDYuDerMNHf1TaOmIGrJld53dPf5Ayz85nNZvSoCSV CQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ecvrg94vy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Feb 2022 09:49:19 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21M97mnn015234;
        Tue, 22 Feb 2022 09:49:19 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ecvrg94vm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Feb 2022 09:49:18 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21M9mxvH003420;
        Tue, 22 Feb 2022 09:49:17 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma05fra.de.ibm.com with ESMTP id 3ear698bgm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Feb 2022 09:49:17 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21M9nC8S50397618
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Feb 2022 09:49:12 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 531BC52052;
        Tue, 22 Feb 2022 09:49:12 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id 3C51752050;
        Tue, 22 Feb 2022 09:49:12 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 0B32FE04DC; Tue, 22 Feb 2022 10:49:12 +0100 (CET)
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
Subject: [GIT PULL 02/13] s390/uaccess: Add copy_from/to_user_key functions
Date:   Tue, 22 Feb 2022 10:48:59 +0100
Message-Id: <20220222094910.18331-3-borntraeger@linux.ibm.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220222094910.18331-1-borntraeger@linux.ibm.com>
References: <20220222094910.18331-1-borntraeger@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: V2MrHORN70l3pldMgzQ8ONf0QYWToMN-
X-Proofpoint-GUID: hcp5ijzEI-ot-Snvj1_eC-gqw-5xe7pd
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-22_02,2022-02-21_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 adultscore=0 clxscore=1015 spamscore=0 phishscore=0
 impostorscore=0 suspectscore=0 mlxscore=0 bulkscore=0 lowpriorityscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202220054
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janis Schoetterl-Glausch <scgl@linux.ibm.com>

Add copy_from/to_user_key functions, which perform storage key checking.
These functions can be used by KVM for emulating instructions that need
to be key checked.
These functions differ from their non _key counterparts in
include/linux/uaccess.h only in the additional key argument and must be
kept in sync with those.

Since the existing uaccess implementation on s390 makes use of move
instructions that support having an additional access key supplied,
we can implement raw_copy_from/to_user_key by enhancing the
existing implementation.

Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Acked-by: Heiko Carstens <hca@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Acked-by: Janosch Frank <frankja@linux.ibm.com>
Link: https://lore.kernel.org/r/20220211182215.2730017-2-scgl@linux.ibm.com
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
---
 arch/s390/include/asm/uaccess.h | 22 +++++++++
 arch/s390/lib/uaccess.c         | 81 +++++++++++++++++++++++++--------
 2 files changed, 85 insertions(+), 18 deletions(-)

diff --git a/arch/s390/include/asm/uaccess.h b/arch/s390/include/asm/uaccess.h
index d74e26b48604..ba1bcb91af95 100644
--- a/arch/s390/include/asm/uaccess.h
+++ b/arch/s390/include/asm/uaccess.h
@@ -44,6 +44,28 @@ raw_copy_to_user(void __user *to, const void *from, unsigned long n);
 #define INLINE_COPY_TO_USER
 #endif
 
+unsigned long __must_check
+_copy_from_user_key(void *to, const void __user *from, unsigned long n, unsigned long key);
+
+static __always_inline unsigned long __must_check
+copy_from_user_key(void *to, const void __user *from, unsigned long n, unsigned long key)
+{
+	if (likely(check_copy_size(to, n, false)))
+		n = _copy_from_user_key(to, from, n, key);
+	return n;
+}
+
+unsigned long __must_check
+_copy_to_user_key(void __user *to, const void *from, unsigned long n, unsigned long key);
+
+static __always_inline unsigned long __must_check
+copy_to_user_key(void __user *to, const void *from, unsigned long n, unsigned long key)
+{
+	if (likely(check_copy_size(from, n, true)))
+		n = _copy_to_user_key(to, from, n, key);
+	return n;
+}
+
 int __put_user_bad(void) __attribute__((noreturn));
 int __get_user_bad(void) __attribute__((noreturn));
 
diff --git a/arch/s390/lib/uaccess.c b/arch/s390/lib/uaccess.c
index 8a5d21461889..b709239feb5d 100644
--- a/arch/s390/lib/uaccess.c
+++ b/arch/s390/lib/uaccess.c
@@ -59,11 +59,13 @@ static inline int copy_with_mvcos(void)
 #endif
 
 static inline unsigned long copy_from_user_mvcos(void *x, const void __user *ptr,
-						 unsigned long size)
+						 unsigned long size, unsigned long key)
 {
 	unsigned long tmp1, tmp2;
 	union oac spec = {
+		.oac2.key = key,
 		.oac2.as = PSW_BITS_AS_SECONDARY,
+		.oac2.k = 1,
 		.oac2.a = 1,
 	};
 
@@ -94,19 +96,19 @@ static inline unsigned long copy_from_user_mvcos(void *x, const void __user *ptr
 }
 
 static inline unsigned long copy_from_user_mvcp(void *x, const void __user *ptr,
-						unsigned long size)
+						unsigned long size, unsigned long key)
 {
 	unsigned long tmp1, tmp2;
 
 	tmp1 = -256UL;
 	asm volatile(
 		"   sacf  0\n"
-		"0: mvcp  0(%0,%2),0(%1),%3\n"
+		"0: mvcp  0(%0,%2),0(%1),%[key]\n"
 		"7: jz    5f\n"
 		"1: algr  %0,%3\n"
 		"   la    %1,256(%1)\n"
 		"   la    %2,256(%2)\n"
-		"2: mvcp  0(%0,%2),0(%1),%3\n"
+		"2: mvcp  0(%0,%2),0(%1),%[key]\n"
 		"8: jnz   1b\n"
 		"   j     5f\n"
 		"3: la    %4,255(%1)\n"	/* %4 = ptr + 255 */
@@ -115,7 +117,7 @@ static inline unsigned long copy_from_user_mvcp(void *x, const void __user *ptr,
 		"   slgr  %4,%1\n"
 		"   clgr  %0,%4\n"	/* copy crosses next page boundary? */
 		"   jnh   6f\n"
-		"4: mvcp  0(%4,%2),0(%1),%3\n"
+		"4: mvcp  0(%4,%2),0(%1),%[key]\n"
 		"9: slgr  %0,%4\n"
 		"   j     6f\n"
 		"5: slgr  %0,%0\n"
@@ -123,24 +125,49 @@ static inline unsigned long copy_from_user_mvcp(void *x, const void __user *ptr,
 		EX_TABLE(0b,3b) EX_TABLE(2b,3b) EX_TABLE(4b,6b)
 		EX_TABLE(7b,3b) EX_TABLE(8b,3b) EX_TABLE(9b,6b)
 		: "+a" (size), "+a" (ptr), "+a" (x), "+a" (tmp1), "=a" (tmp2)
-		: : "cc", "memory");
+		: [key] "d" (key << 4)
+		: "cc", "memory");
 	return size;
 }
 
+static unsigned long raw_copy_from_user_key(void *to, const void __user *from,
+					    unsigned long n, unsigned long key)
+{
+	if (copy_with_mvcos())
+		return copy_from_user_mvcos(to, from, n, key);
+	return copy_from_user_mvcp(to, from, n, key);
+}
+
 unsigned long raw_copy_from_user(void *to, const void __user *from, unsigned long n)
 {
-	if (copy_with_mvcos())
-		return copy_from_user_mvcos(to, from, n);
-	return copy_from_user_mvcp(to, from, n);
+	return raw_copy_from_user_key(to, from, n, 0);
 }
 EXPORT_SYMBOL(raw_copy_from_user);
 
+unsigned long _copy_from_user_key(void *to, const void __user *from,
+				  unsigned long n, unsigned long key)
+{
+	unsigned long res = n;
+
+	might_fault();
+	if (!should_fail_usercopy()) {
+		instrument_copy_from_user(to, from, n);
+		res = raw_copy_from_user_key(to, from, n, key);
+	}
+	if (unlikely(res))
+		memset(to + (n - res), 0, res);
+	return res;
+}
+EXPORT_SYMBOL(_copy_from_user_key);
+
 static inline unsigned long copy_to_user_mvcos(void __user *ptr, const void *x,
-					       unsigned long size)
+					       unsigned long size, unsigned long key)
 {
 	unsigned long tmp1, tmp2;
 	union oac spec = {
+		.oac1.key = key,
 		.oac1.as = PSW_BITS_AS_SECONDARY,
+		.oac1.k = 1,
 		.oac1.a = 1,
 	};
 
@@ -171,19 +198,19 @@ static inline unsigned long copy_to_user_mvcos(void __user *ptr, const void *x,
 }
 
 static inline unsigned long copy_to_user_mvcs(void __user *ptr, const void *x,
-					      unsigned long size)
+					      unsigned long size, unsigned long key)
 {
 	unsigned long tmp1, tmp2;
 
 	tmp1 = -256UL;
 	asm volatile(
 		"   sacf  0\n"
-		"0: mvcs  0(%0,%1),0(%2),%3\n"
+		"0: mvcs  0(%0,%1),0(%2),%[key]\n"
 		"7: jz    5f\n"
 		"1: algr  %0,%3\n"
 		"   la    %1,256(%1)\n"
 		"   la    %2,256(%2)\n"
-		"2: mvcs  0(%0,%1),0(%2),%3\n"
+		"2: mvcs  0(%0,%1),0(%2),%[key]\n"
 		"8: jnz   1b\n"
 		"   j     5f\n"
 		"3: la    %4,255(%1)\n" /* %4 = ptr + 255 */
@@ -192,7 +219,7 @@ static inline unsigned long copy_to_user_mvcs(void __user *ptr, const void *x,
 		"   slgr  %4,%1\n"
 		"   clgr  %0,%4\n"	/* copy crosses next page boundary? */
 		"   jnh   6f\n"
-		"4: mvcs  0(%4,%1),0(%2),%3\n"
+		"4: mvcs  0(%4,%1),0(%2),%[key]\n"
 		"9: slgr  %0,%4\n"
 		"   j     6f\n"
 		"5: slgr  %0,%0\n"
@@ -200,18 +227,36 @@ static inline unsigned long copy_to_user_mvcs(void __user *ptr, const void *x,
 		EX_TABLE(0b,3b) EX_TABLE(2b,3b) EX_TABLE(4b,6b)
 		EX_TABLE(7b,3b) EX_TABLE(8b,3b) EX_TABLE(9b,6b)
 		: "+a" (size), "+a" (ptr), "+a" (x), "+a" (tmp1), "=a" (tmp2)
-		: : "cc", "memory");
+		: [key] "d" (key << 4)
+		: "cc", "memory");
 	return size;
 }
 
+static unsigned long raw_copy_to_user_key(void __user *to, const void *from,
+					  unsigned long n, unsigned long key)
+{
+	if (copy_with_mvcos())
+		return copy_to_user_mvcos(to, from, n, key);
+	return copy_to_user_mvcs(to, from, n, key);
+}
+
 unsigned long raw_copy_to_user(void __user *to, const void *from, unsigned long n)
 {
-	if (copy_with_mvcos())
-		return copy_to_user_mvcos(to, from, n);
-	return copy_to_user_mvcs(to, from, n);
+	return raw_copy_to_user_key(to, from, n, 0);
 }
 EXPORT_SYMBOL(raw_copy_to_user);
 
+unsigned long _copy_to_user_key(void __user *to, const void *from,
+				unsigned long n, unsigned long key)
+{
+	might_fault();
+	if (should_fail_usercopy())
+		return n;
+	instrument_copy_to_user(to, from, n);
+	return raw_copy_to_user_key(to, from, n, key);
+}
+EXPORT_SYMBOL(_copy_to_user_key);
+
 static inline unsigned long clear_user_mvcos(void __user *to, unsigned long size)
 {
 	unsigned long tmp1, tmp2;
-- 
2.35.1

