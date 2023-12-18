Return-Path: <kvm+bounces-4699-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F433816965
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 10:10:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5820F28273B
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 09:10:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C91412B70;
	Mon, 18 Dec 2023 09:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="KXs8NoKI"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2060.outbound.protection.outlook.com [40.107.237.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1784125BA;
	Mon, 18 Dec 2023 09:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mdXh5pdtD00NHKxZNaCt+2h6wL+9mnq/NLW8aPR1cDi+U61VjMUhUJvb3GfvtHhwQYDyCw6snG8R4qCKvp9NJv1viByqoejQ/TKaDk46PCgQA3Qf66U4BYC0TY7TBionTQiYg0aXQB91/uJiMyoVFKPNwuPhlzGI1A7qwivbF7F8mU+yGZnqr2AEhR/qY9rzRmk843fwPHrG+SahoLh5Z0KETHgESk2FbiQYpk6VY+EVDkus7Csp2jIbBxSdUQCzNuu7QTEsBr5JiP4TSp/mRceQBhfVVRfEcRbbIqMHvtCdCbGsQXRidS5mpDjVfN0rXcG14pklA9Uc1D/2gj5+Bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K4I6QhWVt2wYpDE//XpKCme7DDvvwiXK2/rXSlFvPwU=;
 b=g6UUywMKZ0OWxzT3p6yB0aiR4QNEzHTG66MfO2S3Z4spNZtnWeehDOTXYwEP8qu7VjMcSMsdw9Lu+mecsWPZkbjsDy9wSDaCsBqqzg7hzVg8ROEeiVuIoNVMWtxKECwo6Gv2sxTmowoNsJdPQpd2nUlMZvQqprGMQXcc481v9Z1adXEQrEWE8/y/ZMGUMb0yknPn3dihm62bMw+cilcTFeZhitkKl5GXI61uVOHVFxuJTpvr+tjNYc2y7KwuDrf7vFrTB+k+hvApOiVBeFbXug4Ko59jorIKOKNxco74ZATd0yd+qtGna4lkg4tF3vuPPOoZfuteJKMmnYpCIUs5kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K4I6QhWVt2wYpDE//XpKCme7DDvvwiXK2/rXSlFvPwU=;
 b=KXs8NoKIIBd/K2vLbfEOkr/+ODw6MMFTWi/Y9/WKaDyw2ikHLiWUtxf5Ucy5heCxhM/kmgNFslOQfasQ8Ps9SvNSQfIwEA6D9sp5JbzwRkIVulft85U9CkTu3RuaS1sjIesu/j6bEKP4UGeGgo1BcX9Wyax5L+cOCu9/unySyyd5y0WUr5pXxrj8a0f2JNzh/kWSDKg8p3S97HPzjs33UF5/wtqnxmAKPGiL1g/zRHbqTDHC2v9uibZyOdCsPxG1J2HybaHdCzild/4jjxpLwhw/kqJ7ImoC0I2KJqsx7upeUvYBU2vIazf9mlEJvK1bQ4RUaD040UonbI6s7Ptyew==
Received: from SA1PR05CA0011.namprd05.prod.outlook.com (2603:10b6:806:2d2::13)
 by DM6PR12MB4404.namprd12.prod.outlook.com (2603:10b6:5:2a7::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.37; Mon, 18 Dec
 2023 09:08:03 +0000
Received: from SN1PEPF0002529D.namprd05.prod.outlook.com
 (2603:10b6:806:2d2:cafe::c8) by SA1PR05CA0011.outlook.office365.com
 (2603:10b6:806:2d2::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.15 via Frontend
 Transport; Mon, 18 Dec 2023 09:08:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SN1PEPF0002529D.mail.protection.outlook.com (10.167.242.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7113.14 via Frontend Transport; Mon, 18 Dec 2023 09:08:02 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 18 Dec
 2023 01:07:52 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 18 Dec
 2023 01:07:50 -0800
Received: from sgarnayak-dt.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41 via Frontend
 Transport; Mon, 18 Dec 2023 01:07:42 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <jgg@nvidia.com>, <maz@kernel.org>,
	<oliver.upton@linux.dev>, <suzuki.poulose@arm.com>, <yuzenghui@huawei.com>,
	<catalin.marinas@arm.com>, <will@kernel.org>, <alex.williamson@redhat.com>,
	<kevin.tian@intel.com>, <yi.l.liu@intel.com>, <ardb@kernel.org>,
	<akpm@linux-foundation.org>, <gshan@redhat.com>, <mochs@nvidia.com>,
	<lpieralisi@kernel.org>
CC: <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
	<apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
	<linux-mm@kvack.org>, <kvmarm@lists.linux.dev>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v4 2/3] kvm: arm64: set io memory s2 pte as normalnc for vfio pci devices
Date: Mon, 18 Dec 2023 14:37:18 +0530
Message-ID: <20231218090719.22250-3-ankita@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20231218090719.22250-1-ankita@nvidia.com>
References: <20231218090719.22250-1-ankita@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF0002529D:EE_|DM6PR12MB4404:EE_
X-MS-Office365-Filtering-Correlation-Id: f51a83f0-31c9-4550-d9f6-08dbffa8d718
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	B9aaZeGx5d2XH8GrYze4BxLj38qvOTxggsMSVQSDe7PFAVLAg1NrvO5jvmfu8rMOrgXrpvRKKTA2K8RGT07+FpB61NhqGbDW38t2DFwB3kx8uLt95OWNcmvDJTDLdRIfUmFbJknbbmrvu0cvrDZ41M2YglmILQNcuJphrGOzau9zi+Cg6JTrsPNZjYNBVWiAyGrFtI2YL3qXWLBaO83LdnhHhl1e3TG5NyztdTpKR1ill7FZPAt3td38kOMwg8H/jmC1B38PnME++e5cL98A8KlEOdqeKKHfsbWjgKS5RWOj+wEnlH1bkd8ONgG0kEKg0MwAmlNamMTBeGc+D0otDO9lLJoslbh721a8R8lrzyjcLDW0Le616xOWAIpjLE1VfisbWoewMXrNOMfYl1mi5muGGhwj7dsys35msHysLhfq+4McVB8fALhgaYERObWR33bcZnzy8Af0/e5ZhRC9xt9zsPgEMvtZrpl2AjfBbQgxv5+OZhMWdiqtdhPhgzfza53fT9HP64AoNBLKyYe5KTz/OZo6KwN0mJjY/fXGEG52sRDs5B3ox5JHGh0scqWrJOtrbUEDWssmDRwGRPt5CDcHv9QqqB/9cGc80pqoFgkv2i2KCM++HvIQPW1qi4w3NNWeE7E6M5etl822rizxwjHGP3sCaa3VwQ5YfxOWsf4r9lSbMe4hwnZxgUInTRlXURrAELFmCtkfQqiiNS2oDcq+VYRxE9iN1kanEyfeQ7ZAlhKTLUwwU9pJUb44gWvIqtoqfw9TWqJEStXQA1uU8CEclrN49OyTFNyHwhuf8lKWraPVw76SHfJyg/PvOBrzD6ZU5nJnSOwxlQmj1DIPc5J7p2WeTyISdplSBQEUJ/w=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(346002)(396003)(376002)(136003)(230173577357003)(230273577357003)(230922051799003)(82310400011)(1800799012)(186009)(64100799003)(451199024)(40470700004)(46966006)(36840700001)(2616005)(40480700001)(7696005)(26005)(7416002)(5660300002)(478600001)(6666004)(83380400001)(426003)(336012)(1076003)(70206006)(54906003)(70586007)(316002)(110136005)(40460700003)(4326008)(47076005)(8936002)(8676002)(921008)(2876002)(2906002)(86362001)(41300700001)(36860700001)(82740400003)(356005)(7636003)(36756003)(83996005)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2023 09:08:02.9969
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f51a83f0-31c9-4550-d9f6-08dbffa8d718
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002529D.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4404

From: Ankit Agrawal <ankita@nvidia.com>

To provide VM with the ability to get device IO memory with NormalNC
property, map device MMIO in KVM for ARM64 at stage2 as NormalNC.
Having NormalNC S2 default puts guests in control (based on [1],
"Combining stage 1 and stage 2 memory type attributes") of device
MMIO regions memory mappings. The rules are summarized below:
([(S1) - stage1], [(S2) - stage 2])

S1           |  S2           | Result
NORMAL-WB    |  NORMAL-NC    | NORMAL-NC
NORMAL-WT    |  NORMAL-NC    | NORMAL-NC
NORMAL-NC    |  NORMAL-NC    | NORMAL-NC
DEVICE<attr> |  NORMAL-NC    | DEVICE<attr>

Generalizing this to non PCI devices may be problematic. E.g. GICv2
vCPU interface, which is effectively a shared peripheral, can allow
a guest to affect another guest's interrupt distribution. The issue
may be solved by limiting the relaxation to mappings that have a user
VMA. Still There is insufficient information and uncertainity in the
behavior of non PCI driver. Hence caution is maintained and the change
is restricted to the VFIO-PCI devices. PCIe on the other hand is safe
because the PCI bridge does not generate errors, and thus do not cause
uncontained failures.

A new flag VM_VFIO_ALLOW_WC to indicate KVM that the device is WC capable.
KVM use this flag to activate the code.

This could be extended to other devices in the future once that
is deemed safe.

[1] section D8.5.5 of DDI0487J_a_a-profile_architecture_reference_manual.pdf

Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Jason Gunthorpe <jgg@nvidia.com>
Tested-by: Ankit Agrawal <ankita@nvidia.com>
---
 arch/arm64/kvm/mmu.c | 18 ++++++++++++++----
 include/linux/mm.h   | 13 +++++++++++++
 2 files changed, 27 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index d14504821b79..e1e6847a793b 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1381,7 +1381,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	int ret = 0;
 	bool write_fault, writable, force_pte = false;
 	bool exec_fault, mte_allowed;
-	bool device = false;
+	bool device = false, vfio_allow_wc = false;
 	unsigned long mmu_seq;
 	struct kvm *kvm = vcpu->kvm;
 	struct kvm_mmu_memory_cache *memcache = &vcpu->arch.mmu_page_cache;
@@ -1472,6 +1472,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	gfn = fault_ipa >> PAGE_SHIFT;
 	mte_allowed = kvm_vma_mte_allowed(vma);
 
+	vfio_allow_wc = (vma->vm_flags & VM_VFIO_ALLOW_WC);
+
 	/* Don't use the VMA after the unlock -- it may have vanished */
 	vma = NULL;
 
@@ -1557,10 +1559,18 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	if (exec_fault)
 		prot |= KVM_PGTABLE_PROT_X;
 
-	if (device)
-		prot |= KVM_PGTABLE_PROT_DEVICE;
-	else if (cpus_have_final_cap(ARM64_HAS_CACHE_DIC))
+	if (device) {
+		/*
+		 * To provide VM with the ability to get device IO memory
+		 * with NormalNC property, map device MMIO as NormalNC in S2.
+		 */
+		if (vfio_allow_wc)
+			prot |= KVM_PGTABLE_PROT_NORMAL_NC;
+		else
+			prot |= KVM_PGTABLE_PROT_DEVICE;
+	} else if (cpus_have_final_cap(ARM64_HAS_CACHE_DIC)) {
 		prot |= KVM_PGTABLE_PROT_X;
+	}
 
 	/*
 	 * Under the premise of getting a FSC_PERM fault, we just need to relax
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 2bea89dc0bdf..d2f0f969875c 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -391,6 +391,19 @@ extern unsigned int kobjsize(const void *objp);
 # define VM_UFFD_MINOR		VM_NONE
 #endif /* CONFIG_HAVE_ARCH_USERFAULTFD_MINOR */
 
+/* This flag is used to connect VFIO to arch specific KVM code. It
+ * indicates that the memory under this VMA is safe for use with any
+ * non-cachable memory type inside KVM. Some VFIO devices, on some
+ * platforms, are thought to be unsafe and can cause machine crashes if
+ * KVM does not lock down the memory type.
+ */
+#ifdef CONFIG_64BIT
+#define VM_VFIO_ALLOW_WC_BIT	39
+#define VM_VFIO_ALLOW_WC	BIT(VM_VFIO_ALLOW_WC_BIT)
+#else
+#define VM_VFIO_ALLOW_WC	VM_NONE
+#endif
+
 /* Bits set in the VMA until the stack is in its final location */
 #define VM_STACK_INCOMPLETE_SETUP (VM_RAND_READ | VM_SEQ_READ | VM_STACK_EARLY)
 
-- 
2.17.1


