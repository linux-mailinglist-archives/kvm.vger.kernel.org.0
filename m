Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B288680E8D
	for <lists+kvm@lfdr.de>; Mon, 30 Jan 2023 14:10:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235183AbjA3NKC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Jan 2023 08:10:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbjA3NKB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Jan 2023 08:10:01 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42CA0358C;
        Mon, 30 Jan 2023 05:10:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675084200; x=1706620200;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=mprlU5N3o7I2twHFg4+NhlWqt/MSrONf39tSZ2le5iM=;
  b=Wp/Jd/MALuPgsTcVSJCMqX+umIGR7xRupN5ZUAXaQ624FKvo8TuP2/Fu
   Ic/pSIWhdWWSx8NQAjF7LSAZWYQ+ww5S9djmZic3KuB4XIqq1EVOB3jXY
   +4socgkOFtXCGywzWaUSyWihP9o3hQMDZBYzEngTqfgLPtcjwYNdt6EbE
   VCb4z86VjX2rHrFlI40v7UrqLbOFMHzNJ4t2kgp/3ubN+32UPijdEs4dS
   x+BD3fU4oK6ClrGTnA+y35Tez+DXuOeHVy/jvaKij4gTWKG+PZBQHsnaP
   N8qnS+knCFWNNLEnVpaxi5y9P1srQVRdBnOOC/LK/JAtFwsN7UGe8fTwK
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10605"; a="311171328"
X-IronPort-AV: E=Sophos;i="5.97,258,1669104000"; 
   d="scan'208";a="311171328"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2023 05:09:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10605"; a="666066187"
X-IronPort-AV: E=Sophos;i="5.97,258,1669104000"; 
   d="scan'208";a="666066187"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga007.fm.intel.com with ESMTP; 30 Jan 2023 05:09:58 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 30 Jan 2023 05:09:58 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 30 Jan 2023 05:09:57 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 30 Jan 2023 05:09:57 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.101)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 30 Jan 2023 05:09:56 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j77dKACpbi71T1I2Dyi2Y9XuMIFb98yC1T1XUU7FJ56k98u1LmI6UcPBKMevUS29TKdZyjwutSwAqjry3/+el/6U2hUDkSXq4QIYdw73P+7laBV9B4V+V7Mw4ahuInk4aGcnNN1mMssyQqjb/+Gy1jl88zJzs862nqaKB2+EpoyRAWeecCGJABMFRr5Fq9fL0N15mx8S/xhe8H50jODyjHlMbrV53nTqal2pDaDlKMMR2DpYF49aJ+6PFOARnZV79pagNe4IEu93d3Sje0fyB5ofFcD4ne7NBgZHQs0+zBXkGXoy3k0Gi24dCo+Rlv2pqxEH90kk5rmEtxm/iNMonQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pXJKhJh1dp+dF8k2zz9nq1gIHMNVOkFh54uw7HxyWsc=;
 b=mpKdg2YioBYhyiandYHzBh9jbuwEI9G+lXlybZPI4FNs0/9ke1QHVqEtrhMpXPNroluK3Oud/e61EK/JLUE0ioLRb+/rxYbguNyt6+dweRt9VElMSAbTo/bDnjRxeExjR3Agv6xq0flMSJ80HCSDMFRUvetIV3yYMcmnoqum+5IXJx41j3n9xKq1+FglrhunC+DkkrLvcK16tG0ipCvBxOB9m8PhRpdLBNmxWDSm6RaAKvCCJMX1i9qFY9crkxyUu8SeMYz5stQDG4Py0hMn5byOXFrZQC8peS1jEpq8Jevoei8YWKnHszRYBYV+NpcG+NpNYvjrQ+CB8+Zef7yb/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by PH0PR11MB7423.namprd11.prod.outlook.com (2603:10b6:510:282::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.33; Mon, 30 Jan
 2023 13:09:54 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::7d42:36a8:6101:4ccf]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::7d42:36a8:6101:4ccf%2]) with mapi id 15.20.6043.036; Mon, 30 Jan 2023
 13:09:53 +0000
Message-ID: <c568e650-17d7-deef-fef0-996722ef0dd5@intel.com>
Date:   Mon, 30 Jan 2023 21:09:42 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v2 12/15] KVM: x86/vmx: Disable Arch LBREn bit in #DB and
 warm reset
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
CC:     <pbonzini@redhat.com>, <jmattson@google.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <like.xu.linux@gmail.com>, <kan.liang@linux.intel.com>,
        <wei.w.wang@intel.com>
