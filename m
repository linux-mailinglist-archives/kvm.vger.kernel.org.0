Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E0836BE2B5
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 09:10:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231313AbjCQIKU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 04:10:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231381AbjCQIKB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 04:10:01 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12370B53C0;
        Fri, 17 Mar 2023 01:09:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679040560; x=1710576560;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=E/phxLDUicnD0ZatVmeTVWylFn/8Cni7fbQpafmdByo=;
  b=IHU1r4RrYUwNHZWegn6UUFfJUgUBxt6KvRKaVn5pCFqK31eDmoZoPC5S
   bWmHkirv3I8dkU7vYLSNbGvIPO4NPbUpgaQZYAZprYtsJOWPWFpLEr/t9
   UowqTy16p7BR/C3gTg/ebQgKANOzbpacG7n26NoQYQ5PDgJVrhYF1flSJ
   NAepW2SMuLKlpfuZ2CqmGhD42hnub8MaaejgrX4VToV4qnob4FbCi+rLJ
   hlNwcjpXiT2P44NeCQ7QH5FBMhGO8Cf8DiqFsMRMtax71frI7kq4wOYKu
   BRF1sN4Oi/u+7vpPux0sctVbEaG8QqxzoVxXDo+OhENexr3qIICFK2Rx4
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="326570941"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="326570941"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2023 01:08:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="657472881"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="657472881"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga006.jf.intel.com with ESMTP; 17 Mar 2023 01:07:59 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 17 Mar 2023 01:07:59 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 17 Mar 2023 01:07:59 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Fri, 17 Mar 2023 01:07:59 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.44) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Fri, 17 Mar 2023 01:07:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ADdttbywrV1Jz+oadz77Smf7CVWWFPbXwdHCjk8+b+Yn58sm5U5eyQt+2cWxlGuTf6q9uPNNzMmc3j+mPnlbBaYwb7i6ROZjo7PCi+6ImPLTIBZ53PJk3a67O48Cfo7sBxysFUyTt3E/KhLtBpb0JsG7BIV7wZ80fFx2UVu/hnMam8L2DtcjRmJFyx/DYJ1awZspJfcNmOr3MIU1jd0QtAv+aBMOr1hZljNhiQwCSB+rHceLNoCbgXCvU9UAKPCf0UDxcUHZ1T9XMbtPCDuNEkpBdH0smuuR1csA+QyUd8waRlAAbMwukXZJzzlFBnHrEj8RlBQyDKeGqZdbql32Nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c9kAFZod6T8aT5rQOcVcGZGR5K+Ad1Z8ImqpSDCLnP4=;
 b=ROUi2kg912lcUul9iVY6+TvFlpLNa6KynINzf/C7vpqFl73n18vkKKgUZVx9JKICM2elG98qoGhRQCMMOFwoiPztlK67c4R1Rz6YEzGO52pb7mFloRvDxL0A8pQUATf4bWYY3xVkc4vtAi76b1nVvsUY8BJf2oxeIVFZSqtIgzDyDPyqRZNYp+aS41Mt1/i3jP9GV0fo0/fKM0pfT4QmLDBGNKIkoakSkBqbsJy1pisZ7oQC2batBInIzjy3VLbXhciJR340r7nwJUaSWmqKjkiTe8/UT2mpPwRb4GHcSJsyI9+RsdOxzyYq8jpwfMgq4VityoNgBnkqaemLyH62NA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SA1PR11MB5827.namprd11.prod.outlook.com (2603:10b6:806:236::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Fri, 17 Mar
 2023 08:07:56 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::b00e:ac74:158e:1c7e]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::b00e:ac74:158e:1c7e%4]) with mapi id 15.20.6178.026; Fri, 17 Mar 2023
 08:07:56 +0000
Date:   Fri, 17 Mar 2023 15:43:17 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>, <kvm@vger.kernel.org>,
        <intel-gvt-dev@lists.freedesktop.org>,
        <intel-gfx@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v2 16/27] KVM: x86: Add a new page-track hook to handle
 memslot deletion
Message-ID: <ZBQaFRdRawenuEan@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230311002258.852397-1-seanjc@google.com>
 <20230311002258.852397-17-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230311002258.852397-17-seanjc@google.com>
X-ClientProxiedBy: SG2PR02CA0012.apcprd02.prod.outlook.com
 (2603:1096:3:17::24) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SA1PR11MB5827:EE_
