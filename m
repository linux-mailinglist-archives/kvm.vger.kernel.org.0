Return-Path: <kvm+bounces-64511-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FCF5C85B96
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 16:16:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id CEA444F166F
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 15:10:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B13873271E7;
	Tue, 25 Nov 2025 15:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="SUwqcVXL"
X-Original-To: kvm@vger.kernel.org
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012067.outbound.protection.outlook.com [40.107.209.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F757218ADD;
	Tue, 25 Nov 2025 15:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764083351; cv=fail; b=Bgwz/6QRGFazyydfAt4/GebAwXUXEoz4JSpjt+70W/ulRwpHsaTd1Q2CaOmIkMNh4eblsoHfF+y0zLtu2bOTrpG/bWJ40G3UTdX+2LXbxpGQLqdaIxXNiJ8LqmX+jB6r1uVtUuhyROrNmVgst0Om2Oo8gzTVuZIbpQ6reL1dK2I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764083351; c=relaxed/simple;
	bh=AXGGkJeajkAcGebgDZOd6bs/r2tHeZzTE60F2wMfZtw=;
	h=Date:From:To:Cc:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=n4siuEY5X2Otb4j2vCHyBGiIGhjQMG+2+gKYYftcA9QKqfrSUN7n/I/m3Rx2DJFnGUM04lUy0booaaQYt+sdAqQBcis08jhUckmj4VeOgW6/N66Zg+jtS8QXXxJxDodKdyqBicNT8CRi0derXbg293qrICzY6+jwTKoHR+TcOjM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=SUwqcVXL; arc=fail smtp.client-ip=40.107.209.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=clDLkO0eEjQIuLYkWF8Tk+4ragy8lrbVEdu6Wds8is6r9GohPSPBc2CBJjl/5PGUdbeCZjq55FvL1cG/hGn8WKHp50Qt+oBwxfbeWVUa/baas4HAQRrDBwQiPv4gT7txCEsqBy6d3zeAaPmUXYehVMKfk0Gg1iTenqGQn99t+L8aTrsD18BMEwB+efVz8zS779GDh0K7e9GwGyCvFlRIbD4pl1FX99AXf/JkK0ksQlWc4B3UR60v32aOZBo5rP91alZP4DYTu7jM50b/2YCUriKvmsp8XXb+VHPJLGLuudo/f3+D8fHTPm3OL1lNk7GDqkEVFcndi372mXekKL8CbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MYecRZhC4cpLoiWjtWriMHYlRTkNra54scMvqXYf5gI=;
 b=M5sTGnjASaP+TO2/3+8GDVUSdmcSNxmdqb6Izl6BGpQgCARHMz2JmXO9mj9dTP0LU7O+2b/dHAIeAeM3yKmKDS/r7zmU4kwrWfjKXn/RjQiKbm4iYZ1buBgJkpLnAH2DmuDcCOFdyAkabtPJYWF+8UGqnxflKpq4AESSPwMRV06mClZEHzAGKCBtoYV7L6WPfXaeJiGyZt9ZOAUt3M36EmEuPyu4pYJREVIobViv/H+FT/lqNN33vWcp9qsRvR0uEaDzwuD+FSl9g0lx5BrITStYapIsfzMy7ePs3uccsReI2frA1nX/w6Rf8m1805Ti1i1jYpyFkCB04DWgHafTaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MYecRZhC4cpLoiWjtWriMHYlRTkNra54scMvqXYf5gI=;
 b=SUwqcVXLaHjIPr3Yp7tpZ72SqSrdO952C7+MQOM1haKY20xHlhhvkhcW1B9aFUuVh5err9bM1t0IcPOZYf5sG+QK4AHB6u+c0UR8X5GPKqai+k74rw5VH6mPLFglQgf1COceTppPhxL8jBjJ//QSurJCej/Kh5e+fr89GnUBaIwYa1VGEx3QT73hShWyfgRVmp/oDP9LccqxhLB9RbqbO72JJFrunl2DLykd0IfZu3hTUnM86am0u84/icq05n1PowF73g0egpavkbBLJH1uoLks5WZoL1zhXf1TAdLRn5XNKwAppaGpKt9iKyyySPiWKX56VKpqF/eEzAYZZp/XYQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB3613.namprd12.prod.outlook.com (2603:10b6:208:c1::17)
 by CY5PR12MB6455.namprd12.prod.outlook.com (2603:10b6:930:35::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.17; Tue, 25 Nov
 2025 15:09:07 +0000
Received: from MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b]) by MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b%4]) with mapi id 15.20.9343.009; Tue, 25 Nov 2025
 15:09:07 +0000
