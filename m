Return-Path: <kvm+bounces-1462-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D7C27E7CAA
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 14:54:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ECC3528156F
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 13:54:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EEFA1BDDE;
	Fri, 10 Nov 2023 13:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="tXbwREHQ"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A64751A73C
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 13:54:22 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B4FC3821E
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 05:54:21 -0800 (PST)
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3AADkPrr031322;
	Fri, 10 Nov 2023 13:54:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=nwjIEAO+F39T+ygc1Y/Yh+b5+YkSX1vNjbvIno7dAco=;
 b=tXbwREHQZwtvOMLhDrQH3s2qBjdFBs/SBd/LzfzYZxkg7iJYnTWPrlbFvHsT/lqZp1cL
 pRw8ag2HT0oju3OUto7uPhfTetiYBly5zm1skgP5R/3kUam8a0FXrHVOSwOxuDSNi7Yv
 DalkfboSlQar6ezpcv9nsD0oW9OBn7WrGRhQaVkpRVjLMhcfr/jFyVMrLpb7GguRXURC
 TPLOFoLptQOwV94gFxbg0hdLQaaPlsrg/Dl1MuDFccIi6+eHsuGVfcUeGDNojNH7rh4Q
 NqhX3J20LNfH7H34nj7fS8Udr40sEgNDUeTA3bI6sYKt++bTe6xRN93ECfTTLgktw6fK QA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u9mpbaea6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Nov 2023 13:54:14 +0000
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3AADkPMl031266;
	Fri, 10 Nov 2023 13:54:13 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u9mpbae9n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Nov 2023 13:54:13 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3AADeAcA014506;
	Fri, 10 Nov 2023 13:54:12 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3u7w22b7vn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Nov 2023 13:54:12 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3AADs95p46727504
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Nov 2023 13:54:09 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id ECD8C2004E;
	Fri, 10 Nov 2023 13:54:08 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2EF4020043;
	Fri, 10 Nov 2023 13:54:07 +0000 (GMT)
Received: from t14-nrb.ibmuc.com (unknown [9.179.18.113])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 10 Nov 2023 13:54:06 +0000 (GMT)
From: Nico Boehr <nrb@linux.ibm.com>
To: thuth@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests GIT PULL 03/26] lib: s390x: hw: rework do_detect_host so we don't need allocation
Date: Fri, 10 Nov 2023 14:52:12 +0100
Message-ID: <20231110135348.245156-4-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231110135348.245156-1-nrb@linux.ibm.com>
References: <20231110135348.245156-1-nrb@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: QNxXATyVha2hAiLQj3_vI6FohMGOkkpT
X-Proofpoint-ORIG-GUID: xPz0VxXF3Vs5Q4ULJzOdgd3NrozDh15B
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
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 mlxlogscore=999 clxscore=1015 lowpriorityscore=0 malwarescore=0
 bulkscore=0 phishscore=0 suspectscore=0 priorityscore=1501 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311100114

From: Janosch Frank <frankja@linux.ibm.com>

The current implementation needs to allocate a page for stsi 1.1.1 and
3.2.2. As such it's not usable before the allocator is set
up.

Unfortunately we might end up with detect_host calls before the
allocator setup is done. For example in the SCLP console setup code.

Let's allocate the stsi storage on the stack to solve that problem.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Link: https://lore.kernel.org/r/20231031095519.73311-2-frankja@linux.ibm.com
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 lib/s390x/hardware.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/lib/s390x/hardware.c b/lib/s390x/hardware.c
index 2bcf9c4..2175256 100644
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
2.41.0


