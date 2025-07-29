Return-Path: <kvm+bounces-53646-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CBDE4B15104
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 18:13:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 624721882FC2
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 16:13:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4A9829824E;
	Tue, 29 Jul 2025 16:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ihHaa3P/"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2072.outbound.protection.outlook.com [40.107.223.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A94720ED;
	Tue, 29 Jul 2025 16:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753805577; cv=fail; b=ayogGQ8mQTWSyVJ7lVWlAJFoIAGuKGuhcmUUba/FGg+vVMLBRUVWEQS3UrrclS2QJlR0YD/EsOq8iYTo0ieR5hU05o3N3s51t0MlcW93YfDANnvcV0i1oy2C8yMKBUCZ2MirAPH2tGp9hLL5KZEAJvKkO4xvVxQeJlq1iQ4nCLY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753805577; c=relaxed/simple;
	bh=DUhKhgQNvKkWZaCh0yVASqoxH5l7Lpdx7PZC1FKINK8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=VptC7aUgycmkEKNbnU6eePmANZen+bMdcNUiD1ohDO6UMTFWN0qFr/UR40qxq6VqUmFJc2HnnJal4YpQ6HsqBTCUH6QtsMUfAyvw6835tiEzy2NvtfZcJc/ZVdRbIzELQ45R0mJ7NFWngyNGSsWpkOBp9qJEv9Dzpr5wX8tLkQo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ihHaa3P/; arc=fail smtp.client-ip=40.107.223.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=swZtSoHu/DZyy3TVL8EtEQMBYhSYUYyUR7JGg6QIVho6OW3fh7L4XsR3R/Tlja7YXkjrzfnBx/KTvwY/+xtdJROjyhTkLwoaQzvO9UYU5hQX6epHl+bS4OT1sr0NSZIsTbXUks9z4Vxkh0FbXPxmFZLO6Sm99qsjjsgWR/0pMjX1QAJWINy33Amf0i2JBd+elNlHI2SOtzLiByoJ+84pirbaFeZPsPDbq/ssSXzi0ohYjt4mbXCwZrWzUmmFLBuNmML/7V6hD0RlzxzJ7FX5WhFjf8Vezrf7uQaBb5nIJ9wyMZYvgTfBAaNMSwj5rPxUpM8LpPz0yvtPgEFBoqnMBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CDB8Cu6i5mcHLWeNfaYXlc/xrtOy9ZyuKX1scS7Ub3c=;
 b=MmyM2H0kwyKZtA4XA2jSsj6qpMEMxDupqkNUNAFePb/1clU5BG6hZfU5q2wDJ5y6oq9msMelHQURE8AWi+SRce6autJbibI7u0ybFhaJAv6ZV9tx4oy+XhSaaibHKk0NX5tfV7jAsfKWcy7iFnIKafgNNQ9eSCH3pGzqJxJ278RZdY7feHegnlIj8Pc5aLcN0mzC5LPqaskNqlBCdS/JMD88YOrNR2sCD5YqSTcs6v3sf/eajZCzld2qRX5XAn500E4FW3izyDG8RExRpFPubi8UdLYkDZsCccAc2tTIr3LtgKDcY38NlvgFVExBDPo4+QJ2d/f5c4KySxeaHlwG/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CDB8Cu6i5mcHLWeNfaYXlc/xrtOy9ZyuKX1scS7Ub3c=;
 b=ihHaa3P/Kpm6yTd1e9H+2gdab4phSilppEL9c9751nHgYp8nJbbC8VYa6fopNPLKicYZPYjF/xsuvinmfJth4ziLePgse0lf9ZYNafnNVAWs64XhhsMsMnoqsHqO53v5i2ZIeSzqL2nHZ2K1l5ztuGJRgtzu5QIFicumBVexH29yO31AfFqzagb951zVkTaYgUHrdOx7EhLYPcqrEXFQWLRfhr8+vvlggpIRBB4TPIx1FWseTeC/NKWceZXn1ab2NlQx8jB4FiYvBz0q6LJT/9illBzC8uWJtIAFL9yILUJ8BFNx51cAz6GtB9WZKUo5fpHpcvgvsMEa28cE1NPKmw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SN7PR12MB7977.namprd12.prod.outlook.com (2603:10b6:806:340::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.26; Tue, 29 Jul
 2025 16:12:52 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8964.024; Tue, 29 Jul 2025
 16:12:52 +0000
Date: Tue, 29 Jul 2025 13:12:51 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Leon Romanovsky <leon@kernel.org>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	Leon Romanovsky <leonro@nvidia.com>, Christoph Hellwig <hch@lst.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
	dri-devel@lists.freedesktop.org, iommu@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	=?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>,
	Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	linux-mm@kvack.org, linux-pci@vger.kernel.org,
	Logan Gunthorpe <logang@deltatee.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH 02/10] PCI/P2PDMA: Introduce p2pdma_provider structure
 for cleaner abstraction
