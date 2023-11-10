Return-Path: <kvm+bounces-1478-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 42F8B7E7CBD
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 14:56:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 411EB1C20A83
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 13:56:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 980F11C2BB;
	Fri, 10 Nov 2023 13:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="lfzFjCWA"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A292374E5
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 13:54:46 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A5523821E
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 05:54:43 -0800 (PST)
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3AADkVhO017037;
	Fri, 10 Nov 2023 13:54:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=Mn5hVjoQICUNPX7+/vMpRauU1BHCYda+hVI8xOd0/Bc=;
 b=lfzFjCWAAQZPL7om+UkkVLZslMLidYoqmWQBH2AEKuILBKNfr4lQ59V9a+tUN9y8k+K3
 /IOF925AJyRJhuMVZ8e5f3G7ZUVX89Au9hR8vVIhrM3UbKTrdD39v4y3fWswAAWaf2Wj
 jISadu0syYAZS4ch7to4ICmGC9X7jmKS0OicW7f6WH53ehcH7lDQ9gwC6F+a8crToP32
 FZ+uyrgq3o3E1xPHith9tUlmGMWQJ5Z+LOrfPCY8kSVjPlw3U8iE6cUbXu9PH/sDJtz+
 UzWYwF8wxmtfVEZmunmXSgG2FFcW3CfF8fuDTWS38ivQPBuhW6Qp2a2wcsEb+bONslDg 9A== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u9n6uhffk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Nov 2023 13:54:41 +0000
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3AADl6og020837;
	Fri, 10 Nov 2023 13:54:40 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u9n6uhff8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Nov 2023 13:54:40 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3AAB6V6t004129;
	Fri, 10 Nov 2023 13:54:39 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3u7w21b79y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Nov 2023 13:54:39 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3AADsbMl45482456
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Nov 2023 13:54:37 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1046B20040;
	Fri, 10 Nov 2023 13:54:37 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AD5F52004B;
	Fri, 10 Nov 2023 13:54:36 +0000 (GMT)
Received: from t14-nrb.ibmuc.com (unknown [9.179.18.113])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 10 Nov 2023 13:54:36 +0000 (GMT)
From: Nico Boehr <nrb@linux.ibm.com>
To: thuth@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests GIT PULL 21/26] s390x: sie: switch to home space mode before entering SIE
Date: Fri, 10 Nov 2023 14:52:30 +0100
Message-ID: <20231110135348.245156-22-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231110135348.245156-1-nrb@linux.ibm.com>
References: <20231110135348.245156-1-nrb@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 5n8lbJwrLQ4QZGtBZHOq0ESidfp6Wxru
X-Proofpoint-ORIG-GUID: j5FajkPnlCchrECGXnQrg0WT-9s2BZCS
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
 suspectscore=0 clxscore=1015 priorityscore=1501 mlxlogscore=999
 spamscore=0 bulkscore=0 malwarescore=0 impostorscore=0 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311100114

This is to prepare for running guests without MSO/MSL, which is
currently not possible.

We already have code in sie64a to setup a guest primary ASCE before
entering SIE, so we can in theory switch to the page tables which
translate gpa to hpa.

But the host is running in primary space mode already, so changing the
primary ASCE before entering SIE will also affect the host's code and
data.

To make this switch useful, the host should run in a different address
space mode. Hence, set up and change to home address space mode before
installing the guest ASCE.

The home space ASCE is just copied over from the primary space ASCE, so
no functional change is intended, also for tests that want to use
MSO/MSL. If a test intends to use a different primary space ASCE, it can
now just set the guest.asce in the save_area.

Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Link: https://lore.kernel.org/r/20231106163738.1116942-4-nrb@linux.ibm.com
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 lib/s390x/asm/arch_def.h |  1 +
 lib/s390x/sie.c          | 26 ++++++++++++++++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
index 5beaf15..745a338 100644
--- a/lib/s390x/asm/arch_def.h
+++ b/lib/s390x/asm/arch_def.h
@@ -92,6 +92,7 @@ enum address_space {
 };
 
 #define PSW_MASK_DAT			0x0400000000000000UL
+#define PSW_MASK_HOME			0x0000C00000000000UL
 #define PSW_MASK_IO			0x0200000000000000UL
 #define PSW_MASK_EXT			0x0100000000000000UL
 #define PSW_MASK_KEY			0x00F0000000000000UL
diff --git a/lib/s390x/sie.c b/lib/s390x/sie.c
index 97a093b..b8ee43e 100644
--- a/lib/s390x/sie.c
+++ b/lib/s390x/sie.c
@@ -54,6 +54,8 @@ void sie_handle_validity(struct vm *vm)
 
 void sie(struct vm *vm)
 {
+	uint64_t old_cr13;
+
 	if (vm->sblk->sdf == 2)
 		memcpy(vm->sblk->pv_grregs, vm->save_area.guest.grs,
 		       sizeof(vm->save_area.guest.grs));
@@ -61,6 +63,24 @@ void sie(struct vm *vm)
 	/* Reset icptcode so we don't trip over it below */
 	vm->sblk->icptcode = 0;
 
+	/*
+	 * Set up home address space to match primary space. Instead of running
+	 * in home space all the time, we switch every time in sie() because:
+	 * - tests that depend on running in primary space mode don't need to be
+	 *   touched
+	 * - it avoids regressions in tests
+	 * - switching every time makes it easier to extend this in the future,
+	 *   for example to allow tests to run in whatever space they want
+	 */
+	old_cr13 = stctg(13);
+	lctlg(13, stctg(1));
+
+	/* switch to home space so guest tables can be different from host */
+	psw_mask_set_bits(PSW_MASK_HOME);
+
+	/* also handle all interruptions in home space while in SIE */
+	irq_set_dat_mode(true, AS_HOME);
+
 	while (vm->sblk->icptcode == 0) {
 		sie64a(vm->sblk, &vm->save_area);
 		sie_handle_validity(vm);
@@ -68,6 +88,12 @@ void sie(struct vm *vm)
 	vm->save_area.guest.grs[14] = vm->sblk->gg14;
 	vm->save_area.guest.grs[15] = vm->sblk->gg15;
 
+	irq_set_dat_mode(true, AS_PRIM);
+	psw_mask_clear_bits(PSW_MASK_HOME);
+
+	/* restore the old CR 13 */
+	lctlg(13, old_cr13);
+
 	if (vm->sblk->sdf == 2)
 		memcpy(vm->save_area.guest.grs, vm->sblk->pv_grregs,
 		       sizeof(vm->save_area.guest.grs));
-- 
2.41.0


