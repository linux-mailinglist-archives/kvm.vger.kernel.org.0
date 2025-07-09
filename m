Return-Path: <kvm+bounces-51971-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A31B3AFECC8
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 16:56:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DB1E717D566
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 14:55:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C6A12E9ED0;
	Wed,  9 Jul 2025 14:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="lsM6+3qj"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2057.outbound.protection.outlook.com [40.107.102.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F01E32E8E1B;
	Wed,  9 Jul 2025 14:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752072759; cv=fail; b=pAvE1307Umqk0XHJzN1Gnoc6AVa0Mo+LZQ0ZR5g1d75cZlH10a4dfqnPRoIT2is05R1ZIo+gyaXW4Szm7qyKwwp0V2nVH7afSZBdUcXibhcY7NVpdf4iP6GeW3QYTIKwfIN1ohGN1ZZmkH3gYyee3A270q+N6wYhxKvYHa0E5Cg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752072759; c=relaxed/simple;
	bh=uRijN+lWRX/byW0VFgKXWNhC4eHn39VKkjgK1/QbSCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=hFQmHt6RIxJYs5vHL4XG/e0PZtVr7q6sR8g6JlvYe4WnrOTmtSjGcs7OeHetdxiQRVe6LBYzN0WtF6sw1MyCzyg72UseDaF/BFvqzs/QIk10JcqBPdoPm8RM4G8qly3mGLtnSjLVJ/7G9w9Sj9/ukn0aj5zynmWKekpG4Uk1V1A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=lsM6+3qj; arc=fail smtp.client-ip=40.107.102.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LxAWYjtiyACuK6Z8yoZpZSKZiiiHoFw3XAXX8Q9rAUC0afdW96NtdosGSyPrkI6rP0NiJu3hqwQCYSK/rcf5cFGN1gaV8ZTVvtzRIjuSiwCqSlsETDFo13Y536484eNAFg5g/NtUYq957E35wGwI8/q/+39SrHrBu5EZyaT/8DBaA2VA6/kHBts4BGMuOD/j9wmx9j7AdPrrgmhwKWQujbvaGtu/+Kqf7TfgDvQZ2Fe67n5C8i42q6383zo6BOjMmVjDfvFDWaqkygxxsmDVXx3BdgSigWTFul4ryaCskJycyXGuuSU7fjtujJa2+Mn1yMzxRcK4uJ8grNVsK+P+iA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7fNeODLOKSqq6e+565KyHpCPotK2yxz+0za2m3TR2Gg=;
 b=R9eYQ7yVtGfsq49vIq1HbKL7Jw/t/uKiz65P3zZNbmbIb+u4SP34pf2BlWTVtXgoa2XOw10/9rFFMNJVHSRuNTfG8aTRoI37qHBt1LNFCCkwEBd4lMehoT5S9K48iRgE926ZeJ9jR3BDemWYMxrLMPB1hEvmjJCYO99X5IFN3XwSvHOtFuv654rBuKGlv7jNCYr8cDnfLXHr4kGPl5gcC55X2AcaTUqiEsmRYq4EY+ePpS2gXBCG111g6qataXvFZR88zDiBXEIiPRNVCsjck2mRS+8lwIx2SvR2J0l11AKf3trALD0+AFSg/qyBfR1AvZPRkYHMvstswAyMkVLjIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7fNeODLOKSqq6e+565KyHpCPotK2yxz+0za2m3TR2Gg=;
 b=lsM6+3qjkC00UX2xoP/zkJskqk11KSFmx3Nu5kqO5bTGaboYs4draTa6IOLiPb8CjHAuNF4nLaxln6qqB5JwED73aR/6OqlwaBxf6Y6rh/PJ06mm5At/5MErqyuaBd4osdwVZCheBL4YZ8oadumUvX6mvdPUDrqdj0f+4mUR9stNCwUFtMUKwE9+R9fprVI4oWBuPI35iKPy36yhUCokXvDRugb/Go67WHQmwACcnO3aVa668mcAKQNtn54QQLdUgbt0QIIcDzuOnAASxANJNRD9e5WaRPBO49CwbsyXfIRvfbMKfweFQ9Lj0Umq2Q3stHNe9kz6MPat1DBv+71PtQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by IA1PR12MB6356.namprd12.prod.outlook.com (2603:10b6:208:3e0::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.26; Wed, 9 Jul
 2025 14:52:25 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8901.024; Wed, 9 Jul 2025
 14:52:25 +0000
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
Subject: [PATCH v2 03/16] iommu: Compute iommu_groups properly for PCIe switches
Date: Wed,  9 Jul 2025 11:52:06 -0300
Message-ID: <3-v2-4a9b9c983431+10e2-pcie_switch_groups_jgg@nvidia.com>
In-Reply-To: <0-v2-4a9b9c983431+10e2-pcie_switch_groups_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN1PR12CA0098.namprd12.prod.outlook.com
 (2603:10b6:802:21::33) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|IA1PR12MB6356:EE_
X-MS-Office365-Filtering-Correlation-Id: e4539f4c-1d87-4cf3-01a5-08ddbef836d8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?koT44JT6RackZagr9b0reVzc5vWllNioSpplC7miwncumf6yrWGBD/yWsylM?=
 =?us-ascii?Q?IhKltnO7l9KyPAyrBow0HHCo6hxElyF/guwbPg717xy19RZ0hHAbfqHaoYdl?=
 =?us-ascii?Q?6y0PDytx8EtnG9Sv/gnr5Fq5jKAljEkJ8Io43uhJkpnAv97BvNN07LBZJopR?=
 =?us-ascii?Q?+DUa24yOc76Mr5KqH4zrmJtrOFHDcl7c8piMlehNJgFqcMUBi3fyWV66Qlq+?=
 =?us-ascii?Q?uDYlvBwgCRSBJrmHxsHYJryt8o/5j+KaBe+/RMfcbSZehcV87cUwMg8/inyD?=
 =?us-ascii?Q?kQoE34SyLs5RKoABtmybq2uZEVXpxYQ/QiJcUNWAHyWFIs8GOgZHm3+cr3Kj?=
 =?us-ascii?Q?xSO2Aia6Mbt93Wgs7OFRmMaPkhN5yOCDJRD62PhFW138frX2voaXMyMvfUFi?=
 =?us-ascii?Q?yIs17ZYvVcN+DdedbzYCPfUpD67u6s4QAaAMvJV0rMNfMHV2PGjIdr7ZLFCL?=
 =?us-ascii?Q?WSud/gi2qHH2JUmZFGXa2riMnq/hw/ar1xudBysCysakL1hNFI+/39u6YQg6?=
 =?us-ascii?Q?iWmJ7ywMLc7BK+Oq0xvZHEda0XtdlKpNrwUcFWd686vHv1oQth3RqzgRAI3X?=
 =?us-ascii?Q?wkq8BEWg2rI4Hs5AKnQFgHuTcqDqmn5u2mMWoSqrvPjPk7YPn86RvaNBWD0/?=
 =?us-ascii?Q?drWFsUyBaYdN6sPtMnaqJTLJzCPxdBBvPJtJbsoiOPQZk6QbBIof4pyg/mCP?=
 =?us-ascii?Q?y0/GidCZf1DYQnIpLiWcHY9gXUnjBJypWyYmmVcZUqqHhHDcQClfwdTth8/K?=
 =?us-ascii?Q?3xIh3Y83+x66FJeYK+O3vC3phJw+OPKrij1GrlQt5/gGtTMbvdUuocYYwLiN?=
 =?us-ascii?Q?7J0iGepjz52DBewnkE7hlmpaV0lUd26i6VyAuEsNX2AQxpBbWVaj0A1+49m0?=
 =?us-ascii?Q?0U39BxJ18d7UH4pKhKN1sKE7710I+W7N25v8NJ0l3mWSFwQ/MDWDap1S+z7E?=
 =?us-ascii?Q?SUkGm9/fm/pGX0/SH5KiknLVkv5wW6PdVmDK97Z921cxsbMe5MigdQLmmppD?=
 =?us-ascii?Q?wRqGgrcFJNVnUkrnrYEBpQleVlQcLMMVMhEJsFE3y/kjjcdQ6GW+ulDj7Pu/?=
 =?us-ascii?Q?r1MNY7YKhDLsOft8wXINEd31eICQlyhELE3ELM1nrdssyf8N59vhfwUDdTNU?=
 =?us-ascii?Q?Y+bILj28AEPKHBcxw/HXOtIxzD+Tjv0GWhArD6tXSxqbiAQAOSHqivle+Y8H?=
 =?us-ascii?Q?5T1wYIm3ooMymgGMTNEYBPAkUXXCu/kAjdo1sJaqroT7WgNCBBVo7XGG7b6g?=
 =?us-ascii?Q?+21qucAp8uH//M5gvvdfLnQp4IN7wF9zc2QquBflK+Yais0RQtjm7uLtmVck?=
 =?us-ascii?Q?Vi8vlehQgV13okHdqQDzrTiEsKA34OLSu07hIkpooBynsc+4ZD3BOKASukdj?=
 =?us-ascii?Q?E0hZiQYTz2opwXWqPWk5bEtjtfFiUJkWkWffcwVqoA3hUID5annLG3XIaU8U?=
 =?us-ascii?Q?IBOwDmk21w0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?aP5zTWKe0J0hZAfUXU4Fi40zN1TVpMXTrlTSb1UlVUqXiKf6kdc/UXaZGrhy?=
 =?us-ascii?Q?Gm7x5S/ueyPkU5s4bwNCnvXE5MqYzGSeOfZ5m9Ay/TDaxFRaeTLmD47MXDFj?=
 =?us-ascii?Q?UGKcNfmGZU1m9ShGqgFkuEcCp1hR3+IkAVIpGC/JjSJe35Wos/ojv4wQtgRN?=
 =?us-ascii?Q?V747hyc5I+oNkTnCO/3Nrym3pNja/eO9ZyInblRfCKPY8YJBS/uZFqjpLV6Y?=
 =?us-ascii?Q?GwCU6glFbC2lF7EErSV1JReHDIvwbrEwJ1b/7/M4v1HoRzpLaQtV29AnIE6p?=
 =?us-ascii?Q?0GawITRTqZjpYnLHtbQyTp0ulKds/DQ+evCmeEOWMVycrz4lzIY8UKnXUwTg?=
 =?us-ascii?Q?xeCROHKUXHjAGD+F3QVSDjYZOPHg++NP/Y2B4b+M89jEYh9jYI96NPWJNr9S?=
 =?us-ascii?Q?Ron6LwmzWQiNivPXmDOeTeSY6hFvq+P42IjM0F9iWEajxQ7IVV55q3XNtoWe?=
 =?us-ascii?Q?2SivVMkduey2lo8uWSqq0I1vaioH8ioU8zV3MWsSM51G+LDcoQ+H+Qz3ibGu?=
 =?us-ascii?Q?N5eB9t+TX5uOaHqsGrbo9zK2zvq/0t6ib6Zhj25ZoVbYTX/cLIxej9bcnSzW?=
 =?us-ascii?Q?76VSB1RaFz0LTvlpvo6HbwcsarCOK3fNdTnFy6IWZPIEBaxUvia3zss2uEmf?=
 =?us-ascii?Q?VSufP+6XP1Ul4DSiFT182ohT9eKOkTXNbkZ2wcbEof6lljr/txm2KRgRWezg?=
 =?us-ascii?Q?4mtHudFyQNFrvQOIgP3yEsLN4MdL1/GrJ8TKBAELEwAjUoXUKcOXCYffl7tF?=
 =?us-ascii?Q?4f+OaUlgjdp9dq+jJyax0ZQ8ziFoP5YNyg1VMbFY9iKv8TQrFr74ya9PZboo?=
 =?us-ascii?Q?RZDSRNDZQHYdfv42ymhNRrJ0dtLVjBWpGYdr+HoVuXJkbNng3mxFTug27JPL?=
 =?us-ascii?Q?Ahn5IAiV2S811328UOV/773+O7tFf7AgK8iCyf4q+cK3++DnGj8eVDbmQKcC?=
 =?us-ascii?Q?Iga4wdinnFtTU1bSJnkgL1TfG0zOJoL9xK10x1FZLBFFA6ofrCatMW9l8A53?=
 =?us-ascii?Q?mZ5j5/DKLsGko8g93M1GxB7FaHHMMoKDFtaYc9R5rykTZNBejcrbQC/8eauW?=
 =?us-ascii?Q?wx7KLV9RsXAgHBzcynB51T+kSqj087LAHKIAeRGXygwdzHoe5uZcfx8I925v?=
 =?us-ascii?Q?Iz9I3j1eGWXgI4ghoVYuqvvmkogoGxQoxxolyqUO9dqXnk6jlWmcYZzK61Ck?=
 =?us-ascii?Q?BzHtr98I8e7WYHmksWaz1CVo40cFjMh5ht6T7f2QS8H8DgR6avlgZnyb+isp?=
 =?us-ascii?Q?mI2SEG8P2EtsUfuCjxwCx5EKVFxq21BC/JqS4pUtjaNBQ2fhsxlb3MhHmH34?=
 =?us-ascii?Q?fWKrCtQys8qrzipCvgPw7a7xwmfwq5L/QI/+x5flKA9qlO1tXtYP+nmCD8RB?=
 =?us-ascii?Q?j4UAQIiVcDcfgY3+aU23xL1rXisEGdpbdaEFWFKlOpuc3wu3fQru89QtZGBl?=
 =?us-ascii?Q?vtPuFmIKlO2zmqIn7+X+hqZucJbIfglXpepS8e7BLrB8CgfWG15D5+QNncXw?=
 =?us-ascii?Q?LkR+tymuf9dc3qxppOWa7vjWf1n1sXQWs8/xFKwjOdAPSxPlVaEi6k6Uia6g?=
 =?us-ascii?Q?4C6vy/yDISJtQp83oLN/fAoPBsn3eOVSwSeRtX0+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4539f4c-1d87-4cf3-01a5-08ddbef836d8
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 14:52:24.2168
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 93I99g3V9fkFRMZVC9NzAJBmhaiRcOt2RJGANYJn62Hi0CImRWSBHsj0rtnR283C
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6356

The current algorithm does not work if ACS is turned off, and it is not
clear how this has been missed for so long. Alex suspects a multi-function
modeling of the DSPs may have hidden it, but I could not find a switch
using that scheme.

Most likely people were simply happy they had smaller groups oblivious to
the security problems.

For discussion lets consider a simple topology like the below:

                               -- DSP 02:00.0 -> End Point A
 Root 00:00.0 -> USP 01:00.0 --|
                               -- DSP 02:03.0 -> End Point B

If ACS is fully activated we expect 00:00.0, 01:00.0, 02:00.0, 02:03.0, A,
B to all have unique single device groups.

If both DSPs have ACS off then we expect 00:00.0 and 01:00.0 to have
unique single device groups while 02:00.0, 02:03.0, A, B are part of one
multi-device group.

If the DSPs have asymmetric ACS, with one fully isolating and one
non-isolating we also expect the above multi-device group result.

Instead the current algorithm always creates unique single device groups
for this topology. It happens because the pci_device_group(DSP)
immediately moves to the USP and computes pci_acs_path_enabled(USP) ==
true and decides the DSP can get a unique group. The pci_device_group(A)
immediately moves to the DSP, sees pci_acs_path_enabled(DSP) == false and
then takes the DSPs group.

The current algorithm has several issues:

 1) It implicitly depends on ordering. Since the existing group discovery
    only goes in the upstream direction discovering a downstream device
    before its upstream will cause the wrong creation of narrower groups.

 2) It assumes that if the path from the end point to the root is entirely
    ACS isolated then that end point is isolated. This misses cross-traffic
    in the asymmetric ACS case.

 3) When evaluating a non-isolated DSP it does not check peer DSPs for an
    already established group unless the multi-function feature does it.

 4) It does not understand the aliasing rule for PCIe to PCI bridges
    where the alias is to the subordinate bus. The bridge's RID on the
    primary bus is not aliased. This causes the PCIe to PCI bridge to be
    wrongly joined to the group with the downstream devices.

