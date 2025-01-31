Return-Path: <kvm+bounces-36994-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A3F31A23D20
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2025 12:30:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EA3C57A4B5C
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2025 11:29:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB69E1C462D;
	Fri, 31 Jan 2025 11:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="MP+QKVvg"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 860311C07DB;
	Fri, 31 Jan 2025 11:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738322747; cv=none; b=lVV6l1LHqTieaE3IKZ7ouAQQkJHd/g1P+phTow3gSllr4EibG2Qfc41w5MjcBeCu/HoGJrvCk+2Bbo7KTLFrVMkNyu8+04zldd4JsODw8t4mAFE4FCPICdsrDBnDGiybIlLQ1VmO7669wuUVoEkqS5BuPJljRI7fsxPRtV8/dks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738322747; c=relaxed/simple;
	bh=Tm5yoTT5bQSaPlXmP71PXDTDC1SM1eJs7+Ig1825A08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nyamQbvxGnjxipjmleuLYlfnmWtq29T9sTVWFsDPOEHW2ug23rpy1OtZ7sgcEZKqjhWEoBQLVGeFTjrXAbKHKiy/k1L13uPrfYF4L4gVPzVWgNEWr8LOj1KVTmZ09POUoeQ/m8wDngiPk4R4qYIVU64MgKKLkSnji/olvx+zTVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=MP+QKVvg; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50V2OCi4014643;
	Fri, 31 Jan 2025 11:25:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=VmN3nvdAgnv/4lbjJ
	KfSAgFyvI659GLqZraGOKNFYqQ=; b=MP+QKVvgEaPE33rUAlkB67cIJX08drB4W
	D4ib/Et6PwoUcd+GsunBNwaIjjT0UsBjx1V94zgZmTZu2xiVeVKEUFTcMbztF48P
	zpcfNMTag/U9WCn7+Y2cx6cUZHcd7OD1vzRob4hEqUTT4MM7KXLsgSPp1jAfln0X
	b/mZAbTph9/PYg2Oihx2OzNthLRgwQ+CUr35lVidBzB2sXGM4A9oxDZ0t4UFXCYv
	W4+pSk08OC7hNyFwpmfvw72rqhNDa6FoKg/urFPOd7UP234a1w0yz3vYkKXpaqjL
	jcHCy9HbAP3J/tOvi7m32sdTpCUnsEiMr6yJQ9Y9J0DPZXZvdideQ==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44gfn4ued3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 31 Jan 2025 11:25:42 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50V8Awsk013864;
	Fri, 31 Jan 2025 11:25:41 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 44gf93b9gs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 31 Jan 2025 11:25:41 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50VBPcOK42402110
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 31 Jan 2025 11:25:38 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 10AEE20136;
	Fri, 31 Jan 2025 11:25:38 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B742B20135;
	Fri, 31 Jan 2025 11:25:37 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.171.25.38])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 31 Jan 2025 11:25:37 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, david@redhat.com
Subject: [GIT PULL v2 20/20] KVM: s390: selftests: Streamline uc_skey test to issue iske after sske
Date: Fri, 31 Jan 2025 12:25:10 +0100
Message-ID: <20250131112510.48531-21-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250131112510.48531-1-imbrenda@linux.ibm.com>
References: <20250131112510.48531-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: lYGi5rqFyaIP-jYAY4FbqJzUsjip8Fvw
X-Proofpoint-ORIG-GUID: lYGi5rqFyaIP-jYAY4FbqJzUsjip8Fvw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-31_04,2025-01-31_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 clxscore=1015 impostorscore=0 mlxlogscore=999 malwarescore=0
 phishscore=0 lowpriorityscore=0 bulkscore=0 suspectscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2501170000 definitions=main-2501310083

From: Christoph Schlameuss <schlameuss@linux.ibm.com>

In some rare situations a non default storage key is already set on the
memory used by the test. Within normal VMs the key is reset / zapped
when the memory is added to the VM. This is not the case for ucontrol
VMs. With the initial iske check removed this test case can work in all
situations. The function of the iske instruction is still validated by
the remaining code.

