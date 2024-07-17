Return-Path: <kvm+bounces-21785-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D4B5934265
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2024 20:46:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B753DB220EF
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2024 18:46:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CBBA22095;
	Wed, 17 Jul 2024 18:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Ke95/4Iy"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2079.outbound.protection.outlook.com [40.107.95.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F433125AC;
	Wed, 17 Jul 2024 18:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721241970; cv=fail; b=ajZtcPg8ieN3vJF2k9CrRTQdM5sBlVgYwzKnceY/W8jjB5QsP7GDErzOCejhjY4UYI4tzSYDSEB1591oPpLQQkXYeIDsmMcXHnslL0YJm6bqtVuL5/6Y9UQ25xu0CUDOHCgOQj2CfcZrtkhIoqbuNvtW8qft5UIas/dYUi4+178=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721241970; c=relaxed/simple;
	bh=tYX0bNjluCBuyzMfPGVPtJS3MAiwwhutaLeZTJXtANU=;
	h=Date:From:To:Cc:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=kgFLLb2RTckzkXKOguXk89VhQNnJ7DQJqI7TsHjd30ZX8+1ZxcL1Do9eCQsE6fTCGJk/ckBtQy6O/C5znpCemNPzVRQR71xpUSX5rb2n+4YxeIjbwJLzd+yyDl7AJNf18Ldc4EHZwZQbaqfcS3Ee7RfHCY/RTzs8c93ddRZg+gY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Ke95/4Iy; arc=fail smtp.client-ip=40.107.95.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GI7U0DrXXHj3ajsQ2Repa82fdqcwexTR0LcqwZ9UKQfpmlaQLFtNcivObs4YqgCoQl+p8jcmoV+UMibdRqZi3aLQIEJAw134Kvmh9+RnxLFvKgLaJ4F04X9ImooWOXViWyIoEVlDqtyZZarKUP0PTIx9f2exF2CHpS1iV9T+Td6M/Qr4sGb7nidCEK69U7BdOUO0/NOK5BYe9VIBfC02BH8OuZCCMimP3Mp4K4A0zR6MIyGUjKYSk76ZTRkkmdhw1T7z5hS1dzEYWjOziRJSECUtTEtsWKHPu3HFtKb+AGl1EF5LqG4aRE7JZ1f0sg3MtZNdQ4CFhV5MShaGj2xVfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W35qIb44nCaDlPU0Obb/BZekX9OV5mElwlFyRgIIszE=;
 b=kHOZoyGQjZHeY5Bl/pu2aHzxpTYBwIFEM90wMDXOzJX+9WENNcbXDloc1I8QM+O6fM3zawGqHl342rMHGBmu/4jqzW2wpNoRtpVkiKiDsS2xk67J9/OD8FFn7rX9dW6QmrMzqdv/YuBB92Aql1dG3xvT6AO8DTZeGF3AfpC1H6aTgvNn9h0/dKULRcsbAHCOiE9u6b6ZRfnzhTJxa90ooHm+8LYXy9TC1zvBobYqAEKASzDIrBRMz6UB2/wI6RmNfIgA+a+toOXUpJKCwwTKOO5mGd4MNlrdwH0jnh3aX2cn1FC2V7F4YRr2VIh6pQE9OJdLDL76pFcIW3QFGEU/CQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W35qIb44nCaDlPU0Obb/BZekX9OV5mElwlFyRgIIszE=;
 b=Ke95/4IyF27T7EcjwzwexCmsQ0zmTkRiIaDreIrvoq5EMd9nE4iROIUUB/WCa+6vM2w24lxgOdsGrkylZuwogK/nNi/+oHqFnNwjg2KTP/ehO03R/ZJZtFE7pB3Du96ywDFQWs8Qo0Q3g4MumLkojsTuNRIGSsNhO58siC9CUTyxyktQ91Pw5mR62fwPIIrxKRFELrywnxXZtA4ny4uPRAXDNFbfBLJY3wiKquBpvFYFXBKG6jFrxX/8jiXgBfeZhJAIdrXutY29PhoY9Q8lmdZxsR9S3SUNOicTWFfqaCjJPsDryibVvevtbaVVuBht2MjxUzhdYXg6gsRFpbevIA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by LV2PR12MB5824.namprd12.prod.outlook.com (2603:10b6:408:176::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.17; Wed, 17 Jul
 2024 18:46:04 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%4]) with mapi id 15.20.7784.016; Wed, 17 Jul 2024
 18:46:04 +0000
