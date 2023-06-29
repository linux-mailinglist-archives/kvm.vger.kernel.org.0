Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B15A742147
	for <lists+kvm@lfdr.de>; Thu, 29 Jun 2023 09:46:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232213AbjF2Hqn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jun 2023 03:46:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230504AbjF2Hqj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Jun 2023 03:46:39 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EF74E5;
        Thu, 29 Jun 2023 00:46:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688024798; x=1719560798;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=0plKtLeyjWPuPH9UKWmSlWQ9MMEtaDpRAOIDHl8Q4aI=;
  b=b2JGK/s8ktmop8FY2aCsASTKgwPjeoG+S0uM18uL764SBuYbPFVm2gDC
   wQ/G+rT8Jw9kPLfsqQWByAibA3r+RwCGcNlR/cP+uNEGYfiW/Nt3M7wyM
   fs1zWpVlSHxWReyfczLS/5xszhgho3tuzs0nnXQc2kOYtb3dyOG0a4kyd
   HIl7CxByGdm10+ItXtQdfEf8PMHJC26PG/DUhC4WR8sXXJrvbqRYUhl+m
   1PJcuwfpYgKnKcLI3s5MOmrl1A0mYq7O5RDBvdU6bYrhBUbGT+ZfiMvpX
   8q9qvEOGi62JDMyFvG5eXozCaErRUiuqCO9w1Ke8V+5ZPg1FP7bwcVOqS
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10755"; a="351847843"
X-IronPort-AV: E=Sophos;i="6.01,167,1684825200"; 
   d="scan'208";a="351847843"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2023 00:46:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10755"; a="807217325"
X-IronPort-AV: E=Sophos;i="6.01,167,1684825200"; 
   d="scan'208";a="807217325"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by FMSMGA003.fm.intel.com with ESMTP; 29 Jun 2023 00:46:36 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 29 Jun 2023 00:46:35 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 29 Jun 2023 00:46:35 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Thu, 29 Jun 2023 00:46:35 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.107)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Thu, 29 Jun 2023 00:46:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KRcUSpumjyfVKlIiJP4neNM0Yw+ZZQJkzgqE+xQ4pi9BIxAOD9uqc1WqRaHPNtg3SC7UHuuIJQ3aV2t4O205YmqZRhMX4Q5HCjghjNFlhIZ4k+bmRZ7hs8YexgwFqy3RtoVttAwQgambiemVGJvA+q0CXdvaNg2JM1ucZwJWEPxelOd6B2f8GL1bnJ/ex0HWEAliSyKWyUZ3WCWbLi6E4FqIknXhyNq879FiLr+KfzIqU3FoPrZxUSFhbzAi+z7UeY1hILhHVeNCUCuxmXmi8h9e05MRn6qtdhWVwegrwXMiphdG/w9rdww8OYz40nN5RPwvntCO3hCRT07pTEmDSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6WvPI/oMS8jSKGIYdHsDhtbZVsCH7hnaYBi40YqeOSM=;
 b=jvzUwxCPQrAH0mYWSc6EOHSzUkJ0gORG6NzKXS0UDHz74lQ8QTT59GWUdPp4uRPwSOpwd3PZzQzy4ZIqwz2Y1VcWaNQWzbdPAT2AhpYhw/AIOujTfYUb77XFg3zVRFqMeey5mmXlrG6FoVWGwb65SeDKXMdGQSQyugGdtSpUd9vZmUJh12qeEOGlyrT/B/VexKEHMLBlipEWU0sX0Q2XIaFmgPxrwodoMdLKpxzrQa051wx6mt91yPCBeC49hEgPohxc7IyFaqcl4u5V5QNlkDvs95VfoalOa8S5UtfSkx/2U5mnyqV5IHOYJzSjeuhkbw7j/240nTf63YvD2dpR5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH7PR11MB6881.namprd11.prod.outlook.com (2603:10b6:510:200::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.37; Thu, 29 Jun
 2023 07:46:32 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::9f93:c41e:2b80:1d6]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::9f93:c41e:2b80:1d6%7]) with mapi id 15.20.6521.024; Thu, 29 Jun 2023
 07:46:32 +0000
Date:   Thu, 29 Jun 2023 15:21:10 +0800
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
Message-ID: <ZJ0w5pKk/41Zv26i@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230628071217.71126-1-ishiir@g.ecc.u-tokyo.ac.jp>
 <ZJxTTZzZnfbyMVIH@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZJxTTZzZnfbyMVIH@google.com>
