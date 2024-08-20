Return-Path: <kvm+bounces-24668-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 76C309590A9
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 00:48:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CC063B22D64
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 22:48:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD1291C8231;
	Tue, 20 Aug 2024 22:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="k/4Lqu80"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2088.outbound.protection.outlook.com [40.107.92.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62CFC1C7B7D;
	Tue, 20 Aug 2024 22:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724194124; cv=fail; b=cm3KID070A5CsbEJSwIeqIbAyVf/sDvbbeQfE/wNr3LhZCrcmxxyHjHiIGTUk0LKlL9h2B0/1CmPPNVAylyVCRmB0VABvcIBfhLKG0+TWCeZfhqzZm1OybBgGPzjJI9iqp9EDAFhIgmveZGyoBBaKngV/Blt35ec+mcv3NMozYU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724194124; c=relaxed/simple;
	bh=bGS7G9Ud2UYKXdoHYZ8gnirEc1ZDlIRmRK1JmTYlIdE=;
	h=Date:From:To:Cc:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=R+osVzXLPpVkGa/p1zU4I8o76K2W0a82bq7A7uBc9bhOJHu8ngoKFqnY1zH9/F5sYpFqAS3I/uOnhYsyRagUVfxdpVrNLypcFlhBB/kCoif6NpgwGTsn0W3/tBMvC8L5oMkRxwhcjyE9i29QOu4cw3g5zocgws7d8ntTW/PCdeQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=k/4Lqu80; arc=fail smtp.client-ip=40.107.92.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UzyVob2bnBGeeZkL3OH0NDOFqOGgts4qHmUihELxSjXeKz2Bojqmn0lZcdIOLNnziTpyRqIgJNXEcofGHHjs8wxBIqJ4iIJDFnsItqLDn6Q62IfFu4/AWuPkM69ywnDdr5HBe8y4a83fpe6ZcRm7HvZ5/AJ4SBdO7b8XkDxf4vmjwoTRRWyrK+V5P3MQQqrmSRtvQheqjItqo+xS9gmDr5+rHS/ZkXLf99wH2cdlo3epGsDnpsbQhTD7LbQCVgmZkQbYZOvz4qoY+YRILTOLmLz2prOPn8gLIoWxcYjcxmu8oe+VXc8JIWKyI6FvvMX8XgM/xVI+MzARQX0fonsLJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SwrgwGlSRMV+7dNIS3jKlk7xG57Bdxd9IeXdDawlKc0=;
 b=Q1xekIwYO0grIu6PnS/RcTVNpL1UD5FEUkcXUlJqQxxo2vAOx+oi6cTy58TALCRxb2oC79L1ODUxKGDbuIiqeJX8mWt4JHof7Q7KkSbmeSNFNdeJIrhWKgT4iJp2kWfPun2cvnEFeykcHgEUkcpEcNYFGQu8q5cWfg7kAi3DtPQ7UvYuWQR/Lnb9KDZz1568xFsdxbyzpaFrryWFg3jpX4BBrcj/J/BaE0bhXPrsN0A3BcWvg1heuranbD/2jmNSp88cOoaseaEkso9F17u19Zw5hoyKEkCyfTBWF85zF4RMmwo+wDP4rqWhb4PzpcJkXVvAqQTKQQ54wkOK38k9oA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SwrgwGlSRMV+7dNIS3jKlk7xG57Bdxd9IeXdDawlKc0=;
 b=k/4Lqu80zOLU5e2XHhpt4npJOfda3t5CI1xJRIIo/D/3+/u4AhlfQCmshFlp4f++Jeds+uJd2R9MQRCgfN2toW8JqfDFcYaylwO5tBarcqREkatsOkHDM4nkTZOoesQYroF90udUc3AKJegHdJJGdDmYb50omPaDn+R1IUZ6+InRz1Z94Ud/hOj+I+dqKpWkD4n70LJdPYwxs4utzE/FvdxL6jTtXQPkg9VaDxVWKmktTrmTWsRAK1MpWwXfBBUI231wXWdzFXfa95FkCYBVHl+BOBg2u2DwL4Cmaa9Y56C4sfhqp6sm7u5OB/Q1yU+qA9tbAJ1QOV852H/k2ua5Qg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by CY8PR12MB7610.namprd12.prod.outlook.com (2603:10b6:930:9a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.27; Tue, 20 Aug
 2024 22:48:39 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7875.023; Tue, 20 Aug 2024
 22:48:39 +0000
Date: Tue, 20 Aug 2024 19:48:37 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: iommu@lists.linux.dev, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Kevin Tian <kevin.tian@intel.com>
Subject: [GIT PULL] Please pull IOMMUFD subsystem changes
Message-ID: <20240820224837.GA1570264@nvidia.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="znwk1F58Q6lZohaG"
Content-Disposition: inline
X-ClientProxiedBy: BN1PR10CA0012.namprd10.prod.outlook.com
 (2603:10b6:408:e0::17) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|CY8PR12MB7610:EE_
X-MS-Office365-Filtering-Correlation-Id: baaca936-b6a6-4377-0f5d-08dcc16a3b87
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?nvCGdK/amZE/AH2Wj//iJVfBfpok5kbtX413rtaXQrPTrAebbeklphJflWOD?=
 =?us-ascii?Q?//a/RQXyAsn0KNKChBUq38RsdFNCYO6L8vABkVkTwOEUm4TRTKZHtYMLGIMN?=
 =?us-ascii?Q?z6Ralv71qL4LN1n6bel4eSiYYQmms3CLFGG89mh3vrOXre5zjc20MFpcVZnr?=
 =?us-ascii?Q?N2usB9UVxey+Xdfelm3PuQH29QXoENgU1pJJv7fU7Zw9uf/RgXI5WDPtOfHI?=
 =?us-ascii?Q?fSJ6wFt1K7ZL9+3o/B/tflUbrhgtuET0/UFqR5I+7Xukj5TuNIs4UJwcmo3k?=
 =?us-ascii?Q?7Vlc77Y+l7e8MeHPF5niZOHGT46+QF5oJko6pvMgIRJRYZZfV8YFGKeh4Ghf?=
 =?us-ascii?Q?dMceofruxyDearV85GJk5DKjcwacOxImthltMThS3sqKGM23IfjNMEhp43SU?=
 =?us-ascii?Q?ZvRfOBcBODrRG+To9lsIq16MXu7kYuREaUsQJHChSbzxQ1RHGUDXdV2bl7S7?=
 =?us-ascii?Q?Zv50KPMteQVR9VXHjRw18TvwIm56X8LU249famPfSk5CM/hMV6Jg3uDn8hpc?=
 =?us-ascii?Q?y+i5ifCELDLErj1tGv+FHKR0RxLEGAsq8jRO06cvupLRr3yIi2cXkwahQ1+9?=
 =?us-ascii?Q?f1SaHHNVg+S+MktHoj7dvZJfRr/tUkcYuDEoOthZ1y+wiz/ShRlHChMFoTpr?=
 =?us-ascii?Q?94HkpSnhcdF2q61+AwJ/o51lt9AlejZp3Cv/rsHRw6gZPK+q5zJ4jtkSrTl2?=
 =?us-ascii?Q?8W2zOiz6AJdunAbKKck/5/odZ9tzjE+5AsJJnoxSjPg5IZgkXKr8ES5Km2fM?=
 =?us-ascii?Q?ihksXuKxSFVFWVj0gm33mKoY5ZyNd/yoWhj4/m5EYoWaHMU8KyRXU9ULaAn7?=
 =?us-ascii?Q?7pIFSVMozEaEdr0uBoF6l5gEWxiMCAnwDkeutXTp/yU7qHx8lZ7Toi3WzgPn?=
 =?us-ascii?Q?GBghGOznj5dyVQJzALSsUO4o/aak0Aa23FkrTREFVGmYeNLZivnl9wwhrzz0?=
 =?us-ascii?Q?dVg7uUkgRgr4nYCttpxa2wTH6aLf7RsnNZFH+xY/0un820KnNMsTrkypXtVn?=
 =?us-ascii?Q?KHx7L5X9ymXTazRzfgNXH4alvK61Ia/fIStZPD70OksIK6D/H0bGeNJi5BfY?=
 =?us-ascii?Q?9wSfgJUGrBuOUhTNMo4qaFk/YiTE/YyBoYXR+vJnlPg1axdrN74a62taXViu?=
 =?us-ascii?Q?zHhRvZ1g6GhDDtNNWW2n05pDfLGN8ZrXYyih+cXvRzAxJCnIxVYToIyvlAtg?=
 =?us-ascii?Q?uetAmydKOvNMd9RGZAaGhy+C5BsrUSWL/5MXu/Ha2Nj5C3uWTS3tuX2wRQbb?=
 =?us-ascii?Q?Dyvh7agsNAoMoVDF07aGWRRU/Ims3/7chuJURRfuJ1lIysQelFrdCBv4W8PJ?=
 =?us-ascii?Q?JzgFK8n+Wju6mFsE1hzrLeDzuMPiqpPvMMXFUXdmilD60Q=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kkidLVoo+mi1mALv43dSqhRSoJETdyiJ1GiUBkXHZ6QU8c8PEm/cUA6YnNXM?=
 =?us-ascii?Q?6UNEcWuZXwUe8CNq+iUDPiSxlXahj8vK8sV+eX+FRZ9ldCeXzdc/a5o+aQVx?=
 =?us-ascii?Q?hZGAwSvIVAQD7FZ80vZoTQBI24znwuOkwvJsRnDcmAYq//gvL2Oliq7vKyKv?=
 =?us-ascii?Q?xc0Za2q01rQm2y3nQbu3kIG17Mg0ePv24+rqdLhUiTRVLo05/1sBy9yqGkjX?=
 =?us-ascii?Q?Rzky7WN38cXxmKTaECIzZAj44Ddre2hHy+9d54RzECXe+iKrZK8fC/WTOTEC?=
 =?us-ascii?Q?Ra8gtsTkV7dQrxJt/EAmfARRkbUCqzUXAL7+xw+k2cklqSKleVre0zzdk2KK?=
 =?us-ascii?Q?F7l9BMjPaY/0KiuWhKOoZ9CgI8agGCrIFT3zR2ZeKRjr7wXKRW34g027LVaM?=
 =?us-ascii?Q?RQXRNp24hTHmpLP2No0Y4lagpP3zQK6YeMQIJiIzuXC5502DYTRn0qRScAHe?=
 =?us-ascii?Q?tnAakWkMhBLCl8fz8kqi1CkZ3wavFIlJwXFwgBaaN4w55VfU1oYQpnpBgrZC?=
 =?us-ascii?Q?BZ2rV2OpH0QO6s2ClODQktss3DkNWcwjNYS+agXNdk+eaNNdiKiW721koWQI?=
 =?us-ascii?Q?GE3ZB8PvS6zuqa0+3X7EC0xOWk5/6/+ITQUDPiHs7KPohSL2SxAdJxSZmjdv?=
 =?us-ascii?Q?BXbfhY00H5DYwUtSxmf2m6ni21oM55JLEhJMOKLesV0nA4oZzMdtffSwv7Vq?=
 =?us-ascii?Q?u507GxgTSCCIazq23PKU/oI3FctzSdRI2G81FsJ3jJz25VlKoo8hkNdFqanY?=
 =?us-ascii?Q?bJ1NyZbp0uS0geT/xlKkRs7Pz+3Mq+7xrovdZ9fI1nZufv01ALb4VOFzkCgT?=
 =?us-ascii?Q?w4X3Eils+GPj3OFBIGQjnGETS8T1m6yXQzdxpSxf2K60jMcDPWqVx7B8Djnz?=
 =?us-ascii?Q?LWqiJVaWTQ07BS0FVyKsYrp/3lgqCl7dUpeOaCAZVBhmzB2famxdugwLYqTN?=
 =?us-ascii?Q?Nnjb9wfekGpFPRo84hWrRUtAbAxboO/eTlX25Km605oXXUOnlUjpDkzfEuqB?=
 =?us-ascii?Q?eW/OFiyOEYj3VsddOjSe1aLNDa0+vzFkzxmXUg+oopbDR1IFbQZVBA/o1f3J?=
 =?us-ascii?Q?XfgixJ6Y15bzz2rTrKa+dQKlsPZD0HRzwZ31goXsCZ667FCnqtakZLgwaC/O?=
 =?us-ascii?Q?KdnlRA0+BCBD+NBHDAQqnVw3EPHURDqONZzjzY46IhMAfPpB9HsMIwFDjR4T?=
 =?us-ascii?Q?MjV7eQsAMWGwVCA53aAVLPjPQrJyMG5PokM7yg/iZ2TZtuqi4+AfTGl4jqYW?=
 =?us-ascii?Q?w/RnNbRPQwrw7E6YCxfdmOuImhXiw+4j3hIuEzvnSEI9wUxCxymc7Hp3hfTP?=
 =?us-ascii?Q?KyDagxs7wMbrNh4m2X8biZoN6O8NWwBB25lWy0BvKJK6WPknkrOfqFNaLIrW?=
 =?us-ascii?Q?zmxCqMgUC8RKyiigMQo0ma043mAZIsa2S+ye0fSq6JVOyoJiu6Y3A9SvAPWZ?=
 =?us-ascii?Q?dWSfjzsSf11GbJYmmq/pFIQREG0/MQNYkYclo5cXu8ymbwFVcAHd/F0uJN2m?=
 =?us-ascii?Q?UXar11BqlOerB6HMU/8Z5GIVNlVaqUNnQ6+WA2IVipBhWt+/BLfM3HD4MQXu?=
 =?us-ascii?Q?GWrYp7Vdg622Q4vNMVDwDjGt0U9de4uljbni14fO?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: baaca936-b6a6-4377-0f5d-08dcc16a3b87
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2024 22:48:39.0483
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G3WC4Pta73zdO0T8ARYx11zTifr25PpeRMLTlzGQ6wldbBoYO0+fE+JF1WKw/plD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7610

--znwk1F58Q6lZohaG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

Two small RC fixes, thanks

Jason

The following changes since commit 8400291e289ee6b2bf9779ff1c83a291501f017b:

  Linux 6.11-rc1 (2024-07-28 14:19:55 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git tags/for-linus-iommufd

for you to fetch changes up to cf1e515c9a40caa8bddb920970d3257bb01c1421:

  iommufd/selftest: Make dirty_ops static (2024-08-19 09:26:41 -0300)

----------------------------------------------------------------
iommufd 6.11 rc first pull

Two small fixes:

- Incorrect error unwind in iommufd_device_do_replace()

- Correct a sparse warning missing static

----------------------------------------------------------------
Jinjie Ruan (1):
      iommufd/selftest: Make dirty_ops static

Nicolin Chen (1):
      iommufd/device: Fix hwpt at err_unresv in iommufd_device_do_replace()

 drivers/iommu/iommufd/device.c   | 2 +-
 drivers/iommu/iommufd/selftest.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--znwk1F58Q6lZohaG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRRRCHOFoQz/8F5bUaFwuHvBreFYQUCZsUdQwAKCRCFwuHvBreF
YWbtAQChaoEie+AFcdiMFnMWz0O38/1uvP5m091LI6gBz5JcswD9Gj+zdGJmyBdV
gdP6Qp9Y+9aae/hXD8SGEjt8bX8mJAM=
=Kmzy
-----END PGP SIGNATURE-----

--znwk1F58Q6lZohaG--

