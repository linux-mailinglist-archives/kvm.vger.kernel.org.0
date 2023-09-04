Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CB9F791238
	for <lists+kvm@lfdr.de>; Mon,  4 Sep 2023 09:31:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347291AbjIDHbf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Sep 2023 03:31:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235399AbjIDHbe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Sep 2023 03:31:34 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1382ECD9;
        Mon,  4 Sep 2023 00:31:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693812666; x=1725348666;
  h=date:from:to:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=VZ9RWWcWX7NvwT7H/EBuuZAA9NU7C+9qFXprh2EHLdQ=;
  b=dwTZExY+eYwOYCzVZ1RodGCCfU/KXZ+an7uiaICe/zEyy6skKewR0StH
   7NjlpS+AWR05MvBwqYIHjGvxO1ygQZMlWO1jhCRregpRLueeqSpovAr6p
   nfKYCf9K6dHJZ6gcDZkKLEfnkof1NGt7u/Y3LMuzbZjXqPAWkWHRad37n
   gq2ofP2oPl9CmpSZD76UHE2IvhEAbxyL5WwNg96UedTJs/i2+wkgld7c2
   tIs7stoNPk8tpYzeyw+W1TDnxnbJrua+rjFpgRr9+T0iCMvGGLRJoPuic
   v5O7gyIrzxOvXv8RVtZ5JPRBSpKT4i+qr31qVUX5Px8KB782sW2kc9PW6
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10822"; a="356854261"
X-IronPort-AV: E=Sophos;i="6.02,225,1688454000"; 
   d="scan'208";a="356854261"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2023 00:31:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10822"; a="810817111"
X-IronPort-AV: E=Sophos;i="6.02,225,1688454000"; 
   d="scan'208";a="810817111"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Sep 2023 00:31:00 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 4 Sep 2023 00:31:00 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 4 Sep 2023 00:30:59 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Mon, 4 Sep 2023 00:30:59 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.108)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Mon, 4 Sep 2023 00:30:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QiaI6zBv9ieMbNTwyPX2hBDZczXAtzec/bVSveGlav01aQsLTI09sQgy8WoVI9h5gwUks7/IOBID5Nf8po1oYi7BYtS01YOsYGQ9NoZieME0BOiCubZHpxxqDLhqdXrDIpPTMTTbtbkJrjDNp8XroMAAY2Xt7eJHJbajYQ/aKAs/u+jZAvl3YySF2z3HoofSR4wRzKKFr1iwTjqylGA15YSIWreHl1vRIjUuobuqagU+PGGj8hxZjGVx0cNtuALFnGtXp7dMpHiL+jdHJltHP3uXVxfwfGZgIUyIHkocWuH6raqli7qp8H+tdC+bdn+QQeTrJcpYez5QoRT6TmHYuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0bqn2mX3WHVuGxDdMUl/FaRA8SmTXmaYw0PqQ53jZ8I=;
 b=Wbd6xVq2gfVrmTkd1Xk3LyFUba89xj5h4co2ddW+PPtt2nlS3r0pI8DdrIBwLKcN75KwnuEoY8MRYBj8fjYIbboPc728TZ1ItZLATWJ+JmNjdTm9qHWuFtk5nDGbxKS+9EImhBpXzM+b9B7KwjZEymY8IfS2peQJx/5ypbw6ipHTX6zbqdJ1GL+QfP4L9Ot3pHoqCH2ycoHwJXlgLVvzBG7n52cSmwblvMPewyF1dyjbHAxp1BlOFb1ZYYKVwJ6EuIlScH8oPVR4yZF2SQ9GjQQNn9SphE93GGeAy3FwwirVVGiEDKfXsLjFWBBmgtM6x1d03xDD59kfeS+Y4FL3EQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 IA1PR11MB6073.namprd11.prod.outlook.com (2603:10b6:208:3d7::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6745.32; Mon, 4 Sep 2023 07:30:56 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::5e79:2d52:51e:f602]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::5e79:2d52:51e:f602%6]) with mapi id 15.20.6745.030; Mon, 4 Sep 2023
 07:30:50 +0000
