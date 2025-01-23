Return-Path: <kvm+bounces-36409-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B30FA1A83F
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 17:59:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 152C43A33F3
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 16:59:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9920515B0F2;
	Thu, 23 Jan 2025 16:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="GNfcQe0+"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2053.outbound.protection.outlook.com [40.107.243.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F75713FD86;
	Thu, 23 Jan 2025 16:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737651570; cv=fail; b=HiirQnGCJjKmjAnFPqfATn+2Z+l/fEtCND8HH2szX3AYF7fB/tDYUteEmoWgwRxkWV/2zR6Fv7wJPPXYXg7hI6pusmOL3X036KOr5UdxcAW1Ijvk+BR9hJbcFfwdDDJ5QoCBO4rK188vYCxg96tYGRu7+YvKiAG1Znnce5K4iTM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737651570; c=relaxed/simple;
	bh=d09BK7nL2gT9K6hH70ahOvDsV6QWR1mcYPZTW8RleWY=;
	h=Date:From:To:Cc:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=QnZTuNzT4+CiCjT+ow6afc9gZawwqF3xlArlsBf8RUKhZsCITfvfQgpspf+GQyjlFBdvcu8ko4ljXBq3893fauQTgfQTfV1eL9/hIsviYW0LQDWUAbkwU2QFYC+agKSXzOfICgTDtQuv+kJWTfOFgpUBm2fsBj9TK4BTr7CevnQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=GNfcQe0+; arc=fail smtp.client-ip=40.107.243.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dB6vAc38/BKgF2kO4nbo9zYf3dAH1+vYxfYxDaeojSV99zFGTgCL84fezpzzRXEEbxqsWeXQKKrXEC/SpRBNh+EI7cbL2sJIiu4laUAU2ndAYz993fWHFCByTKcn2m+eQzIkIGR98Co/AT7yQOUoa7Gt1MubEPJHTv9U0MuA8NJrVjS0FH8rPLvDPvLR4xunCetQF1ppRQftDzPCNcDc9HX6bqmOOHZZ1w3nFIbkhSCHKBw0LO6KfQi23Ria4WtPrxiQqwG1uvMaZoLArQwkJDNM2XSMTvtoMNj6U6p9bjotQl5Ttp1h9O/PIJDsDLGpcG3pUqCwKioY9Hv8FF5RtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qM+zru2Wr1gjqfp5gTNC3Fg1J9cur085wplFzBwbG+o=;
 b=v+V5THflszZf82SJJC5/zBV4JnE43uYZqLa9PCZmBE0U6ERs54PWRvoQnV7xyJGVOVaP1SjDgrKa6Kilv32isXgfglH4oAcIGmF0RL8M39kWhFUP01Odu64lq0v/bnwSanarO9FFJ1leHIku/TXLc0B1TRfV7fgXCx0ACxgOevN8X/l1e2zFP5/U4HTPcY2IBSTWSoxQL0T/ibrH6VycR6UKBlgXHw3/vUUctPu33kld2Y35KSX2UetogOmO3Xa1INCVEvrx/Gbe83r/ZZuzaItpDJWLjGBkO+REMb7VnWb8LpGTTpCPMwvZoWyZulu3tFLgPxHroWON4kH9nR+j4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qM+zru2Wr1gjqfp5gTNC3Fg1J9cur085wplFzBwbG+o=;
 b=GNfcQe0+/rMqNaBBkFNy8K27Hc822x27nmM11nXfyDEgCXJcUwbtTD2mnXA3xMXz2MzhSPkfL4/emQHhgSFMPl0ormm3kDahmj/4cDEzyUmXsugm+mfrV2PSZJK8W7BjAJdPfKHFo4k/QyCHk7nCyzG525dHwB0nEhTrFjAS2rcZmp/4vShqL2XVA92NuhdKRS3g6mEHDtBA4uiLCJoQ5i1ocC4eA4cUnIH+2PToab75QqOKpE9VN8a986gyHrt0aQ5yAEbqTExY5yMcuZGoPWeVD9F2sNjQjOm3V0za62yAVsDKmKLkLYwMjIOtiEV29okNGBv7hUdnH9AOc0lyYg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DM4PR12MB5866.namprd12.prod.outlook.com (2603:10b6:8:65::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8356.22; Thu, 23 Jan 2025 16:59:25 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%5]) with mapi id 15.20.8356.010; Thu, 23 Jan 2025
 16:59:25 +0000
