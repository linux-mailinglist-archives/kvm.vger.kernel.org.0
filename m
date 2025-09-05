Return-Path: <kvm+bounces-56902-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 458C2B461BE
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 20:07:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 30E724E44B0
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 18:07:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEC7D303A2D;
	Fri,  5 Sep 2025 18:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="NU6SaXOs"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2077.outbound.protection.outlook.com [40.107.94.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7B2E393DF4;
	Fri,  5 Sep 2025 18:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757095603; cv=fail; b=iYujJqkWNiGCkhoS83ltfgxhfIKJv6H4scgs03urGpC9HKFCciIu8Cp98Iags7Dx6DgOVTnanXiDNihCAkErcaEktJnvVMAGUasnp0IuhbZgwiZgnidwxicpiuxnT/AHvQLZCrvW/Ix+GvrVEZgUn1LMylFeWjXnT5vPYmPlzkw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757095603; c=relaxed/simple;
	bh=Fz6eu7szqobFivkzKr63kicSVIu95onlhUIb0+tiaAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=TuRRZEH3w4eaZud1voOYRPRZQBaMP8NFErYImQhJDoWcj/rzrQft6SYs6005lDw2B1jCl89XFoq4bmR+Ehn9kpYi9Ypy4s8wDfMdcGBXCwRmgMQ7n7/RGTzIYdQVJUe69QpP7Awrtf9RIfyIQ5oPvdXFRZTBslNWcL7tPx0jbSI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=NU6SaXOs; arc=fail smtp.client-ip=40.107.94.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lMcqAdDhs/LUvQ4IFs7hgNP5+riXule8DaIghFBZM6VwvxHdFaB/uUfziZEwDsBrfe0vOwPlbF4VojDbTcjICscjccm3omUA7lx1e0F7ipn6i8Wew/gZ/rV3SjXC0on0rh/Ey7A7twvz5XcegOYMOMXMq8CaGeKMmu8Gh59Geqt8XZT2LZK0yHw1DW8KiqhGWZVyzchGASOiW9xZrF6ztYN8iLlPTA5NALcc3t4r4OUP31nWBltGKMCIN3esVQFSmUa3qOcoFdrvD9ZCw+eHAll1oAh9Kk1Mt/VopfWJj8R3AXqqlw+1W/ZDS228EzVHWz+yFQo3TK/bGiZwCPM3GA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AwsWUzitQD4zT8LnPMC3hKyLSvro8kGvcv7RATihtkc=;
 b=OPC+Bb1HNlw90QmG0+/DN4CcpX3n2v7u/H313Pyg1mO39DBxGT3f0TGIUvMg4F3jpqUn9Ad/gRCrHoPLtYVzYsM4y4nlqUSsoRo/SakImHZYDxhPAHlnla2l1gspEdZYfDdpvzG/tzCwPpNwj8wqu5A+ec1wfVtPGT578sDSJzvwYjNiX+oRMoccMRGfq1aC7FZlIKOPEA6W2IezBuhkGp8B1Dn3U9Q7aN02TY0FTeqGU4us+JKrh0ocHommU3ZxeOVTrhokdG9Hk8qdjIyrqeS+ggS6bw4O+YJXgYeBUoyj7tqTsbgg07BVIg/bglM/JBdEgZ2JCxF/23OGqi93nQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AwsWUzitQD4zT8LnPMC3hKyLSvro8kGvcv7RATihtkc=;
 b=NU6SaXOs/tCCHrRWK4x923C+B0O6C8uR6nPlluOJh4zwsb7MkpwYhignzm4rjrPYQZ93bq3bY1mC1M7ZbkOwGP97cdl3D40+5XqZ+5pHbgld5DeCBjlHJbTRtQt7UnMSxNixccOIClLDcVqfArC/gUiRNwafOJP8m30sj4s/EeIQcNfPiFKfBMU6dvIqQhITq3Wy0FJiSR6EmQ/9vv9TxwWssDFSF0hM3Sea2bCK1BSugaKJfEA0MDoRFrFhKEwsWydXVAHu2zVtBrurZfWC25wT5VgAcSEyTWSHWLzXFSwiz6txQ6oS4J2yXM/BYkpShd6rUo7YZ4OktNrPh9+uQA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
 by SA1PR12MB6776.namprd12.prod.outlook.com (2603:10b6:806:25b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.19; Fri, 5 Sep
 2025 18:06:35 +0000
Received: from PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632]) by PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632%2]) with mapi id 15.20.9094.017; Fri, 5 Sep 2025
 18:06:35 +0000
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
Subject: [PATCH v3 02/11] PCI: Add pci_bus_isolated()
Date: Fri,  5 Sep 2025 15:06:17 -0300
Message-ID: <2-v3-8827cc7fc4e0+23f-pcie_switch_groups_jgg@nvidia.com>
In-Reply-To: <0-v3-8827cc7fc4e0+23f-pcie_switch_groups_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0036.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:fe::27) To PH7PR12MB5757.namprd12.prod.outlook.com
 (2603:10b6:510:1d0::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_|SA1PR12MB6776:EE_
X-MS-Office365-Filtering-Correlation-Id: 97313d60-2ec0-4bf9-a574-08ddeca6f1a3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?yS0C+9pE7q0C7lAaryV0VSNY/G0CXqInvJlDBaJNxyq9+kaxjobGSsCCjwu9?=
 =?us-ascii?Q?Bhmz4s8kxjgGTqtBlKv+IchGYj8cap4P7Nkbvo7zVcUSm3eMhwfhsRYvvD0W?=
 =?us-ascii?Q?pCPSBBy8XU+c2XZHLxYtCVrPDFKv3DA8XbRk2c1qbY/kL2OS7RuKg6Gln1h1?=
 =?us-ascii?Q?qtW9finRaubal4Q6/VnhQKsHOLL6PYCruzeEsSw48BDKIsCgvkA0gmwMqKVG?=
 =?us-ascii?Q?97Gdf1I/3uEd6gn/BlHyOzk1LcXcA85IWQaVNQ/JUeyjDkHaNI8FA+i9P1kS?=
 =?us-ascii?Q?rTIDmyKPN50zjWKu1IVUdZJS56POIwsk3NNb3k21JHA8AkoYoCgq+R6tNxwo?=
 =?us-ascii?Q?FNQGOmWrmM4ltJRA4kfZotdWRb5J4PoIAM8/30V/8RyMWHQbNHEDtJlG6q52?=
 =?us-ascii?Q?auCBObSWRKZd6teEVaD9QOBlW3jimLQG7K+OW8PtpNuil+qvbvPxmRw5nUd5?=
 =?us-ascii?Q?ioKASk0KnTIJU8QaQCegBz/QZqIUeNvaeCfBhJlkcrHHPRovmDGOjLSi7bEB?=
 =?us-ascii?Q?OOzuR1OwI6kF39zE0yAI07yRGm6HgVYT+8qqZ40wqcA1ms2iSXgkxXzTooME?=
 =?us-ascii?Q?C1/luj0XZoV94skFY2G0ypuAQ2ZbAX86LsrYw4ySTS9D949kPFR375nnjBuu?=
 =?us-ascii?Q?lhHKeIVkCfPxDCn1u/vxcx8Ind5FuM2xLPVFqnPvwDxVTJTxXGZyHvE48jfD?=
 =?us-ascii?Q?lmpgiWpslRRofK89ePTdiK4yHKoYp3xJhHvhnb/2/NQIaC5pq2Y0LFK4qR8Y?=
 =?us-ascii?Q?cbTXo2njM3JjqkFwp2vpk9fkT/c8eujKj+FE+jQhoCYtzKHVv1JXhPq+0sJQ?=
 =?us-ascii?Q?oaJd6vP6qQnoacPXykL9NY6dnI9tzJEKaP65BYcPbqXfGI3PvIvy5m2XGR2X?=
 =?us-ascii?Q?XVjljX02LiiAHxNZHEbQYLhOGMdgDBoSysmx0ClMHAdEO4z9BAYKtjR/1i66?=
 =?us-ascii?Q?2dp6fLjHHLBNDnu4wSMceEn3zTEkvBc/km0/FDs2obZxdmp89W1IJfALhTNU?=
 =?us-ascii?Q?ScvHcP6chHTy8N6OCErUaQjPyIZtNZxzg9kotzJUMFBY211f8gzeifoKIAp9?=
 =?us-ascii?Q?9SpGxLQn86kZb6UzC+1IVbdIzBFiS181GvX9uaxoIxZZ5j3bDSYNjK71254C?=
 =?us-ascii?Q?VC9rQrvPXZP44tE0Uc52GbuKknWyC83gD79eWmuQkfHEbNgRhxDvX0C3Lv3o?=
 =?us-ascii?Q?b6ODr46/2maIH3HIwJYsOqBCUruOixts+YxtNHUcsDiUdS0ch0r8AENfUGts?=
 =?us-ascii?Q?CwRrN36txkxl5wi1GSRzkxp+WrQTrVJ9KBYcEJb3yTS0+mb1qDJ2ViOHuSsg?=
 =?us-ascii?Q?4gN/nus444gjrc9VksNeUNGvArC9rzAhiv+gfMwfeb+D0rOgCvi7DoI8RzJR?=
 =?us-ascii?Q?aSEPNBGSy5VF29EyoWuEacxYP8OEZUu/lWjhxJXVzKFTd3kW+/IWw9TGzQWp?=
 =?us-ascii?Q?bW9h1dDsI1g=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9mz8X66bG9dxZVfoPfHTBw5IPeLyojDPktSYEUJCA+gGY0a26P63dmvZxGP8?=
 =?us-ascii?Q?GjtbyeJm2Big+sUj6qLBYBPX+UOPPMOB8wc+1Q1/UiTyAEwcJXD6lPt03DjS?=
 =?us-ascii?Q?2XZo9qLt17lYNt76r5gyYAwdiH4uQwXAXKNwaoTW8s9t6kFfbSDWUyyFXer9?=
 =?us-ascii?Q?QmjFZmBjLOPVCQGgQ80s88bKs6LjFR8ITguSwQu9u104VH76Fgtcxf9kFz56?=
 =?us-ascii?Q?cTTHNNbfj1lS6H2F0iQe4cPV6o4BJA9GBJv0ZSlBh5fDJIh4WTHsR+Y6Awtz?=
 =?us-ascii?Q?THSA56nMo2eEzOEHV+lCVo1/n9OkkoJxhCliWSIiQFWzMaJ20Opucn9nqrRj?=
 =?us-ascii?Q?5OlwIRrAdQ71sESAzYvQCX9zGjr4FhkV1awjxRQUPty9WOs+paIh1CMK6hDF?=
 =?us-ascii?Q?IjitFzjfTFK1Pk1co43mzuqwsxtc4njhzOt1kNsOO9b5+O0JXChV16Uglysn?=
 =?us-ascii?Q?rYyY7zqihXEOJbPm4Swx1X+w3R4pgQ8jgrKNf7YbMu6aGx9IzoFrflE+BxBC?=
 =?us-ascii?Q?hq6KZPAXKHwy/BgSEPTqK6h9q4MUnBTb0lLDFqTz6WLNyFxbISGplF/EwCgP?=
 =?us-ascii?Q?VXQ5R5fn6OqniJ9CgD81oBvhpzuuM5MeuH2wS9V0l1D1uSFCehLycYKTMSPm?=
 =?us-ascii?Q?OrBmcnlCvWbfAaUn6OOKGpOfTIDBvmnQxuwcpyKZeN/yHNjRERGwQhaudj2F?=
 =?us-ascii?Q?Du5QlEsce96ST4dDGpIC0w1g0d6sNr0rEkFkAXdAoLG4Mz2pSwjnnCS987kJ?=
 =?us-ascii?Q?ZZImqg5EeAvSdYtrKo63tg1jwn0nH/rdFEuau6IkWy0zdkosgMUZ35Xf1BsT?=
 =?us-ascii?Q?8sncWGtvUG+uujKkNg1FVw7otEO0sIiySRK6qcbbdYI9p/ETzOZBQrUj0OxH?=
 =?us-ascii?Q?WOk0LWjAi2zkocOP+UAEJLHSLbRmE4meAY406jzbUrg1mDRSdgWRydPOT4r2?=
 =?us-ascii?Q?doHCdsKxAifIgrpc6xpj+LQ/AS4F9u4mkuDNytd84dJN0AvrwW6qbbF+vEyB?=
 =?us-ascii?Q?4xyIzPv6QsRt+oC9JmI24hthPU7J9X7SX3HE3mcVgBIZ4xNFjpDRZhQA7EwE?=
 =?us-ascii?Q?LK0GeVuzrkqbyZUqCH7CAArh1mPj4FWEtB7ijrREciOwexvAx4eqLcYs7lxZ?=
 =?us-ascii?Q?+O2ek2nVXBpkesTvwtNOmnTz48scrmeDtUhLjkzZO5DFmRHm6TK/qkPjxW2P?=
 =?us-ascii?Q?CpRy1l/OAILp/HSdr5D+eK5yOt/kS5pL4iKqXHFbITAGlsnBHFqQenaito48?=
 =?us-ascii?Q?4/4AXQCnbz6NtarEPvnTn6INYrklJs5GH8ZMa9o2BZv9ltOCeiFAam/Y89F3?=
 =?us-ascii?Q?D4WSo6QUEAaxfv9+/zIETMmk5ceyiubKPEMdofWIFGUHUlr3inXS40ynped7?=
 =?us-ascii?Q?ngaRprmWRv7MHGNSChBgP3z5+GCJwvIy8A65ta/TfSWxCDfpaBK3vtvVXSFo?=
 =?us-ascii?Q?ErgydhNf/nnfgDF2KwX9m3bH/pwJh0uFjnx6m1RiTm5oD4RinuzETAwlyB55?=
 =?us-ascii?Q?JkwBVhNHk9hnGBhFEad+EsE8nTKcDduNgMvnGK1fel4TFH/Cei2UqIMz8+2Y?=
 =?us-ascii?Q?W09R/VPEXbe8lE8K3Pg=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97313d60-2ec0-4bf9-a574-08ddeca6f1a3
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2025 18:06:32.1322
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Mn4saO1vZnICw0gD3XrwIqkL0YJhrqDdAia4A/RnwE9qb/NMBNkqFtfdFv5q3E7+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6776

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

Multi-function devices also have an isolation concern with self loopback
between the functions, though pci_bus_isolated() does not deal with
devices.

As a property of a bus, there are several positive cases:

 - The point to point "bus" on a physical PCIe link is isolated if the
   bridge/root device has something preventing self-access to its own
   MMIO.

 - A Root Port is usually isolated

 - A PCIe switch can be isolated if all it's Down Stream Ports have good
   ACS flags

pci_bus_isolated() implements these rules and returns an enum indicating
the level of isolation the bus has, with five possibilies:

 PCIE_ISOLATED: Traffic on this PCIE bus can not do any P2P.

 PCIE_SWITCH_DSP_NON_ISOLATED: The bus is the internal bus of a PCIE
     switch and the USP is isolated but the DSPs are not.

 PCIE_NON_ISOLATED: The PCIe bus has no isolation between the bridge or
     any downstream devices.

 PCI_BUS_NON_ISOLATED: It is a PCI/PCI-X but the bridge is PCIe, has no
     aliases and the bridge is isolated from the bus.

 PCI_BRIDGE_NON_ISOLATED: It is a PCI/PCI-X bus and has no isolation, the
     bridge is part of the group.

The calculation is done per-bus, so it is possible for a transactions from
a PCI device to travel through different bus isolation types on its way
upstream. PCIE_SWITCH_DSP_NON_ISOLATED/PCI_BUS_NON_ISOLATED and
PCIE_NON_ISOLATED/PCI_BRIDGE_NON_ISOLATED are the same for the purposes of
creating iommu groups. The distinction between PCIe and PCI allows for
easier understanding and debugging as to why the groups are chosen.

For the iommu groups if all busses on the upstream path are PCIE_ISOLATED
then the end device has a chance to have a single-device iommu_group. Once
any non-isolated bus segment is found that bus segment will have an
iommu_group that captures all downstream devices, and sometimes the
upstream bridge.

pci_bus_isolated() is principally about isolation, but there is an
overlap with grouping requirements for legacy PCI aliasing. For purely
legacy PCI environments pci_bus_isolated() returns
PCI_BRIDGE_NON_ISOLATED for everything and all devices within a hierarchy
are in one group. No need to worry about bridge aliasing.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/pci/search.c | 174 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/pci.h  |  31 ++++++++
 2 files changed, 205 insertions(+)

diff --git a/drivers/pci/search.c b/drivers/pci/search.c
index 53840634fbfc2b..fe6c07e67cb8ce 100644
--- a/drivers/pci/search.c
+++ b/drivers/pci/search.c
@@ -113,6 +113,180 @@ int pci_for_each_dma_alias(struct pci_dev *pdev,
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
+	/*
+	 * This bus was created by pci_register_host_bridge(). The spec provides
+	 * no way to tell what kind of bus this is, for PCIe we expect this to
+	 * be internal to the root complex and not covered by any spec behavior.
+	 * Linux has historically been optimistic about this bus and treated it
+	 * as isolating. Given that the behavior of the root complex and the ACS
+	 * behavior of RCiEP's is explicitly not specified we hope that the
+	 * implementation is directing everything that reaches the root bus to
+	 * the IOMMU.
+	 */
+	if (pci_is_root_bus(bus))
+		return PCIE_ISOLATED;
+
+	/*
+	 * bus->self is only NULL for SRIOV VFs, it represents a "virtual" bus
+	 * within Linux to hold any bus numbers consumed by VF RIDs. Caller must
+	 * use pci_physfn() to get the bus for calling this function.
+	 */
+	if (WARN_ON(!bridge))
+		return PCI_BRIDGE_NON_ISOLATED;
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
+	 * Since PCIe links are point to point root ports are isolated if there
+	 * is no internal loopback to the root port's MMIO. Like MFDs assume if
+	 * there is no ACS cap then there is no loopback.
+	 */
+	case PCI_EXP_TYPE_ROOT_PORT:
+		if (bridge->acs_cap &&
+		    !pci_acs_enabled(bridge, PCI_ACS_ISOLATED))
+			return PCIE_NON_ISOLATED;
+		return PCIE_ISOLATED;
+
+	/*
+	 * Since PCIe links are point to point a DSP is always considered
+	 * isolated. The internal bus of the switch will be non-isolated if the
+	 * DSP's have any ACS that allows upstream traffic to flow back
+	 * downstream to any DSP, including back to this DSP or its MMIO.
+	 */
+	case PCI_EXP_TYPE_DOWNSTREAM:
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
+
 static struct pci_bus *pci_do_find_bus(struct pci_bus *bus, unsigned char busnr)
 {
 	struct pci_bus *child;
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 59876de13860db..c36fff9d2254f8 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -855,6 +855,32 @@ struct pci_dynids {
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
@@ -1243,6 +1269,8 @@ struct pci_dev *pci_get_domain_bus_and_slot(int domain, unsigned int bus,
 struct pci_dev *pci_get_class(unsigned int class, struct pci_dev *from);
 struct pci_dev *pci_get_base_class(unsigned int class, struct pci_dev *from);
 
+enum pci_bus_isolation pci_bus_isolated(struct pci_bus *bus);
+
 int pci_dev_present(const struct pci_device_id *ids);
 
 int pci_bus_read_config_byte(struct pci_bus *bus, unsigned int devfn,
@@ -2056,6 +2084,9 @@ static inline struct pci_dev *pci_get_base_class(unsigned int class,
 						 struct pci_dev *from)
 { return NULL; }
 
+static inline enum pci_bus_isolation pci_bus_isolated(struct pci_bus *bus)
+{ return PCIE_NON_ISOLATED; }
+
 static inline int pci_dev_present(const struct pci_device_id *ids)
 { return 0; }
 
-- 
2.43.0