Date: Tue, 25 Nov 2025 11:09:06 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: iommu@lists.linux.dev, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Kevin Tian <kevin.tian@intel.com>
Subject: [GIT PULL] Please pull IOMMUFD subsystem changes
Message-ID: <20251125150906.GA520978@nvidia.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="qbjvUKhLNjlHrtJR"
Content-Disposition: inline
X-ClientProxiedBy: BL1P221CA0018.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:2c5::30) To MN2PR12MB3613.namprd12.prod.outlook.com
 (2603:10b6:208:c1::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB3613:EE_|CY5PR12MB6455:EE_
X-MS-Office365-Filtering-Correlation-Id: c31b7005-ceb5-4f2b-8d7d-08de2c349475
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?igMCL/U0e/JY3wPh3ghPENwvqOKAPo4kiG2tpMD5cItZriqDIGEpp5hHcpvN?=
 =?us-ascii?Q?4cqy5FSnkW95/eGRlELl9dUzWqM+IGGAGSBmOH8EFA8Sn5XJMX82SKCk3IfN?=
 =?us-ascii?Q?wy1wLqN+wOMHYncsPmpLxw5lHRQGQFSoUq9rofmKWRtBkAootqQefQHGDLGB?=
 =?us-ascii?Q?omck1bEpziG0k8qkHZUwQCJp9ojW3I4Aa6/Xu7/DtkV4zzlWN2xIzcQQWi6E?=
 =?us-ascii?Q?BliRyPAAsh9yVF7OdW4uyYF9rSE9/eZmY2/S8ooq2dT3x/2EmTK3+/eQQElD?=
 =?us-ascii?Q?KL6GiCyvR4+4qhfOfvTOpoGjrYMWQ4pEEkUrzsuZZY2ADIE0rWaWtXivceBu?=
 =?us-ascii?Q?qg+zUDSOrMxNU6ATcvwPm5zJc8N+P4+0yNNN+mNeMmq/HTgndgd0x5f6kz7j?=
 =?us-ascii?Q?C2ecHY5xA0vZjIDeD03SkpLcSwPr2CtzhmdFJGz4c1YdBbLFpT5lNkmu5OFD?=
 =?us-ascii?Q?YMBJyy8erNIWo3ceXXfQkSILrLRNjbrt+dVw4xSv17RguwTMQa+j4h5s82iE?=
 =?us-ascii?Q?OxBTX0UMsFUJE28/5lvEvDeFtd6LFhS1n0QYFa9CcKkxUiexXvaWbcUAMw6Z?=
 =?us-ascii?Q?DySYcRBt8NKLUmR6L8smqKLafRGmSy0BYVjwUYBNtqiGXt0QBHk9/V9gEskR?=
 =?us-ascii?Q?PxfRxAtgHTVXJErxerxW7yNcy4i+2UR1MzUvbl6+INK1bDDyGyxEcECLJVT7?=
 =?us-ascii?Q?TP15Z7X9nTHz8P99E+lbeZw6q71nu0hD+f86H1Y7gSH9cbWADzxtrVUbx6hY?=
 =?us-ascii?Q?J/v/tohq375fhf233Akm/SeTvdCB4QPRSMzpY6YIYHZpNAN2FE90aNhNnz5n?=
 =?us-ascii?Q?dvfNwNiGLPPcbXvXh23JFnnGn0/8VxbSE4XvidRommepFfYZYRl5sU9ej68s?=
 =?us-ascii?Q?gsp9+aURBX6A3FhnbKF/x9sUq8FwSw4wwbDPKT5TkMvAxcvPomHzPT4ZSVc6?=
 =?us-ascii?Q?k15Q4yeS+UPROU2h1MM8QvvHGeJ/4slFWwUIbYgqPw4wktpqIzm4eTtcnYUz?=
 =?us-ascii?Q?/J+40Q97n9ZFsTRopvnnIfwJeQO+OM4pqi0qzXyYsyo5kxWnf2vNeHBCtF+6?=
 =?us-ascii?Q?wuB9PxDKV0v1u1KrObUJOh9nNuFMXbx3tehHDLMpinoJbqYUmmjTZx/hv8Ex?=
 =?us-ascii?Q?OrL/S/zkg3p+pQ8mGOZaTt+jzTWZTYicbpxb6/ZHgjsCNzN9D13OulCRrZ1s?=
 =?us-ascii?Q?0muUp2D17ah0QYlC9hWJDubhDa1xY3dnHS4T1oXkSIopiZE4Yq8LowyacDlB?=
 =?us-ascii?Q?BTkhwe614Bs5vaHZMVkS8O9fJWfwGrNXguE1dF3pQukA0G1GPGdMSeeEqYe0?=
 =?us-ascii?Q?N3nY1nML4yw0dQYIPDsD7Up5bwp4v6oYarCcaKDYIIpXctUTmccaLYv2GnC0?=
 =?us-ascii?Q?pUQhcd6TjjizgfSB4pipgdyseT5ljcK1+5k9n2CT5+PwO8ldi9K/Ekf7LP6G?=
 =?us-ascii?Q?Q2cNFB+Akryxnfz0I+Gwh2T1jnRYOtTT?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3613.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?W1R13/3aMzRpUZ9Q6KARx0PpJId1Yncb8EyJovp8T2oXSZabHuu0c+j7WJxR?=
 =?us-ascii?Q?2m0+dfGAedx3Q15I9GBvbKJ6+nNNtthi+rE4Wl6aJhI6JRcjaIvo/cMf4v/e?=
 =?us-ascii?Q?iysx9vNOlBqnL9L8vjWpJBGhUorJ1VrESOwsjECNZBSHwzbUNGvwKWCF12wL?=
 =?us-ascii?Q?8zANjSoik3QGs2ojzBd/UiKfv4jDO8G/hvfbxVNY2T1Uq8faP8eXBTp/dN7j?=
 =?us-ascii?Q?tH8xUYKZmcANnSGf82QNE7acy2bqD9n2QvNALw59msVCMurUACXu2Jt0hSM0?=
 =?us-ascii?Q?JRLswtHb8hApbvBqQGYz+e4OOpqSWXtGIKaMDvXqRSwXjAEpldZ+LoLEbyFf?=
 =?us-ascii?Q?6gYaZ8dJaxA9MvzAu7QKN5d0I5c8dOH+zYwagzVslu3X0mhOovX+upPSWzT+?=
 =?us-ascii?Q?3vUIB8e0+BdjdWOalpYt7xj/NNcQJpoUiV4OlalQ/D7cMr5LsqQTD3XSeZW3?=
 =?us-ascii?Q?0YpCWW8l66XARo4c6t4ez7JOIgLSkaxE54PJmEg22O07xMadmAVWTyWdSlBK?=
 =?us-ascii?Q?oe/Kic8QwLbfhQHJR1MuwobmXAZpH/9RCl/S6bv0kSyR5Z1IM1NJqykI8Qq6?=
 =?us-ascii?Q?LpFPCz/VNxIk1dc6iYX0ZQefVMgJXPW+bS+VW59+wShbyM6hWYMwJcLHekb5?=
 =?us-ascii?Q?9K7v64Q1c50AmQYYnV+386EQhCelTJ9sU1UiP6XSMPMH975TLCHB/CSCxFCe?=
 =?us-ascii?Q?msz6FNi/Ns4wtarq8dd1auwZKcoCLCBarVUoD5eKjjvf4nr4fxXzRVs4IP1I?=
 =?us-ascii?Q?K7BgPkYra6XSI1H63eX6eh+5zul5Ss8pd32ZkGe2lUnkzE5r4qegyJzP+W8J?=
 =?us-ascii?Q?OnZRjloTINayOeBph0GvGerQ0gMyHHtJeRR3EKU23Qrns3hz4h06d3oEL10L?=
 =?us-ascii?Q?F4RiOsxnceaeWaryYRKmAGueX3/4XSZlSl83t1Fu+T0VAMwUUJayMcOkoaIe?=
 =?us-ascii?Q?1WKuI6mQ8u4h9DgntFdjsxKYkgcGRiuRBdyygTtgYFZ1T/TDxH7jKQzZCPis?=
 =?us-ascii?Q?jhu+vMkQwCRAmZW98LAzw8KwIS14BISBuYsZKMp6liAN7br6jSojeO8My9t9?=
 =?us-ascii?Q?40cIfVxXxT4oWVUErDW8HyQ7yK5Dk1lR/14S7LyOcwx+qhwl3urbxL2u0z47?=
 =?us-ascii?Q?cojkaR8xQeI2eA0ltKAUEdgwLmk7bti4xOI5LyRy0X80tYIkGv+cWcDv3RUZ?=
 =?us-ascii?Q?u9YYgG4Hc+TDap5i0l6JzlyQet22TzCbnGMELd3yRSviPnlAx56oMvtRoENB?=
 =?us-ascii?Q?YSxTmeE6sj9+ZhMINW2wDD2yOUIyjdlTAUe3t76Lzftjed2qaRpOqc+e3Set?=
 =?us-ascii?Q?rkGKeEPQriM4M1KcuozpCrF8VGRrMN2zhynOiUdC2eGoqOQDnQQmZjwOCxK7?=
 =?us-ascii?Q?Sfl0/MzLW2afDJrmJyZyyq/xDkj1twlemQNPVkn2K6MN+f4LMPb/7Skxkx6h?=
 =?us-ascii?Q?qxTVzhFu84pBALK5p/W0FACfiUcGzD76c/CKv5P5/JCDIBRKOv4tpeok8swm?=
 =?us-ascii?Q?UDVTeX9T972M293aBDNHQ2hKl0TGZp5JjBMiK21UClsizN/OlfkTcYJYCqUu?=
 =?us-ascii?Q?fsFNDcR/MzI4a19Xm/M=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c31b7005-ceb5-4f2b-8d7d-08de2c349475
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3613.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2025 15:09:07.4745
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fx4diGv5AFYGCTrddSMNGXlBKRKxx7oHB3ww440rVVfQcFwMBRU/zPXGc1vXJGIE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6455

--qbjvUKhLNjlHrtJR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

Two compiler warning fixes, should be no functional change.

Thanks,
Jason

The following changes since commit 6a23ae0a96a600d1d12557add110e0bb6e32730c:

  Linux 6.18-rc6 (2025-11-16 14:25:38 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git tags/for-linus-iommufd

for you to fetch changes up to b07bf253ef8e48e7ff0b378f441a180a8ad37124:

  iommufd/iommufd_private.h: Avoid -Wflex-array-member-not-at-end warning (2025-11-21 15:38:27 -0400)

----------------------------------------------------------------
iommufd 6.18 second rc pull

Two compilation fixes, no functional change:

- Fix a possible compiler error around counted_by() due to wrong initialization
  order

- Fix a -Wflex-array-member-not-at-end

----------------------------------------------------------------
Gustavo A. R. Silva (2):
      iommufd/driver: Fix counter initialization for counted_by annotation
      iommufd/iommufd_private.h: Avoid -Wflex-array-member-not-at-end warning

 drivers/iommu/iommufd/driver.c          | 2 +-
 drivers/iommu/iommufd/iommufd_private.h | 4 +++-
 2 files changed, 4 insertions(+), 2 deletions(-)

--qbjvUKhLNjlHrtJR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRRRCHOFoQz/8F5bUaFwuHvBreFYQUCaSXGkQAKCRCFwuHvBreF
YeItAQCI1qAklScdT6ry192vrY06FH6PLh0gFibHRJrN5oIErAEAwQblnIR4ZSIl
qdNxMPkccrikCrN1QSFZ8u13uZbrmwQ=
=8EUx
-----END PGP SIGNATURE-----

--qbjvUKhLNjlHrtJR--

