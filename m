Return-Path: <kvm+bounces-51812-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F649AFD8B3
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 22:47:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 358533BB24F
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 20:47:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90E7A24169A;
	Tue,  8 Jul 2025 20:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="YoB5QyEL"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2071.outbound.protection.outlook.com [40.107.95.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13DF421CA0D;
	Tue,  8 Jul 2025 20:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752007643; cv=fail; b=Dn09JaWZJoGiFZrbzqWsRMrAlEveYoUrL3wT8mEq00i8OX78xhbzXOb+fRLdZW7g0REfU++hx/y69YYDk5bpO6Ho6S+1RnTWIZGUmDMnxkvg0AN3wtOJLrFYuy+dT5hqBAcd1WXchsGuLig2KXAzEuFMNdFVwnJczzeBtjSd0Uo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752007643; c=relaxed/simple;
	bh=K9jdRdWj3a6DqlOYnnuAvARVkAdS+cx8htYgTtevuTg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=tFu7Hgf/YkvpORYpUTOFVRwBrchdJq38pUFiOSDJVPVjFDjucpTRKAQRsnC1rOHU6t4w2TQRoRg3mFXK2l02c6Mm6ykULC2BOpIvm/yJ+muF8w/wX7QbT+/uhgRx3fXifdsSjGL9Ld0ZRvl0nFqNPlUN1/3h1UlXvjapk5lxxhg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=YoB5QyEL; arc=fail smtp.client-ip=40.107.95.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NrPmIkBhT5XevKp5zUgS3oHPHoO6gcASCMvM9kwwvNvpfn+8vLsVfzWD+deImo/O789PDJ4Bz5gnHW6qMvz0pSySNygEbdgYwdF0FvGihONI07rOfKd3XzXVbnTs8W00PRNFEpgQqRDdnfjvCOJfOctxXkVi8a0mCs8YB7Ua/TrZ057Kl+sG0cBhiWxTODrCBHsfBQb3AIXdPieHbI53Z/eNJNHxcZU5qXk9MuoRKughe6o58mX7cEXrkaa3V59egD4HrrCYewct6UtIgLXqRPCVWmzueUNrpZVwk+Db50ZM9Foe9uEbmEkDqLXxMyloreG2GB3gr8ojrY9Yq2GVnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XYti5GwnRDB/0DNqxvizMGN4PPesC2OZW+73qEpMWwY=;
 b=JpuScZCkXSz1YzvFuatPgVs+rCfdIjGCCyGEkHNDzBWz7VMGk+HYV6gJVOQTW/mGpfzesQlM5XXoJgW3AaAIg5cv9oh6wnCkSTpAkuxY2JpYtd5xrcN1ADnzaciKyoy/3708bzOj7iHZnLJPV8CLxcYNKUWMRkVyn+kehxbPIpxyXqLft0EuhdcA41OOuj6vwWtStjrQehJCtkVOQxmOn8DCtQEQN/0+ETYDkCSQgfJoSDwWGwodpNO6g4XTMcW/MsuchVCee66j6SsQppTA9nNtQ1E0BjUofRh9SVilkaRupu6y36NdJFq3L9IPj3P1zWadF63u8ughX5s+SHEdEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XYti5GwnRDB/0DNqxvizMGN4PPesC2OZW+73qEpMWwY=;
 b=YoB5QyELCo7pS9D8GcYA5C5vJnT+HGyBenDtA5R9iF295ih/L8SYXYfqCVN9lZ7iHmu+bkDnmsZDVabE+Shu7CkHNgrycVik4nJSBIZ1pXd3/ZAESlDWkgXJlvWkr6RnKVyjqjSRZ9eJsi+532qyxYRuePJCQFwhZLpuYdS4wmogvOj3zU+E4TxBYD3OQKCTejHEbxJsv7mMgn6Tj3BCeT9kXG5WHIdvgVEYiTTaTR6LlEkNhiwSZs8Eq0ySB9wXhS691WnRKwRpwUA1lFqxrMuFQEtN6m5r32o6IyVPy7ZU4CB8iH8ICGg8hvHDO+0k0k5QOOyOKYMwUHoS3TEr7A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by BY5PR12MB4100.namprd12.prod.outlook.com (2603:10b6:a03:200::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.28; Tue, 8 Jul
 2025 20:47:18 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8901.024; Tue, 8 Jul 2025
 20:47:17 +0000
Date: Tue, 8 Jul 2025 17:47:15 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>, linux-pci@vger.kernel.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Lu Baolu <baolu.lu@linux.intel.com>, galshalom@nvidia.com,
	Joerg Roedel <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>,
	kvm@vger.kernel.org, maorg@nvidia.com, patches@lists.linux.dev,
	tdave@nvidia.com, Tony Zhu <tony.zhu@intel.com>
Subject: Re: [PATCH 00/11] Fix incorrect iommu_groups with PCIe switches
Message-ID: <20250708204715.GA1599700@nvidia.com>
References: <0-v1-74184c5043c6+195-pcie_switch_groups_jgg@nvidia.com>
 <20250701154826.75a7aba6.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250701154826.75a7aba6.alex.williamson@redhat.com>
X-ClientProxiedBy: SN7PR04CA0080.namprd04.prod.outlook.com
 (2603:10b6:806:121::25) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|BY5PR12MB4100:EE_
X-MS-Office365-Filtering-Correlation-Id: 9dacd996-d0e5-441d-d233-08ddbe60a062
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1Uuk9X+76rYvlgq3r7/b/8KYnTStVxGZ6SmuyVXwV7bLDIUsWYTCZgnxLYTg?=
 =?us-ascii?Q?XfMf/MAPFqQMRO2f1o9PWsFpSUCDW8eoUneapaob9wA//6xuAO3JGzuNH5Yz?=
 =?us-ascii?Q?7U6x1WTmZq7jSSbjMhLQBjKL5Rchu0z+7rqvSUQG/ay8bep/Klr8QjBUkm/m?=
 =?us-ascii?Q?b+yZ+qQUG/UaA8stPs/mFF0lU/EjAbbQ38NBfDH32ODfM+AfJCzH4D+TvwrR?=
 =?us-ascii?Q?qTBOe0oVJJUg5vTqi+6ICRchxl4wIdaTIJao+T0Bs1q5I6C4i47cJT0LID1a?=
 =?us-ascii?Q?m3rof6xjWFr58RAOxhaZ3akB77FlygYIi0CGWz8IXQ7jy3NS8FzUKIId1qc9?=
 =?us-ascii?Q?0AWIolrw8g48ZtQ/CsIO+anAmp8oWzfANCGzLkSiYniMogTgPqMK10RPYdbA?=
 =?us-ascii?Q?nyoKWEw9z9JRDmts4fqyyMwbdGmJv78OceMxYMSo/aIqOgyCyvFUpu9ALp7h?=
 =?us-ascii?Q?Jjbro5PnGkdyQTHXZj1dc3aRrkhDQSYeGnwreGjnlOdoEt0OTV6VLqKHci5h?=
 =?us-ascii?Q?k4hsvrddf5x7aj/ZLdikziFFQiKauhKIvmTQi1XoPS1IGDvimbjI9R3OT2My?=
 =?us-ascii?Q?goBXTB8Oyt7V1/Z0U/LnOOk3LoyYL/XOJUoC9UkNefKgXHjGVuMC7aPK58V3?=
 =?us-ascii?Q?6tQa10wU0/m03wYDzh4TjsOlgCL9B+VLsRT+XNw6HYHTzbqby8V1iDI4tGZK?=
 =?us-ascii?Q?Wq2eZrt6exc5EExyPgHOEVMAYhvNyWsJo/YoUnjanAj1MpAQxBKWm7xy7wX1?=
 =?us-ascii?Q?TY0ITVHvvy7UOR06KWCYzjkO3irVAGB1TCic1+PR1aAQB0rukuIisX5CJWLl?=
 =?us-ascii?Q?Uki+4phmWIuK6oeP5e12N31hxm/jW6HGNrZaJPhr88cRGRQTsK84QrZV2N/v?=
 =?us-ascii?Q?jBGq1cC/S4IlnJCgmmchZ5XziyMGyIlso0NQl8YLT9lR5hIuf9qVjsF7qwrW?=
 =?us-ascii?Q?gXbf6GlBYn2OeVcJo+baWKEOWqpjdbrYo2JyZqg0kUFwGhDfLhmVZDWzUBif?=
 =?us-ascii?Q?rvEqG2YdyTGubjFWpkGRaCq6WMPij2J6EnBLPHBWeBhYX/tgbOTpdhnokvP8?=
 =?us-ascii?Q?Ycb2YkA9vrPZmjSN0sZfTQTKcLJWUo8gamW0qcqUz0Vm5zJLtJwwSobz01ns?=
 =?us-ascii?Q?8m9P7C/FkTIacfTYNAre0r58/riXgvW52gWhO6eYsSnKsvbNX8jCF2ylCXi2?=
 =?us-ascii?Q?S4HVEKKhRYL5K+yMH/vSRPLfLA4irjKf/TRzl0968tPQ9LVVResXHn/HtiUF?=
 =?us-ascii?Q?oxtSI9ygJB2RftbrvYv3PML+DTcQcgqX25kT08q92SXvpCqSJlTAgn+fpZh4?=
 =?us-ascii?Q?1/CSX204xT/823pSunoi/2jg4m1t0rHQ3nhvN5FHPABU7jVewJNOJ/8TtWCD?=
 =?us-ascii?Q?fyQcHZDhdtvqjPAfxa2x/1CT7mvArwPb6ITHaU5ZempPH/K3bg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?tWbFVgV9LIGFmpbW5vhweIm11flusj4BEA1cnQDUUI5grE0GbTEwEXLZQZQu?=
 =?us-ascii?Q?iPt7KGwkGjMVqz1GgzXIEDi5oF2ZNKJ6RC4gSo4qFaL9uwysEQ3V2J8KSquz?=
 =?us-ascii?Q?xiMVe0pPgIrVVlVTclW7vzqA9bKSGbH0FjvGyzopjvsQ+w8w2sjyqmfFVlED?=
 =?us-ascii?Q?z1YNQ02geWUBJ4+gtucDQNIGxfwfBO5q/oi5evy0up7BA4QGTAop6ZaomVvW?=
 =?us-ascii?Q?5QeHvIb9qjRzHwZ2BWn/Vdx51Vg/L3QF0L2xIBrSwQKsXlgrfKGBoqHPt2os?=
 =?us-ascii?Q?enH/6+Z1DKJngTRTuL98HSTS1K2Hq+/teJOe6EqfUyiNON0+RDx6UI0LJHbQ?=
 =?us-ascii?Q?CpCQy86bijHd8B9CcfchTkG7C7WRZ+ejxofNUS1CgGAOGy+8+z/dx3dlTU5k?=
 =?us-ascii?Q?JxVUfocbnJTTv07sjQqjaRo/zB9e4Txvgz6ouh3LYdjxQxf5y78ZSbjLP/uz?=
 =?us-ascii?Q?XD9jKA4Q2uodWmlHobGikWdpC+2JhhLC3kT4TMp4PBTWGmL3DQQxKf+Sr5RX?=
 =?us-ascii?Q?a7d0x5uhKoVmJ2NTgXBXYN5GvEgHrwk61wzOMFzhOGWXrnnrPwwc8cx8bfJo?=
 =?us-ascii?Q?M0puqNsJE4tah84YeaxdYDSDM/60oK7p6lzJlk+xaVb5n9BSliKbbpgqnLB1?=
 =?us-ascii?Q?1v8Kz1dZVIylzPvvPALibgP/8PkWWTXfKyUEl2nIqs0Wa/NLWfte46lQGbD9?=
 =?us-ascii?Q?CKh83Ie5Nywioeuz9HNvktkV3stVg30PzsKXxo4TcIKdQm1NLSGabfSNXVhU?=
 =?us-ascii?Q?mHlpG4gvkcHeO96IswNBYHHm1B4rwUQpEH1SdO66N66C3s5uV/Rek/xwjkap?=
 =?us-ascii?Q?yZuwy6Bkll9xXF7poTnFk8CCjrejNbQNTxoK0tIOpzesAmbq7u0ma5NguWYY?=
 =?us-ascii?Q?gpeb+WuyD+vft78Gt4POlPXeCPsJdqdB8UfzI++qjSvWL4rMI+pNob7T3rgG?=
 =?us-ascii?Q?KfPSfmo9ziwa022wv4omy4X/rm/bcjmwPO9f0JYQ+3nGsGrMc/E4Nd9jqNYL?=
 =?us-ascii?Q?H/POCPxXoq47a3yrfQJKv0Z3owvteaHimZgYh8Ua+E2T6+aq1FLOnR9pcAhy?=
 =?us-ascii?Q?ewl+DYApNUUygPiLAV22dDSR0LRCUDt1z9Ky++8Ad/Zi99+jlp3WmgPcagma?=
 =?us-ascii?Q?KjTIkNcAUesB+j+dIUngh3Wlurb4DxreXy6GleyiN1MpO9boPil/B4r6zH7Q?=
 =?us-ascii?Q?Guz/0P0qudqEjjsicL6F3NIzbXlUf74oRBNGLyTV4cEKf/Gn7TBFBvSgeB8C?=
 =?us-ascii?Q?zEFEu5seYOxejo2dg+HDD9hHJLEbHXn3HJQ5xXSV2NroXzinUNLwBHhTsRNs?=
 =?us-ascii?Q?cUtJY/v0sPce/CMILsvezUE1WnLQYLURBnFn7RFlDIzt1uISAIsbBmFph80h?=
 =?us-ascii?Q?BvzTbbEGbnDRN4jv6Ypz1QNlpgrukRGEC5OTBwqPWJlyXPyesGXnBHgREqDF?=
 =?us-ascii?Q?toxh3KFRbmEjHxfI7NO0fxcZW8PkYZAuNSQxnYkECTF5ff/X9p5I0gEhM86Y?=
 =?us-ascii?Q?DaLYtC1lgfznrRNTwbj7XEQxLVuXIF8fJRgBinriOywkfmR4yhNAqoZYNHE/?=
 =?us-ascii?Q?PZKPPwYXd7KiyRNNge/Cnv6N6vtNlv2mRAnJ/v96?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9dacd996-d0e5-441d-d233-08ddbe60a062
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2025 20:47:17.6146
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QtOTYXnOGIws2HVsSW/hi06REMndN/brZBeRe9PPRxr6zNMeht9UDG6kvsJzppLK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4100

On Tue, Jul 01, 2025 at 03:48:26PM -0600, Alex Williamson wrote:

> Notably, each case where there's a dummy host bridge followed by some
> number of additional functions (ie. 01.0, 02.0, 03.0, 08.0), that dummy
> host bridge is tainting the function isolation and merging the group.
> For instance each of these were previously a separate group and are now
> combined into one group.

I was able to run some testing on a Milan system that seems similar.

It has the weird "Dummy Host Bridge" MFD. I fixed it with this:

/*
 * For some reason AMD likes to put "dummy functions" in their PCI hierarchy as
 * part of a multi function device. These are notable because they can't do
 * anything. No BARs and no downstream bus. Since they cannot accept P2P or
 * initiate any MMIO we consider them to be isolated from the rest of MFD. Since
 * they often accompany a real PCI bridge with downstream devices it is
 * important that the MFD be isolated. Annoyingly there is no ACS capability
 * reported we have to special case it.
 */
static bool pci_dummy_function(struct pci_dev *pdev)
{
	if (pdev->class >> 8 == PCI_CLASS_BRIDGE_HOST && !pci_has_mmio(pdev))
		return true;
	return false;
}

This AMD system has second weirdness:

40:01.1 PCI bridge: Advanced Micro Devices, Inc. [AMD] Starship/Matisse GPP Bridge (prog-if 00 [Normal decode])
        Capabilities: [2a0 v1] Access Control Services
                ACSCap: SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCtrl- DirectTrans+
                ACSCtl: SrcValid- TransBlk- ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCtrl- DirectTrans-
40:01.2 PCI bridge: Advanced Micro Devices, Inc. [AMD] Starship/Matisse GPP Bridge (prog-if 00 [Normal decode])
        Capabilities: [2a0 v1] Access Control Services
                ACSCap: SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCtrl- DirectTrans+
                ACSCtl: SrcValid- TransBlk- ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCtrl- DirectTrans-
40:01.3 PCI bridge: Advanced Micro Devices, Inc. [AMD] Starship/Matisse GPP Bridge (prog-if 00 [Normal decode])
        Capabilities: [2a0 v1] Access Control Services
                ACSCap: SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCtrl- DirectTrans+
                ACSCtl: SrcValid+ TransBlk- ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCtrl- DirectTrans-

Notice the SrcValid- 

The kernel definately set SrcValid+, the device stored it, and it
never set SrcValid-, yet somehow it got changed:

[    0.483828] pci 0000:40:01.1: pci_enable_acs:1089
[    0.483828] pci 0000:40:01.1: pci_write_config_word:604 9 678 = 1d
[    0.483831] pci 0000:40:01.1: ACS Set to 1d, readback=1d
[..]
[    0.826514] pci 0000:40:01.1: __pci_device_group:1635 Starting
[    0.826517] pci 0000:40:01.1: pci_acs_flags_enabled:3668   ctrl=1c acs_flags=1d cap=5f

I instrumented pci_write_config_word() and it isn't being called a
second time. I didn't try to narrow this down, too weird. Guessing
ACPI or FW?

So the new logic puts all the above and the downstream into group due
to insuffucient isolation which is the only degredation on this
system, the LOM ethernet gets grouped together with the above MFD.

Given in this case we explicitly have ACS flags we consider
non-isolated I'm not sure there is anything to be done about it.

Which raises a question if SrcValid should be part of grouping or not,
it is more of a security enhancement, it doesn't permit/deny P2P
between devices?

> The endpoints result in equivalent grouping, but this is a case where I
> don't understand how we have non-isolated functions yet isolated
> subordinate buses.

And I fixed this too, as above is showing, by marking the group of the
MFD as non-isolated, thus forcing it to propogate downstream.

> An Alder Lake system shows something similar:

I also tested a bunch of Intel client systems. Some with an ACS quirk
and one with the VMD/non transparent bridge setup. Those had no
grouping changes, but no raptor lake in this group.

> # lspci -vvvs 1c. | grep -e ^0 -e "Access Control Services"
> 00:1c.0 PCI bridge: Intel Corporation Raptor Lake PCI Express Root Port #1 (rev 11) (prog-if 00 [Normal decode])
> 00:1c.1 PCI bridge: Intel Corporation Device 7a39 (rev 11) (prog-if 00 [Normal decode])
> 	Capabilities: [220 v1] Access Control Services
> 00:1c.2 PCI bridge: Intel Corporation Raptor Point-S PCH - PCI Express Root Port 3 (rev 11) (prog-if 00 [Normal decode])
> 	Capabilities: [220 v1] Access Control Services
> 00:1c.3 PCI bridge: Intel Corporation Raptor Lake PCI Express Root Port #4 (rev 11) (prog-if 00 [Normal decode])
> 	Capabilities: [220 v1] Access Control Services
> 
> So again the group is tainted by a device that cannot generate DMA, 

It looks like 00:1c.0 is advertised as a root port, so it can generate
DMA as part of its root port function bridging to something outside
the root complex.

This system doesn't seem to have anything downstream of that root port
(currently plugged in?), but IMHO that port should have ACS. By spec I
think it is correct to assume that without ACS traffic from downstream
of the root port would be able to follow the internal loopback of the
MFD.

This will probably need a quirk, and it is different from the AMD case
which used a host bridge..

Any other idea?

Jason

