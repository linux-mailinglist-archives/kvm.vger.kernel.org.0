Return-Path: <kvm+bounces-16735-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A5F28BD270
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 18:19:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 19ECBB22AD9
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 16:19:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 703E8156997;
	Mon,  6 May 2024 16:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="UvBQlARU"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E24FF15665C;
	Mon,  6 May 2024 16:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715012293; cv=none; b=g7uRyhTyiES6pB9y+Kf1kkY58gQvxsBxGIDR1XwgUw0Suj68WXiKpEEV0P8biQHe/q0u57Xx4cXyzImeRpFW1kz/XSo9NO4TVtJz+ikdrYMray+SJb8ZXqDd2469FBtm/3GL/I2Ii17hfUR9uXJ9pKY3vq3uYg2IRaeWeGCDiHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715012293; c=relaxed/simple;
	bh=Yudd+LbphmqwuVEHJwSLVDg9XFbhqEuPzRJAqIoAD5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eycSWUcR3hHBUIkRL417rOfJQ10T/oHta5x+EVIKjI9S35uvyyWq8nbucZUZPqzfpgqC4aUWCK8cGO2CQxYyK2/tCEgCsVrIrETmvohQnTEqREGfDpMRKnp9eMMWXJXUJa8noR3w/WUaMKzDwdhbpiHHdqoCob7AvVSEkm2gP4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=UvBQlARU; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 446GH6lL026899;
	Mon, 6 May 2024 16:18:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=1ZljFRPQkJliM89Aj1uqay/WLHKarY1XQa8XB660YSs=;
 b=UvBQlARUFXa/fssmm0GGeaXvHKxkwHVeJRHjzsx9EjlVZwcx2gaOmqGdTvp3/BH4cBWa
 rg2mgmX2GkHD4CtQAxMrn3WVw0pR0xeqDMat8jnG/YzCuWJ+un3C2WfKShK2bs9qzwj6
 wrhe6LJT5YRZBzFSOvZfuUviKlDDd5noe2Q1Mr2qdYHQVmlc/T1k6Ey3xPKndO9Oir/P
 p0sqca5LrHwRC+4+GxzOjw8UC6OK8BsD9vCW5i7LIcr8qP+WkiTe4A5Xno2smzTOqEpJ
 v/UVXYTf/Tw4XJzduVi7yOrSMOnPqqqL7jkrXItFwf24mm7p7NU90X74BJfePVl01/zc 2A== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xy2ka806e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 May 2024 16:18:04 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 446GI4K0029545;
	Mon, 6 May 2024 16:18:04 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xy2ka806b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 May 2024 16:18:03 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 446DklrG022497;
	Mon, 6 May 2024 16:18:02 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3xx1jkrj34-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 May 2024 16:18:02 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 446GHvTo57016824
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 6 May 2024 16:17:59 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 890BE20040;
	Mon,  6 May 2024 16:17:57 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A564F20043;
	Mon,  6 May 2024 16:17:51 +0000 (GMT)
Received: from li-c6426e4c-27cf-11b2-a85c-95d65bc0de0e.ibm.com.com (unknown [9.43.105.31])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  6 May 2024 16:17:51 +0000 (GMT)
From: Gautam Menghani <gautam@linux.ibm.com>
To: mpe@ellerman.id.au, npiggin@gmail.com, christophe.leroy@csgroup.eu,
        naveen.n.rao@linux.ibm.com
Cc: Gautam Menghani <gautam@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] arch/powerpc/kvm: Use bitmap to speed up resend of irqs in ICS
Date: Mon,  6 May 2024 21:47:29 +0530
Message-ID: <20240506161735.83358-2-gautam@linux.ibm.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240506161735.83358-1-gautam@linux.ibm.com>
References: <20240506161735.83358-1-gautam@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: I0zi3wmf-XEqBJBOGsx18Ged2lPofcQi
X-Proofpoint-ORIG-GUID: EmSSA70nkoVw2EnX0XdqyKahIU2YJXJc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-06_11,2024-05-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 phishscore=0 suspectscore=0 mlxscore=0
 priorityscore=1501 bulkscore=0 impostorscore=0 spamscore=0 malwarescore=0
 mlxlogscore=493 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2404010000 definitions=main-2405060114

When an irq is to be resent, all 1024 irqs in an ICS are scanned and the
irqs having 'resend' flag set are resent. Optimize this flow using bitmap
array to speed up the resends.

Signed-off-by: Gautam Menghani <gautam@linux.ibm.com>
---
 arch/powerpc/kvm/book3s_xics.c | 22 +++++++++++-----------
 arch/powerpc/kvm/book3s_xics.h |  1 +
 2 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_xics.c b/arch/powerpc/kvm/book3s_xics.c
index 589a8f257120..12de526f04c4 100644
--- a/arch/powerpc/kvm/book3s_xics.c
+++ b/arch/powerpc/kvm/book3s_xics.c
@@ -47,9 +47,6 @@
  * TODO
  * ====
  *
- * - To speed up resends, keep a bitmap of "resend" set bits in the
- *   ICS
- *
  * - Speed up server# -> ICP lookup (array ? hash table ?)
  *
  * - Make ICS lockless as well, or at least a per-interrupt lock or hashed
@@ -125,15 +122,17 @@ static int ics_deliver_irq(struct kvmppc_xics *xics, u32 irq, u32 level)
 static void ics_check_resend(struct kvmppc_xics *xics, struct kvmppc_ics *ics,
 			     struct kvmppc_icp *icp)
 {
-	int i;
+	u32 irq;
+	struct ics_irq_state *state;
 
-	for (i = 0; i < KVMPPC_XICS_IRQ_PER_ICS; i++) {
-		struct ics_irq_state *state = &ics->irq_state[i];
-		if (state->resend) {
-			XICS_DBG("resend %#x prio %#x\n", state->number,
-				      state->priority);
-			icp_deliver_irq(xics, icp, state->number, true);
-		}
+	for_each_set_bit(irq, ics->resend_map, KVMPPC_XICS_IRQ_PER_ICS) {
+		state = &ics->irq_state[irq];
+
+		if (!test_and_clear_bit(irq, ics->resend_map))
+			continue;
+		if (!state)
+			continue;
+		icp_deliver_irq(xics, icp, state->number, true);
 	}
 }
 
@@ -489,6 +488,7 @@ static void icp_deliver_irq(struct kvmppc_xics *xics, struct kvmppc_icp *icp,
 		 */
 		smp_wmb();
 		set_bit(ics->icsid, icp->resend_map);
+		set_bit(src, ics->resend_map);
 
 		/*
 		 * If the need_resend flag got cleared in the ICP some time
diff --git a/arch/powerpc/kvm/book3s_xics.h b/arch/powerpc/kvm/book3s_xics.h
index 08fb0843faf5..8fcb34ea47a4 100644
--- a/arch/powerpc/kvm/book3s_xics.h
+++ b/arch/powerpc/kvm/book3s_xics.h
@@ -98,6 +98,7 @@ struct kvmppc_ics {
 	arch_spinlock_t lock;
 	u16 icsid;
 	struct ics_irq_state irq_state[KVMPPC_XICS_IRQ_PER_ICS];
+	DECLARE_BITMAP(resend_map, KVMPPC_XICS_IRQ_PER_ICS);
 };
 
 struct kvmppc_xics {
-- 
2.44.0


