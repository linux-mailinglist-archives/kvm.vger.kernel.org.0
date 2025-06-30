Return-Path: <kvm+bounces-51117-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D2352AEEA44
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 00:30:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4D0313E1B2B
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 22:30:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 070012EB5A8;
	Mon, 30 Jun 2025 22:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="joyR/3iE"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2060.outbound.protection.outlook.com [40.107.243.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43AB92EA75C;
	Mon, 30 Jun 2025 22:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751322529; cv=fail; b=OU24C4dbpoE1EUZfyr4IryOwISQFdcYo7G2g+0tFZ8oa2fN67O08RkzbI6pss0dxdaaulAsH37PodsnjF7LWbFEOShZgEG6rlVQslx1S3N/eMXLZlTBxu/TP2ueOzBm2W0c3I0PHMmA70FbpzJNmx1ut+1fwttnge16z5dXYgbk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751322529; c=relaxed/simple;
	bh=t8ZRLT4dAOJoi9qYvcz1aLUiTR1o0uH4yxQ5NuejWNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=VuLoR6nWBIk4fvq4abvXot4JJ7QkUCPQzMaf1Ykww3bOaDcU/VEG91olZW7c0Omv+3BtJscycB7o3hVWXZV6vOmW5CccenvsbB/4d/Nx5hzJFdswXnfa99wzgcUIOOprXRTPum+IAZatKCf60ChbpRj4RJwnCl1CBE/zHNjcaUc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=joyR/3iE; arc=fail smtp.client-ip=40.107.243.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ijgkP/lKNXZs7THLwL892KX2viEfPN2I6y41Hz+c9kOeVi3FluQCPoJPNG3//Jw1wz1ZbHDbaRHqYq2yNN2R4ExotbF8mGtCRlfDVzIJzIvKKRgtUxR9YNyDrtzIlaXZv0lu1YQogf2J5ne3opGbtRVv2y+CNsx/FRe7Ql2VUEszTc8v3fRf7Zv9XSphZ5mxPBoiKFZ1qM17edtoDjydGobKrBRP9QJOhvlo4SFNnodVB+0BtyINZQzqk3QupQNBpv0c8g9bVLgFyb06jEMp06HiUJ502tiU99O7U91pOE+YCXdBynVNZwzV6QxVp4sJyRzsfYFE+cY1ScQ+qzkF5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bShY+QBOEsWJJnJ5ZfAAWfxse45J8OkKk4hh6OQaaUo=;
 b=WeTV9J1lWLd3+7gjEZTVJcHuKSevVHLEytAD1ssU29NV9EG4DpMlersgxukfvXGtH1SSpWA/DJ3Tj+gGGmM4j4yDpZ2jJ74Wg3EN3lCqXZic2iTOOBs2BzEe9qM9pgGsYMU1jxSdcb/yDWlTR13cg7XrqXkmEMxYYD8cVSm7yeFKJ2k06jCa8dKg7vWk5dRNOPzcF4OZ+wof2Amho4r7ePrPIn+fX85bicdSlFUmVFcaKl/ecI799gfXkAEPTPCpwrS/XYiu2MtWPnl3YZvBaLbVY35EgN+owJ0MO3cv5LAsmgIVFDYY7buAJgywlE03Qujxinslkr18CWxoWZiJiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bShY+QBOEsWJJnJ5ZfAAWfxse45J8OkKk4hh6OQaaUo=;
 b=joyR/3iEW61IxxATI2+cA4HjhXqv+7NPwFfk/NOqg+joESBozcUxfCTFWAT/VfprCJsXVHYPYbf4daYEc5ZFWPsWY46lW9usQeh+FmojqE7PU99FI8cpRs7glSHlT+5ga9NRtUdRvfHV6DqelU5bhDU+slSDN/vg4i7Md8zKzUNgvD9yLGFUdJ3uV1UzW1+vEV5l+uPbvcqH9v64tpiNE4jNMre3R84lbai9h2CtAWdNvQWMovkr0Y1sNBZ0oWn7x5LCD4GMXqcf9pO+Gc6KbMhnMHOMfkb2/ACzSS9o/qkjSZu5QM0tHUfx6gE/IBJOlxm7j9koWLwL6GlHE8RloA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by MN6PR12MB8566.namprd12.prod.outlook.com (2603:10b6:208:47c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.25; Mon, 30 Jun
 2025 22:28:44 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8880.030; Mon, 30 Jun 2025
 22:28:44 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-pci@vger.kernel.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	galshalom@nvidia.com,
	Joerg Roedel <jroedel@suse.de>,
	Kevin Tian <kevin.tian@intel.com>,
	kvm@vger.kernel.org,
	maorg@nvidia.com,
	patches@lists.linux.dev,
	tdave@nvidia.com,
	Tony Zhu <tony.zhu@intel.com>
Subject: [PATCH 01/11] PCI: Move REQ_ACS_FLAGS into pci_regs.h as PCI_ACS_ISOLATED
Date: Mon, 30 Jun 2025 19:28:31 -0300
Message-ID: <1-v1-74184c5043c6+195-pcie_switch_groups_jgg@nvidia.com>
In-Reply-To: <0-v1-74184c5043c6+195-pcie_switch_groups_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR17CA0015.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::28) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|MN6PR12MB8566:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ffe79e5-19e8-46dd-4a2d-08ddb82578c1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Ae8FrVY68pD/8ZL0lLv9tB2u7l821AxbDWkSZVoYNN1Q/xuEey+LrcIOznS3?=
 =?us-ascii?Q?npuXI4+NZc8abMtA4/YZTD3wOJb/4EgbsKcHjt7ZqKxy2mYU6d+rhX+YKkZn?=
 =?us-ascii?Q?LAxuqI45jOwDvXc4icHn0X7Z7By4H9A1p1rGg6Z+UTDLBZ3Daejb0aK0aM1e?=
 =?us-ascii?Q?RUrt90Kr7XJZx+BdGxnriVWGz3Kj8P+MeMyQ080rlvc/xv85e+TZn66X5HKY?=
 =?us-ascii?Q?HZ0YS+zWrlumXqoTlW23Yzav/me3LkdULG9/tA7OOo69WPuw4LD2yTluiAdc?=
 =?us-ascii?Q?ruogGJxlwDFrZgrvzAyRGTiiAIC0X7u3/5Xx0txBpejEeWZFm/JKwK+aUmOi?=
 =?us-ascii?Q?FwCJEzwd28BqG3xu/I4ObDZjsYzKdhu5onP9ZWUx/k7JCMr2DuZEWllc9Njh?=
 =?us-ascii?Q?w4FVTzrGd/QHtI8jd5gr5igxU3UFieHoDwrUVL59S3KkR7laZswxoDwoDOUX?=
 =?us-ascii?Q?UKYS7zJ2izM4STrbNX4REQKuc/rwbY2fOcVwM2jjJhkauPEGjrNXSWQD1SOG?=
 =?us-ascii?Q?yxvSjVkmwU6uoCfF3JxvFuPSygfgKen3PRoaS52DPeaO+i7sIuc3DmfTG+UA?=
 =?us-ascii?Q?jxTjOTfvwUKS1dBB3x8ZZWFtmcV+2GI+Bw/Gp5cHUdb02KpAARPLdasZD6lQ?=
 =?us-ascii?Q?XJTcZF2kPXCQ0x3An6okT5y90rlUV2A5spr3Yu3KeeNCYeBsV8wWbC0aNulj?=
 =?us-ascii?Q?klAzYW+/g88R3sQKa/fv3WXpx4zNeX+gIDNLoPID06aj/DHbh2jHGbR99zMk?=
 =?us-ascii?Q?bat5NhH/c0BQjV/Ugr4WH3hWK1Tfwitfrg2nM+rm31U7HdfmrpR3/L1r5Ltb?=
 =?us-ascii?Q?X5PTU4yeUWx+8rWyIhevE6rY//la7k9hYE5hEkqGZAQW8vfWdVselFlRUqkS?=
 =?us-ascii?Q?r3wdIpzv9s7+sd2ZvlBzI4iFprXMOEcgl9/F+9VMTqhiHQgx8GjNhcrhQibq?=
 =?us-ascii?Q?/gddBXMr2oO8MJjfrmVk36l9gcuRpnRJ+iL4XR7tE6diEAJt+oocYbxq6wSM?=
 =?us-ascii?Q?ZGW7Gu2cyqpTeEwkCz5ee2IYEtuNQHTAXjk982j+blk/v5DCBN8/vDvMc6KM?=
 =?us-ascii?Q?VlvCvMbesLGMpFZ7aBNlCK/r8u5DYihMR93RYAkstwWBbQX2E2DHyyskO1Ln?=
 =?us-ascii?Q?FaMHsJVlfNC52BVKkBNPREYGUY7TTtIy4YWpINqtVleyFnZELyUjCsQdh9JP?=
 =?us-ascii?Q?e9zJG/2IZIJ9hemP+dUvFS1Ll4R6gf6Vo/OV7jLWnswXZAZ2Q8QH6TdGiE3W?=
 =?us-ascii?Q?n/uoJrpSSUfiVmC2941m/pUimuan+QYpzvgM41i8tI/qm1CS73AD7mjFLF5P?=
 =?us-ascii?Q?Q8ahNTjWdiZrZ6Bf4OMOEFWvfynDNViOHGIilWAhCnhc6bBMhWEtBxF4EhE4?=
 =?us-ascii?Q?746BGVVug/xNCxPni1+CTW0kWt2YV+LxS0oj+L5OqM6SvVruhX/GMn+IEzyD?=
 =?us-ascii?Q?QqaQHhA0iqk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?k0U7BTZIyiRqLnCnMXyWhCSV5wqYhcZP6N24nRiytRSHKUFoJiYsg0Cqtkdq?=
 =?us-ascii?Q?KzA4qgHa5seexRBACxB9MIjWMxd2C/K6Ehcy5GPVPUhVlOuvJPOEF0mUomT5?=
 =?us-ascii?Q?0YTaZKtdkj+2EjxjdKbD111sscfGK5X5gPjgjq0kPKzDIxIowHb8hs2AorjZ?=
 =?us-ascii?Q?T8xCKdy1D7lHKgCY3xTLnbAjyqhKYkX6LUjANEOsO7yIvB1yRxt0Z0vUKxj6?=
 =?us-ascii?Q?JxhKlxONx+vzeVO7Rx75Wp9sOn7X1k5ZxpF38fo9AiGUzpeC7tJfM/SI6sHC?=
 =?us-ascii?Q?6lj+vQT8AsS/FppIaGcDk+0rqGBTY5E3FaGj/LRP1+6KRsFhzGdwGIIH6OZQ?=
 =?us-ascii?Q?qCtc3iCP1obR61SavEuYzfg3TkMfiFUmc68Gx/ZArowS/Vgr5AU2/UMBCnVn?=
 =?us-ascii?Q?255VIihw9wjH4XqjG6elLnF1YWdSyhipwAHYpEWy217tyuT4zfh6w53mBXM4?=
 =?us-ascii?Q?8HEfzZ8jU811kuW7pUhzvJFNowPaNKfWkA6r0LC53FsfMDgpKM9RWnIwinoS?=
 =?us-ascii?Q?R2qHnNujwixSVj9UjwPGGgGhIVSRVVMl3e3Z1l195R8nOAKWNB+65l1e5Gx6?=
 =?us-ascii?Q?1qeNHFGBjPpHbv5zYx5HY0i6XGLWoAQwWnt7QDP72fqzckZzZJ5L7dC6Mb78?=
 =?us-ascii?Q?NUapijX2B19yuJcIh8snvWLgpS1YXiheuDqCcyGA/CJl2Ci7xGlVurIhCxyW?=
 =?us-ascii?Q?6I4+Nuu8lBIhDiLuYoWJ5hIPEe5AjAcEwlzxVSSDyDk3YkrmUFGezYhCVSxm?=
 =?us-ascii?Q?nIh3Q2nWr6mvQnEevhhXASZVvwGDQH8TWWeQLGg2hzOb1yNey5ivwLXAbpp2?=
 =?us-ascii?Q?3V49pBkK6+f12LgygLOrSBXiYARAzFP/S44J0wC24cBTJz6E2uH84bMtV6xm?=
 =?us-ascii?Q?THFUibtgL0nJNauQRWnWKPw0muI3djQ6kbRidc2MeiSNhFAlTxFeVhBLPVfs?=
 =?us-ascii?Q?sQoDsCeujeBT9iJzjW2Ro+TVwEulaBr/m1kQnPIwwXcqC/MhV7tJKI7jCVvB?=
 =?us-ascii?Q?9XGT3A1cCg9kFhFH8yjDodwCi2L6//IteOCVwoW9zbA02bNRbSp2uYmISnY4?=
 =?us-ascii?Q?mtl8WvgBnaB40QSzc2tgtcOXDXZ/zASJZ0fjte9itg7jPjsCEDYpyXFjR9Cx?=
 =?us-ascii?Q?ps5CXv2LoIEAhOWZxUb/zW/Qxr6VYvx0qZ0HbklH3vnfCm5BfVnskdQ8rGeb?=
 =?us-ascii?Q?tpjfCSpv0uO3J+3LaTy+dWrLrtuI+ObePLw8Ld2kX+vOXMpIID56O+hqcGnZ?=
 =?us-ascii?Q?n1PegTFxa42LhgBXGBam1wgir7G/XkVIxt6mUJqAzwRlpPEyPSo8NHSbzRfa?=
 =?us-ascii?Q?b6+5q3Y6+hVKg+UJEwI/iVVv3oN9yKIhdkqI3Gw3s7HziQgA2/9ZMxEiHpZw?=
 =?us-ascii?Q?TQDBgu3IX2Ag+OxHb6jM2zXLw4ayRboN4NKF0JHq3ZwVvEjKLNo5mVnzsFC5?=
 =?us-ascii?Q?Sks8EtSavspYODcH0ka/y6sADPKU9PFYtJpMMIJInM432muhNPGLpvGStwGt?=
 =?us-ascii?Q?neusX5oo6Lhwr0+w0FChUTrF4rWu7XenKw+o43seaD+go+2qzp9HI2MTmuKe?=
 =?us-ascii?Q?/E+NMT/MABiw1OoewLzaZzY9AeI8O3CIL+5whw9x?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ffe79e5-19e8-46dd-4a2d-08ddb82578c1
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2025 22:28:44.1100
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8JKl2qhDRxRQA+X/ZHSllJrTZnI4VAuCtrnjK8qqfUqwR0IVfbWeD8uXkxlhO2nq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR12MB8566

The next patch wants to use this constant, share it.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommu.c         | 16 +++-------------
 include/uapi/linux/pci_regs.h | 10 ++++++++++
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index a4b606c591da66..d265de874b14b6 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -1408,16 +1408,6 @@ EXPORT_SYMBOL_GPL(iommu_group_id);
 static struct iommu_group *get_pci_alias_group(struct pci_dev *pdev,
 					       unsigned long *devfns);
 
-/*
- * To consider a PCI device isolated, we require ACS to support Source
- * Validation, Request Redirection, Completer Redirection, and Upstream
- * Forwarding.  This effectively means that devices cannot spoof their
- * requester ID, requests and completions cannot be redirected, and all
- * transactions are forwarded upstream, even as it passes through a
- * bridge where the target device is downstream.
- */
-#define REQ_ACS_FLAGS   (PCI_ACS_SV | PCI_ACS_RR | PCI_ACS_CR | PCI_ACS_UF)
-
 /*
  * For multifunction devices which are not isolated from each other, find
  * all the other non-isolated functions and look for existing groups.  For
@@ -1430,13 +1420,13 @@ static struct iommu_group *get_pci_function_alias_group(struct pci_dev *pdev,
 	struct pci_dev *tmp = NULL;
 	struct iommu_group *group;
 
-	if (!pdev->multifunction || pci_acs_enabled(pdev, REQ_ACS_FLAGS))
+	if (!pdev->multifunction || pci_acs_enabled(pdev, PCI_ACS_ISOLATED))
 		return NULL;
 
 	for_each_pci_dev(tmp) {
 		if (tmp == pdev || tmp->bus != pdev->bus ||
 		    PCI_SLOT(tmp->devfn) != PCI_SLOT(pdev->devfn) ||
-		    pci_acs_enabled(tmp, REQ_ACS_FLAGS))
+		    pci_acs_enabled(tmp, PCI_ACS_ISOLATED))
 			continue;
 
 		group = get_pci_alias_group(tmp, devfns);
@@ -1580,7 +1570,7 @@ struct iommu_group *pci_device_group(struct device *dev)
 		if (!bus->self)
 			continue;
 
-		if (pci_acs_path_enabled(bus->self, NULL, REQ_ACS_FLAGS))
+		if (pci_acs_path_enabled(bus->self, NULL, PCI_ACS_ISOLATED))
 			break;
 
 		pdev = bus->self;
diff --git a/include/uapi/linux/pci_regs.h b/include/uapi/linux/pci_regs.h
index a3a3e942dedffc..6edffd31cd8e2c 100644
--- a/include/uapi/linux/pci_regs.h
+++ b/include/uapi/linux/pci_regs.h
@@ -1008,6 +1008,16 @@
 #define PCI_ACS_CTRL		0x06	/* ACS Control Register */
 #define PCI_ACS_EGRESS_CTL_V	0x08	/* ACS Egress Control Vector */
 
+/*
+ * To consider a PCI device isolated, we require ACS to support Source
+ * Validation, Request Redirection, Completer Redirection, and Upstream
+ * Forwarding.  This effectively means that devices cannot spoof their
+ * requester ID, requests and completions cannot be redirected, and all
+ * transactions are forwarded upstream, even as it passes through a
+ * bridge where the target device is downstream.
+ */
+#define PCI_ACS_ISOLATED (PCI_ACS_SV | PCI_ACS_RR | PCI_ACS_CR | PCI_ACS_UF)
+
 /* SATA capability */
 #define PCI_SATA_REGS		4	/* SATA REGs specifier */
 #define  PCI_SATA_REGS_MASK	0xF	/* location - BAR#/inline */
-- 
2.43.0


