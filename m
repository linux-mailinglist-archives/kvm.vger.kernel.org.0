Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F35D35F96C7
	for <lists+kvm@lfdr.de>; Mon, 10 Oct 2022 04:26:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230384AbiJJC0t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 9 Oct 2022 22:26:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230202AbiJJC0r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 9 Oct 2022 22:26:47 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C232324958;
        Sun,  9 Oct 2022 19:26:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665368806; x=1696904806;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=xMamYI7K1sPNjeEsHdeGwtymFMKQAPyf1p39OLyUZCw=;
  b=JTLJtyqB1vYiUuiFJsC26sxhNOFDGuv5E36ocaCVmMqu14PajfYGMD/e
   +bx2LaCm71iDNcKL68NLoBeDlRaHpBVEkgUbizwO/y1jVdPlYgYiSgLsW
   1fDc6sixzXAI09dH5AvgmFFyd0GC8IipCm/Pd4GaPT7gD8b/CwNPNNXpb
   GlIiA0F1JZzEWatl7Q7W72B2sQCGZv0C6Np3q5UowfijAzJSG4byLex3q
   ka1yV5N8ac6oQBWKuIKa2klAWlVSMglVDUJpvBUCRmyCb78jT6g1TaHmr
   e10G4c/ZBd8YHFnjyKAgAIZOd10lJGCG9FqxJ97Im5O1AYgSdzzNRbZCo
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10495"; a="330586565"
X-IronPort-AV: E=Sophos;i="5.95,172,1661842800"; 
   d="scan'208";a="330586565"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2022 19:26:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10495"; a="694468083"
X-IronPort-AV: E=Sophos;i="5.95,172,1661842800"; 
   d="scan'208";a="694468083"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga004.fm.intel.com with ESMTP; 09 Oct 2022 19:26:44 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 9 Oct 2022 19:26:44 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 9 Oct 2022 19:26:43 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Sun, 9 Oct 2022 19:26:43 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Sun, 9 Oct 2022 19:26:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XpeovqnxKKjXDh1dG1gELTKla81YVx48EhwYrOSNCIrWxBRnxFyU5G2keZFs/xg4TAP0fsMsqW+06gq74UEIOhufVNEJIII8VVxw5mnsAOJYJlXCxmYFwtfO9JOlZieXiZ19+LnjSOp2Nu9jDxGT39G222FtBYdCfxCQOFctBmZcss4zMsLBXDoHF5bISLTu0GWgFJ2+RJAOlJvJRolqaDAVD+mhgjzWzbSuZ490colLPszAkKMW+mEXsNztSr1UgC1CS6dbJBOUJ+PgD9INwnqC1rh18zqxTFtlAZmHrCY1Rj1c3qYRCTBrNRIY6lUaw/6mz74iX4sqRAmroTBKKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OtbzrOMwIqGEKejIR2b1URVBKC9yeq5xXJwl766gFf0=;
 b=UkkQz7a5KmhIwC1IoGqMdLGtSmUCyDcyZwKofg9UIAdwa6GWtadCA1T+U6wQMu7pcHeZKHIPPWQhxlSdB0kLDVAWGbo9a0VqMJkNh3MxqFHW3qRqUGdENJYUKKy5L7/0yEtbI1nEP75RRuIN8GsMdRKICDZrTUrIcq6CDNFTJVPQU88bVzLTYmivq3cKavamtszb0I5SwHyeOj+By8OgzFH63JCLF39OkIWwG5YR6OUi9BCZnpyXyH+xckAJO+Dy/E90dlEDa0YQZPLLYEZKj6X5w41yezfKBzHRQrpzSKFUuDnFYYocSQmh5IlMkkNOQQDQkhAay0+ghh6fR/0i4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH7PR11MB6427.namprd11.prod.outlook.com (2603:10b6:510:1f5::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.26; Mon, 10 Oct
 2022 02:26:41 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e1be:376b:2662:16ad]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e1be:376b:2662:16ad%3]) with mapi id 15.20.5676.032; Mon, 10 Oct 2022
 02:26:41 +0000
Date:   Mon, 10 Oct 2022 10:05:29 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Mingwei Zhang <mizhang@google.com>,
        "David Matlack" <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v5 2/7] KVM: x86/mmu: Rename NX huge pages
 fields/functions for consistency
Message-ID: <Y0N96VIqxm76F3xl@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20220930234854.1739690-1-seanjc@google.com>
 <20220930234854.1739690-3-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220930234854.1739690-3-seanjc@google.com>
X-ClientProxiedBy: SG2PR03CA0096.apcprd03.prod.outlook.com
 (2603:1096:4:7c::24) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH7PR11MB6427:EE_
