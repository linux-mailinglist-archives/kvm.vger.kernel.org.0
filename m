Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F5ED65664E
	for <lists+kvm@lfdr.de>; Tue, 27 Dec 2022 02:00:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232489AbiL0A7w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Dec 2022 19:59:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231770AbiL0A7t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Dec 2022 19:59:49 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36FB525E9;
        Mon, 26 Dec 2022 16:59:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672102788; x=1703638788;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=d7/cJiEhtpQEBKmtxYwMJgN7vN+Wh9BBd4VpPUvynLU=;
  b=OQRe5N2GZxljQIvbixDUhejXQUEOdtmvHUZmI/Kzf4CqKMouCk+P0W1n
   Mmgtl1YTl1TmsQizP4HtEMOgKov7NgU/fVXiOnmgMlu8e7C4HopkgNqHo
   L8NHVkVCmdOsEgeND2TnAu8qY5i/VTgWAOXvGMACJWnY0dbrFciDYkwEp
   Jj9qDQZuo1SE6xFglDr85IWYJCO/n09Q07mvORVvyjdFPKFROvV9uiJmE
   F5A/tofSHytl/M4fEtEFygEedr1ZZpHKIhWOLbQrvEhADk/fi131Wh/Yf
   dammawgd1ANONw0j8zyB9nFZpTQ3Al9sLJuObAi3s112zkanX6Y0fNRX6
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10572"; a="300315261"
X-IronPort-AV: E=Sophos;i="5.96,277,1665471600"; 
   d="scan'208";a="300315261"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Dec 2022 16:59:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10572"; a="685282425"
X-IronPort-AV: E=Sophos;i="5.96,277,1665471600"; 
   d="scan'208";a="685282425"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga001.jf.intel.com with ESMTP; 26 Dec 2022 16:59:47 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 26 Dec 2022 16:59:46 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 26 Dec 2022 16:59:46 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 26 Dec 2022 16:59:46 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.42) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 26 Dec 2022 16:59:43 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UMRRkjcx808jfuZcJx+NELf7Vg24BuNzQbiDJ7BhuMOOmo71sPs8oKqnHaya5ygHVY5wZzFs0wlm/NQ7zvHxVTlEoB20vVsM9wtFAvFXmuV5yMyHoLLS3gDq6NbxytsOscZlQDNmQt6tXQvdsOAoavRA6lmLFsJX4kjmUCj8C1qq49cQyHcFJIkc8gzXSkAyxeJOB0nuumyQwcOTPAmkRVGwhBGgQYeZHj8Y2ca3c/6kS9EyJqyA0jUCm7vW294Oipsvy0dhqLoOwGdTKKwpMmy8NV6Q9U0D7KBYWgnoh9FuBRqG/Skbq2+PdkudHd05qBYDIiyxoqsz+YIb/wPqcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=64RKgfpGabj7ZKUkY4f27dyHXMBVKVypzDoIfu7fgjs=;
 b=WfNvWc79VmrnOV8vcMbJB/FhXnqMozgAVpRhOTqtcyonUke9tXNuwOzxId9iIefbOZapB6Z9H/UDBNpt7/bHed7X2bEDkd6DAmB4egIXPLAKtMqEHXt0Sroe6+qhFxVZslyycarTE+YTSUeWCoa5KoRU+7+qvJrkz2wMJ+5oncG6Sedig2p4NUgrZmypq85QWz9j1j49uJ4kPaurTHbsDjgMxX0e6kRX3GNa5S8RLtyXP8L46Be67ljbpsF79AVpFTfXO9P5ioyicw8oBJ1GfBF3c9dk9gDRqZhob1e3+7OybKd4QnNEQoIjMeuzajkeWVrT3tPNTgp0qiTFsrK+8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by CY5PR11MB6259.namprd11.prod.outlook.com (2603:10b6:930:24::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.13; Tue, 27 Dec
 2022 00:59:24 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ae1a:fa3e:e36e:c2fe]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ae1a:fa3e:e36e:c2fe%3]) with mapi id 15.20.5944.016; Tue, 27 Dec 2022
 00:59:24 +0000
Message-ID: <752cacbf-5268-6ea0-8c5d-36fb297789ee@intel.com>
Date:   Tue, 27 Dec 2022 08:59:13 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH 1/3] KVM: x86: Omit PMU MSRs from KVM_GET_MSR_INDEX_LIST
 if !enable_pmu
To:     Like Xu <like.xu.linux@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>
CC:     "Christopherson,, Sean" <seanjc@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Aaron Lewis <aaronlewis@google.com>
References: <20221226111710.51831-1-likexu@tencent.com>
 <20221226111710.51831-2-likexu@tencent.com>
