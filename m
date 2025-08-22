Return-Path: <kvm+bounces-55504-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ECBDEB31BBD
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 16:35:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 63016647B98
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 14:28:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0831B307AF0;
	Fri, 22 Aug 2025 14:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Er2m+OZy"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2076.outbound.protection.outlook.com [40.107.102.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1E413054DE;
	Fri, 22 Aug 2025 14:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755872513; cv=fail; b=A1zV4Fi4MwyXXN2/owuzUle9+u/EygM5dMYkBg5/Qfav57xSzDv1jWEP2Gwic/EEDH2PR8rN+V65g4RkpkaAZcBFwmisKqiyKvbfefw2lzWB9jR8J3hufUMyq47J5g7WuW3XJWpH2bZZbsPXtQWMWrmQYwYk6IbV8iaL205cDwQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755872513; c=relaxed/simple;
	bh=f/1Tv5xEwoxv1eraCCuG92hpuNpFxWMFCoM/6+DSa0o=;
	h=Date:From:To:Cc:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=g7u2daovGp0l5WMXP+UdVgsIyHIuZ8yGpqCZINiAYaAQbNVyF1P1WllL8TCzBlmmltk8ypAmB51EgbtVsUCmXtq9fvz0hAV3fJ/neB11Cr8/kl1ivhHZnLiBZl0Zm9e5emzFE9YfPowLkuoHihcx8Qi096lwaWJUcM9IvjrqOoE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Er2m+OZy; arc=fail smtp.client-ip=40.107.102.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=w2lmZDHzrLhIPa+4K3QkjTdMjcy9QOmlDxij6qYvLnFV3wZNod0rao4wNr1F54XjcS7nRXftnk8pyBhdCENWtIOhHytwSDvfJv+tfWFNToCH7f1WqnUb0pLGxcFTDJc23AUAr4A9E4MOFE687+32V87mAQj6rOtnWEFueH4sFz06Bosb0rIJNfpKkqlGBQiaKamNdWYRO1oIJgQPdUgNBL+5rHloRqaBsVUoy2NvL+gyRedBCmqaWO+FdFWstxxyRQsNKvQZ+spQJXGjKvKyEWvcHdEv/N1wVRFcOtOzHRMFVMANsMZ+BUCumUDv3Vh6SnAsYu3NHTblaO8BBLaf6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5TiVjGtrfzAQwXS4hkl8g6G2eqCxVwXff8vlq+8UZsY=;
 b=R2lssQJUEf1z+Kr8Ihr3AEiwi7HVnBSjb2S0cpxqaZwLCy+87pRnjk9bTwztsq9HzFBE5WdIQw45oAvekhjTHykFZ1K5wjcEKJCjcfIrmDTttk5yZQEOBCUXQxy/FpCh/7TShF14+ktlDRbFlkUBBlgdgDGekETHZbsFZAMC+mJWn1/jdyC2V4zywbbad5iLfDuPbC0Jowz2w59+CSQMGnCmr3vD+pY087dgMWDBh/7N3nT70Qf9SR5ZPzxJItULhWb/tsBePP+Uw6CwHw3jYJukCCQ8kagz1cOvGmIjqOAPyYEAcu7LR/ltFLPoZgl602jqEd2e5X7wjAWY8K04xQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5TiVjGtrfzAQwXS4hkl8g6G2eqCxVwXff8vlq+8UZsY=;
 b=Er2m+OZytPVZHflkbBzB/NZz40UqmJ/truYpDGDIkJjKpol7s+APZQtN/4FynZni4qhec55Mpf3cbwd4HSyNZFWHR4LJ7OPSh+haYzkLS8oZ8sLQyRwAfuODFAR5WHJLWhxxmCLCZdKOdTszMuh7ApfRaNdhJE0LWJOIe0XmYeNzAu0t5e8DhwvWo8KknQr0eq/7QZRBe/CHIm3DAMsCvyB083vvGvvnRaDKiomm5jfXrpbjXpj2WwbJJuf81Ou/8EZd2121j0eOCX7f736Y/wjzM+b4sPoDr/qLs4PvvyODZS/FFkUpOE4d1t6bkqAwmFZDIGH2mpLcThM6Hb2L4Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DS5PPF266051432.namprd12.prod.outlook.com (2603:10b6:f:fc00::648) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Fri, 22 Aug
 2025 14:21:49 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.9052.014; Fri, 22 Aug 2025
 14:21:49 +0000
