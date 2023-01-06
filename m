Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 365C065FB61
	for <lists+kvm@lfdr.de>; Fri,  6 Jan 2023 07:21:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231754AbjAFGVE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Jan 2023 01:21:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232390AbjAFGUl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Jan 2023 01:20:41 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 782406E0EB;
        Thu,  5 Jan 2023 22:20:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672986010; x=1704522010;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=DFoUqw5nFqaUGH6XSnCJHIYMPd2OAp4FbpPuqVvTGyk=;
  b=RU4isCaOIytJ80WfO5r8irLcZ3ks1mMFXzDGerh8NG6aEnGj30HtBWxK
   UhNvcLEgsrqzAv70lMHavrl5ze5IwPs62A+s53TeBROKBBTWmahcIGCAX
   rrN3lGFwVLaXOp4FzCz59yEUoZuRlr16bmu06MA8UCifif/gdnUnDt+9Q
   l1TLADFtHpsG/x+8w3UN+qS6PE6o8tht8QTuppPq6j6KPFRj7XmTsqWom
   +LsSIIZPjd+uD++acFVpB00y7voP7xSd1MyB79ePOi7PEKJidZqxK5fQI
   W4R0W5FXZTYfn72zzw2phkHeJDteAwsQC+uja6sRuJQBGstWSGl812iAs
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10581"; a="384722060"
X-IronPort-AV: E=Sophos;i="5.96,304,1665471600"; 
   d="scan'208";a="384722060"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2023 22:20:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10581"; a="901190008"
X-IronPort-AV: E=Sophos;i="5.96,304,1665471600"; 
   d="scan'208";a="901190008"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga006.fm.intel.com with ESMTP; 05 Jan 2023 22:20:09 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 5 Jan 2023 22:20:09 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 5 Jan 2023 22:20:08 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 5 Jan 2023 22:20:08 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 5 Jan 2023 22:20:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C96h7c9RXXlzHMp724lSGJzb+6ak0sA/cQLpH+9YksyGKggFknKWHaI0fKPSY4qZrLgTQWsxwx11dKtCTknypeJ6Q5KpvqTboxZIpmPo8yte24eO4GFr3ullT6kLx5fjgmIrfkZ6kDsKAAmiAnStAL/oM368/0ADcVl6oTONJaKkqIvnyQZlnbTl6oCgWWpT0IT3lisvGRPE3BQLafHiz7+jqpkqNvJNxiOLhS2/q8M52cW3tg+1COD/LP5lIzUmauT31CqcGGQwFgtveyI6tOWkho1P8L+FGOVVf4jnKuxqVSTcxKdU4he8oppqE6dDIs4lqtXffIOzl9tBuWqPDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xqj/I9j8Oy8ncM3Rj8NwzXVRu7Vy8g019/1r2s2hnRw=;
 b=oO8q0xJMvvWVNIIqCDAvavR1e17VtxGEaMPVoZADrYZHLO9xUENjI0KoFSrp3giwxofRVPMfruZojIdv1szo9c0qqNVbVll14ypqRoOu7Abx9ND6BKcoXbbzPj+8ILUibBEUhDnQQjeGTxk1tNy3wZwGYEV4/BTKaxacuEHFDTQY4++5o0Cum+vdDdlJYvFcWLb5fAv26lc1f9iIFbJxMGiT2OdnZ2ukGiwRds4zNKW412xU3tLCXPCZXdCeF796vkgdoPE7zqxoDZt/6sqC64hWz+VWqmJ8ER4OZg940o7bGxZRP3bHgFfq/10rjK5NHH8vzbP67aOlxX6u3rY9+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CO1PR11MB5201.namprd11.prod.outlook.com (2603:10b6:303:95::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5944.19; Fri, 6 Jan 2023 06:20:05 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::bd50:2cf7:f362:3734]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::bd50:2cf7:f362:3734%8]) with mapi id 15.20.5944.019; Fri, 6 Jan 2023
 06:20:05 +0000
