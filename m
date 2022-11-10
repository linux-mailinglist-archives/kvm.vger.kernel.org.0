Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 232FD6238B3
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 02:13:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232216AbiKJBNJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 20:13:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231801AbiKJBNH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 20:13:07 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB8FE20BFD;
        Wed,  9 Nov 2022 17:13:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668042784; x=1699578784;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=nXd/A7ACf4PzsVE/u6+t8YWewN/GUVrOnlshxev8U5Q=;
  b=mLEua2NZe/vXvWfcI8rhKoDX42fQXm5lbSZFur9hiDXpLs9T+t1iA0Dd
   nV7ql2gF7LtoMetO14GnS9feA4yquTls5Taf09V2m7ZnsY5gzy32MXVrP
   /P4LRmYm/0JuGYoJKcXCepR+I/OUk/xGXv5vFVPsvUNXaDnavZnxDLMkd
   76Wj9xEqiyRZq4bcxpn+VXedLtZ1U3lQte7NMogF1hpztEOVZUizEoPkK
   VQgvAGGPZGx9LV1dkRTmiWfXe/kOPqZ9TjnFfsVrwu2Lgde2XYxSJoIvC
   xpKCHWE1M+X9J60HqWt60na+KVgK04JNyEiIVyl4lLqk72sUhpTM1/ruh
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="373285145"
X-IronPort-AV: E=Sophos;i="5.96,152,1665471600"; 
   d="scan'208";a="373285145"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2022 17:13:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="705938863"
X-IronPort-AV: E=Sophos;i="5.96,152,1665471600"; 
   d="scan'208";a="705938863"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga004.fm.intel.com with ESMTP; 09 Nov 2022 17:13:04 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 9 Nov 2022 17:13:03 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 9 Nov 2022 17:13:03 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 9 Nov 2022 17:13:03 -0800
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.40) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 9 Nov 2022 17:13:03 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z8+7k48WhEvFE/k85kY2JmjdKdZeMHRe5S8+TMY9x7bwOXA0ye9R6I6e1ApjyllSIZBSnHQ8YGCRSXRiIgbjEMyZO2OHOjz9Q/5zalNqZxS7NO8TEBvnMzPc3wLF+KKzpAcLdHfuKiUuX5rgFpK0xR0JM/sK9t1TVdKr+WUHPEp64ukf0tDI5L2XVf1PsRHeJaiX2b+dvxDQLfi9efppCIaufb7MY5i1bvAOSyEODbec4h1kWJdFfE2qSAxt4xnUCS1cFZNZugucOykx+x16BrbNlzcf2Hn0Nj8TgeskBLDE4pbVlHQG69wzaiZq6sioYx/E759uLqjA1M90UQ8lxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J/DmpTX+zYZrmbEoqIVW9bBtCNaS0hywCusdPfnoQYY=;
 b=YI6O1IXCFCUrlhqw9Uta9/zU2+JVCKFsKA1caaiKoi0WbDY42m+McMpFWauiXewywgQytzCmpwDAUX4VAPWwuwoSycf+80K5b3zLJBQmOdJO5bVhXdgvgIpzHGXMAzUoRNOA3HrTrWtTLiIAekRC5qv5+I0CVhidpuR7b/QiCUt0f9MW55m2gJJCk/uSr8KbEGBFvn+jXOiaHNZWuh8i6laYs7utmzClx/+O0rNkSPebOLjl9JSjhcH0tGPFaoeIi37D7fYJoUsztIcY4AuitPFVR9FjwoijUUQQpTOoyxBzRr1NZtvKL3enqL75hkFh0a7blaeYsax4B2aSqEk3NA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SA2PR11MB4985.namprd11.prod.outlook.com (2603:10b6:806:111::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.27; Thu, 10 Nov 2022 01:12:59 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::dc06:6d36:dc8a:fe7f]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::dc06:6d36:dc8a:fe7f%7]) with mapi id 15.20.5813.012; Thu, 10 Nov 2022
 01:12:59 +0000
Date:   Thu, 10 Nov 2022 08:50:10 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <pbonzini@redhat.com>
Subject: Re: [PATCH] KVM: move memslot invalidation later than possible
 failures
