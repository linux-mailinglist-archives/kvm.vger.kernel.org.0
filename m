Return-Path: <kvm+bounces-8801-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B1798568AF
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 17:02:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3FFF71F236A9
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 16:02:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 831D0134CF4;
	Thu, 15 Feb 2024 16:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Nv1C6qI1"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 224731339BB;
	Thu, 15 Feb 2024 16:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708012912; cv=none; b=FOeq9CRFlVZ7E6i+TyoXnozNnKhOqsJOEp+ab+kNNTB5Ey3Ng7DoQVrTg1i8KVZ6d/MPLVliFztqWdk5fnfPtRw9k8K37a1VDpFw5M8bk1G+ZsPlQChpS7jmx0o7yM+txs7+he7NoQ5bwJkCIo23H76OTNoN638XQXXmibYgh2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708012912; c=relaxed/simple;
	bh=AwzV7l6ngJMH/6dLMFfjKrzBAa6wt7rrkiY5JB/Q8fI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Vgek9oNdm+RpHSmQnux7HaaSSd/hMDSqxsy8qyB9j1BAH9Xxtv4Ti16/Z673XWo4I6bi8xkvvEJq5Wrb/sRbnm6TTZHzbba0ECyWqagkEvYzLpfyuVrKt/kMnHcfOzsnFq+JYY0YKQpgD8qAO4xcU7cJytdq8mEO9oPxpb8xJsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Nv1C6qI1; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41FFTZrA030241;
	Thu, 15 Feb 2024 16:01:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-11-20;
 bh=fUQwbcSa7JIfZs3FFwCfuYGrDzAceP85zj8kWQZplu8=;
 b=Nv1C6qI1Z5ks6SYBT1JUXvTL6Q8Dndhj2WgYfudUth+RqnAjBlUqAyS2xn8ttN1Dea1/
 lDIe/YoKFIjAgiKSEFeUtm4vse42qAS2DTGumj5fLktSNO7yM2n5sMNcczw3RUg6RLsD
 hcey1mhr1jGhRaVHW/aaLOB/fPjBHNfmC3EpDj99CC27cU3z4kK1Ha0cyUcUjH3wVahm
 VTD9oeommIUL+cfIKXguqnWNx18Ej9RTGnQGvn7d5dvQeoLvHNU3TXqNey0ixDRmHhbJ
 2EV0n4K1zb/011OOUZ318PlYc+FBbEb8f9rcF23Xzip25ZDKMVnZgsAN2gWb/dARnZyo /w== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3w91f02t8w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Feb 2024 16:01:40 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 41FEtq5H013770;
	Thu, 15 Feb 2024 16:01:40 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3w6apdkesw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Feb 2024 16:01:40 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 41FG1cZU031601;
	Thu, 15 Feb 2024 16:01:39 GMT
Received: from alaljime-dev-e4flex-vm.osdevelopmeniad.oraclevcn.com (alaljime-dev-e4flex-vm.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.249.106])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3w6apdkep6-2;
	Thu, 15 Feb 2024 16:01:39 +0000
From: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
To: kvm@vger.kernel.org
Cc: seanjc@google.com, pbonzini@redhat.com, linux-kernel@vger.kernel.org,
        joao.m.martins@oracle.com, boris.ostrovsky@oracle.com,
        mark.kanda@oracle.com, suravee.suthikulpanit@amd.com,
        mlevitsk@redhat.com, alejandro.j.jimenez@oracle.com
Subject: [RFC 1/3] x86: KVM: stats: Add a stat to report status of APICv inhibition
Date: Thu, 15 Feb 2024 16:01:34 +0000
Message-Id: <20240215160136.1256084-2-alejandro.j.jimenez@oracle.com>
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
X-Proofpoint-ORIG-GUID: SGy7if_VQHKWaR8sDeMhTLlXqfzv_VaW
X-Proofpoint-GUID: SGy7if_VQHKWaR8sDeMhTLlXqfzv_VaW

The inhibition status of APICv can currently be checked using the
'kvm_apicv_inhibit_changed' tracepoint, but this is not accessible if
tracefs is not available (e.g. kernel lockdown, non-root user). Export
inhibition status as a binary stat that can be monitored from userspace
without elevated privileges.

Signed-off-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/x86.c              | 10 +++++++++-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index ad5319a503f0..9b960a523715 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1524,6 +1524,7 @@ struct kvm_vm_stat {
 	u64 nx_lpage_splits;
 	u64 max_mmu_page_hash_collisions;
 	u64 max_mmu_rmap_size;
+	u64 apicv_inhibited;
 };
 
 struct kvm_vcpu_stat {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b66c45e7f6f8..f7f598f066e7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -255,7 +255,8 @@ const struct _kvm_stats_desc kvm_vm_stats_desc[] = {
 	STATS_DESC_ICOUNTER(VM, pages_1g),
 	STATS_DESC_ICOUNTER(VM, nx_lpage_splits),
 	STATS_DESC_PCOUNTER(VM, max_mmu_rmap_size),
-	STATS_DESC_PCOUNTER(VM, max_mmu_page_hash_collisions)
+	STATS_DESC_PCOUNTER(VM, max_mmu_page_hash_collisions),
+	STATS_DESC_IBOOLEAN(VM, apicv_inhibited)
 };
 
 const struct kvm_stats_header kvm_vm_stats_header = {
@@ -10588,6 +10589,13 @@ void __kvm_set_or_clear_apicv_inhibit(struct kvm *kvm,
 		 */
 		kvm_make_all_cpus_request(kvm, KVM_REQ_APICV_UPDATE);
 		kvm->arch.apicv_inhibit_reasons = new;
+
+		/*
+		 * Update inhibition statistic only when toggling APICv
+		 * activation status.
+		 */
+		kvm->stat.apicv_inhibited = !!new;
+
 		if (new) {
 			unsigned long gfn = gpa_to_gfn(APIC_DEFAULT_PHYS_BASE);
 			int idx = srcu_read_lock(&kvm->srcu);
-- 
2.39.3


