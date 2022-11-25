Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40A196381ED
	for <lists+kvm@lfdr.de>; Fri, 25 Nov 2022 01:35:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbiKYAfS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Nov 2022 19:35:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiKYAfR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Nov 2022 19:35:17 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 121BC827F5;
        Thu, 24 Nov 2022 16:35:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669336515; x=1700872515;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=sx7QZQCmb7sOiLtqvcETTHD03LiwNbYraZ7KNARwVtM=;
  b=FgP7I2rxh1VeeLma3+CXSFtvS3gwvKcsyQ/NvLIQVHpf3jZmXUu0E/6j
   Dj7busQza9H+M63iNsHYsYrTd5gI7ivuLjiS/MvULFL/p55GPXXn19ZLT
   QjeDtfi7eD+22IyZsbszwZDtVhdIoC8ZCkuNA+RUTxpW8mhIuR5g2XGu3
   JOSG9DIqnrIzt0kFTcQjAtMUhYyfGgWVojfd5uFUWGEVFCsoOWLgYOc67
   FZSMYdmitDntV+oh/4vmaddsSudMDOkcBIv1tPW2GmAG19w6uayYPt6Dt
   GBqcO85ll8lUn6x3rKyn3bdGgaMG6kO/UZZ05s3SSg3/IPqbWUmR9aFhH
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="400674218"
X-IronPort-AV: E=Sophos;i="5.96,191,1665471600"; 
   d="scan'208";a="400674218"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2022 16:35:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="644630276"
X-IronPort-AV: E=Sophos;i="5.96,191,1665471600"; 
   d="scan'208";a="644630276"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga007.fm.intel.com with ESMTP; 24 Nov 2022 16:35:14 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 24 Nov 2022 16:35:14 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 24 Nov 2022 16:35:14 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 24 Nov 2022 16:35:14 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.48) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 24 Nov 2022 16:35:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b3gk+MgIfCMXL2+2yQfnUTU9yCof1XrQBNoeaMRMKhcoko6z9ymJY6h7rKjB20sFRzwztq3smyMG/zCaQBDxatCsA3A3EtSn0Z3YmuiBfUgTn+/8Jr02I4neqsiN4rG4Z1vpmDsRQ+uWsEwJrFzOsKngW0duhtkTE03ibTRvEGRCOxpfcUYb+3elXunbj2nluhnLAECOSvah8KjBRjPBug5kZdvZG+4g7Uc8YO4GgmFgX2QrvmgiLD4u/b1t5lcgR58/oAOhAvHDDKd3mY7UMASvLUNFYwhsSSiAEIi1oxgpJSnmqfd5vNFl2mk3cuedWzOmqdHFtj5PvlEB/2uKcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uk+wL2S0+lp8vZ65kOmE620iL8ZQOXdtiZbNsXf0Nxo=;
 b=cxsMNhh4Qg2JgVqZ9KjKsVBYFfYA3ojt1iwPEMVcYFMdBZasTebuzq6qEKQthgm8/Yq27iMLMcpCarWrMzYvR1gMstspBhB/BgKrYeYQgMImOasARMZTf6xXhYo08tekm+olmEs7/JFALCKi98D0uxQG7Dg5B546qXhuZL6Pa+wJl48th+X5CVi3iPiWDjPuL8KoYJYVY1ZUjWX2hgadaeezrHlrK/tU4kFjqc4+KHM6Oso25xea0bf9UTYD2ls2FeMKaSEhkIbzasQbJzkyXHJT6Ik7XRSGN+5DJL8L9LwG4+KNw36zsJlcgSc28hhd9TEVgnU8E6CU23ZVLWJpRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH7PR11MB7513.namprd11.prod.outlook.com (2603:10b6:510:270::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19; Fri, 25 Nov
 2022 00:35:10 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::af0:fb9e:4ef9:24e5]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::af0:fb9e:4ef9:24e5%9]) with mapi id 15.20.5834.015; Fri, 25 Nov 2022
 00:35:10 +0000
Date:   Fri, 25 Nov 2022 08:12:16 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     "Huang, Kai" <kai.huang@intel.com>
CC:     "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [PATCH v10 035/108] KVM: x86/mmu: Track shadow MMIO value on a
 per-VM basis
