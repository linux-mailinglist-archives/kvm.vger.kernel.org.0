Return-Path: <kvm+bounces-32166-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 06FE89D3E65
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 16:02:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BB0992851C0
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 15:02:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEA091CB301;
	Wed, 20 Nov 2024 14:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="qFYYkkzS"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2064.outbound.protection.outlook.com [40.107.220.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB4441BDA84;
	Wed, 20 Nov 2024 14:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732114433; cv=fail; b=kvkmP+F/aC5acOKpKWJfmrzADJDbJ8fU4KUcEaU1UvO81RGIf8C47Lq4113HwK1QYDMrbnHAR5d51nOn5CcRvF2XF1kf2TUePP3mq0h8Q1wSzzT2eWuTMk+l9/8aYyc0T+i0q3JptbqdZAFvLt/pqr2B/oNcYC9ZU+s//j4bT8o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732114433; c=relaxed/simple;
	bh=gbKeXGurhruIPkDYCOE7lb9sX83RNQvOGyDYhTryD5c=;
	h=Date:From:To:Cc:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=kMpzaZa+11YK6eCV42VOhP/jLkrFwAW8GYgYxWMYkLmhVQ/NKtmv1OErQjFaABJdcCbjft8qrL0R5ngZUz7np9mJdr34QETCZ6/vCXydfIAGhdvw6B8NjDPCvaUzy2Qn8AxTH/H04E9METAbbZ0SSxvsfs1d3mLVqGP2ca0TL2c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=qFYYkkzS; arc=fail smtp.client-ip=40.107.220.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hzM/b9WoZcS9cZq47OXnnIXZy0JAOhmk7wjl4CmlwfsvOmtKfWpjuJiPKEaEg7ViM+H/BzQ7rkeLDYYvgJbg7oqaLn5UW6y9yBorVuDJxm/0igFnCsZRpLN/KM9vk3NElHUv6xFKu4+Hj1iBUr793zzNAt5k5OJghcC1y4aQkSiSjaD+QTZ+PaZjEh4ggRLLT/7VpdKZHDA+WQXvlASyVNXttfAlUCwgFH4MVRiAMrrYnaxdy8ARjjiK36e55TDITz9NN8wQpGi6bFudpruNzJOs+OghhwJxj56MCfbdxkh2FomhMJACiPehLPe/bPkKbBXkkv2QWI/xfM2zGPU1cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9H2dzSkXOYTnAJaY3RtEcS02BtKEDTusyAwjrMFQCRA=;
 b=INwnMoN9mIC5HxaE/uIEM5DkAboalAFaHfuICT7btjVEaY63Wz/o/HPw9Lg+VVQ1uu+DqXrmZ2s6yBjxRdkWEbWvoQ87QzjgArukjuRmwWfBXPG660rjqelwsxgZ/iTWUwsfuZ0B9UOjDUlGaB5cX4hdQZJhKuF1zOXll8ZPqCmxEc1W73dK4e1cdIFJk6WnPpxq8sqdGgz+omR56YGSvkVNFTl+c8rT56RatR1T4thhmLqnBVWJpvISNWua14VEm7dg4SwNAYq6Yv4hp2YbOrq5DgFCIvCAWuP+ryvMNmRpAIiBNqF4jdvQzdA4b32H4WMYjjhUt+RJWklD0zRRkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9H2dzSkXOYTnAJaY3RtEcS02BtKEDTusyAwjrMFQCRA=;
 b=qFYYkkzSRJZAg48P3CH2CEayZJtN0lcMSMbOkIEum+JBBmxpa6kP17ejFLWTAMaO+eilDO5s6suMH1oTRLma2TyKNXXEnRf8Q5VxGEJfHHoCaIYVHeT7cor3EkqYVpQ6qPyCnoJjcmt7KBWoE1c/ziA9t/4sdROHrESlZsDwd1yoFJOFGy3P3Bf5M8PFOHFBrt0MlJ/icY+SeGoty8ygAwPXl2VfkxcVxUxCHgJnIIVggchmCg+X/RYgImcxxVaZ7FRXHcXUIWz/eoakNqOq38hehWtHY4trTPsPjATlZBLFfiU8VXs42/3mWXQ8HtFiD36TV64cyZwwBqmWAdI1xg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by CH3PR12MB9099.namprd12.prod.outlook.com (2603:10b6:610:1a5::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.24; Wed, 20 Nov
 2024 14:53:48 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8158.019; Wed, 20 Nov 2024
 14:53:48 +0000
Date: Wed, 20 Nov 2024 10:53:45 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: iommu@lists.linux.dev, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Kevin Tian <kevin.tian@intel.com>
Subject: [GIT PULL] Please pull IOMMUFD subsystem changes
Message-ID: <20241120145345.GA811296@nvidia.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="11c9dN1vCblxRVbY"
Content-Disposition: inline
X-ClientProxiedBy: BN1PR10CA0012.namprd10.prod.outlook.com
 (2603:10b6:408:e0::17) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|CH3PR12MB9099:EE_
X-MS-Office365-Filtering-Correlation-Id: 46579ed1-5d7e-4a9b-c0c1-08dd09732385
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?QwXwyzlCEAolkMrY+3zTs9Jz0h6EEbLFd/vA/yFUsEp4+50gtrQAClTeSWJi?=
 =?us-ascii?Q?oERb8Q7fJ4RNs1QUT2zuA5oiPGPr4AehdtSNOa4hDPtXvkTmWVEyHn0Qk6fQ?=
 =?us-ascii?Q?nDSC5RL8b22o9GPeC6qIqIUL0ZTFmgOTGHhvSwSfLDCwSNqafoLn2QKlSaLJ?=
 =?us-ascii?Q?jEfoWotqG+EmK4hgMqcY+vdbY9V38G2QmkjI2+kJt0727ysODoswOuMbe2Z5?=
 =?us-ascii?Q?vxDG+YuVbg/rKQ5YJzdpPfVcsTpQq/9EWIvOqa8nILM/EERbj/rqgVtmeYnz?=
 =?us-ascii?Q?1pdXuSX7qwVKqfqKv3+AgkJrF8grlr4xF5vAFC2cWwf9Nklblrr0TQ+yriUU?=
 =?us-ascii?Q?BJMgKehOQt5zfv11aqav2GL1pBK2hHndoMuJyTZHcSHF94/QJkZZICJBYpvv?=
 =?us-ascii?Q?feBys1vfpvamCRZbteTXVdjiehSwXybdy6mqdnfOOfMqIRJUnnYG2HRCsRBW?=
 =?us-ascii?Q?SGgZdDMrDNmLzxz4U015itDauytRK9yyj0YGELXkw7BZ0n8FARCC7ggeBYFh?=
 =?us-ascii?Q?vevw0BPkwlxEWi4PsuXzCgrYGOVOH9Izy1UPkcioErY4IO0h8jyamWhL8P+j?=
 =?us-ascii?Q?xeQ4f3gQoaG+VQ2ZVFkmMcPRNMUJxUxioSRa3kWNZOnj8T9DFwI1tyMVagoz?=
 =?us-ascii?Q?EWaM9DSWkBGFbEiJ4ShQnM/xoVwvq2Kj35dQtg15c4bdCrolSDGnSJYv3j5D?=
 =?us-ascii?Q?OpXVPyN8OwJHq6rekhMjC7W//OrTTI2FR5WEzbbD48N7MfqzlvqBk9O8Vg2H?=
 =?us-ascii?Q?xy77TdDPJsieEzYu2dZIJ+ejwxWYAi/FofIfmeLO1UCtE9RmD0cQFityTsEi?=
 =?us-ascii?Q?HkNuQuCqCcXPLm75iyh9Rz6iN3Q2bfShiAdDIUPySUxABevnnk4oDUynCQSS?=
 =?us-ascii?Q?SO3+9pZiq12tF96xnm5o/ElssftwcWu5KoJ7XCFzmoIaN+WlII3w5Jn7E39M?=
 =?us-ascii?Q?SOPl6gWRuZnGN23i5ziOMBR/MzRQVSqm+TLX9BWcpi5NJnZt6DCRh90obeNa?=
 =?us-ascii?Q?QmJ+Y0+AKcOwXk5brwngE/MQPGGzHlSazHGTCTsRE9Mw9pPGUHYEL6qxaok8?=
 =?us-ascii?Q?lBW5ETBWbdH9JrAF0Z5fZaYznEjZ28TZq89ILHx+rCcb0Uz19PrteQhUvtb3?=
 =?us-ascii?Q?/luFAad0Yq68SJKTw6BCUrD7UjEdQDHQQSDXf1MCR6Q/2NROaSX08T1/Osfb?=
 =?us-ascii?Q?rzuMG1Htkz/9vyz6zVTO+ZnqIHxRe8Wlr9oVBtwc9syy3KLyE9HvYFBWtb7G?=
 =?us-ascii?Q?raOg4EZ44dR5987XQsx6inoGnb6kRlIROL5gHXl/vliGR26GW5dR8asskUrx?=
 =?us-ascii?Q?wS4LDHqD82+GjnhWjqhkrY9w?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?eHrNMPcVOsxbbz94dyKmOtGVwPtGqrqr3zWj41EhVcHPuX2CADhv4JwlFYcU?=
 =?us-ascii?Q?dS23IAcxlTNd2pHkRpVvieY4B8BGIdjuNyTjc1BT0dlFC1ycCr2wogoKwtme?=
 =?us-ascii?Q?8iatIBQRz3YK+yLW90c8VwLCzXRpvcN8mdU9psDEv63/g8x87hu2L+nuVute?=
 =?us-ascii?Q?2HvAyFDUZ/tzDruXtrmCBNCbYvOgThaAwBG2TLjjZch2KihDJkKH3LR8yASe?=
 =?us-ascii?Q?bexx9O/WAleAk/mscWNo7FUBLl8XVDD1PVTYsxdvg1FGbmBFOeIkM2qfyt/A?=
 =?us-ascii?Q?SlwOLrTgEzu3BVo6k8zRcb7U0gnDwslcq53SsrBIrv7Oi+cs0utJCwzNX1G2?=
 =?us-ascii?Q?nE50lync0s0snHetZi7iZSHOkS1KXzJ5R+dCRMAc42YBjNm05jVVgCo/myjY?=
 =?us-ascii?Q?2VzaFQIjBjqmfDmcwQP/iJwUiVDloiB/oHbbfUmcQEX2AJE6ZId5yOD0Oyl4?=
 =?us-ascii?Q?xUadhx/9AoxokfhTMOSoVQbHixnT/Hs+aZphZnH+NUe24fpOhy+7Vz/8JsJ+?=
 =?us-ascii?Q?2KVFDEpMRGkqQC0nucwZ8D9P6R4GQPHOLL0YAgTdrGdIM9dPjIsAlmmBYp8u?=
 =?us-ascii?Q?WzkbwGd7gpJqTG7L7CYmLlyzwch4EK5LDfAMmRLLMmQlDV5SK2oclKf/17G/?=
 =?us-ascii?Q?KLk3i4AOLsr0X1/nuYsrvMfR2xNxFs1so+eGLPyGsASRTsT8fDxY/ST/Img3?=
 =?us-ascii?Q?4BecKvwDvmkRRM9K9Na//lW9uKufuEkAmq3/JzxvSSyHy6Y0VOiNVYnV+nck?=
 =?us-ascii?Q?2ifQI6Bbo1aAHlb0p2gonJ5VvmWVBikswaNOn00l9n1+9s4qD0DmwVnp1gYI?=
 =?us-ascii?Q?2R8+2w6y4/ncdxNSzFBzxPQlmXQEn1ltMyBvWdU2zNaTVrAZF+Kjt6Vd48tH?=
 =?us-ascii?Q?s83/SpGFICoIAUlrSqxt1gOxnKg2tiJNb5LzgJ0+GbxJHNj8geMpEY4F/IgI?=
 =?us-ascii?Q?xkcpA2zUdyiV9WhiJcdleWFMbjFey9fIFoYdNG9xHzpzgkpDM38wKW2n4LHn?=
 =?us-ascii?Q?maptohezFXyWR5k+zOzlXah/aG46+Fi0erMMaTF4ejrJ7X3HnHayam2j8rDo?=
 =?us-ascii?Q?JEWUw8V3CzbBjjxJtoph2qHppeYsQZ1BlWo//QEdBQinZCTBlOUzdcE5blQ4?=
 =?us-ascii?Q?5LbyxiwGyfKkqYKS7BqlQcBjnbcwUTHx3efZ2h+VkxjdbozuP4MpsF7SdttI?=
 =?us-ascii?Q?MDnd8Pt7IvIyZIvWLf1Mis32Ra4AO+ogjQoYcACG4AHjYqDRgUt88U2i1ofj?=
 =?us-ascii?Q?5o7Ft5yV3H7tBSB+FvrjFu2HVTqmwd6zxCLzG7Hy9GhHmV8hP5ZVKzzmBQqc?=
 =?us-ascii?Q?QPevYqARs+4LpaZ5h7RZMjBi7GHy5YwjB/dB7yQNyrmqrbBVcz4UnIZhEdDa?=
 =?us-ascii?Q?/P8W+df6Rm77/TQ2d1UlNLaYqBVfr+mBfjMe1z2HIXVtlRVR8rLmqnBUXGZV?=
 =?us-ascii?Q?MWtlDmBBDkjSiIdY4IJuZfhsIELvxy8eTU/g2jzYpIE85Y/BN8ab0pAcCERy?=
 =?us-ascii?Q?/qgNzGtswYXrYd8aw1vjOd3YRgy/oXRZHOg7KA9+CH17iQnyZhqtroWZJQpT?=
 =?us-ascii?Q?UjzyeXg2ufYD8K8yczU=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46579ed1-5d7e-4a9b-c0c1-08dd09732385
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2024 14:53:48.0400
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J51onkLci2vRHRgCyMzELu1xxIJg151pnf7nP4qvEKIk9TpJU0+D3Wq8jGIAR7NP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9099

--11c9dN1vCblxRVbY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

This is a bigger PR that principally includes ARM SMMUv3 support for
nested translation. There are still additional series needed to solve
problems with IRQs, but this is the iommufd side of the work.

For those following, these series are still progressing:

- Draft AMD IOMMU nested translation:
 https://lore.kernel.org/linux-iommu/20240112000646.98001-1-suravee.suthikulpanit@amd.com
 (and many other AMD patches to prepare for this)

- Draft vBTM support for SMMUv3:
 https://lore.kernel.org/linux-iommu/20240208151837.35068-1-shameerali.kolothum.thodi@huawei.com/

- Draft RISCV nesting support:
 https://lore.kernel.org/all/20240507142600.23844-1-zong.li@sifive.com/

- Grace command queue passthrough iommufd support:
 https://lore.kernel.org/all/cover.1712978212.git.nicolinc@nvidia.com/

Patches for PASID support in iommufd & vfio:
 https://lore.kernel.org/r/20241104132513.15890-1-yi.l.liu@intel.com
 https://lore.kernel.org/r/20241108121742.18889-1-yi.l.liu@intel.com
 (Several precursor series were merged this cycle so I hope this
  to go next cycle)

A lot of the iommufd support has now been merged to qemu, with more
progressing.

This has a shared branch Will created for some of the SMMUv3 code.

I have two patches renaming a function that I would like to get merged
in this window as well to simplify next cycle. They need both iommufd
and iommu trees to be merged together so I think there will be another
tiny pull request.

Thanks,
Jason

The following changes since commit 8e929cb546ee42c9a61d24fae60605e9e3192354:

  Linux 6.12-rc3 (2024-10-13 14:33:32 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git tags/for-linus-iommufd

for you to fetch changes up to 6d026e6d48cd2a95407c8fdd8d6187b871401c23:

  iommu/arm-smmu-v3: Import IOMMUFD module namespace (2024-11-14 21:07:15 -0400)

----------------------------------------------------------------
iommufd 6.13 merge window pull

Several new features and uAPI for iommufd:

- IOMMU_IOAS_MAP_FILE allows passing in a file descriptor as the backing
  memory for an iommu mapping. To date VFIO/iommufd have used VMA's and
  pin_user_pages(), this now allows using memfds and memfd_pin_folios().
  Notably this creates a pure folio path from the memfd to the iommu page
  table where memory is never broken down to PAGE_SIZE.

- IOMMU_IOAS_CHANGE_PROCESS moves the pinned page accounting between two
  processes. Combined with the above this allows iommufd to support a VMM
  re-start using exec() where something like qemu would exec() a new
  version of itself and fd pass the memfds/iommufd/etc to the new
  process. The memfd allows DMA access to the memory to continue while
  the new process is getting setup, and the CHANGE_PROCESS updates all
  the accounting.

- Support for fault reporting to userspace on non-PRI HW, such as ARM
  stall-mode embedded devices.

- IOMMU_VIOMMU_ALLOC introduces the concept of a HW/driver backed virtual
  iommu. This will be used by VMMs to access hardware features that are
  contained with in a VM. The first use is to inform the kernel of the
  virtual SID to physical SID mapping when issuing SID based invalidation
  on ARM. Further uses will tie HW features that are directly accessed by
  the VM, such as invalidation queue assignment and others.

- IOMMU_VDEVICE_ALLOC informs the kernel about the mapping of virtual
  device to physical device within a VIOMMU. Minimially this is used to
  translate VM issued cache invalidation commands from virtual to physical
  device IDs.

- Enhancements to IOMMU_HWPT_INVALIDATE and IOMMU_HWPT_ALLOC to work with
  the VIOMMU

- ARM SMMuv3 support for nested translation. Using the VIOMMU and VDEVICE
  the driver can model this HW's behavior for nested translation. This
  includes a shared branch from Will.

----------------------------------------------------------------
Jason Gunthorpe (9):
      vfio: Remove VFIO_TYPE1_NESTING_IOMMU
      iommu/arm-smmu-v3: Report IOMMU_CAP_ENFORCE_CACHE_COHERENCY for CANWBS
      iommu/arm-smmu-v3: Implement IOMMU_HWPT_ALLOC_NEST_PARENT
      iommu/arm-smmu-v3: Expose the arm_smmu_attach interface
      iommu: Add iommu_copy_struct_from_full_user_array helper
      Merge branch 'iommufd/arm-smmuv3-nested' of iommu/linux into iommufd for-next
      iommu/arm-smmu-v3: Support IOMMU_DOMAIN_NESTED
      iommu/arm-smmu-v3: Use S2FWB for NESTED domains
      iommu/arm-smmu-v3: Allow ATS for IOMMU_DOMAIN_NESTED

Nathan Chancellor (1):
      iommu/arm-smmu-v3: Import IOMMUFD module namespace

Nicolin Chen (28):
      Documentation: userspace-api: iommufd: Update HWPT_PAGING and HWPT_NESTED
      ACPICA: IORT: Update for revision E.f
      ACPI/IORT: Support CANWBS memory access flag
      iommu/arm-smmu-v3: Support IOMMU_GET_HW_INFO via struct arm_smmu_hw_info
      iommufd: Move struct iommufd_object to public iommufd header
      iommufd: Move _iommufd_object_alloc helper to a sharable file
      iommufd: Introduce IOMMUFD_OBJ_VIOMMU and its related struct
      iommufd: Verify object in iommufd_object_finalize/abort()
      iommufd/viommu: Add IOMMU_VIOMMU_ALLOC ioctl
      iommufd: Add alloc_domain_nested op to iommufd_viommu_ops
      iommufd: Allow pt_id to carry viommu_id for IOMMU_HWPT_ALLOC
      iommufd/selftest: Add container_of helpers
      iommufd/selftest: Prepare for mock_viommu_alloc_domain_nested()
      iommufd/selftest: Add refcount to mock_iommu_device
      iommufd/selftest: Add IOMMU_VIOMMU_TYPE_SELFTEST
      iommufd/selftest: Add IOMMU_VIOMMU_ALLOC test coverage
      Documentation: userspace-api: iommufd: Update vIOMMU
      iommufd/viommu: Add IOMMUFD_OBJ_VDEVICE and IOMMU_VDEVICE_ALLOC ioctl
      iommufd/selftest: Add IOMMU_VDEVICE_ALLOC test coverage
      iommu/viommu: Add cache_invalidate to iommufd_viommu_ops
      iommufd: Allow hwpt_id to carry viommu_id for IOMMU_HWPT_INVALIDATE
      iommufd/viommu: Add iommufd_viommu_find_dev helper
      iommufd/selftest: Add mock_viommu_cache_invalidate
      iommufd/selftest: Add IOMMU_TEST_OP_DEV_CHECK_CACHE test command
      iommufd/selftest: Add vIOMMU coverage for IOMMU_HWPT_INVALIDATE ioctl
      Documentation: userspace-api: iommufd: Update vDEVICE
      iommu/arm-smmu-v3: Support IOMMU_VIOMMU_ALLOC
      iommu/arm-smmu-v3: Support IOMMU_HWPT_INVALIDATE using a VIOMMU object

Steve Sistare (13):
      mm/gup: Add folio_add_pins()
      iommufd: Rename uptr in iopt_alloc_iova()
      iommufd: Generalize iopt_pages address
      iommufd: pfn_reader local variables
      iommufd: Folio subroutines
      iommufd: pfn_reader for file mappings
      iommufd: Add IOMMU_IOAS_MAP_FILE
      iommufd: File mappings for mdev
      iommufd: Selftest coverage for IOMMU_IOAS_MAP_FILE
      iommufd: Export do_update_pinned
      iommufd: Lock all IOAS objects
      iommufd: Add IOMMU_IOAS_CHANGE_PROCESS
      iommufd: IOMMU_IOAS_CHANGE_PROCESS selftest

Zhangfei Gao (1):
      iommufd: Allow fault reporting for non-PRI PCI devices

 Documentation/userspace-api/iommufd.rst            | 226 ++++++--
 drivers/acpi/arm64/iort.c                          |  13 +
 drivers/iommu/Kconfig                              |   9 +
 drivers/iommu/arm/arm-smmu-v3/Makefile             |   1 +
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c    | 401 ++++++++++++++
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c        | 139 +++--
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h        |  92 +++-
 drivers/iommu/arm/arm-smmu/arm-smmu.c              |  16 -
 drivers/iommu/io-pgtable-arm.c                     |  27 +-
 drivers/iommu/iommu.c                              |  10 -
 drivers/iommu/iommufd/Kconfig                      |   4 +
 drivers/iommu/iommufd/Makefile                     |   6 +-
 drivers/iommu/iommufd/driver.c                     |  53 ++
 drivers/iommu/iommufd/fault.c                      |   9 +-
 drivers/iommu/iommufd/hw_pagetable.c               | 113 +++-
 drivers/iommu/iommufd/io_pagetable.c               | 105 +++-
 drivers/iommu/iommufd/io_pagetable.h               |  26 +-
 drivers/iommu/iommufd/ioas.c                       | 259 +++++++++
 drivers/iommu/iommufd/iommufd_private.h            |  58 +-
 drivers/iommu/iommufd/iommufd_test.h               |  32 ++
 drivers/iommu/iommufd/main.c                       |  65 +--
 drivers/iommu/iommufd/pages.c                      | 319 ++++++++---
 drivers/iommu/iommufd/selftest.c                   | 364 ++++++++++---
 drivers/iommu/iommufd/vfio_compat.c                |   7 +-
 drivers/iommu/iommufd/viommu.c                     | 157 ++++++
 drivers/vfio/vfio_iommu_type1.c                    |  12 +-
 include/acpi/actbl2.h                              |   3 +-
 include/linux/io-pgtable.h                         |   2 +
 include/linux/iommu.h                              |  67 ++-
 include/linux/iommufd.h                            | 108 ++++
 include/linux/mm.h                                 |   1 +
 include/uapi/linux/iommufd.h                       | 216 +++++++-
 include/uapi/linux/vfio.h                          |   2 +-
 mm/gup.c                                           |  24 +
 tools/testing/selftests/iommu/Makefile             |   1 +
 tools/testing/selftests/iommu/iommufd.c            | 606 ++++++++++++++++++++-
 tools/testing/selftests/iommu/iommufd_fail_nth.c   |  54 ++
 tools/testing/selftests/iommu/iommufd_utils.h      | 174 ++++++
 38 files changed, 3354 insertions(+), 427 deletions(-)
 create mode 100644 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
 create mode 100644 drivers/iommu/iommufd/driver.c
 create mode 100644 drivers/iommu/iommufd/viommu.c

--11c9dN1vCblxRVbY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRRRCHOFoQz/8F5bUaFwuHvBreFYQUCZz339wAKCRCFwuHvBreF
YZqJAPwMlQshHsuhWM0G0wH1hxd5EJvT7YN0cE6d5jocdNKlmwEAjMeI8jVCla33
IcL1h3BlWFZI+Khb4+A65whk/I3z5gM=
=EV0D
-----END PGP SIGNATURE-----

--11c9dN1vCblxRVbY--

