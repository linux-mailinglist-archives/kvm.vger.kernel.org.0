Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3968628DAE
	for <lists+kvm@lfdr.de>; Tue, 15 Nov 2022 00:45:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231837AbiKNXpQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Nov 2022 18:45:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230144AbiKNXpO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Nov 2022 18:45:14 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C90CC4;
        Mon, 14 Nov 2022 15:45:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668469512; x=1700005512;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=zGqK9JhQor4+mbNxdfXS9HPQdu1CK1wawcxf1vMSGd8=;
  b=UsG6ZIoibK+WcsFm7txFwNtIyNpz3BsuSuy9EMIW5CH20JGZhqyJyqx0
   r1cdmzWh5KTqD0ss169pWzOOWGJIosWI7uuv2HcBjs/OPJlm7PmakHTta
   kqMGhMCOIDWR9W2yhG8n3x2t419HhOybm9iaNpQJhMjgoi2nWYQFfWgZR
   tI7x92g4VSaqvM0eqLVqGbUbjz+cpQ9xcmTZqN1zQCaYxChPVsKa0PWbw
   dkG5y+mq891fWnc00JZF0bDqhZwhRdhjmPu+j4bqp9HhQg2qSohn618cf
   dHkbugsroOtOe/zZa0jL8ADla6xu85mX1qkumSAcOls7yU7kWgv1PaQCx
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="313920594"
X-IronPort-AV: E=Sophos;i="5.96,164,1665471600"; 
   d="scan'208";a="313920594"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 15:45:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="671769448"
X-IronPort-AV: E=Sophos;i="5.96,164,1665471600"; 
   d="scan'208";a="671769448"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga001.jf.intel.com with ESMTP; 14 Nov 2022 15:45:11 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 14 Nov 2022 15:45:11 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 14 Nov 2022 15:45:10 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 14 Nov 2022 15:45:10 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.170)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 14 Nov 2022 15:45:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g9Kp9XPj6hRNMZLEK09MLIAnr1RJ+BQQRCX/xnM4mCaalKILeyRsAn9Ah/8lOu1L6zhHTxFvqvqluRCWV3bCUbHnTx0QpxnMt3F4AdFnG1TVZql0gkr/m8mRwIZCAY7usTU2R+t5crsMJAtBrj9sFoCjvaXIrLMTiRKN9fh/krKE3i1+e4BOZJLBkTFdGwUtMerfz52FpU89G9O6TXq1qTneUuQn46rSOiyOl7q855UIHqvmdAU+kCwjVM3FhK51oAA4MsX7aMVGBAGQG8HW6L/2AbH4JpJsKT8VaRXeKDU3A7SAlTCIPI511DN/4PEXY55p9+xwiFTJ511kdVbtCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+IcXfM6VI+F0fxNVph08ruEC+vnRwaW2Gip6Ew3pl1g=;
 b=Umn7WnNWYDBpTjtg//nmy+oplJvxrHjcAAbGlP5vzziQfa+Sne64MMhzcC3Rzpr22aqUC2fa8T0p/1yjzNeHglplD39K9+vEKfqeJ4+W238RxxlI6d9uatAk5PhmFbEQxbLXMguUMd/Gm2AyBiFgzyBqT0GKo6wqzPFA0vIKZft5j1eNc8Il+zifUJjNzSXMBhTp6S3bAGaue5UPdew+udasydJJizs8hYZamX1IYnxajebiqDYWlb/HnQ4g8ScmEHo90GPKOm4/XTgxaMnkpf4l/5JQLaJFduyEI1lSIFk3AtFbDTkn2caCmHjwJWMm+cL9JKxoKY5GMyKzhF4x1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SN7PR11MB7090.namprd11.prod.outlook.com (2603:10b6:806:299::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17; Mon, 14 Nov
 2022 23:45:06 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::dc06:6d36:dc8a:fe7f]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::dc06:6d36:dc8a:fe7f%7]) with mapi id 15.20.5813.017; Mon, 14 Nov 2022
 23:45:06 +0000
