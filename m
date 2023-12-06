Return-Path: <kvm+bounces-3660-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B6FC80665C
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 05:43:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1428C1F21807
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 04:43:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E9AFCA64;
	Wed,  6 Dec 2023 04:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Wbouh+jz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D7BD1BC;
	Tue,  5 Dec 2023 20:43:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701837787; x=1733373787;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=7TjjfuIrDxHvq3J1LuDKkwzJWHZempJkLsUwdcaQSn8=;
  b=Wbouh+jzsCI405/kjjiEDQ5nXEIpPvqapvW6sxnJCnoB4SRWeoQ0Up0B
   QGj/Zi5pvliwfCXaCiix7+8cShZVWpRns3hVqlaqwG3YtTiW66ofH+uHe
   Vq0Nly+iVtkwTNVO0UEh0OY6xakIyr/V11NMuUXz4+V3kjqMSX+HY2jJB
   NLfOcufAEaeJDw9OpRpgLEy2WHVNahK7ECrNJ6tt2rhcyOssJRNZbXrij
   2gbHP4BnAm0lYmh/87B2H/erezC/QoVm3hmRwesPHudqYsO4CVudaNUj3
   utVr9R0Omry45bMyGH9EsOrosisHoOk4kaTOKnMlK7hZto+ZglFd0QGq6
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10915"; a="1099596"
X-IronPort-AV: E=Sophos;i="6.04,254,1695711600"; 
   d="scan'208";a="1099596"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2023 20:43:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10915"; a="1018449133"
X-IronPort-AV: E=Sophos;i="6.04,254,1695711600"; 
   d="scan'208";a="1018449133"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Dec 2023 20:43:06 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 5 Dec 2023 20:43:06 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 5 Dec 2023 20:43:06 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 5 Dec 2023 20:43:06 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.40) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 5 Dec 2023 20:43:05 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HrzLhluz+eCvaiC2vIadMqNnw0TTHz8aKNon4wzSr088cecGtnBxc8cGhH4dNBTWkXcAIq10JH19TUSnh9cdfcXkx25NXExxlbSbzsoTpNy20/Kzvs8DqkE3T86X8wN53Tz6UogZmMKaN53Jna9hevMf632nWTFOWMUVx788Ucw6Wn+lnXeUwTAnBSpoeENURxvgZDc6BRJU4wmJwg+U0ECDMXO4vvNUU8i4ZMH+09nWMr0lKAjrutt75+nwLhWamZvuPdzIZXjURStVIpl7agTDk2icbY54xktsWULIcQ3/aplEsv0fk1LVUae/1DzQSlpmF4Y/atlJkh1XP3V/gQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JtWYyjCJm1YqZ3/CgwUPLl2TR3yRSgXfXpO46vDoXyA=;
 b=kcmJqu4sj+HP3DWAXbKj+U1B/ZZeA4xExWweC79lfAVpWM7Pi6TKUE2HGX5BXwO34WwccwrO+UVAx7TpvYeOk+gm30c5ItLxhLhc9bWGSEjxtB+M9c7IJ8GfqQQO3yWXYg4xxkmxn1aa3dxedElV3Al27G1WIVEsOd7caLEozTyPFKJ5bVx3RR3W/smMFZC0FYoOxsZszOEY8fYXrmbXdtvz4JWk/lpgFLb+Qf01MwRDPt4BdFyIyhBjkEvt81dnkUoLMhJt5+MIhP0THGC/yILelj1umwhX4CMi6fq6URnymCOz/h9xh0VNWnjZP8TwIvYqQS4IJfS5N88lBFd5sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by MN6PR11MB8218.namprd11.prod.outlook.com (2603:10b6:208:47c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Wed, 6 Dec
 2023 04:43:03 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6362:763e:f84b:4169]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6362:763e:f84b:4169%5]) with mapi id 15.20.7068.025; Wed, 6 Dec 2023
 04:43:03 +0000
Date: Tue, 5 Dec 2023 20:43:00 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Samuel Ortiz <sameo@rivosinc.com>, Alexey Kardashevskiy <aik@amd.com>
CC: <linux-coco@lists.linux.dev>, <kvm@vger.kernel.org>,
	<linux-pci@vger.kernel.org>
Subject: Re: TDISP enablement
Message-ID: <656ffbd4e2a39_4568a294c5@dwillia2-xfh.jf.intel.com.notmuch>
References: <e05eafd8-04b3-4953-8bca-dc321c1a60b9@amd.com>
 <ZVG3fREeTQqvHLb/@vermeer>
 <58a60211-1edc-4238-b4a3-fe7faf3b6458@amd.com>
 <ZVI8Y8VICy/SwYy5@vermeer>
 <51bf9fed-2bad-4eb1-bbc7-239200bff668@amd.com>
 <ZVOTsEhQTYxOpxA8@vermeer>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZVOTsEhQTYxOpxA8@vermeer>
