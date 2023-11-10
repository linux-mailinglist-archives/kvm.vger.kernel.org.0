Return-Path: <kvm+bounces-1464-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 33B3F7E7CAD
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 14:54:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E46B228143E
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 13:54:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C1A01B28E;
	Fri, 10 Nov 2023 13:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="DENmvaXt"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 615681A72B
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 13:54:30 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ED533821E
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 05:54:29 -0800 (PST)
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3AADaKcB001450;
	Fri, 10 Nov 2023 13:54:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=u381LJxo4IZIaULGFVH+XDkA8mtFPi9CMzLicjJ5JPk=;
 b=DENmvaXtYfPLcKX15xJkFT5aJ8eLsLMRyApCO24Yhe9bVNvA9QQNGXRa8SfKTAcoKm0V
 /P0hOvVucv3eBDUH86oF8Fo8NfJwi6ZhL5ViuXeuh2wQSkXVpmxeTB02BG1j2e6p6Teo
 mqO9oBqjT81OMmQfneKqXczJpsDwj6ihKNoc4oGKOV/qGzzeGx+zf0PDi79ZEf1Nvkl7
 esukKMmJRH+r6q7s+TW7Qz50Za6ZwguZRJYsLlDOjRovQnEA03dQKtQ++CPm+GB+wf9r
 4AIdYwQr1+PK/GWwXx9p8Lkzo4ozq/dTvLIlmE+bbtGGEapaXYBY6I/Eio0JfYp+Ct4i RA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u9mrn9rgm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Nov 2023 13:54:21 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3AADqYiL022564;
	Fri, 10 Nov 2023 13:54:20 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u9mrn9rfv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Nov 2023 13:54:20 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3AAB4RVK014372;
	Fri, 10 Nov 2023 13:54:19 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3u7w22b7w5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Nov 2023 13:54:19 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3AADsGUk37683840
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Nov 2023 13:54:16 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2741420043;
	Fri, 10 Nov 2023 13:54:16 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3EC182004F;
	Fri, 10 Nov 2023 13:54:14 +0000 (GMT)
Received: from t14-nrb.ibmuc.com (unknown [9.179.18.113])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 10 Nov 2023 13:54:14 +0000 (GMT)
From: Nico Boehr <nrb@linux.ibm.com>
To: thuth@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests GIT PULL 06/26] s390x: spec_ex-sie: refactor to use snippet API
Date: Fri, 10 Nov 2023 14:52:15 +0100
Message-ID: <20231110135348.245156-7-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231110135348.245156-1-nrb@linux.ibm.com>
References: <20231110135348.245156-1-nrb@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: rq0EWCVaUlfKkHi-cy3GuXhccGdDvVJ4
X-Proofpoint-GUID: -BlHLTGFDgU8CZDVGXoxIEGJmOirP40J
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
 definitions=2023-11-10_10,2023-11-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 spamscore=0
 bulkscore=0 mlxlogscore=999 mlxscore=0 lowpriorityscore=0
 priorityscore=1501 clxscore=1015 impostorscore=0 adultscore=0
 suspectscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2311060000 definitions=main-2311100114

spec_ex-sie uses a snippet, but allocated the memory on its own without
obvious reason to do so.

Refactor the test to use snippet_init().

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Link: https://lore.kernel.org/r/20231106170849.1184162-2-nrb@linux.ibm.com
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/spec_ex-sie.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/s390x/spec_ex-sie.c b/s390x/spec_ex-sie.c
index 5fa135b..fe2f23e 100644
--- a/s390x/spec_ex-sie.c
+++ b/s390x/spec_ex-sie.c
@@ -17,19 +17,18 @@
 #include <hardware.h>
 
 static struct vm vm;
-extern const char SNIPPET_NAME_START(c, spec_ex)[];
-extern const char SNIPPET_NAME_END(c, spec_ex)[];
 static bool strict;
 
 static void setup_guest(void)
 {
-	char *guest;
-	int binary_size = SNIPPET_LEN(c, spec_ex);
+	extern const char SNIPPET_NAME_START(c, spec_ex)[];
+	extern const char SNIPPET_NAME_END(c, spec_ex)[];
 
 	setup_vm();
-	guest = alloc_pages(8);
-	memcpy(guest, SNIPPET_NAME_START(c, spec_ex), binary_size);
-	sie_guest_create(&vm, (uint64_t) guest, HPAGE_SIZE);
+
+	snippet_setup_guest(&vm, false);
+	snippet_init(&vm, SNIPPET_NAME_START(c, spec_ex),
+		     SNIPPET_LEN(c, spec_ex), SNIPPET_UNPACK_OFF);
 }
 
 static void reset_guest(void)
-- 
2.41.0


