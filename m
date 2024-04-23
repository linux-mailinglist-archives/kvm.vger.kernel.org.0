Return-Path: <kvm+bounces-15631-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CC5B68AE24F
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 12:35:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0AE791C21A61
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 10:35:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 120D25FEE6;
	Tue, 23 Apr 2024 10:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="gjGe2y+N"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ED47208BC;
	Tue, 23 Apr 2024 10:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713868540; cv=none; b=RTkUe5QioUfyQxT6lZXX9V32WR7R4mC359G3IYzKdwFeN+r5ybTf+DEnYiczI2m/DVTANF0TyypEbDyqsyvsGm7FeowTrcHYogW/GsNHM6wkpWxewkxAjZFNYXXKAUN0FcymSJFtmM123ouNgrNuyfBwSlbvhCvpsKP+1BGuoeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713868540; c=relaxed/simple;
	bh=/iWAo8oILFNgWLzShi+8Mx92XJbaOZaKmF2DxhL0xKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZPzry16fkz2bpwIEJ1HlbT7PWGreK9OT8k0Iq/qdntg8zjdlDM/WgXnsB1wy2Tzv/4wZ5NbjxTDxaXZDZfGGsMVL402VDexEIO176/mGD0+9E+CHzxTdGJwONjxVQncNRzIhBrstRWhjJdLUKNydeLsys424JCkexseJe9oVw3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=gjGe2y+N; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43NAU2WF022449;
	Tue, 23 Apr 2024 10:35:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=oZVa1McnfVjnR7hgvPmvE49sWfu02hCrKiT0rqMTs3M=;
 b=gjGe2y+N5fXI3KkYbVNX0rkNV3TG9vb1UnBBsjkCWpueWiT7o3QXOcnp0GyNePWrxZQo
 WLUUkcxfuwwoV1BqM8Zc7EyRGbV3gyJkbbbxIPewNXOWI+K/xOop7EknTHUuZwLOVWTG
 3GPmPGgSR4d5eYDnbvNzAEC8oLt++YW+XRm9yTsV3jrBeMedQS5eyEzTszJVHxBabelq
 7RNHXI69ByG+YdFLFUEme+4DCdJoaB1EvqlMGAwkqUSpmsaqlEaxBSOFK71OgjoZjAKS
 q58LYUKu5Nb+PasINKojdsUTlhV40rowyzU0Jde+oJB5SClm3Vqc50Ykdfar14VjNXho SA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xp9q4075g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 Apr 2024 10:35:37 +0000
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 43NAVl8l025087;
	Tue, 23 Apr 2024 10:35:36 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xp9q4075d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 Apr 2024 10:35:36 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 43N9i9fl029854;
	Tue, 23 Apr 2024 10:35:35 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3xmr1td99s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 Apr 2024 10:35:35 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 43NAZU1N15925528
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Apr 2024 10:35:32 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 976802004F;
	Tue, 23 Apr 2024 10:35:30 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 699372004B;
	Tue, 23 Apr 2024 10:35:30 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 23 Apr 2024 10:35:30 +0000 (GMT)
From: Nico Boehr <nrb@linux.ibm.com>
To: frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v3 1/1] s390x: cmm: test no-translate bit after reset
Date: Tue, 23 Apr 2024 12:34:59 +0200
Message-ID: <20240423103529.313782-2-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20240423103529.313782-1-nrb@linux.ibm.com>
References: <20240423103529.313782-1-nrb@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 8SrWLNqgwWNqf_lMrSvyl25QzIQiaQRg
X-Proofpoint-ORIG-GUID: j9u3eyZTtKs0LdYIJ9ZebiQwkcRM14TV
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-23_09,2024-04-22_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxscore=0
 suspectscore=0 spamscore=0 priorityscore=1501 phishscore=0 malwarescore=0
 impostorscore=0 bulkscore=0 lowpriorityscore=0 mlxlogscore=999
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404230028

KVM did not properly reset the no-translate bit after reset, see
https://lore.kernel.org/kvm/20231109123624.37314-1-imbrenda@linux.ibm.com/

Add a test which performs a load normal reset (includes a subsystem
reset) and verify that this clears the no-translate bit.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/cmm.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/s390x/cmm.c b/s390x/cmm.c
index af852838851e..536f2bfc3c93 100644
--- a/s390x/cmm.c
+++ b/s390x/cmm.c
@@ -9,13 +9,17 @@
  */
 
 #include <libcflat.h>
+#include <bitops.h>
 #include <asm/asm-offsets.h>
 #include <asm/interrupt.h>
 #include <asm/page.h>
 #include <asm/cmm.h>
+#include <asm/facility.h>
 
 static uint8_t pagebuf[PAGE_SIZE] __attribute__((aligned(PAGE_SIZE)));
 
+extern int diag308_load_reset(u64);
+
 static void test_params(void)
 {
 	report_prefix_push("invalid ORC 8");
@@ -35,6 +39,35 @@ static void test_priv(void)
 	report_prefix_pop();
 }
 
+static void test_reset_no_translate(void)
+{
+	const uint64_t mask_no_translate = BIT(63 - 58);
+	unsigned long state;
+
+	if (!test_facility(147)) {
+		report_prefix_push("no-translate unavailable");
+		expect_pgm_int();
+		essa(ESSA_SET_STABLE_NODAT, (unsigned long)pagebuf);
+		check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
+		report_prefix_pop();
+		return;
+	}
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
@@ -47,6 +80,7 @@ int main(void)
 
 	test_priv();
 	test_params();
+	test_reset_no_translate();
 done:
 	report_prefix_pop();
 	return report_summary();
-- 
2.41.0