Date:   Tue, 15 Nov 2022 07:22:14 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <pbonzini@redhat.com>, <intel-gfx@lists.freedesktop.org>,
        <intel-gvt-dev@lists.freedesktop.org>, <zhenyuw@linux.intel.com>
Subject: Re: [PATCH v2 1/3] KVM: x86: add a new page track hook
 track_remove_slot
Message-ID: <Y3LNplTrOpJdxyEW@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20221111103247.22275-1-yan.y.zhao@intel.com>
 <20221111103350.22326-1-yan.y.zhao@intel.com>
 <Y26SI3uh8JV0vvO6@google.com>
 <Y27ivXea5SjR5lat@yzhao56-desk.sh.intel.com>
 <Y27sG3AqVX8yLUgR@google.com>
 <Y3GUdqxnPJvc6SPI@yzhao56-desk.sh.intel.com>
 <Y3JtonYdDYOhbmfG@google.com>
 <Y3LEZXWqk6ztuf7x@yzhao56-desk.sh.intel.com>
 <Y3LOIKueyTUoJ00B@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y3LOIKueyTUoJ00B@google.com>
X-ClientProxiedBy: SGXP274CA0002.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b8::14)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SN7PR11MB7090:EE_
X-MS-Office365-Filtering-Correlation-Id: 79cb71a2-f829-4a7a-344b-08dac69a422f
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e98FDF40SrKseFq7Whwbt1wm0n0bMZNQ1VQcZvhlHSPseKorlvawCVBk7hHv2J8oN1BG+HyjIj/5nS6W7iVr4t1EWJXxIa8UzamH6erq6fS6gqvuan+tlQGaST+RZh+FxPW/wktXipqNlzDRW3CtMkUNZXjqDSngetnbVtVNv65DzmumpxXxjEuWy6S+hcOpo3y3xa5i2fXVQD+2nrY7B1G2tGBeNNdzmqaGiTHYiRi9wEdJPpiCT4obBEnAoNHOSfyXJIb2PF51VNBLsZVZiZ2I3J4uwJQ1Wp5dsdwe+hyrc+M8N8uNhNhXKazkjgvnoWyIjIqK0FK5FKB9Xgk5uahuqLF9ST8w3FWjRahHzPNp8EqGXlgmVL5I1VKOBVn+9WXbOqUmQlP0dXiQtkVZ4+5A2DLv3nsrrTsL5oZiTVxOIsNC45KRCnGWtLIqDZORzdsC4Nvsuzm7Wr1QYBd1QhS27q90sHI2h8SnqOGv+GWRlGvVEJ7f/iHG+r2N/sTyuWZxlFGI5ax7IdyDDeUTLOSMw3tX3MotQTIWRKRcUvy9wtNzsJlr9EQ6JPAYtzJPgvUUyGlz4R430a4TawwJ4V1itGw/UlGmSiIW13bKHlHT21CAjhTz/sFwEuKQaPZyakB3FotR+nEtC+5XNM5lZXf2h2Ou3UZHkpSOZZzwvJFgM+NKX0JZGQc3zmWdUJcjiNILzeLsDqHj4GETa+DWiw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(396003)(376002)(366004)(39860400002)(451199015)(6916009)(316002)(478600001)(26005)(86362001)(6666004)(6512007)(3450700001)(2906002)(6506007)(66476007)(8676002)(186003)(66556008)(82960400001)(8936002)(83380400001)(66946007)(41300700001)(6486002)(5660300002)(38100700002)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?66qBeyrQWMknuApLxL+RYn87nhmQoPROmBrkhFo+60KUjsS3k0Wgf3tGKBiG?=
 =?us-ascii?Q?zahv0N0IzD7yJof15chRJXbotKoBde0jwR0ktpHmGr+Gaf38IaIOAK1PcfP8?=
 =?us-ascii?Q?AMDTn9WPZ234w+Kh5Vo3o1GXwUlicYalq5YJC0vEaeKKkDZwNr14hRkHnGlW?=
 =?us-ascii?Q?eULtWurebsODx1wXiOK09ONrxOcub8DhnfzLZHh8pIsxwjTqhrLcIwGffa3C?=
 =?us-ascii?Q?GloVTEJDmlr+AnnvngAPfeoZelHX1v6sZA4xN8VojxUfEvJ5C8aDZDgxpxhS?=
 =?us-ascii?Q?9dsdgjrbFeBCFGzWI+Q9J5+teRoCDI4i5ztghbCvLhVB0aTvOgaWbdStoBnq?=
 =?us-ascii?Q?1ekn0zY84ouCGEOv67C3CQfK76xvwoU0kReySS7bzpJRhQe/wxIXfwX/lZI7?=
 =?us-ascii?Q?jBXABIJgQUmDwbokjU/4IOcVZD3FaoXfKZqgnqySRwXg0egi3UQDzm73vt51?=
 =?us-ascii?Q?JGTtKZ4GRYnvfTogSOmuK+NlER6ecOI71KSVpNLv5BNikYlL86tCNzzZ5QCM?=
 =?us-ascii?Q?k9l3UgG1h0TTNQOf6ym38Okm1fImXCJNmoEZ6XCYFybAnieW6qReUWP/y2gX?=
 =?us-ascii?Q?bfDUuvLWLmQ+N627vihxI5wxQF5xTMkTt300tPNDqJhm0vl7/qzbAAbDQo8g?=
 =?us-ascii?Q?Xc6FX9VbouFzHfqYp3EUuKZdceu6SfgcmoNNlYFAHKc2ULo6wA2/lyE597Ow?=
 =?us-ascii?Q?tVP96OagT9yFl6e3Uft4Q+Y1hNH8UN1uFYs/FD8zQfeIBNQiaHLBxV+O1v8Z?=
 =?us-ascii?Q?IZEwGB5nJv7X5OLj2hHu7N0xU0p+l6AryhS/InHljHoh/1CiC3CVs5bhbThM?=
 =?us-ascii?Q?n2EH+DIZzBt1I7axZJW6XQ5oI8vmKVz9unF5GwaI8ubcTbTqTm/O/6jmClFQ?=
 =?us-ascii?Q?Xgxk1GE8YH9V1VPY3aIhsWAxVZTlXUdvic9+gc8p/8QFR/4f5DwuoSn4JJZ6?=
 =?us-ascii?Q?+9OEPmJ2h2R3PKuvPlkdmLEhaG4rUw/2s7Sx/Zaqc3YbjDi2pkzzbSX8MDU4?=
 =?us-ascii?Q?5gm7Y8DHM3cu6E9bL5eWs1IIJA2gddnoNqTNGMEgSLDZCoQ2nor2Jhk5bSnY?=
 =?us-ascii?Q?QFdXjID64dQxX/otcGY24kloNe/wPEaQj6eONoAURnXXlxnedIZ3I6KCvHvG?=
 =?us-ascii?Q?plLSJ0hpiCfhH9suDN9XgmN9fRwXGUXEbsHqsaRdzEnwe3yKO5XlOc+SoOx6?=
 =?us-ascii?Q?FmlfougW1/8oyIlmvAiM+wKh11qcxFNqgfjmUECyNgnYnZ94YBLEGdPhMEwm?=
 =?us-ascii?Q?zBZfMlTS51TK8SxSZrW2EZ1FCfy89dnkVkaumR4Sz4oRVNpopZlWrJE97d6i?=
 =?us-ascii?Q?TPaQf3B+tlEDyZV18XtyeGr0NlCWkaTNzEBOJ8UOjRoaWZ6Y9RxPftk8sIXe?=
 =?us-ascii?Q?Ipm2yj1yvvA+k7m4vXW4gJ6/f1flhQUcHSttqH/cxjlVIGlIMD0epjueVGvX?=
 =?us-ascii?Q?XNOUrvpDvSTZ/SjPHQ7OTL+NmG4V2WpnOv7EtXHKD5J8GsuwufshC0n77v8b?=
 =?us-ascii?Q?OlMBK/kQMIe/2AWthzF85fgQoRme2GFAC2rVp2a07yfB10a0ijEMWQyYkfzz?=
 =?us-ascii?Q?Czm4pOg1PXF3LZVJzsM+OWXkHI4lJlVVXarJzpIchbzuAOh1YUkIhP5TlDIN?=
 =?us-ascii?Q?Tg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 79cb71a2-f829-4a7a-344b-08dac69a422f
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2022 23:45:06.5717
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J4WFGy8qzFyEmk9xr4bT+w6UXVEx6vhTqZqJil1D2GLlfY+377H76IFjwadDt2W/WBKjTAmnNR2OT+LLZk9BNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7090
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 14, 2022 at 11:24:16PM +0000, Sean Christopherson wrote:
> On Tue, Nov 15, 2022, Yan Zhao wrote:
> > On Mon, Nov 14, 2022 at 04:32:34PM +0000, Sean Christopherson wrote:
> > > On Mon, Nov 14, 2022, Yan Zhao wrote:
> > > > On Sat, Nov 12, 2022 at 12:43:07AM +0000, Sean Christopherson wrote:
> > > > > On Sat, Nov 12, 2022, Yan Zhao wrote:
> > > > > > And I'm also not sure if a slots_arch_lock is required for
> > > > > > kvm_slot_page_track_add_page() and kvm_slot_page_track_remove_page().
> > > > > 
> > > > > It's not required.  slots_arch_lock protects interaction between memslot updates
> > > > In kvm_slot_page_track_add_page() and kvm_slot_page_track_remove_page(),
> > > > slot->arch.gfn_track[mode][index] is updated in update_gfn_track(),
> > > > do you know which lock is used to protect it?
> > > 
> > > mmu_lock protects the count, kvm->srcu protects the slot, and shadow_root_allocated
> > > protects that validity of gfn_track, i.e. shadow_root_allocated ensures that KVM
> > > allocates gfn_track for all memslots when shadow paging is activated.
> > Hmm, thanks for the reply.
> > but in direct_page_fault(),
> > if (page_fault_handle_page_track(vcpu, fault))
> > 	return RET_PF_EMULATE;
> > 
> > slot->arch.gfn_track is read without any mmu_lock is held.
> 
> That's a fast path that deliberately reads out of mmu_lock.  A false positive
> only results in unnecessary emulation, and any false positive is inherently prone
> to races anyways, e.g. fault racing with zap.
what about false negative?
If the fast path read 0 count, no page track write callback will be called and write
protection will be removed in the slow path.


