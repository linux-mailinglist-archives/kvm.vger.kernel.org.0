Return-Path: <kvm+bounces-29864-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C73479B3660
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 17:24:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3DE1DB21949
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 16:24:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5E711DE8B4;
	Mon, 28 Oct 2024 16:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="pTKqJt21"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2087.outbound.protection.outlook.com [40.107.236.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF82F1DE2BF
	for <kvm@vger.kernel.org>; Mon, 28 Oct 2024 16:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730132642; cv=fail; b=EY4bltv4dfPtzqqDwRqge4e7J+sSF+5b+FyvQgKQEKe1JN3Tep9HP9wl4rRFQxGc4vO8IgJoGsuiUw3O4DoqHMAPhKjHbRAqBoL4dy8xT8sLZp9c9ejJztchwNGuq6S8KEXfFm+MiUXWmpb8BTs2pnjjtMoSflNssY5eucswWcg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730132642; c=relaxed/simple;
	bh=PT7tmJYrnqunEjUsJtdXzWFJly8Orajtr+2GDtL00nE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ipjiztw3hpGubKqBO+vDNhjPneZ+3PWzklGddZgbFkoazxYFzi10EsCBd3YVGx++nNK7xJ0XMgS1LnMeKzttwJV+RzPwwFzmrhQJrMiD+74iEYSPyQ/0j95B90b2tgTo5JzJbBIgmwcAOvhTpJC/0qM/0Ids496rvT94SBuxdZg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=pTKqJt21; arc=fail smtp.client-ip=40.107.236.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sQYm7o5KraJtIHXZZEpHLyRqdEE6T+bbrs36lLBcDEKweoqbUfWaN2eXN5+1MYPxXsHqy0OPHdDKfeQmFfxeDDB8jbLKFskiaL9RPb4O5aQx78kE0z/NzwTkS1yBFUnbZnm/fPBFXYW2Mca54/XHMB42xHkEY2uBImBsFL4ySzjRkwNc1+VNbqnaYM60TG/2Lm2AQZhw+sU8SaExsTalDQX903e3rDyDdiFq5npbD26SJ0Q6EztXYL/2dtaeW3qkk28GN4zyKlQjZ8Tw14M3nbB+p9uk/FJD4z0WHJWiybqJ0LF32dFKQ5HK6fF/W6JEp4o5bKBtwfM+kUVl3N35pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lDXAb05QsSi3XX3t38UK7nFI0yBALXX+cXAoAiOYquI=;
 b=kwaHhYDBr5Y2sBV1xcBwrjnpfzOGvlO3PXOI9cbnN8JTLnU5ZMF8w1m8PK7FXMVX5uu77lsjZNr15BMu8J72U719ljRu9KMziLdk0g5cPUCprvGXUC+WFSRG3oXmtG8ChmZMT4cairVownvaWeF4snd+iM0dHDoFzgaYnDdDr8MYKASDir3+LR+ZvdlnA++8PBSehmZJTIIHNrVprWlFy5Z0KB2kSclKOdLfdEHXYwYwVSNXWTppdyxjhYXLNW+DgdzEV8BkIsMG7twdDuqY1pK3g8E3NXlmttPz6AF4oIeUFWQlg1sAKFDJhTXRICm1MO9XFEViscg6INRnGer+pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lDXAb05QsSi3XX3t38UK7nFI0yBALXX+cXAoAiOYquI=;
 b=pTKqJt21gpmhwXHvabqJRcLXBWgfmZNV6wGY4prU+yn+cdCfevaiyhj4mmcZ1AIXSGqQETMl2X6YTU22aFnCojFPj6AOZiD3N7MDLGdiCDCTK7gelOrN/0XfQ9q8G7mBjIUqbX9a7XLB//ZgMEujHfoAvEOUFT0dN3c3j7Oi5/Q+vqa0+fb9O1xNbRNyS9Q5PFOvWsVDrlVlTH0gLD1uW1kI0eynZVtZRbmvkUC8Olwe9q1A3P6Vg+SN9OT/+LllLy7BI96JPhoSlwOlWDZTDJLreMvlXOyxhVbadhrzhT4g3DSjB2b16xgRnHSmW5oUC4hvAxi012rAkM3myfJ1Hw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DS0PR12MB6632.namprd12.prod.outlook.com (2603:10b6:8:d0::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8093.24; Mon, 28 Oct 2024 16:23:56 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8093.018; Mon, 28 Oct 2024
 16:23:55 +0000
Date: Mon, 28 Oct 2024 13:23:54 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Yishai Hadas <yishaih@nvidia.com>, mst@redhat.com, jasowang@redhat.com,
	kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
	parav@nvidia.com, feliu@nvidia.com, kevin.tian@intel.com,
	joao.m.martins@oracle.com, leonro@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH vfio 0/7] Enhances the vfio-virtio driver to support live
 migration