Message-ID: <Y2xKwvq4nkwMO4T6@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20221108084416.11447-1-yan.y.zhao@intel.com>
 <Y2qSwlN26qWi3ZqH@google.com>
 <Y2tNGHF5Lbjk4DQV@yzhao56-desk.sh.intel.com>
 <Y2xG1SY/kNULHFck@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y2xG1SY/kNULHFck@google.com>
X-ClientProxiedBy: SI2PR04CA0004.apcprd04.prod.outlook.com
 (2603:1096:4:197::22) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SA2PR11MB4985:EE_
X-MS-Office365-Filtering-Correlation-Id: 183af736-4da9-4957-a03c-08dac2b8b531
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: z32RQ4yevovA79kgJ/BLJINrv/UB+nOn8qjHYEOPFcY+8tZMm1xLhaw37tIheqBttA0gB0Yd1UPcdHtiXBr95N9mNq52n39LMRi0gw7L3VJcHRfwJ2A26roYC4n+eFhZZPzLKoOEQv0KsgxrgrlNsedU2joVAG2xvBz181ZDJ3vHORfT9g+XFXm4lmSDXq2jYzyMRQcfhSch1PDjE1zms8fdR+bbu4IoKXJCJU/V4WUyFC+F+H0SoktuyUVENqN2LC5L/H7tf9VPcOQsMKGpv+34Xm/bvs2XDOAIXXLaB7XtMNrhbkYjymuDLCd24ooTfnuc93TP6rOdtn02oTUtE3vV7lblfaSr5BPx2ooI4PJLhAHZST1GokmySF74f/TCb9/+rjge7CtYbsz9UiXGYXt5j+/OCN8vFhcE+842EwaE9N75Dhe2ETfTBGDsXPrUAfF6s1BsnMYsr/knDcRJtJX58iuukesVbTZV3PBIYeC+WZ0mMyx5CCig40XzYBNdtd9ASvp7ISMbpn4VM1ncZ0JYFsJnJ/Kbu5TfJA1PLmw8W0kXJCsgwXDkrWHCaW+BCbCmqDZ7NPsqC/B3NXXPdk4nolfQbZBr+WwACLTXsP+oNj5JaHN7+tUx0VTKPKzvz3O2JG2l2fv6vQPilAi6/0ML+mLDm2Vt3NuQaClPSYJ7NZwneZ4JrQQNyNyqhHKM+riixRzUr8k0IwQGHWxswg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(39860400002)(366004)(346002)(136003)(396003)(451199015)(82960400001)(186003)(6506007)(5660300002)(2906002)(3450700001)(86362001)(6512007)(66946007)(66476007)(66556008)(4326008)(8676002)(38100700002)(83380400001)(8936002)(26005)(41300700001)(316002)(66899015)(6486002)(478600001)(6666004)(6916009);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xHAVHKDmJ5Rq4Sp2BuEZ3x4zhUcqu3hkuIW47ZhGPfpuydpGPToO4vaTFi8c?=
 =?us-ascii?Q?Nc839N+cWkmOoKRRUcjXg7/OaTiFcWLZXwDV/ozC8FBXkzZym6wonUblaSRH?=
 =?us-ascii?Q?WbX6bHEyKI52ECwKerKd8Vmdh6vUP6yPOrIbQzIDNpTVGDPB0MmXi+CqvLob?=
 =?us-ascii?Q?snPSzcHNGkvNB16tji84qfEXMxg4AuikqjhiV5DxwFDENsZ8Y2c9O2RFm3Yv?=
 =?us-ascii?Q?/yD/JzLU8NWwXJHE1Vksu6d+hx/sI1ik9OzcaQP8zQnIzPFyAeNjOx21aD1F?=
 =?us-ascii?Q?ZdyjnOowIMIsyzCc6J8pVNTO+gmFi/4JNdb0C8+Y9fJZts0JlGhcgJrrq08r?=
 =?us-ascii?Q?oFNvMeSa+awgHyDQIxaP0uOaTNuHEYDWDD5umxwdXUdnl0qDoN+re/EZmhDN?=
 =?us-ascii?Q?ciYdHqvcjo8UThtNmSkOfXEmgrsH0k6sVlscxUPZuDTsZqSGxNHtYYrAknHX?=
 =?us-ascii?Q?zOChcamwuUpo8LlXn/+x4KDGFpPV9eNB5KmsAC/NHqU95tRaNgat4M8DFPbm?=
 =?us-ascii?Q?YZ3CosNK6YR77Wv2MTmZ/GVeqvO7sFqn35CUISx0M7XwMToOgnuadbqXhxrm?=
 =?us-ascii?Q?itoEr1BAdha+nIXh4nEXXOx4AX/hNa2xj60MDDYR7FqhDv5Fvjxgugv478TV?=
 =?us-ascii?Q?gWlghNjy7bkCRpcMIlV6yMBPmRxB6IpTWahJdrczvh7Fnkytjrdh2vu4cE0L?=
 =?us-ascii?Q?RdPOIHvS9AWKynYj7iihZVLEWErWz2qbjMpHQ06lHMEEjNVNdpBhpeDblLn+?=
 =?us-ascii?Q?lMa0ETAbh0hzgnBxIY1ICY4uW5VD/+qUS3tc1wtItYAHmsMxB5uEotY752bw?=
 =?us-ascii?Q?FQMgFRIqCj4wP/z/bkDDqcHSYHAs4FsUInQLj43ORjHdzoGm6KCESTKHMm8o?=
 =?us-ascii?Q?0ipUR5y8eUFuOHz0gdqt35bjqTPTRDH6TKbhdV3si9OAfF0GYOrFGeSG2Snx?=
 =?us-ascii?Q?VUaLh8w45T3L9avJyRP+5nJA2l1ssUeamPlTcWz4hCdi0CjlCEcq4Lz9bLo3?=
 =?us-ascii?Q?4N0e+vFk6T8im5TkRdT4ODZPQwmN2CwxT+jMf1TWgsJ+nNW34gzBa304ft8N?=
 =?us-ascii?Q?WJe+NaTxXiAdcZ9pDa1kB/1qXEFrGPwbpJpxrJg/VqRID4ZjYPlOOPYL6Qsw?=
 =?us-ascii?Q?NnLue/IcgNKsZeN423/vG5iS0LUqYYtN08YLTVjCosNBTUE3DFL++AbbUMUq?=
 =?us-ascii?Q?yf1DUXaynapSW5UeX/lD16Moiv4dstka7zB48y84NaxoEwCXUBLJZZNB1+it?=
 =?us-ascii?Q?ROMH5OUP9W3a1ZMvV1FLsgJDMSx0KTB6S38WYEbqVjiniwGLX+C3VBWhfz8H?=
 =?us-ascii?Q?/WNdCqcVju0bp8kO+9BzVpoa2sntIWY7cQuDh4xICNrsEV7xmytY5O084Cnk?=
 =?us-ascii?Q?ZwawfPwemGeYpfNmxBf9THCqoC844H662qqdFby+ApukQWm8zZABB/9jxhrz?=
 =?us-ascii?Q?A58CFr6OSWt3oiDPmccPr4KCGlFbXLmZs97zIx7IOUo+KPl2kW2p7f2ca6KS?=
 =?us-ascii?Q?UvlEdOSep4f+HRKgyqmF6nQ4rJpAnm7H5OO+LTVv0XkV01vdLjEtTMjlWdrL?=
 =?us-ascii?Q?OfJgpd1VAP9RNGh4/c95qXRvmZf6e4bsTNKMmhzVzjnOP4P/bWLiCBkJExC4?=
 =?us-ascii?Q?cA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 183af736-4da9-4957-a03c-08dac2b8b531
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2022 01:12:59.7920
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: efTNiNgGnOQh396urO4f77YRJrajF2XeF1hD/uPIo73+/G657kLK42wqeI0j6GzuJYe3WDBjWGKgaA9KtwfMAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4985
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 10, 2022 at 12:33:25AM +0000, Sean Christopherson wrote:
> On Wed, Nov 09, 2022, Yan Zhao wrote:
> > On Tue, Nov 08, 2022 at 05:32:50PM +0000, Sean Christopherson wrote:
> > > On Tue, Nov 08, 2022, Yan Zhao wrote:
> > > > For memslot delete and move, kvm_invalidate_memslot() is required before
> > > > the real changes committed.
> > > > Besides swapping to an inactive slot, kvm_invalidate_memslot() will call
> > > > kvm_arch_flush_shadow_memslot() and further kvm_page_track_flush_slot() in
> > > > arch x86.
> > > > And according to the definition in kvm_page_track_notifier_node, users can
> > > > drop write-protection for the pages in the memory slot on receiving
> > > > .track_flush_slot.
> > > 
> > > Ugh, that's a terrible API.  The entire page track API is a mess, e.g. KVMGT is
> > > forced to grab its own references to KVM and also needs to manually acquire/release
> > > mmu_lock in some flows but not others.
> > > 
> > > Anyways, this is a flaw in the page track API that should be fixed.  Flushing a
> > > slot should not be overloaded to imply "this slot is gone", it should be a flush
> > > command, no more, no less.
> > hmm, but KVM also registers to the page track
> > "node->track_flush_slot = kvm_mmu_invalidate_zap_pages_in_memslot;"
> > And in kvm_mmu_invalidate_zap_pages_in_memslot, memslot (actaully all the shadow
> > page tables) is zapped. And during the zap, unaccount_shadowed() will drop the
> > write protection. But KVM is ok because the dropped write-protection can be
> > rebuilt during rebuilding the shadow page table.
> > So, for .track_flush_slot, it's expected that "users can drop write-protection
> > for the pages in the memory slot", right?
> 
> No.  KVM isn't actually dropping write-protection, because for the internal KVM
> case, KVM obliterates all of its page tables.
> 
> > > AFAICT, KVMGT never flushes anything, so fixing the bug should be a simple matter
> > > of adding another hook that's invoked when the memory region change is committed.
> > >
> > Do you mean adding a new hook in page track, e.g. .track_slot_change?
> > Then right before committing slot changes, call this interface to notify slot
> > DELETE/MOVE?
> > 
> > Not only KVMGT, KVM can also be affected by this failure to MOVE if it wants to
> > support below usecase:
> > 1. KVM pre-populated a memslot
> > 2. memslot MOVE happened
> > 3. KVM pre-populates the new memslot (MOVE succeeds) or the old one (MOVE fails).
> > So also add a new interface for the MOVE failure?
> > 
> > > That would allow KVMGT to fix another bug.  If a memory region is moved and the
> > > new region partially overlaps the old region, KVMGT technically probably wants to
> > > retain its write-protection scheme.  Though that's probably not worth supporting,
> > > might be better to say "don't move memory regions if KVMGT is enabled", because
> > > AFAIK there is no VMM that actually moves memory regions (KVM's MOVE support was
> > > broken for years and no one noticed).
> > >
> > So, could we disable MOVE in KVM at all?
> 
> Ideally, yes.  Practically?  Dunno.  It's difficult to know whether or not there
> are users out there.
> 
> > > Actually, given that MOVE + KVMGT probably doesn't work regardless of where the
> > > region is moved to, maybe we can get away with rejecting MOVE if an external
> > > page tracker cares about the slot in question.
> > > 
> > > > However, if kvm_prepare_memory_region() fails, the later
> > > > kvm_activate_memslot() will only swap back the original slot, leaving
> > > > previous write protection not recovered.
> > > > 
> > > > This may not be a problem for kvm itself as a page tracker user, but may
> > > > cause problem to other page tracker users, e.g. kvmgt, whose
> > > > write-protected pages are removed from the write-protected list and not
> > > > added back.
> > > > 
> > > > So call kvm_prepare_memory_region first for meta data preparation before
> > > > the slot invalidation so as to avoid failure and recovery.
> > > 
> > > IIUC, this is purely a theoretical bug and practically speaking can't be a problem
> > > in practice, at least not without completely breaking KVMGT.
> > > 
> > > On DELETE, kvm_prepare_memory_region() will never fail on x86 (s390's ultravisor
> > > protected VM case is the only scenario where DELETE can fail on any architecture).
> > > The common code in kvm_prepare_memory_region() does nothing for DELETE, ditto for
> > > kvm_arch_prepare_memory_region().
> > But as long as with current code sequence, we can't relying on that
> > kvm_prepare_memory_region() will never fail for DELETE.
> > Or, we need to call kvm_prepare_memory_region() only for !DELETE to avoid future
> > possible broken.
> 
> Agreed, I just don't want to touch the common memslots code unless it's necessary.
Ok. Let me prepare a patch for it.