Thanks
Yan
> 
> > > arch/x86/kvm/mmu/page_track.c-void __kvm_write_track_remove_gfn(struct kvm *kvm,
> > > arch/x86/kvm/mmu/page_track.c-                            struct kvm_memory_slot *slot, gfn_t gfn)
> > > arch/x86/kvm/mmu/page_track.c-{
> > > arch/x86/kvm/mmu/page_track.c-  lockdep_assert_held_write(&kvm->mmu_lock);
> > > arch/x86/kvm/mmu/page_track.c-
> > > arch/x86/kvm/mmu/page_track.c-  if (KVM_BUG_ON(!kvm_page_track_write_tracking_enabled(kvm), kvm))
> > > arch/x86/kvm/mmu/page_track.c-          return;
> > > arch/x86/kvm/mmu/page_track.c-
> > > arch/x86/kvm/mmu/page_track.c:  update_gfn_write_track(slot, gfn, -1);
> > yes, it will be helpful.
> > 
> > Besides, will WRITE_ONCE or atomic_add in update_gfn_write_track() to
> > update slot->arch.gfn_track be better?
> 
> WRITE_ONCE() won't suffice, it needs to be atomic.  Switching to atomic_inc/dec
> isn't worth it so long as KVM's shadow MMU takes mmu_lock for write, i.e. while
> the accounting is mutually exclusive for other reasons in both KVM and KVMGT.
