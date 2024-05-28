Return-Path: <kvm+bounces-18238-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A5DFE8D2576
	for <lists+kvm@lfdr.de>; Tue, 28 May 2024 22:07:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D76B31C24D1E
	for <lists+kvm@lfdr.de>; Tue, 28 May 2024 20:07:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6359F17839E;
	Tue, 28 May 2024 20:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="VAE1xyi7"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C70110A3E;
	Tue, 28 May 2024 20:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716926835; cv=none; b=sBOoeLIqXrFIU+0mSql8ePM8R9toHqAs4jJZNRNeFj12FcaPv4r0Q4cxCc7tRacXSkJ/YxwhasS4VfhdU7y5CLXY62NB1jWejX9W2EkFHHw+NW2bE2dTnYBS0rHazM8mitohfHuZx/Rurf3HYX3bbByGD4E922xsNFlldAUJ9w8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716926835; c=relaxed/simple;
	bh=N6vwJeSmmvYBNdjtiWxQ1nwJbre93PhEvl+twzPPdwA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:To:CC; b=ctyvSuG67RooiM6nRuvxGVPcWw2Wcp6mu+0eSCn6Fzu3IPX8VSm1r7esFKJI9OTdrS3WVsgzDLEAF79zp1guDApwAYuJJI8n7P/sscX6pvEEfODiOvM/10ns8oQn+afKoUEk28AqszBdFP3RYPcVipVJOTuEvyxwcHkZi8/g+lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=VAE1xyi7; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 44SBY0Zu007985;
	Tue, 28 May 2024 20:06:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=+A2p0eTGmhORMiKBsVfkaO
	iYDcBr3l0hvpb+y9Zsx3I=; b=VAE1xyi7gcWrB+xUVHqHJyItlBwRJbcwNGjCqT
	X6dnTuaVz4z21NLdzbL9jqBGUkLl5i3JLxzL696eOZU+hT2H+Pk8ltuCgPeCxKJ0
	JvCWJE/I7no1CE+E0wf2Ck5fkFDXGQ2UAvPXXQ5K6BMEnPwjb9jlZD/XFBY3MUIp
	V784cio0tvBZykkGWrdJCIqg+ubYhqsgQ3oZZ61uh6evPrcUZ/ZH56Y7+a299SSL
	7Koj35tojSxbXfngsJQ/wu4uEgT8eiFxM1NApfMkv9V397c5+yyUjllaFrajFETZ
	5Idc4vFXMQe3yHYdXBF5oSRq/FWf84u6ke3zulaGLYed2L9w==
Received: from nalasppmta03.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3yba0pq47t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 28 May 2024 20:06:46 +0000 (GMT)
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA03.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 44SK6jIQ022490
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 28 May 2024 20:06:45 GMT
Received: from [169.254.0.1] (10.49.16.6) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Tue, 28 May
 2024 13:06:45 -0700
From: Jeff Johnson <quic_jjohnson@quicinc.com>
Date: Tue, 28 May 2024 13:06:44 -0700
Subject: [PATCH] KVM: x86: add missing MODULE_DESCRIPTION() macros
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20240528-md-kvm-v1-1-c1b86f0f5112@quicinc.com>
X-B4-Tracking: v=1; b=H4sIAFM5VmYC/x3M0QqDMAyF4VeRXC9QO5WxVxm7SGvUsLWOZBNBf
 PdVLz/4z9nAWIUN7tUGyouYzLmgvlQQJ8ojo/TF4J1vXOtvmHp8LQmv3eBdiA21wUGJP8qDrOf
 R41kcyBiDUo7TMX9L/q2YyL6ssO9/FMiW8XcAAAA=
To: Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini
	<pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar
	<mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen
	<dave.hansen@linux.intel.com>, <x86@kernel.org>,
        "H. Peter Anvin"
	<hpa@zytor.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Jeff Johnson
	<quic_jjohnson@quicinc.com>
X-Mailer: b4 0.13.0
X-ClientProxiedBy: nalasex01a.na.qualcomm.com (10.47.209.196) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: tC9DMFtnNQiPYPiD6BqMuqaddMurqHOP
X-Proofpoint-GUID: tC9DMFtnNQiPYPiD6BqMuqaddMurqHOP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-28_14,2024-05-28_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=566 bulkscore=0
 suspectscore=0 clxscore=1011 lowpriorityscore=0 priorityscore=1501
 mlxscore=0 spamscore=0 adultscore=0 phishscore=0 impostorscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2405170001 definitions=main-2405280150

Fix the following allmodconfig 'make W=1' warnings when building for x86:
WARNING: modpost: missing MODULE_DESCRIPTION() in arch/x86/kvm/kvm.o
WARNING: modpost: missing MODULE_DESCRIPTION() in arch/x86/kvm/kvm-intel.o
WARNING: modpost: missing MODULE_DESCRIPTION() in arch/x86/kvm/kvm-amd.o

Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
---
 arch/x86/kvm/svm/svm.c | 1 +
 arch/x86/kvm/vmx/vmx.c | 1 +
 virt/kvm/kvm_main.c    | 1 +
 3 files changed, 3 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index c8dc25886c16..bdd39931720c 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -53,6 +53,7 @@
 #include "svm_onhyperv.h"
 
 MODULE_AUTHOR("Qumranet");
+MODULE_DESCRIPTION("KVM SVM (AMD-V) extensions");
 MODULE_LICENSE("GPL");
 
 #ifdef MODULE
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6051fad5945f..956e6062f311 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -74,6 +74,7 @@
 #include "posted_intr.h"
 
 MODULE_AUTHOR("Qumranet");
+MODULE_DESCRIPTION("KVM VMX (Intel VT-x) extensions");
 MODULE_LICENSE("GPL");
 
 #ifdef MODULE
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 14841acb8b95..b03d06ca29c4 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -74,6 +74,7 @@
 #define ITOA_MAX_LEN 12
 
 MODULE_AUTHOR("Qumranet");
+MODULE_DESCRIPTION("Kernel-based Virtual Machine driver for Linux");
 MODULE_LICENSE("GPL");
 
 /* Architectures should define their poll value according to the halt latency */

---
base-commit: 2bfcfd584ff5ccc8bb7acde19b42570414bf880b
change-id: 20240528-md-kvm-36f20bc4a5b0