As grouping is a security property for VFIO creating incorrectly narrowed
groups is a security problem for the system.

Revise the design to solve these problems.

Explicitly require ordering, or return EPROBE_DEFER if things are out of
order. This avoids silent errors that created smaller groups and solves
problem #1.

Work on busses, not devices. Isolation is a property of the bus, and the
first non-isolated bus should form a group containing all devices
downstream of that bus. If all busses on the path to an end device are
isolated then the end device has a chance to make a single-device group.

Use pci_bus_isolation() to compute the bus's isolation status based on the
ACS flags and technology. pci_bus_isolation() touches a lot of PCI
internals to get the information in the right format.

Add a new flag in the iommu_group to record that the group contains a
non-isolated bus. Any downstream pci_device_group() will see
bus->self->iommu_group is non-isolated and unconditionally join it. This
makes the first non-isolation apply to all downstream devices and solves
problem #2

The bus's non-isolated iommu_group will be stored in either the DSP of
PCIe switch or the bus->self upstream device, depending on the situation.
When storing in the DSP all the DSPs are checked first for a pre-existing
non-isolated iommu_group. When stored in the upstream the flag forces it
to all downstreams. This solves problem #3.

Put the handling of end-device aliases and MFD into pci_get_alias_group()
and only call it in cases where we have a fully isolated path. Otherwise
every downstream device on the bus is going to be joined to the group of
bus->self.

