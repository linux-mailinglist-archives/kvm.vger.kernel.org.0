Return-Path: <kvm+bounces-51118-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B4F70AEEA46
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 00:30:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 964F07AD6E1
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 22:28:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F9442EBB9C;
	Mon, 30 Jun 2025 22:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="NtSn0saT"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2054.outbound.protection.outlook.com [40.107.220.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B57352EAB63;
	Mon, 30 Jun 2025 22:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751322531; cv=fail; b=YSa+F085/LvjEotKzw5cyP4EoJ2V7ioyn2YiZJLBt2tQWwT9NdcNeuTX0rFQC1nLXZUWJLKKknzCh6h+jFa6KAI/HpqRUjOBtPaPbKz30Glyshr8a3juH1Pt0hGPXRRkI0Y1MXyjBw3DyuWsDxdMGCbWymFGMhDVsRQBvV6FONU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751322531; c=relaxed/simple;
	bh=T5leVHv3UYvAn5b22jKN952LhaSxawp6tjblVniQ4sM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=SyhG1NLDxuA9mxCFCa3bo47QLWdzOwXTZqBlQWFnq9clIYm+QtKdZnFwOTWSrMDIuQuaZAIgmYZX0VPP0iBcRYuYXHe2kmfVfnMAmTneK2GnqEInC1ROLxC6Bz3d7JQTVV7r5xzjxZ/YAnhNVEFdUjITzKICm+oeNcWNxg9nED8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=NtSn0saT; arc=fail smtp.client-ip=40.107.220.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p7m+4X+HRuGQXk0YKNtAoGo0erpWttY/GhpXDsi52N9/QugMnLX1273QMTYRcDdR23QP0d/rjTJhghJy8f96UEIiqR8c6EZupUlVmCWZYKgLaJsxV24NIC3MfojW5+TQ0Po7pKSaEW/PV7wGFH72hU727Qu0ZvecQjtaXyYG+CBVBnzAbCLxG8aE7J9Gnf9jQe+CjSJ3I32ce3gCUVLxZWOFYMlwK7uJlgjrun0v7ujqWmlMlGz0lmCUB7XopyT0aZlktR/TTDJUSEebCbpMXFuLjQ3AJ0jEDkSDhX1NpIerJqsiP5IUR4dFjQxHdVM/jS/N5dSTvR5vuvLMgCv90A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jzUyEWLo8P817DEm9VtyDgKJwu1xXBN6eCu0q/Qz2eY=;
 b=C+v6EnIEJyVg9nvsOPNfiQ+ZmrjolyFvyzv4qOI+Z1zmmHaVJooqzpNt2TQlU+kt1BfESshUBdz7EQDAmAUU7KWyYPyOlBTWDhhwlfVXhhkGWEVexVOVFDKoSmf03UZpq3ozzvoDIcGRhaKRAVUykYglJ8bvP9tdvdy8ecmcxoMbg2bMmwr9AxRuitDp7Xk6oQUNFFlEx2W+iVAdpFBJNufQutB1AtfUAmjeulgdEsf6SWj+noXSvYHM9WQpniVnAZB5taUx2lMJHhoHNQA6jb3uVpoTS2Fu/3zR2lh08jnyvfrW/W0bYCjYOQVGj6znFwsG/DI0owDUiA+fQvco5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jzUyEWLo8P817DEm9VtyDgKJwu1xXBN6eCu0q/Qz2eY=;
 b=NtSn0saTxEBDFqQZycSIptIxmipgMN/0vHDuFxqQsUsOGN2EiRRIdF3Sg1JTLhtDNhjPwhESIVbF/PFNf6/0fV3UZRJTetu7t7m1hqm4+dBLIkPyqL1Cr+3Y+QTRaTNZA2oM/1LWTYgDGb3Pf6UB/g8mAwxRCQtZ0gYxFMsCfFR07nEe/PD7ipwf9MQZvnTjZQBR1faIzXgdcKcLa/73A4AVia6J4JGkifn+zJifueoiATjzh/IHmyPGEAHWIJ/CvVaGJCTJDtwZxYXsTPh6YGzhoFWSiW9gAUOFUO9EHuz3aRVyFCNNOenDVFWAIQN99eh7PCmf6kXMThBhUUyY1A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by BN7PPF48E601ED5.namprd12.prod.outlook.com (2603:10b6:40f:fc02::6ce) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.29; Mon, 30 Jun
 2025 22:28:45 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8880.030; Mon, 30 Jun 2025
 22:28:45 +0000
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
Subject: [PATCH 02/11] PCI: Add pci_bus_isolation()
Date: Mon, 30 Jun 2025 19:28:32 -0300
Message-ID: <2-v1-74184c5043c6+195-pcie_switch_groups_jgg@nvidia.com>
In-Reply-To: <0-v1-74184c5043c6+195-pcie_switch_groups_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR20CA0018.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::31) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|BN7PPF48E601ED5:EE_
X-MS-Office365-Filtering-Correlation-Id: 17bcabd6-1de2-436e-3fd5-08ddb82578d2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?e593TLpbO6l1jVq3oFDCRXh4gt5xoemJ5gaj1MCwkyV4o9HmOCGgFHJ5UrKB?=
 =?us-ascii?Q?qn5WsgfixAmavsYUsbNkdPYDnE8KbWCJXkF5qWZG+KPs+Fw59u92uztRvD3e?=
 =?us-ascii?Q?kXLrFiqN+4LQXc5GDsQekD9/QUmSN7xP8gbXPanefAfZ8GECb1Plb04TGn2g?=
 =?us-ascii?Q?OSWmPTBxalMFnBiqzReqXkOIyQ/CzdGAMJDLlkNiB4lbl7RjFX6yAxVvmCv/?=
 =?us-ascii?Q?ZEw2d5VeK9djYenziaz127Dmjpk5eiScsz7/Dhg6myosABUKW/igPsTXPNV9?=
 =?us-ascii?Q?kozspXHrIvepuyoB2QkxNIJfPmUbiQjxEc2l6Gr3uyeL1zs0ZMyRH0WVllfk?=
 =?us-ascii?Q?N95y+kvXT9u5XHzEVGUSxjST31rHskv0N/8eCOva5ilMvzywhiI9LrYInzaJ?=
 =?us-ascii?Q?6Tm6rlJKQP3neOjhZgls1Sj/zWZuqu6U5WeYWyJPNpu3L0yVGpusuu++Y3NS?=
 =?us-ascii?Q?VSy+qX4rhPm3cjHCja4ivEs93hhI/Q3iR318iHKQAP711lfRtcH4n5u4DAhW?=
 =?us-ascii?Q?0r71GnwXfs+syTexsT6ufC0mKA5aRqtXXcFQF2008cDiS9C0cocpX/nxfnaB?=
 =?us-ascii?Q?o4444vZkCZdZNKRDRNX3JYEyv0Eb/oS3d1/shn+WgwrJz++eh8SBNyL1YLEH?=
 =?us-ascii?Q?GgILT8rQ5jR/ZBf1L9U/wPLNCzh+fppXx5SfDlC7yYlKhOyfRzDW0kbgpCIr?=
 =?us-ascii?Q?cSwGqMsLBsCXqUet89xdw6aTvaFAV6dhOA7h7uoiJ3ISYFNWrz7lr9YfK4Pp?=
 =?us-ascii?Q?GhsyDBSFCeF4+Z4bWuVuRGEKmuhUzt8yoGPFjsZRJtOiGeIqa1McF16xmyma?=
 =?us-ascii?Q?9nTfkbMkH7rx42CrTU4HafSvQ9s3vx75S9mbGEBBtVHBQyFNGh/53grU4rak?=
 =?us-ascii?Q?SnV4GkePBXK/Go8z8P0wX/CuJnXn7vfzjelj4fkGFP2ScWDX35rmvyLhz/HW?=
 =?us-ascii?Q?ZEPAk6PnTqqs8KSIUkI7Hdp3GqEiYEUuklJOuJ10W0I5XB0u3mQLeqiXrHBP?=
 =?us-ascii?Q?wBq6ZoLg/UBRG4G9epnYHrTS+x5Hc0C5FKmejQaM9F8F8no1BmDX9ZtpiLym?=
 =?us-ascii?Q?ZDX0COatArQ9bWoFNJGinAxFitgtR+Ajd4dYE06RB2gOXWUNnuWMXyDhOKbN?=
 =?us-ascii?Q?yAYU4Ht2P5muatM4RGzeFU810/0HeANJaslstJjJHOPX/bK7eY6eP/oa71aN?=
 =?us-ascii?Q?ZymZemb8Q7LtyDhvpG5I8USWO/qeilEMrDV3yPIH2+4ojJsGZSTlOWDvtOnS?=
 =?us-ascii?Q?WjfasQf+H8cxTv3aPu8Ol2EgyEWd0eS7svq5jAUu9AORO6/lipKO7H6UeVz1?=
 =?us-ascii?Q?DdCLDmQ0AaA/qoZ4XJMEktmqbiGb02OxOpF3tUc2FX2hc+VcRplVItQwd2FX?=
 =?us-ascii?Q?lof20Ev/rUojx+DecNNAGBsyaRIajwXv/HD4cIlGAp0lTLXHWtoALHAIIrgE?=
 =?us-ascii?Q?tr5lx5jU/4U=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9BJAzK1CAz0UQJJ562Idi/2i51ATYjh29UyI5r1pXd4aHi0edr394RinBhce?=
 =?us-ascii?Q?yaPeZFjax/PthmvFZ7bQ7nIQ8B709Tz5JDlBN2KJNuXX8UY1qKM53vLezcFV?=
 =?us-ascii?Q?EZuavnG2PlF43XNYVkhWaksTdz2D0ZawqczX0MBWX8AlIgUwUlchG6MKT6H5?=
 =?us-ascii?Q?KPlGnkOvdnGtcrOSmZOB1b5M0Idq5PBP1R3YYzTmv5UWNktHoyZ7x8sUe9pt?=
 =?us-ascii?Q?651ZtOx7jkWgBgFpJ0F4W0AiOwuc3hv12mvVcm7FhTAly4Zg6a4zNHcSnSTc?=
 =?us-ascii?Q?YWpnjD92uXADKFmrAXxXjgQNKr59ZwGaP3jamh5+EUYgKr0rwg6Vie7ewbIA?=
 =?us-ascii?Q?TJaomnrT9UkGPn2uJfuV6ywPNyaVDGZu5wrERAw2a/4EoYHEApGkG/RqeJAF?=
 =?us-ascii?Q?grnPP9KVC5t3weXTLGCUrS19aAN6UBp0WlaZLgalB50nItHm2XQBdSTD3bze?=
 =?us-ascii?Q?fHWU3hHywsKBzFTU4Ut4KJ6tZj3YEuyESgmELSDo0SH05SskX20BIz6NUhqJ?=
 =?us-ascii?Q?GL90KETU5akBAynDP+KJTp9nGZbQ1cVRtc5DICK1aWkry9sA/98NmdEX6tXM?=
 =?us-ascii?Q?XfPuM5a+gLDtXsZGIFgWUoB47eR7BN+scx/we2Q6WsgL6IMTpB9gr5cKFhg6?=
 =?us-ascii?Q?BI4OllBayDMGCXEPZW0AX6/HoyhTRjOWxG9+OqfywN2lyz7la7YGrwXHJA7p?=
 =?us-ascii?Q?5PFbLgJK7hQQDvmIzWXIxbQ1sjNeIF6/QBzXwdC17iGcNzJ1wyt1KLVJIaho?=
 =?us-ascii?Q?DwT8Q7YnIDZQlp6U/s9SLJ31b0vWairNqRDlyGPzQAC9vIcDM0T7yCRkalI2?=
 =?us-ascii?Q?ya2N9XzxXEeXjVWBqnUS/6y9ukAH5XptG25yYDxkMS9U2aVexhsxyEGzqp3t?=
 =?us-ascii?Q?ePrngKt99wgdErNkHPUoAJAEEN78rsZuxcrHVn/5VgFFH3k0W84RI8oMWG82?=
 =?us-ascii?Q?B1gdviTBjznZA/7LNGktXiAbX/YE94U2XXeK5e/WzIWiA24cU4JUxjscARlA?=
 =?us-ascii?Q?qqB0OXj869wpR9fGxxz5/1mezCB3xZ8byuwS6k0ZioNu8KkO284whydhgI9D?=
 =?us-ascii?Q?GRJYjSGCGeUQMilAg9MGlN8m0BTlWnVNvm/QZzxM35qYAEigqJcCNnBK//pY?=
 =?us-ascii?Q?BCZln8rrWrJGHQSNOEZWoWgMQfMw5hioVE9o8mtL9eIXVfwzl5DGoy7JxXzG?=
 =?us-ascii?Q?pkWwYs8fLVOyLMSe0941+j2q9On9VfKn7EUEDY/4yRUBNAkZr6zdA42c6K7c?=
 =?us-ascii?Q?9TMYb02wtJ2tYeM9jrcT8vAZ31IuYtLTTz7XIRNIzR54XQguc7GgxxlJKbSX?=
 =?us-ascii?Q?CDbjygfjat4H2kdvlc8oPjcLi23ElO0aaspzMH5TV0ZKdd5dRuX+WeRhdAcI?=
 =?us-ascii?Q?NGhisriftBmBGpR51qcn2c9jM7k9aitj330YP9YPf4GGDPjyPPO6pv3v1C/h?=
 =?us-ascii?Q?t7KinSIuQdxL3+uYZNmd3lKUmR4iy9qr3zXlq1BbHdk83CGgPRNVHfJ7AbqA?=
 =?us-ascii?Q?ULRwHNqX4CmhaNZDFJ+f0/xl3ctQVQbshIdMwEz9XcTvxZDqVqSAjLiz16AS?=
 =?us-ascii?Q?JIkJFNYhQsYQ5XZcigQVKXuBoRNQ0pqtnib9/EU6?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17bcabd6-1de2-436e-3fd5-08ddb82578d2
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2025 22:28:44.2910
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YfDox7SIj//oMUApF5+Lb1xs/zWq4WbrCJt09SadcxFTuXrpwaL3uREvA1v74rml
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PPF48E601ED5

