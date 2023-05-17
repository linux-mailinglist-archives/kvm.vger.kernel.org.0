Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4292705D52
	for <lists+kvm@lfdr.de>; Wed, 17 May 2023 04:32:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232098AbjEQCcM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 May 2023 22:32:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232096AbjEQCcK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 May 2023 22:32:10 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC31B4C1A;
        Tue, 16 May 2023 19:32:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684290728; x=1715826728;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=FIdxsOsQ3v7+cdRKcpHI8lUjiIj+FAiqemt9Rxd9Lqw=;
  b=IHkHOyXQLpfNDyjmlE+QQcbffVCUZ09j3iZIgtbv4jo8xm4jKDKzWP4d
   MfhcZXL01QdGtJr3kj5xro2jivNnz0aIAsOqzPHfP79Y6dcupvfEijq7D
   djrCgblIXv2UA2dUulTrlpbVXQlVGA6wygmhNZ1yXA6fQtsbmKKk43JT1
   k4iULT3539BUiso0vuD1TRGb9YlsQMj83siYBuFji1AueDI5WRfBaOP2d
   PMpz9UgUNFRJF2VjbjY0Mxy8PHzbl1Go3Na2LGiKGMcPCPLmCGXCgLSUV
   eRQGPDIs3h/Gozm0IiETZdOmFoIukVrK75vgZLCjIKFrkdT2UDX3qADCS
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10712"; a="415053028"
X-IronPort-AV: E=Sophos;i="5.99,280,1677571200"; 
   d="scan'208";a="415053028"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2023 19:31:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10712"; a="679096902"
X-IronPort-AV: E=Sophos;i="5.99,280,1677571200"; 
   d="scan'208";a="679096902"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga006.jf.intel.com with ESMTP; 16 May 2023 19:31:57 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 16 May 2023 19:31:57 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 16 May 2023 19:31:56 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 16 May 2023 19:31:56 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 16 May 2023 19:31:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aclhzpVreEBt9+pKuWC0ZFwDIJHMUEyc6efk8W9LmcBkDTrKwyNbRy6RCyt101eB9YGC/7TvJZ7ag1JiqrZpbGO5LoUSfjieQ9Cs57adAckZT8Dt93TD3cfYxQRQDHzlD0CjRsZrIRCf/blWuz/N/qovPjM8c7EEAVqumXu5ucbPLLm2LIYpHY93Og2149Ho6F2DeqKi9DGl9OSzbr/Y7NLQFXs1MDz6MvUZpZwntr4mHA4qxEAaLYR31/NkNFqIajPLvgJm8KMF/HqJV2av8xhaqhW+rP5qBVLOeyQkxCu3nrbNPYlSu7/riO9redUpDhOaI8CmjmuYCpVmiHzAIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iZivDLnsmL5CRMds4fla1qghINmsngOFmB5wlhtTOHI=;
 b=Up1LL3KJJotmgNwjNp3XiZipQwcl0GIdHuc7SF3Z0O6vr8Tniv4/kl/r4LIEFBZbSmdCzpFk+I0SM4lefyhDVqggK987LZCwW+8Oe6cB4kHgSUThrH4S3x27eXDv+99h5MoknY1qxBaPHJmPRfYNRK2EcvTahLxeFq4SXOdaFIvOBSM3gPijdV7Zzy4/AgroBToco58h4LTBZCbq4CLv5TfC/mOJb7KgMpACH4RLn6zNTQ/PLDgE7wW2ufhK/p8vWsYW2wcm0CY0qApr+yPaZUdsurqoj3VSLaWHw1ZvjcqfHTNViinl0glHnLx7C1VyXNJ+9RFG0cD37xEpx+9dkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 MW4PR11MB6785.namprd11.prod.outlook.com (2603:10b6:303:20c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.33; Wed, 17 May
 2023 02:31:54 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::a670:49f5:d602:e2e4]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::a670:49f5:d602:e2e4%6]) with mapi id 15.20.6387.033; Wed, 17 May 2023
 02:31:54 +0000
Date:   Wed, 17 May 2023 10:06:46 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>, <kvm@vger.kernel.org>,
        <intel-gvt-dev@lists.freedesktop.org>,
        <intel-gfx@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v3 12/28] KVM: x86/mmu: Don't rely on page-track
 mechanism to flush on memslot change
Message-ID: <ZGQ2tslYJWSqpRh6@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230513003600.818142-1-seanjc@google.com>
 <20230513003600.818142-13-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230513003600.818142-13-seanjc@google.com>
X-ClientProxiedBy: SG2PR06CA0233.apcprd06.prod.outlook.com
 (2603:1096:4:ac::17) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|MW4PR11MB6785:EE_
