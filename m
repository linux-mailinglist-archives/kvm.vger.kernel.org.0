Return-Path: <kvm+bounces-35325-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FA43A0C2AE
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 21:42:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1E3C518879CB
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 20:42:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37A251D318B;
	Mon, 13 Jan 2025 20:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Lf2yV81T"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2088.outbound.protection.outlook.com [40.107.212.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABD111CEAD0;
	Mon, 13 Jan 2025 20:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736800926; cv=fail; b=nKtxFWLmSCC7SAIiRUb5Li/1b5c3Ki1/i+5enqzO7skVidjYeYX2kYzDIp8J4hCkRcv5r22daK6IFdKvDVmV9fez9n/dRo/avp2gH0/eoM8kv/GbkxoP1fThft7HlIezGJ4lDureMt83kOCfd0YqYQ6wmZQjgyuJ6rCX2iqoKbc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736800926; c=relaxed/simple;
	bh=9UcpwZXlH6LfENETFQXeRGHJDtbLastWDgnVSkO17Ao=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=E7LKs1ZevQzCIe2AqXY7899i+eQBby+vvrYwijEba6DdvujmiHIuL0sE9Ladvf/lfMqVT0lVHPMpybNIygJEUMSXbnAjS4jimHIamjPAVy5S1G+PLZuFi15OXFY31m2hVX1krg2+t7S6IMOhe4dWhRbsTIP4z29SRxWdLAQv6BE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Lf2yV81T; arc=fail smtp.client-ip=40.107.212.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lJp4l8elMBVTvinoSH9Jc3PV1lvK6SxOxhh1EXSPNFd9eHKyDerF7HRYyx2zEXbuE6S1INfpjYnI7r7ViBYyuFmwaLXLMbPDNUF/exorsQNy0K5ExW6KpR8gLJ2vNAjhk2kto+4mzjfWjPrN5MUJhUpi/+NYx5eq4ipYMI/8B0uKLSyEbit3m+rXDIB2ETSkLgp+jbgzzitulVjgbwOzzPIEryRMsbrWrlQqZs5LhacA21LwFqGwQYiRuuQ+98+apF/InDvveTJwqZ3BIpdPC6rz2b79nDuJYXzx5GZ0blRyJOEp5OsMhRd5dmJRYFiHQmGhdvE8gKKQril9hf321Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9UcpwZXlH6LfENETFQXeRGHJDtbLastWDgnVSkO17Ao=;
 b=r85xSZELjSyZRPC4pq9Ghvxh5enmamL+E7QZPfhgmP/W/4t5bF66sbAOAw6ZkwUNnctkmIt6yQmTpaUljfihnBHSPe+dpkzeRhBkoct6pjkqhTWEIqre9eBq/fHSfCY+xrxJfcuI1iE0Pz1ISo7jAAhLCP/yL0mNVHsSk/MDzR/3AWDGiR2VGu2Rre2JDs/edwuckZ0RdKhGm6gx0zX1Ea+6ostXIv65JGUq1+4/p26meS7x3J3rqeL6+abIZ7bWp1nq8ecKpFE0wow94I8y8jxZFNX//1tt8MxDM6j3l2I9joPw79EWQ+sjPPCPAvHJtqgtcLs40xUHG2GbhHTngQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9UcpwZXlH6LfENETFQXeRGHJDtbLastWDgnVSkO17Ao=;
 b=Lf2yV81TyxuaN4YzythBSCbcQPlmeV0Mft0AxcG3tk4hutVkIQnwQZ1twLpEEWw2ymiT+oAtiwZcm1fdEsOxXjHKlxMnmTF0wCGecvSZLKgFlzAo/BgpoUUjr6IRR5O9CS0rrRQ94+RlSa/7toUG14nXjfM0ZNFzboM6MeDK/LL1fxjkZdZOjcTu2HRHN7O/WRuGGlwTMGJ2xcAEQ71KgOs6Eqe8rroiQml9KERJIKS3CH/bUhb40sCrlTiMSd0oyTilUKezGrmajrCompM8lfbTsLoZ/BZDXI/A9WET2/er0XBCbbqcT5v1Wtp+ZmYGQduPh1z87rsuwsFS38+Ozw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SA3PR12MB7858.namprd12.prod.outlook.com (2603:10b6:806:306::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.18; Mon, 13 Jan
 2025 20:42:01 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%5]) with mapi id 15.20.8314.022; Mon, 13 Jan 2025
 20:42:01 +0000
