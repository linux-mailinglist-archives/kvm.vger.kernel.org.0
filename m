Return-Path: <kvm+bounces-3450-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B3631804883
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 05:21:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E4D5A1C20D7C
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 04:21:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99E3DCA79;
	Tue,  5 Dec 2023 04:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dAyIqwc+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65F64FA;
	Mon,  4 Dec 2023 20:21:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701750078; x=1733286078;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=cLva71zwgi/M8KDtf0M821OdwuVBok5ShR2kEwMkmlA=;
  b=dAyIqwc+foHobi7UZuLc5ymrYV5bbRcvXFFaLAqf7TYrw6RhsFJoA1GE
   jYBSZI1e8lYDsFfwvfzTKE+t2B6hcJdH4xY1lnL2tq9OI3F6Is/c94Pdu
   ttW5SboDWrQ4kNKt1mswx8d8SCVTm+s7zaD+EdNtcgWI9Qa4jLrCgxZ3R
   +YA8S8F4fjYUIMkXyDUoiMaB1UwS2BWLn7wCvKV013UJJy7IFCvcq5MXU
   9HGoE2hWIavW5HeKKFUBSH5jEPTzS43gyycU8IAS2/ENwnNBsLpmHPr5Q
   rd0WJSQ5ESUZT5z0K6DSEbc9U9tqMAXJWZ+QnObdgq6q8K2o2m7TyDynd
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10914"; a="393574318"
X-IronPort-AV: E=Sophos;i="6.04,251,1695711600"; 
   d="scan'208";a="393574318"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2023 20:21:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10914"; a="841309370"
X-IronPort-AV: E=Sophos;i="6.04,251,1695711600"; 
   d="scan'208";a="841309370"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Dec 2023 20:21:17 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 4 Dec 2023 20:21:16 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Mon, 4 Dec 2023 20:21:02 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Mon, 4 Dec 2023 20:21:02 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Mon, 4 Dec 2023 20:20:56 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VNwuWvQZxExuWx7Vk1OosfEs+FYE6pzTV0DncXC2lJbozIhYA08Rv008JCEZVbp2hv5GAnvCPRkXeYuEmi6UGrVU+JTl2mkf77ktFN3q4o0hKPP26U+52kG4HOWHX+xEHYIbqMYAJXHXcqh18S6IobsaSusZ/51uVqqu+gauTeo2i4aaE4E/NfuVYp03YJ4AolBUQx1GgNCY0CnrKrWl13zSWhB6GO/+BfHElvt4srboA2bBThfL3aCIa1g4EmEkLZN7ryv5KINQDzi9PdSaryKrrxk44beGgAhCuFTi5IYp+q+LKsGz7MG17VVWHXpHcXKo8PaXHQuZwHWWLJaRHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T1gLnS9yGbXQKZknZoSGF394YC42Df7fZw65S4+VtbE=;
 b=Hhy5KKwFGdCBIdvnIqSpVUAtoZJqUM7/ojuavA76ytretM1l+wHlQaYRFZZ488RgOLj0IVwWKPbX1Z2w+14bpxk3QY/wgiu3XiS59Cn/raQASVq2YZDOQtjZaBi+2KPZnGbgOPLmskp8UUzTxIq4XPnhEGUmi+ANu9ymZY0rl1Tp+1+Or3D4i4jX0HhXdQxv8OZ3PdFTJuZdnNyFayjWfmDYAlSprXQhs2eGvBJm8MkQe9v5+rlGX6PLMiZK8SoGGIb6W5UgU5V6QWD1urb+MTosufTGUtC/CbeyhtnQ9LzZXCsj46fH6Nfv0Sy3EGBhSmV8b0xCrpN/pPsalMX/EQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 MW4PR11MB6737.namprd11.prod.outlook.com (2603:10b6:303:20d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.33; Tue, 5 Dec
 2023 04:20:54 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::32a9:54b8:4253:31d4]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::32a9:54b8:4253:31d4%4]) with mapi id 15.20.7046.027; Tue, 5 Dec 2023
 04:20:54 +0000
Date: Tue, 5 Dec 2023 11:51:49 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: <iommu@lists.linux.dev>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <alex.williamson@redhat.com>,
	<jgg@nvidia.com>, <pbonzini@redhat.com>, <joro@8bytes.org>,
	<will@kernel.org>, <robin.murphy@arm.com>, <kevin.tian@intel.com>,
	<baolu.lu@linux.intel.com>, <dwmw2@infradead.org>, <yi.l.liu@intel.com>
Subject: Re: [RFC PATCH 00/42] Sharing KVM TDP to IOMMU
Message-ID: <ZW6eVexQNIqtwDaZ@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20231202091211.13376-1-yan.y.zhao@intel.com>
 <ZW4Fx2U80L1PJKlh@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZW4Fx2U80L1PJKlh@google.com>
X-ClientProxiedBy: SI2PR02CA0024.apcprd02.prod.outlook.com
 (2603:1096:4:195::18) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|MW4PR11MB6737:EE_