Date:   Mon, 4 Sep 2023 15:03:15 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <pbonzini@redhat.com>
Subject: Re: [PATCH 0/2] KVM: x86/mmu: .change_pte() optimization in TDP MMU
Message-ID: <ZPWBM5DDC6MKINUe@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230808085056.14644-1-yan.y.zhao@intel.com>
 <ZN0S28lkbo6+D7aF@google.com>
 <ZN1jBFBH4C2bFjzZ@yzhao56-desk.sh.intel.com>
 <ZN5elYQ5szQndN8n@google.com>
 <ZN9FQf343+kt1YsX@yzhao56-desk.sh.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZN9FQf343+kt1YsX@yzhao56-desk.sh.intel.com>
X-ClientProxiedBy: SI1PR02CA0057.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::10) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|IA1PR11MB6073:EE_
X-MS-Office365-Filtering-Correlation-Id: 47620351-0510-434a-a7e3-08dbad18dd03
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vIS575eI+nYw9T+vHRFHz6vdSTMottr7bAmc4fhmzCCeBW5wtTnL1IcZIbpWRO+zxpirmVOgYuk+g0HTUj0rYf/iWPIdrarr44hHURhq4e/mkJIFtvFzeiT7O0GcqSZZWqyfOi1NBvt9XXXGbNBUAkjvUZ/4a8lzM4b4V9qjbaITJhaIeUejJsQNA+sAD7UzzICcsi36OwualJPrln6k4q5L07Ttv7zaN+5ZIC+Cuqtv85h9/L4stmKN+7usxnKhEX6SMJkVy81IdI5khyfaALZ7eATo7W7Bktu8lybZHVQuCq671ht0+hZxchroqob4tYpzM8YSikKsTdUIcf8HUevFXA4OSjZvsGQpvvZpMnv8bF3emTJXSY7P2jRZgd+hU9YzBZExXzeRX3VOuT38nEIt+743Q2ub46x+n3RvRcO57yXl2S6MddOsypqSB4Qa3ukxa6CVUdQURU+IH+M4hF6ms4LLHCrmpn3d5XwMjKFFhL/KlTgKNy6H+K5E6ZapeNGPiv1UeCsCq6NQ/ld5HvbLaf2hRm2he0xjep0Zd6HFveMUfhxBaA54I/TFR5a7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(39860400002)(366004)(396003)(376002)(136003)(186009)(1800799009)(451199024)(6506007)(41300700001)(6512007)(2906002)(86362001)(38100700002)(316002)(110136005)(478600001)(82960400001)(66476007)(66556008)(66946007)(6486002)(6666004)(3450700001)(8676002)(8936002)(26005)(83380400001)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YWFHpI+2Z6RUJNLaOA+AHnhErrgKWsITaUsfTCgTAG/3zTiCOwZvuF1PATht?=
 =?us-ascii?Q?U3Ftvz/TujR8MOuKTU4hGXYh8XAa1Abs5KNeDPtljGp++/HOyGIea/8Q3o/w?=
 =?us-ascii?Q?a+dlsAide0Qc4dIYU8QsJOrrA8Fmhi1s9Y2WJ44gbPWMOjWhNIktzidWkA7G?=
 =?us-ascii?Q?FFl/LYJKWddOlAna4fkY9N7C6JGFA9I642c5Jg/m9xdsn1uu0eU67zLEhhEu?=
 =?us-ascii?Q?6j4MQRzSpJkWCnKZYyG83/2sQMVykD4HHjV5Wu5KDcvHYqOHNXim61CFlN9Q?=
 =?us-ascii?Q?ZhdvTx97BxrBwCTKy6533rn8L+88KI3yXRRNzDA/UZIrcYqjR7FbvoC4s/Y4?=
 =?us-ascii?Q?qjPwDGkPvgBuNoCRCakYo3Y90cbUT3q4ZMHomrYv/UrcTRwBOAO3fh2P8/ag?=
 =?us-ascii?Q?mcDgg39KgjrA4oCe3BMkfZNxIqVgkRNe0x3XD6YEFo6LqdS1T+of9SJcP8bG?=
 =?us-ascii?Q?dFd0kePmzUtyn7HcMJNZ0QxkHiECveokJtSbz6kuqFPu+n31ShooOusSYKgU?=
 =?us-ascii?Q?JnV3f/ldPj/KojY/kkl87GmvoK7E75JmPS3G2y1g5FXWNZTkm1SvuKRSpFKv?=
 =?us-ascii?Q?KfyqXyTnsyGN8ePdpjoR851vqGrTs5vRQxFDBJ8yYrdREwYv78VTXUcUklLM?=
 =?us-ascii?Q?4Jf+s0UjZI4ntbIUyJ8JL1PpaFxIaPAPeMY1fQwaWSr6yQ4JbbLfVMYkDNI/?=
 =?us-ascii?Q?AsP7Ezuc676ugoU93deTtLwdDABm9QXSJE7qeR96CkYV1UcBWCMw2QsxTIE4?=
 =?us-ascii?Q?KffzXagfeleiqYzvYCKwolYiuKd/l9skEj57CrkdqvdhFcnefXweuV2Bic4B?=
 =?us-ascii?Q?bm/k6AeS+haDYMkwlB7P/TAlcVdfVGWb23VZE0UqLVul27o8dgrpiR51HNGx?=
 =?us-ascii?Q?1T/wse5DQzvHDGUmn88roie5lbEeoDrMoTXRmR2o2hezNxy3wai8In8e4qqy?=
 =?us-ascii?Q?FpJwP4UCEMXedx6VZXJxYqW2AvO2DxqRWfJJtWURufNgTdRQBceKObMJGhx7?=
 =?us-ascii?Q?ml98DtcJ1ofGXbtnf+3Oo2s6ldfq+/Tl7+UyAVfzTVCw6tUVE9du3NuIEend?=
 =?us-ascii?Q?wyUAVoj75JVdsEZbZ8q1IizXVe57+xVUECzth2n3mU3FgUptHxafVFqASkF6?=
 =?us-ascii?Q?P9j+IZscDnBbBs29nhFTOnbxGZipmVsUso+GxP7wBbQDOlcfIxgvpPCZjJIO?=
 =?us-ascii?Q?jS8qpbkz3LDNPt5nKQJ42715oTKf1FebfVmj+UzhMQ4dLc8yc/LlbsCl/J2d?=
 =?us-ascii?Q?wp8G30CvERA21JOCjxp1tPXj7js+cGqd5+/K6cpqrRf3zjHTAhBxpduZfMeQ?=
 =?us-ascii?Q?P73TpSryqVmZTWCpXWT9qRztHYuaDLXRtJH/NomBZXPIubnsbwsZpz2LW6QG?=
 =?us-ascii?Q?jOK41q1v9h9r6bm1fjN2HseWLPdIIZJz9oMuWb3ieADGHhZA0GZRv9VECRRa?=
 =?us-ascii?Q?7Guy2xNY6hzgvKFmv+ponQIjLgZ0/0ZA/wM8eL6WSMOzz0VIukUc2o0Fpq0+?=
 =?us-ascii?Q?sjWmrCeEFD/zwz6Y5xIA7qZ8HgQ//qQR46gW+O7+wtxT27L89xwW48ixHJbH?=
 =?us-ascii?Q?eXOdzSMuTQbC9BqF8enZwSIuS2YHVmIU1MQ0bGE4?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 47620351-0510-434a-a7e3-08dbad18dd03
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2023 07:30:50.4404
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LbN4M3hIR4VHA78DxPDxv7isBcqYeWj6519tnqqpie5j7Qgn4m2KKwj2ryDMWO2Njier+iFw7YyW+lhwsA+8cA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6073
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

