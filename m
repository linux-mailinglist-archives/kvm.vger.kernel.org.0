Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9358606FD1
	for <lists+kvm@lfdr.de>; Fri, 21 Oct 2022 08:05:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230074AbiJUGFk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Oct 2022 02:05:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230048AbiJUGFj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Oct 2022 02:05:39 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D43E31EF2;
        Thu, 20 Oct 2022 23:05:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666332334; x=1697868334;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=NkR1KXHj2YetnyqhSLw0CykjNKNOHs0bjKs9vmGB4b0=;
  b=X+qJsEs/ij04l7KOE+8dDtrYI9tLivD9oXxFLL7B9gdQGDI/uK2XCYUV
   opxxXnZo79AGAR6YLYssinBs/K1BCD1KzZvEesgjuNxZwv947wjJA82a8
   b/DLtfiR2xIcxuCZKvs0VkQi5QOVrwmdN5vUKMKjl3cFhN/GVZ7pJf9h2
   oLnBEKK5ytux/QjF7HLPWDiXJ6Sl7lfeauu+qD52KdT0CdV9z4IxpmiNR
   DIPU+HXB/RxLc/g7DBB0SkeGFqNdwMcld0Dbl572TnNd6KdcdVfdomRVW
   0alGriH/23fBricLnn6KnDavwtHb0ktgCf8mjIPIg8W/Y7zdU5l9H2o+i
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10506"; a="287321956"
X-IronPort-AV: E=Sophos;i="5.95,200,1661842800"; 
   d="scan'208";a="287321956"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2022 23:05:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10506"; a="719524229"
X-IronPort-AV: E=Sophos;i="5.95,200,1661842800"; 
   d="scan'208";a="719524229"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by FMSMGA003.fm.intel.com with ESMTP; 20 Oct 2022 23:05:31 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 20 Oct 2022 23:05:31 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 20 Oct 2022 23:05:30 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 20 Oct 2022 23:05:30 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 20 Oct 2022 23:05:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cZMuPfXy7jsZH9F5kplRRo7qfsr5355wU+2fNAJ1rYvzIgGka3ev7DdYzMaaJ2ZVKWm2bIX35sZIJHUlvrrN/nVl6Nv7m+U6o6+RI20D7xeR4E5gP3ShfX92MHoEtd2Ze+UGuMFOJq+HmNAJjy/YKTSuwv+Ya6Wn3lz4VR2oquOolkDYIL71vv77HdgpgMaR/OUZ9oca0GVBe3ggDqhRwMF897tgGVa1W+azJ0cIXgQVFAEtpQ85BgXnGZt6bX4dmqQIFMHM3JpD4yPycEJ6EmFYdKny6X98HwbMizPeEeagrKncwIAY2LF8yEIy5VUkx1enm85LvUWYi6yRvlVvvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p33PNn48zZCeAbIRv1HmKU2zKuBIwOLVFkO8M7n6R4c=;
 b=cmaSN7BKv0d2Z6aTbcmkWqQi2WYp66ZFPaUKyQRYK8U7xenjNkhYfrLkk4/kBfo11goblbasqNcHVNrmRbk+jwULQUOgxL+VHZ4o8BIl54O05B/eDx3t0qBbvnZlD/eMy8Z+tSgu9znRgfhZHrFQ32XI/4SdIO68by6fTt6mjCCka1G/SokG6EADn1h0aDyt8RJaoRMIDIsObKFBWhVAw3P67EBtXOKVxGrSP+LgZHBj4Lqud9IgFsHEDaOx1Z1bPXBI2dNo7UD+bGNgF96bbZBbJzRhuhp32MJth1nAyXkkQrifC3Tch15zVTZkYJZZ2C03BB1QlBbN9pnagFNKpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 MW4PR11MB7054.namprd11.prod.outlook.com (2603:10b6:303:219::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.32; Fri, 21 Oct
 2022 06:05:27 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e1be:376b:2662:16ad]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e1be:376b:2662:16ad%3]) with mapi id 15.20.5723.033; Fri, 21 Oct 2022
 06:05:27 +0000
Date:   Fri, 21 Oct 2022 13:42:54 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Mingwei Zhang <mizhang@google.com>,
        "David Matlack" <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v6 5/8] KVM: x86/mmu: Track the number of TDP MMU pages,
 but not the actual pages
Message-ID: <Y1IxXviByW9/jCgr@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20221019165618.927057-1-seanjc@google.com>
 <20221019165618.927057-6-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20221019165618.927057-6-seanjc@google.com>
