Return-Path: <kvm+bounces-15352-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 410398AB45C
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 19:29:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 94F58B21E88
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 17:29:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A476213AD16;
	Fri, 19 Apr 2024 17:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ObLmzB6H"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2083.outbound.protection.outlook.com [40.107.236.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 588E783A07;
	Fri, 19 Apr 2024 17:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713547745; cv=fail; b=IeegYfgHx3js4UVKk3og507F9UHjTBLmdKw3h7HM5SOncjMQ2o6Tq7/yOVK+uuL9Q2OVMVC8KII8mkIQajg8DCSlvBUt7WmhD5v4q9f4Lwlj8qUfVQLwXK/KC5ktEvifRlsBWR0Wnodb9Xx/LiGt8CYTcw17v7WElUWPVjSc6d4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713547745; c=relaxed/simple;
	bh=c5zYnzreujVjV8cwl96BnAS2SQNq8lVdMJD7FXv9eHU=;
	h=Date:From:To:Cc:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=uGMUfBvLe/bjl8XW4gVbzmej8r+F5W7KvuGLF2r9ICP2JzUMEV5ysvsD2Q82e8L1vcvxnlJiwu6C7ief/A3B4wJzVZNZSuvyo1aOXTw9cQl7oVLtvpHQlw6HlVia3IO5F4pIn5NQQiF/Z/9woJ305DnR+dLvwKsbnvJYLMUcu+w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ObLmzB6H; arc=fail smtp.client-ip=40.107.236.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IJYhGr9H5BFlGxbxM3cbdHTBqsyKj6uh62QaKFCe0pZJqBbPmU3LiTakThNc0MsNinrJFDoYSc73WW1c4fj043FoCq1w+LCUWS4S9xYu9FgTL8lFxd9kZE8+2Fv0KshUOYbNuacaOJ6adhoN/YjcqiEqz0nT/wdG1sbEbPsfrZ28xJbGGCg40EzfQFzgd62KhI+nPimwDpx131yp/9E2LOPylOf4ivepi/nv+Ww5QqJrUHupkK3GiLdQlNNwKQeK5BGGg8ucOq9s7HPI/T9UBnM2a0UuHRprv5bngg8fSJUGUEzXRM+5/yt9qv37Kw+uqOZg0LFjAKChRDYB6rHvmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9xE+Rfa4urfcYyjL9i33PNG4B1DUah3Raw4fFu+n4qk=;
 b=kjHAkg34bmvk/wT6T2zO1IxAepyxS+6J8xwa0uyxWT2D+p+le47NXOyIntic57jIupge7UmCQZLnG83ksVGLgQkpnCyDVOCHkW5GOsID8cansTIGE53HdsbC8F2EgeYutXG+hnhEgaEZopqetkjniQSubZZhGNyAF3URFxyqkSuqtLXwJXqUArT4Z6yjcIpOFkyLEpJhTg8W+kArcz801b5BiV7VMPEbjyAxCB356ppjZkQwpbUAXbmIFo+S+k26TlcvUWQn5tnJyppmxauzhggt3/xQYTZCESsiy/yL9fXsOIcPydf7mDadiD/3eisIVqbVIxwBkR+HytGpnexRSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9xE+Rfa4urfcYyjL9i33PNG4B1DUah3Raw4fFu+n4qk=;
 b=ObLmzB6HaA84EfCmiGmSTkDa4XtIaIkAvzRVu5rhXpvKcneWj5MduiPdPgJbAdBHMslJuOflsq9mY9Mu6kU+BsyfsYC4CPgyfwFWcOG9KD6qyczCXCNoGhI16WHKf/Igsyl6r4ja9fCk6CVqKLxFyD3sT8pAEGIBwrTywtQW2gYstiePM6vhEnmnNOardbxndVWPydsxSqcjpbjTEvoHSFOwY21uNqe8faMdMwSWE9sktFzDA422xQ+wSDmxG30S3bLAWY7CrnWFllWNdDRdGvHI8d2p8JE2XJG7D/PBp5jJtCsJKNhzxFT+0IjRVx/5+/fAIn8DxthCGS76YVk0sA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by MN2PR12MB4335.namprd12.prod.outlook.com (2603:10b6:208:1d4::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.44; Fri, 19 Apr
 2024 17:29:01 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7472.044; Fri, 19 Apr 2024
 17:29:01 +0000
Date: Fri, 19 Apr 2024 14:29:00 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: iommu@lists.linux.dev, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Kevin Tian <kevin.tian@intel.com>
Subject: [GIT PULL] Please pull IOMMUFD subsystem changes
Message-ID: <20240419172900.GA3818133@nvidia.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="rwOwfyHrED0VDoSA"
Content-Disposition: inline
X-ClientProxiedBy: DM6PR13CA0005.namprd13.prod.outlook.com
 (2603:10b6:5:bc::18) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|MN2PR12MB4335:EE_
X-MS-Office365-Filtering-Correlation-Id: 453800bf-6aed-4804-e88a-08dc609633ee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?cc97yeT+B4xbJBEa3C70O+6OTL9O0aGrvHOQPlutpJkoyp+djyv/3gysXLJN?=
 =?us-ascii?Q?ZbsiJkTlHSSdQxd98ei1SMoppyLcYrhmsM/AvjKLFFfzv6rfbM48XdU862pp?=
 =?us-ascii?Q?4l9FFBS4HHlets0v0639Whrr1ycVcA00HILi/RbwWqfHPjf/JLWxQD+7TaHU?=
 =?us-ascii?Q?Vp/DnTkmVxK9lUJVZ7Ld6ivq2rzId9W6EA0kLEbJ4UPxIpRuXPKje7zLgbpw?=
 =?us-ascii?Q?LAO82pvYzUO9hgEUv7S6LVb4y+CCbiHlEhb/ZsHLfSUN48CijzW+p9Wag3gt?=
 =?us-ascii?Q?mrntYhol4onjAis6p3rc8zieXH4t5RjiO9X0oGcVbg0kHkL8P9EJ8Y1Hv2r2?=
 =?us-ascii?Q?KSiIY2uBROWepiuwle3F1Cozdm88xslZSsSZcsz3xqkdOXmUVgmKutrffj53?=
 =?us-ascii?Q?klNwUdlohD5OKBYeD9VpXqyXNyk+m5cibYcXj0McHtkHfptXPkq0VxcwLvxx?=
 =?us-ascii?Q?r1gtnr0NtCGRI6+fceUshqnpBRTMTdQ7RqlTRhJifZHfZO1EioGV/v7tNxG9?=
 =?us-ascii?Q?IqnpNpqSqcjv1A+bzyH0fv/niofa+3qMD5UsrSP3Y8um9SK9nkyOewBRe+Fi?=
 =?us-ascii?Q?gYF2gybtxxqXaPRHBVnnEj4A3/PGlAKNqf24yP/prcfeV1L6tsW+02jBgewS?=
 =?us-ascii?Q?EknGuxtYLTLp9S8PBB/vQCxZ7mqPrXISMasqnhhrZdNxv8PhDdn4C6AMY7g4?=
 =?us-ascii?Q?z63g2gMctJVYGuRtoTYFQ1vaXUV9u4QJjOGstf04fpKJ0PBHxDvRaTkfj/IL?=
 =?us-ascii?Q?hmfsj8zOMpZz1Itf51EP3X6jZE22GTslDeBIG774X0mSxDzgZAc2DRYmSVKY?=
 =?us-ascii?Q?u9EKAe28TwHyoCiYlqb98+1x94l6RN7XWG+FTz84iYjCvPMJN67c0NmXrudC?=
 =?us-ascii?Q?2+JqmDjvFIGXMlcSaz3kXu9SqtDQOJpo9xWC+fIpGeuuccAJbk+3vbgoAP3S?=
 =?us-ascii?Q?3WYJhv0wffUy/VaB4xjiu7gpCxisTqEbGNCGMScKcpPHgjPSDOHAgDEYxeHe?=
 =?us-ascii?Q?ebCyR3X0UQlTkKShui5jTErPiGQv0Pl7507/cioCGzgQbArzoLwzZBdhjBMN?=
 =?us-ascii?Q?pHkBXZLXPEPautRmr6agSU707/6O6lxDe7pw849AAHWMGjM6uqNDcZevV1Nz?=
 =?us-ascii?Q?7wRMVHWCs33pqmyQD9Kyc/d4M/NrvMNZDpa/hwu87xQHTiQeu8W0AQEa6ZEF?=
 =?us-ascii?Q?bVtThaGHX8ik4obBUKvCAo/FbnvBtegGJyMMJv5dE7NvvgcVqXj7yjpzVLW3?=
 =?us-ascii?Q?caQilJ/sM7wtF6zfjbPbbW6LzH4282oRQKX1OV80kQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QXQ8rdoPzgciTpe15EMayUjLSty3b7WqT4BAIXC+H1kkVBEbmhgjczWHlnf5?=
 =?us-ascii?Q?D1MDbYkpm1Lsa5A+vO7CCgkZsqeGQ4s7cw62dWvE4dnG7P2EfL5o7R0OrU9b?=
 =?us-ascii?Q?pccy50ITX7ZkzBaOGmfhlWXGZz4sMHY03dbfxoz8ia6v+wHRp96aXShoUv3K?=
 =?us-ascii?Q?vYlzkV7yss7WRVw/YmOTCqjNPrOGJ7Xh6GgRpOLZpA+OLXk6VFIuXFQz7XL+?=
 =?us-ascii?Q?ay+SQFRkT76zFjBOm+7FnQ5Ih/M0Rl46lULCNTG48vPopIOhq9OD9EcUCKD3?=
 =?us-ascii?Q?D2izNbZxMOUmCq6rnN+iwYm5nrhF3+IJ5DzCeqjdw2voLki5nZ2L4g3vfuG2?=
 =?us-ascii?Q?bqsQqSHoo/RGK7siIhs6syuGdOA1GTGtkcvh2xlKWXZrYM3N6zZA3JBOuLZ7?=
 =?us-ascii?Q?aFjEtaNVi/T2Paxj4RfO/IYEkfjPKQfPkjd7FCT0hskqS9ObvvhF4Gmzzy33?=
 =?us-ascii?Q?Wim+rqN296XaQPzchWiCTEIvd1c6nU6hP44Ljlay4aL+9MCDMuhf1/sJk5NB?=
 =?us-ascii?Q?mp7mfLEsQCmguLbuGmFYr3tYQxvLG725TSrn19zWFdAbp4Ltacufd28Uh+kd?=
 =?us-ascii?Q?ufMZq0VmLvvNlmvZny9J/PgKQEc9k6zlBBx0H32oSj8EK6XrcvV/zNUxemOP?=
 =?us-ascii?Q?ds337OchZlbSmOpX4rUg2xOf5KROLaAqXfPQUjBP6rqcHfEAdbgcBT/mN/T6?=
 =?us-ascii?Q?nKWTSdzSQ6wEkVx01igRuok/iouhhEJ2m5W4s6Vsj9V0UWTauIx03i/Mkgda?=
 =?us-ascii?Q?eL2bOAVew7h0Ypf3Pl9b+Q7kU/yEBiJphVORrpT9JLexp7QYslL5epBlwfEw?=
 =?us-ascii?Q?qz5djlFCUgND/0ViLY6RRJB/b1gbLl17wRE4RXKf7EV9ZcWG4IfoiZrANnCv?=
 =?us-ascii?Q?KpvdqnUcmIloizeSArYm5z3ohZB1X5vaMqpqrCQqqVsgskXlo94gcLz4SET9?=
 =?us-ascii?Q?sweW8lTTT4ptTOByTmwVvx5CsbfswtWa5xiKeWg82ME+YTFhpoGdvPBFP7zu?=
 =?us-ascii?Q?0jRQYMODcfmwS0S/Kwk1/cF/i1bLpooGWxytGbIiGX8MO+kEt+qIb4BOl04j?=
 =?us-ascii?Q?npnGIEn3iklTuGYSreNveTityRq73Hi7i03NXWiGuBl341WdG84uXhP9k0pH?=
 =?us-ascii?Q?s/LzFFYN6rqPi8flU9xzV9tbQ6GQocbFTEW/xDzsqVtp05fbqw0VRzoKXkS5?=
 =?us-ascii?Q?KUcAzSbn/6H5uPSj4o6PpMdJ9EKGIrV8mb2JKKzqc82Rges59UJRppjkYCuD?=
 =?us-ascii?Q?OFxh25LwefnYgitUj5U5P6shTbnmphzr5JAavyZEB/rWyiW8S5i3oDDrmksl?=
 =?us-ascii?Q?7sz0QZicnr+H6EVoD5XnbQQEUx8p732Qb0vp/OmzedhStBfy69TNy71DNuAM?=
 =?us-ascii?Q?ZYOVim5wdF7m5/YQ0AoaIUR+FkG674pYa/lQGqHJOh5Px5aMYu/eY3TyALIR?=
 =?us-ascii?Q?5FVqz0iQpixd/rithXUIHPZgrLMR8BbDpEqo03jILW/6+Y7OB4JJnXb3j7yZ?=
 =?us-ascii?Q?JU6Q3OuWzjis3HISYk7j1g2M3zw21JwkEPY5X+sCqUGtdSUo90uz9/wxl+se?=
 =?us-ascii?Q?sGTN45h5m5Zf5l9SWH8=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 453800bf-6aed-4804-e88a-08dc609633ee
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2024 17:29:01.3404
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VQFtoaa5cSFYnTi1KSexIyYsWCIkISu/jOGNguQmNag3+PTA0Y+W6lirBH3cHj9m
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4335

--rwOwfyHrED0VDoSA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

Minor selftest fixes.

The following changes since commit fec50db7033ea478773b159e0e2efb135270e3b7:

  Linux 6.9-rc3 (2024-04-07 13:22:46 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git tags/for-linus-iommufd

for you to fetch changes up to 2760c51b8040d7cffedc337939e7475a17cc4b19:

  iommufd: Add config needed for iommufd_fail_nth (2024-04-14 13:52:08 -0300)

----------------------------------------------------------------
iommufd for 6.9 first rc

Two fixes for the selftests:

- CONFIG_IOMMUFD_TEST needs CONFIG_IOMMUFD_DRIVER to work

- The kconfig fragment sshould include fault injection so the fault
  injection test can work

----------------------------------------------------------------
Jason Gunthorpe (1):
      iommufd: Add missing IOMMUFD_DRIVER kconfig for the selftest

Muhammad Usama Anjum (1):
      iommufd: Add config needed for iommufd_fail_nth

 drivers/iommu/iommufd/Kconfig        | 1 +
 tools/testing/selftests/iommu/config | 2 ++
 2 files changed, 3 insertions(+)

--rwOwfyHrED0VDoSA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRRRCHOFoQz/8F5bUaFwuHvBreFYQUCZiKp2QAKCRCFwuHvBreF
YQyXAQC95xel+MDaFodAalged/FP47FflPcXo04xP9cWzw4k8gD/dGF6NB70hujK
utWbaptC7ckY6BD3/j0fWSvlLiG8zgk=
=oy16
-----END PGP SIGNATURE-----

--rwOwfyHrED0VDoSA--

