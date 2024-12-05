Return-Path: <kvm+bounces-33174-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BF0579E5E64
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 19:44:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EF79B2866E0
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 18:44:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 790D922D4CC;
	Thu,  5 Dec 2024 18:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="mfZMYSyM"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2048.outbound.protection.outlook.com [40.107.93.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14A8522B8A2;
	Thu,  5 Dec 2024 18:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733424278; cv=fail; b=vCH0F3ExSFOZuZYqYeTxkhI1Ht9kZ/5YcQ2YAv8wrI9aPc1JTrey4ohEOf3xKXeoJNrdYScQ+IwsDOMfiJdzfSA7rVhlCi+qMClWOIX2FDCWHo8rbS5ehrrGHOwVmXx1sq5Fyfz+D/OTH6OG5/AFMmpK6KMF42ifQZflo7QGQ20=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733424278; c=relaxed/simple;
	bh=xilU2xtgAZgr0JZTji/JrQXnfdNGQyNrzZfvOK8eaEc=;
	h=Date:From:To:Cc:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=Q25+n/fg8PWp5SYuAGjFBTcIl/bkxQBlWiq82iFHorxFsGl41bPGFRXViKivcCxa0swLu0auAzNBDVoOQr4XmNeN+3M71VhDX6K/lbEq9rE6S8B+7CUJWpOwOPuQILIMizCNAGkRJVZqVP3YMuM33x1fq4moXf3zQa81nL8anTc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=mfZMYSyM; arc=fail smtp.client-ip=40.107.93.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=a574l8knaX2SGBaHSYcbocKHmF7nQb/ehdav/U+nAUIiOnuqgF2zKgqDjVAEkco0o7c/qQioN1TrU7jplUTFnXs/9SrNoH16nUCljMhOrB8d0GiWJbFv2GDtBh+oBohnwk+mCRalbRWVcmjzOxU+t90e1AS4L8QkBaxG7vL3zJkJGa0GPt3mCSGghRS/+86ro5XDIJO4jp4ToEsreHRQxR07fB4t3l1UdiHcdj2E/F+5f3R5UNqg3wEYwVMUqcTM9wcLqJJs3bP751/PbYmE2dZ7e23E2VHXTBdM3EPmq4yf8qfi99tDuDOcFIXe8p0LcweKL/rUPjZYazN8RXtdsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BtSISHw6D94kP/rPIxx1EMX8xArB4VC9IUBXvIIH9+s=;
 b=Ddk8NnFYlCMrr+NIs4FSR26NPwigqIEsNPS1gfo6v0edvigYmQ0Lh12xqR9VEGj5Jpcb7eQPTvwKI6a+wTmW8H2dn6qWyPTksqAlpUf47/uCzSer/q3LnYO20+JYB1hPNPyU3+x5+u2QOD7cBLcnOIBokRLHzZoez4haFYqM//n17fmD7iqt8WAvD6pen2gaicBOVAlbW/XASEQZ/BIAbvy90XaJkcgtQc4g7jVK+pekLrx0u/msmbjI2bMw0hVPV8kYj9MohRgnABG7xNxfyY4ckmBdCM56fmWxwdXI0q7sr4I+WZnvYvpF+DqZ/8TckiiPAk2AxP/vBMESXHp3sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BtSISHw6D94kP/rPIxx1EMX8xArB4VC9IUBXvIIH9+s=;
 b=mfZMYSyMnwCmjtNsdBY2M10bG4t4OqcEO/WrJ2zmgIBCteb+gI4TwGVpu9Pyl5tJ4dTqOL62pC7hPaTWP2z6NDNdXaajHpoEoO214blDJjlsMByM1KuSckdTE2MN6ScycoJt1fY56/ucjTGfU0/8ONR8aMa4u7PEOQLp0wHHyYdGnAqeDgDXHkU89lI1GE2ucZsZVlrr9vWNR/HFt3lG25e2XHDZiN1Qa1OQ440I0LKnrXa8P7JDptrrgMot9zfbJRoewUyDGppjrcqGZYU7yZq2CyQYgSIPFlnPqyweVxyKJ2JEqj8FfXwxF4cLS2yH7eF/OOws/XEA49HfZXj1yA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by CH2PR12MB4278.namprd12.prod.outlook.com (2603:10b6:610:ab::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.13; Thu, 5 Dec
 2024 18:44:31 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%5]) with mapi id 15.20.8230.010; Thu, 5 Dec 2024
 18:44:31 +0000
