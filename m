Return-Path: <kvm+bounces-44338-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D10F4A9D0E6
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 20:57:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1EE1B4E39F9
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 18:57:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0140218EBD;
	Fri, 25 Apr 2025 18:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="rxTV8LBK"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 676FD1AA1C4;
	Fri, 25 Apr 2025 18:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745607439; cv=none; b=nUg+Gr/eB47Q6Yfy0lDm8bYfjoX8t6cEccv5g51C37QYoKfGlwdfGczDwdR5NE8uImqMJ6XZSbbDrhIBLdCmmdoinq9UvfEKYgTT9LuFg1zZVLkXoeLxAsyI5y4fY1ShM3faV3w859ZdVl5yl1P380Qf7eaaYY67JkQhWVzJCoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745607439; c=relaxed/simple;
	bh=x7XEmKyrnTLSPQG415tcCiyGd0rHCAq19lelHp9z6iQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=npJLck4kRbTQUZMerRy2JGuYysdevzfXQhg/OJi7NXUmPPslowapVZg5Z0Ey4/02HShUG512P2o47FhCZI8djatkx1n834yCENT0uSYwcOo4jVN1qyxb9sN8Dv0aHS4C1L+93ayNLiBCxlBO9bypUwsbEAhr0P9Z0qRzlIpY6C8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=rxTV8LBK; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53PBdfKY007747;
	Fri, 25 Apr 2025 18:57:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=NZ5CMcwkibg8f3O2G/yQR+21QckOSfDJrrdRNwM4V
	B4=; b=rxTV8LBKI1s0a3yWO1UkC/KKzIYBq9nCtzlbKp535tGSC/aAXGQFFkHMP
	bWPc21+lid/0KB/VTK5ZoKa2IxfBELhgZumFrjDy3nohoDF2QRIbPbbNVAgM5Xbn
	rGwbb6NU1TyUCW92lQP4/Zn2dAAjFxPCm03vVcA89+oE6kG4FeLfC29zv8bDI4sH
	IyBBN/Db32aIczCx1XW25DNQ2j8MECfgPO+Gnozw3RLerCiUueRIvF2s3LZKqj/h
	ay301rydllpb/cxLRuI5bIZ/tbTvD2lSQCkJ3fbtB3H27zXWir0sZW8aUAK93Q9X
	lgkisqSp7oJHcXbRvnMawBbP9Wf2w==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 467wd9n39m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 25 Apr 2025 18:57:03 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 53PIt7JZ013791;
	Fri, 25 Apr 2025 18:57:02 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 467wd9n39f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 25 Apr 2025 18:57:02 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 53PGVVXB005852;
	Fri, 25 Apr 2025 18:57:01 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 466jfxppfp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 25 Apr 2025 18:57:01 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 53PIuvrO53477730
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Apr 2025 18:56:57 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5663420043;
	Fri, 25 Apr 2025 18:56:57 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6B9E620040;
	Fri, 25 Apr 2025 18:56:54 +0000 (GMT)
Received: from li-e7e2bd4c-2dae-11b2-a85c-bfd29497117c.ibm.com.com (unknown [9.39.29.186])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 25 Apr 2025 18:56:54 +0000 (GMT)
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
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: PPC: Book3S HV: Fix IRQ map warnings with XICS on pSeries KVM Guest
Date: Sat, 26 Apr 2025 00:26:41 +0530
Message-ID: <20250425185641.1611857-1-amachhiw@linux.ibm.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: v88G27NCaf46Vsc9gyR-bPj9G6Uq03Fl
X-Proofpoint-ORIG-GUID: cN1gsQoPqVbnJhhdAzabvmzrtgvAXFBC
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNDI1MDEzMiBTYWx0ZWRfX8FlgmsuvUj+C TxM698pex7OVHF45rb8/NXRHqG6OCFGCQycFTGnWTwCOvlPXlzKDxtACMMZVniTgQg7Rm8l+owD Ucz95lXpN9jTvwIzLNjjaW7p+TvwU7RyvqWRgbpHP5/SMxYSi96vg9IUVtNBzkcHTw8wyYbC+c2
 Ot1enG5Svxqgd3NNhCulGOXThOyE96IenxGRUUAFlEBwNl+6yMXlnZ49cqubqp2gVq0Vd3zMGcF C1Mk41N2ALmnqboCFktficoh5VSK/hlKPGFvI9/75r1bVZjPABXcYrKubkNXeRZIsDKZlJTsKu5 1xqrhxzq/+kPjiGy21SSTtEKDALd5ayvl3jb8OqWpArMwKw4Dx0nVfct9sbDjGdKBoqOyu8uuue
 j2MgurqFMmy4xvgOwIZdpZhX48IFmcnAauCfIv2vMohQe4GLwcseGUKrlFzNvv+EQsVziw74
