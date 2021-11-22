Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 107AB458BEA
	for <lists+kvm@lfdr.de>; Mon, 22 Nov 2021 10:58:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238955AbhKVKBh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Nov 2021 05:01:37 -0500
Received: from mail-sn1anam02on2110.outbound.protection.outlook.com ([40.107.96.110]:37558
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238875AbhKVKBg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Nov 2021 05:01:36 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GrOD36GMyJkb7c7RadtaLAQ+2jPOlKzqURBP02IMFy1vyxGRhCC47KQEhrIsOXG7NWOFe4K3BqdTKDp3ME+1z2ua49HXdogYSb7HDye1GFOmynaCv+a8rmQNmaGe6NzZ62NGhtPFoO0IGrtXYC1U/M9LZfUvaJrfkL3cVC0Olb2lK9ygeH5kOIuBBPtQ0ls/A98Zq3QsXOUDUWrPyNloZmBiiOFchPRLL7WEO9BKx5QjhreuedGx4q8gTmmd4f7jPO7jIF187wdqAksaHwOKn7c6oJMzdQCaqAvLI17txVUjzSMA1Q08SubYS7u4jdeFvyWle/R6ya2q0P2lbtzqfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UUuPIxzOLTeVM+HhcYZiOgnZeN28d/gzNV+CL7Q9Nbo=;
 b=Pa2xu5DJJJ05UCsks4GYeiIVcpAsXaLH8HPZDvBUECABNtkm99NOX2WkR7jb1pUJxtpt/okYPuab6dak6+Y/EDS1e4LIh/pgxqESxrHfW+whzvMPAPlxa2dJxP6/xLZXKgged1SD0Aw/JwkjQRco8UdEBR0ttBdiTtpfvq9R8sAbXFBpHkH/oAJHfQcE4DoEAT2k33k4oxJug/RVTR4/PcoT2e5FH2H7rpTLsIf9JJISZ8Op/MKDzfYFB3T3p4TV3U8hbY8WB2Fdwqd5IcvuCUDpr41c2Fn5pX4KlGby4BJ0z3se+o9zeq6UZPLoWqrP5f++OtJCPVjHqjv2a1v4FA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UUuPIxzOLTeVM+HhcYZiOgnZeN28d/gzNV+CL7Q9Nbo=;
 b=Vms236mcnSZfokbiN00HY8khs48zv7QhmqhTln42y2DUK8sdWrORm7/egLmTqnYGXOW9DpufoMaL7YWRm5DEBZfwqqAO0aMHrOUH/FfWaFwj0DvDO5MowIXqZToWmDUfzVl8AX4anMdyLakFTEs165zemSSwqDKJx3sC78pNGG8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from DM8PR01MB6824.prod.exchangelabs.com (2603:10b6:8:23::24) by
 DM6PR01MB4122.prod.exchangelabs.com (2603:10b6:5:29::27) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4713.22; Mon, 22 Nov 2021 09:58:28 +0000
Received: from DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::ec55:306:a75d:8529]) by DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::ec55:306:a75d:8529%9]) with mapi id 15.20.4713.025; Mon, 22 Nov 2021
 09:58:28 +0000
From:   Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
To:     maz@kernel.org
Cc:     catalin.marinas@arm.com, will@kernel.org, andre.przywara@arm.com,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, darren@os.amperecomputing.com,
        d.scott.phillips@amperecomputing.com,
        gankulkarni@os.amperecomputing.com
Subject: [PATCH 1/2] KVM: arm64: Use appropriate mmu pointer in stage2 page table init.
Date:   Mon, 22 Nov 2021 01:58:02 -0800
Message-Id: <20211122095803.28943-2-gankulkarni@os.amperecomputing.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20211122095803.28943-1-gankulkarni@os.amperecomputing.com>
References: <20211122095803.28943-1-gankulkarni@os.amperecomputing.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR05CA0056.namprd05.prod.outlook.com
 (2603:10b6:610:38::33) To DM8PR01MB6824.prod.exchangelabs.com
 (2603:10b6:8:23::24)
