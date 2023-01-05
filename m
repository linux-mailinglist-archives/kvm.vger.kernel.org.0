Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C91265E260
	for <lists+kvm@lfdr.de>; Thu,  5 Jan 2023 02:16:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230163AbjAEBPa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Jan 2023 20:15:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230388AbjAEBPR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Jan 2023 20:15:17 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDC3B30560;
        Wed,  4 Jan 2023 17:15:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672881315; x=1704417315;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=CgHiLBRqe5+V4mM6u9+0/Adr+slQVMK84ZykjGXX/eY=;
  b=cXLgY0sTVKh3k2M02tKNi4b17pKqd5nI3vyhrkLLCbc6nexzKmKAcVt4
   jUYr7OSAXjiFfpw1lNhASXAlZDhmebSuG1Odstsgy7gZ81lWAUZXLWDoj
   0axEXOMLmAXHcrTtWA2TodCYzIx8ihJteMDytycbiWkdfgwaQBVeeXmP4
   DnE8l4+rV0CdQjJUaxGroPaX4ekq+N4EXpa0b6Wkxj4wwDAmAjaJm+4VP
   P9ZN//yKlw8Cts/lIu5UwbUMfnWfo4y4kQMSvcP6/jR+5Cg4D54rvvn3b
   UbaCrDghVr1H9hxCLwRdEtMpqB/7+7deKJzdJeBxBckbICF0Guq4u+3qP
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10580"; a="320796251"
X-IronPort-AV: E=Sophos;i="5.96,301,1665471600"; 
   d="scan'208";a="320796251"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2023 17:15:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10580"; a="605360971"
X-IronPort-AV: E=Sophos;i="5.96,301,1665471600"; 
   d="scan'208";a="605360971"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga003.jf.intel.com with ESMTP; 04 Jan 2023 17:15:14 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 4 Jan 2023 17:15:14 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 4 Jan 2023 17:15:13 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 4 Jan 2023 17:15:13 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.102)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 4 Jan 2023 17:15:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PLmTCOd1rvwe9+P1QFAJQtbn8G5mHwjJ65RkaJ4ewgi43jX/tRXHhJVQ3B7dbTFGogop5v3kUJGStuF4lGhpE/6jFcYNOLtEJVw2awefDdgzmyWltb8/cxVyfc0YaajjwzHyO2fXle2PJygjJoZqKnXRVmWvDbwxfv44LAGL4y2YDuYdL0szpyF7wzAzNXDUVY+3MMUyKqX0METFsHnY7UDXy40JRsK6zOhbSR6dzIBEfr6nEhPCg4OLwB7Pwwyp3YlHPX6LStGRijGTkzMdU754wMPCNLPsZHc8p/fMfi8XAZkQA+zvOK6bBQTL/X/G1co2NhkB33deXfDcbUEyDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=13LufF/LO4sisMKwWjQGx14KrBlQuPhZE5vdBPIsFgs=;
 b=fzb1k8mFLo+61LEdoz/h4DY86hbxDBr4NveVB2R8EyeTIxjzDqVtCNwHt2S74OVHvWh14ph9mKjiTmAaFNWAM7NxXIWJPWuIyN7f675FPundhV93E027ZxH6UDDLn1ODJWoAu97st6yKXIWDCBuI8a+3EyudXjPk1R0FFfZ4PejF6PdIjfgjeiHtnYbxhP4kmQ58dSbDKdcnY64twiQOlRP5Ub6ae+lQvkPGbLTgwIuhSj4nTU0qby46Cx+/8e1DcV6Dqo4GQoySWkBYK1fPPqDmBULTZEyFk/b3QC/YNeVtN48j+j5o2Xi5gF35IQULAG0obezuSFo3q3ZnE3pipA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH7PR11MB6547.namprd11.prod.outlook.com (2603:10b6:510:211::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Thu, 5 Jan
 2023 01:15:04 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::bd50:2cf7:f362:3734]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::bd50:2cf7:f362:3734%8]) with mapi id 15.20.5944.019; Thu, 5 Jan 2023
 01:15:04 +0000
Date:   Thu, 5 Jan 2023 08:51:20 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>, <kvm@vger.kernel.org>,
        <intel-gvt-dev@lists.freedesktop.org>,
        <intel-gfx@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH 09/27] drm/i915/gvt: Protect gfn hash table with
 dedicated mutex
Message-ID: <Y7YfCKcalLkKnIV+@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20221223005739.1295925-1-seanjc@google.com>
 <20221223005739.1295925-10-seanjc@google.com>
 <Y6vOEjHZhOWulyo1@yzhao56-desk.sh.intel.com>
 <Y7STZZkd3EaRXLTC@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y7STZZkd3EaRXLTC@google.com>
