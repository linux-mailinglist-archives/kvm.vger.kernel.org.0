Return-Path: <kvm+bounces-36824-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AD950A21A1A
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2025 10:41:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3AF087A20EF
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2025 09:40:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CEA31ACEC9;
	Wed, 29 Jan 2025 09:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="OQEX4LS4"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BB4C19D07C;
	Wed, 29 Jan 2025 09:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738143689; cv=none; b=aQbg+hXErUb1eKomJSshP3XNvuuAeTWkSSfdzoEUKHMAbJDUnx5UqUtPFXgTFj+zeCUraSoeJDmSZ34+KKEoHXuPMmR7UhbnM7PanE00Vrrh5KUFKLEx02Q1BDVd3A0oYnlOGGEpe2BIyvLMih9j2VCmI5ghE+KVeZqypgFpPfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738143689; c=relaxed/simple;
	bh=+H7TZ0haIWjqdVTXbCyYPtbLhDabfj5908jj5j3zc3M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZPua3SJFBmsLjCnOQqO/al5LkFIM0eP+Ud5ahBZ1ibxaLgOgjANQL1wJK9iG8u1ncfsrTVUl2AX5gDiKTNOu3WVEOakZi2pBRxcOvlfj/sHl0c5Pft6N+/eMLqrTo4sSsASbivxjEnxKT3n4HU0vk+aKwf9DsSrOwXz5psUmN2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=OQEX4LS4; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50T20YvY028471;
	Wed, 29 Jan 2025 09:41:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=oNZkm1uX7U/WwtMtAAdmr5FSLoJzcomJRfKSuLi+Y
	y0=; b=OQEX4LS4kn4Xy37Yh8WrCQsHr35kGTxrrelBLOPH60eapDFgvEqzmIc6t
	Eifbfhmr22jYNUwxJ+ZBe/jghVpLDraMjfJpLOxrnVJq2i6WZiX/WNwbgPwXyF4Q
	7PxqGkLvYsYYhBUpB9yWshiZ7LcuytgPtnQbGMpyHhinBkRnIxklnzSfov0WV7lH
	/N+YGpf2eji921olBWSB3sJwf9Qeb/FDeSglAzbPYplROKw50QL4Vfl8LGXPls3I
	TUqqm8tg0qsLV40eVkag/7oGuSfTlfoyjz4T685tDM1deW0w4Ww45O03FNX1WB5U
	JzRA6N5+A1XQSAVT2nH44z4/F7saQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44fb609g2t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 29 Jan 2025 09:41:09 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 50T9aY8E006602;
	Wed, 29 Jan 2025 09:41:09 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44fb609g2p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 29 Jan 2025 09:41:09 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50T8lO2u012336;
	Wed, 29 Jan 2025 09:41:08 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 44dany83k8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 29 Jan 2025 09:41:08 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50T9f4rb20250894
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jan 2025 09:41:04 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A1EA520040;
	Wed, 29 Jan 2025 09:41:04 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E859920073;
	Wed, 29 Jan 2025 09:41:01 +0000 (GMT)
Received: from li-e7e2bd4c-2dae-11b2-a85c-bfd29497117c.in.ibm.com (unknown [9.109.198.84])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 29 Jan 2025 09:41:01 +0000 (GMT)
From: Amit Machhiwal <amachhiw@linux.ibm.com>
To: Madhavan Srinivasan <maddy@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Cc: Amit Machhiwal <amachhiw@linux.ibm.com>,
        Vaibhav Jain <vaibhav@linux.ibm.com>,
        Shivaprasad G Bhat <sbhat@linux.ibm.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Naveen N Rao <naveen@kernel.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH v2] KVM: PPC: Enable CAP_SPAPR_TCE_VFIO on pSeries KVM guests
Date: Wed, 29 Jan 2025 15:10:33 +0530
Message-ID: <20250129094033.2265211-1-amachhiw@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: TWdhonsq_87KGcTRAxAYs1iT1N1D-B3f
X-Proofpoint-ORIG-GUID: -jAVV3X5Wcjma1oMS2g6sROUOl1lkTg4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-28_04,2025-01-27_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 clxscore=1015 lowpriorityscore=0 mlxlogscore=793
 bulkscore=0 spamscore=0 suspectscore=0 phishscore=0 priorityscore=1501
 mlxscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501290077

Currently on book3s-hv, the capability KVM_CAP_SPAPR_TCE_VFIO is only
available for KVM Guests running on PowerNV and not for the KVM guests
running on pSeries hypervisors. This prevents a pSeries L2 guest from
leveraging the in-kernel acceleration for H_PUT_TCE_INDIRECT and
H_STUFF_TCE hcalls that results in slow startup times for large memory
guests.

Fix this by enabling the CAP_SPAPR_TCE_VFIO on the pSeries hosts as well
for the nested PAPR guests. With the patch, booting an L2 guest with
128G memory results in an average improvement of 11% in the startup
times.

Fixes: f431a8cde7f1 ("powerpc/iommu: Reimplement the iommu_table_group_ops for pSeries")
Cc: stable@vger.kernel.org
Signed-off-by: Amit Machhiwal <amachhiw@linux.ibm.com>
---
Changes since v1:
    * Addressed review comments from Ritesh
    * v1: https://lore.kernel.org/all/20250109132053.158436-1-amachhiw@linux.ibm.com/

 arch/powerpc/kvm/powerpc.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index ce1d91eed231..a7138eb18d59 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -543,26 +543,23 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		r = !hv_enabled;
 		break;
 #ifdef CONFIG_KVM_MPIC
 	case KVM_CAP_IRQ_MPIC:
 		r = 1;
 		break;
 #endif

 #ifdef CONFIG_PPC_BOOK3S_64
 	case KVM_CAP_SPAPR_TCE:
+		fallthrough;
 	case KVM_CAP_SPAPR_TCE_64:
-		r = 1;
-		break;
 	case KVM_CAP_SPAPR_TCE_VFIO:
-		r = !!cpu_has_feature(CPU_FTR_HVMODE);
-		break;
 	case KVM_CAP_PPC_RTAS:
 	case KVM_CAP_PPC_FIXUP_HCALL:
 	case KVM_CAP_PPC_ENABLE_HCALL:
 #ifdef CONFIG_KVM_XICS
 	case KVM_CAP_IRQ_XICS:
 #endif
 	case KVM_CAP_PPC_GET_CPU_CHAR:
 		r = 1;
 		break;
 #ifdef CONFIG_KVM_XIVE

base-commit: 6d61a53dd6f55405ebcaea6ee38d1ab5a8856c2c
-- 
2.48.1


