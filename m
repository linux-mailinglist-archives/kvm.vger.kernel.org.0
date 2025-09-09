Return-Path: <kvm+bounces-57145-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DEE6B50808
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 23:22:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 51AAF56075A
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 21:22:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 501D125C6EE;
	Tue,  9 Sep 2025 21:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="mJkBeUA3"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2064.outbound.protection.outlook.com [40.107.243.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB3432580CB;
	Tue,  9 Sep 2025 21:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757452887; cv=fail; b=I2ul1pyh29PXJpv2MQxD+VXCaMa5HTfKUx8PshIyoPvhVzY20YHsGVXnSkc9cEYE4zjxWG/nkKMTGPexwLY8YbRb0hzArWhQsB1qAxigYnIrxb2MzOxC4CKjwL8dq3d7atF85SHhVQVFf+a0xghbvUaGEPWYMNuYQIhAU/NAXfw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757452887; c=relaxed/simple;
	bh=afmwj+uCd/815yMAs+iUkvPHRr8hwt5ixLVIMZgn8wE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=GukrDTXbSCCEaCjaVvm4IVKSoNnyk3cg1Yrgly9yuMgrcSw0rgFXyuUR0d6eyQO1tgO1gipHcVdO4B7IA3TOCZ0Syj/FIJZarbd+VFjQw0C0P7iwgQPrk6on5Cb0ronXwRVvmn1WDDDRYsJYY3gmFQUnPMOS5KmiAIUALMFwX3E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=mJkBeUA3; arc=fail smtp.client-ip=40.107.243.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LLl4mR32+9ZjqWSHXV2Fw5kCf3LWZqBWWgocDu9Cv9RIWuBzHbRBrCFYvw8sOwx2Vpg3sG520hLLp++QfnxEAUKgIzDqgRWUekFccTVgktDAMyJXTYXFziWPniq4KTVBd9gDp5c71HGanAMZ4V7upFeXBINXmiqsEoVP6RA0EN3zTFdk+ZHqVfUOU/9J97I7t3usNQtaqoo+55/Zsf+Pxicn2ou+bf0/qxyeLrXVEQdQ4F7jvhy+nydo2Fgf+2E+WpOv53yHfsj/eBS15TPMstO1TjXolakuHymXGqnhtXdntC4abVdW1XvsKZlPpB2DIUNslOZYUN8J76BSFcVBwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j0jVJMZbPUfpAf908C9+DglU0uToTMGXvcFQQewN2bM=;
 b=wUABFkhQ8YZ2Ui872hvxy4WKTFIHppYAvEjZBVfpztUvZhq9zVE/i7YLQ7pE5cC2t8QodHDE3Uj5NxnTAONvq4FTxNt+M7Jn/ogLZnqzMFnsb40TcpDtijz91xg5oZnkwxinMUowP5/C5iQ6+Au88aRcW5veVuRN7bl6nj0ie9kCuK5JC++jnTbc7gmrXxJ7aKeP32g+bOmxk90qMVrgDotuq9SSJ+8b5Fki002Bmsqbc95uSdLatI2GJqZ/RBTa1FMeBbrz99j0/6XUOh/PYCKiTb9W4s8ZIcB+rnua01Gh6xut6sJG+LzpikUxgcgcHLZUjtzJw3uSy4MuC8G+OA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j0jVJMZbPUfpAf908C9+DglU0uToTMGXvcFQQewN2bM=;
 b=mJkBeUA3alJwDoUaQOtG5mBaJqsuHS3+yzkisoLPwjuztXIIfw1WqbUo/+i9Vk28EhgfgWeinzmQl8wFsT6CXg+ihiY6vvcSmTUzgD8ZaqfM6xc2ji1N7IxwhroAiIuZiXorgXbxQFst97YVtndVHtOKtHXFTIDiVgsNtkqtfi8vgPKtCylm8URE7+zcqpr5O5eRuakpQs+wL+RqQk4X9Qlo2KHrwRQk8X/gpFgbiPPZK3MZmZKl01wh981DVOAN5ZZUVh4Y0t9m96NftahEyqMUkiPac0ZuLXJJ9quyyv+QhtdafJdyWq67EyWC40nje1IDeqL+esapsJWRy+gFAw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
 by DS7PR12MB9528.namprd12.prod.outlook.com (2603:10b6:8:252::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Tue, 9 Sep
 2025 21:21:20 +0000
Received: from PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632]) by PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632%2]) with mapi id 15.20.9094.021; Tue, 9 Sep 2025
 21:21:20 +0000
