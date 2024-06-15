Return-Path: <kvm+bounces-19734-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C205D9098D6
	for <lists+kvm@lfdr.de>; Sat, 15 Jun 2024 17:20:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7646A1F22295
	for <lists+kvm@lfdr.de>; Sat, 15 Jun 2024 15:20:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F35044965C;
	Sat, 15 Jun 2024 15:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="jgvuDx3j"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F744383B1;
	Sat, 15 Jun 2024 15:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718464799; cv=none; b=K/+9N37pSr3n0hM696iFs95J6LTaDusVGKvnb0Jy3WFQ3Ij3DNCK8/1kiYGBQn3+5kqowkhyfsnI/tP82Y6xYGRbxQ+IuVBXZNWcMhSiMqnMD4ZJriMFYkiNt6+WPjjUItBXNPkA95XMQrL/euo0Qm3AfwModlqhvVIhP6BD3BY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718464799; c=relaxed/simple;
	bh=jshkWIHPo3YzeCmina0UJk9xyEG39QgO5mRkhbtsSK8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:To:CC; b=ZdYpa1McsmPiKiQBg+JiR9VAAjmCb3XEqMFdi8TYibE49gjSK60v9cXCMts9t31NCiJpl7tX/33vGCGP6H66E0Vo4J2wLOqDj5LHywuznG6NbxencwFltze4HTADD8P8HZNLD/xtB7YLwL8nPC7f2jUFvo1il9t9P1a0a//1kHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=jgvuDx3j; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45FEhgkD024563;
	Sat, 15 Jun 2024 15:19:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=+Q0rGL8N8LaCSBSgdAqB6/
	nnToMU3UOTJeUQub067eE=; b=jgvuDx3jzAv5sm8K7CuY1RWbRnuFuWVv2uYSDA
	+Q4whNArFf6KmKkJNjZwXLmtTrmzJpeQEt+HFcTJ7+8/NQL+05TwEJlSOz2ZBU2M
	xeKQepW24FzcKR75mUBMuB8prlXLOBgC6GI3YdegoliKdtj1meW8UhAoiSvjb8Xu
	WLiSw9u4gvsBnFo/BFRiTct64DeZFnsvz6k4NC2Yz1I6QguB7rKoYzTKQGLL2KeQ
	Ugyg+gqRq5+KUka2QCG6CJCTYMBr5fJCWLieNlngnQKVDaiwuqvTlNMgigTRAv+B
	5t8Tr+4ZELXQxeWzS1iexyF5X0R1T7KItq5M0zNODYdnPZFg==
Received: from nalasppmta02.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3ys3b70q1j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 15 Jun 2024 15:19:13 +0000 (GMT)
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA02.qualcomm.com (8.17.1.19/8.17.1.19) with ESMTPS id 45FFJBiV017204
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 15 Jun 2024 15:19:11 GMT
Received: from [169.254.0.1] (10.49.16.6) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Sat, 15 Jun
 2024 08:19:04 -0700
From: Jeff Johnson <quic_jjohnson@quicinc.com>
Date: Sat, 15 Jun 2024 08:18:59 -0700
Subject: [PATCH] KVM: PPC: add missing MODULE_DESCRIPTION() macros
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20240615-md-powerpc-arch-powerpc-kvm-v1-1-7478648b3100@quicinc.com>
X-B4-Tracking: v=1; b=H4sIAOKwbWYC/z3MwQ6CMAwA0F8hPdtkLIrorxgP3Siu0Y2lUyQh/
 LvTg8d3eSsUVuEC52YF5VmKTKmi3TXgA6UbowzVYI3dm649YBwwT2/W7JHUhz/uc8ST7Y6j752
 h3kEdsvIoy2+/XKsdFUanlHz4ng9JrwUjlScrbNsH0A6iY4wAAAA=
To: Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin
	<npiggin@gmail.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        "Naveen
 N. Rao" <naveen.n.rao@linux.ibm.com>
CC: <linuxppc-dev@lists.ozlabs.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
        "Jeff
 Johnson" <quic_jjohnson@quicinc.com>
X-Mailer: b4 0.13.0
X-ClientProxiedBy: nalasex01b.na.qualcomm.com (10.47.209.197) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: c65O775oj7ut3YNE45UZp56zioJYRR9i
X-Proofpoint-ORIG-GUID: c65O775oj7ut3YNE45UZp56zioJYRR9i
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-15_11,2024-06-14_03,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 malwarescore=0
 bulkscore=0 spamscore=0 mlxscore=0 priorityscore=1501 clxscore=1015
 mlxlogscore=999 adultscore=0 lowpriorityscore=0 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2405170001 definitions=main-2406150117

With ARCH=powerpc, make allmodconfig && make W=1 C=1 reports:
WARNING: modpost: missing MODULE_DESCRIPTION() in arch/powerpc/kvm/test-guest-state-buffer.o
WARNING: modpost: missing MODULE_DESCRIPTION() in arch/powerpc/kvm/kvm-pr.o
WARNING: modpost: missing MODULE_DESCRIPTION() in arch/powerpc/kvm/kvm-hv.o

Add the missing invocations of the MODULE_DESCRIPTION() macro.

Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
---
 arch/powerpc/kvm/book3s_hv.c               | 1 +
 arch/powerpc/kvm/book3s_pr.c               | 1 +
 arch/powerpc/kvm/test-guest-state-buffer.c | 1 +
 3 files changed, 3 insertions(+)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index daaf7faf21a5..e16c096a2422 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -6519,6 +6519,7 @@ static void kvmppc_book3s_exit_hv(void)
 
 module_init(kvmppc_book3s_init_hv);
 module_exit(kvmppc_book3s_exit_hv);
+MODULE_DESCRIPTION("KVM on Book 3S (POWER7 and later) in hypervisor mode");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_MISCDEV(KVM_MINOR);
 MODULE_ALIAS("devname:kvm");
diff --git a/arch/powerpc/kvm/book3s_pr.c b/arch/powerpc/kvm/book3s_pr.c
index a7d7137ea0c8..7c19744c43cb 100644
--- a/arch/powerpc/kvm/book3s_pr.c
+++ b/arch/powerpc/kvm/book3s_pr.c
@@ -2111,6 +2111,7 @@ void kvmppc_book3s_exit_pr(void)
 module_init(kvmppc_book3s_init_pr);
 module_exit(kvmppc_book3s_exit_pr);
 
+MODULE_DESCRIPTION("KVM on Book 3S without using hypervisor mode");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_MISCDEV(KVM_MINOR);
 MODULE_ALIAS("devname:kvm");
diff --git a/arch/powerpc/kvm/test-guest-state-buffer.c b/arch/powerpc/kvm/test-guest-state-buffer.c
index 4720b8dc8837..10238556c113 100644
--- a/arch/powerpc/kvm/test-guest-state-buffer.c
+++ b/arch/powerpc/kvm/test-guest-state-buffer.c
@@ -325,4 +325,5 @@ static struct kunit_suite guest_state_buffer_test_suite = {
 
 kunit_test_suites(&guest_state_buffer_test_suite);
 
+MODULE_DESCRIPTION("KUnit tests for Guest State Buffer APIs");
 MODULE_LICENSE("GPL");

---
base-commit: 83a7eefedc9b56fe7bfeff13b6c7356688ffa670
change-id: 20240615-md-powerpc-arch-powerpc-kvm-9267fc8b0a8b


