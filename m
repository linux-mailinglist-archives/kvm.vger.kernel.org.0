Return-Path: <kvm+bounces-798-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C7A367E2A08
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 17:38:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5904CB214A4
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 16:38:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C10929D07;
	Mon,  6 Nov 2023 16:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="PHjZI8nF"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8ECD2942E
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 16:37:49 +0000 (UTC)
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8218510F1;
	Mon,  6 Nov 2023 08:37:46 -0800 (PST)
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6GFVhx031385;
	Mon, 6 Nov 2023 16:37:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=OCnQ6/UdfLYgQNTnUJz7NQHRlus7/ag9953tw14co0I=;
 b=PHjZI8nFlMq82c+u3B2yN2eZfZTT3Ospms5qRMEHMD8n9UNoz7CSx92DN7eYMI86dYGd
 Q5wfpR0Z3XQXz3EVIQ3mlOVHvLB4ntcyEzzGXx3bEoEPvWLjg3unIq8GkzRabo/rU1X4
 UouYMlutWB/N+N0iaWHCVkVNBM5COJk9GyB/ieuKFfBWPcu+nxg8RJ3j3Okr6jkpuyer
 redjpr5NveT7jiDyWzdLHeOfNSAaVqkxs84dVYQXkds38bmHgcDI1+LCs5vVd6a8lQDI
 AYXKmCV+bTZ38BCUz9RdVOVAI2w1Q9l2Y2gVsaabby6X0EZIf4/c4Z3aTgLuRGAw6O4K Sw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u73gh8rvt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Nov 2023 16:37:45 +0000
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3A6GFZlH032012;
	Mon, 6 Nov 2023 16:37:44 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u73gh8rvd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Nov 2023 16:37:44 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6EMvUn008078;
	Mon, 6 Nov 2023 16:37:44 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3u61skafu5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Nov 2023 16:37:44 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3A6GbfAD9699914
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 6 Nov 2023 16:37:41 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 25D9320040;
	Mon,  6 Nov 2023 16:37:41 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D62D920043;
	Mon,  6 Nov 2023 16:37:40 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  6 Nov 2023 16:37:40 +0000 (GMT)
From: Nico Boehr <nrb@linux.ibm.com>
To: frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        hca@linux.ibm.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v8 8/8] lib: s390x: interrupt: remove TEID_ASCE defines
Date: Mon,  6 Nov 2023 17:37:30 +0100
Message-ID: <20231106163738.1116942-9-nrb@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: LAPY1rBsB3hythmOxt-cBTQbuYbkwphk
X-Proofpoint-GUID: itqfF9_xJhgTovifh1FDk0nE_SPsevvl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-06_12,2023-11-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 spamscore=0
 impostorscore=0 malwarescore=0 mlxlogscore=828 bulkscore=0 adultscore=0
 clxscore=1015 lowpriorityscore=0 phishscore=0 mlxscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310240000 definitions=main-2311060134

These defines were - I can only guess - meant for the asce_id field.
Since print_decode_teid() used AS_PRIM and friends instead, I see little
benefit in keeping these around.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/asm/interrupt.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/lib/s390x/asm/interrupt.h b/lib/s390x/asm/interrupt.h
index 39b43b64ea07..61d156d56b37 100644
--- a/lib/s390x/asm/interrupt.h
+++ b/lib/s390x/asm/interrupt.h
@@ -13,11 +13,6 @@
 #define EXT_IRQ_EXTERNAL_CALL	0x1202
 #define EXT_IRQ_SERVICE_SIG	0x2401
 
-#define TEID_ASCE_PRIMARY	0
-#define TEID_ASCE_AR		1
-#define TEID_ASCE_SECONDARY	2
-#define TEID_ASCE_HOME		3
-
 union teid {
 	unsigned long val;
 	union {
-- 
2.41.0


