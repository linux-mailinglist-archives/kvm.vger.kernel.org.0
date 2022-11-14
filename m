Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84487627429
	for <lists+kvm@lfdr.de>; Mon, 14 Nov 2022 02:28:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235679AbiKNB24 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Nov 2022 20:28:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235634AbiKNB2x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Nov 2022 20:28:53 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C0E5DCA;
        Sun, 13 Nov 2022 17:28:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668389332; x=1699925332;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=PFP3z3SuD9XYtp1Tgx0R/Fg+Jm7saThFquCva7oqiL0=;
  b=Pevd/McEMjTsKgNu2a6GWHCjlkHQwtOIrTNJq469wCfNX7zdBAOZXNY+
   a9a/IjsLN/C/ka+9xjo7cxUDqP5KWv38ZgiHGMEFPHpuyzdsEBaHmQ0W2
   st6DR3Z4aGu3sgR/CZza7XJa4sm/fM9FBBB44oZL8s5PUDGRr9OeXgQ2s
   85IHpVv5WqspS4KyyT7D0OMW3nqtLX1/zBQVL2sPQYoIBOZJqhNtM6j8M
   gZtlSSHSTD5cuwJ9C6iTjWbofMxCDya8+X7WiY9g2VUe0y/knTo7FBxXo
   Tmn7+lILvQ72t4HqQGglYoVvtA1jcCEf10V+FBlluRCzWidcCiLLQH0OU
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10530"; a="292258005"
X-IronPort-AV: E=Sophos;i="5.96,161,1665471600"; 
   d="scan'208";a="292258005"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2022 17:28:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10530"; a="671368748"
X-IronPort-AV: E=Sophos;i="5.96,161,1665471600"; 
   d="scan'208";a="671368748"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga001.jf.intel.com with ESMTP; 13 Nov 2022 17:28:52 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 13 Nov 2022 17:28:51 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 13 Nov 2022 17:28:51 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Sun, 13 Nov 2022 17:28:51 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.48) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Sun, 13 Nov 2022 17:28:50 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XCAPqPV8/iyLSYJZtT3S8WuOIHZy5DWhy2wjH8dI+6PWH5sj1taxVBoxoXjTB0wGeeYdXB4UmGUvVJz2xYXAGXtsWwx0hBzPwkaL5x4PliFo6tMW7JOVBvn5O3MY118CtDx0DDIrsBf5cc+BJ7OYiCW07OYJkbEd+8+xHuPaik/08/bNZPPdIrsRP8t/O5Azmb+eoTbMLA1NzI4YFQrJGC0WOryws6bXGacBVq39z2vublrL393XmgBSDLz20EH0kEVGOF0VEcNCRUPFUdei10rqCzrvN9wtVIbKU+Z8FgzqxxJYnFG0TDs5yhtTZ/NVwbB+L8ZIf3gy/retjC1UfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iaFoNNVRjYeEDpgxwij8F18vOrA0zPVqaQbEy85relw=;
 b=d8DIpglrWSMtWm5azg/m8yf+sXMZwnYZJnZ2P1MBxdLcd7FHqktkxEf/RCcyonohHG7Do0ntybjx0cdoD52HTBmifaONsMHBotL3P09eOmZhcZDnhZ8dV9mkRWCWjSgWwAOXI7P8ofotjespZdeiW55C1CV4q/weH6Wfe0phJ0P1/5yVPIWPAtLRzvh6SbCaA8FdjWe6V8GOpjBDxnZ/yhLiRuCZVvL24ZrBM+MGkoDWlJeSuJdQs+ZqLRlQ+kpTMPBvlHlNX41Rr274ICHbf1qm0BrnojsRTsAWM19ruYSQefV8qqBWQs3lwsJBNX8VxEGZuonzzUvrIMgviJ1TOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 IA1PR11MB7341.namprd11.prod.outlook.com (2603:10b6:208:426::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17; Mon, 14 Nov
 2022 01:28:49 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::dc06:6d36:dc8a:fe7f]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::dc06:6d36:dc8a:fe7f%7]) with mapi id 15.20.5813.017; Mon, 14 Nov 2022
 01:28:49 +0000
Date:   Mon, 14 Nov 2022 09:05:58 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <pbonzini@redhat.com>, <intel-gfx@lists.freedesktop.org>,
        <intel-gvt-dev@lists.freedesktop.org>, <zhenyuw@linux.intel.com>
Subject: Re: [PATCH v2 1/3] KVM: x86: add a new page track hook
 track_remove_slot
Message-ID: <Y3GUdqxnPJvc6SPI@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20221111103247.22275-1-yan.y.zhao@intel.com>
 <20221111103350.22326-1-yan.y.zhao@intel.com>
 <Y26SI3uh8JV0vvO6@google.com>
 <Y27ivXea5SjR5lat@yzhao56-desk.sh.intel.com>
 <Y27sG3AqVX8yLUgR@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y27sG3AqVX8yLUgR@google.com>
