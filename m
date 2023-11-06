Return-Path: <kvm+bounces-800-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 498B37E2A0C
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 17:38:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C2772B20F30
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 16:38:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF0062C851;
	Mon,  6 Nov 2023 16:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="n5+LU7U/"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C618C2941D
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 16:37:48 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8D79D6F;
	Mon,  6 Nov 2023 08:37:44 -0800 (PST)
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6GCSrp013132;
	Mon, 6 Nov 2023 16:37:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=mGKfaxFcsqBeblRGL8tnRW6ubtJDlbBFj1Lalg3Ogd8=;
 b=n5+LU7U/e/JYe4J8D1rvC+ZIjvi5LlntPv8VgZrCe3VfiQO3SfJIWp7lKUKn+o72EjkD
 gxuQEMukWws0bAGXCSCC8Z32VaI8cMY12BlfzN8sFjB/iXJkTxSUHHadqvuVelSRPVHQ
 xDov3ngIl49BxrnkuEQTHsGvr8tQtbXdgZo+urnK23H3tHzYnfjwvZmU+G+dQD/SOjlu
 RvfR3x2NFNqZauW5oBzbesBMASXs3iyQdrR854nK6wcBXm7u1Zx5n+9qwh0b1pqTpKeR
 A5t6I2PduKWEsDyA+GdbRM4INUD2py6bp/gfS/FWlfRIsBqrLyvjAsC1b4RcY0ebZ9+g kA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u73f4gygn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Nov 2023 16:37:44 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3A6GCatj014051;
	Mon, 6 Nov 2023 16:37:43 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u73f4gyfy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Nov 2023 16:37:43 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6EQb36007971;
	Mon, 6 Nov 2023 16:37:42 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3u61skaftw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Nov 2023 16:37:42 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3A6Gbd7W44892462
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 6 Nov 2023 16:37:39 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 19A032004B;
	Mon,  6 Nov 2023 16:37:39 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D10AC2004D;
	Mon,  6 Nov 2023 16:37:38 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  6 Nov 2023 16:37:38 +0000 (GMT)
From: Nico Boehr <nrb@linux.ibm.com>
To: frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        hca@linux.ibm.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v8 1/8] lib: s390x: introduce bitfield for PSW mask
Date: Mon,  6 Nov 2023 17:37:23 +0100
Message-ID: <20231106163738.1116942-2-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231106163738.1116942-1-nrb@linux.ibm.com>
References: <20231106163738.1116942-1-nrb@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Z2sS8W4t6D9KGZS7_HthGq1-MfL9jDox
X-Proofpoint-ORIG-GUID: ImsmejNktl9u8JWp6iZkzS3wt18s8Ug9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-06_12,2023-11-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 mlxscore=0
 clxscore=1015 lowpriorityscore=0 suspectscore=0 adultscore=0
 mlxlogscore=673 priorityscore=1501 impostorscore=0 spamscore=0
 phishscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310240000 definitions=main-2311060134

Changing the PSW mask is currently little clumsy, since there is only the
PSW_MASK_* defines. This makes it hard to change e.g. only the address
space in the current PSW without a lot of bit fiddling.

Introduce a bitfield for the PSW mask. This makes this kind of
modifications much simpler and easier to read.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
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


