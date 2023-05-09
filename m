Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86AAD6FBCDB
	for <lists+kvm@lfdr.de>; Tue,  9 May 2023 04:05:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233960AbjEICFs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 May 2023 22:05:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbjEICFq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 May 2023 22:05:46 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 146FC1FF5;
        Mon,  8 May 2023 19:05:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683597944; x=1715133944;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=kNZLzzv76QYtqFL6ay1YO+WBg9RcWmtWmRHcK1CD5rg=;
  b=b0c4s8KBqqf46cCLflVzryGGPWgYENQqKlqvjtAZkx+6fgtS8XctCOO+
   kXlN04Q5z9S2tDR/TLraGJa4vSrS0Jf9BFVsBGfm46zLJ1jPBQ6BiLFrI
   8sjUrlT28J3STrwz7Ivb8EJmn0aLRwBNhjuGoREc6H8Gvew6Uz+PGikKk
   5GXIHF97GKAplHsjJA9zug0cKp81O1YUg/HdtZ/oc+YtYL9GeSClAEUWm
   FuFgbotq7ovHd1Wbsj2DxcY1piHfZ/91XjwG9GSuml0ibnwwjehz+OiLc
   jl+G25Lbtq7tjgY1Z79kfI7fAT1f3yER7w8k2BwYvmPPlMh/U1A0XGZGM
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10704"; a="351959076"
X-IronPort-AV: E=Sophos;i="5.99,259,1677571200"; 
   d="scan'208";a="351959076"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2023 19:05:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10704"; a="649104599"
X-IronPort-AV: E=Sophos;i="5.99,259,1677571200"; 
   d="scan'208";a="649104599"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga003.jf.intel.com with ESMTP; 08 May 2023 19:05:43 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 8 May 2023 19:05:43 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 8 May 2023 19:05:42 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 8 May 2023 19:05:42 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.174)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 8 May 2023 19:05:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Iby6VYY5xN9mdFo+VwZD1l0t+WuDOIjB707H750mjES8B5dtOVUrKWGyfMV8Xo3YOpDMxt9TrJyZURJ8/gM+/mCcLlZgNOYJAJNl2wHMXEzoQjqlexZmXxQakP7fRq8Na2pKEjjsR+QpWSxmheBB5Vr7lyMWX/lKj7RW8kHS8llCkd+RTbJh8z/eIpCrS9w8lesJ38BWdbNbz0syozw/e9MgtnUJRTDOSNvhXO6SVX9ylvl8rDZCZcMi65khkvKKdb7wMW/C5FRxHokbvnsd4gCoGkJ08HIXo4qG79zu9/Z9L6nOQJnGu82AinMtRu5zu6D5NDd95k6QH6+Ns2mwbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X8+GLSoQD4HLOqqhMPEbc/+oBP7mMZR8e4zu9zmLa10=;
 b=e6TbIbTGwIqM7kY9izvKS6AvkcKvzKmhkdVdNw5yEj81kDcU+JlmM7N0fgaa9ZhsrzVIW6qq0wvrSVRoKeQB8dPICDrK1ZNuRiapBYxPlizrKbyzJ4aP8lKbD0YA+8dqE9LN574w6wBf7TEHzsyhs76ktb3u/uutsx5yoNE+DeP+LBRR2Ds83XRfIAaOPSomxYfAFd+u6XBPnEVH8bt72Ii6lt6YyoUffQgEX6XqG1xGxIsjNISDlqYmrYyJZ57MeeblS6jNCgMQTXRycSN3shfxJar0bOrcE2lNxjpfnYFhUYhSBVIDYa/2cTuZHDfBOvyi9AC2LUpdinkPFkhDvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CY5PR11MB6091.namprd11.prod.outlook.com (2603:10b6:930:2d::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6363.32; Tue, 9 May 2023 02:05:40 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::a670:49f5:d602:e2e4]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::a670:49f5:d602:e2e4%6]) with mapi id 15.20.6363.032; Tue, 9 May 2023
 02:05:40 +0000
