Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB7DC70EB82
	for <lists+kvm@lfdr.de>; Wed, 24 May 2023 04:47:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239174AbjEXCrT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 May 2023 22:47:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231585AbjEXCrS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 May 2023 22:47:18 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B44CEE9;
        Tue, 23 May 2023 19:47:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684896436; x=1716432436;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=vmcMfssceo36OjrC4Lj6KmcYGlEM/OgPWrGoWx+uQIw=;
  b=InWrATPzBC+MiM2L6LJXtjBqIkuRoQR4cUJs0I9TOrjf/1/4F4iut15l
   dXbGr+2bWyB4xKIxd93I0sRMvIUmbOZHXxusxcPoyKIzvrNwZDP6pKs81
   0pHChDbeSHAHDDLeAqHfBhEkcyMX2kHrUFkQjSHDKKeLGjSSkISJxm60E
   z2j6rpQ+wuFGe/lZnzAYLasD1CIzM25fGkIIz+AAWunyMkUHm0QAuMDlw
   2qrifsZyDCTepx48nDsvYwSYJY2kslyUDxEYVcUIGQ8uxnwdKPnTK9RxO
   C9kFqHTf+mPCJuP9QqNBFt99E7QsxbQ75sINojhPNLNCYcpk6d/Q2qxm9
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10719"; a="333795428"
X-IronPort-AV: E=Sophos;i="6.00,187,1681196400"; 
   d="scan'208";a="333795428"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2023 19:47:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10719"; a="828373561"
X-IronPort-AV: E=Sophos;i="6.00,187,1681196400"; 
   d="scan'208";a="828373561"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga004.jf.intel.com with ESMTP; 23 May 2023 19:47:16 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 23 May 2023 19:47:16 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 23 May 2023 19:47:15 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 23 May 2023 19:47:15 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.174)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 23 May 2023 19:47:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bXehbnNJZXnh1i+AMofqSaklJs61VbCDSZwoH3SzXCtBnMClq5ZuN99UqR9/UaC1fW8gT8x78kacTv1zaE+E2voM0sNk+pHh4aUNpwqkVs7LjkKU8taZtZBLtSrSRK3AccrdJWvS5Id0cPfzSpLlm1r0N9AOwIM/An0In2RI99X1P+4kZSgIAF2rdwjDauVcHAIi8cLOmA4v+CCCqJiDFj+1EJDbWADmot2Nu+kn/gR5AcdIIlWBNTxl+NLe8pZs1VdsmnBG0GCj9yk/3yXvvY02MEUiI0Xb4zPeGjLkreGcAi9alhgrDAnHv9ZRgRLiOwyRiMYam5VcOq00yqrzSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qq41iTeAF7PkTf1pJpE1rdsTLlQtXDQIv5ylFabGtNU=;
 b=Gst8mk+gP9nfylGcTYcNV/AKPvB7IxGJgKz9kfob3HBUNKk4VYeRw46G+1iTKHtxWOp6LdY/D0FCGNEd6s3GIbsUZ4BduR4uUHCx7P5cC93BKp/a5SiOX2HBGMS9UoDLM0XB61+YQzo8MWU5nyFi4YTi8jPff8rxuazfkn97oPfNtZFzk+fuMvqIdyyDvx9g7tSZ2OUaY9z1YLtxmQd+BMC044Awf9qJm31nt+MYyWfrt4CFeonm8pFCInu/vKs7M1ePBqafTC5qo6AgjHembvFCd4Vc3dV4x9IPHHMebUylZYcLuroG1wIaIn2wTPvGw8CsqQ1m2wNOPX5bSz2rJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DM4PR11MB5391.namprd11.prod.outlook.com (2603:10b6:5:396::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6411.28; Wed, 24 May 2023 02:47:13 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::a670:49f5:d602:e2e4]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::a670:49f5:d602:e2e4%6]) with mapi id 15.20.6411.029; Wed, 24 May 2023
 02:47:13 +0000
Date:   Wed, 24 May 2023 10:22:06 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Chao Gao <chao.gao@intel.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <pbonzini@redhat.com>
Subject: Re: [PATCH v2 1/6] KVM: x86/mmu: add a new mmu zap helper to
 indicate memtype changes
Message-ID: <ZG10zi6YtqGeik7u@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230509134825.1523-1-yan.y.zhao@intel.com>
 <20230509135006.1604-1-yan.y.zhao@intel.com>
 <ZFsr9TynkA/CyPgg@chao-email>
 <ZFtQeLNuXP6tDMne@yzhao56-desk.sh.intel.com>
 <ZG1DhSdhpTkxrfCq@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZG1DhSdhpTkxrfCq@google.com>
X-ClientProxiedBy: SG2PR01CA0182.apcprd01.prod.exchangelabs.com
 (2603:1096:4:189::20) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DM4PR11MB5391:EE_
X-MS-Office365-Filtering-Correlation-Id: 128e024c-7969-4528-af2f-08db5c012d93
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HWzVxGWWUj6QdhE4VgOH3VxN1R/YB7KYRsBN4BxHRHYc2PvlbEwrhJlz70vMxKyprJdslkOmXAhvS2nKd9vFnvqfA28FyEodlX5AT91AR/86sXaMGgyfbPVXsW+hhCDXRSXZw/ZrfsdN61Rs/dmjKmlnRGFBbnLATPT4T/RW1vPByl4HQVhvaiIgmn92dBXAsv6XHmQJKw2cDGy6eq7h4T2mOfyZ2VrSXQ+cpGLNVIo1ln9Q46IBK66x3B0SdFjgY58QwU2pNjl6dJc8odIodJHRxJ08jz/AJTg7WTidEGnPA5pJkwZga+bDnoky2py1z+rx2FuQZCAQxf/yo56MuNwcLF4w851zcAr0vo7zdEw3VA7KX+GPO8T/AF6RBhADzNH2imcoEWiccErW2iJBZfPgoJLcwrQIYkZOLM4XXN3mr4ZUwioJtw92Rro8B3P3Lm40eB+Utey83DdTt/UGlg7ABQnTcWlIt1Fwa7ytj5ubNkmSNUmw0ASTa3cs9Th6uHGM04pzyJk4dmAkJLPx+9nJ6hKskKULbbFnQn8HGuy6G7DcPK59aUMzEBG92r20Hg1wk3aXnfAskotM4Ke9uQuOtYTEZAzWuSdC/48chqCzggQJyrLih+4Fp6f+MSAu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(346002)(396003)(376002)(366004)(136003)(451199021)(6506007)(6512007)(26005)(186003)(83380400001)(6486002)(2906002)(6666004)(6916009)(478600001)(316002)(5660300002)(3450700001)(66946007)(66556008)(66476007)(4326008)(38100700002)(86362001)(41300700001)(8936002)(8676002)(82960400001)(309714004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?njEbF4EkMg86rku9xotp8pXctu4jtQIoKVqL2D6AOxYi6ku+6UMIAcfTp8QU?=
 =?us-ascii?Q?1IoAi7HW17NQHTYwzgL9c87yrf86JWHNZyRe0Xn89C6t6C2GuIiqQa8EW9K8?=
 =?us-ascii?Q?GngSeCzaTrJYRAtV3ebh83o28xu2QKwsdNFXpD4ELPArkwVPaWTllEqx7Foj?=
 =?us-ascii?Q?8h14MZKOR7xrOjY6qQ03VQS8KipxPAfE0RHaXBSlMHBBAmflaTVw5LX4A9/P?=
 =?us-ascii?Q?jMCWQm2lA2uBcXgdefBuApUvSEk0SbAAuikEnEX7uOTIA9Nb89CrWG9DiJxM?=
 =?us-ascii?Q?INE5hI6T6P/Ftxlb7R0lTz/qIvTl21lQIE6m3MEikApW0tIBRSO6LHQUGLrN?=
 =?us-ascii?Q?Yv5k9rCnHubDiA5a6oDgf0ueSitGMwnyNpgM3GqB4oqxV9HQRfnCPLx3tM5O?=
 =?us-ascii?Q?5KSRUVz15GAlJZPx/XaqzcpxDepnrJylI78Xi/PR0S1bWrgdDK+tGcSRuGqu?=
 =?us-ascii?Q?LzwLpDCMZlxyYjdPDbvAoLbuRx7sT8HNFbZJM8K+L+1GLFAWULM2fYdCWxTf?=
 =?us-ascii?Q?+vOVF9RIyuKHvdC0paa3d27GJdYOsrv9R+pwKG53jxOOAp37J5TtbjWDhJCK?=
 =?us-ascii?Q?Ucps2fHs9z6pUGzfhr+MJJUsDlCQt3iZNO4NEYqu9cEU2/IuPVPcPEOSv3iu?=
 =?us-ascii?Q?9lcufli4/7kE4imnphnKvfcWCj9+xBaWHSh/DvuwnTC0nrD9dNSTqtp/JOyD?=
 =?us-ascii?Q?CAGfbyC2OMTff7cNzuQyDKf9SqyM5ORgVP31uxm6jid5gx/0pap3qI/ZHTQ2?=
 =?us-ascii?Q?7/oaGOxC7Zac8VeqffVzM0RG65Jzhvds82tKH+ZoTmNAVv5fMGmS0pJ1Klss?=
 =?us-ascii?Q?DETRTEm+720rQdGbGPWL+wAM7ihwqQXc0ZUO8EnPIjMRu//4Ytmz7ggcFhff?=
 =?us-ascii?Q?m/7/zMnp4+A4EjMEpWz7G7oySuUINMkZ8d3CVh/kPst6jhiLJS2Z44hQ05tQ?=
 =?us-ascii?Q?KDlScwpJyEl3sQLAkDMyvl4DERMdhL1eMPnkhslsNlCFDA5S+ynJoyxLjw1O?=
 =?us-ascii?Q?gSQbjjgUyRQTrANRjzpySFGjdNoRU5ulbkbWu7X9dcWs0NQcLRLiBvMYxn3v?=
 =?us-ascii?Q?TJI2zzZ0rkGGCtBWvLmyijAdsOYrhYqIgRbhWNOUJyLs3JC0oJ2+2893PZsx?=
 =?us-ascii?Q?3UavhE0Xx3FO0P+rzzyiXwxP2+ypJmImeXMTXQPFyGmrZpRuP0Y6bkS7i4VE?=
 =?us-ascii?Q?TAnCl+UQoJcUsk4LwQpAFO7oT1kSChstntvG3oJdKFFzlU8y4zlAbLQgzH+c?=
 =?us-ascii?Q?wn+FYMDXtLKrtwCJp+DE4fqaiIxV3yAF7ID4EdATHszjU9rOyj84Xr/OxAo1?=
 =?us-ascii?Q?fygjYudaAfWItKhENjSEmqR1xCBRhlkESPLISshcEFg8TjY+Otq5soKC6shn?=
 =?us-ascii?Q?SErJJSxZDZ4EJs00s4bOZozRhbdL6fItZPDGQd6CcPlozTCcTgAZHUharZFS?=
 =?us-ascii?Q?fDHqGimM36y6gdLbPDJ4z4IhQyFGjkx9b5M3uZgswW3xgQmgZw4W3J08nPn0?=
 =?us-ascii?Q?Fa8xuRMdPiZM2z6BOJq0APa8PNqZLDSE6OXgrkbk55jIXfE9whpMxoaVxsVK?=
 =?us-ascii?Q?y1zCeav/oseJ6XJJGGlmWTueRkJaJYI4bp5Dg81H?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 128e024c-7969-4528-af2f-08db5c012d93
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2023 02:47:13.4660
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PNdZhU+ROz0/bTMHmej2Rj5tKks4qrMPdfkDqWKTzC3WmiehUG9/ScffXaHzyotKDRBdeROVgJUBOSWrXd59JA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5391
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

On Tue, May 23, 2023 at 03:51:49PM -0700, Sean Christopherson wrote:
> Rather than add a helper to zap "for memtype", add a helper to query if KVM honors
> guest MTRRs.  The "for memtype" isn't intuitive and ends up being incomplete.
> That will also allow for deduplicating other code (and a comment).  Waiting until
> the zap also wastes cycles in the MTRR case, there's no need to compute start and
> end if the zap will ultimately be skipped.
Agreed.

> 
> E.g. over two or three patches:
> 
> ---
>  arch/x86/kvm/mmu.h     |  1 +
>  arch/x86/kvm/mmu/mmu.c | 19 ++++++++++++++-----
>  arch/x86/kvm/mtrr.c    |  2 +-
>  arch/x86/kvm/x86.c     |  2 +-
>  4 files changed, 17 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index 92d5a1924fc1..c3c50ec9d9db 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -103,6 +103,7 @@ static inline u8 kvm_get_shadow_phys_bits(void)
>  void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 access_mask);
>  void kvm_mmu_set_me_spte_mask(u64 me_value, u64 me_mask);
>  void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only);
> +bool kvm_mmu_honors_guest_mtrrs(struct kvm *kvm);
>  
>  void kvm_init_mmu(struct kvm_vcpu *vcpu);
>  void kvm_init_shadow_npt_mmu(struct kvm_vcpu *vcpu, unsigned long cr0,
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index c8961f45e3b1..a2b1723bc6a4 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4512,12 +4512,10 @@ static int kvm_tdp_mmu_page_fault(struct kvm_vcpu *vcpu,
>  }
>  #endif
>  
> -int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> +bool kvm_mmu_honors_guest_mtrrs(struct kvm *kvm)
>  {
>  	/*
> -	 * If the guest's MTRRs may be used to compute the "real" memtype,
> -	 * restrict the mapping level to ensure KVM uses a consistent memtype
> -	 * across the entire mapping.  If the host MTRRs are ignored by TDP
> +	 * If the TDP is enabled, the host MTRRs are ignored by TDP
>  	 * (shadow_memtype_mask is non-zero), and the VM has non-coherent DMA
>  	 * (DMA doesn't snoop CPU caches), KVM's ABI is to honor the memtype
>  	 * from the guest's MTRRs so that guest accesses to memory that is
> @@ -4526,7 +4524,18 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>  	 * Note, KVM may still ultimately ignore guest MTRRs for certain PFNs,
>  	 * e.g. KVM will force UC memtype for host MMIO.
>  	 */
> -	if (shadow_memtype_mask && kvm_arch_has_noncoherent_dma(vcpu->kvm)) {
> +	return tdp_enabled && shadow_memtype_mask &&
> +	       kvm_arch_has_noncoherent_dma(kvm);
> +}
> +
> +int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> +{
> +	/*
> +	 * If the guest's MTRRs may be used to compute the "real" memtype,
> +	 * restrict the mapping level to ensure KVM uses a consistent memtype
> +	 * across the entire mapping.
> +	 */
> +	if (kvm_mmu_honors_guest_mtrrs(vcpu->kvm)) {
>  		for ( ; fault->max_level > PG_LEVEL_4K; --fault->max_level) {
>  			int page_num = KVM_PAGES_PER_HPAGE(fault->max_level);
>  			gfn_t base = gfn_round_for_level(fault->gfn,
> diff --git a/arch/x86/kvm/mtrr.c b/arch/x86/kvm/mtrr.c
> index 3eb6e7f47e96..a67c28a56417 100644
> --- a/arch/x86/kvm/mtrr.c
> +++ b/arch/x86/kvm/mtrr.c
> @@ -320,7 +320,7 @@ static void update_mtrr(struct kvm_vcpu *vcpu, u32 msr)
>  	struct kvm_mtrr *mtrr_state = &vcpu->arch.mtrr_state;
>  	gfn_t start, end;
>  
> -	if (!tdp_enabled || !kvm_arch_has_noncoherent_dma(vcpu->kvm))
> +	if (!kvm_mmu_honors_guest_mtrrs(vcpu->kvm))
Could we also add another helper kvm_mmu_cap_honors_guest_mtrrs(), which
does not check kvm_arch_has_noncoherent_dma()?

+static inline bool kvm_mmu_cap_honors_guest_mtrrs(struct kvm *kvm)
+{
+       return !!shadow_memtype_mask;
+}

This is because in patch 4 I plan to do the EPT zap when
noncoherent_dma_count goes from 1 to 0.

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 41d7bb51a297..ad0c43d7f532 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13146,13 +13146,19 @@ EXPORT_SYMBOL_GPL(kvm_arch_has_assigned_device);

 void kvm_arch_register_noncoherent_dma(struct kvm *kvm)
 {
-       atomic_inc(&kvm->arch.noncoherent_dma_count);
+       if (atomic_inc_return(&kvm->arch.noncoherent_dma_count) == 1) {
+               if (kvm_mmu_cap_honors_guest_mtrrs(kvm))
+                       kvm_zap_gfn_range(kvm, 0, ~0ULL);
+       }
 }
 EXPORT_SYMBOL_GPL(kvm_arch_register_noncoherent_dma);

 void kvm_arch_unregister_noncoherent_dma(struct kvm *kvm)
 {
-       atomic_dec(&kvm->arch.noncoherent_dma_count);
+       if (!atomic_dec_return(&kvm->arch.noncoherent_dma_count)) {
+               if (kvm_mmu_cap_honors_guest_mtrrs(kvm))
+                       kvm_zap_gfn_range(kvm, 0, ~0ULL);
+       }
 }
 EXPORT_SYMBOL_GPL(kvm_arch_unregister_noncoherent_dma);


>  		return;
>  
>  	if (!mtrr_is_enabled(mtrr_state) && msr != MSR_MTRRdefType)
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 076d50f6321b..977dceb7ba7e 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -942,7 +942,7 @@ void kvm_post_set_cr0(struct kvm_vcpu *vcpu, unsigned long old_cr0, unsigned lon
>  		kvm_mmu_reset_context(vcpu);
>  
>  	if (((cr0 ^ old_cr0) & X86_CR0_CD) &&
> -	    kvm_arch_has_noncoherent_dma(vcpu->kvm) &&
> +	    kvm_mmu_honors_guest_mtrrs(vcpu->kvm) &&
>  	    !kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_CD_NW_CLEARED))
>  		kvm_zap_gfn_range(vcpu->kvm, 0, ~0ULL);
>  }
> 
> base-commit: 8d4a1b4011c125b1510254b724433aaae746ce14
> -- 
> 