...
> > Actually, I don't even completely understand how you're seeing CoW behavior in
> > the first place.  No sane guest should blindly read (or execute) uninitialized
> > memory.  IIUC, you're not running a Windows guest, and even if you are, AFAIK
> > QEMU doesn't support Hyper-V's enlightment that lets the guest assume memory has
> > been zeroed by the hypervisor.  If KSM is to blame, then my answer it to turn off
> > KSM, because turning on KSM is antithetical to guest performance (not to mention
> > that KSM is wildly insecure for the guest, especially given the number of speculative
> > execution attacks these days).
> I'm running a linux guest.
> KSM is not turned on both in guest and host.
> Both guest and host have turned on transparent huge page.
> 
> The guest first reads a GFN in a writable memslot (which is for "pc.ram"),
> which will cause
>     (1) KVM first sends a GUP without FOLL_WRITE, leaving a huge_zero_pfn or a zero-pfn
>         mapped.
>     (2) KVM calls get_user_page_fast_only() with FOLL_WRITE as the memslot is writable,
>         which will fail
> 
> The guest then writes the GFN.
> This step will trigger (huge pmd split for huge page case) and .change_pte().
> 
> My guest is surely a sane guest. But currently I can't find out why
> certain pages are read before write.
> Will return back to you the reason after figuring it out after my long vacation.
Finally I figured out the reason.