Date: Tue, 9 Sep 2025 18:21:18 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>, linux-pci@vger.kernel.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Donald Dutile <ddutile@redhat.com>, galshalom@nvidia.com,
	Joerg Roedel <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>,
	kvm@vger.kernel.org, maorg@nvidia.com, patches@lists.linux.dev,
	tdave@nvidia.com, Tony Zhu <tony.zhu@intel.com>
Subject: Re: [PATCH v3 03/11] iommu: Compute iommu_groups properly for PCIe
 switches
Message-ID: <20250909212118.GQ789684@nvidia.com>
References: <3-v3-8827cc7fc4e0+23f-pcie_switch_groups_jgg@nvidia.com>
 <20250909202702.GA1504205@bhelgaas>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250909202702.GA1504205@bhelgaas>
X-ClientProxiedBy: YTBP288CA0013.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:14::26) To PH7PR12MB5757.namprd12.prod.outlook.com
 (2603:10b6:510:1d0::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_|DS7PR12MB9528:EE_
X-MS-Office365-Filtering-Correlation-Id: 2c6dc726-e0ae-4280-5870-08ddefe6d1f9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?UmSWjLDrOfJb3LVSY7yoWaF0GMaFLW/gA1E8cVXcyL6HeW38hfYx4aGe7jId?=
 =?us-ascii?Q?/sNcNF6JIre2f0xNrdMPr3MqQk7kgUPn1B+5Bzta8B/9eDzsurlvGqIXK6j/?=
 =?us-ascii?Q?0GSnhDB1DRmDQXjNeedScLngteOn5lubVUYEBzvimwahuUK0bGZ7CKYeaHNy?=
 =?us-ascii?Q?Bf7JKgGNlCZ/4onb+dOAhCmLwzXvHFbLIzLLcikg8dVW5zK8vKhrzjgH3S/W?=
 =?us-ascii?Q?tQ3uLxz5LkDTrQvVpQ4C5uc1/qkwKfEOcSvueTrPe+X+eMMUsjzZJe9DJQTz?=
 =?us-ascii?Q?pOXsk0mXNVy1AdLXTE5G3m7+PEnN+uefTTsbvAelWfi7RDfyZHfLZW81C6V3?=
 =?us-ascii?Q?TqPKWfJV3KKVZmkEuHqE4bE9C2rswbDhsALRcl2yEJJYOhHseNGD1OWdN4EY?=
 =?us-ascii?Q?XLKMFdzvS0sfR4hNRJBa7WnOLl/XoGK2UWFWlcLNfQuSFLcvNidACOna4Cj/?=
 =?us-ascii?Q?xF4gLKZZ9RFlKoiKMEGhF2kdadT+n97BGmQZO+wGBBOWMuJDJnN8WsiaWFqW?=
 =?us-ascii?Q?KYsPJXovxg2p/DExmQ3iI/nJXrZxhvXF1E/e8wed0QknuXr1g1WNkb2KReWr?=
 =?us-ascii?Q?hL/JwVgwKjgLjby7hOD1TjxKnkr8unHYka/voVVpjHD3vtgP2GuGIDO3yH/u?=
 =?us-ascii?Q?axSCQf/SXiM+rlMHvMpSv3J/sBbbsmb9yHculWxMkb7byqgY+Nk2QqcuRL9e?=
 =?us-ascii?Q?NbjlWnHJnGoIuAL+bVQdXKKK1wDPv+xUZstmM0fIMDeTlr8FByHk5A7BZJ1r?=
 =?us-ascii?Q?B/DkBE3CzK6bp6ufLnf1KBA5bZiU9Y7eRFDWCPbZe70fc8ukiBAiFJhzzlvV?=
 =?us-ascii?Q?0LEsXASb/EQHB7Eerlv2AIvV+lhfYXI5mR7egF8D8m2HN/u2nPuefORxb6+M?=
 =?us-ascii?Q?P56dhCvpjW6zMgwuR2pTnbBasFXLfggmVizr8GzAHV/niSl75Na7xhC8csY5?=
 =?us-ascii?Q?dXaN97G3ow0rIhBKIRkdycQWsWvf6nyjXUBHnsYeQ9fgrdogeBqtvsIgwTY1?=
 =?us-ascii?Q?WdjWFvCZG8tPgOpHPntiizrHNmvLUXClAOWG6Akh/hQqGlKn94uhHa2Zs9Gm?=
 =?us-ascii?Q?SC4KLq/wf7SiagIw9sFwb/6lY5z/grIO5DUO6WkLAksN8s6PA/rXJYF3c6pL?=
 =?us-ascii?Q?+bCyl4BfHvWkczE+yf5G9X+DlkBpY6BYVbVHRNRhPgcg0YGnXw0S4gTyyjCA?=
 =?us-ascii?Q?LCI8iEZB2n2ehbIqzsZNZMzcQRhWMo68UN/WVDXpcXN8+Ssa/S4OvSSb+hai?=
 =?us-ascii?Q?b7vQ8aSNr8fAg8iJjN1kOgmBcTzICw776eyaLE8x3DoiwlaCLqyzxEgX6f4l?=
 =?us-ascii?Q?JL5kIUfCSIDbR15lwxnSWaP+nYUvDXvHjYWlyFoFwSU1E9ZcjkLVHKyQe5rz?=
 =?us-ascii?Q?xRyzrCMkX7FSYNUNgtLAB5Rtmkr0z18uts09gN1DDiPjPbXUhgPiaP0ArRqX?=
 =?us-ascii?Q?ESbqv6TmkCU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?93a0zr1itB8I7PmmqucmDsWJ5B+2+1HgWlKEpO2dQsUeG0GFpl+RlOIDeySV?=
 =?us-ascii?Q?OmLUmEOerhA2K5aUf4zJbO4G3YnG4jjddjcZO7B3X/kGgODUAkpqsJ1Cd2bo?=
 =?us-ascii?Q?6zq3TcmA3aAKV8IRFpglPE8n23DtEuDvO0w++q3I840suYYDN57uDdEeIORG?=
 =?us-ascii?Q?g1yox0lx4nBI1kJNUv7QswukhJh9wywsESdtZXajUJ4mvgDj87MUXmh0cSZy?=
 =?us-ascii?Q?CNNebylKBS/7HHJpgjKVAmYhj4yCpKGczeW/TFgU38icPOASWXeJT3nKt3MV?=
 =?us-ascii?Q?OutxB776JLACMwkj6IqUgg2TdDYH1GfIiJhfIaGepY0Bbf9CPFGQA5LQz2cx?=
 =?us-ascii?Q?4jrHlgLEhoMwOrxtFjZrzpszB7oTT6t5VvdKL/TkbNi0ZPqyA30edk9CWyhn?=
 =?us-ascii?Q?7m4HyZ/oTZP8fYqv3HYEOF+ac/TNwDx2V7oyQL9Sb2J9ayMZTCdItvr4j9zv?=
 =?us-ascii?Q?PL6uAj+Mnchn+K3gr8vFOVTm5AmVDenW8K/eLf4+g639UHQbVviJ8mhZHQDN?=
 =?us-ascii?Q?uQLG2hO4w7F8vzeO5cy6EtgxmvdOzckLMKLz671pBu1k4SKNwoeSAUGWtK7Y?=
 =?us-ascii?Q?Y/9gRl03OD8ddOavNRliCvTSzedw8ON51IxjHwReEDVLUqc7RJODAa3rX9RO?=
 =?us-ascii?Q?KVZXyFBCQm3HCZZNKSt4DMyD2PoezXSJMT7RPNjAsz7IZTD1cqwUYl6c3wdJ?=
 =?us-ascii?Q?yO8a6i+fzzTvV6OWZGfiJoZP7oFm0EcdMpc7hTwjzzoadYR3HsmIu47KGBU+?=
 =?us-ascii?Q?Y51dlk+15Mga+e90yfsaQ7uxdJ85JI9Pxl2xRDht0qn4RPnTP3ajkPujPCGp?=
 =?us-ascii?Q?HHAnBKnb0Iv38z2XoG3bYKygxExa30xpres82lFz8zAFqbkh9JlOPeeJhDfZ?=
 =?us-ascii?Q?q8ffIC91lF4JZymF6jMKFRuLTsMAuh/Fj6pINCIbylLipQJetokpGtH3kcUw?=
 =?us-ascii?Q?stHLn4Se3RGE26c8XOgrz6XC73F1vip4DE153tGXz5EHX5FDd7Ks6wSkwm1m?=
 =?us-ascii?Q?860qjLU6ubMbr+U8WZ6lfB27s0NFEs0WuVkwbzXfnZynDxcPNjW116r/4zUE?=
 =?us-ascii?Q?9NDg2lUym/3nOMLQzEnDLxAFGxKtNycDw1jl9PaxWZrnmHE1vz1QFjcNZhrd?=
 =?us-ascii?Q?LRdT3gKYdpcEIJKzHcPxJiv7yUdoQhfVgl9sX+3MasDWKxBeZa5ZiDLeuQV5?=
 =?us-ascii?Q?XYVcIecPEqU3liIJp+6+8rpL9cOsgTvV0FeBu0pPxQtFB+Ky9s7h4cpswRR4?=
 =?us-ascii?Q?YRGY2156YYn7y0S8LOQeaKOcLh5ZBDzhT/wB07KM+moneelKMcjBYmAZaPpH?=
 =?us-ascii?Q?gu5YcBD34oBrIUnmDTdf4IA3JFVWco5KsB2Uiq3wUakrfjh3Ob87fqjlF2Zf?=
 =?us-ascii?Q?QBlpQWjcoECZk/gaapkIZCpd+zyLS2pfGCdjSM2aIMQ825NBoYdQcRCIoPwm?=
 =?us-ascii?Q?JdymoH4wB43KJn1fNOrORBUK9+nDcaQNiMiqjP4vWNbtiflJkeqoQ4esEK33?=
 =?us-ascii?Q?ifJwCmoJfM0c197Olqo8Ph6mRtmrp3wh81ukoE75bBjnfB52/FtvJ360Y/65?=
 =?us-ascii?Q?M3nlLNmgGPwHebV/MVo=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c6dc726-e0ae-4280-5870-08ddefe6d1f9
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2025 21:21:20.6158
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UPEpOOJt1yxcHccpYYF1hXYzOIiuFCGdudpkx8MzVQvcM44A/Fo6UNa34NHDAnu7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB9528

On Tue, Sep 09, 2025 at 03:27:02PM -0500, Bjorn Helgaas wrote:
> > Instead the current algorithm always creates unique single device groups
> > for this topology. It happens because the pci_device_group(DSP)
> > immediately moves to the USP and computes pci_acs_path_enabled(USP) ==
> > true and decides the DSP can get a unique group. The pci_device_group(A)
> > immediately moves to the DSP, sees pci_acs_path_enabled(DSP) == false and
> > then takes the DSPs group.
> 
> s/takes the DSPs group/takes the DSP's group/ (I guess?)

yeah

> > While ACS on root ports is underspecified in the spec, it should still
> > function as an egress control and limit access to either the MMIO of the
> > root port itself, or perhaps some other devices upstream of the root
> > complex - 00:17.0 perhaps in this example.
> 
> Does ACS have some kind of MMIO-specific restriction? 

I guess no, the text could be more generic here.

> > As grouping is a security property for VFIO creating incorrectly narrowed
> > groups is a security problem for the system.
> 
> I.e., we treated devices as being isolated from P2PDMA when they
> actually were not isolated, right?  More isolation => smaller
> (narrower) IOMMU groups?

Yes

> > Revise the design to solve these problems.
> > 
> > Explicitly require ordering, or return EPROBE_DEFER if things are out of
> > order. This avoids silent errors that created smaller groups and solves
> > problem #1.
> 
> If it's easy to state, would be nice to say what ordering is required.
> The issue mentioned above was "discovering a downstream device before
> its upstream", so I guess you want to discover upstream devices before
> downstream?  

yes

> Obviously PCI enumeration already works that way, so
> IOMMU group discovery must be a little different.
 
iommu group discovery is driven off of iommu probing which can happen
in enough different ways that it needs to be checked.


I will fix the other notes

Thanks,
Jason