Date: Fri, 22 Aug 2025 11:21:47 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: iommu@lists.linux.dev, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Kevin Tian <kevin.tian@intel.com>
Subject: [GIT PULL] Please pull IOMMUFD subsystem changes
Message-ID: <20250822142147.GA1404783@nvidia.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="r2/z7+sXphrFiesb"
Content-Disposition: inline
X-ClientProxiedBy: BL1P223CA0001.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:2c4::6) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DS5PPF266051432:EE_
X-MS-Office365-Filtering-Correlation-Id: f74020fb-ef79-4f5d-d5bf-08dde1873b7f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?IXgC6lkrooMl05JXVtIp5fLrHgnvxacZe7F7OgvELhCMpKwAanlm1k9FOnj8?=
 =?us-ascii?Q?zvvqC4eOveD+eSo82oFO9WLcB7DNs386BLzcljHzLDJoTG8kVUrA1KqNqCUg?=
 =?us-ascii?Q?O6aqe8TjB8pukFG+rYH3/f6TiFU7T+Ksim8tMZfBBKo+gK9XQtNqFygeMPDB?=
 =?us-ascii?Q?Nzw7Tf3hlEbT3wwknMdpojvQD6wRHSjohotvPOCBhNIjTomM8gGN6vCwJiuh?=
 =?us-ascii?Q?YUMECsFsrTDu4FFLBiS921rNIenLsgKJ5qYfImV9psCZOZYS3hisyfJw1gxB?=
 =?us-ascii?Q?iKfxBIQuoL/r2rVbR2wl2snaYaery6YmlZlOLxe6XCvA1t8URzcbXqQQCwBM?=
 =?us-ascii?Q?JKnkVk7TE+gLCS6X68r/KoM6odCeqoVv5u/6c0WEzFe3/OO1IhRBQB9VOZtQ?=
 =?us-ascii?Q?szrjTnJn9UJFxfuLdPz6GEZihO44HYVwtnohxfn6DbXEYIz8PDloL2EoX2C2?=
 =?us-ascii?Q?p838nA548NS1MoZ2nLkAdHiZfeA6jRCEG+CBu0SOHhhvWTeS+znROYzZ4T8M?=
 =?us-ascii?Q?Fa9DW8Zm4x1AtW4QhYNlEtJhjbo0lWjuucexAdk0TX1t/SgC8JghY/Xzx0Sr?=
 =?us-ascii?Q?0aKn/SZCH3Q1th/AlwbvtWkl2LV73VDP2T3xCnBZtE/b3mOtIzj2yAxyrqvq?=
 =?us-ascii?Q?iS/dzAi5ZhmZaAppRoYvYsi/bOwiY/BJYGMXQXKY8TKDXRenxP3WXjDzXZen?=
 =?us-ascii?Q?PCxP6FzIRS2U6iTrO+9aEla8+hrdU9UPHzZ3kZ9LzuSFi77y29h0T2Bd28Sb?=
 =?us-ascii?Q?Y1+oN894Hg2eKxxfpFUpX/x4v6F7U+QJwNaqTb8I0HBshIr9k1F6MKcfLSfJ?=
 =?us-ascii?Q?x3mEQcohZ2BtW4YVMrX2BoXFfOcd7PzTui9tPHwGye7chcdFUe+IyuJjA6Kc?=
 =?us-ascii?Q?ifdXac1jN403KDDUwj12LaPFbQFYRwaK8EEldilYpnSnEW+iKKRtn44fhO7R?=
 =?us-ascii?Q?AvTVBEwJe+88IHPbku+2MVo/Z8M2XM3w0/9aWgCUOoteTP9rs00Y1SYk52hq?=
 =?us-ascii?Q?KOjHt3OFSA+Rvv+vRinNCaKfez+MiSQeFtQxMxfEh/2p/lk0X0nLNUslag1L?=
 =?us-ascii?Q?+XEsg4u0ggodRTePkH85NEOJs8fOCxZpKORScS9WYM+VW6cWBtVQdwPvNxqo?=
 =?us-ascii?Q?8g40gYa68Cbi5L+05pxNwrAlrEV9DKNCY4PbFc6X5XWAgMZl+R1moRkCR8Ap?=
 =?us-ascii?Q?nH83Hej9/a1gVIwRkYtff8oF4mZYWJgmhwaiMxF5n/f+y+AT3lyjXtLrIGuD?=
 =?us-ascii?Q?Ab+EpxFBDoET5AKOxcFaLAQWzPsZObdsoxF0fcDXUJHZgxZQHz8u6ZEYjpQ9?=
 =?us-ascii?Q?IzFHQj/TBGq+8LtnJys/eivvw0+G5Qh8mU8BPlsHaspoJLQM6d5YKISsWUFA?=
 =?us-ascii?Q?zS/i6vbeIPENhJsHjsDFEU1Lw/zYpdjb9emz6SBA+x0L/PuImFZlqP8iPnGE?=
 =?us-ascii?Q?TbSyOfeilhM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?YPKIZoY1Flsxid7xhG1On43ZHmDCNF8GayJLiH7t+BhYcnXVM+CuxIkfK5Wv?=
 =?us-ascii?Q?km/zJP9BgMDVHguRGrcs4ZJJvg0N75uqZYqtYD0A0YneS8doaP6SYF+SRH5/?=
 =?us-ascii?Q?QALO3ltyb3YxdC9Rq9K8x6dUCfvZEjL5wL9n8tWtsBtJVl7IsYi79NM5Dk1r?=
 =?us-ascii?Q?pu6RlBqLchrIpCgChCDcmZio0DCTNX+aq818Fxg6FiMU6p27Q527oBbygtm4?=
 =?us-ascii?Q?jb9aPeEGb/J3zGB3DYNVt65rbG+09Gh5UPw1ESkiN++wCHvd3ZeMB9ceaJXM?=
 =?us-ascii?Q?GsMorA8aC/WUKxSOxurDuo7mbuKbzVGyvT7lA+z4nP8zXnEpi+jZP863Pe9m?=
 =?us-ascii?Q?xmac6PYhm3XAMnnmJUoX24mLlhly2C1LoOsK/ZeXsZifp7phbTMks2H+OK+3?=
 =?us-ascii?Q?MMjtKqUTD/S5RRc5OIC2PtMnhcy8oI3XClHM2XlJ22tDau5ZscbjyczQpSfi?=
 =?us-ascii?Q?x+6sZn4fusMJ/s6zI8n5JjiYKRNv7EVO1Ig4NGEnEN2LY0mVjExhrIVK3Ifh?=
 =?us-ascii?Q?JmM8BaJdR6zSfXtlp4qTLfpu8Umw2LT2XVCBRVKqKMUFzLfHLH3DhtMxWofg?=
 =?us-ascii?Q?1AMb0Md1VBHhQu8jn+uVKS1uyUqvge3A6d4RyoPHIxDC19Uk/1/pfBeIqNEa?=
 =?us-ascii?Q?2Xw/CQO8ALmVJ24P3/139TKYqXkPiaG/XwnA5FO/k8vDru8JfYKna4Ks9AEK?=
 =?us-ascii?Q?wWt3H/bkOpnDne3I9SmDUCQoOLiZpnUwsHiZ3Spc4MwvBCyzknQRupDniTaa?=
 =?us-ascii?Q?0AYipxVVHtvKqbXxTkH2ZcEglbQDQDMBN9IwsrvAb7Pvu4UlzHmKA1xdqlGx?=
 =?us-ascii?Q?6UgEvOz9d2tuqiIxO5YhtUmkdugSRKj0fXZtgGGv9vinr8JlP2tf1DL0/cHp?=
 =?us-ascii?Q?4ozKGqWDF+uzXIaLxIYxbXr/TPjxf/h38ZPd4BVQVCI70uhAwoA7+Aj2qtpx?=
 =?us-ascii?Q?7OmwGTblB0o6to8eea5P/CBj2fp7siNao4h1Wif0JdzpDHCLsR2aOMJN5aE/?=
 =?us-ascii?Q?tKjp3GdfwxxbA5P2ddTXJo9POGaa+SwUgRiHglU8tWaFjfGTxei0rVdo8AA+?=
 =?us-ascii?Q?pl9ScucuNrCNCDFB2oHvnx5vVJLWTjQywqlCDWgPB5YzZkPI8YhA6lbIHWCD?=
 =?us-ascii?Q?Vi5TLbOOdkKhrHRObRTbT08/fp+O1zeQDLOyUmkLUWXX1dYum7H0R2hLb/uS?=
 =?us-ascii?Q?5XLh3l0pBGbBlYBexaxggIJwklrpQkuTyy3eNFQSVQucKms6P5+z+8chGbPo?=
 =?us-ascii?Q?vaV2destu++pRJFegx+aw8k0Q28Ayv7BuJRdlu8v3GMeiFPXQ4X9Kf3JaFtX?=
 =?us-ascii?Q?kTtSW9dWmJkqQTUb5/uuPXh3TgUn0T8tINU2h2+BywjG7N4U0anSpFICv1ty?=
 =?us-ascii?Q?KDKO3YzDJdABBTtCvcZ4PfvDrpXanZYfJs3RjDFCLzfRWgBRBSgYmKENpJuf?=
 =?us-ascii?Q?TxrhbFRs3qz15ejEg4pe9AC/hwaw2M5rL2Z1k++s1oVWvS9jyTK659JG9Svi?=
 =?us-ascii?Q?1n2awBT4hgE9ORXJOmGTjAHTJPk3X8S7NJvKKLFWp0QOZ7RGKKM+1NOcdPD1?=
 =?us-ascii?Q?dqu/hWa45uB4VWTwn55ob+Gq41hN4r159XalNhzY?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f74020fb-ef79-4f5d-d5bf-08dde1873b7f
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2025 14:21:49.3871
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CI3qBOYShmtU5RDdDroPQzfRfvcnjJH4NWjqSFx1F0GhSVi7jtTLRCWrfy2vAIOO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS5PPF266051432