Finally, replace the initial pci_for_each_dma_alias() with a combination
of:

 - Directly checking pci_real_dma_dev() and enforcing ordering.
   The group should contain both pdev and pci_real_dma_dev(pdev) which is
   only possible if pdev is ordered after real_dma_dev. This solves a case
   of #1.

 - Indirectly relying on pci_bus_isolation() to report legacy PCI busses
   as non-isolated, with the enum including the distinction of the PCIe to
   PCI bridge being isolated from the downstream. This solves problem #4.

It is very likely this is going to expand iommu_group membership in
existing systems. After all that is the security bug that is being
fixed. Expanding the iommu_groups risks problems for users using VFIO.

The intention is to have a more accurate reflection of the security
properties in the system and should be seen as a security fix. However
people who have ACS disabled may now need to enable it. As such users may
have had good reason for ACS to be disabled I strongly recommend that
backporting of this also include the new config_acs option so that such
users can potentially minimally enable ACS only where needed.

Fixes: 104a1c13ac66 ("iommu/core: Create central IOMMU group lookup/creation interface")
Cc: stable@vger.kernel.org
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommu.c | 274 ++++++++++++++++++++++++++++++++----------
 include/linux/pci.h   |   3 +
 2 files changed, 212 insertions(+), 65 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index d265de874b14b6..8b152266f20104 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -65,8 +65,16 @@ struct iommu_group {
 	struct list_head entry;
 	unsigned int owner_cnt;
 	void *owner;
+
+	/* Used by the device_group() callbacks */
+	u32 bus_data;
 };
 