X-MS-Office365-Filtering-Correlation-Id: e970b75e-188e-446d-c9ba-08daaa66dda4
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nSwOe2lloN3EqXuzRS15psmx0MQKGpTszLq2Vby58IIuc9pdcQfbn3x88xKTmy3cYueLlrsQ/DLnlsopx5MdMJ66JeyyAYa5D4hX7DnH6CcyOL8m0T6+w10hPzvxpgaGRTrcr72VUtwvKqEHLme8pPM6luq3jmXsu1RsznyumKhaOM+Jk/54whQBCJPuKaJrqHtPLKLLA5AtclkF6xmwLIBLPXs856kFYRTuzj+aHkyvHNafLxyJJQ7lsSdVLLZg9VHNbCBjtLdcSD0FexmujNHv0rDsQjztP4tZ7vvxUZiw9aRgzAXUnGk4hFWcPAr6JIN4OwLFmyOLlWvLrFJDbQnR1g+I2A4I0P72euNCjQ8O0p1yepVkHM3/Ki3VWf7cdagdE4o8xSjQsSJzknCwUYvn9TUsS3F/FzH6AgLaJXAGcovSr7lLuxHKPChyYOpfimbC3OK/XASBI/kkEnZF/6aV+Ji2CFHVCBRrOtTpB2kJ2mLO01cmciVwjl+R4y0+xxTdOENTSg9OdS9IhNb0dYCzQMyRAddNnISLN7x4sNh1IaNmpskx4fIhDx1DhXQARwwyrgfN1B44hCo9L0mlSUzZE/UYZeb7h6blkFtmLhcE3MRLgFl852GwFc1DrnKts2CDHrKMFIL5LJ8U3CnYQN8ot2Ev0JU5Hxkr7ZXfjMJOTdBqJozEkoh5PCMSEXZ2j2e5/ErbqynHccY3ilGFI81kdHcQLiikhSe+TaAocORLYAgJqOGm2TJbBiZ1WmRK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(366004)(39860400002)(376002)(136003)(396003)(451199015)(66476007)(6512007)(186003)(26005)(83380400001)(6506007)(6666004)(66946007)(38100700002)(54906003)(6916009)(41300700001)(86362001)(82960400001)(2906002)(478600001)(4326008)(8676002)(316002)(6486002)(66556008)(5660300002)(8936002)(3450700001)(14583001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lOqzwBBRECEORhMZm8SnGPEQuxmprII9bgpKiKqjvgWDumeniYMYCZL3rPCg?=
 =?us-ascii?Q?UTPru7CtVw/vnat8UvXFGBUkoMUnObmSQbooHNDT9r2WVoPA+7W8h5D7Ihig?=
 =?us-ascii?Q?aLErrK7NY73VjyTbPzse/+0YZEKfKVx7TRf06YyheFEm515BdNxuv025Rl6R?=
 =?us-ascii?Q?XDEWDuqkv7B0AGLcLG8MqyJzmUbmfwJM3kmwlRPIY0rAS4wY47XUxA1ssmPY?=
 =?us-ascii?Q?CUyrfLd4Z/+C74utT2UYior44pEQASxx1s3qPkKLNH15evNGRe8Zk28rMi+J?=
 =?us-ascii?Q?cGZTSGvTEFxoyI7tjQwxMAz/QbVMbPpleQubISqMtrSwGwLMWOLSq2mzQC7d?=
 =?us-ascii?Q?bJ9fXgLKNv740dwXto3psfOHKDlJ7el8zqicQSGxuAWuZ6CtLFTqhFuk9jnF?=
 =?us-ascii?Q?4QbgilfJQH4x9EqLVCir1vKSWUmCmIoMFXRtz2i3rHXdVxQm3MdRO6I8vQ0j?=
 =?us-ascii?Q?6Y9QO31Y7bES+3qKUE9IS56s2D4Q1nPBtP3I8HRwgpV9OOgpDjv1TXL1vog5?=
 =?us-ascii?Q?ulPIdG1Frd0i2H6AtfSUeCq0a9+4xb4BYj/YunXs0ZEGfcCdcKbdzzJel1DA?=
 =?us-ascii?Q?aus9t1KyqjXovYJGrsoZNvcp0W2Cdn38hALQjKusfvTdImJ0G7DGS8r8a6FT?=
 =?us-ascii?Q?ZiKLHLJFcwldNK8skTzZw8KVTI4oTBAiw6w02bmKHp9WtSaIjN7y0ichzfu5?=
 =?us-ascii?Q?qsmlb4bHoXtsXpqE/YoJHIWkOjT4OWKJgMm2DdIoAPxC+m4N05McRhmDU4k/?=
 =?us-ascii?Q?h887N9moYnPSTHiEXPOatqkCGwUcAt2627gLVW67v6dMu1aLsZu6STWTCiJb?=
 =?us-ascii?Q?cgBPXEvdIY4VBRal/m02zPTP8w3BgkZc+8LvcYTwXqXQJFOf+phL8zjkfR4h?=
 =?us-ascii?Q?N+uY6pI0mER07hyGLBu5FPx2Et07R+YEhpJgyZgs3NFKEHoK7IgY+GPx41lv?=
 =?us-ascii?Q?jJGHwAMPV5ra0hpTm/vUmhqhlH0PkWI8lvPa9fQIQHegOJKFsADEI0wiLbek?=
 =?us-ascii?Q?XaCzVPpIq5WZvmug2HbhNlhnjx4NP3KjkMK4gdY+84+hh3ocVsk+6LTju6ID?=
 =?us-ascii?Q?5BgC03SdKdny5nRcx6S05NvNUo/IKO4hIKrVXgCdjHPMcGphnCftm4vhwzGA?=
 =?us-ascii?Q?RHBduI3nAQ1yhBZYuhWCgL0SKCyHEZ3E/nv0bt/g5L6vawMM6eRoQFJLgLCi?=
 =?us-ascii?Q?os//0Q85UbZwvvSsq2yTFLnHgRdlcLhPVR0xmWWIj/PHPUhWSLIZ1jjN6/Hk?=
 =?us-ascii?Q?miyYyPvEWVPwOgVNOekFNpnAMsRjMz5XeRzWxlvA0JI8scvBh8NlKYNzcUym?=
 =?us-ascii?Q?91HOr5enxpd7iJJv3NBjcsUQhoZ28EZs9k/Y3mGs9YdwHSI4kwnCsM7fqxxl?=
 =?us-ascii?Q?LxMZLAdScj5T4X5TRrB3lfYalOsGT5pBy/J5efSuWb4pDKR3yLMRKaPJR4FS?=
 =?us-ascii?Q?SsyXXbDxMyMBJd/3F0HA3wyN+MkmxfvoFn7lFSL4P8JKiYbsLo50YSGlSeVD?=
 =?us-ascii?Q?75VjPSW2hrp9c76KVD1VwXQCkH/r0Q6Gq3oXgCF9Vyk7yRsGbyCtBFT2Q74n?=
 =?us-ascii?Q?2a5nsoAivU+x6GXBbQ9tJwIA6mlLooMqZ/4XHXZm?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e970b75e-188e-446d-c9ba-08daaa66dda4
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2022 02:26:40.9859
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K6VxuWljdOWth8+VkvGUDs8JB+xX/rusrsRuGp7ZcQsiYu2ftQ4Gp6wudMVX8BhFPlbZq44sFrZeVlfpNLEnWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6427
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 30, 2022 at 11:48:49PM +0000, Sean Christopherson wrote:
<...>
> -static void kvm_recover_nx_lpages(struct kvm *kvm)
> +static void kvm_recover_nx_huge_pages(struct kvm *kvm)
>  {
>  	unsigned long nx_lpage_splits = kvm->stat.nx_lpage_splits;
>  	int rcu_idx;
> @@ -6833,23 +6834,25 @@ static void kvm_recover_nx_lpages(struct kvm *kvm)
>  	ratio = READ_ONCE(nx_huge_pages_recovery_ratio);
>  	to_zap = ratio ? DIV_ROUND_UP(nx_lpage_splits, ratio) : 0;
>  	for ( ; to_zap; --to_zap) {
> -		if (list_empty(&kvm->arch.lpage_disallowed_mmu_pages))
> +		if (list_empty(&kvm->arch.possible_nx_huge_pages))
>  			break;
>  
>  		/*
>  		 * We use a separate list instead of just using active_mmu_pages
> -		 * because the number of lpage_disallowed pages is expected to
> -		 * be relatively small compared to the total.
> +		 * because the number of shadow pages that be replaced with an
> +		 * NX huge page is expected to be relatively small compared to
> +		 * the total number of shadow pages.  And because the TDP MMU
> +		 * doesn't use active_mmu_pages.
>  		 */
> -		sp = list_first_entry(&kvm->arch.lpage_disallowed_mmu_pages,
> +		sp = list_first_entry(&kvm->arch.possible_nx_huge_pages,
>  				      struct kvm_mmu_page,
> -				      lpage_disallowed_link);
> -		WARN_ON_ONCE(!sp->lpage_disallowed);
> +				      possible_nx_huge_page_link);
> +		WARN_ON_ONCE(!sp->nx_huge_page_disallowed);
>  		if (is_tdp_mmu_page(sp)) {
>  			flush |= kvm_tdp_mmu_zap_sp(kvm, sp);
>  		} else {
>  			kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list);
> -			WARN_ON_ONCE(sp->lpage_disallowed);
> +			WARN_ON_ONCE(sp->nx_huge_page_disallowed);
Can this WARN_ON_ONCE(sp->nx_huge_page_disallowed) also be applied to
tdp mmu case as it holds write lock now?

Thanks
Yan
>  		}
>  
>  		if (need_resched() || rwlock_needbreak(&kvm->mmu_lock)) {
> @@ -6870,7 +6873,7 @@ static void kvm_recover_nx_lpages(struct kvm *kvm)
>  	srcu_read_unlock(&kvm->srcu, rcu_idx);
>  }
>
