Return-Path: <kvm+bounces-3932-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D1E7180A9A3
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 17:48:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 48977B20B42
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 16:48:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B698037151;
	Fri,  8 Dec 2023 16:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="pat3+ixb"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2054.outbound.protection.outlook.com [40.107.212.54])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 262D419A6;
	Fri,  8 Dec 2023 08:47:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DVwkvQ3sNa+XtS3HPuV+ozAPtjrcsGT0tDdt0aKKgUjYT7du70gvAzhZtt3mvuhEiBk6C5HWLeBBRdM47q2591WRzA8DuOg6Yikk1VZ85SObXU1B7wG1TN3n0H38n+vyY9LZaGV/woO+h1kwA+7su+8BrZJPSHN/ZqgeJyzUFFYwq7zwDt2slSiIy5mJDie6jiiYLkEMn3wugVFVq/sYf8DGstk7KpxyHVa1CTQS/HLBk7X90DctzzRBkVt7V/MEdALDlSYFxrEqko92Q8l8IH9Jn/9x3FgrSo181dLDkWZcwreBZBbxxKwzs15PK8kl8ktUIKtXPcJYQ2pxohMBAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rdqJ/MqrrTEdlgdPk7gcSIxLY3/h+42UQ3wjWVPBf6Y=;
 b=aGvXsUbEW8hoMixRVh6NOzAdvv/4Z68CIDGZX1nKSbOArYvi70scUqRAmBwWlR2K6PFxTFpiJuZAgXI1XTOx/X03shaCsenwuzg09K829OYUmdPA6Hp1MtcWodOOvf3eZTvcxVuw/ESNJh8+gKh80+KRmLXoQf6mKityl5HfrYiv86Vr0QFOVauNKCG4WJWwrrhOQJLyxvhlRrZEgoa5gQCni4VxnK/caZbp0FEFhgE3Pb/VMMmCB6TUke8nVw+mNYk85yC/gl9k00qV9az/jn/XZfnptqzpW9MrDrwRHrUd95xtHb/GZHpOq42njpMcGhjKWGZqA+G6DnCNbQml6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rdqJ/MqrrTEdlgdPk7gcSIxLY3/h+42UQ3wjWVPBf6Y=;
 b=pat3+ixbIEBcNdTvxh1twlNEpK7TfZvfJMkS9gDhLnTZsw4WC1PSL+TOMeS0PcCTJ4rx1sDUBIruDr1LFS89Rep3rZkmU9dg3BE+CDX1qfHiyyVZhUFYf1GganKGX7zf90ZWlRVOvjKPWF4l8zKuf3rpV+gUTAGx08jdEm6/HYLN1F6oJbDMIVFamypVhaR4q7mDTXpMWAsXG10keDmHyNBHj8PoqmdJeUoJqxo5SnzVNAtvf+48YNTp2kFp1ZnhPAYo/ITNUuYLe2PiMBdRJybsqT+Gc1M+yFcCaFw6Th4E89jPYccna0qH3tBfK7GokYZbEQ/SRW/GlcA8LWph6g==
