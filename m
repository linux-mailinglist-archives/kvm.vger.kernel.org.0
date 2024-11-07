Return-Path: <kvm+bounces-31130-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2195F9C0A01
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 16:23:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 713151C221A1
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 15:23:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8291213ED8;
	Thu,  7 Nov 2024 15:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="DvJzWNsp"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AAFC212D31;
	Thu,  7 Nov 2024 15:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730993021; cv=none; b=NyDE2IutniicB5Xk5nHb7t1T6LkROv9ATkEpbCA7/NVSeRLM9SqKfiIrGq4CSlVfK8jH4flR/u0BU8WmsdaTzAJNmpFFgcrEOWGqDVNkthPIrVSc+H6ND//7PRUAz+Hr4rmey2hfWSdhF3QLkYHUWc8uNpwu9pBiWDxmW6EaspY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730993021; c=relaxed/simple;
	bh=y4X9nMngUkz0tiS2keBTzLxiUP5KGzcYzzpdZyl9xf4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QT7MyM4uB1OvE/d7bPhvNpnpTkhRmwUIeXiy6+g1xLdR6kB8jvMERGJ262TT98pvpa168L/CcUWMDTJnyfK1aDEuERBTjdKIfB03C9CALUTuG5QbvY0PIJP5oWOqxhjjDLA2jyGzExOCI5y9axCpc0OjZS+xeCpDyj3CKlQfM4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=DvJzWNsp; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4A7FALGn015298;
	Thu, 7 Nov 2024 15:23:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=nx9zxen3i95cfQyC5
	dV6JNorzBWqLiQQ71P9JtAMBaA=; b=DvJzWNspS/LKrgXPtEC7xlW94t8a0X6WW
	nc518qJBr/oSJGNTE5I1DNyLdCdv74mJwb6Yb2MY9MNPgLC9IRhtMNe/bOsTccnW
	8CpI0xPuQRmQw85mxEbQ/xodhNGTSeSLUUhb13gQXeV6NO6PqNaM4Vlhqul9G7Ib
	4AS+wZtM47aIJ9Q45KZSOxmW3ASkDJZLAihCD0UJwUJ7B/XRYTxiaa0qDS3/nR5D
	K/sXD+K59K3EFXUqjSv63dSrSW3WzIiyrxSvouhsUpfrxU+2Pw8YlZeRjhnVq5VF
	yKPizRsXVDmZJt01yc84UKTSRk5zHT0rGaskg0Z5wKxVExN+5VY/A==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42ryy002dm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 07 Nov 2024 15:23:37 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4A7CgCE6024200;
	Thu, 7 Nov 2024 15:23:37 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 42nxds8fp3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 07 Nov 2024 15:23:36 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4A7FNXsQ45089256
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 7 Nov 2024 15:23:33 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A21C120040;
	Thu,  7 Nov 2024 15:23:33 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 74C6B2004D;
	Thu,  7 Nov 2024 15:23:33 +0000 (GMT)
Received: from vela.boeblingen.de.ibm.com (unknown [9.155.210.79])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  7 Nov 2024 15:23:33 +0000 (GMT)
From: Hendrik Brueckner <brueckner@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, imbrenda@linux.ibm.com, thuth@redhat.com,
        david@redhat.com, borntraeger@linux.ibm.com, frankja@linux.ibm.com
Subject: [PATCH 3/4] KVM: s390: add gen17 facilities to CPU model
Date: Thu,  7 Nov 2024 16:23:18 +0100
Message-ID: <20241107152319.77816-4-brueckner@linux.ibm.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241107152319.77816-1-brueckner@linux.ibm.com>
References: <20241107152319.77816-1-brueckner@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: euomUaWUxEsJp6oxIS_pWszC4qTCzxVr
X-Proofpoint-ORIG-GUID: euomUaWUxEsJp6oxIS_pWszC4qTCzxVr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 suspectscore=0
 spamscore=0 malwarescore=0 phishscore=0 clxscore=1011 impostorscore=0
 lowpriorityscore=0 priorityscore=1501 mlxscore=0 mlxlogscore=808
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2411070117

Add gen17 facilities and let KVM_CAP_S390_VECTOR_REGISTERS handle
the enablement of the vector extension facilities.

Signed-off-by: Hendrik Brueckner <brueckner@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
---
 arch/s390/kvm/kvm-s390.c         | 8 ++++++++
 arch/s390/tools/gen_facilities.c | 1 +
 2 files changed, 9 insertions(+)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 6efa812ca592..14d72749b000 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -812,6 +812,14 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
 				set_kvm_facility(kvm->arch.model.fac_mask, 192);
 				set_kvm_facility(kvm->arch.model.fac_list, 192);
 			}
+			if (test_facility(198)) {
+				set_kvm_facility(kvm->arch.model.fac_mask, 198);
+				set_kvm_facility(kvm->arch.model.fac_list, 198);
+			}
+			if (test_facility(199)) {
+				set_kvm_facility(kvm->arch.model.fac_mask, 199);
+				set_kvm_facility(kvm->arch.model.fac_list, 199);
+			}
 			r = 0;
 		} else
 			r = -EINVAL;
diff --git a/arch/s390/tools/gen_facilities.c b/arch/s390/tools/gen_facilities.c
index e97b4faaf222..d5c68ade71ab 100644
--- a/arch/s390/tools/gen_facilities.c
+++ b/arch/s390/tools/gen_facilities.c
@@ -112,6 +112,7 @@ static struct facility_def facility_defs[] = {
 			15, /* AP Facilities Test */
 			156, /* etoken facility */
 			165, /* nnpa facility */
+			170, /* ineffective-nonconstrained-transaction facility */
 			193, /* bear enhancement facility */
 			194, /* rdp enhancement facility */
 			196, /* processor activity instrumentation facility */
-- 
2.43.5


