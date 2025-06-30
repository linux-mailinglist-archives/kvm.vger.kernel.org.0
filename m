Return-Path: <kvm+bounces-51124-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DE9D9AEEA56
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 00:31:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 274F53E1CD1
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 22:31:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B4782EE5F7;
	Mon, 30 Jun 2025 22:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Ahj8w19Q"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2053.outbound.protection.outlook.com [40.107.243.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98F852E5404;
	Mon, 30 Jun 2025 22:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751322539; cv=fail; b=n0Uwzip4A8Ev/0Rt+ugm1VjMocU8iINVC7voSuMN84LPC9ufWIvgkyjk/MPUe0pTt5u4juefI88iXxgWEwAYb5OAQJMnotbwDmI38SGwjSaODeqS8hks8ZYl5nx8IreulhNtDbjEImcj/CUvfiKIXxUfLUbFg2kgwjfMshczBmE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751322539; c=relaxed/simple;
	bh=+Ef7bMk6oV4JmWwrsjqq1UOGBEoTz1eyKMc8UkBg4KY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=J4XFafoSP8fI2w7ODo8zGJy0qHvrFmgh1b6LWc8iGnveU8yG1uy8oIZPUTJ4X851dDpxGxAU1Tq4bb5GDmOnFUM6O9xrDrUAyKh5j+aFwEVAFgdyW4yC7ESEDuJimSqkEpnDILmSkXDIhuNaFZMZ3Asx2jxcsxAmm149YzRb7+c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Ahj8w19Q; arc=fail smtp.client-ip=40.107.243.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NKVh6aOOk8vBvItVVupDB6LA0KwfxBZUAUDARgPH3CAHwuVmAly9/uzkrtacbDkhG9n7M3DgIFZdpeexBPsACj7oQk9wDfAzyQEMbipiWjXQV7YKsxAcdRiIQqfxHmlBU5U9CXo+2o4+aArVRFGznBKUGQYWWoRtAiUSHE6E1rsifVW73EMgx//DX2bLcWbYk2HGlhIj0XFmex/u3db8CE44Tm8jO+5pF6PnnETNrNPDto4wh+/PIHv4U7fr0Wnr5s9IGVq8rFdpfNrC/qM6YrYd5uPqqA9gFWdZrbPmuQSRoeHXS6c5BmP45x0C61tviLPWL6Z/nETyJuGus37nsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KXAs9LpzfoMHU3sB47kLQF16oqtLo5puIjhfIvr+HGc=;
 b=FFYG1XwD/jrJ1j0wGWGPiR+WGSwD7J4Nu0jIs+QAPXoNFDWAYEBABJX5CjiuEQ6Yl7r/Y2i7UAbLKcEJt86SguYt/RKs2kVXdpKfGSYHtcsncN+5k2XK5XrriAQ0QkVkm2gRMLu7m9Rwre5Sy7jEBRUmKn2177eLT4rvU/wG19KrUOzspZ01d4FRiOtRXzL3q8rFYBckItP+s6DQE+21EAZoyngwCKfjs5OzljWGZhJ8oiDOwtZ7VFycwaRxCCsvxqMT8eAVcOz9TOXNt5GNYoRN2D3j6z2tXfLRwpw7ze30U4o6ZGzmqXhMWcW3kJFNLun7u8OMhDV8TV3E0vesTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KXAs9LpzfoMHU3sB47kLQF16oqtLo5puIjhfIvr+HGc=;
 b=Ahj8w19QwwtCT9/q3WzXxPbPC7FZs4rkA+ZrBWbVERDuFhtqlE/DL7L4LpfXl2s0oJIe8+cum0vNg4LkQZ+pvDUJqAp5VWjgRwlUjjMKo9yrIBrzlUWBKphdwIDzOHjj6oQAta1i+0I9uL//B5CR5aEpPeDrJkA4BonnPhnIK/1TI+nNY6/cM7kIahJxa9Htp8Xka58slik4rUXjeir25qG6dzJtGWfqhZSjI9YWvpRaR5OU3NqpNzZEJ2ZCkWojDIi9rbaByNlxynUcNzBZ7kvfPPzaaGWKtu+R3uxhSRSb3M2g9nDp2tjuc9ShSCpTm/x0gTJpYIxrmL0PZCD6Ew==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by MN6PR12MB8566.namprd12.prod.outlook.com (2603:10b6:208:47c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.25; Mon, 30 Jun
 2025 22:28:49 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8880.030; Mon, 30 Jun 2025
 22:28:49 +0000
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
Subject: [PATCH 06/11] iommu: Use pci_reachable_set() in pci_device_group()
Date: Mon, 30 Jun 2025 19:28:36 -0300
Message-ID: <6-v1-74184c5043c6+195-pcie_switch_groups_jgg@nvidia.com>
In-Reply-To: <0-v1-74184c5043c6+195-pcie_switch_groups_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR21CA0013.namprd21.prod.outlook.com
 (2603:10b6:a03:114::23) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|MN6PR12MB8566:EE_
