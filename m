Return-Path: <kvm+bounces-64545-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 314C6C86CAB
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 20:23:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 75FFD354188
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 19:22:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B91D334378;
	Tue, 25 Nov 2025 19:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="HoGvsDjj"
X-Original-To: kvm@vger.kernel.org
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010058.outbound.protection.outlook.com [52.101.85.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98A18334369;
	Tue, 25 Nov 2025 19:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764098394; cv=fail; b=I5QXFmGWU6YwBuVT9PQ4H8Ar0934kwR/JTOCEOnJVhginTidwK9gDh8yC6Ak1V3mSGQIuOP87S/+J7gIOaV3xg2vEtCb8hpape5QfLdBK+oJk3p3/SD2jsyY2NEFhq329R7S/fc8IKMIjuMVlvs/dCKAcjVgALlg2dxUUpyfXKI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764098394; c=relaxed/simple;
	bh=xbS+OAnC5yObRjjgz159mZRIPSF/9QDkP9dXzkAhH7Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=m4hZmMOsZ6tYS1GpSpwebZlzTXAfHO7PPZUfu+j7oqn4pHDwiQmFwj0RppA1DO6nOJv5JpsNmX9ybsPZ1WFjTMXYq27vv00DI6DQC43TsPep105RvygbiLuXM1bpum/18hactJwR/UtXQpTjniWR+bLelhMvHwEbNauLXUN7+oU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=HoGvsDjj; arc=fail smtp.client-ip=52.101.85.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n83VEMHG8UG4/mi3JzE8vK+BMKhx3d1kgnH3QfGF0XulpnN8ZkJjGwWq82vsHbPEe7B0GQbrTomhAyVd35ZUrn2KaLm6tg5VKpPjJ0enhVlXC4Wm6VnA/DUyl3JgjQl9nU13ngp10B1JTj/Aery7yWfv5trBjcOmaOOLlN4pTHznYruuq6+YAlSxzc8n1XUPklPIMlhkYLoX1VemhMQREqOIJ/wjnoKs6EGtYOFWYL4PSC+jCJDFmdYhnAamlaZtoNKtqESY2nJvAWoP/hWq1QetQu8Xu6U5dGAHCTkd6hmIRby6bpFD6/vnEPxPX158+Pr4IEeWOrArB3CSd3HcXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WE9pH5M36PWvy8ZmKtuDN0jrmNAsbllTRTJChQ7LC3I=;
 b=vLBkECKP7mFFXSsBoZ36EakRRBW1Jl1lKlpLkd6SwgVaAx97EQk9ZNbxHEVyUP0xofhzOZS/g345+4kJzEA5RcbEZHmRXza7ArXTL4TrzIETd0ptz4HEGax9mhAORoEzwXngaAstEP6d16dcDg98RfD6at2bzGc70FqMRDzLnwy/9hLEvD9MjEWXZxQI36EHHas/wblg56PZ8sqxp2LpqCjgDw8stl0I/Knv19PgYRK2wYHDqG07rjedEFmw1dnOpIv8gg4CpXKA2s88ejr5WiK/z8Wl3xOazOYB2tucAtEOosahTO18UELetQPgT2WTjtnDz1eJ+91m9MWzsIggyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WE9pH5M36PWvy8ZmKtuDN0jrmNAsbllTRTJChQ7LC3I=;
 b=HoGvsDjjdNU66zZHcb2lZg2QFgC+/wwg3NDhDPU6e9lQJqSPz4dt1ZwRyVBCO7c6kCvTv61WiS07DwAjz4MiYehv2h5Q3czdvZ79s/zDSA9BbBXRojrG9OSOzBguiPjjstIkaJ2slAjRvtGVyBJvnmZM9bdCQQLiRS+OoY1YBh6dkCEibPM7o1d6E6Fs5D3bqjVSSjd0k6mCR71JYfYHWyZ4pFCnNxvvKuE7puEu6X2qBHZZle5xKlVydD68b+Qg9uHtbdd7+2SRyZc0m5D+Pu/oJs6x0sY4LtwUCDh3P18hA8fSfr+VcJytMD4zos1E+rc7IDWu/TMqDodJfd01WQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB3613.namprd12.prod.outlook.com (2603:10b6:208:c1::17)
 by DM4PR12MB7552.namprd12.prod.outlook.com (2603:10b6:8:10c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.11; Tue, 25 Nov
 2025 19:19:43 +0000
Received: from MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b]) by MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b%4]) with mapi id 15.20.9343.009; Tue, 25 Nov 2025
 19:19:43 +0000
