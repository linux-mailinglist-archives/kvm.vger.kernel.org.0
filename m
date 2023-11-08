Return-Path: <kvm+bounces-1135-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A7707E4FD0
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 06:00:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2FB091C20D73
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 05:00:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7162D8F68;
	Wed,  8 Nov 2023 05:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Vljzlbzw"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 485906123
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 05:00:39 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C39E8193
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 21:00:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699419638; x=1730955638;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=/L55t3YbgczX++vw40HKVhCG70vBB090ZtyDFruxa+o=;
  b=Vljzlbzwr8nawFeKngyqS/sZ9jJUywRrjjbbCWhXNwcHvuKk4JmhB4yr
   CMCCQ/R/YNs46iKFBV8V6K4CrKD3OjHSL0Y4rC4jzUBr0j3xBcbkY5GQB
   tClmftUCTCfsmbfGMt3ybbm5Xz5S0Dm/zaZS5eWJ9N0xRVk7R8acrnADu
   bYHAO/r42w/rM4YKEqCydLxwcwNabhSYQWlcuuFTNKJSY3La/USTAFj27
   IMm5GTvbPKOqXTpNSq7QpwPp8G9EByhLmANqbosDfxDedizPtWArkc839
   /h6d/5JTnKz658pgYqw3YdxL7bXck52wPAaGPsTa1fKiWVCGsbi8VIqo/
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10887"; a="420796432"
X-IronPort-AV: E=Sophos;i="6.03,285,1694761200"; 
   d="scan'208";a="420796432"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2023 21:00:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10887"; a="756433869"
X-IronPort-AV: E=Sophos;i="6.03,285,1694761200"; 
   d="scan'208";a="756433869"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Nov 2023 21:00:38 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Tue, 7 Nov 2023 21:00:37 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Tue, 7 Nov 2023 21:00:37 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Tue, 7 Nov 2023 21:00:37 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Tue, 7 Nov 2023 21:00:35 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fJGG6XK8qx4cy7YY+CFNT4jY7CGCtexPuzLLTvONKZ0Rj21owkdMQZH1XybMdoLXcaU2d+kxg2gQFXYKaKm8QHohNtvPo0tPOtBpJk566WM3DDASg9A+k7JvgFCC+GF6UeznhPrQxsXRVxqUDXC3/YDCLjwBtPZeLXA0dz+fxjJG0JXZ3wRa+qoIbGyWxAaIWVtF18iVRifLTbGJGmMp9dnAl9Ffqi/JsSQ7Dg7ZyZEl5olc3/FBQxIyM4W6lBXwCn0qg7A0GoeEqOW3eGXXxeqtRiFdyabOV1A7f9/BHN3HYV8JRlQHkC95hFg0KK1F2mZliqt58NPDkt68+IufCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ckPsxoIhHss8wD2K2jnQBWymTj/NzpwIWZahQAJN2Q4=;
 b=m2UWeKXSXr0+IExol4AOjqmMWOxsd3oi//bsaxjIJYk1oAMNUzhezTUBnO70xqHs1ARqbre09+2wXDaboIrN8ohABurn1e2MSR1vsHeIJFIsshdDz/7+xLChavWDCuUWKe6KFbUU/1Lcdn5f9tMj/GkVg5tChO06PTmJyK29rLvi/6qKt16SFmXLvZZSlHXVw3a1KSlZf5p1GmAgwvCecmdLFEkta6bCrdE4lSS4HajZYOdvD38Qq7vRmnGhwjj5Re+/w/mEiO9XSxXaiTwe7QBolyVJS69r7oMssCOfXPa2Rxuz0rrpA3apuDvAatmqB9idOsuMrUCKpm9uhQ17Ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SA3PR11MB7416.namprd11.prod.outlook.com (2603:10b6:806:316::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.27; Wed, 8 Nov
 2023 05:00:19 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::32a9:54b8:4253:31d4]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::32a9:54b8:4253:31d4%4]) with mapi id 15.20.6954.029; Wed, 8 Nov 2023
 05:00:19 +0000
Date: Wed, 8 Nov 2023 12:32:01 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Yibo Huang <ybhuang@cs.utexas.edu>, <kvm@vger.kernel.org>
Subject: Re: A question about how the KVM emulates the effect of guest MTRRs
 on AMD platforms
Message-ID: <ZUsPQTh9qLva81pA@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <2C868574-37F4-437D-8355-46A6D1615E51@cs.utexas.edu>
 <ZTxEIGmq69mUraOD@google.com>
 <ZT+eipbV5+mSjr+G@yzhao56-desk.sh.intel.com>
 <ZUAC0jvFE0auohL4@google.com>
 <ZUDQXbDDsGI3KiQ8@yzhao56-desk.sh.intel.com>
 <ZUEZ4QRjUcu7y3gN@google.com>
 <ZUIVfpAz0+7jVZvC@yzhao56-desk.sh.intel.com>
 <ZUlp4AgjvoG7zk_Y@google.com>
 <ZUoCxyNsc/dB4/eN@yzhao56-desk.sh.intel.com>
 <ZUp8iqBDm_Ylqiau@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZUp8iqBDm_Ylqiau@google.com>
