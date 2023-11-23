Return-Path: <kvm+bounces-2338-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CDB407F5560
	for <lists+kvm@lfdr.de>; Thu, 23 Nov 2023 01:35:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 141C01C20B9D
	for <lists+kvm@lfdr.de>; Thu, 23 Nov 2023 00:35:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8911817FA;
	Thu, 23 Nov 2023 00:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="WTL5f8CR"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2072.outbound.protection.outlook.com [40.107.237.72])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A0EC10E;
	Wed, 22 Nov 2023 16:35:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NLp7Cz5ZDbBVe+exxUeRznxzGDG3R5qqHQ4+8tCzgA94noZLy8kA56i5nji6TBf2LJtchLWSfqV2NDVIck74jcp6jt9k3cHsAdcLAZmHY8ZJ9axDKseQlg0APL09BSjswVrK26zjsCPMv+JIQeEEQWKR3e1/pLDWUcF3Xri8rjOvxMdap+PAH/eT07N5J7G5/Wml4Iz41HkDUISto/QC5/dNmB1akDUTabd0pdxBUo00QMmvJpxrRuyl6+IHmE+RWZS3h+ZyPjQvNg6oHOhhXup7YdrJ0xwFEg5PVJPitHDHpIciYxdhnTauM2dLOt18miL6VchoHELF5+9brIbrZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=23Pup1BZOXr14VgsOTv5ghhA2i92yDAHGFFn5oXh4Ak=;
 b=gzttpUV2/G8EcnvwTr4z5GcIkEQbaFBWLa0tjWOopIz5+ElCOLzUI2pwz3ouDH7PsEYp3yFXjE8UrbT0G7T1if8n8StYfVri/YAkCAeJCsiHHdpGU+RszYS3575Y5dHj6WU1Yfhz5+Lq91VlNQYDE7gXMnjc6cI8tWMUNjb7q5FltkAmdM/b4mZ2qyW34LpTzICY2muvysDESqXO3gtHU0Lzg9ewaWRQBQ59b/YKRaJRdT3N8C3VdABxDqWku0Colm69GgDQWgFy28LOWiZ/8Xt6OUp3CKqj4JEqPv7FMuqyRnPy+mQpjH2Z9v3pRDKjlhzsqwuUbAQweQUjCYO7rA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kvack.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=23Pup1BZOXr14VgsOTv5ghhA2i92yDAHGFFn5oXh4Ak=;
 b=WTL5f8CR1IKZ4gxcXO8XEtbNJfMzEmrwXP4lI9iAPfU2mW0NZZ3RP6UUvaa4sKJO2UlRZKP8urgJx+bEt5mt84dEVWUVmzOf1IEQPze3emb8sO1nueNYu3TTVPqsB4+qV6ioHfn1ayW/17f8Q3jTQ2DTt4MWwIavPPjmIU6cEYCX4JyP/tLLDAG+tN+UKomoX7bEFwd88H47IxvCLGIPIPr2JZhsYPqZ//jqFuIU86LgkFxFXsmgob2DXtd498POutaj1EnKmNK4qnLo2qimtR0J48bNOvoS0WoeKXiVwpSzB6jfwZggeeZqVo3N4uy3X+Qo9RBdjwnX6BnCKyLocg==