Content-Language: en-US
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <20221226111710.51831-2-likexu@tencent.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR02CA0029.apcprd02.prod.outlook.com
 (2603:1096:4:195::6) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|CY5PR11MB6259:EE_
X-MS-Office365-Filtering-Correlation-Id: a59c4c38-6d31-4428-8932-08dae7a59852
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WFH65rvTp5uW2cEtGxkF1dAVz8S8S7s5hFVtCJsfqPr7sugPs1Mn4pTFt1RN8XLPhUcLW5T+5rT87oAz2N2ZuHwuibsjp6kKYxfCeS1oAmgaJ4GrL3K9yoXyk46gkgwU3m2gA4DsUm+DvGi2r6tnEU7tgUNITX+Y0c5MbOABPKpMFKkLCxFE1sKxzpveidFMKNQdHQmBWROBmPoUpE+jtlcz5XCTEmWCewY20xMA+GKchsHRz8sX50gBC/6SJLylssD6NOvDqfdUjn7cHhIyZSQIkZyWgNeVTKQy24XOtPFN1Uq02xnPqHE6W3wD/rC9cPMxjcB1Vz+6ygzl81ExSazNw5uAPkLfn+qx3fiK0ZHgdOLCPGNpK6um7JaHKwE8JIPHImMDwVll4sL21tu7VDVvzu3LcL1NBxMItXhzmjqnWT4vV9clsFRqsiyzq4R4DSm+xG9MokH3Kaddp+ELzPpZCMeuFiudz7zry+VqTSUsTdWJPLHUMHHxRvIYVB/8kUYc9sfDUMiHbQUArCqK17BB4gsAO8uzWSOdHe6IId3NwIsxRMvV1w3P3uPbKfZ27gSmM9CK23i6EVhej5C0HfYDMYuuWPq3v6cqoYte+uUvSd6G0y0snGRV7vZkZvptXMtmC9pdwxPB/B9PpR8zRde473H2NTLbeRwiic9IB/2ofpKGjJ0ai9DlvsV3b47U02tik7Sy4Dp2WhPFzbnkRw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(136003)(39860400002)(376002)(396003)(366004)(451199015)(2906002)(110136005)(316002)(478600001)(6486002)(83380400001)(36756003)(54906003)(53546011)(6506007)(86362001)(31696002)(6666004)(2616005)(186003)(6512007)(26005)(82960400001)(38100700002)(8936002)(31686004)(41300700001)(66476007)(5660300002)(66946007)(66556008)(8676002)(4326008)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WXhkblBpcWlCQnlteWFLQlY3S1R0VHZYM2R0V0Y3KzNqVWFTb1RCZHRaU1lQ?=
 =?utf-8?B?U1prbDVRMjk4SWZ4QzQzNWJVZ3l1VTg5cUN4OThJRVNkenB3K240TlZhUU5L?=
 =?utf-8?B?bmZDQ3ZpZzc0aFhPcU9NOHhJRHFqNWpZTFJLVXlOZDlWRVNPcXVOSkpTZk1B?=
 =?utf-8?B?b0JXb2RSK2ZEbmJCZEh2QklZT1RVZVA5eTAyTEtZL21UTDR0ZUw2YytPRys1?=
 =?utf-8?B?T3NxWWNSWXRYK0YwVlhqQ1hyWVhGYWUzeFNHSmRDOFJySU9lYzQzU3lnOVBr?=
 =?utf-8?B?QTAxZXYrdUlzUGZCSVBxUEtVZ3YycEs3eWhOejdvL0ZJaytjU0srSTlSQ3Fk?=
 =?utf-8?B?bzJBa09DQnBkNGpLR1ZlSVZ0WE5xYk44cEdUQy9zeUZEcFljR1BmaHVQeC9x?=
 =?utf-8?B?cUJSb1FzcEU1T2pBaDBybUxsa1Bhb0JwRzdlSW1zRnlaM25ncmxGdmpwK1Rp?=
 =?utf-8?B?SENwcjhKeWRYcHF6SndJcHdpZ1E4R1E3UDhnTzdnUGlSYjk2YW1yanIxcENU?=
 =?utf-8?B?L1FVYWR3aDgxZkk2bGJmM25xMWtlVWg5Uk5aYmMrSEo5a2FxTzNpcVBYeWlD?=
 =?utf-8?B?eHdTRzloT1NKbUZHbHp1OGdEcHdHbEl6aSs3M3VjUUlwOHpZS08yMDQwV1JG?=
 =?utf-8?B?ZXBuRkJFVnJITDY5UC82QU9LNVJQbWxKakdIdkVaOWpEbEdMYXN6ZHdMODhQ?=
 =?utf-8?B?RFlEV1ZlTURUREZBeDNXYlpsT0N4NWR6MHZQbm5vZFJnL292cXg4NENJMXpp?=
 =?utf-8?B?KzFBZnJMOCtiNUNLbXJHTncrZFJCazJZbjh1OWZlTm9IL00ySHdOYW9qQzNZ?=
 =?utf-8?B?V3kzSzF0Ri9pblVXcGxKZ2NQN2hkbDR3bmJHYms5dGJYQW4ydm9BbFFDSk9w?=
 =?utf-8?B?ZHg3NXVsbXRZUG9ub2lrOU13N3R1Q3BveXRQTCs5YlpFNTI3Rlh2VGRucGFp?=
 =?utf-8?B?MCtyRFFINlIwUU9hU0MyMXBLT1ViZGNLL3FnUWtpWTR1WW5mdjNZaVNSdHVh?=
 =?utf-8?B?RVNwem1uWUQ3clU5dTlIMW45aXBsak05b1MrTW9JUEhKOTQ4Y0w3ZmFBS2hm?=
 =?utf-8?B?eDlOZXp3bjZVaWVPbitXbjB1aHc5NElNcWY0S0dYY0xBZ3dlbmNBVFVCbEsx?=
 =?utf-8?B?WG80RkhYYXA3eWxqcFJkS0szc0o1bWJINnNod09KdXg0YTQ2MlFSa1V5NjF5?=
 =?utf-8?B?RmxjSUZ6YVAyYitaaFRzZno4eG13M2pPYlYyaFNmWkF4NDRFYTJPY09JNEZR?=
 =?utf-8?B?UDU4cVJOamF2QU1FalJaQXZoY3dBQmkxVFZnWS9LeEZ5RjZ6VCtLTWhqelh6?=
 =?utf-8?B?YWkxQXpCMzZSTzAxbDhabWJWUDdjRFpsTlQ0RlJ6OHRVZ2dXVTlwQ253cUFz?=
 =?utf-8?B?aGxxN2dJM0doWlFucGpiRGtPSDdQbngzUlBJaU9JUzZtQUY5dG5TN0NHUGdJ?=
 =?utf-8?B?ejkxRXd0L29EZzdkUkloVnBKTHdYL1NqbnFmcGt4bU1UVDBzUjB4V2dFeTl4?=
 =?utf-8?B?NTd2aW4wZmRXd3RPUFd5OGNMNFc1N3A4MDk3dHFSU3gwNkFEY2F5SUVRYU52?=
 =?utf-8?B?ZDNueTlmTUFPd2NXRTVMMFBUZ200R3dJOGh3TDF0Yi9jSUJtbnhnVThjOGlN?=
 =?utf-8?B?YUMyREtpd0FoK1drYjltdXk1THBkbTlmZDE3dkE0L21IeWNCdDUzK29lUVRU?=
 =?utf-8?B?OFBNaWY3SkJZUlZrUjUwS3hITFRDK01BbE5PQW8zQjIwZnBoWCtGbG5IWVhi?=
 =?utf-8?B?TDdEWXRDalBvOVY1Ly9Vb2ZsVmd0bkYzYkxTWUZabEpQdzcyYmh0ZEVHaEVn?=
 =?utf-8?B?WHJZbHVDb2VNcWVOQ2pnOWhaOTJwSm9MeHcyRDlIdTFhZkJHZ3Zmb3pjaXQ2?=
 =?utf-8?B?aVA4UTdXb2s1V1J3MVliR2ZQcXBIc29Fd1pSZWlYbkg0MWNSU2c2dDVXTmZ0?=
 =?utf-8?B?ZnlXY2xnbTJXZkI1bGtKN1NUTEYxS3BmQ2tNQ0VCU3RRRm02ZXFIY0h5eEtn?=
 =?utf-8?B?d0VpOTZoQk1SVGlqK1NKRjU1Y0dHRXRVQzREcXBON1pOcUJaUXpUMXJOVXNv?=
 =?utf-8?B?ckRzV0pDNVJxMEErYUoxVnJya3ovK3ZKNWhSMWJjdmZLN2I1cGQxYmxENWd5?=
 =?utf-8?B?TGVGVTlYWTZmK0JLOWhaUWVONFhxNmJUVm9kcmdSdzRKcmYyWTRtTUZNOTc5?=
 =?utf-8?B?NEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a59c4c38-6d31-4428-8932-08dae7a59852
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Dec 2022 00:59:24.0012
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 736aa5aLFLTxc9olhKkh5weq+9SG3ifajEq22oY7liFCSBdwD3LwaTL62Ek2XxDLoTPRSvtXTkwy/a1vmvk7yg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6259
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 12/26/2022 7:17 PM, Like Xu wrote:
> From: Like Xu <likexu@tencent.com>
>
> When the PMU is disabled, don't bother sharing the PMU MSRs with
> userspace through KVM_GET_MSR_INDEX_LIST.  Instead, filter them out
> so userspace doesn't have to keep track of them.
>
> Note that 'enable_pmu' is read-only, so userspace has no control over
> whether the PMU MSRs are included in the list or not.
>
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Co-developed-by: Aaron Lewis <aaronlewis@google.com>
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> Signed-off-by: Like Xu <likexu@tencent.com>
> ---
>   arch/x86/include/asm/kvm_host.h |  1 +
>   arch/x86/kvm/x86.c              | 22 ++++++++++++++++++++--
>   2 files changed, 21 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index f35f1ff4427b..2ed710b393eb 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -514,6 +514,7 @@ struct kvm_pmc {
>   #define MSR_ARCH_PERFMON_PERFCTR_MAX	(MSR_ARCH_PERFMON_PERFCTR0 + KVM_INTEL_PMC_MAX_GENERIC - 1)
>   #define MSR_ARCH_PERFMON_EVENTSEL_MAX	(MSR_ARCH_PERFMON_EVENTSEL0 + KVM_INTEL_PMC_MAX_GENERIC - 1)
>   #define KVM_PMC_MAX_FIXED	3
> +#define MSR_ARCH_PERFMON_FIXED_CTR_MAX	(MSR_ARCH_PERFMON_FIXED_CTR0 + KVM_PMC_MAX_FIXED - 1)
>   #define KVM_AMD_PMC_MAX_GENERIC	6
>   struct kvm_pmu {
>   	unsigned nr_arch_gp_counters;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 5c3ce39cdccb..f570367463c8 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -7054,15 +7054,32 @@ static void kvm_init_msr_list(void)
>   				continue;
>   			break;
>   		case MSR_ARCH_PERFMON_PERFCTR0 ... MSR_ARCH_PERFMON_PERFCTR_MAX:
> -			if (msrs_to_save_all[i] - MSR_ARCH_PERFMON_PERFCTR0 >=
> +			if (!enable_pmu || msrs_to_save_all[i] - MSR_ARCH_PERFMON_PERFCTR0 >=
>   			    min(KVM_INTEL_PMC_MAX_GENERIC, kvm_pmu_cap.num_counters_gp))
>   				continue;
>   			break;
>   		case MSR_ARCH_PERFMON_EVENTSEL0 ... MSR_ARCH_PERFMON_EVENTSEL_MAX:
> -			if (msrs_to_save_all[i] - MSR_ARCH_PERFMON_EVENTSEL0 >=
> +			if (!enable_pmu || msrs_to_save_all[i] - MSR_ARCH_PERFMON_EVENTSEL0 >=
>   			    min(KVM_INTEL_PMC_MAX_GENERIC, kvm_pmu_cap.num_counters_gp))
>   				continue;
>   			break;
> +		case MSR_ARCH_PERFMON_FIXED_CTR0 ... MSR_ARCH_PERFMON_FIXED_CTR_MAX:
> +			if (!enable_pmu || msrs_to_save_all[i] - MSR_ARCH_PERFMON_FIXED_CTR0 >=
> +			    min(KVM_PMC_MAX_FIXED, kvm_pmu_cap.num_counters_fixed))
> +				continue;
> +			break;
> +		case MSR_F15H_PERF_CTL0 ... MSR_F15H_PERF_CTR5:
> +		case MSR_K7_EVNTSEL0 ... MSR_K7_PERFCTR3:
> +		case MSR_CORE_PERF_FIXED_CTR_CTRL:
> +		case MSR_CORE_PERF_GLOBAL_STATUS:
> +		case MSR_CORE_PERF_GLOBAL_CTRL:
> +		case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
> +		case MSR_IA32_DS_AREA:
> +		case MSR_IA32_PEBS_ENABLE:
> +		case MSR_PEBS_DATA_CFG:
> +			if (!enable_pmu)
> +				continue;
> +			break;


I prefer use a helper to wrap the hunk of PMU msr checks and move the 
helper to

the "default" branch of switch, it makes the code looks nicer:

default:

if(!enable_pmu && !kvm_pmu_valid_msrlist(msr))

         continue;


>   		case MSR_IA32_XFD:
>   		case MSR_IA32_XFD_ERR:
>   			if (!kvm_cpu_cap_has(X86_FEATURE_XFD))
> @@ -13468,3 +13485,4 @@ static void __exit kvm_x86_exit(void)
>   	 */
>   }
>   module_exit(kvm_x86_exit);
> +


Extra newline.