Date: Wed, 17 Jul 2024 15:46:03 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: iommu@lists.linux.dev, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Kevin Tian <kevin.tian@intel.com>
Subject: [GIT PULL] Please pull IOMMUFD subsystem changes
Message-ID: <20240717184603.GA4188230@nvidia.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="zj0wkU+gecuC1ltG"
Content-Disposition: inline
X-ClientProxiedBy: BL1PR13CA0447.namprd13.prod.outlook.com
 (2603:10b6:208:2c3::32) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|LV2PR12MB5824:EE_
X-MS-Office365-Filtering-Correlation-Id: 0fdb444d-e9d2-4880-7b78-08dca690b66a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?kvURGxIpmaX7ID5y+iwa+3Tr6vD2Js0d8qMyUaS55DyvOzp2xOQuPlKCMXj4?=
 =?us-ascii?Q?GwhDDTptq2Ri3bdoyl70DCDPw+r+2rVZNPkWddM0iQ/MpWnqAmLn5ju2uxcD?=
 =?us-ascii?Q?2kTmoLAMjVNjzuy6U7dDbvcQtp/oXuitjWDQtaclNcwRlwbZ+62lfbcqbGQe?=
 =?us-ascii?Q?InSAFINTn6aAthAvkFFCUMH5d+gtVW30gFeOhL48qFY0AY52n/0stq2gNS2K?=
 =?us-ascii?Q?HJlJUzvlXBF/+VG8o+FHhdqMSCgrpwBo46MOtvt5LNZG9jnNLefIygMt6yDc?=
 =?us-ascii?Q?QhQoH6fVI+kb+ncHUwg64Gt2gRYxqtlOxA0b88cm5yJXLHMKKH2jg7VcrDZe?=
 =?us-ascii?Q?xBUeQ63Hdl2HKKYgjO0MvsLNvrtXdbCAxtXwqrB/CAf0mcuGGBdXKkkxQwYj?=
 =?us-ascii?Q?J5gcgPDFPXKT0K/0yAHSQm8U6SSTFx8fgVHTo+pXBQaI/bbh/lX691tL3Lpq?=
 =?us-ascii?Q?3VRk2d9eC8EDa8267124SFwQOsYfqZeZLAboZaBjSZYMaL06UuNFwcq45/fk?=
 =?us-ascii?Q?bfF2TPuRQI2FZas4pHw6CteUuBigy++pHcWqx416pomaoVjnUuxGdQaZuptd?=
 =?us-ascii?Q?IvjcLMrA32oRS7Y192dWP9P67XfKJ+Zb5HShFQVjvvjQ6h2qSVrd3WMR1OmD?=
 =?us-ascii?Q?i2w+DJ98jI40bQD4TPXeev/Jpf2MDhC4PVeZ1V0ay+dFjFyte/vFv2iv/U9i?=
 =?us-ascii?Q?4jaPmlCgfQ4R2M9uLeyZ4ipgKsWEriduoy5EFwtDpjQWY7i0Ph5G1ZFTG53L?=
 =?us-ascii?Q?tPmXc+gU85dVX8nvVdlbEXqdFq27MVgEYh0riegItYf9PP5wGCCJdcLFHxsI?=
 =?us-ascii?Q?KVX50H/wzElel/ZPaqM7XiclyMiI6pVRZt3q40rm5IC+Xdp4P94/EekUrnDo?=
 =?us-ascii?Q?1KIhhsFxWqKxPgrW3gak0KSSHMMEyHCzr/8B46oBWSkzrgxwDHEMakEtatlJ?=
 =?us-ascii?Q?Cg3zJRpsozI7BiRc2irZTHNi5OFq39AM6Dm8OYtltZ8OZOavB/RQfWLQpRM3?=
 =?us-ascii?Q?MFo06cZUn1J/iTM1jlvcHpUcRJ4Qrj2/7+8ePcADkB/KN0iV1sFEGwGAa1JW?=
 =?us-ascii?Q?YSYNGU+4VTyGslMQfaRqpoAC1vIMRUeakjuzN797P8T1UKWu3Uwmh0iNINw6?=
 =?us-ascii?Q?tb9qmPMAX/9LbNKrCRbaP6TvO9PXCKO1E24MNRJHGuJtddBnmk0YcxDIkdes?=
 =?us-ascii?Q?Y3nMymNNkRli7DgSsLQrOB8UP9FlEUA9Gbmy0LAtO5+kfrrNCqYWhGJgs81M?=
 =?us-ascii?Q?qbjvsmdNA76vdhIj9wQmQrWCYdNqEv4VJ8j6jAAjZawn0GUqgAxoPOyHTlU+?=
 =?us-ascii?Q?d/b1e/h0tMi2VfNaKTECKdBBiCOYGINtx+wMpfBtmktaZi/DgnIE7A9U1He8?=
 =?us-ascii?Q?ZbKx8q4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Hanzxi5yA6qGoZ666DzSra7fanvrB+bHNJnVG72ZMdoDa8OM+S1u4QiUp0rB?=
 =?us-ascii?Q?sIh1Uo6Rqf1injmL6eUfI41tF6f/SLqzErJDpojxNIqhhZCk6ICc5mjMZNPC?=
 =?us-ascii?Q?M9j5v4yo3INJ2dwEiK3oCelwXMgB+Y3MGRey4PnADuPvvNyGO8ybQk0GplYb?=
 =?us-ascii?Q?Pfl/HcKX0WMXiz0bhfiiWCx9v3g53jsFKMEGZBpws/aFAoIvo+BwLILtDgbl?=
 =?us-ascii?Q?25UOtm0r+98xguIsM/kdQcIWmm7tPDzWi+qVgkUtWaigXj0gVwFqUUo3c/CW?=
 =?us-ascii?Q?Batmj8opHV8YWFgmXP4JqjNp0DjNphJTUpQfTp6nbA8k7zMmjhSFoQsAxiq6?=
 =?us-ascii?Q?F2RxneDn9D51vQSkY28aVAOddWeD6E5jj2AIZ+XzU9IXZqxSE+nnYrBxJHIQ?=
 =?us-ascii?Q?5L9kBS1dSiooY8NOc/upNPqnPMI6k/eAViXZyQ+YH9zMEJ0s8vp3b6j+HcH/?=
 =?us-ascii?Q?V2m4PKy04gUUU6Fj7ALjLzR5YoJzB74nyiwteqluD1bodzWU9U8fnerj+kYd?=
 =?us-ascii?Q?BF7piKHAqIccQc1Diwu8MHUA4t7Hj15Antq7uwBRbNaUufggl9gXHmxXQ9XP?=
 =?us-ascii?Q?HO9bBJOp6xM/+QXoU+LenAhiU+CufftFT/Pwio+HGLzoA+ADHmMZa6xT7YLP?=
 =?us-ascii?Q?2EmmkB4HaMydWcz1OAqenlQM0Hlyuf8CHicc7nm3VyU1pgQhuG7kp19o4wjm?=
 =?us-ascii?Q?KHQnmUfFyAaFSS2i+f7ZQfRrROZ7L4FbbcJUJ9oq1IKfqZc4BmVBUi+PfW5P?=
 =?us-ascii?Q?Kd5em9HK/0wKL4edTgDFxzSotsVmNQH5O1v0VFCZ22CYkr3UELyeiRXyDpD9?=
 =?us-ascii?Q?HohejHoU/Zi12N7e0oOknRGMsK/kNc7lbvVnLVO0TcsYAGsnbRoR23ViGQ2x?=
 =?us-ascii?Q?QQc/45RjWhGVF2oA7we+xPLCBl/8Bog+4TV86JcM2OGJUl9yygZZtRY+Ac4L?=
 =?us-ascii?Q?5X1rRjG71UagHkc2Rjy5ajWRiiODNbP4py2fmkvKRJUv3zTQ0MBoogQ20tvi?=
 =?us-ascii?Q?wO09J1sIqqe9W8H2i4sv6mB4+IM9PholIMX85Ja5ngxI0P3nApsR1Iq/aeSy?=
 =?us-ascii?Q?JyXgzj+fnkvs/Vy5dsUbpOvxBG+DWc4d2sJzqBzfFLiIJfartgcHpcLwTo+4?=
 =?us-ascii?Q?RPsGRbkbZDMW0ai8KapjqodcFQIkD9D4en3DVsdGUc8AEFxh6SVSBKJGehog?=
 =?us-ascii?Q?rQACifXALcZkY8yp7E1Dj7sIXQ1K2Wa6dE/ox60sNOv/Zhj4HpTcwB3k5XnC?=
 =?us-ascii?Q?K9pDCwb7kslQgfYwOoKBY50s90rf8TT7jkhB8HkjU3cN5tTQg1apU3BBKJo6?=
 =?us-ascii?Q?Qvl0mLmuz3jHzgEVcuFXT58eO7qHSp4fxjBufdP/VLmypCRfVVf9OdyfBlFX?=
 =?us-ascii?Q?9vU5GIeVkHkqUbQB7Xs1cHQGCDtWdMGF9hlqyLHq0+cqykcuPPI3LZLXfEy1?=
 =?us-ascii?Q?0mQyQ4+8mMXN4WFAXJjuJfsYZHMgLNSOoudpUi99n/ZijxrBGvTqhwT5i4iW?=
 =?us-ascii?Q?IBHkqDB6L4dp4q9fRrV9Z+B4Duxyld9J9XMEdTj9s1zDNJD5jVQgDN1LrHt0?=
 =?us-ascii?Q?bOsdr3leyRVPZ3ZQsdUuFZPuGFR5e3HNMAEwvQIp?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0fdb444d-e9d2-4880-7b78-08dca690b66a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2024 18:46:04.6625
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7/mCVEaC7bg145TdJbh3sIz6Q6e7zMGH26UPVooTGJxqkglWu4M6QSR5Uz0LlKJo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5824

