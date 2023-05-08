Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE7D26F9D75
	for <lists+kvm@lfdr.de>; Mon,  8 May 2023 03:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232515AbjEHBkU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 May 2023 21:40:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229960AbjEHBkR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 May 2023 21:40:17 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3129846A8;
        Sun,  7 May 2023 18:40:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683510016; x=1715046016;
  h=date:from:to:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=DrB+UngInhlvM5B/LxtbG+QXayt2bdwi9OCzg56ME90=;
  b=VvCgAOYP0IcrwnLJeGd2aAEkibPebMgfZmR95Usxe6sWG7zOe5wgZExZ
   Ey/w0QrcIdy8qDAXDtq0YQ5U/XJINzqrKKLX2p5ilitO7WDTPuF0xjFOm
   3er2OjR0AQaJls30EQj1ObIIOWuMIoc9gpyLDpLPoh0A6r9ROUpS0LzEK
   XWnlze9WjwysT9Eo76p7d6MDuxo97iud1xDbXrmKBARD13gkjpLY+m/7l
   tDkwrgt2oclmAUeF3BHZVMzom6wKrhy0hGRvVACSNFGydb8VAURY+LI8A
   KXc1YlG7V7r+utCZvS8lPOmOWwvODsnafm+hPBrOS6+yUW9P6yK/48Epo
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10703"; a="349563142"
X-IronPort-AV: E=Sophos;i="5.99,258,1677571200"; 
   d="scan'208";a="349563142"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2023 18:40:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10703"; a="767884184"
X-IronPort-AV: E=Sophos;i="5.99,258,1677571200"; 
   d="scan'208";a="767884184"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga004.fm.intel.com with ESMTP; 07 May 2023 18:40:15 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sun, 7 May 2023 18:40:15 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sun, 7 May 2023 18:40:15 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Sun, 7 May 2023 18:40:15 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.174)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Sun, 7 May 2023 18:40:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g5A+iLfiVcu+EI0ghGAhBeb6GKDBiY/hu0DCUqhdCYY//aq0GvJpfsmkmGm5Z9TyU4nPAJri0MfQU/HKfDi80G8Ow5N9fk5/HhlYhsTiWq+LyEiujIKBgzmLP04g+bWVXr2sRSZtcD3951qh2KlHBaoyOzOxgdSI8tqQ3X4/mwbAadSCfrTzbACJbfClNnCTEZFy2EvqLh57hwiSm31WER7ZZR/zAR+c8PGlg8XV7pDT8nnIFGf1vqBf6t+0oHi/A056EknyFKxw8W+MicKp5R2HDb46bGGHyy/9gOhFo/7AM6xxYVCO+6kZIoOZISyzX61UoaK4iypCgilm+GMlNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1PIYMKqxt9ZMOQ0lnveYlgBM+ZdcrowqsToghlpwsU8=;
 b=l0FqCEda6oK+KWkosunVVNzb2ZixW1YP5/q1M0WiL25RVvWbfJKBl5K+AOFrY6VixIJAYKa/xWvxCWObgcoz1buwRZcAOnhRdN/bla4rRci7rolYWE4+BAvTZy5xKYEn6iCLTjWM7Zlug30V90UK0UtqpaZYApfRmJNWNZAlEnN8JG7lkgf+EevWK+NObQ6jtpMAJBH+8YAjECVzR+mzCz3oQpJxE3pEyVRNFumRSdMear+ebb3Z0/nq1t3IDdtwrDsJ0gWcXaNRDdZf21njxPob4BBfj/bGjBmCZNe7/lhNR3c+46Lr/rK1BnKaKcUAiGAoq2/6lcQgyJ4Q1LC1TA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DS0PR11MB7850.namprd11.prod.outlook.com (2603:10b6:8:fe::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6363.32; Mon, 8 May 2023 01:40:12 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::a670:49f5:d602:e2e4]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::a670:49f5:d602:e2e4%6]) with mapi id 15.20.6363.032; Mon, 8 May 2023
 01:40:12 +0000
