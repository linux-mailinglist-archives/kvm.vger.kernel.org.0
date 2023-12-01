Return-Path: <kvm+bounces-3117-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A1EE800BDC
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 14:27:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E6B87281C19
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 13:27:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0911F3B7B4;
	Fri,  1 Dec 2023 13:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="UXje27QD"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E13410F8;
	Fri,  1 Dec 2023 05:27:21 -0800 (PST)
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3B1D0Vwu013825;
	Fri, 1 Dec 2023 13:27:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=G8DN0o+pS342ovmB0cLLGGQTGUTz9ve8djaW1DkLab4=;
 b=UXje27QD0IzXyviuQDMWjfX3SYtZCkfelYsK1QrHtGPdxKFyr1SJGmm4qk8qMgtlnzAz
 /qLe5OGMWvQxGfy61T5I2SbgdkD+WvdnYWfa2pfkGR/BGk8tOiQr2kfCBejfgJJC2tyc
 cOiUuzmPb5wuDQOLgGZdzxZJYCE8bvTBzDkBfrqoBUZsM7/lCm0lE46qsdiVll8XxO2V
 zefHY1TgAZIpVqWzanwuuTRMjfeHx4MGtiUFxgpIHZFeGldSArGlBbJv5B/h7j7JkVEB
 GGMZamaPlkG8iif93u2xx+fcEqldV7CoSWO4ZOsFXoIe0HJPfui8ZGRlG/U2252P5GgW Nw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uqfsc99en-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 01 Dec 2023 13:27:08 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3B1DR795019981;
	Fri, 1 Dec 2023 13:27:07 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uqfsc99dp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 01 Dec 2023 13:27:07 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3B1AY0mo020443;
	Fri, 1 Dec 2023 13:27:05 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3ukvrm52v2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 01 Dec 2023 13:27:05 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3B1DR2lY56426758
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 1 Dec 2023 13:27:02 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4B3B320043;
	Fri,  1 Dec 2023 13:27:02 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 846C520040;
	Fri,  1 Dec 2023 13:26:58 +0000 (GMT)
Received: from vaibhav?linux.ibm.com (unknown [9.171.33.138])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with SMTP;
	Fri,  1 Dec 2023 13:26:58 +0000 (GMT)
Received: by vaibhav@linux.ibm.com (sSMTP sendmail emulation); Fri, 01 Dec 2023 18:56:57 +0530
From: Vaibhav Jain <vaibhav@linux.ibm.com>
To: linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org
Cc: Vaibhav Jain <vaibhav@linux.ibm.com>, Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Jordan Niethe <jniethe5@gmail.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>, mikey@neuling.org,
        paulus@ozlabs.org, sbhat@linux.ibm.com, gautam@linux.ibm.com,
        kconsul@linux.vnet.ibm.com, amachhiw@linux.vnet.ibm.com,
        David.Laight@ACULAB.COM
Subject: [PATCH 07/12] KVM: PPC: Book3S HV nestedv2: Do not inject certain interrupts
Date: Fri,  1 Dec 2023 18:56:12 +0530
Message-ID: <20231201132618.555031-8-vaibhav@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231201132618.555031-1-vaibhav@linux.ibm.com>
References: <20231201132618.555031-1-vaibhav@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: pBnaP7NnwDhzmiods1L8ZGKq2uR_xHon
X-Proofpoint-ORIG-GUID: QldL5K1FzT6tswdHGvMoSpj30lWvWjjf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-01_11,2023-11-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 spamscore=0 bulkscore=0 lowpriorityscore=0 mlxlogscore=643 clxscore=1015
 impostorscore=0 malwarescore=0 priorityscore=1501 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2312010091

From: Jordan Niethe <jniethe5@gmail.com>

There is no need to inject an external interrupt in
kvmppc_book3s_irqprio_deliver() as the test for BOOK3S_IRQPRIO_EXTERNAL
in kvmhv_run_single_vcpu() before guest entry will raise LPCR_MER if
needed. There is also no need to inject the decrementer interrupt as
this will be raised within the L2 if needed. Avoiding these injections
reduces H_GUEST_GET_STATE hcalls by the L1.

Suggested-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Jordan Niethe <jniethe5@gmail.com>
---
 arch/powerpc/kvm/book3s.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
index 6cd20ab9e94e..8acec144120e 100644
--- a/arch/powerpc/kvm/book3s.c
+++ b/arch/powerpc/kvm/book3s.c
@@ -302,11 +302,11 @@ static int kvmppc_book3s_irqprio_deliver(struct kvm_vcpu *vcpu,
 
 	switch (priority) {
 	case BOOK3S_IRQPRIO_DECREMENTER:
-		deliver = (kvmppc_get_msr(vcpu) & MSR_EE) && !crit;
+		deliver = !kvmhv_is_nestedv2() && (kvmppc_get_msr(vcpu) & MSR_EE) && !crit;
 		vec = BOOK3S_INTERRUPT_DECREMENTER;
 		break;
 	case BOOK3S_IRQPRIO_EXTERNAL:
-		deliver = (kvmppc_get_msr(vcpu) & MSR_EE) && !crit;
+		deliver = !kvmhv_is_nestedv2() && (kvmppc_get_msr(vcpu) & MSR_EE) && !crit;
 		vec = BOOK3S_INTERRUPT_EXTERNAL;
 		break;
 	case BOOK3S_IRQPRIO_SYSTEM_RESET:
-- 
2.42.0


