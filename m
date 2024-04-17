Return-Path: <kvm+bounces-15006-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ACB438A8CC6
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 22:09:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 66A5E283291
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 20:09:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D53C33A267;
	Wed, 17 Apr 2024 20:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Sr++p7f5"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BBF236126;
	Wed, 17 Apr 2024 20:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713384540; cv=none; b=jpm0yH2lctjy2sv1wrNwrhzspBgqfpD0797k2bE3dkRRoZ/tKQvrJEt5dOxFmD3VrHuc+DA0iyVv8ouYtE76+/NPZoUZbQ2b+jE8KTKWcgqXcieGyqWks0q3emk4itA5Ov+BGL80kox6rzQW9IEfDZM+4f2DSQxTHwV129iPuzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713384540; c=relaxed/simple;
	bh=oQpiWnJBZrZr5K7EFvEe+HixtI3es0yTeL+0nXlBB3k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rDds/KWCq8xNvRIoaW7DTqNReA+3dbqnThgDnaz3H+WJeiXiGtcGVjpzrlkYpmNAEy4dW17bvdIYuPd1IZ76J3V5GElsgw0nnSj6GPI8X04vbcjn6JkxZNU/miJplPxqKuZ13Bga9ANEtpvyyp9ds7fmIplSa5+zr6SE+w2MvHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Sr++p7f5; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43HHiVcQ006061;
	Wed, 17 Apr 2024 20:08:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-11-20;
 bh=wiNpZO58EjLUyweT0dnyy20j0eWeP31mSBEQlOyqWFY=;
 b=Sr++p7f5+2U//Uz+M8f1BBP0dK8tFnFWH11w0UFxiOdB62nOalTtSl92pQVOk5QF3zWN
 g8lvdgWMH+TpE25fqyR94rqr0kCpHeJMKm8xJ5nW/65JPHLH2wKGXtIk5h5MnOv8zL/R
 xkq9+8ODv42qySKnZajC28DXsipUTJGD49vJiEcfg7C0xctzXvefM/soo4QcN+mGjv8m
 h1suHZdWeMf3qt6Y4yE4VsTqMk3z5SmjQr7T7HTsnkwB5rkY232rovkNTabhumPqxdnP
 opLPPy77PNpFP9cIMeWmVOIgAhOmXT63gxDRu7g4e6jn/2o//7Alh/dcN930UwCJ101s fA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xfhxbrqfj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Apr 2024 20:08:53 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 43HJvPoY022438;
	Wed, 17 Apr 2024 20:08:52 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3xfggfny93-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Apr 2024 20:08:52 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 43HK8oFR023405;
	Wed, 17 Apr 2024 20:08:51 GMT
Received: from alaljime-dev-e4flex-vm.osdevelopmeniad.oraclevcn.com (alaljime-dev-e4flex-vm.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.249.106])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3xfggfny84-3;
	Wed, 17 Apr 2024 20:08:51 +0000
From: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
To: kvm@vger.kernel.org
Cc: seanjc@google.com, pbonzini@redhat.com, linux-kernel@vger.kernel.org,
        joao.m.martins@oracle.com, boris.ostrovsky@oracle.com,
        suravee.suthikulpanit@amd.com, mlevitsk@redhat.com,
        alejandro.j.jimenez@oracle.com
Subject: [PATCH 2/2] KVM: x86: Remove VT-d mention in posted interrupt tracepoint
Date: Wed, 17 Apr 2024 20:08:49 +0000
Message-Id: <20240417200849.971433-3-alejandro.j.jimenez@oracle.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240417200849.971433-1-alejandro.j.jimenez@oracle.com>
References: <20240417200849.971433-1-alejandro.j.jimenez@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-17_17,2024-04-17_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 mlxlogscore=999
 suspectscore=0 adultscore=0 phishscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2404010000
 definitions=main-2404170141
X-Proofpoint-ORIG-GUID: 2zrGgiVXvghqn_jEgNYI-0NfXTRS20xP
X-Proofpoint-GUID: 2zrGgiVXvghqn_jEgNYI-0NfXTRS20xP

The kvm_pi_irte_update tracepoint is called from both SVM and VMX vendor
code, and while the "posted interrupt" naming is also adopted by SVM in
several places, VT-d specifically refers to Intel's "Virtualization
Technology for Directed I/O".

Signed-off-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
---
 arch/x86/kvm/trace.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index c6b4b1728006..9d0b02ef307e 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -1074,7 +1074,7 @@ TRACE_EVENT(kvm_smm_transition,
 );
 
 /*
- * Tracepoint for VT-d posted-interrupts.
+ * Tracepoint for VT-d posted-interrupts and AMD-Vi Guest Virtual APIC.
  */
 TRACE_EVENT(kvm_pi_irte_update,
 	TP_PROTO(unsigned int host_irq, unsigned int vcpu_id,
@@ -1100,7 +1100,7 @@ TRACE_EVENT(kvm_pi_irte_update,
 		__entry->set		= set;
 	),
 
-	TP_printk("VT-d PI is %s for irq %u, vcpu %u, gsi: 0x%x, "
+	TP_printk("PI is %s for irq %u, vcpu %u, gsi: 0x%x, "
 		  "gvec: 0x%x, pi_desc_addr: 0x%llx",
 		  __entry->set ? "enabled and being updated" : "disabled",
 		  __entry->host_irq,
-- 
2.39.3