MIME-Version: 1.0
Received: from engdev025.amperecomputing.com (4.28.12.214) by CH2PR05CA0056.namprd05.prod.outlook.com (2603:10b6:610:38::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.13 via Frontend Transport; Mon, 22 Nov 2021 09:58:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b064ab31-2b93-4e71-e4e5-08d9ad9ea1e9
X-MS-TrafficTypeDiagnostic: DM6PR01MB4122:
X-Microsoft-Antispam-PRVS: <DM6PR01MB41227F6DEB635B381C36570E9C9F9@DM6PR01MB4122.prod.exchangelabs.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 80XkJnoaNGOVdWk3GyH0Ghb8jEjeniYGsDs8Rmtu1co6pb0/rOkICpkplKOAySW/yRP36IphYi5JJiKSWmMuqYJdVBnQK3S7M5ctNf2D+rgleFRV3pCNExB+Q69d122pTHHLjnIaUxxL57l2qnuXGwORR++yDyUTQyvdf00VzgMw1NQsBUTOCt8tz3dHVnBGqOQEDdfveQsk3LUuicA4bv0GPG8yf1zw6A81Wo/T+3snAedWr/USnfcA8qETKgJSGP7VhIGlA7JFzhANAckziJNiODsj8RlNsoSrsv8Vnk87EmzRQNVV4mYWakxIfStJCourrZom+MzP9AALhyfIbQ5tFFVkvRAyc7Mb+09DufR8zom02hH4FUDycRuMx5Tm5h7Qb+uREgKIMhSJ/7K+7IiMHUMOI72n/3UxOb1ysWdFvrhYeirN2L14AzM5n4C9fLJbSt8fcsEKhcv/6dEI97mTXPvg2T6nHGzs47c0CRSqXat2uUEVVRYIlZCVMPJpR2x4N5tGOkrYg0nN6lA2QPbdlcHPjsUnVtSj2MI4/F3zFk2OEoL0nll9BDmHZa9rZamdrG7M7ddHElTj9I30A5zgtNDsZ4g5r1BwSt6mYgaNOuD7mYPjzOHjj/NENhXiV0Yi39M2EaPyHdQBbrWb9UkYSwjr4x/h0GcVpiuShoL84nbkQs7dXcWbjGVBYtnxPyfN3Ye5fXXmk6/95M9njg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR01MB6824.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4326008)(6512007)(1076003)(8936002)(6486002)(186003)(316002)(38350700002)(66556008)(5660300002)(66476007)(83380400001)(8676002)(26005)(66946007)(6666004)(52116002)(956004)(2616005)(508600001)(2906002)(6916009)(38100700002)(107886003)(86362001)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?M8OJKFRAKkfq2sz1iSdRI5FOkP2IJuN2ZS9ub/tMue+NadoVdbJiwhd+y+io?=
 =?us-ascii?Q?wB7s/JIad+60i4ySo7VboILiAkxVNMt3YaCcWDtVmPurX+KNUsuLlT0n1kpa?=
 =?us-ascii?Q?gtE1f9AMS9Y7kfaP39mgvu4po3GdJuXw3rEhwJFVDaVrRswIk2/ZPqc+LhiY?=
 =?us-ascii?Q?9MRSdz6ejvDpL8miiFWiPLDRmDqThYOIBTV68A3w4uEWCzEk6NzJfkhlLbdQ?=
 =?us-ascii?Q?/Vg9TskmwL771dvc/45BRVW43EydxJbfQifgKS0WmMFHehHN0UjKzu69VAhy?=
 =?us-ascii?Q?YUQb8Mb4RK4x+UmUqNt3NzdLtFvn9FIhwai+8/gvp9BGgreFuN8mFMtR73Qc?=
 =?us-ascii?Q?VRD36BG1M5MnEZagwkvJdLkc6e10twd2BT/yyIjpG7TCwKKsBAGb5xuWB0py?=
 =?us-ascii?Q?sH/CDJaa3wz2SS3aXioWUXRP22pcAXkHv03SoZdqZbMND/2Y75Ddz3Am5XuE?=
 =?us-ascii?Q?xJXvVi1j6SS5h9ncSYJNrciEYYCg/oipuoa+LMeMy2uHwRC1sBWuB30Q4fz5?=
 =?us-ascii?Q?yyDv0G/YsxZXJlaQVgJFWUWQpHzkckpbS/L5Kqdnn9o/JWSGyA6ChLqd2EO/?=
 =?us-ascii?Q?DJ+AqMqmB++SpaBh3sPJ4DgtX2Rpkt+nnJOhKlURqwMLhSLEvOTAh/i4SYLl?=
 =?us-ascii?Q?+8ZKtAdbZalYMS4Mji7rTzkjTTcSWCruk/IZMJltylncGkMxLB3BhGNZ8NmZ?=
 =?us-ascii?Q?OzOQugwbnYYxKmVWIjFB7bIjfGupY62JCayBfdW6KWE3LVsqTh85TwIxv4G8?=
 =?us-ascii?Q?G6cX0izOiaQey/oUgt7Aw6XmoixY+xfKbr/n7XV6rxji9tQwAJv+8j+Sv8XG?=
 =?us-ascii?Q?HjBMWhcsWNnvJ+InJW0xnXCTTKwJicn2bcKBBAyHKaqj/Yv98nqyJGq53w0m?=
 =?us-ascii?Q?suiesaLmOqV/pCmgCx4IMMXPPjw9FT4r1Y+kOstoX4LwgaTnwflRrJTyQYiA?=
 =?us-ascii?Q?8nAUE8v20p31H0alsSQdqz7YEIR5zmT+J7drOzl5sCxHh4tYl0t7EuvBrKVi?=
 =?us-ascii?Q?wYvWJmS7CGRf7SO+PvDvFm3MtkGUp3VB6Hb1SDDRs93bYPyuh5KM7xd587vj?=
 =?us-ascii?Q?UFN1WcscimEiDGILUafQWFoq58wBDuC9evTMwWKDXQFC4TJp0wM3SeHQRwtl?=
 =?us-ascii?Q?YBlIpKDUzr2rc4WymZzfWQfd2ZjwYAWSuuc42gIYhQVFE0MCLmMYSMw21m3Z?=
 =?us-ascii?Q?jkUEF4MJyBn8MtUTKP+95cPVE1AvMqFw6O4prsY2n0MzW10vnjeyUmmEaVVJ?=
 =?us-ascii?Q?wuRRJ9/i3tZ2359kWBg+WcS8q/2Ky/t+FiFrEmMXaV2Pfp7OmRWO4duYhm9O?=
 =?us-ascii?Q?EZP+rPAH8YdOGOG2Vi/WWzR9/rhGdp8GP8ppkiYTApySjVDIEZsoiEWK7mWa?=
 =?us-ascii?Q?Y+6/O+lBxNLb5QLsDnGtE81O+uWrbZUQJI3m43xMKv52R4X07RGogcvBNV34?=
 =?us-ascii?Q?cDrwtE3RNUoNEra38AbI0krLTC7Jbfj9xPcIXUmZkKqd/D4LQwuU+vHL+b0H?=
 =?us-ascii?Q?v8ytDb1Ul9cgsHgTKuL6iVtKOl5gvCww8JvbOMB5xUXcwOiMdK5TuqiU0ct7?=
 =?us-ascii?Q?91RXhSRdtxkOowRH19uYex06lwYYuvg5bV9+Fz4OVuO0d1NJLH2oj/Ys4+oX?=
 =?us-ascii?Q?eYfL4S6sA4cd7+9V9JYDs3SCUYq7glVuj9zheL/EJNk17LkK45862t7Aylm6?=
 =?us-ascii?Q?RzSoJ120FLQDxEYz2SrunxvqMkK/+rTmh1Ar79V5RK0alI0DNZhvaGkY4ltK?=
 =?us-ascii?Q?pWfMM65USg=3D=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b064ab31-2b93-4e71-e4e5-08d9ad9ea1e9
