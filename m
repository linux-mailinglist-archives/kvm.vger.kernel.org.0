Return-Path: <kvm+bounces-20328-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C22A8913801
	for <lists+kvm@lfdr.de>; Sun, 23 Jun 2024 07:45:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7DC372837BF
	for <lists+kvm@lfdr.de>; Sun, 23 Jun 2024 05:45:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED4081CF8F;
	Sun, 23 Jun 2024 05:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="gPVBR3ZU"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EE207FD;
	Sun, 23 Jun 2024 05:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719121527; cv=none; b=PuG2aPJmmM/by8+NOu73XyhOxRnZS5BiN3eYjAqTVrI4h4TpwFR34eICBdYJ+VlQ7GRApgCOCFOTRYAVXoNoy/INut9zBXaG58QI3FXGJDv3kh8G2rFScMhcMd7uQGabklIfV1YLODbS9jObJ94UspKhueYtoiRJyTK7BegjWnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719121527; c=relaxed/simple;
	bh=Dsv+gvnAeJEM2c+WjU2T9ZUKpqGuD33nzFQBPE7WR3s=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:To:CC; b=UMTBbuOmuceabb0uo1r9R0ULEoSIE6T1ot4rldUJS+M0AW5PfWk9JUh9IeSb+LkUvsweIiBLCOUHNdivUs6xzGIwIZpG7ngCnE+EkhT+o3WO13+rAj01VmIw4upGHQJBpszyvOdfTvigHGl5DpXlNDCWvEsxpNtCLXmvjJ4FhYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=gPVBR3ZU; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45N4u8sW013316;
	Sun, 23 Jun 2024 05:45:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=Al3xT5HMJ512bAKdS0RGU8
	tdONKW04l3wjQ6Jc5WzSE=; b=gPVBR3ZUXxOWzDyVPjF/YKEc3Dvand76qaLnYf
	dQTyDvQZsm/SkfD81j0wYroZi0c09A6O4JbVVi7LfvMxBCBkT7A3vZ6oJuPf+ofR
	dgEWEgc21y6tFAd1njPQVyLaBYpNCbQ5Pk+i/Zy6sX1dCuBt5kn+VTGsyAHXGzO3
	boCLb1FecHOIExA78u8PMaOyUp2pzQfuzRUEN9JIWO6wzJNjidjyEZtk+Zxhh//Y
	YrWxG7B4wW2RnMZpYaTO2c8SykNqtwmp+1zu4FJFmyJ68nGPHWqbtQvq4IxMEN8o
	GCPeKMyMAypqMwFLxLRcHe5D7hDTdm6boeiyFpraD09s6V9g==
Received: from nalasppmta05.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3ywpu11cnf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 23 Jun 2024 05:45:01 +0000 (GMT)
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA05.qualcomm.com (8.17.1.19/8.17.1.19) with ESMTPS id 45N5j0LT009558
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 23 Jun 2024 05:45:00 GMT
Received: from [169.254.0.1] (10.49.16.6) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Sat, 22 Jun
 2024 22:44:59 -0700
From: Jeff Johnson <quic_jjohnson@quicinc.com>
Date: Sat, 22 Jun 2024 22:44:55 -0700
Subject: [PATCH v2] KVM: x86: add missing MODULE_DESCRIPTION() macros
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20240622-md-kvm-v2-1-29a60f7c48b1@quicinc.com>
X-B4-Tracking: v=1; b=H4sIAFe2d2YC/2WNwQ6DIBAFf8Vw7jZA1Zie+h+NB1ihblqwBSU2h
 n8veu1xknlvNhZNIBPZtdpYMIkiTb6APFUMR+UfBmgozCSXNW9kB26AZ3Jwaa3kGmvVaM6K/A7
 G0noc3fvCWkUDOiiP4z5/kV9WcCrOJuz6SHGewvfIJrGP/gpJgAAUumstt40Q8vZZCMnjGSfH+
 pzzD77Q2tW9AAAA
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
X-Mailer: b4 0.14.0
X-ClientProxiedBy: nalasex01a.na.qualcomm.com (10.47.209.196) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: jzzs4qQWZSnhSPoMVAu-13mhhTuHhGkz
X-Proofpoint-ORIG-GUID: jzzs4qQWZSnhSPoMVAu-13mhhTuHhGkz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-22_19,2024-06-21_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 spamscore=0
 clxscore=1011 malwarescore=0 lowpriorityscore=0 priorityscore=1501
 adultscore=0 phishscore=0 mlxlogscore=861 bulkscore=0 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2406140001 definitions=main-2406230042

Fix the following allmodconfig 'make W=1' warnings when building for x86:
WARNING: modpost: missing MODULE_DESCRIPTION() in arch/x86/kvm/kvm.o
WARNING: modpost: missing MODULE_DESCRIPTION() in arch/x86/kvm/kvm-intel.o
WARNING: modpost: missing MODULE_DESCRIPTION() in arch/x86/kvm/kvm-amd.o

Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
---
Changes in v2:
- Per Sean:
  - updated SVM and VMX descriptions to add "support for"
  - updated kvm_main description to use the term Hypervisor (in 2 places)
- Link to v1: https://lore.kernel.org/r/20240528-md-kvm-v1-1-c1b86f0f5112@quicinc.com
---
 arch/x86/kvm/svm/svm.c | 1 +
 arch/x86/kvm/vmx/vmx.c | 1 +
 virt/kvm/kvm_main.c    | 3 ++-
 3 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index c8dc25886c16..e484a95ffbad 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -53,6 +53,7 @@
 #include "svm_onhyperv.h"
 
 MODULE_AUTHOR("Qumranet");
+MODULE_DESCRIPTION("KVM support for SVM (AMD-V) extensions");
 MODULE_LICENSE("GPL");
 
 #ifdef MODULE
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6051fad5945f..2ec2b7105056 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -74,6 +74,7 @@
 #include "posted_intr.h"
 
 MODULE_AUTHOR("Qumranet");
+MODULE_DESCRIPTION("KVM support for VMX (Intel VT-x) extensions");
 MODULE_LICENSE("GPL");
 
 #ifdef MODULE
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 14841acb8b95..ffe4ba998225 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * Kernel-based Virtual Machine driver for Linux
+ * Kernel-based Virtual Machine (KVM) Hypervisor
  *
  * This module enables machines with Intel VT-x extensions to run virtual
  * machines without emulation or binary translation.
@@ -74,6 +74,7 @@
 #define ITOA_MAX_LEN 12
 
 MODULE_AUTHOR("Qumranet");
+MODULE_DESCRIPTION("Kernel-based Virtual Machine (KVM) Hypervisor");
 MODULE_LICENSE("GPL");
 
 /* Architectures should define their poll value according to the halt latency */

---
base-commit: 2bfcfd584ff5ccc8bb7acde19b42570414bf880b
change-id: 20240528-md-kvm-36f20bc4a5b0