X-ClientProxiedBy: SG2PR01CA0116.apcprd01.prod.exchangelabs.com
 (2603:1096:4:40::20) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|MW4PR11MB7054:EE_
X-MS-Office365-Filtering-Correlation-Id: 19c7bd5e-a0ad-425c-2172-08dab32a4050
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: thXgazk24fJnjd5RktJyxVo4yqrtYi8JDJE4E3tA816i9KPxaUxXCnzLx84Z2SAFYhAGecv0EJuxiL6MjSUT2O7xBiaCMpmEr05zazLdY/WvSuJVmT1RaWCrhf4xFdpeEYWbuIrtT81m/ZDdxVST0NzQ79k7pX2iDvm5Ucty4uwbiw+tbacINClGujIuewOWi/Ns/w8vRbNqQWDXNZQtz5xgZ7oImsXxVyxtFFr9uxLkUDtavv84kswKumxLeqbFkXBNCIXpTgayMlSoU+8ZaM6KaCJ7CixppVzVeKCcrJ1DesPMYDdNmgBwyjuAgp/cqQw6v+BjL/mT1iHkkO380YEn8z3D6yrKELQZ3QKu4efX8EVUTz5hCV49QbemQdDhOw1Bgmo4Ln8nWiFB5r+q3HR4LCekbc1qtCfPURHNtJlGM7ZvWLgG90jIdLbrIlBESYg6DCWXFKdQihy2LBNLkSy5r9/eNRpPaU1m3f3vMES3HkMcgw7S1Z+yD8BEdseB4a2NNp0hOUQhB2PiYGX8yGw69BaodN3EzJdyEZHVD6Rsc9Od18QdGno/rtfBdT9GsJ1kI0o/9ZmrFKOwSbc/lyAR3jZHFkjn040JM9HtuxfqgVOL46ksw194KKOahCEBI6NGIWp/fHCqblAYPQTTXjwMbG/bBXWthChjeHZePvWK6wpit0g/aO5mFQO6ut2bmwU5M3doWIWrGYrbL1dh3A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(366004)(39860400002)(136003)(396003)(376002)(451199015)(8936002)(2906002)(86362001)(82960400001)(5660300002)(66476007)(41300700001)(3450700001)(4326008)(38100700002)(66556008)(6506007)(66946007)(8676002)(316002)(6486002)(186003)(6916009)(54906003)(6666004)(26005)(83380400001)(6512007)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?my3zZb0PYxefXT39L4m39M8hncg5+qpzPQWnY8rvaAWzFV4Ut/IRoUBOTrH7?=
 =?us-ascii?Q?yRv2etvxeSnMktC3K+9MN1IhDP9buuM+bNhWrn7jVbfQ1n2Ul+IE/aXVHs8z?=
 =?us-ascii?Q?Eyd1HmfqNX94ZBouiDHHxdTziFwSptVLARz6dUsZlF4We2R3cnglJ9ywjymw?=
 =?us-ascii?Q?27f2W9kTLB2knS6V5PyIujtzGfBKr3tufeU+AbCrKqIeEhxA6blLwXIbMeTD?=
 =?us-ascii?Q?Hy1k9p2El+yWvJ9n8OqHs8/DFxD2w4C/W1UXsUGj7q1zyc8nkTJBAeTlJ2Ie?=
 =?us-ascii?Q?bwUbAwdtLuGfrfrhhbKqm8MhI5edUh4FBbbg04Kn/IPOUAidXwbsgHZtS6NR?=
 =?us-ascii?Q?iuKVKXdrAURcZI0H7Ey0T8YbI932vPObGU2VBoWQw05Gd177V+ZQc7ZOS5VM?=
 =?us-ascii?Q?JXM1wS+JaJRRutzoer6I1WcRUaCJkuoAdEPusmFO5VSDgrb6QBllM7G73G3F?=
 =?us-ascii?Q?9EPSzvLzAuIn6rzve1bw/ZgLs1aF3lpPs5la4W6cII+Fi/P57FXFTB5ya/uQ?=
 =?us-ascii?Q?j2d1vKTk0BvOmZV77xfVmG6gmOmWReq75SbTnbIZ5F7mazegZ0F5ep0i+qEC?=
 =?us-ascii?Q?Z3tYtTXQK50R7Ai09x+IGhCJuBawWjc80l/4hAd4w/AagOWtKHGdfs9X0RQ6?=
 =?us-ascii?Q?iMekClYXI6FonF6+8sOQ6bIzH1vuRgJNPB5NwJDbBNAdUf/xU1ks4a/+tUyy?=
 =?us-ascii?Q?qZaGRJ8aZ2yfFVxGv354rxaneZxaEuuQ6HU417yrUC6jMAU00hLNtuQnWWHM?=
 =?us-ascii?Q?Ywbpf7oxlxOdalm1HwQFgOH6nDlFzrbXg1ycdnRhN/Z/0xzpoqH0PCPC3kE8?=
 =?us-ascii?Q?uQj1SwhZrJMkrbY89uf/ED5vZf1yuN1tS8/WD8NycpAulo71Q/xBZUdjnU15?=
 =?us-ascii?Q?U6DtyJBk/zxIjFFJiOS3E4pIujCJ7fznt6+rviHG4s7kSw34iHNYf42t0mN8?=
 =?us-ascii?Q?CRXFjvGfAhfAung4xNrfsx838va8RQ/JFKTXSVtfGiDc3w3ee+ka6xye6rQC?=
 =?us-ascii?Q?ZEBSLT3vKZdVquEZ5CbXtI7/Z3LLmbKkAF1FN85d0VQ2F6DQkxSoXRIkB9O+?=
 =?us-ascii?Q?SdM5smcPZB1V3TLhORPvbBFUqkgX6vz26WVxGlyMEHK0W+Zo58/HnSyMROC2?=
 =?us-ascii?Q?MT7NGt9EYNRYx78k+KQUDcxLE0RPdgtSnBHADg3SLuL15OtLmBpGxdzx4glZ?=
 =?us-ascii?Q?x1eH7JYpbCzuyszvGBt/aqqpfx59CPDmNI/wTHtvs+PaonbHjmU3YY3nh1Tu?=
 =?us-ascii?Q?AXBoki6cAiLi9FnGmemyoSNEUOYQBF80g4Gp2QR/9CmzU5HZ8Gqsv6wUwaiZ?=
 =?us-ascii?Q?V5vjQPOxmnXWukT1RcUnyT95E2ZE5pKEz1fx3a5jm1JBIZtBqAvN7B3La22Z?=
 =?us-ascii?Q?G4SPFh/Yo1MFKltTxzc3i1aQ1SDQkUjje6nNYTO54ZPxMYlW8bd7j4P36DcC?=
 =?us-ascii?Q?eKVWW75JMLRARcJZvgBfmjBjsZwImd5AdIHiYVz4ZtYZvMPev/kfmnJZga4F?=
 =?us-ascii?Q?rBZVvN4416ALrqR7NyaIVFL79pDg3nvysd3IFZ+b7r9RcUZ+0Hv0dyrL5rZY?=
 =?us-ascii?Q?yclBwoqQxQ+4ODvCRRhL7tWZadbNXJTC1kGrFJ3A?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 19c7bd5e-a0ad-425c-2172-08dab32a4050
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2022 06:05:27.6744
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TEBKJ/8/8t12XGgncwDv+2At3X5PiVqy1/hEoEO98Ht87XECU8+TjHTtIoIl8MsZWNEg/5vxWo1ncC4KLey6HQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB7054
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reviewed-by: Yan Zhao <yan.y.zhao@intel.com>

