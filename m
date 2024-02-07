Return-Path: <kvm+bounces-8283-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0EB7484D32D
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 21:49:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AB15228BCB8
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 20:49:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B111128366;
	Wed,  7 Feb 2024 20:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="FUi7Kqd3"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2062.outbound.protection.outlook.com [40.107.223.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D9F91EA91;
	Wed,  7 Feb 2024 20:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707338891; cv=fail; b=OKZZv9VqVuLLKDgwv8sX4vOlmSacmrGAfodRmhs5pZhYmmk8BnIbiM1rlL6NR31wzlC4WQJi4ZY/DzuEWx73TnQ9yGlajT4eZ2GdhJVQLX8cl98OVn9F2d59lIzECYcl5lWkUnS6EuLaMb8tWYGQSh3nKscvxZ24tf2zo59weiY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707338891; c=relaxed/simple;
	bh=p/9BW8Vxnvb92g/IjyB8UOZVvD6V/JVJYu3HwXbV9e4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WUU3hlEjEtThNIbvXIpHo0dnliGSUY8XfWPixc4i5/+mVZpIKj2HIemQ9MFALGszlP/RsJd7O2j73pBAhl0tZwfIkPV6mryfDGsrF7ONSVJR49AF7h/UAidC3z+/DOJ7y5XsNFY8FkCHwttvqM6Qs57Dc8ECZMDqxJ3fCliJb0M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=FUi7Kqd3; arc=fail smtp.client-ip=40.107.223.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AJqc6ACS8wnsRqgC5y6rYRt7UEjGiyQrAXnaiS9NxS5Wmim5Y59gtZ6pTx1+Mx4KQyQFeXe8JndQu8fH/J7iZt+0j2mWFnlYC/bEGFw1vOdPjFQpnzmDVrrMP2vGKmgL9gK3ZqZ4W3xugwHTi/40FMmSMQ9mOHPcLs5Xq086KaF8Mg75OJT84LLcg2PEHbmYlIR+oB9MBj3VTs8w5HBvcLEdXFr3PnI82KUXeI/Ph6IerPaBRQIemS2/WAt1H5RG9q1nAhkpY+fuL3MYASeIji2T1yD3S0crfiJTgFnJxTtZCZA7H8kZdNqpQYD9zHWzhofwNiPrp9aUQzm06lqf8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pqQFFkNqWF5Job5Q0SDOOd/FxuHJVp3sxKAEjZUkkRs=;
 b=dqJk/C3eAgLgkRFoeUY14oh5i8SclT6bm/MHsTmwBKBikjkcQ9Y0DUWg+doTZpejLPWNzdVsN1I/V3h3bUHfaVo6CMQ2+Q2qEywTyRW/sPn5QxMOzQ65DyqSPtI1EdOhm2ZnvExsHboegMcCJOM9nyZeA5b04/Iw9+v10mrDtaGJFuUdWT3nF3B0/ZiRV47LAn0ONMEMujGsi6SIsmh/NNWQAKNuhg6hv+KCoiTQwK2Wxn+3rUckGZWCKsPyZcPlvXFXwutNnlLSQslLF5kDOXFsM3IpDE8kNa6rf6xiPv2SeQ6IVuNAD5A91LiKGlsJufpzTG0XJCEMT2kpkrV5cQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kvack.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pqQFFkNqWF5Job5Q0SDOOd/FxuHJVp3sxKAEjZUkkRs=;
 b=FUi7Kqd3X0s6wbNmkt87MU9WR0XqoVx+G/joxdm24h0f/yZ/QlWRnj+ITIn2t2lEMsfqMEIcS3jr+WgPLKJtLvQV89czu0S3OXS44UVViJ1ifHwU3N4p1gzGt9at/C6qez8NODo3IoUsBeuTM8+dZ8Cvzc9PIdwPStnQ9igqYfgd+rAXoifD3dD9xMYwmRDIYBOB9nNzURNUceb4CyZpM9LLGguYJri21mTIf0wKMQT9ZDr4rk/s4TojFCBaGHQPMm44y0e+u+dhtxri6u1vH1OctXyag3S85vM0jKqgfUYW8RoWVUCmORdvyxQYOq83a49NguCU3zXOZ7eZCbWA5w==
Received: from MN2PR22CA0012.namprd22.prod.outlook.com (2603:10b6:208:238::17)
 by DS0PR12MB7851.namprd12.prod.outlook.com (2603:10b6:8:14a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.17; Wed, 7 Feb
 2024 20:48:07 +0000
Received: from BL6PEPF0001AB59.namprd02.prod.outlook.com
 (2603:10b6:208:238:cafe::5) by MN2PR22CA0012.outlook.office365.com
 (2603:10b6:208:238::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.38 via Frontend
 Transport; Wed, 7 Feb 2024 20:48:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL6PEPF0001AB59.mail.protection.outlook.com (10.167.241.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7249.19 via Frontend Transport; Wed, 7 Feb 2024 20:48:06 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 7 Feb 2024
 12:47:49 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 7 Feb 2024
 12:47:49 -0800
Received: from sgarnayak-dt.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12 via Frontend
 Transport; Wed, 7 Feb 2024 12:47:38 -0800
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
Subject: [PATCH v6 4/4] vfio: convey kvm that the vfio-pci device is wc safe
Date: Thu, 8 Feb 2024 02:16:52 +0530
Message-ID: <20240207204652.22954-5-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB59:EE_|DS0PR12MB7851:EE_
X-MS-Office365-Filtering-Correlation-Id: fa88e2fd-4575-45db-e55f-08dc281e164c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	uWhH2LZU962uRd42//LULo0F2zaUHFQQKkIJEUwvJJYl+T6ihNDJQF3OYwBc79OqY1i8DCEF353H3rDxXZ5akqjXcsvEO6CQan9FCv1POe0HuVISBQdTLHVKE9IhHivz/ROigMfDXp/P2V1Wah5XWChvrJB5e1M1hugIGXQlBOgBErK7u8GmRCJvKvsGop797ewyAivaZBlNmQJ9wTyzoq+lCokl/q37jY4sW/gPDpE0TMpapYdoWsE3Morwt4mTGF97EgQqUa38pP1dADtctACyek6Ea5IvPpBvpOQbVDg7NWTnAovsoAVu9FVhuot7zsx+hnN7B/6dAJqM+00IQ/lR2fuL68wBiv6RrSHjOrDiinXBpduFevCPADygQtYqCt/Boj86dlNXhkyCwVLbZStaZuymFR69emiTNa3XT9+cdV+om2XS5Nv327galAhRfZGRwY1thVzn9fLWWExpkQCXKQvdTKfk6gDlmWMFUzfvzE/3joQp8bohiVah18p2jqqtwQ5XffCXNj0tLk8NXcX2eQxVUqv4ST/ZAPrSYS2n18vZLtdGaEKbGoI7wYQmaWYTyS8j6dBqXTIPp4tep8kYjiVs/2uF+tuDHrt4rtAkEuk1+Qj8yHh9vsVLbHFOuI7Uv6ddITpRMq42cOynFQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(136003)(376002)(39860400002)(396003)(346002)(230922051799003)(82310400011)(186009)(1800799012)(451199024)(64100799003)(36840700001)(46966006)(40470700004)(6666004)(426003)(7636003)(2616005)(921011)(336012)(478600001)(26005)(1076003)(5660300002)(82740400003)(7416002)(356005)(8936002)(8676002)(4326008)(41300700001)(2906002)(86362001)(36756003)(83380400001)(2876002)(70586007)(110136005)(7696005)(316002)(70206006)(54906003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2024 20:48:06.6160
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fa88e2fd-4575-45db-e55f-08dc281e164c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB59.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7851

From: Ankit Agrawal <ankita@nvidia.com>

The code to map the MMIO in S2 as NormalNC is enabled when conveyed
that the device is WC safe using a new flag VM_VFIO_ALLOW_WC.

Make vfio-pci set the VM_VFIO_ALLOW_WC flag.

This could be extended to other devices in the future once that
is deemed safe.

Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Jason Gunthorpe <jgg@nvidia.com>
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
2.34.1