Date: Tue, 25 Nov 2025 15:19:42 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: joro@8bytes.org, afael@kernel.org, bhelgaas@google.com,
	alex@shazbot.org, will@kernel.org, robin.murphy@arm.com,
	lenb@kernel.org, kevin.tian@intel.com, baolu.lu@linux.intel.com,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
	linux-pci@vger.kernel.org, kvm@vger.kernel.org,
	patches@lists.linux.dev, pjaroszynski@nvidia.com, vsethi@nvidia.com,
	helgaas@kernel.org, etzhao1900@gmail.com
Subject: Re: [PATCH v7 2/5] iommu: Tidy domain for iommu_setup_dma_ops()
Message-ID: <20251125191942.GD520526@nvidia.com>
References: <cover.1763775108.git.nicolinc@nvidia.com>
 <6e8aacd34b038e7534fc5cb3fa21ab31b1af01ad.1763775108.git.nicolinc@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6e8aacd34b038e7534fc5cb3fa21ab31b1af01ad.1763775108.git.nicolinc@nvidia.com>
X-ClientProxiedBy: BLAPR05CA0009.namprd05.prod.outlook.com
 (2603:10b6:208:36e::16) To MN2PR12MB3613.namprd12.prod.outlook.com
 (2603:10b6:208:c1::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB3613:EE_|DM4PR12MB7552:EE_
X-MS-Office365-Filtering-Correlation-Id: c0b81465-0914-4461-a89a-08de2c579652
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?lzSXOfLP44buBb6jCwnjmPxnqtz05PeOzGJKzgbY+oNEakNvyShAnaLGMQSE?=
 =?us-ascii?Q?3jA7dI6jf3o5QYk4LHRct47QVHPK4BbFNQGzYoRaSqXy4xI6rJc63dz1/y79?=
 =?us-ascii?Q?E7WHmgtt3RyIEfeUpMd+An3C6tbh6AGzM/LrKq7YzHfvX87HqVt+4SxGVT44?=
 =?us-ascii?Q?XepPAdqiMfNyEnmTdNWWIqyaSnTUppRNIYhoXutO7jtt3ABOTtoBumFTPaoQ?=
 =?us-ascii?Q?+jcJ43AbCa8d/XO7ZPULQA2XXijiSlaMuU1mOG3rhsYVFS3RtuP6HGd+fDR+?=
 =?us-ascii?Q?PWGgSKXbPOzLQC6EwL7MxebfxLAMFM6UvJEsGXbovbqTO+2Vmdf+ILTj3z/o?=
 =?us-ascii?Q?Y80oCAM1+X/wNM1huy7sCGQYKwHlgnbioUtN8rp7IopS5otEt534TKr9/AOT?=
 =?us-ascii?Q?mOQXq+jXJ3xBE82ZJxTtpHcMl/0irBXJ+4iG1/EOSRDOI9xGwvwybSOLMhBd?=
 =?us-ascii?Q?X36zmoOyVKZfURreRHus22OxpBytO7JRWvQ97iDZ2y0X/hwv2Pva8b/DZ77N?=
 =?us-ascii?Q?i77XMJuWGgHQXw+IUAOJn6CeIdwjNTnnZlmxB7FyVXycHB278w8h3K6Y1PXJ?=
 =?us-ascii?Q?Ur7C/CPznUlOuqBbe3oFnA3JkUabFMUH2KoaMdIc89YweRn8+fGfUv8BGGEM?=
 =?us-ascii?Q?tYNs9wFwOQPFSecHCyCwZSfePjIgEoUVJukyOGFWz2l0KNS+qdPoBEC2aQvs?=
 =?us-ascii?Q?U1TTLfoSZTMJMWeKOYYteMAtPEgyq/otAl/QP9EOi8tPPFdN2sF6qEbR64y4?=
 =?us-ascii?Q?xnXni18xmiQEnlef1/pi8XHWEz39HgVKT6LmkSmdIRHh+x87B6UtIv6Hq6w8?=
 =?us-ascii?Q?5QIwcsRI/k3W94gaUU5V+Y7UjGhXFouRjlJxKxmoPwVXkmynyNCxmsoNh9JV?=
 =?us-ascii?Q?UURZ9YkJDuuNgDbTCsE7R/S14i3j134FYDmfRx7fLKq3JQoaCKpdKjPtuob5?=
 =?us-ascii?Q?D/Hv4WHki+nI8p/ynBNVeN7hgTRWA50u9+m2onMeT2Q4Vbn38RYxWblrBeeH?=
 =?us-ascii?Q?BIIX7vBKko1kmefo4sM85dZ6Zx7RRljAjISLNa22ywMR/VCyXYCmld6hLuv7?=
 =?us-ascii?Q?IvE0hlQLbjO3XhWyay+XMDabXqPwSiatidsp2C+8TtWJ7jEwyeAiRmJ6CfgW?=
 =?us-ascii?Q?HDz8k4G9fOye3UOkTrXKzh929PYSDdZxS8ID8hdUxFiM0KNSlp38KSpbOLse?=
 =?us-ascii?Q?r7znsi3R+/1dvBSKa7I0mJJfUk/Tx87KmjCn/3LDDwv3fs29gbnqPgfWQq9V?=
 =?us-ascii?Q?rDCycZp0DvfC2eW1mSFD/RdN0bqheH8yx+/PhV/vyovtbmZhroAJVl04sBJQ?=
 =?us-ascii?Q?lyTsQbM/TOriAeBQW59ivVhtKLFkGKsuVws9kydzJbW3DWTK/y8sr4ipL/QR?=
 =?us-ascii?Q?9NUAuVAl/1mOuOgprd1TgiuQov3Ncmex/XRXJoIv7eLkVLa6t4aLeVTMzhjL?=
 =?us-ascii?Q?eEStaIqzlK/iUVDariz5UgdjH33Qsish?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3613.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?C9by6Uc5AOIfdo0iMKCfJuFGpkzqckbz33jwnLauaiVY+QXA4JFiWZa/EMnV?=
 =?us-ascii?Q?JEqMdu9TLzCg3vtwnx8Pd4qYbZExw8692nL9GQ5LDgcp2HqpYPC/9hM0/bMd?=
 =?us-ascii?Q?7J0hm+t465uxK02Dtyh7jbeupquzQ9qc7BGUhRBQ8HPoC95m2gzQXtbK/RwD?=
 =?us-ascii?Q?pXnqpQy0nuRlfLx14LhCI6lAcVRljny9bPbRCdGmOHHxRWtYWuxyYGS57MUG?=
 =?us-ascii?Q?jFXH9crv6R8GfYlnPBwES4Clqx+STS3h0FOKOQNFR7W8lCnBI+fl1J1Vkx22?=
 =?us-ascii?Q?G8IRRgSBVf9jlizIXt38MgPqZCvyuho8396Wkkxw9UZUL2HbJNgQiwqscrwi?=
 =?us-ascii?Q?eKBGV6hxiF5yoTpn1D7vlM3yt8rR/d1ddtjOy7J/dbmduYGsvS8wGdqHwWct?=
 =?us-ascii?Q?4/lSELGhu50EsEyj0lM4+X1SPUOLfQUC96yeMqmtjHXabLiAUaydFUh2Z2+a?=
 =?us-ascii?Q?CdLCnFrjAQjilywElIGPZmeN41GAoWtNmWsszivPaPoplcQyf/qsH4SXiWj6?=
 =?us-ascii?Q?z0PtTFEBOuyMzPE+R56OnjLg7JdA713bOdYf5fl43TbBdw7mDs3TUUVAZSrl?=
 =?us-ascii?Q?QXyosrJwnrSfj9FasBvr79kfkUqFFKrbzaBwUjdMun7SPY/1bNGByRVqFaU0?=
 =?us-ascii?Q?vWVLqAYjCDAm88oSVXWas8LINGxFXiD4bwf2SmhLa5Ayi8NwmBgCRHBOFcxl?=
 =?us-ascii?Q?UxzO7dzANNTigKAWuAqabcciyf8HLChNhIdt4gqdCg18Z9REo/wOTCtg1wXR?=
 =?us-ascii?Q?0mFnMHCjVab70OuvhZl6n8eIXz6hNgMFRD2YPVlGCSI2bmFGF8qptdujuhTp?=
 =?us-ascii?Q?Wyyu08u0OjGXEKHEGq/iRmptT3el/m1hh0wuWRFDyLyvHuUBnQDVMf3KTmKT?=
 =?us-ascii?Q?Do5pRQTJw+G6FO70ViRMEHZ+9h5StddR8SoDpEK+M4GHFPoeec4iSqGjZVRk?=
 =?us-ascii?Q?Z68F5/lIB8QfRim8mwRxPh94OEIwk4WPS7o0FQCf6lalaisfD5kN3uG3r3w8?=
 =?us-ascii?Q?btuspOALazA5m/vD1nOB1i8USXpuJXlgaGyfIlDKLms5x8khQA0sXz58yeo4?=
 =?us-ascii?Q?B1pAuVhEnTvttZFPViRuJP+1K+PfX31g78/ttvL7GDbb4XqG7Lf2sKkYBWA0?=
 =?us-ascii?Q?y4KufEXeB5fsvbY8qZMSTBgosT06r7cVrg4ieyNRNUW2zEwYoUrlgk73wMM1?=
 =?us-ascii?Q?3k7GG/fZSTnqPHBG7eWZlb3FiNFYFdqydwcP3A0tyFWfv5OBMmpIVyaoO/vG?=
 =?us-ascii?Q?3yHhrdr51IcJ0yP4jnGjJHYwISr6+tBXdJFtr9UWacO8UeQjWu66FX89EAHV?=
 =?us-ascii?Q?MT81KYStfx/URDdgSGEqG/7vfi6fPapZRTWeK/jW3fD+T1VKGx14JrsFUuXW?=
 =?us-ascii?Q?jDHkTM/h++JEOPfWRlotrXADzyiEIbro6i+Hk9sdRHc1O1d3xju087G8kyMn?=
 =?us-ascii?Q?n3nil8fhWZpfsDft82ef0XZPnl7+frprfN9ye27picIJ6XhVHv229hjvPumN?=
 =?us-ascii?Q?CG6sZCOKUN38K6hruqDaWRAXfR2kDjqSpWS5YIpQMBIVJAyOULRJZUFKtml3?=
 =?us-ascii?Q?QsHkgz4BERMXodH6E/Q=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0b81465-0914-4461-a89a-08de2c579652
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3613.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2025 19:19:43.0286
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iNpeFHJW6zMFZPAzKKdW/iV9L5BdMDhszg+zMstG+0K0lCwjxeYwuQNLisqJERVs
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7552

On Fri, Nov 21, 2025 at 05:57:29PM -0800, Nicolin Chen wrote:
> This function can only be called on the default_domain. Trivally pass it
> in. In all three existing cases, the default domain was just attached to
> the device.
> 
> This avoids iommu_setup_dma_ops() calling iommu_get_domain_for_dev() that
> will be used by external callers.
> 
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
> ---
>  drivers/iommu/dma-iommu.h | 5 +++--
>  drivers/iommu/dma-iommu.c | 4 +---
>  drivers/iommu/iommu.c     | 6 +++---
>  3 files changed, 7 insertions(+), 8 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason

