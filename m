Return-Path: <kvm+bounces-477-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0365B7E0007
	for <lists+kvm@lfdr.de>; Fri,  3 Nov 2023 10:30:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A74C91F210EC
	for <lists+kvm@lfdr.de>; Fri,  3 Nov 2023 09:30:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6051168DD;
	Fri,  3 Nov 2023 09:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ro3k5TS8"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6865168BD
	for <kvm@vger.kernel.org>; Fri,  3 Nov 2023 09:30:10 +0000 (UTC)
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76A1B1AD;
	Fri,  3 Nov 2023 02:30:09 -0700 (PDT)
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A39Oeln013081;
	Fri, 3 Nov 2023 09:30:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Vtx3jimJJQcEYxtJsiGxZSAsCGrbB0/Nlzx0qU+lOS8=;
 b=ro3k5TS8pfdUjE31vyqsjFHI4+rJd+F15JKemuaAQdOqKPcMyWv92jYtDzHe2X9lzOYh
 6gc+0iH+MnreYk6A3BNanT2XbYLbx6ZcDuW/qQjzVVrSY2r0yFHgaXZ4SGUOni9aNHA1
 M8fRjzex4qiuDFCnqwXhDrThaO8ucWrosirhplsK0OZKIygn8zZ9iuF9XkyUV9iQEYqH
 vzDRSuiK9NPWlzU/R44TJRCriWtxxHSwmI2R7AlKpd05zGrAs/VcDw/nLDxR/FGjwzzY
 ehoUtt8QGEjxWZVp1dDXAZBIPjzrgjsSfEan6ARVGasy7HzLr0RuE+GitIuXD7aIf+/i ww== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u4x6wg43y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 03 Nov 2023 09:29:59 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3A39QDoq016894;
	Fri, 3 Nov 2023 09:29:58 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u4x6wg43f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 03 Nov 2023 09:29:58 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3A398kqm011576;
	Fri, 3 Nov 2023 09:29:58 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3u1e4mcssd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 03 Nov 2023 09:29:57 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3A39Tsgm20906718
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 3 Nov 2023 09:29:55 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D98772004D;
	Fri,  3 Nov 2023 09:29:54 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B6F5E2004B;
	Fri,  3 Nov 2023 09:29:54 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  3 Nov 2023 09:29:54 +0000 (GMT)
From: Nico Boehr <nrb@linux.ibm.com>
To: frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v7 1/8] lib: s390x: introduce bitfield for PSW mask
Date: Fri,  3 Nov 2023 10:29:30 +0100
Message-ID: <20231103092954.238491-2-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231103092954.238491-1-nrb@linux.ibm.com>
References: <20231103092954.238491-1-nrb@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: lmIkTwB_Ms2C2dWgySY2oqCNeR5abIrX
X-Proofpoint-GUID: rCBpVYRlH9J0qO6nppbNz3lhy9jFssco
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-03_09,2023-11-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 spamscore=0
 lowpriorityscore=0 impostorscore=0 mlxlogscore=612 priorityscore=1501
 adultscore=0 suspectscore=0 bulkscore=0 malwarescore=0 clxscore=1015
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310240000 definitions=main-2311030078

Changing the PSW mask is currently little clumsy, since there is only the
PSW_MASK_* defines. This makes it hard to change e.g. only the address
space in the current PSW without a lot of bit fiddling.

Introduce a bitfield for the PSW mask. This makes this kind of
modifications much simpler and easier to read.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
---
 lib/s390x/asm/arch_def.h | 25 ++++++++++++++++++++++++-
 s390x/selftest.c         | 34 ++++++++++++++++++++++++++++++++++
 2 files changed, 58 insertions(+), 1 deletion(-)

diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
index bb26e008cc68..f629b6d0a17f 100644
--- a/lib/s390x/asm/arch_def.h
+++ b/lib/s390x/asm/arch_def.h
@@ -37,9 +37,32 @@ struct stack_frame_int {
 };
 
 struct psw {
-	uint64_t	mask;
+	union {
+		uint64_t	mask;
+		struct {
+			uint64_t reserved00:1;
+			uint64_t per:1;
+			uint64_t reserved02:3;
+			uint64_t dat:1;
+			uint64_t io:1;
+			uint64_t ext:1;
+			uint64_t key:4;
+			uint64_t reserved12:1;
+			uint64_t mchk:1;
+			uint64_t wait:1;
+			uint64_t pstate:1;
+			uint64_t as:2;
+			uint64_t cc:2;
+			uint64_t prg_mask:4;
+			uint64_t reserved24:7;
+			uint64_t ea:1;
+			uint64_t ba:1;
+			uint64_t reserved33:31;
+		};
+	};
 	uint64_t	addr;
 };
+_Static_assert(sizeof(struct psw) == 16, "PSW size");
 
 #define PSW(m, a) ((struct psw){ .mask = (m), .addr = (uint64_t)(a) })
 
diff --git a/s390x/selftest.c b/s390x/selftest.c
index 13fd36bc06f8..92ed4e5d35eb 100644
--- a/s390x/selftest.c
+++ b/s390x/selftest.c
@@ -74,6 +74,39 @@ static void test_malloc(void)
 	report_prefix_pop();
 }
 
+static void test_psw_mask(void)
+{
+	uint64_t expected_key = 0xf;
+	struct psw test_psw = PSW(0, 0);
+
+	report_prefix_push("PSW mask");
+	test_psw.mask = PSW_MASK_DAT;
+	report(test_psw.dat, "DAT matches expected=0x%016lx actual=0x%016lx", PSW_MASK_DAT, test_psw.mask);
+
+	test_psw.mask = PSW_MASK_IO;
+	report(test_psw.io, "IO matches expected=0x%016lx actual=0x%016lx", PSW_MASK_IO, test_psw.mask);
+
+	test_psw.mask = PSW_MASK_EXT;
+	report(test_psw.ext, "EXT matches expected=0x%016lx actual=0x%016lx", PSW_MASK_EXT, test_psw.mask);
+
+	test_psw.mask = expected_key << (63 - 11);
+	report(test_psw.key == expected_key, "PSW Key matches expected=0x%lx actual=0x%x", expected_key, test_psw.key);
+
+	test_psw.mask = 1UL << (63 - 13);
+	report(test_psw.mchk, "MCHK matches");
+
+	test_psw.mask = PSW_MASK_WAIT;
+	report(test_psw.wait, "Wait matches expected=0x%016lx actual=0x%016lx", PSW_MASK_WAIT, test_psw.mask);
+
+	test_psw.mask = PSW_MASK_PSTATE;
+	report(test_psw.pstate, "Pstate matches expected=0x%016lx actual=0x%016lx", PSW_MASK_PSTATE, test_psw.mask);
+
+	test_psw.mask = PSW_MASK_64;
+	report(test_psw.ea && test_psw.ba, "BA/EA matches expected=0x%016lx actual=0x%016lx", PSW_MASK_64, test_psw.mask);
+
+	report_prefix_pop();
+}
+
 int main(int argc, char**argv)
 {
 	report_prefix_push("selftest");
@@ -89,6 +122,7 @@ int main(int argc, char**argv)
 	test_fp();
 	test_pgm_int();
 	test_malloc();
+	test_psw_mask();
 
 	return report_summary();
 }
-- 
2.41.0


