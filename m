Return-Path: <kvm+bounces-20551-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 81D809180FA
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 14:35:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 17257B23A4F
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 12:35:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADF0E181BB7;
	Wed, 26 Jun 2024 12:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="OtD948vO"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B8751E51D;
	Wed, 26 Jun 2024 12:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719405312; cv=none; b=A5JpG9XGtl0NwWvpzXytIYtFEH3g/EQC2JXkBv23hPweEJ8JtOB6k1mwlzu7FjGlKkbMnFfHNvpLToEl/LF5nzqQgMx9qDGr9WfcDXbPgXOlC9emf/weymqeXvD2OvfveWH4kNwK45n60Jeu72D13E4KzgjbZGCH8EJV6LPTFMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719405312; c=relaxed/simple;
	bh=vI/1o0+2hln9lPAnOOhXh21rWmGrsxGmQIF93754w34=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qkhvM6RFY1zaBCGfGgUX29M/ApwqTu0/K4EmBevtQB+62f3+ETHyb0T+CZVB4CxvO8pWyTgeAECvOP9mt/H089pFYgVk3j3Y18iDH4ExqQizrexnWV1Vvx+zxj14MDaONsFLCsFn2OK2QN0OPP+Qtkb/+IFePerxV8kgMI6ceSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=OtD948vO; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45QCSZS8025519;
	Wed, 26 Jun 2024 12:34:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from
	:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding; s=pp1; bh=1M3uab7xvRx35jrrCl/rxHpIST
	fv19tWewf+1efpx6w=; b=OtD948vO4kYLvlKeLdrGojELI607ol+Bdi5QKdj4B7
	yejJdB8NyP/WsJDAPaEwDwPrE8k86q+e/lEzuaZQYLIIUZ3BbDAyXCWT86t+UI4C
	O5HbtGfbErWa+T7K44vLC5pivj8C/0Yf0HM0pFUEPP6NbcXc3vezjOAPGxmCc3vQ
	GzDFUFgdDy8iFfVVsloj5SI199EJgqALeg6euYfxCFypxlAMjXmPbo8bCDHiMsWU
	W5srlo08pQuyVKsLuOnZhkW6cL7w6ZCy8pTaPGx9AP5kOuEvZ4DvFowdAOwoqwiv
	pJvwMxTHKTVA8G1ao3XZpmYEexFQslIcrUslW+oAEpbA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 400k16g0py-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 26 Jun 2024 12:34:58 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 45QCYvt0005532;
	Wed, 26 Jun 2024 12:34:58 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 400k16g0pw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 26 Jun 2024 12:34:57 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 45Q9sYvn020058;
	Wed, 26 Jun 2024 12:34:57 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3yxb5mm429-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 26 Jun 2024 12:34:57 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 45QCYpuG18547158
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Jun 2024 12:34:53 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A207D2004F;
	Wed, 26 Jun 2024 12:34:51 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1C8E52004E;
	Wed, 26 Jun 2024 12:34:50 +0000 (GMT)
Received: from li-c6426e4c-27cf-11b2-a85c-95d65bc0de0e.in.ibm.com (unknown [9.204.206.66])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 26 Jun 2024 12:34:49 +0000 (GMT)
From: Gautam Menghani <gautam@linux.ibm.com>
To: mpe@ellerman.id.au, npiggin@gmail.com, christophe.leroy@csgroup.eu,
        naveen.n.rao@linux.ibm.com
Cc: Gautam Menghani <gautam@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] arch/powerpc/kvm: Avoid extra checks when emulating HFSCR bits
Date: Wed, 26 Jun 2024 18:04:45 +0530
Message-ID: <20240626123447.66104-1-gautam@linux.ibm.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: OLd1RCc2EWjGPQmFqe7jpg_cZK6BSujC
X-Proofpoint-ORIG-GUID: 0NX8MqzH6XRyWYsOpeiK1bk-GVisM4-E
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-26_06,2024-06-25_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 spamscore=0
 phishscore=0 mlxlogscore=826 impostorscore=0 malwarescore=0 clxscore=1011
 priorityscore=1501 lowpriorityscore=0 mlxscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2406140001 definitions=main-2406260092

When a KVM guest tries to use a feature disabled by HFSCR, it exits to
the host for emulation support, and the code checks for all bits which
are emulated. Avoid checking all the bits by using a switch case.

Signed-off-by: Gautam Menghani <gautam@linux.ibm.com>
---
 arch/powerpc/kvm/book3s_hv.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 99c7ce825..a72fd2543 100644
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
2.45.2


