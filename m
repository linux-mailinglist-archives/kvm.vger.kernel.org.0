Return-Path: <kvm+bounces-10547-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A7CA886D35D
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 20:40:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1EF411F2547A
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 19:40:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 038B713C9F2;
	Thu, 29 Feb 2024 19:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="BAu1MFlu"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2072.outbound.protection.outlook.com [40.107.220.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41B8212FB0B;
	Thu, 29 Feb 2024 19:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709235589; cv=fail; b=KJoebJiyiOXMwU5wDPYg4rAoJI+8u5ipXFPc74LTHvTLWODNlYI/4fgNkv117QC6p2xvBv++iJjKJ09UHmePE7X6H80T+KGE821RG881S7ZzJprMRSRa+oqsusMjQgx23Wf6fTM7r3ST+EbISmqS1KD44ZQXJRvOjNdsyzrKg8A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709235589; c=relaxed/simple;
	bh=BXI94fTo/+st/2UgTyDvPVMXFsKfSC6Nczgo3L0r9v0=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=QQY6XcAZ8TK1igkn8aUmmeXoHkGCsf1/ClCbopmzxT534JRtnDsdm8YyNSFdDQwyOS5jOx63wFhCezgRnyhz8R0P3WTZlCAwVAk63ceWz75TueQnK2LulMLRgFk++pZnBK686V9WOYIlC9PFlwuLchftUEEfzsDiACC3YPZChXw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=BAu1MFlu; arc=fail smtp.client-ip=40.107.220.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QxLblNkkHl92F6xZZVvijGDypVn8mP2fXW9+CQETQDEIHZnGEj2j25berFwI6M2zbRrhI9cGkAoYJc7usI8YVrl6XoILSnHIIiQwr9qmSfM4xLRYZqrVxsfYaB1VxewuoJK/nev0sZWXW1JDpoKJV90HoL+0E2MKoLI+VQ3+k+iHOnV646sxtH5giPNvDqkG1cK7hEL5HsPVN+WB6Oh8JlF5ti3HVw//YtQsqkryFHEdgdHj0PHBXB4/UWwe5QBzarueIA4UTa8Z/FElqQE1Ai4HOGM3iYZ5w39eBJ9jjlbv5JHiBA+1Clhnxlbjnw5OasQpH7YXmqcqRk6yyyuaWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2zlRcHPUcfcsAoR9NZ0ZpwKBXX/EScekMzuU0PDoxqE=;
 b=LJuPJW+h9/TPQIWbuxaeXFwSgBNY4HUPby3dhF2twSUNuZw2NPtraEPsGr7LtagOH6n2HGRXkrJsOTzoAzjRNB0oUs+UV9VN+Q8UU36eCUflUGKjwEoJun/Qh8T/fSdlhXrQOcLYSWi3llh1nkccy0PxY77voRfeeQGuZPr8U5P06aMgr5B7LkXjGoD1hhvUMn+cixrx+pZAPuQMw2enm0NHppkmAH9lmyuU3sPwSgJWwhsuS05GaI6MIwzTKur/cZzGVErx+raWIh1IoxnQVzZ+D/2q/2y9J4Yihm9RkWjfcHucA1GupV2gk6S6FXNM1vrSCWrIciWrJhNaQyRaZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2zlRcHPUcfcsAoR9NZ0ZpwKBXX/EScekMzuU0PDoxqE=;
 b=BAu1MFluderqaUzZ+d6hlxMTFykIL/BczgKLOGGAlA/ICul3EGacrsb/AKumsdBRtHTtbwJdZzez01g77Qhwd2hfZCAlGhe+pAWuxXC/pB3mpIQgcqVP1ktYPvLAM3EPNu+jNbiAfXN9v008/ejTPj49mVFooafNzej2qlLNFmsZk08CHy6vIE1cmolpqvwJhnel+dOpo05FvdGjtFdAN0ps8FpITw4cj2z19UcXr3pwUsj2zGzwmt5AsY079fauKwIqqUjbzKYE/+19af59MYEv9Tv2zh5loep4x6XCzZk2ko4H2UgAIrR6AYa6CsA4nLcYH2aU3g5cmId5Ev+NTg==
Received: from CY8PR22CA0001.namprd22.prod.outlook.com (2603:10b6:930:45::6)
 by DM6PR12MB4073.namprd12.prod.outlook.com (2603:10b6:5:217::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.37; Thu, 29 Feb
 2024 19:39:43 +0000
Received: from CY4PEPF0000EE36.namprd05.prod.outlook.com
 (2603:10b6:930:45:cafe::46) by CY8PR22CA0001.outlook.office365.com
 (2603:10b6:930:45::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7339.31 via Frontend
 Transport; Thu, 29 Feb 2024 19:39:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CY4PEPF0000EE36.mail.protection.outlook.com (10.167.242.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7292.25 via Frontend Transport; Thu, 29 Feb 2024 19:39:42 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Thu, 29 Feb
 2024 11:39:34 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.12; Thu, 29 Feb 2024 11:39:34 -0800
Received: from localhost.nvc.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12 via Frontend
 Transport; Thu, 29 Feb 2024 11:39:34 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <jgg@nvidia.com>, <alex.williamson@redhat.com>,
	<yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
	<kevin.tian@intel.com>
CC: <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
	<apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
	<rrameshbabu@nvidia.com>, <zhiw@nvidia.com>, <anuaggarwal@nvidia.com>,
	<mochs@nvidia.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 1/1] vfio/nvgrace-gpu: Convey kvm to map device memory region as noncached
Date: Thu, 29 Feb 2024 19:39:34 +0000
Message-ID: <20240229193934.2417-1-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE36:EE_|DM6PR12MB4073:EE_
X-MS-Office365-Filtering-Correlation-Id: a7b79aae-fffd-4bc0-4d82-08dc395e2d57
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	vHXXZxij5U4lePKnlzZTPeiCEpd4KsU+opaETy+tr0aMRbxMtPmlQdBibzny2VdO1Ao2I8r6G0JnYqx64/FTf3w0zw+sF8UZ/yzTeQjzcy0NGZXr2b1GU0vqR+KFt5kQc9qgxMhc9AVb16qqqYcKnDine8HyenSWIhW2cwm78hBlOXLvQ5kcbYe5af1GN3JIKy2nXObW5Zs2M7iEbnEjl8wDazWEbtfQl+nt5nw7hkWVvQaCFPq/uQefDMkIPZwrQDPG5MOCc9lxoQB/0usy8xWsHXz3wJYx3YSGfit5qBKRKZlK64T2K+vC1nO1cgME05kZgpoOUIow5NIPwut8gHnLnrjUSIPuA+UaIho0aLyhdUsvObsHVpluP8JjVvDzIwVOMW1MSx3iG6spcYwFcLTVw8TS191mtBLzKNooaiWvZDLGgiw1gkr2mX+214xTVBTr/R13VTFfpJN3bRXG79raqAKRYEGsnhmFzMiTN99srg7ghpx/21NNCmMsUw8MhBsBzf4hsCmMNQObI58wsN0+/YpVy5uzRDZJ9u4tX+ZVUweOAHIh9eXnZmfx7U5fN5wKWF0E1DtrKEONknY280UKsnkKRKRZ7DL/HgpX71qRmtJ8Z6JZdIDwBdnihC+A1WDf1XjcQHjfREjoGnihFAHV2WAEIsrijUtV+sc9a5t7P0pj/UPWSy3VHlKRahxkVBAmA8WGAlOmWCjwwZ6YU88qKQs1bX7jg1F8DhZ970sbQdG1keS1zP3+nXZfokhy
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230031)(36860700004)(82310400014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Feb 2024 19:39:42.9235
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a7b79aae-fffd-4bc0-4d82-08dc395e2d57
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE36.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4073

From: Ankit Agrawal <ankita@nvidia.com>

The NVIDIA Grace Hopper GPUs have device memory that is supposed to be
used as a regular RAM. It is accessible through CPU-GPU chip-to-chip
cache coherent interconnect and is present in the system physical
address space. The device memory is split into two regions - termed
as usemem and resmem - in the system physical address space,
with each region mapped and exposed to the VM as a separate fake
device BAR [1].

Owing to a hardware defect for Multi-Instance GPU (MIG) feature [2],
there is a requirement - as a workaround - for the resmem BAR to
display uncached memory characteristics. Based on [3], on system with
FWB enabled such as Grace Hopper, the requisite properties
(uncached, unaligned access) can be achieved through a VM mapping (S1)
of NORMAL_NC and host mapping (S2) of MT_S2_FWB_NORMAL_NC.

KVM currently maps the MMIO region in S2 as MT_S2_FWB_DEVICE_nGnRE by
default. The fake device BARs thus displays DEVICE_nGnRE behavior in the
VM.

The following table summarizes the behavior for the various S1 and S2
mapping combinations for systems with FWB enabled [3].
S1           |  S2           | Result
NORMAL_NC    |  NORMAL_NC    | NORMAL_NC
NORMAL_NC    |  DEVICE_nGnRE | DEVICE_nGnRE

Recently a change was added that modifies this default behavior and
make KVM map MMIO as MT_S2_FWB_NORMAL_NC when a VMA flag
VM_ALLOW_ANY_UNCACHED is set [4]. Setting S2 as MT_S2_FWB_NORMAL_NC
provides the desired behavior (uncached, unaligned access) for resmem.

To use VM_ALLOW_ANY_UNCACHED flag, the platform must guarantee that
no action taken on the MMIO mapping can trigger an uncontained
failure. The Grace Hopper satisfies this requirement. So set
the VM_ALLOW_ANY_UNCACHED flag in the VMA.

Applied over next-20240227.
base-commit: 22ba90670a51

Link: https://lore.kernel.org/all/20240220115055.23546-4-ankita@nvidia.com/ [1]
Link: https://www.nvidia.com/en-in/technologies/multi-instance-gpu/ [2]
Link: https://developer.arm.com/documentation/ddi0487/latest/ section D8.5.5 [3]
Link: https://lore.kernel.org/all/20240224150546.368-1-ankita@nvidia.com/ [4]

Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Vikram Sethi <vsethi@nvidia.com>
Cc: Zhi Wang <zhiw@nvidia.com>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/vfio/pci/nvgrace-gpu/main.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
index 25814006352d..a7fd018aa548 100644
--- a/drivers/vfio/pci/nvgrace-gpu/main.c
+++ b/drivers/vfio/pci/nvgrace-gpu/main.c
@@ -160,8 +160,17 @@ static int nvgrace_gpu_mmap(struct vfio_device *core_vdev,
 	 * The carved out region of the device memory needs the NORMAL_NC
 	 * property. Communicate as such to the hypervisor.
 	 */
-	if (index == RESMEM_REGION_INDEX)
+	if (index == RESMEM_REGION_INDEX) {
+		/*
+		 * The nvgrace-gpu module has no issues with uncontained
+		 * failures on NORMAL_NC accesses. VM_ALLOW_ANY_UNCACHED is
+		 * set to communicate to the KVM to S2 map as NORMAL_NC.
+		 * This opens up guest usage of NORMAL_NC for this mapping.
+		 */
+		vm_flags_set(vma, VM_ALLOW_ANY_UNCACHED);
+
 		vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
+	}
 
 	/*
 	 * Perform a PFN map to the memory and back the device BAR by the
-- 
2.34.1


