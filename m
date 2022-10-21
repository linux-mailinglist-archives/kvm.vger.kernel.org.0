Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7F98606FC8
	for <lists+kvm@lfdr.de>; Fri, 21 Oct 2022 08:03:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbiJUGDv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Oct 2022 02:03:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229746AbiJUGDs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Oct 2022 02:03:48 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48E664520B;
        Thu, 20 Oct 2022 23:03:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666332228; x=1697868228;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=ai0NFzjZ1K+uOrW/6IlWC7V39roerarE9pJtfQQ26Hs=;
  b=oEXPSMVZKz5zxVdiTaWl4I0ZT2gE5C5BhnOYtWY2cV/EvTO2MudqjN3J
   rhVcRBRI/aCXzqgP/XpSAYJeCqYSa781Q5IlsrJw4EKnx/8t5c/YujuqF
   PZOIyd68LAYklGts3zNKG5gQal3CnVJ+G7rxBqo1aCh4n3RmkzacYyh6x
   5ApWYSaxPpHBrQMifo8KBR93AMM2vZxU/DMB6MAss+g8YLckuTD0TWUXD
   h5D739sJURevkzXCS4svvaJ63d7SUskBfQoVmYyhmbNaeWywKzJ/Q3rEA
   FgR/rGnvDifLUQ8v8UurqaG5IOe9Qy8p/w3DKrv7m8TBmkR3KZ7KAtbUL
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10506"; a="306911748"
X-IronPort-AV: E=Sophos;i="5.95,200,1661842800"; 
   d="scan'208";a="306911748"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2022 23:03:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10506"; a="630302080"
X-IronPort-AV: E=Sophos;i="5.95,200,1661842800"; 
   d="scan'208";a="630302080"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga002.jf.intel.com with ESMTP; 20 Oct 2022 23:03:47 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 20 Oct 2022 23:03:47 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 20 Oct 2022 23:03:46 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 20 Oct 2022 23:03:46 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 20 Oct 2022 23:03:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M1Xkuadj6TqJTs1mKEDMq1tovCnwCUUdZDmQjgXia2MR00dUUFcMTbxqrhZkA9semkzq08wYZGEanSzfHCiBbiQ21wM30ONDOfuIzLL2z+qRxdxsBWEOB3AyuTn54pi7VvvRhmBxc5OQdZMEM97NiOjT9lElGoAgsmaZ6+knEHkTa+/3EuX2FMwZjwyAObZhwjzb45wrIluoMTvPmsJZ8wpP7H6rnKRg2gv457w2fh5mnUez3h7kG5zvWQWdm/5gLwVG5lPJaqhZa7hhV8UuovGKIBcEbpLgfe/PzoNL7NrGl/RsetRknSH+ijh0zYryhHyiPZFXmSOWMAZ8x4O4+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tMvR/nEV3ensVZBdL0VX+sbDA2mWlAlOMpyH9hZOOao=;
 b=nZbp84Ah3gAtilEkCvfPJnrMXmkaPejRegwa8iIMuqh+ab1GmJMmAJPWRtoXKjp3mINxFwrAEpwYs5JCd13jU+0spb350KEplrCU9Wy7Wwqx7ah5VZj2Zhyy/OcBwAr35kOxWw1lrTIbOpuJFuu+U9pNtweeUK2+7EiY3TsGaga89VwG5X0pQAB23H1rF+J0JUZvaCmsw/xfR/EWjJy3nWyEFSVh2pqTOF2Jr47asA/xlqtFD48TE2mEAbK6iKfUHVtgAVPuB9pGWFNxzxJefCcLmWQZkpCyhhWBpl76Q3B4zLDxaPY97VGHOcl6paNloBZifza7Q4gZqr66GdCYhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 MW4PR11MB7054.namprd11.prod.outlook.com (2603:10b6:303:219::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.32; Fri, 21 Oct
 2022 06:03:42 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e1be:376b:2662:16ad]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e1be:376b:2662:16ad%3]) with mapi id 15.20.5723.033; Fri, 21 Oct 2022
 06:03:42 +0000
Date:   Fri, 21 Oct 2022 13:41:01 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Mingwei Zhang <mizhang@google.com>,
        "David Matlack" <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v6 8/8] KVM: x86/mmu: WARN if TDP MMU SP disallows
 hugepage after being zapped
Message-ID: <Y1Iw7bwz9gwc2116@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20221019165618.927057-1-seanjc@google.com>
 <20221019165618.927057-9-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20221019165618.927057-9-seanjc@google.com>
