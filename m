Return-Path: <kvm+bounces-47860-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A6747AC6577
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 11:15:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2E31B3A8A1D
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 09:14:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14F9A27511C;
	Wed, 28 May 2025 09:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="nRzFVdvS"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5B342750EC;
	Wed, 28 May 2025 09:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748423699; cv=none; b=q6Le1OiOEx82WNYJUttLSPT/nrMtnP6z+uLE0dl35iioazQZcS2FUykKkTcmDSk+ZX5e37GEHnpGFof692KcevSTMsxtoyJ4xnSL8BjI2qWGG3Q7TO8f9rv9IfsA4hmm63gSa198IlzW3XHEPntpDLrHpfcpdUfppoke4/9VvJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748423699; c=relaxed/simple;
	bh=CG2gt9rtrmax1ql2fknzRhrmi2MkJxdsKHJh+mz4Pa0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dzGuFZ+1Nl3YKrcbk7XSKNvBF6e5jyMTsjqGoUu9Ogf39vOqEx4yjMoYW6WHr8RDajDLidPQTtt7AuCEZqZTd4nauYNtosGTjw6OohziSrzalkbAccTAjMctpLhygIq2jvwfOOXcjSvHatLPUxcFBKlP9aPGXVmxPRiv5WwswR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=nRzFVdvS; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54S8ejBI003374;
	Wed, 28 May 2025 09:14:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=CO+lBsRpdDJ+DIm2L
	Wy6mfT9Ork2vUj30ZB2IOx4xDs=; b=nRzFVdvSYRmMnHxzF4wmcROt5i+k/6Uvv
	lRVf1QuXKBnwqqyb+K/t6JSkochdBUona7R2+RmIP0k0OfS3EilOeVSraUSM4rOD
	8KTZ2/z5wZ3lAmEz0nFMFWQBlM3R/w6IkLFs4sYLuChmwSxsB8oJqBVlFs6YoJR0
	5RcXS3zIV4Bla51sB4kKudX/zWxMnIWykQPNX02pPA2FmOo7GOzC3HmaWLOM1Dkg
	PFkylTet4yrYaPF9H5WnvryOHk//rgwOaipoS7x0Sfgtc79rOudhZvruqlbUzX3/
	KWPglycZRdbycA64G1O/d4t90MRGCAV+9NV6BcpuJg/wsRIRB7Q3g==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46wy69054g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 28 May 2025 09:14:54 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54S6cBNb026432;
	Wed, 28 May 2025 09:14:53 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 46usxmxru1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 28 May 2025 09:14:53 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54S9EnxM8257842
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 May 2025 09:14:49 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BE30020040;
	Wed, 28 May 2025 09:14:49 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7F1DD2004B;
	Wed, 28 May 2025 09:14:49 +0000 (GMT)
Received: from a46lp67.lnxne.boe (unknown [9.152.108.100])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 28 May 2025 09:14:49 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, imbrenda@linux.ibm.com, thuth@redhat.com,
        david@redhat.com, nrb@linux.ibm.com
Subject: [kvm-unit-tests PATCH 1/2] s390x: diag10: Fence tcg and pv environments
Date: Wed, 28 May 2025 09:13:49 +0000
Message-ID: <20250528091412.19483-2-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250528091412.19483-1-frankja@linux.ibm.com>
References: <20250528091412.19483-1-frankja@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=UP3dHDfy c=1 sm=1 tr=0 ts=6836d40e cx=c_pps a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17 a=dt9VzEwgFbYA:10 a=VnNF1IyMAAAA:8 a=3kXVTq6UBBXIgh48pi4A:9
X-Proofpoint-GUID: QfTePssetlQGoh3NTjnTwP6I1k0fq56J
X-Proofpoint-ORIG-GUID: QfTePssetlQGoh3NTjnTwP6I1k0fq56J
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTI4MDA3OCBTYWx0ZWRfX+NVenpKyEZDl kzTsFBG3r8ci3ljtT827K72b5SJ2jT+wtkjBk/0RHdOUGB7fEbLS0MjBFCh4cJ9Ri8NtMtXdC06 0KUD9fjjQLGFvStx/dbRDlT4F9OzVk5EnwG0L2TOVlk59V0xE5yhu+3S3L6FtDHEyIJs+RCyFV8
 OXlNvxjzM2I/aiFCRD2kpMzxiXCYMJw097DpcU8lDXCCD8inHsGLg/cAy1UgqvYWXcHsDQUrapK Xx14dCHBWoM5OCp/t2hHayATBC5Pl9itT/jH5miMrkSdw1KYVTY+vBoapMvafiEETc/PGyBfq1K w3Z6/PEoNKyG5NbAJG2k4nwRXHHlf4tLROw5j0wnHndF1GCjdAicQ4B6KhQ30p/4omAWY133Bfq
 OqoJxU3o+/pJLu4EmO889CTcyifQlxAJCrhXZlDI0THI67ZOErFbdLNYnduMPEjH4NevZWZy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-28_04,2025-05-27_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 lowpriorityscore=0 suspectscore=0 malwarescore=0 impostorscore=0
 mlxlogscore=999 clxscore=1015 priorityscore=1501 bulkscore=0 phishscore=0
 spamscore=0 mlxscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505160000
 definitions=main-2505280078

Diag10 isn't supported under either of these environments so let's
make sure that the test bails out accordingly.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/diag10.c      | 15 +++++++++++++++
 s390x/unittests.cfg |  1 +
 2 files changed, 16 insertions(+)

diff --git a/s390x/diag10.c b/s390x/diag10.c
index 579a7a5d..00725f58 100644
--- a/s390x/diag10.c
+++ b/s390x/diag10.c
@@ -9,6 +9,8 @@
  */
 
 #include <libcflat.h>
+#include <uv.h>
+#include <hardware.h>
 #include <asm/asm-offsets.h>
 #include <asm/interrupt.h>
 #include <asm/page.h>
@@ -95,8 +97,21 @@ static void test_priv(void)
 int main(void)
 {
 	report_prefix_push("diag10");
+
+	if (host_is_tcg()) {
+		report_skip("Test unsupported under TCG");
+		goto out;
+	}
+	if (uv_os_is_guest()) {
+		report_skip("Test unsupported under PV");
+		goto out;
+	}
+
 	test_prefix();
 	test_params();
 	test_priv();
+
+out:
+	report_prefix_pop();
 	return report_summary();
 }
diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index a9af6680..9c43ab2f 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -51,6 +51,7 @@ extra_params = -device virtio-net-ccw
 
 [diag10]
 file = diag10.elf
+accel = kvm
 
 [diag308]
 file = diag308.elf
-- 
2.48.1


