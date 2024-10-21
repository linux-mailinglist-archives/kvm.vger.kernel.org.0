Return-Path: <kvm+bounces-29284-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 67D509A6892
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 14:34:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 243DE284715
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 12:34:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FC541D1E88;
	Mon, 21 Oct 2024 12:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="dcVo4xeM"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2055.outbound.protection.outlook.com [40.107.244.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF8F11D1310
	for <kvm@vger.kernel.org>; Mon, 21 Oct 2024 12:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729514040; cv=fail; b=Jmd0cE4xylRhyJ+vUGZyOmn2ZTj8eRss/mVe80Xq2XWqAfSerqYy18vDZhMG+kXJZdOZU1sKX2V/r2HCAfdvHaCN5VWqk62yXEVaDc6ueM+jOvcUg4yz9id9eVecgSnE+t7457yg43GdPpyDXeXUuZ1E6u/g5wdboE3Er6gjNP4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729514040; c=relaxed/simple;
	bh=zG1V9gYxhjOeZ4NOMgrLiQYmf/lfV5Qf5+yDxwlDi2s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ulN0QohgPdqJpo8V6L9S3EILzj42njpxLs8vdivB/NudxMGmMHwmEVDzrvK7beZXPOp8nMqx2utbDWJr2M12U2tZF6cZ30mn8qeqoQChc8gp8Yaus8VG7CDx3bLIdhATLwWTZliviR6IwbJzY3maGJHxqMXQr3BZ0ydXmyGIMSA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=dcVo4xeM; arc=fail smtp.client-ip=40.107.244.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q6do9vcHDlpDvI3SWx0dNEQDbez8++I7oBiHXH5SRFpSGzD4hbYxuh3NeIgkOXBMGn+DduD0kuJ+EQUxL+SRLnGdafiOndqdR/8DGKgE4CmwMGF9AsR2pqgwjIoHGgXKt1sQ99pjjTPICo+3YItOSzfDR3Jq3mfTOwwbrLkNGKRj5mW/kNrSDCQ53+5s+u4su4OxRySHsG8DabTeDNQ43A8r4AstMMSkRyyAPlxRQyKqc9rLY83QXBvRQ42ZbhRs/MtXc54k6qD3FQXw0KsTzpoCIn8v/X6bROpOs3yJ1ef/FEHhkMCLFRznyEs43wN+sm3r16KagGixjECBeHshmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V2qXKgHWEMqjRXBAjx7qtZvvZwEvpy61SYK8jk+3kmw=;
 b=sghFdx9WbTX/Kcv7F3AVPCY9AGpJVEeL39auDb0SD1NVnQemsWQD/b8MCsVU/DGQMuQ84hy9hkL5o3gwaCRJa0xxyaNJ1PD7sPPQIokPeJCxkoWBbu31mIWU8FJV7DMkSTiju7v2Wk3HLXcXFfnrMseSb6ZsVItEu5JTpYrrUsqYdwszx/SRj4VJl6yg5kW9UvOI2uO8SEIqNouAAMzDHJJbH5hBN5L/RQw/DMQQmL6i7zCAkZQUqgQRFf703E+yA+jWlNwXMQKp6OAxivBmSb1j5BwN4fNHzcr8FWBui9HY3LL4ds9seoEdIHkipSnFdfjw5xjEX0PUsFTXNpYLXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V2qXKgHWEMqjRXBAjx7qtZvvZwEvpy61SYK8jk+3kmw=;
 b=dcVo4xeMAT9YZUDrcLl5YDul5lIcZjQY7aiieRKqVIsDY0sx7Gtr39z70CSIvbM+HKVDw/Rme8LjwkXhtt6pCmaoDfLKBTLWm+QdcF9EU9TLS40rX68bW0hFtjAre1PhTbaBHOfQX8dDtH8KlYUH6PPTb6N89DdwX8cAJm6kemv6DyNLA1RSGgCvMWySqj6rRPHt/nEbUjebXKTby0dpwiStl9YQekP0GFEKYEEa7Qe1VP4Xz4ljjn19I97SnShZ5Swp4nfchIfOjnMzhtgGrw96HvecVrDw/GUsIEAnBxrTo/lgefleFnnF6itfn7gY/5bRHosolsH2aN9FwYnb0g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by MW3PR12MB4394.namprd12.prod.outlook.com (2603:10b6:303:54::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.29; Mon, 21 Oct
 2024 12:33:55 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8069.027; Mon, 21 Oct 2024
 12:33:55 +0000
Date: Mon, 21 Oct 2024 09:33:54 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Yi Liu <yi.l.liu@intel.com>
Cc: joro@8bytes.org, kevin.tian@intel.com, baolu.lu@linux.intel.com,
	will@kernel.org, alex.williamson@redhat.com, eric.auger@redhat.com,
	nicolinc@nvidia.com, kvm@vger.kernel.org,
	chao.p.peng@linux.intel.com, iommu@lists.linux.dev,
	zhenzhong.duan@intel.com, vasant.hegde@amd.com
Subject: Re: [PATCH v2 1/3] iommu: Add a wrapper for remove_dev_pasid
Message-ID: <20241021123354.GR3559746@nvidia.com>
References: <20241018055824.24880-1-yi.l.liu@intel.com>
 <20241018055824.24880-2-yi.l.liu@intel.com>
 <20241018143924.GH3559746@nvidia.com>
 <9434c0d2-6575-4990-aeab-e4f6bfe4de45@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9434c0d2-6575-4990-aeab-e4f6bfe4de45@intel.com>
X-ClientProxiedBy: BN9PR03CA0201.namprd03.prod.outlook.com
 (2603:10b6:408:f9::26) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|MW3PR12MB4394:EE_
X-MS-Office365-Filtering-Correlation-Id: 5344d309-f37a-46e5-485e-08dcf1cca0b4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?VXLQRDd97mBtYpsOnJKoPX7Im7uNYSssKkP2jQ0Yn/RhA817mYHwgwd2oOey?=
 =?us-ascii?Q?s9m19p2luGbIiEcx8bIYd99CpF9rEAG7EWKDy8QSFs+dx0JCge4JvIZjVfmx?=
 =?us-ascii?Q?+MmaJtEpedOq55FoGk6yShma8w40GonFiWX4tKw9WP5Y+iZwfPeMHtLyiQBH?=
 =?us-ascii?Q?FwWzf728HhFMCIJgQZQAIxWmhfMViMGpPl19l88Lr+wtvrT6A/r7bTBxyRGf?=
 =?us-ascii?Q?d+KMJODYY7pniAUlsFt3Qhp7L6yvBEd7wjrpKRC1vZR3yQFAiikGmOjB+/Dj?=
 =?us-ascii?Q?2etJ+9hyDgrqpm+2Lm6J5k2w0UTJiI3jCHthvMIix5MRzIuyteoYEdPY1d/r?=
 =?us-ascii?Q?s9nd4REVv/WTqF1xc7gXN4freM8lkhpzYgP43KFeDvnUah4ohDiL3QtTOb7Z?=
 =?us-ascii?Q?ls4YLGvyh8CCFy11I1uESgxSdrNbE4GF/hkS87L5dBp3yuLzN2BpGQJTcSa0?=
 =?us-ascii?Q?aK0Hz68w1tX5lc5p6KQWfQq1WmpkMkJnWGMBbjuGnyZ5vChqoAsUxizi1JZh?=
 =?us-ascii?Q?WYACyBrZ3dyI12+Kov2M3gp02vkB/ChYTFCEkwc6oPESjJWItMCWwwbUusGR?=
 =?us-ascii?Q?JounhFYiUPElsUrFuPw/jwLp/nDEs11CXSxQJhPamRQi+KlVF86EopQB3X6S?=
 =?us-ascii?Q?iVwdSGY7I4lTU8xhu8Ek26Ag9InqrXv/TtGjyEYwsxIBS/+/KrOHzYH0zYct?=
 =?us-ascii?Q?0rFafIVxPDpIvL6CYqRdwPZjbv93FRHQO/TnUn04yKi7i1vpluMcVxq6JFi5?=
 =?us-ascii?Q?o/NRYVIGYfOIeSd4jQ6ycPCpgMqLCUQX3HhRjbgZfvPQEBPcCA97QzWVD8AO?=
 =?us-ascii?Q?mGIvgSwK9FtY/SzlUxLpDwGWs9lhxWkT6A1QW0vT0fiVHWg5wY9Cz48HV2RE?=
 =?us-ascii?Q?MRuANFAcHTSFHL5J8syF8fM6psyD+Y1Rf4c7wbaEeo0pvEqq9ybPqzuZ7VNn?=
 =?us-ascii?Q?W8bYK0PjKVud1s8eyzv9TG2Um62JY6WmLmURpmGdKNFNIGsS3Qo+xBB7se5v?=
 =?us-ascii?Q?1Pej8VdWlNQWUbnXLRCPYfu2q4hTdtdIac2HAjWsSA+Ib6xL8BCDiLGzE9mM?=
 =?us-ascii?Q?8l7tX0pBxgZwH6kxWPn+HVhN/VEJXP6Um37I34Qe34HYo5zwfGD2Xla+NfDU?=
 =?us-ascii?Q?kw3EeX4haYQfDyblBc5YSK8HxtdH2xbACCELZK6gx+FuIETv5rqG0tEzCgjG?=
 =?us-ascii?Q?2Jt8ZpNja8KDTI1OKcTkqLcu1zFMe7tyOtUN2rn3dud9tGOoXT4cvOiw7gOK?=
 =?us-ascii?Q?mXhirdsY50D4jBjmjzxMXkCi9SCxhV2WnQTX/k8ZZYySC4OJg+cZoP/u5msX?=
 =?us-ascii?Q?v9w=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QytSzKGARsfcWeYGZlJvSnkXFh2hEWRJf/wQitGGAEzD6goXVRN4Iz72bL4J?=
 =?us-ascii?Q?sBQshavF9RuP7Hvc8KrQ6sdOJ+4eM8k+tOGuf8NJ5XMs3Dg69f61ORa1yazQ?=
 =?us-ascii?Q?emopPc85+NZF2ImpQWymdwy8S7AJLje6a/thZZuJfSH3SblDwBgijaiL6gQj?=
 =?us-ascii?Q?0s2C+CdpD6r6plHyR61PFv4vaAMJ/4fpvU7wn4f3APJLTevU08zKa8ouGPII?=
 =?us-ascii?Q?FUQ7Jq8o6L3eDyInbAJSXER0VyiYI1Y5a/VzRm6lPACZCevDPFdLiNbfZJ6C?=
 =?us-ascii?Q?pb7gpTwxYnvlENrVQeRuXYnQ06mHTSs50liWVIVKnSfaRlVxXCNPXlKM8cEg?=
 =?us-ascii?Q?2AiR15j2JaCQfAKq0FKTiJj8SCl2FCHd9QLgEt1OKAsOoKRlQRG5voLtz50d?=
 =?us-ascii?Q?7WfD59aEDogCoTlOX417z2CY4tO57pvlJTRrOa/ZnmTZcH1pu1zm555S/3ep?=
 =?us-ascii?Q?kntNiXLTLx7zteYOJ7K70tlpy1vuilS65FQzlgT++ST7bcLs4zc5nihndfe5?=
 =?us-ascii?Q?SKBeASGAjAy8XmKts9v9B14vUYikmaI2ji65iGjHGlWUPYpSAYQcokuY1ssn?=
 =?us-ascii?Q?uWoKRzBxPSpLiU3IJmIhwLXxTTn2y9OxYXimBHtsb7sSi+Bdn+CdQnjK8ZW8?=
 =?us-ascii?Q?XLqha6fYDYMer1/H8LRQO5nq17xYOx/TLmX4QwLJhwfCG3YwwW7MKuYCmTEE?=
 =?us-ascii?Q?fBZ9fvTLF2q42vHhGA1RP6HALnO58woiBD1vmXQVLkTlsEbV4N7Gp09BlWNb?=
 =?us-ascii?Q?MBJNl9mQoDGyFZiwfrJa3NfK9tm0abOveZdWVGxJOlI2NpmJerkXtwJomx3O?=
 =?us-ascii?Q?8vqdwL5EwQ73/u3vxlZCov6qlfZ+LBHj56M3M/2d6puR/cYLTIWNALlePt83?=
 =?us-ascii?Q?QeLG4+sWpyaP8bWZz3196/l9ZO+BKG8vlyw+pknbgbZjBu+IHuNkJ4hif7nI?=
 =?us-ascii?Q?JjmWwe9YbXHy9n1emt70SFIcF6OKN9ypKGDzLU0ahzFI9eS49nter63l0+Wd?=
 =?us-ascii?Q?7+1jCmAKtXNBo3FH2YcsnIKApeFBurZjKJto6WGs4QC/GZhk7zpqN82D8iD8?=
 =?us-ascii?Q?e8W+33IdE7saP7yRT7b8Nn0mY7Dz2mOzU1Xw+pD8g7Hm5W73r2ZPlEL5i8KS?=
 =?us-ascii?Q?hLZ8brgnNUpJLQgLyCBGobEl9FwsnXkaJPRiPdVxmRkYsqsPfoEUbuD/ZpTj?=
 =?us-ascii?Q?BPVB6wceYN5JI+OSj6pSjAVb7gOYGUfD/qAyQAbnvnv+v0BoztoeJZpbqvnm?=
 =?us-ascii?Q?UB2MNgqKhIm6JOSdesMLgENUUmEfGvn6eVHyo8R3i1HJUJKZAprPiULYMz+w?=
 =?us-ascii?Q?WuxZvZ/hrzWCqlthSpwflfEkRQLeEqrJV+I6GWY9bRBKvotxPYy/ztjZViOO?=
 =?us-ascii?Q?enIpa5c0cktOIcZeSGSuE5e+0WmJAv8/oL6qfhooZGx7vw/17x4Axc8YewZf?=
 =?us-ascii?Q?BbZsIiIq1juvEQ1w3klOPDkqhra9EYPIYfMX+AQokymKc7JzhsDfM8Bdvi+z?=
 =?us-ascii?Q?pRirqw7QQTnPS3gfXMtcaNDMFyVSZg9hKjC7ShJEwMPjrgCicETePYy83w8p?=
 =?us-ascii?Q?4rs9S64QGY57IV5MjA0=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5344d309-f37a-46e5-485e-08dcf1cca0b4
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2024 12:33:55.3355
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o8/E/gUaf7ioz5N+1rBWHZPV2f0q6U+08YlIMa2y8QVaFi6eOghSh9ScgNOPCgB+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4394

On Mon, Oct 21, 2024 at 05:35:38PM +0800, Yi Liu wrote:
> On 2024/10/18 22:39, Jason Gunthorpe wrote:
> > On Thu, Oct 17, 2024 at 10:58:22PM -0700, Yi Liu wrote:
> > > The iommu drivers are on the way to drop the remove_dev_pasid op by
> > > extending the blocked_domain to support PASID. However, this cannot be
> > > done in one shot. So far, the Intel iommu and the ARM SMMUv3 driver have
> > > supported it, while the AMD iommu driver has not yet. During this
> > > transition, the IOMMU core needs to support both ways to destroy the
> > > attachment of device/PASID and domain.
> > 
> > Let's just fix AMD?
> 
> cool.

You could probably do better on this and fixup
amd_iommu_remove_dev_pasid() to have the right signature directly,
like the other drivers did

Jason

