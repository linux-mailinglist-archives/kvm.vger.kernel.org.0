Return-Path: <kvm+bounces-31634-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D7B889C5D28
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 17:27:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 90B611F257BA
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 16:27:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8841206944;
	Tue, 12 Nov 2024 16:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="CX+5sILk"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD6B4206063;
	Tue, 12 Nov 2024 16:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731428780; cv=none; b=SA5LU2x1iaTNHpJE854VorJ2+bjhAOjbFfk85T5CO9fkKVfWenuiNjmz/HPHDV9dt/WEFsDW+wTYv4W5DxiaCUPQmCShSqHMK+pW383cGe5UBibCMTCsxjJjDIqYFCIpZZwGfWW3Iw+i0G7IjKhQR5EwE50doUgL33veGDFh4W8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731428780; c=relaxed/simple;
	bh=F6z1uTF4rh00blzR65zz5BM+aeXPneF03Lx0DBzxsmw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OLWt78jHFsmF22X/FoA/rO+XrfTwrUKIH+vGtU36/1FtTJyK9wElVqCFnLqbbk/Q60JpCqZ9nixvHMo/6NHUMWK6PVEGNVkQNo7koFhmX0odOasYaCaWsY7XHAHCttmZ3JU++xaIcJKIpNpG9BY6v7aNx/JyssBAy2FTBxQ8nQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=CX+5sILk; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4ACEZFeC007961;
	Tue, 12 Nov 2024 16:26:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=3jYxncapvVAoonHOi
	aNhazb+Z6IKX7fJOnWF3/wvxfA=; b=CX+5sILkHNnGXhxgI8SkrKOatlA6O4Yw5
	Q7ANBtRVhS+NtZqtY+4k6d3x3EBWHqgU3iHghcUlebPdiXRzE0UdvQ03xDN6xoXR
	vIhXUuL2YH1GSjTuZqIaBpRHijdzZ1bOChwIsigZauurvPU+zRd+QNdbaQEAFfSL
	eq2DLR333SHiwXHhARqDojyIDNmsGdQSQUVXOFHFU8C7BBl8Vra0xKBmmjDTMsFb
	OiOjSL34ACUW9hL3f5W5KZToDoScCyo/n0eI4ggke1/bBLVUevPtyqb14lFMV3D+
	VysnoBm95p/oj8CgPzxxqUC6X6svV0wH4FTi3SxykrCs9RKV6L/YA==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42v8wmghme-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 12 Nov 2024 16:26:15 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4AC63bkv007703;
	Tue, 12 Nov 2024 16:26:14 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 42tm9jcene-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 12 Nov 2024 16:26:14 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4ACGQBOM35390026
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 12 Nov 2024 16:26:11 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1385020040;
	Tue, 12 Nov 2024 16:26:11 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9B6EC2004B;
	Tue, 12 Nov 2024 16:26:10 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.fritz.box (unknown [9.179.25.251])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 12 Nov 2024 16:26:10 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com, hca@linux.ibm.com,
        Christoph Schlameuss <schlameuss@linux.ibm.com>
Subject: [GIT PULL 09/14] KVM: s390: selftests: Fix whitespace confusion in ucontrol test
Date: Tue, 12 Nov 2024 17:23:23 +0100
Message-ID: <20241112162536.144980-10-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112162536.144980-1-frankja@linux.ibm.com>
References: <20241112162536.144980-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: x4aZF_-MeawQ3b3I_cu1wCwZC-0fTX13
X-Proofpoint-GUID: x4aZF_-MeawQ3b3I_cu1wCwZC-0fTX13
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 spamscore=0
 lowpriorityscore=0 adultscore=0 mlxlogscore=902 impostorscore=0
 clxscore=1015 bulkscore=0 mlxscore=0 priorityscore=1501 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2411120125

From: Christoph Schlameuss <schlameuss@linux.ibm.com>

Checkpatch thinks that we're doing a multiplication but we're obviously
not. Fix 4 instances where we adhered to wrong checkpatch advice.

Signed-off-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Link: https://lore.kernel.org/r/20241107141024.238916-5-schlameuss@linux.ibm.com
[frankja@linux.ibm.com: Fixed patch prefix]
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Message-ID: <20241107141024.238916-5-schlameuss@linux.ibm.com>
---
 tools/testing/selftests/kvm/s390x/ucontrol_test.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/s390x/ucontrol_test.c b/tools/testing/selftests/kvm/s390x/ucontrol_test.c
index adc72ae80e8f..690077f2c41d 100644
--- a/tools/testing/selftests/kvm/s390x/ucontrol_test.c
+++ b/tools/testing/selftests/kvm/s390x/ucontrol_test.c
@@ -370,7 +370,7 @@ static bool uc_handle_insn_ic(FIXTURE_DATA(uc_kvm) *self)
  * * fail on codes not expected in the test cases
  * Returns if interception is handled / execution can be continued
  */
-static bool uc_handle_sieic(FIXTURE_DATA(uc_kvm) * self)
+static bool uc_handle_sieic(FIXTURE_DATA(uc_kvm) *self)
 {
 	struct kvm_s390_sie_block *sie_block = self->sie_block;
 	struct kvm_run *run = self->run;
@@ -398,7 +398,7 @@ static bool uc_handle_sieic(FIXTURE_DATA(uc_kvm) * self)
 }
 
 /* verify VM state on exit */
-static bool uc_handle_exit(FIXTURE_DATA(uc_kvm) * self)
+static bool uc_handle_exit(FIXTURE_DATA(uc_kvm) *self)
 {
 	struct kvm_run *run = self->run;
 
@@ -418,7 +418,7 @@ static bool uc_handle_exit(FIXTURE_DATA(uc_kvm) * self)
 }
 
 /* run the VM until interrupted */
-static int uc_run_once(FIXTURE_DATA(uc_kvm) * self)
+static int uc_run_once(FIXTURE_DATA(uc_kvm) *self)
 {
 	int rc;
 
@@ -429,7 +429,7 @@ static int uc_run_once(FIXTURE_DATA(uc_kvm) * self)
 	return rc;
 }
 
-static void uc_assert_diag44(FIXTURE_DATA(uc_kvm) * self)
+static void uc_assert_diag44(FIXTURE_DATA(uc_kvm) *self)
 {
 	struct kvm_s390_sie_block *sie_block = self->sie_block;
 
-- 
2.47.0


