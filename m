Return-Path: <kvm+bounces-56900-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C67EB461B8
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 20:07:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A18AC5A6C92
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 18:07:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CE00393DF8;
	Fri,  5 Sep 2025 18:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="MGgbp5Jm"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2044.outbound.protection.outlook.com [40.107.92.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A18337C10F;
	Fri,  5 Sep 2025 18:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757095601; cv=fail; b=hO8l/SzyWhJeqy+8u/R+oBYfcDOe3s9Jw+h0So84yKy7ooN70AkAW1mUynf/Mpoj/Q11D3DiwFaHiTuMke75bBrtaS5qbnYvwFDAvMRnNgmlTGjnFtN86hM/0WNjIw/GWAClB2j+VAtqvSB6oLyAqhj1Pnkm95fI3dd7CLQ/qKY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757095601; c=relaxed/simple;
	bh=GTdRKVOgR2YZMqy9qYfZ7gnaIZmWdLJbM3WQzQwpcbY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=HZ7H45q5OyCysEo+l5P/l25R2ffbDCuRc7IADtekEQMDgB06auG7ZNkM1A+SXHUnuvTCM469U3NKxdwrzIRnvaeqYHmvplQ1G60DR/JX5Uio51SRBOFV1thV1ud9QqpK6bpOvGhv9ZL64Oofe4YcWwZgYqlptfmpqk4oOAx5Vqs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=MGgbp5Jm; arc=fail smtp.client-ip=40.107.92.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Odd3GquwlSuRlJ3scwwOidsFFZU80KgTgkj2U/VXKeNQSI3nnLP3Gqs7b5LJPIovB2uBJZ4BTRPpZvWOWRUMbY26HYog9mV76ipEmpbgI93/FyMSOhIqLZIk1r1YN+gJdGYKySHFdNU4ktA4vBn+vvNe4uaxlB1uhJNkd8KUD4x7y/gNOftNP72A3p/9Dpj0q809Uafs5yiOAfEQfXbd5jQzckUNtxItMX4m3/7qb42r3/9tXFyV3Vy8n1rsvhj+SjMl6kDTPGzhyOOfZy4t3ewSWfOUyybNCMAuYIM8eAhkrvdv5ZFM/kB6BWx4t04NbhpZ+bkjoMMuJaMhrhSM8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lnAUJhY8961VZXNWNHiJ9OvjJ9dnT1jZxU+gPAenOnk=;
 b=N7TUUhRZSbO58af2HfTtM3uztg17kKA85DEaQvi5mR91/Ffnwc6frhYF7nkGcQNrr9tvVqJzcVxH1h6WLlDYGgdTVFA0T44jnubHpYpL8QJ17tcs8Jpnn8/wT7OO651+ouSkaVdc+PrfLyPH7MUyYxoDQNCRmNVTIrNFfF+dRn/9mAYl5Rw+g83rDBUoVXLJZyZPl+w+kv08EIM8Pw+Z0Th+dnnPqfPZW9MR90a7ywqRl7htx4Pb5dPn2qUvLFtvEC1Li+XCSRgfrjtHryYV47ZG3TJw1DsSxmYg/leumcDD6aN8WjWKwpUQUreBaBa9GJ0oW1q5jMa3dMlk3V9WoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lnAUJhY8961VZXNWNHiJ9OvjJ9dnT1jZxU+gPAenOnk=;
 b=MGgbp5Jmr6XczWPDWnhoDMR+JJuaJfqpVD/Hsxv8sY6zooBSXKDBMQRwMRdSJ24MqiFW4R9GOTutkXGf1bmPyZDRCJKn/u3Vgi2yMUNelHNEfY70mUt61TDinJguI4FwTs9AYaIlw027pOEhL3gH0c5Dp71q4r1EyUE6v42vzDzDBL/Io68gV0MlN2mZdsbkdL+JdWSCkZEDuzptVN7KyYagxE4G3q9aOEtR9CSBjKISMhWW/Nn/aB4L5+XyV67Hhb/EaHJI44cRLBkqapBJ7ijoKg/BoBuwtmdWJSlmHD4XlGcdoCOFK5SBzl5OK6ey4DwGwsXOYFP5inKypqCIUg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
 by DM4PR12MB7696.namprd12.prod.outlook.com (2603:10b6:8:100::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.17; Fri, 5 Sep
 2025 18:06:31 +0000
Received: from PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632]) by PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632%2]) with mapi id 15.20.9094.017; Fri, 5 Sep 2025
 18:06:31 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-pci@vger.kernel.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Donald Dutile <ddutile@redhat.com>,
	galshalom@nvidia.com,
	Joerg Roedel <jroedel@suse.de>,
	Kevin Tian <kevin.tian@intel.com>,
	kvm@vger.kernel.org,
	maorg@nvidia.com,
	patches@lists.linux.dev,
	tdave@nvidia.com,
	Tony Zhu <tony.zhu@intel.com>