Message-ID: <20250729161251.GL36037@nvidia.com>
References: <cover.1753274085.git.leonro@nvidia.com>
 <c2307cb4c3f1af46da138f3410738754691fbb3d.1753274085.git.leonro@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c2307cb4c3f1af46da138f3410738754691fbb3d.1753274085.git.leonro@nvidia.com>
X-ClientProxiedBy: YT1P288CA0014.CANP288.PROD.OUTLOOK.COM (2603:10b6:b01::27)
 To CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SN7PR12MB7977:EE_
X-MS-Office365-Filtering-Correlation-Id: b5a94d1f-7f86-4c7f-0873-08ddcebac506
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?980W6JOc97jNYniLDhBP7BRQhORVxW4Fy+YYxrarxU/isCU/TkbACCbdZk5m?=
 =?us-ascii?Q?FXdFlqkJYh7brsgQVPBbG7P7CizQA23JJN5TdbhrIBny7UwfnXAHOD5JVF8m?=
 =?us-ascii?Q?xZFm6iofonMDdANAl/Ff8LhKmaGjR8sXqahjEJpwgq3R1Ja37tYTrUp8hyRH?=
 =?us-ascii?Q?1QycLYOBM8jQrpAcXcqh+RG9k5erFNr9e9RpslFhudSCXGLfcqRhclGtYY6z?=
 =?us-ascii?Q?K4nwlx8DybXyDmQ+43jo9RxfHlchMlmmbKDltBZsRTNsshFsVvc6Af5oYwFB?=
 =?us-ascii?Q?Q0OmdbLF+nrJVX51qZm8l59qLusc3h/THHWVywwCgaJNwViP9t9o9WoCjDuE?=
 =?us-ascii?Q?int/plB2xLoQvZJx8zCDBWmBBxM6Tryw/j9C0jvFz+Kwa7ow1SYb+1nS7Job?=
 =?us-ascii?Q?+pDO9rS093nOImuL+2k+N+nEN1NUxYVD933GcPEYZqFU6QIhMLWDYotxObRy?=
 =?us-ascii?Q?5Dcd1CrYUYKXomnvwNd4sKcLr1pbtY8vGbnqMMoz6UPJLpVmWF1XMgadERQs?=
 =?us-ascii?Q?QNAw31bFhgylf2mPwIqY4acInlb/Ep1GUyltXec4nDKmBzDQCHwLW3BrwhM9?=
 =?us-ascii?Q?MAxPf8uNyjFQ1Y11pSslen4GnMiAtpOBENBOSEBOHBN7/og4Xp7sD+WY6M83?=
 =?us-ascii?Q?wVXMqOsmxkW67haHvoMzS7DZ0ljjyIhNk9A3UA8AWenI2B70yREqbhpU220/?=
 =?us-ascii?Q?HqSc0gn70G7fpXkugyf/A95+c7gep4DrTBEqMitns4DNj4Ck/iZDfkG5LZjs?=
 =?us-ascii?Q?9Mnio/tQLUD5ei8vWZ8CHW9fhwu/nRjTriAqk+WB/0xiPBBrtsWqezieAH5y?=
 =?us-ascii?Q?M/cUPsE4DgVs0H40bz4BQmarfxF7+nl9vR03NpIxbxKEJ/pZ49r4NUXBnM+U?=
 =?us-ascii?Q?Qt58UlC9GRvrutgr59N/pVNSUOwaAfK0FW/O3a/cznBUWFjAZwtuAM7FyqQY?=
 =?us-ascii?Q?s2bPY1mWSA+IDhBcyxv/wNdZo87mr3NH8gdAjNk41wIvJsvKyUV/P0N3R0Sd?=
 =?us-ascii?Q?WY+l3XJ8ZsOY+QbdAF7Q9X7vz5E3GMm3U4Xc5gO6wx0XHv2vWqQehSPxtBcm?=
 =?us-ascii?Q?A8fiHIJvcluYkl1x+sZBgOElspWXy3Fc+qGg0bXwY5FRz0+y2Z1cQ+tDnnXw?=
 =?us-ascii?Q?m8ZnePmwKZGW1na1mZwLknvBAmFPfOEAGlf9Iy2hI1wms3I/ChLiQuYbS7j/?=
 =?us-ascii?Q?iFVjYipYoSGPniyeDl4ZdFrTZ009KRUDFgYLOKnB8ms9/id1zMzePg05Rv/D?=
 =?us-ascii?Q?uvsJTFuLntyEyEwZ90yAOdkr+bV/8g2SvP8QVOA7uiFlTUfL4BiSD9atonpA?=
 =?us-ascii?Q?MedfKi4sV1ik4hxXjOemW6BK9PcaaUe928zkb8hsOFnpZQOHP4Yvn4nDnihU?=
 =?us-ascii?Q?QUw2OEns3iGoomza1BTYO6wig9pbVSENo87Pfwq3xmxTf86vYSOSAcyhxNop?=
 =?us-ascii?Q?KSpWYx6K0fE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rOySeF58KQ3bNi2EFjzNKTIyKZCWIRsliIg7GNLmVnDvitBNoIyqq6BFagOW?=
 =?us-ascii?Q?oan4lew/JO68XNAhFwGW4wm8mJWLriRBu4Kr+FdSM6OhkmdzT01ijRLEFCjT?=
 =?us-ascii?Q?KhgIG0iUY+7CJFIfsqDgzPZqbWu640WttZcvz+dTunInTic+H/PrB0jBjLwj?=
 =?us-ascii?Q?8AWjrO9r/kgtaaGfy+bMF5/9aoNR4mWWITq3HirOGjJX6Z4YVBzCrSeRhTUq?=
 =?us-ascii?Q?NZiHj3Q7cuKKhDrV/+zndhnsdpK7r1vyf20OHnlNndDYg8FeyawRUQfFMCxu?=
 =?us-ascii?Q?CdLGgmWwkM8yz4guAMel3NXmuMyPeD3fSr58Kun/0yvnigUwmQWj+9CbBTjz?=
 =?us-ascii?Q?K0qj7IidSDTX3x/NzgF/yI8Kxcmydo12r3EQeZQY9e896Z9wUzRm+vPYQBFb?=
 =?us-ascii?Q?gNDiYhohEy/xLJpXYCdo5qbUpFFWwzbJXZwt7ubGJjdgnP7Lm2tJLhgLM04H?=
 =?us-ascii?Q?sqJ4In4c//3ewywWQbmaTens5EhIMv7vpAXc6c8NLIaEU2piqnskAxNZOEkK?=
 =?us-ascii?Q?IHR/q18JeZCvmw5nnOaPm2KTknHc5ck8j6Ifwk9idE1GfUXM8aVnVpjxKTt/?=
 =?us-ascii?Q?um0eG3by6aaJKGEImcfoTpYRm2caaqk5TGwJnkzcYEFpxs+6fWUNzYo7jeWS?=
 =?us-ascii?Q?Y6orpaxuAqQAJqawXILM3Wp9P6uOjtwirzGR81b28rGMOqE1bF5lMYlwSXu0?=
 =?us-ascii?Q?HEkVLcWkT+TcuPAMACBtfHXvkq68fsNWkjSxNGnii9pctwXRXFtsKa6WsxFX?=
 =?us-ascii?Q?ccWt0Tl+iASfXUbM49X/ZAexWaQEEU7ADd+IZFr7i284hez0rx338nF6WM+s?=
 =?us-ascii?Q?Zbtr/mYMyosKi3gzihy3pci7Ma8i2GsKEGKOQIHlmxZdXVrQJ+aBzcpLsZxw?=
 =?us-ascii?Q?yDefRjwzjA9sreqLPrl8qKwwaj0SJ8E1JEvqoVYj0jxp/CxPY9hL9Tazu3DE?=
 =?us-ascii?Q?1ubZ3MzDZ3RjyyjfgptbLTYwTygsFXPL41htfAiEG6Ag8AsRpyVvJBMIplv8?=
 =?us-ascii?Q?AUI3Y3f2L5kOR1r2YToWc2M1dWsdf1tXu5UK0Kb+vWg6sDOW6KHzPBGAEhTu?=
 =?us-ascii?Q?IqKJmNoDoNOr07muOhSo28lFTpZ9OkjQPTfIRY2/q4C7w6fTQi0ThdYLppRk?=
 =?us-ascii?Q?nb+np7LoWmOj/7thte/zGQMkqMmI3IUKRDE8bm896gqb1CfUVpkdR7P4ak5t?=
 =?us-ascii?Q?4AVC4OBt80Q8oXCVo+SJRTxTtarQHt31muH0IV7vwRlJYVj9zf1MZjfj8pO2?=
 =?us-ascii?Q?ues1A+vMH7iSMhEGqK8YD2rjerQpEawY3Zhe0o4MLohwyp6FaTUuQxobqw1c?=
 =?us-ascii?Q?X//n823xisG3lzDJkp2UDYnjW30IYEHZE1nNd8jyay1CKM81Qx1GJ6PtaUTU?=
 =?us-ascii?Q?Cia+rtCUD9i7h9qX1HOwFys0ZU+Mxk9QaIfi41nrGd7AedEYSvD0L0xOx15w?=
 =?us-ascii?Q?3gzkZW6ggu45Psbl7AJoW3e5EHZ6yeMaefjYxk8WT6ZUD8HKyY9KRyLpaEQa?=
 =?us-ascii?Q?5MBKSKnaX/r/qu/RDm3c/Igqnf37iZMarkiE3fIjBi/P9DdpY4ctWDwIij9R?=
 =?us-ascii?Q?qeraHsQNdUkIrPVesWA=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5a94d1f-7f86-4c7f-0873-08ddcebac506
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2025 16:12:52.2750
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: INHiNe1CsiwxAvNJqK3TLjyICYSqd8xRk6/6+o+ZiMC2himzXNGTTlc6Vmk+ybqv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7977