X-MS-Exchange-CrossTenant-AuthSource: DM8PR01MB6824.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2021 09:58:28.4306
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LcfYKN6K4a3MrlY987xaBzgJbsqRr+22ZjW3yGyFlrtvEaRJG9cVSO09e+1Q90gZp9i05iUBWnOkoLJlzwhaZjyn6stsa3jD8JgGfoJt+xPUJG0VY/YU4RYd1Qa2C53O
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR01MB4122
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The kvm_pgtable_stage2_init/kvm_pgtable_stage2_init_flags function
assume arch->mmu is same across all stage 2 mmu and initializes
the pgt(page table) using arch->mmu.
Using armc->mmu is not appropriate when nested virtualization is enabled
since there are multiple stage 2 mmu tables are initialized to manage
Guest-Hypervisor as well as Nested VM for the same vCPU.

Add a mmu argument to kvm_pgtable_stage2_init that can be used during
initialization. This patch is a preparatory patch for the
nested virtualization series and no functional changes.

Signed-off-by: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
---
 arch/arm64/include/asm/kvm_pgtable.h  | 6 ++++--
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 2 +-
 arch/arm64/kvm/hyp/pgtable.c          | 3 ++-
 arch/arm64/kvm/mmu.c                  | 2 +-
 4 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 4f432ea3094c..9c0c380f8e3b 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -223,16 +223,18 @@ u64 kvm_get_vtcr(u64 mmfr0, u64 mmfr1, u32 phys_shift);
  * @arch:	Arch-specific KVM structure representing the guest virtual
  *		machine.
  * @mm_ops:	Memory management callbacks.
