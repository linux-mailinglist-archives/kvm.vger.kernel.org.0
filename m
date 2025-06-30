Return-Path: <kvm+bounces-51126-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E078AEEA5D
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 00:31:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B63F23A3146
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 22:31:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA9F02EE5E6;
	Mon, 30 Jun 2025 22:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="L2MyzkWL"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2053.outbound.protection.outlook.com [40.107.243.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A7EE2EE29B;
	Mon, 30 Jun 2025 22:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751322541; cv=fail; b=W6k/zmA7L5SLEiJjqbk7Q29NoG1LVApTZUx6G/7L61AxEL+jVk3OEfQxyGVtfnZKMhtpxeSwlJtsD3wG0fYM198BXnXnS8ixS995DZDefeH5XNOxkt4smz9uhh7lub+hnSDXdyDhf34ZAenItQ2qJfvBuZgCuI4pdQW7FtkMQok=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751322541; c=relaxed/simple;
	bh=1XJCPGlBlztEKk3rEWOVjOWCIqlDFwyMISHdomHxqE4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=MuO7nBrKgOwnv5yfRdu7YIY5u79UYgTZUNe1XFOllfdsr16DOVPjbvHVpBHrYRjv0I+F5AmAyxPD5LFnoP1+2pGyNsurTCqIFaE48cY3nboxIHjLAzS6GPQ9RvZtF1DROZHxvKTzJgdxmFl01gzl1VTuQjxjQuba5zJKIxG2ILU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=L2MyzkWL; arc=fail smtp.client-ip=40.107.243.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tdnImlqJXM8Ux1fnXbrfCoW70x27HZOAiOJBZwStMQZupGgIA5La/9zxYSgvcXyRm8OqOP4t9bhpk5P8ytO+0ch6je6D/wncuRj87c1TI8kEVT/fPjiX1luKznSIV9ZcwHKUBqffFoQ3tIb0RYx+0dsNPG/iry78Elfr8VH7DBPoIjSacV2xdBF+6AV9txf9dksJMDniXF/hXqhRmG0xVCtcYJNIFbuuAvsHAAeS2QBq8itMWcPnm9jqviMdHLtzGtVnRWFxJ6RfO6MHBxxfXKc0dE4ditQ88FoB9MDUckrYblbLNd+IE/0z+k/RqINeOV3a/wyjooyLhuG+7aUiDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=539Tt2SNciWW4zYB8kbUplKcGRRmrvfm7QjCBv9H9N4=;
 b=FDcF7SErN5E6KW8SAp025slsfCq1DIjuRXvteroGgb5s4gdNS3pSf3AU1FiE+zNyQPafGZNogD5h/lPb3gcH9Ppr/2aUH1Ombf0q38iPUUBl09J2O7zxUIELKiS1IMnltpyrB570+MmCTxXNqlyss5KnWgz3YMznwsx7iTjsJcoCCmUQFpmaqVb1rakIsHXSjUXIAkaK4ZZQHVgMFV3LVjWrV1O536DBLJ1XdaGadoQZmzojYNdQijYZsP1RRna4rofwZbwBx5Djz41LzPN4U1hqESC3oDsm9zqw9sZLfjxOLI1yuyWE9SpKWKnc6HCcKERxyWu3cCzkQv7pUAOJXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=539Tt2SNciWW4zYB8kbUplKcGRRmrvfm7QjCBv9H9N4=;
 b=L2MyzkWLZCl7Jed/ssV/YkztCrlCa9mdnFIjhyFKx3SqnRnWB0NQFMcoI1jxMhFFT2NAbih702u+lizttV5qIY6KTTW/NzhF5MfevTLvd2KmU3NNp5SL4UXLIBMjX18YQUgyP76p56HmZLio4QIsozroqgQZ7LAhwo10It0r3XWMOj6pr/O9l73XgjtKoxDZ+BJQuXwKdtQCabzfGjGnINXVd/CsT4LaFL5v8BUf/A5s3KLbZSPdyHpG/i7zfIn2aebl0ey8GgF4qQqEUYwK5j40BqXzzA7ayKH040+RGruaGZlSguOdT4Ngeba7P5QukI6MGBYMaEP2YL4npDhq8A==
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
Subject: [PATCH 07/11] iommu: Validate that pci_for_each_dma_alias() matches the groups
Date: Mon, 30 Jun 2025 19:28:37 -0300
Message-ID: <7-v1-74184c5043c6+195-pcie_switch_groups_jgg@nvidia.com>
In-Reply-To: <0-v1-74184c5043c6+195-pcie_switch_groups_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR01CA0046.prod.exchangelabs.com (2603:10b6:a03:94::23)
 To CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|MN6PR12MB8566:EE_
X-MS-Office365-Filtering-Correlation-Id: fb415879-136d-45e3-6396-08ddb8257c01
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?CpY/gof/s04kLViC7VP3hxbRHyxatgKKjsHXzCO/+LfcS2xGd/V0A1iAlJM/?=
 =?us-ascii?Q?4HZusq6KP6gWkFCPSML2dcrvsG3ELMFgLLrN5KD+51ncnVlT1qQxOA8tIM3y?=
 =?us-ascii?Q?g16cLSw0MJYveqUK5aH/0naBSwd2/Z7CTqc9KbvCunaJtwkmmyVao/jY5kS4?=
 =?us-ascii?Q?Ufk8oKnYRvw9VykKAvWV5V9dzxenb9DTgTkyVIMAchBUw7UHCJFMKFHFOb31?=
 =?us-ascii?Q?HQwlrMrKti38MOCNyoIgWXJ3EnQGwOqf6y0ve/SMlNb392uQTVJANv/QBDmj?=
 =?us-ascii?Q?IphH9Ip5EzRHnlPJtmBvFvp2OWJeumheXpvl0BXlrHddHJZKcxAb0d26PeeD?=
 =?us-ascii?Q?qB6wr9YiyzLwdGsY+TdIvworaxzkzXwA3jUZLFuIhT1+to5ZwjADUOvwOnYW?=
 =?us-ascii?Q?4ko6OGjGTY5rM5i1Gm41s+rLWz1EotdCyjMv0eqa/JRRyn9qY4QE8LNdalYK?=
 =?us-ascii?Q?8K7ChBYcehw8jck+1i1aKKdiWjRcmv+Dj+VhJzEOpwWqnTWI4cN1btS4pAia?=
 =?us-ascii?Q?nuzVCeSrSp6gll5LlbGpBmFfvxm1q/u2E+QxSV+fGOMSyFW9dYlWX4wFlMq0?=
 =?us-ascii?Q?gsw9mh/yGXfaLYBcwumI7nyG28i1vJHuPJH4m4mP2/MfclQCDF95aIz8MuhH?=
 =?us-ascii?Q?m1yKdTDt8JQeMeKMWiAJwb0BjN0FQ6L76EwPplTfLUHfvrJ6bLGf7N91ewl1?=
 =?us-ascii?Q?IKDjv4Eiv/C2Kyew16beqJ4zFt6DU/CmEbhyHQx/5eym6ddaQQg/lu9COkw6?=
 =?us-ascii?Q?EIKZtyYaKqQkG0Bo8RKfTcrVoU3ExMh9RWoKALt4bAxfoff6R8osfzFdfDqO?=
 =?us-ascii?Q?ddMTDoQXQ0vFdyR1zf3WO8ljgctbxqUAJoQkBFPjZeP7hOwHvLgUb8Ay8CIC?=
 =?us-ascii?Q?6jbW/10kpzFye80rV3w1Px/EMzlSs5FRFjnymb1mU1EW6bsV/IQx44hyUxW6?=
 =?us-ascii?Q?nY4hyxkYU+yXBNEPMwpufblb/mxUhdPlQExyK3YKReAx7JbgF7uwv83KqgGy?=
 =?us-ascii?Q?BoHqzxLTxtQvRLevMj4Hf0zTeDhEAJ2D81lXDBihwzF9XLlfPpvdHl5fX5ke?=
 =?us-ascii?Q?UTAwZRqmoJjbb2GqVh1l2vmLL/AQ0S+0y7sENUTz4IVxWN+VAecmj5YUvDtH?=
 =?us-ascii?Q?6GrAp4HVAYQJzq7hHBVCsrsM4EIxKgLHglmS9+97SgmqweQQzMWqsvrrqCP5?=
 =?us-ascii?Q?W6xiDgYVpWfrF3VibebRDFaDCCqQLsrE48qzMwOUdwmfhDuGazuMoCXizKij?=
 =?us-ascii?Q?1lpuvVVecxoMIKejod5mbFTZqLocASuCiXJ7BwiCa5LZSpp3kDW87lS95kwY?=
 =?us-ascii?Q?iPE8nCXFXdA4kmzvJdAzcm9bqPKAW3+Z3/41rhV4G0TQRs8a+0q4fxQ7ikXP?=
 =?us-ascii?Q?Kpm7EWDdK+sk6HmoSv4EkcbeZ01LNGKY51Pf08L56y/s6kJftKt4RfesJUq/?=
 =?us-ascii?Q?qg359f0XSXc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?b3KqwVgOZe1ioNvyiS4sY8HQ1OD9OrsccPxvKMhVQqC+8cWFQYivZe+GUsV9?=
 =?us-ascii?Q?6Zue3QbWXXFCmGp1H2J7REqpnzbtg7W7QHaD3fC470WRC3MrFc+2yOeBxdg8?=
 =?us-ascii?Q?hebIVUInacXPyxTiTHror51J/TJRyUy+hBE2vToL1Ct0hLu4ZAwQP06HQVO4?=
 =?us-ascii?Q?yCAo7pIS3VKE6L/7hbEjUwiVbSleQr5+UFRCcYdkvjD5bCeLxX8peq3naRrl?=
 =?us-ascii?Q?zF8ScsANg2CZBlqEms0gCzgywPIFmMJ+B4fN7nIHcG0odg9ADEe1uAIuey9m?=
 =?us-ascii?Q?Do9IiaXddsgc3QoXneb+QZMNQJBBw/Zgpc9wjPvbwVlP8jMkoI9lA/eZS78y?=
 =?us-ascii?Q?WpXPJokE/hwNRow7Ckd0Xy9CSzo3XSgajr3zOouq83eC1FNeRImd4LPbZFVO?=
 =?us-ascii?Q?u6ODC2bxAXkpOKO4suHoY51iUnmyRce6IOybOm/8CqXBoyidZiHGegpWWn72?=
 =?us-ascii?Q?mwge4I/wA6okBE7GsXusg9GtOlbhvyxlzIPtwhqu759GxI4ihIXwj1dvDBCj?=
 =?us-ascii?Q?OYNuGb5vKE7+AENE17ZghZpdnpQOMDINUdZqqCcFpLZcx2TajLDqJbL+xlyP?=
 =?us-ascii?Q?JuXC7iIcYDEJijw4MPlETXQtAzoZE5KVrbyHVvweor3AOZnVCJlFG8Q5u+QW?=
 =?us-ascii?Q?MZ/fwaUXb71wtP6Yg5ALz3d1yQGXYeU6vIx8Dsqad5/i1Ws9Ji1Af+VEGbbz?=
 =?us-ascii?Q?/IeqTIykZ3KvPTASakVYn6zHnyWe1A06ezkzhqBpS0gbsw8R9mc29GiKK+Do?=
 =?us-ascii?Q?bD56iTrx1S9DFjSu7FYva5IWNFC4gqfSD0szcEYlA60ZZAw2OE5AXXVC+sx1?=
 =?us-ascii?Q?N62/mq1rPc6F6DrrLUWWqNZt/CkL4Bm248Z4p62rn6EY4bY/enlDp6CuEdR+?=
 =?us-ascii?Q?VJUTKmavCElrgcrINECNZi+Z0KVsWKenHLLjIy5G2HSTqQCzQER7dk2zEYP2?=
 =?us-ascii?Q?+MjFHJAFOI8ag+96GLH5pseNYJdA7eVuqwKC+J++Mk207A4lNsIiONl25TXJ?=
 =?us-ascii?Q?iswMbw2yffmyPUmRIrvOfX+glYac6zGklFQdbqhOVwvUkLMVQbfKFgzzqheh?=
 =?us-ascii?Q?R/X9QP6DRTlW3o/RqEMO7rj9XLNQipHS7LJ5708T5RikVIhVhhqkQd3001SV?=
 =?us-ascii?Q?eJkdN2uaSSPBHtECJU9Yd6XZlRGLe8wvTJMowdhjI79BGDX6WSoq300zqHf8?=
 =?us-ascii?Q?GnhMMV5w6gPz+oOfQrdnQ9wV92VZ7g/3vADniWgP4/AmbwYWA3nmWzdQkq1D?=
 =?us-ascii?Q?inH6efFNNM+LCdkKsKO3RDYM8GFf2/lPI5F5Z9fRFa/k/e53fVxYzRVmwu26?=
 =?us-ascii?Q?6sOli9t9IHg9EZZpBb67HewX3mnsBExGC7zMDs4jkSNuJLUspQ2mCShGDWKw?=
 =?us-ascii?Q?dGknVjEd76wLo8xwpMPQBs5T6l9q4K0seNaQYufsrEBqbqYgFe25elf++JN5?=
 =?us-ascii?Q?uSBcEFrNifV4xM1Z1dzDWZpLbozby7M6WDPSlzFAImSJh8SbU70jEIcqftU8?=
 =?us-ascii?Q?fyuoRLZyy5aeGso+d2qAbscIODHwHC9c7GjDNWH+vnmc/zCvJuT31XFJLpmn?=
 =?us-ascii?Q?xtw0bqPAZmqBhHfAxskKvyNS6BZQCRhGBvsQSPOp?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb415879-136d-45e3-6396-08ddb8257c01
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2025 22:28:49.4870
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4n9HOdaQUQVehXJxzx3rP0rgbpSCzFAKS9ca42kwlQ9Eu89ZwMjkKCs1vL+4TsOx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR12MB8566

Directly check that the devices touched by pci_for_each_dma_alias() match
the groups that were built by pci_device_group(). This helps validate that
pci_for_each_dma_alias() and pci_bus_isolated() are consistent.

This should eventually be hidden behind a debug kconfig, but for now it is
good to get feedback from more diverse systems if there are any problems.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommu.c | 73 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 72 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 5a8077d4b79d41..907c1b4eb883ed 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -1556,7 +1556,7 @@ static struct iommu_group *pci_hierarchy_group(struct pci_dev *pdev)
  *     Once a PCI bus becomes non isolating the entire downstream hierarchy of
  *     that bus becomes a single group.
  */
-struct iommu_group *pci_device_group(struct device *dev)
+static struct iommu_group *__pci_device_group(struct device *dev)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
 	struct iommu_group *group;
@@ -1666,6 +1666,77 @@ struct iommu_group *pci_device_group(struct device *dev)
 	WARN_ON(true);
 	return ERR_PTR(-EINVAL);
 }