Prepare to move the calculation of the bus P2P isolation out of the iommu
code and into the PCI core. This allows using the faster list iteration
under the pci_bus_sem, and the code has a kinship with the logic in
pci_for_each_dma_alias().

Bus isolation is the concept that drives the iommu_groups for the purposes
of VFIO. Stated simply, if device A can send traffic to device B then they
must be in the same group.

Only PCIe provides isolation. The multi-drop electrical topology in
classical PCI allows any bus member to claim the transaction.

In PCIe isolation comes out of ACS. If a PCIe Switch and Root Complex has
ACS flags that prevent peer to peer traffic and funnel all operations to
the IOMMU then devices can be isolated.

If a multi-function devices has ACS flags preventing self loop back then
that device is isolated, though pci_bus_isolation() does not deal with
devices.

As a property of a bus, there are several positive cases:

 - The point to point "bus" on a physical PCIe link is isolated if the
   bridge/root device has something preventing self-access to its own
   MMIO.

 - A Root Port is usually isolated

 - A PCIe switch can be isolated if all it's Down Stream Ports have good
   ACS flags

pci_bus_isolation() implements these rules and returns an enum indicating
the level of isolation the bus has, with five possibilies:

 PCIE_ISOLATED: Traffic on this PCIE bus can not do any P2P.

 PCIE_SWITCH_DSP_NON_ISOLATED: The bus is the internal bus of a PCIE
     switch and the USP is isolated but the DSPs are not.

 PCIE_NON_ISOLATED: The PCIe bus has no isolation between the bridge or
     any downstream devices.

 PCI_BUS_NON_ISOLATED: It is a PCI/PCI-X but the bridge is PCIe, has no
     aliases and is isolated.

 PCI_BRIDGE_NON_ISOLATED: It is a PCI/PCI-X bus and has no isolation, the
     bridge is part of the group.