X-ClientProxiedBy: SG2PR06CA0239.apcprd06.prod.outlook.com
 (2603:1096:4:ac::23) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|IA1PR11MB7341:EE_
X-MS-Office365-Filtering-Correlation-Id: 92622c42-99c4-423f-4678-08dac5df949a
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YhqBMg+vyXjlZc8dMpExyTD/pcEmJiPuviT1Il0/tbx0OY7G57d50NJg4LFkXCIf6uNhPaxm+/h0QrtMfXzFJx19Fc7xmknGn4lfq6jvpTrS0gfgxTo/923rTn3l3z+rCrGRQI+2ztzPFFlgtU78BsWy2tS7VeJ5X2EMb0PidbIJ3AYd2+gulZAX5H3LFsrp8AgLcT3n3XIXbtjXVtmQeWoNGTMuDpWF+veXSX90P8FPtHgQTH3Uj+/ZeWrjvYWLKFu9L0Y12YxQcx2bDBzy1yJXEyd8GgrFM5dRWOD88FWRP5ClcCvT+jkl1yOaAFXbjxJ+vmlhc4KfuCX+cQRmPebB0YNYySD4lTfqk8JueOXKJEzU2fg/GE7JioD+xzqvwneI72uxo2Bupn8rVIiCgxLd1XtVu1OcepaCVV4Z66kcLs6ma112VaN8lInYa/r36ecI1+WDxdXi0WVU//50Pbs1ct0N1Ov6cx0LFVW9esfd26UN4WwnR2pE5WVL6pLsOQXYC/HMAmhh7G/ySJj2woa6Vh9gowvzW51+1nqgPe8/m1S4s7X8tdY0R6L+aljsLHsZcDUhIDB69XEEBTve+7p5vnZD7URxNTZH1j7AI5K7FQL1BxGrH/AUpw++yGya8BXz79omGkRfr209n8vtWNPZCFbct+uF5Fn7wXx16OHwXYLuC4xnVhyJovOLS7guiQ7Yj62ElFk19M+sff/VEw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(39860400002)(396003)(136003)(366004)(376002)(451199015)(66556008)(66476007)(4326008)(8676002)(66946007)(26005)(6512007)(8936002)(186003)(5660300002)(41300700001)(316002)(38100700002)(82960400001)(86362001)(83380400001)(2906002)(3450700001)(6666004)(6486002)(6916009)(478600001)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YsuJPWFYBO/P3EUabUYIOv99t393Tn4HEe3JIHH25FGyb+zij+h78fbiSneP?=
 =?us-ascii?Q?Rvcc3gf/idWY8xC0y+JvHDFDQxW7238E7mHLAHVsskjdooyV6JvnkVJ3Jn7j?=
 =?us-ascii?Q?YXO/Wq61Dak0ciwIb+g2xm/jXjePZqufo1rFx+ei+r01kZWocfsUU2jWv/r2?=
 =?us-ascii?Q?gPvNbbP3Bu8Px1jh5IVJWwIqfn8HRwlT17mKyf5MEjO6XG55Fm+jgF1UgPFl?=
 =?us-ascii?Q?kzQyveD3o9fJje3PQ+VHqT9HKsKnQmYgchy8LgfwI8EKs92vW1y98hjSBg+v?=
 =?us-ascii?Q?fT+5zqzti/MPdYHzLrFvoYm9VPXZKwus5sV1yK7OnlRbdBaJq3WeWJkH/t6r?=
 =?us-ascii?Q?4l+NoBQl8wS5RRY89TntTyrt8o7qOf3SeteX/llDrgq7MwJ+/85C7yQzL8N6?=
 =?us-ascii?Q?hP++PGaiwpgtZTq9kP8MIkYwayhnwvWppOh8aye2kMVigBvESznB1D+ZBXPY?=
 =?us-ascii?Q?9SaiR2Uf7ve/eXbzmE4KPTauOhNPob1eSLhkGak0pGlLd4zl8Lee97naVgl+?=
 =?us-ascii?Q?wp+yGXxo6EA4CvNlR1V092rZZA34D2+zoAd6T1oa1Ivgn+6zXd74Rl8tkdoB?=
 =?us-ascii?Q?kE0SWWpM6z7cvdLp7osaayaIRv7vSFB2pV80nYe/N2x7qGHUGloa9zVsdTCC?=
 =?us-ascii?Q?LWMzmJR9IIUoB5CR/ddujZlUaRRyiQw8ksGNct/v9XP0QGqMbscGc9ovy57E?=
 =?us-ascii?Q?7nO9T0oKuqEjRV01WvWR6oFwHYskkKZWMcCPrvFhrC6sdo7BLmRO+J/aSWaA?=
 =?us-ascii?Q?5JIzEPK3adDqDzXInOwCtgfRX/1/dQgfssaMebD6bcDUlGiW9pgkGNtJhc6d?=
 =?us-ascii?Q?+yIrl+hAglm3qKoToiBLSCi19CCnCFUWr0gIvcgkAisGmwnUOTMS9S8bu1af?=
 =?us-ascii?Q?KSi90vgmqpBqDzSw36SUCLsOaytKi0U0aEEc+0TAyrUgLm4IsX3767WfNG0D?=
 =?us-ascii?Q?or4lSZQJQFvvD7Jd4FdSKmJpF2AAxASSwHwwzVlzeS9Wn1gi0oMPH/lCngYk?=
 =?us-ascii?Q?m7apJ8iVocrnyloGEo/fYbDEbO5WRSTnKemgiebUPM05l+MIDGAOWKWG52Ux?=
 =?us-ascii?Q?QL351JS/DTpu+p4dAVfAU0jsS+QVtNvh3slZPe+PJFXfA52ojRvhkQV7wg4X?=
 =?us-ascii?Q?/d7on8wHLxlM25wZyL2Rod8HrjyPWCbEB2Ig4E8jkrVI5Sub6mOEr15j2oKS?=
 =?us-ascii?Q?H17jqtiS57aJW4tucfom0lcbhWGdI1COZI8V+YH4wO+0oqk9EzJhBLAkj9PU?=
 =?us-ascii?Q?WsberQt7rnG0uMrcaL9/Q0OeRLXdcMEuende5FsAeujsvLNUTaLIwwSW2b4W?=
 =?us-ascii?Q?BIdAuFLnWIvB1Q7m3PXHZmcKHwQyjat47QpZ79IlMGZ4dfRJqufCRLcF2slC?=
 =?us-ascii?Q?lsMO+QSjI91DjnvD/tqXkwqSQltej6IellvsQUNNNdvHMl9FHJlKwMQ4jWw8?=
 =?us-ascii?Q?xZ2kroZyrTkvyLm81/JH6gE6Xnkge+FayVQHewrSCDJFJvhyKs/nuDVAw9l3?=
 =?us-ascii?Q?ACAl4AOlp6Y47j7XBB5rA9X54IRj9T/NKYTW8xk3T7BTt81z/QLMWRgAeRCg?=
 =?us-ascii?Q?UWQNHCBNiN9XdTGG+x7f6bqWb4br0oBU4Ea3QUFn?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 92622c42-99c4-423f-4678-08dac5df949a
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2022 01:28:48.9269
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bw8nzjuRC80kmL61eVLUO+NWJ/rjG/Guasl8PZ0kk1+Wzbfi7VvsxGxtUIh8mmS9ppsfaI1PYhiJXb2PqMP5CA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7341
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Nov 12, 2022 at 12:43:07AM +0000, Sean Christopherson wrote:
> On Sat, Nov 12, 2022, Yan Zhao wrote:
> > And I'm also not sure if a slots_arch_lock is required for
> > kvm_slot_page_track_add_page() and kvm_slot_page_track_remove_page().
> 
> It's not required.  slots_arch_lock protects interaction between memslot updates
In kvm_slot_page_track_add_page() and kvm_slot_page_track_remove_page(),
slot->arch.gfn_track[mode][index] is updated in update_gfn_track(),
do you know which lock is used to protect it?

