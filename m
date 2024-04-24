Return-Path: <kvm+bounces-15786-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0512E8B07E0
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 13:00:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 73EE11F237F5
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 11:00:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F16E715AACF;
	Wed, 24 Apr 2024 10:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="duC5P2Ha"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9AB615991A
	for <kvm@vger.kernel.org>; Wed, 24 Apr 2024 10:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713956394; cv=none; b=eYv7hfu362RxNEZ0pwfEijw5QrxcB41p+w7qzTqyfu11AGFX6hFw9tiRXJNUqlvC2RUrXP3nkf1VLd5BMrOpxjr03Mb+UkLXVnDqSPNN/XPJcKtQ7jvutkuOWkKMtFOIChBItd8J+m3SRO8ptSpyGNOcZCAAbaadw63ZriDpabU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713956394; c=relaxed/simple;
	bh=GszjFVTPbxBJaIEozULNa0CaPgNFwiZ0+s1li8lvADk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pbqSsV6Fy2it4ge/lnphJZMtqRR8L+mXPczcKfh+dQLeYAfHODQBgYdm9J2bsIdEe3MhaDJnQqkL14kax0ghdBZwJgu5KGstGemVFr9Rlfovd93AeGuTRF0LuOnH4Apt3Zlng4J2LZHytXooSs74YHh0TBro0lvZa2pfhnqkMBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=duC5P2Ha; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43OAxmuT031431;
	Wed, 24 Apr 2024 10:59:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=rGpE5/gD1g0K9bvoFTaMxU6u4gvU9v8lLD0V3l1xQPo=;
 b=duC5P2HaJ/h4fWvQlTo24dSEXEr7Yu67KT5/7vEINv8guqwTMYzT2sdGYY+yjwJpc8Y9
 Ue+R8PcEI+1BgSPQdvLFPhZfsfUrAswZBzKey84xJVQ56P2Eudl1CvDSS9NpO76zpwAL
 yv7BfOBXpzhba1BfFPyTR/L4dcThJdGHlb19xGUOPxF3NKhmXEheU5BNoLpm1DE27QVv
 5ASompITZZuBLwIhYpQoGBCxABHG/Iqn9lKDq8XzceJa4g81QW2CGUh4FgmOMbzusiwC
 8LO/10ObDFzpqPeI8NjSUyMdhmqe9HpPBy842hLvT7q3bybcsI0XplfRUu+pbhseKu+1 sA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xq0pbg0kq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Apr 2024 10:59:48 +0000
Received: from m0353723.ppops.net (m0353723.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 43OAtwiX026536;
	Wed, 24 Apr 2024 10:59:47 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xq0pbg0kn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Apr 2024 10:59:47 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 43O8C4C8015343;
	Wed, 24 Apr 2024 10:59:47 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3xmshmb25b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Apr 2024 10:59:46 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 43OAxfHT50856372
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 24 Apr 2024 10:59:43 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3DE2020043;
	Wed, 24 Apr 2024 10:59:41 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 192602004E;
	Wed, 24 Apr 2024 10:59:41 +0000 (GMT)
Received: from t14-nrb.boeblingen.de.ibm.com (unknown [9.152.224.21])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 24 Apr 2024 10:59:41 +0000 (GMT)
From: Nico Boehr <nrb@linux.ibm.com>
To: thuth@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests GIT PULL 13/13] s390x: cmm: test no-translate bit after reset
Date: Wed, 24 Apr 2024 12:59:32 +0200
Message-ID: <20240424105935.184138-14-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240424105935.184138-1-nrb@linux.ibm.com>
References: <20240424105935.184138-1-nrb@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Ow4qSG-cK0plLmbpgXuOWUfCyGLREEHa
X-Proofpoint-GUID: r6OxlulpAbFEXf23bYN6vNbZBhFz_89B
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-04-24_08,2024-04-23_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1015
 priorityscore=1501 adultscore=0 phishscore=0 bulkscore=0
 lowpriorityscore=0 suspectscore=0 impostorscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2404010000 definitions=main-2404240045

KVM did not properly reset the no-translate bit after reset, see
https://lore.kernel.org/kvm/20231109123624.37314-1-imbrenda@linux.ibm.com/

Add a test which performs a load normal reset (includes a subsystem
reset) and verify that this clears the no-translate bit.

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Link: https://lore.kernel.org/r/20240423103529.313782-2-nrb@linux.ibm.com
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/cmm.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/s390x/cmm.c b/s390x/cmm.c
index af852838..536f2bfc 100644
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
2.44.0