Subject: [PATCH v3 05/11] PCI: Add pci_reachable_set()
Date: Fri,  5 Sep 2025 15:06:20 -0300
Message-ID: <5-v3-8827cc7fc4e0+23f-pcie_switch_groups_jgg@nvidia.com>
In-Reply-To: <0-v3-8827cc7fc4e0+23f-pcie_switch_groups_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0005.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:d1::18) To PH7PR12MB5757.namprd12.prod.outlook.com
 (2603:10b6:510:1d0::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_|DM4PR12MB7696:EE_
X-MS-Office365-Filtering-Correlation-Id: 4fd9b33b-20ac-4cf4-a0b7-08ddeca6f0b6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Z5SO2TIsrphZWTJQXsyQRdVxqjRhWOriBPYP7ZZNtD2ZVfLRf6dqCHV3M3Pv?=
 =?us-ascii?Q?eUqY5LGpwXefregQi8OdsXrhC8qvoGDbra7LD1OF5Q5w9yyURC/Q2aJOy7DV?=
 =?us-ascii?Q?hzVz6Y0ha81A1EQ+AKy3xqaoGHgn8/JeEPhpHhvew6a1MT/B1Px/oPH/HXuA?=
 =?us-ascii?Q?zTZ3Uqrd2+KFRQr+y21tSIOvySUiSeN799n3a7xijMeC58rNWAOX/SvjY/yx?=
 =?us-ascii?Q?+clMoiNqrStTrO3HqfOvKVCXyOkR8XuKC9NIkCuaCQW3hFzj8B2xfNDFFS35?=
 =?us-ascii?Q?A1XRjXiCisZJjfhOG2/nfpf3iZBd3aNQM8LyTdNSC9aMUrYWgLkHyZfbf+b4?=
 =?us-ascii?Q?oGTRRGcmrlsPjZHMuX/T/cwmLaIlRdvczRXae80pZv4aIsrpBAcc5GEqmbfj?=
 =?us-ascii?Q?5R3b6qzOAAS76QrmFe4eiEw494VgnCB7QvcaC2rkJS7ZK+vDoy1ih+gLyW5e?=
 =?us-ascii?Q?DdIW9nKTnXPKKdZsuHksFiiLkTf6r7ejHLTiNqJFShT8lEcpnWp4uKtEBJN2?=
 =?us-ascii?Q?grxSx4ibzttj46frG7i32dKn2WBIDcmmjAhvm60VEXFmJ9PKjxCHDYP1C9ZO?=
 =?us-ascii?Q?/iKVtRpjMSy73KcwxAytZzWwxepVU7X4xpecmKgnmiWzpX+PqIX5MpaZH/s8?=
 =?us-ascii?Q?a086vCZgavAH8YaxfGI+Ja6ZBf4YX3J1drxQfVJV3k2VCFDWoEWfY1g2TZIr?=
 =?us-ascii?Q?MpeGmxyDFqLZ8pd04seN89oNJ9JA/bk/ayZmNYLyARFrIGOLx3CoWc4Hky+7?=
 =?us-ascii?Q?0uMh3/wdZlayT2kjFUZHL5eAEpdbpzqdBFP/4hUL0EU5Ek/lIQMhymyFTlfs?=
 =?us-ascii?Q?GrMdT/8GY+QmyJaUx8jGXgiM5gGFCLj10SNIIdyfZA2lYF7BU/s0SG61pJkv?=
 =?us-ascii?Q?Wb+dlXRN51zGHPRsjjO2ECm7OswWjGbLPYIz659UehLh1/yE/kYdU42CpCP1?=
 =?us-ascii?Q?92iR1g82EadSlIG2p2yJZn3FNNGaoQUZXZWllbuYx2xMXFOWBWKavNlHN4lM?=
 =?us-ascii?Q?rtCzmfaTeUSfD+SR2oxG3dm6blcaEiNIr4/BKzEAt21HF1GtTgmf22/KS+Wa?=
 =?us-ascii?Q?19G22HUOm1Q7XzTf7/Dx7RbjA8w75xaTCvz85YbkrRVdfBKH7+M6sZcLkeMA?=
 =?us-ascii?Q?dY8M7OT8kmZjYUXCfBnJwJuJTB6jcEiIEBoi4iNFUAzzFZtqSVFwCMvkKNR4?=
 =?us-ascii?Q?c3AAaH0CrPftKa3jdYEQZGGRzEdmXVHUkB2RL0EsIt+oi4eUhu+1wbJvcEck?=
 =?us-ascii?Q?EbZmWbfre4JgJ3Q5dBxRDUR8ouigISEXoy6tcH3fdcFASuNptTD8LRYmsdOO?=
 =?us-ascii?Q?4DOexf68Yy0KYxw4q4gHOvjnUBQkdAr9jJIoMkumr4kwfMGxuKW8kpNrZKTJ?=
 =?us-ascii?Q?7wwTqvPInWtnPo98brvokdfKbtISfSSWE5PF91o3pfuWanRWTpr/FOfpNMO4?=
 =?us-ascii?Q?l3pkTtQJ54E=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kLFGw0FfSzukY+l0KFpwa1j3CaOZV8ZTm+ZpQmtAyVYI25+9943p6SHjHuNd?=
 =?us-ascii?Q?P89rybPZ8HSWrASyrhNW4ATzP39hHQOJyVABGvSyOBwHikil6SKrp0DI716O?=
 =?us-ascii?Q?2B9FJEs2W9fWk/rhyzhM67/6XM/L/v11scgroVZ2bF9QNmuR74+ef24taL/H?=
 =?us-ascii?Q?fgMzVV1Ys/hDDZ+zdcd/N9p/gvwccjaudB8S0RgayFeX50C6qYqWBz2LtZo9?=
 =?us-ascii?Q?h7C5mWM89JyJD8wHqUe8RNHlaLdzn0cpH7vDUJM60+J1b9jZwv8ghPiarrZ2?=
 =?us-ascii?Q?U1Z1zCCB6WNZDm2EtDNiTc9pPIju47nxe37BkzWLgPrBvo4aTNjYKN1yhWjl?=
 =?us-ascii?Q?nJSxQRMuI6/p1OLCHiz5l0ahy2HUH59JB3XuuQyUqVYTDlPBN1/omOL4cvJA?=
 =?us-ascii?Q?9fOzihPaMuTO/RjiZxqh5dygB43DvLOxMwTjVv9OxPS/kZOQm6L0ji62NU2C?=
 =?us-ascii?Q?GULcl4t1eBNQ13rP1FF1ttZunu1lDdC0jvSgcUfB7mF8ozHtCqKXl+ogghOs?=
 =?us-ascii?Q?XslLmbhVssuV5BgLRHvFusLtgtkt67CVSlb084U9UKxdI5wx2OpSGqEJOMI+?=
 =?us-ascii?Q?OsxnhuCOuhHWFuwUHughAbu2XxrORoZmmWYnusn0EpNbq2fYe8MdSFIf91mD?=
 =?us-ascii?Q?myVyxr562AQX350sSItDfTabA/LSI+i8iUHXvrDqlFi5tDntwpTbMYemcKRm?=
 =?us-ascii?Q?9BJTNdfmjNoqkuoKmvX66zh7jgO1aQgGci1loaV5nGYzux7C69rne4cBtALl?=
 =?us-ascii?Q?pPHyYP5W3dE1oOmr0jI9PKl8nASJmWNrkroBMIyWMIj7YSCTkZ81P30htLdT?=
 =?us-ascii?Q?48z7shl3ni3YdTJfFGP+cxPWUn10Eyd6i46fXKtJjenqRcNKSNPFC5WevmTj?=
 =?us-ascii?Q?Yxy7XS9c5DEHLkHr6hI1yRTw8MQxzQ8CwxGbAA0RKRB0h/4bWUSBtdcgc5Z6?=
 =?us-ascii?Q?CZ/NRpvoy5Ybn8hyYPICQHyZ9f/7TYp3zC1anvaPNETHvFqUt1Jifsuai9RN?=
 =?us-ascii?Q?a6thlHOx6PDHUA1iXW+b0hlV4gPmcY7h6ZuG2pxETPAIwiEFw9AiSqCjIee5?=
 =?us-ascii?Q?n8m8Xi6IYTR4t+7lV8M8FQ27+kd+9r1a5PHUqwsEe6SL9p/1fMS0psfeNXyx?=
 =?us-ascii?Q?FZZXuD77ZUmAm7MlR1uQAFBb/ERtF+y+Y7MqZoEvq7Y0wONBMtZz4/lCyyQr?=
 =?us-ascii?Q?Zf7MJkMDrfe3/lsmBG0B0XQvYl+TAk7bmKkTDnjowtPwlyLukYs8l7qH4tpG?=
 =?us-ascii?Q?LQdU/0PU5BdPOoyx6nof2XImcHAtfBAmwITugapMNZZaDWLsm4UBX+6gVxha?=
 =?us-ascii?Q?gLhTe67p8slUYVXkl/V+LplAfE9isvMytX5Ez02+Z+UtlvtvVIECC88ASx3M?=
 =?us-ascii?Q?xCGmAsk5MKuPfaO1bBXK6BKT0yhPrTQIPZvuTIq3hnclNrC3qM3oKqGkXVei?=
 =?us-ascii?Q?Vs8oAMQesQiFkNRTZ8SSkBBaCM2iisw3fU+NT2pU5nX9miMxbD5us88ok+m5?=
 =?us-ascii?Q?NVOCIg4nX+7KUVtZyeA5mKqGAy8ObeQqt4DOTtfeAYyJrwfc06OWx8QR49vV?=
 =?us-ascii?Q?NbApTh0GHeUQFljGwdE=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fd9b33b-20ac-4cf4-a0b7-08ddeca6f0b6
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2025 18:06:30.5215
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2XMXtUhfqlg175hB6VL9emioPiQluJpWbG9cNYRmDoHrXXOrcPmTsX5r10qD46TJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7696

Implement pci_reachable_set() to efficiently compute a set of devices on
the same bus that are "reachable" from a starting device. The meaning of
reachability is defined by the caller through a callback function.

This is a faster implementation of the same logic in
pci_device_group(). Being inside the PCI core allows use of pci_bus_sem so
it can use list_for_each_entry() on a small list of devices instead of the
expensive for_each_pci_dev(). Server systems can now have hundreds of PCI
devices, but typically only a very small number of devices per bus.

An example of a reachability function would be pci_devs_are_dma_aliases()
which would compute a set of devices on the same bus that are
aliases. This would also be useful in future support for the ACS P2P
Egress Vector which has a similar reachability problem.

This is effectively a graph algorithm where the set of devices on the bus
are vertexes and the reachable() function defines the edges. It returns a
set of vertexes that form a connected graph.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/pci/search.c | 90 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/pci.h  | 12 ++++++
 2 files changed, 102 insertions(+)

diff --git a/drivers/pci/search.c b/drivers/pci/search.c
index fe6c07e67cb8ce..dac6b042fd5f5d 100644
--- a/drivers/pci/search.c
+++ b/drivers/pci/search.c
@@ -595,3 +595,93 @@ int pci_dev_present(const struct pci_device_id *ids)
 	return 0;
 }
 EXPORT_SYMBOL(pci_dev_present);
