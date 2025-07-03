Return-Path: <kvm+bounces-51486-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C1FEAF756F
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 15:24:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7A33D4E5E82
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 13:23:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD09117A2E2;
	Thu,  3 Jul 2025 13:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="LjsWmbvh"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2045.outbound.protection.outlook.com [40.107.102.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 210014A1E
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 13:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751549043; cv=fail; b=ekRiBV7KbEK8qIuYpqmp/EAOohB++TOQ0ehzeLZHnwrE3AyEud7mJDZC6f2w+bFC69xKGz412Y2q2Mbo1ZUF8qVCLv5i/ph7wzCAMLEqY2vsObznRQqlb78yhjWP3q+KyEOoT4NVW5QUJvxZeRHKQ7FbFGtylSUDPPLV8E9vFSI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751549043; c=relaxed/simple;
	bh=/Xb4duIoOkYmrA+pk6iaZktHp69VuLxRwn3DLkQebR8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=nlSfZIg/+u5NNuCm3BPXPkssjRzPCiDSs6izPQgGdVzy/pYv9k9q6be4otcVRIGh8FXa7fam7QbxZK7WbaNKAYy4Oisi7Wo9ukP59w436wx7crAd0X1Tv2Ry3xGDYzQVBaZ9joP5KLPboDSRvpCJyx5gdNgM7ZxY/RUPRPRqjNY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=LjsWmbvh; arc=fail smtp.client-ip=40.107.102.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fSK/x4XMyNx78VJGvwK9DnMeZyx9yeCDRe6GaYKtHo0NkAqChMguvpg+doCBAj/punRrTuOJvP8dmg7s4fdVcSq2phXXRm5XGqdPzbN4bwatixsEP5tITeLB+RPf0yg2eva9LjmASU+q50K8moqhQ3A26S5IwjSUWxcQjg7W/8uJTwU/la4taufvJ0e8JJrBpGQ6KPs1/Tr0rA+kReGcHGb7hMFwt9YwBc8eogBAIbdkdxSnvQ+F+NrpjuhXClncJgJ9J1Njfkaz1sNHAhcZGwuGVniLPzfOwh2/VlbYOLNuQfrjTSNhQI8FtTLhcalz+QZnzL4h2C0DQbAzNeLG4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F4MKJf8ciZb2jYU0ueiOTCaZLLY6Nt1mhA4XHf43HDg=;
 b=q+EsMYJSxZjvjt6HUbVs7soIf7rNNXkv6kXZiU5NCL3E4bJzSkI/tLhGSQmJxqILVIf5pOA4DoFpZJmNUiut6JiKliwvV+UAQGdFnQaZ33Yt5NFH7gn/77+dBDq5rJMJ9lTzoFX9oIEtRCBY57LpO7yyxXxEZmAH0+9aOsdQ1JhqFFfRxSgUWItNzVwEL1aXMI9RY6dLmYwZQm88deT5PjH/cEY9GixjmYJdu84eYVwrujH7mgF05lqvG9hL3z4iLpI1M3K8yz9XmH8GpNKa6dttSNu8MMILuoV4BenQ+d78PNxzAMQ4LWuE+jC7T2cK3jCQl8wlx4+vDqpfrNp4/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F4MKJf8ciZb2jYU0ueiOTCaZLLY6Nt1mhA4XHf43HDg=;
 b=LjsWmbvhsZSlIFsSUGFfxf5kcKAx6rjjePu0ZnBFSK+vVa5RJvObS98uwUReqSaHIUwc6Ol8SqM/eeOtNDC1FWrCSYltjjfzvMcCKljwRaJnvS/xlrFeR+4g15J3ePi92GcHx0eaRJmCY6q5YSzEO2v78AvJrzOmkw8/oCxEZJ5gY+VADMjdBlLghjlKFDY54MaUJmy0HDe3G/I/Bi51stuXf6GxJfe3jlByIHzWHsZgXucOgD5iUbHSpCa2s5OXVrtBEfYKlHWZoFM/6SOQGa68atYzPKoHIoITlBvVy0VgTwmNXy1xLPytsqAF2PC4Py0/Kr01HEd6l3P0o/D5bQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DS0PR12MB9345.namprd12.prod.outlook.com (2603:10b6:8:1a9::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.19; Thu, 3 Jul
 2025 13:23:54 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8880.030; Thu, 3 Jul 2025
 13:23:53 +0000
Date: Thu, 3 Jul 2025 10:23:50 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"aaronlewis@google.com" <aaronlewis@google.com>,
	"bhelgaas@google.com" <bhelgaas@google.com>,
	"dmatlack@google.com" <dmatlack@google.com>,
	"vipinsh@google.com" <vipinsh@google.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"jrhilke@google.com" <jrhilke@google.com>
Subject: Re: [PATCH] vfio/pci: Separate SR-IOV VF dev_set
Message-ID: <20250703132350.GC1209783@nvidia.com>
References: <20250626225623.1180952-1-alex.williamson@redhat.com>
 <20250702160031.GB1139770@nvidia.com>
 <20250702115032.243d194a.alex.williamson@redhat.com>
 <20250702175556.GC1139770@nvidia.com>
 <BN9PR11MB52760707F9A737186D818D1F8C43A@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB52760707F9A737186D818D1F8C43A@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: SA0PR11CA0060.namprd11.prod.outlook.com
 (2603:10b6:806:d0::35) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DS0PR12MB9345:EE_
X-MS-Office365-Filtering-Correlation-Id: d210b525-2e21-4835-da86-08ddba34daab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?V2S7zIgrBb59hgj/Ayd3Q5OepafSneToac1L2Uz6kzaWP/2p2BffFPGkjHZn?=
 =?us-ascii?Q?jb8N5faXqy6DjJ+GtCUiCaKVIvpeYMrRdpg2qz2tYkMPkBhAaYlBS2WWdG2s?=
 =?us-ascii?Q?g/d5OuhVnCCLX5cf2ZxkBa2LrggMc0O4NsE75Oo2IbdioUgPcHqcHgDMeewt?=
 =?us-ascii?Q?9RuuKAFkK3YFwcDZrxBj6CTMnYa7ROSDDuAgDhSAyXAeTXyC30o8ku+svKmb?=
 =?us-ascii?Q?IV3IXwNJOtdxA4D1KxkiXQItG3QQXzAEPm8YE7zrX9o7hRLzVo2/4E9bcCvP?=
 =?us-ascii?Q?BTLwbrws5fqcMS8uPo/b9Z8amdSuDF7aMNKYNZYJsKEd2rmuKRUeq549VNaa?=
 =?us-ascii?Q?eYNe4SPa6eMS+L1z8KzMSq9+x34zSUI/a25vilsCQ4HRNmv666KZ2q8ze77w?=
 =?us-ascii?Q?uR1bC4I7+0IF4ScuZuD//6sqJsjKQqcC6diVTIhByI1vG5EY4XGngTLJ6jLO?=
 =?us-ascii?Q?X0bIBmvjlnPp/pFuRsmidtaIjpg29fmdvD0mhXpZg0L3MZr4GCfE+1js6JLS?=
 =?us-ascii?Q?1N0ESq1uEUusNPWdFqHIddPsUy2+NUe3oU66+IsF3iSZJI1dNAuxC+RQHSDy?=
 =?us-ascii?Q?0eP5uuz8b9QV78q/bUJW6xcg8KHdj4tfDjdDqPNArSNzcTI9FzA3dXvUJQTu?=
 =?us-ascii?Q?WPUc8uXJHj/CpdBILTVxAyHE/kl+ZPRz2pDvVkhRZpyRiKrobk/gq1WbuouY?=
 =?us-ascii?Q?xxVb2x3SMD+Jcv73yPNTeHjYExLfqOkhbhsOf38EzDoNfVjXN1QwWxLGpjG9?=
 =?us-ascii?Q?vhU+Xb3CuMPpkCDz+xZWFrU5aIvygL7sVpHUnhpNU7oFdNDLsAvR9y4EoirH?=
 =?us-ascii?Q?SoAHrgh7ndqhd8JlsQYjcELDKIUK6Y37eR/gQmRSD7kpEYBvIr/AyuRRbj9V?=
 =?us-ascii?Q?1/qHZz+g9Gi+uUBusnXS//L0IZqURrtLSMJs9PNFM6auLbqsV+d1nFLIQgEi?=
 =?us-ascii?Q?UwT+5Aqg3tK7vF3G7w6kf2bohjAgEdKy7qwgZsFDtSdPvkjEnqyiKG5FBZSu?=
 =?us-ascii?Q?EHvpZ+R675PDWPJtxiBofisR0BUwOAQ/eVQYWE8yqqxPT0+R/sOD5FfGJeew?=
 =?us-ascii?Q?K/YGdL+nWU20vhF2r6FABLlc0rWVtnKYKkB1HQUcTF4qig7CUOkZbyrnmOe9?=
 =?us-ascii?Q?HNtXV3SUqn89HVKcC3qVqDFTozXCYSuxAHH/OUOkiVBtDO0CarGmEHz+qTp2?=
 =?us-ascii?Q?bB8AoW0Ie0NphGdMhEBevCrXzZ3194B6oNHhEbZaQm/boetIMkXPcDj+6MAY?=
 =?us-ascii?Q?uA1N38JHRxMRUsaLY8S5GkXgFseWl0SpJiXwh31QVRYU5mBhML9WWmeHum9C?=
 =?us-ascii?Q?tzIBkEv+hqWAPtqvD/cPLGvPuexcxOBjPA4rxyx9xo9KOEpKhQebnXpfEDDy?=
 =?us-ascii?Q?OMjk4WEouIFnxFQh2td5VPIvLHJ0ge0VZ7gXr9J145n3KjA90QHGTMEXI49n?=
 =?us-ascii?Q?HnR8KnxbeJI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?sMkD3SKnkQP9CxyrfqfvRiiBopWUJZH/XtwxwlXAgQZiy3qcy39e6LvofQ12?=
 =?us-ascii?Q?BGfgS1seAJ/BHXV8pkGvTBhgkdeFYi0544na/5pjk36XtfK1cqZp6WkGw2ig?=
 =?us-ascii?Q?cvK5F3DCQhUDrONwk6cFVH8Q9nagJsjnMiOu8LTOoRcUu55i37qYaMOD847C?=
 =?us-ascii?Q?sRQhiuPVoEtBb0V4sGSwFJ6hDdoQvrXCSb8kTvE4ktzfRwtK/NCR+ByBHCqg?=
 =?us-ascii?Q?MlAfuJdHv0UxjFMSASUtpqRu1AGZdS7aK+dfQF32Po1obuPA4Hh3VchawYUs?=
 =?us-ascii?Q?5XuE2dyiTbPUlXxoFhTj5NNKZST4NlBBk/TmdCNfWuglfoIgiTYR1yiFwIQj?=
 =?us-ascii?Q?5l9Cwbr4GCiWHfAmeapzV9m0WwQT7bjdZCoNzuxozw1plfsZ46XoEsDaEpql?=
 =?us-ascii?Q?L0cjttlgU+NRGLVlVsoRI6+RK46BHOgR3P3UjHUPP5LYElpIsiUzNK4ER61s?=
 =?us-ascii?Q?uRl+vgMF7Ouh3g6ap3sT4xSneS0H87GYAFVXpgqsYYUnopwf1dgnkuZqOZMn?=
 =?us-ascii?Q?8qSCQ50rw75FobZjkVmDaCKe9RIOiV2wBPb6SiaxxhEr74CPRKCw3suwy6Lr?=
 =?us-ascii?Q?GGSruCdQU8br4e5/SkqwW0aqHsRr543dWOAxDlB+wMS5bUGIPODpDjed/YJW?=
 =?us-ascii?Q?Qphhxb5srbnnRhvdEsVnEnECLe2Th6w3k9ouSZKf13UjAJZTm0H5Aa6RKSYZ?=
 =?us-ascii?Q?r6+FjO77ElqbOYMlls3oZEGKohglNGSN3G9GH4YemnGDkyY/FDJKPOYwwc2p?=
 =?us-ascii?Q?HjVGBuAoGT+GiF6Wn8NhxzN7OF/iKC7r8XXPlWaP2mwR9CBjUiFcchMPx/ld?=
 =?us-ascii?Q?sBJaksTQDjNTC05lMiKHlfJkPAdppcqld7IzI9tUt44ScnJwgV/rCBO+gNLe?=
 =?us-ascii?Q?82Sz5Y7tCzfsKjQk6WNcIRe+LAB+IEv8xVvOOAhPEz7TSEmT+e6mFCmqGWzE?=
 =?us-ascii?Q?Dv3VKgKFW7HOQqntqOypfH/HcbOrdYvoTMXvbbSr4xHVpQDJ/pDMqbQ3q2M5?=
 =?us-ascii?Q?G/+ohg/n254vQkpuS0brFlNU31V0Kb9Wh6L13Q5Oyv3CJBFYMULzYlzu4CJP?=
 =?us-ascii?Q?c1bhPgIjCGFTKHT8WhIz7dV/ftWM9KyAHQB0hIDaIMo9a+Vng6jHlPGpvChy?=
 =?us-ascii?Q?AHHhDzoV+ixp5ohstDZwNcPYoNHtlBZSxFT2MIxQZSAHqyt0CWBU4P/zVCr6?=
 =?us-ascii?Q?hbR2G8qOwMf74FT/q2Amf/owixKs6SmT2K9EvMQxuSSDIolfyth4oc4bSUp8?=
 =?us-ascii?Q?ZiWlUWvU46DaTgszPoRWLZcpQ4f44w4Ys93AESa16xh+/o/7WzQoilrZTl7+?=
 =?us-ascii?Q?stp7e8SOiiMJVowE8ATs1G4eNzMQ1ikPYVqV7BQWlUt69uyU3oBi4dqIsHM1?=
 =?us-ascii?Q?tJkVt+2mGMtjAoQi7uTbMxSE+tkwc8vDW9yHryYCvWyrEciXGFBbpWRtu17U?=
 =?us-ascii?Q?2ul/4YHA4XnjhEhaXTnR5gqfSCrOgA4HAlk6ArKHJw7CCjjOk2jok51uhNJy?=
 =?us-ascii?Q?WJZe5ATICRUicgsIDjzx56VAlEXyu3dU0wuvc7SiOlFr4D319DPCB/UDFlGn?=
 =?us-ascii?Q?Ej9qYMoGnlQlWwqYyObM8RHIn4kxOq5zEClwMOzR?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d210b525-2e21-4835-da86-08ddba34daab
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2025 13:23:53.0161
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zKWYIYxDJtLOS6RtlTimdhr9ZPUUs0ox1AkL9XNXlim/KFCpphbUVcSCl4rfNEo1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9345

On Thu, Jul 03, 2025 at 06:10:19AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Thursday, July 3, 2025 1:56 AM
> > 
> > On Wed, Jul 02, 2025 at 11:50:32AM -0600, Alex Williamson wrote:
> > > I haven't tried it, but it may be possible to trigger a hot reset
> > > on a user owned PF while there are open VFs.  If that is possible, I
> > > wonder if it isn't just a userspace problem though, it doesn't seem
> > > there's anything fundamentally wrong with it from a vfio perspective.
> > > The vf-token already indicates at the kernel level that there is
> > > collaboration between PF and VF userspace drivers.
> > 
> > I think it will disable SRIOV and that will leave something of a
> > mess. Arguably we should be blocking resets that disable SRIOV inside
> > vfio?
> > 
> 
> Is there any reset which doesn't disable SRIOV? According to PCIe
> spec both conventional reset and FLR targeting a PF clears the
> VF enable bit.

This is my understanding, I think there might be a little hole here in
the vfio SRIOV support?

Jason