Date: Thu, 5 Dec 2024 14:44:30 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: iommu@lists.linux.dev, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Kevin Tian <kevin.tian@intel.com>
Subject: [GIT PULL] Please pull IOMMUFD subsystem changes
Message-ID: <20241205184430.GA2110789@nvidia.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="NWhtbCSZBtmsPm2R"
Content-Disposition: inline
X-ClientProxiedBy: BL1PR13CA0445.namprd13.prod.outlook.com
 (2603:10b6:208:2c3::30) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|CH2PR12MB4278:EE_
X-MS-Office365-Filtering-Correlation-Id: 07c95b2d-3f43-4f1e-e4f7-08dd155cdaf3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?sZPieA1h752pYM8oEe5ttwcjHJ2t3LmL2m4574EOGD3D+2rHRHANIJRMteaz?=
 =?us-ascii?Q?iePXJBD6v0mpsde+wQGt1GoAFpTJPaxjYkU9ZOj/o4Bp6zag3waUxGFAZaa9?=
 =?us-ascii?Q?FFkLax55ECWCamHJYv7v/9/LumiXoGmtDtk4EguHbcYZ0IabwvbD1KFTcnHy?=
 =?us-ascii?Q?gkKCVUiRPQMTugn6EuYteagohgoO79V2FWnbBXoOE/AfQaZMkOQHalt7eTx3?=
 =?us-ascii?Q?E+l10zKnYFaZyxiVU8cHaoR6JQMRqCVQ5J8qIs/Tu8FQDsjYmOXyqB9j1/NY?=
 =?us-ascii?Q?hJ69eo1WRM3QzhiEczk763T7YDJQSsPdXUtIfSo5CLChdCUr5a6TM48v8TXR?=
 =?us-ascii?Q?mqNADE9nUOOmEnq/ekCRDJj+I7dgZoy39vqIo2daGh4fVuRHatdptAX3BZFf?=
 =?us-ascii?Q?P3vWrc0Vl8AzZQe4l0QpCtRv6oe0Y0/Pnl6u2QZ2UhYQNEatDHsCrnDBLh/t?=
 =?us-ascii?Q?XhhxQgeSrugFdIfBrmtsQDPji1jis4uZ5MYtEA+dKiYoVyhDokSdwrfMxVzM?=
 =?us-ascii?Q?y9CRTi/U2ui01D3ZzRJTtUuKpqsT7YOdu+4vN3YIMbVDSXokKBHOdnMZRgsF?=
 =?us-ascii?Q?lzGEW75a+3sGFP1BNbCVY1rwfRscPUcyOffmgkvFsIL6Ftvn/IJ0MIGwDl1o?=
 =?us-ascii?Q?LvRRZkipWcNZdrXo+6cXBBQFs1kTnFhrTlEkSfEP5x0hWicxQHInQ1Ak65L9?=
 =?us-ascii?Q?Hrmi1E1NZ6Y4OHMR7RzlMtwBl9LgMSemxhGkAjI7ux1ochTHUJ/c+yGRdfUG?=
 =?us-ascii?Q?anMlOlUB6xVvH2Q2E9zx7EO4SdcP/wa8dDsdier2SU6OkkBRC21Ck512OkcV?=
 =?us-ascii?Q?DnN0CYBf8mf8MjAkmkNVTY3zk0id5mbHMvNV+JqVze9Z2QyEPtrH2p8inGhj?=
 =?us-ascii?Q?2z4FNjcr/o4+Vb5LP8PV4JssSOU4YIT0zlaJGinBAfesjMI56Idv0UCaIsKX?=
 =?us-ascii?Q?zx+sLZPUhJbDhbEN0k8YsAwfbs65iKWRm/v9cTclB+bD64piithyAgRJUE1K?=
 =?us-ascii?Q?shwxEWToQU4+HXd+9BIBPThXYYXXSYNgnupTX9KjyvNovWr7R/9x1pOktKeY?=
 =?us-ascii?Q?wbnc6erehKbtTZCbZalGNvyRmEKCjZTj0Kt8AoIKAULJNx6Lj+60J8X5zntC?=
 =?us-ascii?Q?O2nV+DPUS2nDp/i7pyOdsIZ9Y/yLvtcRy5fEp3VnPAQy6Upn5C0cZAYgRnlu?=
 =?us-ascii?Q?ueMMq9fowsS+zoPUb98kKJbZwIKKdPSkgicBrntl7dVbQULugbpMkFcL4e5d?=
 =?us-ascii?Q?MbUqqQXISZprsDMgfQMxCGeYQ/sLRbgtNyOll0Y11XINGAomnKeRsWsrMv1l?=
 =?us-ascii?Q?ZwxDsOLAf8VV74y1J1KYa0mmSn8z5BmzTBxoimjsNoKW3w=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?bZzRRMOH0uq5hFhIvaSZElMHYIqcp9MoMBWC5CtbIkiv9QFDxok+wgxY8ro6?=
 =?us-ascii?Q?q2G9i2c8rr2x+RBhH6DMHAGAnWjjBayA71zt4DCoqhAzn1rz9+y3neFSvVWj?=
 =?us-ascii?Q?1TPuulJlDBNL/BWos6VMQde9RyojhD/SIsS6V2NZ6kuGum5+pvS4EyB3xp8b?=
 =?us-ascii?Q?XHdOqV3ce7G2s1VO5bcG+nIyAKqQYT7JT6WGN1IMjsH56SQEXdApKFS+UwNM?=
 =?us-ascii?Q?p6UBx/xh6bP9Lu/saMyqSyPzqDEX0idytqYGihvF78XsRmzV1/3w3EiLISSs?=
 =?us-ascii?Q?9G1s8kckQIDCBnlt1zpK3GDv0/MdpV/A2QqKH8DW3R1MVAlQ0GuLaZGJxWWy?=
 =?us-ascii?Q?ggAxDvOLO8E7oMzg7uE4xRiLYhnShpzMMjB0kF5aZDE/6IaheKsJh3prGwsg?=
 =?us-ascii?Q?fWWd0g7orR5zhdUOrKgFqlC31oeC5vf5kdXwPpQrCPQGZyy6biIZoaoZfAm9?=
 =?us-ascii?Q?vvEueQjQUUhDzdC76JItIKlQBZmu6x9jlHm9ZnJZWeGfYsUewQlfpnK9GaDc?=
 =?us-ascii?Q?XEVvNBcJSQCuHo9AJJSfV4+Usmt4TIEjFPhrlv9U/QgrWy61N8bWZ7gG1rVb?=
 =?us-ascii?Q?KbrmVSA5anQECxVAiK9A9wD5XxLbXA9SMFhocs9giMQc7j0mFl45hKytMug8?=
 =?us-ascii?Q?JqJE5HqJkASV0F5Eee1yQLGwPi9OZVB6qc5cGe5C6BBcf7Eafc0DZFNULIZ1?=
 =?us-ascii?Q?+ziHYG9JOnxGRAPEq3YWMnBzEns+L/JXhzXix+uSV/7vCfsTM1my3QHTvKja?=
 =?us-ascii?Q?iZAfWTnVAgT6swJOX0TEk0Tm7OZIQ0xLNSwxr+WzmA6ByJ2uHsdcldx5tk4C?=
 =?us-ascii?Q?A9lzrjS4NeTlQxrHSk55fuxYjVnEYU1q/+m0gP4kC7BdjoxURJv4izQjFmbW?=
 =?us-ascii?Q?xtVjlhFWvaJgj7NgSw5k/SUZuwGd6XFBG0Ap+IDHtirYqIdL819/+mHFVEY4?=
 =?us-ascii?Q?M5hy1xMqwAmafdTxqnAToawuwagdDBbaB40GTZDW3/Ui3bX2SRZ10Xn2YSwY?=
 =?us-ascii?Q?UuWyZcDY5zKUB/zF3pin4E2yB4nZXoqGPOpIYIHaUWnjwdKSIbqrpu0p8aDi?=
 =?us-ascii?Q?djyr0cySot0apdmKESJFohKRNzhl15FZdxZilc6JHZm4jh6iSt/mj6ZpPzcj?=
 =?us-ascii?Q?WBY4wC/gIFpOtLwaCOuEA3BH5hbWQDusgvgTNHQOfCDW9T9mXlZBv8vhZZi1?=
 =?us-ascii?Q?6rfNHUGLHzssKxlKB4yvT3gzzSnw66/2U0AyML7rgao4bjj1KpA7pmGjyFHS?=
 =?us-ascii?Q?4+qER6+b/RnEF0OvBOEp7LDGlgA5rQXh4liY4cRrS7IkKPEGgWFV66RV0KgR?=
 =?us-ascii?Q?1FqRrt7lVH9VlLlTTRzLFxhAR1w6xya2gUIvEFY6EMTZ6HLFTo/NwKIYGuRx?=
 =?us-ascii?Q?nR/1v4EO6bswAxxK7ZdI5QVPpu8nA3RoivW1tTMSWGc/9mZ2qxgNiiAe5TfT?=
 =?us-ascii?Q?9FWQnRhUaU8YHsBkBLt8q+3l42har97I6h1m31gE6EkmeJFYj8QYxMvhyNfm?=
 =?us-ascii?Q?8vYz99aRKMefIV0l87Y0v0FzCfezFm5CyodCmtn57Qx/Pp25Nj98YUdGj0nT?=
 =?us-ascii?Q?UyxTdceSYIf4WBkGgb2c9YQR8OSpAlo2V5tkq1Tq?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07c95b2d-3f43-4f1e-e4f7-08dd155cdaf3
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2024 18:44:31.2553
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qXouJBQh/3Iv5xWW/yA6NJLvtFTAtplhRDjj3+3dsEz5Z2YVRsYNS2TZ3AspEINx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4278

