Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDE58626602
	for <lists+kvm@lfdr.de>; Sat, 12 Nov 2022 01:26:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233734AbiKLA0U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Nov 2022 19:26:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229991AbiKLA0S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Nov 2022 19:26:18 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A25B110057;
        Fri, 11 Nov 2022 16:26:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668212777; x=1699748777;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=jyWt1ulDlk+u8wllfwU3czFKl+gWp1kuZ2fZm+D+6/w=;
  b=bJASGxd02n8c15wwxPF/gpvJbOyhRj6sscbKQJLA1/i/IvFa48D04OEe
   vwH2l3Yw0Sac+uYa8pBsqlXbPwyBdCCK1nMUsM10ZTScqjaGJI1VRx1Zl
   jNkWs0/HsU8yvLhPy8D3PStDKt879dyPH2OpQ2wlV4LAe0Qr8syTY8+Ae
   +L/8aaoWD3P9yir3/iPb9hh8p1yVlCeSxEjeR87aVfyGWLTRAIjrd4bd5
   uW9Nhgt5EpctDjcnnz4yVCBNclwl2M+0ZBbJJurfFsHvvzWInZD/2wseR
   mM8fcY0jlBoMEcX5aJJMldGs4B4QRv3UTCZWnFBg0Xu/zJcERqrvdvseZ
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10528"; a="311688310"
X-IronPort-AV: E=Sophos;i="5.96,157,1665471600"; 
   d="scan'208";a="311688310"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2022 16:26:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10528"; a="780319952"
X-IronPort-AV: E=Sophos;i="5.96,157,1665471600"; 
   d="scan'208";a="780319952"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga001.fm.intel.com with ESMTP; 11 Nov 2022 16:26:12 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 11 Nov 2022 16:26:12 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 11 Nov 2022 16:26:11 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Fri, 11 Nov 2022 16:26:11 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.177)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Fri, 11 Nov 2022 16:26:07 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WMHlQ//GXVdgLUw6TznYA+wB4O4tpD3H9KkgzB1t6uGrq5YvIXM2gX98KRZDQhxnWMeAS4vrQ/kDBVut07IoB9FwfbEPLwdm3+I74D5KwryX41soOHZjhUbcvLh89ztjtDnUGIvz8WjHErmHtxN74XhZPJrhQ9hShHg2ujZ/tY9yRqBJx4rHbcuKttqzC1BI18Kk4JsXmj2Y5CGv2E0EEhW1zlPV/7j/Ze9DzYN0mw1iyMmdnbVsPM/XvNHiy4C2hi4u8FJFB6PZiPD2x/qolwCU/wTAyk5cSrDC+XvLAySbaSe7sekxKdakWtXylI+XihloSnByvQ4msPYWwGyjQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w12E4+oFcLakeM6M9q9mIrPG5Wq911Rjkv0eeW87txE=;
 b=kwMFEXPwiTQfm/BDDNNZst9xDJdCTQOC1S2JnYGH94W8+PlWhZg7m6EDm+l6fGiPfDFchiWX4J574JehrbiU3f3RIGALeCz7Ej9tRQWVg0Qj2nIStd2IzA0Yda0ol/qteqzLMcnk87hiFY1GEbrQrQwmJNCZ8e9H9Cu/M3ybWn07HBtfD/mOlDFjUDLMmwYV1UFXx8i03W12Tq0CUx8030GZVo6oEnmFPEEigMlf0Kbz8d1VXC3OrEe666+WYBJQJfFb96VPuGVRex29UUN+yaD0rOVqjhZ8V1hoYpA2X/OPgiiOqJXBpu5EBFCmZTkNB2V/Uo03k7k0fzwhJsvWFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH0PR11MB4869.namprd11.prod.outlook.com (2603:10b6:510:41::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5813.13; Sat, 12 Nov 2022 00:26:00 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::dc06:6d36:dc8a:fe7f]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::dc06:6d36:dc8a:fe7f%7]) with mapi id 15.20.5813.016; Sat, 12 Nov 2022
 00:26:00 +0000