Message-ID: <20241028162354.GS6956@nvidia.com>
References: <20241027100751.219214-1-yishaih@nvidia.com>
 <20241028101348.37727579.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241028101348.37727579.alex.williamson@redhat.com>
X-ClientProxiedBy: BL1P222CA0002.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::7) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DS0PR12MB6632:EE_
X-MS-Office365-Filtering-Correlation-Id: 216da413-6179-48a7-9319-08dcf76ceb52
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?fyJGtEzNYUJrVAibo7PdmfDAsY409xn8ylWS93Wa+A3oYWzv+zPCAIejK5EO?=
 =?us-ascii?Q?vm62d0Xhr4QmPSPovN3TZ06qTbjoPRBom6x9q0Q4g6mvEQFbqXEW/Nhvlfn3?=
 =?us-ascii?Q?Eg4WlQ5pXCy3HiqxoKpcQ/3kihSCQ3c+TupuS68kbgt51K/69YIjvpUl6etW?=
 =?us-ascii?Q?Kn6kQlhVz2wambj0leJ0xe6tTEWFSAq5Okl0mcPD7tFYVJvT8rcz8sl39lJt?=
 =?us-ascii?Q?MQv3/1OCxXI1p7RemUEvIkl5z5uEn0NdkzlwwgFvAfgsruYWRbaPHmOyc7Wh?=
 =?us-ascii?Q?zeRFoa/7DrLzRAA5t1Zuls4AdNQZo/soHsoKXl8Utwjn1sBWbdpDf6NL5lJJ?=
 =?us-ascii?Q?qTqjnvQsWzMdzNhwhG5B2PBfDFxPaRx+K6H1eIGhMjzgP+Y7i12lF4HgI3La?=
 =?us-ascii?Q?RxlQeYvoeAL/kQruCNdxW2z0hJIfKEFVtEE2UT+2F3aSpK1zHniJuADkgD0h?=
 =?us-ascii?Q?1b1iRUF6y5c6+6Y4nR4IzT2IbX0sddq7UfirLBwAqRv3Gth+HyVGO3J6RcXP?=
 =?us-ascii?Q?9pr02zNtc59mE04Z47JnFjyoyFrGu/tDDThyBV1Ez1h+MpF8foUH4uple07s?=
 =?us-ascii?Q?zE2bqflsWuacaN8w4CV9ASal9lA3JSjN/VJcEZwDF+gLVNgSPZiAHqfJucSm?=
 =?us-ascii?Q?+11qhtgFWjtRT6SWJBurvt0Ea/+23OMhgOj8vP49rrOtybkkYSWh8t/43f9k?=
 =?us-ascii?Q?iUhDgfsHl+u/tR9HOEXxxt7SLDNhx4yRSBSGOra11Vwb85G5hDPzyP4Ew+Jm?=
 =?us-ascii?Q?g1uNrbcWkcCGXAwm0bVzXWcou8KctwP5Fbv8ifZ5O4uBgtGMEBC45VKFVr7x?=
 =?us-ascii?Q?fLrDoDj0eECL1NRWgsLYHGXHemYlqoQTiFEP/lljsiXGCkTWJQK/zIyIuQNF?=
 =?us-ascii?Q?9xt8ut+NY9qHHmmTj+9sX9gvTaGwljlF/ZVAydw00o/CdJNp40E09by531TQ?=
 =?us-ascii?Q?Vmk9hfkkcKaGPnNqrW9+aYHMit/N9KgQqJaeN7DSl+wa8gDHpFfKw8qEZzOW?=
 =?us-ascii?Q?kB5qjYsawHXyj13+LjR6VaOjxLkr9S4Syyj8VQRCJ2++bq5ztWitnII/m07t?=
 =?us-ascii?Q?744AO7g1oDs7vvi/s95ZV6Q24amBqWTqrlC5xQHLO1x0WzYxktoB8RYJP47y?=
 =?us-ascii?Q?5GWf2kTVWejnV6EjX8CAu7DKVt+6wKv682vLTvh/fKlmAgvbvpxHygP386wj?=
 =?us-ascii?Q?4XOGz3+FZ3EIv9CZ/b4QhXNwMSLgNgpVBL+oTES7Ve4aelFlOAmvn3iLNjn2?=
 =?us-ascii?Q?VDFeFhrCkI6ceKciVaK/vs5xbD4dy9ZgyirtR/awR2d2Uncc0DhMF5KmotgC?=
 =?us-ascii?Q?JhblSM3YApsZGo8OqoQU4pOU?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?WpfEz1y20rJoh0s/M5wYLXIjMXVfGkgbJwE6kQPWD5w7DCVfukiJacqN5FxB?=
 =?us-ascii?Q?cujr4eBKQGf7ZnJwmc5sOF7N3xlcN5+X2qV9l0/ZwIMpjnGJnszIF9YMHapr?=
 =?us-ascii?Q?L2svuZ58bFYjYAsWSpPCmwqTwePkXPl+4z041nfBlucMzaZ0uaWZQFcuWkwg?=
 =?us-ascii?Q?bT6p2+KU0vUNA/9TKUKg2m9PX5gdQHt93f7Jlf3RKVgJkivT78DHShk8q/r6?=
 =?us-ascii?Q?jH9lNcvK1pnMM40DCkSEvGiAcY/fZRQaonQl4NlqY1GjGCFgrUTje4aBgCP1?=
 =?us-ascii?Q?pSTZ22YlzXwadaCQ7WxldabmFJbUI3vkYfJtYUdgQWFSDp7bnLIsopu97gRf?=
 =?us-ascii?Q?LMCw/UmRfopY4A9EigNrvSexsJ85xWoGRM4jmQoTWqysQwi9hh/R8cy19i2c?=
 =?us-ascii?Q?WfkT6vmTqhZ0WuS3YJ3pZToPJqioWYzrmmfqhs/xfK2UocJA/CAajaracTXJ?=
 =?us-ascii?Q?F8ite80OT9kPHgjHcWxLLufcrJQg7h6sPXPme4H//NK4BmYB8VXkxYY0sFqJ?=
 =?us-ascii?Q?woV4Rcbus2bvalN9Pc16Uu4DWdGBh4O0ONVZBkmqa1MQY3GJkAPMyNs2ONpF?=
 =?us-ascii?Q?cN/049sZWAYwJpABehEakKB48u1E/SmR/xeDCKrxd6AZE9Pilg8JtH1M/ykU?=
 =?us-ascii?Q?dQ+waL4UetcY6YoTwagbhzmqT5AfpZfC5aaAODQkW3BAfbIEV1MyW9Rb/Y90?=
 =?us-ascii?Q?AN1GaJJziuD1909yuQOsLIEQl8QIKcfifk3hRowd6rurDHdMwEG2Dbjb5EuQ?=
 =?us-ascii?Q?AkDqRG+VRE7fIWMNlZ6NLtPFoxHFNoueAP0ux9blBinD07k04H5L++8BYLf6?=
 =?us-ascii?Q?VJVvk+6OTOOEZx5RDyLaFEJEpE47+Hru3WB8FvF5sXCaLbnQFkvSRqShNHEv?=
 =?us-ascii?Q?i7b2UJLjo4EKlDFCY27tvbWNKJ5Nl4t5EF0Yt8/U0oDrpBYIkMpCqqLMzl5w?=
 =?us-ascii?Q?pUwX77mN5ls+/VUjhN4IR6eQf5n1k84odea58KFMcPEFlTMcxIQwxaZnHhO1?=
 =?us-ascii?Q?SOMEI4PBEJtA6KS8CfTxi4hkZ5dijlHJxz+d0d8C6knKsVwI7bbClecNS+wU?=
 =?us-ascii?Q?/LmT3w65l697s4hvW6crhGw2Pc5d/G3xKll1ugLR2TNjYy41m+wnA7v/GlD0?=
 =?us-ascii?Q?PQjqBG0thX8XR6GVWXTbymYDzmcsATXC/GCfvADMKEfHyGythFvtIgdEy1gL?=
 =?us-ascii?Q?Rk+fJXKs3Hv5mxCpE1HoJ8i/ll5SOtwrgdKBiCBaVZLcvgmPRjnfg/leHw3O?=
 =?us-ascii?Q?Jnr0fMRIHTP7aQU/jIaJQeoWTFybx+SDBEH9JSQZd60+TiYId75vwWb/92pS?=
 =?us-ascii?Q?2C6HaglWaX5/3nAe9PuPxxNatPKV4upxm1/6I34mEHtHQLIcGueQPlACUlab?=
 =?us-ascii?Q?OESAbyC1v6HCb4nRmJY6AFbU/zplns5tV8Lfi6mcDBIp45wlZ0apSRx9tYJw?=
 =?us-ascii?Q?wwPc+OXw3N2zgWTT1lh6jVsfBzCtwa7TbtmGNylR+EaIQNC5YvlEyOT4yq/i?=
 =?us-ascii?Q?vzO/+s9jXboKxUenPvcz4auhkOJ9LZic/ZX5KELImNkC+VnF4OvwJYKEgCf7?=
 =?us-ascii?Q?YFODA40ShDBJ8xAqKcvaE96jcgYM43+tK90lg7Mv?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 216da413-6179-48a7-9319-08dcf76ceb52
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2024 16:23:55.8242
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RhzPPy4vkVqVOSKDNBqJEgl4bDAVStmU3MgVpLrNRoOcZLHZs3fyYgZqlTzI5sws
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6632

