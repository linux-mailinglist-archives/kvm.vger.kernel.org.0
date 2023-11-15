Return-Path: <kvm+bounces-1805-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A6D17EBEFE
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 10:03:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2A15F1C20B0F
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 09:03:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A57B5249;
	Wed, 15 Nov 2023 09:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="tRQ0uoCA"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 847477E
	for <kvm@vger.kernel.org>; Wed, 15 Nov 2023 09:02:55 +0000 (UTC)
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B682114;
	Wed, 15 Nov 2023 01:02:54 -0800 (PST)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3AF90AcB005411;
	Wed, 15 Nov 2023 09:02:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=rIhKRCxW1nerHrialj53PfM13X+C2Uytiy00AyDIMuo=;
 b=tRQ0uoCAWc12EqAX5BAbsOv4QL3FAKyYjiIlp+7HbevQfaY/8hKUjPOVrAh7QmR3ipIe
 fNfggd4Wd9N9fYE+BSOe0SSf3yItis3eBEIRyKvrifMywIr5AxDEOmhUM/d9r0lCoBDf
 KKPMfgXppjCdAuCv0VrTAblPh3GcEDMYPi11zv1sfNtl04z5sszYSjWjF4m8ro8t82zl
 Nxt/J0EmEJk8Rxascy+NOOFBTqzBB60bkeOlYGKuj6A1P5wEc9QPzP0Xpj8z00kigKZP
 UKIC+IsqxQGv6DCuro3igqXCQXqqo+0j0hHOnk5ixcG7ZEZo923DKoM7ZxlXNceWToX7 Ow== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uctyh85bj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 15 Nov 2023 09:02:53 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3AF90hiO011212;
	Wed, 15 Nov 2023 09:02:52 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uctyh859t-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 15 Nov 2023 09:02:52 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3AF7jVQ1023945;
	Wed, 15 Nov 2023 08:38:51 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3uamaye4xf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 15 Nov 2023 08:38:51 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3AF8cmnh43844038
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 15 Nov 2023 08:38:48 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 45B0C2004D;
	Wed, 15 Nov 2023 08:38:48 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 268472004E;
	Wed, 15 Nov 2023 08:38:48 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 15 Nov 2023 08:38:48 +0000 (GMT)
From: Nico Boehr <nrb@linux.ibm.com>
To: frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v1] s390x: cmm: test no-translate bit after reset
Date: Wed, 15 Nov 2023 09:38:32 +0100
Message-ID: <20231115083848.17803-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: rcSZMjGn88BVlD0P8jYWrtpPcl-E_e9S
X-Proofpoint-ORIG-GUID: 9nW8JSxkOkCNjLozPRGolOmjomCEj83j
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-15_07,2023-11-14_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 mlxscore=0 bulkscore=0 spamscore=0 lowpriorityscore=0
 clxscore=1015 suspectscore=0 mlxlogscore=999 adultscore=0 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311150067

KVM did not properly reset the no-translate bit after reset, see
https://lore.kernel.org/kvm/20231109123624.37314-1-imbrenda@linux.ibm.com/

Add a test which performs a load normal reset (includes a subsystem
reset) and verify that this clears the no-translate bit.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/cmm.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/s390x/cmm.c b/s390x/cmm.c
index af852838851e..8f10c107d81b 100644
--- a/s390x/cmm.c
+++ b/s390x/cmm.c
@@ -9,6 +9,7 @@
  */
 
 #include <libcflat.h>
+#include <bitops.h>
 #include <asm/asm-offsets.h>
 #include <asm/interrupt.h>
 #include <asm/page.h>
@@ -16,6 +17,8 @@
 
 static uint8_t pagebuf[PAGE_SIZE] __attribute__((aligned(PAGE_SIZE)));
 
+extern int diag308_load_reset(u64);
+
 static void test_params(void)
 {
 	report_prefix_push("invalid ORC 8");
@@ -35,6 +38,26 @@ static void test_priv(void)
 	report_prefix_pop();
 }
 
+static void test_reset_no_translate(void)
+{
+	unsigned long state;
+	const uint64_t mask_no_translate = BIT(63 - 58);
+
+	report_prefix_push("reset no-translate");
+	essa(ESSA_SET_STABLE_NODAT, (unsigned long)pagebuf);
+
+	state = essa(ESSA_GET_STATE, (unsigned long)pagebuf);
+	report(state & mask_no_translate, "no-translate bit set before reset");
+
+	/* Load normal reset - includes subsystem reset */
+	diag308_load_reset(1);
+
+	state = essa(ESSA_GET_STATE, (unsigned long)pagebuf);
+	report(!(state & mask_no_translate), "no-translate bit unset after reset");
+
+	report_prefix_pop();
+}
+
 int main(void)
 {
 	bool has_essa = check_essa_available();
@@ -47,6 +70,7 @@ int main(void)
 
 	test_priv();
 	test_params();
+	test_reset_no_translate();
 done:
 	report_prefix_pop();
 	return report_summary();
-- 
2.41.0