X-ClientProxiedBy: MW4PR04CA0388.namprd04.prod.outlook.com
 (2603:10b6:303:81::33) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|MN6PR11MB8218:EE_
X-MS-Office365-Filtering-Correlation-Id: 63f6dc9b-2800-42fc-6061-08dbf615d51e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cfYUefsIjEBc2+oVKU1bspR8NcPUYcnhOtJpY3OK+7+EPa8Xq5rQAhAaHIf65J1YerTEIaW1rpemrhe2LAEM6/8Iy3alzvosh3xqFLsGuAUy80ZARxkA5Gg9APcAllEuDqvFnT9EEzAVFo5uwF/B5J2ZcSrBFcE30oECnD5/uHjo40VrHEr356jZp5IzGJfJTOu4jNJk5QFhd7s+4Fg09XzvM6RAAhHwHdl1980KdKsbxCN/gWlRb7GAdSGiO8EDe6+ai9XlvGUPmmQoq6sfc+IHKymWSvhA4d19tOXGEV2Tf2ZSsZ0PxqSYclx6EUadW3Zst4GkLw9iHXtjbqz+oPwmErb/40HIMM6dQbe+IcoOTWi0JYlrMSGn+4UpWk9KFhm8EksySbT/1L9MBbJ/D9BLTMOrxibRjR6c6pCgPO5fuMA1Mozu2GvQc+vBXkDoaBeGMNSgYGegwHFUPv5JhkV4jyQepKuqO9dB+XWPVbhiAWg1gIsIoTg/h35D6ViLCDD40mfv9CqthwHUTVpYIJds5fiHBQ5jNV14EvtoKSXwD8mr36z6A9MjVp233mJ/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(376002)(136003)(346002)(366004)(39860400002)(230922051799003)(186009)(1800799012)(64100799003)(451199024)(66946007)(110136005)(66476007)(316002)(66556008)(478600001)(38100700002)(6486002)(5660300002)(41300700001)(2906002)(7116003)(86362001)(8936002)(4326008)(8676002)(83380400001)(26005)(3480700007)(82960400001)(9686003)(6512007)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?C/RfKV3D0rqN6u8RQ2yWWr0Q7BUjjx6grBIsh44zdvYIstUjt8oMl3NSv6kP?=
 =?us-ascii?Q?1DL9mbGibjTWP51QXqxoApYAn/a5qvCAIdBMfy6O3qROTIh3crDAmoN7gvDj?=
 =?us-ascii?Q?w9dblbBzZn7gKxuj3B2NwvBzzH+0PSx5TyjptWef61hTT4ZTk2HhUZNFRFpn?=
 =?us-ascii?Q?nmGzC77L5pH5rLKpoB6CPtHOsXiRfb/1dQP7oNKXBpGRcvBsgowPPQjMtfra?=
 =?us-ascii?Q?SolSTt6hm+Rb7PQ+XDLfV1eWSu9MEXtqhsow4+x37S2xfFUQYwu4f/f9NwuK?=
 =?us-ascii?Q?Kb9Wv9zqbKyCh+ExL1JpjWRh9cGfdfjfX0mV31j59ej5Ik9sLc1ua+Fctutl?=
 =?us-ascii?Q?2527CUhYDQJEdvFCH9DKqUsYrNUFT1b30jZLh9hpWrLj+kC0Ryi7ixtY/w9E?=
 =?us-ascii?Q?APzxH2lBN28+0NgoVPIdHdKByfSocN1gGpJLHRTl/6AKYKwDTcrXYQkuGR5U?=
 =?us-ascii?Q?YivqS8OTPb/0H4TBPqfIPMBQqo7GdXY2R4dmq2ZT4PYFAk0Dr0M7KkGzANUa?=
 =?us-ascii?Q?KEez64EZB6KElm8FLMEWz0Z1HB7gBf2OlzdriHF7lNAYrqmWAJQYMR9Uvzqq?=
 =?us-ascii?Q?pZSJ/zwX6HZ1IjrfGXrge0l1mSvW55TYhtVsaNdqsDWf3eUEvHIrQ3UCClXW?=
 =?us-ascii?Q?MJJQaLm/Ovfep0huc3fUSv94EVJXzyxNE6ylx9Eu5wTckgUavokTV7mF+bGE?=
 =?us-ascii?Q?KAasbiU+Z4OZ+c+tAn7Re0TUtvpL1/bv3R/e1kM+Z9lL7Hcjl1wrWXBgXIvl?=
 =?us-ascii?Q?1z65sO+yqCYIIxyflJeVFNjgfiwNyhMikNyFfOJ2jXUzp36iWjCouaELOqcU?=
 =?us-ascii?Q?yaIfYZrj5KTLwhclj6AMEUfLqs3gYHS3gFdOjSws9U6gtc6RqsbQB4ETCRSJ?=
 =?us-ascii?Q?Kdl0sjHaQRae5Q0KUrZKSPi+Lx9VfkwKbcYF0X61VG0/ZBR4eVAtsfbUmczW?=
 =?us-ascii?Q?7CjWfUABt0rgMGedITMEmVZEQ6+h4rHtGxMbBVMPVVW2Opy/2D6X8zglDPHb?=
 =?us-ascii?Q?SSmGo7OT5kUC1E3wKlLi17Eh1dgWidDFobFmZKF5uNUPMyBcB1jskPqtAwD0?=
 =?us-ascii?Q?QaG8T1UawjlQwK68OBLRCRSIAL+LoHy283evLlzz2pvH5yu9bKMXjLv7xi6N?=
 =?us-ascii?Q?0UCyMFJsI0BABnwasff51I85Hx3iTLeopeHoY7dkiJmy5GGN4vydG8OP+iW0?=
 =?us-ascii?Q?4URmcIbXff7jwaX9JZOpcuRWskdnEtvj3izsk3UAH65OeYMX+JkrxuJM0U6y?=
 =?us-ascii?Q?rLZsFAvD7SSPRJE10B60UnuJlIRBhS3JXJJsTvjTkOgCBMV08wkqD476RjQS?=
 =?us-ascii?Q?cGw7LaketXfDktxCCiyCWFdToWEyTbrY6yfqcwNW489Nent7noQjqD4C2wGT?=
 =?us-ascii?Q?bM8QeSPTGxVUChvHX46rkxS8TrgLIJht7ZLjCkVjD0TsfYsoLNB3DmZFIXFs?=
 =?us-ascii?Q?oawsu0VDbo9+VWGxG4WPq6LueugTT7vKyB2aEMJzAPD6mTcckJV7PwEpxpb1?=
 =?us-ascii?Q?c3KT04VPh74NLVD12jmqbmxXk0dD2BwlEkwM/N/8vnVu0oqN8X1hfIHGy/LU?=
 =?us-ascii?Q?Tz3WMfmivoaHdS8d7lqJXH2sSTiWqqwiGGuN3QJL+5H313b+dvbifQl5yTi6?=
 =?us-ascii?Q?PA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 63f6dc9b-2800-42fc-6061-08dbf615d51e
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2023 04:43:03.5538
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y3PHVzVVVyjMLf/99Do8z6qabQiuD0calh9yckmPxu9QZ9OwuqS8jmHwLWh2EpHxxAW47Tu285UMsOArKTHTC8D6Z0YwHZxT3QConE0FYW8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR11MB8218
X-OriginatorOrg: intel.com