Thanks
Yan

> mmu_first_shadow_root_alloc().  When CONFIG_KVM_EXTERNAL_WRITE_TRACKING=y, then
> the mmu_first_shadow_root_alloc() doesn't touch the memslots because everything
> is pre-allocated:
> 
> bool kvm_page_track_write_tracking_enabled(struct kvm *kvm)
> {
> 	return IS_ENABLED(CONFIG_KVM_EXTERNAL_WRITE_TRACKING) ||
> 	       !tdp_enabled || kvm_shadow_root_allocated(kvm);
> }
> 
> int kvm_page_track_create_memslot(struct kvm *kvm,
> 				  struct kvm_memory_slot *slot,
> 				  unsigned long npages)
> {
> 	if (!kvm_page_track_write_tracking_enabled(kvm)) <== always true
> 		return 0;
> 
> 	return __kvm_page_track_write_tracking_alloc(slot, npages);
> }
> 
> Though now that you point it out, it's tempting to #ifdef out some of those hooks
> so that's basically impossible for mmu_first_shadow_root_alloc() to cause problems.
> Not sure the extra #ideffery would be worth while though.
> 
> slots_arch_lock also protects shadow_root_allocated, but that's a KVM-internal
> detail that isn't relevant to the page-tracking machinery when
> CONFIG_KVM_EXTERNAL_WRITE_TRACKING=y.
