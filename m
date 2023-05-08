Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0149E6FA0DE
	for <lists+kvm@lfdr.de>; Mon,  8 May 2023 09:20:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233176AbjEHHUa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 May 2023 03:20:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233155AbjEHHU1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 May 2023 03:20:27 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1270635B5;
        Mon,  8 May 2023 00:20:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683530420; x=1715066420;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=bXrESkAFXbUVATbaIhroniz2XfmyV3qMs3hDeVb1EJM=;
  b=JOttJELkzQLYtZ2I3svc1QznX3f79F9/sIrAQF93W1if04XHvXGr1QbJ
   9ukS95IrkzNEjVvVWJjRSgoMGEImhsvM3uVbpxYfWMhbzQHi6GDvQOukx
   uKi8gXTpsZhgGXrYTyCEgen6bJ3sAHk2YASyH9ZTcrcc/cCPIGVL1YCMB
   34tXqlaOj5H2BJvc7AxYSzNVeLA51ECQzwKqcWVY5FbGzixkd3uKClsUF
   sK1gZKLfH8+ypvnQUu3sCEMbEbnwSeBwDY88Gj0ppsj9w0PWIm5Pzh2r1
   Yikr61YwZSQvzyGmYjiOOaASWssOF80A5i8vHyH6AoEd+MVBRLGHvRzia
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10703"; a="351741193"
X-IronPort-AV: E=Sophos;i="5.99,258,1677571200"; 
   d="scan'208";a="351741193"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2023 00:20:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10703"; a="763285337"
X-IronPort-AV: E=Sophos;i="5.99,258,1677571200"; 
   d="scan'208";a="763285337"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga008.fm.intel.com with ESMTP; 08 May 2023 00:20:17 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 8 May 2023 00:20:16 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 8 May 2023 00:20:16 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 8 May 2023 00:20:16 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.172)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 8 May 2023 00:20:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iTmozNmqnVDuWQoVHTdE3NzCq19q8sCQ86pzerZ473GlUlo7NjYaNHS/l7QTeW9GKFxUWZEw1oTMy7XLWVz/Q4v9wwtan339yWRqjP34eZcBYJNs2nmzaC7Xp2ws+cH5zP8nbvWdIFb2o3Evp4cJs2nJO/1Ev0uRTkYXN000BKcmi5qHVx+4zXAb+3bmWFB4ofcX1iDn5EFh1QuwUt0qRcRwqDax+PPP4c8nkdYrH8l0MdZqXAGIEDSOHrJxgpWs2v7CANv/8dJoQM2eU5ff9z82ZEzLlnkLhtsDHzA6W7CGjkhJDFldgVS1nx96tPE7eqZ0ENCDenEn+WwggUfWrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o+wE+kSymbxVn3aNl0A1qqTIcIEkL2q5GOtKtl14bBU=;
 b=QYhjrNXsAgZMAuaQSGDSGvssGSHeM1fHG9kvyxU6fdgJe2o2tZ8cZ3WrRCiwpedTj0ty5rTjuBd+xvxgld+invtDECWEEue2eNeJPhPNRohtRRvsstaP1cY4dFW2IWUxj5O/vDSHX3XVp6z1YN1WkRyyviysfAnpqwrk+2vhkqmtZoqORPEbsK+OWKRfx3tN1rEnA1vvP2ZZ98R/MsLYKlSCyAOiKfUvs+ugzoAd971bB4DRtiNsHrJMHWsDumDJ4jIrczMpp9psSZAk1tAKoaWXlYhOOIKDnKol2mRgV3vaq6vUYllLbojnbNN+ShvtMG8uN55tuf/IrxgPingegw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by DS0PR11MB7832.namprd11.prod.outlook.com (2603:10b6:8:f5::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.32; Mon, 8 May
 2023 07:20:07 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::b4cb:1f70:7e2a:c4f5]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::b4cb:1f70:7e2a:c4f5%9]) with mapi id 15.20.6363.031; Mon, 8 May 2023
 07:20:07 +0000