+ * @mmu:	The pointer to the s2 MMU structure
  * @flags:	Stage-2 configuration flags.
  *
  * Return: 0 on success, negative error code on failure.
  */
 int kvm_pgtable_stage2_init_flags(struct kvm_pgtable *pgt, struct kvm_arch *arch,
 				  struct kvm_pgtable_mm_ops *mm_ops,
+				  struct kvm_s2_mmu *mmu,
 				  enum kvm_pgtable_stage2_flags flags);
 
-#define kvm_pgtable_stage2_init(pgt, arch, mm_ops) \
-	kvm_pgtable_stage2_init_flags(pgt, arch, mm_ops, 0)
+#define kvm_pgtable_stage2_init(pgt, arch, mm_ops, mmu) \
+	kvm_pgtable_stage2_init_flags(pgt, arch, mm_ops, mmu, 0)
 
 /**
  * kvm_pgtable_stage2_destroy() - Destroy an unused guest stage-2 page-table.
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 4b60c0056c04..cf7e034a0453 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -99,7 +99,7 @@ int kvm_host_prepare_stage2(void *mem_pgt_pool, void *dev_pgt_pool)
 		return ret;
 
 	ret = kvm_pgtable_stage2_init_flags(&host_kvm.pgt, &host_kvm.arch,
-					    &host_kvm.mm_ops, KVM_HOST_S2_FLAGS);
+					    &host_kvm.mm_ops, mmu, KVM_HOST_S2_FLAGS);
 	if (ret)
 		return ret;
 
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index fa85da30c9b8..85acd9e19ed0 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1018,6 +1018,7 @@ int kvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size)
 
 int kvm_pgtable_stage2_init_flags(struct kvm_pgtable *pgt, struct kvm_arch *arch,
 				  struct kvm_pgtable_mm_ops *mm_ops,
+				  struct kvm_s2_mmu *mmu,
 				  enum kvm_pgtable_stage2_flags flags)
 {
 	size_t pgd_sz;
@@ -1034,7 +1035,7 @@ int kvm_pgtable_stage2_init_flags(struct kvm_pgtable *pgt, struct kvm_arch *arch
 	pgt->ia_bits		= ia_bits;
 	pgt->start_level	= start_level;
 	pgt->mm_ops		= mm_ops;
-	pgt->mmu		= &arch->mmu;
+	pgt->mmu		= mmu;
 	pgt->flags		= flags;
 
 	/* Ensure zeroed PGD pages are visible to the hardware walker */
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 0cf6ab944adc..6cf86cafc65a 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -495,7 +495,7 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu)
 	if (!pgt)
 		return -ENOMEM;
 
-	err = kvm_pgtable_stage2_init(pgt, &kvm->arch, &kvm_s2_mm_ops);
+	err = kvm_pgtable_stage2_init(pgt, &kvm->arch, &kvm_s2_mm_ops, mmu);
 	if (err)
 		goto out_free_pgtable;
 
-- 
2.27.0