+/*
+ * Everything downstream of this group should share it.
+ */
+#define BUS_DATA_PCI_NON_ISOLATED BIT(0)
+
 struct group_device {
 	struct list_head list;
 	struct device *dev;
@@ -1484,25 +1492,6 @@ static struct iommu_group *get_pci_alias_group(struct pci_dev *pdev,
 	return NULL;
 }
 
-struct group_for_pci_data {
-	struct pci_dev *pdev;
-	struct iommu_group *group;
-};
-
-/*
- * DMA alias iterator callback, return the last seen device.  Stop and return
- * the IOMMU group if we find one along the way.
- */
-static int get_pci_alias_or_group(struct pci_dev *pdev, u16 alias, void *opaque)
-{
-	struct group_for_pci_data *data = opaque;
-
-	data->pdev = pdev;
-	data->group = iommu_group_get(&pdev->dev);
-
-	return data->group != NULL;
-}
-
 /*
  * Generic device_group call-back function. It just allocates one
  * iommu-group per device.
@@ -1534,57 +1523,27 @@ struct iommu_group *generic_single_device_group(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(generic_single_device_group);
 
-/*
- * Use standard PCI bus topology, isolation features, and DMA alias quirks
- * to find or create an IOMMU group for a device.
- */
-struct iommu_group *pci_device_group(struct device *dev)
+static struct iommu_group *pci_group_alloc_non_isolated(void)
 {
-	struct pci_dev *pdev = to_pci_dev(dev);
-	struct group_for_pci_data data;
-	struct pci_bus *bus;
-	struct iommu_group *group = NULL;
-	u64 devfns[4] = { 0 };
+	struct iommu_group *group;
 
-	if (WARN_ON(!dev_is_pci(dev)))
-		return ERR_PTR(-EINVAL);
+	group = iommu_group_alloc();
+	if (IS_ERR(group))
+		return group;
+	group->bus_data |= BUS_DATA_PCI_NON_ISOLATED;
+	return group;
+}
 
-	/*
-	 * Find the upstream DMA alias for the device.  A device must not
-	 * be aliased due to topology in order to have its own IOMMU group.
-	 * If we find an alias along the way that already belongs to a
-	 * group, use it.
-	 */
-	if (pci_for_each_dma_alias(pdev, get_pci_alias_or_group, &data))
-		return data.group;
-
-	pdev = data.pdev;
-
-	/*
-	 * Continue upstream from the point of minimum IOMMU granularity
-	 * due to aliases to the point where devices are protected from
-	 * peer-to-peer DMA by PCI ACS.  Again, if we find an existing
-	 * group, use it.
-	 */
-	for (bus = pdev->bus; !pci_is_root_bus(bus); bus = bus->parent) {
-		if (!bus->self)
-			continue;
-
-		if (pci_acs_path_enabled(bus->self, NULL, PCI_ACS_ISOLATED))
-			break;
-
-		pdev = bus->self;
-
-		group = iommu_group_get(&pdev->dev);
-		if (group)
-			return group;
-	}
+static struct iommu_group *pci_get_alias_group(struct pci_dev *pdev)
+{
+	struct iommu_group *group;
+	DECLARE_BITMAP(devfns, 256) = {};
 
 	/*
 	 * Look for existing groups on device aliases.  If we alias another
 	 * device or another device aliases us, use the same group.
 	 */
-	group = get_pci_alias_group(pdev, (unsigned long *)devfns);
+	group = get_pci_alias_group(pdev, devfns);
 	if (group)
 		return group;
 
@@ -1593,12 +1552,197 @@ struct iommu_group *pci_device_group(struct device *dev)
 	 * slot and aliases of those funcions, if any.  No need to clear
 	 * the search bitmap, the tested devfns are still valid.
 	 */
-	group = get_pci_function_alias_group(pdev, (unsigned long *)devfns);
+	group = get_pci_function_alias_group(pdev, devfns);
 	if (group)
 		return group;
 
-	/* No shared group found, allocate new */
-	return iommu_group_alloc();
+	/*
+	 * When MFD's are included in the set due to ACS we assume that if ACS
+	 * permits an internal loopback between functions it also permits the
+	 * loopback to go downstream if a function is a bridge.
+	 *
+	 * It is less clear what aliases mean when applied to a bridge. For now
+	 * be conservative and also propagate the group downstream.
+	 */
+	__clear_bit(pdev->devfn & 0xFF, devfns);
+	if (!bitmap_empty(devfns, sizeof(devfns) * BITS_PER_BYTE))
+		return pci_group_alloc_non_isolated();
+	return NULL;
+}
+
+static struct iommu_group *pci_hierarchy_group(struct pci_dev *pdev)
+{
+	/*
+	 * SRIOV functions may resid on a virtual bus, jump directly to the PFs
+	 * bus in all cases.
+	 */
+	struct pci_bus *bus = pci_physfn(pdev)->bus;
+	struct iommu_group *group;
+
+	/* Nothing upstream of this */
+	if (pci_is_root_bus(bus))
+		return NULL;
+
+	/*
+	 * !self is only for SRIOV virtual busses which should have been
+	 * excluded above.
+	 */
+	if (WARN_ON(!bus->self))
+		return ERR_PTR(-EINVAL);
+
+	group = iommu_group_get(&bus->self->dev);
+	if (!group) {
+		/*
+		 * If the upstream bridge needs the same group as pdev then
+		 * there is no way for it's pci_device_group() to discover it.
+		 */
+		dev_err(&pdev->dev,
+			"PCI device is probing out of order, upstream bridge device of %s is not probed yet\n",
+			pci_name(bus->self));
+		return ERR_PTR(-EPROBE_DEFER);
+	}
+	if (group->bus_data & BUS_DATA_PCI_NON_ISOLATED)
+		return group;
+	iommu_group_put(group);
+	return NULL;
+}
+
+/*
+ * For legacy PCI we have two main considerations when forming groups:
+ *
+ *  1) In PCI we can loose the RID inside the fabric, or some devices will use
+ *     the wrong RID. The PCI core calls this aliasing, but from an IOMMU
+ *     perspective it means that a PCI device may have multiple RIDs and a
+ *     single RID may represent many PCI devices. This effectively means all the
+ *     aliases must share a translation, thus group, because the IOMMU cannot
+ *     tell devices apart.
+ *
+ *  2) PCI permits a bus segment to claim an address even if the transaction
+ *     originates from an end point not the CPU. When it happens it is called
+ *     peer to peer. Claiming a transaction in the middle of the bus hierarchy
+ *     bypasses the IOMMU translation. The IOMMU subsystem rules require these
+ *     devices to be placed in the same group because they lack isolation from
+ *     each other. In PCI Express the ACS system can be used to inhibit this and
+ *     force transactions to go to the IOMMU.
+ *
+ *     From a PCI perspective any given PCI bus is either isolating or
+ *     non-isolating. Isolating means downstream originated transactions always
+ *     progress toward the CPU and do not go to other devices on the bus
+ *     segment, while non-isolating means downstream originated transactions can
+ *     progress back downstream through another device on the bus segment.
+ *
+ *     Beyond buses a multi-function device or bridge can also allow
+ *     transactions to loop back internally from one function to another.
+ *
+ *     Once a PCI bus becomes non isolating the entire downstream hierarchy of
+ *     that bus becomes a single group.
+ */
+struct iommu_group *pci_device_group(struct device *dev)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+	struct iommu_group *group;
+	struct pci_dev *real_pdev;
+
+	if (WARN_ON(!dev_is_pci(dev)))
+		return ERR_PTR(-EINVAL);
+
+	/*
+	 * Arches can supply a completely different PCI device that actually
+	 * does DMA.
+	 */
+	real_pdev = pci_real_dma_dev(pdev);
+	if (real_pdev != pdev) {
+		group = iommu_group_get(&real_pdev->dev);
+		if (!group) {
+			/*
+			 * The real_pdev has not had an iommu probed to it. We
+			 * can't create a new group here because there is no way
+			 * for pci_device_group(real_pdev) to pick it up.
+			 */
+			dev_err(dev,
+				"PCI device is probing out of order, real device of %s is not probed yet\n",
+				pci_name(real_pdev));
+			return ERR_PTR(-EPROBE_DEFER);
+		}
+		return group;
+	}
+
+	if (pdev->dev_flags & PCI_DEV_FLAGS_BRIDGE_XLATE_ROOT)
+		return iommu_group_alloc();
+
+	/* Anything upstream of this enforcing non-isolated? */
+	group = pci_hierarchy_group(pdev);
+	if (group)
+		return group;
+
+	switch (pci_bus_isolated(pci_physfn(pdev)->bus)) {
+	case PCIE_ISOLATED:
+		/* Check multi-function groups and same-bus devfn aliases */
+		group = pci_get_alias_group(pdev);
+		if (group)
+			return group;
+
+		/* No shared group found, allocate new */
+		return iommu_group_alloc();
+
+	/*
+	 * On legacy PCI there is no RID at an electrical level. On PCI-X the
+	 * RID of the bridge may be used in some cases instead of the
+	 * downstream's RID. This creates aliasing problems. PCI/PCI-X doesn't
+	 * provide isolation either. The end result is that as soon as we hit a
+	 * PCI/PCI-X bus we switch to non-isolated for the whole downstream for
+	 * both aliasing and isolation reasons. The bridge has to be included in
+	 * the group because of the aliasing.
+	 */
+	case PCI_BRIDGE_NON_ISOLATED:
+	/* A PCIe switch where the USP has MMIO and is not isolated. */
+	case PCIE_NON_ISOLATED:
+		group = iommu_group_get(&pdev->bus->self->dev);
+		if (WARN_ON(!group))
+			return ERR_PTR(-EINVAL);
+		/*
+		 * No need to be concerned with aliases here since we are going
+		 * to put the entire downstream tree in the bridge/USP's group.
+		 */
+		group->bus_data |= BUS_DATA_PCI_NON_ISOLATED;
+		return group;
+
+	/*
+	 * It is a PCI bus and the upstream bridge/port does not alias or allow
+	 * P2P.
+	 */
+	case PCI_BUS_NON_ISOLATED:
+	/*
+	 * It is a PCIe switch and the DSP cannot reach the USP. The DSP's
+	 * are not isolated from each other and share a group.
+	 */
+	case PCIE_SWITCH_DSP_NON_ISOLATED: {
+		struct pci_dev *piter = NULL;
+
+		/*
+		 * All the downstream devices on the bus share a group. If this
+		 * is a PCIe switch then they will all be DSPs
+		 */
+		for_each_pci_dev(piter) {
+			if (piter->bus != pdev->bus)
+				continue;
+			group = iommu_group_get(&piter->dev);
+			if (group) {
+				pci_dev_put(piter);
+				if (WARN_ON(!(group->bus_data &
+					      BUS_DATA_PCI_NON_ISOLATED)))
+					group->bus_data |=
+						BUS_DATA_PCI_NON_ISOLATED;
+				return group;
+			}
+		}
+		return pci_group_alloc_non_isolated();
+	}
+	default:
+		break;
+	}
+	WARN_ON(true);
+	return ERR_PTR(-EINVAL);
 }
 EXPORT_SYMBOL_GPL(pci_device_group);
 
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 0b1e28dcf9187d..517800206208b5 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -2072,6 +2072,9 @@ static inline int pci_dev_present(const struct pci_device_id *ids)
 #define no_pci_devices()	(1)
 #define pci_dev_put(dev)	do { } while (0)
 
+static inline struct pci_dev *pci_real_dma_dev(struct pci_dev *dev)
+{ return dev; }
+
 static inline void pci_set_master(struct pci_dev *dev) { }
 static inline void pci_clear_master(struct pci_dev *dev) { }
 static inline int pci_enable_device(struct pci_dev *dev) { return -EIO; }
-- 
2.43.0