> 
> > > And for MOVE, it can only fail in two scenarios: (1) the end gfn is beyond the
> > > max gfn, i.e. userspace gave bad input or (2) the new memslot is unaligned but
> > > the old memslot was not, and so KVM needs to allocate new metadata due to the new
> > > memslot needed larger arrays.
> > kvm_prepare_memory_region() can also fail for MOVE during live migration when
> > memslot->dirty_bitmap allocation is failed in kvm_alloc_dirty_bitmap().
> > and in x86, kvm_arch_prepare_memory_region() can also fail for MOVE if
> > kvm_alloc_memslot_metadata() fails due to -ENOMEM. 
> > BTW, I don't find the "(2) the new memslot is unaligned but the old memslot was not,
> > and so KVM needs to allocate new metadata due to the new memslot needed
> > larger arrays". 
> > > 
> > > As above MOVE is not handled correctly by KVMGT, so I highly doubt there is a VMM
> > > that supports KVMGT and moves relevant memory regions, let alove does something
> > > that can result in MOVE failing _and_ moves the memslot that KVMGT is shadowing.
> > > 
> > > Heh, and MOVE + KVM_MEM_LOG_DIRTY_PAGES is also arguably broken, as KVM reuses
> > > the existing dirty bitmap but doesn't shift the dirty bits.  This is likely
> > Do you mean, for the new slot in MOVE, the new dirty bitmap should be
> > cleared? Otherwise, why shift is required, given mem->userspace_addr and npages
> > are not changed and dirty_bitmap is indexed using rel_gfn 
> > (rel_gfn = gfn - memslot->base_gfn) and both QEMU/KVM aligns the bitmap
> > size to BITS_PER_LONG.
> 
> Oh, you're right.  I forgot that userspace would also be doing a gfn-relative
> calculation in the ridiculously theoretically scenario that a memslot is moved
> while it's being dirty-logged.
> 
> > > another combination that KVM can simply reject.
> > > 
> > > Assuming this is indeed purely theoretical, that should be called out in the
> > > changelog.  Or as above, simply disallow MOVE in this case, which probably has
> > > my vote.
> > >
> > Yes, currently it's a purely theoretical bug, as I'm not seeing MOVE is triggered
> > in upstream QEMU.
> > 
> > <...>
> > 
> > > I'm not 100% sure that simply moving kvm_invalidate_memslot() is functionally
> > > correct.  It might be, but there are so many subtleties in this code that I don't
> > > want to change this ordering unless absolutely necessary, or at least not without
> > > an in-depth analysis and a pile of tests.  E.g. it's possible one or more
> > > architectures relies on unmapping, flushing, and invalidating the old region
> > > prior to preparing the new region, e.g. to reuse arch memslot data.
> > yes. what about just moving kvm_arch_flush_shadow_memslot() and
> > kvm_arch_guest_memory_reclaimed() to later than kvm_arch_prepare_memory_region()?
> 
> I'm not dead set against tweaking the memslots flow, but I don't want to do so to
> fix this extremely theoretical bug.  In other words, I want to fix this by giving
> KVM-GT a more appropriate hook, not by shuffling common KVM code to fudge around
> a poor KVM x86 API.
> 
> And if KVM-GT moves away from track_flush_slot(), we can delete the hook entirely
> after cleaning up clean up another pile of ugly: KVM always registers a page-track
> notifier because it relies on the track_flush_slot() call to invoke
> kvm_mmu_invalidate_zap_pages_in_memslot(), even when KVM isn't tracking anything.
> I'll send patches for this; if/when both land, track_flush_slot() can be deleted
> on top.
Ok. thanks. I'll watch and decide what to do based on your changes.

Thanks
Yan
