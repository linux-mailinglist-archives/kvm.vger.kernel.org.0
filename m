Return-Path: <kvm+bounces-49981-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id ADC10AE0826
	for <lists+kvm@lfdr.de>; Thu, 19 Jun 2025 16:00:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7C0971BC40EA
	for <lists+kvm@lfdr.de>; Thu, 19 Jun 2025 13:59:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEEC328B4EE;
	Thu, 19 Jun 2025 13:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="KinEoqBl"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2088.outbound.protection.outlook.com [40.107.95.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92F62231856;
	Thu, 19 Jun 2025 13:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750341539; cv=fail; b=ogQGPnxZc9jG5+7VXgvPmQjZMydt3aol8xUkeOH/fUtK8XwF37sm1HZGITS1bXoFyfccMKTaBxEmNdCN+rleiZzAw1kohtTv4rLWu3IfAe2xFoqQuho1AgapYnwCYCvrNuK0rPcPLJrqUeU1w30B37vDjdOPD7lI1j9Ll9elIhI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750341539; c=relaxed/simple;
	bh=Isxsdc3OSJZ+/kiZzdYg4S+fbXtsMI+z7+vDrToE17g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=gjNnk4nUlb2bhpG2kUB5aXHL2IGGZIAbwUKi2IFAqeDhQUx01M2IS0+wGAOUBF54GxdTeMbfhFm288ot6Ffey6RzIDzMPkBGoGpOQycJNVfNEBRYlDiopts7PmEi7Zo0FG7HYaBFnEwYwWU9saZFarjv9hHr5m/dw8Oa4YqIHZY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=KinEoqBl; arc=fail smtp.client-ip=40.107.95.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bVYd7RSvgyMh+QjVxN9COweWLO7YKUQ2UE57n3HVIaeVeIre1SN9C04oMeqZQ2PeThuWn3vBFtsJAv8/dA981tLpCCcT/bJV9CVyZ9l1URhRXIiCICsW3R8PnEFHrEdG/NwizJi3R9ftmgcJqWlInYLmmHVHBu3bJZMfVUIZFtP4BujG7T2F5JMZeucCPFFO9W0xNd1nQg6HWCMd9/2xxETgvUs6H5QKRF71Sa72lSR8kRZFy9yX8G8cpnIwGN+fZ+Wiei2Gqi0hLKUxJ4D/qEbFjlGEFOQxbCnTOoyxlp7rXW+IMdD7NZrUYSXoy+xeLBpic0yIsJkbt6GWctWOlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RHTr//N17sEqjwh9QwpuPyH0GN5WI3tvqk0sCbFLhOc=;
 b=t3TMbN4eqrGZabsHJ7yFzi0PmKTLPrPZ/R1ihqDiexp1RGy1ZpqwIHXeJ6yYfWQRKWJ9CZg5IAJrsv/6VBeRcEWz75Rwa8Kt7DgN4HO9Oi9YIV7VnNfgmau9SM4DlRggZOrZ8VXdKA0vsTLGVbpthYnt3MLBpJ4RSqiLqIIdehoSod3yIPP01dgSztejvBBUfUNsDCSjBP74SptGaeQx5PolQJvsk9l3pe1HVoR/AIN0MNt3x8FWbuxX5dSHKlOgAjzWISB1K5OL0O8QjrfPBRAtkZEhNGELCdUtq7hS2m+JnBPphJ2ZbjuO6OKTkX5o8v+5bzX+Pi6a4LxeWJzhjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RHTr//N17sEqjwh9QwpuPyH0GN5WI3tvqk0sCbFLhOc=;
 b=KinEoqBlQbYOUFxk7qHk/2M/a5Owu9UGZL+Qff1Po70ZJUnqIX2G/Lh0RYW0ADJPvzafGc8+Gcji+7hNofmqUEKtzvV5fHlXPs0UYGkkE4RF9IMJYKoj8697SFqjacUw51MtQK8pvVEQUnvEfyTDzJ/U6SpKIxp/QUR/ZJcIqwEthq7BfPMT1tFD8Eq7XtJg+sWqUhS+dYmj6ycj2hbA/c1LvGUGx9NvG28ZjtOHzyu7D9aeo6jy8cW4HZpM7bMViS2bEmSuAfYm8PqzrgJ1M4E/WnTJifAaAy49DAUAYqdNzL/s1wqhNnPY5ZGtKev4rscZG9vjaVD8Qhjo8vXeWA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DM6PR12MB4339.namprd12.prod.outlook.com (2603:10b6:5:2af::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.19; Thu, 19 Jun
 2025 13:58:54 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8835.027; Thu, 19 Jun 2025
 13:58:54 +0000
Date: Thu, 19 Jun 2025 10:58:52 -0300
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
Message-ID: <20250619135852.GC1643312@nvidia.com>
References: <aEx4x_tvXzgrIanl@x1.local>
 <20250613231657.GO1174925@nvidia.com>
 <aFCVX6ubmyCxyrNF@x1.local>
 <20250616230011.GS1174925@nvidia.com>
 <aFHWbX_LTjcRveVm@x1.local>
 <20250617231807.GD1575786@nvidia.com>
 <aFH76GjnWfeHI5fA@x1.local>
 <aFLvodROFN9QwvPp@x1.local>
 <20250618174641.GB1629589@nvidia.com>
 <aFMQZru7l2aKVsZm@x1.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aFMQZru7l2aKVsZm@x1.local>
X-ClientProxiedBy: YT4P288CA0040.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:d3::21) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DM6PR12MB4339:EE_
X-MS-Office365-Filtering-Correlation-Id: 88217fa9-95c3-481f-cc5d-08ddaf396d7e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ERNAlyMLYb4dbweEKEcXciURB+zpKpVOHWuRGqmryT9meCtCdyvPZfpcku3A?=
 =?us-ascii?Q?Wz9Q82K8hDS/u1bnfGNbcKs0SGzIwUbK54DkDrMA2jyqEsD1YUvw+4Mh34XI?=
 =?us-ascii?Q?jFqY154dCjpMuSwoUKBWN+v9t8tJ+X3WjDx6rUCqk1p7PLa9vXUeUlTVDypb?=
 =?us-ascii?Q?V5/cA7ZCHbiqbTc6VBjEfWQoIRd2vqclQYpZqNb/5ysESGbTGH8qLtIHsqV7?=
 =?us-ascii?Q?FyOGfhapoh2qdPlylDto0VE3y7jsSL07Nm5IlGGOT1dbnYX1J4VbyZClr3kE?=
 =?us-ascii?Q?HXzXBd+LvJfJq3qK2pE+6f3o8YZp9WqbGgthoiaoXCRRDiCSEfDLjlUksIoS?=
 =?us-ascii?Q?fFB2L/jHwG7OBkMEQeypo8q1ZEaBW+nQEdbaQ7g00JV6yN0ZZw76zi1GqY2D?=
 =?us-ascii?Q?fBYPcnjc22B6WNmLiAgV+KaZaLGiPoA4ptiPDk9JUVMJ3jxr+MbPiYDvAFJ6?=
 =?us-ascii?Q?AtKspj1mEP43fJiJJQDCFOvMSMlEedgBOkw7/p7bXXoAKvzY9NOEXaHHkKpe?=
 =?us-ascii?Q?e5NQlQkmhuysaWQE2oF+LVdwrmC8eY0l4d5S5/6IVyq0v4qq68wx2M5Qu5At?=
 =?us-ascii?Q?DBWhJq2Ai6y+EprUs/0GgAf83Oc82fmAJWtIb30nDzlkZpKuw+o8pFq4v2MH?=
 =?us-ascii?Q?rI9F28BTLXVo6abAmtHcQkAAESkbEOdleDiT82vHeuHs+lpllIR86OCoQ1UY?=
 =?us-ascii?Q?g3BensTjdIb+1W/7NJCJPSbJ3kj7r64MvZ0XotH9yq6xBu9Ubc1f6kAmwami?=
 =?us-ascii?Q?DbiteN3gT2i2HGB0HJgGVDMc8x4ESmBw4lGtZ8H3e9XJdbp3cb2DPgxjbBOI?=
 =?us-ascii?Q?L9gr/w4JFbbKSn02Oh69M/ffdtsh/E2O2mlKo/wCCEyfWAVPMXccui41nDNY?=
 =?us-ascii?Q?60Ne5DVWmM2CCIEO7jDPzSkyHkSJI7Vn229A2nqk7xf/wC7ukPsUT2w10NHS?=
 =?us-ascii?Q?yLFcWI2SnA70ENMace3L0A4oQkPBkUkVDzypnxyEP5LFI+ac8dAfJmKPnU7t?=
 =?us-ascii?Q?KoAdqaZuma647VOu3SxaW1uwRreLOBkV1sxCNx5QG0hgmIOcKqnn34PgL177?=
 =?us-ascii?Q?akyQNeUcGD7nS8c8S2xuBc0NfsGPUnl5O6tbaYJyuA4eid+OfFm3aBI9b5aL?=
 =?us-ascii?Q?SKPmKyDWeZxM92dLJU38eE3vkXr19SeIOGLJMuCHBerudGP0+Y78kBWBwVuy?=
 =?us-ascii?Q?lzT54FGjD2uNP4HJD5XjMex/Nk8Bk5DkGaDDAOGRyetQa7cpuAAWdoFO8nCy?=
 =?us-ascii?Q?83lEe0xJMyCgvfdG7zAoHm6aMtvmffO7Lub1M1bJWgJTxRZE+pSESkB5u6u5?=
 =?us-ascii?Q?QpF9WNzHFq67k6qva0R3NdeZTC1eIXsovE0pj/8vP4slIw6r2huLV4dCvKda?=
 =?us-ascii?Q?SaFUzkAP5rfwwsAfn3GSVpkpAA6iLdey9jFfn7EegWWQOCyoaPj1Qcq9iEgA?=
 =?us-ascii?Q?rSHArsQhj/4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?XpZ9u4C6W2vHwTPT6+mE8Iyq5+WCkYMy7pO1z+RQftWagFue9aNG1UTK/EP3?=
 =?us-ascii?Q?Q7PQml5Ou2z36EDahoiVktwlbCW8u4M/DK5Y31RMkO4h+HaFNr+9X1qQWzI6?=
 =?us-ascii?Q?CLAKNewoHrb/TwmW2vlsqi0aY5yuNIxZnqcg7KDxDhXsTqHn8QstcDRmrOay?=
 =?us-ascii?Q?X7L1lui1HR7S5Xgd7zcTnm1JBeVbHnw3AtpZoJBqBLgYocVewZ+meEGh6Rcp?=
 =?us-ascii?Q?2cPOd4Y00PwyF4MApq+ATyzaBt7WfGelGnYyB0W150h8asY61ZKy5dOI432t?=
 =?us-ascii?Q?pDO9HP3+XYwF0Er7HdtwB7P8ZvrlAx9niPeiVqNV9v6t9NOnF8KGtzjrrQmY?=
 =?us-ascii?Q?O6VyMHAtiCNn49fMkVOlXkJ+Qj1E3sBMLhqh/fBxube+sVTF3Dx0FUjRbDrl?=
 =?us-ascii?Q?BALm8ApRNQznh9lzKFDnU5ntjMmHS0hquig1Qg/ws8IaBpLiAgusRffteI+A?=
 =?us-ascii?Q?8BS3iT8xItBt157TuRra3KVPHxAJTaXRkD+P8TeovggKTBOhADHcEJueDnl2?=
 =?us-ascii?Q?fdPvj5XFq+AI2c09UY8OSD/0N9aG/6PhMfr1vAkX5COzJrAwbzRkGgsf4Eq9?=
 =?us-ascii?Q?YxUsvMUuUcSwYq0p6vZvhCu556IEa7v43aF1TieDsJVdTPjDK5PgBk+uQ8R3?=
 =?us-ascii?Q?39jYsxmUu9Gr5xoaLoZUmUabIRy4Wk1ak4/wvLB4GhAJ4TDNmsoEEaBFz6xJ?=
 =?us-ascii?Q?MbNG1uUQm5+ioTdHKn+xZ/YWq2ChKgotnM+IfnctLePdQQiblQcL5kRU5slJ?=
 =?us-ascii?Q?A4VWMjRt7n6sJDvDFkpzm1qwm1vxklVb+yJCPd/JV+q5XF51hYSdX/2qS7WL?=
 =?us-ascii?Q?14y5Zpm+PaeBYYuaVrf8nJa5JJxCbAlUIBHXnXCD72z1DPtWAuhidAFE9KDA?=
 =?us-ascii?Q?2tbnHw2t9B03XnEy82tA0TDwxX6eFcihrfE8HgiHctY/f4p0OK4xno4AWSsl?=
 =?us-ascii?Q?0J94AkJ/6g+ExWdi5mgcWhrgkQCrZ5GMKkZAP0DuupEuka9ULDLkPBT9hglW?=
 =?us-ascii?Q?0XOTIHCq/etRbMXQDvnDxU2PuT5oasKNpk0U2VvZdWSaNvZYRslcknDAEWnH?=
 =?us-ascii?Q?YU6xKUnxnTry9OyPHHRSZd3CpQwlnGtvByu0de8w0Y69gChPaPzmNlDyL3zG?=
 =?us-ascii?Q?DXPt0vsOpxv+j/DZqJhMvqgmWy+9Xe/Gv9r4tGiy78CKdk/YIYRvXNn2WBZZ?=
 =?us-ascii?Q?mAHQn/av092AULNuYvhXPQP9fwpfdKwmSrG8V7k2K7+4p06NqckMujF6ft68?=
 =?us-ascii?Q?wbTu3aU65JoSR8THBHpQ5TQwMnwE8Tx5jXLdUWo8m0iIUBE/K7G2q3YNYsZ9?=
 =?us-ascii?Q?90fnq8ZuZSVxNkVEnunw7oyTVRuVK15fTdnw88RNgC0QkyvsXi2wF2QLckwF?=
 =?us-ascii?Q?SbZWVFzpW9FNyEs+bjU4VA/tVTFXjXswFyZCZW1Y98VPZGwrCrMj28NWEEFJ?=
 =?us-ascii?Q?s+GSLUo3y38XxOtSixUAMdXF0T8CT61XAxVhlowOCgWbGS9yyvU9wd0LRxKy?=
 =?us-ascii?Q?O8iUBMQVaQJNtI2O/5vLJEMYoHNBud+bP0p82ktCpAlFk9YbGCchUk8hhGsQ?=
 =?us-ascii?Q?Cvra5iXZbfsyZCHLA+rcL7AbhD89cWslqsOZcO8X?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88217fa9-95c3-481f-cc5d-08ddaf396d7e
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2025 13:58:54.5529
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g1fWyLRlP3GKRkHNredpMGSR/S0nHcUiVCzohvdEM1jeaHpbjoEI20178YQmK3aW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4339

On Wed, Jun 18, 2025 at 03:15:50PM -0400, Peter Xu wrote:
> > > So I changed my mind, slightly.  I can still have the "order" parameter to
> > > make the API cleaner (even if it'll be a pure overhead.. because all
> > > existing caller will pass in PUD_SIZE as of now), 
> > 
> > That doesn't seem right, the callers should report the real value not
> > artifically cap it.. Like ARM does have page sizes greater than PUD
> > that might be interesting to enable someday for PFN users.
> 
> It needs to pass in PUD_SIZE to match what vfio-pci currently supports in
> its huge_fault().

Hm, OK that does make sense. I would add a small comment though as it
is not so intuitive and may not apply to something using ioremap..

> So this will introduce a new file operation that will only be used so far
> in VFIO, playing similar role until we start to convert many
> get_unmapped_area() to this one.

Yes, if someone wants to do a project here you can markup
memfds/shmem/hugetlbfs/etc/etc to define their internal folio orders
and hopefully ultimately remove some of that alignment logic from the
arch code.

Jason