The calculation is done per-bus, so it is possible for a transactions from
a PCI device to travel through different bus isolation types on its way
upstream. PCIE_SWITCH_DSP_NON_ISOLATED/PCI_BUS_NON_ISOLATED and
PCIE_NON_ISOLATED/PCI_BRIDGE_NON_ISOLATED are the same for the purposes of
creating iommu groups. The distinction between PCIe and PCI allows for
easier understanding and debugging as to why the groups are choosen.

For the iommu groups if all busses on the upstream path are PCIE_ISOLATED
then the end device has a chance to have a single-device iommu_group. Once
any non-isolated bus segment is found that bus segment will have an
iommu_group that captures all downstream devices, and sometimes the
upstream bridge.

pci_bus_isolation() is principally about isolation, but there is an
overlap with grouping requirements for legacy PCI aliasing. For purely
legacy PCI environments pci_bus_isolation() returns
PCI_BRIDGE_NON_ISOLATED for everything and all devices within a hierarchy
are in one group. No need to worry about bridge aliasing.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/pci/search.c | 150 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/pci.h  |  31 +++++++++
 2 files changed, 181 insertions(+)

diff --git a/drivers/pci/search.c b/drivers/pci/search.c
index 53840634fbfc2b..540a503b499e3f 100644
--- a/drivers/pci/search.c
+++ b/drivers/pci/search.c
@@ -113,6 +113,156 @@ int pci_for_each_dma_alias(struct pci_dev *pdev,
 	return ret;
 }
 
