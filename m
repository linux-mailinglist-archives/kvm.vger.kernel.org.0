Return-Path: <kvm+bounces-4700-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B0F4C816968
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 10:10:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 293361F23189
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 09:10:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDECE134D5;
	Mon, 18 Dec 2023 09:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="gs4vFhTA"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2078.outbound.protection.outlook.com [40.107.95.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6775A11CBD;
	Mon, 18 Dec 2023 09:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MN/P/0336/kDzC5OhncxeCdivouBz0O12PisQmWLhFjMotA0fmM6qG+ezr9WTNBc3TSq5qizgJ0QHTapRfRW41XWjPVoEMQdKwABd4K2cRM+InC39AyxxEKdKTa2U02w10ywUY5F5lZRcHF2Y8xWln3dqtYhTpR0cVdaky06U3YvsAcIzm004dnRgDTUlyFWuN66VE8pITnuH3aZu6Ovv+IX2p5nSU0tN5eZverv5UT43XAgou/kddvFx8R0tRwg3YgRLzUgjETG41tnkbdjcjnXkvtVtlYnlf05kI5jNawiVCQ2mahkgeBEIAm40j7KrGo//qQ4PqN1mDU8LhdFbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bIgOQYSUcDqbQrALPAOUM80vmPREds8DjkfHG1eIAJU=;
 b=h9CK5Hn3me0MhfXcE8dMGWkMxJjCMdjjBPXCxAaCWnuWPPVHjJ4Azjy5VQJYlH6UK259ZKcfYF0XKM8+1Jq4JUGscSxAI2ElNP1Tzl4uypK5aXFXVTtVkhUGU6p7timNB8Lg62xLgJc/NocXRRIQpwn0H7D/pceZh+Td6aBbohGSFgBjzpWkyyVGo1N2DQWKVT8ka1NGWv0CCZSF6xiwhrrTZbPyrXVOR8AITesMUDH9gP5WOpMnTIpfqFR5SXSvFCDZYSE+5vdv5HKifBDXCUDYqaD9JZpbrslL3jyaL8+phOAaM3h0RyoC0dOINF/oiQMn1iCg4NyFOgbl5L4BKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bIgOQYSUcDqbQrALPAOUM80vmPREds8DjkfHG1eIAJU=;
 b=gs4vFhTAouIbhD6YvNojDBEN5C8QhMQtPF58OJP9V4TzSDl90YkPPNSGFV9bQU0u/4CJ2V8N4gE9BzsmVq7+6rvkEqat7H0mzfxk/c0eE9RqHcJfZK7gyJDITfhCW+9k36XSAHcne6urLl+0uytFm3cbI76R/z5UK9xjJeosKtrTsz6f5ptVOF4jkIg6679UCncs1UuI4c4GkWQ3RCGOIt9yYwUtmSjWrwmXAqhIu4ZkNqzRfXM2+iKZF/UttOVPZ7tNMyOTDXmzwzLUw1fgzLlRkhy6jWhoMiiGfTBKnKtCTkjEj+ojiMxvfPIkyb0PXJQXEwwKJuSRv/WFdf6DDg==
Received: from SA0PR11CA0101.namprd11.prod.outlook.com (2603:10b6:806:d1::16)
 by BL1PR12MB5303.namprd12.prod.outlook.com (2603:10b6:208:317::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.38; Mon, 18 Dec
 2023 09:08:15 +0000
Received: from SN1PEPF0002BA4F.namprd03.prod.outlook.com
 (2603:10b6:806:d1:cafe::d4) by SA0PR11CA0101.outlook.office365.com
 (2603:10b6:806:d1::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.38 via Frontend
 Transport; Mon, 18 Dec 2023 09:08:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SN1PEPF0002BA4F.mail.protection.outlook.com (10.167.242.72) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7113.14 via Frontend Transport; Mon, 18 Dec 2023 09:08:14 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 18 Dec
 2023 01:08:01 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 18 Dec
 2023 01:08:00 -0800
Received: from sgarnayak-dt.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41 via Frontend
 Transport; Mon, 18 Dec 2023 01:07:52 -0800
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
Subject: [PATCH v4 3/3] vfio: convey kvm that the vfio-pci device is wc safe
Date: Mon, 18 Dec 2023 14:37:19 +0530
Message-ID: <20231218090719.22250-4-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002BA4F:EE_|BL1PR12MB5303:EE_
X-MS-Office365-Filtering-Correlation-Id: a427e793-120b-45ce-226a-08dbffa8de3b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	3lOi9508GZA6Cl4x71zeBQ/Zdg93uI09PNS8og8qUjNgPuk0ss8x8YnWg/8ezTa0BTvYzDDNa7zoMUQfyn8dSBPztxJ0CnBO5xUgJRfMOQ6r7kvHXWyxFiVPzGpzv+/iQp/SHci4yQxxW/uJ176//+fYi7idCpn1hA5azxcflo7dqrygZvqFgTgLECw9l+1mc7YtL9tSU8/K/u1DpGiq9JYNvJT2iItUCXMG4j2FQEMTWVpMo6MhYTCie5F7myCI8GAfFPPE3Xy9bTwrEEqD5wETUifPNjs6HkPQ5tTQa9NLdTcp35LPjOwBOT+6IqFtb3rnmUNN1AoXYAFgxdA6uqS+ZmkjxJwAgtnpKUnXu2bOeNND7etgKnacf9dn7eXgLWZhIzxBpz5BYWVa9syMwH07AhgKhpB3bfwO9HTbEccnnDLQMAD7r5pdLlTc53/woWsLm6OJeazoF91fWuLzW7Jj5iG0ppmVK9jes+m6OpmqXD7OT0e0E+jSpnWdXCKvuhd4Bj4JRx05stzGrpz3Lzt9jzisbrLsoCdlUroRXvjwykuxpTsLKt8DP5vfmWR2IGheExGeUMfDmmx7GnN+NOmJKLhcu/tn85XhaCzx6kbsKG5lzHMIx+BFmhplHJDGdyB4xrYX9uLCjCt71r7U3iTqWl+vygOpH3FCBgisqJAHYmc6tL4jS4UF/nLIhyrKdZWsB0Nnq1NyzeL0EjpDxQPxWH3GN2o+GmWrRg22pVRhDY0cU9QWDMHdZKOlfqoy0HiLR/sM65UU8qCjtGHZzXijx5vbgRt68ZeN+6cWzCBMQgM9V1NqPrQBNEz0uwIL
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(136003)(376002)(346002)(39860400002)(396003)(230922051799003)(451199024)(186009)(1800799012)(64100799003)(82310400011)(46966006)(40470700004)(36840700001)(40460700003)(1076003)(26005)(336012)(2616005)(426003)(7696005)(6666004)(36860700001)(83380400001)(47076005)(5660300002)(7416002)(2876002)(2906002)(41300700001)(478600001)(316002)(54906003)(8676002)(8936002)(4326008)(70206006)(70586007)(110136005)(356005)(82740400003)(36756003)(86362001)(7636003)(921008)(40480700001)(2101003)(83996005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2023 09:08:14.9656
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a427e793-120b-45ce-226a-08dbffa8de3b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002BA4F.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5303

From: Ankit Agrawal <ankita@nvidia.com>

The code to map the MMIO in S2 as NormalNC is enabled when conveyed
that the device is WC safe using a new flag VM_VFIO_ALLOW_WC.

Make vfio-pci set the VM_VFIO_ALLOW_WC flag.

Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Jason Gunthorpe <jgg@nvidia.com>
Tested-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

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
-- 
2.17.1