+
+struct check_group_aliases_data {
+	struct pci_dev *pdev;
+	struct iommu_group *group;
+};
+
+static void pci_check_group(const struct check_group_aliases_data *data,
+			    u16 alias, struct pci_dev *pdev)
+{
+	struct iommu_group *group;
+
+	group = iommu_group_get(&pdev->dev);
+	if (!group)
+		return;
+
+	if (group != data->group)
+		dev_err(&data->pdev->dev,
+			"During group construction alias processing needed dev %s alias %x to have the same group but %u != %u\n",
+			pci_name(pdev), alias, data->group->id, group->id);
+	iommu_group_put(group);
+}
+
+static int pci_check_group_aliases(struct pci_dev *pdev, u16 alias,
+				   void *opaque)
+{
+	const struct check_group_aliases_data *data = opaque;
+
+	/*
+	 * Sometimes when a PCIe-PCI bridge is performing transactions on behalf
+	 * of its subordinate bus it uses devfn=0 on the subordinate bus as the
+	 * alias. This means that 0 will alias with all devfns on the
+	 * subordinate bus and so we expect to see those in the same group. pdev
+	 * in this case is the bridge itself and pdev->bus is the primary bus of
+	 * the bridge.
+	 */
+	if (pdev->bus->number != PCI_BUS_NUM(alias)) {
+		struct pci_dev *piter = NULL;
+
+		for_each_pci_dev(piter) {
+			if (pci_domain_nr(pdev->bus) ==
+				    pci_domain_nr(piter->bus) &&
+			    PCI_BUS_NUM(alias) == pdev->bus->number)
+				pci_check_group(data, alias, piter);
+		}
+	} else {
+		pci_check_group(data, alias, pdev);
+	}
+
+	return 0;
+}
+
+struct iommu_group *pci_device_group(struct device *dev)
+{
+	struct iommu_group *group = __pci_device_group(dev);
+
+	if (!IS_ERR(group)) {
+		struct check_group_aliases_data data = {
+			.pdev = to_pci_dev(dev), .group = group
+		};
+
+		/*
+		 * The IOMMU driver should use pci_for_each_dma_alias() to
+		 * figure out what RIDs to program and the core requires all the
+		 * RIDs to fall within the same group. Validate that everything
+		 * worked properly.
+		 */
+		pci_for_each_dma_alias(data.pdev, pci_check_group_aliases,
+				       &data);
+	}
+	return group;
+}
 EXPORT_SYMBOL_GPL(pci_device_group);
 
 /* Get the IOMMU group for device on fsl-mc bus */
-- 
2.43.0


