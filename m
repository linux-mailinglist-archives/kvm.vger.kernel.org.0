Return-Path: <kvm+bounces-18883-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DDC68FCA95
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 13:40:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AE533B22BC0
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 11:40:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4987194129;
	Wed,  5 Jun 2024 11:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="SjuG2/8/"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18A541667C1;
	Wed,  5 Jun 2024 11:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717587598; cv=none; b=QWaAWuUuK4T6ODTCpsFkezQuIVZ6Hmx1xXuwST/WOD1Ew0uFoUFdx4644D61RPQ9k1wRB/pZMiQZFgaGRLMZTDrEISoaIPXNa8Sb95KHdOakmKFXrQh4r5u5FeVLAPJxitxmL+Oatx3RVOezsvmMoD6/TUoi8mUhmAXiJ5D/9bQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717587598; c=relaxed/simple;
	bh=0admlyV/7AyY9L+dogEDQsTR90TLY3i0Uoet05qWKpE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AIerR2K77Q4dHHp6S+dqlqe2cseoSHmNUQpijBBBn4+EKg+Dh4YHTvhQoVBZToVoPzf7tGe8TxP6mQkSuFOM0Thh1Ff93fO57Uy8CPuTOfD6gmGhNoE6MVO0xXwNbug0aB3t2wgUk1OVcogdKggHsAUKdbE1u1FePS+umrRGjFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=SjuG2/8/; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 455An3aw011309;
	Wed, 5 Jun 2024 11:39:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc :
 content-transfer-encoding : date : from : in-reply-to : message-id :
 mime-version : references : subject : to; s=pp1;
 bh=Z2DO6bnYJ2I8hoJAQ7iXvWE50WGcBCvyA6wQPoQ3uxY=;
 b=SjuG2/8/Ucte9JTXXktLEHUQ6q6xWT/zTCIxi4ssP/XXZcxB27YX0yQ9YlCn0yN2UyuR
 /pyWT+IcWiRogYXRKbUoG6DkJqKtRWnNEEwWuJ0EKkvCJWpKWkF9D3bvZLOHk/A7UtbC
 0fDBM2GSMhUwlWTcNd8GWqBLb0JJTE5rCx+/Fc6Vu06ry/p7AZ4nU0hVR4mN2y1y1bL5
 pWN6k164/mQtVrYLleVEysHqGxGYPPCh3N3JrwjtzyBxAIzBHTR/pHAMpsaedM1mbRNi
 6bnh/vGsm6kJCl8CqM/JeOtY6FVnZAcvB7F9h3eNo9QH3Dvb6uVu9fnCFhyVgsYNjrSR zQ== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yjpkbg3k3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Jun 2024 11:39:44 +0000
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 455BdhlK021212;
	Wed, 5 Jun 2024 11:39:43 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yjpkbg3jx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Jun 2024 11:39:43 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 455AAC6Q026600;
	Wed, 5 Jun 2024 11:39:43 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3ygffn3q9r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Jun 2024 11:39:43 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 455BdbuM51708408
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 5 Jun 2024 11:39:39 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4D71220049;
	Wed,  5 Jun 2024 11:39:37 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3978520040;
	Wed,  5 Jun 2024 11:39:35 +0000 (GMT)
Received: from li-c6426e4c-27cf-11b2-a85c-95d65bc0de0e.in.ibm.com (unknown [9.204.206.66])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  5 Jun 2024 11:39:35 +0000 (GMT)
From: Gautam Menghani <gautam@linux.ibm.com>
To: mpe@ellerman.id.au, npiggin@gmail.com, christophe.leroy@csgroup.eu,
        aneesh.kumar@kernel.org, naveen.n.rao@linux.ibm.com, corbet@lwn.net
Cc: Gautam Menghani <gautam@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org,
        linux-doc@vger.kernel.org, kvm@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] arch/powerpc/kvm: Fix doorbell emulation for v2 API
Date: Wed,  5 Jun 2024 17:09:10 +0530
Message-ID: <20240605113913.83715-3-gautam@linux.ibm.com>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240605113913.83715-1-gautam@linux.ibm.com>
References: <20240605113913.83715-1-gautam@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: yd8Q5CslfA_U3bYHDTUsxqoeoc3Jzg1F
X-Proofpoint-GUID: w_X9wiRDwOIhz3Delcf--5LOWzqbb123
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-05_02,2024-06-05_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 spamscore=0
 impostorscore=0 lowpriorityscore=0 malwarescore=0 mlxscore=0 phishscore=0
 adultscore=0 priorityscore=1501 clxscore=1015 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2406050088

Doorbell emulation is broken for KVM on PAPR guests as support for
DPDES was not added in the initial patch series. Due to this, a KVM on
PAPR guest with SMT > 1 cannot be booted with the XICS interrupt
controller as doorbells are setup in the initial probe path when using XICS
(pSeries_smp_probe()).

Command to replicate the above bug:

qemu-system-ppc64 \
	-drive file=rhel.qcow2,format=qcow2 \
	-m 20G \
	-smp 8,cores=1,threads=8 \
	-cpu  host \
	-nographic \
	-machine pseries,ic-mode=xics -accel kvm

Add doorbell state handling support in the host
KVM code to fix doorbell emulation.

Fixes: 19d31c5f1157 ("KVM: PPC: Add support for nestedv2 guests")
Cc: stable@vger.kernel.org # v6.7
Signed-off-by: Gautam Menghani <gautam@linux.ibm.com>
---
 arch/powerpc/kvm/book3s_hv.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 35cb014a0c51..21c69647d27c 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4116,6 +4116,11 @@ static int kvmhv_vcpu_entry_nestedv2(struct kvm_vcpu *vcpu, u64 time_limit,
 	int trap;
 	long rc;
 
+	if (vcpu->arch.doorbell_request) {
+		vcpu->arch.doorbell_request = 0;
+		kvmppc_set_dpdes(vcpu, 1);
+	}
+
 	io = &vcpu->arch.nestedv2_io;
 
 	msr = mfmsr();
-- 
2.45.1