References: <20221125040604.5051-1-weijiang.yang@intel.com>
 <20221125040604.5051-13-weijiang.yang@intel.com>
 <Y9RLowPBbQFCqLRf@google.com>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <Y9RLowPBbQFCqLRf@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR04CA0198.apcprd04.prod.outlook.com
 (2603:1096:4:14::36) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|PH0PR11MB7423:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ddb2afb-3366-40df-49be-08db02c346b5
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B87RETRBvQZAlqfYOW694Pymm3Q6spX8pZPtJaoiGRV5e7WHEaSLRM5SaVBeMHu40+uEU1NrjikpcyhFCF0CokJeCqMwRKfk+0SQokJGBbVsLvDBjvQLutL7kvFREWUspjPQT66gM8FAEA8Cm3JpbsaUIoZ6KsIBHU303ygQsIpijyn7HFG/lQ9JSTKqPhovuPGJhy+zqrnfw7iQoorZb4ydu84alLuppt/AgHhbZW/gkogYXSvQTFxkBmnfQyjfFk3RejMe/pyyhy+u2Sarq9Z1hopuF1cBbYpym3LXAnyrrTkEH74e+RmJ+hVNpInWGI/shCuV+SAqKXyhadHdBWZAoW2a6UfH9M3rBrxUk9RcXXu/GxBL3EEykxAXmNOxSHhtGep8Zd3TkShiUfut84GnylvW+0n9ndpVwa+wt1WcirHKjHzPwy2rhJqxpAJolk470CzYdtSzPu6MgXN0aoqO4bJecQgabGutVN+HXMaTuR5rGa60nfWv5oL2+TG58gjS9pLYlklzh0+SwJoJIY5yj8P6isIdA5jNXRsaWf6ZpM3rPvV+1uxfuR9jKAx/yx60MWC9AQfTE2Y1unD5M2R8cL0VCAwDaO59eDvXK3Gwo+WzdXRU8O6ZGFJEVeMkFc7Kt5cb1pcMycB5n0yGgwjde0FKhMTR2JEQPl0K0TfKLEyXhEsmMpjgZOUBSm3XU8qz3GL3QuPeAiReQtpofpSeIexir11Au9GwSj0/oOo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(366004)(136003)(376002)(346002)(39860400002)(451199018)(31686004)(36756003)(6916009)(66556008)(66476007)(66946007)(4326008)(8676002)(86362001)(82960400001)(31696002)(38100700002)(6666004)(186003)(478600001)(83380400001)(53546011)(6512007)(6506007)(26005)(2616005)(41300700001)(8936002)(5660300002)(316002)(2906002)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V2ZIZmlvWkVOQUw1bGFTQXBjM01MZlNSd3R1eDJjQ09zUVlBa0VqWm1IU1hL?=
 =?utf-8?B?ckI0Ti9BeUlCY0c4YXhFU1QwdkVVMWNEbFB1elF5WTducTJGU3hzUEpoT3Jx?=
 =?utf-8?B?Ti9YZnFzZEtPcENOSGZvY1JPOHlVQjRHRjJYYXc5QkJwZDNocnQ0ZUpCNGxD?=
 =?utf-8?B?UUp2QUJZR1lQRnVaaGVpYWx0TEh2S1ZmY3JjQlBWaVVzMXdmMHpCMmFNZHkr?=
 =?utf-8?B?Z25aRnRleWNSNjcrSVBNcitlUnR4aTFoTVg4OEd0RHA5QU5IeE1CVGRBcURr?=
 =?utf-8?B?MW1uSGRyQmI0US91RHJXeHVGREtZRlVNM1NwaDArTXVvaitOOXhUSjBTbERS?=
 =?utf-8?B?WHE2ZGZBNzZHenVuT1k5RHpJd3RKMks2dUptSHVKL050SXlGakJuc0pCRURx?=
 =?utf-8?B?MC9vS2x0NnFucUt5bXRZaEd0cGpCdFhTaTY1aVB1R3BYa3BsRlZVaGZ5ZXVH?=
 =?utf-8?B?SXdWdVpneWZxVktIS0h4VU91N1lQbWJsa3I1d3NKd1FvMmFsOTlQSndNdUFl?=
 =?utf-8?B?VVdUZHlwd3lZZkFtRllkWlgwMzVac1lPN1F6U2ZTRDlrWjFzeHBGaWJ0b1My?=
 =?utf-8?B?REJnS1lRUWJBVkxaQmJTUmduOVBpdGV2cVFLUGtlbmFGYUpHdGNSZVhvdERW?=
 =?utf-8?B?bjRWTWhyVTM2VDVZRmhtd3Q0NjRqYnJIdmdMZ0hSa0ttODJvdjJPdmFkanNo?=
 =?utf-8?B?SzBWN1hiVWNPcjBIWVg0SXlsV3pUMHdKMXhpZDQrcGtjcFlDZ29WdHdROHV0?=
 =?utf-8?B?bVVteCtiM0FLMlFJMlppVkpDOHl3cXRpK2FPVXhzQ01wazE1Wk1TYS8rQ0hz?=
 =?utf-8?B?UFR1SC9XVGZrRG5GZlFmZXRQOUpVc2tNRDNEdDlBTTZEUDdzSlgzSGZLT0cx?=
 =?utf-8?B?ckRKTVNDcWphNlVRNkdoT1pUVFZyTjExbTVROW9CQkg4aGlqMi95Z1hYZy84?=
 =?utf-8?B?SlBOdFQ0T3RVZVp1SkNFcURtVWNrK2M2aFFGdDNyZk1KVGpzRmRQeEZ2ZCt6?=
 =?utf-8?B?ZitBSjBJdDBFNnlQdEN1MVd2ZHB4Uk52M1o4WDR6MGxxaXRkMWRNK0tOY2Nr?=
 =?utf-8?B?K3ZUYW16eU1vcTNZd2IwMTI0WnRpdzRjaVptT1dkTWZ0OVkzRmZROGNyTmRv?=
 =?utf-8?B?eXA5QS9CbzJ1YlJJTytwOE5FSCs1c3A1dzRFc0dtY2lqZklUclJYajZyK0pv?=
 =?utf-8?B?YUZYd3JzZ2JwSnJnWkhhQWxOTWw4RWhnN1J5bitoTEhCby9iTGlVRGNFSS9s?=
 =?utf-8?B?MFVLOHJUUVFMbmxucW03SnJxYTZqM1dCYVE2eFRRVGFDSDJGaHg5VzBSUVFP?=
 =?utf-8?B?Qzk2c1pwY2ZqT2EvOUVxMlpZOFdud0M5ZXl5SkNHWkJyRm5RUjF1RjBzbnBS?=
 =?utf-8?B?OEN0ZDcvZ2JTbUN2MEtRejNNME9SWWRKOTdTdEF6Y3dOWFEwV1dLWEVlSGtD?=
 =?utf-8?B?MUlTNHNDa2lXL1h1RkY5RysraG5ZSkxsZHRZQmIrM0hhdk1IaGpFb3NHR2Qz?=
 =?utf-8?B?TURmSkx4WFU5RE9sejBCM29CM1JOMWljY2Fjd3NTajRjWHByZldpTkRHUkpI?=
 =?utf-8?B?THVIV2o0ZGRmU1VpamhyNWJab2ZqZ2p0eXR6elR2RGVkSnBqOFU0dmcrMEVp?=
 =?utf-8?B?NzB0Rmw0WXdyTHZEZ3c1czZWb1dDajNNaWJ6Y3kzdzVCanNpT01ac00yaG5J?=
 =?utf-8?B?WXpTMWZ5b2JBdzhXMFI4S3R0d1Y2dnFTbmtWZUJ2cjY1RVJKTTZBQVRwL0Vv?=
 =?utf-8?B?WjdOSDY3bXpjR3N2cGNmK1dIa1NQZ3V1bThiOG1jTTFCM1E0MUsyb0lKMDBo?=
 =?utf-8?B?SndCQklFdkhCZ3NwUWdXWkc4dk0vMTlUbUE4MjR3SVZzV2VWRUhPdXBUNFRt?=
 =?utf-8?B?cXRxM05UMnU2bis4enM4bzJwR0NVVkY1VUovTEUvRkJzZjZaQStqVWxBM2s3?=
 =?utf-8?B?dVVoVEtpWG14bXY4WEttUWd2akdNbDVKQmk1MnZGbFVIRWZGKzRla3UwcnNG?=
 =?utf-8?B?R3dpcHozOHpRWVRDdThCd1h2dVBGRGU3ZzZlSmVWRS8vYktxbFpocmJ1MkJ5?=
 =?utf-8?B?cE5OVlo4RGFwTTM0ZGtnbVZpQVR1ZlNyOUxRVTNCQnp6WFYxSklwUU14RWYy?=
 =?utf-8?B?TVhsOURCRkk3bWcrU2RlbFR0K3M4Qk8vaENjbUpSNTVPUlNKOUxScmJLYVJa?=
 =?utf-8?B?Ymc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ddb2afb-3366-40df-49be-08db02c346b5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2023 13:09:53.6546
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WaQObNf/VcSHPW6/tJSw6dbSjJsiUfSdZpcjsVVqaGYY95rCeDw6m6Zs9GRW7QRWW2CtHm/61uhDQowG67gbtQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7423
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 1/28/2023 6:09 AM, Sean Christopherson wrote:
> On Thu, Nov 24, 2022, Yang Weijiang wrote:
>> Per SDM 3B, Chapter 18:
>> “On a debug breakpoint event (#DB), IA32_LBR_CTL.LBREn is cleared.”
>> and "On a warm reset, all LBR MSRs, including IA32_LBR_DEPTH, have their
>> values preserved. However, IA32_LBR_CTL.LBREn is cleared to 0, disabling
>> LBRs.", clear the bit manually before inject #DB or when vCPU is in warm
>> reset.
>>
>> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>> ---
>>   arch/x86/kvm/vmx/vmx.c | 24 +++++++++++++++++++++++-
>>   1 file changed, 23 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index 3bc892e8cf7a..6ad765ea4059 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -1695,6 +1695,20 @@ static void vmx_clear_hlt(struct kvm_vcpu *vcpu)
>>   		vmcs_write32(GUEST_ACTIVITY_STATE, GUEST_ACTIVITY_ACTIVE);
>>   }
>>   
>> +static void disable_arch_lbr_ctl(struct kvm_vcpu *vcpu)
>> +{
>> +	struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
>> +	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
>> +
>> +	if (kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR) &&
>> +	    test_bit(INTEL_PMC_IDX_FIXED_VLBR, pmu->pmc_in_use) &&
>> +	    lbr_desc->event) {
> I don't see any reason to check that an event is actually assigned.  The behavior
> is architectural, whether or not KVM is actively exposing LBRs to the guest is
> irrelevant

Agree, will remove them.

>
>> +		u64 ctl = vmcs_read64(GUEST_IA32_LBR_CTL);
>> +
>> +		vmcs_write64(GUEST_IA32_LBR_CTL, ctl & ~ARCH_LBR_CTL_LBREN);
>> +	}
>> +}
>> +
>>   static void vmx_inject_exception(struct kvm_vcpu *vcpu)
>>   {
>>   	struct kvm_queued_exception *ex = &vcpu->arch.exception;
>> @@ -1738,6 +1752,9 @@ static void vmx_inject_exception(struct kvm_vcpu *vcpu)
>>   	vmcs_write32(VM_ENTRY_INTR_INFO_FIELD, intr_info);
>>   
>>   	vmx_clear_hlt(vcpu);
>> +
>> +	if (ex->vector == DB_VECTOR)
>> +		disable_arch_lbr_ctl(vcpu);
>>   }
>>   
>>   static void vmx_setup_uret_msr(struct vcpu_vmx *vmx, unsigned int msr,
>> @@ -4796,7 +4813,9 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>>   
>>   	vmx_update_fb_clear_dis(vcpu, vmx);
>>   
>> -	if (!init_event && cpu_has_vmx_arch_lbr())
>> +	if (init_event)
> INIT and warm RESET are not the same thing, i.e. this is flat out wrong.

I was confused a bit. Is there's a way to intercept guest warm RESET so 
as to disable the bit?

Or what should be followed per spec.?

>
>> +		disable_arch_lbr_ctl(vcpu);
>> +	else if (cpu_has_vmx_arch_lbr())
>>   		vmcs_write64(GUEST_IA32_LBR_CTL, 0);
>>   }
>>   
>> @@ -4873,6 +4892,9 @@ static void vmx_inject_nmi(struct kvm_vcpu *vcpu)
>>   			INTR_TYPE_NMI_INTR | INTR_INFO_VALID_MASK | NMI_VECTOR);
>>   
>>   	vmx_clear_hlt(vcpu);
>> +
>> +	if (vcpu->arch.exception.vector == DB_VECTOR)
> Huh?  This is _very_ obviously injecting NMIs, not #DBs.

My fault, will remove it.

>
>> +		disable_arch_lbr_ctl(vcpu);
>>   }
>>   
>>   bool vmx_get_nmi_mask(struct kvm_vcpu *vcpu)
>> -- 
>> 2.27.0
>>
