Return-Path: <kvm+bounces-64686-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 517EDC8AE7F
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 17:17:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 001884E1C28
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 16:17:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BE6033DEC0;
	Wed, 26 Nov 2025 16:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="PnB7M0xY"
X-Original-To: kvm@vger.kernel.org
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010070.outbound.protection.outlook.com [52.101.201.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C28D25487C;
	Wed, 26 Nov 2025 16:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764173842; cv=fail; b=I/uQYzuhNLFjsIpVprmFjes+ejRPzyif7K5Y+JL3JIzMW5RfChHGZ23vAGjIUh/7RytQpJ8KBMRy5euTh9PBkWhka+m5j78uPhUlr2CVh+nhAN2bU+t2FROySctAnTDmeyzMB6u/dQlDq3GtirHl0fv/rih/nunh9g4pP+YWg5Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764173842; c=relaxed/simple;
	bh=59dbul5u+a5/eEc9+HVPaPgFdQqoiHNrx+O01kjC4hU=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GW5BynJp0GE2Gew+UimF7bXVdyNJLazwc8ySxtueX9m2kR6wcAvN2WWqZhB2v4//0xy/Wl/91IP8/9jcmGni+5/UbYG/7WyyDoZg1yDaCbWZ/DuXNznLAZWhcYVRyV1G00LMLDtThU66KPz4A8252yPWL9M/lQ7LOkdBndX40Xk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=PnB7M0xY; arc=fail smtp.client-ip=52.101.201.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=muEvsr01lyaLhIOmVAoGRb6fHLXxPuKu0O2OkBmj8w13NNGeUvWoYIwZEl/OKYWS9TguENN/QWHlGbyL8p8t39r3AAXQ0z/0aR1M/qWXidNM/UfQqwfFPWryTTY12FYXjxrz5p/vQ1Gee0zIy5YMWYXT6OmhZr7Oa2N7CmUXoWny4+j9cjqvHRdHydevxmujDTUtxHgTyokNh0nSOcSA0u74APlGgK27g8WatI3VGbHttmZA6T9WMhd0rSkxcUP5DQRE+D++mlN5ZWkv2Ywtm5TJCmI5tyWJL5lzDE7bvma334pHUvzeJmBNgFgZPLPYSoBfUFcbAYPJXJuTHAJC9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BT9J92y2KCsCjcSJEXZha/lFViLEelcSyMMy7Qud3EE=;
 b=vLZQdsaeysDF500/7HToV0cCW++TGqQ5FzO8qOCUoE5ZrBfgXfylrE6jXWjCpqAEVQVrjRoUbvMkTB+k7dkN1SmvGhTNGcE1yjii5DatA4g3zigN1F0Z9evvd72PJ2xgfiZJvxvWh81m2B7oml7NupY2YWC+c8Nk4cTQSlr9yMNNc4G3EzWNM0Yy0LwSFu4aMt0Gd74bbda6N658SYUBKkKH7H1IkQ+sm/kSDcfGbptgHWXC+X4vpmrI09a5q/dGgb+pN2tGNU0BtSUUs4pnX4g7BHxszb2rkwxNadt81bva11KROcYbczi9T6jbkoQHtD3PT2nNeYhTIK0GscwsCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=amd.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BT9J92y2KCsCjcSJEXZha/lFViLEelcSyMMy7Qud3EE=;
 b=PnB7M0xYEnSSdvzJCR49HHiH9cdY7gPGranJEnAtfJFXg1mlDIzGE9Z5d59R6kZgBhZxuHTB8M8iZjBqRMJYPWyNd1LzWxIFvuSA0xMs72jrHUh6KOoCkORgZduQxwfdb1jWOvQk/KRNuWtalDYYkHo+BjnYIU/H70PQ0Wv0krkvkw64KkK5LxB8vvBGX+w4WaAeEQ+1L+82hxO7jFueeYwbZfGf8mcFZu5TkZ/8xKNSfH1BJGP/sx05DF20NFxtFQZoT5SkwbEMlsriKBfUVopLIuj1iJtg12DVWVwNRurlJ/ZBx0ghTx+Eyj4bvepdmnLLqI/yoXujCt8cVtgm9A==
Received: from SJ0PR13CA0043.namprd13.prod.outlook.com (2603:10b6:a03:2c2::18)
 by CH3PR12MB7547.namprd12.prod.outlook.com (2603:10b6:610:147::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.12; Wed, 26 Nov
 2025 16:17:14 +0000
Received: from SJ1PEPF00002320.namprd03.prod.outlook.com
 (2603:10b6:a03:2c2:cafe::8c) by SJ0PR13CA0043.outlook.office365.com
 (2603:10b6:a03:2c2::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9366.11 via Frontend Transport; Wed,
 26 Nov 2025 16:17:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ1PEPF00002320.mail.protection.outlook.com (10.167.242.86) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9366.7 via Frontend Transport; Wed, 26 Nov 2025 16:17:14 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 26 Nov
 2025 08:16:58 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 26 Nov
 2025 08:16:57 -0800
Received: from Asurada-Nvidia (10.127.8.13) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Wed, 26 Nov 2025 08:16:56 -0800
Date: Wed, 26 Nov 2025 08:16:54 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: "Srivastava, Dheeraj Kumar" <dhsrivas@amd.com>
CC: <joro@8bytes.org>, <afael@kernel.org>, <bhelgaas@google.com>,
	<alex@shazbot.org>, <jgg@nvidia.com>, <will@kernel.org>,
	<robin.murphy@arm.com>, <lenb@kernel.org>, <kevin.tian@intel.com>,
	<baolu.lu@linux.intel.com>, <linux-arm-kernel@lists.infradead.org>,
	<iommu@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<linux-acpi@vger.kernel.org>, <linux-pci@vger.kernel.org>,
	<kvm@vger.kernel.org>, <patches@lists.linux.dev>, <pjaroszynski@nvidia.com>,
	<vsethi@nvidia.com>, <helgaas@kernel.org>, <etzhao1900@gmail.com>
Subject: Re: [PATCH v7 1/5] iommu: Lock group->mutex in
 iommu_deferred_attach()
Message-ID: <aScn9t5ctN7FgRKD@Asurada-Nvidia>
References: <cover.1763775108.git.nicolinc@nvidia.com>
 <a7ebae88c78e81e7ff0d14788ddff2e6a9fcecd3.1763775108.git.nicolinc@nvidia.com>
 <1f65de37-db9f-4807-a3ff-6cd377c855a5@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1f65de37-db9f-4807-a3ff-6cd377c855a5@amd.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002320:EE_|CH3PR12MB7547:EE_
X-MS-Office365-Filtering-Correlation-Id: 369c9118-1291-418d-922b-08de2d074319
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|376014|7416014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SXUya21lUlc1UW44cVlaNTJpclpJbjNXcjY0M3RtY0s2bUc5dDFub3dwYkdr?=
 =?utf-8?B?UGNodTFmdXJOSHlXMEhCUXlqRTdVK2x3S2Vka094Y3Vyc3dXbDAzUmM0L1NI?=
 =?utf-8?B?U2hRazc5ZEdoczUwTlRvRzlyb2JhSy9URlF0M1J5c0VCUlQ2WWNXSVlFWWdt?=
 =?utf-8?B?U2ZjLzdHSE9LM0VDaHdkdHNBRTl5OEtGcVI5WnlSTlcyUFJycXNsMXdDYmVk?=
 =?utf-8?B?eVJGbmwwWDRKVmdiYVFVNEJyMG9nVGx4OFU0cDNMRFM5ZGdPdkFTM0FLVm9k?=
 =?utf-8?B?SDlqM21JOFJLMnJGNklCbDU0dUFPbVNLVTdqS04rNzg3NVZKbmlrSXFvTGFK?=
 =?utf-8?B?aWpVSUxQZjdVSEd2USt6MzRZYjVRZm5xUy91MGdkY0x0WW12NjRacHQ0NHhP?=
 =?utf-8?B?Y0hqYTN2Z1B4dy95ZTVMVncrSDYzM20zbW81ZVMrVHFHMUdkOHJ5SldhNlRU?=
 =?utf-8?B?ZDhvWWdNY0xMeXZmeFlsK2dWQ3k3Ly9zb0gxQ3NsMVNHTUFCOUZJa1E0ayth?=
 =?utf-8?B?bm9xdGRWTDh6ckdCMlg4TWczNlR6b2lmKzhtNk82ZDNlcTRsMGRHNzdPWXRu?=
 =?utf-8?B?QXhhTy9Td3dDUDZUWEVIdzZpSStnOVI4OWhRVElmSnVXSDRsNExaSnFKZzBm?=
 =?utf-8?B?THZ5cEZ0bnVRNTduOWRsRE1PeWRLZ2NPUUhvY2RIOXlVQ0NLNnlNYjNBTk00?=
 =?utf-8?B?cUVKKzIveHA1Q1RCNzd1QVRmT2x5Y2hSeFordzBIaDR5a0txejVVdTR4RHF4?=
 =?utf-8?B?L2Z1cnRyWnROWlhIZFhMczdnUjV4TXZ1dWQ1WDQwaC91d21lZFFObHBVdlVW?=
 =?utf-8?B?a2lXM1BSYTVEWVpVVHBJV3hhbTd0ZndyV0VHakpQZXZ6TE5QS1RSbll2NWdC?=
 =?utf-8?B?czc5L0wrcHZ2M1B1cnRFVGVKQkwvVzJROURISlJBejduTGc0YzZYQ2htRGox?=
 =?utf-8?B?S0tLbXh2TlV0LzkvNDdWTlYxRjNHenJnOURhQjlGRkptNi9uKy8xUmRSc3p6?=
 =?utf-8?B?QTA1VWZReFFQMzFHalVtU1FsOG1FeUV4ZUNsY3htcDR6L1ZKdTI0L1ExN2Fa?=
 =?utf-8?B?cE12anFDM2tDaWszaFREdjl6THd3Zm1uSElFOWp0bjd4NStPdXBmVkZVODU0?=
 =?utf-8?B?NDBNY0gwcmlaU1dCQ1ZMNEFINDNnNEx2R3ovSWNSQnd0VXV1MGtGRzJBRWJw?=
 =?utf-8?B?S2MrWW5BTG5ab0VXRjI1WVJXMzJ0T2R0VzNSaEdnNEtMdThhUUxJRzROcnV3?=
 =?utf-8?B?T0tSdVRuZVJvU2NlV0ZwalhvMlREc3Q4YUtvTDVralFuVnYzR1ZGUHlEc29p?=
 =?utf-8?B?TzJnSklJa1RrTDdTRXJ1YXFOeittZ2xTME11VFYweVB1Y25oOGw5dkJ0M1Bx?=
 =?utf-8?B?Y2twWWZ5Kys2RkNBOTlhaUxiRFlGbHV0amdDOWpUSE1UMW1POXpaR3VrU013?=
 =?utf-8?B?c1VYYWN2bE9UcGg1NFc5SiszanAzWWZVL0I1Sy9iUGZLazBsM3ErNGtjeC9B?=
 =?utf-8?B?U1I3ZEJmSGlWRit0MDJFSFZxWlNkbFFLRkRqb3BHd1FnaStlK0t1YVk5WHUr?=
 =?utf-8?B?MnZuWUVEb05idnNkWTU4WktkalI1MVVmYUlkbGkyR3l1cGJQVnRSdHlUK1Ex?=
 =?utf-8?B?SWJNTVNyWXBsWE1lZ2g3OVlqMjBBTHRUUGVpdUN4WksvUmx6S3VINVB1clFs?=
 =?utf-8?B?aUlpZjRscldCWElkUTVZYS9tWlBCbWQ3TlFWcVNIa0szcVY2ZWwyRCt4MVUz?=
 =?utf-8?B?WEF1dHQ4SDBVUTRkdVkzTHVjdWNGYjFkTVVLT2lnYUk2NEIrRmJsMmQxNzlu?=
 =?utf-8?B?L0V1ZjYraU1hcks3WVZDSHpvdWtrQ2tTdnlVRnYzM0NVZytEM3g1eHBlRkdx?=
 =?utf-8?B?NFAyM1NGWHFrTndDNlpmY28zUUtFTHVteDhTalBUMHlEYU0vRUVvQUVqOGMw?=
 =?utf-8?B?K2p0RVByS3VtdWQ0T2hXcVdsbjNUbzJaWEtzQUYrcEpUbmp6SC9BMlhETDlJ?=
 =?utf-8?B?eGl2Kyt2L05jZlhnTWlKU2dWb0VUS2VJZ2dZYzZBZS8rSjhScHV5ZERaQXhQ?=
 =?utf-8?B?dzlsWmE3dm5rQm15bUw1NGNVNytYeSs2amplZldnNmxIYi9VNUNBWDFYRXlG?=
 =?utf-8?Q?nDqQ=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(376014)(7416014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2025 16:17:14.6630
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 369c9118-1291-418d-922b-08de2d074319
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002320.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7547

On Wed, Nov 26, 2025 at 06:25:34PM +0530, Srivastava, Dheeraj Kumar wrote:
> On 11/22/2025 7:27 AM, Nicolin Chen wrote:
> > The iommu_deferred_attach() function invokes __iommu_attach_device(), but
> > doesn't hold the group->mutex like other __iommu_attach_device() callers.
> > 
> > Though there is no pratical bug being triggered so far, it would be better
> > to apply the same locking to this __iommu_attach_device(), since the IOMMU
> > drivers nowaday are more aware of the group->mutex -- some of them use the
> > iommu_group_mutex_assert() function that could be potentially in the path
> > of an attach_dev callback function invoked by the __iommu_attach_device().
> > 
> > Worth mentioning that the iommu_deferred_attach() will soon need to check
> > group->resetting_domain that must be locked also.
> > 
> > Thus, grab the mutex to guard __iommu_attach_device() like other callers.
> > 
> 
> Tested the series with PCI reset on PFs and VFs, including device
> pass-through to a Linux guest. All scenarios worked as expected.
> 
> Tested-by: Dheeraj Kumar Srivastava <dheerajkumar.srivastava@amd.com>

Thanks for testing!

Yet, this is replying to PATCH-1. So, you might want to reply with
your "Tested-by" tag to PATCH-0 :)

Otherwise, default B4 command might miss your tag in other patches:

  ✗ [PATCH v7 1/5] iommu: Lock group->mutex in iommu_deferred_attach()
    + Tested-by: Dheeraj Kumar Srivastava <dheerajkumar.srivastava@amd.com> (✓ DKIM/amd.com)
  ✗ [PATCH v7 2/5] iommu: Tidy domain for iommu_setup_dma_ops()
    + Reviewed-by: Jason Gunthorpe <jgg@nvidia.com> (✗ DKIM/Nvidia.com)
  ✗ [PATCH v7 3/5] iommu: Add iommu_driver_get_domain_for_dev() helper
    + Reviewed-by: Jason Gunthorpe <jgg@nvidia.com> (✗ DKIM/Nvidia.com)
  ✗ [PATCH v7 4/5] iommu: Introduce pci_dev_reset_iommu_prepare/done()
    + Reviewed-by: Jason Gunthorpe <jgg@nvidia.com> (✗ DKIM/Nvidia.com)
  ✗ [PATCH v7 5/5] PCI: Suspend iommu function prior to resetting a device
    + Reviewed-by: Jason Gunthorpe <jgg@nvidia.com> (✗ DKIM/Nvidia.com)

Thank you
Nicolin