X-ClientProxiedBy: SG2PR03CA0132.apcprd03.prod.outlook.com
 (2603:1096:4:91::36) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|MW4PR11MB7054:EE_
X-MS-Office365-Filtering-Correlation-Id: f891a2a3-0570-454a-087b-08dab32a015e
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aUZmbbTismnB2br5QOuTLhXoUo16zk2wJiCAIR/phL3IQ0yoI+8cQY8jLlqr6BeRCCUM+ohMlw/sqdU155qhvXomtgpBkf7hz9v/XhdVPHjzced+LndQb9Z9yLUr78Ize5uxRskeOi2KJJkcMAwzsmi4d76tRgNCHdk5yAX8gmMjQiujL0fl6GyxLd9MAUWrzclqoWC0GUYnqSOYewL/3pXGiomPkT+a0hj5JgwnewiZLrT2HhJiaVpDgWHTgCDSYTQuSLBZOORh92Ezx9WLlDf+D10ev4Rzi3P68hMYuksS6MOPvaRXvhRI3FcF03kSm/4fRwYftF8qA+cyNCZhVi4hH1rw43NomZj6nWiMFoYLGUaKodPc514gtbkA6H6E2A3CCZkBa1ovrMemNFdJlPd+d0ehw+JFyOxdKK1nnJVBmI2Srhw656EfR0cXBB0I2CUtaXOGeybmT7oj6kL0PWkMAXPy8lolxYVCb7nrhirbDyaIR3alAy7zr0X2gfh/tjUi3xKpb+49kAnfFgtv46zoUcC7mMQE5OJqeqvA/xAmJcYDC+3+pgWwlqZn5JwWthhmnV/r73TZezENQWZhp7ioJfiA9+XBYUEcr6v8JUBHx8vDx9s8EQGUAcS6M7zsDGPiEHTs/4zXotj/ca8JPvqg9B0BKfO0WbeXJo5hk8uIkYi1bDnrg5pfDDRQNbRAh8Dh4wDdRSMSO1ynegstgQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(366004)(39860400002)(136003)(396003)(376002)(451199015)(8936002)(2906002)(86362001)(82960400001)(5660300002)(66476007)(41300700001)(3450700001)(4326008)(38100700002)(66556008)(6506007)(66946007)(8676002)(316002)(6486002)(186003)(6916009)(54906003)(6666004)(26005)(83380400001)(6512007)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1jWWICiCDEBz0EcIjvgcim4T0XGh335860qE9AZ5oj6ne7yFr+dYqsEh9TgE?=
 =?us-ascii?Q?sUK/GainohY33Tb2gL+T85JywUNkDRiVqz6anaNY4eJll/eBHfj2NfUi9k63?=
 =?us-ascii?Q?WIVrz/7I7WnpJvsUXv2VrYbn9d2OcfyfGXPoqK4nnTcYMxqGrkqeCVa7QB3O?=
 =?us-ascii?Q?oMBX06zPm6PaA9k1FItxpRisqrhXfam1YiRFxEiSVc7ZIYzYNwD8vGn9i2Rw?=
 =?us-ascii?Q?MUu88njaf4AbIGfTu3sMbLw1YSlDfjwtyyq13yp3EUmTDOEy+VCLsswYS1oL?=
 =?us-ascii?Q?JL3o4BlO5ByzcOM27QBqklt2T343sKrh/I1299uIM+ARsm3jKyCpztiy5IrX?=
 =?us-ascii?Q?pTo9kPKSK7DI4Ab9Trlkci3Xv2xfSF94HPhyRESCApKf55UX5H6UUuBtLd1r?=
 =?us-ascii?Q?zFq49OPXSOdxDZbDcUMURP6xwdgK56oH71gYjVFnJiMoXB65odPXPheegPIz?=
 =?us-ascii?Q?C52OLPik+rNrN0wpliK8hMgfDj3BJHHaOE/7GfDwg+ios09VM4TTXW1HoGUf?=
 =?us-ascii?Q?Tios18DafPwi0Y5q60d8Jjxh+6NBh4myPOEEK2oAP+bz3sdEIF+TbwBFT1ty?=
 =?us-ascii?Q?EzsCV3uiqRzigf2Q7zs8cbItx9COCn/0bznoS+Gzb5RPWJfLZlv3EmYH5KFc?=
 =?us-ascii?Q?Iv7Z6/5l5Dm6Tdf0GBORyNAJb3YRkeTaWFHqOsX5nWiDOwzY5ODVgUNnN2fU?=
 =?us-ascii?Q?PE3CN+lei/IVhszQQjdsirpnVp27J/lv8d57OejaEW2C2eVbcKWYfsZlTKOK?=
 =?us-ascii?Q?KqV0BuOHonBWEJX6ufUZS5PDdD/UpaSST4d5VC4ZIM7PrVJvj1I3xcACYW1g?=
 =?us-ascii?Q?3iX+f4XPrmxtGs0xHuw8Pr5iKIn4IeqE7Dl2U3tXb/F6WMnfZUMv7Ji55Syk?=
 =?us-ascii?Q?EQ2GJwWZYeXxfylwaPLXzBBagXSsO55jB5DxkSbGS5k/42S5ppSJs/Vu6fRy?=
 =?us-ascii?Q?wvesVyrUKMoTzm0IBj2oglpc5E8IwjxUqjAlnzOlatujL9GEdw+3KFZg7Kko?=
 =?us-ascii?Q?d2Ifs1/9jjeiTAkMMfEQlGD5SVOpS/iXl7CROG1sWxCSZRCwHyr5OwXfPxb/?=
 =?us-ascii?Q?kTXy4WS7DGzmtq3lCpw9vnsweKitfupRiA+q2YlMEfm1iBzeR+7aVKsuO6/a?=
 =?us-ascii?Q?bTvH/xaoXPYvaQ0bVKGA5Bp5Stb6eYSA8ZpMeITn3+byHU5PSsj/Qj55DCyS?=
 =?us-ascii?Q?LcLpBK5g94n8unYbipdHdoq7oG1Oosr1A4P7KDXyJ6T2lD+v7zl3G1S4lsB1?=
 =?us-ascii?Q?Ga5YbuaHf6oZkaVJuHGP21hkXG2ljwGsgBBwU7aYi0cfCqWGzl3yoI4F7/rp?=
 =?us-ascii?Q?OHREchNxJ3izwFN9bHd4AIjbwQlZR7W6FU34ZS0qmk3M2lb9kLREc2jgMbLE?=
 =?us-ascii?Q?fHZ5/YCB2fHQlzpwlMp7afwPVRYx+bruj9Yskkuqhp64n+JhGPQO1ztPG3jO?=
 =?us-ascii?Q?0gNE/qzSa2zuqArM3BYV1CSV0fJ8LcxTnH48V0tJcvT7XPj5qYF2iupZ5VDc?=
 =?us-ascii?Q?kMA9HGJdnkpTywFcG3UnQiJwI5002voY9OFgUvbbikuaB2d+rGCtupb51hUT?=
 =?us-ascii?Q?KUWmTSJkvjfcdR/wG+WTqHHqFpYhx8zl0uoi419P?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f891a2a3-0570-454a-087b-08dab32a015e
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2022 06:03:42.0534
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SSjlnISd8p6DrUwSqnlxIvcOlBTHpZB2Y1v5Bwp9autsBoV+7njHahtxi9pOjizpwOAVWwA1M3lpTL9TFVCMZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB7054
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reviewed-by: Yan Zhao <yan.y.zhao@intel.com>