On Wed, Jul 23, 2025 at 04:00:03PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Extract the core P2PDMA provider information (device owner and bus
> offset) from the dev_pagemap into a dedicated p2pdma_provider structure.
> This creates a cleaner separation between the memory management layer and
> the P2PDMA functionality.
> 
> The new p2pdma_provider structure contains:
> - owner: pointer to the providing device
> - bus_offset: computed offset for non-host transactions
> 
> This refactoring simplifies the P2PDMA state management by removing
> the need to access pgmap internals directly. The pci_p2pdma_map_state
> now stores a pointer to the provider instead of the pgmap, making
> the API more explicit and easier to understand.

Based on the conversation how about this as a commit message:

PCI/P2PDMA: Separate the mmap() support from the core logic

Currently the P2PDMA code requires a pgmap and a struct page to
function. The was serving three important purposes:

 - DMA API compatibility, where scatterlist required a struct page as
   input

 - Life cycle management, the percpu_ref is used to prevent UAF during
   device hot unplug

 - A way to get the P2P provider data through the pci_p2pdma_pagemap

The DMA API now has a new flow, and has gained phys_addr_t support, so
it no longer needs struct pages to perform P2P mapping.

Lifecycle management can be delegated to the user, DMABUF for instance
has a suitable invalidation protocol that does not require struct
page.

