Return-Path: <kvm+bounces-51972-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C609FAFECC4
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 16:56:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 46F471C46532
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 14:55:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1004E2E6D1A;
	Wed,  9 Jul 2025 14:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="FTx79wTV"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2083.outbound.protection.outlook.com [40.107.96.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 664472E6D03;
	Wed,  9 Jul 2025 14:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752072759; cv=fail; b=CWm+10X68qQ09jzqvf7n9oH75HKfVjiyajpNByxKTFLcCCl8GKwisQugUxDPqR7T3ogI2jtyUY+htN+c+K8rG+94LKZ9KsYGS6aPqPZEgZ0aw4rNVcGhqHd3QmNP8NEX07MQ8+JI43jUZzhA5PRbmzGGAq4tYA11C2KZ7KHfHos=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752072759; c=relaxed/simple;
	bh=9t2oOSnuV6a4X4ASEtsXZwK1yLRY95wyvZeOEy3StQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=VCJCcFoJwcStQ8ok4Je++B4OAVyatbJq6z67eiwLR0cw1gLUKBaYPSBCIYwSvQUL1rlm/VLy+tKtbkM2yKKjm7rte7ljspB3BJwRCX+xtRFe65C/IBNStbjNrkE6S62rXfBqs0BQvYgchAQJf2K10w5uKQGzy9QeV22JeelsvZ0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=FTx79wTV; arc=fail smtp.client-ip=40.107.96.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KKqiI7oBiZyWxiVQKdZI/xCZ7czJF2pq6ggx7J9IKO/Vy9KDlnLN3i4ihnAXI9hzcpGx98ZFAqBnKwpgRjFpVLyP5wefpm6TaEZVe4j4WMHaATGXfu2KwJGJWFW8jGPxeIUuPO0nIU/MH0F4t+ppl7vlNeMoFfq+R1TNyrqfOppjGWiIf0MxP1tqGJ+SWseniABSu6qfT1zEFG5byVv/DwmzWqUi8hu0gp31qbkOjm50935fzEPPL3ZRaw3ycNuTmDM8rWwZVx/oWcUdmW5PC5YXN/6BR8ftxUxQQRn9nIoZuG7nt44p+VPwGgLsF8khVm/nit3jr0dyeNNcAd6XnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GrPIQjskBK9bk+GAipPeiDUaWMs09cPMKX01pa0UbHs=;
 b=iDEcGAEJu1VGmSstr8Y0lTj0z33Bqdyk0/ClEZcW9LIxKdTlXswOTyXxJbN/oz+pbtWP933YpoJZC/8UFdDElpsKPZ+dgUcWw4eNvPH6eZ05kQ/+dy2gkJ1Xjr9RDbGcZmZ8TC7b0b2PgrtvlRNUE86Lacfn6jMSX6DPPE5nsIUxAMz33ZO6nnlxMYZt8D/nTDpPDMs1iPlBLX6aI27FM4nGAloQGSzkKBzhd3S0k7QYJQonkvXv/XW+F42SpwTKQf2egUw7/7VfdCa+JBslGnYJLAMxKlMXa5I2mQoDklB/25+5do1yLV4eGJI+yueg6lN1nbufhjR8k2yXpqJUJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GrPIQjskBK9bk+GAipPeiDUaWMs09cPMKX01pa0UbHs=;
 b=FTx79wTVCPd7o2jwnNdknwKfEv+5xt2acLafwy6do6+csvtbB/aFlL8UQrg8ylWB5lWJ/ZOonKBPfxw1/PZ7oTkTvhOgi0lS7V8Ikxu9b3NzXP82mXHI2Fz2bL02/3EmV4704n3/jn+KIozVANPsRlbnauT3NA5Zc+fjFKifZ+AWp2FBvz1NmJ9M1F7M6UB41TAFFhnIJ/pCujcxVDa5BcVI348nHvkcRdvYobp2TvxTsYfdGvaule3KQZz0dtlg71T/1xY/FBQxnNeB81KcYiev740CeSDO/UG3uzDGcpAn5fBZ4lt054FqVjF94mf6roRLcVgLijZ2CC7ktcwxyQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by MN0PR12MB6125.namprd12.prod.outlook.com (2603:10b6:208:3c7::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.23; Wed, 9 Jul
 2025 14:52:24 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8901.024; Wed, 9 Jul 2025
 14:52:24 +0000
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
Subject: [PATCH v2 13/16] PCI: Add the ACS Enhanced Capability definitions
Date: Wed,  9 Jul 2025 11:52:16 -0300
Message-ID: <13-v2-4a9b9c983431+10e2-pcie_switch_groups_jgg@nvidia.com>
In-Reply-To: <0-v2-4a9b9c983431+10e2-pcie_switch_groups_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN7PR04CA0219.namprd04.prod.outlook.com
 (2603:10b6:806:127::14) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|MN0PR12MB6125:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f62da59-ce1b-4b8e-65b2-08ddbef836af
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ro7vYMCebmvNCkw8myP4M6mZ70+2hESreaeV0ImZWGFrPRpPtdkQkaw0BiLK?=
 =?us-ascii?Q?K0mmySle2Fq3tZb3nAHIrtfn1fvGiKegyLDoJGYugkO6ZF9l56OZ5DJXrRbz?=
 =?us-ascii?Q?jWcCvTq56pBk2BaWAMlAnN1gh325YrOvlFDyvabXRYRSjsHyYG+zg8kJf8YY?=
 =?us-ascii?Q?TjZZ9AO8P4ZKKnuQfgCJoUnMKnUphKPCbfrTF6wMYZ1F5p0Ufg2CBD/uywNq?=
 =?us-ascii?Q?G/Yxw+fcxwhLWUobp2sWIbAMkzN35SgHTPsHBRu4p8fu8dUsQ87CNcE3kgWo?=
 =?us-ascii?Q?FaIU3z54jJkl/A2Xqq9iIi+2RImXK2PUshYq719X0lq9hpeCOr5Qp7wgqkb/?=
 =?us-ascii?Q?nnIVl8gQ0O6w2/S1dz8aHoI8za3FoxJEapoU0q6gFyQT2Qs8ESksPeGB26dY?=
 =?us-ascii?Q?4U7aCYInI4aYfckDqL1gaiEao0RW6jD7r5/TiK10sx3MQWE7QfMtXtUPtD4n?=
 =?us-ascii?Q?ST9+U00DxYZli39MF7ddQSmHUjkJNkw6qDJNuENHuu1xkhR/7dWy4QU907z2?=
 =?us-ascii?Q?q/YI1IpGBtKUR5hHtQGyOJL2qyIfBewqwBXS9/z/EMzdlANjjpbjy7wVwPN5?=
 =?us-ascii?Q?69jMF9J8mh3GxcjBgbV2N4fgiaQd1eS2oSLTVnpKMRdDa8Es241yYYIE6+L6?=
 =?us-ascii?Q?u6HvDegkBbcxEFTjO22xan1qYMjXIhhEXhw9X7OvC1aytfQYCNpNkt2M1eTX?=
 =?us-ascii?Q?ocgl+7+mqmHOidXJOz47Rcbn6CRfw4x79e53FN+1EZ7pCZ+O/yxp6J9gN+fG?=
 =?us-ascii?Q?ZbyYdJ/fMSUj71L40oS2qkycc+yrp1vI/xykYNuZXOsaTS152ZzuIeM4Epqp?=
 =?us-ascii?Q?vNzn3UGOyBvcRXuqnOqCq+YmT4YX18Od5WigAvtNeTP5XBdEd8pICl+3ugbS?=
 =?us-ascii?Q?vJUoJS+1721yCEIny/LLoRyjhe4FgMO/njEc5Tr+uFNHQViR8wCVgkatLgVu?=
 =?us-ascii?Q?/+VqBxunQlTn9MOpzLUrYFea+M2Ow4ZxpQ8h9AyZgMqj7jrlEgqYNisrN6Bx?=
 =?us-ascii?Q?yXfrfMEjthy8PKdXJC6eUDU2ATnEwWX56wPLCqj+BDB1Cwm1c3vvG43LQl8K?=
 =?us-ascii?Q?bAw1VhHGlffUcYdA3Np7L/9+6/vbWpmamOjdG0mAk4gwTKVLfmkxb/KOM6P4?=
 =?us-ascii?Q?U/H+bVbVtvChv/Qj3YA9xF310PI6Us6uAmfD7K6Q5f0pxlZUhPl21WA6m3Up?=
 =?us-ascii?Q?gX5+IacmOBlTbKcXr3zV/1znfTrqgNUeHFiML+gVzEJa6QD5RdaLH/EES+na?=
 =?us-ascii?Q?A4Clvp1ZK0xz4NzTXtZXPIuPCaj0/FzgZ62WCgM2bRW0mIeCKwr/uWfrB2++?=
 =?us-ascii?Q?3+e3PG3pvrMNQ1Nw9aIeirz6DVEyphErWFvCMOj61Dmu666yyAnr46d1CpCn?=
 =?us-ascii?Q?Tn3gDQxvCcGSVNW0FwktT9pvHh8be5ZWCg2n9FP4jHBu/XOXeJ7iI4kaiHGS?=
 =?us-ascii?Q?41DBjqAIx1Q=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MedODEzt/JXwHxODfY+KNXmGpRAykkUXfVJvWDgda82SeCQniSz2dOpXDYnR?=
 =?us-ascii?Q?4VTebzmD7E/W/4HsPOs61F4kPqiJKlNk8pPNtBJrOmFOQrLkT8buKKypXw8D?=
 =?us-ascii?Q?sMBDBDgd9fVKLmIp5uA01W9sw7TqUCNzkwqQcRh0lvpQLgn0fPBfz4RTmkKg?=
 =?us-ascii?Q?ToIlg37GeprIqSrRKFpyNx4va7rne4jBX+LV1mcDjbW9302bxAbn4nKh1jDd?=
 =?us-ascii?Q?/cq95NPgx8TOeZvY5rIO+xeDVeC1MuF3PC3MmcRdZPNecF8XHTcpRgR7dioi?=
 =?us-ascii?Q?I+lDkrukWwHZqTV1ZpMfp5q1deR7nXVeRrRzliI0pXl1IGTdZcctXllGvtt2?=
 =?us-ascii?Q?K4You27H67SCDSp2rssqBw68sUXJt7Mw1B5sXlFEMO+mBDF4YtufydsdjAZq?=
 =?us-ascii?Q?IeUU6VYVrt4Gy3XDpkQbuO0+zaRhsjg66w7GhRANidfzhjH2kzptr1M1V/uB?=
 =?us-ascii?Q?Iiu3abHoeMfPYndhQe29Pq5rFEEggkFbHXRgU0PA0D0hfl7WlVIZ95JivQ4q?=
 =?us-ascii?Q?PHEUHSBWXS3ltVdk+Xa7TuF0QLFs+TGGvx3i0yH5s7yEZ+os9RqjNUUzZVFJ?=
 =?us-ascii?Q?8wt+0PTOPOoW5G8nRgQ3Qn7oy8DzzVYDvdbnbgQNPhgYgfvvBd33XWr6T71O?=
 =?us-ascii?Q?118IHLvkoyCAoDEd+y4/8qGiafZa4Uqs4SaLULJjeHDuuKWVZvflrqolLlL3?=
 =?us-ascii?Q?t7i29/cjp8E0irAgSlF/z899S8Ek7NcPxPsWJPiQrjI6ElZ591bgcMWyAYR7?=
 =?us-ascii?Q?1p84PtEt+osRaxpoucTjS5z382y32kHJ8tOPXXB0IxQtVwLbheMhMjW9Nt7N?=
 =?us-ascii?Q?Wn7qSogPoRRNIpD5VCuIw5DQGe07ipuPCZ53QMsxDUQM6kS5PuP/evIp9pWf?=
 =?us-ascii?Q?k9BAtoyT02y6a5IT0+0IeyOEdobSczSfYIKnQ9MbTWhjncA0Fk20GHqFSq1P?=
 =?us-ascii?Q?2Jou2G0AhSzGnyDihLNgGmUN/HP4toYeCXjyW4DBTbT75FCQKJtRxIUIY7Wl?=
 =?us-ascii?Q?GbEUdrvXLideblZYFnNGjTu8l6Nq6+cNukW+muhch2+Pd8XGvjWoDCTO01Wl?=
 =?us-ascii?Q?Jq5sCQnhQ+aogbAlzCVO+uouzwsSCFbh6Ips5cKG4AowvbGZ8+uzvW9/Ab6P?=
 =?us-ascii?Q?B6cqq6oLKIXZmsLENyF5v1EVOPaKQVGiPwV2SD0D1kRWuqAOT3mV8HUQUDxy?=
 =?us-ascii?Q?4NHUYnAO6D58UVhBa46xuzlDs03HQUjz/DsYWgVQdEKAHEBYH4OepHxwuquy?=
 =?us-ascii?Q?wB5U8yXjHRp5fc+XXN8Ng0pkAFT5RWqeR2HYkGm9JMVXJKwOdehEEOjSWees?=
 =?us-ascii?Q?46mRwspZsSXk0mAKXhu5xjhLSTVz1pnd+GooD8zcebv/fcrB6uOo2/VkDX6T?=
 =?us-ascii?Q?JabCpX/vzQ01QOmIqQcgM0+OBAZFkesC3Z60EQHS49jJjClMTvQu8m0Bai9d?=
 =?us-ascii?Q?nrU1ce1Y0Jzaj80lpnFyrJi1bLZpP7jrpDDjn+cijg9dxKXhXoPa0XemI71+?=
 =?us-ascii?Q?ywpY/BZl/LrYwAK2uUgJJHaI2dH3jcWX5k6x35mwxw4VW07v1PSAuaKEjzf9?=
 =?us-ascii?Q?DCQLEgRak3h8q4ugS8hWgNavogxViZU3DTEfFJ0D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f62da59-ce1b-4b8e-65b2-08ddbef836af
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 14:52:23.7799
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CvXfqzQxgzrn0LUiFD96o2pqEfa2/5W4R6HM0LlOmfQyaiieHqf0yiZAemOxHpUM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6125

This brings the definitions up to PCI Express revision 5.0:

 * ACS I/O Request Blocking Enable
 * ACS DSP Memory Target Access Control
 * ACS USP Memory Target Access Control
 * ACS Unclaimed Request Redirect

Support for this entire grouping is advertised by the ACS Enhanced
Capability bit.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 include/uapi/linux/pci_regs.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/uapi/linux/pci_regs.h b/include/uapi/linux/pci_regs.h
index 6edffd31cd8e2c..79d8d317b3c17e 100644
--- a/include/uapi/linux/pci_regs.h
+++ b/include/uapi/linux/pci_regs.h
@@ -1004,8 +1004,16 @@
 #define  PCI_ACS_UF		0x0010	/* Upstream Forwarding */
 #define  PCI_ACS_EC		0x0020	/* P2P Egress Control */
 #define  PCI_ACS_DT		0x0040	/* Direct Translated P2P */
+#define  PCI_ACS_ENHANCED	0x0080  /* IORB, DSP_MT_xx, USP_MT_XX. Capability only */
+#define  PCI_ACS_EGRESS_CTL_SZ	GENMASK(15, 8) /* Egress Control Vector Size */
 #define PCI_ACS_EGRESS_BITS	0x05	/* ACS Egress Control Vector Size */
 #define PCI_ACS_CTRL		0x06	/* ACS Control Register */
+#define  PCI_ACS_IORB		0x0080  /* I/O Request Blocking */
+#define  PCI_ACS_DSP_MT_RB	0x0100  /* DSP Memory Target Access Control Request Blocking */
+#define  PCI_ACS_DSP_MT_RR	0x0200  /* DSP Memory Target Access Control Request Redirect */
+#define  PCI_ACS_USP_MT_RB	0x0400  /* USP Memory Target Access Control Request Blocking */
+#define  PCI_ACS_USP_MT_RR	0x0800  /* USP Memory Target Access Control Request Redirect */
+#define  PCI_ACS_UNCLAIMED_RR	0x1000  /* Unclaimed Request Redirect Control */
 #define PCI_ACS_EGRESS_CTL_V	0x08	/* ACS Egress Control Vector */
 
 /*
-- 
2.43.0


