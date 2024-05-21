Return-Path: <kvm+bounces-17846-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C84288CB1E0
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 18:05:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EB50A1C21FCD
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 16:05:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DBE91CAB7;
	Tue, 21 May 2024 16:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="E9QmSGSO"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2045.outbound.protection.outlook.com [40.107.236.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 067AA1B299;
	Tue, 21 May 2024 16:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716307490; cv=fail; b=sf8/hhfPU+aaxVieXnxOvZJhtgU0f4GrMO9kxoky88Va93cjvatzMSy1t1Nwt6vpfCr5Y7j9keOfDHhOYRPeJDShLSsGKfQv2BYcm1AIcY8GAqE+wsXK6Ef3IKg01IBJpuQQkXDQjwXsmvdfo2+K9RL7pXlBO33LtqmLROYWCe0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716307490; c=relaxed/simple;
	bh=H6GorP1SMmREUaDGHPBjwc6OyitWYKYQ9WTn9inOXBg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=hf150Y+EBDXrOTjL2OCeRkuxAkcQqRbLuDL/m/guxxxgV8O5DvpD0PHLDuLbYzfgFOlt/Y8MgctN0ZYKpGLM1sV7sTu/Ek0SiJZQG6MypPr483rBhoyufjrWvXIlg2+M+yEbVSBToaFIQSNGZytSEcOP9bamUmlehAg2ZQWJ2qc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=E9QmSGSO; arc=fail smtp.client-ip=40.107.236.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RLNW5OHugjNEEbCZwFSpAZVRTy8k8L69rxLMQw3GICiuEawUVm99qXuX/MdBUFk3w57y57VAXTctGI2es1B8cpfzG2NQMf69SxlnbrVs67AIcUyktjbNiOAmcb5zM4Wwi4txtgNEeAeFSYN1GY9plhkZF5He634lH14R+bSppsUJA4L3CIgR0AneOuMXXXydrpfkX41S40bmGUDS3GXeoHIRsicQmXymawzaS8VP/HjFSUDl9CmNhc2ckeMDzoc58NpPnZdnXfi8pok+4PMy8IdKKooYepSltslA88+tvHCOzeLm7CWctPQReDJb5b8oI95/9+oJgypSKso3EtzlWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vubmO6mYkwi2Us/xq6nY3qb3WsTaPG7UxbtKV0v3tko=;
 b=cuSJDkAiY77cNxyldlSQnR1MVgQWYRxxyjOiGymGqaGtutR5ZiRuly/W2KGz7kiGsUfDV/JMA+H5EEq/fc9IlfUfLOhXG+pZDIaqrqt2Pa1rIsyTYQiDsRwgYzKuz6/HWoiYlnMjMqiz+crhqhEm+wQ6OOhrz92mmWfbw1Mi3z66fLkCIDO4DND6B7oxbcjMws5BYLN0+WA0HA7UtKGKheDShBV3B5v2b6YlOz0iYO4B/JlOMxH6Tu5QWNk024Ze6RBVP3c3lcqe3vDiagwuD1rqN4HxvBscEeiYOSnsOqg4yemnm75blu4grbxmJHIPtSWIyBWq4w94ktDz0u9MiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vubmO6mYkwi2Us/xq6nY3qb3WsTaPG7UxbtKV0v3tko=;
 b=E9QmSGSOsaaPzeQu4Fu4QbqGruTy7dx6+JcP2Q3X5CPsE8cQX6spcHj2VT3rSFOfMrP4uRDhF5BwsMw/AvVJksZe1/6bwaDNU29utyHrlE/x3vAIO0MnFZszQcgikYWc7CAwBXI/A3cZzsM0ty5JCioXiUgXw+MTPPskLLA5KDIZugNLbLRn6a/Cmrai0rPxZel64F06XJ7HFPO0d4U6WvqA4kRh0WyUdQ125jTe+QRkbHEc/NXZtpLbxDTWGIh4Sg2gk6J39aT7G3uAhkMvBEu8/xw/MPnr/NxlHU/d/f3gidwdJRYkf/u2u476u09PV4+l6Uve2f4LYKPkv81KtA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by MN2PR12MB4318.namprd12.prod.outlook.com (2603:10b6:208:1d8::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.36; Tue, 21 May
 2024 16:04:44 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%4]) with mapi id 15.20.7587.035; Tue, 21 May 2024
 16:04:44 +0000
Date: Tue, 21 May 2024 13:04:42 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
	alex.williamson@redhat.com, kevin.tian@intel.com,
	iommu@lists.linux.dev, pbonzini@redhat.com, seanjc@google.com,
	dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
	corbet@lwn.net, joro@8bytes.org, will@kernel.org,
	robin.murphy@arm.com, baolu.lu@linux.intel.com, yi.l.liu@intel.com
