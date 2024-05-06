Return-Path: <kvm+bounces-16770-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CBC118BD7FA
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 00:56:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 03F771C22EF9
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 22:56:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A44615F326;
	Mon,  6 May 2024 22:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TqzM5GPk"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEE0215EFCA;
	Mon,  6 May 2024 22:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715036011; cv=none; b=Gsx7GrfFrLHL0zXtaCOvOJQnSxZjOZPoW4DuW8It3DfumAt3GnLdBZj9q2epJL40yvw1p57hqokJTxnJo8Z1IylAO9Vzx15u8HK7QS06kObi90665GaDQp5B7abQZgELu0OMxJjkdJNm9UiSG00+c66RFg/l1iPwNmvh1feAQ7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715036011; c=relaxed/simple;
	bh=OO26FdXFEBlagFtETE8C+k5hqlOa3G7JdRW5eT/w6Xg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=uQS74rUVtj3NVFIR+YBUhs++xGVw2PWrpDybbhcxTsF9KMuHK/X9BMDB8Z634WgiFZ7vkF/xMhbZpw3vnfuQrp4/19uK/5Q0qeFiqdDG8EnVAatKIb04QWsvE324wC8gLGQRvcRXtsfhouVHM57m328lEOD357nbt9PBx+r0SJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=TqzM5GPk; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 446MqTZh006875;
	Mon, 6 May 2024 22:53:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-11-20;
 bh=H9IZVi3DWKq501eRNFuQDWwQF55QlP0lPQ2r++Zshwg=;
 b=TqzM5GPkH8MKkNofGT8oZ7zIgb0nM+XArXAVdociuD/qpECgkXzZHACnRo083Jmdkka1
 7cJvuPpYBYaX/T+fUF37nIXNrcxO6FDnSSUWJjvI5FQDWkdeRFoWgdm+lXZyjjR+4Uc5
 c9VgZGPn78n+hMj2kAiRbmGeti9uJGadvkEhpWnF5hzZR/WhmMi8qBB6Pvjvhk0HqYN4
 uaUEY3T0YHD+oqi8fe+xHGtl86XgYEPDARohSujprJfRB9D3wX9FoUerFeIGp4lquNtA
 33wVNomaBuqxqs0nRPHCMvvpue3sKHylDA3ZKyQSvMxR757UqgN+/yxnIIoIIYUmaSes Sw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xwbm5ks55-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 06 May 2024 22:53:24 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 446LsjOD027579;
	Mon, 6 May 2024 22:53:23 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3xwbfdg8p0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 06 May 2024 22:53:23 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 446MrMxE006764;
	Mon, 6 May 2024 22:53:22 GMT
Received: from alaljime-dev-e4flex-vm.osdevelopmeniad.oraclevcn.com (alaljime-dev-e4flex-vm.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.249.106])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3xwbfdg8mq-3;
	Mon, 06 May 2024 22:53:22 +0000
From: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
To: kvm@vger.kernel.org, seanjc@google.com, vasant.hegde@amd.com
Cc: pbonzini@redhat.com, linux-kernel@vger.kernel.org,
        joao.m.martins@oracle.com, boris.ostrovsky@oracle.com,
        suravee.suthikulpanit@amd.com, mlevitsk@redhat.com,
        alejandro.j.jimenez@oracle.com
Subject: [PATCH v2 2/2] KVM: x86: Keep consistent naming for APICv/AVIC inhibit reasons
Date: Mon,  6 May 2024 22:53:21 +0000
Message-Id: <20240506225321.3440701-3-alejandro.j.jimenez@oracle.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240506225321.3440701-1-alejandro.j.jimenez@oracle.com>
References: <20240506225321.3440701-1-alejandro.j.jimenez@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-06_17,2024-05-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 mlxlogscore=999 suspectscore=0 malwarescore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2404010000
 definitions=main-2405060166
X-Proofpoint-GUID: U9-hmjDCybQjSc_yhM6KDU82HtpzWzFn
X-Proofpoint-ORIG-GUID: U9-hmjDCybQjSc_yhM6KDU82HtpzWzFn

Keep kvm_apicv_inhibit enum naming consistent with the current pattern by
renaming the reason/enumerator defined as APICV_INHIBIT_REASON_DISABLE to
APICV_INHIBIT_REASON_DISABLED.

No functional change intended.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
---
 arch/x86/include/asm/kvm_host.h | 4 ++--
 arch/x86/kvm/svm/svm.h          | 2 +-
 arch/x86/kvm/vmx/main.c         | 2 +-
 arch/x86/kvm/x86.c              | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 08f83efd12ff..8910a8ac23b0 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1203,7 +1203,7 @@ enum kvm_apicv_inhibit {
 	 * APIC acceleration is disabled by a module parameter
 	 * and/or not supported in hardware.
 	 */
-	APICV_INHIBIT_REASON_DISABLE,
+	APICV_INHIBIT_REASON_DISABLED,
 
 	/*
 	 * APIC acceleration is inhibited because AutoEOI feature is
@@ -1281,7 +1281,7 @@ enum kvm_apicv_inhibit {
 	{ BIT(APICV_INHIBIT_REASON_##reason), #reason }
 
 #define APICV_INHIBIT_REASONS				\
-	__APICV_INHIBIT_REASON(DISABLE),		\
+	__APICV_INHIBIT_REASON(DISABLED),		\
 	__APICV_INHIBIT_REASON(HYPERV),			\
 	__APICV_INHIBIT_REASON(ABSENT),			\
 	__APICV_INHIBIT_REASON(BLOCKIRQ),		\
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 323901782547..7ba09aca2342 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -634,7 +634,7 @@ extern struct kvm_x86_nested_ops svm_nested_ops;
 /* avic.c */
 #define AVIC_REQUIRED_APICV_INHIBITS			\
 (							\
-	BIT(APICV_INHIBIT_REASON_DISABLE) |		\
+	BIT(APICV_INHIBIT_REASON_DISABLED) |		\
 	BIT(APICV_INHIBIT_REASON_ABSENT) |		\
 	BIT(APICV_INHIBIT_REASON_HYPERV) |		\
 	BIT(APICV_INHIBIT_REASON_NESTED) |		\
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 7c546ad3e4c9..5418feb17e13 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -7,7 +7,7 @@
 #include "pmu.h"
 
 #define VMX_REQUIRED_APICV_INHIBITS				\
-	(BIT(APICV_INHIBIT_REASON_DISABLE)|			\
+	(BIT(APICV_INHIBIT_REASON_DISABLED) |			\
 	 BIT(APICV_INHIBIT_REASON_ABSENT) |			\
 	 BIT(APICV_INHIBIT_REASON_HYPERV) |			\
 	 BIT(APICV_INHIBIT_REASON_BLOCKIRQ) |			\
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 597ff748f955..9747c3bc52f9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10026,7 +10026,7 @@ static void set_or_clear_apicv_inhibit(unsigned long *inhibits,
 static void kvm_apicv_init(struct kvm *kvm)
 {
 	enum kvm_apicv_inhibit reason = enable_apicv ? APICV_INHIBIT_REASON_ABSENT :
-						       APICV_INHIBIT_REASON_DISABLE;
+						       APICV_INHIBIT_REASON_DISABLED;
 
 	set_or_clear_apicv_inhibit(&kvm->arch.apicv_inhibit_reasons, reason, true);
 
-- 
2.39.3