--zj0wkU+gecuC1ltG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

This PR includes IO fault reporting for iommufd, along with some improvements
to the dirty bitmap reporting library. Details in the tag.

For those following, these series are still progressing:

- User page table invalidation (non-Intel) has a roadmap:
 https://lore.kernel.org/linux-iommu/20231209014726.GA2945299@nvidia.com/

 There will be at least two more invalidation IOCTLs - IOMMU_DEVICE_INVALIDATE
 and IOMMU_VIOMMU_INVALIDATE in future.

- ARM SMMUv3 nested translation:
 https://github.com/jgunthorpe/linux/commits/smmuv3_nesting

- Draft AMD IOMMU nested translation:
 https://lore.kernel.org/linux-iommu/20240112000646.98001-1-suravee.suthikulpanit@amd.com

- Draft vBTM support for SMMUv3:
 https://lore.kernel.org/linux-iommu/20240208151837.35068-1-shameerali.kolothum.thodi@huawei.com/

- Draft RISCV nesting support:
 https://lore.kernel.org/all/20240507142600.23844-1-zong.li@sifive.com/

- Grace command queue passthrough iommufd support:
 https://lore.kernel.org/all/cover.1712978212.git.nicolinc@nvidia.com/

RFC patches for PASID support in iommufd & vfio:
  https://lore.kernel.org/r/20240628090557.50898-1-yi.l.liu@intel.com
  https://lore.kernel.org/r/20240412082121.33382-1-yi.l.liu@intel.com/