X-ClientProxiedBy: SI2PR01CA0048.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::17) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SA3PR11MB7416:EE_
X-MS-Office365-Filtering-Correlation-Id: fb31efaf-e612-47e3-dc4f-08dbe0179af0
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DIL10OxnBF0V6pLNtgANzuoh/Sm6X3z0kcktQhBaoi8jfJqhu1CNOIJtHg4pJ8YZV+gazuJUhfpAtgqN+bZhxXZmysRp7f1VPHCyAFg52putavr7mvDGK4Xnv1bP2Ji4xtVpk1vElscbhoJ2t+rxeBnOv5HwBWzS5rqaB2HPgdEpxlchfG0L1Y1estjoRq8ssz/yrBGEahj+QxOcP3MbpmA0A8s8Q3esx0INQNFGwC+Az+vy2w52vewlHVbx8miDMw60p0IOYfXSGboZx5qU+LfuP8aefd4mGcPPY0FWIHfuuBgex3ZQKsSxdNWAGpFX9G/o3MGedpsepQZebciA+UlVWWU/JHVrlLTp2IHUff+GpUBjX0c7yUbKFFTTuxCKO8SjvYCsEYG7/dbD6JLpTOARaPYQAB1jFrXZQIkUn6kvL3CA/LvnbpQrT5ciG4oTRqzoGI/FBFE77zu7uXE6Up6PgdOMWqT/KsivLvgpCLpS/zBzqszv/rA4wZX0hP4BwEQdLVPVE7OH/bw4VGvZJgEtAgOvJ2u+Mv7Jg74xUNpYgHfNN5rKcUCYQ4kQx8kC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(39860400002)(136003)(366004)(396003)(346002)(230922051799003)(186009)(451199024)(1800799009)(64100799003)(26005)(6512007)(6666004)(6506007)(8936002)(41300700001)(38100700002)(82960400001)(86362001)(8676002)(2906002)(6486002)(3450700001)(5660300002)(83380400001)(4326008)(66946007)(6916009)(316002)(478600001)(66556008)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RY4c68URNvBvhA/OvUn6VQgsVN4rDkO6qMkcNjJpTWmJU+pFJgIBZAkm5zkV?=
 =?us-ascii?Q?PACYGAKDuwVU4XhQzBIgLAlDlFS+6PC29cM4xo0W9DwT+eUW6rjCOnTaAQpU?=
 =?us-ascii?Q?OZoDwiNcK76ICMqRYBuXkF7v0FfxMFrMyq7WOhgbAJJpUsJzZJ/cyS1N0lHq?=
 =?us-ascii?Q?GMKy0zo/Tk19m3cinWHv+ad7Asn1FMzmH/n0fMpU5H6AVoLQBX+fQKvCp1dR?=
 =?us-ascii?Q?n/HsSm58+S0xUE8FpfsHn6hlBURkmbuQuxnV603M6l4dyfPYS/80RZ4ndLVs?=
 =?us-ascii?Q?DOw1jwmYRiD1nfTIAKJ//o1fHOzwVPuP3wvKKEMWP2w9Drck+BaU/BqRtUAW?=
 =?us-ascii?Q?h9DNul8L4c2DHHReD8KlwPfPhfXMwjClIhzxWp0h++J9d8GVbMmm2Hv+mALN?=
 =?us-ascii?Q?o99aijmk5oRbsb1iOa/xUmD9LbKn8Mx4ernXCAk2BQ406l38ArHw3BpwaPZI?=
 =?us-ascii?Q?QbTl02VJmTw0SGi81InWjGcHb7KG2sGkYnymo3JA4fOOaae2YlKs0kQAsftM?=
 =?us-ascii?Q?3ZZ8CwXCFeIEEzqdrpgNqnkWGn+sEYyMIYNWR3gGolByYOTEE5tdcbBqgL2W?=
 =?us-ascii?Q?7mVkt3XSfdvkx21myq5UktiKyzRoBcPWuQFbULJRzUtcPeq9l9q7HAyHx2p6?=
 =?us-ascii?Q?jwpYWcsMveARcuIF39gSWmTMrS3uwrzr0yJCYwgnOyd9p9fEBsRby62M+W29?=
 =?us-ascii?Q?CSFLPaSTTRYeo6U6ejuaUOHfS0A0yalC6gpX2/uHRKQMOUXB/dtzJWydv6Ia?=
 =?us-ascii?Q?7ekZc9LmArq3/0/b0dSSbLpCRkp2suXqIKIDgoRYTTizETPvXbU8VK00W7l4?=
 =?us-ascii?Q?vF7p30/eKL57/Z4cklftXZL935mBtX80QcNXSHQ3rrVhmwiCxjK4RJQKPej8?=
 =?us-ascii?Q?/lrUeETlNqwOkx5a41kI9uNy314C+nr0s2h+qLroa0pLnkT2UnWuKc6QVlpg?=
 =?us-ascii?Q?VncMzXwaeLVn2oBYSP5vwIWrIRPs81/mVoNz6F2EOQHx/ODnj+UPilxf/jv4?=
 =?us-ascii?Q?TZUI1mKViKD5inzcXCAw6E4vGxhfWH+D9TDMuDduI5x0ORW0tTHioWACApia?=
 =?us-ascii?Q?r6X3/7lIqLsP4xkF2hAd7Wb2frQaC+aPavLXoxkFzqeYFQu3vB6mloYu0BMx?=
 =?us-ascii?Q?PU4/Wf6hd2gXdsEHZBoZcG0a23++3FoCU24WRl4Wp15fGQHe3Y77jOt/OrK5?=
 =?us-ascii?Q?n29JXOtzh+jcwSfaYU7+VkzK9xrmgUgx6VLxA045TA8mdh9EayBYHt1dwP7X?=
 =?us-ascii?Q?rOlDTcqpB1wWLWJd8/ZWSTBNFqEbVgNxXhC5aNDchh7I4/qod5z/OugZ866S?=
 =?us-ascii?Q?cG4ZlNHzTcDyjgMYj0q3/jqDx6SRwtbvYWOFk9VCItmz/aNK1c5O2lTTwGPy?=
 =?us-ascii?Q?Hg/n5V6n5W9KELf6YzUKk1ikUmoJcNh3ZuN9gNsPCmQ7kRZ/u15ku3DMdLic?=
 =?us-ascii?Q?CZT7gzCK2TDBsUJz5QBrFElmrFf99aVh2SJCZiHWfy6jnB/OhXMA5ieVgrnV?=
 =?us-ascii?Q?Xw2l8xwL7cJwZlWUe+2eeO6e6XMWpI0xe6RZC7Aqh+jU/P2aVrhAd9ekIlO+?=
 =?us-ascii?Q?7EX05U6eKHGynW+HtJlOKIkYNv9UEZI9dDDd97j4?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fb31efaf-e612-47e3-dc4f-08dbe0179af0
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2023 05:00:19.4423
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HMOsSSOsarJ/uacwsvwsipU2YpNL3XVT0rkYsctWxy/Qhb5zV64l0uFPZc/sF61sNI8LF3f6W/SCs1wcYhh+rg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7416
X-OriginatorOrg: intel.com