X-Authority-Analysis: v=2.4 cv=M5lNKzws c=1 sm=1 tr=0 ts=680bdaff cx=c_pps a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17 a=XR8D0OoHHMoA:10 a=VnNF1IyMAAAA:8 a=-VtFrL9j7JuT0UG71X4A:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-04-25_05,2025-04-24_02,2025-02-21_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxscore=0
 priorityscore=1501 impostorscore=0 mlxlogscore=999 lowpriorityscore=0
 bulkscore=0 clxscore=1011 adultscore=0 malwarescore=0 suspectscore=0
 spamscore=0 classifier=spam authscore=0 authtc=n/a authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2504070000
 definitions=main-2504250132

The commit 9576730d0e6e ("KVM: PPC: select IRQ_BYPASS_MANAGER") enabled
IRQ_BYPASS_MANAGER when CONFIG_KVM was set. Subsequently, commit
c57875f5f9be ("KVM: PPC: Book3S HV: Enable IRQ bypass") enabled IRQ
bypass and added the necessary callbacks to create/remove the mappings
between host real IRQ and the guest GSI.

The availability of IRQ bypass is determined by the arch-specific
function kvm_arch_has_irq_bypass(), which invokes
kvmppc_irq_bypass_add_producer_hv(). This function, in turn, calls
kvmppc_set_passthru_irq_hv() to create a mapping in the passthrough IRQ
map, associating a host IRQ to a guest GSI.

However, when a pSeries KVM guest (L2) is booted within an LPAR (L1)
with the kernel boot parameter `xive=off`, it defaults to using emulated
XICS controller. As an attempt to establish host IRQ to guest GSI
mappings via kvmppc_set_passthru_irq() on a PCI device hotplug
(passhthrough) operation fail, returning -ENOENT. This failure occurs
because only interrupts with EOI operations handled through OPAL calls
(verified via is_pnv_opal_msi()) are currently supported.

These mapping failures lead to below repeated warnings in the L1 host:

 [  509.220349] kvmppc_set_passthru_irq_hv: Could not assign IRQ map for (58,4970)
 [  509.220368] kvmppc_set_passthru_irq (irq 58, gsi 4970) fails: -2
 [  509.220376] vfio-pci 0015:01:00.0: irq bypass producer (token 0000000090bc635b) registration fails: -2
 ...
 [  509.291781] vfio-pci 0015:01:00.0: irq bypass producer (token 000000003822eed8) registration fails: -2

Fix this by restricting IRQ bypass enablement on pSeries systems by
making the IRQ bypass callbacks unavailable when running on pSeries
platform.

Signed-off-by: Amit Machhiwal <amachhiw@linux.ibm.com>
---
 arch/powerpc/kvm/book3s_hv.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 19f4d298dd17..7667563fb9ff 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -6541,10 +6541,6 @@ static struct kvmppc_ops kvm_ops_hv = {
 	.fast_vcpu_kick = kvmppc_fast_vcpu_kick_hv,
 	.arch_vm_ioctl  = kvm_arch_vm_ioctl_hv,
 	.hcall_implemented = kvmppc_hcall_impl_hv,
-#ifdef CONFIG_KVM_XICS
-	.irq_bypass_add_producer = kvmppc_irq_bypass_add_producer_hv,
-	.irq_bypass_del_producer = kvmppc_irq_bypass_del_producer_hv,
-#endif
 	.configure_mmu = kvmhv_configure_mmu,
 	.get_rmmu_info = kvmhv_get_rmmu_info,
 	.set_smt_mode = kvmhv_set_smt_mode,
@@ -6662,6 +6658,22 @@ static int kvmppc_book3s_init_hv(void)
 		return r;
 	}
 
+#if defined(CONFIG_KVM_XICS)
+	/*
+	 * IRQ bypass is supported only for interrupts whose EOI operations are
+	 * handled via OPAL calls. Therefore, register IRQ bypass handlers
+	 * exclusively for PowerNV KVM when booted with 'xive=off', indicating
+	 * the use of the emulated XICS interrupt controller.
+	 */
+	if (!kvmhv_on_pseries()) {
+		pr_info("KVM-HV: Enabling IRQ bypass\n");
+		kvm_ops_hv.irq_bypass_add_producer =
+			kvmppc_irq_bypass_add_producer_hv;
+		kvm_ops_hv.irq_bypass_del_producer =
+			kvmppc_irq_bypass_del_producer_hv;
+	}
+#endif
+
 	kvm_ops_hv.owner = THIS_MODULE;
 	kvmppc_hv_ops = &kvm_ops_hv;
 

base-commit: 6e3597f12dce7d5041e604fec3602493e38c330a
-- 
2.49.0


