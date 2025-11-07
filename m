Return-Path: <kvm+bounces-62346-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 07D6EC41573
	for <lists+kvm@lfdr.de>; Fri, 07 Nov 2025 19:52:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 285443A0666
	for <lists+kvm@lfdr.de>; Fri,  7 Nov 2025 18:51:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6C7B33B6EF;
	Fri,  7 Nov 2025 18:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="NsW72qw1"
X-Original-To: kvm@vger.kernel.org
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011029.outbound.protection.outlook.com [52.101.52.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20A30235061;
	Fri,  7 Nov 2025 18:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.29
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762541505; cv=fail; b=OuFy5XiFcl2pcW6POYlfS60CTm9Z7aujh0AUoHo/6P7KxCy1OIerNDzLm7+eolsM7AV/3k76/ALQV5W2/Gbg5eb1OJjG+prXbh5cvIz1JAJZpEWj+9rWwdquKFDsMmOzr+Rvh/QXTRhMJy3PcmqADT1NvamjCXZndI3dO6gfWE4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762541505; c=relaxed/simple;
	bh=ILBvesQ9W1MUeN1U0jmLwa0lxscbjdToYYJv5MRsZuQ=;
	h=Date:From:To:Cc:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=Vi1ePtLUmfSr/+zUdOswUhhH0VzzA6zOylqMggm9ogOokzOZdTWKL8z2xkm4bz9EpwmChmWcIcr+ATSpStrcckRViZVqSPdxm1cgiAQLkzEKN9Nm1qRB8WfmfnoG+2s3ApJhByqaaT8Sh3syyfJ8np8SijI/E1oG4LCpqiF/yxI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=NsW72qw1; arc=fail smtp.client-ip=52.101.52.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MeVlklfcAcX123SZGOOpoGm/O7DzQx3LkLcgS6S1e15UHHpT1d1oCO2O/JpyMbDLC30wiktbvvNMiS0l/FewS7OxFYyrSVYZQaZLmvtNagXx5RhF/CLkDv2ZSgFnWHL9eqs7SWHyTQS0b++bIQmM1Uc3YMC3vBESOGQqkJH7wiSBN57chlClwaP9eoAHFtEdN1/gamYYe2nCBCqWpRm8rwSWKZqHGBvFQKqPIWEUbeeDEjyE8nlQhXBhiL7ftARiUbXe3UJVD/UjNTcD97+CYlKfB12/IW+0EhIKH06e3YB1OOZKKGgXGvakWaYzyOtb7EsJxD7b12QcuafTp+045Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZCboiBahYSLrx0iHNKYS9KPlh3byOnLh5Jn8W4yjhFI=;
 b=rsSyGH+xqaFvZMZdA1XsuLKkXDNhZgASwcw/KiY1wopNZaFpzt63HTpm30qgloSIM03okjWV0D/nw2eu3Y3ej3eft3JTqX+gNoFc5M3/xWM60pMc6x9v1XQE6O8NN4KRrP5pgOIIV/nqtlpEls4VC8BE6Ru4g/aZDGYVY3sKWpA0s36A5ZxUKxIqk8Ily74LIuYl/OBszPgaRJg6ujqUNOBcFkeIRWqAXcY4xgOjOrSggKV+M94KK3LtNlaeGpNlRzHgpbUxFzcMw2eAyzUyy3M+RIeA7snS5EQAbcW+9lWlM1EsYVqccCadLot+hM4QT0gHTFdL8Mo3HYNaV4JunQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZCboiBahYSLrx0iHNKYS9KPlh3byOnLh5Jn8W4yjhFI=;
 b=NsW72qw1e+ZU1tNhN3sxKheWiAE1/tAHbQMcet4EzbUF5E7lYeWL4+9ek1UleX728BZpXfip0aZVlSw9ErJTw4eXCx3nkZ1X7ht3/0O7myLK2UkjEI180wIVaTE71VzkQbxVgJhl+EUnc70Kzx8BU4hJZTkaS+r07cYhWM4D41MXVWZSZSRcb3sr3/TbA07t3kg5MFVREXLxdlAe79Aci5X+mQL7nnCCoFTDdTS3T8+mFzsqxJYVQTEoqEtiEpN2/z0K6e76KB9MbmbXQmS+p/xO9j/HTJJ0YJDzswvXJdij9zN47amFk4+achCfCnsTB6f4GxGxkGxNiy1Bx5ZMHg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB3613.namprd12.prod.outlook.com (2603:10b6:208:c1::17)
 by PH8PR12MB6841.namprd12.prod.outlook.com (2603:10b6:510:1c8::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.12; Fri, 7 Nov
 2025 18:51:41 +0000
Received: from MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b]) by MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b%4]) with mapi id 15.20.9298.006; Fri, 7 Nov 2025
 18:51:41 +0000