X-MS-Office365-Filtering-Correlation-Id: a8633149-343a-4ff9-80bb-08db567ee08a
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mJ33zl30a93sYLcl4qmy1nxLP97OB6vKMiZ/gQShqeFQ6jnNmuGAMK+qnp02pdzuKzuM+hhZu1mRvY97oY2lO14ltosyp6NCumYkEM4vvDmZlScKoFCvi2vnZIAwMLIIXpBGGUxVA8s/cgS7IsSIw+rNY+vO0Hb8EOEdI95jzzQZ3+SihuCPQ6FCRniq5zCNby7+XISoNAjNYPl5UiqObYxaUXY24UxoOEkmLoG2FoFou24aamS59RZ9VTMBUjA4Gi3Vzm4UaQes5NH5zbBdN7uKdmO+G27TWYtd8+reYJG6zGqYN2BUqoEGiehMT5qyTrXfsIwOYY7nS2jvDknkeibmfLEiZK9R3NkoS7JO3FOmudYaykd+vgbnMbFp3iuC7OsRYqV9raLwpjOlrnM0ChijgIOruhvdWhTffAp8hcteW5bBt+paeMD65gUopt2vabcbRvL3k9rouixyHc2VMTl3FJ4G7o86q4wgd05b8a3hUMcR/QDQftwAgzK9hqhw0jclVg2lmhzcYh4lphH3/HLB6JYATw948T7XQ5RtT8Q=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(346002)(376002)(39860400002)(396003)(366004)(451199021)(5660300002)(8936002)(86362001)(8676002)(83380400001)(966005)(82960400001)(6506007)(6512007)(26005)(38100700002)(186003)(6486002)(478600001)(6666004)(316002)(41300700001)(66946007)(54906003)(66476007)(66556008)(6916009)(4326008)(2906002)(3450700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IPUt/73n40/Q1sxVVum1ba50OaBSsTrp4+QMrhdZ+NDJ0KFyWADCGKltxk0P?=
 =?us-ascii?Q?TyA7+LMHB4fFbmk0qHnV7dfvyi4d0z68bVlSM1igaWz1hAfbIMheT1Bwum0U?=
 =?us-ascii?Q?MExxfWfxGrMQe1EAANZkel2rQGpl0KPD2gqTwEUO5EHJd3exZBgzWaFOtaeJ?=
 =?us-ascii?Q?1bjqSjmiahzdlJC843JSJdJAxsN0l4TWebPqVCKG3uuwKJBsWWf4jcMEOk+p?=
 =?us-ascii?Q?/E1hIRn+r/Hy1ggN5eccVZnItKMciscFOPrCBH6VKL/fDmvkSEglR5u/kSIS?=
 =?us-ascii?Q?OGfaYGJFxUEs4gT73Akw5UpDtB5wHPSDy0OYS0Nomz6SUsTgqs7yxdJ+RKkW?=
 =?us-ascii?Q?ZEoxIJ73jPRWbyL13unZ5zgWzeqyakAPUqRrh4gR6r7RkQvDhaJyVNc6wsiF?=
 =?us-ascii?Q?7Z9QW7VNRJvSdCSKjrwC5o4zaHRCffwdj0v/c2PsJ2aQBWEsbRPio/pJDRh5?=
 =?us-ascii?Q?7cU9o4S62jjSCt6YokqEB6E82XXMLvUm1LkKwQ9JrNVIcephGxrAQhJE+nTU?=
 =?us-ascii?Q?pyILSYjvTuBXKB5+uEPBdp/EdkZT3W//tV6v7WVh1vAKU/7KsDai1kfm0+bn?=
 =?us-ascii?Q?TaSggLLkKhIwWQ++LpGEBYnTnz8/odNbYT+RARyX88obckaoDTkwUwj4sn8l?=
 =?us-ascii?Q?1DbCmzekZuw6/E83VryYXtePY/YUE8tFQn0DQBOHicBaaUjS9DpzjR5sEXIA?=
 =?us-ascii?Q?ZvoKLjQZywEvsqkOzU9MwK58wEUgKWPt/qj9AyqD9l3/C8Wv8+wR6kTW8k4Q?=
 =?us-ascii?Q?Es17rNn37b8vbsbyPVicDcjqvvJ3m9zD9ZffJfpoKbNOXRKPPAm2poxg5lQ1?=
 =?us-ascii?Q?WPxrobY8E5mGQ2VYvWoOTCvEMmSxUu5XpI2hSZhhFmjE5QIDFiT0gGalXVEn?=
 =?us-ascii?Q?fIpjOp3tnXZ0Bze6fgBVXYcZpW4wK2JSbX9rePql64om0O/ebpjGdFvnyu71?=
 =?us-ascii?Q?QyQyKwikfU1c74nzCsGxt/qRO/boT2+vxt6W2YUi834BlKYq2WzKaM52d2ol?=
 =?us-ascii?Q?snzwbcBTwOrr0cI9vZqMOejOer6Gc8V0szHCWnuQXN6O0a9JuH8rObXr2knj?=
 =?us-ascii?Q?CiEkhMun1O0+A6sC3XOxhpc4l+sWQN7/cnDwRe/lFxluRg8pn00/H/E/admV?=
 =?us-ascii?Q?i6yYh5LGfhT8D2pUaIu2VTJLouoSYjzPpw8wVZNd9hETmpQ+azY/3Ny1NXXA?=
 =?us-ascii?Q?cu6GTZ+kmHICnSBCFlUoVnBDtiZtnJ+3zqNJglep0gBDR9QbYkMAL4UV1vol?=
 =?us-ascii?Q?92bg8fPD310wr3QqPnTbdwT2fngTdT+2JbCbITpfGc9p2ARk6sZxFqpqclU8?=
 =?us-ascii?Q?CxYKG8JOBxvo+UThLENDEqer12H1rOfwvAYtjwlW+5HMhG92U4p1tQMPoME2?=
 =?us-ascii?Q?QHEhuvju0HhRl3YrPzxMSZxAH1mL8zV9m66M2NmhKTNBUu3a/mDrdPlQW1P4?=
 =?us-ascii?Q?MsDMeAUy2hMJeSqq4B1uz7xNWPbnUnoaQGBqnQ4vD+h2l6ykrXnAVX7Us/s8?=
 =?us-ascii?Q?GKTdRPMv3HqMPuaLQKl0y+oDmX9ki62wlPXYYXjAKcKAeouWunRxv86qEojc?=
 =?us-ascii?Q?WfH1AQCOZHz4VFRQK8+52bFIydmu+ZRTRo00Kp+r?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a8633149-343a-4ff9-80bb-08db567ee08a
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2023 02:31:53.9192
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jOOKyqgJleJglzwHgz58hJ4F2t5LU2q3jTLICO5Kh0e2BLhk0w+52yJl5adcg1ZsN8yna+pNA7YYP5uHJUSuJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6785
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reviewed-by: Yan Zhao <yan.y.zhao@intel.com>

On Fri, May 12, 2023 at 05:35:44PM -0700, Sean Christopherson wrote:
> Call kvm_mmu_zap_all_fast() directly when flushing a memslot instead of
> bouncing through the page-track mechanism.  KVM (unfortunately) needs to
> zap and flush all page tables on memslot DELETE/MOVE irrespective of
> whether KVM is shadowing guest page tables.
> 
> This will allow changing KVM to register a page-track notifier on the
> first shadow root allocation, and will also allow deleting the misguided
> kvm_page_track_flush_slot() hook itself once KVM-GT also moves to a
> different method for reacting to memslot changes.
> 
> No functional change intended.
> 
> Cc: Yan Zhao <yan.y.zhao@intel.com>
> Link: https://lore.kernel.org/r/20221110014821.1548347-2-seanjc@google.com
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 10 ++--------
>  1 file changed, 2 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 2e4476d38377..23a79723031b 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -6184,13 +6184,6 @@ static bool kvm_has_zapped_obsolete_pages(struct kvm *kvm)
>  	return unlikely(!list_empty_careful(&kvm->arch.zapped_obsolete_pages));
>  }
>  
> -static void kvm_mmu_invalidate_zap_pages_in_memslot(struct kvm *kvm,
> -			struct kvm_memory_slot *slot,
> -			struct kvm_page_track_notifier_node *node)
> -{
> -	kvm_mmu_zap_all_fast(kvm);
> -}
> -
>  int kvm_mmu_init_vm(struct kvm *kvm)
>  {
>  	struct kvm_page_track_notifier_node *node = &kvm->arch.mmu_sp_tracker;
> @@ -6208,7 +6201,6 @@ int kvm_mmu_init_vm(struct kvm *kvm)
>  	}
>  
>  	node->track_write = kvm_mmu_pte_write;
> -	node->track_flush_slot = kvm_mmu_invalidate_zap_pages_in_memslot;
>  	kvm_page_track_register_notifier(kvm, node);
>  
>  	kvm->arch.split_page_header_cache.kmem_cache = mmu_page_header_cache;
> @@ -6750,6 +6742,8 @@ void kvm_arch_flush_shadow_all(struct kvm *kvm)
>  void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
>  				   struct kvm_memory_slot *slot)
>  {
> +	kvm_mmu_zap_all_fast(kvm);
> +
>  	kvm_page_track_flush_slot(kvm, slot);
>  }
>  
> -- 
> 2.40.1.606.ga4b1b128d6-goog
> 
