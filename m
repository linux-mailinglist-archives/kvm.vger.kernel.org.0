Return-Path: <kvm+bounces-15472-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5163A8AC816
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 10:55:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0D0F2283C03
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 08:55:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5478537F0;
	Mon, 22 Apr 2024 08:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="S3HA438S"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26F5A433CF;
	Mon, 22 Apr 2024 08:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713775963; cv=none; b=GevMO+V8MUzVEEQlPuIMtLhlEBvn4UgBH0ctugo/NIq2EGdr5YL4HA1wFSi2yLEju4BoF0i6uCC7q/Y9xAi37QspcloFi8fyiU/O6/8e9QhS06TrVMU7Q06dkFc6jYaT4KohLjWHu+EtLapkLlCdiRoTehfU5ixKjOz+S+F7RTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713775963; c=relaxed/simple;
	bh=jg+ObMLwm83PXAH3tHWyCR4NF9VahyFZz1sLw/dO2Sk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cpBqrvaztBL+rw6qhUn11ezivXcHNfTIZarZPKFNV7bxyJ+O0WPOIR9FlSMQBmYTCmN3dshu/DxUWJwes59U83PWv+QbFN2pEvQA+gk+pSw/3WXkO1qwdD4DXkbd9WHEkUXmFfNZYJU7bFtfYyF10M+210iL+OfrRMLMy6LWbls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=S3HA438S; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43M8SPWj028988;
	Mon, 22 Apr 2024 08:52:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=nMsa6VKqmpu5xjZ/NfmY/IyEs0Lc/Ez4ENHPOvglI9w=;
 b=S3HA438S6CQcYyQjDFtgFOEQ2+ulg7NDlTo7FbL2MD4/sNWIsnGpTPfEwqyopPUU2jVF
 XEWvcaXLiVHoldd58161So9Dv29NdVT8RB7+aGK1RLs/5kDJ38Xl9fFQk9yVH0MEYmTo
 ENbstmTFzWyZ/iXlhFP0bfJ8dfidIs+eJvoTI47NuYfZOqLv3j1HIfHwBlBo5MoliUOy
 J+pUlLscwGRD7Wm58W03EhvXrLvE6A5rOzt8osDOlqa+N7iJu/sbYV1ksxJYT3Zh5jV9
 yxEkARygSfXrlfa/pD0F9iSbGyZCqwfxmv1zHiKIcUDNBPpLE9VA5WlnhH70HP4ou4re jg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xnmd4r1h8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 22 Apr 2024 08:52:39 +0000
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 43M8qdOb001908;
	Mon, 22 Apr 2024 08:52:39 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xnmd4r1h7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 22 Apr 2024 08:52:39 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 43M81Z2f028763;
	Mon, 22 Apr 2024 08:52:38 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3xmtr268y9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 22 Apr 2024 08:52:38 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 43M8qXwB50135468
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 22 Apr 2024 08:52:35 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 044702004B;
	Mon, 22 Apr 2024 08:52:33 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CA19C2004F;
	Mon, 22 Apr 2024 08:52:32 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 22 Apr 2024 08:52:32 +0000 (GMT)
From: Nico Boehr <nrb@linux.ibm.com>
To: frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v2 1/1] s390x: cmm: test no-translate bit after reset
Date: Mon, 22 Apr 2024 10:51:50 +0200
Message-ID: <20240422085232.21097-2-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20240422085232.21097-1-nrb@linux.ibm.com>
References: <20240422085232.21097-1-nrb@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: r6F0sq20her3d1aBb-t8ynrWlntV7yy-
X-Proofpoint-ORIG-GUID: lRnGWHsvPuLugKAPafpIe5XcvjpT4w3A
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
 definitions=2024-04-22_05,2024-04-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 bulkscore=0
 mlxscore=0 lowpriorityscore=0 impostorscore=0 phishscore=0 suspectscore=0
 priorityscore=1501 mlxlogscore=999 adultscore=0 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404220038

KVM did not properly reset the no-translate bit after reset, see
https://lore.kernel.org/kvm/20231109123624.37314-1-imbrenda@linux.ibm.com/

Add a test which performs a load normal reset (includes a subsystem
reset) and verify that this clears the no-translate bit.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 s390x/cmm.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/s390x/cmm.c b/s390x/cmm.c
index af852838851e..ca6eb00bd663 100644
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
+	const uint64_t mask_no_translate = BIT(63 - 58);
+	unsigned long state;
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