Except 4 pages were read before written from vBIOS (I just want to skip finding
out why vBIOS does this), the remaining thousands of pages were read before
written from the guest Linux kernel.

If the guest kernel were configured with "CONFIG_INIT_ON_ALLOC_DEFAULT_ON=y" or
"CONFIG_INIT_ON_FREE_DEFAULT_ON=y", or booted with param "init_on_alloc=1" or
"init_on_free=1", this read before written problem goes away.

However, turning on those configs has side effects as said in kernel config
message:
"all page allocator and slab allocator memory will be zeroed when allocated,
eliminating many kinds of "uninitialized heap memory" flaws, especially
heap content exposures. The performance impact varies by workload, but most
cases see <1% impact. Some synthetic workloads have measured as high as 7%."

If without the above two configs, or if with init_on_alloc=0 && init_on_free=0,
the root cause for all the reads of uninitialized heap memory are related to
page cache pages of the guest virtual devices (specifically the virtual IDE
device in my case).

When the guest kernel triggers a guest block device read ahead, pages are
allocated as page cache pages, and requests to read disk data into the page
cache are issued.

The disk data read requests will cause dma_direct_map_page() called if vIOMMU
is not enabled. Then, because the virtual IDE device can only direct access
32-bit DMA address (equal to GPA) at maximum, swiotlb will be used as DMA
bounce if page cache pages are with GPA > 32 bits.

Then the call path is
dma_direct_map_page() --> swiotlb_map() -->swiotlb_tbl_map_single()

In swiotlb_tbl_map_single(), though DMA direction is DMA_FROM_DEVICE,
this swiotlb_tbl_map_single() will call
swiotlb_bounce(dev, tlb_addr, mapping_size, DMA_TO_DEVICE) to read page cache
content to the bounce buffer first.
Then, during device DMAs, device content is DMAed into the bounce buffer.
After that, the bounce buffer data will be copied back to the page cache page
after calling dma_direct_unmap_page() --> swiotlb_tbl_unmap_single().


IOW, before reading ahead device data into the page cache, the page cache is
read and copied to the bounce buffer, though an immediate write is followed to
copy bounce buffer data back to the page cache.

This explains why it's observed in host that most pages are written immediately
after it's read, and .change_pte() occurs heavily during guest boot-up and
nested guest boot-up, -- when disk readahead happens abundantly.

The reason for this unconditional read of page into bounce buffer
(caused by "swiotlb_bounce(dev, tlb_addr, mapping_size, DMA_TO_DEVICE)")
is explained in the code:

/*
 * When dir == DMA_FROM_DEVICE we could omit the copy from the orig
 * to the tlb buffer, if we knew for sure the device will
 * overwrite the entire current content. But we don't. Thus
 * unconditional bounce may prevent leaking swiotlb content (i.e.
 * kernel memory) to user-space.
 */

If we neglect this risk and do changes like
-       swiotlb_bounce(dev, tlb_addr, mapping_size, DMA_TO_DEVICE);
+       if (dir != DMA_FROM_DEVICE)
+               swiotlb_bounce(dev, tlb_addr, mapping_size, DMA_TO_DEVICE);

the issue of pages read before written from guest kernel just went away.

I don't think it's a swiotlb bug, because to prevent leaking swiotlb
content, if target page content is not copied firstly to the swiotlb's
bounce buffer, then the bounce buffer needs to be initialized to 0.
However, swiotlb_tbl_map_single() does not know whether the target page
is initialized or not. Then, it would cause page content to be trimmed
if device does not overwrite the entire memory.

> 
> > 
> > If there's something else going on, i.e. if your VM really is somehow generating
> > reads before writes, and if we really want to optimize use cases that can't use
> > hugepages for whatever reason, I would much prefer to do something like add a
> > memslot flag to state that the memslot should *always* be mapped writable.  Because
> Will check if this flag is necessary after figuring out the reason.
As explained above, I think it's a valid and non-rare practice in guest kernel to
cause read of uninitialized heap memory. And the host admin may not know
exactly when it's appropriate to apply the memslot flag.

Do you think it's good to make the "always write_fault = true" solution enabled by default?

