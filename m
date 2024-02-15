Return-Path: <kvm+bounces-8799-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id ADA9E8568AB
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 17:02:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 623551F2550C
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 16:02:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0A4913473B;
	Thu, 15 Feb 2024 16:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="icbN689W"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A8B953369;
	Thu, 15 Feb 2024 16:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708012911; cv=none; b=Ar8jkNk1L9d2uP8U7MUI0UHag7LCqoNF3QWii/AgXgFfP8ieETm+3i0k5EMB7aQqbmgd41ZbWSqUsITdVAs5jSov4ZK1mdoZ/CHUStmLRoU004XsgBGHnEr27WCmMTWNAic6vlelZYnwYVZG/VnfOvbX1fGsD0kgwiIFST4Kl78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708012911; c=relaxed/simple;
	bh=R8BSvkkG8B1Q3ey87bWjhKkTTn8tS5TYT9HTwPNq0CU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lAD9D63ZCNE4hUM2e9czlmszgqxZjtKpGdL6JJa5KUZAT7SVP19pts1L1LmMZ7569LD8PoYzF4B4IUo9DLXb47TaM6qdJRIHTESG/maTesGfwz/qZ5fCiARE8khClI+aBAksMAJXKvTXj/RiuA/YE9DHECM73fz/MhWMLh1XcEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=icbN689W; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41FFTYmv030204;
	Thu, 15 Feb 2024 16:01:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-11-20;
 bh=tFGju7bPNchiqt2tnKGa3v1xLt3nHlirTspnDjTX6L4=;
 b=icbN689W0HGSoYorX178SmDDUqn6jZmge5q+bcM0X0oZiDe9tZjsIvbs+Uto87U6SeN2
 PLChoH/tE98WMJRO/iKEMgat0y5gm6ReImvfARef6reYqA0JVWLM+gcEweAsqxle1rfx
 zhPxqN8Qfoey/tB5fNXxH7tY6fwHwe4cPcN+r3dma/9nSGispnc1znu0rdHHxh2CHAZn
 mo5E8CNjVa5yqrq4OyrykYlfUF3EnJWJ3HQzDxVCsKQaevAJzmy9c0nAdzPPqYg176gP
 eEe6S/KgYQpr6f4LBY0yJA60DFYY2V3zZJwgV186Dz1Qw6dH9cGblVEAcqcHNHHMsm8B Ig== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3w91f02t93-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Feb 2024 16:01:42 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 41FFecT6013775;
	Thu, 15 Feb 2024 16:01:41 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3w6apdkeup-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Feb 2024 16:01:41 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 41FG1cZW031601;
	Thu, 15 Feb 2024 16:01:41 GMT
Received: from alaljime-dev-e4flex-vm.osdevelopmeniad.oraclevcn.com (alaljime-dev-e4flex-vm.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.249.106])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3w6apdkep6-3;
	Thu, 15 Feb 2024 16:01:41 +0000
From: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
To: kvm@vger.kernel.org
Cc: seanjc@google.com, pbonzini@redhat.com, linux-kernel@vger.kernel.org,
        joao.m.martins@oracle.com, boris.ostrovsky@oracle.com,
        mark.kanda@oracle.com, suravee.suthikulpanit@amd.com,
        mlevitsk@redhat.com, alejandro.j.jimenez@oracle.com
Subject: [RFC 2/3] x86: KVM: stats: Add stat counter for IRQs injected via APICv
Date: Thu, 15 Feb 2024 16:01:35 +0000
Message-Id: <20240215160136.1256084-3-alejandro.j.jimenez@oracle.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240215160136.1256084-1-alejandro.j.jimenez@oracle.com>
References: <20240215160136.1256084-1-alejandro.j.jimenez@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-15_14,2024-02-14_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 mlxscore=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402150128
X-Proofpoint-ORIG-GUID: ecyd8N_T40VKvEXxh8sQtaG9KXfqb93D
X-Proofpoint-GUID: ecyd8N_T40VKvEXxh8sQtaG9KXfqb93D

Export binary stat counting how many interrupts have been delivered via
APICv/AVIC acceleration from the host. This is one of the most reliable
methods to detect when hardware accelerated interrupt delivery is active,
since APIC timer interrupts are regularly injected and exercise these
code paths.

Signed-off-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/svm/svm.c          | 3 +++
 arch/x86/kvm/vmx/vmx.c          | 2 ++
 arch/x86/kvm/x86.c              | 1 +
 4 files changed, 7 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 9b960a523715..b6f18084d504 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1564,6 +1564,7 @@ struct kvm_vcpu_stat {
 	u64 preemption_other;
 	u64 guest_mode;
 	u64 notify_window_exits;
+	u64 apicv_accept_irq;
 };
 
 struct x86_instruction_info;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index e90b429c84f1..2243af08ed39 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3648,6 +3648,9 @@ void svm_complete_interrupt_delivery(struct kvm_vcpu *vcpu, int delivery_mode,
 	}
 
 	trace_kvm_apicv_accept_irq(vcpu->vcpu_id, delivery_mode, trig_mode, vector);
+
+	++vcpu->stat.apicv_accept_irq;
+
 	if (in_guest_mode) {
 		/*
 		 * Signal the doorbell to tell hardware to inject the IRQ.  If
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d4e6625e0a9a..f7db75ae2c55 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4275,6 +4275,8 @@ static void vmx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
 	} else {
 		trace_kvm_apicv_accept_irq(vcpu->vcpu_id, delivery_mode,
 					   trig_mode, vector);
+
+		++vcpu->stat.apicv_accept_irq;
 	}
 }
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f7f598f066e7..2ad70cf6e52c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -304,6 +304,7 @@ const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
 	STATS_DESC_COUNTER(VCPU, preemption_other),
 	STATS_DESC_IBOOLEAN(VCPU, guest_mode),
 	STATS_DESC_COUNTER(VCPU, notify_window_exits),
+	STATS_DESC_COUNTER(VCPU, apicv_accept_irq),
 };
 
 const struct kvm_stats_header kvm_vcpu_stats_header = {
-- 
2.39.3