RFC patches exploring support for the first Intel Scalable IO Virtualization
(SIOV r1) device are posted:
 https://lore.kernel.org/all/20231009085123.463179-1-yi.l.liu@intel.com/

A lot of the iommufd support has now been merged to qemu, with more
progressing.

Thanks,
Jason

The following changes since commit f2661062f16b2de5d7b6a5c42a9a5c96326b8454:

  Linux 6.10-rc5 (2024-06-23 17:08:54 -0400)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git tags/for-linus-iommufd

for you to fetch changes up to 136a8066676e593cd29627219467fc222c8f3b04:

  iommufd: Put constants for all the uAPI enums (2024-07-15 09:44:54 -0300)

----------------------------------------------------------------
iommufd for 6.11 merge window

Major changes:

- The iova_bitmap logic for efficiently reporting dirty pages back to
  userspace has a few more tricky corner case bugs that have been resolved
  and backed with new tests. The revised version has simpler logic.

- Shared branch with iommu for handle support when doing domain
  attach. Handles allow the domain owner to include additional private data
  on a per-device basis.

- IO Page Fault Reporting to userspace via iommufd. Page faults can be
  generated on fault capable HWPTs when a translation is not present.
  Routing them to userspace would allow a VMM to be able to virtualize them
  into an emulated vIOMMU. This is the next step to fully enabling vSVA
  support.