X-ClientProxiedBy: SI2PR01CA0031.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::11) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH7PR11MB6881:EE_
X-MS-Office365-Filtering-Correlation-Id: 67612370-f1d4-464d-205b-08db7874f4c4
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MKPxpZSxYTMxsxLK17YarICt/GHW7OnhrOTqUNevebTP/EbN9XM6KtP+tqkftRH7LAFwswkk0JVzZVsH19zEeJdyaydYckbiQpHElk9oxULmb+d60wt/8fxQ+Cd9gsFQhHxnp1+eVYB/p/IJ5CVsDwe3okQWyUbzgLaoOwXFgrfFeXlFCK+fUlVg1aL8KySSN0h2FR+kQoNkMjDYOfWv3IDy8b2WcWeHoEZoBuEuALXsjtQ5/Jv/GmnU3JLIrkDOyh4W628C8ifzzCuH95fQQUcoZ8dNsP5bMiEoUNKNmSJvbX4An/Q5b3PQEKkPxZWhcUzy/ze3XYDpYA3v73osb/Vxz0U+3rG3SAXIXj3oPvblf4ddT1OwFHrrvsJI1JZPYt+aHgsgusaXMM9YJozHB2Qy7cNb7KcF8yW92SvcX40IAVVaSOGRVnjVj3CBXkynv6o4xMdi56tzweXYwdwdb2REwM0yTG+AThqCZn22F4KlNL+YMMQgkMI6dNVl4mJQ2P3J/ID3hZsjlc7H76hZ5kY/o9MCYhvMTd+fBzP3XxQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(366004)(396003)(136003)(376002)(346002)(451199021)(83380400001)(66476007)(4326008)(6916009)(66946007)(66556008)(316002)(8676002)(3450700001)(5660300002)(2906002)(7416002)(41300700001)(8936002)(38100700002)(54906003)(478600001)(86362001)(186003)(6512007)(6666004)(6486002)(6506007)(82960400001)(26005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?G77RYu3mYd0sjealTjE2SQcO2bUcZ8Lb4vHN8hgkod4viUJU8VlnOoDBGmQQ?=
 =?us-ascii?Q?a1yzlH8aiqPe7S2IKlxLHXKPHdRf4POzNxYvb7kz8QtEtuvP1ommnYbMAeuj?=
 =?us-ascii?Q?+ku/pC6khN5RX4IaQfp8Im1zEOks8LV8Z32Zhfe+JLrT6YVnIfSI4h7UFVxk?=
 =?us-ascii?Q?fO4dc0peK4EssfaY0xsCqZm+gmuj8auoPZm3xXfOCm3efOPOeKKKROq0unxh?=
 =?us-ascii?Q?qYLXyZZDtwU7pcLsxpB/tdzMVqhHUf5o9M/eqdL5v/UoDJxl1Dbt+3VRw9Ql?=
 =?us-ascii?Q?rHnvUaDaWBevVOaOdyhza26ylIWcTkJuAQy9TOB4QSv4NXwzL5mijKTRWMAd?=
 =?us-ascii?Q?Bxia6bGmRFGjQH6LCo5goPxg4/sgGTRTNB/gpqRZz7oH5TnTa3FuAgdzUcFl?=
 =?us-ascii?Q?XjhZ2EZNTyQZZZh+WVmz/ANxsF7FCbA5wibzgQb07a7/rlUKT9mzgg/rLEe1?=
 =?us-ascii?Q?NTsPru7ynvlQARibGUq+b3f3K9uTr9Sy8jXgqiVxlX2N1q0uiYH4cZhFcuaU?=
 =?us-ascii?Q?s/2ro6zZaacaym9H4TpwCJJRwH0clki2TW5Xy64CEUca0ChtEyX3T6nU5E0w?=
 =?us-ascii?Q?YwIPAyePTvr6uxL92JiJ9yfB7Jbb1j7lOmLyFYQq+knZ7YvWYUaFxTrWaqJN?=
 =?us-ascii?Q?O9NJ4QhOL7D1UEv20Pu+cQ0YQlwxfNjFQalySY2tkt8pHDflCufFgKQfbbno?=
 =?us-ascii?Q?lEPuzV504DMk2cTqtPHFINEiwI9VA8nKZl49S2Ap8hayi1rFY5s7DcVsUNbV?=
 =?us-ascii?Q?BxefzBhepJ2coygkpq6Kuft3ew3w4MChFdUSvNt5RJFrsJAY2J/TPfMeZ4zn?=
 =?us-ascii?Q?GRdKQcohUzN1sFJs6QmNlhABuoUb66n4bNHToafmtaB2/Tu+pe8K49y1pSpF?=
 =?us-ascii?Q?en2k2JP6K2t7HohzSC+QQlHyB4ZyMfux+7EXQ/YDj+mU11YcmwDOyolpqBpM?=
 =?us-ascii?Q?QmPom8lzit2V2b6y2OIStrorK9sJAvZtA4SGY9w8A4dQ7EBH9l51CWKGWYYW?=
 =?us-ascii?Q?5NE9ZSI2IyKTriHtKcXGJN44L8mK/okObkhegtVKclldVn9Er95OCW6mU4pL?=
 =?us-ascii?Q?2F0KImBq2JeF+DLflUFh2Jpe8hvLNz/0JzIRLMnSnN2ZtDGd/Z00ams7KMc/?=
 =?us-ascii?Q?7FClnjZIgHi7gV1lVDyahmxjwvlTl7vefu6QzzAgUXA1LulGeuBss5iapJU6?=
 =?us-ascii?Q?pbP1ecKH3ngyOoH70khiEgqlLB7tx/+qovNWWqXDi+E71OnqcBE+gsKNbDtf?=
 =?us-ascii?Q?9mmxLSSdMZsujr3N+hbzdoFYSIVK+Wq0lxLYvl3ohzO8gmLXelJYX07PW73Z?=
 =?us-ascii?Q?EBTNEvBRUkTnIhjRrinUsYAzHZf5Q0+SjNnOiCdYe6alnls7ThuzcOnVo0US?=
 =?us-ascii?Q?5ZgJQKb2NkAAFmVd/Gh+9FlkvzF9eDW6KjLYnKCcQ4QY8OD2x3SZBiLLRnBu?=
 =?us-ascii?Q?R4q0Fc2dOh4OW2W/+dzBuSgBnjjmUfFtrU0a/3DTpfb7rYeT8hM5JDsUj2UQ?=
 =?us-ascii?Q?KfUt6Q0VJbmCuP6yYXJNokBhnUZJGWJ58aGOhREwMCnVaJ25zBtVyiCwdG0l?=
 =?us-ascii?Q?zfS8K0WChzqJbybjcnFv5CapIlqzBrT4o7wg9oa+?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 67612370-f1d4-464d-205b-08db7874f4c4
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2023 07:46:32.3049
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +HNG/twxcv44chzXRiQ6Pq32ywoxVVdqe9a+D/jvCUA9XOSeVPmra1hEr1RJVmznWGlAeXrkDEYGUxJAGrcsUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6881
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

On Wed, Jun 28, 2023 at 08:37:45AM -0700, Sean Christopherson wrote:
...
> So I think we should try this:
> 
> ---
>  arch/x86/kvm/mmu/mmu.c   | 19 -------------------
>  include/linux/kvm_host.h |  1 -
>  virt/kvm/kvm_main.c      | 13 ++-----------
>  3 files changed, 2 insertions(+), 31 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 60397a1beda3..e305737edf84 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3671,19 +3671,6 @@ void kvm_mmu_free_guest_mode_roots(struct kvm *kvm, struct kvm_mmu *mmu)
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
> @@ -3821,9 +3808,6 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
>  	root_pgd = kvm_mmu_get_guest_pgd(vcpu, mmu);
>  	root_gfn = root_pgd >> PAGE_SHIFT;
>  
> -	if (mmu_check_root(vcpu, root_gfn))
> -		return 1;
> -
Hi Sean,
The checking of existence of memslot is still useful,
Otherwise NULL pointer dereference would be met as in below call trace.

mmu_alloc_shadow_roots
 |->mmu_alloc_root
    |->mmu_alloc_root(root_gfn)
       |->kvm_mmu_get_shadow_page
          |->__kvm_mmu_get_shadow_page
             |->kvm_mmu_alloc_shadow_page
                |->account_shadowed
                   |->slot = __gfn_to_memslot(slots, gfn);                    ==>NULL pointer
                   |  kvm_slot_page_track_add_page(kvm, slot, gfn,KVM_PAGE_TRACK_WRITE);
                      |->update_gfn_track(slot, gfn, mode, 1);
                         |->index = gfn_to_index(gfn, slot->base_gfn, PG_LEVEL_4K);  ==>NULL pointer dereference


Thanks
Yan

>  	/*
>  	 * On SVM, reading PDPTRs might access guest memory, which might fault
>  	 * and thus might sleep.  Grab the PDPTRs before acquiring mmu_lock.
> @@ -3833,9 +3817,6 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
>  			pdptrs[i] = mmu->get_pdptr(vcpu, i);
>  			if (!(pdptrs[i] & PT_PRESENT_MASK))
>  				continue;
> -
> -			if (mmu_check_root(vcpu, pdptrs[i] >> PAGE_SHIFT))
> -				return 1;
>  		}
>  	}
>  
 