On Mon, Oct 28, 2024 at 10:13:48AM -0600, Alex Williamson wrote:
> On Sun, 27 Oct 2024 12:07:44 +0200
> Yishai Hadas <yishaih@nvidia.com> wrote:
> > 
> > - According to the Virtio specification, a device has only two states:
> >   RUNNING and STOPPED. Consequently, certain VFIO transitions (e.g.,
> >   RUNNING_P2P->STOP, STOP->RUNNING_P2P) are treated as no-ops. When
> >   transitioning to RUNNING_P2P, the device state is set to STOP and
> >   remains STOPPED until it transitions back from RUNNING_P2P->RUNNING, at
> >   which point it resumes its RUNNING state.
> 
> Does this assume the virtio device is not a DMA target for another
> device?  If so, how can we make such an assumption?  Otherwise, what
> happens on a DMA write to the stopped virtio device?

I was told the virtio spec says that during VFIO STOP it only stops
doing outgoing DMA, it still must accept incoming operations.

It was a point of debate if the additional step (stop everything vs
stop outgoing only) was necessary and the virtio folks felt that stop
outgoing was good enough.

> If the virtio spec doesn't support partial contexts, what makes it
> beneficial here?  

It stil lets the receiver 'warm up', like allocating memory and
approximately sizing things.

> If it is beneficial, why is it beneficial to send initial data more than
> once?  

I guess because it is allowed to change and the benefit is highest
when the pre copy data closely matches the final data..

Rate limiting does seem better to me

Jason

