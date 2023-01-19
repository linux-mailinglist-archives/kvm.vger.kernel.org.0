Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E76F6674AC0
	for <lists+kvm@lfdr.de>; Fri, 20 Jan 2023 05:33:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230154AbjATEdq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 23:33:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230030AbjATEda (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 23:33:30 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3DFDBC8A3;
        Thu, 19 Jan 2023 20:32:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674189161; x=1705725161;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=e58AN/9Gi0OzWoWVvKqxjbxuZ51lvoME9LuHAv0/XwU=;
  b=MEI9y7uzkqMHikGmBuHpBOF9klo2hjK4el94j8ud2TDZU5NLKtBHaKi3
   aeFhSdiULk+bKTURgSTeuikMIIPsXGf/jWdGH5CL5ZkMfVS0ubG9XnF0G
   Lrt3Y/+TOlGDnxE+oL7m3SvS6ic3+gGO1zEpHVMh12uKxoF4+ZXEj9Oy/
   unUqT/2zhEK76GDw2Egy4NsUUv+FLoPaMWES2rETxim2aopix4MgcgFIw
   ikzJ7c0LYpafI69lVLPwMvTqz1GrSiIqebiV0mRAGfFE+6NZvcdHH+UWU
   b48mQNm/fCinAdv+YT+MO5GvKyxsrKi6gr/EbSIv0+MzTn3fc3Iy2b7WJ
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="411443393"
X-IronPort-AV: E=Sophos;i="5.97,228,1669104000"; 
   d="scan'208";a="411443393"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2023 21:50:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="748769786"
X-IronPort-AV: E=Sophos;i="5.97,228,1669104000"; 
   d="scan'208";a="748769786"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by FMSMGA003.fm.intel.com with ESMTP; 18 Jan 2023 21:50:46 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 18 Jan 2023 21:50:45 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 18 Jan 2023 21:50:45 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 18 Jan 2023 21:50:45 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.177)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 18 Jan 2023 21:50:45 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BIY7YHL+HZ5rM3hTUlODhWT+PrffRV/9OiTO5ThbXBXMxUib+dlcDiYjVjbzVn9eVtcPr+9lJgkZS9k/iykYatYY6kkCf5FIn4RmtmoobVoeM54SydeoULx9d2stRvF59Ebfx+COIRhEje6tQk9g9yAYQ48xq2a+MXBoAqxJ5rM2yj2bpQyfQ8jlWQF97vfaUJSb7Pp0n5WSVIvyRs2wCWRhhp+KyAAJmgAt3tnVbCZpPcZa9gCxT3vcCPqGDzfSK7mPh4O3cksaGOoKALDVuBgytXDU24rI55EbxfJtvLXXSVVggJdXIikHcr08+N1+Ch+mY/XRUSKrZOTzw683Yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CeVnGnefZdJMJTuNOYCwmbAyhYPaTwrILDew33NzYRo=;
 b=UwpdwgyeVXejEQVoehAodOu7yjCPJjL5abQ6mJLML7lhNcITa2gF3zc7QY127SthQ4K3jwBh60jrSUYQbJFk5vYh/A93AXLHA4F1FrppFP239DzV/JT2r/BpbAsot0QoN8M0ciiq8+lYH0tA5ItP93AiOlqWtc+dLhvcfzuU/3Mh9G6TZPE/IQ0klY6i1U3kZ/l9RuQzzuUVVcrOIYqHWFOSXEIhqxqa/2g6x41hf/RWgXkZWQJs6lb1CwdcmHNyeNvpMpnf5dCmtlALwC7oZceHsApLGLvEwtiqXrvDQrG6m9PgVfDfAymQVKvucBoUQrstTSQiqZTiaFcxN8ugaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CY8PR11MB6889.namprd11.prod.outlook.com (2603:10b6:930:5e::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.24; Thu, 19 Jan 2023 05:50:37 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::bd50:2cf7:f362:3734]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::bd50:2cf7:f362:3734%8]) with mapi id 15.20.6002.013; Thu, 19 Jan 2023
 05:50:37 +0000
Date:   Thu, 19 Jan 2023 13:26:58 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Zhenyu Wang <zhenyuw@linux.intel.com>
CC:     Sean Christopherson <seanjc@google.com>, <kvm@vger.kernel.org>,
        <intel-gfx@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        <intel-gvt-dev@lists.freedesktop.org>,
        Zhi Wang <zhi.a.wang@intel.com>