Date:   Mon, 8 May 2023 15:19:56 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <pbonzini@redhat.com>, <seanjc@google.com>
Subject: Re: [PATCH] KVM: x86: Zap all TDP leaf entries according noncoherent
 DMA count
Message-ID: <ZFiinKOqGDvyVAkT@chao-email>
References: <20230508034700.7686-1-yan.y.zhao@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230508034700.7686-1-yan.y.zhao@intel.com>
X-ClientProxiedBy: SG2PR01CA0129.apcprd01.prod.exchangelabs.com
 (2603:1096:4:40::33) To PH8PR11MB6780.namprd11.prod.outlook.com
 (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|DS0PR11MB7832:EE_
X-MS-Office365-Filtering-Correlation-Id: 8951c6d5-c5ca-47ba-4a41-08db4f94a61f
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5MYU3BrG4VZW4G7lo3KM9Q3DwKCLmf+3leTfZmzJxG8SWaJjm4DiPDoTfx6GuntXobsdPd6DZPq0M1rkjetOv/SG6MMXzQMeOpKRnfjRnOOKpdI/6TFzPS5mrnHt2bl5qt0f3gDydPb7N3cLswzGd6lvGaU6eMvHsJVLRR2EWepDWwN8Gqji5ukn0FVH+Pf3zt4nSe0svRuhurKgnWNCkDEuz7imjL5GVhfq3sdRjgzhbejM9JrzqF/VlU1GIe5cEipSGZz9JShbNCiqt328YyrE6xkCeWc1nqlVjO+DfDqBJUAB9oxA4Puvb7b6lbUi9GEhDyXoACenbo//nsWaRMvpg6T775mWDUcHr5WRYWA5PJ0JVYYGneuxVElrn69euyQVfvI/xXpgucVwt/xr4uDaZaTr9aBRx1IRR7eIk4ljC6papsmrGo9TBhvvnwcXnk+8pOuott438GJYlhXf2ovmZQ1CfHC+hJtEX60qleOmszwsCj6T5rMA93O3G6SSxXrcwmwyo1QphAF1+20RMmKIKSHZZwaPGQtJe5SbUXdWmoLrY9kVrn1/XAElvPL/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(136003)(376002)(346002)(39860400002)(396003)(366004)(451199021)(2906002)(478600001)(6862004)(8936002)(8676002)(316002)(41300700001)(44832011)(6666004)(4326008)(6636002)(66556008)(66476007)(5660300002)(66946007)(6486002)(6512007)(9686003)(26005)(6506007)(186003)(33716001)(82960400001)(83380400001)(38100700002)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EIA49Es6RStMsSgvDMAYMyjtrmRFr/ZAUfk5e2ntNCoSvniAi7BBzZvSnkSB?=
 =?us-ascii?Q?xQr2H1JA5Zsnno3x3H6avmlQyZbpGfnMwVIkxLKmBJxZQbnbyDMb3Rd2NgYP?=
 =?us-ascii?Q?DbV5anBUgs0tPowhXCUiBZUbiiMb4ydhj6rSQ9E5KZj7xT0bxL8odIrxTIFv?=
 =?us-ascii?Q?Zul4BDnTqX/7lhtZyO8JhK+BpalP473BJKmsuc+EoKkep655QeN0eNOMRkMT?=
 =?us-ascii?Q?Rm4TQNBBQoVagweqaHjvw4c1TQVgN9nDPkvWrI5K19VlqimRIqE+Jd6eE778?=
 =?us-ascii?Q?iH6X1RqM+zoOSrs+lwwQh/UpwoxMlTjCSQl3x2NBrdraVXH2pUjbk14ywbKT?=
 =?us-ascii?Q?D3u9ovd7Yf9AyXvOCoQHHnxEcCfiy/zHpmYbk/yNSmF6ZI50aGyhPWhf15qA?=
 =?us-ascii?Q?4393aBQCHbMuKj/rERZR4aEBKOjRKbNRSEZyE44q87JBjF+3884OnuujuoDF?=
 =?us-ascii?Q?At/FMQ/FcruwtjzPyV4ky+f9DlMoqAAfzf1aKR274WdobUioQRsFTopElb5g?=
 =?us-ascii?Q?MYST2xU8YoZBmR/LghAZRW0cK+pQ7NJqpKY7PsSMMtByqCi/skvJsYjqpncP?=
 =?us-ascii?Q?4YsdZRgelAejxUHT081qyGBcUMSULt9gMJ0Lnu0d83ghz6lLNEl81Kv5IxI9?=
 =?us-ascii?Q?CWyVOAL71wntcUOgHWnGboQjea2phb7TK8mvEsVam2cF4+TH5luytbcxyGSU?=
 =?us-ascii?Q?0TLyFdfwgfhlWucMR5lojSayAsyBK9mTZnD0obA+i4UEL8QJLudJhvIOUYW5?=
 =?us-ascii?Q?Lg9yjtLXcCAVGVK8LU3kziMj6s4emSQXm0EqAjcFcnRjR0luk14d6EVfLCrX?=
 =?us-ascii?Q?e8zZhq1b3grV8gKdFUFYrZZdEH/TBJ1xGlVUgk91uzmK6G8sGMLA0fqFCPIO?=
 =?us-ascii?Q?GmcRvq/5xJ86kVIrVyus2cj76It/z9dNQCI55XcFRzpJHN0LRXW0+D5FD1PI?=
 =?us-ascii?Q?OSB8MDLiDc5Tp4pCVbFGPTFpee+alVXgPb9usvnAuxCYEP968LYVr/NVXBH4?=
 =?us-ascii?Q?o9s0sIEP0RjBhDcHjoNLKtyPOXbonJSdMkgc0qLV2KMYBQQf32XKPeg3lTm4?=
 =?us-ascii?Q?OlnRxGXMipA/DZ0Ba9rL4mtZEBQoUpacgnqF1pMEX4QhB8fP/bJsclj3AP4M?=
 =?us-ascii?Q?aED29patpg1bQjG2KqM6n2JJNfqJgIob3M9oxQfXUBxQvpBLs9gUgEJQeaU9?=
 =?us-ascii?Q?9iYhq+OLrlqxoNE3NFzYpSo+zM9h7SrtsiySW4rAJgPfWmBzxBtYoUYMnmrA?=
 =?us-ascii?Q?akLV8wWqf4thpM03yIot2qXddVL54NvQlOQLzaEj6ghYSJw4ysi0lMXR193t?=
 =?us-ascii?Q?EKQ3/djPSbGPDsXxyDsdxUf3EpH7PID+wSqXkMekeX2qlC5QsR9q1N76xZ+V?=
 =?us-ascii?Q?+rN9lDSh3nJp3kWqjqrAxyWBVcJ7Z1M7+AzKRMaVZ5fN8wqSVOFCVMRkulZf?=
 =?us-ascii?Q?z5OIsN8bD2NPJ9yGkB4oNWa1ZYyS0h4nYM3dmwkT19bZYQTvkOGc2BiHsxhS?=
 =?us-ascii?Q?lkUM6tkFXujCsjAF1A6appSceHZjKKUuYZnsR7+SgxEIxCUqET76aauADEDi?=
 =?us-ascii?Q?CwdGaNfsoxiCultX/GGt0ipzjAECSQ9c+nEgfwvl?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8951c6d5-c5ca-47ba-4a41-08db4f94a61f
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2023 07:20:06.6527
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zo2IK97+l5k0e5e2zJZsWMpnH1Q1jflsjMb5Jj/RqAGk4aOpweIUDA5Ffb6ksafUmdr5zUzktPP1TfIVaOV9lA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7832
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 08, 2023 at 11:47:00AM +0800, Yan Zhao wrote:
>Zap all TDP leaf entries when noncoherent DMA count goes from 0 to !0, or
>from !0 to 0.
>
>When there's no noncoherent DMA device, EPT memory type is
>((MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT) | VMX_EPT_IPAT_BIT)
>
>When there're noncoherent DMA devices, EPT memory type needs to honor
>guest CR0_CD and MTRR settings.
>
>So, if noncoherent DMA count changes between 0 and !0, EPT leaf entries
>need to be zapped to clear stale memory type.
>
>This issue might be hidden when VFIO adding/removing MMIO regions of the
>noncoherent DMA devices on device attaching/de-attaching because
>usually the MMIO regions will be disabled/enabled for several times during
>guest PCI probing. And in KVM, TDP entries are all zapped on memslot
>removal.
>
>However, this issue may appear when kvm_mmu_zap_all_fast() is not called
>before KVM slot removal, e.g. as for TDX, only leaf entries for the
>memslot to be removed is zapped.
>
>static void kvm_mmu_invalidate_zap_pages_in_memslot(struct kvm *kvm,
>                        struct kvm_memory_slot *slot,
>                        struct kvm_page_track_notifier_node *node)
>{
>        if (kvm_gfn_shared_mask(kvm))
>                /*
>                 * Secure-EPT requires to release PTs from the leaf.  The
>                 * optimization to zap root PT first with child PT doesn't
>                 * work.
>                 */
>                kvm_mmu_zap_memslot(kvm, slot);
>        else
>                kvm_mmu_zap_all_fast(kvm);
>}

TDX code isn't merged. So, I think you'd better not use TDX as an argument.

>
>And even without TDX's case, in some extreme conditions if MMIO regions
>are not disabled during device attaching, e.g. if guest does not cause
>the MMIO region disabling in QEMU.
>Then TDP zap will not be called and wrong EPT memory type might be
>retained.
>
>So, do the TDP zapping of all leaf entries when present/non-present state
>of noncoherent DMA devices changes to ensure stale entries cleaned away.
>And as this is not a frequent operation, the extra zap should be fine.
>
>Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
>---
> arch/x86/kvm/x86.c | 6 ++++--
> 1 file changed, 4 insertions(+), 2 deletions(-)
>
>diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>index e7f78fe79b32..99a825722d95 100644
>--- a/arch/x86/kvm/x86.c
>+++ b/arch/x86/kvm/x86.c
>@@ -13145,13 +13145,15 @@ EXPORT_SYMBOL_GPL(kvm_arch_has_assigned_device);
> 
> void kvm_arch_register_noncoherent_dma(struct kvm *kvm)
> {
>-	atomic_inc(&kvm->arch.noncoherent_dma_count);
>+	if (atomic_inc_return(&kvm->arch.noncoherent_dma_count) == 1)

>+		kvm_zap_gfn_range(kvm, gpa_to_gfn(0), gpa_to_gfn(~0ULL));

The issue is specific to EPT. shouldn't this be conditional on tdp_enabled, like
update_mtrr()?

Likewise, shouldn't we omit to call kvm_zap_gfn_range() in kvm_post_set_cr0() if
tdp_enabled is false?

> }
> EXPORT_SYMBOL_GPL(kvm_arch_register_noncoherent_dma);
> 
> void kvm_arch_unregister_noncoherent_dma(struct kvm *kvm)
> {
>-	atomic_dec(&kvm->arch.noncoherent_dma_count);
>+	if (!atomic_dec_return(&kvm->arch.noncoherent_dma_count))
>+		kvm_zap_gfn_range(kvm, gpa_to_gfn(0), gpa_to_gfn(~0ULL));
> }
> EXPORT_SYMBOL_GPL(kvm_arch_unregister_noncoherent_dma);
> 
>-- 
>2.17.1
>
