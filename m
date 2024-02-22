Return-Path: <kvm+bounces-9389-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CF49C85F9A2
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 14:24:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 416061F26D13
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 13:24:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6ABD9145FF6;
	Thu, 22 Feb 2024 13:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="rIw1srAG"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2052.outbound.protection.outlook.com [40.107.223.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F27E712FF74;
	Thu, 22 Feb 2024 13:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708608189; cv=fail; b=tCdSNXXO+LZ3vYBG5wpUcebqM583OL0BMQzrsx4FlPQxmhBZfgXXvwMmuLvRCyKZJra2x3QGydfSgml4yqvG5q9vJ4EBHUUm70x2SAG4gUjrZ4ZZoh8eJLnBWlBxpBdfH0Xx3yHORpmQ3XzUWEy+iFrzr9HGo+pBKawk7Lsjudg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708608189; c=relaxed/simple;
	bh=uqfIxxOQX3ruqIQZKSpFgLxugu4SWiaJsVcKUhIkrfE=;
	h=Date:From:To:Cc:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=NtYSZiO2l8Ed0l1FmUFoxl2ezREnI3nyIoR47dFTktnbj7agskEHwwH8BLes8PK01Ur9DQX7g2OQVHGx3KTzEfwvAUIhcpBAAhmK9BRkYIXdMFu0Hoi82p7e2wU/dXQKjXcMMm0iShpYGV+KcLw3ezI4xpS3Vc4/Ydg/oqME+Us=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=rIw1srAG; arc=fail smtp.client-ip=40.107.223.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZreBr/brMPsomW78HOf0usOJ5v+Fcxa8g4XCUQ5axQd+EH1/bXfm6zyG1KDWOvVVZ6bSoFcJ7Ncu+9DmPXTxAJZGSJWUUO1ZBd0ahQgBrHI1FZsiPHknZ4iZFtH3TKjQS1pm9mgFUGDWJGk9ewF+A+sXBKN8yBj0J3qoACVMjO+RNLoEEKAlpaXhkcObqy+aNuqJX0o8VVPmyvjxkttOS0IkWIErZmxxFM4HnLNbBIxZ8Bl0WtgJuOSIg3Xupqm7XYs9ruWueWhA72UxjDT826PlvREqEXhGty3uFa8lPRmR166vWz4oZdooLBH5Zp8ASFDf+gmySFl+vdWz1rQ73Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3BXGIUYTYdcizYd/yXbOLHtAv73O5Nqa2dmKunxJIwY=;
 b=MOVgliJzPkMj43iEXdRreaEcSOqW+B5OSn1x7wbUyNShxlubd2TOeCYJRVJdMZ5uNdPpJ/mKqbWCHNUpQYb+NauqaZUBgAxL8ZI6vSF9EPlSRFOXDsnZWZiiSyCwuZOmYtKiamAzvubshbaiNSn4eyM4YvpuIbmM6vpL6AbvIkdItyfSd70A7W4WKKY01+rFxd5vsPawi8QeVCPA/M0IzaynfmC412w7zLF66/XlfV6zL3jBPznRVuRZDAg+0XJE9zijfnu1bdfdoAs5XO/08B0LKMPWdEEJXlA3u5QgD7WATM95/fd6QqydHMEgqeOlyvmz2/jtVAKMpsUpd3TNZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3BXGIUYTYdcizYd/yXbOLHtAv73O5Nqa2dmKunxJIwY=;
 b=rIw1srAGvs7blOtlP142P5HF66X30zjIbjHPxctdHMg867cg/S/MTyca8oCQbZZ7tx+2sls/CbuJvgSi5NFj9Q/2j257AoFokUn8ISuHlsiTq5mhA6n/KnBdQM0RpzIl9C0PP4/gnQHqx6LRi3+d01KdP7OQ3jFJKNhDrquN2Lvt1/o54+sq2p3jTxqOSPN5laEpgFvYRuyWFmKM92M4AIO3YuTTNfWo831UHGEpfMzxE5w0F7jadxHKbkZPbkhCQwRZiYvUazOEcfmrJ7FzlM58uwmTpwOh8AZKFoq6wPsLlcQjL/4geGqnrCrIiZ20vOnm9pD5bRhIE5Q7FrtbQw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by LV2PR12MB5750.namprd12.prod.outlook.com (2603:10b6:408:17e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.20; Thu, 22 Feb
 2024 13:23:05 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7316.023; Thu, 22 Feb 2024
 13:23:05 +0000
Date: Thu, 22 Feb 2024 09:23:04 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: iommu@lists.linux.dev, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Kevin Tian <kevin.tian@intel.com>
Subject: [GIT PULL] Please pull IOMMUFD subsystem changes
Message-ID: <20240222132304.GA3882153@nvidia.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="ckfeWuDiNqjgRFbE"
Content-Disposition: inline
X-ClientProxiedBy: BL1PR13CA0191.namprd13.prod.outlook.com
 (2603:10b6:208:2be::16) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|LV2PR12MB5750:EE_
X-MS-Office365-Filtering-Correlation-Id: d7e6105e-57cd-4c98-527d-08dc33a96766
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	8UAHjCDStbC1885Ph0NNgM7vuJbl9SgRQqrHnfzP4hAPUH4d2cP8Ebn3NaSkWATgB9Zosd3eBU+Ch7xI6Y836Hjd8I5TRLw69ZGUinBEEx94DBTOxwY7XLm0cV4UqtvJFB4WsrEYuTVrtlLZIbcM8dFxBpIFKtN8Vq+1TMurKJN6iLiw8iRFlC5EMcYGKxKBl+ZGRtSGLUBIvawqkCoeNTCNTFbn/4+1B9tf3KYuTXvaaNPt5QMafb8itSaVAizpxaeNlF3eKb0XCHPFr+N2IgCL6O3es0LsKBSVD8eovSOOtLHdzTK0p1ydmoBVsnRZd7esS2Qjwggx/zandz1FHl/vtkPWU7XV65kSK6AoM+NxVyb9K8MT5GZ/oNrhAshzuDWMuryC5jhi0Ady9C2wrCg/0AuOkSQMmsX8QWOXEDAytyZXQy3P+yyhF2JFfAeZfCIqBpV0xTWv8Jly53AL3ePV6tA1eu7qfsGVmqvthBnNUGP++/8PJ37bnUqhpwdYHNgf1Bs1Xi7U0Hg35O9M6A==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ttrIMDap4xt0f508rrpTwcwrQXkup8DB8YdLPI9UMbA6O/WTm7E3/ix32UuQ?=
 =?us-ascii?Q?bK/wpeWi5z3b1w7axhKXc6/BNcLTfKte305f7R4vot08lvtFdubOcfQdxIDk?=
 =?us-ascii?Q?pZr8fsXfmpS18xKmRyaOeOJsBUOgz5IJN+z08OCClYD3DZODDOSyMDJy+fkV?=
 =?us-ascii?Q?ZspJVhSU64f6LB7foveXfi7/J/oLaJbwe5fFIZ+Ta1xTvx96U/NCEhTeUKRp?=
 =?us-ascii?Q?sQJEYCnFYSbHXXDM7GbRd2zSdEglXu/Y/4T1bJsyo1ZLWxgqZto0wRgDEFLe?=
 =?us-ascii?Q?CtDKVsF/fVgdJNvTC9h9oFxhfgzUs6RL/qkvzW5xzhpKr+5J+5nKA+FS8pRL?=
 =?us-ascii?Q?9Z/FQiH752CaQXs2On710SbeJ2NhnwbUYUWQ2A2LmEbX6o4HgRAyBbU3C+s3?=
 =?us-ascii?Q?kHz1XtfW/ZlZmrN6QkCUhRh7+zyMw5WYlON2FhXkiDL0YvDaeL3oVYnn5xB9?=
 =?us-ascii?Q?yQ9689yvRP3OhjpYg6T8B3tsYYPHj0Z25RxtanL6v0U4OGNPq9KQjjtUOvkK?=
 =?us-ascii?Q?Br/NeWw27ODbHbnurT5DAfueYCGuM/3k1GARYmH6eNHvmI1mmUyEBNPcxFPf?=
 =?us-ascii?Q?lYKe4z/fc3KUsP0GSKSv31Y/5JsuVraIUdZJFB6Qf/OEuWMdoK3Vu+KK9wt0?=
 =?us-ascii?Q?C+fkGW35Wvgd7mQNgN/cVngbUy2vm+PXpAgn2p2f6IznhOQ6ycJULnvCqFUE?=
 =?us-ascii?Q?pJqsLgvXKgrIPQKgNji/WDPIHU3d8gQMP1mdgluTuoyv75NdN8kUV2Q1SUtP?=
 =?us-ascii?Q?Pei+b2KssVywmtKEI/O4TTY+ncNFrbXEM1r/Z1uFfVfnhhlkrxbbYtGBiEcr?=
 =?us-ascii?Q?bWZUtB7FG7MbviJJw8Lno5wdDAB5qYmXYzVu8YMvMKAmETv8T4/wqpYtFtIz?=
 =?us-ascii?Q?oY1FNKXd9O4JVVbGVYCgUR1QGxVfUlIaIIOefsgUcm/MaBQDuZttyDiSMuPI?=
 =?us-ascii?Q?pEqQ64TkiW8aW71efVj3Scrxq7YjfMzsC2Ey9sYjfFrVYFx01pztE3dA0And?=
 =?us-ascii?Q?fiR7o6dWIsGQZvPodi2XOSnvcPVgS/4b5NLEG0oLIcgI6JKt9aeAFhNyfe2g?=
 =?us-ascii?Q?eB2wCwg90BPQwXWnJzfttlswHQF6SGGdISgQW0LQo+ynBR2rUM/qiPR8AlJb?=
 =?us-ascii?Q?GIzQJEUFtGUpCo9w+JMJaEKOQpMkVsKGDey8XqG+flcywP7SXAsVuiFXOV8b?=
 =?us-ascii?Q?FNCx1HeXFx1gLiuy8APGyqg8kB2uJuiGNskiOw8OVC+xd7j/vtLG/qrVjp7+?=
 =?us-ascii?Q?kRO45OUaluwIW1JyLy7V0IwCujTxHPVCjWKIO3eGL2mZ6EBkGzA0nQxYWcWj?=
 =?us-ascii?Q?S5wb0k4I9XEUfU1V0lkfBAoEGNtVWqYKOwsdko8l2DpF8HgFjKiU15fRmdOg?=
 =?us-ascii?Q?btC5r6Cy/VKQZ1LEbivrDbrEi58QFx0BZwZMjLmKjLcDDVozSU1C+4tIotz3?=
 =?us-ascii?Q?1DqyT2JO0As11YHY4bGNeyGZZQC6mFepfwYM8Ecf5i2fSg8/bOWlNe88Rxde?=
 =?us-ascii?Q?ouHOGwutstrjeSAXBMebs1Kgzk3WwPGg0JsIUUyO3PO4V1/lU4EHBkc7ZsrY?=
 =?us-ascii?Q?nyDpjzAUl6Lx5lYhM4/Gn3HfHpVH6cryJrogn1co?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7e6105e-57cd-4c98-527d-08dc33a96766
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2024 13:23:05.8255
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wnYBsMToufQNq2UDfJuoIhJmxjhWI10tSKnn/ZbdpMRRVANum3LdO+HzCVFxNmWx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5750

--ckfeWuDiNqjgRFbE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

Some small fixes and updates for the selftest. I'm aware of some
syzkaller issues that hopefully will get fixes into another PR before
the merge window.

The following changes since commit 54be6c6c5ae8e0d93a6c4641cb7528eb0b6ba478:

  Linux 6.8-rc3 (2024-02-04 12:20:36 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git tags/for-linus-iommufd

for you to fetch changes up to 510325e5ac5f45c1180189d3bfc108c54bf64544:

  selftests/iommu: fix the config fragment (2024-02-22 09:02:05 -0400)

----------------------------------------------------------------
iommufd for 6.8 rc

- Fix dirty tracking bitmap collection when using reporting bitmaps that
  are not neatly aligned to u64's or match the IO page table radix tree
  layout.

- Add self tests to cover the cases that were found to be broken.

- Add missing enforcement of invalidation type in the uapi.

- Fix selftest config generation

----------------------------------------------------------------
Jason Gunthorpe (1):
      iommufd: Reject non-zero data_type if no data_len is provided

Joao Martins (9):
      iommufd/iova_bitmap: Bounds check mapped::pages access
      iommufd/iova_bitmap: Switch iova_bitmap::bitmap to an u8 array
      iommufd/selftest: Test u64 unaligned bitmaps
      iommufd/iova_bitmap: Handle recording beyond the mapped pages
      iommufd/selftest: Refactor dirty bitmap tests
      iommufd/selftest: Refactor mock_domain_read_and_clear_dirty()
      iommufd/selftest: Hugepage mock domain support
      iommufd/selftest: Add mock IO hugepages tests
      iommufd/iova_bitmap: Consider page offset for the pages to be pinned

Muhammad Usama Anjum (1):
      selftests/iommu: fix the config fragment

 drivers/iommu/iommufd/hw_pagetable.c          |  3 +-
 drivers/iommu/iommufd/iommufd_test.h          |  1 +
 drivers/iommu/iommufd/iova_bitmap.c           | 68 +++++++++++++++++++----
 drivers/iommu/iommufd/selftest.c              | 79 ++++++++++++++++++++-------
 tools/testing/selftests/iommu/config          |  5 +-
 tools/testing/selftests/iommu/iommufd.c       | 78 +++++++++++++++++++++-----
 tools/testing/selftests/iommu/iommufd_utils.h | 39 ++++++++-----
 7 files changed, 210 insertions(+), 63 deletions(-)

--ckfeWuDiNqjgRFbE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRRRCHOFoQz/8F5bUaFwuHvBreFYQUCZddKtQAKCRCFwuHvBreF
YWU5AP4jZv47dnvw4rFM+MQDHiVN/3kT3eYmirUYRI7mGJo5dwD8CFW92m17CjoD
h238bIQHw9PmSVy86yBmX2FP1yjVBQo=
=Qq2e
-----END PGP SIGNATURE-----

--ckfeWuDiNqjgRFbE--