--r2/z7+sXphrFiesb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

Two very minor fixes

Thanks,
Jason

The following changes since commit c17b750b3ad9f45f2b6f7e6f7f4679844244f0b9:

  Linux 6.17-rc2 (2025-08-17 15:22:10 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git tags/for-linus-iommufd

for you to fetch changes up to 447c6141e8ea68ef4e56c55144fd18f43e6c8dca:

  iommufd: Fix spelling errors in iommufd.rst (2025-08-18 11:15:06 -0300)

----------------------------------------------------------------
iommufd 6.17 first rc pull

- Fix mismatched kvalloc()/kfree()

- Spelling fixes in documentation

----------------------------------------------------------------
Akhilesh Patil (1):
      iommufd: viommu: free memory allocated by kvcalloc() using kvfree()

Alessandro Ratti (1):
      iommufd: Fix spelling errors in iommufd.rst

 Documentation/userspace-api/iommufd.rst | 4 ++--
 drivers/iommu/iommufd/viommu.c          | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

--r2/z7+sXphrFiesb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRRRCHOFoQz/8F5bUaFwuHvBreFYQUCaKh89QAKCRCFwuHvBreF
YVtLAPkB5MylMOj/Zed5r9VgYWY/DUbd0ywziuuQb99KLedrBgD/ZoYVX0ayVoSC
72j7Ttd15sNavBozOq3m3nHmN/QxzQo=
=V36y
-----END PGP SIGNATURE-----

--r2/z7+sXphrFiesb--

