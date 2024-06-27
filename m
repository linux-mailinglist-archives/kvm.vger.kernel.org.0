Return-Path: <kvm+bounces-20607-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C322D91A6B7
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2024 14:42:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E39F51C21DB1
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2024 12:42:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CE8415ECEB;
	Thu, 27 Jun 2024 12:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="TXeeEON1"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2072.outbound.protection.outlook.com [40.107.244.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23013156F27;
	Thu, 27 Jun 2024 12:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719492136; cv=fail; b=HoW2aIcNzeSczoUVtQMww1qMfxL8CsLezLhqMRrM6WhrHnVF5rkdcDE+70bx5Cz90PuvKEeyEGEq0ITVw5UBJWT/ZqnMe6+SqK188dzoGFBpK6W8czlirqXKLmP0yk+z0fSd5hgfj8vJgWjsnmEytT67zXcO7VndaO75BBbR2PY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719492136; c=relaxed/simple;
	bh=0VvDcJ53hLPJyH6UH7uHa1lHpA+3ANy4ZpxlPfSH580=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=iBCbKOeBK3NL06x7X0Vcd3IxIvBd16kqoqz2FAiu9kClYtQwEWZHAbiUrYrwXRetlk+GrO0xamPqKyBLVXBD2OUzBsdVMFOCIsYompbCQRIGEoO0Ygo3vFwm569rEaC2SWu8sO53gOEjCqZKP95nJkkP/KbcbzZmxsglW3j6fX4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=TXeeEON1; arc=fail smtp.client-ip=40.107.244.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IP4NYaOw3JR/7UKyavi4yv7XOm9N6MyTUDwIKj8/WQh8CeIt8xt2vImdFFCZ1PXMzEif7UOPESFAPvdjufLBsftL3PBxhE/H+JBuKqSbcZE57xKKNsa7+6yl2J7DnyfC3S/U7cPwOgUjDs0iI4EvPRUKVgN/lHqj9WULO9niT4MkoO+lZULixKAziR/Y73KFwzXCF0BAL8IMT28bGLcQzC8NNjiwlEN0F89QVus4GRynuEsdFlcDt+YOq1W3LCG2IlXIKX5AccfJ9arhHew8/zW2IJcj37k+whhx8vkv6M4fwVIyL1nl2mN3LYZGYd8lfYUHfJf2SWJG0NWcb2eNlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0VvDcJ53hLPJyH6UH7uHa1lHpA+3ANy4ZpxlPfSH580=;
 b=UddHtSXPaxDTHsldmKxEOH3hX8w8YowD4fwWQSlWGnu4dAz3ehqahZJiD+ZtCzUM+fDmEC+AsbVIV7MrwujuhFL/lRG7vvwA+sUN42E9u3JV0kH3nlgy+NCOiQs00oZlQxXaRlStlr/m2sQ/W4XiQNAufkYrdiLoBJmSgFZKbxxuWMK+PY7rCTJk/dmZnMPAJ1cnqRkKG7iCSUuD468aO0sOxSDqGE/66PHiMX3cqCDrw0PqUNlC4L2kWZVOkrJcR4daEL25XeyZsoSXsPrC4dDqORwpZyb3P+Gw8Rd1g1Rc13AgxeqkIjH0uNMows0m7jD4VAK4TwtAqj+2HN9JpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0VvDcJ53hLPJyH6UH7uHa1lHpA+3ANy4ZpxlPfSH580=;
 b=TXeeEON1h/IKc6KjaSzZ3YRnxnmh7DexIl6x0IGUwExyK98UkSqUR3MomdygkkP1lYUEMTZj2FAJ9uuxwEcOJ9GM6fXFpgq50JZU1WBzTMnBY4CKMTtk4XQpzRAJWc1dq0vI0/fwZalOPUjMY5772mlXnlPST3xi/5MFxK/oVgM3Hchc8ZRmtSGrWpphRyBuaqZrC+qz1RwNKhUbi1DnKwvTytNDDhiEgI0Fg2tIrnP4BRMawu/WrNd9U4+HMZQTmdNVtkQalcYmHLyUEzJtmNNKDxA7nm2MKlca/9OEQGIqUBBKEhqD/N3WQceLq8sIADJMrAXD5TCjS3JcKB8vIQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by SN7PR12MB6744.namprd12.prod.outlook.com (2603:10b6:806:26c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.28; Thu, 27 Jun
 2024 12:42:11 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%6]) with mapi id 15.20.7719.022; Thu, 27 Jun 2024
 12:42:11 +0000