Date:   Sat, 12 Nov 2022 08:03:09 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <pbonzini@redhat.com>, <intel-gfx@lists.freedesktop.org>,
        <intel-gvt-dev@lists.freedesktop.org>, <zhenyuw@linux.intel.com>
Subject: Re: [PATCH v2 1/3] KVM: x86: add a new page track hook
 track_remove_slot
Message-ID: <Y27ivXea5SjR5lat@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20221111103247.22275-1-yan.y.zhao@intel.com>
 <20221111103350.22326-1-yan.y.zhao@intel.com>
 <Y26SI3uh8JV0vvO6@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y26SI3uh8JV0vvO6@google.com>
X-ClientProxiedBy: SI2PR04CA0009.apcprd04.prod.outlook.com
 (2603:1096:4:197::8) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH0PR11MB4869:EE_
X-MS-Office365-Filtering-Correlation-Id: 475559e1-ff94-4697-a837-08dac4447951
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DZzvC8EePnioNhE54psWYWWCXZ/eBMOWHsdTM47rM0zBE3s0cMSqUY6yZ3I3N5gjXz2ibhC4RF53Au1/f4gZ6U9cT/EmtdO2lbQdWEk502vQlHSRmJyg0y0Jzy+/k7DcSLDQ7SC9EkjbDwIWtZ52roeqMIncOayDW5ObOZ5Qjce3ifiP0+SSkWgAfSu4KT+fLVYVw4YMgAv4D4kZlKVPzvV7CB7o0HtqABCdoSJrw2vm/LkTBYrpuaqRuHVqrCDQ5n5kou9Zzw2lf1LSExKQIa/HDIUO2V5cUMCGzmLJbFn2JT11q4YLHrZ5rWUMfBgvl6cuPK6IFLzH72y0HbjO8+3aPZ9swzTtBUnS/NKitbXeElY2tZvONtdT4P3DeBWIaa+hW6HZ7sNZ4f7qMjUsHlOI1Gdenls0wWvlgR4hHpVOOot9vsc3y2oKNOFFp492sHkErA5Xua8wj4uKWFmiWV6uFBHhyC+CWzTCUkJAcQv+iBI9hhY6ZUJGmkCG/BKX7Bf1pV8YdWFjAnOond6o8HIQc3FoGpk36ey80kiil3XHgeOGsxj9m08hk6XD7QDpGBgbp7VypZXP4tE9i2gw+iprIz0mHmMbp024kfvmSSiRZUZrmQRjadhkUkV+cd1yCRSEzW0Hq+qyepsGf1cytO+4+fVcmKyCdJ1eOYVZzu3Ha0YQneWDMDNBWdZwk6Vdb7VFBU0MDTZxjQ9/GyMK/A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(396003)(136003)(366004)(376002)(39860400002)(451199015)(6512007)(26005)(8936002)(41300700001)(82960400001)(38100700002)(8676002)(3450700001)(83380400001)(186003)(6506007)(6916009)(66556008)(2906002)(66476007)(5660300002)(66946007)(4326008)(86362001)(478600001)(316002)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?B6CMspXKpgDzahmTNugRqxyfc44F30gIcTK+rewiLYXMF3l8ZLPJPp8WJaA5?=
 =?us-ascii?Q?rg/sJUFLTFAN3/mZtzs8SypdpZU9uwHmQQJUcbLAjw9uKKDiMCAd1G5mPXrd?=
 =?us-ascii?Q?6SNwSWW9Ql1k9gLoye5218q4jfWFBubi8R+9LSBlvTB1eJ6V2FujyhJNsZJG?=
 =?us-ascii?Q?xe2qx7c0G3OSy+xRPFK9fWNt98ra5AixImY2EQy08huikDlFof/uTB85JUSB?=
 =?us-ascii?Q?csUXTexFp6y8fgwRQ7FRG0xrzJZ+HEeQaQwJJCE//tf9L5tKTrRHth1vK0v1?=
 =?us-ascii?Q?P+ZmiByMQ7SePx5Vcli45hILOnezeCSpYE76Wicz/nVX7pGsSn2/6CU/GKV6?=
 =?us-ascii?Q?qDIgJLp7i699K/QPiBk3FInpU9Mdom9drBEyAG9O0uu+G8E25P+oBqL9ysIn?=
 =?us-ascii?Q?WoHgQwnvJnziT/nuqcIuWwtUBFeDtSHLCbPHLqHp3OS8XTp16kgQwKQWwYLU?=
 =?us-ascii?Q?OQI7BE2h39+noiZi33h/s8gdRpmACUefWjVl6BzwCEbQPnVE0aGlzeGXniUF?=
 =?us-ascii?Q?QeZ4xRIH3n/XmHCuRFJRtvZl09VEdIBTNr9NTexSiRH2bI7beOUrZU6J/4cA?=
 =?us-ascii?Q?nRCrcUvaFcL1IAKZcFcLDOIABUxPwWvay6tcxDU3ZmkPkzDli60f3NBSf3Xv?=
 =?us-ascii?Q?36o0OFBcLMuI3LK0JY2pYOC1y2G0qORk4oUYHWiM2seUjWyIXcmixGMiv1Cy?=
 =?us-ascii?Q?70IJbBEq2svnaPha17Mcgij3i3NOJu9rPs8xXwdOjzW/x9Vv/oAdkaaqw1AH?=
 =?us-ascii?Q?gqLKWJTn9MvJ3bA28zD8kHZBY/gWOstGba1QipOOZQAApc7qorgwTphNwvse?=
 =?us-ascii?Q?7cD5R3ZotJ+/v6TegAinU7qtS+u5BeGafGuMpuo8nw74zOrNaTXzVVjkToGQ?=
 =?us-ascii?Q?YvZdxsAOzDAeozmu2B+yXxseRy8SujNRFjJNLBESAq+ECyznNLP7t31hHbb1?=
 =?us-ascii?Q?gcpoPbKmLpagwuNDUa4K8TZ6etUQNg3/k+S+VZfKOJgCa3fNfULxwj+ocRUv?=
 =?us-ascii?Q?ouyliOo8Ximh3vcFNaJinx6BhV2Nehs5KXBQ5A/uzTmUqCYtso1eZCq4ASTV?=
 =?us-ascii?Q?NoRh3MTNgs7aZKV3jMnfjn/dinmdLrNf1uIyrZWULU0DrriExrJgDObB8KOo?=
 =?us-ascii?Q?sJJx2scR/9XrEObOueoQIKd2BGK+N6UbZrQzDDjgOF5Z+yOOgkT3YXh5U+tl?=
 =?us-ascii?Q?0Uj9M2ANxIik4L0Doz83OYd4GwzYyrhKxcSb1xWYwuDy+LF336rzK5H1D88p?=
 =?us-ascii?Q?ZpbGi9Aji5bjYIAvrLBm/L4wIM4umWiDONlpOxWY40b1qV7rAiCXRSHx+NVy?=
 =?us-ascii?Q?AL9ayn4H+RUQGEKw6FOYbaI0DRKlvfTKeT1l/ofZUoohuqLCnlR1EyPSh7fJ?=
 =?us-ascii?Q?eWOnjjdIg4sxBj0Q5baY9sWRfcGLAAI1mxjQ81rijCjVqXGb0m3O7f1T+sUB?=
 =?us-ascii?Q?QI5bo/FVcVWJ3taUTfq8McmBJZMR8x+EVwPBn9YvTtOv/KwqHrHSh5W5KJWJ?=
 =?us-ascii?Q?KpDPikhj95GP/z4ACHjcYGEoVhhf8qRDEHomTOX7ZPs5JcaVLyAehhnKh/we?=
 =?us-ascii?Q?xvYPuKXY9TmD9fLVpxX38XVADWDNtjTgn0Li6AMn?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 475559e1-ff94-4697-a837-08dac4447951
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2022 00:26:00.0123
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TwoKAzmU68tb1AC2fyHG99n4/576C9dFXlQcOMr0TN6W/6kgVsOSC1Em4k6aMi6Zr/0CO+6HNcxYLzrpB8sCcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4869
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 11, 2022 at 06:19:15PM +0000, Sean Christopherson wrote:
> TL;DR: I'm going to try to add more aggressive patches for this into my series to
> clean up the KVM side of things, along with many more patches to clean up the page
> track APIs.
> 
> I'll post patches next week if things go well (fingers crossed), and if not I'll
> give an update 
> 
> On Fri, Nov 11, 2022, Yan Zhao wrote:
> > Page track hook track_remove_slot is used to notify users that a slot
> > has been removed and is called when a slot DELETE/MOVE is about to be
> > completed.
> 
> Phrase this as a command, and explain _why_ the new hook is being added, e.g.
> 
>   Add a new page track hook, track_remove_slot(), that is called when a
>   memslot DELETE/MOVE operation is about to be committed.  The "remove"
>   hook will be used by KVMGT and will effectively replace the existing
>   track_flush_slot() altogether now that KVM itself doesn't rely on the
>   "flush" hook either.
> 
>   The "flush" hook is flawed as it's invoked before the memslot operation
>   is guaranteed, i.e. KVM might ultimately keep the existing memslot without
>   notifying external page track users, a.k.a. KVMGT.
> 
> > Users of this hook can drop write protections in the removed slot.
> 
> Hmm, actually, on second thought, after thinking about what KVGT is doing in
> response to the memslot update, I think we should be more aggressive and actively
> prevent MOVE if there are external page trackers, i.e. if KVMGT is attached.
> 
> Dropping write protections when a memslot is being deleted is a waste of cycles.
> The memslot and thus gfn_track is literally being deleted immediately after invoking
> the hook, updating gfn_track from KVMGT is completely unecessary.

