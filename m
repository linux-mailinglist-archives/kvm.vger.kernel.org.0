Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E16B606FCC
	for <lists+kvm@lfdr.de>; Fri, 21 Oct 2022 08:04:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbiJUGEi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Oct 2022 02:04:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229998AbiJUGEg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Oct 2022 02:04:36 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6023221E20;
        Thu, 20 Oct 2022 23:04:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666332271; x=1697868271;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=O+bzw3s2LWrNgnmWD/ZLsQK8uzFcemCMCSeJuewmOXM=;
  b=n3kNNsCkaNUWELrscfLZrwiNBbgLStpNq3fI2s0O61KeVqDfoZQ+O/2l
   f3M6ttrxw1lQ9nWLdrvCDZZGN5sy71rW2OcCH3QCCq+zzELH28iDZmULw
   KsqEqR6XAYkyfd2GLywdvZncQjQzCwa+gODXJnW912O4V3GctYHaKobCF
   c3muxR/+kXRaSv23XND2uR9UridU6aml1UIsoGwpV3wGYVkvcspZ9baly
   d21bSGLP71hNL+jot3reLgTEEphUAolji0SmDYkMEQsiTEDFaR16yJPDW
   ILI8ljtYeB4Mh6A9CH9EZTihnwDbdCh55sKt1A1zeADS3f5Lo1gieitUg
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10506"; a="308018326"
X-IronPort-AV: E=Sophos;i="5.95,200,1661842800"; 
   d="scan'208";a="308018326"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2022 23:04:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10506"; a="630302500"
X-IronPort-AV: E=Sophos;i="5.95,200,1661842800"; 
   d="scan'208";a="630302500"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga002.jf.intel.com with ESMTP; 20 Oct 2022 23:04:28 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 20 Oct 2022 23:04:28 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 20 Oct 2022 23:04:27 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 20 Oct 2022 23:04:27 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 20 Oct 2022 23:04:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GUi0LqEB3dx/jkU7kSTkRGEN3XLEkiKl6rhm+dtGmPpiVXNoESWURAmADzu+WY+W+TCIafyW/oW1u3JVAtdzv05bBqpdxxx9I6GAdiBBpqX8akZUHaLEoxwJ6pUxBL+OrbxMOCOecg623uoR17jTBDkOO7uaTp6+Z0b2AKL+O6jvlON/4eyOpscfcGe0ZYqCDz2uNwqF97B9l1yAvTLAdGq2gfOU4yvgCISrev8qxoUcCTwSDJbKUjNWCKuel0xhUGVmcoIml6Ndebet4N6X4KbfyFveTMAOqODO5fjmyKDcv/qnAIO0q3Z5nffORw7rpwJgXxsDQqk3Bq4wsCw5RQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sDPfySK/bPIZsuAiYT7j0tUxLxr4p0rKBRElQT6b7Pc=;
 b=RMnGRgb/RWty8PChhESK5QyyoBk9hD6Mmjs9umj920i9K68w2E5PBFtSa/G1dJMm9hRqX35kT6udHE4lmK+LGunAwb7be5hA2mSpGOVyct8HhZWM3dEbQToHksiSX4Yg+MPLo9hlBLYvljPBPp9WrQO8fmsSLjF8Np33cuj20Mi5Thd+CfwMXGbtcS3w1XpS8IFcq/o9GreacVkIliTUU5rap97Xq9wXd4K61b+3FW5d0gKUdCUUnM0FOirSXpFgVnX5ZimAHihijLyai61LromAHi79BS2eQh+/mXINVwf1+wcymXSUSQiYrdFrYBre1g6nT3xPqyBmquqBOT1pGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 MW4PR11MB7054.namprd11.prod.outlook.com (2603:10b6:303:219::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.32; Fri, 21 Oct
 2022 06:04:24 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e1be:376b:2662:16ad]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e1be:376b:2662:16ad%3]) with mapi id 15.20.5723.033; Fri, 21 Oct 2022
 06:04:24 +0000
Date:   Fri, 21 Oct 2022 13:41:51 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Mingwei Zhang <mizhang@google.com>,
        "David Matlack" <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v6 7/8] KVM: x86/mmu: explicitly check nx_hugepage in
 disallowed_hugepage_adjust()
Message-ID: <Y1IxH/GEa/LddQqU@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20221019165618.927057-1-seanjc@google.com>
 <20221019165618.927057-8-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20221019165618.927057-8-seanjc@google.com>
X-ClientProxiedBy: SG2PR02CA0097.apcprd02.prod.outlook.com
 (2603:1096:4:92::13) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|MW4PR11MB7054:EE_
