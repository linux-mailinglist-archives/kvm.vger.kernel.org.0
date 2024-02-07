Return-Path: <kvm+bounces-8282-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6227F84D32B
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 21:49:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8682B1C250B5
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 20:48:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7A7412A15F;
	Wed,  7 Feb 2024 20:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="MOZ31CZz"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2051.outbound.protection.outlook.com [40.107.237.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BBAD127B67;
	Wed,  7 Feb 2024 20:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707338874; cv=fail; b=aSnL733a8vBviO2aqrga2amGNlcuviK4//AhyrGr89A7MjYP5GpXBtpn2PUPdocWrW8PJarJAEvE2gTfrUNDsCnF75Pju66EDZhIlZVQM8+ungHviEtGW8CN/ZEcMffwjlS0Lvhf0fLtPKCj9XnEXvVSTCl/iGaAfVwUu6CMTkE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707338874; c=relaxed/simple;
	bh=QlNsIAteelD4xW3W2awNp73UHKXqw8x7bzR5hG1i52E=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fQ7wFUV0wdcNefTDpGpmEbKADLrNd6pgf9A1QIGpxYX5kIRl6mTMSmT1PfzFgvSJtfPZsnAGBBmnDYjNiecjQKPTriBayXN+6cgh8RmcKkHLhkHGCNlOodcPYsBzySPylphJePcpLtKB3ZqykUmEqSpHCIr5Ut129/dXPaljxU8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=MOZ31CZz; arc=fail smtp.client-ip=40.107.237.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RnXn6Us+jXK+1v/A95FiOgtAgHu2trLDOA/+ZGOJxcDMDq9oHg1QWk+w9rYnfhPyshjRsZ33agdMxXtguyuNHPmOVZ1HYVnnwJ8r9b7cj9kTkJE2GnXzaeHmamnWx5k9ulTvdlkmmdILSNz4AYBeJn8GL5GJlzT66eu7ZxR1MH1GMMDTLtxRXPXKnHSATWr1ohHm+3eG8AKS6wNtAvkRttd6VDc2YY9dZkEICjX7cgacYEiDxXAlWCeCc1+K/w0bPk6qIX6PHilWjiYWpB6Vli/eBu3mz4UUhfFZl8ybIJKWHTdzTrhJUORV9Z2GtlvwylCAfMN3ERqTFP/vZwKkYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9dH87y1Ff3/JbyhQcuXvoX32nC0bGp9ziimKLLP56yU=;
 b=SGGGT+DNLX1Qp/0fUY9WCraYCl0PUiGgde7uXClm6n1FXBpUMVJfNAy38x/u0xMTQlUXNXI5KHEqEuOM9Xzox/Pn2+StNryf+5km8shTkA2vRpxMop4/ku9mDuHmOU6NcGwgk6g13Ng8pKayqboMl75WAxJO7+EIYf9YxwhK3CLy28naEbGzxqF6CvTD1WO3PobTxVkvi6vZw5z9kzPB/nxlW2u3qKfJ9QCEAuYaYa6KSdi4zAemCJpkqjHCozMhc0k642f5CGujYPt6AAFYNJHzBf/O5hHBaRslgkTjCazsHkYOEQnzm43l+X6Ih8TxJqgbpXULk1VgBfnD9SuWqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kvack.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9dH87y1Ff3/JbyhQcuXvoX32nC0bGp9ziimKLLP56yU=;
 b=MOZ31CZzxhqRgQeWGyVu1qWVpwqEsz0tKAaVRIehf4jbwE7rn0ZJXGvYbyDrlJxYmxz8OtZin/eY4Re/mLDoihHWZFFLaHM1IJlm1YINILxzzMy5u5/9mR1zGlA9LKNnmcsoeVNBDBpemjY53ooTgKbppYIia+VXs5nueG80IYtSBM8p0Q+6VC2KfstqQgvc+pc58qECSDr9RlYS22HOfVTXqI+gcFVGXpvjZqasaSIUTq2zUX6gJw3YFrsmLYJEXw9TaAHLQTgIqEmZ8WunPvU/tNHB5hoNNU6rY6/S+qbdtdEGIZU6sP8LRC1fQpnasosebswt1wOmJ5ny9X0vbA==
Received: from DS7PR03CA0286.namprd03.prod.outlook.com (2603:10b6:5:3ad::21)
 by DS7PR12MB6141.namprd12.prod.outlook.com (2603:10b6:8:9b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.14; Wed, 7 Feb
 2024 20:47:48 +0000
Received: from DS1PEPF00017092.namprd03.prod.outlook.com
 (2603:10b6:5:3ad:cafe::2a) by DS7PR03CA0286.outlook.office365.com
 (2603:10b6:5:3ad::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.36 via Frontend
 Transport; Wed, 7 Feb 2024 20:47:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS1PEPF00017092.mail.protection.outlook.com (10.167.17.135) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7249.19 via Frontend Transport; Wed, 7 Feb 2024 20:47:48 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 7 Feb 2024
 12:47:38 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12; Wed, 7 Feb
 2024 12:47:38 -0800
Received: from sgarnayak-dt.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12 via Frontend
 Transport; Wed, 7 Feb 2024 12:47:27 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <jgg@nvidia.com>, <maz@kernel.org>,
	<oliver.upton@linux.dev>, <james.morse@arm.com>, <suzuki.poulose@arm.com>,
	<yuzenghui@huawei.com>, <reinette.chatre@intel.com>, <surenb@google.com>,
	<stefanha@redhat.com>, <brauner@kernel.org>, <catalin.marinas@arm.com>,
	<will@kernel.org>, <mark.rutland@arm.com>, <alex.williamson@redhat.com>,
	<kevin.tian@intel.com>, <yi.l.liu@intel.com>, <ardb@kernel.org>,
	<akpm@linux-foundation.org>, <andreyknvl@gmail.com>,
	<wangjinchao@xfusion.com>, <gshan@redhat.com>, <ricarkol@google.com>,
	<linux-mm@kvack.org>, <lpieralisi@kernel.org>, <rananta@google.com>,
	<ryan.roberts@arm.com>
CC: <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
	<apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
	<kvmarm@lists.linux.dev>, <mochs@nvidia.com>, <zhiw@nvidia.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v6 3/4] kvm: arm64: set io memory s2 pte as normalnc for vfio pci device
Date: Thu, 8 Feb 2024 02:16:51 +0530
Message-ID: <20240207204652.22954-4-ankita@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20240207204652.22954-1-ankita@nvidia.com>
References: <20240207204652.22954-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS1PEPF00017092:EE_|DS7PR12MB6141:EE_
X-MS-Office365-Filtering-Correlation-Id: 0fba5cdb-b07a-44b8-8d0d-08dc281e0b52
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	VvsnuM6oaAyfiXtkuG/bCnHcQm+BLB+0IhVYzYpvhutoFNOji1ZVO4uwuoOvf4KgZfcVkZ/tJUPzZuO87IKzLtRH3o9mAJxX1KylGW4I4vrfcyo4K4CVjbPjtzZAz2S5xY9YL3AdzLEx0iuOZwL226tDckNeBYeIlDjp8Ic9dCgKgW4QrdUqDogoSoKbcd+D+wzudAM8mcQUetB69mefK4gqYqzfCs9ACDmgBr9EQzu9GAeQC9bRHzHpb9h9prkK/+Y7gYlZemGkfuhEmBB3jTszeJ1RW+yNU3yQX5kXYDKUzW+gWVWII7OX8gzHX94cfxdoElaJBhVUp3xD9YX0JIH6ydA968u4t8+uHFxWGRnmJBc1qxpEvqLP0lRVHQHz0G4M385L8I65ypX9XxAfEYK56kUIwJe9k4DHlVrVzsbC28le2OyVgrgiR6dkMndsGOFp/6niFyTcNO62y4uO7sI5dBHTrqyRNZBxabPm9ZIvm7917rxXx5xjVO1TSRX6Yu9gCYsBfGa2rybZ0ucyZaSGgjdyd9Qvbc5yi6mVcnPHIvmINztFtra+56VYqjJ9KHOqySljiQIzMUa41jGAwJYNYaEnOD3wYJ+phKaf1+zSKd5668iURzXiyzNvxjrNCwasOoKUOLVCPHkJ0ggFpA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(376002)(396003)(346002)(136003)(230922051799003)(186009)(1800799012)(64100799003)(82310400011)(451199024)(46966006)(36840700001)(40470700004)(7416002)(5660300002)(4326008)(2876002)(8936002)(316002)(110136005)(70586007)(54906003)(70206006)(8676002)(2906002)(478600001)(921011)(7696005)(6666004)(36756003)(2616005)(83380400001)(1076003)(26005)(426003)(86362001)(356005)(82740400003)(7636003)(41300700001)(336012);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2024 20:47:48.2450
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0fba5cdb-b07a-44b8-8d0d-08dc281e0b52
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF00017092.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6141

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
new flag VM_VFIO_ALLOW_WC.

Adapt KVM to make use of the flag VM_VFIO_ALLOW_WC as indicator to
activate the S2 setting to NormalNc.

[1] section D8.5.5 of DDI0487J_a_a-profile_architecture_reference_manual.pdf

Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Jason Gunthorpe <jgg@nvidia.com>
---
 arch/arm64/kvm/mmu.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

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
-- 
2.34.1