Date: Mon, 13 Jan 2025 16:42:00 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nishanth Aravamudan <naravamudan@nvidia.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Raphael Norwitz <raphael.norwitz@nutanix.com>,
	Amey Narkhede <ameynarkhede03@gmail.com>, linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org, Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org
Subject: Re: [PATCH] pci: account for sysfs-disabled reset in
 pci_{slot,bus}_resettable
Message-ID: <20250113204200.GZ5556@nvidia.com>
References: <20250106215231.2104123-1-naravamudan@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250106215231.2104123-1-naravamudan@nvidia.com>
X-ClientProxiedBy: MN2PR14CA0004.namprd14.prod.outlook.com
 (2603:10b6:208:23e::9) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SA3PR12MB7858:EE_
X-MS-Office365-Filtering-Correlation-Id: 5fef147b-43cd-41f8-f890-08dd3412bb37
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?yQ4DKX13FV4mJtdPlDLMdDzSj2PptEiri3ujCIxe9h6aaC2V33ZyvVjeMpcJ?=
 =?us-ascii?Q?V1zc1nMSFKEV8Ue7aTcL6qYzpE1gUHtHQ28SyzO+lDM8UTb0KwAWqp+7a40x?=
 =?us-ascii?Q?MkTCaOnXHCluV5R5nuKNetN8+4Wg5qNSciSHo/NYoHAf8BuMOCnYcmjh2oAc?=
 =?us-ascii?Q?9xqm0ORikyXTlC2czZ8Yr8SqNt2VrlsEdln9TVsIlRXQjRhBLVaU1brTvVUA?=
 =?us-ascii?Q?FX2GWWdabySSz5iOWFeSgJ44gkwui5hNnjY15XRfTltp855ULNTg4yYxtqCz?=
 =?us-ascii?Q?6bA+DTqRLHnkxZJUMcmj0y2casXE5ap/EFqZeQChQ3DBrPhUyHs7Hw58HNGW?=
 =?us-ascii?Q?N6tEhKP+/YvfFsqGKiX66q/UeThKMCLUv0mgYB58072GBx3f2h6CDKMMSjSB?=
 =?us-ascii?Q?+0cldEg2eJP0pqka+mY/8LrMhuaZC34zVxkLvCrNki+DAroRuNBKteHw/OBA?=
 =?us-ascii?Q?zVMH75MJbMButmfEb+z2qd4PUoJElY68Ud5eBHQ5455IBzWnBWI70/QjjQcv?=
 =?us-ascii?Q?Vdy3p9M8qBoLlx7TSuG+VvfJvwAG+JHCQhZO+O91EHVSxH6KvmQwdURVxkAq?=
 =?us-ascii?Q?wX0XXZLXdynytv4XRaELcHXH2JEWFAna3beRkR9803x77BGwaweSC76EkLYX?=
 =?us-ascii?Q?MCcJU5i7F9rq+ktScxJZZdefTbk1r3KGbZm13ICgpYRCrH3UhR63yMr9T7Ii?=
 =?us-ascii?Q?sGW7+Cr6zd9NNjs9isul6j3dMJkDz95LBq0CtDFvS7mZO27u5PxrS39YlFWD?=
 =?us-ascii?Q?fkhALFBmFqob+ZvD0V0RwM5rX2L/fJK25m7g03UMlxLsi1ha1iX4Sx1Yl1tp?=
 =?us-ascii?Q?OGJcZMouyPP/6IUTOs7+u7AOkomnHpmEkKGDxBxfeRxc6LYRDcoJfP3CuUmg?=
 =?us-ascii?Q?+BCAYYRJLbL5lP0j4yhqi9Qljh5JMeLY9cEWaEL4k5h9V3ihh8UY53DGgUPW?=
 =?us-ascii?Q?8MUO9/WOZI9I8EbWcsvexHeLX1avGJaXrVLhFaIqsu1h9ODmBT+/ELOd7rzZ?=
 =?us-ascii?Q?jWR+U5MI1iBZyxf3BjZHN0aR0XPiMWV8cOF45Ox0eZPS+/OlwyFixVPPHI/k?=
 =?us-ascii?Q?HlKo5qJV8dKEeyOkhAMUMj+eYj1XvP3CLrL7bvV/NYpNeZNw40WiHXxxQK/h?=
 =?us-ascii?Q?iHEbYNIDyjN38YnA57VKn9F+4kH80nytg73YNC2wmN2WM/PcqPzAPwL3FuJa?=
 =?us-ascii?Q?YmWOjCe7ChOsz4Eo+0JEccT8jOUc8vGJn5CdBrm6zOC2N4l7FX6kBboDRZVp?=
 =?us-ascii?Q?T4Ng+KNOkeRiuB026/cmLhpZvCohjumpOy2DCi1N+2IXI7BALu4eGVvEVj3q?=
 =?us-ascii?Q?9MBKD3LdeL31WQu9GwbV6go1/AlAsc38j5FRa5yVZ5g0U2noWoubskS5+R+e?=
 =?us-ascii?Q?T/YO5SMDvlZSRw9xriKeasUTCQ74?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?uVf8vtu3uS13KWszVINTB8oR89uWMW/MAu7DYuvc375WRaly/QRZxMp6Fljp?=
 =?us-ascii?Q?9vLmMnXdOSSsTQ4eggGhMRNHXfSG1s8JwgWnmKVajxlxoKJhrvzwQvQnQ313?=
 =?us-ascii?Q?09WMOEvbjaTTvkdXoLfqTpH4nufsycEyMKizjCsy3psE61e4GGSuovVXOS8a?=
 =?us-ascii?Q?+dI+jmdxJMvGTrL0vYO+OeRZXVnaV/dmqoOWrZ566PZN0cqfeOx9AuPOekiQ?=
 =?us-ascii?Q?cFWNR9QqUxRBXG0NfiSm6R2JkzvMmFzo1ldBSJ/BLzEP5gmwoYQulcyFm7aX?=
 =?us-ascii?Q?leUI3J70DxZ0o41q43ULTrBdOII5PNBOs4Z0tOTH4Z72FoOS8un+nJMXMRBO?=
 =?us-ascii?Q?D58qKSX0RrVpHxNgGJAAOtcyLJ+/lDe4tpTYR1YmnUqxLc5Yqy7gQMGyR9Fq?=
 =?us-ascii?Q?YADxSzdtnJAbOGIWMkGFUbOyOvMw5iwRH2SujiTlBZ6hOoSn7dMBT/7RjS4K?=
 =?us-ascii?Q?8UwgeR533MLUWvRi/ZxmGqD6/fXRijPyRpm3Bt1XDKjyomsQhNpyoyFzPnwO?=
 =?us-ascii?Q?TLVdIN0qHiBOKdMTIBsU1a1UvIgroDZdGT22l6/lw+uPNE/xm37SGHqVD8yb?=
 =?us-ascii?Q?zofXf9kHC3PwyNykDPzwSP+20orDWUSZEBrz+qwWgYyxgoQnbA79VZk+ArZQ?=
 =?us-ascii?Q?vqc3o6kbe/utROGfuUgPukSKch+hcH21rZy+QS/5FK20aTr+zGKYHwPZ58yB?=
 =?us-ascii?Q?Opijc7hv4gQi3OPCVu2Q62gVDOlGYiGHIR5QUvtLgKQyCyFvBeRx7jK3xSeL?=
 =?us-ascii?Q?QVdoI+ZMCeZoaYsNZHp3dj2ZNODTD29fQYABaFTJgU0ynQWvBOHLSiYO0MeP?=
 =?us-ascii?Q?hbcrRV0Akog3ITSp86beYaq75wjSxaTV/SI5DmMhJKp/F5eBZS5UxpaGRkYH?=
 =?us-ascii?Q?ndm7M23ZSkwoKlfvqqzQfzCBvFOAxzP6nI6JFlcMOgpfLPTv4+xGg4L4k3r8?=
 =?us-ascii?Q?CU9EjxQEMrL78Rt6FXhZJD6ZGAjc/4uxto5BZRzPzIcJduR6l5DlGM2Mzk1J?=
 =?us-ascii?Q?3o/chmLivRJqJeYNluIFU0uTNNVq8w4rdd4cMtOvIuhtSy39z0vJYaNvD/5E?=
 =?us-ascii?Q?FFGJ6wYbt/rb9MLQByRlOwZbrAVlX98joemXFOGDgt8r/0s2k9rXyrb1ZtqI?=
 =?us-ascii?Q?E82g39/0HQTNghnXgZD/aDWJUqccJ4uQ5RKObRNeTFKVqrZUkypeUnp/xB9U?=
 =?us-ascii?Q?6s2mFnkJgcTOOGt3H/y9wrhgKXgsiaEfoeyzRrV2J0So3TAyewBIcQ3urvnH?=
 =?us-ascii?Q?Dgv1Ap+EF0G6HOJyyomx0PPb7KgtVzg+5vuQXgDaNi3pq6dmeRBRIOauvXhO?=
 =?us-ascii?Q?qcjJJMHlyzaABo/4/yLfKhir70EdLh90uRKm09ZI71xkeLBGUNlcUZtaFYo7?=
 =?us-ascii?Q?yjuGwStYs3vxmM+BN1kY+5TRhW+SIfSR/hUfsirrEYCsLxsyRqPm/jAONk3A?=
 =?us-ascii?Q?5VUPwjOzP5qyhAb9q9Q0MYGgPb++JczELz5/OG03TGDkXqAbBJ9DmuXqiwVL?=
 =?us-ascii?Q?eyuHE5HEixVhPvHoNYLXb0rjnMKjLlCTm2afI2UqleQVWIaJQzpey+KWTE/1?=
 =?us-ascii?Q?DEdhwAgcWsJkKuKYnBii0M62fkEXuUW4WUUU6gGb?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5fef147b-43cd-41f8-f890-08dd3412bb37
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2025 20:42:01.3325
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ov9PI1y71iT5xnRzz5VJN2xefeuQLbaWf+mtEXkQXA8x1FyfKx1quUk4CCQRh+tg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7858