Date: Thu, 27 Jun 2024 09:42:09 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: "Tian, Kevin" <kevin.tian@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"peterx@redhat.com" <peterx@redhat.com>,
	"ajones@ventanamicro.com" <ajones@ventanamicro.com>
Subject: Re: [PATCH] vfio: Reuse file f_inode as vfio device inode
Message-ID: <20240627124209.GK2494510@nvidia.com>
References: <20240617095332.30543-1-yan.y.zhao@intel.com>
 <20240626133528.GE2494510@nvidia.com>
 <BN9PR11MB5276407FF3276B2D9C2D85798CD72@BN9PR11MB5276.namprd11.prod.outlook.com>
 <Zn02BUdJ7kvOg6Vw@yzhao56-desk.sh.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zn02BUdJ7kvOg6Vw@yzhao56-desk.sh.intel.com>
X-ClientProxiedBy: MN2PR12CA0033.namprd12.prod.outlook.com
 (2603:10b6:208:a8::46) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|SN7PR12MB6744:EE_
X-MS-Office365-Filtering-Correlation-Id: e1e29ede-1555-4592-cf47-08dc96a6905c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?d2soy72XyMd+zsifyxpl7m5Kn/N39lVRG9xyzXOjjbtOwLBpTFV+I6hDfIbx?=
 =?us-ascii?Q?X2461yuzqJFDdF3I8YuQFhY3e29dnhYVKpBVvxzhUsqDTFojpMsIkciGs25L?=
 =?us-ascii?Q?QtlkhAJT9aTrCncjiPbYNnL9sbO8Dw1hENmK0JYPShjYmW9c8Dq3O40iFW5d?=
 =?us-ascii?Q?LDLp0IxgRyL1xkqpLjM9RlUG/hr9wOmUVuHzKQa1/iCYpw4W3pb9kmcErGuJ?=
 =?us-ascii?Q?1hKe73YnPVZusGrf2KQVdDZCGc+hJMrcaTuiAZOymJkXLw9hNJidItJeJe37?=
 =?us-ascii?Q?HCG2BQRZXrK47WpyCnA5Fu4d5bU4SUhRng6ubTzx/VxKEQyhRmQWszN1hSGe?=
 =?us-ascii?Q?/0JzwVaTpD1dJ1DzfVJmyH6/TFmHJV16np/WeEectHV+FeRZX3JMLOjbNmHc?=
 =?us-ascii?Q?fYY+MucMWhQVjsEbBx+qTAWmgACQiNsqrvKayoyuCMEMq85x18pQ9li4xZm2?=
 =?us-ascii?Q?erTsMUV8TxOFa4l2Um3diY0Q2H5LzOYA0KXRQJNavGzK2UjFGwheyhvK/Qzo?=
 =?us-ascii?Q?Rk+qYS21hpKGofz4gvPa1NLi3DxdxxCSisSymD5G1LxbNl79GphZ/zknPiSN?=
 =?us-ascii?Q?VmSsmiPu5r8gYV+tA9h1TEWh1DnqHJe6UOq/aoJVIBAk0zIl9YSRnluUcOpO?=
 =?us-ascii?Q?4ntQJR0N8OSoZSI3Du/yu2LCUMz+z82Xf42VTx5jsOResjXrReXyOYPcsix/?=
 =?us-ascii?Q?pu4lxuw2GlPiWoNywsZ6Svl0z5NQE0wEzzuXgjWaZm6JSMhVDA3xe+EeWKYq?=
 =?us-ascii?Q?s4ssNzRED8x4XX6BM88GqrNRr90xIo7VZ8AZutO1vXUbR+WLIJA/z2j8yFmZ?=
 =?us-ascii?Q?K8kErQfcH+63/W8xMAY5PyCpwF1R0sMpTpAQ56vM8WL/onaicXVBe61J23pc?=
 =?us-ascii?Q?qqng5dqr5cprRcdmyArDXQpVF4TRGGdWFtO9bB8NOOcGBRFOsFiyVbmuXaJ2?=
 =?us-ascii?Q?LAegzukv7Gdj6TjPjxNGsdBjoZc7j+TXqF5yFxsa4u7+7lf9YmIy7D8AU+QN?=
 =?us-ascii?Q?f0c1wbqmsyycTEo3nvUTUEf65Ujc57qooNjkf2roVq4W74Yo73h0vqGzyLE1?=
 =?us-ascii?Q?fZttexmTPVtTirfpePusypZBNWnjOXG0hy3A4vC837a0ZkGXb711B8Y15vUu?=
 =?us-ascii?Q?PR5l71cyXU5y/BNfHW8VY2LAVSyG54F5reS2SfBJyUaUC0KfYm+YxNMoAyaD?=
 =?us-ascii?Q?WaLlGEisKXJhtYBf4jCG+pRd1i5qJA304PuDjoWZFG+A0y9jtPzE/tpfUkib?=
 =?us-ascii?Q?frmcdVsQ0CaQo5aPYiFTBSVG+vc7UFZWfJNWkJwJ3y+A4VDJgG8i4brsolSa?=
 =?us-ascii?Q?D3sGaKus54sEtYDFtLCOOv+kpQQqdD6RhNlTU0R9FesjwQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Zm9zvx631ALh19xCakXnFCML1eTgrjxODJ+FHCM0dJg20v7XDdhv0Invlao6?=
 =?us-ascii?Q?AIrEP/9dFfnvFYzvGtSYIb54a/nBSoVM2qByn70hR5sr81Tk5tjS1erNHPXA?=
 =?us-ascii?Q?NREsTIFKX6uj0S3TRmuNybEBXCtZ73GDm2g0fcmI8U6uK0mmW71r+90mKXq3?=
 =?us-ascii?Q?9uf1Cc//i+sSVF0HWgByxr0bnlWIYOF0At6wjs82ovo8CZSD3En00AJYno9R?=
 =?us-ascii?Q?JdHrMpSGMYpMx34swiUSZ59Qs+tlgyhWmXIRmL0f5Q/vWMIsxrxzR3/ubt/6?=
 =?us-ascii?Q?gzhqqLkfX7q1o5WEz2iT6iReIqTF72PgAe5gO5A4uHPhUjFTfu/ZZHn17Qnx?=
 =?us-ascii?Q?sXC3NcjcqtiPSyGM/GjnwN5xB+2dvokRigWN8uqIkadaT0ze/Ewo71Q9EAqs?=
 =?us-ascii?Q?tuVV3j3DOfAFn3M3mTZfO8HJ8NpffaHzgeMwhh3Af5eliCQrmrKjFw4jyk9p?=
 =?us-ascii?Q?y5GeXBsSj8f3tGpHxigKfFqsnJiSCGxt+Sp/rcdHryWeoBKf4esXBBUX0oCl?=
 =?us-ascii?Q?nFmk87NrTtnGx2ErMkXP7DeMCqK3KVqdXoQKxsbTsB9+/+oWYuazKOlxNXCx?=
 =?us-ascii?Q?A8YQGh5QvIFRUZu1HSkWWS7uRRAsCchs5NZbz0Rz3UXBDGAKwEu6d/oI/V9z?=
 =?us-ascii?Q?IW9MPsYT2AbyYMYFzURRTWchMdlqmHLF8oGlo47eCmVTKnhb3nv1LwMi2MYY?=
 =?us-ascii?Q?VThRAaULkNR8J0+KOA+NjICxIKbWntd3h/4FOedp8wYj7Iru0to5WvmICBzF?=
 =?us-ascii?Q?O6IKdY4JSr5PauGfkwOknLv915M0bkFfQw6zdMropdcHoeFLk4tXkgfRQcgN?=
 =?us-ascii?Q?h70nTGUP9D46HwpnuvB9VZ+zPZI27+SpeQG8Z4FPiSBXwhRVT6h7sH/N8tzD?=
 =?us-ascii?Q?8I1LMdiqFkq5fYD/Y/IjOujT3bzzfbdDmx3fYLIkGq+7vMPD3Oir+3ic10Ep?=
 =?us-ascii?Q?pooAOHh637nHYwWi5v9N9Ips3P+LJCZQHhMzO8fcEZLdr8wuA+XRPpM78VUZ?=
 =?us-ascii?Q?6KH+T87tbazDqc7kqytpwdCIX8RPDlnn4coJ2gnxAh5fL9gBbQzHzdxGhTAb?=
 =?us-ascii?Q?oXIMxJY9hsZmM78CjxXFxd/xRUKbH93OuaoUfSmJynVBPeSW5VDKO0hUncWg?=
 =?us-ascii?Q?xxui3eCXP2dgvL3C+w3caZcgyYbV6M5hXMe6+SJzsLQGqH1i5vK2R3VH5L4Q?=
 =?us-ascii?Q?SqdnIcUbh75YdAPk65aln6Va3+5JzTk4sSiey5zglrc9IVXP0OzZ04EDuvbl?=
 =?us-ascii?Q?XfPmobihkcjcyzdfeyZSFHM745oCQm9IWw4Drf7WwWb8kwHbxJAqV7tkmtmv?=
 =?us-ascii?Q?dylMT/isk2aboftC3GwFTW/CeoTiDSLr1AfjPlILLWwKU4a/dA8zywSr8Tba?=
 =?us-ascii?Q?3JaC0Tmfyv13yhSChsUNPFSJVf4M3rku4KUBtPKhx2zShZDuZuJ1nyWcjr4O?=
 =?us-ascii?Q?vlI1fp2h8SXVHJRcYIYTnJiA0+tMCSngHOAR/+TVLs++ywj77JamWaEO+yg+?=
 =?us-ascii?Q?KpVVIa5HOwhMqcFK9FebF6jFWHe6m9ykAAZGg38lDkVL0Qm6RhNrCDuXjyFf?=
 =?us-ascii?Q?3hmoneHEcPlQiy7FUFotryN8RQQKacanHZi7WjgE?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1e29ede-1555-4592-cf47-08dc96a6905c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2024 12:42:11.1459
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 16lppzehF/bUxKxI0/mHgO/vXiek/h1GGBGR32CgepEKFfR414PVpiNJJQVqBXpq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6744

On Thu, Jun 27, 2024 at 05:51:01PM +0800, Yan Zhao wrote:

> > > > This doesn't seem right.. There is only one device but multiple file
> > > > can be opened on that device.
> Maybe we can put this assignment to vfio_df_ioctl_bind_iommufd() after
> vfio_df_open() makes sure device->open_count is 1.

Yeah, that seems better.

Logically it would be best if all places set the inode once the
inode/FD has been made to be the one and only way to access it.

> BTW, in group path, what's the benefit of allowing multiple open of device?

I don't know, the thing that opened the first FD can just dup it, no
idea why two different FDs would be useful. It is something we removed
in the cdev flow

Jason