X-ClientProxiedBy: SI1PR02CA0047.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::15) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH7PR11MB6547:EE_
X-MS-Office365-Filtering-Correlation-Id: 2d1b4cad-dded-4bdb-3e9d-08daeeba46a4
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: orgsNBEt2Bk3O91FU7SlgXYhHiuJByBk9jZzYDvejKrm7Hi0SrYXFILRsKJd3SyDas2y5AKX1d/VKnPF5/5+jzPmTN8oYJ3iifAhnSCMCruinl8lL4nD2uOG2UGh5MBF4MzWBBoWi0amjhufljxmF/LMXZAXOGmR02nQfw/NglJHqFHr7zfe8OsU840G/xkw3IV7n6NuDPx1ZBSu+jpzy1OTpDA5V0rkm7UQ4DBIq/pC0TAiOpjCqdB4EV1G8rB45wH8D5FHY7gfgG2UhspxjBIlaCwxeYQeTHD28PSVLf36n6DdPho0eOstSY1Dg5hqXIjpZ+J2jz0TSimmHFYTt4z8psd45SINPvF9sha/UP/q8/OMssbmuY0s9SOJdwHPsbLS/rVEBbuz4m4+eA5tX0TfnUJqYN4h8YEYjUvZ+HMcGR50DJP72nzTyZyZ7+nc+eWfSzcxg1Zo0BP7Gd4tlbwPQCwxo4flUbshNJAlZVu2heP+VoqJxC6pwRmcuFyveJMBHeTwPnBH4zzSSQjr2yr9VMejDJLA+O1zpXPBxpV/FAx8YfUEMPSAN4d/qaG4gFd9MaYQDa3EIGdoW8BStp7/Baaj5GnZsss5YNPSmp1FmdUZ5rBpD2YlalGZqmRiY7eNcTL24voztcr0PDQ6mg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(366004)(39860400002)(376002)(136003)(396003)(451199015)(4326008)(8676002)(66556008)(66946007)(41300700001)(54906003)(316002)(66476007)(2906002)(3450700001)(86362001)(82960400001)(5660300002)(38100700002)(6916009)(478600001)(6506007)(6486002)(8936002)(186003)(26005)(83380400001)(6666004)(6512007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?E+G25Zj6D3T0pnyc0AxyYRQSh58pGAxreMHtjwNcEuTIrC5bDIWoaempFS56?=
 =?us-ascii?Q?gT7+Wxs2e3oOQRXk89UmUJO68yJIONwQKz6EV8oWMkSbXmqzUHiubFb4qXbE?=
 =?us-ascii?Q?o5GZ4uMhlJgx4wBLXvisA4nLmfNXH3Ol6XwzpDyQo7XOvoCfiL4ke+2zvoz4?=
 =?us-ascii?Q?+Sgk+045eh1FsTcV3W84/YmYeXpQ+8brdbis03UmHeO2YeZBxFzXd80Vmuoo?=
 =?us-ascii?Q?I2NeizwSG4pB5Po7oDth7F+aYsaAuuSvfmr38sIt7I5uEbK/iH73dBNj/1jM?=
 =?us-ascii?Q?/3jLYIZpfo5S0751GDkj++E96UeY2o1Fe24zEsJyTDV7TEp9rdHuiij+8UtP?=
 =?us-ascii?Q?+2K0U0fA7SYCFG40KQKQdKx4dS2R0NOl8vWv9sKZiocdrMrhbAOsTaj97Rg/?=
 =?us-ascii?Q?gShH802Wf1Bv71R0fnjijDcDHsKagX4f3j11E3Mjb94t54xLNelSsKywZAd8?=
 =?us-ascii?Q?vCMa1C+cM51Fym/kXoDVucufRqcgb0epVJkBPsGpqAllNfxfg8pwZ9KHZBn/?=
 =?us-ascii?Q?Zg6rkoguNwTr5hgxla7zU2m2usY+WxEZn8Fr0S93ffOEkECFq5p0/dWPt7Q7?=
 =?us-ascii?Q?ptM/a8exLN0bZ2vKBOl93BRetkP5qcxduwWLKBSHv5DfkyQk1xg07TnAmKlU?=
 =?us-ascii?Q?PuczroridfXhdR7mKA0WNHXv3bWG1blnW3bistMETtXDNFMMl1UTQyggzw9i?=
 =?us-ascii?Q?8mETpgLFQQ9wxmHZ3HstXGSwZSDi6lxzdxVDzMSQ8U8vJ+4jBypQMYWtJM7e?=
 =?us-ascii?Q?TSWbSZ0hwJj/2xLIYroMf8DhlGs5qUZDfXPO/LolJ94DZjsmroJ5+pqAtWEh?=
 =?us-ascii?Q?4/B3SefIMiBiOEA6Wu2dqDPszTWtujvHsgZeKWhesPKTkTi4wPIPOHiHZCuF?=
 =?us-ascii?Q?LHpG7LI/tAd5rf3qHGoNVxKOsKfX4R1bfeanAkRiIP5FJcFS2kIx9RtaW6Ly?=
 =?us-ascii?Q?DBS1vRIOkleyhswDcb06pBZ2DfUSsEW/PmqSYE+sK29SVxt+6pjM5oO99njd?=
 =?us-ascii?Q?q7A0AYQINRYoHJk567S0xqVrcl9OzgDiDoOVxGlrH1FZByfn+MzY8wNrO0pi?=
 =?us-ascii?Q?VZbGNJA5W4zUbOoySJtjDXt2LZjEI3eDYdZshbN1ZNbwG0Vw7uXhte17NMUG?=
 =?us-ascii?Q?3sLBVGQG2bGL3fKJxnb71jzryFcLSEGmj9nvGJdQDcte1gTI7UriI4tf6pM6?=
 =?us-ascii?Q?+4lWGfCvpCBR+nhT6j4g4lVGN3SrgGcBC1IN8NKXEvo4lQ5Oto8fz1m2j9Dx?=
 =?us-ascii?Q?Sk1UXeKMDGWTBP68bSE47hMcdqYQi7OKBZwc7n9XRXx7YAma0pDNQgpQtEjp?=
 =?us-ascii?Q?vKKePYRK8ePlJzDFhnAgs2cjY3SuX5szj31E3H0AcmJByll9rEIB6I2sutFF?=
 =?us-ascii?Q?T05hB5P4KdjdQGPueicgzIRuhh+dHXvZ8vU2MprR/h5dhKT36u61j2RErOLz?=
 =?us-ascii?Q?WRY6fr/GEpftbypeY/KGA8QF6W+DrFpPrtmPsRVsG2auk7w9fA/JKEZCUjZh?=
 =?us-ascii?Q?bCoDzyHTfIiv6nZr1qLNk4Hv0ZcPy5DIEoesj1JwMZ8Q0tsrfVEBtDlwkBMX?=
 =?us-ascii?Q?sPkKWNZ1xQSRTMyFziyx+/NIA9LEn5LGbA7zUnCL?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d1b4cad-dded-4bdb-3e9d-08daeeba46a4
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2023 01:15:04.5186
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K+HRXSQlEMS8k/8WkwFHdvHWkkDuzo48HS58STnlbFT8z/B+3M/gTJbVQgIvxHAKgJglbaMWAgBw2JNOrF1T3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6547
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 03, 2023 at 08:43:17PM +0000, Sean Christopherson wrote:
> On Wed, Dec 28, 2022, Yan Zhao wrote:
> > On Fri, Dec 23, 2022 at 12:57:21AM +0000, Sean Christopherson wrote:
> > > Add and use a new mutex, gfn_lock, to protect accesses to the hash table
> > > used to track which gfns are write-protected when shadowing the guest's
> > > GTT.  This fixes a bug where kvmgt_page_track_write(), which doesn't hold
> > > kvm->mmu_lock, could race with intel_gvt_page_track_remove() and trigger
> > > a use-after-free.
> > > 
> > > Fixing kvmgt_page_track_write() by taking kvm->mmu_lock is not an option
> > > as mmu_lock is a r/w spinlock, and intel_vgpu_page_track_handler() might
> > > sleep when acquiring vgpu->cache_lock deep down the callstack:
> > > 
> > >   intel_vgpu_page_track_handler()
> > >   |
> > >   |->  page_track->handler / ppgtt_write_protection_handler()
> > >        |
> > >        |-> ppgtt_handle_guest_write_page_table_bytes()
> > >            |
> > >            |->  ppgtt_handle_guest_write_page_table()
> > >                 |
> > >                 |-> ppgtt_handle_guest_entry_removal()
> > >                     |
> > >                     |-> ppgtt_invalidate_pte()
> > >                         |
> > >                         |-> intel_gvt_dma_unmap_guest_page()
> > >                             |
> > >                             |-> mutex_lock(&vgpu->cache_lock);
> > > 
> > This gfn_lock could lead to deadlock in below sequence.
> > 
> > (1) kvm_write_track_add_gfn() to GFN 1
> > (2) kvmgt_page_track_write() for GFN 1
> > kvmgt_page_track_write()
> > |
> > |->mutex_lock(&info->vgpu_lock)
> > |->intel_vgpu_page_track_handler (as is kvmgt_gfn_is_write_protected)
> >    |
> >    |->page_track->handler() (ppgtt_write_protection_handler())
> >       |	
> >       |->ppgtt_handle_guest_write_page_table_bytes()
> >          |
> >          |->ppgtt_handle_guest_write_page_table()
> > 	    |
> > 	    |->ppgtt_handle_guest_entry_add() --> new_present
> > 	       |
> > 	       |->ppgtt_populate_spt_by_guest_entry()
> > 	          |
> > 		  |->intel_vgpu_enable_page_track() --> for GFN 2
> > 		     |
> > 		     |->intel_gvt_page_track_add()
> > 		        |
> > 			|->mutex_lock(&info->gfn_lock) ===>deadlock
> 
> Or even more simply, 
> 
>   kvmgt_page_track_write()
>   |
>   -> intel_vgpu_page_track_handler()
>      |
>      -> intel_gvt_page_track_remove()
>
yes.

> > 
> > Below fix based on this patch is to reuse vgpu_lock to protect the hash table
> > info->ptable.
> > Please check if it's good.
> > 
> > 
> > diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
> > index b924ed079ad4..526bd973e784 100644
> > --- a/drivers/gpu/drm/i915/gvt/kvmgt.c
> > +++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
> > @@ -364,7 +364,7 @@ __kvmgt_protect_table_find(struct intel_vgpu *info, gfn_t gfn)
> >  {
> >         struct kvmgt_pgfn *p, *res = NULL;
> > 
> > -       lockdep_assert_held(&info->gfn_lock);
> > +       lockdep_assert_held(&info->vgpu_lock);
> > 
> >         hash_for_each_possible(info->ptable, p, hnode, gfn) {
> >                 if (gfn == p->gfn) {
> > @@ -388,7 +388,7 @@ static void kvmgt_protect_table_add(struct intel_vgpu *info, gfn_t gfn)
> >  {
> >         struct kvmgt_pgfn *p;
> > 
> > -       lockdep_assert_held(&info->gfn_lock);
> > +       lockdep_assert_held(&info->vgpu_lock);
> 
> I'll just delete these assertions, the one in __kvmgt_protect_table_find() should
> cover everything and is ultimately the assert that matters.
> 
> > @@ -1629,12 +1629,11 @@ static void kvmgt_page_track_remove_region(gfn_t gfn, unsigned long nr_pages,
> >         struct intel_vgpu *info =
> >                 container_of(node, struct intel_vgpu, track_node);
> >  
> > -       mutex_lock(&info->gfn_lock);
> > +       lockdep_assert_held(&info->vgpu_lock);
> 
> This path needs to manually take vgpu_lock as it's called from KVM.  IIRC, this
> is the main reason I tried adding a new lock.  That and I had a hell of a time
> figuring out whether or not vgpu_lock would actually be held.
Right. In the path of kvmgt_page_track_remove_region(),
mutex_lock(&info->vgpu_lock) and  mutex_unlock(&info->vgpu_lock) are
required.

static void kvmgt_page_track_remove_region(gfn_t gfn, unsigned long nr_pages,
                                           struct kvm_page_track_notifier_node *node)
{
        unsigned long i;
        struct intel_vgpu *info =
                container_of(node, struct intel_vgpu, track_node);

        mutex_lock(&info->vgpu_lock);
        for (i = 0; i < nr_pages; i++) {
                if (kvmgt_gfn_is_write_protected(info, gfn + i))
                        kvmgt_protect_table_del(info, gfn + i);
        }
        mutex_unlock(&info->vgpu_lock);
}

The reason I previously could have lockdep_assert_held(&info->vgpu_lock) passed
is that I didn't get LOCKDEP configured, so it's basically a void.
(sorry, though I actually also called mutex_is_locked(&info->vcpu_lock)
in some paths to check lockdep_assert_held() worked properly. But it's my
fault not to double check it's compiled correctly).


> 
> Looking at this with fresh eyes, AFAICT intel_vgpu_reset_gtt() is the only other
> path that can reach __kvmgt_protect_table_find() without holding vgpu_lock, by
> way of intel_gvt_page_track_remove().  But unless there's magic I'm missing, that's
> dead code and can simply be deleted.
Yes, I found intel_vgpu_reset_gtt() has not been called since
ba25d977571e1551b7032d6104e49efd6f88f8ad.



