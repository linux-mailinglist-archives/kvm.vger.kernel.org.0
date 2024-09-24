Return-Path: <kvm+bounces-27393-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BF310984F1B
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 01:47:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E218B1C22E68
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2024 23:47:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 941BA17A932;
	Tue, 24 Sep 2024 23:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="G1uR5xHo"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2085.outbound.protection.outlook.com [40.107.102.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB33217557
	for <kvm@vger.kernel.org>; Tue, 24 Sep 2024 23:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727221663; cv=fail; b=C3pusNI8Gsix0xnqI55iAQrF5o0ymCt8tdaUaw6iaqJeJiqTg2h3oi/mjRQVx2W51id4Kdmz2ApFNw0CASPh0deZS3dY4pXrn7hFPVOoKno7epeR1/R/t7q6DJH53YCJFO1JyzP71nAePgsp7zRm/KUXqvdjIwSm+RW91GjPofU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727221663; c=relaxed/simple;
	bh=gSqL7AVyu5o/fmL1afVW9UtSc9xosApcT8JOGA9Qc68=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=GoeyaeST1srREs2Z/+oH+9Tbzu/TNLHMIAZzZNCjhH9eZf+JXnPaLI0j31jU9BFRb6tHoHgbbnhrTliQlR+YsRxzIu1KqpMglUZU2soD/NrJ5F2gl+mZIsi8qcOHAW9eWrpzHfDoTQXbQImfhzK53dSuI/MSJh8Q4Y6XcQCxQ28=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=G1uR5xHo; arc=fail smtp.client-ip=40.107.102.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NWEsdTZSCMCh/lHfE8SoesnUTWwgGXJHUv9zF/r3oMX0f4L54C5M3BiEdPP6ojPBaBNic4MFXfVpFOmH1UKrfLkznV7LxA9ztqik/vwwIxhkXR2o3OXO8TSTD6FIeVQF3zwTiPtOMcCpGuJiLz3xGNQdsJeqTR+gWqpS2TLh9AFoNWSNYK5vPLNoWFSBYAmIuoPwDv2yBXb6E/gWF9j95t9rPrp1g52iFZpxxcOMJN8gOmDwyS4E413bwmNOYHqepORkKd8632iHESy9zAq8/AMLVCRDDxC9MugRNrXdo653bSX5NsW08GUizzyTY1HTspj0QIDVqXniE6Ge/NXrEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=roTRf9pL3AfnwfH3cFCuaNqmbK+TR2DmcUXosdXdsrQ=;
 b=D9ZtTFZiVddk4oDdxj0KjFGYscLU3QvrKjlB77KJkjZSObRhQvAo/hBwbNkpiDZvfLMSpUpjC2yNxmiAL1hIBCfk2gfwfOmdGlZOoSPWBHQt8QmYEG/DZ69lGbTrjQHwD+B3t/v+4Kg9Sct/O9VitzsqzEwkW8yiFS538aDnhmBWeP/oN40SJpbsnz6uQpAQhlYBhtGfLQo0nT3iHyN8Pvi1ho20KvNlfZJJeMv9OpXAoI/Fb3MkAOYkbPUMiH8gsWKX/2FhQzVA5ZXwHsPgBdrWXhXcQlNTLZef9lmX9Wp2fGgDdKTYgkuYaNyoficMIhwtgEQ7eVufLrsbQ1hYVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=roTRf9pL3AfnwfH3cFCuaNqmbK+TR2DmcUXosdXdsrQ=;
 b=G1uR5xHo1cD9g2EhLvGbnMB/K3yT8AZtLTH4XMCHV5m+Xm6o9O2bEc9VYdXJMg7t0TpTbeKmQ5xa1B38srwN1qjTrfllBmdtZTCWywz2nZ/PmB69iRHpq6vpl/u6FcR1/l2aaPHnzPwlURfrdNhEjXtVdk7lCwya8t2U+6KeiqNJ0r3ejRMxS7qlVzPfT23iwvwnl7xvYGkaWKpHTbsdHXdZGOGRhQ8UN4cc8X0ukCTxRe4whJq2+gvoIZ4Zxxp8O2yuO51caX23mcpSq0kdzZqcRx5wkSkwndsTKQSCKD/JF4ndp6TjU/N3PGuqm8iuyp6oLvTETeMuTe8PNuDuoA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by CH3PR12MB8726.namprd12.prod.outlook.com (2603:10b6:610:17b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.27; Tue, 24 Sep
 2024 23:47:39 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.7982.022; Tue, 24 Sep 2024
 23:47:38 +0000
Date: Tue, 24 Sep 2024 20:47:37 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Dave Airlie <airlied@gmail.com>
Cc: Danilo Krummrich <dakr@kernel.org>, Zhi Wang <zhiw@nvidia.com>,
	kvm@vger.kernel.org, nouveau@lists.freedesktop.org,
	alex.williamson@redhat.com, kevin.tian@intel.com, daniel@ffwll.ch,
	acurrid@nvidia.com, cjia@nvidia.com, smitra@nvidia.com,
	ankita@nvidia.com, aniketa@nvidia.com, kwankhede@nvidia.com,
	targupta@nvidia.com, zhiwang@kernel.org
Subject: Re: [RFC 00/29] Introduce NVIDIA GPU Virtualization (vGPU) Support
Message-ID: <20240924234737.GO9417@nvidia.com>
References: <20240922124951.1946072-1-zhiw@nvidia.com>
 <ZvErg51xH32b8iW6@pollux>
 <20240923150140.GB9417@nvidia.com>
 <ZvHwzzp2F71W8TAs@pollux.localdomain>
 <20240924164151.GJ9417@nvidia.com>
 <ZvMZisyZFO888N0E@cassiopeiae>
 <CAPM=9twKGFV8SA165QufaGUev0tnuHABAi0TMvDQSfa7PJfZaQ@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPM=9twKGFV8SA165QufaGUev0tnuHABAi0TMvDQSfa7PJfZaQ@mail.gmail.com>
X-ClientProxiedBy: BN9PR03CA0700.namprd03.prod.outlook.com
 (2603:10b6:408:ef::15) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|CH3PR12MB8726:EE_
X-MS-Office365-Filtering-Correlation-Id: 7ce9d5d8-9489-4cff-3fbf-08dcdcf345c9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Ay3VCJWKz6loBnM5VS0F5aYL+SSu/ZW0Q0M8F0XIRkElfmStAoyog9gIKSt+?=
 =?us-ascii?Q?mJ1FqlwRxX78QZh7fSXWfnQq+BMxx3VX6ia4VSucvDz6nMfHaXxcDt9u1IHR?=
 =?us-ascii?Q?df28N6UAb4KOqhtxyL1VCJ6TsxFSSwC4GtRJb+Y0A8DWPBFUPUVvLqGiZhtF?=
 =?us-ascii?Q?qyamweQ9GA6rHCqDYGfHOFHtmO6jFmVHZYaCBptA8OTyC7dsaCJPc4uMo7+V?=
 =?us-ascii?Q?+pj554VyWkWG33pnpbJlGM5qf68by3BP3XWN+5ZAvLeC/2p1a4IMYR8MQ+fs?=
 =?us-ascii?Q?4ur2LNd+cjYorA/LMxYI9q7SaLGKeHYt9T5rHMVzETLiABkh7nE+TgI1fW6X?=
 =?us-ascii?Q?4qZ4Rz/IAg2oYygvztAhcnBRyW/rZGOE5yOE9a+p47wj8sszFX3syd5/JJ1A?=
 =?us-ascii?Q?ziRoqx7lcPKmxtZyvMMtyE6HoKgbSqJPsqkuT94gsmGZ1pPBBQEJk11WMLOF?=
 =?us-ascii?Q?ECEnHoAXdn8XA6KoiNPrLb1+mRFmMjlRPTv1ydHy6qrBaXV/ljUL0FESMXld?=
 =?us-ascii?Q?yS567Nc8qBToYo2b6lbfAJSlMPEGc7/KuOXxjHB3eXDDlb/L3WrrgA5jnNJb?=
 =?us-ascii?Q?8sa/1ElK2Thz2BrCp5Pj6R/B1OR1+75sRYrH1ZlQjX1XsCaQTPneuwRmdXsV?=
 =?us-ascii?Q?MIh6cbSW+spS7EtJUeiN+WX8bdIPhYqmeWkUX5/RK8tfh0+wBWHpoKZHKQVb?=
 =?us-ascii?Q?Hrd2Ce/p6BfG2CAt9jD77O3BcMtP6tKSa5K0RgZL7uU8oUeRi4ADj70/KJ7r?=
 =?us-ascii?Q?0TrgS728MR8PMe6RAZppM0NlC4470UmshottIiC+2pWyy8Js5hmdvJOPCXAY?=
 =?us-ascii?Q?E/kJgvwcnRfod9HgG2Dg3uNeH2dwVRlVesmOsO0q7YMXeX62BFxYr6PtQlcE?=
 =?us-ascii?Q?rhK2Wy0VtlE0z7OptFdzAxls+JxSdASWTyTvGkorCIYut1P3dEuq9hctSuBs?=
 =?us-ascii?Q?ljyWsEkXJ9LluDIokiO8zUR1cP8+u/UYqZMMNTio/b/PDysPAuDsHCdSXmbN?=
 =?us-ascii?Q?a+x/VJC2mVSlwVie/+72g1++JbQ8vl9CCpsXQLi/eQ1SbglnBsj1F8NpFw0I?=
 =?us-ascii?Q?1ceOif5kR0muAndRijRsdA8TSeSY2rmoDjp0WOaoTYqkPM/aMKbA2PcdL72b?=
 =?us-ascii?Q?QBQNSrPE3WvqBGnWsaPZqhpe4idOzq1dFLeL4KiqGAUS2MHbfn2AZkxuxDdK?=
 =?us-ascii?Q?vIwj8HFAgefbuPJ9rwySN4KW908uPixNsP07QHeAZt68LdTUZBsHrBlzXo0p?=
 =?us-ascii?Q?1iym3ybMqR9u3J1pW9NaIWbgOH86QhFpSvSJaXzL30IkLiJR7fU4Vn6ijFM6?=
 =?us-ascii?Q?UUtT1g2D+1wEfC/hh8xTiDRUHdNjjGKC4sdOcYoqk/f/HQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?bLj6pKMYSKvzCuVGLcgIm5KN0DJi9bag9A7h/5L4Cbzn3ML8h6sVLGpXLUnl?=
 =?us-ascii?Q?WfZm9zmANh+qSVGsrUikpnn8g2A3cEcyo4prJAg8JQY0ed8F8Xe3c0bXKOD0?=
 =?us-ascii?Q?HnUOtxceoaVTdUE+Q3WaZHOmQEHZBJkoB91vY9dUSRS1JcZAjmSwLkUcQjru?=
 =?us-ascii?Q?k3Iq/hi6sYbn3QTdlPkJWBjgjg+BL9IftH9ZUZWI+GeMQg5IjQMvSAzcsF3h?=
 =?us-ascii?Q?Jij8/ek9wzZICoMc0kku6Kx4PKH1kIKThDwWWNxxIrW6VYMXxtFkXMx6wY+B?=
 =?us-ascii?Q?weZz9OIPCVR59UxjyFoZ4Q6rCLzUXY5OYCqnH0Bet19laFAeB6U1a01rpwXy?=
 =?us-ascii?Q?0lg6rlNS08+TImolqDTRZMLfI3iYbLCwHuFxlSi9vaeQraPm1v3ssyTW4bR7?=
 =?us-ascii?Q?YWd857oOq/9SgjDrxVHJpi+iNoL+U8eoQWttEAKumYjrFU8D0R5B+eDyJkaP?=
 =?us-ascii?Q?JDTxN2P3HqZ0ewCtaLyV/lVmO7RNKpO8oijhRz9RJsQtaNLDN0W0ILjnihhV?=
 =?us-ascii?Q?aZO5Oi/JsnolW6xbCv6IEJa7/+G9/icOg2M/xCgEaf3+egD2C8Hr9rZz3tHk?=
 =?us-ascii?Q?meiRxhcxh9Ow+ESu+iPrW+d5cbrpP5HCK3TnVoTldlgSAXvYQ7GM2+k/RuXQ?=
 =?us-ascii?Q?arW6cMLchjO32pxmDoLCvk93Mi7QGqT0bgpXdF4vQ7IVWH2p1IPfe7dtG1Mn?=
 =?us-ascii?Q?+sRA704MFtb3WLiyL9bqbIybXayTf67NjK32gND/OiY7uTNojpzOEDs1zN9v?=
 =?us-ascii?Q?p8on2U19U79DhWqQFawW2VGLLHIoz8jm38cX/D2pTVLFmIdvOlFGXVtcKZtQ?=
 =?us-ascii?Q?nr1YIvnT22xdFBe3Yi9btXMSGBY+5R+OqhjUXdgbuJTz9VNTYFM77LyB/Wjv?=
 =?us-ascii?Q?WYMiDdMQ+BbW+fadRb5mUUI8ItxE2jZ4TJ26Jiyb8z/b7R4ojWPytxQmcSu/?=
 =?us-ascii?Q?eG1aDTaoWwPZ/sY2rTxtktC1ieGoAMkLxycGW5fTcTQDqn1EUy8Gt6bDGC4C?=
 =?us-ascii?Q?W+uZefmCQLL9mE8Z/oOxYcufEYVTrgIWh/ZtIia2596exT9cxgkk1L2hAqJD?=
 =?us-ascii?Q?fUeBHtjzGHz4mcohJ+2wq28TCTVXqzDvHJlyMWRTof8jWu0F64S8zhuU6Mkq?=
 =?us-ascii?Q?YiI0unS1kKUm0sVgC6rGtDFCYvfATN9bCiV89xZeAg1IdNhN3koNMJ/EnjO7?=
 =?us-ascii?Q?aAlYBlVD/E1XQurvZmYBhabhrzQxOm4QdJXRWJfCXTMfqzqK2fqwsttCQGIE?=
 =?us-ascii?Q?Kj/OYj2AWVoCoEIYiRzwpYw4Nn7dmkMhXcBxBC0SwqE7fDFRNHiDFByIQnEK?=
 =?us-ascii?Q?cLVGqNq643nMfMfne2YFKanazA3RLV+OCuggGsGT6Cs+f1iw0DK1q7snFFaW?=
 =?us-ascii?Q?vymEQ3s0dKdCvkM9W6Jx9VvQjG0wMVgou+rAKW4G2GEGvENlkFEafLcBTWVu?=
 =?us-ascii?Q?BTHeqyEBtRWQdPhtteAM/lwlYprBN8BP0n8ceQmsQusPhdA/0HmZkwr7lcW7?=
 =?us-ascii?Q?imDlI/MbYsXX5QqffDTxAfYEStIqC8eA94CJDfJrOB3OkCc8JHEvQFjhLirT?=
 =?us-ascii?Q?lf+Vk6WvQ+okEwJcXxU=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ce9d5d8-9489-4cff-3fbf-08dcdcf345c9
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2024 23:47:38.7186
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iqDowWktah6YWa0I6F2gTr2rxsDfuUbbB/2wYtbAXNmcLi8mtMty7KHOk5/WBtZ7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8726

On Wed, Sep 25, 2024 at 08:52:32AM +1000, Dave Airlie wrote:
> On Wed, 25 Sept 2024 at 05:57, Danilo Krummrich <dakr@kernel.org> wrote:
> >
> > On Tue, Sep 24, 2024 at 01:41:51PM -0300, Jason Gunthorpe wrote:
> > > On Tue, Sep 24, 2024 at 12:50:55AM +0200, Danilo Krummrich wrote:
> > >
> > > > > From the VFIO side I would like to see something like this merged in
> > > > > nearish future as it would bring a previously out of tree approach to
> > > > > be fully intree using our modern infrastructure. This is a big win for
> > > > > the VFIO world.
> > > > >
> > > > > As a commercial product this will be backported extensively to many
> > > > > old kernels and that is harder/impossible if it isn't exclusively in
> > > > > C. So, I think nova needs to co-exist in some way.
> > > >
> > > > We'll surely not support two drivers for the same thing in the long term,
> > > > neither does it make sense, nor is it sustainable.
> > >
> > > What is being done here is the normal correct kernel thing to
> > > do. Refactor the shared core code into a module and stick higher level
> > > stuff on top of it. Ideally Nova/Nouveau would exist as peers
> > > implementing DRM subsystem on this shared core infrastructure. We've
> > > done this sort of thing before in other places in the kernel. It has
> > > been proven to work well.
> >
> > So, that's where you have the wrong understanding of what we're
> > working on: You seem to think that Nova is just another DRM
> > subsystem layer on top of the NVKM parts (what you call the core
> > driver) of Nouveau.

Well, no, I am calling a core driver to be the very minimal parts that
are actually shared between vfio and drm. It should definitely not
include key parts you want to work on in rust, like the command
marshaling. 

I expect there is more work to do in order to make this kind of split,
but this is what I'm thinking/expecting.

> > But the whole point of Nova is to replace the NVKM parts of Nouveau, since
> > that's where the problems we want to solve reside in.
> 
> Just to re-emphasise for Jason who might not be as across this stuff,
> 
> NVKM replacement with rust is the main reason for the nova project,
> 100% the driving force for nova is the unstable NVIDIA firmware API.
> The ability to use rust proc-macros to hide the NVIDIA instability
> instead of trying to do it in C by either generators or abusing C
> macros (which I don't think are sufficient).

I would not include any of this in the very core most driver. My
thinking is informed by what we've done in RDMA, particularly mlx5
which has a pretty thin PCI driver and each of the drivers stacked on
top form their own command buffers directly. The PCI driver primarily
just does some device bootup, command execution and interrupts because
those are all shared by the subsystem drivers.

We have a lot of experiance now building these kinds of
multi-subsystem structures and this pattern works very well.

So, broadly, build your rust proc macros on the DRM Nova driver and
call a core function to submit a command buffer to the device and get
back a response.

VFIO will make it's command buffers with C and call the same core
function.

> I think the idea of a nova drm and nova core driver architecture is
> acceptable to most of us, but long term trying to main a nouveau based
> nvkm is definitely not acceptable due to the unstable firmware APIs.

? nova core, meaning nova rust, meaning vfio depends on rust, doesn't
seem acceptable ? We need to keep rust isolated to DRM for the
foreseeable future. Just need to find a separation that can do that.

Jason

