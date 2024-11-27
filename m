Return-Path: <kvm+bounces-32568-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 96F979DAB31
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 16:57:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C0159281EAF
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 15:57:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1D16200134;
	Wed, 27 Nov 2024 15:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="tfdu3+wD"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2051.outbound.protection.outlook.com [40.107.236.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EC8C200117;
	Wed, 27 Nov 2024 15:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732723043; cv=fail; b=qztKWpNR8FnK1qn4FdrRIbfyWDIQgthGBY9wGi1QFEWNuNXjv2mSyDnJNBRVg2IHOJeSmAt6fnCAQIazYoMeSZlF+VNFbfMnNvCP+JjQOs9ECBTGMlDMubKMYdedPEih3A4YUjXZbE6b3ZnxELR/o9jFs3wllP8JV2Kd0f6Fjog=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732723043; c=relaxed/simple;
	bh=xj6vP0+/7cWb+Rk3UcySeIYpyo31n6rg1JhdX22h9RI=;
	h=Date:From:To:Cc:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=OPGLEBpRZxAs9ojZf6PZezLy58eFkkie5NvwIYJwA1PRwesyaWvIogbI/EjbMG/pEDiE/+5XufM2Wn2EFHJfVUZEjbs5wo5K43N5HG7wb0GRXZcrh/WOJ7+4w3dq5odNktSmVhp1MkIA5lkYAlejakpGZYQeDndSfmAI6cQ+XFs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=tfdu3+wD; arc=fail smtp.client-ip=40.107.236.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PFW6KN2Am+gcBjLl/TAuQL9xUA5QDfcRlW7Y3LQZ+77+QvFFGR8pS17q5CBhfvw1PBJ8xd86mhfE3zCw0RjUlrQF/fylB/iNRI8cV3DXIODgAbFNMQ/zx33pjGDiM9yPRcbzl6CGvPkt2yBZ9tY/9mcQA6b0KS/BMTHODoL9PFdmhZHIQAPQdb3Vqb2SGShKeimHJCHONnwkwLGzyYp/cRdaH8L0SkPAEoDR5+SPkzBY39743Q2sL2Leb78XMeCZUcqhWavRKAYML7CbDKWhF/hQdILbhyGYXKYThL8SeVWB9ipL0B08vwLs7qKg2QOExS9dySZKkavPLx4HD2kW9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EIBk15kSSVTKJIIhbnwj22TCGQSp2+3S6eHHaHHNKOg=;
 b=tsTw51hJkO4yMCk3OcUQjauIz/OlaZnesz5oq7uH9UoliZkoXevM471hNmN/kkaLxYoq21KAyZuNhZAlf/SceJhsIidpzopMIc4Pwf2TNo5NvJWhb8Qq/bS6wmg0RFkqtluFCRqePH1jGB/pzn4dbJfTznUBR2xYdGVG3Bu88fqn3/HW1cgA+Wf5GJBp+ZEq162cjseAvsI3fYC34GqPvG20qRmluI96bNxTuVnkAV6oBcUM4d3sHGGA/sdNpCKNyhKD3kaGbq0FSuoARfVJ9OuEUnU1trBxRrLdiPAt58zkTCrYoOQ3iXJiD/WKzco3eVMKRjH30rbsED2TaeLW9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EIBk15kSSVTKJIIhbnwj22TCGQSp2+3S6eHHaHHNKOg=;
 b=tfdu3+wDLuRUp02DnE3gMywX5lY9tx6wwgB0lBmS589covwKigO54A6TXQJG2dUxqNMmIJU4xKWdDU0Br/eDHxh5U+DJv5CIXkt71cNob80/JMdFQrDOdOhLyI42ZlUu+APgCYEx54OiSVFMJawQIhL26n1l5NT8LcWDL/ZcixTlxnm2QMVEKHmQmD6378iTo0ctPv+9ZH0dR08vVxWMOsEun30MTazZCY9gjapceuzRBN7Q3xUkxXY0PXpTzJbP8fDvFSiDPZivP+zybG5WbFyWUrZXWJQR6VWNjSXCrhJGVqK/zhlLOinoK/G3cIJdq3PXnOPyO1+ASKXROsJV0g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by PH8PR12MB6793.namprd12.prod.outlook.com (2603:10b6:510:1c4::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.13; Wed, 27 Nov
 2024 15:57:14 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8207.010; Wed, 27 Nov 2024
 15:57:13 +0000
Date: Wed, 27 Nov 2024 11:57:12 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: iommu@lists.linux.dev, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Kevin Tian <kevin.tian@intel.com>
Subject: [GIT PULL] Please pull IOMMUFD subsystem changes #2
Message-ID: <20241127155712.GA1470954@nvidia.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="XpamI7JgGU+G7+Xz"
Content-Disposition: inline
X-ClientProxiedBy: BN0PR10CA0013.namprd10.prod.outlook.com
 (2603:10b6:408:143::17) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|PH8PR12MB6793:EE_
X-MS-Office365-Filtering-Correlation-Id: 92269b94-63c6-4b96-db1e-08dd0efc28da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?GYzNYMYhD4imiPMlv5ZIA0EDkZ08AkykbqcyKdMtcxdcqKFni5QuajT/SUBL?=
 =?us-ascii?Q?O6INmJ1U6Z/90KtukUQ+jbnoXksGYLXtgfICILh+oDl83GUhcFdYbY0xxBPm?=
 =?us-ascii?Q?OUkaUJlQcCauRlLGaM724qftR/TmVTInlJyXZ1b2B0Khst+O7uB2p17vDavJ?=
 =?us-ascii?Q?0hm15YHcw51L43HIm6aYlCQqIDCR7Gd4lJZz3NZJZqCy24cTQUGmzS1/YzdW?=
 =?us-ascii?Q?zH9G/mA7RjBZY2R6Acqe6KeJ3em2pF8E2Pe/MGVUXV0TJidSrRXMXMIP5P08?=
 =?us-ascii?Q?4LgaM0sM7xjzn2f7DOjSTIABLP2/CBToTRB+DF910vwOR2Dotwes74Gdw1d6?=
 =?us-ascii?Q?Ud9vaE6vmQy3zzV832pgyu+erTzz04Edi9X1rkqnYwoEsZd4VLCJ2Xx4fJ/Q?=
 =?us-ascii?Q?aszD0JvWKsy0bgEsp27hK6fSmHI6J9vwYp70nixtybarb9tsPbA3jWyOgbH/?=
 =?us-ascii?Q?SrcYW415xzmim7mHRj0LQ248ljo4xvkiM0UNEVh5OwsuNICPqJSXkwsNN+zj?=
 =?us-ascii?Q?frJRStJ+rvO5xHKh14GOWFb8mXrhoK+9jDuK2Rs3cTl+jB7MlNqLhcvBIB2C?=
 =?us-ascii?Q?deDPWfK32UwSv1VbMuwMM0qfOOp5mJrog4WV09ntuA0mBSs3bkYflprUR9sS?=
 =?us-ascii?Q?Oj/arNDYOt9BLaeR5xspyr6GQfmyjofwJrM6CCNBtzNEN+nJBMa8kZ3NXSkg?=
 =?us-ascii?Q?zKaA58VSSRlW5om/kJzyBZHdlgXrIN4pDH6F23cBN9cCdTVaDh3XpEVgvu8W?=
 =?us-ascii?Q?e8Kzj4i/7EDKorReTFRGBbXf7DfBmn86C4vF3dGQi/TlmW6pyTUdF5A69Qji?=
 =?us-ascii?Q?c9rxTSnQQ4/PQwEYqLIKtf44EzxwXkEGuJT3ySAapdb40PEHaTieAOHDIAzt?=
 =?us-ascii?Q?m37mG6DBTrRf4qBuB1JJIstk0qs6bFSUt4qUVU532gJIz7M14n9p6qTvMAim?=
 =?us-ascii?Q?GPQMS2/8Yt4h9WJDnGKnNxAZ0y6ArfOH9Dy2E0SQ2v0Qc5TusoL3tUcH8vw7?=
 =?us-ascii?Q?bM07+cov5ryNHbb/OXJkLdSSNitKXyYWpiCfXAx2X9gTu/x5Efm5a0ouxvS7?=
 =?us-ascii?Q?1DNhW2Va9WkQE+gVZve9upyGDrF3PeLStp2IlSl5dBVs0fqdxjTmb1WVxXXw?=
 =?us-ascii?Q?LMCAV28tSj9El+L16pghCK7y3ZXgQLIZ3ds0cZ6M3dbmVcGnHd4fMXnb4Abc?=
 =?us-ascii?Q?pwjzFsUw+aaeM36fM1ud9I6zKUGXkuAeVEADDD4bsPwiuiLiLwgEsXodvxp5?=
 =?us-ascii?Q?hmNETgS2YojFUF0Oa5fFaS9c3QXMYYzrj87c2JuzIsKBOtjIXOJ8BjStwK71?=
 =?us-ascii?Q?NWgrfMHcik/ZYHmd/CF4tRjE2I8zZbxWgW5Km+mu1E8DHA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?FU3HR7VUP2P/FeEM7E4kK+7UMelV8xTvlysfbG+LjQ34TKPC0NIAD6vFDLCU?=
 =?us-ascii?Q?5u0ImkBExnLXWUHw+G6/Dugm4b7Q3YeUoHwiu9hfAkf5Ek5+YsaFMw23H3yR?=
 =?us-ascii?Q?sVx1PzHo9kMh1hjyFDcBaiSfIs0Sc4jnNeW3OTjlY67fcF+q4aKCfsh896P/?=
 =?us-ascii?Q?LblTR8KUJwX++XXG0GJEKmohqf9big9PwMH6gkup9xI34S3wvoUYIv5lE4mD?=
 =?us-ascii?Q?j4nACi74b3EfJGgg22hmBAfHiH6NAcpsru2sv26Mn52rWvD4VoB4PWelSphX?=
 =?us-ascii?Q?ppEAbfQVxOhYsriAQn6Hj7TrzyU/UOUG0mRGZobmBW8refusOJ4glqRNn7wr?=
 =?us-ascii?Q?rRe7JwLFWoJWPraX2hddCaiM1spPQ4I60MvmIPBe2LH2CLhFEGS0q4Ehzcb5?=
 =?us-ascii?Q?R1MKCoGNaqqwGnOnoND85+rhIWEwFq6ocjBsQpMF44jkVhJSmOH1kTZepn3v?=
 =?us-ascii?Q?GbFBLOt3zoT50mZrCPX6WJWAZPCXM/4Pk3OOYkhIXvyNfRQvorkc+mAZr72o?=
 =?us-ascii?Q?zmvgGZVj9DWf6jI4jRYMSlXwcNNccqsQpZk2/1TR/yWUqjzMhUlC6tvpQycR?=
 =?us-ascii?Q?MT1Iv2S43p8C3HrIiOINLJDebiStY+KItpafm/ZgqDXgve0Qnu+8viKbKn5p?=
 =?us-ascii?Q?bggZ/Jo7dOaawULhh+LYZFS9xt5x6Nwu+fMgD7VwPwZGeajxozEzgcmr5On5?=
 =?us-ascii?Q?wkQtaCt5nTF77fIbhhEvHrNa2mGBTWRwUjjPK0Rq221qXDOGgoiUBI/UI/vF?=
 =?us-ascii?Q?iPTJLB5UwGirr70pkGmlHtXFxdU782AjgOwdB1gWAsBSMxuqEoydeVmW+W/F?=
 =?us-ascii?Q?oY604k3p6mrrq+BMZCSppxOer7iU4MnrX/Lfjao8Otxqf6Hv0XgrQHoyq1dZ?=
 =?us-ascii?Q?NIRlqHkGMLzKYtswBOU79kSVLeVJVQGUcsi1bkgw6lX5scW89OUpbxGY/aq+?=
 =?us-ascii?Q?rIIYXbfqOTNtuNi1b/6j540YA2gZQjrPEELPn0LVTLh70xxBoKPS19YP8eX2?=
 =?us-ascii?Q?58kxDO9h/7rkrOUuJ0e4EDmRqzN35EpfZtV5xOAEpYynbSyJhWof7BR8gKro?=
 =?us-ascii?Q?ixNDUhlJDIJqGoMDWygIUXZvK+8Y89u4GhETAbnJVEJw6pHvoS6n9x72jBd8?=
 =?us-ascii?Q?NWIWIuFqW7cXDFt3TpUByu6Q0zMvflzv9ZEYZA/sa62nfGwc+3OzCfaA7i8J?=
 =?us-ascii?Q?f4ew+RU6+PiXMex/0osnvUxGQ8Np6e6GmlzFZgk8IDgupzSqoCg3hyJ7t7LK?=
 =?us-ascii?Q?M8Skm9SSxqRQV7+GwaX/mrCJO3kLNnngXU2deQPLOeDB2Pz9DXzEgPsDKiWi?=
 =?us-ascii?Q?2Iw5KZkNSPOKJWB+JN4vmO0XWdidqC9am8Vnvu+92nUSMf/CYzqROFCOLLnJ?=
 =?us-ascii?Q?JCC1Y4HE0yyYYFEWHHnUsiKUKOdl0VG0EwzPxjCsZ1zvn4lL83BzbllKX5Kf?=
 =?us-ascii?Q?SpehnLY0UedW7iYr47YWgO9v4pxOeQmSUuGYsYWG75CWfxLZmIZOgyjNMH9J?=
 =?us-ascii?Q?s+P8meHc3gJUgjEmSrVXn1w9wA4LXvthECTi2PV9tzsLkErsa/4CkPcsfSM3?=
 =?us-ascii?Q?0SurTB5DMqtpkq5IXy54cUqcrmE0/nTahcjntGfT?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92269b94-63c6-4b96-db1e-08dd0efc28da
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2024 15:57:13.8529
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZxoihAymJuiTNNKo12xk6L95A0TfOcIseeJlmVu37pWt0Xne5LUn1zGM5pZR1dFf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6793

--XpamI7JgGU+G7+Xz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

As I mentioned beore this is the two patches that needed both iommufd
and iommu tree merged together. You have merged both so this is the
remainder.

It has been in linux-next since before you pulled from Joerg. I left
it based with my merge of Joerg's tree to iommufd rather than rebasing
it to your merge of Joerg's tree.

Due to the many different driver trees in iommu it is helpful if
global changes like this make -rc1.

Thanks,
Jason

The following changes since commit 42f0cbb2a253bcd7d4f20e80462014622f19d88e:

  Merge branches 'intel/vt-d', 'amd/amd-vi' and 'iommufd/arm-smmuv3-nested' into next (2024-11-15 09:27:43 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git tags/for-linus-iommufd

for you to fetch changes up to d53764723ecd639a0cc0c5ad24146847fc09f78d:

  iommu: Rename ops->domain_alloc_user() to domain_alloc_paging_flags() (2024-11-22 14:43:45 -0400)

----------------------------------------------------------------
iommufd 6.13 merge window pull #2

Change the driver callback op domain_alloc_user() into two ops
domain_alloc_paging_flags() and domain_alloc_nesting() that better
describe what the ops are expected to do. There will be per-driver cleanup
based on this going into the next cycle via the driver trees.

----------------------------------------------------------------
Jason Gunthorpe (3):
      Merge tag 'iommu-updates-v6.13' of ssh://gitolite.kernel.org/pub/scm/linux/kernel/git/iommu/linux into iommufd.git
      iommu: Add ops->domain_alloc_nested()
      iommu: Rename ops->domain_alloc_user() to domain_alloc_paging_flags()

 drivers/iommu/amd/iommu.c                   |  9 ++++-----
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c |  9 ++++-----
 drivers/iommu/intel/iommu.c                 | 15 ++++-----------
 drivers/iommu/intel/iommu.h                 |  6 ++++--
 drivers/iommu/intel/nested.c                | 11 +++++++++--
 drivers/iommu/iommu.c                       |  4 ++--
 drivers/iommu/iommufd/hw_pagetable.c        | 16 ++++++++--------
 drivers/iommu/iommufd/selftest.c            | 15 ++++++---------
 include/linux/iommu.h                       | 27 ++++++++++++++++-----------
 9 files changed, 57 insertions(+), 55 deletions(-)
(diffstat from tag for-linus-iommufd-merged)

--XpamI7JgGU+G7+Xz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRRRCHOFoQz/8F5bUaFwuHvBreFYQUCZ0dBVgAKCRCFwuHvBreF
Ye0TAP9T2MWCVVVuRu0q2VKH6ESd4wU1KTwaJY04f4qWAl7DLgEAsD7IjrMCXyF2
JNrfYXp+PRA1+J7Xa2fug9hoLSK6zAc=
=E8NR
-----END PGP SIGNATURE-----

--XpamI7JgGU+G7+Xz--