Fixes: 0185fbc6a2d3 ("KVM: s390: selftests: Add uc_skey VM test case")
Signed-off-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
Link: https://lore.kernel.org/r/20250128131803.1047388-1-schlameuss@linux.ibm.com
Message-ID: <20250128131803.1047388-1-schlameuss@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 .../selftests/kvm/s390/ucontrol_test.c        | 24 +++++--------------
 1 file changed, 6 insertions(+), 18 deletions(-)

diff --git a/tools/testing/selftests/kvm/s390/ucontrol_test.c b/tools/testing/selftests/kvm/s390/ucontrol_test.c
index 22ce9219620c..d265b34c54be 100644
--- a/tools/testing/selftests/kvm/s390/ucontrol_test.c
+++ b/tools/testing/selftests/kvm/s390/ucontrol_test.c
@@ -88,10 +88,6 @@ asm("test_skey_asm:\n"
 	"	ahi	%r0,1\n"
 	"	st	%r1,0(%r5,%r6)\n"
 
-	"	iske	%r1,%r6\n"
-	"	ahi	%r0,1\n"
-	"	diag	0,0,0x44\n"
-
 	"	sske	%r1,%r6\n"
 	"	xgr	%r1,%r1\n"
 	"	iske	%r1,%r6\n"
@@ -600,7 +596,9 @@ TEST_F(uc_kvm, uc_skey)
 	ASSERT_EQ(true, uc_handle_exit(self));
 	ASSERT_EQ(1, sync_regs->gprs[0]);
 
-	/* ISKE */
+	/* SSKE + ISKE */
+	sync_regs->gprs[1] = skeyvalue;
+	run->kvm_dirty_regs |= KVM_SYNC_GPRS;
 	ASSERT_EQ(0, uc_run_once(self));
 
 	/*
@@ -612,21 +610,11 @@ TEST_F(uc_kvm, uc_skey)
 	TEST_ASSERT_EQ(0, sie_block->ictl & (ICTL_ISKE | ICTL_SSKE | ICTL_RRBE));
 	TEST_ASSERT_EQ(KVM_EXIT_S390_SIEIC, self->run->exit_reason);
 	TEST_ASSERT_EQ(ICPT_INST, sie_block->icptcode);
-	TEST_REQUIRE(sie_block->ipa != 0xb229);
+	TEST_REQUIRE(sie_block->ipa != 0xb22b);
 
-	/* ISKE contd. */
+	/* SSKE + ISKE contd. */
 	ASSERT_EQ(false, uc_handle_exit(self));
 	ASSERT_EQ(2, sync_regs->gprs[0]);
-	/* assert initial skey (ACC = 0, R & C = 1) */
-	ASSERT_EQ(0x06, sync_regs->gprs[1]);
-	uc_assert_diag44(self);
-
-	/* SSKE + ISKE */
-	sync_regs->gprs[1] = skeyvalue;
-	run->kvm_dirty_regs |= KVM_SYNC_GPRS;
-	ASSERT_EQ(0, uc_run_once(self));
-	ASSERT_EQ(false, uc_handle_exit(self));
-	ASSERT_EQ(3, sync_regs->gprs[0]);
 	ASSERT_EQ(skeyvalue, sync_regs->gprs[1]);
 	uc_assert_diag44(self);
 
@@ -635,7 +623,7 @@ TEST_F(uc_kvm, uc_skey)
 	run->kvm_dirty_regs |= KVM_SYNC_GPRS;
 	ASSERT_EQ(0, uc_run_once(self));
 	ASSERT_EQ(false, uc_handle_exit(self));
-	ASSERT_EQ(4, sync_regs->gprs[0]);
+	ASSERT_EQ(3, sync_regs->gprs[0]);
 	/* assert R reset but rest of skey unchanged */
 	ASSERT_EQ(skeyvalue & 0xfa, sync_regs->gprs[1]);
 	ASSERT_EQ(0, sync_regs->gprs[1] & 0x04);
-- 
2.48.1


