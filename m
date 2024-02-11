Return-Path: <kvm+bounces-8518-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8319F850AB9
	for <lists+kvm@lfdr.de>; Sun, 11 Feb 2024 18:49:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A6FD61C2161D
	for <lists+kvm@lfdr.de>; Sun, 11 Feb 2024 17:49:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC1015D474;
	Sun, 11 Feb 2024 17:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="CQbruZeQ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2085.outbound.protection.outlook.com [40.107.93.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B3BE5B685;
	Sun, 11 Feb 2024 17:48:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707673693; cv=fail; b=TNKvk5ZZx53+71P9/hjmbtS4OTiGpTwEqOj7psYsjWGYGfF2gXWf5D1ZWfY4r6V3i8Pk7Rn7RO2Fd7qCxUqoL0aLy1JmT7iq3mmxdShvEs0JJVmIRAHsdN+Oy9jN4ILRXsDBzzLkkRfCuYaoFCVRyw5XM4McU5VjWo65IneVrKA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707673693; c=relaxed/simple;
	bh=kNi0reNB01DofnLcUiiuclfoxarZoKtmniePTqy56u0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MY0DuD6NvV5a9TeDl3l7h/nG+HfD6Lbil7qrGXtxiBbl6Iw7EZSTFTH1kK9AUcD/BKqzSB6N9VzAiPEzBSyqdct+KuA/yPSlsQOO4zhGCwKpGFiio0by9tbQgOwF3gv/5aOtofVhu9P3jOv4N83OWqqcu4uhTvJevNAAi1PvGGM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=CQbruZeQ; arc=fail smtp.client-ip=40.107.93.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EYRphY9UwgFTedg7L2G7QVasqDihPQvqPRVUskY1s5nWREut41+RGOdHb+PvriW5wwp0g4Me5S4FjBuNxpZGA43ZzkZynazkSQ83Lcl6i9uu5UtB0/VPXuRjTaS9+T2zqfqL45B5fW4y/PwlN2rIqeLMSwJ4sVRfdtjAsHqh7gNkHPfOsEUTkDWwteuZZ3ylk1kcO8hHN6hA1sFh97NtG9w3/CsiJgbEMEE7MV+SfS1bGynDJW4HgLvTSBQzd7dFHI4R5kvb+hsRXu/3bPjO6pu9eeqlaYJQIsXRofJe7os81BhpP37d7zLWYHKDjehedNYk9DBv7qzfgLIAxoLJeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wh4MZCC2T9D1grz8V/GzArHYhJ98qxcO/FoJgoYQOSY=;
 b=WBlq66OfMJRlCFiTMnw6Y1yXwNvVHsZCnb/HplOeZn60X6uKdppg5Nb8dXjhTSZL7s5WOWpbRKImzJEI1x9gLEYZAmABWDDfB5L/03aUvrpokBLTkOywU7xh8lqYnZYWuDIbM0sScEKjluBr35NcoRE+7LWDXNUV4jbSafRZIxn02hS9uunT8KEniqGuTDJg9xi1yGYgvYj2BduTZfLecSCNJJZ+sJW+FQxQF8jqymgCQ12kLL+igilNil3VU8hQQTnCqcGUr0l+BifaTFf0uUNzZNxF1DtouiVcdvgzjHt58XIfH+7M7Ymvl8NLQw4dJKSoRhtKaQXt5boS6KhkiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wh4MZCC2T9D1grz8V/GzArHYhJ98qxcO/FoJgoYQOSY=;
 b=CQbruZeQXqtaHiq2B62VBbuJgjMLgk2Uy56v3ziIDkkIdqUMRtzV9+rJCFwUlE1zpMX3+c5lpBim39cMS0BLIAqAR1IzOw2oZh2Qvvxd/QQqp8UScwDQhnjT0KfOghV6YHa4qdQvsKuGXv9PYnw2ts7cXw01L79GE8dD7BY9Tt9PJJM3GMGYKVtIVvtDvAC/mcLWzkTl5NxVXUsLkeKZvkjAqXMGgonQFvldEnicnQ6DSnyowJQ5G+k20B3tiyYOZMnZJPGJfc+IRutFitJl7KKqIgZoOIAp/bUHcglqMC9Gee1aUa1OLjp07LWev6LWQu+Vln9T2A3ZeQUsXXahUA==