X-MS-Office365-Filtering-Correlation-Id: 53a30611-7d9d-4887-ae7d-08dab32a1aad
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rsLSkbC1ptLu+SS1TtSu7FZj84uAks7Y+Ma1RAzbrPS6NM33QvR/RK1/EWqnE8zOoHwJZc+aUjOIrV7bSr70xCyp/2zfT122waUKNxZbO71kUWmSyePVCPVhW6lf3sEBzKuyYpwmzA95eTTs7oRKFj5qso2lMU7mcE+XXe5EBXI3Nrmmtl1td74AkkF3QD8r3UZYOCahMKnV3y2dPIVx8GypozJABKy5hAAHcYsHDvJtOHgCD1YhueoKvEPmSQWqMYpnSTiPPAtJhga+MsAfFDbVIDoML9uIUJl2DP+96qRyNTSQM/m2HnN7cgUlyNjzVZET7dGD+NRu6/wpme0AnC/eqbZg+oKB6BsAcoULNlLYwC2x4juMekRcRqdjms5MTVEOoGmE9chn1FEXnwjtEMyVLUNt09uSl7li2/mGkLmHGDiwbJqlO08eZ8Y1x0YT+EtV9pW3KY/BzR0W74RKauBZDYOIDQ/0yAPJUYBa040FH1oQFRu6mW+csV52nw2reEy2DHbeK0KsdKxuGxCXE3n2vqvEraFW3ueXc0AUleBdNXXJ0NLp1AGw1/3U3yd2rh0BYS9WSsezO1XZA18GNpUHFsnPZCHn00WGNTmypV7LkQnCc+WQy4ewORj5ZSueJhQvISQVjFZDdtVfChu7JjQWqJYSEEmQZZ0X71EdX4VE+Zgymy/NXP2m1pQIgUCtPQkm68cxjgrIyiNOTvS3hg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(366004)(39860400002)(136003)(396003)(376002)(451199015)(8936002)(2906002)(86362001)(82960400001)(5660300002)(66476007)(41300700001)(3450700001)(4326008)(38100700002)(66556008)(6506007)(66946007)(8676002)(316002)(6486002)(186003)(6916009)(54906003)(6666004)(26005)(83380400001)(6512007)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0CRrRJyWg9e1vDKVIsKbWdLA1WJu8irxJwrP2+6yzcFDpnw3tuTabPPeVLcc?=
 =?us-ascii?Q?xYPtrbq+j27h9FUt5Y0vrcRrwfoi1farqu5aszUYMHB23R6RI8QqLgK+KVDO?=
 =?us-ascii?Q?tQbVGcWWcZIEcqhBMWV8M/JC3HwBYGTsPoseKPklwhc+93dWBYwIZkagnP4F?=
 =?us-ascii?Q?Hrppvo7N1d+MH1siF/n5304GYYrRpX40eCIN4KI6bwTju1+pxm3mVCH+RAD2?=
 =?us-ascii?Q?ik/zYGyUeMSo5nyad9nqbkf9RZk8pnXTjqfjCsakAaIxOdfujzmOJ2/dKjkY?=
 =?us-ascii?Q?X9q8+7LMkcc4D1wLXZZmn1ltumguHN5Y05hPJysL3ye4wXlD3xCWRDOkxaNA?=
 =?us-ascii?Q?ZU0Mp4bwwB19z1m7Ut8+TiiSKn9C1nycfrgCZjJNy55A2BkrUq0bSqFc/ujm?=
 =?us-ascii?Q?tmlXKzy8IhDQj1uDzxiYS8Uyu2CssI6iCaIQ6u4hQDaN7NmX3fQ+OmAltSZE?=
 =?us-ascii?Q?31hd+b8UaDXPwtV80+gIOEfq0F6CyDebPDQUxBZmdxZGkn7c6hx9HiP5lYY1?=
 =?us-ascii?Q?X7BlWkfRIVrm15mZxR8QRvO8/uSrwRSV/NA3fSIcvyYsehRL8gs7aUdxuJht?=
 =?us-ascii?Q?F53itfjtg6HZULHXyOlWFA/jgGDV9gH9NLMi6YDOaFdS7ISUVtf7H+HBJ/t8?=
 =?us-ascii?Q?+/8doAWNU9dWn1cHqVb2T2m8/nTIgLADXBjxqvrn0IAHJz2sJQdb8ucrMnKY?=
 =?us-ascii?Q?4dxv16InhAqM1MOf/44FmfpI93BHyIuFlTVnn7w5cx3m47N04FiDR4SWCVkl?=
 =?us-ascii?Q?6MHiJPzJn7GiscZkdiRbSUS5qMSSzsIwB7xE9aD350HWOCIP5yvhpFdmAXAP?=
 =?us-ascii?Q?Hy7U9GAEBalOBqYJGOCPkRonggfscQvzTknJlgmR/VUB0pnJQiZIG/8TrI1a?=
 =?us-ascii?Q?Fp5SblC8oTWKPhwD9X4kBepX6oj9WkQSb3Vb+XQUDxnVe3Ptmdwyqf0hZkns?=
 =?us-ascii?Q?YtzNhiI5nCPjolmGgsK0Gi6jVCccoawjh/C6Zf9dj4EvFXDRRDscq2ua6LL1?=
 =?us-ascii?Q?rISstipamOk3k4ele1HeywvLtfmAZUmZzeQWg0PbuC3IOxeXsX/DU/RIk7B2?=
 =?us-ascii?Q?bMihlf0gSH460rNLMqi9hPY1d6ZRAG0grVHO1uGkiEwRQbFxvTK68WDtbYeQ?=
 =?us-ascii?Q?ZybzuMxN32tnLWrAav1y6i9x0j2zIrmk3vsH4uKVnVUmEZogOVHPUyiX4I9R?=
 =?us-ascii?Q?8q8uGYxKWPZAnzzmWBEqKofZJtVFB/4+rR19Y53Gh8/ifOs6+TZ5l9UTd6E0?=
 =?us-ascii?Q?oSfljxY77w996uYlb7Gpr81q8Ekfy/wvIPz39GLXM/R+nhP3bBCgJ0BEnH16?=
 =?us-ascii?Q?tN1nhI2azMJ0aoshh1IccfOSqOZdbzlvCrmAvI86VyNI17wJkFZboN9Q0/kS?=
 =?us-ascii?Q?UMYi/y1yCLhkCRPK9EEtGvqciQ6BtnaexQakgKRNJORfKBZyxyE/WOsbIx3T?=
 =?us-ascii?Q?4W46QNxmNxwfHnm/mMUs3XnwVagRpAmYMjzNrbhkFW7UE8JodVwXXMAo8XDw?=
 =?us-ascii?Q?FfJvQprXMBvG/ZRfWKx8a8FswzM6bOb5m2hO/w8Hlct0dq5pBQQ5AwTVPzlq?=
 =?us-ascii?Q?rUtxEssFm0I7LguHUWlCCXnL7EXhSJQZNmhT0NWYxvbsWv9o+xp/uxzoKxp2?=
 =?us-ascii?Q?0g=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 53a30611-7d9d-4887-ae7d-08dab32a1aad
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2022 06:04:24.4872
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EiEim62f+2YBQIVW6HZdbV3Y85K3DIrEGSO93/mDX/WwHH7xLwLvol52P4zI9tyqNEsIewrH8C9P9aWhVy3LAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB7054
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reviewed-by: Yan Zhao <yan.y.zhao@intel.com>

