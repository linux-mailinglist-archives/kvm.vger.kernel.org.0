Return-Path: <kvm+bounces-21702-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B154932606
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 13:57:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CB0B7B21679
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 11:57:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2C3619A286;
	Tue, 16 Jul 2024 11:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="kliwWgR8"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFD9A1991B6;
	Tue, 16 Jul 2024 11:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721131042; cv=none; b=YZTEYvtQAcz5dOK22MBw51Ov3t5aqqu+UqW+aASr8c8OYlthJVxKiw1euNOOayVefZkMi1XGgBzV0miqeO/Vt98N9ZmXZ4s8youWQFmKbXb18im4DMXZEM5ecxw7pr/2mxoWd6TRMrBCTedxapN7nlSbdVL7LW2D7haE5KqqUoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721131042; c=relaxed/simple;
	bh=YfBB17F/3CAT8ddcwhGop5L9It/iSjGlhp0Qh0MkSxA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jU7RJn7LVu3DVZ9Jvdk93jJJDuWoVK9zmU/c8+feCB71xcSTXUArsr6QXJYclomMFYem18VIiDTBOFQWVR1a7ihcwNZFtvLyou0ricr5mpdWVQwK65NLYGBFRJHSbD/TpscGE96D0YPpZWetpRP0C2BMoUui8tB85kc+BJK+2Bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=kliwWgR8; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46GBv6GO008575;
	Tue, 16 Jul 2024 11:57:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from
	:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding; s=pp1; bh=Ghcc0qNpM6RaiKcCYkB5fP+8Tg
	UPXtwbux3lz36maPY=; b=kliwWgR8uSrjEdhZJS5e9ZeObKaIbcNxjNlxhhVA1a
	JziXEUP0C7zRz98By8nnXg0JkrXd/8b/fvW/Gd8ZTqJNPp41h7MZuIxm7fUHZSVr
	kbwoNUT3YLQg1H4nHIa1d8HNI3kC90B8v8THRGpzx1GsBQHjYsqwmZbSbnDPQrqh
	O+82QxjHHjyvg8DgBoW1vc070dqff3dx4JbCHgFkMW6QcyWyjz1OqfeUhh7AkKtv
	ax4BtGDdwTTA/VPgFLuM+EdA4pRNfgyuJ5DocK0XXN8OVDapwiQ4yRXWQLu6zVM9
	1O6Mitk+IK5Uhjjs/D3b6Ons37oE4gJ+r+z84Ww6JE4Q==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 40dqk2054r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Jul 2024 11:57:06 +0000 (GMT)
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 46GBv5NI008512;
	Tue, 16 Jul 2024 11:57:05 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 40dqk20520-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Jul 2024 11:57:05 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 46G8ijQv017944;
	Tue, 16 Jul 2024 11:52:16 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 40c3wtv2k5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Jul 2024 11:52:16 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 46GBqB8b53150114
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Jul 2024 11:52:13 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 64CD020040;
	Tue, 16 Jul 2024 11:52:11 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CF47F20043;
	Tue, 16 Jul 2024 11:52:09 +0000 (GMT)
Received: from li-c6426e4c-27cf-11b2-a85c-95d65bc0de0e.in.ibm.com (unknown [9.204.206.66])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 16 Jul 2024 11:52:09 +0000 (GMT)
From: Gautam Menghani <gautam@linux.ibm.com>
To: mpe@ellerman.id.au, npiggin@gmail.com, christophe.leroy@csgroup.eu,
        naveen.n.rao@linux.ibm.com
Cc: Gautam Menghani <gautam@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] KVM: PPC: Book3S HV: Refactor HFSCR emulation for KVM guests
Date: Tue, 16 Jul 2024 17:22:04 +0530
Message-ID: <20240716115206.70210-1-gautam@linux.ibm.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 1r5ZGJHnw9tG090yZ4UknphQyEOMPzDJ
X-Proofpoint-ORIG-GUID: K07rOCBoRRo1DHfUcZi6ijHkxD_A17Eh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-15_19,2024-07-16_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 lowpriorityscore=0
 mlxscore=0 adultscore=0 bulkscore=0 phishscore=0 impostorscore=0
 malwarescore=0 clxscore=1015 suspectscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2406140001
 definitions=main-2407160087

Refactor HFSCR emulation for KVM guests when they exit out with
H_FAC_UNAVAIL to use a switch case instead of checking all "cause"
values, since the "cause" values are mutually exclusive; and this is 
better expressed with a switch case.

Signed-off-by: Gautam Menghani <gautam@linux.ibm.com>
---
V1 -> V2:
1. Reword changelog to point out mutual exclusivity of HFSCR bits.
2. Reword commit message to match other commits in book3s_hv.c

 arch/powerpc/kvm/book3s_hv.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index daaf7faf21a5..50797b0611a2 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -1922,14 +1922,22 @@ static int kvmppc_handle_exit_hv(struct kvm_vcpu *vcpu,
 
 		r = EMULATE_FAIL;
 		if (cpu_has_feature(CPU_FTR_ARCH_300)) {
-			if (cause == FSCR_MSGP_LG)
+			switch (cause) {
+			case FSCR_MSGP_LG:
 				r = kvmppc_emulate_doorbell_instr(vcpu);
-			if (cause == FSCR_PM_LG)
+				break;
+			case FSCR_PM_LG:
 				r = kvmppc_pmu_unavailable(vcpu);
-			if (cause == FSCR_EBB_LG)
+				break;
+			case FSCR_EBB_LG:
 				r = kvmppc_ebb_unavailable(vcpu);
-			if (cause == FSCR_TM_LG)
+				break;
+			case FSCR_TM_LG:
 				r = kvmppc_tm_unavailable(vcpu);
+				break;
+			default:
+				break;
+			}
 		}
 		if (r == EMULATE_FAIL) {
 			kvmppc_core_queue_program(vcpu, SRR1_PROGILL |
-- 
2.45.1