Subject: Re: [PATCH 5/5] iommufd: Flush CPU caches on DMA pages in
 non-coherent domains
Message-ID: <20240521160442.GI20229@nvidia.com>
References: <20240509141332.GP4650@nvidia.com>
 <Zj3UuHQe4XgdDmDs@yzhao56-desk.sh.intel.com>
 <20240510132928.GS4650@nvidia.com>
 <ZkHEsfaGAXuOFMkq@yzhao56-desk.sh.intel.com>
 <ZkN/F3dGKfGSdf/6@nvidia.com>
 <ZkRe/HeAIgscsYZw@yzhao56-desk.sh.intel.com>
 <ZkUeWAjHuvIhLcFH@nvidia.com>
 <ZkVwS8n7ARzKAbyW@yzhao56-desk.sh.intel.com>
 <20240517170418.GA20229@nvidia.com>
 <Zkq5ZL+saJbEkfBQ@yzhao56-desk.sh.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zkq5ZL+saJbEkfBQ@yzhao56-desk.sh.intel.com>
X-ClientProxiedBy: YT1PR01CA0150.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2f::29) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|MN2PR12MB4318:EE_
X-MS-Office365-Filtering-Correlation-Id: d07096b5-d507-4160-2379-08dc79afbab9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|7416005|376005|366007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Mu8jQJ3KEq0mCxypdO9sNWokcBkBCWms1ZmiMfS8wl4ETQSWhVL8yU3xn64T?=
 =?us-ascii?Q?7feXnxm93Wc6f+hfZjwHhXGx3lmdJx8lIS09wXjVita69P5c4RH5qhxFnJAR?=
 =?us-ascii?Q?Prhhxaoaj9puWcOlLfI8U4l/wZH6VK4iCAJ4oXixT1BggOOM4PGPkf9dV9nx?=
 =?us-ascii?Q?5qYMhjpiYU0hJ635MCtwtFRUY9vzycrcF0p92xiRUqlLtwLVuI5X5OAR+nYi?=
 =?us-ascii?Q?aeAbQ6YVC28kEvzEj6qXpdDMVZJ0fSeBiiP9YHvAz9DLKuLyzzLqsWsSJKWL?=
 =?us-ascii?Q?OCd0MwE9YMt365IJ3F1pGef0Tj5ixB6oPlBd7DueKpDqq+2CI9Hr3VmWdves?=
 =?us-ascii?Q?PTx1BtsZe+NmRDrspn8znGYXzhTOiuFy6kC1fsXyLedzX978p9LSnYtBZ2JT?=
 =?us-ascii?Q?escvyOwutLOgHFGvfI7/w1mrdEhheM9hO1dsnEzU/vX91XWAigAUInqpDWb+?=
 =?us-ascii?Q?mykppe/ceOTUv2vWoIxm+SDkBDuvWk+5NlivZj+MddlMfgwPNf+Wh+m8RzeR?=
 =?us-ascii?Q?baFA7l+G7F/noW88CGwbfJ/qXhT2nxklddmEaMfgCApyrqrTIoFjgJ4B3k2I?=
 =?us-ascii?Q?hXLhuoRL1+sFD2E7dIccXnrvqHDXztMdxdKLpCmVtK0dHqWU/FvHtUjk+AXC?=
 =?us-ascii?Q?SVnJrW3NMIffsUZ0MaOBURXHPBTpKHLFREvXFc3PFxsKH8N4wNHXGwap1B6f?=
 =?us-ascii?Q?TmN83qBc2QwUG6uHi46lwbzqI1GsSqIK9yIac+4VGduf54ojZxJGrq3hpytb?=
 =?us-ascii?Q?Lhiwjmxrg6aI+R3KA9tA4z6AqIqY4TkeS97RWMbmyNoy4WWt5MeZxtOuodEr?=
 =?us-ascii?Q?C4gG751JPJ9kHslzxefIbmUmQoyGnei37ypmDB7kBc+wchUqDu1pGbxHhGQd?=
 =?us-ascii?Q?PyKk5ZyKmhU289j+EMwtF90RygbmiQBjh0W/ThC+7kYsIXtzGZhr6wUIbS+7?=
 =?us-ascii?Q?KjRHeQ44XSAoL0XE0XZZeM2GmHY059EvNxTvJ6dDXBpRMj6JaxsTLVviDR5d?=
 =?us-ascii?Q?ocKxO7sDOffadb2a5Vm5EE0Zaue47Z3F1eSIVzNPK9u4RytGmNyxL+GFNNo9?=
 =?us-ascii?Q?NAekiHdwzHA1QjDP7txz7aMDLYcnEVUEwjj7NjTFhHnBzPDctqFxXcXlShJM?=
 =?us-ascii?Q?vpgIn6V5lZfJjgz0dtE+1dYTYLcwgOZ0PREzbN18f/Lf8sMgVx1sxtrg0JG1?=
 =?us-ascii?Q?QaJJ7ld0wWeEWyjwU0jGXwgUMg6ljjTu/ZOeuycf0ncEIqEFIEBXVHWoyNtM?=
 =?us-ascii?Q?r8A0AuSTWKmE4dR+oHB4i/YDzQW/PQO/tfYX6tprhg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(7416005)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?FSVU0tgJcdaLB5lAnf7nfMZcY1nWun2GsxB4l1PpP7V+llmKyUzUx72UGc3P?=
 =?us-ascii?Q?8MRp9kiErATXJQfRxucnNSeO4v623gpZ4CGvxbCU75xSQn7NdAGWJb+6/a8y?=
 =?us-ascii?Q?5nuTxQbLczBeAF7TR72CZLqqRnyV0vuIgEV5He1z1J9IWzG8uD0+7RcTNrlS?=
 =?us-ascii?Q?7pL6BIPFDbi8f7ti9u5kcG0fnQ2ELxtA5JwsmqSH/cVAgtkhYFv5kXwBtisT?=
 =?us-ascii?Q?kJFJSz1R5XcQd4rlEZhPTHqqv7xoJkazfYYDX9HktrQ3e7C5E9JgW8gJCT0V?=
 =?us-ascii?Q?d1jUHu/P8WEy4LQGKaqs5O6O1lwoyckuNnAD5fsH+aBWnTcsUfGmbPVoOl7G?=
 =?us-ascii?Q?4NCU6/Tj5mvfisRktH/AAdZAA0mg+5mQ43kI04eU20x2UCbOlKX5Vuumqx3R?=
 =?us-ascii?Q?YmKT3s1spN+CGbOZPMLwK0HJ3Cb0TMTtsan7kj5yyERVM45xsI5CNIku996k?=
 =?us-ascii?Q?PaSsa+UvWQwLKBB5WgMJJoxUy3Loxlm3W1v+6J/rouZ4w3oWhFjWCqbeU75O?=
 =?us-ascii?Q?zOu6qR0CwqCDDalBei/w81U1aQmHn87ny87+SOY31LRsGI3njfh4psv6OD03?=
 =?us-ascii?Q?H1BNkeOCnupId7OEWPe4E1QExLqAAJ/rJP/UX7RxjTsjJZCAa0JjBmo0JMZ7?=
 =?us-ascii?Q?M33eJNxd+M5LtXyL0/94hT3vgQyP9G9GOvBolvKaE4acIY2+2deMXVEySKbd?=
 =?us-ascii?Q?rVxoEa2AiI9YkNWtVqMN38W2LeyBfhl94T4I6wp9Jtwj83D5xrfN9NQWvG++?=
 =?us-ascii?Q?FRrPyQ9MT2mJ4H5d135NQM+3VDv32RlARQuSHLBRZ+FeXQorgdu+8rWak6I9?=
 =?us-ascii?Q?Jfqt648fzkwuYoknjknwj8XOQu7hzkibdAt7WERWhQPx7YnZY8L8chjzI3Oy?=
 =?us-ascii?Q?+WX3ba0RuVFrv+BU2RVg6fsMjB7nb62lIAiOUiK5SJ8NEXU7CE2pf/QuFRoh?=
 =?us-ascii?Q?ak6zrLPJu6P0CRLrJHxA/ZtF3/63ihVLzFLVd8hHUyOHO0H8mwiN7l4cXf/n?=
 =?us-ascii?Q?AEzwYBmKZzHHY5dklTutQNMXzM9OUei7C5yIFUBrQpypKwohL0G01UfD5Xx9?=
 =?us-ascii?Q?9+QL4u85V4nuMtmiXlM1SlW9MIk7Q3aQh+iCjRtROWblfoxnKxB1nf6BBXHR?=
 =?us-ascii?Q?fs+O2tiznvQQdOeQeg1DmTawHT2LqjEpjTQvACK5/ybdMaytBcR4NQdb9cSt?=
 =?us-ascii?Q?Gld8Ma+EcCYEjHFh9sUDz1qh5FQMMl85R750D8a7AC2ErZVamGEILDyCIaFh?=
 =?us-ascii?Q?VjgLw1f42P8QZQl1/11dNdlFoiN0RhEcwXP334i1e7Ol4BwwjHzwayvC5yKa?=
 =?us-ascii?Q?SowburwEcNJip5q9HH6ciwo26kmYsAHXXv8GzXXIG42l5c90CT9HcAqAfayq?=
 =?us-ascii?Q?oXnGL1ZbfBuYXyzQOuqrU5dZAG84hE6sdGZhC3lV7T+8g+YhzIiJzkMv5tvA?=
 =?us-ascii?Q?uMJ4NT88o3pghSyfzXZOLp3FD8XdufznimWjSiPSExPZBgI8ZBCzOBU01DZT?=
 =?us-ascii?Q?plf3QYQSwmY0PhsDEpTRJ+UJm6u8IzzWc4WO5eDS9SjJvdXxnEgH/PEUFnCw?=
 =?us-ascii?Q?OiajU32Sqj6MZKRDsXr7HasnCxB7D2KJoCQkm0wV?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d07096b5-d507-4160-2379-08dc79afbab9
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2024 16:04:43.9727
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DwMQrypeYdldiybK4J0tYLMqZVTVtGWm8b+Q4fsIMeaw9of8aCfgvcUqvHol73wG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4318