Samuel Ortiz wrote:
[..]
> > There is always a driver which has to enable the device and tell it where it
> > can DMA to/from anyway so the RUN state does not really let the device start
> > doing things once it is moved to RUN 
> 
> I agree. But setting RUN from the host means that the guest can start
> configuring and using that device at any point in time, i.e. even before
> any guest component could verify, validate and attest to the TDI. RUN is
> precisely defined for that purpose: Telling the TDI that it should now
> accept T-bit TLPs, and you want to do that *after* the TVM accepts the
> TDI. Here, by having the host move the TDI to RUN, potentially even before
> the TVM has even booted, you're not giving the guest a chance to explictly
> accept the TDI.

I wanted to circle back to this to agree about allowing the guest to
control the transition from LOCKED to RUN. Recall the Plumbers
conversation where I mentioned TDX moving closer to TIO to streamline
the common TSM interface in Linux, and foreshadowing other vendors
making similar concessions. This is an example where the "as simple as
possible, but no simpler" threshold looks to have been crossed.

TDX like COVE allows for guest to trigger LOCKED to RUN transition. For
vendor alignment purposes this looks like an opportunity for TIO to
enable the same and prevent a vendor-specific semantic difference in the
TSM common infrastructure.

[..]
[inclue Samuel's further justification that I also Ack]
> > > After that call, the TDI is usable from a TVM perspective. Before that
> > > call it is not, but its configuration and state are locked.
> > Right. I still wonder what bad thing can happen if we move to RUN before
> > starting the TVM (I suspect there is something), or it is all about
> > semantics (for the AMD TIO usecase, at least)?
> 
> It's not only about semantics, it's about ownership. By moving to RUN
> before the TVM starts, you're basically saying the host decides if the
> TDI is acceptable by the TVM or not. The TVM is responsible for making
> that decision and does not trust the host VMM to do so on its behalf, at
> least in the confidential computing threat model.
> 
> Is there any specific reason why you wouldn't move the TDI to RUN when
> the SEV guest calls into the validat ABI?
> 
> Cheers,
> Samuel.
> 



