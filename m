Return-Path: <kvm+bounces-16173-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 264488B5E4F
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 17:58:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BB4CB1F21F19
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 15:58:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCF99839EB;
	Mon, 29 Apr 2024 15:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JDxUlc1c"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CC3084A2B;
	Mon, 29 Apr 2024 15:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714406272; cv=none; b=bp/Zp87dSbPryYukMO+mdLbv6gQbzOj/xRyN9kcuuHAvHhw6/tPJrlkvPmOqErSYTMZxIKs4yPr3bQ2R31CGOLW0B3vANRcoB1BI0K4b6/TWNdbvDhECEmb0iAhO45R3DWQtlxwvqRjdZTDTp3/fXqYNckFjVNd+dSm8k6krtDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714406272; c=relaxed/simple;
	bh=Yx10yQlU7fLLx3U/PfdEEvcwLQHEP15tZTFMbY6ANHo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JdLhXiKfge1+kTT739tH8dA0BDIwqSplka1DJJbEK0JCfJs3Tmg3RzWRIH93AVqhlT+cEPUaonJJ5vN7N5jRkauzLtRNCDArK6whPckRp8/rSiOTS/rHFqPxyi8+JeHkuLu3uTM6VCW2HE2+hNB6dh2X9TSRjr+5DN7TltHloTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=JDxUlc1c; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43TFo22o003852;
	Mon, 29 Apr 2024 15:57:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-11-20;
 bh=9dxkp9qWdEPqQUS7q3J/EVb+1tSnlOWVbYhXQ6eDerA=;
 b=JDxUlc1cz/imfKZBHIpT0cX+v3nTPdQ+vnMqmliweJ6/HxNdVdQ7zcX8AhQlM5StHSlH
 8xrg+8+rgMl375fPNJCY8nM3hwYLptFmhVeaZENoom2sbBVffFfxJkw87OE199N4wAeH
 tWF12yJwdDpUGrdzqerkf1YK/8bbPn0232b/Zx0RE7b5vo84CkpGOEpaCRWdGG/7OBqs
 0H812eFmkz7rDwN8iwn35K3I0RQG+FsjQpXVDbufo6JCdpBNsVSOSqQplQsWTAvId0oI
 f5p/z2HHyl4hpnEgshxj2WDems+EJPSB98mnVlowNs91lMlNK69YZOA+A9L1qzuxdJDU 3g== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xrr9ck157-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 29 Apr 2024 15:57:45 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 43TF0qFq011412;
	Mon, 29 Apr 2024 15:57:44 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xrqt6j97g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 29 Apr 2024 15:57:44 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 43TFuxjO040299;
	Mon, 29 Apr 2024 15:57:43 GMT
Received: from alaljime-dev-e4flex-vm.osdevelopmeniad.oraclevcn.com (alaljime-dev-e4flex-vm.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.249.106])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3xrqt6j91w-3;
	Mon, 29 Apr 2024 15:57:43 +0000
From: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
To: kvm@vger.kernel.org
Cc: seanjc@google.com, pbonzini@redhat.com, linux-kernel@vger.kernel.org,
        suravee.suthikulpanit@amd.com, vashegde@amd.com, mlevitsk@redhat.com,
        joao.m.martins@oracle.com, boris.ostrovsky@oracle.com,
        mark.kanda@oracle.com, alejandro.j.jimenez@oracle.com
Subject: [PATCH 2/4] KVM: x86: Add a VM stat exposing when SynIC AutoEOI is in use
Date: Mon, 29 Apr 2024 15:57:36 +0000
Message-Id: <20240429155738.990025-3-alejandro.j.jimenez@oracle.com>
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
X-Proofpoint-GUID: iCIGZ6ZatbAlm23u8jcAY9IZx6XV8q_8
X-Proofpoint-ORIG-GUID: iCIGZ6ZatbAlm23u8jcAY9IZx6XV8q_8

APICv/AVIC is inhibited for guests using Hyper-V's synthetic interrupt
controller (SynIC) enlightenment, and specifically SynIC's AutoEOI feature.
It is recommended that guests do not enable AutoEOI (see flag
HV_DEPRECATING_AEOI_RECOMMENDED and commit 0f250a646382 ("KVM: x86:
hyper-v: Deactivate APICv only when AutoEOI feature is in use")), but it
can still be used in legacy configurations.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/hyperv.c           | 2 ++
 arch/x86/kvm/x86.c              | 3 ++-
 3 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 12f30cb5c842..f3b40cfebec4 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1534,6 +1534,7 @@ struct kvm_vm_stat {
 	u64 nx_lpage_splits;
 	u64 max_mmu_page_hash_collisions;
 	u64 max_mmu_rmap_size;
+	u64 synic_auto_eoi_used;
 };
 
 struct kvm_vcpu_stat {
diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 8a47f8541eab..4263b4ad71c5 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -149,6 +149,8 @@ static void synic_update_vector(struct kvm_vcpu_hv_synic *synic,
 					 APICV_INHIBIT_REASON_HYPERV,
 					 !!hv->synic_auto_eoi_used);
 
+	vcpu->kvm->stat.synic_auto_eoi_used = !!hv->synic_auto_eoi_used;
+
 	up_write(&vcpu->kvm->arch.apicv_update_lock);
 }
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0451c4c8d731..27e339133068 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -256,7 +256,8 @@ const struct _kvm_stats_desc kvm_vm_stats_desc[] = {
 	STATS_DESC_ICOUNTER(VM, pages_1g),
 	STATS_DESC_ICOUNTER(VM, nx_lpage_splits),
 	STATS_DESC_PCOUNTER(VM, max_mmu_rmap_size),
-	STATS_DESC_PCOUNTER(VM, max_mmu_page_hash_collisions)
+	STATS_DESC_PCOUNTER(VM, max_mmu_page_hash_collisions),
+	STATS_DESC_IBOOLEAN(VM, synic_auto_eoi_used)
 };
 
 const struct kvm_stats_header kvm_vm_stats_header = {
-- 
2.39.3


