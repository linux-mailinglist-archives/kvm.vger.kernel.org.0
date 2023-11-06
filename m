Return-Path: <kvm+bounces-741-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 17B5F7E2271
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 13:54:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9708DB20FF6
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 12:54:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A13CD208C0;
	Mon,  6 Nov 2023 12:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="K1KKdage"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77D521D55E
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 12:54:08 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEB76BD;
	Mon,  6 Nov 2023 04:54:06 -0800 (PST)
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6CRvPx027788;
	Mon, 6 Nov 2023 12:53:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=0sYlfLyrmvZzEkFloIJ3pPfbSx8/J/LK0wUMN6Jl7lk=;
 b=K1KKdagecEofGuvrNaFX72hbQ5B8pks+3Z5A5F4kASiYF43wh4CphhjQhFIxxbmbAit6
 IOgITzHvGFWrTz21rQVg71vfvY+fDhIPOh01Qp9eHwDis6iicBIlggd4fEjm1dqNTw1F
 PzHe7F5BkKG9YoFLTUzkg8MDKpO3roAIjodVntEgIm1ntIsKzc9CsoZ9qGBh2PE9/oYS
 tj94/B5KFRck/x3SPVmZfdrkNQ9ftBx3jZEO54PfjMl8Uq752eSVJNhT3VSif0ZDbKBI
 oR+ABFlxP2phatRFAn1Cy/olsCltYcJHrnzKsfZge/8qgYyMzoR4GKxr5n+VuBuMO3IB FA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u705rgm3m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Nov 2023 12:53:57 +0000
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3A6Cqd3R010896;
	Mon, 6 Nov 2023 12:53:57 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u705rgm2r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Nov 2023 12:53:57 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6A0NKx016964;
	Mon, 6 Nov 2023 12:53:56 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3u6301gqps-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Nov 2023 12:53:56 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3A6Crrum30998962
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 6 Nov 2023 12:53:53 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4521720040;
	Mon,  6 Nov 2023 12:53:53 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0D81720049;
	Mon,  6 Nov 2023 12:53:53 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  6 Nov 2023 12:53:52 +0000 (GMT)
From: Nico Boehr <nrb@linux.ibm.com>
To: frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        david@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev,
        lvivier@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v1 02/10] powerpc: properly format non-kernel-doc comments
Date: Mon,  6 Nov 2023 13:50:58 +0100
Message-ID: <20231106125352.859992-3-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231106125352.859992-1-nrb@linux.ibm.com>
References: <20231106125352.859992-1-nrb@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: _HdtDSTomgH9PHW3RRGDSGVyRAYUAHd2
X-Proofpoint-ORIG-GUID: 60GWSYiP8wR6yZetBP3imh8gFztj9ly0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-06_11,2023-11-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 malwarescore=0
 impostorscore=0 lowpriorityscore=0 priorityscore=1501 mlxscore=0
 spamscore=0 mlxlogscore=999 clxscore=1015 phishscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310240000 definitions=main-2311060104

These comments do not follow the kernel-doc style, hence they should not
start with /**.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 powerpc/emulator.c    | 2 +-
 powerpc/spapr_hcall.c | 6 +++---
 powerpc/spapr_vpa.c   | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/powerpc/emulator.c b/powerpc/emulator.c
index 65ae4b65e655..39dd59645368 100644
--- a/powerpc/emulator.c
+++ b/powerpc/emulator.c
@@ -71,7 +71,7 @@ static void test_64bit(void)
 	report_prefix_pop();
 }
 
-/**
+/*
  * Test 'Load String Word Immediate' instruction
  */
 static void test_lswi(void)
diff --git a/powerpc/spapr_hcall.c b/powerpc/spapr_hcall.c
index 0d0f25afe9f6..e9b5300a3912 100644
--- a/powerpc/spapr_hcall.c
+++ b/powerpc/spapr_hcall.c
@@ -16,7 +16,7 @@
 #define H_ZERO_PAGE	(1UL << (63-48))
 #define H_COPY_PAGE	(1UL << (63-49))
 
-/**
+/*
  * Test the H_SET_SPRG0 h-call by setting some values and checking whether
  * the SPRG0 register contains the correct values afterwards
  */
@@ -46,7 +46,7 @@ static void test_h_set_sprg0(int argc, char **argv)
 	       sprg0_orig);
 }
 
-/**
+/*
  * Test the H_PAGE_INIT h-call by using it to clear and to copy a page, and
  * by checking for the correct values in the destination page afterwards
  */
@@ -97,7 +97,7 @@ static int h_random(uint64_t *val)
 	return r3;
 }
 
-/**
+/*
  * Test H_RANDOM by calling it a couple of times to check whether all bit
  * positions really toggle (there should be no "stuck" bits in the output)
  */
diff --git a/powerpc/spapr_vpa.c b/powerpc/spapr_vpa.c
index 5586eb8d3341..6a3fe5e3f974 100644
--- a/powerpc/spapr_vpa.c
+++ b/powerpc/spapr_vpa.c
@@ -53,7 +53,7 @@ static void print_vpa(struct vpa *vpa)
 #define SUBFUNC_REGISTER	(1ULL << 45)
 #define SUBFUNC_DEREGISTER	(5ULL << 45)
 
-/**
+/*
  * Test the H_REGISTER_VPA h-call register/deregister calls.
  */
 static void test_register_vpa(void)
@@ -111,7 +111,7 @@ static void test_register_vpa(void)
 	report_prefix_pop();
 }
 
-/**
+/*
  * Test some VPA fields.
  */
 static void test_vpa(void)
-- 
2.41.0


