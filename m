Return-Path: <kvm+bounces-11716-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AC45D87A395
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 08:27:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DE3BA1C20DA8
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 07:27:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0935C171AC;
	Wed, 13 Mar 2024 07:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="EBUhrqtc"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 794E915EB0;
	Wed, 13 Mar 2024 07:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710314829; cv=none; b=JWqnb42JFVr/ebnZi4hbtzI6T3JfjR8kMRqufmmXsXp/QMpuJKx0K75U17ZueT9lLf1ep89h9NX0FidIfuKQhhMKLNqGJ+cPcn/wMylzrWp3BWc6b7w+TaCh7eWtmzbXVb99JvUWqvJXLZJzJ0nB9LOhA1fFtcNqCpGWmfHjoE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710314829; c=relaxed/simple;
	bh=zADcJ+7QRRr/xSXqFTpvOl1n0XOV8qBBycUoiaOx66I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=A7bkfVtJLCvtiuh5ivYoFKG3XkU4HvLHE03ZaQ2eWr5/TlD3//XIHr+uHiJAlBoEHFCL83aKCuPHXyHv0wUCdpF/w19S6FuQPttd/Wex3PtHbMrZz+875mu7cANbliWtuGQp/FpvhNHDqCWSWTOzA54SP6YOnm3YqnvXAV43MZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=EBUhrqtc; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42D7257n005155;
	Wed, 13 Mar 2024 07:26:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=rOor7RYeGfCOqux28AEV5i5j/WIDmKriNbgjbkQ8YKQ=;
 b=EBUhrqtc3UDjCknmr7gvBw4Y6++4O/Du8j0GvqBpIL8W+yvZ9MCgtDRn8V9LgfIMVkLT
 lDCzpcfNkPAysAIbDscs7bhnhDFiZ0GMXcJTkBJF+ajeW1rjTTXQI76XRVCTasgnRrK8
 v2MiVDykNyAyttbfVccST9/vao6SAI94kOVeH4DvyRCy6v/Z4e5NRu8iSBeiFPHwHa4o
 +DOc8jDTu+ZFqOxEScPBz176+SHuh0xlRLJaOsYWVIT27UK1/I0tHmQR2f/g+n20QVw+
 6/hVNwPO3SHS4P00avNURtBtdgbyzK5rQyBqNLrMS6B9UieNJP3kwI1aPq5GQRH6We5k AQ== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3wu7d58ac3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Mar 2024 07:26:52 +0000
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 42D783ob018909;
	Wed, 13 Mar 2024 07:26:51 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3wu7d58ab5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Mar 2024 07:26:51 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 42D5VakQ018621;
	Wed, 13 Mar 2024 07:26:50 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3ws4t23tr7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Mar 2024 07:26:50 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 42D7QjJB29753626
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Mar 2024 07:26:47 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E87A920040;
	Wed, 13 Mar 2024 07:26:44 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3DDA520043;
	Wed, 13 Mar 2024 07:26:37 +0000 (GMT)
Received: from vaibhav?linux.ibm.com (unknown [9.43.89.57])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with SMTP;
	Wed, 13 Mar 2024 07:26:36 +0000 (GMT)
Received: by vaibhav@linux.ibm.com (sSMTP sendmail emulation); Wed, 13 Mar 2024 12:56:29 +0530
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
Subject: [PATCH] KVM: PPC: Book3S HV nestedv2: Cancel pending HDEC exception
Date: Wed, 13 Mar 2024 12:56:23 +0530
Message-ID: <20240313072625.76804-1-vaibhav@linux.ibm.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 7-uVPKZHgdkelGTF0ILsAB7_BnaOOr58
X-Proofpoint-ORIG-GUID: wBtPzTAxrU-_ZDuPAwchNsQUVA7Ghuey
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-13_07,2024-03-12_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=804 phishscore=0
 impostorscore=0 mlxscore=0 suspectscore=0 lowpriorityscore=0
 malwarescore=0 priorityscore=1501 bulkscore=0 clxscore=1011 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2403130054

This reverts commit 180c6b072bf360b686e53d893d8dcf7dbbaec6bb ("KVM: PPC:
Book3S HV nestedv2: Do not cancel pending decrementer exception") which
prevented cancelling a pending HDEC exception for nestedv2 KVM guests. It
was done to avoid overhead of a H_GUEST_GET_STATE hcall to read the 'HDEC
expiry TB' register which was higher compared to handling extra decrementer
exceptions.

This overhead of reading 'HDEC expiry TB' register has been mitigated
recently by the L0 hypervisor(PowerVM) by putting the value of this
register in L2 guest-state output buffer on trap to L1. From there the
value of this register is cached, made available in kvmhv_run_single_vcpu()
to compare it against host(L1) timebase and cancel the pending hypervisor
decrementer exception if needed.

Fixes: 180c6b072bf3 ("KVM: PPC: Book3S HV nestedv2: Do not cancel pending decrementer exception")
Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
---
 arch/powerpc/kvm/book3s_hv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 0b921704da45..e47b954ce266 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4856,7 +4856,7 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
 	 * entering a nested guest in which case the decrementer is now owned
 	 * by L2 and the L1 decrementer is provided in hdec_expires
 	 */
-	if (!kvmhv_is_nestedv2() && kvmppc_core_pending_dec(vcpu) &&
+	if (kvmppc_core_pending_dec(vcpu) &&
 			((tb < kvmppc_dec_expires_host_tb(vcpu)) ||
 			 (trap == BOOK3S_INTERRUPT_SYSCALL &&
 			  kvmppc_get_gpr(vcpu, 3) == H_ENTER_NESTED)))
-- 
2.44.0