X-MS-Office365-Filtering-Correlation-Id: a1487150-ef21-4933-5b5c-08db26beb68b
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ai2iXrw2C1TdUoE4OA5irIi7ys8Biw4KRhbcLh6+VQi3zMf5TRLtiNzdfgWOXICQJdeir5GCfv4m6APq8Whl7BL5VX/b4bbKHzrQlZwWV3ePlhlwc1U0yjqDUKxQJAEJE2tPvU8LDTenIYe0KieonsJSf/ewFf2O7gI93/KK1kNsUrWW1w8ZuMEXWInq1w8sqLoEVog7WAjQ/O7mECZsRGTuAsTtmIqtoRLEitlJONVtGs/YEtUvNcDULwupLmzpO/AZ776YLTCc8MlxMxdcbC36y6tcafUmgiqawIZZJvgm0/7BIw3tsZGTraE8eWXS9kYNdPHSOCIDoUJ0w4fGy3d3UVB4UyGbCPZKc5uOV6K+tDho/vDJDbG4h5I6s/uwQoyzHh09C7D9d6QJaM3OhCo/fzEbssHtv6dRlyYb6nx5L9QYBiNauh/+YRRGH0W/KuBEwI70b2WwJbdim12JI/k3oOTx+b4nTU7s+g06bFJ9kWKTeRuXqlGhXVS/lPiF+N2jdCJBtefbJ8MdP0Rfr10g2P1rV2IeJwgL/FCOMuiRa989popSP42D7uz1zgAJbtAG8O1YHZ2q8GF7+cT/BPuNcwQhGYLwE75e+Dj53eO/GeyHlaQUJ1VQ4D7QcOqHyTZlCi0PMtrTZbCu3IPgag==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(396003)(366004)(136003)(346002)(39860400002)(451199018)(82960400001)(2906002)(41300700001)(8676002)(38100700002)(316002)(66556008)(54906003)(4326008)(6916009)(86362001)(66946007)(66476007)(478600001)(3450700001)(5660300002)(6486002)(26005)(6506007)(6512007)(186003)(6666004)(8936002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8xi3HLCgQB55T8BMYhFOSU6Pl4wxqWLuGbCvLTa5ZAmKi+w2GEtjA9eVNfkM?=
 =?us-ascii?Q?qtukVX20kv/SMb5HNlAp7R1h6jMGerybg29cUa0arSuNJfz0yimdQRPrtpnf?=
 =?us-ascii?Q?IipRmNUKcHk8+RLqAHkwCsq2sZ0y3mjdhIeiD5bt18f7rlY0TRUc5TXg5dkg?=
 =?us-ascii?Q?DOTKQ7noG3FBUQ3ajG/mH9GycnZOnBCJ4PoBAcbSo/hhzcQUpgPJqi6zY55H?=
 =?us-ascii?Q?7ZZUTH/GdlohHkXBrkD6kPR4etrGCA0HLrk1qjuidXtWxKaUtiwpkWfuAApr?=
 =?us-ascii?Q?zcltooTbZxIeyClWxOjRPd68kcaPEMLrPC/dT1Y33JHgHeilsUXsTtJOhfRk?=
 =?us-ascii?Q?WfBrl/Ka/1iIbjI3e5ilwgIci+9T1hi4SsFXJXdQBEUguuo+jD3LCTo3d6N9?=
 =?us-ascii?Q?6BESWK+H02RXKRIvatDUXsdh7bF1ETubYNlQ53p3S9LH27AvyRV0gDTuN1Cy?=
 =?us-ascii?Q?Gg+zHK+H0ckYz646EsPa3Aass1fQsVDW6guMXVG33pKRlyqfg2xDLRNyL7+9?=
 =?us-ascii?Q?HrNKukt/DOvSLHvGFlnRZuG1lvMYUpFvq1IYwmkKuj1xUazAbau5ekCtqcOL?=
 =?us-ascii?Q?Gqn+fy/hRVxbcEx/7XDtaBazdCsuRHePXCelqlXCTzzmicE+XdO5RIlwtQpg?=
 =?us-ascii?Q?q5svgZsGVAKuTU7i5bwvQvCQwv03pwmT2sDOXZuyIzNOvzSgDbPedvVURJ/B?=
 =?us-ascii?Q?KkuZCnsq4WcqlNimCilMHuqprZnCtBDpljo2NSiHazBrPXxPH41rrDELXiYC?=
 =?us-ascii?Q?UrZe7OMhesT9dbx3LEYMbISPxf9+RhfqWMlx1ymepUZleqvbl+Nq760RGWeM?=
 =?us-ascii?Q?9CTbJLJYzemqSqSuzpsbJZii/6ykCKuLk5fqRFrsCs/K/Lxq2TP7AEvjwJ8p?=
 =?us-ascii?Q?I1ut6RK6C5o7S6NaHjOPY6Xovks9dyqSmSJQ9XBJRut8zDQ1e9wz4B+1JSB0?=
 =?us-ascii?Q?WL0DrHQfSS343P82R/OXb9ryArtzV3AnFGECUHZaBaJ3Ryyza1rwYr3Er0CQ?=
 =?us-ascii?Q?4ToVBhObgYOQlEIvnQSJceVmCG1MJWUJhnA1/Xs/mY9cI6R3I9J9TqNKa8gD?=
 =?us-ascii?Q?DY+BWvHpmUCYuC1z/se8jsq1ZynQL9Db0+CM1MlIZGQH7BsX5w5ehKP1eUr/?=
 =?us-ascii?Q?aolZzmuWOWuiinbsIN4vysXblDol2aRV4eoaS+802Q2qDI4iXIBbOcQfHfyr?=
 =?us-ascii?Q?TYrJ29XCIHUKvojbJSqI0W2nSOUXPrEJ1JI/7+FTVmSU5Pmh9XYDiRlOh5ud?=
 =?us-ascii?Q?H+MFws/vpy8jmdH4/7c0+xvkROZoBov2q2JVOz0mYbbfuBvxlYiVEf6RqoMi?=
 =?us-ascii?Q?V5bVznpAAAds9laJB3Xa6IrNaCrXHS4rgKsZdngUrHy9nvfnik/b29JWeaRJ?=
 =?us-ascii?Q?cXtoHcAgWffrZKaL4nC+72GerGRFPwl1Ysv4LjaCGnQ0m576cfUuDF1WqqFI?=
 =?us-ascii?Q?zSlki2tEXSnWho0sEkai60DX46/AT8Ozny/SmEnTQZxx+MKycYaAA2aba7Lq?=
 =?us-ascii?Q?NcFhFRMyqXtGZ/GvP4bKy9msBfBrYb26Hadj1Fmz3CKkkjiUTwwYZB3g66ZR?=
 =?us-ascii?Q?W+HuxiQO4LpLff0Fp8ZjpN1udGDbVJkG7Je0xoMkXYhNaPvZaWW8aPPH95wY?=
 =?us-ascii?Q?eg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a1487150-ef21-4933-5b5c-08db26beb68b
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2023 08:07:55.3641
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wQ1KvjKijWt/0p7GMPZdROz6CHwsguyCXj/2epUHSlBLBMByi5eDSYe3nU6V13urq8WkqIfqmp6V4u1flLiiPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB5827
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 10, 2023 at 04:22:47PM -0800, Sean Christopherson wrote:
> From: Yan Zhao <yan.y.zhao@intel.com>
> 
> Add a new page-track hook, track_remove_region(), that is called when a
> memslot DELETE operation is about to be committed.  The "remove" hook
> will be used by KVMGT and will effectively replace the existing
> track_flush_slot() altogether now that KVM itself doesn't rely on the
> "flush" hook either.
> 
> The "flush" hook is flawed as it's invoked before the memslot operation
> is guaranteed to succeed, i.e. KVM might ultimately keep the existing
> memslot without notifying external page track users, a.k.a. KVMGT.  In
> practice, this can't currently happen on x86, but there are no guarantees
> that won't change in the future, not to mention that "flush" does a very
> poor job of describing what is happening.
> 
> Pass in the gfn+nr_pages instead of the slot itself so external users,
> i.e. KVMGT, don't need to exposed to KVM internals (memslots).  This will
> help set the stage for additional cleanups to the page-track APIs.
> 
> Cc: Zhenyu Wang <zhenyuw@linux.intel.com>
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
...

> +void kvm_page_track_delete_slot(struct kvm *kvm, struct kvm_memory_slot *slot)
> +{
> +	struct kvm_page_track_notifier_head *head;
> +	struct kvm_page_track_notifier_node *n;
> +	int idx;
> +
> +	head = &kvm->arch.track_notifier_head;
> +
> +	if (hlist_empty(&head->track_notifier_list))
> +		return;
> +
> +	idx = srcu_read_lock(&head->track_srcu);
> +	hlist_for_each_entry_srcu(n, &head->track_notifier_list, node,
> +				srcu_read_lock_held(&head->track_srcu))
Sorry, not sure why the alignment here is not right.
Patchwork just sent me a mail to complain about it.
Would you mind helping fix it in the next version?

Thanks a lot!

> +		if (n->track_remove_region)
> +			n->track_remove_region(slot->base_gfn, slot->npages, n);
> +	srcu_read_unlock(&head->track_srcu, idx);
> +}
> +