X-MS-Office365-Filtering-Correlation-Id: 66d4cc9c-961b-4ab7-37dc-08ddb8257be3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?b1t6xdt10ddpPCiqzEPDb0w5cbjRNjk1HvLQQx0sfoHCLMfNE0iLzmXy1GVM?=
 =?us-ascii?Q?6+dtpZDaISB6OR+ZGsD8i/j7vBfEuB4t8jQ6WfqbLFmI6Nqr/DAmraFchkxV?=
 =?us-ascii?Q?BoYjljcqKPFuvQPzsUT0eUYUdBQvvnTQEkU9C0k0vNNnB2gi+H4onqvsV0+1?=
 =?us-ascii?Q?bduNZtH2RcbstucOboyMgPyEvkIluZk0LDojKVkJOE7mIJPBRPa7DZZ2vbK7?=
 =?us-ascii?Q?Jn7OQhe8UjwdTPgbZVLOOmNc3R65uMZF1Gstp/GJVCOE80h55T+IJvWPFCJw?=
 =?us-ascii?Q?OKChqOu3wWooevBOgtFJes8yEg+KDM6yst7BcMUXTG7MqRmn1Pbpz8WuVj5U?=
 =?us-ascii?Q?G3wiQLj5GmYY7HVl/83WmFvqYKz4A277oAR4cThKyydoiUkcHTLFyQQTivOx?=
 =?us-ascii?Q?uFQMD0lGpaXk9LQoOxO2onhMRN65HF1n1hKuwHSPFsIXQb5nwN3+oxOx9VsB?=
 =?us-ascii?Q?m/Zk7Z8LItHRWXz8GrC0pthVqzDchXoTPuK1KNn7ZniZ9n2dGST9aJGNojGw?=
 =?us-ascii?Q?ySl54pA3uVXaWmC2ixoPKbf4sMX3Nl9dJuy1he5pKCeK+OidneODcDRdNkYS?=
 =?us-ascii?Q?qQbRYWE9gS98yL1B/954oLOrO2NMqcxbM6gKbe5eAwfS3/bDKafkMxNS0uzM?=
 =?us-ascii?Q?E1LG8brVHF7IkeACens94xsyk6zHMxK6Comj5MAh2TEtdcDyxfjUXPtleagO?=
 =?us-ascii?Q?gvOVRoEwUCX9cojvFEMkdGLi96uxXEUh8lKB2uH1YeawtZ79GxCsOKGDkutJ?=
 =?us-ascii?Q?37/O7GyaIi2IWYtA5zKgCeCoPmUPo9GnaD77i+0N7/dTuqiOGfc6UbqPDfr5?=
 =?us-ascii?Q?7X8WUkHYEAMlvAWBPZjwgyf3ip89JFjG4LK9b1TlJCTMouBS/qvI1cZ/WZjL?=
 =?us-ascii?Q?s19BItJpFopX/GHaoEYKIValopSShDd1DqZxUk3UngucVLvrcJM1rf4Lvgbn?=
 =?us-ascii?Q?lMPGhxY7CSt59axwQiaNaeDkUDkAEii1Fj1SEr9GeEELVhMh7mLjviEekgbp?=
 =?us-ascii?Q?QryfcNuA5rqti08ROROanrkpwELEnnwY4FG9JgJPJ0kNLcpueoQbsAKvdz6b?=
 =?us-ascii?Q?JqP45uixe5gPebGreMyuKdFdlCKaYHFCoN0FDY6+LXfhdStZFefSfrEAvpJU?=
 =?us-ascii?Q?ZQX884JQx6xVIxbxJBJgNdPJiEpJvRxDHG+kH0DrB8r9HitqB24ITrilxQ7p?=
 =?us-ascii?Q?Gr5FkKy8eJY7bg7814cVMVrj9eb2MIdq1BuXHYo0BZhhmkrBmU2ujaT0YsnC?=
 =?us-ascii?Q?KqKs8HHP2gl0kgNk2zOq24RL8+eNIznk1RMSEz19AAkQmsLa02NTCnwSnj0i?=
 =?us-ascii?Q?iPIgIxgWZV34XwVafcvCt/SpzxWYCTwjzFhYMDww8ose8IkpcFjJX5KdozzM?=
 =?us-ascii?Q?yr1z87+z2amDfBlXTYA5VfXT2tF+IoPE2yLT5L7wA8pP1JRQfZh14tX+bgBU?=
 =?us-ascii?Q?M/JTh10MBlc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?FUN8octW+NohBIanxBlFu1z4QUIVG4p8FEcV3k9rLyVfZnDhbxkzKG6ioKdN?=
 =?us-ascii?Q?RGMze/I4yDjtz1srVLvrarJB90fUlVqgIs3pxuEnET57WeimK0bcWHgsFc+/?=
 =?us-ascii?Q?r+xMT/RlkswFyH7nh0pQvi8GM2OHjE0f3kge6plkQ4NjfMb6Jnc/R851g1MB?=
 =?us-ascii?Q?B99S0NlJONjA7H1fukaVI7QPwAzcHjLE3NiYNFjqZ2ltjLdS8E6FNoOW7NN0?=
 =?us-ascii?Q?0z+TYATjyeH3erC074esZ2YXZRcNNeYipNYaOfIAbv9xn6J81PU8JtSGLsqh?=
 =?us-ascii?Q?XHzyfU1zotgtKiA5u4zxJIcRG5+xN5kQG55iG7rZeFq5RiMliKkAFSRwvKY1?=
 =?us-ascii?Q?pYifn6MBYy8Hgjyg6cB/U+VDAazQx4dc7IajFQbtMEJpulJAKV8Ghprxt5QO?=
 =?us-ascii?Q?MPDpxHtvqVu6AN/fhLeHgVycZ5Wr9LVc5XtS2zJNlNRd2g2YXuCuex1a0qx/?=
 =?us-ascii?Q?PtzOZjTDuqMBHUSB/97nqMaQQC7Fs0/GnMPB58iA2SEJjMRUz5Epq+QmQGDD?=
 =?us-ascii?Q?rbJ0IWdZF4GM/DSkVmlUSofMAtxd1g7rcJ8irFnTu0S2fyjYFhNR5LIIuzAP?=
 =?us-ascii?Q?lliwPct2bc9ZSzuZHvOL0TCUqhATivw9PF4j8sQMGLv3Sm7x6Vcgnx5lpv+3?=
 =?us-ascii?Q?8Iyn3xgsN1b0lIRUAi0au0+EISqA5AWxOAUlfIfI4UUuvMm0m66o3narkvTw?=
 =?us-ascii?Q?R42MNvX9c3ZvZC/ZX0aZ7XRW34pIyG0JvTjVoRaDRC/lem0TUEq06cKSavnU?=
 =?us-ascii?Q?MBZ5GW2Vt+RHDocidQ3AumXstDbOonsTjdAinaAZv4FEg5IA+MQNwJ61N7rr?=
 =?us-ascii?Q?cQMnZX+knxbeby7A0oFhNGeQQlKsNTEV/Ro/3t7WvD/thGk1bDQ9avMhKSVS?=
 =?us-ascii?Q?psNrdkqsI/Q3JlofCf/Z4y/mx6MUazmtgW1cIIVQR5BZU4y8jcq0hS+5FTp6?=
 =?us-ascii?Q?BhPVIPiAI7XEM44b3+YAypG7X9Xi+y6BXDey0E9zVQsaJ4vBZpL5HSz9J7zN?=
 =?us-ascii?Q?puufM0DG00CHyz/2bMSLlk6DC2xiQAA0/L3zgzyQI78MXmw4xkwcTsSCNn/A?=
 =?us-ascii?Q?NZUSbxBaelVRHArTYrVdvqFfMG7fEOlQHAcnyyMKYVYaGUhp2QH3dWldXgNH?=
 =?us-ascii?Q?k2C6/Y4SdEifwk/OIcLztBsgj0h99ANUjIfNldykZdw49pqOaGZe0vTkFDAG?=
 =?us-ascii?Q?uWPbOAQsvPt0UckVgMucxlzdY7qJukzuH9J5kOGg8T/ZdxTS91d/Dbbg7g6Q?=
 =?us-ascii?Q?X8h4hAdwqiecxtK7kHMDjnRUFWriUMpOAoUUi2pAWSqV7bQik7/5F29FdkIM?=
 =?us-ascii?Q?6pW8FMTgA5DtDNmX23kuqsqC2gtGiLGADYmTjKLlZn3OIPtwlZGzroimp4sp?=
 =?us-ascii?Q?QZFL/Rwuqwuu5Ur0qct467nZdbFiV2GeYzvKHpAdD/+Rb1SP0xoTzsSdeIBY?=
 =?us-ascii?Q?FX6Jfw4azGVOyUxTSGPOUYkS8DOJT3cZaXk5wQ1JtEqeUMtr7Crwn7WijzKe?=
 =?us-ascii?Q?ocHTPyFoxB2VjSSJ/zuwx3chE3ws8xRrcxc1seFZeHSY/fz/qA8kmxkw6a8L?=
 =?us-ascii?Q?KmttV5OAJhuhEGm+/jXNuH32PIzNIFipTNQ/G3EY?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66d4cc9c-961b-4ab7-37dc-08ddb8257be3
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2025 22:28:49.1210
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: StxmzvWrz4MHPcpvs+jGEcWKY0FhL7UxyT+EFKbgI+g90FkWEtBbqW5ilrjFSpmE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR12MB8566

