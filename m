Return-Path: <kvm+bounces-27314-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A178297EFEE
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2024 19:45:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 36B28282429
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2024 17:45:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC09D19F40F;
	Mon, 23 Sep 2024 17:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="QqTR3JsV"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2045.outbound.protection.outlook.com [40.107.243.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CC3916426;
	Mon, 23 Sep 2024 17:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727113541; cv=fail; b=rgkBRogDt+k5YSQXx81TiMPGYuzAfwFwDdrRPrBg+IDiLGyGX4SV8fL4ptQGbm6iWkaxCryXKt2NsjkYwzffdceMQZQS6lWLmwfNaLgjzhtllCIkCe4643LE1akMcDcIHYeoGNGqJ56NKaJgQ7It0jHeJgRMPe/hxY7frfTIN7A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727113541; c=relaxed/simple;
	bh=gasvsgI4MIUpLnyDJMfjKB/3yBwvDoka5JaY1AGVX1M=;
	h=Date:From:To:Cc:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=fvGl5iv5Dmxr/ncFfryw4UfCbpxSf/47w79TDmM79JEprUmMaGIIxv37nqgdrzEGWQlCYINxKae+xuY8Z8s0/PgIr3M/pPGxepHif/4QQtQsrNio0Ig09Oy7OOHBUWrXnsNPIIRHjA3X6aNgdS+3HPW5QnnPfCeTcqGxkX2oQTk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=QqTR3JsV; arc=fail smtp.client-ip=40.107.243.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Smbi7M+Kagwqitp7f53IYhB3ygqt72z6pwhFGJNMttup81OOXiuQImCGwgg3MgyQMYAkvwrM55fId0GiH0fmExfqOquW7y89qxfKrHKFALTBA4FSTgWiZkEJ/TVUOjeF9olpokXMmB4dskA/qi9S6Ptztm0nyrQS3aQTQXp4aMvXsXo7mmBorp4lGyANWifyI4zaNeh1YRXN3TLjZU6ut5/lR+OXCpwYqCy3924aoGbRXJNNW0KwqtmCaIQvZkiSTUcJkl0PaGtyO7vWOQWYqfFSOsGOAQB/PZuNIdYekrUuPrGBXnvCUBOiGXUeN312DnGL90siJWKOHClaluH/BA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BU1n3Kb2p0WmqJzm9gEL6FDmDI5aJ5hVhtV8h3lmfTU=;
 b=L1PBN9L2RSG7+1Zsv2e7ucgzJEVIhGbx9xvQE9mnL4hRuwEoMTZmBDs1py5irnM78x+t/dQF/5OaNkkeFqOveljc5TqnWAKrHLljJPXWFXzVOo1Jl+Gh3MwA2E+mSufFsuBkSfrNdBSP+resmd6PshNBI9B6t/09kFVsGoXAfjuzi5+STIrNPE9pdCJS36wrH3IxViVipqZh8P989ujSkmEglMxcYCm0+HrPi0MLlsCfgE9dutyHYxy7t0RHfQo63Wu3PoPvl2wHNmiuxeCFnFad4TJDLBS159owV+MQiGfOaThSRH5FXH29S9uPlkJZjy5P0hmYWlCf6qZ7vz/wJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BU1n3Kb2p0WmqJzm9gEL6FDmDI5aJ5hVhtV8h3lmfTU=;
 b=QqTR3JsVwuNVUvudWoaSM55RoSQKffVon4XdIaYnoe+2Iac/iykxq6rN0lFICzdOd9rDEVmPVdsozyy4kT5WVYOif9+j2+o0/Qa0AuaOf2RDuDOLwFiBLHUkTLBzPamLGTzILiMUWSQLvDxIilLK/RVNAmsmw/a5pwjKqzr5FP3DTDYHZaJh7xmjoAB10uG5zAKJpbsJJZBB6IUXCh1w8MP0tvtJWTVn+YwKSaAbyq8rtjoxlyuv0FsnG3cxWnKsadQxRdbVMvQ/Ix01ZglhQ56QIxUb+hq9Ms/WTPmFwSvClejvWipnQGLbdsKsZPq/5Z+oQ7XV99UwVOFzZGNDFQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DS0PR12MB8814.namprd12.prod.outlook.com (2603:10b6:8:14e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.25; Mon, 23 Sep
 2024 17:45:37 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.7982.022; Mon, 23 Sep 2024
 17:45:37 +0000
Date: Mon, 23 Sep 2024 14:45:35 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: iommu@lists.linux.dev, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Kevin Tian <kevin.tian@intel.com>
Subject: [GIT PULL] Please pull IOMMUFD subsystem changes
Message-ID: <20240923174535.GA77474@nvidia.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="tuLoZ1SXOKftaOK1"
Content-Disposition: inline
X-ClientProxiedBy: LV3P220CA0002.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:408:234::15) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DS0PR12MB8814:EE_
X-MS-Office365-Filtering-Correlation-Id: c4b5c53b-bd96-4c14-3906-08dcdbf78815
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?FamQrCwX/7nb4hAaA4QFlxMa2pCsFl3tiyp1Te/tyclgx4oPaGjWaCgg/tLz?=
 =?us-ascii?Q?C5Dqo297CLDl7bWerJR5sDpSiZLFmxCZkAL/SD0X43PiQqejIfevIFETCcu0?=
 =?us-ascii?Q?bWsiT2isrzGnjiV4g5rVjxZEsW8QkYJrxjt6wR/kgCwvhlv17f4+10UQin3D?=
 =?us-ascii?Q?d4r8FVVdjLGh/1muMKVnMy3aU8+iqp3D0qPhWsk8Sv6virwFaoUyJ2Ur/WKy?=
 =?us-ascii?Q?3Oc0PY8r3pnAn4R3a8AZYWd8XivCre1fxxvNHObcapLorWeIGiuuwQE5QZ/8?=
 =?us-ascii?Q?ZGrCqro3CiB9pGzrteAu9mW5oGQWBX4KcFZ8t4LOIJEKU7wOz9NssXE3hujc?=
 =?us-ascii?Q?hw8b4MqVr3liS0Kg2UrB5zb6OOkaLueqMK8gtnC66wARi+b+UMAztqJu+6BK?=
 =?us-ascii?Q?fgbzOaE3fu9Xjb+nUTOsAGPtOS1Oibe/v4lj/oVRmmFSRFHNBVqld3beq0hS?=
 =?us-ascii?Q?lTeqySIWxQV4HZncb8WQiUMqKMIiurmf5zNzpTskiEKZ8s856dvX52ndSsdh?=
 =?us-ascii?Q?oMPPK7wtNAohyfMCCMkTvu3Y0aZIZX/KJA0qyeeDQ+pLL/YiqIcbZFtqONw/?=
 =?us-ascii?Q?RpSMe6rHI0SUAwPvaVP5fcNV9LMbzvbbk8aeiwAi/yIrauRbQs/1XG3P8+Ij?=
 =?us-ascii?Q?K7j2X19gDkNCJYD0KMN5AfXn0W5qa5uJQQBFs8+oCwb5TGiWihTuSA6aaIEF?=
 =?us-ascii?Q?eP4jcp90bxEgHcsol2ZrVvGReVQSxUTDOZNL5cHwJ+F/6gKeWqccVhThSYQ/?=
 =?us-ascii?Q?p5YGCSky++lk/9jq8NPbpoI7giRnoU7WbMhR6Rvykx2mk/J0TVHP10ndecTm?=
 =?us-ascii?Q?+PkaqEqP6IEmsH3qw3TX/Z94YZTlnqtIY44EzU1y4Tbm/L86L7eI5yZa4LTe?=
 =?us-ascii?Q?V5p290biag44BrvNjRABOaKq6nFkqTGQ/k3+B/Jtaqp4MgDVfoR43STFaUPd?=
 =?us-ascii?Q?3hOEFixCbVMvmWeO3F6LlXdwbNJtzpxIoF384++gEUGf9axQY1nfnDVEKb0B?=
 =?us-ascii?Q?SEhVJinIfdxqqnMRMYcCxcbnQ0G3XyBdhR2RWiO3A7Jgvw0U+/2abMOAC/dL?=
 =?us-ascii?Q?mDBFbF323INLbCe4aIG5NnJGLnuOLafWV7LdTwjV+OQ5pyD42Q+UyxqvpjWA?=
 =?us-ascii?Q?ubQ1OA7YZ5ngbYFqruyGLK9eFjYOLG6izmnMk/mrhtQ5C5oPcD+mp89YeasZ?=
 =?us-ascii?Q?CFifkHbR++qICn5hz5lNmf7LK6sb6fqeWy4P65WAqQJk2FDkJmRNau6CZtEn?=
 =?us-ascii?Q?ueOHsLSc8DUTRvVmHrLOO1TTLblxFGuQTbxy6UJgiq1jOgTkhWCIxDshYGbb?=
 =?us-ascii?Q?LFfKKGpuRZwpQPrZrQj+kcIOp1MoZ0Gvj+gVK3qZD56WBw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0Tah9uK9rK64HtY9h1fiqT0hjERyfxhI0UQc/MIe386OTv9DchVH/pij2il4?=
 =?us-ascii?Q?3+DzG81KafeCVkw3yK6cE0T++bYHIqbY9cRzbBWJRPuf7jch+l3XCHuvjEbm?=
 =?us-ascii?Q?1uu5DP55Rt0sn9+Kf3sfnGHDGGBaRQ99AXRQ2ohIcIfPuGRLbkIMlUWrltd6?=
 =?us-ascii?Q?nnDIgvxb/Qopr9lYsCYSam81YX6Fu0tA99Zg9lM+xwk/ZgLrk6YV+fmshtpI?=
 =?us-ascii?Q?x6HtyxzRLpWWZEvJqwjsUKOe2jGQmNp2LffGlDevMZqaKGXbkaeHyDt12O7e?=
 =?us-ascii?Q?/LOQHUl/3ARQZZrneSeB+nKWTHp4+tR3oaZ90dDyoi9v56HpzoP6IPsCytkm?=
 =?us-ascii?Q?Dqmou0VI+DWSOIJH5KS7xy1hNywZJH6XoKbkhlQjmnYTW2K+7BEhP/V3M2kw?=
 =?us-ascii?Q?7FosiD9MsoJi60FBZamtEHcC7ZlQ7TGCCu8WnEhOUVSvmcraHT+/EawDajf6?=
 =?us-ascii?Q?rWSCA6qkGXqcdjO+kubNZz1wre/tEuueRcJ1Fa0MTsFX4fSV6qeilosGgdbM?=
 =?us-ascii?Q?YW3aZCZRoru2RTyGibcLfKdwNOrYWcf9uHjIOLBQNQD41sv9DzgF/vmIPOCx?=
 =?us-ascii?Q?7snadc5qXEiaRohwYYNL1QmkHNXblozdgVuWbSSxS23i/tPEIo0vpjlxmczu?=
 =?us-ascii?Q?rjbsfgg9HBNBP3FDzYLBV3bcfwFtYa/HCSLbPJ+ULllnciGypgMKyiy3u/w2?=
 =?us-ascii?Q?OlxK4R1AVgFXFFPBaH1+C7t+tNBMYtRg86u8zElNK+cGVKGPoXSECCXmnijw?=
 =?us-ascii?Q?hsp8qvxE50aKaEj2AR1VSvT0GkBJDRnXFR2y1IAcFNEFX1T5yz7CA+/59QK6?=
 =?us-ascii?Q?Ms6wcjUVCd5J3Js2pVO+QKkiAWuqTC1nouJxDviQHyeeBP/DWWlzdxx4xSsT?=
 =?us-ascii?Q?pgHkwiTni/Ylw3erkUywecDea6YtNSfnjNWRsyfcjCXQOFzRJeXgtATU3NIV?=
 =?us-ascii?Q?45YlFwvpvBqkbeIp5WpgGQ+E/mJEDcdE7RAuTBzzenkP9ZvzztrEuAiUOm5U?=
 =?us-ascii?Q?EiTQt4O5qaGvEY/C6zL3RtyH7N49AVLxvYLk2+s9980eT5NaSKYKd/f+EFPp?=
 =?us-ascii?Q?GJqrkhJOluShwJy+QrwRe8fRUrgQUppoHtVQ1k+yQTFrxQXPUPTLVa036Br1?=
 =?us-ascii?Q?I1Lehd72A86DwNuNCkhUKXKRpdXV3GYjklhEw71l5pBxocfJH4A52Epkx9hv?=
 =?us-ascii?Q?tK+6D3gYAO+h+rd3pfaCaO2oIw+h3mPClrJsz6scYSjEEQbPcPX8zSr+dtJJ?=
 =?us-ascii?Q?PLIBTyEg97YgBXRiDjxAOK08LyQelAryUC3iNTMBzwYIoc0MT9SfJCiLbYtx?=
 =?us-ascii?Q?nfabsAEDKP1pfDzrEi0L1Y9VAniGzl/0IYJDqhzBcn0mirVlfJvt7VthMAqz?=
 =?us-ascii?Q?zucc6iWFiCibF0Rq3UJ353RcPogo7xeG2Dr8LIiMDzx0fHSjayf3GzjdEmJo?=
 =?us-ascii?Q?7XSLHy2a7CGX/4w+tMgzb7ZvKX0UKbCT+KuoH3ihy/owK52h6neVvCXZwMmV?=
 =?us-ascii?Q?T+6yHWjgAszUFxdhKxPhZe2R5q8cA+o8W3CIl+xNlP+upwmE2okaKWLdMkCO?=
 =?us-ascii?Q?nstKKQMyOdi+gmPOf0E=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4b5c53b-bd96-4c14-3906-08dcdbf78815
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2024 17:45:37.0122
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rx2ItQD7HGJZQE6D5Y9brf2vSGC15n79W1Rh75oF8eZ5vx42e7f8IzV+jchwg1Ak
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8814

--tuLoZ1SXOKftaOK1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

Nothing big this time, I was hoping viommu would make it, but not yet.

There is a small merge conflict "take mine" to resolve, the mm tree
added a debugfs.h include to a file that mine already has.

The tag for-linus-iommufd-merged with my merge resolution to your tree
is also available to pull.

Thanks,
Jason

The following changes since commit 5be63fc19fcaa4c236b307420483578a56986a37:

  Linux 6.11-rc5 (2024-08-25 19:07:11 +1200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git tags/for-linus-iommufd

for you to fetch changes up to 79805c1bbbf9846fe91c16933d64614cbbff1dee:

  iommu: Set iommu_attach_handle->domain in core (2024-09-11 20:14:07 -0300)

----------------------------------------------------------------
iommufd 6.12 merge window pull

Collection of small cleanup and one fix:

- Sort headers and struct forward declarations

- Fix random selftest failures in some cases due to dirty tracking tests

- Have the reserved IOVA regions mechanism work when a HWPT is used as a
  nesting parent. This updates the nesting parent's IOAS with the reserved
  regions of the device and will also install the ITS doorbell page on
  ARM.

- Add missed validation of parent domain ops against the current iommu

- Fix a syzkaller bug related to integer overflow during ALIGN()

- Tidy two iommu_domain attach paths

----------------------------------------------------------------
Jason Gunthorpe (4):
      iommufd/selftest: Fix buffer read overrrun in the dirty test
      Merge branch 'nesting_reserved_regions' into iommufd.git for-next
      iommufd: Check the domain owner of the parent before creating a nesting domain
      iommufd: Protect against overflow of ALIGN() during iova allocation

Nicolin Chen (3):
      iommufd: Reorder include files
      iommufd/device: Enforce reserved IOVA also when attached to hwpt_nested
      iommufd: Reorder struct forward declarations

Yi Liu (2):
      iommufd: Avoid duplicated __iommu_group_set_core_domain() call
      iommu: Set iommu_attach_handle->domain in core

 drivers/iommu/iommu.c                   |  1 +
 drivers/iommu/iommufd/device.c          | 56 ++++++++++++++++-----------------
 drivers/iommu/iommufd/fault.c           |  5 ++-
 drivers/iommu/iommufd/hw_pagetable.c    |  3 +-
 drivers/iommu/iommufd/io_pagetable.c    | 16 +++++++---
 drivers/iommu/iommufd/io_pagetable.h    |  2 +-
 drivers/iommu/iommufd/ioas.c            |  2 +-
 drivers/iommu/iommufd/iommufd_private.h | 32 ++++++++++++++++---
 drivers/iommu/iommufd/iommufd_test.h    |  2 +-
 drivers/iommu/iommufd/iova_bitmap.c     |  2 +-
 drivers/iommu/iommufd/main.c            |  8 ++---
 drivers/iommu/iommufd/pages.c           | 10 +++---
 drivers/iommu/iommufd/selftest.c        | 19 ++++++-----
 include/linux/iommufd.h                 | 12 +++----
 include/uapi/linux/iommufd.h            |  2 +-
 15 files changed, 101 insertions(+), 71 deletions(-)
(diffstat from tag for-linus-iommufd-merged)

--tuLoZ1SXOKftaOK1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRRRCHOFoQz/8F5bUaFwuHvBreFYQUCZvGpPQAKCRCFwuHvBreF
YT40AQDAYrybnBfy8Y+K26+xqUc1f/TEe7zF/gn2ZqUR/7GAdgEAzAAl0WJWfnxi
gBpdiNjHwTNbSJtu8vkj7/0W2DMZ1Qo=
=dQ9d
-----END PGP SIGNATURE-----

--tuLoZ1SXOKftaOK1--

