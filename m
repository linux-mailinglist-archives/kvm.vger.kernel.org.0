Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1E8E7459A2
	for <lists+kvm@lfdr.de>; Mon,  3 Jul 2023 12:06:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230137AbjGCKGx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jul 2023 06:06:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230016AbjGCKGv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Jul 2023 06:06:51 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DAC7DD;
        Mon,  3 Jul 2023 03:06:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688378805; x=1719914805;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=uX5ATIFPK2TK1ANoVPK0bhaXb5azYbuMvjqU7VKIYMA=;
  b=TXWJ44wkDDWKxPJEU4KVRY5D6TnYbTxVSK3YIHPURiN544lfCDr9w/QG
   tAKaTYju5AfrB8EzFYQpUZESwTtntMobqDrYoRlfXxNvq+ppsQWpUW6Bg
   YtariM7nDKBwmG0R2IxjVDsJ2w9IQKpavbjPzM+S+FPn8R4a01Kz4jRIc
   pFuIlVgiWJCyLCWC3y7tSEegidmyWlKI3+lJOFGeMeRZKQiS48wviNKpg
   fEUV4MBq7NTUJdpposZAwiTuXdkvBlscdFvOasEATKIWZ5L8w3v00pYWa
   qjl18geuX8y60l5R5vXf1BfBzB3WPj1Ka5izCpxPgI1OYEsdXLG4OfzUp
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10759"; a="352668225"
X-IronPort-AV: E=Sophos;i="6.01,177,1684825200"; 
   d="scan'208";a="352668225"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2023 03:06:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10759"; a="718548754"
X-IronPort-AV: E=Sophos;i="6.01,177,1684825200"; 
   d="scan'208";a="718548754"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga002.jf.intel.com with ESMTP; 03 Jul 2023 03:06:15 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 3 Jul 2023 03:06:14 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 3 Jul 2023 03:06:14 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Mon, 3 Jul 2023 03:06:14 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.46) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Mon, 3 Jul 2023 03:06:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BUJAXSEYvzj6Tfn9xrMQrWZGLpOkoRtmGT7omta0ii+vd86eATxcrVhMzSJ1BfuNagwNMpp5ISDA6xbhTA0XjkctoGgPYaBALLkhwG9FOkyYwbqjMVgFauvDyfDuXHQURNT5+XrV4Bw5jbWzKjB7ThvVIEFclVsM9r1qFfUiM5NJr4J7FESylPCymctzZxayB2LLnPpl8oTwiMLrUBtrsg2Zig6oFPbsdcGOYB2l1xNorGjDpjieS3T+7Tj2jt1z+PbHuKwyRiDu+ARSOp+OXmmDcLN8NeWMcZ+7kS6IKZxlMGfta4YZMLHhvqEOLoDE52SaFomb06QEI1JrMQMHzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V8Eiya5fklunliq/9wPLKjNq0TdzthjS0yy/z77SwmU=;
 b=NjfhpyAkky8YRY7VhrHapgpOd3yfer8L8ugzOsk5Cn6WRdZqlYmz2gGzJSjzpAJp9KtOFSRwWHI+eykQ8iGV38N2LyaJL1VcxS4oZ92j18tU3ZGV+Xjw8Sa8o5HbiINVSQCuLR9tgHYq3JE/GdC5hTynoTTbrzVsQU01W7NSyvjTAsy77oD9cPOsa/zzgc3NRIXfWq6UV6MGuk7pRUndgZUnTKXvP+17XbbSGfnesi0dQqBOVSgfQFocXIvGcqpr6YJLGSGKzabecTJCYiK82EAhixNzm59OJHW7wqMPV3WW7yRAJ1SWTKyo9sMvlJpKNm9lLmNgx8h3JX+UQceaCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 MW4PR11MB6935.namprd11.prod.outlook.com (2603:10b6:303:228::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6544.24; Mon, 3 Jul
 2023 10:06:11 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::9f93:c41e:2b80:1d6]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::9f93:c41e:2b80:1d6%7]) with mapi id 15.20.6544.024; Mon, 3 Jul 2023
 10:06:11 +0000
Date:   Mon, 3 Jul 2023 17:40:46 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Reima Ishii <ishiir@g.ecc.u-tokyo.ac.jp>,
        <shina@ecc.u-tokyo.ac.jp>, Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <yuan.yao@intel.com>
Subject: Re: [PATCH] KVM: nVMX: Prevent vmlaunch with EPTP pointing outside
 assigned memory area
Message-ID: <ZKKXnu9E14Pz38Tc@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230628071217.71126-1-ishiir@g.ecc.u-tokyo.ac.jp>
 <ZJxTTZzZnfbyMVIH@google.com>
 <ZJ0w5pKk/41Zv26i@yzhao56-desk.sh.intel.com>
 <ZJ3FyLUYrlr6+HLw@google.com>
 <ZJ3p5wBwyQZ+aQOV@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZJ3p5wBwyQZ+aQOV@google.com>
X-ClientProxiedBy: SG2P153CA0012.APCP153.PROD.OUTLOOK.COM (2603:1096::22) To
 DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|MW4PR11MB6935:EE_
X-MS-Office365-Filtering-Correlation-Id: 0182783c-8b79-4e59-563b-08db7bad20b9
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: z7NLeJNqOkz8BUW8jaCLSdtaMl1w42dvkpX2F2Lb6ecAIWt8qz1aMvr6Y0OndtTI+cetnUwYzccv4uyOAnC3oTsqAy1XxUXpGrGQYrU/CAiWH1cw6q3XktumvpemWrWpnUnhybC1S+ypiaXCBL7lyLzk7boeD/6uFDs696By/wa1/NPC+4YEYnaHnnNPCOnOcmv49vKavJfcy7HNMT1euEI/LdPvD2SF8YZsWY/pwcvZIE2m/7GyoAmqMNjeKCT9uGhoZPPBlbFqt+DLnnA+ab4bmd47Bi1EuWkBvS8fuWJxuREe51YxFPhc6tx8K56OKXbNrx5XnEkMAJSkzhmMYDAcWf8gvURCflRzGQdhdvSbq5KiU6jyAqsGKTHruTyiCh8xdojZTKR3oAP2hqmLf+QWMCGnt7JApyAZnyg4YcT+REELaJvbwIRZjL5ig4YnT1mSLj/r3336+l16M/kRR1on99NUIEii7grjUPV3v3oxgH8XL8ObwcS7/y3K4xnVI1UaSJknktjSDYhXMvq3qqDuhosyK212xtG1qIYtg3+fBG+UEoSIVUM0kPeGbr2g
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(346002)(376002)(136003)(396003)(39860400002)(451199021)(4326008)(316002)(66556008)(186003)(66476007)(6916009)(66946007)(6506007)(6512007)(26005)(86362001)(83380400001)(82960400001)(2906002)(3450700001)(6486002)(38100700002)(66899021)(6666004)(30864003)(7416002)(5660300002)(478600001)(8676002)(54906003)(8936002)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JnYj/2CQvd1usrGNa0BXY6/NwrPj91Q9ORZsOo3a3/CB3guPcDnRLpYzNVBc?=
 =?us-ascii?Q?rB29OrwzlauF6EoGYgCUs+UZZrbxrEXCLdzcvQ8kKy+m6Pa4tj8bJbJI7dZf?=
 =?us-ascii?Q?JWKBEnRbSJmU72hWLR4wH/fW8RCpxYHjdAIX/PJOVYv17CAQMOwpp/LFe3dD?=
 =?us-ascii?Q?ni6DIGY6kYlaBwkOvQnkMu4RYNfXFn/7vcb7mRsUglcZbY7ZutZ4ZtZ1JztB?=
 =?us-ascii?Q?EpxZFbqxxmSPjOo2bfFyfdUT1C7OvgO72kC/ljEdkkrM+lbnPhzq9cpMamRl?=
 =?us-ascii?Q?AeVNtFtX+I2lmTdmmHW7HXTOhFdi2wxeB5UN3/fspuE0QoefrMt010yt/CE1?=
 =?us-ascii?Q?v8G6LljQ/ak77M/4iPFW3kuP41niPHcFNt8KYxPUqOS/IC6ZxqLrNEjWikT9?=
 =?us-ascii?Q?c+M2m8LuNTf4qsczvIQF1BwrmQhrL7X3mUI9TCE9R4rmspvepbigKHW1wy1k?=
 =?us-ascii?Q?+CoHIGslI5a51TyCKX5fgYKWPFfe5xKTrSWju7X3Kkx/Wh/EwaiCa0EhE4bn?=
 =?us-ascii?Q?yb8W/y0+Z2Xp6h8+AseqOfkKVx9430NmbN1HkfXVwTrUCYj152llEruUWSmS?=
 =?us-ascii?Q?zwP4TWGu9sTifZpRmEArDgPeqIrR/gZJt4enBXxIBwmOaZo7zFAlbtvaBfpK?=
 =?us-ascii?Q?FaBeO33kjpq6lwFJWetQe0MQWq3s2v4TTbKi1DmJ6+Is1WOMjmWIdZd9c3O+?=
 =?us-ascii?Q?0AtI+knrm2ZODeAQ7UZmnaxqYILiWtRot6wYuFhDuqUQjlbwWTdcQbfyHHHc?=
 =?us-ascii?Q?5PRJwFrzFK2wtTvtcIb9shIZJz6Li6cXORg/BxnasIkmSUKX2EVFWa3t6Vpe?=
 =?us-ascii?Q?Pycdf63C4COwVd54mS/FpfqcXzG+PPslGTkWGn3XahMDdNZBtxjbrAiTYLHC?=
 =?us-ascii?Q?ndpi6ByxkVhtXO/Rs5I2weRykiYm/a7U7uCSGLWdLh/ZT894teQWsj98cQF/?=
 =?us-ascii?Q?jbZVedx/UZJTHkSJAjIMXIa4xjUdeNruEMW9i4xyKPpKynMbE88dk4T+bNwd?=
 =?us-ascii?Q?8XGBmgfW+G1ZrOGTQvTtB6dcmeEnQGmNVEMDcmfKihNQKU1Hk4QlhfZ6ius8?=
 =?us-ascii?Q?5cf+wPZBuANxEVq+FdyJongxPIOlHSC6fknHT2jpN12KZ2Z5Zq+7LRsa/BA5?=
 =?us-ascii?Q?kiBcvUaHiSlb8nWXUH571G6RO98cI+mi2/JhSKibVIgPzfQfc4Xu/358wqzq?=
 =?us-ascii?Q?5mYI8Hg6dPrGawhhjnHc5BEz2w96tdhhio/bhw+fAgO4vGyslYKGlMEn3NCX?=
 =?us-ascii?Q?lXgVLzPkrrXIdTMGz2ElC+XVR+VFdfJRNC2UUEK5KjSqJM0LboLZJECNwpyI?=
 =?us-ascii?Q?xGyi2IAMMh1cm8tLmeTE9kuxfqCR7dxGkSkBxr0+Z6fZH6f8Evt8xknQ/NXe?=
 =?us-ascii?Q?cNS+ETSKuLo6wJ4GSBSU2/WCi3gaF9Ppb3ZhRspgjuPSiGmcFn1GAx4HMuWV?=
 =?us-ascii?Q?FuggCz7Zs5RZeremOzTiomQQxnZ0CrzVMhuhHHTfaKVQq4oWdJNAAzEfxe9s?=
 =?us-ascii?Q?6g7l8tpUJYHm7mq1VVHrZ2i3pThk2E6WHdGrl4WlrQIggA+oQcRtgJcn/yAo?=
 =?us-ascii?Q?r8vRQ+wBNrm0jGfVlhV2bj6+yYECa2+g/w2PS8Vp?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0182783c-8b79-4e59-563b-08db7bad20b9
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2023 10:06:11.6022
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8nPwdPS3g1iMqtQ+D7rSrURDp89GLeReMvWt5F4VHkj0KwWvbzOhbGv4ut+ZQp2Xc1SVXFCO7mRrhKMLBk0/6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6935
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

On Thu, Jun 29, 2023 at 01:30:31PM -0700, Sean Christopherson wrote:
> On Thu, Jun 29, 2023, Sean Christopherson wrote:
... 
> Turns out, not _that_ gross.  Exempting triple fault "works", but as I called out
> earlier, it generates the incorrect exit reason in KVM-Unit-Tests, e.g. when KUT
> stuffs a bad GUEST_RFLAGS to trigger a VM-Exit consistency check, because the
> consistency check has higher priority than anything that can lead to triple fault.
> And I couldn't bring myself to propagate the hack into testing code.
> 
> Lightly tested, but if this pans out, I'll post a series to (a) exempt triple
> fault so that there's a fix for stable@, (b) effect the below over several patches,
> and (c) revert the triple fault hack so that HEAD is architecturally less wrong.
> 
> ---
>  arch/x86/kvm/kvm_onhyperv.c     |  5 ++
>  arch/x86/kvm/mmu.h              |  7 +--
>  arch/x86/kvm/mmu/mmu.c          | 92 ++++++++++++++++-----------------
>  arch/x86/kvm/mmu/mmu_internal.h | 10 ++++
>  arch/x86/kvm/mmu/spte.h         | 12 +++++
>  arch/x86/kvm/mmu/tdp_iter.c     |  7 ++-
>  arch/x86/kvm/mmu/tdp_mmu.c      |  2 +-
>  7 files changed, 79 insertions(+), 56 deletions(-)
> 
> diff --git a/arch/x86/kvm/kvm_onhyperv.c b/arch/x86/kvm/kvm_onhyperv.c
> index ded0bd688c65..77add2afc92b 100644
> --- a/arch/x86/kvm/kvm_onhyperv.c
> +++ b/arch/x86/kvm/kvm_onhyperv.c
> @@ -113,6 +113,11 @@ void hv_track_root_tdp(struct kvm_vcpu *vcpu, hpa_t root_tdp)
>  {
>  	struct kvm_arch *kvm_arch = &vcpu->kvm->arch;
>  
> +	if (!kvm_mmu_is_usable_root(root_tdp)) {
> +		vcpu->arch.hv_root_tdp = INVALID_PAGE;
> +		return;
> +	}
> +
>  	if (kvm_x86_ops.flush_remote_tlbs == hv_flush_remote_tlbs) {
>  		spin_lock(&kvm_arch->hv_root_tdp_lock);
>  		vcpu->arch.hv_root_tdp = root_tdp;
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index 92d5a1924fc1..6dcc81582afa 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -146,12 +146,7 @@ static inline unsigned long kvm_get_active_pcid(struct kvm_vcpu *vcpu)
>  
>  static inline void kvm_mmu_load_pgd(struct kvm_vcpu *vcpu)
>  {
> -	u64 root_hpa = vcpu->arch.mmu->root.hpa;
> -
> -	if (!VALID_PAGE(root_hpa))
> -		return;
> -
> -	static_call(kvm_x86_load_mmu_pgd)(vcpu, root_hpa,
> +	static_call(kvm_x86_load_mmu_pgd)(vcpu, vcpu->arch.mmu->root.hpa,
>  					  vcpu->arch.mmu->root_role.level);
>  }
>  
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 6e6078194ec7..64a918d89472 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3574,11 +3574,7 @@ static void mmu_free_root_page(struct kvm *kvm, hpa_t *root_hpa,
>  	if (!VALID_PAGE(*root_hpa))
>  		return;
>  
> -	/*
> -	 * The "root" may be a special root, e.g. a PAE entry, treat it as a
> -	 * SPTE to ensure any non-PA bits are dropped.
> -	 */
> -	sp = spte_to_child_sp(*root_hpa);
> +	sp = root_to_sp(*root_hpa);
>  	if (WARN_ON(!sp))
>  		return;
>  
> @@ -3624,7 +3620,9 @@ void kvm_mmu_free_roots(struct kvm *kvm, struct kvm_mmu *mmu,
>  					   &invalid_list);
>  
>  	if (free_active_root) {
> -		if (to_shadow_page(mmu->root.hpa)) {
> +		if (kvm_mmu_is_dummy_root(mmu->root.hpa)) {
> +			/* Nothing to cleanup for dummy roots. */
> +		} else if (root_to_sp(mmu->root.hpa)) {
>  			mmu_free_root_page(kvm, &mmu->root.hpa, &invalid_list);
>  		} else if (mmu->pae_root) {
>  			for (i = 0; i < 4; ++i) {
> @@ -3648,6 +3646,7 @@ EXPORT_SYMBOL_GPL(kvm_mmu_free_roots);
>  void kvm_mmu_free_guest_mode_roots(struct kvm *kvm, struct kvm_mmu *mmu)
>  {
>  	unsigned long roots_to_free = 0;
> +	struct kvm_mmu_page *sp;
>  	hpa_t root_hpa;
>  	int i;
>  
> @@ -3662,8 +3661,8 @@ void kvm_mmu_free_guest_mode_roots(struct kvm *kvm, struct kvm_mmu *mmu)
>  		if (!VALID_PAGE(root_hpa))
>  			continue;
>  
> -		if (!to_shadow_page(root_hpa) ||
> -			to_shadow_page(root_hpa)->role.guest_mode)
> +		sp = root_to_sp(root_hpa);
> +		if (!sp || sp->role.guest_mode)
>  			roots_to_free |= KVM_MMU_ROOT_PREVIOUS(i);
>  	}
>  
> @@ -3671,19 +3670,6 @@ void kvm_mmu_free_guest_mode_roots(struct kvm *kvm, struct kvm_mmu *mmu)
>  }
>  EXPORT_SYMBOL_GPL(kvm_mmu_free_guest_mode_roots);
>  
> -
> -static int mmu_check_root(struct kvm_vcpu *vcpu, gfn_t root_gfn)
> -{
> -	int ret = 0;
> -
> -	if (!kvm_vcpu_is_visible_gfn(vcpu, root_gfn)) {
> -		kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
> -		ret = 1;
> -	}
> -
> -	return ret;
> -}
> -
>  static hpa_t mmu_alloc_root(struct kvm_vcpu *vcpu, gfn_t gfn, int quadrant,
>  			    u8 level)
>  {
> @@ -3821,8 +3807,10 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
>  	root_pgd = kvm_mmu_get_guest_pgd(vcpu, mmu);
>  	root_gfn = root_pgd >> PAGE_SHIFT;
>  
> -	if (mmu_check_root(vcpu, root_gfn))
> -		return 1;
> +	if (!kvm_vcpu_is_visible_gfn(vcpu, root_gfn)) {
> +		mmu->root.hpa = kvm_mmu_get_dummy_root();

Also set mmu->root.pgd = root_pgd,
and reset mmu->root.hpa to INVALID_PAGE to trigger a reload after adding
corresponding memslot?

> +		return 0;
> +	}
>  
>  	/*
>  	 * On SVM, reading PDPTRs might access guest memory, which might fault
> @@ -3834,8 +3822,8 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
>  			if (!(pdptrs[i] & PT_PRESENT_MASK))
>  				continue;
>  
> -			if (mmu_check_root(vcpu, pdptrs[i] >> PAGE_SHIFT))
> -				return 1;
> +			if (kvm_vcpu_is_visible_gfn(vcpu, pdptrs[i] >> PAGE_SHIFT))
> +				pdptrs[i] = 0;
>  		}
>  	}
>  
> @@ -4002,7 +3990,7 @@ static bool is_unsync_root(hpa_t root)
>  {
>  	struct kvm_mmu_page *sp;
>  
> -	if (!VALID_PAGE(root))
> +	if (!VALID_PAGE(root) || kvm_mmu_is_dummy_root(root))
>  		return false;
>  
>  	/*
> @@ -4018,7 +4006,7 @@ static bool is_unsync_root(hpa_t root)
>  	 * requirement isn't satisfied.
>  	 */
>  	smp_rmb();
> -	sp = to_shadow_page(root);
> +	sp = root_to_sp(root);
>  
>  	/*
>  	 * PAE roots (somewhat arbitrarily) aren't backed by shadow pages, the
> @@ -4035,8 +4023,9 @@ static bool is_unsync_root(hpa_t root)
>  
>  void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu)
>  {
> -	int i;
>  	struct kvm_mmu_page *sp;
> +	hpa_t root;
> +	int i;
>  
>  	if (vcpu->arch.mmu->root_role.direct)
>  		return;
> @@ -4047,12 +4036,12 @@ void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu)
>  	vcpu_clear_mmio_info(vcpu, MMIO_GVA_ANY);
>  
>  	if (vcpu->arch.mmu->cpu_role.base.level >= PT64_ROOT_4LEVEL) {
> -		hpa_t root = vcpu->arch.mmu->root.hpa;
> -		sp = to_shadow_page(root);
> -
> +		root = vcpu->arch.mmu->root.hpa;
>  		if (!is_unsync_root(root))
>  			return;
>  
> +		sp = root_to_sp(root);
> +
>  		write_lock(&vcpu->kvm->mmu_lock);
>  		mmu_sync_children(vcpu, sp, true);
>  		write_unlock(&vcpu->kvm->mmu_lock);
> @@ -4062,8 +4051,7 @@ void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu)
>  	write_lock(&vcpu->kvm->mmu_lock);
>  
>  	for (i = 0; i < 4; ++i) {
> -		hpa_t root = vcpu->arch.mmu->pae_root[i];
> -
> +		root = vcpu->arch.mmu->pae_root[i];
>  		if (IS_VALID_PAE_ROOT(root)) {
>  			sp = spte_to_child_sp(root);
>  			mmu_sync_children(vcpu, sp, true);
> @@ -4382,7 +4370,7 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
>  static bool is_page_fault_stale(struct kvm_vcpu *vcpu,
>  				struct kvm_page_fault *fault)
>  {
> -	struct kvm_mmu_page *sp = to_shadow_page(vcpu->arch.mmu->root.hpa);
> +	struct kvm_mmu_page *sp = root_to_sp(vcpu->arch.mmu->root.hpa);
>  
>  	/* Special roots, e.g. pae_root, are not backed by shadow pages. */
>  	if (sp && is_obsolete_sp(vcpu->kvm, sp))
> @@ -4562,9 +4550,16 @@ static void nonpaging_init_context(struct kvm_mmu *context)
>  static inline bool is_root_usable(struct kvm_mmu_root_info *root, gpa_t pgd,
>  				  union kvm_mmu_page_role role)
>  {
> -	return (role.direct || pgd == root->pgd) &&
> -	       VALID_PAGE(root->hpa) &&
> -	       role.word == to_shadow_page(root->hpa)->role.word;
> +	struct kvm_mmu_page *sp;
> +
> +	if (!VALID_PAGE(root->hpa))
> +		return false;
> +
> +	if (!role.direct && pgd != root->pgd)
> +		return false;
> +
> +	sp = root_to_sp(root->hpa);
> +	return sp && role.word == sp->role.word;
>  }
>  
>  /*
> @@ -4634,11 +4629,10 @@ static bool fast_pgd_switch(struct kvm *kvm, struct kvm_mmu *mmu,
>  			    gpa_t new_pgd, union kvm_mmu_page_role new_role)
>  {
>  	/*
> -	 * For now, limit the caching to 64-bit hosts+VMs in order to avoid
> -	 * having to deal with PDPTEs. We may add support for 32-bit hosts/VMs
> -	 * later if necessary.
> +	 * Limit reuse to 64-bit hosts+VMs without "special" roots in order to
> +	 * avoid having to deal with PDPTEs and other complexities.
>  	 */
> -	if (VALID_PAGE(mmu->root.hpa) && !to_shadow_page(mmu->root.hpa))
> +	if (VALID_PAGE(mmu->root.hpa) && !root_to_sp(mmu->root.hpa))
>  		kvm_mmu_free_roots(kvm, mmu, KVM_MMU_ROOT_CURRENT);
>  
>  	if (VALID_PAGE(mmu->root.hpa))
> @@ -4684,9 +4678,12 @@ void kvm_mmu_new_pgd(struct kvm_vcpu *vcpu, gpa_t new_pgd)
>  	 * If this is a direct root page, it doesn't have a write flooding
>  	 * count. Otherwise, clear the write flooding count.
>  	 */
> -	if (!new_role.direct)
> -		__clear_sp_write_flooding_count(
> -				to_shadow_page(vcpu->arch.mmu->root.hpa));
> +	if (!new_role.direct) {
> +		struct kvm_mmu_page *sp = root_to_sp(vcpu->arch.mmu->root.hpa);
> +
> +		if (!WARN_ON_ONCE(!sp))
> +			__clear_sp_write_flooding_count(sp);
> +	}
>  }
>  EXPORT_SYMBOL_GPL(kvm_mmu_new_pgd);
>  
> @@ -5536,12 +5533,13 @@ static bool is_obsolete_root(struct kvm *kvm, hpa_t root_hpa)
>  	 * positives and free roots that don't strictly need to be freed, but
>  	 * such false positives are relatively rare:
>  	 *
> -	 *  (a) only PAE paging and nested NPT has roots without shadow pages
> +	 *  (a) only PAE paging and nested NPT have roots without shadow pages
> +	 *      (or any shadow paging flavor with a dummy root)
>  	 *  (b) remote reloads due to a memslot update obsoletes _all_ roots
>  	 *  (c) KVM doesn't track previous roots for PAE paging, and the guest
>  	 *      is unlikely to zap an in-use PGD.
>  	 */
> -	sp = to_shadow_page(root_hpa);
> +	sp = root_to_sp(root_hpa);
>  	return !sp || is_obsolete_sp(kvm, sp);
>  }
>  
> @@ -5728,7 +5726,7 @@ int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 err
>  	int r, emulation_type = EMULTYPE_PF;
>  	bool direct = vcpu->arch.mmu->root_role.direct;
>  
> -	if (WARN_ON(!VALID_PAGE(vcpu->arch.mmu->root.hpa)))
> +	if (WARN_ON_ONCE(!VALID_PAGE(vcpu->arch.mmu->root.hpa)))
>  		return RET_PF_RETRY;
>  
>  	r = RET_PF_INVALID;
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index d39af5639ce9..3ca986450393 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -44,6 +44,16 @@ extern bool dbg;
>  #define INVALID_PAE_ROOT	0
>  #define IS_VALID_PAE_ROOT(x)	(!!(x))
>  
> +static inline hpa_t kvm_mmu_get_dummy_root(void)
> +{
> +	return my_zero_pfn(0) << PAGE_SHIFT;
> +}
> +
> +static inline bool kvm_mmu_is_dummy_root(hpa_t shadow_page)
> +{
> +	return is_zero_pfn(shadow_page >> PAGE_SHIFT);
> +}
> +
>  typedef u64 __rcu *tdp_ptep_t;
>  
>  struct kvm_mmu_page {
> diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
> index 1279db2eab44..ac8ad12f9698 100644
> --- a/arch/x86/kvm/mmu/spte.h
> +++ b/arch/x86/kvm/mmu/spte.h
> @@ -236,6 +236,18 @@ static inline struct kvm_mmu_page *sptep_to_sp(u64 *sptep)
>  	return to_shadow_page(__pa(sptep));
>  }
>  
> +static inline struct kvm_mmu_page *root_to_sp(hpa_t root)
> +{
> +	if (kvm_mmu_is_dummy_root(root))
> +		return NULL;
> +
> +	/*
> +	 * The "root" may be a special root, e.g. a PAE entry, treat it as a
> +	 * SPTE to ensure any non-PA bits are dropped.
> +	 */
> +	return spte_to_child_sp(root);
> +}
> +
>  static inline bool is_mmio_spte(u64 spte)
>  {
>  	return (spte & shadow_mmio_mask) == shadow_mmio_value &&
> diff --git a/arch/x86/kvm/mmu/tdp_iter.c b/arch/x86/kvm/mmu/tdp_iter.c
> index d2eb0d4f8710..eda82a0e7fdb 100644
> --- a/arch/x86/kvm/mmu/tdp_iter.c
> +++ b/arch/x86/kvm/mmu/tdp_iter.c
> @@ -41,8 +41,11 @@ void tdp_iter_start(struct tdp_iter *iter, struct kvm_mmu_page *root,
>  {
>  	int root_level = root->role.level;
>  
> -	WARN_ON(root_level < 1);
> -	WARN_ON(root_level > PT64_ROOT_MAX_LEVEL);
> +	if (WARN_ON_ONCE(!root || (root_level < 1) ||
Though I think it's impossible for root to be NULL here, it's strange to
access the root->role.level and WARN !root.

> +			 (root_level > PT64_ROOT_MAX_LEVEL))) {
> +		iter->valid = false;
> +		return;
> +	}
>  
>  	iter->next_last_level_gfn = next_last_level_gfn;
>  	iter->root_level = root_level;
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 512163d52194..046ac2589611 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -689,7 +689,7 @@ static inline void tdp_mmu_iter_set_spte(struct kvm *kvm, struct tdp_iter *iter,
>  		else
>  
>  #define tdp_mmu_for_each_pte(_iter, _mmu, _start, _end)		\
> -	for_each_tdp_pte(_iter, to_shadow_page(_mmu->root.hpa), _start, _end)
> +	for_each_tdp_pte(_iter, root_to_sp(_mmu->root.hpa), _start, _end)
>  
>  /*
>   * Yield if the MMU lock is contended or this thread needs to return control
> 
> base-commit: 9bee9f1881ecd4eb68ba1ca88b56bff88e50fc8a
> -- 
> 
