Return-Path: <kvm+bounces-30955-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 16D869BEFB2
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 14:59:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3B2C21C25201
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 13:59:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FE5C2022F9;
	Wed,  6 Nov 2024 13:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="kEuHk/dA"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2076.outbound.protection.outlook.com [40.107.95.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE4C8201114
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 13:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730901556; cv=fail; b=ig44DRalVSNaVot7SIU9abmHuQAuuHghRJ3Py8fQVepa84HLAvHX5+JOKY0kgLVIbkiC3jLY9KP+A1V4oY9JWKDmL3306eGaVBbwUgFppsG4ItPzdpfg4jGjjSDr1PcH+UQPMpOfaptSNJgR8aws6cFmHazrA+kzdQl1y7+NjGM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730901556; c=relaxed/simple;
	bh=D5asV6Xw6+jStl4LsPOwe8CfOcx66ywaLW01F1hi9UI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=VP0aQVBYJznD5kSZnF9kDyLFqpYL9lXSjPTiXi6RVzSjGHRqHjarBMvgq+NH6C1nnxqayE92Ux2ucYmHLoUXmHbgzWAaaRjKsoI6zLcJTgZIk2v74WWpuDymKhOF0Pf+Ak4RieZlfl+rLe5ORPciAD/OwiMzOA41acW0XE+TasQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=kEuHk/dA; arc=fail smtp.client-ip=40.107.95.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D71PPLcd9P+cq5ANlxja069YCkrJcVz24669FybAhkcax/kXpKbYvrS9E4Hgc31tP3n/XSdapa3taba2xTGw6+y7VrI7IUBii2eZLV9myMxLqtQqDpIghWuyPs1V6sZnk70muVjzYOiHlPIHa9ykGpi3/r+kVz+uM/gRaIzToUS+hJAh/qo0yYFLdIt1yXtp4Bs7peW3TWmGNQU1IPLsQZkMgBJ+MdUns0T/6h292ORB180TnhTEZXxRe1XYOrqbuVJPD5Kyp4OZW2hO5StODkqHXhj3onRaNe/TsCLkVjrq4vjOH175KZ0Ni1oFzdsjvTuEEPKduO6iewcDy7S1bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bneBahdiOhu2O1gGeTrO3/mOl+3L+LdtGMzt49f8688=;
 b=JK59RkOEgyKfxUSxdvq8VhR+ZnNuYJ6IaH6ZnkZR0RGAdSEjwM8WEbQou8qzw/9HXwmf3nYPuw4nDhUM6lo5DRxh+LJeydKX6r6Vs5SUKOgoS2mN+JLunLlt57dW4vLODntQ2+GCEymLNX6avL7oYP8AtyU2JS4T4p6Hk4VcS36N1hj4QfKnTmquCvIPYHe+E3shQBl5N43VcG3WmJjqduANgtwab1zMcDsoqUYfkHfS5i8RG6nGTD1WvxaVqu75G8FbpO6O9arm6UrxaQijQk4UbvrZWIC4T7GuMkmGaGFR4ZLxxqzokDp7L9Tt4XBtrGMXLfk9BK774SaBTCfuAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bneBahdiOhu2O1gGeTrO3/mOl+3L+LdtGMzt49f8688=;
 b=kEuHk/dAoBeM5g/uHAa8iM+9C+eESsN0gyGfO5e9EgtZuXHdFYIKjc3ydC4TBOl1vTln+OyRRPwXR7VlTBoz932AU1zGz85GQLBQvIXgWxG0r4YwqBhMdpDzzD+rm3cAR6ZUzzpmNBU5nsO4n5PPuQ31gIrfdxhGhItbxPxSfTtzSoQ7JKuAE5BmNKMxxNwvoCuhkU+lk6yPaXQwc47l2JZ2y6ifDlohkaap9CFbMI2PU/n0RkLKZFSPwgkjl/DnXQh3exEXO0/azaH8zT0LAglRyu4N2fSlLEh1jmjRA7Utb2XwZ9sEN1tYzsFpaIog+qzHQTg+m1cZSaRBLJPFbQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by PH0PR12MB7864.namprd12.prod.outlook.com (2603:10b6:510:26c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.30; Wed, 6 Nov
 2024 13:59:10 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8137.018; Wed, 6 Nov 2024
 13:59:10 +0000
Date: Wed, 6 Nov 2024 09:59:09 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Yishai Hadas <yishaih@nvidia.com>, mst@redhat.com, jasowang@redhat.com,
	kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
	parav@nvidia.com, feliu@nvidia.com, kevin.tian@intel.com,
	joao.m.martins@oracle.com, leonro@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH V1 vfio 7/7] vfio/virtio: Enable live migration once
 VIRTIO_PCI was configured
Message-ID: <20241106135909.GO458827@nvidia.com>
References: <20241104102131.184193-1-yishaih@nvidia.com>
 <20241104102131.184193-8-yishaih@nvidia.com>
 <20241105162904.34b2114d.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241105162904.34b2114d.alex.williamson@redhat.com>
X-ClientProxiedBy: BLAPR05CA0038.namprd05.prod.outlook.com
 (2603:10b6:208:335::19) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|PH0PR12MB7864:EE_
X-MS-Office365-Filtering-Correlation-Id: 55749c2a-7cf5-46bb-79e6-08dcfe6b3053
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?yf4KkxZiRvmAWTDbSWYhrmevG3IMfc/ju98iswG9YMU09IM5lDYtfPhOnx2T?=
 =?us-ascii?Q?GhWnm71TmCRoxl8HVVcH8kI3WlbWC0Ws9ocB5VKJ81cxxrXvJ+wvS9OlLe4k?=
 =?us-ascii?Q?awLn6XBN2fACTu0of4+liHvOlS9G9zoYIQrzoIDOKINr0Qp0wvZ739sy+g6E?=
 =?us-ascii?Q?4iP3K6fDSauwGWmTN/HNd6Y8qWGTVIxu9RLoLCsWILw7+Quaw1OdKGsWWXY3?=
 =?us-ascii?Q?kXPhglQwa/1lC0wuO/sWBGCDcZpO8Io4hBSKD1R946Sm4g31DBxETHLxfzVe?=
 =?us-ascii?Q?79bBWHrg5dk2EnUCWFIFNLU+Pz5kXCjizc0Fz9oTM2T5bqjSPAo1NEHBefhB?=
 =?us-ascii?Q?GoWpRCdVaYlfp15c0EEpcnp0o4Tsvp4ZkCA68eBj2PvUWLlqMs7ZKpHi8f/0?=
 =?us-ascii?Q?/a0iFC5e6GFH3MFmzBUN2NmDCPziOWhuTUMzbN9RULXDrK2OMMySgyQaQFuy?=
 =?us-ascii?Q?LDFTxLPZuCJc0HgahD5D7adFutLQXUFI5w2Kvc4Smfe9bTUIBagiwTCX0EI9?=
 =?us-ascii?Q?/ZMS6zH9IAa8/MzqQSvp+4uzPNgnw8dHHSppWsiXDZqqpORF8WIGGS71VaKQ?=
 =?us-ascii?Q?YMY7D+iKtILF8mLnOCByw7NNphEnG2Qpfge3yUZr3d+S6ST2MS/mbu+YwXJF?=
 =?us-ascii?Q?87I01iQ3IE3v7Dg46wknUYBytiR4RcvUgMOvrqFXADAC34M/g+DQ8uTYTzYX?=
 =?us-ascii?Q?UGULlnZdsOZRcpkVUr9Nev1CA50pKd6c/Z/zoeLjvea1YSHJ0FtvaWbGz4k8?=
 =?us-ascii?Q?s1kDvufd0DOch/hvOoVWfuOZsJm16l4r/OGA0/jf8T/QS+RUMafO/EYgg0Yg?=
 =?us-ascii?Q?U0LAJGy7ZBxaYvd53XOesjA+A4SOPwDzylPyk5laCMaJ5hpZ4tT785pUlK6W?=
 =?us-ascii?Q?qRQo+SSEFD5og5JQCNyW3lch7p8lx0O7POQhj40zSZCtrsW2I9diOTf6Cuca?=
 =?us-ascii?Q?yJlTUnvA/KgR9Mw9KfaxshqoPkFATigoRN3/mg3+JPuJl/7FdxhP0nOUu5cj?=
 =?us-ascii?Q?O7j855uE0xau0v7Rwm9gO8ZvNHtNTZwuroXb4Si67i/QMnCvLi8ZexexKser?=
 =?us-ascii?Q?xp3Dv9vfOcN95COa5JQUJTI5NOI6FuSd4Z8w+HTGm5x6ro2siWGJKo4Vpzi5?=
 =?us-ascii?Q?vMkPQHuRfeV8+RFU8UkO4EMC0M2rgtZrQff02OZ2Zi0xoXp9/UPE39x6lEKe?=
 =?us-ascii?Q?sWyqj6XkG+Lc+XE9TQ7bTExbeDWxgEVMc7Pc72W1LL0ffcHNRPuycaoPyXSR?=
 =?us-ascii?Q?kPn7cZtIxbASAk0IrRbbg0RR+XxB5qyRgcD5tbsz+26T0p4vXgh2dq7dzoka?=
 =?us-ascii?Q?jCXZVy1srQDyJ9hAcczUQnDO?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?eLjaqUhicbPBCimpFNU6yL1WcfjXGfRVa5veW6PiEfcMIicOPA/otVullvkD?=
 =?us-ascii?Q?aaWydoRuRW99S59+VCjGA/5898XAa0uVTq9UKFDZJQ3JbbuAv9WA9CQEdCqv?=
 =?us-ascii?Q?kZG/W9mM+dFgL0SpdOxGwWU0KnXaf21g4EY5rgGf2Yrqni3QjdJ4VGBsJF6D?=
 =?us-ascii?Q?8A909TuJ3EA4dgI2czdmE9UJhEqh+c9kGEDznsPw/BIp0pB7o3k5NsdWwcxK?=
 =?us-ascii?Q?eJrS/oZXdTBnSBbqzHD6VOoC79aFn0fN4wnjljJamspp6JrKO7U0Z6jnw409?=
 =?us-ascii?Q?QKFSshzXr9XT96s+fC1QZp2MAq93U9gQWorDuztMPox52bfutUYn6d1SACgz?=
 =?us-ascii?Q?RuH6JqOf1ZhVvdLa6sfoRwSzolGIRufU2c460KxaoOEbBtdH4vccl+ZbFXnr?=
 =?us-ascii?Q?l/mvcNpX+uICZlm4ZYbGSyr3XUt83AOlyRmjtPnjy3Y3H8zbLanSZUie0axa?=
 =?us-ascii?Q?ncCzfv6orLpOvcxbQ4e5h0iErA1blRn68nZ2qLt1qT1qnZKZgqgN8CxtN9PY?=
 =?us-ascii?Q?7V8iPx/2U83OB94IgpO7ZrgEbyF51mSGWgRmcw+QN8kU968HS99l8uTiUbQi?=
 =?us-ascii?Q?yLXUxbdYfTp0nI2/T1V29ySIg62zIlkpA/XS/SmizYowfSrxHH08hlhdyz0I?=
 =?us-ascii?Q?TW6+wIBdfsBzvwIXidRwqDElF7a5F1dTJMGwnl2YYY3mFlrDIyyRHzBQ07ME?=
 =?us-ascii?Q?Ps1bBFGx4x+B80dCRMO4m/Izt65wTL7ZOStBgrnMf4fIcwKtbdN6qX7im8+s?=
 =?us-ascii?Q?wZOh6agYkBgjjSwD/wWh76lilo5y4SgQ/0uSvmDsj00HhdtrRk4KSC1TxhRa?=
 =?us-ascii?Q?H9wgELmxfwjJbuqmRcxagMronTtIizzAlVvI6P7agXiAFOXznZDekVeYfR8c?=
 =?us-ascii?Q?o5o1UrnF1shdGERGVjx2iYrPJenD7A8VDr/vLMhQGIuTIsbQROQJJVC1Qkka?=
 =?us-ascii?Q?qAmQGO+oLD/aub90IcxIjn7rhQ5XoRpEuirMi0qcwl2GXy49hGHQKqYbkRej?=
 =?us-ascii?Q?KaGQVCVeHaX31882t5RK+8xr01TL/+dcbO/ypnqZ9c3Cac7v7MCM/73Ud2pO?=
 =?us-ascii?Q?3IHyVRIJQ4mk8gRNm4o57zZFYVNSmolw4uPJHyPOq7eC3fztBPEP0p2kD+yV?=
 =?us-ascii?Q?eeG13Iq01/O/oYdCtGlI0+WBo/FWvs6jjsTHHSyKpGKr7uqGP0huCpN7/+zt?=
 =?us-ascii?Q?UVzKyJO2aaPaU0hoqdLy/gEaJzdbMrvqFR3qIGiCBAuKNR4N3H0xS4CaXqW3?=
 =?us-ascii?Q?7Mwl+vHYzHL07tQ3YvFKyRvDDUIXu3HKpEbVKA6sB8pBdrjI4ldkLPn54heA?=
 =?us-ascii?Q?/5oMlY+KC9YipBuRunLQC4iE4nCxi5ju/y+QT+MbiJ35gnPFj41W49g3oaJb?=
 =?us-ascii?Q?JDBUamyDD+ymQ8d95rMSo/AmUQEF7U1gDihF/Nhnk3x3/Z0zSnzfBYAZJmt6?=
 =?us-ascii?Q?PhGpodRZ4b0o66PN/p0Fbtnx+v9c7Ke8viqGlXf9Yuge4/wSIFzhiKSjbizv?=
 =?us-ascii?Q?sGOVNj9k0qoAP6RnmpY5QU9V5+68zlRxJZDiBoIGqSM8mVSrbJVerqVkTbCu?=
 =?us-ascii?Q?gOjBaqSt05GZNE1m5WmEzcVEMqTvQ+OrLpWo/oTf?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55749c2a-7cf5-46bb-79e6-08dcfe6b3053
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2024 13:59:10.7295
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OHLqDC7honkF+k9VXLyEaeziXzNl4yXHcy/CnOjclRCSo/uMtB7NfZCvOi4yIjl2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7864

On Tue, Nov 05, 2024 at 04:29:04PM -0700, Alex Williamson wrote:
> > @@ -1,7 +1,7 @@
> >  # SPDX-License-Identifier: GPL-2.0-only
> >  config VIRTIO_VFIO_PCI
> >          tristate "VFIO support for VIRTIO NET PCI devices"
> > -        depends on VIRTIO_PCI && VIRTIO_PCI_ADMIN_LEGACY
> > +        depends on VIRTIO_PCI
> >          select VFIO_PCI_CORE
> >          help
> >            This provides support for exposing VIRTIO NET VF devices which support
> > @@ -11,5 +11,7 @@ config VIRTIO_VFIO_PCI
> >            As of that this driver emulates I/O BAR in software to let a VF be
> >            seen as a transitional device by its users and let it work with
> >            a legacy driver.
> > +          In addition, it provides migration support for VIRTIO NET VF devices
> > +          using the VFIO framework.
> 
> The first half of this now describes something that may or may not be
> enabled by this config option and the additional help text for
> migration is vague enough relative to PF requirements to get user
> reports that the driver doesn't work as intended.

Yes, I think the help should be clearer

> For the former, maybe we still want a separate config item that's
> optionally enabled if VIRTIO_VFIO_PCI && VFIO_PCI_ADMIN_LEGACY.

If we are going to add a bunch of  #ifdefs/etc for ADMIN_LEGACY we
may as well just use VIRTIO_PCI_ADMIN_LEGACY directly and not
introduce another kconfig for it?

Is there any reason to compile out the migration support for virtio?
No other drivers were doing this?

kconfig combinations are painful, it woudl be nice to not make too
many..

Jason

