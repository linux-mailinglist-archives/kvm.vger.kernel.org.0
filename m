Return-Path: <kvm+bounces-16174-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 115A58B5E52
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 17:58:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 42D081C212C2
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 15:58:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76A398592A;
	Mon, 29 Apr 2024 15:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nAAe3m7S"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE58884E0F;
	Mon, 29 Apr 2024 15:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714406273; cv=none; b=kNcZVPlkH4cs1msNooN5rYYEVxdZ6+aeG/D5ePinqOe7SOaLODxc5FPDmAcBuejoQk6p6LMsPSISEQU+cfXmhjJlPWBlLTRoNH3T4RL7Z9upvT0gaTgHNVdqUAxVWkGpmB/GxrOJKFG+awP/yEUxaByrbYxJiRTdMB0ZZgTW/6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714406273; c=relaxed/simple;
	bh=YgyQmLaloPcIUzIg3IrVssDo28Rrg23MlIk6U5amRAM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=suGjVXrmp9iKDtxktaVL0X6OlJdGita09w97sxJ8m9nU0YmKvgY9GJ+IIUAHje8H1tsEbbBWFHFh84acUtGEqxRX61UN3Ot1PRrl8Kt/qMPRNbC6gxv6Gj5jVxyH6NPh+LBvrFmLUgDgOgKKCzYsvFcd/VsxnokR0YMY6NMEIFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=nAAe3m7S; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43TFnbYd017526;
	Mon, 29 Apr 2024 15:57:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-11-20;
 bh=iQ8G9aJXvaHwNv5eTGivSBJiLsTXuxQiiW7NahnRb6s=;
 b=nAAe3m7SiZ43Fh5imak9evRgG5iYRNh0WV4qEGpuYdKblAyEVcasDF6wnpdiu7tE1Goa
 s9KJSKTWferbLIxgHZyjszNq8zh++d4wCi3/st2bm1LlGSsUX2mv9WF69HF80Lq/sGEg
 T84jXNfx6BzSZtev66dtQrsCf/n9HiZsDZMxg5nA01B49QesELZlnPshWwFhJ0gUe+63
 teSW4djhPKiM0deKTbVItYlD36GGRFEg4CulBv9wvU14fPFRw3SkzfhRlEQWlN8jqVae
 73zOlRKdpp+zwKnzhJwQ4Xu+KfRUryXT7Yiu9ht2F+hRLpgam2HyLWWQy5U3/J/3f6lV 1A== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xrs8cjxhs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 29 Apr 2024 15:57:46 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 43TEWetA011415;
	Mon, 29 Apr 2024 15:57:46 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xrqt6j98j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 29 Apr 2024 15:57:46 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 43TFuxjQ040299;
	Mon, 29 Apr 2024 15:57:45 GMT
Received: from alaljime-dev-e4flex-vm.osdevelopmeniad.oraclevcn.com (alaljime-dev-e4flex-vm.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.249.106])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3xrqt6j91w-4;
	Mon, 29 Apr 2024 15:57:45 +0000
From: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
To: kvm@vger.kernel.org
Cc: seanjc@google.com, pbonzini@redhat.com, linux-kernel@vger.kernel.org,
        suravee.suthikulpanit@amd.com, vashegde@amd.com, mlevitsk@redhat.com,
        joao.m.martins@oracle.com, boris.ostrovsky@oracle.com,
        mark.kanda@oracle.com, alejandro.j.jimenez@oracle.com
Subject: [PATCH 3/4] KVM: x86: Add a VM stat exposing when KVM PIT is set to reinject mode
Date: Mon, 29 Apr 2024 15:57:37 +0000
Message-Id: <20240429155738.990025-4-alejandro.j.jimenez@oracle.com>
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
X-Proofpoint-GUID: A8Pgz33DZ_3gpG3wfSelnF-CjYwMBvEO
X-Proofpoint-ORIG-GUID: A8Pgz33DZ_3gpG3wfSelnF-CjYwMBvEO

Add a stat to query when PIT is in reinject mode, which can have a large
performance impact due to disabling SVM AVIC.
When using in-kernel irqchip, QEMU and KVM default to creating a PIT in
reinject mode, since this is necessary for old guest operating systems that
use the PIT for timing. Unfortunately, reinject mode relies on EOI
interception and so SVM AVIC must be inhibited when the PIT is set up using
this mode.

Signed-off-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/i8254.c            | 2 ++
 arch/x86/kvm/x86.c              | 3 ++-
 3 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f3b40cfebec4..e7e3213cefae 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1535,6 +1535,7 @@ struct kvm_vm_stat {
 	u64 max_mmu_page_hash_collisions;
 	u64 max_mmu_rmap_size;
 	u64 synic_auto_eoi_used;
+	u64 pit_reinject_mode;
 };
 
 struct kvm_vcpu_stat {
diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
index cd57a517d04a..44e593e909a1 100644
--- a/arch/x86/kvm/i8254.c
+++ b/arch/x86/kvm/i8254.c
@@ -316,6 +316,8 @@ void kvm_pit_set_reinject(struct kvm_pit *pit, bool reinject)
 		kvm_unregister_irq_mask_notifier(kvm, 0, &pit->mask_notifier);
 	}
 
+	kvm->stat.pit_reinject_mode = reinject;
+
 	atomic_set(&ps->reinject, reinject);
 }
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 27e339133068..03cb933920cb 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -257,7 +257,8 @@ const struct _kvm_stats_desc kvm_vm_stats_desc[] = {
 	STATS_DESC_ICOUNTER(VM, nx_lpage_splits),
 	STATS_DESC_PCOUNTER(VM, max_mmu_rmap_size),
 	STATS_DESC_PCOUNTER(VM, max_mmu_page_hash_collisions),
-	STATS_DESC_IBOOLEAN(VM, synic_auto_eoi_used)
+	STATS_DESC_IBOOLEAN(VM, synic_auto_eoi_used),
+	STATS_DESC_IBOOLEAN(VM, pit_reinject_mode)
 };
 
 const struct kvm_stats_header kvm_vm_stats_header = {
-- 
2.39.3


