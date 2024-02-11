Return-Path: <kvm+bounces-8517-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B052850AB7
	for <lists+kvm@lfdr.de>; Sun, 11 Feb 2024 18:48:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7F9291C219A0
	for <lists+kvm@lfdr.de>; Sun, 11 Feb 2024 17:48:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BB3E5EE81;
	Sun, 11 Feb 2024 17:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="EtCuoswo"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2045.outbound.protection.outlook.com [40.107.237.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C07125EE61;
	Sun, 11 Feb 2024 17:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707673684; cv=fail; b=JoLZi9cyNNcUgH4YfEAuxy9gFVe8lrRy+pIdEwuCdgBBHBhzbnpBDOBmWZfNZei39wldZeMZhQk6qNcjIQ4NKriT58TF3VlHet9z8l1BlPdty3mnBydsx1+2tDJDEBV5NFVXTY1dkOywlZZuxE7ikrIIrD15RUF12gMZIoKEzok=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707673684; c=relaxed/simple;
	bh=9nmLiYxbILV+MjnM7nR4JOP0DeXX/Ob7LX8tmk+JTio=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=id6SbvsoYUP0a6NwKAP9fsX0VNZNhMlN1W+sAYF+VWRrCeN8iwX1/MZrcYP+K04buPqMZ1MRUQrJ4eLBSAuUpZeHAe4m8qVundpk9uhJxHKlQ80lB3gZNuWFq2qnTOpU3Da2fgMEGSF3mq0/6jVV3UQLHMl+RoK2SFb5BZi+6rg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=EtCuoswo; arc=fail smtp.client-ip=40.107.237.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nEzsiuYFjSP8N4G5X5fjz1Ur1/N3qfKNECA9J6NbAjHkvXT866wLPKgq2H8q78RRTPgX6YpoEbQ2Smdt3x8AutDP0rkzJ9HdCehhSxozXhxdF9cAtWdk0eBdp6zzFaGrfI5pP8QiyYWmve6llN4raPYPFNMB+kf2hm4LzyBFGIC0+FQ4V4Ixw3kc1oi816xn1FN0bYw2gbYK3GmIH2OzXnQSAKBSpKob/en3wADXGrKxRDzydshvN1JSN8nU6r8xUMPTumzQ1bjo+aqfV+74367fOOwinLIytojx7Z2AqK9/EgJitvjN1HQ5OkUUonr7zPC5OSXM7GxxYet3rEeMhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GEUPBUp/mRSrwoBY6hHPxBFvFm1Cd4dE+qw16gP2bsw=;
 b=eiqQKPjOsGjX/jhWgG+ETYhHlcmVZdb2UEWHxnKF/UIHhrE3DwV95hYtUyI5qA0Gg4QlqxSMkaR49PYlS3S94obsy0OkvZh5dj60U0Z45FzDdfuNmDQCbtBMhIaJWecCdevVYn1lHQhQLyTEJC3nWKTX/6tFOaa1DtoIoz1vbDaeEtXdFaqnw1cZNuSHs9m6YNK100jsIjpRPrzRRtz2awdmhqTXMpphgoL2gcA2WM7lMrJHtG9NXauE4JKj5pOqgN4qjS8JOy9upckSBzJabbE72jyOjwHK19fvNLsTJUM1KbDIsh6Im3+BIcZLDZC8J9jXrFMifgn1XbUQTgEyJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GEUPBUp/mRSrwoBY6hHPxBFvFm1Cd4dE+qw16gP2bsw=;
 b=EtCuoswotMWpcrle1XP1yr9Eku3RnAE5vjr5yOJiRtAATzvKfW5tJ7FTL2sCnsys6TxFrMmATmyEbs8T6ai7UauzENkDL6T2kE7jhaMY4uokHu/KS8/+kXq4LuU5WifJxa3hkqrKlnNDtkkOd4F3hX/46rXJp/8luql+6/t8vLxvn48kHE/vxBDBPaN+iH2JnOZObgfZSuM3gv1t+bzfAWWS4rUuaTVplWQWa3xTtgeyygtuabbmoNAZRop9h8Vfmue1+4RY91XcS1+ZpH0cW7C7eUT+CxP3DdNFlytLzJwI7Hql68XsWubSjHMGMI+5jk0U4wGu5xPGSCprPiYv5A==
Received: from DM6PR03CA0054.namprd03.prod.outlook.com (2603:10b6:5:100::31)
 by SN7PR12MB7225.namprd12.prod.outlook.com (2603:10b6:806:2a8::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.14; Sun, 11 Feb
 2024 17:47:53 +0000
Received: from DS3PEPF000099D6.namprd04.prod.outlook.com
 (2603:10b6:5:100:cafe::81) by DM6PR03CA0054.outlook.office365.com
 (2603:10b6:5:100::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.35 via Frontend
 Transport; Sun, 11 Feb 2024 17:47:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 DS3PEPF000099D6.mail.protection.outlook.com (10.167.17.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7249.19 via Frontend Transport; Sun, 11 Feb 2024 17:47:53 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Sun, 11 Feb
 2024 09:47:53 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.12; Sun, 11 Feb 2024 09:47:52 -0800
Received: from sgarnayak-dt.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12 via Frontend
 Transport; Sun, 11 Feb 2024 09:47:41 -0800
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
Subject: [PATCH v7 3/4] kvm: arm64: set io memory s2 pte as normalnc for vfio pci device
Date: Sun, 11 Feb 2024 23:17:04 +0530
Message-ID: <20240211174705.31992-4-ankita@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20240211174705.31992-1-ankita@nvidia.com>
References: <20240211174705.31992-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF000099D6:EE_|SN7PR12MB7225:EE_
X-MS-Office365-Filtering-Correlation-Id: 9328e4e7-c2b8-4281-f93b-08dc2b2992e9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	AhSeR5BaxNzG0QKrNhr7kPTxSNWm9QP170YFV72q5ODiA4Y1hSL7BppZPD7U14QobLia8LrifmyWzg4OzDLz5p2XhefJqXX5rhz7HZq3TUh+h32imnfEgh3agJAPc8qcXl/UfRms7q/jR8EYl6cBjCdjxk3wfKDi7/cdU3ocw0To/6hlZXYs7mK8fMmqzv/kcJso1BGTxaF/DEoDv+MwxxGSsCbYyxkxsD3w8Alz/OLrcxwhuF0bVAlVmI0iQpQ+lUx58AMJ7JBlA5dk2V4Sr0Lo3LePXECONE0nj9/ZAhEu9XBsrRGcupE60UKh8g1g/i5FkmkypVW/J90tvUhvvZccZjewmCbgwRbKnjebqy3U3fwQLmWO+R6z0pKeHw/hVNptqHbuMEA6K8s9FviUZ5Kt9i7JdJlKAHsICvkXXcNwrbn0gcrQ+LRHOEkWp+2MpjNXVwAzg33sk4nD2pxL6UNSVOO1z2xKsBvoMRV8VmwDbB44uZAse1Red/dRlAKi7pKsNBJuO1IteA+9AsXunLMOOLcP8A9OdDpqv6cTtL8k7BR+jELYQur/x+LMqsureYsk2yGkM9HgjItcuPpJJJas02+YpHdMxzVqstdTDZ4R3b+paz2MqfNSdiqZEmoPw5btCR0Px5o6avPd6wAG+w==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(376002)(396003)(136003)(39860400002)(346002)(230922051799003)(451199024)(82310400011)(186009)(64100799003)(1800799012)(40470700004)(36840700001)(46966006)(36756003)(921011)(478600001)(5660300002)(7636003)(7416002)(41300700001)(70206006)(8676002)(7696005)(1076003)(426003)(26005)(54906003)(2616005)(83380400001)(356005)(2876002)(336012)(2906002)(4326008)(110136005)(6666004)(86362001)(7406005)(70586007)(316002)(8936002)(82740400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2024 17:47:53.7134
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9328e4e7-c2b8-4281-f93b-08dc2b2992e9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099D6.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7225

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