On Wed, Oct 19, 2022 at 04:56:18PM +0000, Sean Christopherson wrote:
> Extend the accounting sanity check in kvm_recover_nx_huge_pages() to the
> TDP MMU, i.e. verify that zapping a shadow page unaccounts the disallowed
> NX huge page regardless of the MMU type.  Recovery runs while holding
> mmu_lock for write and so it should be impossible to get false positives
> on the WARN.
> 
> Suggested-by: Yan Zhao <yan.y.zhao@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 14674c9e10f7..dfd1656232ad 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -6864,12 +6864,11 @@ static void kvm_recover_nx_huge_pages(struct kvm *kvm)
>  				      struct kvm_mmu_page,
>  				      possible_nx_huge_page_link);
>  		WARN_ON_ONCE(!sp->nx_huge_page_disallowed);
> -		if (is_tdp_mmu_page(sp)) {
> +		if (is_tdp_mmu_page(sp))
>  			flush |= kvm_tdp_mmu_zap_sp(kvm, sp);
> -		} else {
> +		else
>  			kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list);
> -			WARN_ON_ONCE(sp->nx_huge_page_disallowed);
> -		}
> +		WARN_ON_ONCE(sp->nx_huge_page_disallowed);
>  
>  		if (need_resched() || rwlock_needbreak(&kvm->mmu_lock)) {
>  			kvm_mmu_remote_flush_or_zap(kvm, &invalid_list, flush);
> -- 
> 2.38.0.413.g74048e4d9e-goog
> 