--NWhtbCSZBtmsPm2R
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

One bug fix and some documentation updates

Thanks,
Jason

The following changes since commit 40384c840ea1944d7c5a392e8975ed088ecf0b37:

  Linux 6.13-rc1 (2024-12-01 14:28:56 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git tags/for-linus-iommufd

for you to fetch changes up to 2ca704f55e22b7b00cc7025953091af3c82fa5c0:

  iommu/arm-smmu-v3: Improve uAPI comment for IOMMU_HW_INFO_TYPE_ARM_SMMUV3 (2024-12-03 13:30:31 -0400)

----------------------------------------------------------------
iommufd 6.13 first rc pull

- Correct typos in comments

- Elaborate a comment about how the uAPI works for
  IOMMU_HW_INFO_TYPE_ARM_SMMUV3

- Fix a double free on error path and add test coverage for the bug

----------------------------------------------------------------
Jason Gunthorpe (1):
      iommu/arm-smmu-v3: Improve uAPI comment for IOMMU_HW_INFO_TYPE_ARM_SMMUV3

Nicolin Chen (2):
      iommufd: Fix out_fput in iommufd_fault_alloc()
      iommufd/selftest: Cover IOMMU_FAULT_QUEUE_ALLOC in iommufd_fail_nth

Randy Dunlap (1):
      iommufd: Fix typos in kernel-doc comments

 drivers/iommu/iommufd/fault.c                    |  2 --
 include/uapi/linux/iommufd.h                     | 31 +++++++++++++++---------
 tools/testing/selftests/iommu/iommufd_fail_nth.c | 14 +++++++++++
 3 files changed, 34 insertions(+), 13 deletions(-)

--NWhtbCSZBtmsPm2R
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRRRCHOFoQz/8F5bUaFwuHvBreFYQUCZ1H0jAAKCRCFwuHvBreF
YT/iAQCZ1hCGe5w0mtuFrvv0l1Dxp6f6yTPCjkktp0Z1vq+xeQEAkTvxJ112+eKx
0isfw7bIXjQTxQlh6GkLMl3oeBU8qwQ=
=49EO
-----END PGP SIGNATURE-----

--NWhtbCSZBtmsPm2R--