Date:   Tue, 9 May 2023 09:40:37 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Chao Gao <chao.gao@intel.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <pbonzini@redhat.com>, <seanjc@google.com>
Subject: Re: [PATCH] KVM: x86: Zap all TDP leaf entries according noncoherent
 DMA count
Message-ID: <ZFmkleUwgv/38UrI@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230508034700.7686-1-yan.y.zhao@intel.com>
 <ZFiinKOqGDvyVAkT@chao-email>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZFiinKOqGDvyVAkT@chao-email>
X-ClientProxiedBy: SG2PR03CA0097.apcprd03.prod.outlook.com
 (2603:1096:4:7c::25) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CY5PR11MB6091:EE_
X-MS-Office365-Filtering-Correlation-Id: b9add375-513e-4a1e-4686-08db5031e335
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NyNneLnAeEoj95gnUAR626uL5Dr6p6pifFegFokDtllBk/mO3E6L10oxN2yAm1nJ4vaai21iyGHO0KGaKO6aW8fba9OHD9itJ6pkkcyV0tpVugRZWt6DkPVERJOOhVye9DqS8jRP33BFOX+anD0T08Wi9uem/P6qakG+udKd2PRyn1KFdNJHAOIRFfeMlqESNv6qJi0kxkvw1ccDijDvLV0QP7zXSFccMglQ15IKixJqli3E1CWMg+cPBt+fgWd17NiVdLzxhayyQageGoUhrWuPSuKm92Vtxwe1G6UCTJkEFwZ5rN8+Nq2qa7BCSQsZMG3WhjSan3a/g6sR5nRQus93h9AR41ob4fPLQtkkeQxjF9l8q0kX6E6Cjkwn5wY2gDaf6ZsvOi/tlMbKXE0/nWNngljanBhjhsZJbrZydyL/vLR/H/x+ZYs6czhZiqlidrJYbShD+OooLZOkScdfmTLaQsan8SR2zYBceUWntt+VlNoITLw29mumUlZG9NDEArOyz6hsvz1rwP6YRUIWSzBmmQ0QaTr7zAU9SOtoDX5H37Cr57R2L7cyddvJ9L+Q
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(39860400002)(346002)(136003)(376002)(396003)(451199021)(478600001)(86362001)(66946007)(3450700001)(2906002)(41300700001)(6636002)(4326008)(316002)(8936002)(6862004)(5660300002)(8676002)(66476007)(66556008)(6486002)(6666004)(82960400001)(26005)(186003)(38100700002)(83380400001)(6506007)(6512007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pUpK48OBWG6WigxyNh8x3vBz1UGNTiOVsl4ieaQ38g/vTyBQRKgA3ed1O6OD?=
 =?us-ascii?Q?vHSCRxPLlcZtDBHiXq79+q6+tdl5gPOsjQ9k/uOltQ18xygKJO7c4supVnNi?=
 =?us-ascii?Q?guBjVwH/2OD8DkvubBNnLNL8DxjmaUvBmOJYJnkuHkJpvL/oVUQorrFYECBy?=
 =?us-ascii?Q?VngHvabitOh3vkadWSiQLb6KuAZ09vKb6/Gt89H+R0yTsqDUJx3X7rF8IwNf?=
 =?us-ascii?Q?Uc+6vvA+pp5nUdXfYLFL5ujq4UniwKMKRkuL/o0LiERhryadoVNE4r+TyGHE?=
 =?us-ascii?Q?pkXJS8HxRbY9llBGX9BMaGLKtAtGygpN7mG5slYx4Mg8JhchCCwRXnbix1gA?=
 =?us-ascii?Q?XlbL7/l2yGr1vZMhxkYf7ggo0V8t32sF2byWgpNerisGOpIAObdyzYBG+aK7?=
 =?us-ascii?Q?Yae46AHAIULU2yV+9OeGqOnYxkhSoSOP4gp7FZ8dpK4KeUVg8PQUSiCcWi4q?=
 =?us-ascii?Q?QiX1GupNf4lUvgkfDjZTuRKBJQVW0ifPpgY6jrEFFyWlaR/R7sXIXcihfuOv?=
 =?us-ascii?Q?30aFjHNtZFmdhfT+LKwUS/lDtG1jDoGQl4otiOK0VYHTHiAPVJDUrlKaSPPH?=
 =?us-ascii?Q?i9V8VB7sJh7uWMt68A+7TiVSrxhmCaFFN0hHZsWtjM11YOVKs6sJnFOqUpSF?=
 =?us-ascii?Q?R0BF9ZaRS5/mb3xviyPrDs1BmijBeGQ2qF5HhyjidcrcbOFNByyA2Ze8hiKx?=
 =?us-ascii?Q?7AmQZkyVVz332V199uLO7b/BhnMc7NHA4f0AQjMHOjmtJuxGGyLrw3012MZO?=
 =?us-ascii?Q?GiuB+obSKqAOc6KnEh2RepSbBMgGuOszFCQoHrEA8mN7kHAHzxAuoO1UIg1z?=
 =?us-ascii?Q?pujakqCFQMy3dXK63HLRsf884HN5KwdtmXCkZkjAksZ50oI7BvdFWuryFXTF?=
 =?us-ascii?Q?txIqYoICEVAhC1M7gzcPC2HM2EZPBEfllRojatwiEecncl+D/EaHXJy34FT8?=
 =?us-ascii?Q?jyUAJo0ONCqpJ3x9HAZQ9xVHC9YiFqC+ZDpkhvqcePtMHfNTwJeK7gWQwVav?=
 =?us-ascii?Q?H6mTl6fUwKXyR0HbY5wau+xN8kV5U7f7uWSdvp5SjuIrKyUCnh3JxXYueCoZ?=
 =?us-ascii?Q?iPkSWAVH9abK1jCJuFLAm2hCrBI5Ro9D9/Usqy/zu8CDxfw1wBx5gutP3Mjp?=
 =?us-ascii?Q?yRqLQchgWqvACwqDgdjq40+bU7g1UR2gqnRpu7uLSujNTFt3dxnbwjAeF5IU?=
 =?us-ascii?Q?c/tIf+dn065AK8Gy1yMuuMGd3peNUpoK5RPYKMoXgeOKLoTPPqryZLxXrBBl?=
 =?us-ascii?Q?ta6k/phv++w5N4CZlRAQym8M/IYD6VTHkFI7VBuRVI+1Oo0NGQNEIKwsGng+?=
 =?us-ascii?Q?ixUbfWb0i8LmSGUe0giom0XlJ1x4sFMtFR5ev8viKwt3T0e6OHZXGRxeev6W?=
 =?us-ascii?Q?BeePLNe4BIUObKPpvuw74F7fz4g29C7jQQ9q+SnJ4cmwUFvzwRQH9Q7bQOsD?=
 =?us-ascii?Q?S2CBJp/Y9uoHVPHsL/6cJvH8442UWmsIqgejmLP6iABCiEhD+joA6dRvKX3B?=
 =?us-ascii?Q?6NKXCSYQUysBQXt9xOrbhGzxb6b+X+bpE3I8jnwGTcK+GnSwtFgJtkonBPxx?=
 =?us-ascii?Q?QIaGecF3vJjKwtD6cfovXYAMg8ubNd+2yaqcX2r9?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b9add375-513e-4a1e-4686-08db5031e335
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2023 02:05:40.1524
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bjkWW0ajwsbE9r3QO3XCcf+dEbM60Z3h2YtNe5ySlCRidpYaBACXlPsey/FcQq73hk/jmeVgLYJMUs56hmkMoQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6091
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 08, 2023 at 03:19:56PM +0800, Chao Gao wrote:
> On Mon, May 08, 2023 at 11:47:00AM +0800, Yan Zhao wrote:
> >Zap all TDP leaf entries when noncoherent DMA count goes from 0 to !0, or
> >from !0 to 0.
> >
> >When there's no noncoherent DMA device, EPT memory type is
> >((MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT) | VMX_EPT_IPAT_BIT)
> >
> >When there're noncoherent DMA devices, EPT memory type needs to honor
> >guest CR0_CD and MTRR settings.
> >
> >So, if noncoherent DMA count changes between 0 and !0, EPT leaf entries
> >need to be zapped to clear stale memory type.
> >
> >This issue might be hidden when VFIO adding/removing MMIO regions of the
> >noncoherent DMA devices on device attaching/de-attaching because
> >usually the MMIO regions will be disabled/enabled for several times during
> >guest PCI probing. And in KVM, TDP entries are all zapped on memslot
> >removal.
> >
> >However, this issue may appear when kvm_mmu_zap_all_fast() is not called
> >before KVM slot removal, e.g. as for TDX, only leaf entries for the
> >memslot to be removed is zapped.
> >
> >static void kvm_mmu_invalidate_zap_pages_in_memslot(struct kvm *kvm,
> >                        struct kvm_memory_slot *slot,
> >                        struct kvm_page_track_notifier_node *node)
> >{
> >        if (kvm_gfn_shared_mask(kvm))
> >                /*
> >                 * Secure-EPT requires to release PTs from the leaf.  The
> >                 * optimization to zap root PT first with child PT doesn't
> >                 * work.
> >                 */
> >                kvm_mmu_zap_memslot(kvm, slot);
> >        else
> >                kvm_mmu_zap_all_fast(kvm);
> >}
> 
> TDX code isn't merged. So, I think you'd better not use TDX as an argument.
> 
Ok. But I just want to explain that kvm_mmu_zap_all_fast() is not
desired in some cases during slot DELETE. TDX is a good example here.

> >
> >And even without TDX's case, in some extreme conditions if MMIO regions
> >are not disabled during device attaching, e.g. if guest does not cause
> >the MMIO region disabling in QEMU.
> >Then TDP zap will not be called and wrong EPT memory type might be
> >retained.
> >
> >So, do the TDP zapping of all leaf entries when present/non-present state
> >of noncoherent DMA devices changes to ensure stale entries cleaned away.
> >And as this is not a frequent operation, the extra zap should be fine.
> >
> >Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> >---
> > arch/x86/kvm/x86.c | 6 ++++--
> > 1 file changed, 4 insertions(+), 2 deletions(-)
> >
> >diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> >index e7f78fe79b32..99a825722d95 100644
> >--- a/arch/x86/kvm/x86.c
> >+++ b/arch/x86/kvm/x86.c
> >@@ -13145,13 +13145,15 @@ EXPORT_SYMBOL_GPL(kvm_arch_has_assigned_device);
> > 
> > void kvm_arch_register_noncoherent_dma(struct kvm *kvm)
> > {
> >-	atomic_inc(&kvm->arch.noncoherent_dma_count);
> >+	if (atomic_inc_return(&kvm->arch.noncoherent_dma_count) == 1)
> 
> >+		kvm_zap_gfn_range(kvm, gpa_to_gfn(0), gpa_to_gfn(~0ULL));
> 
> The issue is specific to EPT. shouldn't this be conditional on tdp_enabled, like
> update_mtrr()?
> 
Yes. good point.
Maybe also include checking of shadow_memtype_mask.

> Likewise, shouldn't we omit to call kvm_zap_gfn_range() in kvm_post_set_cr0() if
> tdp_enabled is false?
I think so.
And also check tdp_enabled and shadow_memtype_mask in the case of update_mtrr().

Will add a helper function in next version.

Thanks, Chao!
> 
> > }
> > EXPORT_SYMBOL_GPL(kvm_arch_register_noncoherent_dma);
> > 
> > void kvm_arch_unregister_noncoherent_dma(struct kvm *kvm)
> > {
> >-	atomic_dec(&kvm->arch.noncoherent_dma_count);
> >+	if (!atomic_dec_return(&kvm->arch.noncoherent_dma_count))
> >+		kvm_zap_gfn_range(kvm, gpa_to_gfn(0), gpa_to_gfn(~0ULL));
> > }
> > EXPORT_SYMBOL_GPL(kvm_arch_unregister_noncoherent_dma);
> > 
> >-- 
> >2.17.1
> >
