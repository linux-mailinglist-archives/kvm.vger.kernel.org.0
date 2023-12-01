Return-Path: <kvm+bounces-3121-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6976B800C24
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 14:31:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AB2CD281BA0
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 13:31:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BCEC38F9C;
	Fri,  1 Dec 2023 13:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="RIYsZjuB"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5831131;
	Fri,  1 Dec 2023 05:31:19 -0800 (PST)
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3B1DUwZ3028267;
	Fri, 1 Dec 2023 13:31:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=BWnJtPbJ3XZMPnoKoEcKPgJH5uYYE/qMtxR3t/1Rv3I=;
 b=RIYsZjuBrCr1Zf3kogSap4u/AQPM0kqXp/70YAuequx2a6nxX5SSEUYg/fvd61ca0EzV
 21JdARQgzXjqaac0kqH69d7GfljceE4iT6ttgN52ql0faW39T4OCcF19gN5g8+rUruhO
 Sx4ucoX7I2RV6egs900nA/Dg7mGmeCs4kjj8TLBoRGccKdakHiXQbUuyY4tRlxaAwTTS
 ChyFTJeOweIaKhfk1JTPQNgDEYa0SsVw+WMKIrLiU/lyaaX+naccnwcocLNhl+ipemeB
 lBz94JZy9CGmLXxoII7q6GK/I7JBfheATXEZGK07hP2jn79MNGxMaS8MJdYHcq0GDM/v Kw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uqf2m3ju5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 01 Dec 2023 13:31:10 +0000
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3B1DV88Y029262;
	Fri, 1 Dec 2023 13:31:10 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uqf2m3jgw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 01 Dec 2023 13:31:10 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3B1AXnOk006257;
	Fri, 1 Dec 2023 13:26:46 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3ukwfkmu6g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 01 Dec 2023 13:26:45 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3B1DQhG947317472
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 1 Dec 2023 13:26:43 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F208B2004B;
	Fri,  1 Dec 2023 13:26:42 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2C5AE20040;
	Fri,  1 Dec 2023 13:26:39 +0000 (GMT)
Received: from vaibhav?linux.ibm.com (unknown [9.171.33.138])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with SMTP;
	Fri,  1 Dec 2023 13:26:38 +0000 (GMT)
Received: by vaibhav@linux.ibm.com (sSMTP sendmail emulation); Fri, 01 Dec 2023 18:56:38 +0530
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
Subject: [PATCH 03/12] KVM: PPC: Book3S HV nestedv2: Do not check msr on hcalls
Date: Fri,  1 Dec 2023 18:56:08 +0530
Message-ID: <20231201132618.555031-4-vaibhav@linux.ibm.com>
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
X-Proofpoint-GUID: kX9HCWWBJV-DDTez68iHM7jwNN0-ZBrr
X-Proofpoint-ORIG-GUID: nC_KWy1LXcwZLYSesdz9d97IvNnbpPdY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-01_11,2023-11-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 spamscore=0 adultscore=0 phishscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=877 mlxscore=0 lowpriorityscore=0
 impostorscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2311060000 definitions=main-2312010092

From: Jordan Niethe <jniethe5@gmail.com>

The check for a hcall coming from userspace is done for KVM-PR. This is
not supported for nestedv2 and the L0 will directly inject the necessary
exception to the L2 if userspace performs a hcall. Avoid checking the
MSR and thus avoid a H_GUEST_GET_STATE hcall in the L1.

Signed-off-by: Jordan Niethe <jniethe5@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 5543e8490cd9..069c336b6f3c 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -1688,7 +1688,7 @@ static int kvmppc_handle_exit_hv(struct kvm_vcpu *vcpu,
 	{
 		int i;
 
-		if (unlikely(__kvmppc_get_msr_hv(vcpu) & MSR_PR)) {
+		if (!kvmhv_is_nestedv2() && unlikely(__kvmppc_get_msr_hv(vcpu) & MSR_PR)) {
 			/*
 			 * Guest userspace executed sc 1. This can only be
 			 * reached by the P9 path because the old path
@@ -4949,7 +4949,7 @@ static int kvmppc_vcpu_run_hv(struct kvm_vcpu *vcpu)
 		if (run->exit_reason == KVM_EXIT_PAPR_HCALL) {
 			accumulate_time(vcpu, &vcpu->arch.hcall);
 
-			if (WARN_ON_ONCE(__kvmppc_get_msr_hv(vcpu) & MSR_PR)) {
+			if (!kvmhv_is_nestedv2() && WARN_ON_ONCE(__kvmppc_get_msr_hv(vcpu) & MSR_PR)) {
 				/*
 				 * These should have been caught reflected
 				 * into the guest by now. Final sanity check:
-- 
2.42.0


