Return-Path: <kvm+bounces-16172-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 73A1C8B5E4D
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 17:58:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 34C50B24B15
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 15:58:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0051184D06;
	Mon, 29 Apr 2024 15:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SpITK5K/"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0A4082D7C;
	Mon, 29 Apr 2024 15:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714406270; cv=none; b=eWmeVhvm2q6zva9rWTYTrf7Du1f+cluEIcr7GneyKBOqlKn+oB9uVTkYv4lIdn01pcSsbyNjM7/t9umQYrI5gRm/daMTBKPoJo24U0I4TCexgbpw3yJowYupWmb4wq0wBIGjcHgHlb0QzDpqTgcznylVRi1/h2EpXWJFKrh0348=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714406270; c=relaxed/simple;
	bh=kD+D/2NFmo6Jf6tcxV53dZCI5gWFzqlfjYjOfIed1X4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DiDDw7B9ZCvWrVUYvIIdX9ZxN2qRIJnNUTqSD/WokH7cmLDvWPFJ9kmzWPsUlYvjpyjdghumAO3jvVGBRaOOrZL3SecuHNplyw9zoQ4jsaPIRV02oaWZL41aw9TK6Lub+SUw0EOvqw3WZe3LJMw8xoWIioo2NPjD//4q/7Fnbxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=SpITK5K/; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43TFmkww006744;
	Mon, 29 Apr 2024 15:57:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-11-20;
 bh=PBi5rXGW3IONrVECLMotjHdxT/VjBv5UCgvhocP4s54=;
 b=SpITK5K/JsROmI9bVB0HI5RoKX+46Qor5WJMoJIVK6KbJ9LCbjmjX63XQCZ3VqdwXT7s
 ttxsNhJksOoshpIrfdIM5pEtqRM/QSYvok0VMdGP87vLWtxubnWF7QUV+VAz7morwqYl
 ca2NZ+LXZC3fBwoY1yC/sWEEL/F+jTus58sd+KTqPO9Tmqne0ZQgqtyRaOJ21FKUjTmS
 fIMpsw5YKC3dHjQZH5RVFY1YlkqBHOm4pmkrMOKUutcI73Mf7tVStsXnYk+PWMiPsctz
 tSH/EyQ3cDlLdYd0064QBA+Q7wvFL46Bn8spMZGf6ZxVzO8LLvp8mZm4JgFX6k6E2AMR ew== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xrsdejwup-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 29 Apr 2024 15:57:43 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 43TEcwQ6011335;
	Mon, 29 Apr 2024 15:57:42 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xrqt6j95m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 29 Apr 2024 15:57:42 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 43TFuxjM040299;
	Mon, 29 Apr 2024 15:57:42 GMT
Received: from alaljime-dev-e4flex-vm.osdevelopmeniad.oraclevcn.com (alaljime-dev-e4flex-vm.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.249.106])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3xrqt6j91w-2;
	Mon, 29 Apr 2024 15:57:42 +0000
From: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
To: kvm@vger.kernel.org
Cc: seanjc@google.com, pbonzini@redhat.com, linux-kernel@vger.kernel.org,
        suravee.suthikulpanit@amd.com, vashegde@amd.com, mlevitsk@redhat.com,
        joao.m.martins@oracle.com, boris.ostrovsky@oracle.com,
        mark.kanda@oracle.com, alejandro.j.jimenez@oracle.com
Subject: [PATCH 1/4] KVM: x86: Expose per-vCPU APICv status
Date: Mon, 29 Apr 2024 15:57:35 +0000
Message-Id: <20240429155738.990025-2-alejandro.j.jimenez@oracle.com>
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
X-Proofpoint-GUID: faF3Eo7RghRW60RkookFeY1oCaAqZqld
X-Proofpoint-ORIG-GUID: faF3Eo7RghRW60RkookFeY1oCaAqZqld

Expose the APICv activation status of individual vCPUs via the stats
subsystem. In special cases a vCPU's APICv can be deactivated/disabled
even though there are no VM-wide inhibition reasons. The only current
example of this is AVIC for a vCPU running in nested mode. This type of
inhibition is not recorded in the VM inhibit reasons or visible in
current tracepoints.

Signed-off-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/lapic.c            | 1 +
 arch/x86/kvm/x86.c              | 2 ++
 3 files changed, 4 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 1d13e3cd1dc5..12f30cb5c842 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1573,6 +1573,7 @@ struct kvm_vcpu_stat {
 	u64 preemption_other;
 	u64 guest_mode;
 	u64 notify_window_exits;
+	u64 apicv_active;
 };
 
 struct x86_instruction_info;
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index cf37586f0466..37fe75a5db8c 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2872,6 +2872,7 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu, int timer_advance_ns)
 	 */
 	if (enable_apicv) {
 		apic->apicv_active = true;
+		vcpu->stat.apicv_active = apic->apicv_active;
 		kvm_make_request(KVM_REQ_APICV_UPDATE, vcpu);
 	}
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e9ef1fa4b90b..0451c4c8d731 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -304,6 +304,7 @@ const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
 	STATS_DESC_COUNTER(VCPU, preemption_other),
 	STATS_DESC_IBOOLEAN(VCPU, guest_mode),
 	STATS_DESC_COUNTER(VCPU, notify_window_exits),
+	STATS_DESC_IBOOLEAN(VCPU, apicv_active),
 };
 
 const struct kvm_stats_header kvm_vcpu_stats_header = {
@@ -10625,6 +10626,7 @@ void __kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
 		goto out;
 
 	apic->apicv_active = activate;
+	vcpu->stat.apicv_active = apic->apicv_active;
 	kvm_apic_update_apicv(vcpu);
 	static_call(kvm_x86_refresh_apicv_exec_ctrl)(vcpu);
 
-- 
2.39.3


