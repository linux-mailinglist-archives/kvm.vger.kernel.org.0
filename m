Return-Path: <kvm+bounces-64690-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 1EDF8C8AF05
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 17:22:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id D775A359E7D
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 16:22:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48CA533D6EF;
	Wed, 26 Nov 2025 16:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="nCib0NRf"
X-Original-To: kvm@vger.kernel.org
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012025.outbound.protection.outlook.com [40.107.200.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BA5511CA0;
	Wed, 26 Nov 2025 16:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.25
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764174109; cv=fail; b=S122hibUl91tHiA2AWOSHsohqVCTxwlcfTAewNOmoEh3BLAo6oXZ0hku/T3dx2jfkSycMz+oekANRLKPd1oVW8WFVnl9GPNqITsgQAtWJoXrXOTbUTJ4BkhSGABVQJKRrHq58i60hqSUgDV81k5Ng62ezTSAa4bdR4EcHFoCYFk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764174109; c=relaxed/simple;
	bh=7BC+oe7DZ7G0PhQt12M41WMDxl1yiyAiRtpJbKa7uN4=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=Lbcw+gcwyBnVFBP/kEcI4givr5yPmf7TKMMBfgvv2A5ugqdwMi05v3cdopi9nqZikHgWI1sB3zZ720p2gFg+zSE1u4KmKp1N6UwC9jWUkl25vMcFrhzPnR3Lq5Ibnqgttya58GVX1J1gFEtut8mOUJRmjscO1NEsbLkpsKtOJsY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=nCib0NRf; arc=fail smtp.client-ip=40.107.200.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QiIZmaZgP4ZXJMkm+aFownd3zeVcVCaRxvklMhYVbVtSAOJDQyTh7gDlxF8xN9YkuHmJVTZRluVfANd11NhTITJb6jmhRFqmVgvStFwqbFh/LFYhWCWmIKbZTnPC4PjML3amqjriQ+RqAX6LTv/lG2L+eRwMw3C4xuZiH4Pe7dF87UlbWJZtowslVsrJjFxDjs5NlGxFqKDgM5LZ7Bk47FJ73mCl/TJpWX/ExlbYDL0ysd3IlPoDUTUbP4BVKeggSIoKMXKIJsYOXFn5EtU/QsvkjtV9DFtkhmF7GuANgdOh7jLEf5986CFXUHDV7Def2moCXof8ruGERP/0K4o91g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VhxJqQYq/+HznprhzMW/D9eNion+IyCnR+AjXxD7G1k=;
 b=X956n8zp4herF4zym0DlUlhyvHdTmL4qhNT6upm1M02/+QAOr/pVgXHyDdVN5vqt9lJl0jLUhgC+fQO+8Dui7w6T9Q3PBwekHl5icXMHe7QZpyFXwytSSGpoN/xnBeGTMTeSwAQ+kZBerYilwvUHK7XYes2Q8+y2q0TuU5x5MyNuemc+hT4jNSTGbGZOReTNviS0lHCa40Yv9yhW9bT1JEywggZfcAm3m6ktrgewTkFBq1Bsv7QfaBYgoqH7g6gKma6RHVn0FF0b6AGJI/aFn913Cg1pHJgXaaOIYO08AC+TAxLu00RA2VnId+QOh0xDCisqXAgBLHarGuycgs6nkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nvidia.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VhxJqQYq/+HznprhzMW/D9eNion+IyCnR+AjXxD7G1k=;
 b=nCib0NRfKIbW4vn3YKSnzwvXNz61YFnl4kzkeaCCZzisPoASJ3vDL4g7zidBFePrFWyxPtEC6V+CxfZrgOUWtMGe+BtyNN72U8TTXwxJ5w7JAdifXu+6m4SwC4o9YqjFgp7btn8YaMJ6aUvJ/J9x8SVzEMK2twr7R5hA6LNGk+c=
Received: from MN2PR01CA0055.prod.exchangelabs.com (2603:10b6:208:23f::24) by
 BL3PR12MB6450.namprd12.prod.outlook.com (2603:10b6:208:3b9::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.12; Wed, 26 Nov
 2025 16:21:41 +0000
Received: from BL6PEPF0001AB77.namprd02.prod.outlook.com
 (2603:10b6:208:23f:cafe::b) by MN2PR01CA0055.outlook.office365.com
 (2603:10b6:208:23f::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9343.18 via Frontend Transport; Wed,
 26 Nov 2025 16:22:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL6PEPF0001AB77.mail.protection.outlook.com (10.167.242.170) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9366.7 via Frontend Transport; Wed, 26 Nov 2025 16:21:41 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 26 Nov
 2025 10:21:40 -0600
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 26 Nov
 2025 08:21:40 -0800
Received: from [10.252.200.251] (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Wed, 26 Nov 2025 08:21:35 -0800
Message-ID: <6d85514f-3d55-43ae-a00f-334f8a5f81fb@amd.com>
Date: Wed, 26 Nov 2025 21:51:34 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 0/5] Disable ATS via iommu during PCI resets
To: Nicolin Chen <nicolinc@nvidia.com>, <joro@8bytes.org>, <afael@kernel.org>,
	<bhelgaas@google.com>, <alex@shazbot.org>, <jgg@nvidia.com>
CC: <will@kernel.org>, <robin.murphy@arm.com>, <lenb@kernel.org>,
	<kevin.tian@intel.com>, <baolu.lu@linux.intel.com>,
	<linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-acpi@vger.kernel.org>,
	<linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
	<patches@lists.linux.dev>, <pjaroszynski@nvidia.com>, <vsethi@nvidia.com>,
	<helgaas@kernel.org>, <etzhao1900@gmail.com>
References: <cover.1763775108.git.nicolinc@nvidia.com>
Content-Language: en-US
From: "Srivastava, Dheeraj Kumar" <dhsrivas@amd.com>
In-Reply-To: <cover.1763775108.git.nicolinc@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB77:EE_|BL3PR12MB6450:EE_
X-MS-Office365-Filtering-Correlation-Id: 86831d91-484e-4759-8545-08de2d07e1e9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|7416014|376014|36860700013|7053199007|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WUJPV1lTOFJhMUNIU3liM2RLM0J3a1BqZUhlc1FyQ3lGdmVJVmNPTnozNHpn?=
 =?utf-8?B?dVJDYlhUc0oxb05PeCs1MERRb0FKR0lDWGp1Y3ZoWXhiaGpqbVJvMkw1RUNt?=
 =?utf-8?B?cVpNU200L3VoNi9MZms2YzArWTN1alVmck9tdEJmcDRtcHZiM3BwNUpPWEJR?=
 =?utf-8?B?RWpQc05Xc0ZCVW9JdURsSjdXck8vZm1kTXIrSk1HM29SOUlVSkFSdzBUYnM2?=
 =?utf-8?B?MDBFNDhwK0QvbTM0NHNBUzBaSll5YnVDSTFiYVQzbFRWbFpKY1l1dXRIaDJO?=
 =?utf-8?B?b0x1aUY1bnFBM2VPckR5TXErUlVFYXFjNVNwb0tPQ2pUTDRuZHRxNmtrZVR2?=
 =?utf-8?B?TXZ1eWhudk1IWU9IL05GVGxjVUoyWlRlLzVseHVzM1RHSHU1UWViQ2RVYWdo?=
 =?utf-8?B?ck5NMVRadGg5QU8yK1BDYlhSSTBYb0dMMUF6M1VaYk52ODRvM05qNFBmU0JZ?=
 =?utf-8?B?WmV2YjhMellWM0xKckZNWmx4U3h1RGwyZm9XUlN4WE91dytTajBVcXI5a2pi?=
 =?utf-8?B?dWZhbENQQmY2SDhLZEY0M2k3bjFXcEdPeEliZ24xVUpaTkQ4UFJDNHN0N2xq?=
 =?utf-8?B?Qk1rRlowSTlvbUZUeFJCNitGUHVVWWpKVkdjQzNtemYxVnhQUGM0N3ZNbUFH?=
 =?utf-8?B?bFJhUzl6N3VIeHZ3WnJ4TFpweDVKTmcrUDg3czMxdXZLWGlZYi9nT2NYek8r?=
 =?utf-8?B?Z3R6NXFtZ2Y1TGFybk44L0t1d1FGR0FtOCtiOC85aEw1QzBleGhtbzNZZnFQ?=
 =?utf-8?B?ZE81dUpMSk5vZDdmaDBGdk51cTJBNnVJc1YraDE0ZFgzczFFaUJvM1JEUUh0?=
 =?utf-8?B?UnRwTDdNTnN1cGk1ZEMrdjlFVURSK2dVVGs1N2NzK1c2cC9nSVR0N2UvS0FH?=
 =?utf-8?B?YVI2aldubzZYRElTbmtsdEROUGpWcXpRS2Jqa1ZRZUVYQ0k4ZjFXbkRGcFlR?=
 =?utf-8?B?anNuNTVZUmdNUGVsMnZQZFJzb1FBby9jSS9RQW0zcURLMG1PZEhvZ3FDVWQ2?=
 =?utf-8?B?WnVlNll5bWlGa2cyK2pNYUFUUDgwbGlvYWI0ZTNVeXlIV1U0bms1RERzUTZX?=
 =?utf-8?B?Wjc5dlY0VktjSGh0bFRDcXdRL3p2Zmg1eE4vUzdUblA4WjlHUnZLRlJCbUND?=
 =?utf-8?B?SEh2QkU0VU4zbVYyNjVicG1STEZuSlN6amJhcDQ4dFdmd1VlWTNaaFhPR3M4?=
 =?utf-8?B?YWhNakt4bDdHdGd0VHMzbkRjbm5jb21kRlB1SzQrZXZLa0l6MXFqajhwUjVJ?=
 =?utf-8?B?YWJXVkFJMWxGV01SdFZ5UjNNWkxKNmVNOEk4SmtCYy9hY3g5enUvUEl0dHY4?=
 =?utf-8?B?STE4TFQ4MW5maVdvaFljVFRocWlCWnNUdkVhbCs3Nkc2SkFuLzNWRWhicDBG?=
 =?utf-8?B?QUhuNjFmOE5rTkpXYkYxcmFXSWozekQrWTFiVUFlOGpnalJYcTl1dzFkcnRB?=
 =?utf-8?B?NVhHVG1VZUVKU3hYNzhEQUxkcHZHSXJHQk9BeUxiNzB1aVVWTFVpL05yckFY?=
 =?utf-8?B?aGVrSmN4aWU5cmVRMDNGL2FmbUlrU1N1ZkFzVFRlZTltMkw5eFZQMjU3cUQ2?=
 =?utf-8?B?TjdVMEwwVjJ6REZ0a3dCODU4MXBwOUIxOWE3cEczNW44dUdRZ25UNmhIcG9G?=
 =?utf-8?B?dnp1OHVYSnE2OXBRM1NJMWhZdk1QSy9CdnhvRDAwbTJvYzgwazhPQXZ6Qnps?=
 =?utf-8?B?Mk1aMi8vTEhrTkEwTEtUdVcrSEQrQzRMNkZCUDkrK0xWVXdQWWJwTkF5MXRy?=
 =?utf-8?B?aGR1blJIdnM1a3o5Ym54dmxzQWJuUjRYK1VqcjVERDczclpETlQzaytFMk40?=
 =?utf-8?B?VkUzWmw3TW1Tc0doY3NBUm1VV01jZkhYa1pJRGI1M0hjYXVSb2RIbGxQblk1?=
 =?utf-8?B?TDhLTmpkdHZ0OXE5RmtRZ3FGbmlCV0tZUlQ2Vm02WEdITW5HTmpleGNkN3FE?=
 =?utf-8?B?TlBFSEExYXhlN28ydUorbHVuRTRRL1ZFNU9HM01Ga1pSais5WDEycGVEanR1?=
 =?utf-8?B?K2xOVFZRdVBVb2hmT25WVWt1eVAxdWRIWjhYY0JqV2NxMHlXTUJOMWpSQjhp?=
 =?utf-8?B?akNLeVJOOU9BV1c1K2cwckQ2MXhFaE5VLzN4dDk3UHlVMWhnVm1tTEVvOGZ6?=
 =?utf-8?Q?Ysg9AuZwBYiwnhhaKoPiKHzA9?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(7416014)(376014)(36860700013)(7053199007)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2025 16:21:41.0950
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 86831d91-484e-4759-8545-08de2d07e1e9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB77.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6450

On 11/22/2025 7:27 AM, Nicolin Chen wrote:
> Hi all,
> 
> PCIe permits a device to ignore ATS invalidation TLPs while processing a
> reset. This creates a problem visible to the OS where an ATS invalidation
> command will time out: e.g. an SVA domain will have no coordination with a
> reset event and can racily issue ATS invalidations to a resetting device.
> 
> The OS should do something to mitigate this as we do not want production
> systems to be reporting critical ATS failures, especially in a hypervisor
> environment. Broadly, OS could arrange to ignore the timeouts, block page
> table mutations to prevent invalidations, or disable and block ATS.
> 
> The PCIe spec in sec 10.3.1 IMPLEMENTATION NOTE recommends to disable and
> block ATS before initiating a Function Level Reset. It also mentions that
> other reset methods could have the same vulnerability as well.
> 
> Provide a callback from the PCI subsystem that will enclose the reset and
> have the iommu core temporarily change domains to group->blocking_domain,
> so IOMMU drivers would fence any incoming ATS queries, synchronously stop
> issuing new ATS invalidations, and wait for existing ATS invalidations to
> complete. Doing this can avoid any ATS invaliation timeouts.
> 
> When a device is resetting, any new domain attachment has to be rejected,
> until the reset is finished, to prevent ATS activity from being activated
> between the two callback functions. Introduce a new resetting_domain, and
> reject a concurrent __iommu_attach_device/set_group_pasid().
> 
> Finally, call these pci_dev_reset_iommu/done() functions in the PCI reset
> functions.
> 
> This is on Github:
> https://github.com/nicolinc/iommufd/commits/iommu_dev_reset-v7
> 
> Changelog
> v7
>   * Rebase on Joerg's next tree
>   * Add Reviewed-by from Kevin
>   * [iommu] Fix inline functions when !CONFIG_IOMMU_API
> v6
>   https://lore.kernel.org/all/cover.1763512374.git.nicolinc@nvidia.com/
>   * Add Reviewed-by from Baolu and Kevin
>   * Revise inline comments, kdocs, commit messages, uAPI
>   * [iommu] s/iommu_dev_reset/pci_dev_reset_iommu/g for PCI exclusively
>   * [iommu] Disallow iommu group sibling devices to attach concurrently
>   * [pci] Drop unnecessary initializations to "ret" and "rc"
>   * [pci] Improve pci_err message unpon a prepare() failure
>   * [pci] Move pci_ats_supported() check inside the IOMMU callbacks
>   * [pci] Apply callbacks to pci_reset_bus_function() that was missed
> v5
>   https://lore.kernel.org/all/cover.1762835355.git.nicolinc@nvidia.com/
>   * Rebase on Joerg's next tree
>   * [iommu] Skip in shared iommu_group cases
>   * [iommu] Pass in default_domain to iommu_setup_dma_ops
>   * [iommu] Add kdocs to iommu_get_domain_for_dev_locked()
>   * [iommu] s/get_domain_for_dev_locked/driver_get_domain_for_dev
>   * [iommu] Replace per-gdev pending_reset with per-group resetting_domain
> v4
>   https://lore.kernel.org/all/cover.1756682135.git.nicolinc@nvidia.com/
>   * Add Reviewed-by from Baolu
>   * [iommu] Use guard(mutex)
>   * [iommu] Update kdocs for typos and revisings
>   * [iommu] Skip two corner cases (alias and SRIOV)
>   * [iommu] Rework attach_dev to pass in old domain pointer
>   * [iommu] Reject concurrent attach_dev/set_dev_pasid for compatibility
>             concern
>   * [smmuv3] Drop the old_domain depedency in its release_dev callback
>   * [pci] Add pci_reset_iommu_prepare/_done() wrappers checking ATS cap
> v3
>   https://lore.kernel.org/all/cover.1754952762.git.nicolinc@nvidia.com/
>   * Add Reviewed-by from Jason
>   * [iommu] Add a fast return in iommu_deferred_attach()
>   * [iommu] Update kdocs, inline comments, and commit logs
>   * [iommu] Use group->blocking_domain v.s. ops->blocked_domain
>   * [iommu] Drop require_direct, iommu_group_get(), and xa_lock()
>   * [iommu] Set the pending_reset flag after RID/PASID domain setups
>   * [iommu] Do not bypass PASID domains when RID domain is already the
>             blocking_domain
>   * [iommu] Add iommu_get_domain_for_dev_locked to correctly return the
>             blocking_domain
> v2
>   https://lore.kernel.org/all/cover.1751096303.git.nicolinc@nvidia.com/
>   * [iommu] Update kdocs, inline comments, and commit logs
>   * [iommu] Replace long-holding group->mutex with a pending_reset flag
>   * [pci] Abort reset routines if iommu_dev_reset_prepare() fails
>   * [pci] Apply the same vulnerability fix to other reset functions
> v1
>   https://lore.kernel.org/all/cover.1749494161.git.nicolinc@nvidia.com/
> 
> Thanks
> Nicolin
> 
> Nicolin Chen (5):
>    iommu: Lock group->mutex in iommu_deferred_attach()
>    iommu: Tidy domain for iommu_setup_dma_ops()
>    iommu: Add iommu_driver_get_domain_for_dev() helper
>    iommu: Introduce pci_dev_reset_iommu_prepare/done()
>    PCI: Suspend iommu function prior to resetting a device
> 
>   drivers/iommu/dma-iommu.h                   |   5 +-
>   include/linux/iommu.h                       |  14 ++
>   include/uapi/linux/vfio.h                   |   4 +
>   drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c |   5 +-
>   drivers/iommu/dma-iommu.c                   |   4 +-
>   drivers/iommu/iommu.c                       | 220 +++++++++++++++++++-
>   drivers/pci/pci-acpi.c                      |  13 +-
>   drivers/pci/pci.c                           |  65 +++++-
>   drivers/pci/quirks.c                        |  19 +-
>   9 files changed, 326 insertions(+), 23 deletions(-)
> 

Tested-by: Dheeraj Kumar Srivastava <dheerajkumar.srivastava@amd.com>

Thanks
Dheeraj