X-MS-Office365-Filtering-Correlation-Id: b5b01ee0-95d4-4670-50b0-08dbf549919d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gsvWeGJnBU5xh7an8oFYsbkbKB547+DJvG00kbBkehABFwP+QG7kUhjV5RuqaVw1z4sKKtx196++VHs8Lgb0w19IiqfDTtVH1zD+A1UCS8lR8+1mpM1QnnU72fU+odjx0fbU2mcGcmllDj30bFjcKyCjezF3cynMr1rCLbK+nuiUCgz3DVnjLpHiY0bEKbv5pbwdAQwMlGl6NHNUsLi6kZ5q5zt5mlP7/Ku5SZHEegw6wY6RA/5XZJmbF0vfTlVWDfJetsJCwPGhd3zCqtWf4lCt68efXGHXHjCFO+47Yt5ArfIrluHUpVd4LVOxlfftlbTzizJnalESkQrx1QpupCzZ1q9Rmnea1OT3GavwymDz3azIpynOIYM2VIwaYDg7+E6epWFGezxSP0widUW+LIWd/QX6/ErRSFeka3MsU3h3sijYc3f7Eke7XTERUQiTTkl7m5MfFDQnnMy6UePrgBa0krx/RSIt9RBAF9QE3Exu9HSlPC003pC6j1jd3uZ+XzykOCFZNaHOxJJyDPeAqsXrJEziJMrZBOhIavzar8BMbozqIxsQa96+URQJIuNf
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(396003)(39860400002)(346002)(376002)(366004)(230922051799003)(451199024)(64100799003)(186009)(1800799012)(5660300002)(86362001)(7416002)(4326008)(8676002)(8936002)(2906002)(3450700001)(41300700001)(6512007)(6506007)(82960400001)(83380400001)(6486002)(478600001)(26005)(6666004)(38100700002)(316002)(6916009)(66476007)(66556008)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gLsNvpFMxqVmBzuJnp5bPRNqd287UJeFKTQhd6FHDNR6NqoMvb+yzg7b9DtF?=
 =?us-ascii?Q?Dr+7M7rDVVcgdGtY9KQ65X2dO5/UeM5tgfpIEgPtxP09pYrTcmpBBaW4ZRSn?=
 =?us-ascii?Q?HMSI3dWVyx96Oz0ZeJijZivR0zK7XvllMHl+mNGktNvLAeUuflRsdBlHCpmb?=
 =?us-ascii?Q?zDWu5gBgjCGdD+t977voYyqY/U1Ui1m93073mK81IlQHgljdyf0y36PvvbF1?=
 =?us-ascii?Q?sQseVEF9VN6UQElRyh5qERKl9g2yS5N04iy6gr+ELiAJuCa6PcPO96Q0GftT?=
 =?us-ascii?Q?TJKqdjlyjAdV9NlY1xzU7D9fgsEQEIP7yUqKhZSuG+r8xF176O3HMp6cZNIi?=
 =?us-ascii?Q?xg7KXmcINYu6OJY1F9qcqcp/5ShMimdbeb8dtThV5oYZ9a5jG3o2fK3uu1eW?=
 =?us-ascii?Q?hm3wICst557AURw87KLcUTU8SaHh8D6+V9uB6/Z9zQ12JILmDPOtK35r990L?=
 =?us-ascii?Q?+OmsDnqk//k4T87cdaupKiZGmWF8hCcvcA99Vlpp5eGCggZomvsQwmmvXndO?=
 =?us-ascii?Q?ICUXVShq3WBuptFYn/q2acmDIdEQKT/R7svU0LJrhDo2GQxwYkSsa3gwVzTP?=
 =?us-ascii?Q?KbKAfaogBdPeShNhIUngiK3LUHSzoO7I2G3OjH/F4quJB9ohxXhXeaOetglM?=
 =?us-ascii?Q?3C3NrMBZO0WlDIy9CYPIG37zSgh8+/8H+cvHdwy9AQk33bZgch1afgNafzFJ?=
 =?us-ascii?Q?1JCv6PKOFzEqEr0VgAE2QxjIqPtxHbN4I5/dQi+pefDmNYyThFj96HiuAQf/?=
 =?us-ascii?Q?Uk5mbfYMkw9Y2FLpFiwbtNMvJiNrilxHH7HwCDuFUJrWdAs56nFvbjDLAhja?=
 =?us-ascii?Q?oG9ZJcIMHzBbbBscxMbPYs1TeNvORKkVxR7c2ADQLWoyo6s5sjfbEUFOohrQ?=
 =?us-ascii?Q?pVOktW1yXoo7PrK/Nto9iQAQNk0Pzr8+03Y13GIMG9+8V8PoKNGdoT3YuGwf?=
 =?us-ascii?Q?mmggnlLduJyuxFK9GjHYKuQUXlL49yACMzQO79jyJUjVCCVxUK3yEIdVdTui?=
 =?us-ascii?Q?gYitxY7paFUEJjOoD3Ycx7Lyzdvq/RYxxZKcyw2VtwZME4ODyABgCbbi3UoS?=
 =?us-ascii?Q?R1/0UXecItF2/j/xBEgbHBoG/IcXGPBi6vuEG08o3PS+lYMQv2uQ2A0xy8Fg?=
 =?us-ascii?Q?FyMjYTp2uFG7Nxa3BTvd6IaTvtYAnU5wj82mBE1kEIRpk8M/Ar68GSu0YeUX?=
 =?us-ascii?Q?vLfIjL6ip6p5uJEwqTPl2xto3y+8BWIwa516ldefjJ//c/uX0rXx6qN6nmQo?=
 =?us-ascii?Q?KbC6HskU/cU1cnhyXAIBavyeMrp8+WwQAds1M+RHh1gDJctL6mk8ZczjnN5F?=
 =?us-ascii?Q?SeChg7OHIVYX5OvhMi2CW6MbucbrWoIEG4TwFWv3Z4OkK/eP8sGAolhob5pI?=
 =?us-ascii?Q?KkCzfdyTkCX23l2NghJnNU6LiQIuQ8W2EmmZgZxLeCrAY2rRDOF++s6YtyzD?=
 =?us-ascii?Q?gpYzJ+llc3x7KVp61s7MHaEZobauQGzfO25b1//FTZEd54+UtADcS9W9ukp3?=
 =?us-ascii?Q?c0foB8TMl+ntvBdl9AAwl1bkWHKMfcbBAAD5hABSkNpv2nwDbjzKS3S7uMKP?=
 =?us-ascii?Q?7r1/7yKOagATxJL7+Cn/eDVvpf4PFm7duKOyArrF?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b5b01ee0-95d4-4670-50b0-08dbf549919d
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2023 04:20:53.1597
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rLDW5+NU5YEHYW88yEcocr7CNP/4d0EWhcqT06hHtswKpbrxQ1WlbboWqD+0HDeohVWs5c90OS5wz3AzHjddfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6737
X-OriginatorOrg: intel.com