Received: from DS7PR03CA0056.namprd03.prod.outlook.com (2603:10b6:5:3b5::31)
 by MW6PR12MB7087.namprd12.prod.outlook.com (2603:10b6:303:238::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.23; Sun, 11 Feb
 2024 17:48:08 +0000
Received: from DS3PEPF000099D3.namprd04.prod.outlook.com
 (2603:10b6:5:3b5:cafe::d9) by DS7PR03CA0056.outlook.office365.com
 (2603:10b6:5:3b5::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.35 via Frontend
 Transport; Sun, 11 Feb 2024 17:48:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 DS3PEPF000099D3.mail.protection.outlook.com (10.167.17.4) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7249.19 via Frontend Transport; Sun, 11 Feb 2024 17:48:08 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Sun, 11 Feb
 2024 09:48:04 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.12; Sun, 11 Feb 2024 09:48:03 -0800
Received: from sgarnayak-dt.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12 via Frontend
 Transport; Sun, 11 Feb 2024 09:47:53 -0800
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
Subject: [PATCH v7 4/4] vfio: convey kvm that the vfio-pci device is wc safe
Date: Sun, 11 Feb 2024 23:17:05 +0530
Message-ID: <20240211174705.31992-5-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF000099D3:EE_|MW6PR12MB7087:EE_
X-MS-Office365-Filtering-Correlation-Id: 2d7fcd35-0deb-4edd-9f6a-08dc2b299b7f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	6sTQt6Nmm7FkBbUtT2MaOXv9VsAcZ/rB9MlRAC2Ld+MijCgoE6SP6t7XLtTIdSYsSkKWO2TFCzzOlITjfkO4L/IOnXrILncFq5BVDvYq3CVZQ/ptiKVZHvv9b1j6GBnJivwPGmA8RbkY+QTGYIznCpf9J+pOXNpyteiVWNOkHZ7UGZBSj+Hspg+vEJ3GLStd9zk4j8Mir8C0CMfZqxvcVjzBAyvUiL5EC83N3MrJN745Wh3LQaoN2IBirde92a3SVmFfF+iJVJ16j3RKwZUBMEoQ3ULitjpQ01WgBOpJmm9fewPZYz6iMO5/GlKBo8wpPO0qvvWvQV/YgxELRcejlCn7JJfyPiX4jzSrFIkV47p65hGeL+XubX0akTMMofs/ifsjUOVhpC7OAIQedG3x4VhK6QohFT1/4UbTScf9QmzIhKnT2c6Lvrz2cTu5/IPiIKLggRTkc7IgmkICg1RuvkTerKajNkJur1RYxIK40rZtbWf7iVXep3fpPfyHojJ5n9xxihavTyu10IIlPZWenXIUegziQfJ2D+yn4sX1hgOqCB2tsLUoccc4RrygijRZ7dTWHwBQ5rdpSiJ9k0gGSj4/sY6yb3n4oZsQJuSFIt1cO3mQ15ZIuPPcNeeo2tWJUhEP2xJqD2dSBXs08Z6tRA==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(376002)(346002)(136003)(396003)(39860400002)(230922051799003)(64100799003)(451199024)(82310400011)(186009)(1800799012)(40470700004)(36840700001)(46966006)(2906002)(2876002)(426003)(41300700001)(2616005)(336012)(1076003)(478600001)(26005)(7416002)(4326008)(7406005)(5660300002)(54906003)(8936002)(70586007)(8676002)(70206006)(83380400001)(36756003)(921011)(110136005)(86362001)(7696005)(6666004)(316002)(7636003)(356005)(82740400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2024 17:48:08.1003
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d7fcd35-0deb-4edd-9f6a-08dc2b299b7f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099D3.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB7087

From: Ankit Agrawal <ankita@nvidia.com>

The code to map the MMIO in S2 as NormalNC is enabled when conveyed
that the device is WC safe using a new flag VM_ALLOW_ANY_UNCACHED.

Make vfio-pci set the VM_ALLOW_ANY_UNCACHED flag.

This could be extended to other devices in the future once that
is deemed safe.

Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Jason Gunthorpe <jgg@nvidia.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 1cbc990d42e0..eba2146202f9 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1862,8 +1862,12 @@ int vfio_pci_core_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma
 	/*
 	 * See remap_pfn_range(), called from vfio_pci_fault() but we can't
 	 * change vm_flags within the fault handler.  Set them now.
+	 *
+	 * Set an additional flag VM_ALLOW_ANY_UNCACHED to convey kvm that
+	 * the device is wc safe.
 	 */
-	vm_flags_set(vma, VM_IO | VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP);
+	vm_flags_set(vma, VM_ALLOW_ANY_UNCACHED | VM_IO | VM_PFNMAP |
+			VM_DONTEXPAND | VM_DONTDUMP);
 	vma->vm_ops = &vfio_pci_mmap_ops;
 
 	return 0;
-- 
2.34.1