Finding the P2P provider data can also be managed by the caller
without need to look it up from the phys_addr.

Split the P2PDMA code into two layers. The optionl upper layer,
effectively, provides a way to mmap() P2P memory into a VMA by
providing struct page, pgmap, a genalloc and sysfs.

The lower layer provides the actual P2P infrastructure and is wrapped
up in a new struct p2pdma_provider. Rework the mmap layer to use new
p2pdma_provider based APIs.

Drivers that do not want to put P2P memory into VMA's can allocate a
struct p2pdma_provider after probe() starts and free it before
remove() completes. When DMA mapping the driver must convey the struct
p2pdma_provider to the DMA mapping code along with a phys_addr of the
MMIO BAR slice to map. The driver must ensure that no DMA mapping
outlives the lifetime of the struct p2pdma_provider.

The intended target of this new API layer is DMABUF. There is usually
only a single p2pdma_provider for a DMABUF exporter. Most drivers can
establish the p2pdma_provider during probe, access the single instance
during DMABUF attach and use that to drive the DMA mapping.

DMABUF provides an invalidation mechanism that can guarentee all DMA
is halted and the DMA mappings are undone prior to destroying the
struct p2pdma_provider. This ensures there is no UAF through DMABUFs
that are lingering past driver removal.

The new p2pdma_provider layer cannot be used to create P2P memory that
can be mapped into VMA's, be used with pin_user_pages(), O_DIRECT, and
so on. These use cases must still use the mmap() layer. The
p2pdma_provider layer is principally for DMABUF-like use cases where
DMABUF natively manages the life cycle and access instead of
vmas/pin_user_pages()/struct page.

Jason