Date: Thu, 23 Jan 2025 12:59:23 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: iommu@lists.linux.dev, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Kevin Tian <kevin.tian@intel.com>
Subject: [GIT PULL] Please pull IOMMUFD subsystem changes
Message-ID: <20250123165923.GA1053196@nvidia.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="KzWVvzTRayuZUfYz"
Content-Disposition: inline
X-ClientProxiedBy: MN2PR02CA0003.namprd02.prod.outlook.com
 (2603:10b6:208:fc::16) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DM4PR12MB5866:EE_
X-MS-Office365-Filtering-Correlation-Id: 55fe070c-eb04-41f6-db16-08dd3bcf4a5b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?fLBh+xPFapEx7mK2/GOOqPy18vaL8v8DrFLQ5JxbhB16g3/cchrUCDTM3Ok+?=
 =?us-ascii?Q?5gOj1hLoSf+H/LcFWa1jRkMRvQVdVUly1nud3r5MHex4zilWDHiaAFfGJINN?=
 =?us-ascii?Q?IbD3/yLUOCR7Pj85qgbjJGQbcsnwwuXiJjKVMXGKCNNK/rGcf3SAY/c+oeuu?=
 =?us-ascii?Q?19QLDoHkY6+U/w6FBTv0dV6692hmpcyWh9OHcLCMUUlyffEG2esXMAkklqr7?=
 =?us-ascii?Q?/NUyyjbYRY4Zj27F/EXTrqh+jMp5Hu79K0WDOOGiIQE3KkuaVIIZ50Ijrvr5?=
 =?us-ascii?Q?aEgZyyPwrRdpZvlGb8pGhF/Z1s3R+E5XfoO7qeh3IEuHj2LEi2WQO1PT2bkf?=
 =?us-ascii?Q?wcZQrGsg8X3uim+OwaG+kpk2Wxc6ed1CEwT3TLAu69yrpT5SZ9wwB0FvHihU?=
 =?us-ascii?Q?iIVrBgcz/hkSDsGlpHcCPxU2j3iWNAVdWRKzlJLDrX/Pq21TEiyaUZdzEF7Y?=
 =?us-ascii?Q?3wL/DF6AOJ73wguWaVyI4pqkdDoCZWqSGbEcQSqbSGOe8DqJWelJDsxGElmc?=
 =?us-ascii?Q?RsR3RY2su1F+/P3LApZCMWf4ZLiu7JMFhArzSHJftOzxiP+jQpyiIGiepfYT?=
 =?us-ascii?Q?YFuKLvS3OiBrpb1hsffwRNGDHb8wmupFCcqdmnBuFz1OsZ9wQe6rCWmzBHVi?=
 =?us-ascii?Q?0/LADe4f7Y26t84oayTwGZZKndMs39rppnC32ixN/REHSl0/iLuYa7w9/1KQ?=
 =?us-ascii?Q?CYc+6Gx7dMmQhkRAaNND/eQ2VZ8P3QI2RcmH33nEI9Ar625g3jz3EyKWPBzS?=
 =?us-ascii?Q?oC5CH+pY5KBIrGp2qu8EUFu+uM9jM4/mibgfDCdH0BuhdH3iSyk52iSzPNvx?=
 =?us-ascii?Q?6GDrqTggyavGNqiugzxeStcsrPEqhpHnpvtiqkHUZPepMG1nt2Jm6PFPmVRc?=
 =?us-ascii?Q?1KRlhIw9hvBf39g7HdTT0k0NB+rM8XLYdXTmzyNXZgSfLAMkt9oMB9dlbUtY?=
 =?us-ascii?Q?YubON+kvUkyTAytkv8DdgIK7n8MRnjDXHTkwla6BXBK5rksz8Ks2FaD54Z6Q?=
 =?us-ascii?Q?Uft87w92bH0TxOdsl+Mx0d/RXRi3nYFQ6ImbRLI1oKwT6Db/dqUlrpJCLQvi?=
 =?us-ascii?Q?eh2aYzglVYBEFW17Tb363KK8kdgk+cncPq1B8997u0uGGV1+Q/L6TMfATpkR?=
 =?us-ascii?Q?JuZxNmX5PSuABp+cAHY03WFQqAksksN8M9aKGkVjwAHD78XYR8rWro0xN5WB?=
 =?us-ascii?Q?asAtqHCPk+K0XoybFUtmV1/UIMCS0QWx6nVaCrqeN5r9cPvTAmiHPf3PdRw2?=
 =?us-ascii?Q?vrt0mYY9wZHi1U1g/XiAHJ3MJ4m980QyHKov2y2yPTgvDUTtUTW/kITvnZPB?=
 =?us-ascii?Q?gtjePL2yiHeP1wHJbVWNWdvy6iqNax2PpkzC2bBfy5idiPFexaKYikPsx1An?=
 =?us-ascii?Q?NTDq7SFIWL0LEOFnwT9bnfl/ySbU?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?64e1RqdT0FSR8Ym3sp25mufNpY9Q5E5pc0A4D6D9lyOgczfK42yj6/N3LAux?=
 =?us-ascii?Q?QM/icplvR6K9Li5MitPfzI6/DfBUgd8HJLbMqR0znFkJsMo1KevhUXKjHNFf?=
 =?us-ascii?Q?8GbmERCUUbEHsTjtsDSKhHOzDuaat8tWwIvNTk9nmE2tQt7eaC9aNfmNyXVm?=
 =?us-ascii?Q?c1UGq3xxzT+GWdv2zvVx8q23YSKoJXUCBK37mYdCSqeMtTHDhsS2TcZk3B8w?=
 =?us-ascii?Q?jTsSkl82STCqnN+oV1Sh72WtuTvO3sYHpd0P2SGrn1Hxn97D3mAkKffP/uXs?=
 =?us-ascii?Q?0ZIfxaffMRescRL3IvR5RP3hL1H9Rw0t8Y1pxAfTFlLF+8ndRmQm/2SG+j9+?=
 =?us-ascii?Q?+vFkv2zB7R5RAvjjlO9tI7pa/gEWB1o1oWTGMQSisGcomx/yNKBxVYupd6z0?=
 =?us-ascii?Q?vg997CV5rsPF7lYKltYcpV2DRmBw+ZuIJXDivIryNErH7P/HyHScyaJPws1X?=
 =?us-ascii?Q?sDIxWohkia8lcPSoW2nYGpYedfNOtjNhqY5Y1NIrBMJm0H7aiHdCUIO/ru/v?=
 =?us-ascii?Q?v3n7Jq4mwjML9IWMm5OI1LfUH4XkwCUygAYotFOs8Zg8leT6OTXpZQsj6Xrk?=
 =?us-ascii?Q?4OnCdMpqFHA0v88yQIk5FsiAEvVLlmiLlSW8XcbUMPRWOz8BxSJCI0Wz7TSw?=
 =?us-ascii?Q?ql7gWeG0+4vub7+ke3FZGHfVrbZpek9igwDNFGDt0sbC0+ZxTEXjNekLLKvD?=
 =?us-ascii?Q?vmKfaM0aHl/69OAZ0X3zaLTPLdpraQx/ZmsSBJSLttleZ+ECD3BRMBJX7LRz?=
 =?us-ascii?Q?nqd9ATd0JdFWKVDiwjN+xcDaDRuET3FN0dzKkVB5ytpfTUYV5kTrdqFqLNcd?=
 =?us-ascii?Q?rbgD93OYuJZ5ffXx94ia5O/GHn5ZzSgB75Syn3aDIyiXPXV7F/BS9yBx0Zea?=
 =?us-ascii?Q?krcwprvg5Q8Vd73qqtpKDmU4/JBFhKt+SI/ga14iOsJDENfz+Yol28WDL9n7?=
 =?us-ascii?Q?iXjjet/t9iGOiKKqQNadVPW/iAlYEdVooZ5+n7SjGSmEF8Oz6mMd1+Eu/VSx?=
 =?us-ascii?Q?N3fqbN/igND6BWcJHwagV1ynBFECFaybWMjd+8zmo4lGU0HXTyg5VrGWtC00?=
 =?us-ascii?Q?Q9na4CxT7oaCs1Gg5R19Obp7XMiC5tc0O29sK0YSocdueHQGtk5TWOWldo9I?=
 =?us-ascii?Q?FDuKWQdgCrZBuqwJseDp4AnL8Iaj2b/xISCuRVkBSL2NyXswV1wGtOTYOnoJ?=
 =?us-ascii?Q?OPqguv8E7lqUYYXAJZzgXW9Ag+5yQ/usPD93hGn/ydxf34bE3iAXprc94M4V?=
 =?us-ascii?Q?8rhZuHC/xsWloz7RjBDT6YPUX4GGZvjiZvpvZ66Y0/VgVqc05h3+2ZcwO7kA?=
 =?us-ascii?Q?KdxQRNOlXlID0Ut2VdH2/zoAZl37bzW2+qARCcxtfogmj3sh3J7mJioKPKuE?=
 =?us-ascii?Q?IKA21S0BQSNNBH7zkMDZKmsAF9ZHzoxE3+8f8bEU/kaAYrgm0/LijIwet139?=
 =?us-ascii?Q?7fUL42cvn3zfDm/ZBHrH2GtW/i1mxCOLSTEBjObJs8FdILFaA7jP0zwFNlIS?=
 =?us-ascii?Q?b0VJ/fxy9csl/MTW24pPiyj00yLj82UGgC7u5NJoIIX/Kg8CRdxVUvFFWcm0?=
 =?us-ascii?Q?MneVt43rgbM7fvs/I+fPqaqizRZBdFTsPaKI1+GR?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55fe070c-eb04-41f6-db16-08dd3bcf4a5b
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2025 16:59:24.9518
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uxKG8alz9xHc6DKwNcTormWXCe+OHXFI6MAz3FJYg15sQXO/e8lWRk1A23bAL5CL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5866