This is intended as a non-functional change. It aims to simplify and
optimize pci_get_alias_group().

The purpose of pci_get_alias_group() is to find the set of devices on the
same bus that are not ACS isolated or part of the alias set. All of these
devices should share a group so pci_get_alias_group() will search that set
for an existing group to join.

pci_reachable_set() does the calculations for figuring out the set of
devices under the pci_bus_sem, which is better than repeatedly searching
across all PCI devices.

Once the set of devices is determined it is a quick pci_get_slot() to
search for any existing groups in the subset.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommu.c | 137 ++++++++++++++----------------------------
 1 file changed, 45 insertions(+), 92 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index f98c25514bf912..5a8077d4b79d41 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -1413,85 +1413,6 @@ int iommu_group_id(struct iommu_group *group)
 }
 EXPORT_SYMBOL_GPL(iommu_group_id);
 
-static struct iommu_group *get_pci_alias_group(struct pci_dev *pdev,
-					       unsigned long *devfns);
-
-/*
- * For multifunction devices which are not isolated from each other, find
- * all the other non-isolated functions and look for existing groups.  For
- * each function, we also need to look for aliases to or from other devices
- * that may already have a group.
- */
-static struct iommu_group *get_pci_function_alias_group(struct pci_dev *pdev,
-							unsigned long *devfns)
-{
-	struct pci_dev *tmp = NULL;
-	struct iommu_group *group;
-
-	if (!pdev->multifunction || pci_acs_enabled(pdev, PCI_ACS_ISOLATED))
-		return NULL;
-
-	for_each_pci_dev(tmp) {
-		if (tmp == pdev || tmp->bus != pdev->bus ||
-		    PCI_SLOT(tmp->devfn) != PCI_SLOT(pdev->devfn) ||
-		    pci_acs_enabled(tmp, PCI_ACS_ISOLATED))
-			continue;
-
-		group = get_pci_alias_group(tmp, devfns);
-		if (group) {
-			pci_dev_put(tmp);
-			return group;
-		}
-	}
-
-	return NULL;
-}
-
-/*
- * Look for aliases to or from the given device for existing groups. DMA
- * aliases are only supported on the same bus, therefore the search
- * space is quite small (especially since we're really only looking at pcie
- * device, and therefore only expect multiple slots on the root complex or
- * downstream switch ports).  It's conceivable though that a pair of
- * multifunction devices could have aliases between them that would cause a
- * loop.  To prevent this, we use a bitmap to track where we've been.
- */
-static struct iommu_group *get_pci_alias_group(struct pci_dev *pdev,
-					       unsigned long *devfns)
-{
-	struct pci_dev *tmp = NULL;
-	struct iommu_group *group;
-
-	if (test_and_set_bit(pdev->devfn & 0xff, devfns))
-		return NULL;
-
-	group = iommu_group_get(&pdev->dev);
-	if (group)
-		return group;
-
-	for_each_pci_dev(tmp) {
-		if (tmp == pdev || tmp->bus != pdev->bus)
-			continue;
-
-		/* We alias them or they alias us */
-		if (pci_devs_are_dma_aliases(pdev, tmp)) {
-			group = get_pci_alias_group(tmp, devfns);
-			if (group) {
-				pci_dev_put(tmp);
-				return group;
-			}
-
-			group = get_pci_function_alias_group(tmp, devfns);
-			if (group) {
-				pci_dev_put(tmp);
-				return group;
-			}
-		}
-	}
-
-	return NULL;
-}
-
 /*
  * Generic device_group call-back function. It just allocates one
  * iommu-group per device.
@@ -1523,25 +1444,57 @@ struct iommu_group *generic_single_device_group(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(generic_single_device_group);
 
+static bool pci_devs_are_same_group(struct pci_dev *deva, struct pci_dev *devb)
+{
+	/*
+	 * This is allowed to return cycles: a,b -> b,c -> c,a can be aliases.
+	 */
+	if (pci_devs_are_dma_aliases(deva, devb))
+		return true;
+
+	/*
+	 * If any function in a multi function device does not have ACS
+	 * isolation turned on then the specs allows it to loop back internally
+	 * to another function.
+	 */
+	if ((deva->multifunction || devb->multifunction) &&
+	    PCI_SLOT(deva->devfn) == PCI_SLOT(devb->devfn)) {
+		if (!pci_acs_enabled(deva, PCI_ACS_ISOLATED) ||
+		    !pci_acs_enabled(devb, PCI_ACS_ISOLATED))
+			return true;
+	}
+	return false;
+}
+
 static struct iommu_group *pci_get_alias_group(struct pci_dev *pdev)
 {
-	struct iommu_group *group;
-	u64 devfns[4] = { 0 };
+	struct pci_alias_set devfns;
+	unsigned int devfn;
 
 	/*
-	 * Look for existing groups on device aliases.  If we alias another
-	 * device or another device aliases us, use the same group.
+	 * Look for existing groups on device aliases and multi-function ACS. If
+	 * we alias another device or another device aliases us, use the same
+	 * group.
+	 *
+	 * pci_reachable_set() should return the same bitmap if called for any
+	 * device in the set and we want all devices in the set to have the same
+	 * group.
 	 */
-	group = get_pci_alias_group(pdev, (unsigned long *)devfns);
-	if (group)
-		return group;
+	pci_reachable_set(pdev, &devfns, pci_devs_are_same_group);
+	/* start is known to have iommu_group_get() == NULL */
+	__clear_bit(pdev->devfn & 0xFF, devfns.devfns);
+	for_each_set_bit(devfn, devfns.devfns,
+			 sizeof(devfns.devfns) * BITS_PER_BYTE) {
+		struct iommu_group *group;
+		struct pci_dev *pdev_slot;
 
-	/*
-	 * Look for existing groups on non-isolated functions on the same
-	 * slot and aliases of those funcions, if any.  No need to clear
-	 * the search bitmap, the tested devfns are still valid.
-	 */
-	return get_pci_function_alias_group(pdev, (unsigned long *)devfns);
+		pdev_slot = pci_get_slot(pdev->bus, devfn);
+		group = iommu_group_get(&pdev_slot->dev);
+		pci_dev_put(pdev_slot);
+		if (group)
+			return group;
+	}
+	return NULL;
 }
 
 static struct iommu_group *pci_hierarchy_group(struct pci_dev *pdev)
-- 
2.43.0


