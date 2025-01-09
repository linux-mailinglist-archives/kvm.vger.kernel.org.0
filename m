Return-Path: <kvm+bounces-34913-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 35DF5A0773A
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 14:22:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E7E62162772
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 13:22:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A962B218821;
	Thu,  9 Jan 2025 13:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="O41+eNVw"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DFB4218AC6;
	Thu,  9 Jan 2025 13:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736428906; cv=none; b=PL3Wru/RclgfT/dzdGjLclNYLbpc45lyCBGnfZYZMkdcWAz4yX1pdDkefiavs1EQS2HByUm1CRXyRFJ4qbU9XegEF1uHT+9dAg24yxNJT3lS4mLlO0uuB2+mJdqdRlVqGN+koqtGTPt4npMFrBnc2NjkKHRNxodCEUyuvjZR2GY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736428906; c=relaxed/simple;
	bh=uA1KoJ0EVn4JPa8fEqid30FHAIr6fqP4vqAv435NFUE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Du+mHZ9ET3nuNQytTKa23EiGOf8cKGzhXEc6ABQ20PWEV9cK29IinadhvtKmzW5UwWLozSfAnYUIuWLxsEHC/RhaydL5bk1K97wf0xU7EYZpJS1RXV19miAUeu0zKhjTk8GOkVvOvxbZQ4UOkmw65fXaJ7a5GmvrfPg//XurPxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=O41+eNVw; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5090abXX000770;
	Thu, 9 Jan 2025 13:21:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=PIYv3HT1t7t/RxD2CzYvxMvKNpNRTsobx9e1PcdHI
	4Q=; b=O41+eNVwrjnbtCpkyRE2aGtUtngxpY51WzYFvlZQgEYCEIM/sAyJJ5TfD
	JWKJGeUodawGaNpBvTJzaOnJJyvJAsskDLBsYFYfxaFd0GvARVTImtEEkTzTa/Xw
	yHRC0Z2VsxEait13k/A9XLOmmzPzKyOVQ7IOpbEEv3Yx8x//d74jJxXzo4NYXFci
	3/f0DxUbfIyRgwT/GOz6KCJb947Na1pnZIT4lyihZ5hdCxD/gLDqQdJVh2punLkG
	5DCZP5lxiC340r1RFlJND+sQlHYdFDUk1HUdQvfG3LRpFKElM3uPH6olsUsh6VSf
	7tyZya6e6NQfybnRbd0/tdx6doxQA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 441tu5n7e1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 09 Jan 2025 13:21:26 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 509DFhi6008704;
	Thu, 9 Jan 2025 13:21:25 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 441tu5n7dx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 09 Jan 2025 13:21:25 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 509BNhsI003601;
	Thu, 9 Jan 2025 13:21:25 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 43yfatdedn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 09 Jan 2025 13:21:24 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 509DLLnI15073628
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 9 Jan 2025 13:21:21 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4637A20043;
	Thu,  9 Jan 2025 13:21:21 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4CE5320040;
	Thu,  9 Jan 2025 13:21:18 +0000 (GMT)
Received: from li-e7e2bd4c-2dae-11b2-a85c-bfd29497117c.ibm.com.com (unknown [9.124.223.189])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  9 Jan 2025 13:21:18 +0000 (GMT)
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
Subject: [PATCH] KVM: PPC: Enable CAP_SPAPR_TCE_VFIO on pSeries KVM guests
Date: Thu,  9 Jan 2025 18:50:53 +0530
Message-ID: <20250109132053.158436-1-amachhiw@linux.ibm.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: hvpgz_N-ryofrwSI8xwElybReki8Q0Ff
X-Proofpoint-ORIG-GUID: GT_WvY8RHmULRGyFL4N4ZliWEMN7eZqS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 priorityscore=1501
 mlxlogscore=808 adultscore=0 bulkscore=0 impostorscore=0 clxscore=1011
 suspectscore=0 phishscore=0 malwarescore=0 spamscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2411120000
 definitions=main-2501090104

Currently, on book3s-hv, the capability KVM_CAP_SPAPR_TCE_VFIO is only
available for KVM Guests running on PowerNV and not for the KVM guests
running on pSeries hypervisors. This prevents a pSeries hypervisor from
leveraging the in-kernel acceleration for H_PUT_TCE_INDIRECT and
H_STUFF_TCE hcalls that results in slow startup times for large memory
guests.

Fix this by enabling the CAP_SPAPR_TCE_VFIO on the pSeries hosts for the
nested PAPR guests.

Fixes: f431a8cde7f1 ("powerpc/iommu: Reimplement the iommu_table_group_ops for pSeries")
Cc: stable@vger.kernel.org
Signed-off-by: Amit Machhiwal <amachhiw@linux.ibm.com>
---
 arch/powerpc/kvm/powerpc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index ce1d91eed231..9c479c7381e4 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -554,7 +554,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		r = 1;
 		break;
 	case KVM_CAP_SPAPR_TCE_VFIO:
-		r = !!cpu_has_feature(CPU_FTR_HVMODE);
+		r = !!cpu_has_feature(CPU_FTR_HVMODE) || is_kvmppc_hv_enabled(kvm);
 		break;
 	case KVM_CAP_PPC_RTAS:
 	case KVM_CAP_PPC_FIXUP_HCALL:

base-commit: eea6e4b4dfb8859446177c32961c96726d0117be
-- 
2.47.1