--KzWVvzTRayuZUfYz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

Small pull request this cycle, there are several larger series near
completion on the list that will hopefully go next round.

Thanks,
Jason

The following changes since commit fac04efc5c793dccbd07e2d59af9f90b7fc0dca4:

  Linux 6.13-rc2 (2024-12-08 14:03:39 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git tags/for-linus-iommufd

for you to fetch changes up to e721f619e3ec9bae08bf419c3944cf1e6966c821:

  iommufd: Fix struct iommu_hwpt_pgfault init and padding (2025-01-21 13:55:49 -0400)

----------------------------------------------------------------
iommufd 6.14 merge window pull

No major functionality this cycle:

- iommufd part of the domain_alloc_paging_flags() conversion

- Move IOMMU_HWPT_FAULT_ID_VALID processing out of drivers

- Increase a timeout waiting for other threads to drop transient refcounts
  that syzkaller was hitting

- Fix a UBSAN hit in iova_bitmap due to shift out of bounds

- Add missing cleanup of fault events during FD shutdown, fixing a memory leak

- Improve the fault delivery flow to have a smaller locking critical
  region that does not include copy_to_user()

- Fix 32 bit ABI breakage due to missed implicit padding, and fix the
  stack memory leakage

----------------------------------------------------------------
Jason Gunthorpe (1):
      iommufd/selftest: Remove domain_alloc_paging()

Nicolin Chen (4):
      iommufd: Keep OBJ/IOCTL lists in an alphabetical order
      iommufd/fault: Destroy response and mutex in iommufd_fault_destroy()
      iommufd/fault: Use a separate spinlock to protect fault->deliver list
      iommufd: Fix struct iommu_hwpt_pgfault init and padding

Qasim Ijaz (1):
      iommufd/iova_bitmap: Fix shift-out-of-bounds in iova_bitmap_offset_to_index()

Suraj Sonawane (1):
      iommu: iommufd: fix WARNING in iommufd_device_unbind

Yi Liu (1):
      iommufd: Deal with IOMMU_HWPT_FAULT_ID_VALID in iommufd core

 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c    |  8 +---
 drivers/iommu/intel/iommu.c                        |  3 +-
 drivers/iommu/iommufd/fault.c                      | 44 ++++++++++++++-------
 drivers/iommu/iommufd/hw_pagetable.c               | 10 +++--
 drivers/iommu/iommufd/iommufd_private.h            | 29 +++++++++++++-
 drivers/iommu/iommufd/iova_bitmap.c                |  2 +-
 drivers/iommu/iommufd/main.c                       | 32 ++++++++-------
 drivers/iommu/iommufd/selftest.c                   | 45 ++++++++--------------
 include/uapi/linux/iommufd.h                       |  4 +-
 9 files changed, 103 insertions(+), 74 deletions(-)

--KzWVvzTRayuZUfYz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRRRCHOFoQz/8F5bUaFwuHvBreFYQUCZ5J1ZgAKCRCFwuHvBreF
YYlXAP9AJFXZlB9198pd3VVnVxlrtYYUaV+imQjBIEcbeKxgFgEA+qZ4NTfU0GQx
w/k74Y45YO/uFM3CS28QDwRZ/4XhFwQ=
=/MK8
-----END PGP SIGNATURE-----

--KzWVvzTRayuZUfYz--

