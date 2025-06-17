Return-Path: <kvm+bounces-49776-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A3090ADDF77
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 01:18:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E5F53189A207
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 23:18:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A8302980B0;
	Tue, 17 Jun 2025 23:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="QntmvO0X"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2071.outbound.protection.outlook.com [40.107.237.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD8082957A7;
	Tue, 17 Jun 2025 23:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750202300; cv=fail; b=SvM2M7ck0AhsONCbW60ZjP3b3yBdxsXT4CkbDoadTvxV0Cd/YRJXiFHKoja/sNs4ptXKx8OP5O2dUbAdE2S5D4SqB/qtGjBu5r/hR9nH6IqYhhOMvVKwM25j9jssl6I3JxIGCC+pIs9+sAS98puhSnsl4ETyOD0XnBESwsvOXAY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750202300; c=relaxed/simple;
	bh=PK0XeP3SDiFq7CJIoyMuZQd0Ary1J8DWAsp5HUK6g8c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=bWyOcaLg20VO4kUWZx5KeYvjhTkMK+ny6dxCgMCp8LlMXEPV9c69Gj7wtqT+qvLyLXsivUqrNfJS5L5nnCDzR9nP4sIqGbF4O7tnj8KQF/nwTOBTdvQarXV39DbsPy4CxZIsFw0huZR1bvZsU6Uww/CcO1eaJR2AtAqXv+5DdMo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=QntmvO0X; arc=fail smtp.client-ip=40.107.237.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NcWfXIlK7HE92IghKyoo0CxNNYysJMvL6awKX5gTRKjMRHwJzH/WLbhBWavhgpREPvaeUMMIaYbWkU6JMnt0NGX38xlkMKoj9P97oqrDrZd/1CCXaf4RVVbgsd4MyRkxxv3HBNnG7FjB7PtG70+mPDuZzcEOOlRBlEogC6yUCyMBQqsSx/clUiYBpz7aLjvIjvDcERAgYvpuqoCzKVjRftHefkGRsZ96IwaX5/DLNXCOP7Eat3+rvBuq8S4MzYbURRPfgo/Lz3JoNAZ9x48hS6zYNZNrMG4h+/qzXjQbDyf1fwT8FHhDiUxSEIaJA2YaljnL6/pkb9GIAKqF9y7b/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wywq2suyor3gPqF0KDT18k9b/NlUsN+yqj/F+kcDeCg=;
 b=FsN+4a+ct4Ak2mPMy21bDhOFAbqWvb88zow6ry3TKTOfWC3NyvXz0/F//fGtNHDU5A79XAUU/U5SqC+x85I/G3rkdG6OqkKSFXdatExrGa6hF2BboMp2PXZclzEItHaVckzTOdVUZ8I/MH5YXdi2+07tq3/mikB1STgNxZTgnK/tOWvoJgj/YQxVkiq8Gak59JVrVsv7lxUd/kIv1Td9ujmaB8AOns14wsq5lzgRC4Fo63Mp1huk62lMRoIlkya89zNiS2xEwbg+8C6ba258bVqtT7y2mBGGxmTPabXC8v5UNhA8dgxLwh0/ABdAlmdjug/TaKeLN6poUJbLlcdrPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wywq2suyor3gPqF0KDT18k9b/NlUsN+yqj/F+kcDeCg=;
 b=QntmvO0XnkiWDai/aEWs2FPsY0q/Arq3mLzR8pk8jwckZrJGFDIanq/cieO0f0vi4KaQ6MUAjd4D+nqaKrNK937qHupEPmjd9EBfQq5igKZgiic+5lqj6s0Syc83yDIhCBSsRRG4MmRy/6NWfY4ZHd0MirrN7YbRyYR3S9HnRUyNf27G8WIW4dCR6Cx1FMbsicZ2eB5IyCnyFtQOf46tiR+ixKhc+LpFuvs/WPb5CvJ4cwvE/xMRavV3ESWOUj96nDgxRd54x427FMiHVzJHZjzWNhyBhj1PQSH3Dv5gmZSlsNbhYrgSk682CCg4vIq5zZ0fJ6zCS4puac+jMeIXBA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by CY1PR12MB9557.namprd12.prod.outlook.com (2603:10b6:930:fe::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.29; Tue, 17 Jun
 2025 23:18:15 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8835.023; Tue, 17 Jun 2025
 23:18:08 +0000
Date: Tue, 17 Jun 2025 20:18:07 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Peter Xu <peterx@redhat.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	kvm@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Zi Yan <ziy@nvidia.com>, Alex Mastro <amastro@fb.com>,
	David Hildenbrand <david@redhat.com>,
	Nico Pache <npache@redhat.com>
Subject: Re: [PATCH 5/5] vfio-pci: Best-effort huge pfnmaps with !MAP_FIXED
 mappings
Message-ID: <20250617231807.GD1575786@nvidia.com>
References: <20250613134111.469884-1-peterx@redhat.com>
 <20250613134111.469884-6-peterx@redhat.com>
 <20250613142903.GL1174925@nvidia.com>
 <aExDMO5fZ_VkSPqP@x1.local>
 <20250613160956.GN1174925@nvidia.com>
 <aEx4x_tvXzgrIanl@x1.local>
 <20250613231657.GO1174925@nvidia.com>
 <aFCVX6ubmyCxyrNF@x1.local>
 <20250616230011.GS1174925@nvidia.com>
 <aFHWbX_LTjcRveVm@x1.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aFHWbX_LTjcRveVm@x1.local>
X-ClientProxiedBy: YT4PR01CA0157.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:ac::29) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|CY1PR12MB9557:EE_
X-MS-Office365-Filtering-Correlation-Id: e4c2ceb7-7eb6-4947-085f-08ddadf53875
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?irgCEAKs3ZX2pAY3Pln/RxJE22k/h7qePqrr7bnuqglKlD2t7Q5swmPYLIeB?=
 =?us-ascii?Q?9l2Yane2C2ZtN94lV7f0igCZNFS89VvHo+HHb4PTpz32LpJ9UEH4E7Nh6IPD?=
 =?us-ascii?Q?0FTO0sCp5gtbtLjCLxL9j4M1ec0XhLLZvgKeTQXHOBOTZqAbrtjkDSTDDSBw?=
 =?us-ascii?Q?ruoy2ZlYxIB72nNEydi8iEmXtjwSVsVfjijDfuZy4EiiFdqHkDyyRaaEKa8F?=
 =?us-ascii?Q?P2ag1gdcMYNSKAasKM2s7ud9Oyy9YWoxwXnSZFPiW+xKFfuhkmJyUlWDW1Jd?=
 =?us-ascii?Q?p45SfMSw/94/HtYUv13iq9QxgMzfoNx2zrB43RogcswsZ5tYcjUn0YnvRPyF?=
 =?us-ascii?Q?una0NIWEc1fpwBwgrOm1EvRCTaQPgvYJdWZ+e7rNjqruxGmNrHZJkw/UOh7b?=
 =?us-ascii?Q?mBwN9c8fPB6iI4dyxLzKfIhs0YdZM59UkEKEBgx1Fz2Rm9OTzNImushROiqc?=
 =?us-ascii?Q?lvc01sIFjXYvTnlSg1DGiHRQLtNAVevl/943LkGcu+8R/SMMhA5o9KGZrujb?=
 =?us-ascii?Q?0k/+Xq609HfgR7sRrjjSUr1iQsRr33gIDWa6WDwJR0+PvLd9dFlHRK+m8dwV?=
 =?us-ascii?Q?TkthpB7z6/HtLBAGqjxbadoa4uGri3Db8mxCTUM9yU7GBueReLDzK1ulw/6l?=
 =?us-ascii?Q?TlOM6bEMEQsaO4RydPmr/a8rAuohNdl2/UCY025Bc6zt2VagpLAoA5u/ZXqj?=
 =?us-ascii?Q?XaIlrO3/cuQ+gToBBfa9rp3GqOWGbnEWYlaS6mL4WeSppJQhc7A3oEXvPJUG?=
 =?us-ascii?Q?FeIjYAdP9tw0gRip30QlxCdUow2ShcWKJu9iEEqIXZuFsLQ3woKvbcJ4JrJV?=
 =?us-ascii?Q?vFkX5ourdhWo9f84hlF5PkbsTk05DZclxNR4r0jyepU6g4Tv0qLy8TVLRxTX?=
 =?us-ascii?Q?tPrmyJ2PEJmC/xEcTS53NHz4LvZI8Sifd/M5oLbCx5xK12O3BqXKSfGiftw1?=
 =?us-ascii?Q?+fyk7uWRMEreGtTR78bgHat/ICUr15jFYL0zs2FghLqygK2LE+ONQz4+byG8?=
 =?us-ascii?Q?zp0KL+jPfThciGrwIE9VLsb77mzJaFjC55X2YRQGMeUb+FWNsBhO3RKef5oZ?=
 =?us-ascii?Q?W7t2ORMRIvhOABHLOVcwPdX1CRdZNQmvt3H35WC9qajo4SNaQ+PTpuZvgJ42?=
 =?us-ascii?Q?1uGjt4iv4HRraKGV5oOoznr1bbyfOiY10Rx6CoZLoPJTvy0i29eQHZxQX10k?=
 =?us-ascii?Q?wF5t7lWUDKFhGh4xmRziaXpK3M4Y6ukA7A3mPw+E9KChKyH+VlYQp1MriBpT?=
 =?us-ascii?Q?72/Zg69NYVVGT1305rVBdJiRtpKRjHgMVz0R+SgmB7LuTxY/Q7j5MqDA1Qiz?=
 =?us-ascii?Q?W8us4S2Z1Ml0xCq2FvVW2mY3L4A7q1DRaZMWepgOGnV3jggunnhVyjK7i20a?=
 =?us-ascii?Q?kh7aNg4k/iaQ3ECZvtM6iYythn2JYdHQYHpEndhbR3pqn4+cIQtHf94e7wx6?=
 =?us-ascii?Q?WekjbGGThwE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7qFq1A76wvwN1WYh+Ft+gXzehA5xQMnuYIQISajjS8K9BuOJlf+UbJMMrKOr?=
 =?us-ascii?Q?HuIfu9XF/Qt76QkB+agQu2/6mjGGhlislW/vNDek+Ax/Or/83W2wEgcUyL7S?=
 =?us-ascii?Q?ll6pZZNsnq0FsSkNapROONaUGqqT1VlYsczXslskfjslzVH78+dOjxC+RQCW?=
 =?us-ascii?Q?rJdv6QFQxB/cwcXiAze+Ij4Sjf8GxiIZoF6SjsQ9B6+6XibZXxuLrNy+uRcB?=
 =?us-ascii?Q?AEp3c8Pb1toTIwN1K2riKtWz926VhOGRM6bav7wDiIUzWUhcuTAT/tDFJtVg?=
 =?us-ascii?Q?PLVWtYKlicxf3xRfBs6RlFz/gTzE8yraTYZ/XraY9h9fq4nuL2Jxb1TpgDdd?=
 =?us-ascii?Q?mdGVWUM9goiTwbCm+czEu2JfM9Keo26ltVv/T1DR6iQvDkPL/XAQbH67gpwf?=
 =?us-ascii?Q?QfVR8zBTWRkSYywIo6iveSSo3HGrvjvdOQ6qfVyubOqnl14OXH7+erfGbpNE?=
 =?us-ascii?Q?xGh9emdsEtodBCu4MhktPCCfHs6k72o/IThDyvcKaU1gCaUk0yNiWmN/eBHV?=
 =?us-ascii?Q?A2Ftgx3gkMPkKIK57xe38wFsg6Kp/vmluZVjZzioXLy4cGS0q6iqIXcZr7UL?=
 =?us-ascii?Q?pNLKfz701476D+R8bSD9v6M9LKFlEKgXl4MNRpIY1GHYJy5Jz6wm+sksDRWo?=
 =?us-ascii?Q?mW/1o/uaR7guNqiLXjz4XY1iYW9ZbwBsuSdBDWBUI0aIcd4e6/9lY7WGMsqX?=
 =?us-ascii?Q?/hzuKw7oKb61DYbVDYI2/JxNK5o7M93p9ajSPWI/fBosuOBhBx6Q1o3i4eY3?=
 =?us-ascii?Q?3+nlEQW0fuBcAFE6e00XjzQg8dPKQRQ3IEbXiP/0q+Ona4Wz+USRiD4vrei1?=
 =?us-ascii?Q?tKpXDSc3Qt/svgLS3B0mTSmh/C3BV80E2cgYFziLd5s5Htjx5WmaAwHKpBKJ?=
 =?us-ascii?Q?PTe30034iWoM/6vtDJnoh3peHhjmx7RUEo6blWAfTceUy+bOamUFhCwW8WAx?=
 =?us-ascii?Q?F3dhm3fz+bJ50ijqN3rVwiZerpdlM0gJUWOEDr3s9F7mh0XURwbW2Tlx4fxe?=
 =?us-ascii?Q?1dIn/A8K0Umt+4lmMCnNGBC4GchB6ay98uzp2W9ThCLX2AoO/+c4p02Ef42W?=
 =?us-ascii?Q?KKVM0daYE87wssSNhFpaY/JuF59WVitcnfYDI5XjG0Xuc+OInq7aVsZXiqMv?=
 =?us-ascii?Q?sRbUiCx6Y3KBFoBu/phsyKNKuxtRPuNy3Y9t1/EaSX1AHfdQRmN95BFKtaC7?=
 =?us-ascii?Q?kLZzczuqU4AiD4SrqKF8Fq7Bbu7cnSN874Q+scs59dEhurssibgBslGhp/Bf?=
 =?us-ascii?Q?wpriH9OMyE1hnsIFu7dDNA6Ywz02JdI8GQquS0UBH+JGAylDRktecSkJa28/?=
 =?us-ascii?Q?WgqiHfauSLY+MLFbcWMmoR/LR570/A3Eb4kjT7xA51iCpXzqF0SEHMwLmxhI?=
 =?us-ascii?Q?5j/8CNitNoo5z+KjeFR/vXWhuUZEY44oacDB9xSYtRH8f1hgWhEVSlSC9Fia?=
 =?us-ascii?Q?QBxFy3huUuJ/7VdJO77o4wuzwre77XzTj3AqbdQHLzg6GOgUIsCcQJKUG1xM?=
 =?us-ascii?Q?dh6iKRyTz3QljaNxGIMfhIgU4vKQo0g8oi1g9wSdcIMS9RrF15ikH0pen0tm?=
 =?us-ascii?Q?C4hQtvqYduruIIKMRxLZrCmAZQTuiv2MTOI9xgcu?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4c2ceb7-7eb6-4947-085f-08ddadf53875
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2025 23:18:08.5094
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 684QAMeR6vIDcQYMZPjS31tXd8zXXy/r1OTgCnz5Jbvc+t+vXTgfp8ssfJRHyp8P
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR12MB9557

On Tue, Jun 17, 2025 at 04:56:13PM -0400, Peter Xu wrote:
> On Mon, Jun 16, 2025 at 08:00:11PM -0300, Jason Gunthorpe wrote:
> > On Mon, Jun 16, 2025 at 06:06:23PM -0400, Peter Xu wrote:
> > 
> > > Can I understand it as a suggestion to pass in a bitmask into the core mm
> > > API (e.g. keep the name of mm_get_unmapped_area_aligned()), instead of a
> > > constant "align", so that core mm would try to allocate from the largest
> > > size to smaller until it finds some working VA to use?
> > 
> > I don't think you need a bitmask.
> > 
> > Split the concerns, the caller knows what is inside it's FD. It only
> > needs to provide the highest pgoff aligned folio/pfn within the FD.
> 
> Ultimately I even dropped this hint.  I found that it's not really
> get_unmapped_area()'s job to detect over-sized pgoffs.  It's mmap()'s job.
> So I decided to avoid this parameter as of now.

Well, the point of the pgoff is only what you said earlier, to adjust
the starting alignment so the pgoff aligned high order folios/pfns
line up properly.

> > The mm knows what leaf page tables options exist. It should try to
> > align to the closest leaf page table size that is <= the FD's max
> > aligned folio.
> 
> So again IMHO this is also not per-FD information, but needs to be passed
> over from the driver for each call.

It is per-FD in the sense that each FD is unique and each range of
pgoff could have a unique maximum.
 
> Likely the "order" parameter appeared in other discussions to imply a
> maximum supported size from the driver side (or, for a folio, but that is
> definitely another user after this series can land).

Yes, it is the only information the driver can actually provide and
comes directly from what it will install in the VMA.

> So far I didn't yet add the "order", because currently VFIO definitely
> supports all max orders the system supports.  Maybe we can add the order
> when there's a real need, but maybe it won't happen in the near
> future?

The purpose of the order is to prevent over alignment and waste of
VMA. Your technique to use the length to limit alignment instead is
good enough for VFIO but not very general.

The VFIO part looks pretty good, I still don't really understand why
you'd have CONFIG_ARCH_SUPPORTS_HUGE_PFNMAP though. The inline
fallback you have for it seems good enough and we don't care if things
are overaligned for ioremap.

Jason

