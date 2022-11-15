Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0931628F51
	for <lists+kvm@lfdr.de>; Tue, 15 Nov 2022 02:32:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236120AbiKOBcF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Nov 2022 20:32:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231799AbiKOBb5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Nov 2022 20:31:57 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE79A6555;
        Mon, 14 Nov 2022 17:31:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668475895; x=1700011895;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=KaT9o/ttzfouIACWirut3uCAiSUvyAPsI+b3uC3k/YY=;
  b=hRoc8KbKp1FX4NathNwQ/2T5jBaQ2J1L1BKW1EbQedU7g6YkU+eMzJzg
   ICytqyQIniXpG1vKonlvlY9dvtEh76AwLReReSiWA0KDKXJLTBmjLbcCo
   Tf+jUnrEiiFNac7k3l+x54fDyYoRnqOHaSgtqjXjvQPqpWaLepdb+fj8L
   exm5DG2xP1mMO6jvYDk4VsR32g/NMU7j5+xt0O+MtV0uLoCr68kYwa2Jl
   tF0ld9iikI5lS72tOx+x8F+cdukhqXVad8TC0NeH4mmFb8pScCfMPJpNa
   UzMOPR7D8Fj56pVyLCS5iNqhs8q9XaXUaSIid2Y+3t+k8hzoSJXMNoefh
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="309757907"
X-IronPort-AV: E=Sophos;i="5.96,164,1665471600"; 
   d="scan'208";a="309757907"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 17:31:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="616554260"
X-IronPort-AV: E=Sophos;i="5.96,164,1665471600"; 
   d="scan'208";a="616554260"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga006.jf.intel.com with ESMTP; 14 Nov 2022 17:31:35 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 14 Nov 2022 17:31:34 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 14 Nov 2022 17:31:34 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 14 Nov 2022 17:31:34 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.170)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 14 Nov 2022 17:31:31 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TbZ2U9hBB41LuyKsb07n+tsxNk0X8hszIqalrdg045k6zmgyt9Wg0dJ8Yk5nzQD0eEYGvvK0INaPRZGv5ff+fcC8punWhC6QN+yx8RJEImgYgCsAstwZ3m3tKGLi+gI0akQykeQ38RnrOigYT4elfNJXDIUOJEZ/93paMxWVaahQdIfwOFpVMoBbUV3/BhcbdO1l2LItSkNk49BS/Yiz6fye6FNky9VE3PjtMw2Eji+eR5mY+OzTZn/Ah1By7UMlPqtJpHcuLMH/IJI+d2+kqCZ+jMgeKalJeRM4mLfQp8jW88QNgrdFpfOVm+tUwREK7HSuy74MU8mzRe2sAfUDLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r71uB4xp1dW1m402KMb6Amp6Juy4YKRqYML20j4g2F4=;
 b=KlOJK80wq7E1RmiOQGDGSm+BydIXiZMpWP7UnobsozGLoFDWG+g25F6/e2Nqq2z7eyCsklg/vvRpL/WX0/vvgokq/zxM1MU/4BM3i8tjTKodQXKVoFl81UqH7UbNJeKYXV4Oad+oFet7cl1XqGDMrMTWhpIln3rjeindf6y7WW4wmGAgS8QbIfFuVB9eK3x5aUgLhmtkmCyJ6hM9BcQ/iF7fmb6/TKPOQjIbjkJrPcgJfG0fmvxrI+JRQxs2+/0nzNgbGcrg7pIQKABCQOHNdninhYjWSNCl1KSsDG/iJ4o5P58YPCuY6jj2lETK/B3mj697e69zUsgCmW389EzWNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DM4PR11MB6408.namprd11.prod.outlook.com (2603:10b6:8:b7::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5813.17; Tue, 15 Nov 2022 01:31:26 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::dc06:6d36:dc8a:fe7f]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::dc06:6d36:dc8a:fe7f%7]) with mapi id 15.20.5813.017; Tue, 15 Nov 2022
 01:31:26 +0000
Date:   Tue, 15 Nov 2022 09:08:38 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <pbonzini@redhat.com>, <intel-gfx@lists.freedesktop.org>,
        <intel-gvt-dev@lists.freedesktop.org>, <zhenyuw@linux.intel.com>
Subject: Re: [PATCH v2 1/3] KVM: x86: add a new page track hook
 track_remove_slot
