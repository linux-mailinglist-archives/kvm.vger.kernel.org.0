Return-Path: <kvm+bounces-1480-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F8287E7CC0
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 14:56:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E728F28173D
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 13:56:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35E0538DE1;
	Fri, 10 Nov 2023 13:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Uf+AwPgy"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D42E374E9
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 13:54:46 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADEE238222
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 05:54:42 -0800 (PST)
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3AADaIiS001242;
	Fri, 10 Nov 2023 13:54:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=JRwNitP9Q8s5uPXMvAc7TxFaNNqtcdxC3wVI86SH8d8=;
 b=Uf+AwPgyTDLaLGv/YKyfKE7XO0xBOsqEEjciTHU3F1gyS2am44QcZp1QLLcv/kLtITUp
 mxZRQ5dKlGEJQLSSU1kXqCSOLbW+PGkhgbhzcLSgKdCgBHvZNk7Ge3M7khpZIWOOo8E6
 4RaufGKAz+TZZu11Jf8SGk1uSY2ExPiA6WWDbQF9ejqTFncUiZJj7x4orvUAcC+vuqY+
 MFiv2IUdMfmnM5nynduPtXRiTZtyXW1e28UBCSdTAyuHLMgwaf1ezcn+kfrgoeAeEvoQ
 fIiOVgUBvKl8q316NTAgt/Szvyob8sP76n4/M9NLV7rwneVWOX6ye4d571DTdYqREaFu Jg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u9mrn9rx5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Nov 2023 13:54:40 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3AADgjL3022782;
	Fri, 10 Nov 2023 13:54:39 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u9mrn9rwh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Nov 2023 13:54:39 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3AABH9Id019429;
	Fri, 10 Nov 2023 13:54:39 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3u7w24b6gb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Nov 2023 13:54:38 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3AADsaN164618924
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Nov 2023 13:54:36 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2E8F020040;
	Fri, 10 Nov 2023 13:54:36 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CADD12004B;
	Fri, 10 Nov 2023 13:54:35 +0000 (GMT)
Received: from t14-nrb.ibmuc.com (unknown [9.179.18.113])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 10 Nov 2023 13:54:35 +0000 (GMT)
From: Nico Boehr <nrb@linux.ibm.com>
To: thuth@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests GIT PULL 19/26] lib: s390x: introduce bitfield for PSW mask
Date: Fri, 10 Nov 2023 14:52:28 +0100
Message-ID: <20231110135348.245156-20-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231110135348.245156-1-nrb@linux.ibm.com>
References: <20231110135348.245156-1-nrb@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 2-6gq2VTJon_kJKx3xSTNI7hlkSmssSR
X-Proofpoint-GUID: ut_gb2es7qiiYqUTL_5tidNyDabkX4HE
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
 bulkscore=0 mlxlogscore=626 mlxscore=0 lowpriorityscore=0
 priorityscore=1501 clxscore=1015 impostorscore=0 adultscore=0
 suspectscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2311060000 definitions=main-2311100114

Changing the PSW mask is currently little clumsy, since there is only the
PSW_MASK_* defines. This makes it hard to change e.g. only the address
space in the current PSW without a lot of bit fiddling.

Introduce a bitfield for the PSW mask. This makes this kind of
modifications much simpler and easier to read.

Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Link: https://lore.kernel.org/r/20231106163738.1116942-2-nrb@linux.ibm.com
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 lib/s390x/asm/arch_def.h | 25 ++++++++++++++++++++++++-
 s390x/selftest.c         | 34 ++++++++++++++++++++++++++++++++++
 2 files changed, 58 insertions(+), 1 deletion(-)

diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
index bb26e00..f629b6d 100644
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
index 13fd36b..92ed4e5 100644
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


