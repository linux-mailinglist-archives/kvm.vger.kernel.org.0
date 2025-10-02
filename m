Return-Path: <kvm+bounces-59427-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E6C7BBB42AF
	for <lists+kvm@lfdr.de>; Thu, 02 Oct 2025 16:29:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 633FC19C3256
	for <lists+kvm@lfdr.de>; Thu,  2 Oct 2025 14:30:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81DBA31281F;
	Thu,  2 Oct 2025 14:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="jG736nCU"
X-Original-To: kvm@vger.kernel.org
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012025.outbound.protection.outlook.com [40.93.195.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1818A3115B9;
	Thu,  2 Oct 2025 14:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.25
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759415377; cv=fail; b=tPTjEXAF4U+n82MVix0byCFYlKeKSUY80/xhLN6Q+zfCdsL+KYTyreGO4aPNp1X+RQdfX2Ji97mZviAzxiKg2GRpKsBkHFQOQuchmKgQE4xZuow7sCF/gdqw02jK/EdCECUsI0oAWliFSRNUDT7wvrbcAseM8dkdeppSAtiB/FM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759415377; c=relaxed/simple;
	bh=mMtH00Ai0W35mBUTZXHWd7cnVsV8W/tiQajmpTHJdc0=;
	h=Date:From:To:Cc:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=ml5KZA+K1DaDK1f1qmGL3cKsky8PbODHe0CTvu2hwnK5ityIReLQZpguDhtHtQl4albLQOFA/oPIzFm8xihLgWuQwDU7hC4MbfNC1apFwsDVqVGmx8voMUfaqwjtHLqFOuKea++tzopHYfit4NmfR6HxW36k1X9DxJg2rNZgREc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=jG736nCU; arc=fail smtp.client-ip=40.93.195.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T/ZC4o+9Qf9a6tMglnWBp8agBFo7S/jCFGskDfEDQ562i3RNoP6lZSpb59TgY4WBBdhpQ0m6zOm8FLhnFGNMDBbiet1zVtBvS+wtr8AAgbdIXh22exsuAq7Jf5BkccwKYklLpebCQ/wr5iYiaUnlTY90n0ZpwcUFuqZo5zjtO0OSksmAIfnJ14fgdxNTULcn4BlualqDzvuC7E75z5YQ1XqamkoIxDnOai6S5t7a0c3qOjYLQC1RiWUUMcp0aTr3Mwx+oYZ3Pd5BC6Ai1UXLksB1itBwJVW7jjoVP/JCZtDhD5vAF6vyihN1DO8R9xjmhSmF5EKlGqL/XOQUPSWQtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8j9qiMysU+5HWD108rqkYEuT7EkAJ/dvEkd9uAJjjW8=;
 b=uuvzNr/P3b1MSxWVOXi8QuBM9J1gKkg7JRUKQz/fPM69qxRirTe0T+DeFs3hEctBaGzQw77vwRamybqIOl8SrlG6b3iFkTLaRWNMDOfiBlZQdY4LUhDUDMga2K/w6/D4YpYn10FcMn6dgIQIOgjNBrzK/TsBzkXjRcApW2B9D+aioQJ/Dw6quWtiq1Vb6hS65K0JAh2ks0AQ+QO5ec1fVDg1+6p/H1aLWxQwZGqmzeLeGu5QM67imzAbYIyUEhydoh4Y80tOF7nLkzGr64FZfXIA/0g8wMCXScE4BWHLm3MDZ5P5AObdOCgOQQF8rFq++jcHrqc7TPcPYiMkBP3+jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8j9qiMysU+5HWD108rqkYEuT7EkAJ/dvEkd9uAJjjW8=;
 b=jG736nCU7fP8/vdWLhnborJMDAg1jnbzG/6RXzQpUYK5ZFeo2xC5Sul1m/f+HHg49s5/w/NO2PuxrsvsgajtGc4/0iXzhshnbjM5wMVdftpFKBL3b8BN+ztWr9Qs4axV/r1qerqWI3lquSCrI4Ai9PAzIhkBkQDopFRrWIn95RIBQskdnK0gCG/3WH61PSnPU543U/j9fNoBPargmr+6y2VfxvS0HDolpuFCKUNzLMmg0sDrFIBtX4024H9G9yRTnORw3VAnI/nAcbumIgyVYQLK4rACBsncCbc975oMi2N4ZkZ+EzXODCiQb8vON9xSUXwqNb10RbQsfTM8OK3+qA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
 by BY5PR12MB4148.namprd12.prod.outlook.com (2603:10b6:a03:208::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.18; Thu, 2 Oct
 2025 14:29:28 +0000
Received: from PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632]) by PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632%2]) with mapi id 15.20.9160.015; Thu, 2 Oct 2025
 14:29:27 +0000