Date:   Fri, 6 Jan 2023 13:56:47 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>, <kvm@vger.kernel.org>,
        <intel-gvt-dev@lists.freedesktop.org>,
        <intel-gfx@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH 03/27] drm/i915/gvt: Incorporate KVM memslot info into
 check for 2MiB GTT entry
Message-ID: <Y7e3fT8/V2NoXAUP@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20221223005739.1295925-1-seanjc@google.com>
 <20221223005739.1295925-4-seanjc@google.com>
 <Y6vXTcxDNovrmeVB@yzhao56-desk.sh.intel.com>
 <Y7SaklDQD0EoIs8l@google.com>
 <Y7Y+759IN2DH5h3h@yzhao56-desk.sh.intel.com>
 <Y7cLkLUMCy+XLRwm@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y7cLkLUMCy+XLRwm@google.com>
X-ClientProxiedBy: SI2PR01CA0006.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::14) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CO1PR11MB5201:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b1d1d9f-6921-4f9a-c6ce-08daefae0d17
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bRfwMooRUhiv6gwDIK0iAJUDd+4DoDXQ36yasIw6IZifVL2+WMjRUWCMu/rSE6j4Y11vDEzLDgKu7eexPco7NATRg9B1lp6FMoilrsCdp/+mE84CqHRAA8+3ACFtK3b3D9hv4rW+OFcIPsLhU0ktqWQM0Z+FE+ccriH5KeK5bC6mnNTbzh9A6yqML6RCryLLtL+S6d6u4ApdFyuIBd+qKzhS4d/aHcxvDRHebVdxXUh6VUk5dTGCY6Bx+E+O6u5g+ya8M29FyOsldQ1jmmZKFJkaNLan0xKHDNqVieYmJ5AnJTPwgU1Stl5qK5g2vTcKWyRaSrvuBbdGSh11Jt2dzhvYFBYAO3QZed7cxPOxXd4k6E/l3GW4pyumbWBaiG8KdoQWWjWr6N42zs+/MwyOzLuRhJVuOtQUcD+NGr8UKH/gFH2gzGsizMplXXDFnhrOcUBLz8A2HXc0GnEHl+bBL99cetSPamQahwIYWLUGKVg2nvI//GiULNz8bO+kJPoYT/JkpCumL6vD8LC7BbVFQBvm1uKJd4TQT+spRHqXiX17RxujXgowRkhokEKtmmHCjwJQAEqAa6n1KKaXzFPYKXGQSRK0d5vhh9CFi6nN0Sp2xFJEJj6vnV/Oa+UsrSmts8HL+od7hj4kng8i5+hXgQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(366004)(136003)(376002)(396003)(39860400002)(451199015)(2906002)(38100700002)(5660300002)(8936002)(41300700001)(83380400001)(86362001)(3450700001)(6916009)(66946007)(6486002)(54906003)(82960400001)(66556008)(478600001)(6666004)(6512007)(26005)(66476007)(4326008)(186003)(8676002)(6506007)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HoHjJvnyPH8dFyzELnso99a7zeAyxKBRN0LfyN0ZT8nFUwlXoVyMNdYdNItF?=
 =?us-ascii?Q?5CNDOAGunI9NN+KTJiZTVUV6iB2JNut6gUHfcMd8TpuXhMc1WiiMdmljbG3I?=
 =?us-ascii?Q?kAFa8LTylaSd31PAj8yd8fFJmALHUb8w1IRsi6YcukSGA/txn6S6KsfWhZni?=
 =?us-ascii?Q?o2Zm/KjSqzAcJd9TAq9iqVx/fIBphmLNP3/DFUOZVli+vYhvsxtEH8RwU+pY?=
 =?us-ascii?Q?kV6E16rx3DVqHI2qIf3wKlajFFNI6pXFwvOpMSc/QvEXaRWnMyWh8dyiJQVg?=
 =?us-ascii?Q?lXp1Y9KivJ212ywoxWogv5EGg8Ex/VbT/UDNGV7yyvxsBgTIrLEioZ8KNOx/?=
 =?us-ascii?Q?MKTxVGyFS6FhFtnwwKQDH8erJNNoP3LgzfZfw3ZUh+L2mZ9SdOF5B2UbfnsT?=
 =?us-ascii?Q?G9L8bMiDxHdzFMuwU2Y1RKhsJEcvs1WQDwFFVLcPFWK5aOO5v99PAygpVPE/?=
 =?us-ascii?Q?evYcdLEhaLubEii65JX61AqkyEBuQMUsFwKgDYrhmn+/WTJn/AFnAPl5F3xF?=
 =?us-ascii?Q?VdhfBCXrY+Zc+5CzF7JbxWbpuyEFOdwRwoesqIj9TwtXg7Ku9nSMio5NWT3/?=
 =?us-ascii?Q?8vvaQ8o7YBv90pmN1Y5HwVCK84Zy6WF8y9P87v1wWTXYLbqmEGMLRT9irKq1?=
 =?us-ascii?Q?pyfPcNCa0bQb/Kxyw+n77T5QBwSAk/uAsQeo+b5gSehTP0lTxl2xQ7slfWiT?=
 =?us-ascii?Q?n6pZLFvgcgw6I3rClXw/6NTbI7hSD50oKLd98ULUtn7AVqVv7RIOFObxJlB1?=
 =?us-ascii?Q?/lfq54BCaJQs/vUfKjVjJLgZhEGZNfcvwFx5EnTWtRoT9mSwDtI36y/LLpsK?=
 =?us-ascii?Q?hZ9TYyPAsVyyIWp5HRTbtyWe00K35tcwpzydZThBcUmy1qPG0lc7/396D5DE?=
 =?us-ascii?Q?eE374HDN1FZz/z9v9BQNyQfQ4JddIQ5lCkcx+wMnQQYo98ulkyIjDC5c55p4?=
 =?us-ascii?Q?YKkXQy+OABE151qTx9q2motPWotk5CzKce5WhR3uqycB/Vs+Wi4HbkeJeHZ0?=
 =?us-ascii?Q?9zz8P9IMocnviORA9HIyoWnYVk/P+PDs2mYd+l2ZFXV+/2Y+NxyBF9WBIHA0?=
 =?us-ascii?Q?MqLPLC4oFoyVgYA0kER2/aNPVXTajV8Yk7bE6HHDkz/DX45yulLB9P0IixC3?=
 =?us-ascii?Q?nECHD1ZB7KAA+xWbqgo5hyCto/ieg1gkCKIPrXE/WD9GiPkJupCf3gBUWOQo?=
 =?us-ascii?Q?EA6JEa1bhAaPTKOBeZlRjaPsI8Bl8RH0WemegoJuUXkGVI9FawJco6lS2W5k?=
 =?us-ascii?Q?z4Jy3o5DQX8YvCtgYolaeZ/VCNHqCps+Gml1vKRVVZtGGXQYuHZN7+BdwRbD?=
 =?us-ascii?Q?BfWLje7H5rgftGQX1q+9/tqCJZpjBQCiXu1KLFql4nJEPK0Zpa1m1W43ivXD?=
 =?us-ascii?Q?CkBA2ksMv8bjLkKeXKCElLQ/fUag6+2GppwaKE2qta1R8OQf4d2B4M2NQJSG?=
 =?us-ascii?Q?ZR1x+1vpi9hcT78uo0UkJ4m9oAj4cBSvm9CnBl0UMHLN+xX9iIjqhiMuC/jU?=
 =?us-ascii?Q?OG+O92mvHaBmbX/S1t1tjGbLdaC4TjvF2FLlliUibKLiHUH60zcJLvIorKx5?=
 =?us-ascii?Q?67GzIQEUGFYdqVL/sUAyIs4qr90B22PNVfizo1Rx?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b1d1d9f-6921-4f9a-c6ce-08daefae0d17
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2023 06:20:05.1543
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pQI6/bTF4qGcN/MCDtzx5Mb8XrkIMvHBk0Ki7NKjwwC6sKiN/lexuPZ9NSeVjBFZtoT9KO0RpQZnZ1i6LehyUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5201
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 05, 2023 at 05:40:32PM +0000, Sean Christopherson wrote:
> On Thu, Jan 05, 2023, Yan Zhao wrote:
> > On Tue, Jan 03, 2023 at 09:13:54PM +0000, Sean Christopherson wrote:
> > > On Wed, Dec 28, 2022, Yan Zhao wrote:
> > > > On Fri, Dec 23, 2022 at 12:57:15AM +0000, Sean Christopherson wrote:
> > > > > Honor KVM's max allowed page size when determining whether or not a 2MiB
> > > > > GTT shadow page can be created for the guest.  Querying KVM's max allowed
> > > > > size is somewhat odd as there's no strict requirement that KVM's memslots
> > > > > and VFIO's mappings are configured with the same gfn=>hva mapping, but
> > > > Without vIOMMU, VFIO's mapping is configured with the same as KVM's
> > > > memslots, i.e. with the same gfn==>HVA mapping
> > > 
> > > But that's controlled by userspace, correct?
> > 
> > Yes, controlled by QEMU.
> 
> ...
> 
> > > Strictly speaking, no.  E.g. if a 2MiB region is covered with multiple memslots
> > > and the memslots have different properties.
> > > 
> > > > If for some reason, KVM maps a 2MiB range in 4K sizes, KVMGT can still map
> > > > it in IOMMU size in 2MiB size as long as the PFNs are continous and the
> > > > whole range is all exposed to guest.
> > > 
> > > I agree that practically speaking this will hold true, but if KVMGT wants to honor
> > > KVM's memslots then checking that KVM allows a hugepage is correct.  Hrm, but on
> > > the flip side, KVMGT ignores read-only memslot flags, so KVMGT is already ignoring
> > > pieces of KVM's memslots.
> > KVMGT calls dma_map_page() with DMA_BIDIRECTIONAL after checking gvt_pin_guest_page().
> > Though for a read-only memslot, DMA_TO_DEVICE should be used instead
> > (see dma_info_to_prot()),
> > as gvt_pin_guest_page() checks (IOMMU_READ | IOMMU_WRITE) permission for each page,
> > it actually ensures that the pinned GFN is not in a read-only memslot.
> > So, it should be fine.
> > 
> > > 
> > > I have no objection to KVMGT defining its ABI such that KVMGT is allowed to create
> > > 2MiB so long as (a) the GFN is contiguous according to VFIO, and (b) that the entire
> > > 2MiB range is exposed to the guest.
> > > 
> > sorry. I may not put it clearly enough.
> > for a normal device pass-through via VFIO-PCI, VFIO maps IOMMU mappings in this way:
> > 
> > (a) fault in PFNs in a GFN range within the same memslot (VFIO saves dma_list, which is
> > the same as memslot list when vIOMMU is not on or not in shadow mode).
> > (b) map continuous PFNs into iommu driver (honour ro attribute and can > 2MiB as long as
> > PFNs are continuous).
> > (c) IOMMU driver decides to map in 2MiB or in 4KiB according to its setting.
> > 
> > For KVMGT, gvt_dma_map_page() first calls gvt_pin_guest_page() which
> > (a) calls vfio_pin_pages() to check each GFN is within allowed dma_list with
> > (IOMMU_READ | IOMMU_WRITE) permission and fault-in page. 
> > (b) checks PFNs are continuous in 2MiB,
> > 
> > Though checking kvm_page_track_max_mapping_level() is also fine, it makes DMA
> > mapping size unnecessarily smaller.
> 
> Yeah, I got all that.  What I'm trying to say, and why I asked about whether or
> not userspace controls the mappings, is that AFAIK there is nothing in the kernel
> that coordinates mappings between VFIO and KVM.  So, very technically, userspace
> could map a 2MiB range contiguous in VFIO but not in KVM, or RW in VFIO but RO in KVM.
> 
> I can't imagine there's a real use case for doing so, and arguably there's no
> requirement that KVMGT honor KVM's memslot.  But because KVMGT taps into KVM's
> page-tracking, KVMGT _does_ honor KVM's memslots to some extent because KVMGT
> needs to know whether or not a given GFN can be write-protected.
> 
> I'm totally fine if KVMGT's ABI is that VFIO is the source of truth for mappings
> and permissions, and that the only requirement for KVM memslots is that GTT page
> tables need to be visible in KVM's memslots.  But if that's the ABI, then
> intel_gvt_is_valid_gfn() should be probing VFIO, not KVM (commit cc753fbe1ac4
> ("drm/i915/gvt: validate gfn before set shadow page entry").
> 
> In other words, pick either VFIO or KVM.  Checking that X is valid according to
> KVM and then mapping X through VFIO is confusing and makes assumptions about how
> userspace configures KVM and VFIO.  It works because QEMU always configures KVM
> and VFIO as expected, but IMO it's unnecessarily fragile and again confusing for
> unaware readers because the code is technically flawed.
>
Agreed. 
Then after some further thought, I think maybe we can just remove
intel_gvt_is_valid_gfn() in KVMGT, because

(1) both intel_gvt_is_valid_gfn() in emulate_ggtt_mmio_write() and
ppgtt_populate_spt() are not for page track purpose, but to validate bogus
GFN.
(2) gvt_pin_guest_page() with gfn and size can do the validity checking,
which is called in intel_gvt_dma_map_guest_page(). So, we can move the
mapping of scratch page to the error path after intel_gvt_dma_map_guest_page().


As below,

diff --git a/drivers/gpu/drm/i915/gvt/gtt.c b/drivers/gpu/drm/i915/gvt/gtt.c
index 54b32ab843eb..5a85936df6d4 100644
--- a/drivers/gpu/drm/i915/gvt/gtt.c
+++ b/drivers/gpu/drm/i915/gvt/gtt.c
@@ -49,15 +49,6 @@
 static bool enable_out_of_sync = false;
 static int preallocated_oos_pages = 8192;

-static bool intel_gvt_is_valid_gfn(struct intel_vgpu *vgpu, unsigned long gfn)
-{
-       if (!vgpu->attached)
-               return false;
-
-       /* FIXME: This doesn't properly handle guest entries larger than 4K. */
-       return kvm_page_track_is_valid_gfn(vgpu->vfio_device.kvm, gfn);
-}
-
 /*
  * validate a gm address and related range size,
  * translate it to host gm address
@@ -1340,16 +1331,12 @@ static int ppgtt_populate_spt(struct intel_vgpu_ppgtt_spt *spt)
                        ppgtt_generate_shadow_entry(&se, s, &ge);
                        ppgtt_set_shadow_entry(spt, &se, i);
                } else {
-                       gfn = ops->get_pfn(&ge);
-                       if (!intel_gvt_is_valid_gfn(vgpu, gfn)) {
+                       ret = ppgtt_populate_shadow_entry(vgpu, spt, i, &ge);
+                       if (ret) {
                                ops->set_pfn(&se, gvt->gtt.scratch_mfn);
                                ppgtt_set_shadow_entry(spt, &se, i);
-                               continue;
-                       }
-
-                       ret = ppgtt_populate_shadow_entry(vgpu, spt, i, &ge);
-                       if (ret)
                                goto fail;
+                       }
                }
        }
        return 0;
@@ -2336,14 +2325,6 @@ static int emulate_ggtt_mmio_write(struct intel_vgpu *vgpu, unsigned int off,
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


> On a related topic, ppgtt_populate_shadow_entry() should check the validity of the
> gfn.  If I'm reading the code correctly, checking only in ppgtt_populate_spt() fails
> to handle the case where the guest creates a bogus mapping when writing an existing
> GTT PT.
Don't get it here. Could you elaborate more?

> 
> Combing all my trains of thought, what about this as an end state for this series?
> (completely untested at this point).  Get rid of the KVM mapping size checks,
> verify the validity of the entire range being mapped, and add a FIXME to complain
> about using KVM instead of VFIO to determine the validity of ranges.
> 
> static bool intel_gvt_is_valid_gfn(struct intel_vgpu *vgpu, unsigned long gfn,
> 				   enum intel_gvt_gtt_type type)
> {
> 	unsigned long nr_pages;
> 
> 	if (!vgpu->attached)
> 		return false;
> 
> 	if (type == GTT_TYPE_PPGTT_PTE_64K_ENTRY)
> 		nr_pages = I915_GTT_PAGE_SIZE_64K >> PAGE_SHIFT;
> 	else if (type == GTT_TYPE_PPGTT_PTE_2M_ENTRY)
> 		nr_pages = I915_GTT_PAGE_SIZE_2M >> PAGE_SHIFT;
> 	else
> 		nr_pages = 1;
> 
> 	/*
> 	 * FIXME: Probe VFIO, not KVM.  VFIO is the source of truth for KVMGT
> 	 * mappings and permissions, KVM's involvement is purely to handle
> 	 * write-tracking of GTT page tables.
> 	 */
> 	return kvm_page_track_is_contiguous_gfn_range(vgpu->vfio_device.kvm,
> 						      gfn, nr_pages);
> }
> 
> static int try_map_2MB_gtt_entry(struct intel_vgpu *vgpu, unsigned long gfn,
> 				 dma_addr_t *dma_addr)
> {
> 	if (!HAS_PAGE_SIZES(vgpu->gvt->gt->i915, I915_GTT_PAGE_SIZE_2M))
> 		return 0;
> 
> 	return intel_gvt_dma_map_guest_page(vgpu, gfn,
> 					    I915_GTT_PAGE_SIZE_2M, dma_addr);
> }
> 
> static int ppgtt_populate_shadow_entry(struct intel_vgpu *vgpu,
> 	struct intel_vgpu_ppgtt_spt *spt, unsigned long index,
> 	struct intel_gvt_gtt_entry *ge)
> {
> 	const struct intel_gvt_gtt_pte_ops *pte_ops = vgpu->gvt->gtt.pte_ops;
> 	dma_addr_t dma_addr = vgpu->gvt->gtt.scratch_mfn << PAGE_SHIFT;
> 	struct intel_gvt_gtt_entry se = *ge;
> 	unsigned long gfn;
> 	int ret;
> 
> 	if (!pte_ops->test_present(ge))
> 		goto set_shadow_entry;
> 
> 	gfn = pte_ops->get_pfn(ge);
> 	if (!intel_gvt_is_valid_gfn(vgpu, gfn, ge->type))
> 		goto set_shadow_entry;
As KVMGT only tracks PPGTT page table pages, this check here is not for page
track purpose, but to check bogus GFN.
So, Just leave the bogus GFN check to intel_gvt_dma_map_guest_page() through
VFIO is all right.

On the other hand, for the GFN validity for page track purpose, we can
leave it to kvm_write_track_add_gfn().

Do you think it's ok?


> 	...
> 
> 
> set_shadow_entry:
> 	pte_ops->set_pfn(&se, dma_addr >> PAGE_SHIFT);
> 	ppgtt_set_shadow_entry(spt, &se, index);
> 	return 0;
> }