+
+/**
+ * pci_reachable_set - Generate a bitmap of devices within a reachability set
+ * @start: First device in the set
+ * @devfns: The set of devices on the bus
+ * @reachable: Callback to tell if two devices can reach each other
+ *
+ * Compute a bitmap where every set bit is a device on the bus that is reachable
+ * from the start device, including the start device. Reachability between two
+ * devices is determined by a callback function.
+ *
+ * This is a non-recursive implementation that invokes the callback once per
+ * pair. The callback must be commutative:
+ *    reachable(a, b) == reachable(b, a)
+ * reachable() can form a cyclic graph:
+ *    reachable(a,b) == reachable(b,c) == reachable(c,a) == true
+ *
+ * Since this function is limited to a single bus the largest set can be 256
+ * devices large.
+ */
+void pci_reachable_set(struct pci_dev *start, struct pci_reachable_set *devfns,
+		       bool (*reachable)(struct pci_dev *deva,
+					 struct pci_dev *devb))
+{
+	struct pci_reachable_set todo_devfns = {};
+	struct pci_reachable_set next_devfns = {};
+	struct pci_bus *bus = start->bus;
+	bool again;
+
+	/* Assume devfn of all PCI devices is bounded by MAX_NR_DEVFNS */
+	static_assert(sizeof(next_devfns.devfns) * BITS_PER_BYTE >=
+		      MAX_NR_DEVFNS);
+
+	memset(devfns, 0, sizeof(devfns->devfns));
+	__set_bit(start->devfn, devfns->devfns);
+	__set_bit(start->devfn, next_devfns.devfns);
+
+	down_read(&pci_bus_sem);
+	while (true) {
+		unsigned int devfna;
+		unsigned int i;
+
+		/*
+		 * For each device that hasn't been checked compare every
+		 * device on the bus against it.
+		 */
+		again = false;
+		for_each_set_bit(devfna, next_devfns.devfns, MAX_NR_DEVFNS) {
+			struct pci_dev *deva = NULL;
+			struct pci_dev *devb;
+
+			list_for_each_entry(devb, &bus->devices, bus_list) {
+				if (devb->devfn == devfna)
+					deva = devb;
+
+				if (test_bit(devb->devfn, devfns->devfns))
+					continue;
+
+				if (!deva) {
+					deva = devb;
+					list_for_each_entry_continue(
+						deva, &bus->devices, bus_list)
+						if (deva->devfn == devfna)
+							break;
+				}
+
+				if (!reachable(deva, devb))
+					continue;
+
+				__set_bit(devb->devfn, todo_devfns.devfns);
+				again = true;
+			}
+		}
+
+		if (!again)
+			break;
+
+		/*
+		 * Every new bit adds a new deva to check, reloop the whole
+		 * thing. Expect this to be rare.
+		 */
+		for (i = 0; i != ARRAY_SIZE(devfns->devfns); i++) {
+			devfns->devfns[i] |= todo_devfns.devfns[i];
+			next_devfns.devfns[i] = todo_devfns.devfns[i];
+			todo_devfns.devfns[i] = 0;
+		}
+	}
+	up_read(&pci_bus_sem);
+}
+EXPORT_SYMBOL_GPL(pci_reachable_set);
diff --git a/include/linux/pci.h b/include/linux/pci.h
index fb9adf0562f8ef..21f6b20b487f8d 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -855,6 +855,10 @@ struct pci_dynids {
 	struct list_head	list;	/* For IDs added at runtime */
 };
 
