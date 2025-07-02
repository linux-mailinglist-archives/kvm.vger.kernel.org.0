Return-Path: <kvm+bounces-51300-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BD5BAF5AD4
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 16:15:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0559D16DA1D
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 14:15:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AABF284B3E;
	Wed,  2 Jul 2025 14:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="LAIUfVus"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2070.outbound.protection.outlook.com [40.107.92.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A7A42BDC09;
	Wed,  2 Jul 2025 14:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751465701; cv=fail; b=uo9zxnBM9zOlMOCvlfvIjqagTHmKL2jJaWjPzzNs8ggPYLlt9lNnfSYzreMmQJH9+l8dffuqGicoBKbk1gNB1jLhvTugE0zmaZxjVUyxuH12mXwlcbSRwEhqd7BKofx4nn9h5R46ofaGke6wR8v2IhMTG8g/BMjgeIh9yBUXcuM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751465701; c=relaxed/simple;
	bh=CUJcf/awwZIRUrU7GBWO1Xrh50LGEIhoX2qkewulIdE=;
	h=Date:From:To:Cc:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=QC2/KOEySIYUGokR2scEm8zpTRGsvDSS7sWqpoOLeMLptO3jWBY81XziyboY3XeMkQtDhSI40kDkpsvyePJjcWNVHEOBsFCodrnxHmnQ0YvPbpO2NWzIdN2j0iXA3AZNT8oUczOT2xX6JtcssMpgbbT6rwoIAp69wqmlTipaqdQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=LAIUfVus; arc=fail smtp.client-ip=40.107.92.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S8M5PHI9PnPn6r/k1oALnWNWxvineIhHFhUVG8/I6oDp89V2hsYoehifOs2BHTMrZIlfLCyK4A5+ndTrzds+hjhkrcMvGVFx/gkLb3s6cxtJv1bFr8bx6sm+xOLP29vbXZoSOKxLpw65EEstpWtgezn+zdQXMx+bwPK+v7QdZlFDNfyM48u032a/8YrKz1SFJ83Y5FJJRuh+LDRM3aZxdbmGmcb9cO8pAb0LxuewlKIcbkt6MBMesnlV/QGlu/yOFcT+779Je0YMQqSIFtKHB/XHncxThpgbCxAIPPCazEpu8gp8NLFCCdkjTAeIt72vpj+HydnbmRbZ72pAnF1Kfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kdaOufJjSx1XcCUaKkaSdCC0BlFbhHCQe6G9g05jPS4=;
 b=M5wk88vqRg8YE1llNkf4684LGanc++JuyMx0yKebGv04LlDh+aIfRb4xTY95wG6OPptYr88sDC2MbxhkklXH/Mo/0QxjoHsgS60VAeweVozzjwypcrvD7ki+XW1roEB7cgjc8pQmoTv0mQVCAKcPmxEf6BPRdNjySdsP+fEhMg61UtvYjHWr9v6Fb19N7egCrbjC2vu3RMNd2tWWfE4NqP5A9q/MpXVwC4R/fL6a/KOWi3mNNU3aZGDf5xpzCiqR4Ehh/+FTnR7iVuRdVIQLdUg2UhFt6nZ2BHXOmU03JF3V8h0/fSte83UQiyKf/TSoNLwS/MnXpQ5UBwUEYYCFGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kdaOufJjSx1XcCUaKkaSdCC0BlFbhHCQe6G9g05jPS4=;
 b=LAIUfVusYfo1DfvUSnfV+e9qkqXWVzIyUcrhPWemD/U2NEs7IV6Bq8sWISHfKnjRzPJw54dxXnjDANwM8T3V9lY2rlapejb/SvOFcbhWRFHuAwt7ZiaD3FsuL8NvuAWD01kgQ6MAvduRLWmroIfq2eP2fZTsdqHro7XRf0D3RU4M+duVTRTDaj2Cw1YuYdeEOA0i8mQLP+CPVSnzNq0+GD47hWtXMpb7s1b5y6nEeUvb5qlaraBJyUR4t6E8ZScU3V64Fxjy6ZFhDkFVyRAa09Fberl+Y1QdnWDwtQvRQxD+irFBTYzc1+fOlOhIo+jAHR99Z4cHGcFpAvvYtWI8pw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DM4PR12MB6207.namprd12.prod.outlook.com (2603:10b6:8:a6::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.21; Wed, 2 Jul
 2025 14:14:55 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8880.030; Wed, 2 Jul 2025
 14:14:55 +0000
Date: Wed, 2 Jul 2025 11:14:53 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: iommu@lists.linux.dev, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Kevin Tian <kevin.tian@intel.com>
Subject: [GIT PULL] Please pull IOMMUFD subsystem changes
Message-ID: <20250702141453.GA1129243@nvidia.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="1XIgBtimj0PC800I"
Content-Disposition: inline
X-ClientProxiedBy: BLAPR03CA0088.namprd03.prod.outlook.com
 (2603:10b6:208:329::33) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DM4PR12MB6207:EE_
X-MS-Office365-Filtering-Correlation-Id: 31d9fb8c-6a3f-4364-6e03-08ddb972d194
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?We5OoetCjv+SOIAQAvLKW28+RCf4tBrSrAtWZfogmjssidepH51GnLZl7a2i?=
 =?us-ascii?Q?0epdHgF7i2odjNPKU9zeDWvAnbdXPWl9rCoDmYkyTI9Yp+qxx3tckwVBRpv3?=
 =?us-ascii?Q?2BKRPOM6Z9rPJT3C538VE1JdxQfEUv4k3m0wIqeiAXgCiF0vcGlVEgRacnIb?=
 =?us-ascii?Q?9xGqqNEBd5dYToClzK0JcjoX6jRtTkKMYkZPM6qF4rJN+yR902fbK+EUUAk2?=
 =?us-ascii?Q?Zxp5s7LCNLSJduQeKiqWZW3XK9U01r4/sf++C2txjuiv7lUFpGBDui30vUjX?=
 =?us-ascii?Q?8GAMvWEbHiS407091YyqSq7Dn5EV7qAcO8iCeCUzI/RIfW6UFIL6t37Y8k1w?=
 =?us-ascii?Q?EEkEf9cpuIMuoJ2yk68jWPeVBdSsaL4IqK3mrHNrp3I1fvRko+jMzJg6IeQJ?=
 =?us-ascii?Q?aKMsUBvGil74dZ16WdIbssf6CNZyDe0mExvOPc+LQW+lIg4Y3wPtKf3hkeKV?=
 =?us-ascii?Q?nsbQVHk+IEp2/4lgaWpcqtE5L3EIJgLeNMqrmHfMQWlHjKYDxz4iWvX2zdgU?=
 =?us-ascii?Q?2ywD6KiUFLr1ELN1w/9HLr18zA3VKym7RpQH8APcAl7husEYOfZEYCwUtVZO?=
 =?us-ascii?Q?RcZXYtl78/lfqvmf5r0Wybcaf1wh9rKeYm0IyqHJN4+K1TiGDCk2swaan1Wr?=
 =?us-ascii?Q?o397Dl3QftB7itux/388UVDrIC6Z5+hej+bfpTFdyEzoMhBu34Wk8KTnKg7o?=
 =?us-ascii?Q?3uRqbrrDmVz05IDuLhaAWzDzy6SovEIcpZrwBvieQNoFlYrDJtzrM2W8sXoq?=
 =?us-ascii?Q?Y9VJlQfgJdJFBJBaEHB4Yja9ECzZdbN/hfB6wE0FkUq5i3gdpAvr6F4b+jOk?=
 =?us-ascii?Q?AvALbWPdv05CR5E4uUBGkuo/Slmr8j6bD/NzBAYryYjYAdvH6ea3Ak32Z/eQ?=
 =?us-ascii?Q?YHNF/7Rbae2cQ1QDz6uSQJbugEe7Zwp+Tjo3EZZuszSSfb6d69TSnE97XPjc?=
 =?us-ascii?Q?MZtjqjJGtL0zoD2jum0aDiNkVRUFqyixuxgR2CFBGqbTCwLsJBgiAnLnwlxm?=
 =?us-ascii?Q?RyEy48SYY5Xrp23iuPPoCf4SANl2AM+hPWXnxXM2Glpc5gwEBbBWcSFkQaHi?=
 =?us-ascii?Q?DpEJK/opoCgRE9sos6Hyi3RrMuOnyh0zm8gYwtv+2FZh7Q1XH39Fnm1owO9H?=
 =?us-ascii?Q?2d6rOHBmbT3OEEunOmZ1CteWtNizQ96mbLWNf8JHtsIOzdDrHoeV5cmXpP5P?=
 =?us-ascii?Q?xtEuEEWp2C8Z8SysIHSAyRbXaVUxrh73EyW/cnuBByiiTXXbgZx8UbiW29c0?=
 =?us-ascii?Q?3l77+v2c4Jy2x/i09bB8tAJyvpuEC0XJqWTva64eKz9f3yxEW9unrz64ybZA?=
 =?us-ascii?Q?PLGqerjqb1CZ/aa2GZOCQ0thXYKnrCfh7mqgrfeiapiDjfHCONy66S0dmin3?=
 =?us-ascii?Q?sC3+OwH4o0HgoJ8dcxClmB00/7w56QqDFLFJcm0feQr45yXaaWgPf2thcZIG?=
 =?us-ascii?Q?pKD40jbsctM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?JBKlYaBa+pQJ9nihwgDAIumWgXHSF/Qs2r1o7WYgFSoC7L/BQVK2oA8LNq2W?=
 =?us-ascii?Q?35wCLnJ73e7XuSd4OoTyN7MLGZhtyKS5gnWu0e5JrcGRIF8WJOvuL15s+IHz?=
 =?us-ascii?Q?2TTCz0mjRCRbxTgLPT8GC0uEw6ou2D6QpT8WQIOD0Zk1x/gqeq13ukyFJOX0?=
 =?us-ascii?Q?Mdy5Y9UoBMHH3Qm/zPJyCo+demWlLVAyz5HeWtpmH909woSkWLv/C7dRptxW?=
 =?us-ascii?Q?LLLPZl1uaGCE0VpHBToZrEgUMi7jT/ik7LobbT/sGCK9RkOoScBrkP1Uy2zJ?=
 =?us-ascii?Q?qMscyRydjGXxEBlr2jP5JXZo21kqh5udVPaOk23ZPv3/PsW5Mre/JxhXGu1c?=
 =?us-ascii?Q?uGHypFoJjp1r15YRUOM4OSPBMx0YF90ZSXALd/CzvomkqdpVy3JA/JrSJR7p?=
 =?us-ascii?Q?CaheReE254FgRIX83u1zRjoMeKropPT/xMpgkV8PBYPDo1wLHrLUJOvfIZES?=
 =?us-ascii?Q?0FsNmbG+IQ9wWuvtRfb6tcSlDUiAjg+TrSkWpCWh1Sc64W5ICDkffNYoOMu2?=
 =?us-ascii?Q?3qX8MLtEgVyeDSqrz+3PMUn4otJMYyPsAuf2Rc5CSFFLnEe9ruS2c2/bHlGF?=
 =?us-ascii?Q?Ur4hIE9jQkjRi2Qod8swhfWRsqFGIC/Onwef/f3zeztfzOrDaM9HVjc1d0KD?=
 =?us-ascii?Q?0P6j28WNXl5D5n+FJE12qXlOOlLmg/ORhWTvq4P0ymi5RAvEekt3xShlmb08?=
 =?us-ascii?Q?p8ZyNKEIBooTEAzLxiW72b+Y0lYF5riMnW7pbvGLiKLyqHuc/xIe5Ku4T5WN?=
 =?us-ascii?Q?Ih1jSrA1SJaQczFNPDdBQPMvJKqEiEqZLBGYAHh+fzLCSk2/rA/pHwk5iSoQ?=
 =?us-ascii?Q?Tf1gAGLmoZJeIfVciwXLfsMhqN61lBd0DP/8AibAkWDJu1D/QRkWIMU3mx1r?=
 =?us-ascii?Q?iuuKTZFE37JNUqmY/e6LMebiano/sKy6JfMylGbcfx5RJGId9byQmxAqh4m7?=
 =?us-ascii?Q?mnyEBcoMd4U2CuhY8FKhc5iN/TxFmFeuZGPwzd8095dVBsC9MnpBk5WIEaxt?=
 =?us-ascii?Q?BbkR9NpAOeKLe8Esn1ZJrNZPAnJLFq77GrZtzYsqBivQ2nA3o6qr7XzMYshv?=
 =?us-ascii?Q?q1SjS2pI6DRWb3iXspyx9ygEe52IB1hSfOiVP4wXdVtKy0o1MI7QyJM+ozEJ?=
 =?us-ascii?Q?m24jUVbn/7k1rE6x8xdgl8RQ/sak/t3Y/Bk59C0Fb0ekCJ70fIYbFfz3cRza?=
 =?us-ascii?Q?S8tjJPDQbj9qQfthJSxlI1gy4OatVWznrQgV0z+PWY0sXbsIlR+DpU9UFC/F?=
 =?us-ascii?Q?Q8iRymkZnjbW/SOck5EJph/I1qaC+0GKSQxKjNCdhkvbejCZjnFLwJRbhgrt?=
 =?us-ascii?Q?IP8WPToVlz7FRD/ONBTftnASEaw9mh6/c15mxNa7NpGJt2Mx7f0rKmFzlYSf?=
 =?us-ascii?Q?FVWWHlzulNNWQgpXQpwm36rm/52KUZqv5poh9Y8yXCT5QI3TMMEC0JlNyI7l?=
 =?us-ascii?Q?MBVi4+Q6bPy01wkUKAQmG7ggkxBqqaIw/hxHS8v5UzWeVm5rPs62ZrfNyB6d?=
 =?us-ascii?Q?4utSVxnjKj3sjOhPylAxVNzSc89i10/xsXCmF3dTG7JYbawVTI6FqcYiqjbE?=
 =?us-ascii?Q?cQG6H5bo2v+H24wF12Q=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31d9fb8c-6a3f-4364-6e03-08ddb972d194
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2025 14:14:55.4152
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kBrJt3VGOye4XgGOSkmOhuX37WGEY2MiFNXGew785Mbmqghs/+MNpHfONiR5es3A
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6207

--1XIgBtimj0PC800I
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

Some small iommufd selftest changes to make it work again in 6.16-rc.

Thanks,
Jason

The following changes since commit 86731a2a651e58953fc949573895f2fa6d456841:

  Linux 6.16-rc3 (2025-06-22 13:30:08 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git tags/for-linus-iommufd

for you to fetch changes up to 9a96876e3c6578031fa5dc5dde7759d383b2fb75:

  iommufd/selftest: Fix build warnings due to uninitialized mfd (2025-06-24 15:45:13 -0300)

----------------------------------------------------------------
iommufd 6.16 first rc pull

Some changes to the userspace selftest framework cause the iommufd tests
to start failing. This turned out to be bugs in the iommufd side that were
just getting uncovered.

- Deal with MAP_HUGETLB mmaping more than requested even when in MAP_FIXED
  mode

- Fixup missing error flow cleanup in the test

- Check that the memory allocations suceeded

- Suppress some bogus gcc 'may be used uninitialized' warnings

----------------------------------------------------------------
Nicolin Chen (4):
      iommufd/selftest: Fix iommufd_dirty_tracking with large hugepage sizes
      iommufd/selftest: Add missing close(mfd) in memfd_mmap()
      iommufd/selftest: Add asserts testing global mfd
      iommufd/selftest: Fix build warnings due to uninitialized mfd

 tools/testing/selftests/iommu/iommufd.c       | 40 +++++++++++++++++++--------
 tools/testing/selftests/iommu/iommufd_utils.h |  9 ++++--
 2 files changed, 36 insertions(+), 13 deletions(-)

--1XIgBtimj0PC800I
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRRRCHOFoQz/8F5bUaFwuHvBreFYQUCaGU+2AAKCRCFwuHvBreF
YRIqAP9Y8lOHEBBJiqP3S3OpCP1dqgszhAh0iqJhfXVyJaPwCQD8DgtXZXbhNqYU
vnn1pXxw/8kgg2FdW0N5aSEwrfPvMwg=
=Qi1Z
-----END PGP SIGNATURE-----

--1XIgBtimj0PC800I--