On Mon, May 20, 2024 at 10:45:56AM +0800, Yan Zhao wrote:
> On Fri, May 17, 2024 at 02:04:18PM -0300, Jason Gunthorpe wrote:
> > On Thu, May 16, 2024 at 10:32:43AM +0800, Yan Zhao wrote:
> > > On Wed, May 15, 2024 at 05:43:04PM -0300, Jason Gunthorpe wrote:
> > > > On Wed, May 15, 2024 at 03:06:36PM +0800, Yan Zhao wrote:
> > > > 
> > > > > > So it has to be calculated on closer to a page by page basis (really a
> > > > > > span by span basis) if flushing of that span is needed based on where
> > > > > > the pages came from. Only pages that came from a hwpt that is
> > > > > > non-coherent can skip the flushing.
> > > > > Is area by area basis also good?
> > > > > Isn't an area either not mapped to any domain or mapped into all domains?
> > > > 
> > > > Yes, this is what the span iterator turns into in the background, it
> > > > goes area by area to cover things.
> > > > 
> > > > > But, yes, considering the limited number of non-coherent domains, it appears
> > > > > more robust and clean to always flush for non-coherent domain in
> > > > > iopt_area_fill_domain().
> > > > > It eliminates the need to decide whether to retain the area flag during a split.
> > > > 
> > > > And flush for pin user pages, so you basically always flush because
> > > > you can't tell where the pages came from.
> > > As a summary, do you think it's good to flush in below way?
> > > 
> > > 1. in iopt_area_fill_domains(), flush before mapping a page into domains when
> > >    iopt->noncoherent_domain_cnt > 0, no matter where the page is from.
> > >    Record cache_flush_required in pages for unpin.
> > > 2. in iopt_area_fill_domain(), pass in hwpt to check domain non-coherency.
> > >    flush before mapping a page into a non-coherent domain, no matter where the
> > >    page is from.
> > >    Record cache_flush_required in pages for unpin.
> > > 3. in batch_unpin(), flush if pages->cache_flush_required before
> > >    unpin_user_pages.
> > 
> > It does not quite sound right, there should be no tracking in the
> > pages of this stuff.
> What's the downside of having tracking in the pages?

