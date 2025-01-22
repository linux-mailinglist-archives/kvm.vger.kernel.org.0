Return-Path: <kvm+bounces-36292-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 44C6BA19924
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 20:23:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EAE9C1887773
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 19:23:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE670215F51;
	Wed, 22 Jan 2025 19:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="K/wG/NMu"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2050.outbound.protection.outlook.com [40.107.244.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F09F121519C;
	Wed, 22 Jan 2025 19:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737573769; cv=fail; b=D3uP0AkRHsQblpt3aaOgsULMC6Vkf/MtfTmZ24MuIW5LtUIs4UMLn017rODOBvFJkdNj+X+/jwRzr1k8K2kHEfeTHpcJCwLT1IhvC9THHZkZV7ROfOnsF8Sonp66T7VEuxsxeFNZDqK+hKChpHsbHlCmBPWiXwvIH+XH+syzG1M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737573769; c=relaxed/simple;
	bh=bgvXRF4EDZ73nVEaPOZEejuiyuOXbVMWEceolpTwIa4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=cp9mxhRd28gv/uz/MrfJ+67lt/YVeX0X2CTXNumjkOUH5WuLhquNPE13pzCUGbA5t2qU8sFdKWaIjbMvYI+B4RXLK1QhkT6bNnILch+M7hwcY499sRjEvJnAFGmvqcrcPhOZmmrgzNsWC5EQc2H2FFjvy8ovMJcPCF5vTuE/BQY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=K/wG/NMu; arc=fail smtp.client-ip=40.107.244.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RU6/Dxtk7+9CTcH8fzXHaX6/+uFB7UHse/KBSK+2XSiALS3IIe2WZmi2ylCBk3pqOZ1EO9ewqPKTbYnD4w3HFSzSmzgvtjaiUG7hkfJLr8+T0g6tWShi1Nv/+ZDvGd6II4uHbA02l53mVRWFYOrfufx1+OTVNyCteX6OBmHHN5f9YPe8eWdPgz67M9uPrQ+jObEX/VHlumQHoczl2+c0+kDhhE1lETK1uIbEQvjeF5riwHopyLDLRHeFwe5ciCHTYjl7/D+ESDdVgkPTeFuJb1gXc6+/F+El/m1K3mwb9+SmMsPKM1lN3Bp2pLnnnyEhTnhJw/HUMatvYw8kPyA06w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tbAbOLe4RssSU4/wqtFL41gdLFIh/i4/uk5HCzZEFPQ=;
 b=e4p3dPiIED4mQRao+BpvMuBv3Jyrr4S2H7YRP2Hv6FkyhR9E/vyLF4Kn9RGnOFqz3OKagCsxyhp3khWJD9d1snbgNeRLp+up4oVvOb71+D6JcI023qf5ZyZrTV7hHVHpanCrSrpcZ9GM/5JUsrppZR+F1E0QvqIvLyI+v8cjwngyK1z6R/3LngasxwAYBsJ52DbTsMFimwMOQ8kxkUzQPwqMbZ0TOtTb0ofNvVuC0/3LH1T1di7041+51GAl4VEp440EQKBFgY1WThuNr7rUXN/Mw0g0iNI/Y/zNIZLH6qhA8F9fy+3A5OyoTwR79xWW/DUitnkkgQqoJKd+MvUquA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tbAbOLe4RssSU4/wqtFL41gdLFIh/i4/uk5HCzZEFPQ=;
 b=K/wG/NMu0bgxfvulNkTf5JWXyeiYmJ0/fYcDJjGduZKLZm/Yu7SI70gScgLrZCyfRZk7ac8p4B6Iu+8gxRrwU2MhG09KFyetQyWYS53t07ZT6lIUv8P9UiXdUKMhFImM6x0yxTyDvG3FeQmfGSeaeH/aUyrhNGGLtsjlcCgWup06I+kEBZgZeGRu9L0lNN7TsxGdmpi2B7LzF5ZuUgWIV7vtX0TW5NU/+sZVKMH/v2cjkcGPYC3HcjqOdIwqB7aYO22O7EKUWjE3MPBFhHEDZIp56WaEuy18Q4aMoXW5guYt13GFO60DHAFZghfBiHaF/LHgXB9NXofMS6tbkBfqNA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MW3PR12MB4524.namprd12.prod.outlook.com (2603:10b6:303:2d::12)
 by DM4PR12MB7648.namprd12.prod.outlook.com (2603:10b6:8:104::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.21; Wed, 22 Jan
 2025 19:22:43 +0000
Received: from MW3PR12MB4524.namprd12.prod.outlook.com
 ([fe80::b134:a3d5:5871:979e]) by MW3PR12MB4524.namprd12.prod.outlook.com
 ([fe80::b134:a3d5:5871:979e%4]) with mapi id 15.20.8377.009; Wed, 22 Jan 2025
 19:22:43 +0000
From: Nishanth Aravamudan <naravamudan@nvidia.com>
To:
Cc: Bjorn Helgaas <bhelgaas@google.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Raphael Norwitz <raphael.norwitz@nutanix.com>,
	Amey Narkhede <ameynarkhede03@gmail.com>,
	linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jason Gunthorpe <jgg@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>,
	kvm@vger.kernel.org
Subject: [PATCH v2] PCI: account for sysfs-disabled reset in pci_{slot,bus}_resettable()
Date: Wed, 22 Jan 2025 13:22:41 -0600
Message-Id: <20250122192241.32172-1-naravamudan@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250106215231.2104123-1-naravamudan@nvidia.com>
References: <20250106215231.2104123-1-naravamudan@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0058.namprd05.prod.outlook.com
 (2603:10b6:a03:33f::33) To MW3PR12MB4524.namprd12.prod.outlook.com
 (2603:10b6:303:2d::12)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW3PR12MB4524:EE_|DM4PR12MB7648:EE_
X-MS-Office365-Filtering-Correlation-Id: 46bbe2db-eddb-4f40-2efd-08dd3b1a24d3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Qhl2eSKIWbgbEbxM1ncO95OlsTPNfU+NyLpXn3k8disFsq4RWPcxf2sHFK/m?=
 =?us-ascii?Q?Ly5wwguyiN/bbpVKGihKpJjF02Mam3P1M6pDcsRBjKWEDDG6T/7NF5Rz9U8g?=
 =?us-ascii?Q?HL6YVGNW1hZuuryIoJ0jihnpsbn54vswVFb4Prj2wfva+Qi7m6MXhcMt6Knv?=
 =?us-ascii?Q?1HXbtcW5W+1m5DBzg7IERjIYoWYaWjONIITsWrj2rrBmaUwFqHC7aVD+z3kC?=
 =?us-ascii?Q?23sMdMA2HzqHTGADBwhRhUMmrIrjmLGY/tCHbpk/gGJ9krea64zWttR84qQ2?=
 =?us-ascii?Q?1wAqYLBMmg8/oLNv05L2tpZu87CdUg0+pl0CHfRh4aU/Ime5/J8p34l7gv0c?=
 =?us-ascii?Q?IQgYsZzp7twQMtyct0jO14flLmkTMTH4hmIWQ1jep7e78jASf6OF/AZYJFj5?=
 =?us-ascii?Q?KO/lDXuoQa348FOHhQOFlD1qEyMGHF2AuWQQhF7y7wkUeWKopaBDDQ+HN+hJ?=
 =?us-ascii?Q?JwI3Ffxg0rYFUQqr4/TSliS/WJDrwz1BdCzs+Cb5jx9v6ZDghLKPs3yxHvi5?=
 =?us-ascii?Q?p+3Qav8Metqa0NOvk4GY8PuHFTv2Z4L6quLmCVIvM4pNM45gARmSzJmJ2TTr?=
 =?us-ascii?Q?rh4FI35wK1FVgmqsRD9Fdivkdd+fOX0pXuwGiVEtToNU56SeyndlU4Fh6b9U?=
 =?us-ascii?Q?1UeJ3L34YN10d2OL2WVzKJJz9IlwoslI9V3uyXn4e57S2kV3DDplBGb6MUOO?=
 =?us-ascii?Q?S2balA9kVF/zyJ4YxhKI5cnptrLom8cvS73fEDomPyxk2ABOD9GO3mOBtojj?=
 =?us-ascii?Q?7LFG2gK5hNtb+V0qlT41XTX3q0vbSneUQZdDcqSTwlDfn3VbWcEKOU6jH2Hq?=
 =?us-ascii?Q?EMDLZs7yFEjN+M5QxfbYqgLk69ZA+oO/m3+DQ//pXtJ7uQW8FHapLs8JcHPH?=
 =?us-ascii?Q?feCjWplXB8xccV73Kv93iQNjEfNwzzCVoFQHJ6L/j6qa2kG93vsBuMk0PGQD?=
 =?us-ascii?Q?/cateheQVlGBCzjXLzRR2QVNeMv0JNqXa7hdxiMdR5aqvR4SaRQ1UJKWYl4O?=
 =?us-ascii?Q?6Fn2wSLUR5mueaILKxcR8nvg1Irb5tBHlKPbjkEarOMDsqQt/BVWAdNPjciU?=
 =?us-ascii?Q?R4VPHURmOL2gsLlEm7Fk6Fze5l2sSZOODPnT9usH5WaqEeaYnAi5nwF/9ts9?=
 =?us-ascii?Q?IqQ9Wc/vdwOyZpNdTqn1OMtlOcs8LRIa/6vwWbXiwx2ufa6ZkGhFSNE0paZv?=
 =?us-ascii?Q?ZUSOtVH7tnfeAJe+1GWpGa6zBzdIKGB1piNvuLE+eACS97UGrX3w1TPlTSjd?=
 =?us-ascii?Q?xZKx+iP82+WjnY1lkWpN3qORyvXk/ZsdkPtdBJ2T/y59L2aIOW9ItQMP+3et?=
 =?us-ascii?Q?gzbf5zLVOoSttOhBzLNg9h7p6e9Yf1orpYuiAEJMqphzvMGEAxjaldNCgLaZ?=
 =?us-ascii?Q?PBVR1hmhsfam7q5tUIIPNpim3uoY?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4524.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?LEuziOOt8mrgJUyJNkOC/MlndZYJvIXC7zDlK79vnIFwqORlBKQpRlLmEMe6?=
 =?us-ascii?Q?cJaqBg02scxtU0QsxVV4WJW4vlAXRwOsT74IK9rZ3B+3OukLaqLepB8l+YpE?=
 =?us-ascii?Q?u28Yr77pTyC0e6FCphafXKR0jum9XKH80vksM5mFoBzXXgIx6vdEur31L5Bc?=
 =?us-ascii?Q?89aTto9Hdq+vH/X0DdSzujHkROu8AVA3rl5UXaOKuDV6wuF6MjmP7ES0S36l?=
 =?us-ascii?Q?pvQ9vWO/St7Px2qHMjAqpNBrit5PePHoZIR5nD6eaQJxGLm9HfqnGaRUekCs?=
 =?us-ascii?Q?lnOiSUVazzodt7hRfhevuMJhtq8LmI5JB2VL1YUU+Fble75ohePJbNznObhg?=
 =?us-ascii?Q?nyK32R+hdAWZza6HmINjB8zbOeRTNwb36Hr2MaMrWo8N7m4i4dUtOSAKg+W5?=
 =?us-ascii?Q?ubUzvAYZ6EWYnRbu+ZWJmAKSCVs5GyvZgzWme9LuH0/7L4UA5FIkEH09qn4v?=
 =?us-ascii?Q?IfpDupKQU11tvpuXfV2kAqsaUg/74Cp+VT3isL7740/3B96vrwH3Qb+fpaZp?=
 =?us-ascii?Q?PqVZO7wdMYsQjcrJhdBqfVycnMdeCiKc9aA2ikYqCsYD38sYM6FqgmZK1nmy?=
 =?us-ascii?Q?S7bcu2d47FtPRzQ+WVSuyxD1xDVNaOnLhupRh6fPdhaoOxeO4Dv4O/JP/+un?=
 =?us-ascii?Q?Qwabj1mXA+n/4KmLbpWt+AaeFI5S8dtE1CZWXmq9aomRTL5EO2E12CNjEdQM?=
 =?us-ascii?Q?ukvB1elEz9juXYLVS8OSQW3icBKUOmPuh6X7YGMI8KFdfAWC52HOOykWBnBe?=
 =?us-ascii?Q?dlIBLXY8JavZFoLKt37NHVQlWRqN+Z98FA3FkB8lpSQetP6mkxJ0a+ZXoAwc?=
 =?us-ascii?Q?yDPFAAwVejcZNuGmdp99US7aLllwj3KY9RyFI+/f1ceyQyOv20YlMCKGszag?=
 =?us-ascii?Q?H7PialY2DGSg6YAw4IZJ7mR7QD7sy/7M5AMwE4MFuPw1JCE0rvSHT/dMJqHL?=
 =?us-ascii?Q?LBifiiocIJ+7er92zSU0kEqX4vvsC7iJ73wE6jdgfdMNl6dFSB/wPosDjq26?=
 =?us-ascii?Q?RX5/PKJl87QqYzem2q1iDaNIsZj2a7m47hxzjuWu+glL7oB0YEH/JnEFMsPv?=
 =?us-ascii?Q?J3b6msSXD+kDEhq/tnKFCCQ3Zp29u+710vij2+pdD/sLf3wy32+pjkFhYKvQ?=
 =?us-ascii?Q?O96ofS1pWlNIfxayuCQ6fhvnzntS0CcuXvpM9OifATzvqNRQQSpJ/Lsm/ad4?=
 =?us-ascii?Q?RgsqQx3swPJ9nHjCso4BfJjYVFKn8B66K1udc+jgCYQZd1Pvpctf6YV34dUF?=
 =?us-ascii?Q?Y3nj9hkF4A+opcwH5d9l4oxrssqoDtlgodna4YxxaSGZjARiEF+jS3C2/eKS?=
 =?us-ascii?Q?yJb9yc2gKj4jgGsRZUJdASaY2YFKbkwbXhJH3OPndccdcvMYDKMUOd6i9Lnr?=
 =?us-ascii?Q?G11q0YPrcrxlI7dBo72FO27vQKwoXGl8gGAINXPTkm9WNyZxAL+k2yRcGAdS?=
 =?us-ascii?Q?3dk+RTkH1vnOVbslONPayrPiI8ulP5r/btwMrqlxRiKxRcd7ZcYv+8TVEWj5?=
 =?us-ascii?Q?5uEvLnkAJh/DcAyDy1R8MXcUUaDoxgilBd2n1IwhWrhDRLQ0EinEQ7ZQi+v1?=
 =?us-ascii?Q?QPAZYnBFBi3cglAnxtjWl1KIYNykQGovyp3nOJgOTGkWl+65sV/eUpooMZNB?=
 =?us-ascii?Q?tA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46bbe2db-eddb-4f40-2efd-08dd3b1a24d3
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4524.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2025 19:22:43.1016
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: anmu3lADzJT9IJzoc6w22Q8XnUpON6h0TsY5uO1wIAbqYY/4t3kJddyS5ZFxLshgyGgDlq5mBwKlayMmUdyOFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7648

Both vfio_pci_ioctl_get_pci_hot_reset_info() and
vfio_pci_ioctl_pci_hot_reset() check if either the vdev's slot or bus is
not resettable by calling pci_probe_reset_{slot,bus}(). Those functions
in turn call pci_{slot,bus}_resettable() to see if the PCI device
supports reset.

However, commit d88f521da3ef ("PCI: Allow userspace to query and set
device reset mechanism") added support for userspace to disable reset of
specific PCI devices (by echo'ing "" into reset_method) and
pci_{slot,bus}_resettable() methods do not check pci_reset_supported()
to see if userspace has disabled reset. Therefore, if an administrator
disables PCI reset of a specific device, but then uses vfio-pci with
that device (e.g. with qemu), vfio-pci will happily end up issuing a
reset to that device.

Add an explicit check of pci_reset_supported() in both
pci_slot_resettable() and pci_bus_resettable() to ensure both the hot
reset status and hot reset execution are both bypassed if an
administrator disables it for a vfio-pci managed device.

Fixes: d88f521da3ef ("PCI: Allow userspace to query and set device reset mechanism")
Signed-off-by: Nishanth Aravamudan <naravamudan@nvidia.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Raphael Norwitz <raphael.norwitz@nutanix.com>
Cc: Amey Narkhede <ameynarkhede03@gmail.com>
Cc: linux-pci@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Yishai Hadas <yishaih@nvidia.com>
Cc: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Cc: Kevin Tian <kevin.tian@intel.com>
Cc: kvm@vger.kernel.org

---

Changes since v1:
 - fix capitalization and ()s
 - clarify same checks are done in reset path
---
 drivers/pci/pci.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 661f98c6c63a..809936e1c3b7 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -5536,6 +5536,8 @@ static bool pci_bus_resettable(struct pci_bus *bus)
 		return false;
 
 	list_for_each_entry(dev, &bus->devices, bus_list) {
+		if (!pci_reset_supported(dev))
+			return false;
 		if (dev->dev_flags & PCI_DEV_FLAGS_NO_BUS_RESET ||
 		    (dev->subordinate && !pci_bus_resettable(dev->subordinate)))
 			return false;
@@ -5612,6 +5614,8 @@ static bool pci_slot_resettable(struct pci_slot *slot)
 	list_for_each_entry(dev, &slot->bus->devices, bus_list) {
 		if (!dev->slot || dev->slot != slot)
 			continue;
+		if (!pci_reset_supported(dev))
+			return false;
 		if (dev->dev_flags & PCI_DEV_FLAGS_NO_BUS_RESET ||
 		    (dev->subordinate && !pci_bus_resettable(dev->subordinate)))
 			return false;
-- 
2.34.1


