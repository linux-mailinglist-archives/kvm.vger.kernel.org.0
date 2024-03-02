Return-Path: <kvm+bounces-10696-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DF8186ED35
	for <lists+kvm@lfdr.de>; Sat,  2 Mar 2024 01:08:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 99FFE1C21C86
	for <lists+kvm@lfdr.de>; Sat,  2 Mar 2024 00:08:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39CB210E3;
	Sat,  2 Mar 2024 00:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="sGwhEaA/"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2047.outbound.protection.outlook.com [40.107.100.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3606F382;
	Sat,  2 Mar 2024 00:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709338118; cv=fail; b=KozcAuxqlBhes5XQVvu3BbQbdF1WS05IrRbkYW2CpOX3U7tYdF2KSiif5qp4tajuClJSh+uaoDXjJhDPyc/I5ZCZEl8SkDqXiJ+KdwZiuEk3l3wN6rlV49fr6F+4LsffguiTop/SpnHSrzs/y99W9sDKbGAUKZNyeal0tx+JjGo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709338118; c=relaxed/simple;
	bh=wOYdh3BD5/xxi16cr+GlxcUoXt27nTOqn74VaZPNuS0=;
	h=Date:From:To:Cc:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=QbFCldfCvwU44gmvxuevUxkRZkLo80iSZNDV7HCMtTv42mt4EV0l5gGp8oeKU99AQ3ptxpsNG2xBjs+8na9UB07nCe5Pc2x5Pmlh/+R1dnwpnZG/+dP+Tm0oweomRw5QK9Ydy0MxZnOFgY5OUuaD78Xpv+XAa750K1dE2uMkfnk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=sGwhEaA/; arc=fail smtp.client-ip=40.107.100.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZG25MXWi4xdj4bzt5G+6shW7j6eHN9lGpXS4Fr3UjVXA5UPpG8twXcVYinvkfyfiq5god/OXkb4LTsQXyaNFZJ8bhEVhIF1ykDcA1hH68SE6YVLSIdPD+Qap4BxBlP6VPQ9DE3zmmE2ljOT4gBwFUHlYWAf4kvDqBWVuGHPvalAnbO617bJOE3zgEoCp/fVYbc2frxaMUlheADesOTDM3mBnUplt9Mg0OxwsLNawRh0opKmyGc0iPK8T+sOTdIn5GzRikkcT7kiDA75/+znlXTpuLepNOOUN7X5z1J5VURR7tX+uph7lVJq5qKNs3gJMhQp/IlfgLsOy+QSXcJ2bTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oZj/nrGhw/916OyJeuqdthRW2pWOTF68Zi4GcoFZmEU=;
 b=XdyZd8IKRFiL9fELOtO2AP6hQTfHT3/Y+XUM8+6XQUQ0g80nuVbruFmWCcDHhnTQlYaYMxEKDTL3gp+L0lt4ehDv2MoTOyHqsJVllwrDJqnPQ37pnGOWzrC1lLrGDRdO6FcbgsinGOFre3avmW5IA4nCSNYvC8o5RrccnS7XNgATyoFfMzxL6q4HYQQAC4F66XdAyaYVJ6k5k/Cfxtvv3Vs+us3kRrMF7LvNG/lZHjMHaT+ShEreORj8u+WnVpQA6HEvucx8H4vN6Adjw6/MNPy25XuSwDOayjRM0tv/FrjCHQxVClPbhrKg1PmYQHCl481tkIpgSqlKM2Clbw8lXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oZj/nrGhw/916OyJeuqdthRW2pWOTF68Zi4GcoFZmEU=;
 b=sGwhEaA/zdNUZdX7844M6jsS3fR2ER1MBd/9tMtcM4fukL40TWMD/L/eok8voi8MoWAq8cqsEnvAjA4gId8aq4k9OtkYKf7r5ScxocQjW9hi2YiYkeRaMOhXq4949Cpzfs/X3g8DEqHZ/cK6Sg6cOp5Eud0XjEYpE9fDXjA4sqYRww2rSC5YpScdIPscTYSmOONZdO7WHBRJoOTwDSf3QM+uB6vmcjdUFz6l+2TJnMEGI4bhsAUTqF0a5gbf9W6mXpxn5VmNSZC1opAnSh2A2XKS9y2e2TQXp/UlgF1IJ4A+swgugNCdNSB+9TP+tmQUP4lhsadvGRAQ+T9iPnofWg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB3843.namprd12.prod.outlook.com (2603:10b6:a03:1a4::17)
 by BY5PR12MB4113.namprd12.prod.outlook.com (2603:10b6:a03:207::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7339.34; Sat, 2 Mar
 2024 00:08:31 +0000
Received: from BY5PR12MB3843.namprd12.prod.outlook.com
 ([fe80::95bf:7984:9cab:ddda]) by BY5PR12MB3843.namprd12.prod.outlook.com
 ([fe80::95bf:7984:9cab:ddda%7]) with mapi id 15.20.7339.033; Sat, 2 Mar 2024
 00:08:31 +0000
Date: Fri, 1 Mar 2024 20:08:29 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: iommu@lists.linux.dev, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Kevin Tian <kevin.tian@intel.com>
Subject: [GIT PULL] Please pull IOMMUFD subsystem changes
Message-ID: <20240302000829.GA749229@nvidia.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="vzwSBGxv4TfS5vgB"
Content-Disposition: inline
X-ClientProxiedBy: DS7PR07CA0003.namprd07.prod.outlook.com
 (2603:10b6:5:3af::11) To BY5PR12MB3843.namprd12.prod.outlook.com
 (2603:10b6:a03:1a4::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR12MB3843:EE_|BY5PR12MB4113:EE_
X-MS-Office365-Filtering-Correlation-Id: a9ac4da7-2cfd-409b-8abe-08dc3a4ce508
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	ZIh97tfc/QCZDI8DBpV5r67E56/2xX9z6XvYXDn0R0EDAq4b2M7xJZanCAiC8/r7nXY18TtzxhQwMRo3u1ZN4SoseiUokwoF8Oi91TuSHKIGvmyyRmKPlzprJXhIiFuv5+RHplZ+c/Y/8SeZTGBFmxYV96RzUZiJNXQ0Bm705aSNLycCS79KZrebkyj70m4r54NBrYpv0D5WPTInJ9sOH7BmggchK85wcffEqJWDQu5dVQXn+0yeGDRgEfuLhkR6EEoO2z6V9mhAe2vG3eLlOxYJ9epwA2vc3ubASn+53AqFK4IIs4hX+0apRkaMvjoIoSrCI/89YEEafSW77w2FOAVSAwKlNWmpxylZNYhldkWIY/G3cyBMDx+T0MGA2RAEe5qjbkiRuF4eLW1Mcss4S9VUkWt1GrGypv4a1uiUDGh0zRt83SiipaNM5kvY7pH2yW3dTYuDTFvPzAl5qHCHVhoOHG6R40hyhu/jXxKbvOL0OZELoxPpXBYnS7BgZPxvRSmZxc0lhXeuTACXf4dtvYoUsW88Pir74p878s5scc71Z0gmvp7Nq5Ko11X2aNOEZOoBInCA9ueA6fK/7W33MuxykS55O3SYsgNn0ePSg1xJVBUPV+XGsTYOfTspCjNvFX1ILc6njPr5MyTbfTPBsg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB3843.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?SxXkarRs8lXc676b1NFAChUSmrj8yz5Mbhd4BnGNvRQXSKPVlXUXcqZ+5YvF?=
 =?us-ascii?Q?JxR7Wh/IVq0YmHJnOuWBnv+HlVv6MkVhRihheEHNjaqQ6KB/plA41cIIV/nu?=
 =?us-ascii?Q?KgXGHjCgtFpcACipfvpwULGSTAfS+TfNES35QrDf6uJZXIHD1Mty7FO++1Vs?=
 =?us-ascii?Q?y8GyIK4/QK8wRmQZ0im9KYBQox83gfBzbfuzgiyaahRUJsGnlYsAYw6c+0+i?=
 =?us-ascii?Q?GOuhk3LiOWbcWE7mAMOKwzQ8rpPlU+FTvhAvGHmg/KWt+Tf8Zfeq87zt7Eb1?=
 =?us-ascii?Q?Qb3Rsyrm/6vEAAhDQuKoNQ6gN5W6vvTCSo9B8rVo3qN/UGI4a2OFoTcOo+rh?=
 =?us-ascii?Q?7IzmOib4KlA9TYppdABHUOHwumm3qWaQRSn6ExnUY/eWDqjS+QmWwKrTETc3?=
 =?us-ascii?Q?3LVCOvv8+Q48165Vr/9AxGDM5bsyIpF2pyntARgHSNKCDe+9ID3yPlm5km96?=
 =?us-ascii?Q?dI970VMi2a1FbTe5Ao3ZcIGfFlfVFes7vMYd6FUcCX5KRYVvxCR6EuCeBb6x?=
 =?us-ascii?Q?fYgy8L64TG8RAKHXeAJIw89pMmY43luLRJOxcEiyWMFAbZGKdN8FAOKczUBh?=
 =?us-ascii?Q?b/Sm+V2szsAolHAx+DaFKmpCRVAk0FBvjvtJYuFiCXJdvS991fGvmCuvEEax?=
 =?us-ascii?Q?Opd6yj7/kUegM+KTj3fYiPhrkbUiaG9LRtP4WIQYkeCzZv9o0FCQYEjHJR7T?=
 =?us-ascii?Q?1fM9hRuAQ5HepQL8cX1wW/c8U+GCRH4pyVauM/s+GnalddHSA/5De3erLr+u?=
 =?us-ascii?Q?3a9cdWEYbBD0AuoMXBb3t+IUAcgyNJLfX4z6qffxcph+37g4p9gHM6kqLbZq?=
 =?us-ascii?Q?/pbip6ckJXh/ICaVY7YUtSW5SQ7uoR0QYrUhT7Cw7bxllXQPSjpVV42TZ3rO?=
 =?us-ascii?Q?5ehI/sR4EJnMUWpD2h+Unyl49+17kaSF6SSaTf2/9v6mBYAgrsmrGtrR1jaa?=
 =?us-ascii?Q?oDzcaRqrO+8GPbFbZPpVK/X/P9hnhFVVe/1ONEuLLLazzuIEZ65iPsCMNeBW?=
 =?us-ascii?Q?iWwTy/gl4g7P84X69QjGPN4OiInQbEh5TE5opJ6aFj1u4i6Bgx/AHCAkvkXg?=
 =?us-ascii?Q?vWTvaKIZrXUuS7mrR9bIf1YYehuFmT5yVjUqqLrsHV7q1qmD9YL/asAoQoBG?=
 =?us-ascii?Q?voLoIZ+4yui4pcQeIwNF0od2j4ouW8M6oOpP1kcyagv+dtsNOqevJPjHU0ra?=
 =?us-ascii?Q?MOtuBQCw0rHlYULDTASP/WeEKSvGestb9avVU7YUq5Qf7HBoR589p9zi1Ehb?=
 =?us-ascii?Q?MOYfp4XZOKbPJFFKUlhlR7lyY2IBRuuW4UCwVTqLQpOTkFSLx3YZHR0cyYOW?=
 =?us-ascii?Q?YzyE8dEEYpMRHPp1V7hXgnPKw92RAS5GIZInadeA8/63uk3FduGlPHpaWF3y?=
 =?us-ascii?Q?lEu70a9erSOfXR7B8fIp6Tvb64T2PYeVQK6bEEq4ItxVWMpQ0JCO4HdASC/m?=
 =?us-ascii?Q?okvgPTClyFV68jjkfCyHeNPhWSwQpUvheAjfoDe2p3OBAIuFMtG8EIlqLNVI?=
 =?us-ascii?Q?VSuyCtQ88r18sdUjcMVBm1mfBWjk/OlXSoaGHw5PT5lUmneuO7BW8v3VEXqS?=
 =?us-ascii?Q?+m8ajmYryTmGr26NuR4=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9ac4da7-2cfd-409b-8abe-08dc3a4ce508
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB3843.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2024 00:08:31.5527
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R0lfkIIVR+8RPN4VGO/4IONLw6m8QM3ldMZbzMM0uDu12Fjbmb9VGzOmZX3i8yme
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4113

--vzwSBGxv4TfS5vgB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

The fixes for the new syzkaller bugs I mentioned before.

Thanks,
Jason

The following changes since commit d206a76d7d2726f3b096037f2079ce0bd3ba329b:

  Linux 6.8-rc6 (2024-02-25 15:46:06 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git tags/for-linus-iommufd

for you to fetch changes up to bb04d13353885f81c87879b2deb296bd2adb6cab:

  iommufd/selftest: Don't check map/unmap pairing with HUGE_PAGES (2024-02-26 16:59:12 -0400)

----------------------------------------------------------------
iommufd for 6.8 rc

Four syzkaller found bugs:

- Corruption during error unwind in iommufd_access_change_ioas()

- Overlapping IDs in the test suite due to out of order destruction

- Missing locking for access->ioas in the test suite

- False failures in the test suite validation logic with huge pages

----------------------------------------------------------------
Jason Gunthorpe (1):
      iommufd/selftest: Don't check map/unmap pairing with HUGE_PAGES

Nicolin Chen (3):
      iommufd: Fix iopt_access_list_id overwrite bug
      iommufd/selftest: Fix mock_dev_num bug
      iommufd: Fix protection fault in iommufd_test_syz_conv_iova

 drivers/iommu/iommufd/io_pagetable.c |  9 +++--
 drivers/iommu/iommufd/selftest.c     | 69 +++++++++++++++++++++++++-----------
 2 files changed, 54 insertions(+), 24 deletions(-)

--vzwSBGxv4TfS5vgB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRRRCHOFoQz/8F5bUaFwuHvBreFYQUCZeJt+wAKCRCFwuHvBreF
YS32AQCGnBAKvxKIky4W1ejxXTF6Fju64Nf2DRUOCN6qtfxO+wD/fhhMqOUUW12I
kn7EPF1LIvkZemhb3VXoEAONqZqAewo=
=i8Gv
-----END PGP SIGNATURE-----

--vzwSBGxv4TfS5vgB--

