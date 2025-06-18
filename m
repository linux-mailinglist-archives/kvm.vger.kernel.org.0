Return-Path: <kvm+bounces-49891-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 88D32ADF506
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 19:55:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E7DF73A49E4
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 17:52:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21E5B2FE305;
	Wed, 18 Jun 2025 17:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="scP8G6S2"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2086.outbound.protection.outlook.com [40.107.220.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3773A2F5475;
	Wed, 18 Jun 2025 17:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750268809; cv=fail; b=Pq2jbC9XGKkfDdA0HqJfjlLuRYqwa/IYaNkBP35MWPDN98HkVtioITm0VAKf9cGStkEgKlJtpIdVIl0N0Z24pS73OY2yMryEn3A7JdcW6gn9KMcxBePd+tLQuYHeyINhCzk13w/KKNNcsMjA0yMjTfwYdZtEJ2wxHu7s78HvkuU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750268809; c=relaxed/simple;
	bh=cXEFsgAaQyWTJ60VKvcN4QJvPVx8uOiH0+mfktzMY+Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=SH8ndVy9f4uGSoTUkcou4/P+EUu2SS+U0vOBe/outMlAyZEH3lgnIqu43OendSApUSPgNATS47hu2xBQPfDoZUNrIAbIw/m6oD9qEOE9bf5MWwnwW9YakNlecFLiQOOUdm44WIGTFIp6+Llngk1czNB6Bwu7oTrhco/qoFXx7FQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=scP8G6S2; arc=fail smtp.client-ip=40.107.220.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UoIV/PwincmmRam5C+KiqVfjT+ADAW94wr1S6emRVIzwX+GdrOuEah3xuIrP4eV0ktTDqcriwcd4qhafKbtj875j5FPxjdIwCsyclwq/E0bGa4TaQi13baX5qyZpkg9ZHUXzUx5OeP8LXYBgDbD9zg1RevDX7o23qeJsNMjoYFcuqq6z1qWtXrAAX9gvUOmb0nGL1O+TbyMwDB2SHfO8sbqZZDePqgmyCJUtgMO3Tbv1473Smr4z7BgoOn60d4GbKy0KWvakrYTtm+ManzD/HL48516j9lTDPTxYIbbfWalu5RvrdyTKdVJBJD9M0rCOrSvFXdnKSHFOwCPpMOPrqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pmFKLHTUR4ceOBLg5cwyp1EPYO8G8nuAf63B/LlUwmQ=;
 b=EoCDA2ZljtoYj6xNvTg4Z5LNGbisLmgftzhwS2y55pR1c75iICxE4C5+Hl48hyErlrODx1kkOopF3V5RieUSKDLNtuqIBtY+g2bwIRbAMNS//EQDrhZdLgS/Uv/DwMWsgPB9ZWM+NAvCjO/KanXqQdwEmHxflO+nQQaZPOKLVScs+nTY7N6iMHKHXb9WGGM8Ld2IXVvwKjBh/eVuszVtgEky8in5FUn7x/Jv9QFPI3Ep0wHG5IDr8fANwvvckI7tAop54vBhHJXjZ2ElP+uLdpcOdzIRfIkpWAPZUXtOBlaKeqRoy7HW4yFt0nJ9jQeD5KPMqBUlxqSrlULECO9wcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pmFKLHTUR4ceOBLg5cwyp1EPYO8G8nuAf63B/LlUwmQ=;
 b=scP8G6S2eHOo1wASsfbuaFlRlgi8r0JuSxrzo5Kh+/hyeUQPErh6e0N4YVz0BRRnBc2JwYAFdD+7ysj0IDgpDvuH0K4qDHs3tktSZJuhlWnTXF9Cw6+XmR9wg8r+q60/4oB5qIJJ29QISus1uNhLKiU/ONhFRKWeWO6iAMW8KEW8gVuB9rXA9y0j2MGHqM1sQ5mPXYqUXBKD5pZRW3Ka/IUyWPolJ+rVVxHcTxfU/kE+B5xEURVFGS6PlkyD6tZs5HwIEUHUFGLNorYNGZAZfzFl0X1YMbx8o2psoswJeymAfPDHYTyVK8gSwghi14mo/K90lZLz3saQMWDA/PM5fQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by BL3PR12MB6569.namprd12.prod.outlook.com (2603:10b6:208:38c::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.20; Wed, 18 Jun
 2025 17:46:42 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8835.027; Wed, 18 Jun 2025
 17:46:42 +0000
Date: Wed, 18 Jun 2025 14:46:41 -0300
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
Message-ID: <20250618174641.GB1629589@nvidia.com>
References: <aExDMO5fZ_VkSPqP@x1.local>
 <20250613160956.GN1174925@nvidia.com>
 <aEx4x_tvXzgrIanl@x1.local>
 <20250613231657.GO1174925@nvidia.com>
 <aFCVX6ubmyCxyrNF@x1.local>
 <20250616230011.GS1174925@nvidia.com>
 <aFHWbX_LTjcRveVm@x1.local>
 <20250617231807.GD1575786@nvidia.com>
 <aFH76GjnWfeHI5fA@x1.local>
 <aFLvodROFN9QwvPp@x1.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aFLvodROFN9QwvPp@x1.local>
X-ClientProxiedBy: YT4PR01CA0409.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10b::14) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|BL3PR12MB6569:EE_
X-MS-Office365-Filtering-Correlation-Id: 87ee4956-0eae-4e5d-2915-08ddae9015d3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?cYKZfGRApZ1L0Y2gtvSoFvX5v/9JF09epByeh/lduJxH8zJWVP7lpqWhEcsC?=
 =?us-ascii?Q?5xPwkZ4n3LnBQocHoZ7ug1Z4Vu4ztRyyTM2slvy9SRJhXvAVgdXP/sJjaqlO?=
 =?us-ascii?Q?s2t4FCPKHV7BMMMlyHqiJPBYVP4E+4EplhZJiVBnIAqtZJuZaFJemrNxYRWh?=
 =?us-ascii?Q?7HC3Z+mTFDQn4f6v01tRzeQcoJa5rZwX24/eRzTbyEsL6cRFakbN8lgE3osp?=
 =?us-ascii?Q?asCazvtQchLNVCKWR/gXJ+DiE76IFqU70T7oA0d92zT4SEq95FLE72DLmxLD?=
 =?us-ascii?Q?LGGRO6LlKWMqL4cO3BF5zsIcMwhuN4azvIFGkI69adGQIrmCCuO29LJgRCEY?=
 =?us-ascii?Q?0semhHl4ohBJ5rZbR3nu9JGwGERWTXKdr7XsTWclxVcHx4kPTgPGmcOradM8?=
 =?us-ascii?Q?cV3KWUlWXetboXFoqkwMvACkh8R3TKWCLkgH7pCrGfEJ2iEbmrT6IrhrJQe5?=
 =?us-ascii?Q?SHR9Np6yCIAmCxMd+GXpmdK4gJ8VGpkSH94E8tHVn4dtPB3hVanYvJs8bF4x?=
 =?us-ascii?Q?f8HPu6Obcj2TukS3sWRzalJLUnr86N8s6UxVcgT/9L1FyhUn+4s9hgTy4x42?=
 =?us-ascii?Q?GC0guBRHKt3OANyfjCpX4EXm4nQK3SdJWUt6h3QYs9SkKIPYCzlRUoWDNHfP?=
 =?us-ascii?Q?mWA4KxZuxITPXzWsAFbUt3Ehe7K69Ur05uyo0p8bC6VQ15G/x7q3WJFgpWL2?=
 =?us-ascii?Q?CwmDmiKsH1Dx/S/loTg8PlDIzzb3BbXs5P3rsQY3DeuPw7hjOSTVCBEY81Bg?=
 =?us-ascii?Q?5uaKRqfl39kc0AKnLlve1WKp3ADP+1C/eRch5GBWAVrsY397TCPlN/yToWWm?=
 =?us-ascii?Q?xqmMPYBTZhnXfM/crVT/BmOTOU4s6KUM7A9bBQP7rOkJyG1Hl1Z6OOmZ0sPK?=
 =?us-ascii?Q?Gf8FRbYHmd4YDXTYfVsjZ66K4ApZbBWM9UmovHhTlgTl13Y3CBNz4xOc+UJ6?=
 =?us-ascii?Q?f+AnPBneRHgX1oTycfSOdRAG6y+BOP9/3guK5K4jHq7Y7eu2M5IcZefZ9h8c?=
 =?us-ascii?Q?kdBzcKX6E0FGK43hW1TDH55dT9WL0dSRrDEghm6XTdfJml6tiV0agGaUOxUw?=
 =?us-ascii?Q?ZCQ0SAMKanNHjnkvlz/Qp0xIevvqYDjIPLzfX8MQmJ+Zn8RoA7lRx8vxr1jB?=
 =?us-ascii?Q?C/2b5rzYpHUSyGy+s218Zk2wLQ1mnCvPw9NcoUBzp7VRWFdn/4u2AJ9Bu9s7?=
 =?us-ascii?Q?UPBnk8nH5S2gVNLtdAOjg4Ata/26M9E8uE12JKe4uNFe0VHrR2FdQ1Ejw8xr?=
 =?us-ascii?Q?MG0gNZ51Q7z+ANoXbHvCF4wcC16WFmjeze0LXzLn9gnQEAtTiS5k9KkMy7VV?=
 =?us-ascii?Q?pPKQnUXqAitqNtBamFgF+zd1W2+UHi7bVb0LX/nE0kfo/H/vNEHdXVptcFeb?=
 =?us-ascii?Q?NOvuhPATtIntbwLUQvR1iSCynWWYDMFg50tjbmaiyuUtcP+7LlOX/5xUiQYZ?=
 =?us-ascii?Q?7eqcKUcmu7E=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?VWcKOplCiSiFMEZ/3A/IV/ga+VGj/VFCezzxdscP0nrt/v9l+szHyYhgSztz?=
 =?us-ascii?Q?RF+KOWjdN0q0en3+YkO2+ckklcPr5hfi4AnNqmeTFkmECEwXVAWuxZoXBCLH?=
 =?us-ascii?Q?g0SKujtf8hUvv2J3R0ffHF/1eN6l9Vm5sjqnIlwnmLe587trvc4Pi3ch8nF8?=
 =?us-ascii?Q?R2vX0OF+52Gzq1QC+APQcrNmL3maURezFmoB5MBinJfgsSkJXgH3PNSKq5jy?=
 =?us-ascii?Q?3os5d3uS7PSgyvNPnKHLBCSJQWKcPDnpUUr1IsoKM8+A72R55Gogc+/qwhv6?=
 =?us-ascii?Q?WBDSCaxwSkE2aBfHtcE2sz5UBOQKYOYqgW6QP/ubT9EDNNpeWHKCDZHGu69V?=
 =?us-ascii?Q?K4h8vKxKG8TyDVw86ZpZXAC+Lh9zYXLPKJMs81klCaKfoqJZmN88chAxM9kg?=
 =?us-ascii?Q?vtmwGRfUVAWWfEk7Z//CDsRp4YJ85eTnjIxOk6j2uZjypSb1DxHnuVXt906k?=
 =?us-ascii?Q?7u64b3rh9+Nv4WvG7odu4GgT6foJyt4gWkIR3W9e+aauYLvrK3oa+Ozivg1m?=
 =?us-ascii?Q?2o3lPy8a0lHTllNURuYMudETFaATGOrmR7r0K0m+fgT3koOACnVd4ZKqu5g7?=
 =?us-ascii?Q?eWJLxJtaP4hwTau5hpmqcvErCb9ThRWIAkucQUyGDGUjsxG5KgrnmNLB3tde?=
 =?us-ascii?Q?w5Jcqr98pB6wc5Iq3vYiWjCnS0JWFBod+WdSXPAkG0uKN1wxvwhMXWyYHRUV?=
 =?us-ascii?Q?WKuCnPXTvU4oHllRGbimWtau867h8/fPn0wzBIfj6asJrmR2yxBQJy/M2otF?=
 =?us-ascii?Q?YkcIUUrQNGQvC47HZIlkiNdWNIn2d0qg1atNin2/Xq9V/bEJaM6V9+30fsRt?=
 =?us-ascii?Q?ZmLiK16hhtax4RXryXY5EiyiIIsoGmIIOtTFvHdlQBtcFmb8P44Xp+b3OpeM?=
 =?us-ascii?Q?zVybjZ1NXKNzbQxMybxY0ta+Vd/lMWxEi9Ux/txjYBmnnVfTFER0E4VaSTjl?=
 =?us-ascii?Q?IEMd4LKAIKunS/FMlBodwQ5CNM8jOKbqAXbWYJgy32Dar2eKzxEk1n3wyasd?=
 =?us-ascii?Q?s9SQR51PQjxI7DUZRDIWdaVupbiz0sVZSUh1z00RXnxbo+exCUHPbac0/qAq?=
 =?us-ascii?Q?L0eXoto/SNOSYWd+rbVAXDmtpNmwdg23Wl61OGGikKF+HOZLWBrG/plIzSoB?=
 =?us-ascii?Q?KcqiDARUs2GjeW37lV5z9+El7oOEWo0dDH9lc5oyy8LweyDOCsvCoGhhvv87?=
 =?us-ascii?Q?KeNg/AuwMH8j3E0MG03Yox0buX52yCtzNXisgihtd9qPUI85tPNdDgp1YD+j?=
 =?us-ascii?Q?8VqypCaZOcRtU2A16uTw0NFsYfbHPJdMP300Zs9aiUSBwzV88wxD+FwlPQar?=
 =?us-ascii?Q?HzAionr4OaKjl1tbM3LhQTg7JFjYvnMKJePinOK7oFBXtrM97+wysmHop4nN?=
 =?us-ascii?Q?ofp56nJi9ljZKMQbcmZxw/lLpNap0mqeHSz/HRmPzRoRJexUAvMAwIcL2WTr?=
 =?us-ascii?Q?a2sa9Vy/8u3cgRW4+JSJXiTWIJIIG7qiZxSSXphGErKNSSCDcequoTkB6/nv?=
 =?us-ascii?Q?eWYUuvboLxwz7h80ib88UOLvcN7RdBgO6adbgJHZL1Yu5CqGnxxOS6Xqh7q7?=
 =?us-ascii?Q?Cf09o1Nx3pz9SJxqJA6crddZb/JCyaRHH1bUCELM?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87ee4956-0eae-4e5d-2915-08ddae9015d3
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2025 17:46:42.5800
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XB87HmGoNGhjBUNO7vHViCPEzqrqy8YlSL7J6CFE372UXBJWbrg2k2SDLw6jyTIu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6569

On Wed, Jun 18, 2025 at 12:56:01PM -0400, Peter Xu wrote:
> So I changed my mind, slightly.  I can still have the "order" parameter to
> make the API cleaner (even if it'll be a pure overhead.. because all
> existing caller will pass in PUD_SIZE as of now), 

That doesn't seem right, the callers should report the real value not
artifically cap it.. Like ARM does have page sizes greater than PUD
that might be interesting to enable someday for PFN users.

> but I think I'll still
> stick with the ifdef in patch 4, as I mentioned here:

> https://lore.kernel.org/all/aFGMG3763eSv9l8b@x1.local/
> 
> The problem is I just noticed yet again that exporting
> huge_mapping_get_va_aligned() for all configs doesn't make sense.  At least
> it'll need something like this to make !MMU compile for VFIO, while this is
> definitely some ugliness I also want to avoid..

IMHO this uglyness should certainly be contained to the mm code and not
leak into drivers.

> There's just no way to provide a sane default value for !MMU.

So all this mess seems to say that get_unmapped_area() is just the
wrong fop to have here. It can't be implemented sanely for !MMU and
has these weird conditions, like can't fail.

I again suggest to just simplify and add an new fop 

size_t get_best_mapping_order(struct file *filp, pgoff_t pgoff,
                              size_t length);

Which will return the largest pgoff aligned order within pgoff/length
that the FD could try to install. Very simple for the driver
side. vfio pci will just return ilog2(bar_size).

PAGE_SHIFT can be a safe default.

Then put all this maze of conditionals in the mm side replacing the
call to fops->get_unmapped_area() and don't export anything new. The
mm will automaticall cap the alignment based on what the architecture
can do and what 

!MMU would simply entirely ignore this new stuff.

> So going one step back: huge_mapping_get_va_aligned() (or whatever name we
> prefer) doesn't make sense to be exported always, but only when CONFIG_MMU.
> It should follow the same way we treat mm_get_unmapped_area().

We just deleted !SMP, I really wonder if it is time for !MMU to go
away too..

Jason