Well, a counter doesn't make sense. You could have a single sticky bit
that indicates that all PFNs are coherency dirty and overflush them on
every map and unmap operation.

This is certainly the simplest option, but gives the maximal flushes.

If you want to minimize flushes then you can't store flush
minimization information in the pages because it isn't global to the
pages and will not be accurate enough.

> > If pfn_reader_fill_span() does batch_from_domain() and
> > the source domain's storage_domain is non-coherent then you can skip
> > the flush. This is not pedantically perfect in skipping all flushes, but
> > in practice it is probably good enough.

> We don't know whether the source storage_domain is non-coherent since
> area->storage_domain is of "struct iommu_domain".
 
> Do you want to add a flag in "area", e.g. area->storage_domain_is_noncoherent,
> and set this flag along side setting storage_domain?

Sure, that could work.

> > __iopt_area_unfill_domain() (and children) must flush after
> > iopt_area_unmap_domain_range() if the area's domain is
> > non-coherent. This is also not perfect, but probably good enough.
> Do you mean flush after each iopt_area_unmap_domain_range() if the domain is
> non-coherent?
> The problem is that iopt_area_unmap_domain_range() knows only IOVA, the
> IOVA->PFN relationship is not available without iommu_iova_to_phys() and
> iommu_domain contains no coherency info.

Yes, you'd have to read back the PFNs on this path which it doesn't do
right now.. Given this pain it would be simpler to have one bit in the
pages that marks it permanently non-coherent and all pfns will be
flushed before put_page is called.

The trouble with a counter is that the count going to zero doesn't
really mean we flushed the PFN if it is being held someplace else.

Jason

