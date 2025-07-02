Return-Path: <kvm+bounces-51243-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A9F5AF0823
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 03:47:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D00DA7A38F0
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 01:46:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 116B918DF6D;
	Wed,  2 Jul 2025 01:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="W1NfwnPi"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2080.outbound.protection.outlook.com [40.107.237.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 215548F77;
	Wed,  2 Jul 2025 01:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751420864; cv=fail; b=U4jMbSH0yTcg25tBoCIFpUWbeffP8dxY4CDHtKAvBWK+Rcu1XtQ7mn8EGH/4Tw4AkQzMgEta32k/Wm0RSabRPLlxgJLgpLGyIne3eBjQN5rh82RkoT19vJFMsdlfvSGVpBQXR2dka9DtxZ6OSRb9+fLXh/T/xF6UtTEgJxhVvlU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751420864; c=relaxed/simple;
	bh=Hvvyj1NOx3zkWlxiGwmUpFkjeOssOa9OAznxUP6HpAo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=jAdXc/2HrlXWOq8aL54s/p/gnoJATlDF9y+5GBXP21Vef7NuE58LTuNDMxzMwHIP4Kv2Q+MrXtRha62OtihVxJA5Pa0ZJIM5KDxUF1IUAWCHUbrv8CWQt156WQYWBrkCP82KSWShPvzQvYm12+MJI4r6R3X6yYL5EKNHHJYNaTk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=W1NfwnPi; arc=fail smtp.client-ip=40.107.237.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dPDnPFuH9YUGdOZpkj1z2oTtPz+L7ENxPU52rPnMfjnqehMJV1BF7/p421b6GjJmowXr6GehzWi/MpUVIE1nDHA7/sbouG1ZUdOlc5x3wSOBrzshTqTeo+/gMR4hxBx+GqEaxqlv3PfP4hqDtGikkDZYnu8+CAUmjKz3wcci/J1dBrc9HpNMLgi7ygAQHhsqVrDY5JmpezK9RBCY/25FdPfonpjM06bIhSzW+e11tXJv2XldNvZvdP+6cuv6C1k1KraJTCW4lwWNPeEoU2QNRO8X2LrQVksVcLlaR9dFycqNHECqs30f06D1aw+VHC6cHkzfDp70o26sh4d3xSuX1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bjNyhojoWlWqHWO3yP4bIelc3QmpxupmuKu0OFE073Y=;
 b=qiFfKX+5Pzr3dZcK7yKFDJt8k4d8rJI374cxw0zoIj5kEhFfoaFgknJutdc8bD+b35mYufOpUk2x0oGe7izbFWuSZDH5l7WbPpYyqjvRi53lFjwCH+4jdZOsV8Dpw8JcienhU3ANdq/4DeckprD6vA7sd4UluxOjHpicaK6oQgd9WVu0bhnssZLFwKGSZXYUdrguOY+q6Gjru/BTgnIyqtJftXudVEThXxrsuzA8tINwob52gPE9NLpdK+tVnpw45QDGPdP6F66BuO6nLIl//h4If4dLqHBiZeFKzCgNITTB+OsabRR3JqIAwjhn7v4Iaeii8P6afXBAW+dMfRzAuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bjNyhojoWlWqHWO3yP4bIelc3QmpxupmuKu0OFE073Y=;
 b=W1NfwnPipW2r1tngkbKyaKQ8lSnvUnShaNML8zSJCofUxe34FA2GCqw1zJDQl/N3PEw0CV9SZ9z7X9R04hRgF2rJw/4CEAsH+bfRTvemQOx4UZNvHUufv4E22rJg1trd9zFwj+P1bbxI3flpGlKTPCG+aKfgJ/kIdLNqIY8jc8YPXyBsx/StMuAmok4yZweFBID0tDSPR87gKbItqej/TGPMpfwZCdIzQQ4GTsq7ZQJcWMxYLmvijAI3nTmIB/r8ZHkSnAxbl3VQJkX0pdOuoZM25hipDrIflgZ2Y4dUdhqwocRVu8vxHdNvYGOwUGWvkNXaRwCfb6Mtybh3sr7lUw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by CY5PR12MB6429.namprd12.prod.outlook.com (2603:10b6:930:3b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.30; Wed, 2 Jul
 2025 01:47:35 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8880.030; Wed, 2 Jul 2025
 01:47:35 +0000
Date: Tue, 1 Jul 2025 22:47:33 -0300
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
Message-ID: <20250702014733.GC1051729@nvidia.com>
References: <0-v1-74184c5043c6+195-pcie_switch_groups_jgg@nvidia.com>
 <20250701154826.75a7aba6.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250701154826.75a7aba6.alex.williamson@redhat.com>
X-ClientProxiedBy: BL1PR13CA0104.namprd13.prod.outlook.com
 (2603:10b6:208:2b9::19) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|CY5PR12MB6429:EE_
X-MS-Office365-Filtering-Correlation-Id: e8ab0ce3-172c-4a06-7794-08ddb90a6a76
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?503RnlUrxDjSsu4ETWKsdaOw6Ciw8+GIPDgYjzmR3nbs9YVRSx7ursGfKZGG?=
 =?us-ascii?Q?ZLeDefkbGb8Va6pjpB3X3YnM+BPG9toLZM8SlbR5CmOsZ2gqLWdiEtLdUd6c?=
 =?us-ascii?Q?BRSVkssK1ii1tLRxfkB0Km0AU5sdYOk26cwMwt13+yNTfr6oxf3449lZ64nD?=
 =?us-ascii?Q?WSuLbuNU5d+EQ/jzuQfdejb5TEVqICpne/frmLi5WD393uQ6H8AtHsiuAXTT?=
 =?us-ascii?Q?akTn5QjlfEKW5WN0dZPNhP3PAFtbC5PKH6vdUI6++nqyWo1L4E30B9dpWOuC?=
 =?us-ascii?Q?aBXM53aKq4ePIQTX55fRgelBgg9rpPXNB/pDZJLFW0rhmxdpJXWWfZvDKezG?=
 =?us-ascii?Q?s0jFMrk9I1ALrhFJt/fcio3QirmMcWR7AoWlGcVE0B/yRcs7JNn+0whAtENS?=
 =?us-ascii?Q?EmLz8+7VDSZIw5HQTFyIWX/Mame/WaWUm6SJ5hZTqIklN8K1+jLlzTDd4jE+?=
 =?us-ascii?Q?PCkUC2ZDeaZTfrmB6XLSl0GJ9ImjTNoaBdWQTWLWBhM6BFtic9Q2VjPiww3B?=
 =?us-ascii?Q?V3E5KElcySN3n7YderfTBab1l5TAH0at0IYZuzqqLKk7IhwsAKuY7+7zHJB3?=
 =?us-ascii?Q?nSptABLH9IKic5t6GQKcY8lBefPm2Czs7oNHkbhlQWLNDUwrHj0oN9x9JFvK?=
 =?us-ascii?Q?5K0kwmaVTA/RT5PmvvJ26FhoZ30XAH2aQadTg6gEpSBr4WR6BljQnRNei4e1?=
 =?us-ascii?Q?o+w9zd38zaDLtwS7ojgqneH1WY/TRHBPYJfHyLahHObOzEs2ezD9+lhaN803?=
 =?us-ascii?Q?prDXEqGmvCkOxt36+LAdrOIL8QpiL4UxHlnuvbEq3n300vn92rdHA5WrHP2K?=
 =?us-ascii?Q?5T9G4bPJBbzcxOi6drkp9Jnv4FOHmC0wJOgNvJbdjdwrH6YqaxQiCo3Uhtsx?=
 =?us-ascii?Q?LpRYX6vNt5GPgRjCN88bjZYEgirFhbqE+0GZk/rcXd2k8ow/YKH8xBGQu/3V?=
 =?us-ascii?Q?kApeA19B6NMrDRLLLb+YlkMiDJEYCFiDpxLJW/Hw5dg5lIJmjRYKFs9Fv7HV?=
 =?us-ascii?Q?yc6u0NRepeAX3+JypxCqNZ0VH1CQhq9LMHo+N8P0Wu8HbLtJy8+QsUQ85KEr?=
 =?us-ascii?Q?G5YFkdVfVe4K5HVYC6B0t/wK8nySY0lEWXLJpf9hrhwSTlhBjIYSCfTRneon?=
 =?us-ascii?Q?fXzJ+YtBfTgLvxpHyTZBzLQy8j1iCNsPTI+gO2cfYS7+j4F6zAmm7jKhsE8o?=
 =?us-ascii?Q?IaqWJbOTGm0tuK+Uc37ie4u8UIcmYq4mdNEOyquQ81oy7TzgCNOC2sHBPMM+?=
 =?us-ascii?Q?YLZ+S+rwWBsDclju7WC556VnYJG9AIr/wEhp6MpqJobViACM2HNbZQeXUq6S?=
 =?us-ascii?Q?RSnOb8QvbQSLMfyxwkZHH2q6B15ZTJrQhl6t/7D7I6rIWhPWSzYkK+fRDkfe?=
 =?us-ascii?Q?oN1wb8eC9gWB1123TytWCClu71+9vbdA/K3QDsd4IePbeOsBiQT4f+BzQSZI?=
 =?us-ascii?Q?+lBx8b7zL6Y=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Yuqhw9Roh+Lin3wVLQEo3pO01gDcqGOFBJjncVwvNcXXU3Cm1LFhvQ1upENS?=
 =?us-ascii?Q?qtj0T4PcmhvhyiWJ7Nu7j4m5oiS6kewcw9zsYu6Ch4kzEyZqshM/Ht8CCDh+?=
 =?us-ascii?Q?oGtLNvDiP4M2d9boE68Fu8bGh+D68DOmIuUw37tGCYSwmwu9FmbPIo8IKol0?=
 =?us-ascii?Q?NARGbzU2RV9jxC7gKNu6LXs5dfA5XMI9YmNnNyeiSulMkAK7ta38Eqdcf9K4?=
 =?us-ascii?Q?ZVmVPEpugYo1QfYugv40cNEQYNu+8bRcWzj2ztiMYKge3rmTwjqt5tR6af1s?=
 =?us-ascii?Q?0evgmOYSjmz7FtjMbiAT9FKBVD71lpxmrZWmYZ6mCT1nhgdSMhOeIsO6xTDU?=
 =?us-ascii?Q?l8SYKUqdvwAltYedKfqnrHSNMKzAhOzN8GyoGWiOap0MdUhu46TxtS7GHDSE?=
 =?us-ascii?Q?u4bKvB1+s/VusrmiLhm6kR8M15+5YKBqgs6E43z/72Bo/vvCSYHDugwvTX8f?=
 =?us-ascii?Q?tqJIBBTF3dAymUOiXxs4bAZQD2nahnWQySx/u9e/9aH87+zvIPv0CdPqYuuZ?=
 =?us-ascii?Q?ObzNDY9eP6EwmyKLHhjbSvktDQsHeI5t7H2Us6riLnd0BKQOGYKmox3oLP1R?=
 =?us-ascii?Q?kmv3nNYoylEIVkL7dt5CYITYXh9ORAi5mBjZXDoH67FOqygr9OPG1yW5pz98?=
 =?us-ascii?Q?Ic8aeSR2n256/owVarW55V0Cuhps1j5psZrUOuRNCVb9gmQ37/LwRi3dk6xT?=
 =?us-ascii?Q?QWStcHTRdn2WwuqM0VNe0ohO2Itzr+DuDNjIC2qvuvQhubQg+jKYKL8seFGP?=
 =?us-ascii?Q?re7+LqTZRduQwT88fBuZ8KoWswycWV7EBn7f4wSt5JNgIPpQtTHTmiRVcFJL?=
 =?us-ascii?Q?oxDpi0dKz8p3EfHkKk6bMALExT6vRYDimtcInCbmENmqqB1Dj7N5Y8rkMsz/?=
 =?us-ascii?Q?xwV3yUuH3ykPv8Bdi3+4B5xKArhZiwlVBfRpwc7HFHPyuAC2OkcwEjKon9o5?=
 =?us-ascii?Q?xOkjzC0l2ZxPC9Yj0Ub9hRjeGfsf8fZ+ctMKoyozgw7CYRPyoUYBJbVKeMa3?=
 =?us-ascii?Q?msUh8PQVniiKFuH9yBIMtxi7KSn/teifU1JVTSF7bfFd+Ldda9JB8qleWW/7?=
 =?us-ascii?Q?MAovz/cjRFntuuJ42QcpWnTWjXOvR4GrXYQOALYlTrYRrJKeKld9BC1lXafE?=
 =?us-ascii?Q?XFsbPieZpaDlEikV7QkzjFSLOJ3K0F8Glfh6Ks+9psLzaqD7MYq2nmif2vEt?=
 =?us-ascii?Q?iryUvzaTelmbz+VKpk3do+1JftzXxKznNSLl+yy+rjZCwRlc+utjXPvN1DQ2?=
 =?us-ascii?Q?0/FaXYaB/cc9vavtX3Wab1vuOaPdYIvt6OTd2rdmRcGZ9utxbldL+SxRiKtF?=
 =?us-ascii?Q?HZMkOPbpdGdWm+CVlXlMXHrFvNCFbrn8d0u1GB6Rda9bIfs/cBGyoSlSOnt5?=
 =?us-ascii?Q?H3Amhu+q5IhNRhoF+JXkv2nzk0u85c5bUWmnJ2ITFhghY0Bk46/zlWBSrhKa?=
 =?us-ascii?Q?Ahl7zrkqu0yV2rZW5Vh5UNHaUDk3XGNaoxdeqntjk622h8eZyxcxckwKCpcz?=
 =?us-ascii?Q?AlWHTJ+7rEb8gNK5jQX1Kjss2vl2cXtpMJPXAtATWHzxrBxnX7AHfKmq+eyp?=
 =?us-ascii?Q?dtV41yfpM4ufsaUJ1+/DsxPZu0FxUTIL+ZsZAYUm?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8ab0ce3-172c-4a06-7794-08ddb90a6a76
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2025 01:47:34.9667
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DLIAheqJjBXj0mt3e7+dACuh8AOWZZIqMD9XmC+JbLiL5SJC5gTulI0oI5lK1BnY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6429

On Tue, Jul 01, 2025 at 03:48:26PM -0600, Alex Williamson wrote:
> Testing on some systems here...
> 
> I have an AMD system:

I have to admit I don't really like lspci -t, mostly because the man
page doesn't describe the notation '-[0000:00]- +-01.1-[01-03]' means
(I guess it is the subordinate bus range), and it drops any lableing
of the interior switch devices.

I've found lspci -PP to be alot easier to follow for this work:

 00:06.0 PCI bridge: Intel Corporation 12th Gen Core Processor PCI Express x4 Controller #0 (rev 02)
 00:06.0/02:00.0 Non-Volatile memory controller: SK hynix Platinum P41/PC801 NVMe Solid State Drive

However it is curious that doesn't include in the path

 00:00.0 Host bridge: Intel Corporation 12th Gen Core Processor Host Bridge/DRAM Registers (rev 02)

but lspci -t does..

> # lspci -tv
> -[0000:00]-+-00.0  Advanced Micro Devices, Inc. [AMD] Raphael/Granite Ridge Root Complex
>            +-00.2  Advanced Micro Devices, Inc. [AMD] Raphael/Granite Ridge IOMMU
>            +-01.0  Advanced Micro Devices, Inc. [AMD] Raphael/Granite Ridge Dummy Host Bridge
>            +-01.1-[01-03]----00.0-[02-03]----00.0-[03]--+-00.0  Advanced Micro Devices, Inc. [AMD/ATI] Navi 10 [Radeon Pro W5700]
>            |                                            +-00.1  Advanced Micro Devices, Inc. [AMD/ATI] Navi 10 HDMI Audio
>            |                                            +-00.2  Advanced Micro Devices, Inc. [AMD/ATI] Device 7316
>            |                                            \-00.3  Advanced Micro Devices, Inc. [AMD/ATI] Navi 10 USB
>            +-01.2-[04]----00.0  Samsung Electronics Co Ltd NVMe SSD Controller SM981/PM981/PM983
>            +-02.0  Advanced Micro Devices, Inc. [AMD] Raphael/Granite Ridge Dummy Host Bridge
>            +-02.1-[05]----00.0  Samsung Electronics Co Ltd NVMe SSD Controller PM9C1a (DRAM-less)
>            +-02.2-[06-0b]----00.0-[07-0b]--+-01.0-[08]--+-00.0  MosChip Semiconductor Technology Ltd. MCS9922 PCIe Multi-I/O Controller
>            |                               |            \-00.1  MosChip Semiconductor Technology Ltd. MCS9922 PCIe Multi-I/O Controller
>            |                               +-02.0-[09-0a]--+-00.0  Intel Corporation 82576 Gigabit Network Connection
>            |                               |               \-00.1  Intel Corporation 82576 Gigabit Network Connection
>            |                               \-03.0-[0b]----00.0  Fresco Logic FL1100 USB 3.0 Host Controller
>            +-03.0  Advanced Micro Devices, Inc. [AMD] Raphael/Granite Ridge Dummy Host Bridge
>            +-03.1-[0c]----00.0  JMicron Technology Corp. JMB58x AHCI SATA controller
>            +-03.2-[0d]----00.0  Realtek Semiconductor Co., Ltd. RTL8125 2.5GbE Controller
>            +-04.0  Advanced Micro Devices, Inc. [AMD] Raphael/Granite Ridge Dummy Host Bridge
>            +-08.0  Advanced Micro Devices, Inc. [AMD] Raphael/Granite Ridge Dummy Host Bridge
>            +-08.1-[0e]--+-00.0  Advanced Micro Devices, Inc. [AMD/ATI] Raphael
>            |            +-00.1  Advanced Micro Devices, Inc. [AMD/ATI] Radeon High Definition Audio Controller [Rembrandt/Strix]
>            |            +-00.2  Advanced Micro Devices, Inc. [AMD] Family 19h PSP/CCP
>            |            +-00.3  Advanced Micro Devices, Inc. [AMD] Raphael/Granite Ridge USB 3.1 xHCI
>            |            +-00.4  Advanced Micro Devices, Inc. [AMD] Raphael/Granite Ridge USB 3.1 xHCI
>            |            \-00.6  Advanced Micro Devices, Inc. [AMD] Family 17h/19h/1ah HD Audio Controller
>            +-08.3-[0f]----00.0  Advanced Micro Devices, Inc. [AMD] Raphael/Granite Ridge USB 2.0 xHCI
>            +-14.0  Advanced Micro Devices, Inc. [AMD] FCH SMBus Controller
>            +-14.3  Advanced Micro Devices, Inc. [AMD] FCH LPC Bridge
>            +-18.0  Advanced Micro Devices, Inc. [AMD] Raphael/Granite Ridge Data Fabric; Function 0
>            +-18.1  Advanced Micro Devices, Inc. [AMD] Raphael/Granite Ridge Data Fabric; Function 1
>            +-18.2  Advanced Micro Devices, Inc. [AMD] Raphael/Granite Ridge Data Fabric; Function 2
>            +-18.3  Advanced Micro Devices, Inc. [AMD] Raphael/Granite Ridge Data Fabric; Function 3
>            +-18.4  Advanced Micro Devices, Inc. [AMD] Raphael/Granite Ridge Data Fabric; Function 4
>            +-18.5  Advanced Micro Devices, Inc. [AMD] Raphael/Granite Ridge Data Fabric; Function 5
>            +-18.6  Advanced Micro Devices, Inc. [AMD] Raphael/Granite Ridge Data Fabric; Function 6
>            \-18.7  Advanced Micro Devices, Inc. [AMD] Raphael/Granite Ridge Data Fabric; Function 7
> 
> Notably, each case where there's a dummy host bridge followed by some
> number of additional functions (ie. 01.0, 02.0, 03.0, 08.0), that dummy
> host bridge is tainting the function isolation and merging the group.
> For instance each of these were previously a separate group and are now
> combined into one group.

Okay.. So what is this topology trying to represent and what should we
be doing in Linux here for groups?

I note that the spec left ACS flags for root ports as implementation
specific.. So I have no idea what this actually is trying to tell the
OS :\

> # lspci -vvvs 00:01. [manually edited]
> 00:01.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Raphael/Granite Ridge Dummy Host Bridge
> 
> 00:01.1 PCI bridge: Advanced Micro Devices, Inc. [AMD] Raphael/Granite Ridge GPP Bridge (prog-if 00 [Normal decode])
> 	Capabilities: [58] Express (v2) Root Port (Slot+), IntMsgNum 0
> 	Capabilities: [2a0 v1] Access Control Services
> 		ACSCap:	SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCtrl- DirectTrans+
> 		ACSCtl:	SrcValid+ TransBlk- ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCtrl- DirectTrans-
> 
> 00:01.2 PCI bridge: Advanced Micro Devices, Inc. [AMD] Raphael/Granite Ridge GPP Bridge (prog-if 00 [Normal decode])
> 	Capabilities: [58] Express (v2) Root Port (Slot+), IntMsgNum 0
> 	Capabilities: [2a0 v1] Access Control Services
> 		ACSCap:	SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCtrl- DirectTrans+
> 		ACSCtl:	SrcValid+ TransBlk- ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCtrl- DirectTrans-
> 
> The endpoints result in equivalent grouping, but this is a case where I
> don't understand how we have non-isolated functions yet isolated
> subordinate buses.

Sorry, I'm not sure I followed exactly, let me repeat what I think:

The new code is putting 00:01.0, 00:01.1, 00:01.2 in a group because
it is a MFD and not all functions in the MFD have ACS? This sounds
does sound correct? I would have expected the original code to do this
also? Why does it avoid it?

But then you mean 04:00.0 "Samsung Electronics Co Ltd NVMe SSD Controller SM981/PM981/PM983"
gets its own group?

I think this happens because the MFD code in pci_get_alias_group()
joins all functions together but does not set BUS_DATA_PCI_UNISOLATED
within the group. So the downstreams of the bridge remain isolated,
and the bus 00 was never NON_ISOLATED.

This does not seem right. Probably pci_get_alias_group() should be
setting BUS_DATA_PCI_UNISOLATED if the ACS is not isolated in the
function. I did not even slightly think about how a bridge USP on a
MFD would even work :\

> An Alder Lake system shows something similar:
> 
> # lspci -tv
> -[0000:00]-+-00.0  Intel Corporation 12th Gen Core Processor Host Bridge
>            +-01.0-[01-02]----00.0-[02]--
>            +-02.0  Intel Corporation Alder Lake-S GT1 [UHD Graphics 770]
>            +-04.0  Intel Corporation Alder Lake Innovation Platform Framework Processor Participant
>            +-06.0-[03]----00.0  Sandisk Corp SanDisk Ultra 3D / WD PC SN530, IX SN530, Blue SN550 NVMe SSD (DRAM-less)
>            +-08.0  Intel Corporation 12th Gen Core Processor Gaussian & Neural Accelerator
>            +-14.0  Intel Corporation Raptor Lake USB 3.2 Gen 2x2 (20 Gb/s) XHCI Host Controller
>            +-14.2  Intel Corporation Raptor Lake-S PCH Shared SRAM
>            +-15.0  Intel Corporation Raptor Lake Serial IO I2C Host Controller #0
>            +-15.1  Intel Corporation Raptor Lake Serial IO I2C Host Controller #1
>            +-15.2  Intel Corporation Raptor Lake Serial IO I2C Host Controller #2
>            +-15.3  Intel Corporation Device 7a4f
>            +-16.0  Intel Corporation Raptor Lake CSME HECI #1
>            +-17.0  Intel Corporation Raptor Lake SATA AHCI Controller
>            +-19.0  Intel Corporation Device 7a7c
>            +-19.1  Intel Corporation Device 7a7d
>            +-1a.0-[04]----00.0  Sandisk Corp SanDisk Ultra 3D / WD PC SN530, IX SN530, Blue SN550 NVMe SSD (DRAM-less)
>            +-1c.0-[05]--
>            +-1c.1-[06]----00.0  Fresco Logic FL1100 USB 3.0 Host Controller
>            +-1c.2-[07]----00.0  Realtek Semiconductor Co., Ltd. RTL8125 2.5GbE Controller
>            +-1c.3-[08-0c]----00.0-[09-0c]--+-01.0-[0a]----00.0  Realtek Semiconductor Co., Ltd. RTL8111/8168/8211/8411 PCI Express Gigabit Ethernet Controller
>            |                               +-02.0-[0b]--
>            |                               \-03.0-[0c]----00.0  Realtek Semiconductor Co., Ltd. RTL8111/8168/8211/8411 PCI Express Gigabit Ethernet Controller
>            +-1f.0  Intel Corporation Device 7a06
>            +-1f.3  Intel Corporation Raptor Lake High Definition Audio Controller
>            +-1f.4  Intel Corporation Raptor Lake-S PCH SMBus Controller
>            \-1f.5  Intel Corporation Raptor Lake SPI (flash) Controller
> 
> 00:1c. are all grouped together.  Here 1c.0 does not report ACS, but
> the other root ports do:
> 
> # lspci -vvvs 1c. | grep -e ^0 -e "Access Control Services"
> 00:1c.0 PCI bridge: Intel Corporation Raptor Lake PCI Express Root Port #1 (rev 11) (prog-if 00 [Normal decode])

So this is a PCI bridge not a host brdige like AMD.. 
What are the PCI types for this? Is it a root port?

> 00:1c.1 PCI bridge: Intel Corporation Device 7a39 (rev 11) (prog-if 00 [Normal decode])
> 	Capabilities: [220 v1] Access Control Services
> 00:1c.2 PCI bridge: Intel Corporation Raptor Point-S PCH - PCI Express Root Port 3 (rev 11) (prog-if 00 [Normal decode])
> 	Capabilities: [220 v1] Access Control Services
> 00:1c.3 PCI bridge: Intel Corporation Raptor Lake PCI Express Root Port #4 (rev 11) (prog-if 00 [Normal decode])
> 	Capabilities: [220 v1] Access Control Services

Same question, are these all root ports?

My desktop has:

00:06.0 PCI bridge: Intel Corporation 12th Gen Core Processor PCI Express x4 Controller #0 (rev 02) (prog-if 00 [Normal decode])
        Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00

So maybe yes?

> So again the group is tainted by a device that cannot generate DMA, the
> endpoint grouping remains equivalent, but isolated buses downstream of
> this non-isolated group doesn't seem to make sense.
> 
> I'll try to generate further interesting configs.  Thanks,

Thanks a lot, this is very different from my ARM systems here.

I really am at a bit of a loss what Linux should do here.. Your point
about a "device that cannot generate DMA" makes alot of sense. I've
thought the same way about the DSPs too.

Another thought - should we draw a line across the root ports and
assume that if a TLP reaches a root port/bridge that it goes the
IOMMU? Essentially we don't let the BUS_DATA_PCI_UNISOLATED of the
bus->self propogate if bus->self is a root port?

This would allow fixing the bridge MFD miss and still generate the
groupings you see here in a deliberate way.

Alternatively, should we try to identify these "no DMA" devices and
then improve the various ACS calculations? A device with no MMIO, no
IO, and no downstream can reasonably be considered to have no
DMA. Will that describe the two cases you saw that "spolied" the group?
We can detect that and enhance the ACS function to report they have ACS
RR/etc enabled.

I was thinking about this already in terms of the DSPs not really
needed to be group'd with their downstreams if they don't have MMIO
and can't initiate DMA.

To summarize:
 1) We are getting acceptable groupings for the downstream devices. So
    a lot is working well
 2) The root complex integrated devices, upstream of root ports, are
    not working the same way
 3) There is a miss of MFD ACS propogation on bridge/switch USPs

Also, I updated the github with an extra patch that has the debugging
I've been using. It may be helpful. It shows bus by bus what the
isolation is and various other decision points.

Thanks,
Jason

