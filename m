Return-Path: <kvm+bounces-15048-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 148D08A911F
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 04:19:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 943BC281DCC
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 02:19:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48B0C4F218;
	Thu, 18 Apr 2024 02:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ORlCIRlN"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3EB56FB0;
	Thu, 18 Apr 2024 02:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713406719; cv=none; b=tKmGehBwCcAZXbojWuTYa5Azl2bj/fch5ryBGiIncC8KwclEnQPdzkYAtNtUdJkHWuQ3wOBMqiA7U2/O+Vska8K9lA3E4+KXFbmnpjCcSjfPTaAupL+oh1Jfk4aLjtQIM1XwL617f9SExnWQsMgC5lxHKy2fXKXU3Zy/ely/WRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713406719; c=relaxed/simple;
	bh=oQpiWnJBZrZr5K7EFvEe+HixtI3es0yTeL+0nXlBB3k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=aCc7xb8F/xsCI67f7KrK01QU64R+gI7x1NlFCeen9x/t2pOhqCkIy1Er38Eon77Cj8G6nS7Lt7nrIkmmNHq6xKP3fCWsKgcTHVMQrDTuVO/zqqGL1kMHD7dyQ7oTKn/Rg8wfnlXJ2l82ZsC6ibDH6cmYCONvTEUvUq7v3XcXQfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ORlCIRlN; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43HM5CxA012527;
	Thu, 18 Apr 2024 02:18:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-11-20;
 bh=wiNpZO58EjLUyweT0dnyy20j0eWeP31mSBEQlOyqWFY=;
 b=ORlCIRlNB5QimE+bb091LVCN+/R6COLt6FYjpSCKmmCxbXcoYvkGfo+4JZVknrOO+8VP
 oDYywVE+bLZaZP/gX56ldCmc214Th9TpnFXg2m9qnwVCRkvzH9s+ocXkcziHgTEjgp9f
 0bVr0kobrc5AR6AQPYbOyMuplWGU5MUHUeUntzhVLVsg1KJIBjzspDz0uvmIAhsPMExZ
 YGvppuWAyVHYhC44QZ3PIAazA5FDdeLbwLObCCglhCs96Rt0dHQTSBbYpE5Vdtlqpvhq
 KYx+Hx1RKNNvu4sjA8zp/pxsfHdDTkNqEefqvBB7D8jOPnVmLOAR/m0Z55rgvh8wgRKd dA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xfgn2s9gj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Apr 2024 02:18:32 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 43I1jG04029181;
	Thu, 18 Apr 2024 02:18:32 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xfgg9qa2e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Apr 2024 02:18:32 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 43I2ITLq012052;
	Thu, 18 Apr 2024 02:18:31 GMT
Received: from alaljime-dev-e4flex-vm.osdevelopmeniad.oraclevcn.com (alaljime-dev-e4flex-vm.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.249.106])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3xfgg9q9y8-3;
	Thu, 18 Apr 2024 02:18:31 +0000
From: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
To: kvm@vger.kernel.org, seanjc@google.com
Cc: pbonzini@redhat.com, linux-kernel@vger.kernel.org,
        joao.m.martins@oracle.com, boris.ostrovsky@oracle.com,
        suravee.suthikulpanit@amd.com, mlevitsk@redhat.com,
        alejandro.j.jimenez@oracle.com
Subject: [PATCH v2 2/2] KVM: x86: Remove VT-d mention in posted interrupt tracepoint
Date: Thu, 18 Apr 2024 02:18:23 +0000
Message-Id: <20240418021823.1275276-3-alejandro.j.jimenez@oracle.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240418021823.1275276-1-alejandro.j.jimenez@oracle.com>
References: <20240418021823.1275276-1-alejandro.j.jimenez@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-18_01,2024-04-17_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 mlxscore=0 malwarescore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404180015
X-Proofpoint-ORIG-GUID: HqoFHBG1TtnDZsAVsCNUDbLCwOvve6Tq
X-Proofpoint-GUID: HqoFHBG1TtnDZsAVsCNUDbLCwOvve6Tq

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