Received: from DM6PR02CA0107.namprd02.prod.outlook.com (2603:10b6:5:1f4::48)
 by CYXPR12MB9425.namprd12.prod.outlook.com (2603:10b6:930:dc::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.18; Thu, 23 Nov
 2023 00:35:39 +0000
Received: from DS3PEPF000099D5.namprd04.prod.outlook.com
 (2603:10b6:5:1f4:cafe::4c) by DM6PR02CA0107.outlook.office365.com
 (2603:10b6:5:1f4::48) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.19 via Frontend
 Transport; Thu, 23 Nov 2023 00:35:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS3PEPF000099D5.mail.protection.outlook.com (10.167.17.6) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7025.12 via Frontend Transport; Thu, 23 Nov 2023 00:35:39 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 22 Nov
 2023 16:35:24 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 22 Nov
 2023 16:35:23 -0800
Received: from sgarnayak-dt.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41 via Frontend
 Transport; Wed, 22 Nov 2023 16:35:15 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <jgg@nvidia.com>, <alex.williamson@redhat.com>,
	<naoya.horiguchi@nec.com>, <akpm@linux-foundation.org>,
	<tony.luck@intel.com>, <bp@alien8.de>, <linmiaohe@huawei.com>,
	<rafael@kernel.org>, <lenb@kernel.org>, <james.morse@arm.com>,
	<shiju.jose@huawei.com>, <bhelgaas@google.com>, <pabeni@redhat.com>,
	<yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
	<kevin.tian@intel.com>
CC: <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
	<apopple@nvidia.com>, <anuaggarwal@nvidia.com>, <jhubbard@nvidia.com>,
	<danw@nvidia.com>, <mochs@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-mm@kvack.org>, <linux-edac@vger.kernel.org>,
	<linux-acpi@vger.kernel.org>
Subject: [PATCH v2 0/4] mm: Implement ECC handling for pfn with no struct page
Date: Thu, 23 Nov 2023 06:05:08 +0530
Message-ID: <20231123003513.24292-1-ankita@nvidia.com>
X-Mailer: git-send-email 2.17.1
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
X-MS-TrafficTypeDiagnostic: DS3PEPF000099D5:EE_|CYXPR12MB9425:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f79c1bd-d6e5-40fd-b01e-08dbebbc1e22
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	hficySGJ2VGgmAhYpJp+uhyYJCOrTqdq6K6EMSUqRTb/3tYF8fJ69XYvM7KHUbzaiHGC1RpakFvJhCoFeDekxKU6UT/SlEe+RaGO4MBxRCh9X08S3Fy14ElgWrNhN/imUGFMzPsbWhjcqNhYhXJFmsRTbm0X3xexs7GEqb3Spa4owEBHwH7efFxcTLTj+hgmZ8UB2MaLqanLWYdk045pkr4WChiICV35WEvRu8vBNNyydY2wa2pt3envhOITOvCMWEpyJwSHdaksHgb2+ZoJJ5QAwVESylsX1DbaLh4C76+Ivg9ncvgMCy8hVTTwgA6Rm4AVT1qRlgIrf4ZTeONepPEnUxone2BKV139qFWCDOxOKW+OJwettD6HwKsEeeR9J7aM3JSgwN5sG3o6lTNtGe0XdCrf4UwkC/7uuvEDgovPR6Zuksk5JQLsA7lgJZzvqy/crrooUPiOlPQaQ5MZsruy4ohWMS4JATe4xe345lasEWixTnyXm/BRVWzXYa9FoVIoEJMr5VjsEogpYwsoTlyIq4ucHLiCOAbQZqUOUBySOLzfZXMPRwGhv7MrHbtgsEeL7AEPtSup7IY6IBwa6XVY/fNliZYa1hnvWX9ejRFaXYhk9sAl0wQ7ILxR2BJ4uuEfdJoEoUApywMJLd6DZjP4OeMUwawzQPwts/n/aco0xHFABhCBJqGMFonAioozBID1v3mKEOrbWny8sH0P644woEDd3pUHtR4eMdvveOW96YgDifVkbWcLmh3xMj59u9+CqhvaPV63m6+F1G4CKv6YXl3bgrlHIWFBFnD80vFCwbFiUjCc11imGQfU95fE3QYbz0Uba6RkGDoOLTZDfQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(346002)(136003)(396003)(376002)(230922051799003)(451199024)(1800799012)(64100799003)(186009)(82310400011)(36840700001)(46966006)(40470700004)(40460700003)(70586007)(110136005)(70206006)(54906003)(316002)(6666004)(36860700001)(82740400003)(426003)(36756003)(356005)(966005)(336012)(1076003)(47076005)(7636003)(83380400001)(921008)(478600001)(86362001)(2616005)(26005)(7696005)(5660300002)(7416002)(2876002)(40480700001)(2906002)(41300700001)(8676002)(8936002)(4326008);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2023 00:35:39.3463
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f79c1bd-d6e5-40fd-b01e-08dbebbc1e22
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099D5.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR12MB9425

From: Ankit Agrawal <ankita@nvidia.com>

The kernel MM currently handles ECC errors / poison only on memory page
backed by struct page. As part of [1], the nvgrace-gpu-vfio-pci module
maps the device memory to user VA (Qemu) using remap_pfn_range without
being added to the kernel. These pages are not backed by struct page.

Implement a new ECC handling for memory without struct pages. Kernel MM
expose registration APIs to allow modules that are managing the device
to register its memory region and a callback function. MM then tracks
such regions using interval tree.

The mechanism is largely similar to that of ECC on pfn with struct pages.
If there is an ECC error on a pfn, MM uses the registered memory failure
callback function to notify the module of the faulty PFN, so that the
module may take any required action. The pfn is then unmapped in Stage-2.
When the VM tries to access the page, it gets trapped in KVM, which calls
the vm ops fault function. If the module fault function returns
VM_FAULT_HWPOISON, KVM sends a BUS_MCEERR_AR to the usermode (Qemu) mapped
to the poisoned page.

Lastly, nvgrace-gpu-vfio-pci module make use of the new mechanism to get
poison handling support on the device memory.

Patch generated over v6.7-rc2 and with [1] applied. [1] is currently under
review.

[1] https://lore.kernel.org/all/20231114081611.30550-1-ankita@nvidia.com/

Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---

Link for v1: https://lore.kernel.org/all/20230920140210.12663-1-ankita@nvidia.com/

v1 -> v2
- Change poisoned page tracking from bitmap to hashtable.
- Addressed miscellaneous comments in v1.

Ankit Agrawal (4):
  mm: handle poisoning of pfn without struct pages
  mm: Add poison error check in fixup_user_fault() for mapped pfn
  mm: Change ghes code to allow poison of non-struct pfn
  vfio/nvgpu: register device memory for poison handling

 drivers/acpi/apei/ghes.c            |  12 +--
 drivers/vfio/pci/nvgrace-gpu/main.c | 123 ++++++++++++++++++++++-
 drivers/vfio/vfio_main.c            |   3 +-
 include/linux/memory-failure.h      |  22 +++++
 include/linux/mm.h                  |   1 +
 include/ras/ras_event.h             |   1 +
 mm/Kconfig                          |   1 +
 mm/gup.c                            |   2 +-
 mm/memory-failure.c                 | 146 +++++++++++++++++++++++-----
 virt/kvm/kvm_main.c                 |   6 ++
 10 files changed, 278 insertions(+), 39 deletions(-)
 create mode 100644 include/linux/memory-failure.h

-- 
2.17.1