Date: Thu, 2 Oct 2025 11:29:26 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: iommu@lists.linux.dev, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Kevin Tian <kevin.tian@intel.com>
Subject: [GIT PULL] Please pull IOMMUFD subsystem changes
Message-ID: <20251002142926.GA3295849@nvidia.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="yr0u870fJ3mhXBrs"
Content-Disposition: inline
X-ClientProxiedBy: DM6PR02CA0084.namprd02.prod.outlook.com
 (2603:10b6:5:1f4::25) To PH7PR12MB5757.namprd12.prod.outlook.com
 (2603:10b6:510:1d0::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_|BY5PR12MB4148:EE_
X-MS-Office365-Filtering-Correlation-Id: 8294d9e5-16e5-4bd5-720c-08de01c017c9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?GBuT7zKOF4jEF/RmKuACa64Mx1bPkObW4Jw9Jwj1j6hytmqxkO4/87/4CcAw?=
 =?us-ascii?Q?tUCEQWl0T9bVKBDM/H5sva2Dw1OuAcrcDFo5BPM0EKGVvjo2iwPvJ3Yx7gct?=
 =?us-ascii?Q?0+5NAdiZSQJcgAnO4Wmwo9A3MaoQN4oW6AmspCYzxDOD/d7Chg7PrcvcwAR1?=
 =?us-ascii?Q?XkaXjlB9uxF1+jaPk1Mcqw1Q+tvM/mKagRpSusTOon6dsVKvdgt9bOw5R4ts?=
 =?us-ascii?Q?kMEF7eszL7LhH7Rj4EgF0yMPRqU/dd93VoHeKj+Y775zJelrkK3Mkujc2D6M?=
 =?us-ascii?Q?xj4hRLu4SuNxp6UMU1UGXnu26VXtySP7+VkWkTgjpIzpQxyprl2BIAQ0p6PU?=
 =?us-ascii?Q?RKLnPOcYzfDBDjF2nhKcRiVcpXNbM5CVWp8nlxc//9etN0QY79o4mMAjj0oN?=
 =?us-ascii?Q?OTce2KBJRgrwyoJidIS0YSrI4XjV5LEgNLJR66hXRJf9HAXCXsPaEYy/5lRJ?=
 =?us-ascii?Q?h54j6Kw7/xf66RiJoqnQLENFThk5/l66UigzQ7VR8EBWbKX09OM03IIJoPVy?=
 =?us-ascii?Q?D1cpw5L+fKsmc+4RSL8zaup+fDkvKRRWUAP+kLwSOYX14sX3P8Cfde7KeR4y?=
 =?us-ascii?Q?C0RIXWcowfHemP6RJHVLPDw++KUFE7noZ7+9z0uZCBmvPes52wxmhVuU3I7V?=
 =?us-ascii?Q?P5h0zB4cVT5W7aY0q6kvQF9CmBrCcGMaW2GxOMS6oeeUi+vX7vXWHyBH0QCE?=
 =?us-ascii?Q?oh561Jsd5hVNeUrGej4Bo6ogtoFbogZUunRYLRWq4sUe7UuZmBbiESzQzH3u?=
 =?us-ascii?Q?FlPNbvX4fQJthKC3vmMILg63jW5PK8Cv0b6HqyFlbR+Z7N6HlKtxitArEwei?=
 =?us-ascii?Q?XYtZHz5vMiTLe3P16uxbnCce9hG0IQDaM/hfoN/yy3iGXXtfqZ8SSPQxMBlD?=
 =?us-ascii?Q?buC7trVDu6VREo1VDCpFUs03EillyQPJQF/dX0FzrwlNZpw+HLrRdauvkO9F?=
 =?us-ascii?Q?/jE4j15VnbtdOXvEqCibznOV0QFIj6PiOKV/S2hVWlaJStfOzN3Zl5p/xAKL?=
 =?us-ascii?Q?q3Ngd69nl5ZrJjMvmUWBKzNf+Ld29ATGw1AHcNOq3tRxlkjVtQFW9RrljQcI?=
 =?us-ascii?Q?Vk3efjCGB5ok2wHNVyQE0lDj33qNO5zNqXiwy2y+mLeyzw+9Z1i66yVokQYK?=
 =?us-ascii?Q?6q459tJKwoctB7w0JEuU2VbQhDXwz9Kt23jNLMbhbPDP6b8KhxYdnELS/2LC?=
 =?us-ascii?Q?q4tRr9bvCrf7/C8Oqro8CzYKBTOTgj3m7gDbd6mXD8VNmbt3Pw7snfcPLnBf?=
 =?us-ascii?Q?2nGY+0wabJVqN4hzvLnJ7RAgcKiCO6a2jt+vPOBetTQWqxgCzBUgnRuGGfnW?=
 =?us-ascii?Q?ziQR7VqnOSnNR/mHv4ZqXdUyk3j2hY1leRwB4ypqR8LvDDInAhwCkwkn1pgR?=
 =?us-ascii?Q?5hoFnAD5EBN2BOkIhT+SnVJkK+VGnpcOQWaoRNGPRpsRRcYtOs40OUSPeTNT?=
 =?us-ascii?Q?jxKdPBztGmwf9PKiWRyvxx4YMZJDHq8E?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wkKuoMQ+OC21x5tTUmkZU+0LiomNK+xin92ZpEEWHrwYMGIVYh2rUWnYkQlr?=
 =?us-ascii?Q?+unxL0KSEEXQzTPYa1pLgq6dXkhIIMFhrgdyzcbYh5MfhYmQDLAU+F1L6K92?=
 =?us-ascii?Q?ubVNvKGK8NKbALmFFum9N4Gj4JiomxIphr2JMzx4RBAWBu3204Ij5tpCB6Jf?=
 =?us-ascii?Q?7ugSA9UJcUMK4jKrAQVxZIl6xehdIAsLgGZ1ftHga8q964s1m0XuRcHCUrdy?=
 =?us-ascii?Q?lcaids3gKqHK8WpM5HL48Ry+xCWicG8Wfu52hm5MjEcOAkppsMuwspqB4zhg?=
 =?us-ascii?Q?1MhAWhUcGbvO4LWH8+B4qJcWCt/VzbnETTqcxS98Lohygke6OtKlplDIqIeV?=
 =?us-ascii?Q?Jqi69LXGn2fT0K37wBFUKkamVvc7I3nLZ5HvdvK9b+7EWb2NPaWrdqPh40FZ?=
 =?us-ascii?Q?K3sI8hNVOcKmiJyohhdS3YbolwNakKgfUe0y3t9diT2j55WcG7/hsU6YHM1B?=
 =?us-ascii?Q?n30t0YygLZdZSXDnk8KfxnEylqmynV/a1w4gfaosXbcDmF2yCRSYXx6uPUSo?=
 =?us-ascii?Q?Iexu7DttGjETR+J5+V1M1wjlj/vc8i0bMupg6mDvby54Ud+BK6Gypohbadqz?=
 =?us-ascii?Q?O3SYd1hHHghiykG8atvu7i4k2tK8ddDS61YlzyPSlGDAVm/YDb2geHEPKGyu?=
 =?us-ascii?Q?7FIVAALJL4BmTt0eUMtGAZDALb+1MbwBNQSYw7OEEcxDaEnWBjPbrBq/RD/h?=
 =?us-ascii?Q?T2c/A3ztL1le8I/jmvC7V41md0Wb8XMGJUG2q4L3vhp5dqZKzdiYBGTER2D/?=
 =?us-ascii?Q?JOPeOzYbMeP8g28U6T9pmMinq47yApPWWXEw3uW1I5qfwtfIG9MlkX6iewQ7?=
 =?us-ascii?Q?DeFgzq4DA/HO0W0sFwfm+4f5rmGbQfUaBdFvuujqMNtsnPppcaGlVSrUxYAb?=
 =?us-ascii?Q?VslXcEHc4faIfG4ToCUFf/DG5H+OtflebO9GanyTkNphioi3I4X7nEmtYt/V?=
 =?us-ascii?Q?OBgQj5r4Jeo6tPXzRL912zjUYFoooFWWMHIv1tMoWZp0sY4w3yRyDigjmO+T?=
 =?us-ascii?Q?dVDJFmT3Qm2UBNgPtK7YKiQLa671rJ9RzmI47/Mu3GSbUh7cmI9BwbGkMP+H?=
 =?us-ascii?Q?uNCjwObdLXvUyT7+PyijwmgbdWO58isANG2IwCV1H5mHnOJBIUF70D/7LS4r?=
 =?us-ascii?Q?b3ybaAKGi9oRrgsVH/Rw8v5ZkGBuZiwyXOvTJbm6xgjYyCu9K7FNeFoad6l1?=
 =?us-ascii?Q?SWFNVLHG+TLVYZY5ILkPveDaiJgdfvbDHTzQk3S3uSKwn9lUjfA9Wgzvv0ih?=
 =?us-ascii?Q?FywUvMSkM/p++72H+WSxGynGpSF45RA7gln812FEj5T5ARQLXE82lXxhqFWA?=
 =?us-ascii?Q?HXE8DLtJVJcHeX+frOy2u/suoCE77LRt2t1zeo5L5vUO+uphjEDu1hNlr1fN?=
 =?us-ascii?Q?ULfkwPkPXZaEt6ca/hZOpzmkBujfqDVRJBPXmCYt8ctf57OLrAtVHM+vfQHD?=
 =?us-ascii?Q?8JaikCUy+ZbQy6MhNDpYjEJ2tOzcQZU+mQ75LUsufbGHLtouhTtbp3kxFFIp?=
 =?us-ascii?Q?7Q2RzMPqRCG6436inEkqtAo5nCeeSRQ+QbDQmmuFkvL02oebwCdBc19u0qdD?=
 =?us-ascii?Q?aRIBKGN/qiNC1gfFttfLZuKtx9GN8v9EtFJaovid?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8294d9e5-16e5-4bd5-720c-08de01c017c9
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2025 14:29:27.9135
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PWaE2/ywoF5bI4002FDPHLl7O4GtuTeqFrEdt0XVy1NI0GYhBs0XuPqGdHZeJwte
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4148

--yr0u870fJ3mhXBrs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

Just two small fixes this cycle.

Thanks,
Jason

The following changes since commit 43f6bee02196e56720dd68eea847d213c6e69328:

  iommufd/selftest: Update the fail_nth limit (2025-09-19 10:34:49 -0300)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git tags/for-linus-iommufd

for you to fetch changes up to 2a918911ed3d0841923525ed0fe707762ee78844:

  iommufd: Register iommufd mock devices with fwspec (2025-09-30 09:54:12 -0300)

----------------------------------------------------------------
iommufd 6.18 merge window pull

Two minor fixes

- Make the selftest work again on x86 platforms with iommus enabled

- Fix a compiler warning in the userspace kselftest

----------------------------------------------------------------
Alessandro Zanni (1):
      iommu/selftest: prevent use of uninitialized variable

Guixin Liu (1):
      iommufd: Register iommufd mock devices with fwspec

 drivers/iommu/iommu-priv.h                    |  2 ++
 drivers/iommu/iommu.c                         | 26 ++++++++++++++++++++++++++
 drivers/iommu/iommufd/selftest.c              |  2 +-
 tools/testing/selftests/iommu/iommufd_utils.h |  8 +++-----
 4 files changed, 32 insertions(+), 6 deletions(-)

--yr0u870fJ3mhXBrs
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRRRCHOFoQz/8F5bUaFwuHvBreFYQUCaN6MRAAKCRCFwuHvBreF
YWwhAP4xlOHHaM3YdxkbimxzWsVdw9/zu+GYbL1fR0j6PBu3oQEAkMLwqNJYWRQm
NLou/Sunpx0hN38H60EbrGtMY802mA4=
=hwlY
-----END PGP SIGNATURE-----

--yr0u870fJ3mhXBrs--