On Mon, Dec 04, 2023 at 09:00:55AM -0800, Sean Christopherson wrote:
> On Sat, Dec 02, 2023, Yan Zhao wrote:
> Please list out the pros and cons for each.  In the cons column for piggybacking
> KVM's page tables:
> 
>  - *Significantly* increases the complexity in KVM
The complexity to KVM (up to now) are
a. fault in non-vCPU context
b. keep exported root always "active"
c. disallow non-coherent DMAs
d. movement of SPTE_MMU_PRESENT

for a, I think it's accepted, and we can see eager page split allocates
       non-leaf pages in non-vCPU context already.
for b, it requires exported TDP root to keep "active" in KVM's "fast zap" (which
       invalidates all active TDP roots). And instead, the exported TDP's leaf
       entries are all zapped.
       Though it looks not "fast" enough, it avoids an unnecessary root page
       zap, and it's actually not frequent --
       - one for memslot removal (IO page fault is unlikey to happen during VM
                                  boot-up)
       - one for MMIO gen wraparound (which is rare)
       - one for nx huge page mode change (which is rare too)
for c, maybe we can work out a way to remove the MTRR stuffs.
for d, I added a config to turn on/off this movement. But right, KVM side will
       have to sacrifice a bit for software usage and take care of it when the
       config is on.

>  - Puts constraints on what KVM can/can't do in the future (see the movement
>    of SPTE_MMU_PRESENT).
>  - Subjects IOMMUFD to all of KVM's historical baggage, e.g. the memslot deletion
>    mess, the truly nasty MTRR emulation (which I still hope to delete), the NX
>    hugepage mitigation, etc.
NX hugepage mitigation only exists on certain CPUs. I don't see it in recent
Intel platforms, e.g. SPR and GNR...
We can disallow sharing approach if NX huge page mitigation is enabled.
But if pinning or partial pinning are not involved, nx huge page will only cause
unnecessary zap to reduce performance, but functionally it still works well.

Besides, for the extra IO invalidation involved in TDP zap, I think SVM has the
same issue. i.e. each zap in primary MMU is also accompanied by a IO invalidation.

> 
> Please also explain the intended/expected/targeted use cases.  E.g. if the main
> use case is for device passthrough to slice-of-hardware VMs that aren't memory
> oversubscribed, 
>
The main use case is for device passthrough with all devices supporting full
IOPF.
Opportunistically, we hope it can be used in trusted IO, where TDP are shared
to IO side. So, there's only one page table audit required and out-of-sync
window for mappings between CPU and IO side can also be eliminated.

> > - Unified page table management
> >   The complexity of allocating guest pages per GPAs, registering to MMU
> >   notifier on host primary MMU, sub-page unmapping, atomic page merge/split
> 
> Please find different terminology than "sub-page".  With Sub-Page Protection, Intel
> has more or less established "sub-page" to mean "less than 4KiB granularity".  But
> that can't possibly what you mean here because KVM doesn't support (un)mapping
> memory at <4KiB granularity.  Based on context above, I assume you mean "unmapping
> arbitrary pages within a given range".
>
Ok, sorry for this confusion.
By "sub-page unmapping", I mean atomic huge page splitting and unmapping smaller
range in the previous huge page.


