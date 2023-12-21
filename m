Return-Path: <kvm+bounces-5091-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3630D81BB2E
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 16:44:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E3598286D5B
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 15:44:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F4C159936;
	Thu, 21 Dec 2023 15:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="dvBnDAZD"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2071.outbound.protection.outlook.com [40.107.223.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6EA0745CD;
	Thu, 21 Dec 2023 15:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gxvgwQ150iyoxc4y2M/YPtdlzQ0aqb7AuBHjRpETDejzrUmWu6mchnvVdRDoGFyNK+2c0iXokgkAVLPTTTazCfluTfBXcJ1basceiFkOtQGQ/3PcJLueMw5CrWRDFJerLi5SLBoRCDGpws5JjhP0Z1WAhQPXa0CAkvmHruztp1jahnJcvQPMEFJ7xSRvnUYjqA+KZZo6UoIPYnyYeJUaOUJWFN20y4fpj8SIIuZnE6jSUUun+tZphGVtZGl6Rjz93pk/2D3CZP6vQyKmfkSzHFbt9fGqWFZlTpQ9xe1KHZ1/j8b+a+6xDE7a7y9D2+6f+VbyJJrl6M6AYzywg12KJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A2y4ICxI7rCvs7zkEJV8fbXDdlk8MaBO0x9/XhapvEk=;
 b=nfpvjW9BXP02lfBEm5U1/pUs7TFNqcoHyBJCXUK3sofNFwl2Qu8RHdYzi+0tRPhRU8ZjsprwaxuxW1FXTVHtEy8qGN5rpyiXeoQKacm539tEQqxpoxEnKQLxLMGCElYLW1p1DnN6NeZi3zV/1xkQLfIdcDPGdGynRKGOIVAznssa+aF9JImcrYpQ/AUA9jZU1SH5Y/odF9fNUa8lKCLts6OfhY0zAjnxuQ7aDCpK10H+P6cm+YPHbM+fX5sAnxCd0TwjVTK3fhdlnWcTv8O0tBVKOQFBEvyzHsMxom7pG+Hof9QDkfg3Kn8p6Cvyr/E7tBwbYELYxGDzYd59wBMHUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A2y4ICxI7rCvs7zkEJV8fbXDdlk8MaBO0x9/XhapvEk=;
 b=dvBnDAZDbfaOy0SFfizJ+CGtdD44oPuiax4Uk/B5hzSCKTG9uvYVUgxhEoKH3mW09w3aSpB890IAlrFc4aqPdYOXA4ezposkVslEmDKr2H8Uj2lq+da5086rQde6OL0/6aC3oxkAtLVEG8G1GZRTqUaZkeIW6y5MTfxGb6AYA0JntfgsTw5F+vLnhkEEvBoUzlNuNvFdK4s/d6XxngAEMibi9df7wM2zUwCAu1tJFRSOi+VVTaMvN+7Hk21DIsGhFT3e5uiDKSvb0WKFbJBChSgYUcwxp2jFohCNM+G6WZhjf0T/Lf7kDmTCWgFItBRXkKI0VIjiq1a5JMNkNFQQWw==
Received: from DM6PR03CA0038.namprd03.prod.outlook.com (2603:10b6:5:100::15)
 by PH8PR12MB7255.namprd12.prod.outlook.com (2603:10b6:510:224::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.20; Thu, 21 Dec
 2023 15:41:09 +0000
Received: from CY4PEPF0000E9D6.namprd05.prod.outlook.com
 (2603:10b6:5:100:cafe::db) by DM6PR03CA0038.outlook.office365.com
 (2603:10b6:5:100::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.20 via Frontend
 Transport; Thu, 21 Dec 2023 15:41:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000E9D6.mail.protection.outlook.com (10.167.241.80) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7113.14 via Frontend Transport; Thu, 21 Dec 2023 15:41:08 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Thu, 21 Dec
 2023 07:40:51 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Thu, 21 Dec
 2023 07:40:50 -0800
Received: from sgarnayak-dt.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41 via Frontend
 Transport; Thu, 21 Dec 2023 07:40:42 -0800
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
Subject: [PATCH v5 4/4] vfio: convey kvm that the vfio-pci device is wc safe
Date: Thu, 21 Dec 2023 21:10:02 +0530
Message-ID: <20231221154002.32622-5-ankita@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20231221154002.32622-1-ankita@nvidia.com>
References: <20231221154002.32622-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D6:EE_|PH8PR12MB7255:EE_
X-MS-Office365-Filtering-Correlation-Id: 453895de-1891-4115-a72c-08dc023b4084
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	CTZgWefPMY73vO3gv05CbkVLWHZuPIY1w1h7cJVnF/57L5xnoBQzSpLoXn55tg/bdkoUBa6/jpMsqw8AcadCUJTHWx/jmEBl9bk7TVQhZy0NatJFwK6Xc26KTGh16OEWqJIYcvcgsOJPVBGq7ajnoi9XIGpofwD0tzwQ9BIgKk8KdO2/1+DoCPbAGzzeiXxlLdAdp22lpBGdIMhfP+VJW+z6otHxJ03ZQBavq1l/s+8bbktqbD+WtmW/RGDrCIjP6Nepz2hshFoUF1IjfF7xNo/Z0szSlfqbv/6jtewUwQo3i8IApmzgDtX6djCAQGfAJejhwQqFO3/BXOi2sImjjb0bTlUxviSqqyVh8L0TlqY9NDV5cBUrL74agkK1vvwwGypBELLns5gqbKkJXG7tc2pr9UEdCSiVU9oKZ2HEFV9XFi5c4UWoBXImTEpgSRT8f25/CK+FQYv9GMyHTem/SdtI3HOoXzfLHt5WVh0LVOX0ERYDj4+b8UyRBwQxKYaSPDxkmNUlwvzWDOSzU7a9+4buoarm2VboK9wK89oD4FbVdptEWytJDC4IMReLiQqvRo4fYNDGhqszRSOX1gxsHSJg80ZI1HiKW62uvv9q+81MTB85tXhmLf74g/ypzSU/42ZrjiFcqeeKeNBWpntEh7Oh7+Okb0S3bTMXxxqYxVUYuGrx1DYhs+mTAsV49biY4hilc15aRngmGE6wOuC4O2WoCbGHzQgF6tdcAvv49KlrbDOhJsYnkepWTUU7dL1yOB6VdlHMCD/nr0NoCZ/E2E67+cVsHNo1SwbzUOH7LvLZ3E+36OJDtgz+i2hQzZHQ
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(376002)(396003)(346002)(136003)(39860400002)(230922051799003)(186009)(64100799003)(451199024)(82310400011)(1800799012)(40470700004)(46966006)(36840700001)(921008)(86362001)(40480700001)(82740400003)(356005)(7636003)(40460700003)(36756003)(36860700001)(47076005)(83380400001)(1076003)(2616005)(26005)(336012)(426003)(7696005)(8676002)(110136005)(54906003)(478600001)(316002)(6666004)(70586007)(70206006)(8936002)(2906002)(2876002)(7416002)(5660300002)(4326008)(41300700001)(83996005)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Dec 2023 15:41:08.7591
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 453895de-1891-4115-a72c-08dc023b4084
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000E9D6.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7255

From: Ankit Agrawal <ankita@nvidia.com>

The code to map the MMIO in S2 as NormalNC is enabled when conveyed
that the device is WC safe using a new flag VM_VFIO_ALLOW_WC.

Make vfio-pci set the VM_VFIO_ALLOW_WC flag.

This could be extended to other devices in the future once that
is deemed safe.

Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Jason Gunthorpe <jgg@nvidia.com>
Tested-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 1929103ee59a..c5ebca74b8a8 100644
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


