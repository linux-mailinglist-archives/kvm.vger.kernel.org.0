Return-Path: <kvm+bounces-50682-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D391AE83A9
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 15:07:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1CE5D170948
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 13:07:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95D20262D0C;
	Wed, 25 Jun 2025 13:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="MwHwvypa"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2068.outbound.protection.outlook.com [40.107.101.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21DBA2620D2;
	Wed, 25 Jun 2025 13:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750856837; cv=fail; b=kTB6Ex64feQnML0XHOqvjponSCHBR6TT+i6uKkAfn2aev5DoxgYpz6AMimfLA9KsX3dNYvy8q67FezrYGoC3yPa682eGOWYYFgElDMgP6TspBV1a4DT3spQ171GfHtinRY6pCT1vOy8m84zKjda54nn21C6gASOzSO2rnQzHRwo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750856837; c=relaxed/simple;
	bh=M/WRJB0VXDqbqxx5iQNCh6/Kth5ntz3xOm+8GF47IOI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=PFYcB4LOKpQocC4rA6vn6S+6QGngVahvWsqhm43Ij6ZjVzSrqo9Wdegv5KbX9BG/84ZHOgIxqOP+1oaA7i6XlZUuIrrpCwyZgYueTUV6gH+Z4pKYvS7CxP6NWHljERRO8Oxxi/yu7lYEQHfOoB0pjifpfLTaDEyEzaJR518xVDM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=MwHwvypa; arc=fail smtp.client-ip=40.107.101.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rIrYoyh0ycVMKtNixqXyuqQNo0nOTcrtdoGvNQl7xYSvAqUcgo8B4B7dX6effsAXdwQAFi55NbjwKE4iXj2JMoLkqx8g8gNRi8N1BV0lWQVSXyscCuYU/VF6A/1VUAenDnExFGU1yLP8db/1TthZKECLiJvjYjyGC5+qFX5sj6CqPPwGy8pBxTA6GiwxC/NZIjmDgaYudM7tRyZdSu+lpBKD5Lp/nD12MSSbV6UYwuL53neg49Sw1/CwoW0ydnfp2Xd0ndvLuty0gnKK9KItlMe7sRa5g3Ik3eQpZs+jyuMdGCSB+Yz+5maMynAfP1WuRv3Imj3lAnehYPFtgQfa0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M5Zn9XAoNHQa9LXvalLZO3p4NqOETHZYYbT0my0Ubzo=;
 b=E0sFRsExhhEe9ONW13NB9Bs0KC0seejyy/zG7qtDdhz7TIdUaWj1dBICu72Q2X3PbApfqi8bnmaR8L7m3j4JbteKMDys6jHTHqzUekUJlFVC9/nNHWG6lC17wFy4V94v5+qeXHcK4PWONZknJCcaj0eoX9nSwfgXOGCRjQCIV2omggR/nPDk51j6eqd6lqjT2Ez4FpnYD23jTQ/t++638Ve5tqPMJECLsk2dm6POFeVHGF2SRheVZALo4qKLT/2QuY1emNKEE3F81bP96fmzXmYzBlayu6AtCIzPdn5cQDpr4+7VqdJqWPx1uBFu/L1ikkHpz0zyr/7MhN8pChAlvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M5Zn9XAoNHQa9LXvalLZO3p4NqOETHZYYbT0my0Ubzo=;
 b=MwHwvypa9NqhkjMyQn8+xUe6OvtUgO53WAPmp5oFH/wc4oftfZK6gOQLIDfY2b0PHA8FLmBMo8xxm8KhYMR7Oa5y8Bz6EM4owZBAUJkHogpJsI6Ebr9W2KvdwN0u5xEprprnpRFrxKKw+Q5HfkaVB5RFqNnrnmn8g+dN7oJjA4W3/ngCqQu+fWnmev+lemkjcDarB6U1v8PvaEPdTRt1iruIBLoCnjeyovQKB079yJc9Vmbbcure75ZOwQcAp8RISnjcY8rD3K83B9PIChZbTNoqnWS/VuZodwDelMDA80hmWDiFajG7Kt8apTVJPu4IoTGnG82hayglZ403Dok2gA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by MW5PR12MB5650.namprd12.prod.outlook.com (2603:10b6:303:19e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.29; Wed, 25 Jun
 2025 13:07:13 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8835.027; Wed, 25 Jun 2025
 13:07:12 +0000
Date: Wed, 25 Jun 2025 10:07:11 -0300
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
Message-ID: <20250625130711.GH167785@nvidia.com>
References: <aFH76GjnWfeHI5fA@x1.local>
 <aFLvodROFN9QwvPp@x1.local>
 <20250618174641.GB1629589@nvidia.com>
 <aFMQZru7l2aKVsZm@x1.local>
 <20250619135852.GC1643312@nvidia.com>
 <aFQkxg08fs7jwXnJ@x1.local>
 <20250619184041.GA10191@nvidia.com>
 <aFsMhnejq4fq6L8N@x1.local>
 <20250624234032.GC167785@nvidia.com>
 <aFtHbXFO1ZpAsnV8@x1.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aFtHbXFO1ZpAsnV8@x1.local>
X-ClientProxiedBy: BLAPR03CA0159.namprd03.prod.outlook.com
 (2603:10b6:208:32f::34) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|MW5PR12MB5650:EE_
X-MS-Office365-Filtering-Correlation-Id: 43957b60-52f6-4e0e-1e51-08ddb3e932f8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?B1SJBRRovLNWsODcahN317y7bwaqEI5Ypa06mUPdKWJXJrq+Mhew3iRG5rPl?=
 =?us-ascii?Q?qa+jB1J9vorckR6yKdaObigt8bXuIXS8MjaEnGgo+bUYBh96eugDQE3wqfZ6?=
 =?us-ascii?Q?R6UT7rGTnKG4y9qaIjs7W2FT1GNHRlTAu+PYkTzhA3PnLWRZSb4x9g5LZWD8?=
 =?us-ascii?Q?p6NDoPYlCAN+tKygycfIoJnO0lLvHzlK0hDzjwX1F28nQJuJrSCTNSH+oKHO?=
 =?us-ascii?Q?xTynEbwj6Wga5wvphnvPj/Mn80KcyOxpPjGFTX9vycewDonqhUHpjdA+6Grr?=
 =?us-ascii?Q?ehmoebja3JB50CzunfJILbPU3OHaw/iwDCf9u8R4TUXIkjo2P9MS7eks+Hkk?=
 =?us-ascii?Q?5NIL9Y+oCqXaXZSRCr3QSOARvAf7IY+YJD6d/lmgTw2BrdXsE80dwVhu+/0J?=
 =?us-ascii?Q?pTBuGA+WBOeChn8VRuL6NJi8/R/TAHzAgP3ghRsMQNhaa3PB2fdBDjo3O/IF?=
 =?us-ascii?Q?gs5jvzvskt1/LPXvN3L1cRfcZ3CP07WMW/pjMPcwTL32hNqc3Tt+YMwxYqpC?=
 =?us-ascii?Q?P6KYy+l3Bdm3nElDn9Iv8z020oE+rcsN5gJa9VChuHbagZIpzTdrO37rXHl6?=
 =?us-ascii?Q?81HRKSoQwNz+fpmNBWw1Kj6fXGUmzTwAhhxSzKlel9GPrZmSfAMetwRqbqx1?=
 =?us-ascii?Q?FxE43b+png2wO+2l4PkUVlBDZ6VyejxzY28KUAHSR7hGO0RP3ZjXac12+rHv?=
 =?us-ascii?Q?8gbdiWIgA1kz1VTCFEoVOX84RGpCUtpB+UcJTFzK+tCEE4pjDsUf1J4Iktve?=
 =?us-ascii?Q?JBi3RNiyZZv9Pu0wlEytiGKQGTs+i08x2SErRU9bQBFKlUxD4ryFkIkEblmB?=
 =?us-ascii?Q?W/hCl4XKMMInZHugY08V3GCkLohTyTM5KRBuLU5YQO9TN5VUVSvZ8bXYtY/d?=
 =?us-ascii?Q?If8QEFUDOL0x5CJJIrj+pOa4tA1T8t6pvd+KiwZDZU8f0ngpAtRjMTcmjFs9?=
 =?us-ascii?Q?Crls9MDY84bUygSpTJv/IrkNLr8YY/tiahCN4sgC4/ZLrlNZ7PCzq81FAkxE?=
 =?us-ascii?Q?/MGl4Xrpi+y4MO94C/qX4LPTMdztc9eXKY1MG2ZA8CFKkAfH2tKhEFD3kHqI?=
 =?us-ascii?Q?3DboHE/Gpf5Q/RSymGPbuMWiC2bf5TDNX8/y+TT1Vmktiw0Gru+NNiJ0CMiA?=
 =?us-ascii?Q?Iv8ETz8AQzOg45/jufDViGA9XLLVY1xvod/+gA2OQNRiqvXEshHRazin0Ipa?=
 =?us-ascii?Q?tkyQWCBWKwqIp9NLPcioCdPoCEb9u0FI91f19OOzdQ6+2c8MUDAxDmlwWg5A?=
 =?us-ascii?Q?8YK3zR0la58Q0RwCuzd1EIJ53tfVxMgJmlOYjjpT0iKZ9NXfwyl56uOFKP88?=
 =?us-ascii?Q?jnroNxtdqRNUO5/0D60QdjLVtx4saLtMw98RNxXYvzytF7bc4KoLe/c8EXu/?=
 =?us-ascii?Q?JxHanshK5DaoKakMCc3Y09BngkyKM0xaEl8aZf1rwJhNkr15qfrAa2cznURv?=
 =?us-ascii?Q?WUUJBGCtqpo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?t+3HKS23fI1sAKQ0dPQ5SK+BITbqh1n/XgN9NilO+tZzNdMq4TT7n5/H/Sfr?=
 =?us-ascii?Q?4iH+tdAvWD6Aw0ET0htmopvIrj5bdV6mhTZJQx4wuz8r37tdAmqhAanLSgRR?=
 =?us-ascii?Q?wkRYaptM/1TRw5tt3X8rNtutKOS15BhId8QLKlTckAvQuFiF2ArWhYLeYqPZ?=
 =?us-ascii?Q?RscD1rH797onfQs+dGB36A7ltspwNLh9E3RJN3K20TvtpKFIU/Ktp66AuF/l?=
 =?us-ascii?Q?uqFuAFxGhg3ZO1LGk29h2Tc6kX8El3g+3VuFCPnQMjSPZ5Mq4iX9u6HXr9HD?=
 =?us-ascii?Q?2Zfott19D0UckEY1COYfmXuEdrVy2/GYWjncl3fvxh42CzuWF9/a80ccg2bk?=
 =?us-ascii?Q?CSMx5B8FBP3pieIH7cZKa2y6tymFdrCbJmcMIDBFYNOqdxq6KcIeOEhFDkw0?=
 =?us-ascii?Q?Yk/1kdJxUcRqQ0OfHpI+4T+gTLP38fSURcZqgjgevoE3iqsj6nkwTh7aK64w?=
 =?us-ascii?Q?by9yNB+nb8SvK66bwB90qoEN/Nr/2kIrohIwQdiMy4MVKiZz01W3GOjUEfQo?=
 =?us-ascii?Q?HVNWBcM7DG5qGUo0KpdgatQNbb8QT85gQCbr3wf+H+qFln1edLJOPAvhqlCp?=
 =?us-ascii?Q?56m1c0neLoIc21jWcG2B2AWl1kYoZoxDkbyhGfHvF6gK3vQu0YIstxvRA0Af?=
 =?us-ascii?Q?VJgzcUnLyZ9sbDdCStB8/QXJPTc4jDpbEGFGE4khe2Ihk57JucdmYrbx6t74?=
 =?us-ascii?Q?7XI+3OvSjD4+o/znl6NKMmlwn4p9AUH+YrW5jrqD0V4ycWL2XAq0yx1tXFVg?=
 =?us-ascii?Q?qreI+bpcOuQCNCqBYSbhnqiJ88EWChl9PgBZSYwOiQXBKZ2GhzDTbBSMbndK?=
 =?us-ascii?Q?qwl6jw33N1aFT0XnpsHxxZXX75tD26U/AF6ZdPk3P2k/glWRbty/R7Q56yHu?=
 =?us-ascii?Q?C0EqQAOFpbE9/gLu0xWXxqRpZHZQgA0MeJ3CUvz7np8ocHRhvriT2nLqOFvS?=
 =?us-ascii?Q?uZHR+oAXKh9Yu4sPVZuSa+TT5qdrkwc+qpV/jqUQX35yArpPE0yBhq2uE7Q2?=
 =?us-ascii?Q?njUiRkRB4tjgVCMywrz6s5hNGAcDOcWLStKtzHV8N8lzBdItrNAs7mVONHkT?=
 =?us-ascii?Q?taRGcrMt2MZO/POeFaxrQMs6zhjJ7Z1o11/tyIDNfOCLDmGecFhMu0laKEhm?=
 =?us-ascii?Q?H4ztsA0oo2jEFUOKw0k5p0Fngw5ZlYP9IL18NiSrx9MigHLrW+ET2mSwItsH?=
 =?us-ascii?Q?nSFDTso6kyj0d2CUvhXuRyMP94/dlIwevD18BjEnU0WuW73A7q8Fsn1YcW3P?=
 =?us-ascii?Q?HlqDF7u9vvqAZGmHxsmPnWvCVm1RGEtsW02fm3JCBIMrSNtTOKSHr0AarCc8?=
 =?us-ascii?Q?yY5O7Dg2sqRKo2jQPDm6cxyrFh19IbAdaNqrr3D5SDQduOW+DBVqOL9/ElhL?=
 =?us-ascii?Q?JvdxMdkNgEwPTK1yVplYHKxouf1rhvg3o0q4jNgGihEIS8zOqsmV373bdbBZ?=
 =?us-ascii?Q?0VKtQDVo9sCZd/5Mi95gqOOm3w7LS0StSgt6itt7EfFHjAVnXkZZWeeAIjYW?=
 =?us-ascii?Q?U9fjqknGiSq39spc/twNLWadtHfrFoTZukiguoHf+RgD4Olrr52Sq3yEO+8g?=
 =?us-ascii?Q?FF14TbxgkLaiTyurczj0J033oaVDHDA5yV/jlMdY?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43957b60-52f6-4e0e-1e51-08ddb3e932f8
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2025 13:07:12.3567
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ampU6LrRI5T0otLjrh7Bsvavqeh9G7g+VbDbhDfw8ztmYFN1+NSx4i7o1ueiA41K
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR12MB5650

On Tue, Jun 24, 2025 at 08:48:45PM -0400, Peter Xu wrote:
> > My feeling, and the reason I used the phrase "pgoff aligned address",
> > is that the owner of the file should already ensure that for the large
> > PTEs/folios:
> >  pgoff % 2**order == 0
> >  physical % 2**order == 0
> 
> IMHO there shouldn't really be any hard requirement in mm that pgoff and
> physical address space need to be aligned.. but I confess I don't have an
> example driver that didn't do that in the linux tree.

Well, maybe, but right now there does seem to be for
THP/hugetlbfs/etc. It is a nice simple solution that exposes the
alignment requirements to userspace if it wants to use MAP_FIXED.

> > To me this just keeps thing simpler. I guess if someone comes up with
> > a case where they really can't get a pgoff alignment and really need a
> > high order mapping then maybe we can add a new return field of some
> > kind (pgoff adjustment?) but that is so weird I'd leave it to the
> > future person to come and justfiy it.
> 
> When looking more, I also found some special cased get_unmapped_area() that
> may not be trivially converted into the new API even for CONFIG_MMU, namely:
> 
> - io_uring_get_unmapped_area
> - arena_get_unmapped_area (from bpf_map->ops->map_get_unmapped_area)
> 
> I'll need to have some closer look tomorrow.  If any of them cannot be 100%
> safely converted to the new API, I'd also think we should not introduce the
> new API, but reuse get_unmapped_area() until we know a way out.

Oh yuk. It is trying to avoid the dcache flush on some kernel paths
for virtually tagged cache systems.

Arguably this fixup should not be in io_uring, but conveying the right
information to the core code, and requesting a special flush
avoidance mapping is not so easy.

But again I suspect the pgoff is the right solution.

IIRC this is handled by forcing a few low virtual address bits to
always match across all user mappings (the colour) via the pgoff. This
way the userspace always uses the same cache tag and doesn't become
cache incoherent. ie:

   user_addr % PAGE_SIZE*N == pgoff % PAGE_SIZE*N

The issue is now the kernel is using the direct map and we can't force
a random jumble of pages to have the right colours to match
userspace. So the kernel has all those dcache flushes sprinkled about
before it touches user mapped memory through the direct map as the
kernel will use a different colour and cache tag.

So.. if iouring selects a pgoff that automatically gives the right
colour for the userspace mapping to also match the kernel mapping's
colour then things should just work.

Frankly I'm shocked that someone invested time in trying to make this
work - the commit log says it was for parisc and only 2 years ago :(

d808459b2e31 ("io_uring: Adjust mapping wrt architecture aliasing requirements")

I thought such physically tagged cache systems were long ago dead and
buried..

Shouldn't this entirely reject MAP_FIXED too?

Jason