On Wed, Oct 19, 2022 at 04:56:15PM +0000, Sean Christopherson wrote:
> Track the number of TDP MMU "shadow" pages instead of tracking the pages
> themselves. With the NX huge page list manipulation moved out of the common
> linking flow, elminating the list-based tracking means the happy path of
> adding a shadow page doesn't need to acquire a spinlock and can instead
> inc/dec an atomic.
> 
> Keep the tracking as the WARN during TDP MMU teardown on leaked shadow
> pages is very, very useful for detecting KVM bugs.
> 
> Tracking the number of pages will also make it trivial to expose the
> counter to userspace as a stat in the future, which may or may not be
> desirable.
> 
> Note, the TDP MMU needs to use a separate counter (and stat if that ever
> comes to be) from the existing n_used_mmu_pages. The TDP MMU doesn't bother
> supporting the shrinker nor does it honor KVM_SET_NR_MMU_PAGES (because the
> TDP MMU consumes so few pages relative to shadow paging), and including TDP
> MMU pages in that counter would break both the shrinker and shadow MMUs,
> e.g. if a VM is using nested TDP.
> 
> Cc: Yan Zhao <yan.y.zhao@intel.com>
> Reviewed-by: Mingwei Zhang <mizhang@google.com>
> Reviewed-by: David Matlack <dmatlack@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 11 +++--------
>  arch/x86/kvm/mmu/tdp_mmu.c      | 20 +++++++++-----------
>  2 files changed, 12 insertions(+), 19 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 0333dbb8ec85..bbd2cecd34cb 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1290,6 +1290,9 @@ struct kvm_arch {
>  	 */
>  	bool tdp_mmu_enabled;
>  
> +	/* The number of TDP MMU pages across all roots. */
> +	atomic64_t tdp_mmu_pages;
> +
>  	/*
>  	 * List of kvm_mmu_page structs being used as roots.
>  	 * All kvm_mmu_page structs in the list should have
> @@ -1310,18 +1313,10 @@ struct kvm_arch {
>  	 */
>  	struct list_head tdp_mmu_roots;
>  
> -	/*
> -	 * List of kvm_mmu_page structs not being used as roots.
> -	 * All kvm_mmu_page structs in the list should have
> -	 * tdp_mmu_page set and a tdp_mmu_root_count of 0.
> -	 */
> -	struct list_head tdp_mmu_pages;
> -
>  	/*
>  	 * Protects accesses to the following fields when the MMU lock
>  	 * is held in read mode:
>  	 *  - tdp_mmu_roots (above)
> -	 *  - tdp_mmu_pages (above)
>  	 *  - the link field of kvm_mmu_page structs used by the TDP MMU
>  	 *  - possible_nx_huge_pages;
>  	 *  - the possible_nx_huge_page_link field of kvm_mmu_page structs used
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 059231c82345..4e5b3ae824c1 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -29,7 +29,6 @@ int kvm_mmu_init_tdp_mmu(struct kvm *kvm)
>  	kvm->arch.tdp_mmu_enabled = true;
>  	INIT_LIST_HEAD(&kvm->arch.tdp_mmu_roots);
>  	spin_lock_init(&kvm->arch.tdp_mmu_pages_lock);
> -	INIT_LIST_HEAD(&kvm->arch.tdp_mmu_pages);
>  	kvm->arch.tdp_mmu_zap_wq = wq;
>  	return 1;
>  }
> @@ -54,7 +53,7 @@ void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
>  	/* Also waits for any queued work items.  */
>  	destroy_workqueue(kvm->arch.tdp_mmu_zap_wq);
>  
> -	WARN_ON(!list_empty(&kvm->arch.tdp_mmu_pages));
> +	WARN_ON(atomic64_read(&kvm->arch.tdp_mmu_pages));
>  	WARN_ON(!list_empty(&kvm->arch.tdp_mmu_roots));
>  
>  	/*
> @@ -377,11 +376,13 @@ static void handle_changed_spte_dirty_log(struct kvm *kvm, int as_id, gfn_t gfn,
>  static void tdp_account_mmu_page(struct kvm *kvm, struct kvm_mmu_page *sp)
>  {
>  	kvm_account_pgtable_pages((void *)sp->spt, +1);
> +	atomic64_inc(&kvm->arch.tdp_mmu_pages);
>  }
>  
>  static void tdp_unaccount_mmu_page(struct kvm *kvm, struct kvm_mmu_page *sp)
>  {
>  	kvm_account_pgtable_pages((void *)sp->spt, -1);
> +	atomic64_dec(&kvm->arch.tdp_mmu_pages);
>  }
>  
>  /**
> @@ -397,17 +398,17 @@ static void tdp_mmu_unlink_sp(struct kvm *kvm, struct kvm_mmu_page *sp,
>  			      bool shared)
>  {
>  	tdp_unaccount_mmu_page(kvm, sp);
> +
> +	if (!sp->nx_huge_page_disallowed)
> +		return;
> +
>  	if (shared)
>  		spin_lock(&kvm->arch.tdp_mmu_pages_lock);
>  	else
>  		lockdep_assert_held_write(&kvm->mmu_lock);
>  
> -	list_del(&sp->link);
> -
> -	if (sp->nx_huge_page_disallowed) {
> -		sp->nx_huge_page_disallowed = false;
> -		untrack_possible_nx_huge_page(kvm, sp);
> -	}
> +	sp->nx_huge_page_disallowed = false;
> +	untrack_possible_nx_huge_page(kvm, sp);
>  
>  	if (shared)
>  		spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
> @@ -1140,9 +1141,6 @@ static int tdp_mmu_link_sp(struct kvm *kvm, struct tdp_iter *iter,
>  		tdp_mmu_set_spte(kvm, iter, spte);
>  	}
>  
> -	spin_lock(&kvm->arch.tdp_mmu_pages_lock);
> -	list_add(&sp->link, &kvm->arch.tdp_mmu_pages);
> -	spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
>  	tdp_account_mmu_page(kvm, sp);
>  
>  	return 0;
> -- 
> 2.38.0.413.g74048e4d9e-goog
> 