On Wed, Oct 19, 2022 at 04:56:17PM +0000, Sean Christopherson wrote:
> From: Mingwei Zhang <mizhang@google.com>
> 
> Explicitly check if a NX huge page is disallowed when determining if a
> page fault needs to be forced to use a smaller sized page.  KVM currently
> assumes that the NX huge page mitigation is the only scenario where KVM
> will force a shadow page instead of a huge page, and so unnecessarily
> keeps an existing shadow page instead of replacing it with a huge page.
> 
> Any scenario that causes KVM to zap leaf SPTEs may result in having a SP
> that can be made huge without violating the NX huge page mitigation.
> E.g. prior to commit 5ba7c4c6d1c7 ("KVM: x86/MMU: Zap non-leaf SPTEs when
> disabling dirty logging"), KVM would keep shadow pages after disabling
> dirty logging due to a live migration being canceled, resulting in
> degraded performance due to running with 4kb pages instead of huge pages.
> 
> Although the dirty logging case is "fixed", that fix is coincidental,
> i.e. is an implementation detail, and there are other scenarios where KVM
> will zap leaf SPTEs.  E.g. zapping leaf SPTEs in response to a host page
> migration (mmu_notifier invalidation) to create a huge page would yield a
> similar result; KVM would see the shadow-present non-leaf SPTE and assume
> a huge page is disallowed.
> 
> Fixes: b8e8c8303ff2 ("kvm: mmu: ITLB_MULTIHIT mitigation")
> Reviewed-by: Ben Gardon <bgardon@google.com>
> Reviewed-by: David Matlack <dmatlack@google.com>
> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> [sean: use spte_to_child_sp(), massage changelog, fold into if-statement]
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index f4f1b1591a02..14674c9e10f7 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3111,7 +3111,8 @@ void disallowed_hugepage_adjust(struct kvm_page_fault *fault, u64 spte, int cur_
>  	if (cur_level > PG_LEVEL_4K &&
>  	    cur_level == fault->goal_level &&
>  	    is_shadow_present_pte(spte) &&
> -	    !is_large_pte(spte)) {
> +	    !is_large_pte(spte) &&
> +	    spte_to_child_sp(spte)->nx_huge_page_disallowed) {
>  		/*
>  		 * A small SPTE exists for this pfn, but FNAME(fetch)
>  		 * and __direct_map would like to create a large PTE
> -- 
> 2.38.0.413.g74048e4d9e-goog
> 
