Return-Path: <kvm+bounces-34793-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DB25BA06001
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 16:24:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D71791886C8E
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 15:24:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 809DB1FECDB;
	Wed,  8 Jan 2025 15:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="TtPLsisV"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CD3B1FDE2E;
	Wed,  8 Jan 2025 15:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736349840; cv=none; b=cYQLNkfG0ld8T+tLjtTEnOHLVec4c1mtniK4qNDaGMaTQgC4CZgLbT9Dqtg5TcLGvHWHUN99Wt3uuaYdQ3GDVj1a1uNtmVKikPxmiEzDgIKEpa2XKFnm4Wb2XMENsS+PTLwxmWaz7Q3cuCxY7VoY4qgWuv0n59uRbX0EILLqJRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736349840; c=relaxed/simple;
	bh=69VnNoJaGD/GItLWdLMsSQE1u38sIvDmMEFDkxhQJzU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZQquqdcsh6jNOhUWhdWuPb0dRiUl3rRWoydyJ732MB4cjpVKBvvyfvgtBBanfnV+TnZtuDc1RauZaZugvFirsl+AvRtKRRGO09KNlQ4uU36Pv1TQxRUxzYdRkQKaT5myOjOjDOtr6d9NEMFfimuBO9ztQPBxWG1fjISD6HbE5Is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=TtPLsisV; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 508DnIxt015803;
	Wed, 8 Jan 2025 15:23:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=PMizD0ef2pkzdNP//
	d29BRjsMZxgAQwScYuOQ67B6jw=; b=TtPLsisV554CESdqYWnVe9ofJEsY2/zUR
	3qfyxtFCgmBcZnx4Z0cbtXEk2RsUBKB19JGjx2ZnmY6d5iDC2Q6kqiEeiCw95bjP
	lQNC7/LQ2280MOdbBq5FTfpVv2/jsTebhy+BGmPCzho7n7UQEyyPwMGrQuOQQlkn
	emw8wQj3o+FygnDXPV23yrrUTDyqHxh/BhIRAWZ0wdP04h1w8Fj4fMapNE82L9tv
	YUFmxn8bXIFMJvSYXd+gEtubllhF02Ln4Xm13NUVae/88diG00WrLa8wTEsScWgH
	e4sMSbHNeg545ZAD1MIWd8jGbiLpT9gJpMAxcaB28DFDomHl0N67w==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 441huc31j6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Jan 2025 15:23:56 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 508EPdrO027976;
	Wed, 8 Jan 2025 15:23:55 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 43yhhk848e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Jan 2025 15:23:55 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 508FNp8M32244412
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 8 Jan 2025 15:23:51 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8EA9220043;
	Wed,  8 Jan 2025 15:23:51 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 703B82004F;
	Wed,  8 Jan 2025 15:23:51 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  8 Jan 2025 15:23:51 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, david@redhat.com
Subject: [GIT PULL v1 6/6] KVM: s390: selftests: Add has device attr check to uc_attr_mem_limit selftest
Date: Wed,  8 Jan 2025 16:23:50 +0100
Message-ID: <20250108152350.48892-7-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250108152350.48892-1-imbrenda@linux.ibm.com>
References: <20250108152350.48892-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: vgSJ1KWtWoyB75iTE3JG6Ol9GG1AVKF8
X-Proofpoint-GUID: vgSJ1KWtWoyB75iTE3JG6Ol9GG1AVKF8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 spamscore=0 phishscore=0 suspectscore=0 lowpriorityscore=0 mlxlogscore=974
 bulkscore=0 mlxscore=0 malwarescore=0 adultscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2411120000
 definitions=main-2501080125

From: Christoph Schlameuss <schlameuss@linux.ibm.com>

Fixup the uc_attr_mem_limit test case to also cover the
KVM_HAS_DEVICE_ATTR ioctl.

Signed-off-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
Tested-by: Hariharan Mari <hari55@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Link: https://lore.kernel.org/r/20241216092140.329196-7-schlameuss@linux.ibm.com
Message-ID: <20241216092140.329196-7-schlameuss@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 tools/testing/selftests/kvm/s390x/ucontrol_test.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/s390x/ucontrol_test.c b/tools/testing/selftests/kvm/s390x/ucontrol_test.c
index 8f306395696e..135ee22856cf 100644
--- a/tools/testing/selftests/kvm/s390x/ucontrol_test.c
+++ b/tools/testing/selftests/kvm/s390x/ucontrol_test.c
@@ -210,10 +210,13 @@ TEST_F(uc_kvm, uc_attr_mem_limit)
 	struct kvm_device_attr attr = {
 		.group = KVM_S390_VM_MEM_CTRL,
 		.attr = KVM_S390_VM_MEM_LIMIT_SIZE,
-		.addr = (unsigned long)&limit,
+		.addr = (u64)&limit,
 	};
 	int rc;
 
+	rc = ioctl(self->vm_fd, KVM_HAS_DEVICE_ATTR, &attr);
+	EXPECT_EQ(0, rc);
+
 	rc = ioctl(self->vm_fd, KVM_GET_DEVICE_ATTR, &attr);
 	EXPECT_EQ(0, rc);
 	EXPECT_EQ(~0UL, limit);
-- 
2.47.1