Date: Fri, 7 Nov 2025 14:51:39 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: iommu@lists.linux.dev, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Kevin Tian <kevin.tian@intel.com>
Subject: [GIT PULL] Please pull IOMMUFD subsystem changes
Message-ID: <20251107185139.GA1981854@nvidia.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Dn0LNGvkx38/FUYR"
Content-Disposition: inline
X-ClientProxiedBy: MN2PR16CA0041.namprd16.prod.outlook.com
 (2603:10b6:208:234::10) To MN2PR12MB3613.namprd12.prod.outlook.com
 (2603:10b6:208:c1::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB3613:EE_|PH8PR12MB6841:EE_
X-MS-Office365-Filtering-Correlation-Id: 00f66bda-8368-4932-b901-08de1e2eb016
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?5vsprA2i7J+Ins5zbXgSVSABuoHO3qFEvX/PwkZMX+3p4RIkBSua8IQ0UQa+?=
 =?us-ascii?Q?OCkKAETtaogUh/sLJZij7KVDYvB5J0ksOohCJ4CuOaRPXEIbe4q9DZPDlLXK?=
 =?us-ascii?Q?8pD3S8hPRDwkyi+lI/w3QT700FoVs8cVOkVuubcxEYDc9jYi7JYGOROdgY0B?=
 =?us-ascii?Q?pLzJSyOUmphOmPQZunog9l4TKzFlDh869XTY78jFGksArZz8VKZb1hU6Vi4Z?=
 =?us-ascii?Q?K1X8VfbaTru6yTr4yMQUpHLIY5ffnCCZRh0Zq9Dh9tsm8+GTCzuNfLUs8VsV?=
 =?us-ascii?Q?hOAbE49D8cxEHj+OLpWVC2Mlqxe+Oeyhc2U1xoOz54C6+fwwMiEGqyP4Gbwd?=
 =?us-ascii?Q?Kk4INhmUvQmK2gWD4MtUPLmNuqFz4WYnje+xC3NOd6nB9twaM2baX5ztfDyA?=
 =?us-ascii?Q?siDMcLTs+kFl65OuRoOxzbz7ZUiH6WSkR5QPRhejWNHLUwguf52sT7Rqz+lx?=
 =?us-ascii?Q?OAea7JaMAlvF7uk5icbRozN5bmeQWmEX+R+kYKrqca6V9KT0v8X1sI54LYWS?=
 =?us-ascii?Q?qZbNDvnrMYJSNYtvoFN7zBR2N5idcrM3FrTkMcoYX2hkR7cz7+vGnptvnDKY?=
 =?us-ascii?Q?vtewE62dvF/5YIH0pQBvAMZ7CvfONYBgTQhc4+HXk6LqLNU33/4M4y7sV8w+?=
 =?us-ascii?Q?LJjV8sC3qoTfb9Knz4Rf+oka/nEac2RwR3A+vkjvR3Nep8Z87+3cQ2hGYlyU?=
 =?us-ascii?Q?vefnj1Ct/5J0j1jcRuK7g0wWRcGPhJtApnEQbA/pTz3B+1Hyp7LAIelF15s+?=
 =?us-ascii?Q?t9xBerjTY0lVWXevwbgr2x6LkehDtO9/ZuLC39zCMT0yS7q0G4Pu394GZgVZ?=
 =?us-ascii?Q?9RG+F6vFW25PYFO2+YBOn23uto+ms+dDpkwMbmO/CPcPM800+UwSlDcVWgwk?=
 =?us-ascii?Q?2jICrsSN0IIJGbYp0IckQBmaVpLIv2csZGZdDmlqMRn5+ya1YgiaRKWuywMw?=
 =?us-ascii?Q?KBh21Cb5pW5TevgBczEyWyXlGKVK0qrqVyG9/tUJE407T/iKv3csXAzu3hd/?=
 =?us-ascii?Q?OBVKC9hNHwvfcEZmIYyISYotmrhqXTZ4l4PuTpeHf2ngmAf0KyovAX+Vla8o?=
 =?us-ascii?Q?XSGoVj+fUmNYQ6Ufuw/EOxrzl4CVP2dlAjQzdeXW8PgIupMpcIfXEI2FBm4L?=
 =?us-ascii?Q?mM9UQI7NEqQwGIwF5xLMKYmdfptAv33zrpCE3BllyLTHuu+/fTMVTv5AH+30?=
 =?us-ascii?Q?/+ngnIb5akqf7vBNJYIDGPsRaJN5m2Ke50Sy3m59nBpJYHiiSXreSW4yPdVb?=
 =?us-ascii?Q?erRnotZUSMGZXx0bsdprRcNDVxYFkqLzqh1tOLU99NsXugJALq6HKM3KxLaC?=
 =?us-ascii?Q?zRUPpRXvQT5UCmsvOZcayz77EygEApmvtRa6s2akeX7oNQgA6x7Tvfdhurdj?=
 =?us-ascii?Q?7oAGqdP+3VmU3LjJVCq4BiWmaZ27DrNUTBQPGP+wpIN06HXNksoLdZM5um9P?=
 =?us-ascii?Q?o5MdDMZD4Rr1Rj51gza93MlyLXhD4oN6?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3613.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?VDZ0oiqd8++gj40/KLdRFKPjQgVaWgzO3cSGaOkTyPRD55gfXDBRLbPyERFg?=
 =?us-ascii?Q?nJYXBwP4EN02Lpf44IWFzXP+63DN6l9tSV5yRHs+89YZxjpQR+YEBUk2nO91?=
 =?us-ascii?Q?ZTEycCFv3PAY9q2DNLcj+USKaF7IGgP0Q+SfxxdvxC1yyC0ozmatyW/IMDVu?=
 =?us-ascii?Q?uiz4q3rJdJIo+LoVOpzt8gXPaoM6Nvw5wNFnr8TB76cU+AUftot29cV3SI8S?=
 =?us-ascii?Q?X01PgWpMD1Cjk2X0wWsIY3cz9pZarl81ioOzptLhMpS2sorgLK1PPvYrtTw+?=
 =?us-ascii?Q?5X3SfoWIYWrc67V2WrJxSazednrfo4OYxENcrlrvevLlQo2D7q77PpZI9O3O?=
 =?us-ascii?Q?hKILTIDyiopoYbrINkkvr3yAupprDgg0Ak0iF0hqqfd/vLNTOWPcTEZvq4Iv?=
 =?us-ascii?Q?3pe/4f9KMSKz3q7VxAOV+QbtNmhf2WlKEnUoOwd5WhuswkoEAKBb5e3cTVeF?=
 =?us-ascii?Q?7pMHUzg8/Mg+2lUzNO7ghvMOGIKqArWzSXu2HawT6sYd6fOAtGeiXk8MN1KY?=
 =?us-ascii?Q?hBSaNWpe0MX3eDriV2aTuBf/DTUwRPhIYPBue/nugr1Wl8wzfUOtodSY4dj4?=
 =?us-ascii?Q?Q1uaUJe9/uNfyxSgRN5uvTeY4HFNpWSOkYSbnLdQp7lHlvzI6uKowt0Pl7bM?=
 =?us-ascii?Q?UkISwdgfobBJXK30GMA7ubZ3Q13hJBi8rdXb8uDohe1gKmauDCgR+SAbVfDa?=
 =?us-ascii?Q?OlDI9VrenvpbPLzdMqN9ks6lLOLwY6Ma7kogQjctZ4ZPEvyFdWSH0hcG4Sdl?=
 =?us-ascii?Q?hpehzwZb0Oizr4QKJUZj7H22me87ctKAc6eS+SSzH/QGKjGhEC+fLJ9HnE+C?=
 =?us-ascii?Q?60UU1zJlt/6Qj8gZOewcb/oNKm2Hnv2mDa2KW+r//GQAbDoYTfQ83v5zdlst?=
 =?us-ascii?Q?hqzh42HnsqVDALsQKRQBI8zStH+IDZNnpvrVATfkDx+38690f/QwkzmDwsUc?=
 =?us-ascii?Q?5eJvl8x+XUQsuJSvRcUb1UUaZTYDwgKwD0g4yIRAWzYFU1sxN7cZ86IL/qAZ?=
 =?us-ascii?Q?v6SGik3YNIkb55zU9WeMEKor5wpRSi9j505+9eLw+UhgATSJMVImvOVJP2GI?=
 =?us-ascii?Q?WoidOzxgzL9g55QAU5RufpQ7xZg2fHiJP/6dvnS+pBJtsri0iPRb36t/SEKK?=
 =?us-ascii?Q?L9MIdE/aJ9MXQKwV3PxvtPFFblj0sIDjlfXJ1EFPcHDUKkOQiWUYSuYJdJT7?=
 =?us-ascii?Q?Kl9GA5pGfTEoJIy1VGiZwnMH6/PnEyowuPKI5tASfi9nFBB7LsAybbbIHjAT?=
 =?us-ascii?Q?aUdZbv46SY7r/aB6o1pfNTLbXz/exzRHGOSwRRWbg1DKJ5teZ4/qfLIcAExv?=
 =?us-ascii?Q?8skGA2ACxVkH0XEBGICgipKxiOT+0mCVfdm/fdqvWdtHyv3xnoo0u8fgKQ7h?=
 =?us-ascii?Q?OEun5uaerKTyUA9FgaLs6whSM40PdpakfPHdJCR18q7ZTXg6EBT7P0HTHKQG?=
 =?us-ascii?Q?HMKK7e0/YIdIMoK8IGli25cUqgqRKz6BjjKzHK/e80QVl51mWj+JeCBJlzT+?=
 =?us-ascii?Q?IgphqOsONoRKboA3LzQlcVUT/iCY13Q3DUvTl9rgyJ3Jl9tih2X5mEmyvWWi?=
 =?us-ascii?Q?MdH90HKjZOE7zIIzZpU=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00f66bda-8368-4932-b901-08de1e2eb016
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3613.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2025 18:51:41.4002
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 64hRnuznjIPtvJBr14BUQLA2xXgo0ty2IwLIECFGt70ySVWEg7ZDNLBfOxTpZahc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6841

--Dn0LNGvkx38/FUYR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

Three small fixes for iommufd.

Thanks,
Jason

The following changes since commit 211ddde0823f1442e4ad052a2f30f050145ccada:

  Linux 6.18-rc2 (2025-10-19 15:19:16 -1000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git tags/for-linus-iommufd

for you to fetch changes up to afb47765f9235181fddc61c8633b5a8cfae29fd2:

  iommufd: Make vfio_compat's unmap succeed if the range is already empty (2025-11-05 15:11:26 -0400)

----------------------------------------------------------------
iommufd 6.18 first rc pull

Three fixes:

- Syzkaller found a case where maths overflows can cause divide by 0

- Typo in a compiler bug warning fix in the selftests broke the selftests

- type1 compatability had a mismatch when unmapping an already unmaped
  range, it should succeed

----------------------------------------------------------------
Jason Gunthorpe (2):
      iommufd: Don't overflow during division for dirty tracking
      iommufd: Make vfio_compat's unmap succeed if the range is already empty

Nicolin Chen (1):
      iommufd/selftest: Fix ioctl return value in _test_cmd_trigger_vevents()

 drivers/iommu/iommufd/io_pagetable.c          | 12 +++---------
 drivers/iommu/iommufd/ioas.c                  |  4 ++++
 drivers/iommu/iommufd/iova_bitmap.c           |  5 ++---
 tools/testing/selftests/iommu/iommufd.c       |  2 ++
 tools/testing/selftests/iommu/iommufd_utils.h |  4 ++--
 5 files changed, 13 insertions(+), 14 deletions(-)

--Dn0LNGvkx38/FUYR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRRRCHOFoQz/8F5bUaFwuHvBreFYQUCaQ4/ugAKCRCFwuHvBreF
YfsCAP9xZ5OpqyRMubv/NsgG0b15DTvSW09r6KBLzA/Fb12zIwEAh8q2QP9Z9OZj
L/x8XRQM7XlYCXhoetGTIMCYJJknwgY=
=iPq1
-----END PGP SIGNATURE-----

--Dn0LNGvkx38/FUYR--

