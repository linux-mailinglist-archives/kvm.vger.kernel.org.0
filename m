Return-Path: <kvm+bounces-8800-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 962608568AD
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 17:02:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4A2AA1F23888
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 16:02:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9563E134CC0;
	Thu, 15 Feb 2024 16:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MupD0bbz"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEA5013399E;
	Thu, 15 Feb 2024 16:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708012911; cv=none; b=Avz+LX4aJzIzyq7ra7wd4Jwp1t/QSOpjOCR58xVefsdjCvEyKYDLiHasfFkJaI2Zea/TysTnq17uRIN0dUOJxFr9i8b22fFHEITqGpUlEPWGWh/ulYhs6RNUW9AHotGDAf3rEsRy+SoZIA0X6mRs1oGIPiuqc1Tz3YSj2RBxH7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708012911; c=relaxed/simple;
	bh=Xo9WnM9493Bm4oY4MEkdUim500HA8+J/7lGWj8KvKaU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=K3B4nt1EvQ3u1o5sWpMYeNLB2/9zafBHUgb7/a4AkdwU00YOdAq2T/eBEDtBoLULVRZJbrsQQQG09ceZCQ1ASGA8/nQ97e7Oc4tPHaVLyqZFJBLQyh2xEfftFmzYk54L6hf8wyt6vu5JjT+V33gNDkKA9VSdnjm1a6AKUmBf86M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=MupD0bbz; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41FFTS7Q006052;
	Thu, 15 Feb 2024 16:01:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-11-20;
 bh=saWiS+8K1cygqHiQXZAlnKyAJWO/e2zPPqHJyjJ7EyQ=;
 b=MupD0bbzprxVOlTYGacXFVKrsQ4lXxUz+uLbFX33oX6oAHdprRurmF+vs6iuZjf4ahGA
 EA86E6+7EoOxBh1QMJPnbjzxMBaa0/3fbOIXD7IjxNGpS5Tupn3w4bmA2YnPwawcA9x0
 o2RSMvgzLarmF5Xg7UqZJUhueb9oVI0gQV7sxvmQDhsIRoCzzM1CuJ5N/pXK7LSLDORG
 E3t+cqbz+L4DwAaQCTdM6ifiLQNZPPTp446Kma+WvjwvpZXkW5KKHWDNxL7gX6Kg49CM
 ozXPaM0Vcxhew9RNB5TNonzIdureRSOtklcrVpLRLc138ZS0zG8fs3SpBfc/Az4vdyzc Bg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3w92s72h72-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Feb 2024 16:01:43 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 41FExkjD013877;
	Thu, 15 Feb 2024 16:01:43 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3w6apdkewc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Feb 2024 16:01:43 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 41FG1cZY031601;
	Thu, 15 Feb 2024 16:01:42 GMT
Received: from alaljime-dev-e4flex-vm.osdevelopmeniad.oraclevcn.com (alaljime-dev-e4flex-vm.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.249.106])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3w6apdkep6-4;
	Thu, 15 Feb 2024 16:01:42 +0000
From: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
To: kvm@vger.kernel.org
Cc: seanjc@google.com, pbonzini@redhat.com, linux-kernel@vger.kernel.org,
        joao.m.martins@oracle.com, boris.ostrovsky@oracle.com,
        mark.kanda@oracle.com, suravee.suthikulpanit@amd.com,
        mlevitsk@redhat.com, alejandro.j.jimenez@oracle.com
Subject: [RFC 3/3] x86: KVM: stats: Add a stat counter for GALog events
Date: Thu, 15 Feb 2024 16:01:36 +0000
Message-Id: <20240215160136.1256084-4-alejandro.j.jimenez@oracle.com>
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
X-Proofpoint-GUID: twgFqR75LUrbW0Xlv5Pf4z4UXp1zkY80
X-Proofpoint-ORIG-GUID: twgFqR75LUrbW0Xlv5Pf4z4UXp1zkY80

Export a per-vCPU binary stat counting GALog events received. Such events
are specific to IOMMU AVIC, and their presence can be used to confirm that
this capability is active. Also, exporting this statistic is useful to
assert that device interrupts are being sent to specific vCPUs, confirming
IRQ affinity settings.

Signed-off-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/svm/avic.c         | 4 +++-
 arch/x86/kvm/x86.c              | 1 +
 3 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index b6f18084d504..74e08b57f2e0 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1565,6 +1565,7 @@ struct kvm_vcpu_stat {
 	u64 guest_mode;
 	u64 notify_window_exits;
 	u64 apicv_accept_irq;
+	u64 ga_log_event;
 };
 
 struct x86_instruction_info;
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 4b74ea91f4e6..853cafe4a9af 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -165,8 +165,10 @@ int avic_ga_log_notifier(u32 ga_tag)
 	 * bit in the vAPIC backing page. So, we just need to schedule
 	 * in the vcpu.
 	 */
-	if (vcpu)
+	if (vcpu) {
 		kvm_vcpu_wake_up(vcpu);
+		++vcpu->stat.ga_log_event;
+	}
 
 	return 0;
 }
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2ad70cf6e52c..6a1df29ae650 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -305,6 +305,7 @@ const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
 	STATS_DESC_IBOOLEAN(VCPU, guest_mode),
 	STATS_DESC_COUNTER(VCPU, notify_window_exits),
 	STATS_DESC_COUNTER(VCPU, apicv_accept_irq),
+	STATS_DESC_COUNTER(VCPU, ga_log_event),
 };
 
 const struct kvm_stats_header kvm_vcpu_stats_header = {
-- 
2.39.3