Date:   Mon, 8 May 2023 09:15:08 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>, <kvm@vger.kernel.org>,
        <intel-gfx@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
        "Zhenyu Wang" <zhenyuw@linux.intel.com>,
        Ben Gardon <bgardon@google.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        <intel-gvt-dev@lists.freedesktop.org>,
        "Zhi Wang" <zhi.a.wang@intel.com>
Subject: Re: [PATCH v2 25/27] KVM: x86/mmu: Drop @slot param from
 exported/external page-track APIs
Message-ID: <ZFhNHB4VWp8+5wWp@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230311002258.852397-1-seanjc@google.com>
 <20230311002258.852397-26-seanjc@google.com>
 <ZBQkyB3KJP34D9/h@yzhao56-desk.sh.intel.com>
 <ZBwS0DNOwMf7OVmV@yzhao56-desk.sh.intel.com>
 <ZFLrOgUL4T/lrVLo@google.com>
 <ZFMVsFzpN16hiPUH@yzhao56-desk.sh.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZFMVsFzpN16hiPUH@yzhao56-desk.sh.intel.com>
X-ClientProxiedBy: SG2PR04CA0206.apcprd04.prod.outlook.com
 (2603:1096:4:187::21) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DS0PR11MB7850:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c52a469-391f-442e-f8d5-08db4f652a6d
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oxBAzKsStwFb5rgPdhXGwgz8U7jMKfHbGWVvVNwhj03tEGRcse96gBsEIWodihufD1+VXrByASTHNW7osyvc7YrmkMg5smUUNnUkFJX0HTc+8S9KObZUr6jSE56xBySHWSuz8RR4kQ7cQq4Nci7yMuB0Wpi87j+7Hf6bJ3K3DYR3Xv1V4sMeyZWcEBhgkmUkigxmvO3b2kOIVi8fOc7yWELuDfbve6QLcxvD1juwINb1eyAbMUASMM01Q3HQPCtlfRJRDShs6d4mLMmxJLWVqUNEXUjZPhL6wxeGZZzoRlrFCp0cFAnLfzWK5V6c9WLxZDaQEFzlQGQirBJc5vC5XTRLqwRu4LClONJu+9cZSl7TvmAiR//6wpwLzaU0SQmmy+Vp+9brW8/ovmMiqr7E94TOiB5tiQAM6mb65YQKWaGHPgNocu8IStAbOJfFtYRN3Rwu//GqKiojdBglsIGaiftFJDwu5F1hfS6dIplCVSgVTxKRTHE9bWhedbZWOpiq5tQnNG9jJHF9DuWnZHkKwC5uF6j7/CRa6P639/VbMrHcbkeHOQIroefAQoFlJA9Q+AMV/LHL01QuKjQQUBsryIkqHyoGL8rKU4WPXOaxRUs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(39860400002)(396003)(346002)(136003)(376002)(451199021)(26005)(6506007)(6512007)(6486002)(83380400001)(38100700002)(86362001)(82960400001)(186003)(110136005)(478600001)(2906002)(3450700001)(5660300002)(66476007)(66556008)(6636002)(316002)(8936002)(8676002)(41300700001)(66946007)(6666004)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ceTYAesFG3sOj4KnoV6zUzKA9xml+GmkI2ykni463JVbgX6He+WWNlOiIOH/?=
 =?us-ascii?Q?jJB0S99NIm/3B2wg1HYoMvc42ysbqcuso93he18xhT+aOC51t3Yp8sYELdS/?=
 =?us-ascii?Q?OMtZiM9JDxKUBw/54X/KOMmwfDlxr9ilm0CMHVx7L1mR6R5z9I1v05O8iX3x?=
 =?us-ascii?Q?mVa0kHjhuEpugnZojCP2kNz3rbdOhpjojiyBpIDKEqm44KR73dylThXodphQ?=
 =?us-ascii?Q?HaEz9pcTN/gLJWNgIJVbqZYDJw3Tv/vWVr91gu8s2QBirk4lV6d8usZQTlSR?=
 =?us-ascii?Q?59gmtzvVqNEFet/88aIj9/t8sBa+CDf+f0iH3R8W3CkaRmdiA9HPwX8SPLUY?=
 =?us-ascii?Q?3KjD3gdCoxPTwPw/3D0HE25e/8hR/pnWiW/VtSr6iPuaMX4xW3BHsJNhFyy1?=
 =?us-ascii?Q?+woPxiIkHoho272rsgcCeKbzCyo7D0TfKfIFr19PtxKy9j+QBpghIm0HDsHc?=
 =?us-ascii?Q?jEzm6lqBoyIowExwW2jQdrnatl4OXTHDNWUXHfjt891twVzIwZp6CfxOlXz0?=
 =?us-ascii?Q?2JZGliKSzxnibY3/28zkR3JT0Ivv2C5wGjj1IHgpM3KqlySYolU0T35bM+8q?=
 =?us-ascii?Q?1LK39pR2JjPzZY+DUJ7JQQuV7BaDJ/5yy6FRnFH90tp1bgwIYCFJGIsPyuwn?=
 =?us-ascii?Q?mpXlSAoll8G1/yieJ/MeZFjEysum9LJ5jeLvgt4kPKp0hsgiEgiTcbzvwfnU?=
 =?us-ascii?Q?iFQStQ/ObZ0DffqUEhXOo17QvJIUA5n98Jq9BZMht6zXZIh9fjRWnMhYZLPb?=
 =?us-ascii?Q?XIJBkRrEkwkpe6ybu+0Pp0Xtt4OxUp1jH98fGy1NbWcKWQZcHq1fzA3VQuM8?=
 =?us-ascii?Q?F/OoW0f2y6oVH8VkVQ3QILzKYYlcaTmrIhAdgJ6ROK4nN8ukCY7Fn8t41hSn?=
 =?us-ascii?Q?0FVikMOsctoVgOTz+T1Vdy97kUl9EiCsGDk/X+sdTen4X5KZsjgalSJmU+fc?=
 =?us-ascii?Q?JAQD5oW+uB3r9LP/Etnxyeg2jZHWxAcvkI38ypiiFNkO3g8rjAfF/KqOPd9n?=
 =?us-ascii?Q?7J+iSd197+g7I2Ns3HRrNFaEdVIDoCey1h1VyTXixuRau9LezMSukO3z+jwQ?=
 =?us-ascii?Q?nrVTZzaK38UaJf1s9CpE46biRqBT88b0CR/8OaCXWULmP17cOHb5YHgxmraf?=
 =?us-ascii?Q?4msa4XZzum0u4y8cV7rb8cafgNEhGqKw8KdzZl+PprdmCXuEo0So8f+kjSYr?=
 =?us-ascii?Q?qT9Pb3JPdYt5PAA1yVaozG4i45Z6nN0UbS/fCbGWh+J4oVNl9pAjnOH1FF2B?=
 =?us-ascii?Q?0QRh6dpkUm1ZWsGIRZ7MnOd9D2xHWebqt0avJyL3w6l+4ol8c66ki9OMvpen?=
 =?us-ascii?Q?U6Tz2f1iBIiDhvmto2qFpmrpM/CnyU1uGLQpD9G+b0BoHsUnh8pwA+lKA4zT?=
 =?us-ascii?Q?mCO7JbKwf/9nuYdF0TlLghrYwb9eUnQ8/StofCvOXEXkOkcxZJPyco0e54O6?=
 =?us-ascii?Q?XkKuuSRWxWLiQkgZFxLhim01ZpKv9FdLDLWCzCSgS6BtdvY3AcUXAMtrcStk?=
 =?us-ascii?Q?Q3Txuj0F7Bfl1yFeBdZVUGZEkx7lMEW7/demSK7F5efA5MCSjpEKNQ5Iltav?=
 =?us-ascii?Q?AGIDxeYEhw4S1yjedlo7ronKG5UHbfIsrzXJswZX?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c52a469-391f-442e-f8d5-08db4f652a6d
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2023 01:40:12.7034
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 57N8qFWcxv/76b6U/p4wWz4JJHSZY+Aru+Tybd8QjFEvcftPEpTdNxrmRLFN78Q7Rb6RHfq0hHDsZJ5vex0LOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7850
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 04, 2023 at 10:17:20AM +0800, Yan Zhao wrote:
> On Wed, May 03, 2023 at 04:16:10PM -0700, Sean Christopherson wrote:
> > Finally getting back to this series...
> > 
> > On Thu, Mar 23, 2023, Yan Zhao wrote:
> > > On Fri, Mar 17, 2023 at 04:28:56PM +0800, Yan Zhao wrote:
> > > > On Fri, Mar 10, 2023 at 04:22:56PM -0800, Sean Christopherson wrote:
> > > > ...
> > > > > +int kvm_write_track_add_gfn(struct kvm *kvm, gfn_t gfn)
> > > > > +{
> > > > > +	struct kvm_memory_slot *slot;
> > > > > +	int idx;
> > > > > +
> > > > > +	idx = srcu_read_lock(&kvm->srcu);
> > > > > +
> > > > > +	slot = gfn_to_memslot(kvm, gfn);
> > > > > +	if (!slot) {
> > > > > +		srcu_read_unlock(&kvm->srcu, idx);
> > > > > +		return -EINVAL;
> > > > > +	}
> > > > > +
> > > > Also fail if slot->flags & KVM_MEMSLOT_INVALID is true?
> > > > There should exist a window for external users to see an invalid slot
> > > > when a slot is about to get deleted/moved.
> > > > (It happens before MOVE is rejected in kvm_arch_prepare_memory_region()).
> > > 
> > > Or using
> > >         if (!kvm_is_visible_memslot(slot)) {
> > > 		srcu_read_unlock(&kvm->srcu, idx);
> > > 		return -EINVAL;
> > > 	}
> > 
Hi Sean,
After more thoughts, do you think checking KVM internal memslot is necessary?

slot = gfn_to_memslot(kvm, gfn);
if (!slot || slot->id >= KVM_USER_MEM_SLOTS) {
		srcu_read_unlock(&kvm->srcu, idx);
		return -EINVAL;
}

Do we allow write tracking to APIC access page when APIC-write VM exit
is not desired?

Thanks
Yan

> > Hrm.  If the DELETE/MOVE succeeds, then the funky accounting is ok (by the end
> > of the series) as the tracking disappears on DELETE, KVMGT will reject MOVE, and
> > KVM proper zaps SPTEs and resets accounting on MOVE (account_shadowed() runs under
> > mmu_lock and thus ensures all previous SPTEs are zapped before the "flush" from
> > kvm_arch_flush_shadow_memslot() can run).
> > 
> > If kvm_prepare_memory_region() fails though...
> > 
> > Ah, KVM itself is safe because of the aforementioned kvm_arch_flush_shadow_memslot().
> > Any accounting done on a temporarily invalid memslot will be unwound when the SPTEs
> > are zapped.  So for KVM, ignoring invalid memslots is correct _and necessary_.
> > We could clean that up by having accounted_shadowed() use the @slot from the fault,
> > which would close the window where the fault starts with a valid memslot but then
> > sees an invalid memslot when accounting a new shadow page.  But I don't think there
> > is a bug there.
> > 
> > Right, and DELETE can't actually fail in the current code base, and we've established
> > that MOVE can't possibly work.  So even if this is problematic in theory, there are
> > no _unknown_ bugs, and the known bugs are fixed by the end of the series.
> > 
> > And at the end of the series, KVMGT drops its tracking only when the DELETE is
> > committed.  So I _think_ allowing external trackers to add and remove gfns for
> > write-tracking in an invalid slot is actually desirable/correct.  I'm pretty sure
> > removal should be allowed as that can lead to dangling write-protection in a
> > rollback scenario.   And I can't think of anything that will break (in the kernel)
> > if write-tracking a gfn in an invalid slot is allowed, so I don't see any harm in
> > allowing the extremely theoretical case of KVMGT shadowing a gfn in a to-be-deleted
> > memslot _and_ the deletion being rolled back.
> Yes, you are right!
> I previously thought that
> invalid_slot->arch.gfn_write_track and old->arch.gfn_write_track are
> pointing to different places. But I'm wrong.
> Yes, allowing INVALID slot here is more desired for deletion rolling-back.
> 
