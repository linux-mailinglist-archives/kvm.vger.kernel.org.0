Return-Path: <kvm+bounces-9135-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AA4B485B404
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 08:31:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3731D1F24565
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 07:31:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F08C5A7A7;
	Tue, 20 Feb 2024 07:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="P8dxjSOJ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2057.outbound.protection.outlook.com [40.107.95.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAF205A4FF;
	Tue, 20 Feb 2024 07:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708414244; cv=fail; b=gOue9MAsnUqmISL6prS4YiRcZwwPJeZD8QIChkTmdmELiqfqCQNvo8oArxHIORbiRzUwBOgTb39hOwMkdVdO4hAwMnwRQXihQjY+Njtl5tCqYU4cWDAIgjnlerC+RbTWFKazJKIg/nfC+b/3FDVWVjUjRCtx7ezX/OzaubJdWJQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708414244; c=relaxed/simple;
	bh=9nmLiYxbILV+MjnM7nR4JOP0DeXX/Ob7LX8tmk+JTio=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JNDMXgvOfffBTddfc36CUH4ME05XjvbWSYoZNzcyGRlFORq4OkitrTsrnvQYewB6WQid6Jelaow0la3SJEB6JN8bUsnqqoOI3Fzd9In6+UT3a79WSld9Qb4+vWS1gIXDIxQ9MJoR3f2p/+Ro38dNGSx1aMwQfX28ps+mV+ktNJc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=P8dxjSOJ; arc=fail smtp.client-ip=40.107.95.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=inHGrvtncYNmQA0SSNYxz2O9Zv4pzyhYuqjV5gRztnEyTs4s8y9LUq/iNezPzPBe646uD6A6taJRvUBWZ4uN4uQk6hfVe5830VO2iS15aDSHFoi9TM0jfC+l8WYZ+NxrhZJ46dfxlq3jHCH8m/aiPoESaK5TPuD2Fb3ueF2mqdr5FQHtFxn1Rw+eIgqp+WohIeM8dtQAx7AfwaSAw2WnS8LEhwu/Ncfbcdc68UJOm2sEhWS7cICnuCmIHLzAD10DKsdUixiK0lID+i4NTKspMsHftZhtzMTAwCmVkEv+1IhmXQhEQVRxmc6DU1QxSrL3k+ewsRtzooPI0xF5SY70+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GEUPBUp/mRSrwoBY6hHPxBFvFm1Cd4dE+qw16gP2bsw=;
 b=hnWmGRlpLQnaapNYoqzg0r1UGJHhLD41vPBwj3HOT9GVfyiVs7uYWggCPy51WHE2Mp1laWHi7SebDiviTdMs6lCs2sbhWV9PVDqSEEyBAPqhKLnU7uzq2bovCwAd0NwdhrhxJ1vF+1Q70/zM40T/3wwOXKgVu5C8rm+wwqzsW8I17S609Qk9yogE7CW8IcbLaRxCTcAnbYvYhnSSuNMPXiUIBNK+JiB6n9UquhdgchvxBUV9gvA3fS9JBuZdbIqxjyeEvXzgKOYH5V/37BopYTaKN0NwLqzcHqpEl7E7plfbdAsVLLPzz+bymtbyt2vpv1S4Rak8TONLbHckJQRPfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GEUPBUp/mRSrwoBY6hHPxBFvFm1Cd4dE+qw16gP2bsw=;
 b=P8dxjSOJyVuRH67AcNtP8cxTAJ3hb/a574V4QUpha6qAi0g3+Rfa7ox+fOckXoDBSc3tAZdvA6bdLdStehJXj2WpNIu1W9rM1N8KK/juHRssHlS+yqzrtC8yN6T6Yd2kJItC3uiZJJ79FCUbbcqMse/kNwLwJ0UFOj7JYJddZIwkglA6xXkTcxgolnIh9BRjzNNcAVrDojl+SGm/UnD/Fv+H1lzBJ1OxY3ToP+mwh9zt4Qq837b8hG9dBfY1oJOhOplTk7epkEdPOhwb10k8NIUdps1M3ILFmCtDNOLEIBgDRvuqGt5K2dCNnci2Br5UpU+5f2HUgU2WeoN2vWsO0Q==
Received: from CY8PR22CA0015.namprd22.prod.outlook.com (2603:10b6:930:45::14)
 by CY8PR12MB8242.namprd12.prod.outlook.com (2603:10b6:930:77::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.19; Tue, 20 Feb
 2024 07:30:40 +0000
Received: from CY4PEPF0000FCBE.namprd03.prod.outlook.com
 (2603:10b6:930:45:cafe::93) by CY8PR22CA0015.outlook.office365.com
 (2603:10b6:930:45::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.39 via Frontend
 Transport; Tue, 20 Feb 2024 07:30:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CY4PEPF0000FCBE.mail.protection.outlook.com (10.167.242.100) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7292.25 via Frontend Transport; Tue, 20 Feb 2024 07:30:40 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 19 Feb
 2024 23:30:23 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12; Mon, 19 Feb
 2024 23:30:23 -0800
Received: from sgarnayak-dt.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12 via Frontend
 Transport; Mon, 19 Feb 2024 23:30:09 -0800
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
Subject: [PATCH v8 3/4] kvm: arm64: set io memory s2 pte as normalnc for vfio pci device
Date: Tue, 20 Feb 2024 12:59:25 +0530
Message-ID: <20240220072926.6466-4-ankita@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20240220072926.6466-1-ankita@nvidia.com>
References: <20240220072926.6466-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000FCBE:EE_|CY8PR12MB8242:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e7e5fe0-ac1e-4e0f-2755-08dc31e5d6ee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	qpLJyNWq3sY6o8aGbW1uTCBZ8xMGTbned0cGf7WeEH649MhkBsfFNv0F7bD3Id2MbGCRcYtBt/O+OCgSQvpxiGkEqMNiLFOFC1knnfjSOgo62mubXO0I9QrInBippSz1B+VxQfaAsjeigvx3uIFKUVNhgZTiJjaHFYeoFUfygNbL4nFd/9bmeguhtB7rqwgO10TLXsU1YJOIVXN3uWb0aaovquG3OoyohEkonZdQMe9zYdjwaXRww21Yu+JYCcAiyYHZVVGl5JV+iqfD6F8nZ9pLFpFn4BkSDohG5Omp9ctgFNjTtPRMhm7A0wj0UDpCYHAVO9BECoQQv+IeTfZ/lNUZfvkhxmAzW0p4gIfwuBqlyjnTcX08Jz3aQLh3/fpI9SLO6gltqtUTyonPNq0BqKGi+BVwhPO1Y3gtyk2J06ArR/XtpWt8rjAswBQAOemh4F97qts01urpAXc7VKIm3xckVITWFu8fyjQOUcD3XCXeiCi1RGREAb11otFuINznz48sE7eCvLIqzmfNu60mBWX8mjNtnfyTEHfXIJ1zIcWiSSZ48qW88NgdWSxQl3Ba+K+DAq2Fy5/tm0Q6CE04dCdqlUMcmra8D6QbMakX3QNnso2xWvvB0vdmzGCo+z3jhWezXmRKFRHYfBLUBdYgcHzIYkdqpoQK4QeSK5Hpjek=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(36860700004)(40470700004)(46966006)(921011);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2024 07:30:40.1721
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e7e5fe0-ac1e-4e0f-2755-08dc31e5d6ee
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000FCBE.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8242

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