Received: from PH0PR07CA0110.namprd07.prod.outlook.com (2603:10b6:510:4::25)
 by MN0PR12MB6103.namprd12.prod.outlook.com (2603:10b6:208:3c9::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7068.27; Fri, 8 Dec
 2023 16:47:55 +0000
Received: from SA2PEPF000015CA.namprd03.prod.outlook.com
 (2603:10b6:510:4:cafe::84) by PH0PR07CA0110.outlook.office365.com
 (2603:10b6:510:4::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7068.28 via Frontend
 Transport; Fri, 8 Dec 2023 16:47:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SA2PEPF000015CA.mail.protection.outlook.com (10.167.241.200) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7068.20 via Frontend Transport; Fri, 8 Dec 2023 16:47:54 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Fri, 8 Dec 2023
 08:47:37 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Fri, 8 Dec 2023
 08:47:36 -0800
Received: from sgarnayak-dt.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41 via Frontend
 Transport; Fri, 8 Dec 2023 08:47:29 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <jgg@nvidia.com>, <maz@kernel.org>,
	<oliver.upton@linux.dev>, <suzuki.poulose@arm.com>, <yuzenghui@huawei.com>,
	<catalin.marinas@arm.com>, <will@kernel.org>, <alex.williamson@redhat.com>,
	<kevin.tian@intel.com>, <yi.l.liu@intel.com>, <ardb@kernel.org>,
	<akpm@linux-foundation.org>, <gshan@redhat.com>, <linux-mm@kvack.org>,
	<lpieralisi@kernel.org>
CC: <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
	<apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
	<mochs@nvidia.com>, <kvmarm@lists.linux.dev>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v3 2/2] kvm: arm64: set io memory s2 pte as normalnc for vfio pci devices
Date: Fri, 8 Dec 2023 22:17:09 +0530
Message-ID: <20231208164709.23101-3-ankita@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20231208164709.23101-1-ankita@nvidia.com>
References: <20231208164709.23101-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SA2PEPF000015CA:EE_|MN0PR12MB6103:EE_
X-MS-Office365-Filtering-Correlation-Id: b3ed524c-c425-4b36-cc3f-08dbf80d6cb5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	5SCtre8fJDGs6Wt81EkObPxcwz6fNsw6HmuOkYhQoQve8Xel+9sE0tJgdTcW70BJsBLcEt/0fvAgiZuYTdrnFDKxRCeVFmBSXwkftncgbOb3qR4zTZ2yGBZQ9PYL3yw1f6ewzJMGm0ePoK4zzYeTQhmLhOrMyeTZvsE8tO9Ru549nU5B8IfGrZDVy39BlZk4jsLw6VuVaijTk5bxKV/194YgGw3AZsrTGLKfec1kNj/x77W8xAOptSBda5NvfBeLO+qsSCK0sL51G4BnQldpjI9CCRms/FqjTfEcg0j/wMvLwhWXtAg+DLC2rRbhsTGwQmVJ8y1OYzXgz/ZXLnb2b6Oi+vz4PNAqMCB5EseqpvwRECQFG0dEnPvDYwZKEwe4E8BmxwIDZAqvfTMUvgSaaDRXzttsTclyMvu02jyiBT/l4Cifglr8WMmMl8w+rLgx2VR0C/sHDJrDKOjxvxI6T2jESHM+Si+ONbqjNPQbSex94hstxRuxe+WCbnGIBYalaSfBHKV60oJQohY8C2h3oyb8jRfZBRLQsOmmDUu69coEGEd80O9PBZ/gcLJ5tZ9VTecwVVHeCdnNhaUrqKX5Fve9zXIdqnlozQFE0FC4tpqlvWwtLSjdYMoy/Ic7VXiK5YIt3c8UAITOozg1CVpckkspHHLl9xvLrOPyXj2kWS7gfbdjVALnCJYtW86GEuj//XlGMvWMoV/DKgvfgDX7/G3E8/wVydmbAKrNeQDCWBDOizBhK8iomqrJqX9DXVgfpfRPQWjWvDbSI5I8dAQ5iBBTx2v7fhtZ6JeKJOO6CSSs3TtlIzCOO+33qDwMTkxtMNhQ793G5PRZmdK2YhxlG81Kh/FPV75lcEidEV0lwX4=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(136003)(346002)(376002)(396003)(39860400002)(230273577357003)(230173577357003)(230922051799003)(82310400011)(186009)(1800799012)(64100799003)(451199024)(46966006)(36840700001)(40470700004)(2906002)(7416002)(40480700001)(8936002)(4326008)(8676002)(5660300002)(2876002)(316002)(70206006)(70586007)(40460700003)(110136005)(54906003)(47076005)(36860700001)(7636003)(2616005)(1076003)(7696005)(36756003)(26005)(6666004)(336012)(41300700001)(478600001)(82740400003)(83380400001)(426003)(921008)(356005)(86362001)(2101003)(83996005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2023 16:47:54.3924
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b3ed524c-c425-4b36-cc3f-08dbf80d6cb5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF000015CA.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6103

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

Limiting to the VFIO PCI module is done with the help of a new mm
flag VM_VFIO_ALLOW_WC. The VFIO PCI core module set this flag to
communicate to KVM. KVM use this flag to activate the code.

This could be extended to other devices in the future once that
is deemed safe.

[1] section D8.5.5 of DDI0487J_a_a-profile_architecture_reference_manual.pdf

Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Jason Gunthorpe <jgg@nvidia.com>
Tested-by: Ankit Agrawal <ankita@nvidia.com>
---
 arch/arm64/kvm/hyp/pgtable.c     |  3 +++
 arch/arm64/kvm/mmu.c             | 16 +++++++++++++---
 drivers/vfio/pci/vfio_pci_core.c |  3 ++-
 include/linux/mm.h               |  7 +++++++
 4 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index d4835d553c61..c8696c9e7a60 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -722,6 +722,9 @@ static int stage2_set_prot_attr(struct kvm_pgtable *pgt, enum kvm_pgtable_prot p
 	kvm_pte_t attr;
 	u32 sh = KVM_PTE_LEAF_ATTR_LO_S2_SH_IS;
 
+	if (device && normal_nc)
+		return -EINVAL;
+
 	if (device)
 		attr = KVM_S2_MEMATTR(pgt, DEVICE_nGnRE);
 	else if (normal_nc)
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index d14504821b79..1ce1b6d89bf9 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1381,7 +1381,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	int ret = 0;
 	bool write_fault, writable, force_pte = false;
 	bool exec_fault, mte_allowed;
-	bool device = false;
+	bool device = false, vfio_pci_device = false;
 	unsigned long mmu_seq;
 	struct kvm *kvm = vcpu->kvm;
 	struct kvm_mmu_memory_cache *memcache = &vcpu->arch.mmu_page_cache;
@@ -1472,6 +1472,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	gfn = fault_ipa >> PAGE_SHIFT;
 	mte_allowed = kvm_vma_mte_allowed(vma);
 
+	vfio_pci_device = !!(vma->vm_flags & VM_VFIO_ALLOW_WC);
+
 	/* Don't use the VMA after the unlock -- it may have vanished */
 	vma = NULL;
 
@@ -1557,8 +1559,16 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	if (exec_fault)
 		prot |= KVM_PGTABLE_PROT_X;
 
-	if (device)
-		prot |= KVM_PGTABLE_PROT_DEVICE;
+	if (device) {
+		/*
+		 * To provide VM with the ability to get device IO memory
+		 * with NormalNC property, map device MMIO as NormalNC in S2.
+		 */
+		if (vfio_pci_device)
+			prot |= KVM_PGTABLE_PROT_NORMAL_NC;
+		else
+			prot |= KVM_PGTABLE_PROT_DEVICE;
+	}
 	else if (cpus_have_final_cap(ARM64_HAS_CACHE_DIC))
 		prot |= KVM_PGTABLE_PROT_X;
 
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 1cbc990d42e0..c3f95ec7fc3a 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1863,7 +1863,8 @@ int vfio_pci_core_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma
 	 * See remap_pfn_range(), called from vfio_pci_fault() but we can't
 	 * change vm_flags within the fault handler.  Set them now.
 	 */
-	vm_flags_set(vma, VM_IO | VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP);
+	vm_flags_set(vma, VM_VFIO_ALLOW_WC | VM_IO | VM_PFNMAP |
+			VM_DONTEXPAND | VM_DONTDUMP);
 	vma->vm_ops = &vfio_pci_mmap_ops;
 
 	return 0;
diff --git a/include/linux/mm.h b/include/linux/mm.h
index a422cc123a2d..8d3c4820c492 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -391,6 +391,13 @@ extern unsigned int kobjsize(const void *objp);
 # define VM_UFFD_MINOR		VM_NONE
 #endif /* CONFIG_HAVE_ARCH_USERFAULTFD_MINOR */
 
+#ifdef CONFIG_64BIT
+#define VM_VFIO_ALLOW_WC_BIT	39	/* Convey KVM to map S2 NORMAL_NC */
+#define VM_VFIO_ALLOW_WC	BIT(VM_VFIO_ALLOW_WC_BIT)
+#else
+#define VM_VFIO_ALLOW_WC	VM_NONE
+#endif
+
 /* Bits set in the VMA until the stack is in its final location */
 #define VM_STACK_INCOMPLETE_SETUP (VM_RAND_READ | VM_SEQ_READ | VM_STACK_EARLY)
 
-- 
2.17.1


