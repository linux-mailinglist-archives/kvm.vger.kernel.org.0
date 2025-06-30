Return-Path: <kvm+bounces-51127-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 79CE0AEEA5B
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 00:31:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A00251BC3F18
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 22:31:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DEE52EE616;
	Mon, 30 Jun 2025 22:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="OZtkA47G"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2060.outbound.protection.outlook.com [40.107.243.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F44C2EE5ED;
	Mon, 30 Jun 2025 22:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751322541; cv=fail; b=oM1WlCxpjs2y+4O1vjCngqvQCt5lJXNXdRGgbgEAvxEfguUIUc8RlpEiO1WC26Sd04nvXOTK4L7K81XS6fz9F10F0KBIKThDVDsiG1M4M7B/paE1h9Vta3aSOkMepap6Oh836iLdbnHEICwj/SCTrns0qmOxfvIv9hqeRg6ASdw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751322541; c=relaxed/simple;
	bh=TihaXrzGhnqCSfgu5zSrcIQFAelRptzV7c7DnBFT1dw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=laIhBdTE4MxLkMXsx7Kc6sZcUbtLP6dibrvUbUq9z89HcjSUpZj5T7jEc+AkQk79CpRmXbqxzeBOSAURjInLa1mXpdMopQo+er+d2W2LeFnSAWmH/awFXCeqDwlixjvOyWih/H15vVWV9UxWz5GsQS5KBXO4TBT/19qX6232I38=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=OZtkA47G; arc=fail smtp.client-ip=40.107.243.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HSHGBu+jO3OxcfeA8rWLwSzlu3cCO2Jvrje9oBGS34c4NaLWvWhXITawtAmF4coi2Nb+UW61LupA+/rs/s/0LfdS2hDGHUkCw0PHWa8biyuumU8lfyfWWH1n3vwhAHhiOO4RcstgcQ4GoZ1lQeybfAf5RwZeoMb1Zj/mBzfSv2fTXR1mlM40CJYbpcGbi/D7x0epRE74qYTAsfi6TTkXJW8g3Y5bvU7J85LwQznV011BH/clgdXgOkb7tkpauQifHES29tNvDstnbyGb+YRkFjwt1fRpeliULnmd2yCFr0mPKNko2MQLQ4ww2wHdLtHNmfmcGJduOam27cL5QXANLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YMnZHBnMyaWqVKP1Sbs/5eHLF/a34XtG8pTj3ifSOiw=;
 b=nJd31hF0GrEmbXIc1bnCIu6N2s+31GIQFNDzHgpoExpJFS/WePchfz1EUuNNzVXzDLqU3Om52JkMPCG9pN4T0nwwlWZ8jsY+DHjmZ+YbLuLLhWjCt5h6SNT8LvQpCJJTk5rvDO83ljnbzQjDJWGtb92QQODHP9VE8UqwrLqal16YS8u6uFqUCqD8bKQy03Qs6CbXvKJ+JrxHBCrGMcsPQmmD4mM2MdfeZOTc5gChdM9sl33dHf5JYTK4ai/0VvOf4agwpT5MJz796ySw+MLsZeOmnTkvYq8UIkOTaaXkAczeoQQHKlWtJOG4B1A+zVovFEwuNz78lVGSMjkG/XRHYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YMnZHBnMyaWqVKP1Sbs/5eHLF/a34XtG8pTj3ifSOiw=;
 b=OZtkA47Gy7zH2hawbQAZFHNoZPPkvty8JTCXAqA28eFyM+G0YbDrbv7jRyvrcTAkA3VB2/k/BqC7NSEOAqiJMS9z7bgEe7p/uzZ/1e62UQx6AuflSIskq2k/rcBOJzKvBlBkkGlECjHvMdiNdlckEIRjf4rU4OZAq5UPbWj2yi280doY9AB5dhj0HvUp3ww9OBWDuS8wcTewJV3EdgMWeU+ewBCGqr3AmHJQPyofSqyzhJGxS02nOgs8TFpuJ5DJRPHMxeaKT+oRp9NOCoVzQNo25k2CbJNge8Q4HYGRATGKr3IIWwUvtUlhYXPXYH0OYrQatYkC1DXghAwYsUon7g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by MN6PR12MB8566.namprd12.prod.outlook.com (2603:10b6:208:47c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.25; Mon, 30 Jun
 2025 22:28:52 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8880.030; Mon, 30 Jun 2025
 22:28:52 +0000
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
Subject: [PATCH 03/11] iommu: Compute iommu_groups properly for PCIe switches
Date: Mon, 30 Jun 2025 19:28:33 -0300
Message-ID: <3-v1-74184c5043c6+195-pcie_switch_groups_jgg@nvidia.com>
In-Reply-To: <0-v1-74184c5043c6+195-pcie_switch_groups_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR01CA0056.prod.exchangelabs.com (2603:10b6:a03:94::33)
 To CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|MN6PR12MB8566:EE_
X-MS-Office365-Filtering-Correlation-Id: d41747da-fcc4-4190-06da-08ddb8257d8b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?cygipImPkBkyWuPQxx6CMBBwuKvYhJ6mfRrjf2twhELvZf5l2zF4iU5MXUwl?=
 =?us-ascii?Q?RPu+l4VNRBatYggCN734WuN+PJzCYhX6+AiQoqe0eB88UWi0Y4Rzk1TG1dB6?=
 =?us-ascii?Q?K49kSAl4+a0umRbucKD2aNM8D4EAWYNV/e+7psxA0pn32C3vv0VUvJvg52JJ?=
 =?us-ascii?Q?jmREP1eyMvx3CNHQqW9b8qUwQ11dE/5RxmH3J5b9/ocg+vBn73RbDTtJ73cy?=
 =?us-ascii?Q?75h6wYwG3OkOi2KVEbbF9BfMK9EcVYtw78qMYNz3SS88gOKOnFC9Bo8cQJm4?=
 =?us-ascii?Q?3y2cXZtidhLDezmbGpL6ax+DgcC4exEnZObrZMmJ6LxrXKgscUAzbU9sajmX?=
 =?us-ascii?Q?LHSCqsDKH7mwpDZXyteaMfwtJtqfD5MPNisWfxT+aMbCLOWKF3rFTM+KzRX0?=
 =?us-ascii?Q?9lioiI01Oy2D+qf01NVdN3uXOkX4X+EUyDDKeajqUlCbmk0kg4d4R7nVNuPB?=
 =?us-ascii?Q?jmr/dVFLZWO83OzJo8NbVl6cyA9/Ox3+ty2bX9qwC1yNmu4bclWnwjBoxRk8?=
 =?us-ascii?Q?bNI3nGISFQZtGyr3zILoA2da9JHm1lTw15dM6S62SWvyTb8Kuk+HU87Ev9Ty?=
 =?us-ascii?Q?c5WFz48VB9UYU+aln6/9MyzTuT1p3rGhPRtDv7QjwRE4zDsLrtdIR7/oFJBa?=
 =?us-ascii?Q?aonB6lFnFPFgyyBZG5oknfPE/KAQB8dasOnws2t1WHKG96DtpF+0pAHTX3Ow?=
 =?us-ascii?Q?A3681SnAZo1OwS5l4eh3vwVpgc0TlIhu1zTIzacyNwRW6anm/XHMeERUZ/sb?=
 =?us-ascii?Q?ohUkNuZSzoyHO5+zuZeQLXdg/6RpAmgQr0C3jivH/3RHViguMGdcqsMigiXR?=
 =?us-ascii?Q?g092uAiuQqYskRLzh9C/Cr4P1gwAvhiBSVqhYKhk+vwAjAByDbh0WieFNfda?=
 =?us-ascii?Q?DBrh8MdqEjoA2Sq4NIVw4+AAzpjrO985Jo4tzQ365fTydacwjGC/icWrg5Z+?=
 =?us-ascii?Q?0PDIpvV+UXBOngZytIo4FXwdVN6DEcIHMnxr1Lkh94yzBkBV/3Q045WCOSQd?=
 =?us-ascii?Q?x4O0Xo6Ik5UxIWML3OHEIk2Lx2PrBZVm6cBhksRWCr2qw8qg3AWYCzSxFjTM?=
 =?us-ascii?Q?X7RyJSWYN70xWhKWbPOmtx077QSYdjbH5D9UFHd9WwFy8P5gIrnEh6AuYSOc?=
 =?us-ascii?Q?Q3wnQ26ngK3UxeSnqGZG16+mI765PZu6hdCSgNqxCLnv/udZt6nR+4uQYSTX?=
 =?us-ascii?Q?PO5wY8+It7vwc2bc2IidKx9xNdv9MJvibXNhZFiqdd2//AZ5W4v2ZHdAb+48?=
 =?us-ascii?Q?JLfJidhgRjfm1JE9ZmF110v6R6fGJ9XuBrsju0klUWi+UfM3y762tHMQ6hA2?=
 =?us-ascii?Q?v9dGGpZkmofm6WvJP6l7upwSZha2Oeph92N7BVGo+Z73aogdvp/81HVPK66n?=
 =?us-ascii?Q?yoAjwoxT8MgcvDn9kMwT38ZlwKXsGhRz6w+NHUZKVc5KAx5+NaKcCJcj1o0F?=
 =?us-ascii?Q?SHFif6Om7b0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?52Hjo3qYQ1mPXaAMfiCnw2vwPi5F4+rtrbe6iT1/JnkF+i16ZvR5w2kDGP5/?=
 =?us-ascii?Q?+0taroIHBdzJM9xDZwQMj6cPfv87wuQFdExSgvkk2an9mThd7WE0E5+FYwhj?=
 =?us-ascii?Q?gNPaVi9x/eTNtQxzbmAP5DUITbyKC3b8dgRCYCqbkLiIRRC1H0ui7lJQWXEO?=
 =?us-ascii?Q?OBylllO5dnvwVnr/JeqJ76xP2dQVa6pc2e8b+VRCHJS7ynS5DcC3Cwd4nua5?=
 =?us-ascii?Q?m+wmfp2NRkjQF0j9P2ngaoPlueFKf1sh9VvF5cAWeq9zGFtYEgeJU98vKDeU?=
 =?us-ascii?Q?X4xKxEtlzjMlRk/iHEh7FhYhtYCLiST3VmyG3PFI58LphFAPTwikuki5WLuV?=
 =?us-ascii?Q?CJCIUjKFFU5anI+vibpF5T1J8OifJXUik/v8D94i7MknXhlXbaitx18DOMBi?=
 =?us-ascii?Q?PwYLIvEQZXc1tWX8pEBFWN6g2/0DAHnQb7L0N3luYK7MJ7tmk4caFzH7o/CE?=
 =?us-ascii?Q?PKEjBfrSzfRAv0CtX3oWjYy4Ld54+gu/xdINaMzJwwDC23URLEW1iSt/7Axc?=
 =?us-ascii?Q?Wzxof7S53tG6gPLmU9kZlSkZy2q1lpAUnwIwzpH3m0gSNV2j4NiTm92dNboh?=
 =?us-ascii?Q?fpVqurmZCf6c8uMNlAVj/BNMO/c60B1/MsXFc6u/GOsE7gOWP94hKLa+paWc?=
 =?us-ascii?Q?ua3LTPkDJDMVvgpobKoQqcdYyRet3lbwjWOxHjMOmXH41zFosFFd1Lk206UD?=
 =?us-ascii?Q?t3FVb8ekfRLAdvKAhMmWMP2YtRh/m0+GofDNyXjzkIVhEm1JAf+s0DY0t3Qj?=
 =?us-ascii?Q?by5lLcH6CzCWabhDsps80xH301tS2aCNoqSTjxn/RYVbUDD1kxbCZU2Cx8B8?=
 =?us-ascii?Q?et4KMffRzdNBxj3uidEznTi1PHfvQ45jQm33zvJIf49jFNPxLkovhs7g8MxQ?=
 =?us-ascii?Q?L4FwZn9jxK13aGTehaR1z4QM3k6fUmPKzPUsfuXieIluFPhFuYX+sWwqB6jO?=
 =?us-ascii?Q?Ap3KzbotJQOB9LYHJfoNuvTHlKJyfUcGk8veO3cJdgzJFcSTpVQkgnpQS1Eb?=
 =?us-ascii?Q?/Lgj2sBjly3uLYnahqcxUSrLfOZEqZmrd1CKBvTa13m8WMyYgcKRqm1Hbebj?=
 =?us-ascii?Q?hAX9gfcXIHy7VPmTosF84v5BO6WwV1P6P7LqLWU6OlcJzQWdvB2T8/Soj8p5?=
 =?us-ascii?Q?aJu0ZpmsC9owVZiMBvHEhMyx7Urgzuv7k90+Zwum1xtwB+KiJVYuRg1JM93H?=
 =?us-ascii?Q?kOgEPcHake/elhgbAJDwmylvG2BPT8Ilb9OZhlKSxNfXvETPd9vQ9mjBdJBd?=
 =?us-ascii?Q?QWScHxPZlq05FrAK0FkGhut2El2wQ0FOFny2GkyOEZXEw8gJhBPU/3wPb8CE?=
 =?us-ascii?Q?1phme3RrngFlxpdeQVJ0sNyYQVen99Fr2mxGi9v5QNEJ8c5kx4YkO9Cb3ytf?=
 =?us-ascii?Q?WatV3yicjV7SQ++TH1TuteUvqfCVqDFbPQlK0nXjDaa/78HQw3v7icAd9Dpg?=
 =?us-ascii?Q?wajkOrsXu9IKa414WN5MFxfS4gSzvIsTmUlaUIx7a88xKeWepH0tLhdbHt7S?=
 =?us-ascii?Q?IBXTqj+hPUS0Wj57qoTHWL13h57is5C1PIN6XE7sqiFhkPqtlOmY2G17L1OU?=
 =?us-ascii?Q?sCNQlAN6VGT3uVBZptzt4wT/AIWx0fBuOZPRHTBt?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d41747da-fcc4-4190-06da-08ddb8257d8b
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2025 22:28:52.2173
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Aa0miIhRaSQnptxWn/r0Ka4j21BIVq6LsKaz7B4eTsBwrWfPAExb7L0NmV+dr8Uf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR12MB8566

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
ACS flags and technology. pci_bus_isolation() touches alot of PCI
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
 drivers/iommu/iommu.c | 243 +++++++++++++++++++++++++++++++-----------
 1 file changed, 178 insertions(+), 65 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index d265de874b14b6..f4584ffacbc03d 100644
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
+#define BUS_DATA_PCI_UNISOLATED BIT(0)
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
@@ -1534,52 +1523,11 @@ struct iommu_group *generic_single_device_group(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(generic_single_device_group);
 
-/*
- * Use standard PCI bus topology, isolation features, and DMA alias quirks
- * to find or create an IOMMU group for a device.
- */
-struct iommu_group *pci_device_group(struct device *dev)
+static struct iommu_group *pci_get_alias_group(struct pci_dev *pdev)
 {
-	struct pci_dev *pdev = to_pci_dev(dev);
-	struct group_for_pci_data data;
-	struct pci_bus *bus;
-	struct iommu_group *group = NULL;
+	struct iommu_group *group;
 	u64 devfns[4] = { 0 };
 
-	if (WARN_ON(!dev_is_pci(dev)))
-		return ERR_PTR(-EINVAL);
-
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
-
 	/*
 	 * Look for existing groups on device aliases.  If we alias another
 	 * device or another device aliases us, use the same group.
@@ -1593,12 +1541,177 @@ struct iommu_group *pci_device_group(struct device *dev)
 	 * slot and aliases of those funcions, if any.  No need to clear
 	 * the search bitmap, the tested devfns are still valid.
 	 */
-	group = get_pci_function_alias_group(pdev, (unsigned long *)devfns);
+	return get_pci_function_alias_group(pdev, (unsigned long *)devfns);
+}
+
+static struct iommu_group *pci_hierarchy_group(struct pci_dev *pdev)
+{
+	struct pci_bus *bus = pdev->bus;
+	struct iommu_group *group;
+
+	if (pci_is_root_bus(bus))
+		return NULL;
+
+	/* Skip virtual buses */
+	if (!bus->self)
+		return NULL;
+
+	group = iommu_group_get(&bus->self->dev);
+	if (!group) {
+		/*
+		 * If the upstream bridge needs the same group as pdev then
+		 * there is way for it's pci_device_group() to discover it.
+		 */
+		dev_err(&pdev->dev,
+			"PCI device is probing out of order, upstream bridge device of %s is not probed yet\n",
+			pci_name(bus->self));
+		return ERR_PTR(-EPROBE_DEFER);
+	}
+	if (group->bus_data & BUS_DATA_PCI_UNISOLATED)
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
 	if (group)
 		return group;
 
-	/* No shared group found, allocate new */
-	return iommu_group_alloc();
+	switch (pci_bus_isolated(pdev->bus)) {
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
+		group->bus_data |= BUS_DATA_PCI_UNISOLATED;
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
+					      BUS_DATA_PCI_UNISOLATED)))
+					group->bus_data |=
+						BUS_DATA_PCI_UNISOLATED;
+				return group;
+			}
+		}
+
+		group = iommu_group_alloc();
+		group->bus_data |= BUS_DATA_PCI_UNISOLATED;
+		return group;
+	}
+	default:
+		break;
+	}
+	WARN_ON(true);
+	return ERR_PTR(-EINVAL);
 }
 EXPORT_SYMBOL_GPL(pci_device_group);
 
-- 
2.43.0