On Tue, Nov 07, 2023 at 10:06:02AM -0800, Sean Christopherson wrote:
> On Tue, Nov 07, 2023, Yan Zhao wrote:
> > On Mon, Nov 06, 2023 at 02:34:08PM -0800, Sean Christopherson wrote:
> > > On Wed, Nov 01, 2023, Yan Zhao wrote:
> > > > On Tue, Oct 31, 2023 at 08:14:41AM -0700, Sean Christopherson wrote:
> > 
> > > > If no #MC, could EPT type of guest RAM also be set to WB (without IPAT) even
> > > > without non-coherent DMA?
> > > 
> > > No, there are snooping/ordering issues on Intel, and to a lesser extent AMD.  AMD's
> > > WC+ solves the most straightfoward cases, e.g. WC+ snoops caches, and VMRUN and
> > > #VMEXIT flush the WC buffers to ensure that guest writes are visible and #VMEXIT
> > > (and vice versa).  That may or may not be sufficient for multi-threaded use cases,
> > > but I've no idea if there is actually anything to worry about on that front.  I
> > > think there's also a flaw with guest using UC, which IIUC doesn't snoop caches,
> > > i.e. the guest could get stale data.
> > > 
> > > AFAIK, Intel CPUs don't provide anything like WC+, so KVM would have to provide
> > > something similar to safely let the guest control memtypes.  Arguably, KVM should
> > > have such mechansisms anyways, e.g. to make non-coherent DMA VMs more robust.
> > > 
> > > But even then, there's still the question of why, i.e. what would be the benefit
> > > of letting the guest control memtypes when it's not required for functional
> > > correctness, and would that benefit outweight the cost.
> > 
> > Ok, so for a coherent device , if it's assigned together with a non-coherent
> > device, and if there's a page with host PAT = WB and guest PAT=UC, we need to
> > ensure the host write is flushed before guest read/write and guest DMA though no
> > need to worry about #MC, right?
> 
> It's not even about devices, it applies to all non-MMIO memory, i.e. unless the
> host forces UC for a given page, there's potential for WB vs. WC/UC issues.
Do you think we can have KVM to expose an ioctl for QEMU to call in QEMU's
invalidate_and_set_dirty() or in cpu_physical_memory_set_dirty_range()?

In this ioctl, it can do nothing if non-coherent DMA is not attached and
call clflush otherwise.