On Mon, Jan 06, 2025 at 03:52:31PM -0600, Nishanth Aravamudan wrote:
> vfio_pci_ioctl_get_pci_hot_reset_info checks if either the vdev's slot
> or bus is not resettable by calling pci_probe_reset_{slot,bus}. Those
> functions in turn call pci_{slot,bus}_resettable() to see if the PCI
> device supports reset.

This change makes sense to me, but..

> However, commit d88f521da3ef ("PCI: Allow userspace to query and set
> device reset mechanism") added support for userspace to disable reset of
> specific PCI devices (by echo'ing "" into reset_method) and
> pci_{slot,bus}_resettable methods do not check pci_reset_supported() to
> see if userspace has disabled reset. Therefore, if an administrator
> disables PCI reset of a specific device, but then uses vfio-pci with
> that device (e.g. with qemu), vfio-pci will happily end up issuing a
> reset to that device.

How does vfio-pci endup issuing a reset? It looked like all the paths
are blocked in the pci core with pci_reset_supported()? Is there also
a path that vfio is calling that is missing a pci_reset_supported()
check? If yes that should probably be fixed in another patch.

Or do you mean that VFIO tries to do a reset but it fails and nothing
happens, the real issue is that hot_reset_info is reporting incorrect
information to userspace?

Jason

