Return-Path: <kvm+bounces-58383-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1ADCAB91BE1
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 16:34:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E5DBC1755F2
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 14:33:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90D03265CC5;
	Mon, 22 Sep 2025 14:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="e+wuw2FV"
X-Original-To: kvm@vger.kernel.org
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010014.outbound.protection.outlook.com [52.101.193.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D56CE262FD9;
	Mon, 22 Sep 2025 14:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758551618; cv=fail; b=SfUvG1EqGv9NfybtJPvhy2YbU1nait5+GypDfcKDFPNqPSmmMeYw9gA7vNKbkm0v78nk/bOJ1DGAWT+TRdHtor8+z7VWoOR91RYJdXP/IV/eNZWLkrRPBeQzyu1nphwiOAtosWyoYMyCwr6RIGJZEkUEV9i51w5JOiqUBJoO24E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758551618; c=relaxed/simple;
	bh=YZ36HE2YVTDTh+eaKufNyFz3ZLalg5lGifr6j5olRZE=;
	h=Date:From:To:Cc:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=k+TFkyhyGqVU9rpWnInu3Oe1pF/BPQkyWFP9pkZabyKrPUmuoKqYvpWzR420eRYowryU+byyxJI4ZvNN84IBgIKrLVV7AldwhJ90JQAZZcVsZrZ1vIHnOg3dvN6vgT2ESrXVi9aarT10+Nq3PtU2YD2roTWWprKNSrC82SWXocY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=e+wuw2FV; arc=fail smtp.client-ip=52.101.193.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KcI1qsNx08rzqiTMD1Aky4HWUJiwbrGdNq6dXtxTEON7F5cN0tCk4GTLFDTD4BNVn3a8cl485PExbSDGICtIYSsylL/u02zuO8HzFPBiTu+PId6tQMo6tPwqHLTmNXiiC+5ZwMGajTpW6gpIjjq3Zt6Sc2xgks1iaY9f73pBKIiuYop8mJPSVaBUUjV2nOZf+lgAKCdN0n0baG4ztaCKi/vYkBN/G4uyRC6mCgJw/a1P0gEVdT8TvN2HZpvSxpmVA0a5YTOgfM4IsYm1zrA+6HDaoo1Inf1b86cbzL15sQPwGKPBOuxm7fbMJiNrmrvkPPd4lJ+zJmWCJ8lussbuhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GaSsu/B31r9Cw5ktogkmdUs+68/K8UeEGi/smyv1+KU=;
 b=Q3UTt9wjCzxW7RCI+oxgsvVVkb+eiGqzvM3lXhU6P8VSpfRdKRZjDh8rAfjme8QbaHsjL7gTMyKfhse8a+bEeJbpN7sHLcPNcQYRGCjbkNMPKQuofAKFkO1l3kz03hnuAVwTIG+e/cFIYicitrzkjFBXes9f3TewsDL4Dx02qHCqSKxsc4m6QzQyfO9bTU5E7cMlUE7WbRyW/UI0AYIPWSoyuFlbd4xDIx9zWeSbNk7bg0U9iwgDXogcQWXBEK5WfWZq6dGs47Sg7l5iod5VVQI5ttStVDhp3axbnMA0JPh3CrG7U4ewKkePFjiRgHBNF7JgpyERDySLe78qxTpSAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GaSsu/B31r9Cw5ktogkmdUs+68/K8UeEGi/smyv1+KU=;
 b=e+wuw2FVP3SzNVxN6y8EiM2hh8U0XbGM15KVewLVhLhKroBvrcQtHAJzLMRkdrL7edMugxtb0L5CcPBZQf+HYW5Tk74R8U3/lTA3K+fA9mloCEZDScq765f7PPL4kTwTjjlPID1M0uNSgihCY7oeqey3Y7r92lbQ+rpz1pY3oiZJSmifrUVMkYLbeqEUgrfMsggdEW+IxyAmn67icYc3LeJUU8Q8qgB+wQw12laLQII2GQ7LtJQDVlhlvmaKr7m6di7npNXsxoPWsW9JvtGTc2q2A3HP9V1pzBoJPMUfiIXbPNDmL+DUudQ5/OujONAXYTRtOCCMaPsQKLiO7AJgqw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
 by SA3PR12MB7921.namprd12.prod.outlook.com (2603:10b6:806:320::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.19; Mon, 22 Sep
 2025 14:33:31 +0000
Received: from PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632]) by PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632%2]) with mapi id 15.20.9137.018; Mon, 22 Sep 2025
 14:33:31 +0000
Date: Mon, 22 Sep 2025 11:33:29 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: iommu@lists.linux.dev, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Kevin Tian <kevin.tian@intel.com>
Subject: [GIT PULL] Please pull IOMMUFD subsystem changes
Message-ID: <20250922143329.GA2529959@nvidia.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="7opgL0DGTY/ygqTA"
Content-Disposition: inline
X-ClientProxiedBy: SA1PR04CA0017.namprd04.prod.outlook.com
 (2603:10b6:806:2ce::22) To PH7PR12MB5757.namprd12.prod.outlook.com
 (2603:10b6:510:1d0::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_|SA3PR12MB7921:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ff918d1-7387-4887-5bdb-08ddf9e50087
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?FpS0vBTaOS45BIYKRYyFtb4AGxvqYcDmPoIdFRahCESGPEnHIEv6PTJnJph/?=
 =?us-ascii?Q?+S/vhrPtNkksSVmJ3p5t6YsYPl2xzdRZjfc0f6gbCRqxqMhTLYYKKeeE14UC?=
 =?us-ascii?Q?I3BLliUCmjrqV5TDUzcWWe6YWzoX+sR6G+GIA/jERkUHsFvp8f1E5gihMObW?=
 =?us-ascii?Q?6Hjaz+jnxFsSiTMhtuaYS94dzbb69KRDFGOQaxCocfmydhiPluiKc4XIS1/g?=
 =?us-ascii?Q?NY+IY6QVIFutZ2YgXP77KHvwN+4zObIZiKQ4Ry1xfnW/Hnj7ztoiM2GDNKfl?=
 =?us-ascii?Q?+XFqbGQurjkZs0HkIodioj6yibQg8g3c0c2WSX7KqduSSY/bM/qqkSa3SqTD?=
 =?us-ascii?Q?NJvryZMzgtaSXEMf2aCZsPhr4pqT0Q1W+YwUxwad1Fpak2XqAP9dgY99JM7s?=
 =?us-ascii?Q?IK2+NXVc6z29leo1GaIhX+6vqb+hgD+Xuk+mL1y7tY1x06DODqZxe4Now0E3?=
 =?us-ascii?Q?bAZxE8rOiFP38AbWUxuNZW/ZCEk/BJ6j9F04KkxUF4jlVCfCRcmgBZv5PI52?=
 =?us-ascii?Q?Jlf43U73Sauwi3MEeqLYOdNorWT+JjbpSwT0rNQHuhkz6YA63jxBzKhIFF7Z?=
 =?us-ascii?Q?9pF+gKABgbNQO1gjJjMC/j9RwadK//QeEbrA92X8T/YolHUwCWqzQqPqLUB0?=
 =?us-ascii?Q?7A4NpvB/ZJRPbVYHjjwZGygOqzfm94hpg7KqwRt4x16mVYRjT4QpnDEPqHNA?=
 =?us-ascii?Q?TRqovNMPaOYWroIpx7QWnX4NwUHpbRUKq8cEKgUQFmi9LKKqRl/hPqyqAsKE?=
 =?us-ascii?Q?+lgbPx1Iqtlq6jd09qY/exNm2cgIsUWa+3R/KKed4ZbpBl2Vuk4CvvXBAyLg?=
 =?us-ascii?Q?MnmvYA4QYCQjzisrKqOBESkcEzUAN13fpT5MYd+od/r/irx7DKXjotEVwMvH?=
 =?us-ascii?Q?M1D+xxEwHNkZ7TBlHerUcawDh8HNecptPB0epSo9c1IjwloxI5bUUTchOz++?=
 =?us-ascii?Q?W9URyI8DadhfJyZTCL0dSjkCooAiDwzL+tTgsImtRc6UGylYwEYWSa25Fod0?=
 =?us-ascii?Q?ngfFwE9W2zXtaF7NEBC8QVBsYpDhtHVY308vyB6E0EFs6n6EjC1ECjm/pZvy?=
 =?us-ascii?Q?n2aKu7F8FFXthYUgB9zLCPY4UvERqscPOAWbJrvcddJu8SuL/oH1jofjAswj?=
 =?us-ascii?Q?MFoevjVfw3mPhQKBvFz2xeH8nWnyYVxUHU00L+3vzFZlLop71oqJgqz56cmT?=
 =?us-ascii?Q?7UodHid5Ui8EBZ+brKcE/t6NmjjogeUM/TW6bdTzDLIsZaRe6U/yS3RMj6oU?=
 =?us-ascii?Q?KjarnrGXvwo1VPljCHnPbQhODoncaVeo02GrnPM671uGbY3wssfPf+ytKzy/?=
 =?us-ascii?Q?Z3lDUrb9FSwx8iWNCcUdczh+XY3V8qvwye8ypaEfG4hmcEvN/11IjwxpkIRH?=
 =?us-ascii?Q?K5X1eeHxn0tUVdawFZj4YUdPrA3QB6ARYTFXZALzakoW7ZT+PQCtJGmPaAVL?=
 =?us-ascii?Q?w5VwJRYb8J0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hJ9g3LCgUmOHDpS3+6ANDcyqdfRdl+6WY3Fec6BW9X69QvSH27D7KQSnwidu?=
 =?us-ascii?Q?jMz5tQ4cYgEaGSxmMLDbkHDNWVdFJxSaMqJhDLFSpZu4dL7ab9oOiw6m/kpi?=
 =?us-ascii?Q?14AR5hIZ+SgP6eqqx5UwAplAmHn/TiggkUkKrUP2oA846DgpylNvff4wUErH?=
 =?us-ascii?Q?45r/1Pp+yrpRljAgD8w546doB9s9D+VAbwB19WFWFmee7AFLUTC2DjCmKuc/?=
 =?us-ascii?Q?pH8r589rrB26Wsb2ULj038jqkzqE8Xu5eFGG5jZVvHM5hrHZsigWFrS6Bjt1?=
 =?us-ascii?Q?XdRH7CtJ3LHnpbh92WGyUR19noPxmkbZHxFQ3KPnIm/SmY1JeUhTIX0tstjb?=
 =?us-ascii?Q?/HQH8HOpqvRomPLvkzocjKTIZJoiLIoEBKRD1Le5iPYCkKK87XD/4avUu6NR?=
 =?us-ascii?Q?z5yI+YNe+aifPT/yy0bjt/2pds9FDOEpMAA7Fu/eUUiJRiphlNkO3deRqq+o?=
 =?us-ascii?Q?k5O4RV5EbJpSsWQMaq1kaucXB8qi5RxZ8YvWXgdzde21kegDW00IVCbbiJ1/?=
 =?us-ascii?Q?eQBT3gM9wCBLoWa8YcO/CnVrImKvUsvGhzt8GtP2IDwWTHIf8GaFM25XQLjb?=
 =?us-ascii?Q?kZwTn9NQwg1H/1lMiL9E+36VntgBYAGG9nD0qELGXUoPCiY/bmm1FWVPqn00?=
 =?us-ascii?Q?pGlmh+cLwyLn33Ecnove/TRt4610ubWIELGYF0BlyZEU/KQHpK6mrpIrC6rG?=
 =?us-ascii?Q?HWIw3Ah/kYixwQ9OZf1Mehyh36fYN5ZBqRjmb7S3wi3AucIVbnFiSs9aMzPq?=
 =?us-ascii?Q?Ln5sbr5Zz7ordTljrmqTUTyhkGwo8cnAcJ9uki/UUNGUKhJCm2UTvC4c1ReO?=
 =?us-ascii?Q?/QUa9efqPeRb/tUo+KLlnSMm3t14RLUBl8UWUYrI1SHLqtA5Tp/NsI3+OrNj?=
 =?us-ascii?Q?I/Tfh0l3MxzJsGs8pT7DYdY5tMQ8xinb+CFAYkvxxG1y7d79u0m8w7kl7Y+u?=
 =?us-ascii?Q?6fQdF/QKigrbw2S+s2ngRpXfhT2is//8q37jU5gmab0OlzYQwDEkhR4Fvq+m?=
 =?us-ascii?Q?r0BWBWJUFv67DYAHqzW6s6koHktBdnuakZjLXXU2MvX7XuT5ffM1A6fg/SYH?=
 =?us-ascii?Q?es16qkLVQMZWQPmRp6jUbUzZxjOL6BUqXYP0n6w3Oz4CclY4zL2Jo+i+p845?=
 =?us-ascii?Q?8AU+YXJCpHrYY0Y3fetFhgLd5zgKk399GtUBCZQGKsqf2NSR0ocxECfDi1zB?=
 =?us-ascii?Q?vwp8tWCW3BVp4KyUnwBx2/uKo+xUbzlvXA6nJ2layG064wNtc5BSDyF5/Tk1?=
 =?us-ascii?Q?MrzmZckPH6fDo/D0SowyTDO4RAiv0Hl6YMcFoTqP1P20ABSfH5wPhbObyyCd?=
 =?us-ascii?Q?RAU/82vQ6frHHo0AHR+wqoetuHPvOpRmiGjraLnhSnDM6BGuJQP8FcXKiqAB?=
 =?us-ascii?Q?V44XS2MkIMX6sldFjlFjKA5luIsdU4y6ot01TUVYKqUfD9ayFGhPYN8tQrst?=
 =?us-ascii?Q?3DeHIkgCHo98nPubfxGwoVI7qiQ5rGTeqqV8ZATIUo/MLDMtYzp32OFIQ+hl?=
 =?us-ascii?Q?9QwbhtEoeqVnXmFpt1FIh4TmIkG9vt5FoBj22ibXRPsTb7yb1ygHRcFZHGpc?=
 =?us-ascii?Q?MplEmk07XIM5rXY1xyBbzJkwtdReCLv76jknEBjo?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ff918d1-7387-4887-5bdb-08ddf9e50087
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2025 14:33:31.0291
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mONRvmTiKVz2qvOyxu/C3ivGyjwhIbaQSAPCdzwbMIc8w4uCLw+w1G0HqGFGyHcc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7921

--7opgL0DGTY/ygqTA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

Two UAFs, one was added this merge window.

Thanks,
Jason

The following changes since commit f83ec76bf285bea5727f478a68b894f5543ca76e:

  Linux 6.17-rc6 (2025-09-14 14:21:14 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git tags/for-linus-iommufd

for you to fetch changes up to 43f6bee02196e56720dd68eea847d213c6e69328:

  iommufd/selftest: Update the fail_nth limit (2025-09-19 10:34:49 -0300)

----------------------------------------------------------------
iommufd 6.17 second rc pull

Two user triggerable UAFs:

- Possible race UAF setting up mmaps

- Syzkaller found UAF when erroring an file descriptor creation ioctl due
  to the fput() work queue.

----------------------------------------------------------------
Jason Gunthorpe (4):
      iommufd: Fix refcounting race during mmap
      iommufd: Fix race during abort for file descriptors
      iommufd: WARN if an object is aborted with an elevated refcount
      iommufd/selftest: Update the fail_nth limit

 drivers/iommu/iommufd/device.c                   |  3 +-
 drivers/iommu/iommufd/eventq.c                   |  9 +---
 drivers/iommu/iommufd/iommufd_private.h          |  3 +-
 drivers/iommu/iommufd/main.c                     | 59 ++++++++++++++++++++----
 tools/testing/selftests/iommu/iommufd_fail_nth.c |  2 +-
 5 files changed, 56 insertions(+), 20 deletions(-)

--7opgL0DGTY/ygqTA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRRRCHOFoQz/8F5bUaFwuHvBreFYQUCaNFeNgAKCRCFwuHvBreF
YTVRAP9fHjLr22JN7DU9ObUQEj+gCOLkD1p3zqh23OaY3d03tQEA0ekQMrLsj2Lg
w4XkCpZWh3o3cLj/N9ALcgosP4ESGgw=
=VDj9
-----END PGP SIGNATURE-----

--7opgL0DGTY/ygqTA--