Message-ID: <Y4AIYGGEU3BdrQgV@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
 <f1c9996fa4f4bc71b3feee8407d247aeabb8968e.1667110240.git.isaku.yamahata@intel.com>
 <Y3wvhWyIKNzczFov@yzhao56-desk.sh.intel.com>
 <887a77acc9bf96f7c7bea519ab7ebdd27fb67985.camel@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <887a77acc9bf96f7c7bea519ab7ebdd27fb67985.camel@intel.com>
X-ClientProxiedBy: SI2PR02CA0017.apcprd02.prod.outlook.com
 (2603:1096:4:194::17) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH7PR11MB7513:EE_
X-MS-Office365-Filtering-Correlation-Id: ba7ec4e0-9c97-4927-6aa2-08dace7ce8f8
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XJYoKNNWmBFka+Gs23o4k3XATg3G+KGQEaTFLZQz6pyOIhgx/H14U5YpvZHx3rYPT+i9l7WAHdtva9KxGy3FQzINrvOkNoYHaT2vTmL4ZgNb31JZr4rBwHH+pHGd85vwb9dTEm2lHoy7kjCJsP4uBXz3DseFv0+g/1IRjb8bl+qpicGjVbi07j1/y7lamZlLSX7t1t/lg63lWTsDQeDNdfZzdCIVvBVwLhImFFuUhc7FlZt711dx0eBLTY05V/fhru+8FUhMtird1vmAAByjxSZCVaFNjjqIkXEl8NnWDq9hctH9vIKKH2xnU7hydE1VhqgPfqGv1aRJ3lm4Az4L20NzG8C+i8nSSaNX5Fy+8p2O4vbnxA2VFR7pXzMdMwnv84kgmjZyKBBDkZ8nTaYezRaWOtYZBpW7zggg2+W3jnojC+20PtlAd4Exl22+C9AHGlmsExwZ6s5Hwi/AWfuqVvWlJ1p4yxUjX6+nIUBOP7Gb9C+W7K7ydXnTvmed+vXYfLq9lAEKlOUuQ8cY2tzPxi8uYMwWPiybCrQlfnDlIBgd11hwFSsdUqK4LoauSlFVuXJwfaXqZE/Cv+LDYFiC+mDvlPfPh9IO1hn1i/qnf7A4H7VnFYXCAiAs93XT/zfiJ9TbWAPqhwFAfr6rNC7XtA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(39860400002)(366004)(346002)(376002)(451199015)(2906002)(3450700001)(4744005)(6862004)(4001150100001)(8936002)(5660300002)(38100700002)(82960400001)(41300700001)(66476007)(66946007)(8676002)(186003)(26005)(6506007)(83380400001)(6636002)(316002)(86362001)(66556008)(6512007)(54906003)(4326008)(478600001)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6gg5IEBq+4T/nm5p0pqp1gdicrpGR5gDYzdDhHzcan3AF28ZSdT3ulXYS4xm?=
 =?us-ascii?Q?U3iuIaSonMb3BNqaqfknfxGpOoDnjiZ4erwNsq6zX55WLmfy5EZWygvOtlFu?=
 =?us-ascii?Q?QW3K3roJ73XHLqLGYMGIv1sGOxaCxr3kxJsI7tHfXsSiXkkQwsYveWbYOwaG?=
 =?us-ascii?Q?mRtbF9aImW5XaRrPqq1ulq7RZm/bEMgvysVrmjKA6roL4UspplTZysyXhkSi?=
 =?us-ascii?Q?pQvxKexQgdoNM4ociNAn5gVBlnTFCjoiDlZ6xNJ0pti+Ya27fldtbun0RYw7?=
 =?us-ascii?Q?Vp+24CzZuooPTN9HYsdKPi5Apayx9SvegyutJtArnMmqqkYTTsc6BcO28kzx?=
 =?us-ascii?Q?11TNVkZDAX1LrU1xno7Ynp5J2JPdzniEPNsbUHQaudLnOZEhAQBOG2KGuw/i?=
 =?us-ascii?Q?9r6kUDAN5lT8RH1UPteXrxjeR5uozmmWWuhuRtf0NPJ7v8jnkdHNz4kIyyTz?=
 =?us-ascii?Q?3toxiofQbmCB/pn3vx0c5amZrJSj2t5mdDdFOJNmjSVqH6G0D3gXA0XekYgU?=
 =?us-ascii?Q?q4YnSvTS2PKbUrx+dJCZ9oe3Iwc3A/CWk9hoex3moGYGfupCbBQh6MvZtIUY?=
 =?us-ascii?Q?sjYlv0VqSYQ2JM20WtLiDmnvkfg6KwR1xAhigBHYJQPQY3Psbc3N59KUn2IR?=
 =?us-ascii?Q?jwC74IzttQx2ShbSJKsa7kmdwe2S7jexv+Y3Q8bVNlNvUJ4rO2b1IMm/zSFM?=
 =?us-ascii?Q?2xju6zBWB+V5LHXkKe4YXMDHLRsCeZGlnn8Xm+dUR3j7pjpNR/QaZQm/Dv82?=
 =?us-ascii?Q?Zpve+HIfxJIx+9pOlS7mEHJuFF9pjoHnp4QOCFlH6c+9+hMCl3MSUjtMXxhy?=
 =?us-ascii?Q?vNmHeiTjSmxzTjWN0i3JULBOzhTrPAvL7I9zwcH/lFHWx0PWx7YPcicEmUcR?=
 =?us-ascii?Q?BPpcSC3nc7YaZmDphXwqyIYUZZwxK6PRJuVd2DMHrXOIiJOrOSY7OVYTtogH?=
 =?us-ascii?Q?hbcpE+oxdGYgEUBnJJtmOAXq78yaEu1dOYRGkqabZg9omt+09nlZzl+JwlSA?=
 =?us-ascii?Q?aIHBC/juiVTC2l/8McQ/jXSKO764gYB4ew5ThcLu6LhRxNkKhDnXs7NfIdQw?=
 =?us-ascii?Q?K3OSmgsIJ/JS3ZCsyk/yqn9z3hOhJWFI+nCNmrtKOToUT+PGMt8yh+1vvZOx?=
 =?us-ascii?Q?8CNMzC9/ms82FLxQIhWeNFNjK/dbCHzgeQwMG4TVuaIrL14QmbATNyu9PGF6?=
 =?us-ascii?Q?1HIYWmD1V+aJUvYtohOMt329c/ITcwuPT4MBjbGjkMMLQdrY2yOhVJn/59mR?=
 =?us-ascii?Q?4ttA9e5To1BrncfUYrswNQfejgxmevbpb3g3tyHr7KNHSgxoBjXNDv7pD0tt?=
 =?us-ascii?Q?FBgq9J/1FaCBq10qHbk1r1K4thgD3TAIjpPmavhkmuTctfH30apYPnSwaMVk?=
 =?us-ascii?Q?YTluDQt/ybm8aYhg8uBzVELJDl9ZmH1JYJFbu41h4i86vFnVOdro9SsDUKDu?=
 =?us-ascii?Q?bi1tEDsc2arAgtnT6LYyx6bjzmVEoS5Y5q7+PDC+at+LeC+486vSZY0sUEBR?=
 =?us-ascii?Q?Tud3xQxpXZdV3sNYGoub1IYI92bSRMZDt/ZVHCttLSmugIh+ot1TzhIXLZjl?=
 =?us-ascii?Q?U7lLd2KU3FutszQiY9jCLr8wMQNKUyqeMzrNTx3V?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ba7ec4e0-9c97-4927-6aa2-08dace7ce8f8
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2022 00:35:10.7769
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NR4scbGDOjSMseaX2PZhuBjDutbHdrxKymJCe0FX/6NZNs9509x+AQyfzjlznaHRqKW3kamTPQmp/AhpEgQ/ow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7513
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 25, 2022 at 08:13:48AM +0800, Huang, Kai wrote:
> On Tue, 2022-11-22 at 10:10 +0800, Yan Zhao wrote:
> > Also make enable_mmio_caching to be a per-VM value?
> > As if the shadow_mmio_value is 0, mmio_caching needs to be disabled.
> 
> If I recall correctly, Sean said we can disable TDX guests if mmio_caching is
> disabled (we also will need to change to allow enable_mmio_caching to still be
> true when mmio_value is 0).
> 
> SEV_ES has similar logic:
> 
> void __init sev_hardware_setup(void)
> {
> 
> 	...
> 
>         /*
>          * SEV-ES requires MMIO caching as KVM doesn't have access to the guest
>          * instruction stream, i.e. can't emulate in response to a #NPF and
>          * instead relies on #NPF(RSVD) being reflected into the guest as #VC
>          * (the guest can then do a #VMGEXIT to request MMIO emulation).
>          */
>         if (!enable_mmio_caching)
>                 goto out;
> 

Would enabling mmio caching in per-VM basis be better?