----------------------------------------------------------------
Jason Gunthorpe (3):
      Merge branch 'iommufd_pri' into iommufd for-next
      iommufd: Require drivers to supply the cache_invalidate_user ops
      iommufd: Put constants for all the uAPI enums

Joao Martins (11):
      iommufd/selftest: Fix dirty bitmap tests with u8 bitmaps
      iommufd/selftest: Fix iommufd_test_dirty() to handle <u8 bitmaps
      iommufd/selftest: Add tests for <= u8 bitmap sizes
      iommufd/selftest: Fix tests to use MOCK_PAGE_SIZE based buffer sizes
      iommufd/selftest: Do not record head iova to better match iommu drivers
      iommufd/iova_bitmap: Check iova_bitmap_done() after set ahead
      iommufd/iova_bitmap: Cache mapped length in iova_bitmap_map struct
      iommufd/iova_bitmap: Move initial pinning to iova_bitmap_for_each()
      iommufd/iova_bitmap: Consolidate iova_bitmap_set exit conditionals
      iommufd/iova_bitmap: Dynamic pinning on iova_bitmap_set()
      iommufd/iova_bitmap: Remove iterator logic

Lu Baolu (13):
      iommu: Introduce domain attachment handle
      iommu: Remove sva handle list
      iommu: Add attach handle to struct iopf_group
      iommu: Extend domain attach group with handle support
      iommufd: Add fault and response message definitions
      iommufd: Add iommufd fault object
      iommufd: Fault-capable hwpt attach/detach/replace
      iommufd: Associate fault object with iommufd_hw_pgtable
      iommufd/selftest: Add IOPF support for mock device
      iommufd/selftest: Add coverage for IOPF test
      iommufd: Remove IOMMUFD_PAGE_RESP_FAILURE
      iommufd: Add check on user response code
      iommufd: Fix error pointer checking

 drivers/dma/idxd/init.c                          |   2 +-
 drivers/iommu/io-pgfault.c                       |  63 ++--
 drivers/iommu/iommu-priv.h                       |  11 +
 drivers/iommu/iommu-sva.c                        |  42 ++-
 drivers/iommu/iommu.c                            | 185 +++++++---
 drivers/iommu/iommufd/Makefile                   |   1 +
 drivers/iommu/iommufd/device.c                   |   7 +-
 drivers/iommu/iommufd/fault.c                    | 443 +++++++++++++++++++++++
 drivers/iommu/iommufd/hw_pagetable.c             |  41 ++-
 drivers/iommu/iommufd/iommufd_private.h          |  80 ++++
 drivers/iommu/iommufd/iommufd_test.h             |   8 +
 drivers/iommu/iommufd/iova_bitmap.c              | 124 +++----
 drivers/iommu/iommufd/main.c                     |   6 +
 drivers/iommu/iommufd/selftest.c                 |  70 +++-
 include/linux/iommu.h                            |  41 ++-
 include/uapi/linux/iommufd.h                     | 141 +++++++-
 tools/testing/selftests/iommu/iommufd.c          |  86 +++--
 tools/testing/selftests/iommu/iommufd_fail_nth.c |   2 +-
 tools/testing/selftests/iommu/iommufd_utils.h    |  92 ++++-
 19 files changed, 1206 insertions(+), 239 deletions(-)
 create mode 100644 drivers/iommu/iommufd/fault.c

--zj0wkU+gecuC1ltG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRRRCHOFoQz/8F5bUaFwuHvBreFYQUCZpgRaQAKCRCFwuHvBreF
YWxaAQCHVCPG9Kb8WjDFYEcPgdgnf2yU/RCP/OEfVugsQsmRGAD9FgpqZsLo5IFq
M5xHTzLzDPadfpJq4pbscWdZSoTloQc=
=Bl2g
-----END PGP SIGNATURE-----

--zj0wkU+gecuC1ltG--

