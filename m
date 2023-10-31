Return-Path: <kvm+bounces-176-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 909467DCA3E
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 10:56:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C1BFD1C20C08
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 09:56:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5412718C29;
	Tue, 31 Oct 2023 09:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="oI5kxVvi"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF8DF10A33
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 09:56:01 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D9C683
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 02:56:00 -0700 (PDT)
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39V9CKJP029095
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 09:55:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=q/FJwqcGAmM7KXt+vWqBFBCb5WDQuv51aX8ZS5BQVNE=;
 b=oI5kxVviJPuDF9aHNzHyAuq9WpB8AcyJ+m4/oV+lnhMgbMOeglOfcciaRsVy9DIJxDc6
 +nS3rimjeuOOEA5X5VfZckuUPj1jPYLVfHbDojsLNn1ERDNgEf94uS4Oit3qYEZZ4RST
 eJ7NbcVqJLWRlKhstiQg5PhL0hh5gRE2VV24n7RnzcAE9IZoLnNkt+5SH1L+RBROB8/1
 K4QGr4vYwy0C4yS6EjrFA5/YHMvLH3ecRuDXXIcZ3mYChsO9yZn+GV5DTnw1YS6RSbqd
 izi2zdhnj2IIvMgvsKlJqV/fYEKH4u2XakcDBGb90Yw7VeLtpfjjUXrF39O1j3lyxLD/ qQ== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u2xrahebf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 09:55:59 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39V9fgFH018620
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 09:55:59 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u2xraheas-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 31 Oct 2023 09:55:58 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39V9tAMK000583;
	Tue, 31 Oct 2023 09:55:58 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3u1cmsyqyf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 31 Oct 2023 09:55:58 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39V9tsgv21430984
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 31 Oct 2023 09:55:55 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F3A8C20043;
	Tue, 31 Oct 2023 09:55:53 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CE7C720040;
	Tue, 31 Oct 2023 09:55:53 +0000 (GMT)
Received: from a46lp67.. (unknown [9.152.108.100])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 31 Oct 2023 09:55:53 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: nrb@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        david@redhat.com
Subject: [kvm-unit-tests PATCH v2 1/3] lib: s390x: hw: rework do_detect_host so we don't need allocation
Date: Tue, 31 Oct 2023 09:55:17 +0000
Message-Id: <20231031095519.73311-2-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231031095519.73311-1-frankja@linux.ibm.com>
References: <20231031095519.73311-1-frankja@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: oq5WgUOJl37xbdKdnh3G9YKrbVHEed80
X-Proofpoint-ORIG-GUID: EzX9Uspy5PqWLOp_vJjzO2IOgWmTlH6o
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-30_13,2023-10-31_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 mlxlogscore=999 suspectscore=0 phishscore=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 malwarescore=0 clxscore=1015 adultscore=0
 priorityscore=1501 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2310240000 definitions=main-2310310077

The current implementation needs to allocate a page for stsi 1.1.1 and
3.2.2. As such it's not usable before the allocator is set
up.

Unfortunately we might end up with detect_host calls before the
allocator setup is done. For example in the SCLP console setup code.

Let's allocate the stsi storage on the stack to solve that problem.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/hardware.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/lib/s390x/hardware.c b/lib/s390x/hardware.c
index 2bcf9c4c..21752562 100644
--- a/lib/s390x/hardware.c
+++ b/lib/s390x/hardware.c
@@ -13,6 +13,7 @@
 #include <libcflat.h>
 #include <alloc_page.h>
 #include <asm/arch_def.h>
+#include <asm/page.h>
 #include "hardware.h"
 #include "stsi.h"
 
@@ -21,9 +22,10 @@ static const uint8_t qemu_ebcdic[] = { 0xd8, 0xc5, 0xd4, 0xe4 };
 /* The string "KVM/" in EBCDIC */
 static const uint8_t kvm_ebcdic[] = { 0xd2, 0xe5, 0xd4, 0x61 };
 
-static enum s390_host do_detect_host(void *buf)
+static enum s390_host do_detect_host(void)
 {
-	struct sysinfo_3_2_2 *stsi_322 = buf;
+	uint8_t buf[PAGE_SIZE] __attribute__((aligned(PAGE_SIZE)));
+	struct sysinfo_3_2_2 *stsi_322 = (struct sysinfo_3_2_2 *)buf;
 
 	if (stsi_get_fc() == 2)
 		return HOST_IS_LPAR;
@@ -56,14 +58,11 @@ enum s390_host detect_host(void)
 {
 	static enum s390_host host = HOST_IS_UNKNOWN;
 	static bool initialized = false;
-	void *buf;
 
 	if (initialized)
 		return host;
 
-	buf = alloc_page();
-	host = do_detect_host(buf);
-	free_page(buf);
+	host = do_detect_host();
 	initialized = true;
 	return host;
 }
-- 
2.34.1