Message-ID: <Y3LmloAFnNpHDumV@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20221111103350.22326-1-yan.y.zhao@intel.com>
 <Y26SI3uh8JV0vvO6@google.com>
 <Y27ivXea5SjR5lat@yzhao56-desk.sh.intel.com>
 <Y27sG3AqVX8yLUgR@google.com>
 <Y3GUdqxnPJvc6SPI@yzhao56-desk.sh.intel.com>
 <Y3JtonYdDYOhbmfG@google.com>
 <Y3LEZXWqk6ztuf7x@yzhao56-desk.sh.intel.com>
 <Y3LOIKueyTUoJ00B@google.com>
 <Y3LNplTrOpJdxyEW@yzhao56-desk.sh.intel.com>
 <Y3Ljjji0Bwt5+WxH@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y3Ljjji0Bwt5+WxH@google.com>
X-ClientProxiedBy: SG2P153CA0033.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::20)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DM4PR11MB6408:EE_
X-MS-Office365-Filtering-Correlation-Id: 536fd2a4-0319-48c7-1707-08dac6a91cf7
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j8zPPtEfSOyeCVA6gHqC+CYaKaqiUUqonz2+J1Sf4tz8pLNlAQte+57UWeCkOwCSjUenLwOUuPO+XWURmpFQohifPfYueeHvlmszdFBRP6Lb55zJAXm29zUYB0JuCHTKskx9AP5/INFM4OVxignpYhQ64fSltNM4h4SsxGbh51QWH3li7B8RyTYM2zosv8xnGGmyt1SZZmrUi2Zr/Vg5xKKxopQjswy9ZQJsOTWLMRcGNt50BRsNo6TaZglUJ9vCQfpuf+Q4IXbyweYISlacW77Qe5WkNM+/rl9MIeWbt4JsL5w5sioqzzOOBH1qKxWsghqOwxHFoerUd45esiiZsL3Cq8EVaLt/Wd6PPp/osS2xSSibx9nU+MVY+Gz0qmNSCggrsRXA3vsXT9pTME5+H5Mqxbcmnw3rUN6OlwUVhQ7T56VIk42MkC03UEIE3fFeDTua3+DabzmzTYdFEDQyIG8taFQPAOXiG74XGOpVBFagTclKbIrKvxvbNX9iPTDV+B65Ru1RazoJAUPzYez+xa4Sg10s+gPByQKcxDpSRRltg8gG4/0x9GxcunHamHmZ7VVEok80WJCPnsBpvEN0r9UUxL7PbQ00SUKXARkn+v48seyTJOGLTYRziH1OzoPwPA/HTTfTiNUckdRtBgNFmcTsW/ulqhnFD6TcqaBVs2KgYnNRuhufA7gmm5N0loX+rPzAIZAgkA2oPGrcWHPZvg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(346002)(376002)(396003)(366004)(136003)(451199015)(8936002)(3450700001)(5660300002)(8676002)(66476007)(66556008)(41300700001)(4326008)(66946007)(6916009)(316002)(6486002)(6506007)(6666004)(6512007)(26005)(478600001)(186003)(2906002)(83380400001)(38100700002)(86362001)(82960400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GsK4kqwLDD1t6B9twv2gq2i6WlgcHa1+injvj8pGuSt9AejwvFplr682e0ad?=
 =?us-ascii?Q?wEb9EDN+mTo4a2e1R2Qp1GwYy5CKZs7UgvyYG6l65aJ1caJizd8UZeSxPYzD?=
 =?us-ascii?Q?1H9oTRKA5jZpKIB380QdJovY66Qt4fLJcJZ20In8SdlALtvs/BRbyC+i9zpV?=
 =?us-ascii?Q?SwcBXfg+jOrbqkKXAI+skdmGEfsOdIf24hKQto+EYp+kcHw33/7kBYreuNo3?=
 =?us-ascii?Q?Cw/mawja2wiTVe5bZjHTA6o4qdvWtedI59zHvlJg1XVPTtsvJdyTHL16g00v?=
 =?us-ascii?Q?rmM4nN2J1q/jHOrz2hReAdo3O2SXtqpq/JjbLEuPrQ3Dzq61a7hPli77pd/A?=
 =?us-ascii?Q?LBM609H/vjC4VX3nPANIcvcKq9zfryj0S2V7PNGWcnCkwP+EwnIzdnr8tvGy?=
 =?us-ascii?Q?Tfv09+Z3kPAUBZlgU53j4CZ12BPdBjGeHEue7yUbQq9k2P9vj1C6nOzKsCQk?=
 =?us-ascii?Q?on3Kang/qnn/sr+i++5KWIaULQO7ky3JoR5YcUHLhFoYiFoFwlHtea9DTwYV?=
 =?us-ascii?Q?GnvRTTl4vYWsHcGSnPDaIiOUl00iisxI+iXoRbHfDzAjQpI3p3RYe8ev5cBS?=
 =?us-ascii?Q?nk4lCudIclSQDnpnxpNeLIKCamA7iVbeVJtR4hCZD3dMQ74EjRb8M6hdDltW?=
 =?us-ascii?Q?OX8sgDCgEpGMkELxnHVCqtH4x8vQ8odDeAJZaCtqTaQ5r8PTKZKcYCDGhj0r?=
 =?us-ascii?Q?C+3xPMw2LRWIkXm5eznjtXAyHLwj+L6BvbhuG2rWe2KddomHtelDdQ3XJqxj?=
 =?us-ascii?Q?t6vUUkheBSQGB5J6kDDH7IpPlLl+L6rSu9AdVozED//5UxvpgkGUVnJxW4Cs?=
 =?us-ascii?Q?dDhp23srhhd9VlSX7WjQk/04yZ7MsMmK6tKxnGVssE+I+yRnnMCw3NgIqMA2?=
 =?us-ascii?Q?vx7BHr6Iz0I01P2iSyLrB89bslViXNlQ18jaAZ8IWlC/Gmls1Nki8VymrgVZ?=
 =?us-ascii?Q?4WWt1QNUrGzB3gz+7Hd1/Tj/gl2Hdoh00nPseYnqAT+zN8LDJ5BL7xOwo9ef?=
 =?us-ascii?Q?TMtX420ZuAHgx07q7vmzoxTVE84UiJuOejoZgNtz/nZgCLxfGlUpwTo0Z/8Z?=
 =?us-ascii?Q?OkZafDg1irb1eXmiwcftN+FPbO657F5yZrX7N649qQ9PKLwlH7tzCz4OziRy?=
 =?us-ascii?Q?A6HCvFIn9N2E8MS2vfVget9ahhTon286Buj7avISHBWFKa72MxeBZWury6GM?=
 =?us-ascii?Q?u/TLx+TqubPjy4myGZkZLK+Ag+s3WBnesVMzv2Z19IMYMlwCY3CgMKyrt24E?=
 =?us-ascii?Q?U9DJWY9jb6re17yeLGz+6rXVE+g8G8DXSKGYfyNqsmpth6nefi531XDpjaca?=
 =?us-ascii?Q?JrmP7jQBWg0xj3Bz5zUigdRLFoGdzqMYwWH8VefUHHR4B+9IXeDQS6S2luFM?=
 =?us-ascii?Q?z7HvdKPEc4F8NCpwvJmsByYwinQFMNki4aBgTfNkwRNQ+FdCIZIwm+jRkFp+?=
 =?us-ascii?Q?FkycnG0IlDfRePHfpiazArrzOGbZv9eqjGQYncdHmgLVG20jDe8pTwbYlsHC?=
 =?us-ascii?Q?K+FWpChiT+uiPEDwqN9UTq8jIySYx6YEIvEClBb6HDoKJ3xh8LtrxPlhjOyM?=
 =?us-ascii?Q?WpciUHihAx3tmTRb7FZdiFxUjS2cI/lvLUI7Aj5lEB1ZHn4YuXMJY8OincCw?=
 =?us-ascii?Q?Kg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 536fd2a4-0319-48c7-1707-08dac6a91cf7
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2022 01:31:26.5324
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 20xYvDTE+O1KN/v1SX/7JBisSDCAtaj8KxyKDzweVLGZ9FhpBiSiPO5i7nw0N0czAudry6zXDuXdxCchqazShg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6408
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 15, 2022 at 12:55:42AM +0000, Sean Christopherson wrote:
> On Tue, Nov 15, 2022, Yan Zhao wrote:
> > On Mon, Nov 14, 2022 at 11:24:16PM +0000, Sean Christopherson wrote:
> > > On Tue, Nov 15, 2022, Yan Zhao wrote:
> > > > On Mon, Nov 14, 2022 at 04:32:34PM +0000, Sean Christopherson wrote:
> > > > > On Mon, Nov 14, 2022, Yan Zhao wrote:
> > > > > > On Sat, Nov 12, 2022 at 12:43:07AM +0000, Sean Christopherson wrote:
> > > > > > > On Sat, Nov 12, 2022, Yan Zhao wrote:
> > > > > > > > And I'm also not sure if a slots_arch_lock is required for
> > > > > > > > kvm_slot_page_track_add_page() and kvm_slot_page_track_remove_page().
> > > > > > > 
> > > > > > > It's not required.  slots_arch_lock protects interaction between memslot updates
> > > > > > In kvm_slot_page_track_add_page() and kvm_slot_page_track_remove_page(),
> > > > > > slot->arch.gfn_track[mode][index] is updated in update_gfn_track(),
> > > > > > do you know which lock is used to protect it?
> > > > > 
> > > > > mmu_lock protects the count, kvm->srcu protects the slot, and shadow_root_allocated
> > > > > protects that validity of gfn_track, i.e. shadow_root_allocated ensures that KVM
> > > > > allocates gfn_track for all memslots when shadow paging is activated.
> > > > Hmm, thanks for the reply.
> > > > but in direct_page_fault(),
> > > > if (page_fault_handle_page_track(vcpu, fault))
> > > > 	return RET_PF_EMULATE;
> > > > 
> > > > slot->arch.gfn_track is read without any mmu_lock is held.
> > > 
> > > That's a fast path that deliberately reads out of mmu_lock.  A false positive
> > > only results in unnecessary emulation, and any false positive is inherently prone
> > > to races anyways, e.g. fault racing with zap.
> > what about false negative?
> > If the fast path read 0 count, no page track write callback will be called and write
> > protection will be removed in the slow path.
> 
> No.  For a false negative to occur, a different task would have to create a SPTE
> and write-protect the GFN _while holding mmu_lock_.  And then after acquiring
> mmu_lock, the vCPU that got the false negative would call make_spte(), which would
> detect that making the SPTE writable is disallowed due to the GFN being write-protected.
> 
> 	if (pte_access & ACC_WRITE_MASK) {
> 		spte |= PT_WRITABLE_MASK | shadow_mmu_writable_mask;
> 
> 		/*
> 		 * Optimization: for pte sync, if spte was writable the hash
> 		 * lookup is unnecessary (and expensive). Write protection
> 		 * is responsibility of kvm_mmu_get_page / kvm_mmu_sync_roots.
> 		 * Same reasoning can be applied to dirty page accounting.
> 		 */
> 		if (is_writable_pte(old_spte))
> 			goto out;
> 
> 		/*
> 		 * Unsync shadow pages that are reachable by the new, writable
> 		 * SPTE.  Write-protect the SPTE if the page can't be unsync'd,
> 		 * e.g. it's write-tracked (upper-level SPs) or has one or more
> 		 * shadow pages and unsync'ing pages is not allowed.
> 		 */
> 		if (mmu_try_to_unsync_pages(vcpu->kvm, slot, gfn, can_unsync, prefetch)) {
> 			pgprintk("%s: found shadow page for %llx, marking ro\n",
> 				 __func__, gfn);
> 			wrprot = true;
> 			pte_access &= ~ACC_WRITE_MASK;
> 			spte &= ~(PT_WRITABLE_MASK | shadow_mmu_writable_mask);
> 		}
> 	}
> 
> 
> 
> int mmu_try_to_unsync_pages(struct kvm *kvm, const struct kvm_memory_slot *slot,
> 			    gfn_t gfn, bool can_unsync, bool prefetch)
> {
> 	struct kvm_mmu_page *sp;
> 	bool locked = false;
> 
> 	/*
> 	 * Force write-protection if the page is being tracked.  Note, the page
> 	 * track machinery is used to write-protect upper-level shadow pages,
> 	 * i.e. this guards the role.level == 4K assertion below!
> 	 */
> 	if (kvm_slot_page_track_is_active(kvm, slot, gfn, KVM_PAGE_TRACK_WRITE))
> 		return -EPERM;
> 
> 	...
> }

Oh, you are right! I thought mmu_try_to_unsync_pages() is only for the
shadow mmu, and overlooked that TDP MMU will also go into it.

Thanks for the detailed explanation.

Thanks
Yan
