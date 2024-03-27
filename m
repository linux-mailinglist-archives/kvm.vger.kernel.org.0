Return-Path: <kvm+bounces-12855-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CB1FB88E618
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 15:32:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0439C1C2CE32
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 14:32:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D68D12F588;
	Wed, 27 Mar 2024 13:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Qfvi43K0"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2067.outbound.protection.outlook.com [40.107.220.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B740212A150
	for <kvm@vger.kernel.org>; Wed, 27 Mar 2024 13:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711544564; cv=fail; b=BzqJKOYXPpYamvXJOfJbiye9YEIvTl8zLwrp623vjqDVIygevsMqeOCfSEeT9SvYUMb/pCImANzjkk577GuYVvNh+4zcxO0KUTSc+zx8s9YFkIRArCIn14MRj/VrH6Cp1k6aew/JUgKD3D4z1oBA3ADGvsTE+QBc9R4Ixgh8NbQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711544564; c=relaxed/simple;
	bh=vRXUGQohjdvitdk+0/Avh/IX5wH/OgaG1CqYFIVla8Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=qBzYK24J4ytXnLSsUsrbxr5jUTnsCf/DpCVdfwhfeS+Imz/REqSPPq/7mtSgASWSIUEtOfvDXd3470zHq1o3Q6sPRImMAEu+I9+0mGbtHuSzXACwLCcomDX2Mv2mKgtp5wd9Ww98r6p94R+V41whfaZLBd+COI0385jrmCWSnh8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Qfvi43K0; arc=fail smtp.client-ip=40.107.220.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VATnZvuj0hPP1sHCu23h/iuVLA6k32W1pjrEbB7HCwUMDdevQZ6fbqIFIcYryzB+zQwdm1RWMWv+kBwP2rb2AqBitFIz2A9REU/pnOjrTuY5DbA/ehFiIR3aKO/uB2EBHMRdZcHuLajZ8/9K5e3HaIdDxDOtCOJtT97sPkzO+J4eoTSip+c4WzEYuZkmaVo2epVuG39bZSaI2+4nbUCczvxBOZMY0fL/vLfkUWsQ6Y38ZBRNX1iEvPRUL7Q8CWPCkdJdSqS/Rzm2kWi7j5RMt2+KmD6f9Qb6JdbI8Y3u770BIFT4qClyEFxzpf6GmK0DO+Uhpdw5ozStKArasNZnpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E6Vw4cLrpiF42VH9UXwFSf4a34cdtiKsQmbpjt8Sek4=;
 b=YhbZFRjIB4y7CXvJuKq6GfDp8+bwBjig+7USvtNO+UsAMpSZC+7w7zpaWuH4xAflnyp/zc7KSZrhGi9ryfPveYrpw/Rj/65jhykii/2c/bPH3YOVUhkxb1goJQ5mdfTxZ22k9Uh4n2RFhsyMUdQPCMz5mA8DayM6PxbbERw5jaAz4P2NwRMgyjWCXGNwrKn5crAreimujEkGUvIc/miZHwRicDHSdMgHgJykOj8Oi+x+OMxC8irTeqoLbB+/1LuZYCQ1YKFN7xAAY7rjnKeN9LmsfMq2BTIisHmb/gv5uQKTWH/2ZmtYdjoASY38sHifl3DYyinq09JjwqcNvtnRFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E6Vw4cLrpiF42VH9UXwFSf4a34cdtiKsQmbpjt8Sek4=;
 b=Qfvi43K0a4sFnOJ9VfRx728W2l8xByy2nJXhxAQe9qyKNyYTuvlAzN1qUX4twJfWTkTnp76VIfJDlb0cAk4iiFfjc3pGfqEAWWnMUD5e0fVo9lOHl5Z9Z8jT2hXA9AGFUX1aGeyks6dRMufI8EVNVHuFvCQnqtiYOEyak3jxdEvM8tc2/V2WbVYQCOuLFLFijIuRdEZz0eYkYbx10V1SgBS6I5q7t4uzKznal5ksxg57ttqQhm32EKTocvZKBEsxAlVES/5y4FRkeNbX2nxuGxA02HAjs7jwZFblaoiXqVuPKG/xkCkZZga2J/N+z0nAkFl1x3NfFguI9xbakgcSMw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by MN2PR12MB4079.namprd12.prod.outlook.com (2603:10b6:208:1d5::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.33; Wed, 27 Mar
 2024 13:02:36 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7409.031; Wed, 27 Mar 2024
 13:02:36 +0000
Date: Wed, 27 Mar 2024 10:02:34 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Yi Liu <yi.l.liu@intel.com>
Cc: joro@8bytes.org, kevin.tian@intel.com, baolu.lu@linux.intel.com,
	alex.williamson@redhat.com, robin.murphy@arm.com,
	eric.auger@redhat.com, nicolinc@nvidia.com, kvm@vger.kernel.org,
	chao.p.peng@linux.intel.com, iommu@lists.linux.dev,
	zhenzhong.duan@intel.com, jacob.jun.pan@intel.com
Subject: Re: [PATCH 1/2] iommu: Pass domain to remove_dev_pasid() op
Message-ID: <20240327130234.GE946323@nvidia.com>
References: <20240327125433.248946-1-yi.l.liu@intel.com>
 <20240327125433.248946-2-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240327125433.248946-2-yi.l.liu@intel.com>
X-ClientProxiedBy: MN2PR01CA0050.prod.exchangelabs.com (2603:10b6:208:23f::19)
 To DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|MN2PR12MB4079:EE_
X-MS-Office365-Filtering-Correlation-Id: 6a7b0d36-86a6-4551-69ed-08dc4e5e2cb0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	esqkOsUwE7wDbsX4gEomg0j+gUVYBegGC33Mbd3h1Id3FVuaMxult2C7CQhjdxhLLriKBVewlIpolHdbwfB6iNwoLrKgbMrd9WBJm9TVnjA6knCQO91c7vPajY7C5PkZ0V2fCNQdZXnNNiCrSvskv7g+lLZSls8BwEsXPrMaq0ESoHukgH6tY7SUvI1IQO2pyfjVFuJ6hb/Vu31hrIds086GjA3HgGsajl5lh+1+Fgzwr09rGo1wddUH2LF/t/JztQa7e8jzwByKTzVPux3v/Nrd1cxhu+O1o80vJKE6oCPMUe2hTToUmYwVmrDpwNVdxSlfvFPQt9lGuESb9/q8I/B79AZOyBjo6XE7zqiptqaLv452923CFl0bweHuLQDen4rWJavqxy4ldJW9H/QuYE5eXevXppw2JjkVpHJF9LZ/OUDVHxHZkeT2HSvRLVTvXKymlLKjBqJp5aOeBxv1rlOnwxw7EG1GtZNAFWvXCciQQMK0hzL9XoWqoqjuIP5XsUUkFVOECgfM+WtziKMnxzbxUBZakEex9LzvUxiFczkQq6j1cpt0Tj8F+ZIYXHFIdwlzg6F4BBIwpHPIB/HGepny/IX/qZ7syctIYCjfSXKyCiIQiVmDEUKK/m/2/DmzpuOUezwWWn96Dx+z0u+FTNxOeqBfyiJ3r0VmlzsmwkQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?qL+iU2Q4VYXhXFJzHhVQhr/vDVbuDF+t5/PwmpFnnVD8IxpkwH2cOwGxoYtq?=
 =?us-ascii?Q?c/Y0oHl/B3r5BPIVa0iytYkWQPczLu2atiy4iPTUm39tpwbQXm8U5+6R6Lsp?=
 =?us-ascii?Q?Tkwx3v+7NNB5D5qf6f3YiX2hjANbQMgOpwLoXO/gJFv6sq6KUwMKcOEBniDh?=
 =?us-ascii?Q?vobK4DfMKerrkQU6xkSI6lIVB5kZR3vqRlpD5lIueBtDyV5AAIKP4UlNTtxL?=
 =?us-ascii?Q?8ZSDH0Nfd1OGQx33yE1BYY2xGjlLpH8ar/zEZOPLdjNwFj9nb8YKefl6EYJh?=
 =?us-ascii?Q?R7lpN9bjTSFTlMpXf4do8tWTynRTcUbMVHflzJlLgVUWaw21u+E2hU9KS1o0?=
 =?us-ascii?Q?hicmGHARGrpwys4PHTbJYxnYOrgPSkKyyEwL+QyGggrmmFd+it74EamnJB1x?=
 =?us-ascii?Q?8T04KDJPy/EeFZ75Vz0GMcc2UAgfZ/a4r9BEZcDRJaXPtj3Bf+BFEUYmKthj?=
 =?us-ascii?Q?C7Ci8i/E+Ago0d0nAW3G4wEmAgn+dviOCESy0V0DBmqEOh+LYrwHnYBXZwjk?=
 =?us-ascii?Q?QLw8welcman5CN2tAwM0hiJln6ic19l/g6Jc8cVW5M8ASHbG6cr5bpXymuNO?=
 =?us-ascii?Q?5XEbSlRRDt56YXXNTUkZUa7CQVa/orSCiGLFds2vvsrwXAnwUMyTQVyK0il8?=
 =?us-ascii?Q?2etFR2bNbS8quzWamHnxn+C2Wz0Ko3Hz0CY6d+IJ1PuM/m55cpNiX4nYxYfV?=
 =?us-ascii?Q?MfQAcrPw51Hr4GO6BYU4kV2PFkg3LDG76qW/nowNxO99m06nSX/DaXBHiQUl?=
 =?us-ascii?Q?Gydzk9Zzpyfe0+4t9xsEnxloNlPZIJdduVr4Yn+zACzKNuH8jYrXRSyJctVo?=
 =?us-ascii?Q?kDPLYsjRj0XfpxyG4FfFyXeOxPdTl9sfS5kIBL17FdepnpdV+bPqUpA2nMT2?=
 =?us-ascii?Q?7VB4d8anvqYvpfx0VL5JDDPxCtBtxq1euX4aMNDcgJJnqo5dBWJdUettlTWq?=
 =?us-ascii?Q?ngUBaJ8dWUSc7ppOeAwU1Dp76t47U93g70hutfatf0ev55OG8d9wPu3BAvXh?=
 =?us-ascii?Q?Mb0Nzl4sDt/zLUiyDwE4LmjRZ60qvY8Vp4f+h4GEyA+//1IQot3g66WQnVah?=
 =?us-ascii?Q?PL+fL5s0UTx9Wf7ltb95xamctP4yeRVN9UgYK0iPPTKNCvMvg80thi26qhBJ?=
 =?us-ascii?Q?UyFZv4bp5+iMi5S/ctiLA8WFRxK27MgvJRvZVHQiO9m3dDschah1mEAhzZ64?=
 =?us-ascii?Q?99wzL7Zhsvrj3Se0nBnvseQia/njeipSjjO4j4fNjrX9f/hAFGA9ebrBL2MX?=
 =?us-ascii?Q?601mjaTqVy5JT3RikjDuisHTdcqUwwfxLQND5pCYXcuJHSehFShaJ/yiuKJc?=
 =?us-ascii?Q?FnXQjv0OEnEmRk0gqfeBgR/UkApzWvHMWnOvGshFxaugauCKqSOP1T7fS3YD?=
 =?us-ascii?Q?y8zOeaobikz50IGucypEkqy+4i5VgBRUBhMehPko0Zt5xeoi6Mdv1KPnEWc+?=
 =?us-ascii?Q?z/eGjE97LfO4v4TYB4jXTmfL7wR0pzhB8XCNIfEJ7F53zlJiB3wh2ZwMPfch?=
 =?us-ascii?Q?HaqF2i1Fxy1i89f5X0723mHlhe3a2YWz7eMkFUWP+cEMwM4z2wSFo43dO5re?=
 =?us-ascii?Q?6S+rZ/bSK5BqGlu6SRZ0GTvHLhcXNy2Qq0IxkxwD?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a7b0d36-86a6-4551-69ed-08dc4e5e2cb0
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2024 13:02:36.4746
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ttE5mNQb29DgK17KWDkOHPetrUvI7LHB2FZG2ESbSCm/tbvbFwMGMgzelHJDQ2VV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4079

On Wed, Mar 27, 2024 at 05:54:32AM -0700, Yi Liu wrote:
> Existing remove_dev_pasid() callbacks of the underlying iommu drivers get
> the attached domain from the group->pasid_array. However, the domains
> stored in group->pasid_array are not always correct. For example, the
> set_dev_pasid() path updates group->pasid_array first and then invoke
> remove_dev_pasid() callback when error happened. The remove_dev_pasid()
> callback would get the updated domain. This is not correct for the
> devices that are still attached with an old domain or just no attached
> domain.
> 
> To avoid the above problem, passing the attached domain to the
> remove_dev_pasid() callback is more reliable.

I've relaized we have the same issue with set_dev_pasid, there is no
way for the driver to get the old domain since the xarray was updated
before calling set_dev_pasid. This is unlike the RID path. Meaning
drivers can't implement PASID replace.

So we need another patch to pass the old domain into set_dev_pasid
too...

This looks fine

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason

