Return-Path: <kvm+bounces-25050-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AC9D595F154
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 14:30:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 64F782827E6
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 12:30:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EE54172798;
	Mon, 26 Aug 2024 12:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Xn4vM8b6"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2040.outbound.protection.outlook.com [40.107.237.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0539A55898;
	Mon, 26 Aug 2024 12:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724675432; cv=fail; b=caPwubdhd/phzHdGLGyHlHo8nn5Stdr/TZUbAkRYIBW5UBlXAAn0wwDCXTqEC+lpc6j+fULDvyeAIaiD+6ltpk5wOtgVj/5bl0FtHxf5cMwGffCqi0TYcrV4yBx8H+dA6VL6fBflyILbPYJ5x5PzG6RI1cYC1pdxe6/qnQs9LRo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724675432; c=relaxed/simple;
	bh=X0lwjZ3JCYW6doqHoCkCm5i03dB6ykAAEi5FQVOzGt8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Kp1ivnLRDgLje+Cqy8zmhH+HYMO3LgjdmAYeZHUZC0JEd7CqVWyZlBNsgzx/ouwlFpOMLArtKdn03fu9bbogXanzpU0QAzCimanlvpmONdYVtIACtjrXYK4YSjzmylHGRnhdrGbpLKIPlg/5huTDOXVeM37YZAjAchddjan9CN4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Xn4vM8b6; arc=fail smtp.client-ip=40.107.237.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eVh3K/pGdUYXa2vBx4fliJjyIePT2j+gkyMJ8HvwvqXXNkZ9TC3Y9pxU9/eVX0+isTJs90nxB+4LApPND7LtuXnsH28l2FLjVHeLnlZvcrkt0NJm/upY16/wM1A6225BjRBCmzyNSu/UnOpeYlHn/vnCvR1xzkGnkI8Xl9iSFefBV+SbNXiwVciXx0O7Zz6RvVs8RrREvIwsj/B7QFcsspYmShTL4YqjZNZs/gj7QOw8mYYMmBSwYDd5wj3oSHJwFOPqIS5mGC5rubErYvS4M3g3zZUZwP22maXw7SOu/dKhaHkm3+UjZsoMpxF/aOifhcDBdkw/dSDhW6TwC+zECw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4bNPVDOnyyh6ioXdvrQP7fgOGk0h42DdWLSdXf347D4=;
 b=ZO2qhZv4BK9UHBAkAsSChLMdZg+yw6qzC5xUxC07OhF7plZX36eMYDsxO63G6s+sx4j38EEE5nXbR047/9oJNbOZKa4algrH87JEW7thYStrL95PxOZZl9Z1NhJ6XwjegSE6ClRbMnO87D74CxRFmSqMAgA6ZxyyqAL/GhNprUovIS60JjDFPLJeJJ/WLeLYqMEm5gYQ70uCom2WWzyPpbZihILNpD+pI3Fib99/4WLZGfWPZ3+Wjg2hnBRy8bqVNBK2IaKADUWV/S5d5P85vEfX/3F5EoMskPPBHmGkIHCPVT0gcQ/Lop7eevryWZsUfyhi8Fsy1PDxVAWysc/2/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4bNPVDOnyyh6ioXdvrQP7fgOGk0h42DdWLSdXf347D4=;
 b=Xn4vM8b6CKYiNqH7DEudgvYyp8/8Z0UHg0wWSzFxeVEad2g3S5HUpg6gz60BIh2KrR+ptkQRJpwm73ckFoYhLSsozicrks/QxevPyjVXRiMq6k+V6+TcWrxH86Coi99Hnh/EyW+wkdUevfefo+iYEjhxMUrwkFXTcB//RrJIq/W7mkMOHUBr2C4i79IpZarnUWFRz5lzEZKQIonCwIWPeAP7nlsLhjY2ta2PaS9/24Z9khcJBe/MnRnRe1F9PQjbN+UqsBqLFUOyZ1dEDLx0whas0VkmjEwQiGheV9m98D2H3d7CQE1BXvAEK+S29eE2hz5Pztm4aADuzDRMAfFVYQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by PH7PR12MB7329.namprd12.prod.outlook.com (2603:10b6:510:20c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.24; Mon, 26 Aug
 2024 12:30:25 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7897.021; Mon, 26 Aug 2024
 12:30:25 +0000
Date: Mon, 26 Aug 2024 09:30:24 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: Alexey Kardashevskiy <aik@amd.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	"Williams, Dan J" <dan.j.williams@intel.com>,
	"pratikrajesh.sampat@amd.com" <pratikrajesh.sampat@amd.com>,
	"michael.day@amd.com" <michael.day@amd.com>,
	"david.kaplan@amd.com" <david.kaplan@amd.com>,
	"dhaval.giani@amd.com" <dhaval.giani@amd.com>,
	Santosh Shukla <santosh.shukla@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Michael Roth <michael.roth@amd.com>, Alexander Graf <agraf@suse.de>,
	Nikunj A Dadhania <nikunj@amd.com>,
	Vasant Hegde <vasant.hegde@amd.com>, Lukas Wunner <lukas@wunner.de>,
	"david@redhat.com" <david@redhat.com>
Subject: Re: [RFC PATCH 12/21] KVM: IOMMUFD: MEMFD: Map private pages
Message-ID: <20240826123024.GF3773488@nvidia.com>
References: <20240823132137.336874-1-aik@amd.com>
 <20240823132137.336874-13-aik@amd.com>
 <BN9PR11MB5276D14D4E3F9CB26FBDE36C8C8B2@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276D14D4E3F9CB26FBDE36C8C8B2@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR22CA0028.namprd22.prod.outlook.com
 (2603:10b6:208:238::33) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|PH7PR12MB7329:EE_
