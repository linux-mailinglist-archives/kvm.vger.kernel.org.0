Return-Path: <kvm+bounces-53750-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 23703B16686
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 20:48:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7D1DB58459B
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 18:48:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE6D32E3373;
	Wed, 30 Jul 2025 18:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="XyzJEsKr"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2057.outbound.protection.outlook.com [40.107.243.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E17582DE216;
	Wed, 30 Jul 2025 18:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753901260; cv=fail; b=Uqrc9c7f0ChARkuy0dxMm76kuRYYJaOEvYkgKCNsl+3vsGROlp4ZLYc6Ah0c+uTXdKk37i8HWFBEy8PxJErIOBzMkgLPXOSKIPEkTW0o2V/muMHoGz4kLA4W/7m32OOqjAEQddJ/D5+Eu7G+Kg5zz7b5lUp7EJCBrrv2EgBQAO8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753901260; c=relaxed/simple;
	bh=s/NGi+Ggz82XJRcxPj99AuuZXomS0FnJsY53WlSCBvM=;
	h=Date:From:To:Cc:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=DTIdArETGrf5KRR5TjlM0RovV0QtU3lLzpTbMORIncCKxBvRoMcxqEYnJKSFn07f3VQcai28aH3BcEhsh5DeHaVMkwEe/yhCeHbFi/05DEFKsC3A2G5mADOVevUMDL480WLhP5rgzediGdzSF4Iixy9vfZlhNPMuODhfigXVS38=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=XyzJEsKr; arc=fail smtp.client-ip=40.107.243.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N9s94PjdcA+FvJ54MYh/Y10h/3M9O2N5JGlbdXQ66gVpR+JgQ5siQIzU5994yA6dvDD4haEYtJCgllAqwW2Yw/8h104C1neXQCWD4VJNx5GNfDw0Rna7BaiBGYAPvzSyc5ZBu/GetyqyWMY3tYM1UtgjNRvKhOZAkBhHilxRXUDhwPgX+8jKXxpTxH1eiQLLYobUSyHLmXmMs7dQF592uKNX5trfrzrLIotvDtXBZDpRuD1eYtn5WKUx7F1w/I/rOJ22A3ls2C7T4IMlHdGZ+rxhhwsEtQuuCR+e3Q6V75HUzEFES842m99m8mwuSO/tjLjza3m4iw5hKGF7rPRxoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q8gUoUTHLdiEKTsSkZuQPRNsiPV/VFZO0gxZuwMxNyo=;
 b=EpCppppuAjEF5Jx8zcHDd3shRLIXeqMrUmKpvCoGgOuTLP4+f2pJTY1U0lk2YphhRrv0RH2ZbFEzYMmpNfVDaaA6DCoAkTEI7jZe7Dt6NSnpMh3bBXmmH4oZrCo6bGaqcA6jOG9TiPLoSp4pVkFnIlGxrXS+ZeHPhqvgfWx6S5xuAnA6YVUqTVl2RVDeEiI1xrKWVufKTftnhBkS9cXGcP4DwmCWpFE/dP0iU4r7cU9zuI0FhkbVGrJG1IF5TJ6GyIOAzC813bGl0U5Dcjm8LwQwo5kmnm0h6PHxVmbcmq2cLoxd3EzUI5GkkeoLFUVOgBtRpYNb7EPqe6mvz3Q4SA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q8gUoUTHLdiEKTsSkZuQPRNsiPV/VFZO0gxZuwMxNyo=;
 b=XyzJEsKr+oMnxNLXZKnNcZMSrfaHazls7Stwz3tyylaeqsk7CLBKZMBdonTK3oURjuupW8DHUZSkmNk0Ga86CsOop6g5djEfhmg/RJrQKNOnSlitF1Nd8qBjk6C8kA0lQOHGmZHHoZKgEtM/SN/0qu455b62gla06+dVx/afrUdOkD1HGHmcBnxtSZrUMEVBsHt2hn6pt6j3qH34+1P/cmk/PoQJHg01YpaTF9PzlumqufG8owbKlog500l9ZusP6/534GyX9vbjuz0R0gd1L2uszUZNLTE56BbSa3M4ChIkE5vcnAC6Jr0KtsFizM6L4NXo5a5TEqBXI+shnn7vsg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by BL4PR12MB9482.namprd12.prod.outlook.com (2603:10b6:208:58d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.11; Wed, 30 Jul
 2025 18:47:35 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8989.011; Wed, 30 Jul 2025
 18:47:35 +0000
Date: Wed, 30 Jul 2025 15:47:34 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: iommu@lists.linux.dev, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Kevin Tian <kevin.tian@intel.com>
Subject: [GIT PULL] Please pull IOMMUFD subsystem changes
Message-ID: <20250730184734.GA179487@nvidia.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="0fjC38bBwYZinlEN"
Content-Disposition: inline
X-ClientProxiedBy: YT4PR01CA0376.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:fd::7) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|BL4PR12MB9482:EE_
X-MS-Office365-Filtering-Correlation-Id: d90d9aad-9d24-4971-5978-08ddcf998ca2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?mCDalDtdwHQ9Oj1dm5NOSDSXXkH+iQFEo75InyYxA2Nzi5he4Ut2Uz2O1baI?=
 =?us-ascii?Q?p5OQnCMibxuFfmRl+69y5W7h3/oCv/HTiGMAFxeuDghLrHsHLaqugKkKE9M6?=
 =?us-ascii?Q?/3uF99ux9TYpijkPvFUa5jHUefFpJw3BlPfPIVCXKG0z/iydMYRkVWT+f8q3?=
 =?us-ascii?Q?vlhu6mBc7MaCaCosWnI3JYNUY5mYkYfQur5Bvc6XkVG+TK3iK0QsqqKmWqcO?=
 =?us-ascii?Q?jDbaSs29+JHl1tsSwQxMovNdMd+LLE6/IRb5UnjdGR7vpgRorYjXGiyXDWCg?=
 =?us-ascii?Q?+jS14rOO2q/TJIzkciG861AMxilF6ovIP8/wC0aJGpbjdvqH6iID0O9qUMdd?=
 =?us-ascii?Q?8JronORC5hk6HcE3Cs90zRVSfufk5XUZotuYHO3D3+Y0xXlLvZI+eqdzuCIg?=
 =?us-ascii?Q?ADy8GwGJF78u0sJQumnXEtC8LKQ2kWU06p8K5El42Tp9CKJnCRKcGn59+7c/?=
 =?us-ascii?Q?RoZq8jLyBlpsZi0pRy/XnUC66G4LnQErU8XxOZ/N7EVdITB/PGP6xb1k/bYj?=
 =?us-ascii?Q?QpqGSsVoBg5KPdF/vwd6reID2tb/B3PldDxNWaB+mWRruWhSsNRRW0p3a4Tl?=
 =?us-ascii?Q?XHoHnopeFPWtN2VSOaVkKJGlRNcnqAdsy2XDu6Bsf1xzdeLH0dm+ggvA4KaT?=
 =?us-ascii?Q?6rWOsAH0LqrC4Oj8DmG/8f7aUV1w7OOX177EvjrrsyB5Cp4i13v2cRfHD9/k?=
 =?us-ascii?Q?+X+qbhouOVyg2vKEJADN6kJBr4GpD6Tx8iTjsPkMlAlqLiUHj00fJWtB4voO?=
 =?us-ascii?Q?bxvbPyA0Kg068N9orgG2Av/Up15dAfnAKIIEZUA1CoN0YDVwy1KuERsdNinn?=
 =?us-ascii?Q?jlTnKajgklpmjMYgI14uY5KqD82N60z4VkKETK1P9mFbOh21wfPhb/5xFydL?=
 =?us-ascii?Q?j0MRI8+rFbWBzYr7GAjH/WU3H89oqqb8K/UuTjZAlXmGFRSAUviHz0iPFilv?=
 =?us-ascii?Q?YU/AwL6h4ljndCwxvUiCyAoSxKYrioDdskpXd4n80E0wwZHg8i0/a80BQ/L5?=
 =?us-ascii?Q?ciXzBX4d2V5g9+yP9fot0aRfnzWDQ+TQD0SM0s64+qiA4++/Y0pudMKx9gcn?=
 =?us-ascii?Q?0IBKFxccn2W9eLWT/VuqyqhaJCOZqF+h0qKjbZkzPvkp5kJ5BH6KxJcL8RGJ?=
 =?us-ascii?Q?MSVAUgCU43roiktWUowaTMRrkN1QrNqPTEmdD6EGYhsBwKoA/2tE3Ybq1oKX?=
 =?us-ascii?Q?1WOf2XO1X642+DelKx86Nbz0K3B43fwzS930nNeYf6wT1p+yIpmT0T7QlBAc?=
 =?us-ascii?Q?u7psOMuFX+DtdGp809lKO8LpyDlPhHqe2mNGV4ZXyXIn3oDq/G74IrseeZi4?=
 =?us-ascii?Q?pj9JQSPndNN9vOdUiuJXhIwvACG8EZsrG8Ac2fB0XIXU/PzLOMYxmASBHXGd?=
 =?us-ascii?Q?BwKt3Pjx8ylREoX8KBOMaZWqSWBTV0vzsrq5t9XmYUFgRMVEsos66ldvG7y5?=
 =?us-ascii?Q?5MY/juJOM44=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1qUIRtPbGZLeqVie4/InhgIxcz7MSLqclHz9vH+fTgn1l9h0fMZd5Pr6KHSG?=
 =?us-ascii?Q?v/vGxgMJ18RWyPP7pLoIyc6z17ORzaoO/TKkDKICX24H7JYCfngqMMKRLrjJ?=
 =?us-ascii?Q?yeqDneb19/nmRL9uQZsG22m2rFHiK+Coug2a1i38qjyLUZBrRx9hB3ECloiW?=
 =?us-ascii?Q?+bQjiVKTQR1lIcxjbk45ZI8DsP7jsJEbo5FvqJ2xrI0cPX8+DYrA4Pq1Wq2Q?=
 =?us-ascii?Q?5EJW6boW52VVVM38Z2xQfOlMyvn74eG07kFQoCBUT1e2FucI8pwfs1RRvz7f?=
 =?us-ascii?Q?woUkSevKOj5g6c8MuDU+PisjpaCGm+pUm+MhxKgMEZ+Pbx9AXJhFLa7f1iDj?=
 =?us-ascii?Q?gFpQb4MtIto9dumq/OjZEmxl/IoFt7FpzuJlo1yGRvqEapuvnr01MMRk3CKc?=
 =?us-ascii?Q?R6V9c59YqOZZpzNMJLEAjNs0BT0cRdim5puuJbUvjGDM72ZpkRiiwG68vh4G?=
 =?us-ascii?Q?UM7N+8W1GJzLR5sScJWTU+YUkdc81a099U+gZli1qPhJ4tB2bEMc41aKtvrF?=
 =?us-ascii?Q?EQQdOfZ6GxcClMxYMWajp+b9UFXDGfOUaZR5g4qfLRJPfbH8IbZoXLrlfLy/?=
 =?us-ascii?Q?nARO4UUaEY/PzTVkkbH+uLoy/1SM2yvLWz2n6xEhEYfpzzXW6KGXJS1MxOiG?=
 =?us-ascii?Q?oiaGCC1ygRmTJvc655WH4U48WOuEB0r5A4HdJJlfThRKtomROmcIO/npxCHL?=
 =?us-ascii?Q?vyQ+xaCrzYOqCM1uX/r4b9FhLUn3S2VDlYZu0MCFLi3hwahugKm2WElCQiCd?=
 =?us-ascii?Q?sIKDocGDI8AvxZB9XRZj3W1fIvg3jSP0kLEQ+gTBTku9kfJbEXYGYFzGBTiL?=
 =?us-ascii?Q?H3AHR19QNChEGRijXYVJ1kSem5d2C/bZ9EdAsA8oYsOfBioK2IIYPIIIoSx6?=
 =?us-ascii?Q?ekzDu2McUfYsW+NL/lwtozGusyszaMP+/PTG9U4lGfliXGuRXa1elNNLzIPr?=
 =?us-ascii?Q?k5KAKb0NQ7cJhGBMQFcINstf2X9RMNJzxaXCtbm2utWKf3T4W8JNPGm0AimL?=
 =?us-ascii?Q?ZRhzlfJ7Dl/PKSmgJ8qzjmiELVSXwuMGqYUSWXVfh/b6RpMcoFvpEs2dsCLU?=
 =?us-ascii?Q?Csyoqxno2ZJZ9MJZd8vxZ+6/CFZkF0ckXx9qEjl2KpdDoGwOrc9gQRc4sckr?=
 =?us-ascii?Q?5vcQICOFYwDB9Rk9pgjgwB9ipTtQFSwwUCgoxyUcJ6L713s6gBw/PV9Ygk96?=
 =?us-ascii?Q?tMHjbfBD5hzH4u70p6F/dgtkjC3rsUSJPU7w/OW4Rt5pDeJBYFFmvJQyDnvo?=
 =?us-ascii?Q?JldgN4yw72Y1pRgItZ0pSq0cZnaRb/xOkSYZ6GkCR3q+LupNIr6yp9t61CQM?=
 =?us-ascii?Q?0SyPJP/X375Jsp5+9jc7MlGyl1RYLSbLozbt6f94Ho/FIL+Q3gFZtSM2TkMY?=
 =?us-ascii?Q?uro36nGnxXiiX2Y4kLCvQEEc1YnZzEgWMe2b77J/cRhX5K+qH/BjE1Y3k3Hn?=
 =?us-ascii?Q?PMSCmkLaZeVTALZZyMx9VbRMoUv7vcMsnV8M+HCxmO4rbfKYuxl4TkM2K3g0?=
 =?us-ascii?Q?tsZ2LSY2SW0d43Ma1NQFeDW7YrRPCugGxGZvGdg30I+BtfuyTQIa2WYGJWwx?=
 =?us-ascii?Q?hitTLsBgRr2mELAqggI=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d90d9aad-9d24-4971-5978-08ddcf998ca2
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2025 18:47:35.5589
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QT7xbdMfU1c0AOE522SglldyFXNYwcnDXrKb2w5qYPzpvEPX8M9QDatmGTCx2AEj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL4PR12MB9482

--0fjC38bBwYZinlEN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

This PR broadly brings the assigned HW command queue support to
iommufd. This feature is used to improve SVA performance in VMs by
avoiding paravirtualization traps during SVA invalidations.

Along the way I think some of the core logic is in a much better state
to support future driver backed features.

Thanks,
Jason

The following changes since commit 19272b37aa4f83ca52bdf9c16d5d81bdd1354494:

  Linux 6.16-rc1 (2025-06-08 13:44:43 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git tags/for-linus-iommufd

for you to fetch changes up to 2c78e74493d33b002312296fbab1d688bfd0f76f:

  iommu/arm-smmu-v3: Replace vsmmu_size/type with get_viommu_size (2025-07-28 12:07:50 -0300)

----------------------------------------------------------------
iommufd 6.17 merge window pull

- IOMMU HW now has features to directly assign HW command queues to a
  guest VM. In this mode the command queue operates on a limited set of
  invalidation commands that are suitable for improving guest invalidation
  performance and easy for the HW to virtualize.

  This PR brings the generic infrastructure to allow IOMMU drivers to
  expose such command queues through the iommufd uAPI, mmap the doorbell
  pages, and get the guest physical range for the command queue ring
  itself.

- An implementation for the NVIDIA SMMUv3 extension "cmdqv" is built on
  the new iommufd command queue features. It works with the existing SMMU
  driver support for cmdqv in guest VMs.

- Many precursor cleanups and improvements to support the above cleanly,
  changes to the general ioctl and object helpers, driver support for
  VDEVICE, and mmap pgoff cookie infrastructure.

- Sequence VDEVICE destruction to always happen before VFIO device
  destruction. When using the above type features, and also in future
  confidential compute, the internal virtual device representation becomes
  linked to HW or CC TSM configuration and objects. If a VFIO device is
  removed from iommufd those HW objects should also be cleaned up to
  prevent a sort of UAF. This became important now that we have HW backing
  the VDEVICE.

- Fix one syzkaller found error related to math overflows during iova
  allocation

----------------------------------------------------------------
Arnd Bergmann (1):
      iommu/tegra241-cmdqv: import IOMMUFD module namespace

Jason Gunthorpe (2):
      iommufd: Prevent ALIGN() overflow
      iommufd/selftest: Test reserved regions near ULONG_MAX

Nicolin Chen (46):
      iommufd: Apply obvious cosmetic fixes
      iommufd: Drop unused ictx in struct iommufd_vdevice
      iommufd: Use enum iommu_viommu_type for type in struct iommufd_viommu
      iommufd: Use enum iommu_veventq_type for type in struct iommufd_veventq
      iommufd: Return EOPNOTSUPP for failures due to driver bugs
      iommu: Introduce get_viommu_size and viommu_init ops
      iommufd/viommu: Support get_viommu_size and viommu_init ops
      iommufd/selftest: Drop parent domain from mock_iommu_domain_nested
      iommufd/selftest: Replace mock_viommu_alloc with mock_viommu_init
      iommu/arm-smmu-v3: Replace arm_vsmmu_alloc with arm_vsmmu_init
      iommu: Deprecate viommu_alloc op
      iommufd: Move _iommufd_object_alloc out of driver.c
      iommufd: Introduce iommufd_object_alloc_ucmd helper
      iommufd: Apply the new iommufd_object_alloc_ucmd helper
      iommufd: Report unmapped bytes in the error path of iopt_unmap_iova_range
      iommufd: Correct virt_id kdoc at struct iommu_vdevice_alloc
      iommufd/viommu: Explicitly define vdev->virt_id
      iommu: Use enum iommu_hw_info_type for type in hw_info op
      iommu: Add iommu_copy_struct_to_user helper
      iommu: Pass in a driver-level user data structure to viommu_init op
      iommufd/viommu: Allow driver-specific user data for a vIOMMU object
      iommufd/selftest: Support user_data in mock_viommu_alloc
      iommufd/selftest: Add coverage for viommu data
      iommufd/access: Add internal APIs for HW queue to use
      iommufd/access: Bypass access->ops->unmap for internal use
      iommufd/viommu: Add driver-defined vDEVICE support
      iommufd/viommu: Introduce IOMMUFD_OBJ_HW_QUEUE and its related struct
      iommufd/viommu: Add IOMMUFD_CMD_HW_QUEUE_ALLOC ioctl
      iommufd/driver: Add iommufd_hw_queue_depend/undepend() helpers
      iommufd/selftest: Add coverage for IOMMUFD_CMD_HW_QUEUE_ALLOC
      iommufd: Add mmap interface
      iommufd/selftest: Add coverage for the new mmap interface
      Documentation: userspace-api: iommufd: Update HW QUEUE
      iommu: Allow an input type in hw_info op
      iommufd: Allow an input data_type via iommu_hw_info
      iommufd/selftest: Update hw_info coverage for an input data_type
      iommu/arm-smmu-v3-iommufd: Add vsmmu_size/type and vsmmu_init impl ops
      iommu/arm-smmu-v3-iommufd: Add hw_info to impl_ops
      iommu/tegra241-cmdqv: Use request_threaded_irq
      iommu/tegra241-cmdqv: Simplify deinit flow in tegra241_cmdqv_remove_vintf()
      iommu/tegra241-cmdqv: Do not statically map LVCMDQs
      iommu/tegra241-cmdqv: Add user-space use support
      iommu/tegra241-cmdqv: Add IOMMU_VEVENTQ_TYPE_TEGRA241_CMDQV support
      iommufd: Do not allow _iommufd_object_alloc_ucmd if abort op is set
      iommu/arm-smmu-v3: Do not bother impl_ops if IOMMU_VIOMMU_TYPE_ARM_SMMUV3
      iommu/arm-smmu-v3: Replace vsmmu_size/type with get_viommu_size

Xu Yilun (8):
      iommufd/viommu: Roll back to use iommufd_object_alloc() for vdevice
      iommufd: Add iommufd_object_tombstone_user() helper
      iommufd: Add a pre_destroy() op for objects
      iommufd: Destroy vdevice on idevice destroy
      iommufd/vdevice: Remove struct device reference from struct vdevice
      iommufd/selftest: Explicitly skip tests for inapplicable variant
      iommufd/selftest: Add coverage for vdevice tombstone
      iommufd: Rename some shortterm-related identifiers

 Documentation/userspace-api/iommufd.rst            |  12 +
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c    |  70 ++-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c        |  17 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h        |  33 +-
 drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c     | 493 ++++++++++++++++++-
 drivers/iommu/intel/iommu.c                        |   7 +-
 drivers/iommu/iommufd/device.c                     | 143 +++++-
 drivers/iommu/iommufd/driver.c                     | 113 +++--
 drivers/iommu/iommufd/eventq.c                     |  14 +-
 drivers/iommu/iommufd/hw_pagetable.c               |  10 +-
 drivers/iommu/iommufd/io_pagetable.c               |  57 ++-
 drivers/iommu/iommufd/io_pagetable.h               |   5 +-
 drivers/iommu/iommufd/iommufd_private.h            | 135 ++++-
 drivers/iommu/iommufd/iommufd_test.h               |  20 +
 drivers/iommu/iommufd/iova_bitmap.c                |   1 -
 drivers/iommu/iommufd/main.c                       | 206 +++++++-
 drivers/iommu/iommufd/pages.c                      |  21 +-
 drivers/iommu/iommufd/selftest.c                   | 207 ++++++--
 drivers/iommu/iommufd/viommu.c                     | 309 +++++++++++-
 include/linux/iommu.h                              |  74 ++-
 include/linux/iommufd.h                            | 196 +++++++-
 include/uapi/linux/iommufd.h                       | 154 +++++-
 tools/testing/selftests/iommu/iommufd.c            | 541 +++++++++++++--------
 tools/testing/selftests/iommu/iommufd_fail_nth.c   |  15 +-
 tools/testing/selftests/iommu/iommufd_utils.h      |  89 +++-
 25 files changed, 2436 insertions(+), 506 deletions(-)

--0fjC38bBwYZinlEN
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRRRCHOFoQz/8F5bUaFwuHvBreFYQUCaIpowwAKCRCFwuHvBreF
YZARAP40aSYxSavdOBWAA4ayr9OmMA/jbkOZwBFz8nNGMvBqMQEAxiQ2+zDD1ulT
e86OeEMKbUOhKqIzyREWI53LlVGf8AE=
=yIH3
-----END PGP SIGNATURE-----

--0fjC38bBwYZinlEN--

