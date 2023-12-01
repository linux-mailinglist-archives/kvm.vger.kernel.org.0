Return-Path: <kvm+bounces-3115-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 89D6F800BD4
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 14:27:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B05671C20EE9
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 13:27:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AC7C38F8C;
	Fri,  1 Dec 2023 13:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="pJCQzc3x"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEEA89A;
	Fri,  1 Dec 2023 05:27:14 -0800 (PST)
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3B1DH0pI021666;
	Fri, 1 Dec 2023 13:27:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=aDdxgOaL6Dh9EnxgVQBm9wHGLz4pIRePc5u5G3CgdEo=;
 b=pJCQzc3xGiIdn9fBnipbTKViujQV7+IYnNIbSfuX/vaNYYO0JCf3JgZdJIFH+9F1Ws1k
 r89tziirdk6ZgszxUaKuCUfvZJVA8jDdwjCWg7Rn1lC5zVqdlskoN7ERaaqHgChuG2XQ
 SoNrJP0TSB2Z6zCLoXQ3NosSz3AMpC3j/iY8KDm3NHhgtP/NxYufpRyC/uL4+r1u4zU7
 42bwZAuiWNR9myoj6nZEblrJqqwoUMXGTUlwKsGNKhNX2UUVRT7Fv/U5CfeRPh2XOx7+
 NJNsD6TX4tp14+bhhMxfsy2w2LFCStHlULJMTyKBU9vb2b55Xsn5uZjej1u5t65LsOoN BA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uqg828aeu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 01 Dec 2023 13:27:02 +0000
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3B1DHvDv024701;
	Fri, 1 Dec 2023 13:27:02 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uqg828ae2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 01 Dec 2023 13:27:01 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3B1AY2Qg020465;
	Fri, 1 Dec 2023 13:27:00 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3ukvrm52uj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 01 Dec 2023 13:27:00 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3B1DQvST43909826
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 1 Dec 2023 13:26:57 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6E8CC2004B;
	Fri,  1 Dec 2023 13:26:57 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A7BA620040;
	Fri,  1 Dec 2023 13:26:53 +0000 (GMT)
Received: from vaibhav?linux.ibm.com (unknown [9.171.33.138])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with SMTP;
	Fri,  1 Dec 2023 13:26:53 +0000 (GMT)
Received: by vaibhav@linux.ibm.com (sSMTP sendmail emulation); Fri, 01 Dec 2023 18:56:52 +0530
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
Subject: [PATCH 06/12] KVM: PPC: Book3S HV: Handle pending exceptions on guest entry with MSR_EE
Date: Fri,  1 Dec 2023 18:56:11 +0530
Message-ID: <20231201132618.555031-7-vaibhav@linux.ibm.com>
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
X-Proofpoint-GUID: WKVBC-1BHXhVu40T7NgS8du2Ep_eukLe
X-Proofpoint-ORIG-GUID: yS3HZe4JdsuOHbK25QuCJYWbKZo6XCat
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-01_11,2023-11-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 clxscore=1015 phishscore=0 mlxlogscore=736 suspectscore=0 malwarescore=0
 spamscore=0 adultscore=0 bulkscore=0 mlxscore=0 impostorscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2312010092

From: Nicholas Piggin <npiggin@gmail.com>

Commit 026728dc5d41 ("KVM: PPC: Book3S HV P9: Inject pending xive
interrupts at guest entry") changed guest entry so that if external
interrupts are enabled, BOOK3S_IRQPRIO_EXTERNAL is not tested for. Test
for this regardless of MSR_EE.

For an L1 host, do not inject an interrupt, but always
use LPCR_MER. If the L0 desires it can inject an interrupt.

Fixes: 026728dc5d41 ("KVM: PPC: Book3S HV P9: Inject pending xive interrupts at guest entry")
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
[jpn: use kvmpcc_get_msr(), write commit message]
Signed-off-by: Jordan Niethe <jniethe5@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 6d1f0bca27aa..4dc6a928073f 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4738,13 +4738,19 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
 
 	if (!nested) {
 		kvmppc_core_prepare_to_enter(vcpu);
-		if (__kvmppc_get_msr_hv(vcpu) & MSR_EE) {
-			if (xive_interrupt_pending(vcpu))
+		if (test_bit(BOOK3S_IRQPRIO_EXTERNAL,
+			     &vcpu->arch.pending_exceptions) ||
+		    xive_interrupt_pending(vcpu)) {
+			/*
+			 * For nested HV, don't synthesize but always pass MER,
+			 * the L0 will be able to optimise that more
+			 * effectively than manipulating registers directly.
+			 */
+			if (!kvmhv_on_pseries() && (__kvmppc_get_msr_hv(vcpu) & MSR_EE))
 				kvmppc_inject_interrupt_hv(vcpu,
-						BOOK3S_INTERRUPT_EXTERNAL, 0);
-		} else if (test_bit(BOOK3S_IRQPRIO_EXTERNAL,
-			     &vcpu->arch.pending_exceptions)) {
-			lpcr |= LPCR_MER;
+							   BOOK3S_INTERRUPT_EXTERNAL, 0);
+			else
+				lpcr |= LPCR_MER;
 		}
 	} else if (vcpu->arch.pending_exceptions ||
 		   vcpu->arch.doorbell_request ||
-- 
2.42.0