X-MS-Office365-Filtering-Correlation-Id: 4327375e-f4b7-4277-e3f5-08dcc5cadcae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1UyVuY0voznZN5Vi+gLTNtAOY/J1WDD5Yhp1YIh6AdHnI5UWsv3OgioVrcFx?=
 =?us-ascii?Q?1LCoS3zhvpMBWewxWBmsNthKQwSCSxDQBn4e9O8Y4hWMJfNcFQp8Wm+7mNEg?=
 =?us-ascii?Q?iabDA5azPT3fpz25TWeAppNbSIKU27S8UcOuD9gFT4jZxkYgpmKmdL9BuuCI?=
 =?us-ascii?Q?uih9LQq+0s5FsvnYGd476TGDq5Nc5v7xGinTgCe/bHNSz/zCE3q2J8eL+2LD?=
 =?us-ascii?Q?nmOqPYMr0IqDpzWM30+QUHtWHqiiWGDLdtciL5yVOWMjudibA8nYn+aN61ku?=
 =?us-ascii?Q?8mJKoZI8h10rRxIiXDdpmlITrWThAWZuSRFY5tI0Fikhgt7QCdMizbRbNoC0?=
 =?us-ascii?Q?/ZGRO7vLvXj5k7KH2uqIzwOVi9fwHbpsNArRbzlxJsDaICYQNqcHP6HRMNb2?=
 =?us-ascii?Q?d8HRqhBomPSAzcY1XeW3pBGyWz4qR7DHqKfnqJdalBQrJGiTr1ZCJbhepjrZ?=
 =?us-ascii?Q?IdgE5+pXW89X+xVkAeXe62brmwJxF9GSxNEMnzUXkQCKVDcOBumxTTGB8GGZ?=
 =?us-ascii?Q?Y+Fx0WywXyaCatAMrIeBlRJi5d9I2/J8eWy9i2f0ore0smS66JTOli3T/Em0?=
 =?us-ascii?Q?aiCMaMVRUIV06uDD5TBSpL8b7X6tiHP8AK7WCvVdGSOypgbFDXp4tn/ii33A?=
 =?us-ascii?Q?lPYlMWlZWHLZd5AGGQv5GiS/WVd9omsDRLz0u4XaS7qSEI1OpyiE7t2JwSZX?=
 =?us-ascii?Q?uCym4WrxMsPmO/1k9MWyEohWVUAz/Y4CCDvAHUBW12Id6rhw2AmZhOcgTKGv?=
 =?us-ascii?Q?uPZu93CermAm5fYFxslPP28frEuhgiDSwxmGuT68vxAqTAGjMTtmomoMP28P?=
 =?us-ascii?Q?t0dMkGMB3QHWZjVelG12p/RItgVVakgE3iV1EushUuaXjqwTFMnG8+yZXMtG?=
 =?us-ascii?Q?zBXTFjig9O3rasxQ+8Qhio8Xeowa045ZJ4UE63jaGfNxCsahtKtW6QkEJFGj?=
 =?us-ascii?Q?ZsGRysBEGEvsubYajh+gHZtp4v99IsCEGWXbMi2YBmvucDfCataBybKC+ERY?=
 =?us-ascii?Q?TueqlizqtVSa00MCGRq85MG92kNWLF48qYTXt/SAp+wUOfKRmQV+bxddhhgi?=
 =?us-ascii?Q?MKRigFn5KmJcNvNQBavBZl3fN9xkK2PCNT8M49Po5unVe8eU4YHcUyRSieeB?=
 =?us-ascii?Q?hRvffBzpIzp+K0hhFIMgrPLoupWCxNv9maSXCNG2cIJJOjbrfeaH0qev3GvG?=
 =?us-ascii?Q?ZuawnWWPEfjg47A9tZ+v7kzd/1BnAYFTgtlCxG0+4zOQo5JKaIYu/0pLcGUo?=
 =?us-ascii?Q?AYXN6TDMug+c8MaDKrKwMIkf5ld8Y6NdcHGUrqiCw8ewrVo+zLx1RqJGtFO7?=
 =?us-ascii?Q?HQBLTHCiWQ7tkMbUq59ePVhva3i1/YSo3eddyejNDB5leQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?pXNFdSwMuLyBHhzei6TRMU0sqgExo1h82J5Kz3SBzEwMg15VovQdighVype7?=
 =?us-ascii?Q?TprSk09Xg5vC1pwL+b/RMrr6VYANMNHZcBT97BOhk+ec5MTKGsHCElfyDNqV?=
 =?us-ascii?Q?JRfIYCDyW0TXkWctNrBXdM7wWAB8fXRd222nGtrs3DyA1EUpUqbra+iimakN?=
 =?us-ascii?Q?BZdW3NAIXOCkOUCKBrlKFeyLW4wGwbqxWCPx8SqulLy9sEBzen2ljosLRhim?=
 =?us-ascii?Q?XIYK0YfJ/59XNvGPpH28vQWhtsOZs++rKL/zrtSXYLffUJhmquJeo4Nw4YP+?=
 =?us-ascii?Q?wRmyUL9h4ddHgvMud+l8DzxnuVif6T1cYbPoX4XSEh+IZ3uu9GFZlQKTKJ6L?=
 =?us-ascii?Q?gmFCjb+qcQMDewuZKLhJgWDH+iNb7zJ8O/Pi/jLwKi943EG8evqT7HcwEyVB?=
 =?us-ascii?Q?HB8dvf6tNEedl5Cy6rymXgk8YavZhcOC17ph4Ez5q9Cdp8sSzdqL97fjya7L?=
 =?us-ascii?Q?tFJwpLvJIP6rqK9g5B1/ci+kCrhfSsFNR/kB0o+ZFNcQeK8u16UU8IH5u63n?=
 =?us-ascii?Q?/SnrVKht57T8Fu3J0PbfLqV/0B4UZ8OFjJweL2zBnD1gLKgsZiz1IEtoLUai?=
 =?us-ascii?Q?frSVdQ740RIAuXNsqvEWl4DeoBU2nV1MclC00sO0O9tPNT+XR5Be+eCuSD0q?=
 =?us-ascii?Q?eUFuILo3HipRxZ7unW2XcjrcrEkkM+XURhj+a2p4tVMSwDuFDs+qjuWBhjNU?=
 =?us-ascii?Q?9WoyB2dbcmo9gvkJQ+SnF8x7iJ5HVbydYFmm3PWJAKcGxdvjGmCgdpXQQ447?=
 =?us-ascii?Q?yjdspJziO4DOt4T/BfswTOa12ZTiQqf+1N8paOLt47VFNllzuqesYugWfBgB?=
 =?us-ascii?Q?i18o5FTJzgXLlp+ZkDKBtl/GEfkhsmvt88fjppItc7haJEZRMxqdukqNwvrb?=
 =?us-ascii?Q?MgqUDm5rn/W4wokks0RdAxOt9onTb6Z8btVo1wsYoUSSVzE2VMWPlDZ0Q77M?=
 =?us-ascii?Q?6CpzJl8mnD/BZ2L8rDZmzgvdCKouHQChfjInKM3ls6vz2lT1ZNNvjsrIOHfn?=
 =?us-ascii?Q?vCl2w8U4NoGgVJXSzXVZxhG/kEJ1yHsHp96S2wN2qlgzcYDsgQ++j+wUEksJ?=
 =?us-ascii?Q?qKUfdqQc/S4i1qrqoVW8Jmhs3xJs2g/cNIowMXepE9ypmaNlnhPNLKCrqBBZ?=
 =?us-ascii?Q?KQ0oiRNoV63EMOsy6AT8hjrLYb7pz0+dhH+2I7HH38YEX+xDB8kXDbszTIrQ?=
 =?us-ascii?Q?3wxDOXYARqQvvByMfOkqDYCMfWeO+OdFsY1WXT+MSp6abvW9OYZwZbM9xfZB?=
 =?us-ascii?Q?gsn2iUq/Z94kVr/QwzJlRIspKrnXdT+1iIzaikK4AYg8Tqe99BEddja70WoH?=
 =?us-ascii?Q?d5MgELLmFMVXWUZXReHzDcQqwvwIj8MW2HYMk8qRjmPDbhDXENKkuaDF7nAs?=
 =?us-ascii?Q?YrRdfUIBtw4CfSE2rmIJuQ8fPTU3Rzv2dGYzvmW7TdAAIIc22ACZgd7kL7vY?=
 =?us-ascii?Q?xIaescKiXU5c8H4jKOG7x4aaJpxdB2Xynhdx+UOdpMIeDiYZ9TLFPZHPPl2y?=
 =?us-ascii?Q?qblBRB1xk0XSZ3JryXJRsnXuz6/HAIIDevQaxUPNRlfKO65ApZxQ4ALadQGf?=
 =?us-ascii?Q?fD8uxdEhqvN43NDe9gg=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4327375e-f4b7-4277-e3f5-08dcc5cadcae
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2024 12:30:25.7581
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YZ0fq1VYfbbl1fZhFlWXoFlcas2VKHVx8Ao/5tNmnacErWmmcFfq7MMGljt7Mj73
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7329