> I.e. if we kill off the MOVE path, then KVMGT just needs to delete its hash table
> entry.
> 
> Oooh!  Looking at this code again made me realize that the larger page track cleanup
> that I want to do might actually work.  Long story short, I want to stop forcing
> KVMGT to poke into KVM internals, but I thought there was a lock inversion problem.
> 
> But AFAICT, there is no such problem.  And the cleanup I want to do will actually
> fix an existing KVMGT bug: kvmgt_page_track_write() invokes kvmgt_gfn_is_write_protected()
> without holding mmu_lock, and thus could consume garbage when walking the hash
> table.
> 
>   static void kvmgt_page_track_write(struct kvm_vcpu *vcpu, gpa_t gpa,
> 		const u8 *val, int len,
> 		struct kvm_page_track_notifier_node *node)
>   {
> 	struct intel_vgpu *info =
> 		container_of(node, struct intel_vgpu, track_node);
> 
> 	if (kvmgt_gfn_is_write_protected(info, gpa_to_gfn(gpa)))
> 		intel_vgpu_page_track_handler(info, gpa,
> 						     (void *)val, len);
>   }
> 
> Acquiring mmu_lock isn't an option as intel_vgpu_page_track_handler() might sleep,
> e.g. when acquiring vgpu_lock.
>
I totally agree with you and actually had the same feeling as you when
examined the code yesterday. But I thought I'd better send this series
first and do the cleanup later :)
And I'm also not sure if a slots_arch_lock is required for
kvm_slot_page_track_add_page() and kvm_slot_page_track_remove_page().
(Though it doesn't matter for a removing slot and we actually needn't to
call kvm_slot_page_track_remove_page() in response to a slot removal,
the two interfaces are still required elsewhere.)


> Let me see if the clean up I have in mind will actually work.  If it does, I think
> the end result will be quite nice for both KVM and KVMGT.
Yes, it would be great.

Thanks
Yan
