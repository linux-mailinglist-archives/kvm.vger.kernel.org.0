Return-Path: <kvm+bounces-16175-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E57658B5E54
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 17:59:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 98A7F2845A7
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 15:59:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9889585C79;
	Mon, 29 Apr 2024 15:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FjuVDr57"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A2BB83A08;
	Mon, 29 Apr 2024 15:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714406278; cv=none; b=jlxIDYQMGKXoxXvn6bf6aP2y3KQ4LcSbEj8YxAF5Fm1bHfU9eH/UU2kE9PQjY3l4T1eYjPWPJeWpYe2CBBiIf5sefI5uaesTx6HS2Th1+QxKvKwS5cKEOX5agfN8VM0CpqKKv5q8S3cgm3TLApUOldSnpNJUgWdqgzly5OV4bUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714406278; c=relaxed/simple;
	bh=R1npkU7NnhMaEAo02aQmqCLNDfuXn+An7TzBkaPxtlg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JyD8xt7EtM1UMqO3nJNtOHz0lFB1/FOgeJcIatGBHSqFols/nxbJ1yiWxmZ4n3fzNo+QoOzTVu4X6xoC/6SphXa1D/HlIlrP1oB2dSrYJMckPfCTucTLABYKX33vY3ZfIerOUUd595s5JMOQtCK8jRBw84KmW1wEjs9NEj++hiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=FjuVDr57; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43TFmj9k006699;
	Mon, 29 Apr 2024 15:57:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-11-20;
 bh=7uCCKhplZr7mxOWs1OV2xLVt93NnadxTgAHX9zBzeUg=;
 b=FjuVDr57cVSzcGoZdM8Qv6BAvTVsKQYS+aR8llsLONHIspb1YGoxh6FivV7vLC+KzTxP
 um6PjlwebAXOmw6898HRX8FEQwzE6XWjp2WCYBnC6BYzp85HI+dYWNa/d3j5vP59QUYl
 /fEffKP2hi6kdo9CY34LX5KXzYZSluDaEX0dGmT/M3jp2qiJVFKPntrf0ZgfpPFmgwIq
 EYd7gxAWvGLXJEEUps4Usf8/T+64997XIXH+elczVtfipAkjCzi/Ii8NfieERXJH2yLE
 vcvD2gLx83socBWth/DV5eRZLtgXHAzUae3R/2OVcWlrJSQP8FX+7IvPyHTiLbCVeuFm ww== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xrsdejwuu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 29 Apr 2024 15:57:49 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 43TFdB04011361;
	Mon, 29 Apr 2024 15:57:48 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xrqt6j99w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 29 Apr 2024 15:57:48 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 43TFuxjS040299;
	Mon, 29 Apr 2024 15:57:47 GMT
Received: from alaljime-dev-e4flex-vm.osdevelopmeniad.oraclevcn.com (alaljime-dev-e4flex-vm.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.249.106])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3xrqt6j91w-5;
	Mon, 29 Apr 2024 15:57:47 +0000
From: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
To: kvm@vger.kernel.org
Cc: seanjc@google.com, pbonzini@redhat.com, linux-kernel@vger.kernel.org,
        suravee.suthikulpanit@amd.com, vashegde@amd.com, mlevitsk@redhat.com,
        joao.m.martins@oracle.com, boris.ostrovsky@oracle.com,
        mark.kanda@oracle.com, alejandro.j.jimenez@oracle.com
Subject: [PATCH 4/4] KVM: x86: Add vCPU stat for APICv interrupt injections causing #VMEXIT
Date: Mon, 29 Apr 2024 15:57:38 +0000
Message-Id: <20240429155738.990025-5-alejandro.j.jimenez@oracle.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240429155738.990025-1-alejandro.j.jimenez@oracle.com>
References: <20240429155738.990025-1-alejandro.j.jimenez@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-04-29_14,2024-04-29_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 adultscore=0 mlxscore=0 suspectscore=0 phishscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404290101
X-Proofpoint-GUID: xg8gd8qHGZgxX_M2IfeAxc9sVgG0zQgs
X-Proofpoint-ORIG-GUID: xg8gd8qHGZgxX_M2IfeAxc9sVgG0zQgs

Even when APICv/AVIC is active, certain guest accesses to its local APIC(s)
cannot be fully accelerated, and cause a #VMEXIT to allow the VMM to
emulate the behavior and side effects. Expose a counter stat for these
specific #VMEXIT types.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/svm/avic.c         | 7 +++++++
 arch/x86/kvm/vmx/vmx.c          | 2 ++
 arch/x86/kvm/x86.c              | 1 +
 4 files changed, 11 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e7e3213cefae..388979dfe9f3 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1576,6 +1576,7 @@ struct kvm_vcpu_stat {
 	u64 guest_mode;
 	u64 notify_window_exits;
 	u64 apicv_active;
+	u64 apicv_unaccelerated_inj;
 };
 
 struct x86_instruction_info;
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 4b74ea91f4e6..274041d3cf66 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -517,6 +517,8 @@ int avic_incomplete_ipi_interception(struct kvm_vcpu *vcpu)
 			kvm_apic_write_nodecode(vcpu, APIC_ICR);
 		else
 			kvm_apic_send_ipi(apic, icrl, icrh);
+
+		++vcpu->stat.apicv_unaccelerated_inj;
 		break;
 	case AVIC_IPI_FAILURE_TARGET_NOT_RUNNING:
 		/*
@@ -525,6 +527,8 @@ int avic_incomplete_ipi_interception(struct kvm_vcpu *vcpu)
 		 * vcpus. So, we just need to kick the appropriate vcpu.
 		 */
 		avic_kick_target_vcpus(vcpu->kvm, apic, icrl, icrh, index);
+
+		++vcpu->stat.apicv_unaccelerated_inj;
 		break;
 	case AVIC_IPI_FAILURE_INVALID_BACKING_PAGE:
 		WARN_ONCE(1, "Invalid backing page\n");
@@ -704,6 +708,9 @@ int avic_unaccelerated_access_interception(struct kvm_vcpu *vcpu)
 
 	trace_kvm_avic_unaccelerated_access(vcpu->vcpu_id, offset,
 					    trap, write, vector);
+
+	++vcpu->stat.apicv_unaccelerated_inj;
+
 	if (trap) {
 		/* Handling Trap */
 		WARN_ONCE(!write, "svm: Handling trap read.\n");
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index f10b5f8f364b..a7487f12ded1 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5657,6 +5657,8 @@ static int handle_apic_write(struct kvm_vcpu *vcpu)
 {
 	unsigned long exit_qualification = vmx_get_exit_qual(vcpu);
 
+	++vcpu->stat.apicv_unaccelerated_inj;
+
 	/*
 	 * APIC-write VM-Exit is trap-like, KVM doesn't need to advance RIP and
 	 * hardware has done any necessary aliasing, offset adjustments, etc...
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 03cb933920cb..c8730b0fac87 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -307,6 +307,7 @@ const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
 	STATS_DESC_IBOOLEAN(VCPU, guest_mode),
 	STATS_DESC_COUNTER(VCPU, notify_window_exits),
 	STATS_DESC_IBOOLEAN(VCPU, apicv_active),
+	STATS_DESC_COUNTER(VCPU, apicv_unaccelerated_inj),
 };
 
 const struct kvm_stats_header kvm_vcpu_stats_header = {
-- 
2.39.3