+static enum pci_bus_isolation pcie_switch_isolated(struct pci_bus *bus)
+{
+	struct pci_dev *pdev;
+
+	/*
+	 * Within a PCIe switch we have an interior bus that has the Upstream
+	 * port as the bridge and a set of Downstream port bridging to the
+	 * egress ports.
+	 *
+	 * Each DSP has an ACS setting which controls where its traffic is
+	 * permitted to go. Any DSP with a permissive ACS setting can send
+	 * traffic flowing upstream back downstream through another DSP.
+	 *
+	 * Thus any non-permissive DSP spoils the whole bus.
+	 */
+	guard(rwsem_read)(&pci_bus_sem);
+	list_for_each_entry(pdev, &bus->devices, bus_list) {
+		/* Don't understand what this is, be conservative */
+		if (!pci_is_pcie(pdev) ||
+		    pci_pcie_type(pdev) != PCI_EXP_TYPE_DOWNSTREAM ||
+		    pdev->dma_alias_mask)
+			return PCIE_NON_ISOLATED;
+
+		if (!pci_acs_enabled(pdev, PCI_ACS_ISOLATED))
+			return PCIE_SWITCH_DSP_NON_ISOLATED;
+	}
+	return PCIE_ISOLATED;
+}
+
+static bool pci_has_mmio(struct pci_dev *pdev)
+{
+	unsigned int i;
+
+	for (i = 0; i <= PCI_ROM_RESOURCE; i++) {
+		struct resource *res = pci_resource_n(pdev, i);
+
+		if (resource_size(res) && resource_type(res) == IORESOURCE_MEM)
+			return true;
+	}
+	return false;
+}
+
+/**
+ * pci_bus_isolated - Determine how isolated connected devices are
+ * @bus: The bus to check
+ *
+ * Isolation is the ability of devices to talk to each other. Full isolation
+ * means that a device can only communicate with the IOMMU and can not do peer
+ * to peer within the fabric.
+ *
+ * We consider isolation on a bus by bus basis. If the bus will permit a
+ * transaction originated downstream to complete on anything other than the
+ * IOMMU then the bus is not isolated.
+ *
+ * Non-isolation includes all the downstream devices on this bus, and it may
+ * include the upstream bridge or port that is creating this bus.
+ *
+ * The various cases are returned in an enum.
+ *
+ * Broadly speaking this function evaluates the ACS settings in a PCI switch to
+ * determine if a PCI switch is configured to have full isolation.
+ *
+ * Old PCI/PCI-X busses cannot have isolation due to their physical properties,
+ * but they do have some aliasing properties that effect group creation.
+ *
+ * pci_bus_isolated() does not consider loopback internal to devices, like
+ * multi-function devices performing a self-loopback. The caller must check
+ * this separately. It does not considering alasing within the bus.
+ *
+ * It does not currently support the ACS P2P Egress Control Vector, Linux does
+ * not yet have any way to enable this feature. EC will create subsets of the
+ * bus that are isolated from other subsets.
+ */
+enum pci_bus_isolation pci_bus_isolated(struct pci_bus *bus)
+{
+	struct pci_dev *bridge = bus->self;
+	int type;
+
+	/* Consider virtual busses isolated */
+	if (!bridge)
+		return PCIE_ISOLATED;
+	if (pci_is_root_bus(bus))
+		return PCIE_ISOLATED;
+
+	/*
+	 * The bridge is not a PCIe bridge therefore this bus is PCI/PCI-X.
+	 *
+	 * PCI does not have anything like ACS. Any down stream device can bus
+	 * master an address that any other downstream device can claim. No
+	 * isolation is possible.
+	 */
+	if (!pci_is_pcie(bridge)) {
+		if (bridge->dev_flags & PCI_DEV_FLAG_PCIE_BRIDGE_ALIAS)
+			type = PCI_EXP_TYPE_PCI_BRIDGE;
+		else
+			return PCI_BRIDGE_NON_ISOLATED;
+	} else {
+		type = pci_pcie_type(bridge);
+	}
+
+	switch (type) {
+	/*
+	 * Since PCIe links are point to point root and downstream ports are
+	 * isolated if their own MMIO cannot be reached.
+	 */
+	case PCI_EXP_TYPE_ROOT_PORT:
+	case PCI_EXP_TYPE_DOWNSTREAM:
+		if (!pci_acs_enabled(bridge, PCI_ACS_ISOLATED))
+			return PCIE_NON_ISOLATED;
+		return PCIE_ISOLATED;
+
+	/*
+	 * bus is the interior bus of a PCI-E switch where ACS rules apply.
+	 */
+	case PCI_EXP_TYPE_UPSTREAM:
+		return pcie_switch_isolated(bus);
+
+	/*
+	 * PCIe to PCI/PCI-X - this bus is PCI.
+	 */
+	case PCI_EXP_TYPE_PCI_BRIDGE:
+		/*
+		 * A PCIe express bridge will use the subordinate bus number
+		 * with a 0 devfn as the RID in some cases. This causes all
+		 * subordinate devfns to alias with 0, which is the same
+		 * grouping as PCI_BUS_NON_ISOLATED. The RID of the bridge
+		 * itself is only used by the bridge.
+		 *
+		 * However, if the bridge has MMIO then we will assume the MMIO
+		 * is not isolated due to no ACS controls on this bridge type.
+		 */
+		if (pci_has_mmio(bridge))
+			return PCI_BRIDGE_NON_ISOLATED;
+		return PCI_BUS_NON_ISOLATED;
+
+	/*
+	 * PCI/PCI-X to PCIe - this bus is PCIe. We already know there must be a
+	 * PCI bus upstream of this bus, so just return non-isolated. If
+	 * upstream is PCI-X the PCIe RID should be preserved, but for PCI the
+	 * RID will be lost.
+	 */
+	case PCI_EXP_TYPE_PCIE_BRIDGE:
+		return PCI_BRIDGE_NON_ISOLATED;
+
+	default:
+		return PCI_BRIDGE_NON_ISOLATED;
+	}
+}
+EXPORT_SYMBOL_GPL(pci_bus_isolated);
+
 static struct pci_bus *pci_do_find_bus(struct pci_bus *bus, unsigned char busnr)
 {
 	struct pci_bus *child;
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 05e68f35f39238..deeb85467f4f38 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -834,6 +834,32 @@ struct pci_dynids {
 	struct list_head	list;	/* For IDs added at runtime */
 };
 
+enum pci_bus_isolation {
+	/*
+	 * The bus is off a root port and the root port has isolated ACS flags
+	 * or the bus is part of a PCIe switch and the switch has isolated ACS
+	 * flags.
+	 */
+	PCIE_ISOLATED,
+	/*
+	 * The switch's DSP's are not isolated from each other but are isolated
+	 * from the USP.
+	 */
+	PCIE_SWITCH_DSP_NON_ISOLATED,
+	/* The above and the USP's MMIO is not isolated. */
+	PCIE_NON_ISOLATED,
+	/*
+	 * A PCI/PCI-X bus, no isolation. This is like
+	 * PCIE_SWITCH_DSP_NON_ISOLATED in that the upstream bridge is isolated
+	 * from the bus. The bus itself may also have a shared alias of devfn=0.
+	 */
+	PCI_BUS_NON_ISOLATED,
+	/*
+	 * The above and the bridge's MMIO is not isolated and the bridge's RID
+	 * may be an alias.
+	 */
+	PCI_BRIDGE_NON_ISOLATED,
+};
 
 /*
  * PCI Error Recovery System (PCI-ERS).  If a PCI device driver provides
@@ -1222,6 +1248,8 @@ struct pci_dev *pci_get_domain_bus_and_slot(int domain, unsigned int bus,
 struct pci_dev *pci_get_class(unsigned int class, struct pci_dev *from);
 struct pci_dev *pci_get_base_class(unsigned int class, struct pci_dev *from);
 
+enum pci_bus_isolation pci_bus_isolated(struct pci_bus *bus);
+
 int pci_dev_present(const struct pci_device_id *ids);
 
 int pci_bus_read_config_byte(struct pci_bus *bus, unsigned int devfn,
@@ -2035,6 +2063,9 @@ static inline struct pci_dev *pci_get_base_class(unsigned int class,
 						 struct pci_dev *from)
 { return NULL; }
 
+enum pci_bus_isolation pci_bus_isolated(struct pci_bus *bus)
+{ return PCI_NON_ISOLATED; }
+
 static inline int pci_dev_present(const struct pci_device_id *ids)
 { return 0; }
 
-- 
2.43.0