+struct pci_reachable_set {
+	DECLARE_BITMAP(devfns, 256);
+};
+
 enum pci_bus_isolation {
 	/*
 	 * The bus is off a root port and the root port has isolated ACS flags
@@ -1269,6 +1273,9 @@ struct pci_dev *pci_get_domain_bus_and_slot(int domain, unsigned int bus,
 struct pci_dev *pci_get_class(unsigned int class, struct pci_dev *from);
 struct pci_dev *pci_get_base_class(unsigned int class, struct pci_dev *from);
 
+void pci_reachable_set(struct pci_dev *start, struct pci_reachable_set *devfns,
+		       bool (*reachable)(struct pci_dev *deva,
+					 struct pci_dev *devb));
 enum pci_bus_isolation pci_bus_isolated(struct pci_bus *bus);
 
 int pci_dev_present(const struct pci_device_id *ids);
@@ -2084,6 +2091,11 @@ static inline struct pci_dev *pci_get_base_class(unsigned int class,
 						 struct pci_dev *from)
 { return NULL; }
 
+static inline void
+pci_reachable_set(struct pci_dev *start, struct pci_reachable_set *devfns,
+		  bool (*reachable)(struct pci_dev *deva, struct pci_dev *devb))
+{ }
+
 static inline enum pci_bus_isolation pci_bus_isolated(struct pci_bus *bus)
 { return PCIE_NON_ISOLATED; }
 
-- 
2.43.0