On Mon, Aug 26, 2024 at 08:39:25AM +0000, Tian, Kevin wrote:
> > IOMMUFD calls get_user_pages() for every mapping which will allocate
> > shared memory instead of using private memory managed by the KVM and
> > MEMFD.
> > 
> > Add support for IOMMUFD fd to the VFIO KVM device's KVM_DEV_VFIO_FILE
> > API
> > similar to already existing VFIO device and VFIO group fds.
> > This addition registers the KVM in IOMMUFD with a callback to get a pfn
> > for guest private memory for mapping it later in the IOMMU.
> > No callback for free as it is generic folio_put() for now.
> > 
> > The aforementioned callback uses uptr to calculate the offset into
> > the KVM memory slot and find private backing pfn, copies
> > kvm_gmem_get_pfn() pretty much.
> > 
> > This relies on private pages to be pinned beforehand.
> > 
> 
> There was a related discussion [1] which leans toward the conclusion
> that the IOMMU page table for private memory will be managed by
> the secure world i.e. the KVM path.

It is still effectively true, AMD's design has duplication, the RMP
table has the mappings to validate GPA and that is all managed in the
secure world.

They just want another copy of that information in the unsecure world
in the form of page tables :\

> btw going down this path it's clearer to extend the MAP_DMA
> uAPI to accept {gmemfd, offset} than adding a callback to KVM.

Yes, we want a DMA MAP from memfd sort of API in general. So it should
go directly to guest memfd with no kvm entanglement.

Jason

