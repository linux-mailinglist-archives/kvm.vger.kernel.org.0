Return-Path: <kvm+bounces-52183-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EF060B0216E
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 18:14:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 61CCAA64FD7
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 16:13:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEB3D2EF2A9;
	Fri, 11 Jul 2025 16:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="cb1Ow+0m"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2070.outbound.protection.outlook.com [40.107.93.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E9B22ECEAD;
	Fri, 11 Jul 2025 16:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752250455; cv=fail; b=idWzlYTkEa0VAdBPoBpKlEt2RL2ha2Dfnq4WZDil9dw2cprDEdVRqAwb177o07BLceMZ93h8dpiImrSt9Khv2YPpRWe7ZMsWNR24obboXb4fVkDEqrfPhOQ9HRYWH8HEvOPzrxBqsJMNsPfMIy50GOOXkVvLpQqDoGLNZXiP07E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752250455; c=relaxed/simple;
	bh=qdAwr4YSaxa3nQIrhI7lBSo7czNDPEG3Z3xplKTqau8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=jexN8kLnm3cQu+7LbX9li+xrc4GfFokNbHsi4YiXVUDEfC9NoMDeXww3RonTW55kI+azHqzbdR236RkCqRJZl27c4xL3VHq1ZaoBAvKe0/DX/uTOSrsvDiqNSPhCHv4ETq+8Jddbxpto/gljgdYLFjbAUatZX62Hywq1DmRKJjo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=cb1Ow+0m; arc=fail smtp.client-ip=40.107.93.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AzjBOqjOdeTKAuu5sVRBUh+TV2dYKX33tkGHhAA/KoOSSLkorw8syOugx1J8d6HItIg4+TUtxS2BaxDiC1EBuFuqMvt2++Rc1kzHX5SZinUiEhvYPQtgigixy9+EostkjrH4CMaT420oO3zMmczcv2eHUdu4+gIxpQ3wH96uF03LuPUhcwTn8Yi1DqlqMKu2vSN9zuBrZbzDTm31dGgan1rDUfkUQugtehTR+j2fja1s6N3UOhYuIP1ZTlIU3Qx2ccazEWLWFJ6M7ys8ED1QrvLYBmWSqklghs+hUx4/l6c3OvXZkYgSTnW3FEPzJFCv4nh9ek9BSdPdijjNjnenAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TkDYeaK3Sd0VIlklY+rYsb7A6UQ4MtAe67GH3hRJ6fc=;
 b=POTkM1dtrjmn7hxhwzDF1iddhGmQJkc1d5GGyhP3ve9yRf8Jh1lwFvuRPoOmWcLkd7BVTIP0K+HUg9kHT+BMZLnm4Skphu+FGBULjXcnbtdMBWXbJE0lebKpJj5oU7hPx5dBLtGz9UI7qMlrjdWsA+6/Pei1jxO+GOIfyKbOtuq244XScFTyQdgbOCOuK8ylwDdcHaF7d2xVVZgCh26Q0N78r2t1ygPHbyVhhTkERy+ejMS1NTv/trjLd/HyfE+8+pyfZ9bkeBC5wzwAwEWkQI7ZEUPt2VsYJPV3yLXMBsJM/2AtJGyjptp8Klt6byR9Rx9cG7Ji/FPJvKqU6iR6mQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TkDYeaK3Sd0VIlklY+rYsb7A6UQ4MtAe67GH3hRJ6fc=;
 b=cb1Ow+0m+AGKpvNOueOoH/O+IXZgoAibWrWxuziChHqfGmcmpeGVyumH7oiX6CZGMiVkaQygnN1AjsxNufs4s+oEDXIjoSwc8QedZwwcWYZTE0XvvduPBfWjoKO5yQBZDFnEPi6e0iulcgBX2sZVXlqGNIlTe5B9crK7rpP4vLsGcXD2PLOw7HQvndo58ejHM/ocAIhVB/6qDg+RqJtyTm6tyxph+bVcqXvzugJ8aQSLF9axsI0HqGYYBIWlP3RRv22XrAe9JUss3a7gGuOUjRXwqL1RoOLhKJUqNsvZMFYI2R5GwV2MsKfeaC2rZUlzQvxczl2E8KRHs7jyxfADmQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by PH8PR12MB6916.namprd12.prod.outlook.com (2603:10b6:510:1bd::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.29; Fri, 11 Jul
 2025 16:14:11 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8901.024; Fri, 11 Jul 2025
 16:14:11 +0000
Date: Fri, 11 Jul 2025 13:14:10 -0300
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
Message-ID: <20250711161410.GD1951027@nvidia.com>
References: <0-v1-74184c5043c6+195-pcie_switch_groups_jgg@nvidia.com>
 <20250701154826.75a7aba6.alex.williamson@redhat.com>
 <20250708204715.GA1599700@nvidia.com>
 <20250711094020.697678fc.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250711094020.697678fc.alex.williamson@redhat.com>
X-ClientProxiedBy: MN2PR15CA0041.namprd15.prod.outlook.com
 (2603:10b6:208:237::10) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|PH8PR12MB6916:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f91551f-aec3-4959-31f5-08ddc095f8c9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?PJhGueM1gTnaCPks7rhtQMzp8oMe7PNkP4ZUh7hXUaFVUT9RWNtQbeqeKNHF?=
 =?us-ascii?Q?FTEJhpS/9+0X9SzkLWys6aoAqYOUW/oz2JaZHkKcr2PGiPsphLWRvkbiil8R?=
 =?us-ascii?Q?R1pIRckyZLgXxlB20WGaUR37b6+wrP3K4dcgYpAoGtlwFWe/D2N3KVtAW5ZY?=
 =?us-ascii?Q?GD21kkUBuloGQ7GHogDVwjDbKjoP8Gv6FR6mt1HAvPVZyRsY6UtCeXmz7m3t?=
 =?us-ascii?Q?ZO6khI5ARuvoto5BWzK3DiwH6yjHSRKZf6icAm/oJAEuy9zqyrWVYUZtU/sV?=
 =?us-ascii?Q?AiU8LGDC+zyFVNjSMhQGFQm7zmcYbWeefc7Ivxwp8h3ZU2DzffCdIwYT6bbc?=
 =?us-ascii?Q?bxWx4PQYJeYVUOp5q43jMqzo3pgR59y+Ccdw2Pf2ExibBoiIH6mKkKO1SxBP?=
 =?us-ascii?Q?tFY3TexAIS1DDjBeG5sJTwrUHKXVnWaqPZI1DtXEpTRxZqeNyblJpHvVMGcP?=
 =?us-ascii?Q?AI0Jy+CWbPBg1eFDS+3e2SPHSxtR2fVPoN0XBTO14C21P0YVa+HhwoDJH/jD?=
 =?us-ascii?Q?RcFPen/fT9cxDM+9Svz3E7yyvBKaeTt7qqVG/Y9uQNZ/KfhantckLwqrGOS5?=
 =?us-ascii?Q?I7j53BZSNRtObI5W/ghxcAqo8JmJLPu2cIhBXT4dmfifIrY5bVkAkcxrUXfd?=
 =?us-ascii?Q?E2B9mAE/ICPeCkylWv+04E4eUkfm9kiG8IKMEx3UefrVlYK7hL3uiAwoJ9Wn?=
 =?us-ascii?Q?kzgIljefp14lUgALn7NR1qbV24eMwnSn+Yp3oHcpXxFtGBNsB2cRxEqIfecg?=
 =?us-ascii?Q?hvHjDkFG3qsfVtgNUBt4CJtUbHcTBRuN393vn36ascZiaKyIDYNC6S5EXW8v?=
 =?us-ascii?Q?SrYL4DFay027g8qkqceoO2Itt9oWEyJrke1Qka3bkLaj+vtB8dD4KZOPTWef?=
 =?us-ascii?Q?q1prKVwMz1BQ0ynuVAl6ld3AYkV0WDPVnzM5eCjcFbwl5YGK1Dy7KVu68zsa?=
 =?us-ascii?Q?7jhfaLhO/NzY2lgzxsdZ4CcGuec9EWV6TMgD7VN8s3GGpIsJbBYLNGuCQTTK?=
 =?us-ascii?Q?NImcqpLSHYEQfiFMNBrXv0qOyhjQyG9JS7J3YcVz71qNV4xGp/pjpqxjRl4Z?=
 =?us-ascii?Q?E1C2/c4dky/rnUGvwlzRzJTS4L4uKOsiR/jtJQRywQIjnTojDPgMfAhjvsyt?=
 =?us-ascii?Q?PJUBX7z2HJM98lV7Cb89qQU9eq6we9vWjS8b+rMrcHZePAmyKX9DWSXma0cb?=
 =?us-ascii?Q?R8oEoNnB88mYqKoi+KbKZKsRTcDjxf2ma7ptYUu9P5f2pGwhWXDUor7+a8eU?=
 =?us-ascii?Q?9mVuPJBiVEgZqVviuIUW2slmmVGiFHTOhEbdEANmEzzj5W2RRWFmyXl5+YaF?=
 =?us-ascii?Q?zl8gPDqbbYeP5njSR+Ds2/xjkdgTnAnqDRLl/quuHw6fvWp/G8mnBDHzDABC?=
 =?us-ascii?Q?hkbZyA8KwczxI2liZLiyVa03ZJMlX2YnEyB3Kp1JUiwH7845zVWsQjU7XDjW?=
 =?us-ascii?Q?h4FaM4/NVpM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?sRfYczQspHpCRuomMG6L1BstTbhBaDDywXmAlAmrGfqpujMz3YAyk41pf/WL?=
 =?us-ascii?Q?6sjT5sVzd1sXo7jMuLPrvkP4CYX80tf7T3HBSYXUhJtS4EoaEr+fANwOSz7E?=
 =?us-ascii?Q?VnpQYmvI78os+/Sfx37IYTk5MXsY7SSxeyIjBazf7g9Yk4bECjLZi0XARRvQ?=
 =?us-ascii?Q?wIb+pPjtPG65+X/H/QrmxJ1INJbNPu4nYz8YUGChFFmGfabvgF+Yz+TpspFw?=
 =?us-ascii?Q?NJOPrIxZaXH6VMTxZ8+w62HR9pf3LLp2ZSFKh7ZDfAAo2XYKFAYNJDSVloBX?=
 =?us-ascii?Q?HXhwCzSYXZ291LJjFahOeUpAE7oNvEpmPUKow9IfcLU5LwZClBqD+OmYs2CJ?=
 =?us-ascii?Q?XcottRTbJ8e/s1iBCYVNaFm5TPsoYvMMq3e+JTeZSPn33Tt9xXkY9c3bSGqa?=
 =?us-ascii?Q?+Zw8SMDQhh7ZR0x6k4C4NYPM/GXohJ0CP6+l1fLMXYYrlZtyOGjc4Az4HLPf?=
 =?us-ascii?Q?Lh3eEaJ71LNlN++7eg1m5s70qHZ+cOGqTnq6P8ewjFbuZlMtx5JhOPAHdzQN?=
 =?us-ascii?Q?aF3n1x0FqpFwPLCcqoEP2K4HjJiJUF0EVFDmdt9JvF3Xe2P4XfinvieHp7Ml?=
 =?us-ascii?Q?eDwT8H3YXYPfKOGwBZ9wCtCaQ85CstZah3X8lxZBTSxYrI9tCvmA1XXNjGro?=
 =?us-ascii?Q?NJBJAFcetf0faeq9sPtu930NNxCJoShi5JG3ZBVRrmP2HGDu2gBd7/zy8+qJ?=
 =?us-ascii?Q?T2yufvZyx1ADyi6cesi9jgAa+/jn9PVU/jgr4FmI9BNggxYwm2KLESST/LgV?=
 =?us-ascii?Q?Yd8EPk32k1P6f+UYE0iBrKhiuxr/WTrZ1yyz6C74taG0C2l2AMNNFoYnrQfF?=
 =?us-ascii?Q?WPnEceKUNr+iDbPLUQWEJT6US9zF9Edke1pxCsIldHv4LlBMTEBwWFQwKV3t?=
 =?us-ascii?Q?WlM2HYBzqefUstShrCWoclNBOo5xQXwBCe+KoGKFtXLI4RTSgIkmdKPQH9YV?=
 =?us-ascii?Q?tBOwsvR0MDLiGMiDm24bNwunHxqGvcnizgZFeVdB2OD9GHsAIs0dGUYZs/O5?=
 =?us-ascii?Q?yTbQ6F++KAwuktc7+tt+0JMhEmtub8BrKo/g3tDM5t3/IYMmXGcMEM7RYS39?=
 =?us-ascii?Q?t5uHlo66PO7726ZrCjM8gacRlMunqxfexd/FuIUui8iQZD3rWGkXWv+jzeT+?=
 =?us-ascii?Q?kSFVu4/8KOg3PgOrC9Xpl9QNTpjB1rJW6xEmykJTY80JFjl29NBlKrQ1oK8J?=
 =?us-ascii?Q?GtyHLs93uTp3/qj5+cBjzRWlsajI/dDjwBAcRCdu4H0FM/EFkmErcC+H31sf?=
 =?us-ascii?Q?9MaHqGz1SN6AXyGfvTDbxlgM4PxNMQLkxXOKL3rdsbjpMX3Qtyy2sBp4+Rgi?=
 =?us-ascii?Q?dD2URe0UM31mPjwdrx8+bGP+ZZ/Xcb8dr7Q3RvY9FNOHm3eRM1/QtmVggmdN?=
 =?us-ascii?Q?UJTV20w9ulq7SBfLaQAkxdlFvKTUE/2+0gStDXxWpkeMpqUK+9Fg+Qv7B0/Q?=
 =?us-ascii?Q?KmXCR/kByPRelKza60S7OG3q4KVqb4q9uno/1k5JQzsjEz0duUVZFEggy4T7?=
 =?us-ascii?Q?p4cUDbMtoNUo7TYvo1wRkvo/Nent1r657/mj6paZnIyJ2QQ3UhH43XvAXqvR?=
 =?us-ascii?Q?KgRIg8vJg0UabB2i2OrsdIIFr+YNzCD3JEdcQbzi?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f91551f-aec3-4959-31f5-08ddc095f8c9
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2025 16:14:11.5153
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Kca3M1i8UcGxvuQkEOb0tkS4g7T+jHMdGJyLTzvIv2WNAbbha+OnNqYv7udK/Rxb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6916

On Fri, Jul 11, 2025 at 09:40:20AM -0600, Alex Williamson wrote:
> Yeah, that might work since it does report itself as a host bridge.
> Probably noteworthy that you'd end up catching the Intel host bridge
> with this too.

Yes, I think the argument holds for Intel too. A device with no way to
initiate DMA and no MMIO to target P2P can always be its own group,
regardless of type.

> Again, it should be perfectly safe to assign things downstream of the
> ACS isolated root ports in the MFD to userspace drivers, their egress
> DMA is isolated.  It would only be ingress from an endpoint that seems
> like it cannot exist that would be troublesome.  I don't have a good
> solution.

I don't know what the kernel can do with this, IMHO the PCIE
capabilities are simply out of spec.

If we want to do my relaxed idea then we could also say that root
ports without ACS are assumed to have no possible P2P as well.

Jason

