Return-Path: <kvm+bounces-9601-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6AC6D8625C1
	for <lists+kvm@lfdr.de>; Sat, 24 Feb 2024 16:08:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F05B71F2226A
	for <lists+kvm@lfdr.de>; Sat, 24 Feb 2024 15:08:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 854774DA05;
	Sat, 24 Feb 2024 15:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="TNiRMXRA"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2043.outbound.protection.outlook.com [40.107.96.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B11464D9E1;
	Sat, 24 Feb 2024 15:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708787219; cv=fail; b=uyv4fCDr23i9GOnJVLedBwozzKkxQgGoNDiLxnVjG9n1JgydNg7RFqY5W3FNyYWvd/sOUDECXex/l/x/Fe0yna7cNwGeLwkideUAfBJyXMtqdcezUmGQW+c2JJdT79Hfu56omxy8hjzvmGSJVS9SAbdpI9LG0apB13it7LAtv2Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708787219; c=relaxed/simple;
	bh=8vBBEAS6IV/M5LQc2fHxuWsoFqC58ZaknvAh1V7bHrU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c9wZnnBZeMSn0eF5dwCweUzrmLV0GDMTcvgHcDGhlHQ0KFU1Fld71nb20bRcHF69aY6+2o9ZxuyMSO2wt6tZ7MmsNCzHKLmTUoEajHeH0ad4mIwIPdgaRT36+IPjyEFWJfzAeUoi1JJeBk8EJwXF6WKZYnfoOOcJiuisKC3QxS8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=TNiRMXRA; arc=fail smtp.client-ip=40.107.96.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iVK0cGu5AHYQzOIG5CqN20lOKmV/xjbxSytF+soKbCVvzMiRjh6RdMqIQUpz3FMK2I52odqvjqc0mibf7jP1FJigvXSbfYywxXDeLjTClyUaYpyq/t5Q2pjPaqAoVDkp3r5b4+3GOSDplqRH0c5uwEtsVLnNoI79CoueZgWRFJ+o0lznGqSuCPuJiKHv9JYHN+k3X9nRdtOrpynSJzYf9AQh014kF4RtUnomuNES8pKm7j8i/Sv6XPsI5Ad7wF/jB+5nuUKeMNr5c7h3TLiyxQ8RY0vjHJZLvEdR3jV5FGn8X53YxUhLrL9V3AirRHFVN3w9zQvJHv+BS7bM8BOfNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=38sjOfDPntBETQKkswWgEcSo54FMUnu5XGVPfsldrSI=;
 b=WmvW+6NXll5gtsyx1SHhD0GBWwXcqDT5LyphXfdISP9NRkLKPum4Wu0AXn035CHCSh8Mgyf9BQqn22dCXAT8HF48dHUN8MHxbnKJU9HJz7OzaQm7LCs2wC+mbgDxwNRcnzxr8Re0BWVx2ZXJIF+5y/MANxuyQ0xCaRcu8x9X7/580yr5Kc+X3TBblGgEhYLF+Hc7FQqm+OREwxQjYRY7rA1V/ACFjV9ZqFESvfI3AHtPzeXAgmi1ZK5BUlsSPGtV+mMjusg3QIevR0E+r8WXSj07YuuEsdYrAaU69CiLmHqKK5hdQgNCjM8DHgsGeMkw1HoUAULNeIkDSucNOfUgVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=38sjOfDPntBETQKkswWgEcSo54FMUnu5XGVPfsldrSI=;
 b=TNiRMXRA9pRJy1r5DiCE6GcB21XKZL/8C9fbYIUvfbh6/hn03mYNSjkXLqtoc9OpyD5+/Es/Hm5zaYV8ReSPh6NMHFj9+tA4snYQ01+J1L2s6faxYqwOBNoKkVA5UDYY/USLv5oVIFi1awfsS3Qm4dK8GLtVzvyjJxjY6Yu2QJEnMX7Vy7a+yktIXMQNmFAiUV0RaoXJcR4kmtQxgACAhJlXq/8JV/E9tLSHEC6qRaP/qCAOTWmyQBzt6B/dFgfuqeNTpGuEqki/DNjbzl8ZXfQfMVDseNgRtsC5DldV+zL/3tKMzctNgDa17K7Phdfk7GXIH2CBMA7L+SCURe9p+Q==
Received: from CH2PR19CA0011.namprd19.prod.outlook.com (2603:10b6:610:4d::21)
 by DS0PR12MB7678.namprd12.prod.outlook.com (2603:10b6:8:135::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.24; Sat, 24 Feb
 2024 15:06:52 +0000
Received: from DS3PEPF000099D7.namprd04.prod.outlook.com
 (2603:10b6:610:4d:cafe::d5) by CH2PR19CA0011.outlook.office365.com
 (2603:10b6:610:4d::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.48 via Frontend
 Transport; Sat, 24 Feb 2024 15:06:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS3PEPF000099D7.mail.protection.outlook.com (10.167.17.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7292.25 via Frontend Transport; Sat, 24 Feb 2024 15:06:52 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Sat, 24 Feb
 2024 07:06:39 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12; Sat, 24 Feb
 2024 07:06:38 -0800
Received: from sgarnayak-dt.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12 via Frontend
 Transport; Sat, 24 Feb 2024 07:06:26 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <jgg@nvidia.com>, <maz@kernel.org>,
	<oliver.upton@linux.dev>, <james.morse@arm.com>, <suzuki.poulose@arm.com>,
	<yuzenghui@huawei.com>, <reinette.chatre@intel.com>, <surenb@google.com>,
	<stefanha@redhat.com>, <brauner@kernel.org>, <catalin.marinas@arm.com>,
	<will@kernel.org>, <mark.rutland@arm.com>, <alex.williamson@redhat.com>,
	<kevin.tian@intel.com>, <yi.l.liu@intel.com>, <ardb@kernel.org>,
	<akpm@linux-foundation.org>, <andreyknvl@gmail.com>,
	<wangjinchao@xfusion.com>, <gshan@redhat.com>, <shahuang@redhat.com>,
	<ricarkol@google.com>, <linux-mm@kvack.org>, <lpieralisi@kernel.org>,
	<rananta@google.com>, <ryan.roberts@arm.com>, <david@redhat.com>,
	<linus.walleij@linaro.org>, <bhe@redhat.com>
CC: <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
	<apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
	<kvmarm@lists.linux.dev>, <mochs@nvidia.com>, <zhiw@nvidia.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v9 3/4] KVM: arm64: Set io memory s2 pte as normalnc for vfio pci device
Date: Sat, 24 Feb 2024 20:35:45 +0530
Message-ID: <20240224150546.368-4-ankita@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20240224150546.368-1-ankita@nvidia.com>
References: <20240224150546.368-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF000099D7:EE_|DS0PR12MB7678:EE_
X-MS-Office365-Filtering-Correlation-Id: a20538a6-580a-4022-9a6b-08dc354a3bbc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	hC4hhayOtUyn4ffNXgDelGD9b4kuU8rkx2Zk+kuSiRA6qt6A6GVWHvEnuvbA0PdW0bkE6rCPtzu/K/FYsnRQ6BoxppPYZaKxtmeHGYxGlvzpKKGjoCVbgwKAgV4neYhozCyvl9RrZ7cO7FrWKFbke7QBt/dAbs97b0qTshqwNxh0fTuiEVc/QBbT8RwCPG9agpDz50vPxodgNGgPYpZ8miUmgwARYVdmybHHChcOo3uwk25oRpePbkIdc0QOhBqSL9YdVsVEZxq1jxwv+7SxFIxEbe0iZz3xEj9L4mylXDWav8Q78BHCaQNl5bbJvcHzJvrlGxfhg3T4LxEuCDbyj2PNzDd+1/DiTsgsWoYyaVVK878Ff6opm+pwikR6oS2QbncRU7IowTuf6UeDh2cb5gN6UA6GHsU7tN7WeJH9Gr2WFtvmM8SNMaaECj/nOHb5cEaIqz9FAaozLi0I84I3233SeYHEVrIfFHV0PRdTIBLJA56BAAN5LPYH474+/28FERNJhrnphDoXFwSLTyLOrtf9YAez2+EYDWG+vdh++tXqCRGV3nqYD/JsU85HRosohh/XdBz1NNrC02DVpMxAlbDy9IVD99K0wc8Xjns51qLS8M1uUMM+Ca7gkzPQgRBilGk9ukt6DjRn3i14rtb8ZvL87tLKu7dZSu5zheqnU6Y=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(36860700004)(40470700004)(46966006)(921011);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2024 15:06:52.3179
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a20538a6-580a-4022-9a6b-08dc354a3bbc
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099D7.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7678

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

Still this cannot be generalized to non PCI devices such as GICv2.
There is insufficient information and uncertainity in the behavior
of non PCI driver. A driver must indicate support using the
new flag VM_ALLOW_ANY_UNCACHED.

Adapt KVM to make use of the flag VM_ALLOW_ANY_UNCACHED as indicator to
activate the S2 setting to NormalNc.

[1] section D8.5.5 of DDI0487J_a_a-profile_architecture_reference_manual.pdf

Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 arch/arm64/kvm/mmu.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index d14504821b79..1742fdccb432 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1381,7 +1381,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	int ret = 0;
 	bool write_fault, writable, force_pte = false;
 	bool exec_fault, mte_allowed;
-	bool device = false;
+	bool device = false, vfio_allow_any_uc = false;
 	unsigned long mmu_seq;
 	struct kvm *kvm = vcpu->kvm;
 	struct kvm_mmu_memory_cache *memcache = &vcpu->arch.mmu_page_cache;
@@ -1472,6 +1472,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	gfn = fault_ipa >> PAGE_SHIFT;
 	mte_allowed = kvm_vma_mte_allowed(vma);
 
+	vfio_allow_any_uc = vma->vm_flags & VM_ALLOW_ANY_UNCACHED;
+
 	/* Don't use the VMA after the unlock -- it may have vanished */
 	vma = NULL;
 
@@ -1557,10 +1559,14 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	if (exec_fault)
 		prot |= KVM_PGTABLE_PROT_X;
 
-	if (device)
-		prot |= KVM_PGTABLE_PROT_DEVICE;
-	else if (cpus_have_final_cap(ARM64_HAS_CACHE_DIC))
+	if (device) {
+		if (vfio_allow_any_uc)
+			prot |= KVM_PGTABLE_PROT_NORMAL_NC;
+		else
+			prot |= KVM_PGTABLE_PROT_DEVICE;
+	} else if (cpus_have_final_cap(ARM64_HAS_CACHE_DIC)) {
 		prot |= KVM_PGTABLE_PROT_X;
+	}
 
 	/*
 	 * Under the premise of getting a FSC_PERM fault, we just need to relax
-- 
2.34.1