Subject: Re: [PATCH 03/27] drm/i915/gvt: Incorporate KVM memslot info into
 check for 2MiB GTT entry
Message-ID: <Y8jUom2voLubfqxE@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20221223005739.1295925-4-seanjc@google.com>
 <Y6vXTcxDNovrmeVB@yzhao56-desk.sh.intel.com>
 <Y7SaklDQD0EoIs8l@google.com>
 <Y7Y+759IN2DH5h3h@yzhao56-desk.sh.intel.com>
 <Y7cLkLUMCy+XLRwm@google.com>
 <Y7e3fT8/V2NoXAUP@yzhao56-desk.sh.intel.com>
 <Y7ioYegkgKIH8uJL@google.com>
 <Y7vlOCKkJ+QyO3EM@yzhao56-desk.sh.intel.com>
 <Y773+EB35bAchVTC@google.com>
 <Y8ix4lqk8QYH4g3h@zhen-hp.sh.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y8ix4lqk8QYH4g3h@zhen-hp.sh.intel.com>
X-ClientProxiedBy: KL1PR01CA0131.apcprd01.prod.exchangelabs.com
 (2603:1096:820:4::23) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CY8PR11MB6889:EE_
X-MS-Office365-Filtering-Correlation-Id: d88bc70d-b018-40f1-e5bd-08daf9e1168e
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CHeaB/hpEOn4Vb+SnpJTPTRhnkn2ZYgutinqmGPniwpGwiuAK3qqHXxU/NHQUD5aN/wfFU8QaUeED/MbEd2DD+Lfu8df+Tk2RsChPKEOHkB/3N0D0jD03IlQnkEIkhKBjMRqxsjyhfr4K6sgk4J8i1al+OX1cf/2mx8doc3l4cjTDGElJxdNaVbRaXooWHLOXLTuxZkUjj3WKB2/aqH/BBAPW9KxayV3zZcLGoFqdvcvkI+ABsrlDJO5RC3b+6fuoDcehXx6wb32712yZ8WGUfaiE4EwjHn3QET10w20hNOohJuK2HWpqT1cID7D/ldx20zLRhNcbYU+4hTvP1P+AC9FwnDJ8ylW8WnZRUPI+RxCkh9z7IwxQpWpWn7pnEn2cznU57jepcs6jVE3+Sqjq43298EYFPwSUcyJfTugWW1CrRq9qkBsj4ciIwkO6jiZ6bInkDRJ8/xhj2cuNkOoHlDq73d60HhxYRhD3AFohIxUEHcYmD4Uyg82KlHhfYghnTvSv68Y5VdMBvW7hc7qsy9mt8MwEbEzAHq626WVcRzf+D1rg9fdSH9BZfVKP7X3gPvkMAAwPrmD8gLrtXetLGUpDGiMCos2Da5n0OcVNdCpfE+EinKQfTQnGQKuaF1G
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(396003)(366004)(39860400002)(136003)(376002)(451199015)(66476007)(82960400001)(38100700002)(86362001)(8936002)(5660300002)(3450700001)(2906002)(66946007)(66556008)(4326008)(8676002)(6916009)(41300700001)(26005)(186003)(83380400001)(6512007)(53546011)(316002)(54906003)(6666004)(478600001)(6486002)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5iU78KU8GZROZHhTd/CU/o2R3M9SMbxlZOTmbL7coS/ehkKFR+YAqxH9dVpS?=
 =?us-ascii?Q?iSuWmJVwHKmSXs27KJi13i+aPfgKcY5sEL/klNDOpZ/739g/nQqNm+m3OLz2?=
 =?us-ascii?Q?zucV9AbHG/uYuX460FcFdWWG+xBvdo1iWGbprdBjbcPx9YK9yUJuvXGfe85j?=
 =?us-ascii?Q?hncxNGamYaXfHp+Eo+6b/4wVw/NqlT1M+g1F13cLbHONeMQPx1CCEXSRnvvF?=
 =?us-ascii?Q?UKloJmLgupG8wYw06wsi3vI6UvDEzN4zlyfpQSMrpV/sfmj3szSJFzY8lhNg?=
 =?us-ascii?Q?chUc6ZrAgS9Xv/9MH9wTNdQikUrC4Cq9VVvW8rW2vi7jTl4E6VHGr+anWtPD?=
 =?us-ascii?Q?yFodcwZ9/lPseQ1E9gkKaRwQw5DHX8uCWJNmrqhEAg8kEjFdy3rRb9YOiFSz?=
 =?us-ascii?Q?A7aRgP2pSifCP+uikUojPKVWnoIuUIoGJbR10cTJD9TJwXQX4CKaD9y5rfgu?=
 =?us-ascii?Q?qS/1eMzmJwqqQs9m+wAQHmXmXz/3lUp/bKJfKlVqAOLFgS9pFzMKTIwP79ue?=
 =?us-ascii?Q?xyD0UX5LhNJnOPsmmV7GgnAWIbKZwidjayz6+S9vbgtAbNnvADLr5txxUJyh?=
 =?us-ascii?Q?Fkz0HrSzePtOMmPtaT7gMD2Hd2Ek01bkpX6tiC67fZBKMxLaqYhnmWaqutaW?=
 =?us-ascii?Q?1g27zfzutM4gBxR0f2UKk9W4bbE0OoVKHzU5OWkzKs1km//KE/ibbmt8SRZL?=
 =?us-ascii?Q?H5gQf0y4BSxdqIqs3NWwxGEqvBLVCtaCFJY4eoGv/ICanczRCRN37g/fDWK6?=
 =?us-ascii?Q?KHorI8zA7eU35LkKypncvkDpC8ZBdxLO4cb9pvGav35TDqcjqwylo6yq9oH9?=
 =?us-ascii?Q?P0RXPdE+bwlzKbw6zPRCJs7hEFyMjzJvwiZp78CMCB8IBZ8n+3UyItCLXWL6?=
 =?us-ascii?Q?CdF4h1y+okqpoh9ysWbUJp9zpbaVkn2CGX0ljn/OGDWQ3he3NZT+I5iuqoIS?=
 =?us-ascii?Q?52nSbonELIAYs+a7it6oalqimi8ets1pVcnEonACXG2KPjp4v5shLPxPi38Y?=
 =?us-ascii?Q?Ld9xbEcBi7p4LSB5hSnGy/ICaWQicKM4aEg8fK1NFLD4fR9/OXOhO/oaAu7G?=
 =?us-ascii?Q?LvR3VyyZ3AG3DiqX05bpcXCG4v9LFDCt/vgeSTQWTz5bT8hGk5zEr9B4S+WD?=
 =?us-ascii?Q?KuNYLw1VoRxDrxQXYkX3KtqaswnCZ7V64v7EK6Inr6P5REkeR0b9IEduYYhK?=
 =?us-ascii?Q?lvNYTotiYTH+Wy+/rts3dKd4evXXzXU16/hCMJmmt8bnUZzr4dpYZlt6uUen?=
 =?us-ascii?Q?dsi4X3qOPIaJhPAjeGXJHEy5grqASEuiXMJt6926TBzMOBn37Fb8bAm+qRSd?=
 =?us-ascii?Q?sJpd7KeudWbrRNo765eeXZTEp8xOFhU3LZCNKSkDsd+t2iJ2G6TlgpnXH0oN?=
 =?us-ascii?Q?uWOCN2HLeNs11XDQ0zS5MREeKgpiow8mww7LBHLAvtzdGmz56j8lLfbV0weq?=
 =?us-ascii?Q?kzcT5GQ7nQ9EeoOYzt0m/D9zsBaRpLKMyNeGU57cqj0jjcxv15j4YaqbrmED?=
 =?us-ascii?Q?TO9JgZUe4rKsPt9mcuNa4ERayIY7EWryxnznXrcvlVpmxYyK1Qx7+KhccTAP?=
 =?us-ascii?Q?RZ1l4q8FZE2Li/dncPK7DjTPwlmmslspEC2At1nx?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d88bc70d-b018-40f1-e5bd-08daf9e1168e
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2023 05:50:36.9798
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +goYUEF7Mb9q5S1cFYAKaZRSa8YY1AZfoQsJfUYWyxvNrsVPxG9L8ZVV5ZUNaqXvs5mu2XtKMQq+sMuBYI6cMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB6889
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 19, 2023 at 10:58:42AM +0800, Zhenyu Wang wrote:
> On 2023.01.11 17:55:04 +0000, Sean Christopherson wrote:
> > On Mon, Jan 09, 2023, Yan Zhao wrote:
> > > On Fri, Jan 06, 2023 at 11:01:53PM +0000, Sean Christopherson wrote:
> > > > On Fri, Jan 06, 2023, Yan Zhao wrote:
> > > > > On Thu, Jan 05, 2023 at 05:40:32PM +0000, Sean Christopherson wrote:
> > > > > > On Thu, Jan 05, 2023, Yan Zhao wrote:
> > > > > > I'm totally fine if KVMGT's ABI is that VFIO is the source of truth for mappings
> > > > > > and permissions, and that the only requirement for KVM memslots is that GTT page
> > > > > > tables need to be visible in KVM's memslots.  But if that's the ABI, then
> > > > > > intel_gvt_is_valid_gfn() should be probing VFIO, not KVM (commit cc753fbe1ac4
> > > > > > ("drm/i915/gvt: validate gfn before set shadow page entry").
> > > > > > 
> > > > > > In other words, pick either VFIO or KVM.  Checking that X is valid according to
> > > > > > KVM and then mapping X through VFIO is confusing and makes assumptions about how
> > > > > > userspace configures KVM and VFIO.  It works because QEMU always configures KVM
> > > > > > and VFIO as expected, but IMO it's unnecessarily fragile and again confusing for
> > > > > > unaware readers because the code is technically flawed.
> > > > > >
> > > > > Agreed. 
> > > > > Then after some further thought, I think maybe we can just remove
> > > > > intel_gvt_is_valid_gfn() in KVMGT, because
> > > > > 
> > > > > (1) both intel_gvt_is_valid_gfn() in emulate_ggtt_mmio_write() and
> > > > > ppgtt_populate_spt() are not for page track purpose, but to validate bogus
> > > > > GFN.
> > > > > (2) gvt_pin_guest_page() with gfn and size can do the validity checking,
> > > > > which is called in intel_gvt_dma_map_guest_page(). So, we can move the
> > > > > mapping of scratch page to the error path after intel_gvt_dma_map_guest_page().
> > > > 
> > > > IIUC, that will re-introduce the problem commit cc753fbe1ac4 ("drm/i915/gvt: validate
> > > > gfn before set shadow page entry") solved by poking into KVM.  Lack of pre-validation
> > > > means that bogus GFNs will trigger error messages, e.g.
> > > > 
> > > > 			gvt_vgpu_err("vfio_pin_pages failed for iova %pad, ret %d\n",
> > > > 				     &cur_iova, ret);
> > > > 
> > > > and
> > > > 
> > > > 			gvt_vgpu_err("fail to populate guest ggtt entry\n");
> > > 
> > > Thanks for pointing it out.
> > > I checked this commit message and found below original intentions to introduce
> > > pre-validation:
> > 
> > ...
> > 
> > > (I actually found that the original code will print "invalid entry type"
> > > warning which indicates it's broken for a while due to lack of test in
> > > this invalid gfn path)
> > > 
> > > 
> > > > One thought would be to turn those printks into tracepoints to eliminate unwanted
> > > > noise, and to prevent the guest from spamming the host kernel log by programming
> > > > garbage into the GTT (gvt_vgpu_err() isn't ratelimited).
> > > As those printks would not happen in normal conditions and printks may have
> > > some advantages to discover the attack or bug, could we just convert
> > > gvt_vgpu_err() to be ratelimited ?
> > 
> > That's ultimately a decision that needs to be made by the GVT maintainers, as the
> > answer depends on the use case.  E.g. if most users of KVMGT run a single VM and
> > the guest user is also the host admin, then pr_err_ratelimited() is likely an
> > acceptable/preferable choice as there's a decent chance a human will see the errors
> > in the host kernel logs and be able to take action.
> > 
> > But if there's unlikely to be a human monitoring the host logs, and/or the guest
> > user is unrelated to the host admin, then a ratelimited printk() is less useful.
> > E.g. if there's no one monitoring the logs, then losing messages due to
> > ratelimiting provides a worse debug experience overall than having to manually
> > enable tracepoints.   And if there may be many tens of VMs (seems unlikely?), then
> > ratelimited printk() is even less useful because errors for a specific VM may be
> > lost, i.e. the printk() can't be relied upon in any way to detect issues.
> > 
> > FWIW, in KVM proper, use of printk() to capture guest "errors" is strongly discourage
> > for exactly these reasons.
> 
> Current KVMGT usage is mostly in controlled mode, either user is own host admin,
> or host admin would pre-configure specific limited number of VMs for KVMGT use.
> I think printk on error should be fine, we don't need rate limit, and adding
> extra trace monitor for admin might not be necessary. So I'm towards to keep to
> use current error message.
> 

Thanks, Sean and Zhenyu.
So, could I just post the final fix as below?
And, Sean, would you like to include it in this series or should I send it out
first?

From dcc931011da3712333f61684ebb20765dbf2fb46 Mon Sep 17 00:00:00 2001
From: Yan Zhao <yan.y.zhao@intel.com>
Date: Thu, 19 Jan 2023 11:15:54 +0800
Subject: [PATCH] drm/i915/gvt: remove interface intel_gvt_is_valid_gfn

Currently intel_gvt_is_valid_gfn() is called in two places:
(1) shadowing guest GGTT entry
(2) shadowing guest PPGTT leaf entry,
which was introduced in commit cc753fbe1ac4
("drm/i915/gvt: validate gfn before set shadow page entry").

However, now it's not necessary to call this interface any more, because
a. GGTT partial write issue has been fixed by
   commit bc0686ff5fad
   ("drm/i915/gvt: support inconsecutive partial gtt entry write")
   commit 510fe10b6180
   ("drm/i915/gvt: fix a bug of partially write ggtt enties")
b. PPGTT resides in normal guest RAM and we only treat 8-byte writes
   as valid page table writes. Any invalid GPA found is regarded as
   an error, either due to guest misbehavior/attack or bug in host
   shadow code.
   So,rather than do GFN pre-checking and replace invalid GFNs with
   scratch GFN and continue silently, just remove the pre-checking and
   abort PPGTT shadowing on error detected.
c. GFN validity check is still performed in
   intel_gvt_dma_map_guest_page() --> gvt_pin_guest_page().
   It's more desirable to call VFIO interface to do both validity check
   and mapping.
   Calling intel_gvt_is_valid_gfn() to do GFN validity check from KVM side
   while later mapping the GFN through VFIO interface is unnecessarily
   fragile and confusing for unaware readers.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 drivers/gpu/drm/i915/gvt/gtt.c | 31 -------------------------------
 1 file changed, 31 deletions(-)

diff --git a/drivers/gpu/drm/i915/gvt/gtt.c b/drivers/gpu/drm/i915/gvt/gtt.c
index 445afecbe7ae..9b6c2ca1ee16 100644
--- a/drivers/gpu/drm/i915/gvt/gtt.c
+++ b/drivers/gpu/drm/i915/gvt/gtt.c
@@ -49,22 +49,6 @@
 static bool enable_out_of_sync = false;
 static int preallocated_oos_pages = 8192;

-static bool intel_gvt_is_valid_gfn(struct intel_vgpu *vgpu, unsigned long gfn)
-{
-       struct kvm *kvm = vgpu->vfio_device.kvm;
-       int idx;
-       bool ret;
-
-       if (!vgpu->attached)
-               return false;
-
-       idx = srcu_read_lock(&kvm->srcu);
-       ret = kvm_is_visible_gfn(kvm, gfn);
-       srcu_read_unlock(&kvm->srcu, idx);
-
-       return ret;
-}
-
 /*
  * validate a gm address and related range size,
  * translate it to host gm address

@@ -1345,13 +1329,6 @@ static int ppgtt_populate_spt(struct intel_vgpu_ppgtt_spt *spt)
                        ppgtt_generate_shadow_entry(&se, s, &ge);
                        ppgtt_set_shadow_entry(spt, &se, i);
                } else {
-                       gfn = ops->get_pfn(&ge);
-                       if (!intel_gvt_is_valid_gfn(vgpu, gfn)) {
-                               ops->set_pfn(&se, gvt->gtt.scratch_mfn);
-                               ppgtt_set_shadow_entry(spt, &se, i);
-                               continue;
-                       }
-
                        ret = ppgtt_populate_shadow_entry(vgpu, spt, i, &ge);
                        if (ret)
                                goto fail;
@@ -2326,14 +2303,6 @@ static int emulate_ggtt_mmio_write(struct intel_vgpu *vgpu, unsigned int off,
                m.val64 = e.val64;
                m.type = e.type;

-               /* one PTE update may be issued in multiple writes and the
-                * first write may not construct a valid gfn
-                */
-               if (!intel_gvt_is_valid_gfn(vgpu, gfn)) {
-                       ops->set_pfn(&m, gvt->gtt.scratch_mfn);
-                       goto out;
-               }
-
                ret = intel_gvt_dma_map_guest_page(vgpu, gfn, PAGE_SIZE,
                                                   &dma_addr);
                if (ret) {
--
2.17.1


