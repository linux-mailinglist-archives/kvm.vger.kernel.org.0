Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97FEF764441
	for <lists+kvm@lfdr.de>; Thu, 27 Jul 2023 05:19:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230232AbjG0DTt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jul 2023 23:19:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230345AbjG0DTp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jul 2023 23:19:45 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E561226B8;
        Wed, 26 Jul 2023 20:19:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690427980; x=1721963980;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=zbNbmuwHcFkXXHjY+iz1H8ttYKrRh4FA1cM6cgnz+DU=;
  b=KrfwNSmqevYpg+39rvsM3W3M6mYjkyWzJWIPhsdTloNzNBsQapVHhN09
   H1XGjL5NHZHS+PgDTTdcqlw0A+HE8WURcIw4MWNn1cMaJbNtBj7tik+s+
   ckc3GB57j1Pf6Lm33ZwqCgggdAI4ZF7r9jWJtyv6J8dh3PQDYvxMAygXk
   xBgcQAfRUmkWI4GpsQkgtUZcxDknv6/d75t9BJZKnbgizJkc3VzIqn3Vo
   /AkSuJZuqVPb7hx0g/Te15ZRkgDAv15F3Rg80w7A+m0SI02qzJYd0eNbj
   OQxCQjLHiORK1VgVtTT6JJP4e8DVjab3CYfx+w1nbkwIGE5k6Yp4TgnXh
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10783"; a="399129281"
X-IronPort-AV: E=Sophos;i="6.01,233,1684825200"; 
   d="scan'208";a="399129281"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2023 20:19:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10783"; a="726772342"
X-IronPort-AV: E=Sophos;i="6.01,233,1684825200"; 
   d="scan'208";a="726772342"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga002.jf.intel.com with ESMTP; 26 Jul 2023 20:19:39 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 26 Jul 2023 20:19:39 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 26 Jul 2023 20:19:39 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 26 Jul 2023 20:19:39 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.47) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 26 Jul 2023 20:19:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FShSuP7zDuSpRNwffmgus2HM38wxcVCLN8IVQYFDkS/K1UMcIEuO/Xo3vzT7zOvtqJ6zPaTye9lZFJYWgpOMv23aS3rYsJuL0mznvSVdQl0HEih/R0Z9zfwzOkFFsfa7P/jBOnhjr1oqjoiGLY4rAhfnteeEtbuwYF2k5bsESnFg15QydGPc3ZVUxVxM9qS6KRecUKz9Du+AWMxqqKIcrzlj4VDHFw5nBKnSVGaKv/c5vsUqZq8aKKibvHULpfujaYQA7q0RnhdUHqcRkPxqrp50lNa8qX7zQGaEHaiMsXeee433QUmhdOd5nCZ1ZxyKuc+8AIxAaGKnhqvUzdZ66Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RzsCN6Vd6Jak2alIs97iUMdsQ/VoOhH7NHCsuyk5vg4=;
 b=Ovzl+m/Rmy9g0MLJlqRsUzJqejW3TOztZekeHx47TEnDkjG61K8EXNRTfF5Odd2WAYf7cKI//eVIDgLT1IkFE/H00Ox4PF7wK4hiW5WI/E4EucgcD/GxiOsJFSl2QqD6qoc/IA4+uk46rWhHiNXGO6Is/vbRMXOgoBQvZnGTmAVCG27ipIA8KbKJk6sxFkvWp89eoBNCTSDbdO/mR6s8+ausgNtd2miOdu2wBjMWhv0Te7j1bYcSDhgB4zoUSCZgdh25rnHB/Psj2TLjKYyw1hV883mCm+UCMGsB2eUBN3r8txq4sVUiBnKEeHPE+mrRGAU9h0K3u/8UA7metRNe7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by DS0PR11MB7623.namprd11.prod.outlook.com (2603:10b6:8:142::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.33; Thu, 27 Jul
 2023 03:19:36 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::e19b:4538:227d:3d37]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::e19b:4538:227d:3d37%6]) with mapi id 15.20.6631.026; Thu, 27 Jul 2023
 03:19:36 +0000
Message-ID: <3d5fdd07-563c-6841-a867-88369c4dbb36@intel.com>
Date:   Thu, 27 Jul 2023 11:19:25 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v4 13/20] KVM:VMX: Emulate read and write to CET MSRs
To:     Chao Gao <chao.gao@intel.com>
CC:     <seanjc@google.com>, <pbonzini@redhat.com>, <peterz@infradead.org>,
        <john.allen@amd.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <rick.p.edgecombe@intel.com>,
        <binbin.wu@linux.intel.com>
References: <20230721030352.72414-1-weijiang.yang@intel.com>
 <20230721030352.72414-14-weijiang.yang@intel.com>
 <ZMDT/r4sEfMj5Bmu@chao-email>
Content-Language: en-US
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZMDT/r4sEfMj5Bmu@chao-email>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR02CA0016.apcprd02.prod.outlook.com
 (2603:1096:4:194::9) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|DS0PR11MB7623:EE_
X-MS-Office365-Filtering-Correlation-Id: 5102b52b-3aca-423e-8c63-08db8e504df9
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: caoit2HF3lCJru45xC5m+cLQ+5/3JlkK1r60YHaHI/3zj7X/jsVEf0HD+d0JxqMRXPrsv1JeQNvhNRzlu/DiA1Cc3KTAB0QNzb3Optf86zC/mL+IQ8TgJjtQCa33Lqw42JCQe03Z8N6OpLoLBx2C9Lg54rKVxkRunvyIDvVTNZWmTzB7G2aUtd+Ku4TP5qfDQv2KCuyNxZkVsWPXQ+txxurqltFRNPTGgQTW1bMzndlGBTcthuSzET3YZ3LfMzE2qjg40ZB+cqGWj7mjq0LgiqTuX0mDD2GLXq0KfWCH7k543ZoFoecAuHH8rZkHfFasOiHTSXfARt3nj2a4m/CYM+mt4bBu0zazzN2mwkUk0oEuoGvpIMA2cO/nVR3CU2/uSJAC1zXpwtqoMQvanSu6l83MDJn2h8UfNMShdSreimkyhAmdNc2nK5/zUVM6ahFazkP08tcGQSw/z/JFROFdwcRE8VNdfzOKlBmsov+t395jta5/GAISM+rwGN5J/CEDtNLR5hP/+hUNXavvAz5hMfm3ZvmG0PomnRZwQ/T0Cqa/RpNGtur09B1MsrVZ5t/DimnjHpALqkbON0pYd4hiRt0R3cOHWegDMEX0LV9wHWendsyUUqngZva5gjkVXRgjMA0MhX2xhkugztVUHsxNNQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(366004)(376002)(39860400002)(136003)(346002)(451199021)(31686004)(2906002)(6862004)(8936002)(8676002)(6636002)(4326008)(5660300002)(83380400001)(41300700001)(66946007)(66476007)(66556008)(316002)(6486002)(6666004)(6506007)(53546011)(36756003)(6512007)(186003)(478600001)(26005)(37006003)(31696002)(86362001)(82960400001)(2616005)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OHFSZEhWeEFVZThBM1Qxa1JwZUxYbnI2M1Frck1XbU1PRzFQQSsxTElWV2Zo?=
 =?utf-8?B?eWErQUQxZHhtUkJaSGVqUmo5Tm5JbGxRdzJZTmdXcDBSam1MSmQ2dkduZjBR?=
 =?utf-8?B?V2pERzZNU05nVmhwUDN3Z2RCY2VlVEZpRDNwS0MyUEp2Rks0WkFnaWdDOGZi?=
 =?utf-8?B?N1JwUGJFRVBmMHZ1dmhHT2E0bWdsYWF2MlJySWlTUmwvekh5K2FKOTRqdjV0?=
 =?utf-8?B?MzdlTWpFdVRpM0pDUHBRZnlRY0FHTmRxK01wWW9WTERzYnBxRDNOZ0JJSG15?=
 =?utf-8?B?NzFUdzZVM3BJTU90S3BWTUU2M1QydzNWVTJ5bnNQYytVbDJ6N1E4QUM4VHNX?=
 =?utf-8?B?R1JORHZ4eHFFQTBFc1BpT0piUldhMU1xd01qUWxsaVlRNUl4TkJPMzhVNEtW?=
 =?utf-8?B?SXNmcSt6Y1ZJVXdDaUNIaDJhOVlVRjRxY3ZQRjE4VjZJYms3WmJUM3lGVmVn?=
 =?utf-8?B?VHFrU3FJdHJkY3hJME56b0dtY3ZkNW9CYWU4aFk4MzFEZHd1NnkwZWt5eG9u?=
 =?utf-8?B?dlpFOFF1QnJiZkdFN1hxVGFKbXBNdCt4djIyQjhBUTRHaXY4SkJ2SnE5bkRL?=
 =?utf-8?B?ck1FZjlSeFhXcElURjBwVkQ4Z3JHZFJNbEhMdUlCVUJwR0FxVUFYODc0WDlv?=
 =?utf-8?B?VmJQYTUvWHBBNEJLYTliUDEwcTk3YXpBTGIwNllteFMyT09NQzVJZ0NqYy9F?=
 =?utf-8?B?MURkY2YyZHBqNDRvNjQySFNUL3Z2c3ZqbDZhbW9UMnRtSmVyWDFoeEx4dmE1?=
 =?utf-8?B?cUk1OG5ZYXFkYWhVcllNUWVyZzNPT1R6SUJpaHkyMFA0b2U1bWNDc3h1NG53?=
 =?utf-8?B?UDR6M1crVEVBbkhJNHpBaURQcVBqemlhemxMUWQ5aCt6TmlpT0hFZzJpcWwv?=
 =?utf-8?B?eGg3SFNWbjMrM1dhcG1qRTFpM0cvTzhDbWpDR1pDcUpJU0cwWTVKZ0xlR3My?=
 =?utf-8?B?bHlvQVQvV3MvYzV4bTlCNjczV2NsNWJpc1YvZ0RwRzlwdnM1SkdraHJ6dEZB?=
 =?utf-8?B?T09GTnlJNXR5cHBNWHBRQXQyQWVUZk9Zd0dQK3RpK3M1U1FiT000VkFWMHBE?=
 =?utf-8?B?ZjFUelpYSFl3OUl1U3hqWmtqZW9mVFpJVFhQaUFCeWNCVjNzSmd6V3hVNFVV?=
 =?utf-8?B?NWk2amN6alNtRjM0SVcraTRtU0ROOGJPWWQ4SXN5bk9oa3I5azNtREU5QjZo?=
 =?utf-8?B?V3pXZ2g1RVlOK29mcVFoRHA2eGtSaG9hdHZGZUVodGFOY2ZxRHVhUjBOcGpq?=
 =?utf-8?B?cTFzV2Fnc3VoTHFLbkgyb1VGV1hZb0VoaUZTbHREV2w0SHZSRGxWU1g5cEt0?=
 =?utf-8?B?bXBSbUlPOWtkZlBoYXJGOGdTMWkzdXBReklUQWRDQ0RCTkcvakFHNmwrM0VR?=
 =?utf-8?B?U1pUbngxZzNZK0V3dUFkRkVlRUgwcmN2TzhzM0xFYktzQ2EwYXBNR0p0bWt0?=
 =?utf-8?B?ZGtMamtDMFc3S3BwODRrNDc0YWltZUo0TmVZS3BWSy9Mdm00elRlc3hsZUVS?=
 =?utf-8?B?K3pHZUhWaVFJNUpTb2hVa3U5NUF2TkV5RGhCOTB5aDJvY2hLY2JBNjRjUXZx?=
 =?utf-8?B?cVhXK2hoYnFvU2pyZm04TGZQYWRMZU1jcW5YT0UzSzVoQ09sUEhSWXJ0OWM4?=
 =?utf-8?B?M25vL0gzaXNYZUFpRWlGeG05MEJSUlNFNjBRRnJWY1FvZElIbEJ4V3c2Ykpr?=
 =?utf-8?B?Y3VXTGZEUW9YSEs0RUJ6L3I5ZDlGY2ZWOGdxU0FYdU8wNHFyZERvUS9pMnVL?=
 =?utf-8?B?RjRTSGp0MzcvVkpheUVzUE9mbWNoRTNnWkVYMHZjUHk4NEx1NklEUWRKOFhk?=
 =?utf-8?B?UEFRcVhTZEJzMi8xdTZjSXFMeXdRcGlONmt2ZTFnQ0RRMkx5TkhHM0VjN0VT?=
 =?utf-8?B?d1R2S0tmUHhZcG45TVRtMlRIK1ZId3ZYeFJZT3pHdXV4ZVFYcWdRMWFGTlZH?=
 =?utf-8?B?eC9tRHI0SVBKaXV1Uk0wV2lhbnhnTHp0cVFNcnBTQ2xMQk1pTnVqTm94eVFa?=
 =?utf-8?B?cWc0RzdYcmhWN2U3MG5FaUFXQk8vbXA0bHpwWndIQ1NPVWRwS2M2MVNyajZG?=
 =?utf-8?B?OEUzQVh5WEZNSFFaSHQzRGFyVVNDUlM1Q3hOcTFFVk9GVkNvTjlNOXQ0aXUv?=
 =?utf-8?B?OFNrQk1LUkxzeFIzcS9tTlo0K2pRZjN1S3ZHWmtvWWQxdXZqM0E5aFR5QWpD?=
 =?utf-8?B?U2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5102b52b-3aca-423e-8c63-08db8e504df9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2023 03:19:36.2509
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4TbKsoVkhgRoa9OPHjYnpWBWrWvKjHIUMjkUA+rxNCxCfVaP7jSQrL31ACkpURzs7nzZnRhflehxDJ2acd3ZsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7623
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 7/26/2023 4:06 PM, Chao Gao wrote:
> On Thu, Jul 20, 2023 at 11:03:45PM -0400, Yang Weijiang wrote:
>> Add VMX specific emulation for CET MSR read and write.
>> IBT feature is only available on Intel platforms now and the
>> virtualization interface to the control fields is vensor
>> specific, so split this part from the common code.
>>
>> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>> ---
>> arch/x86/kvm/vmx/vmx.c | 40 ++++++++++++++++++++++++++++++++++++++++
>> arch/x86/kvm/x86.c     |  7 -------
>> 2 files changed, 40 insertions(+), 7 deletions(-)
>>
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index c8d9870cfecb..b29817ec6f2e 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -2093,6 +2093,21 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>> 		else
>> 			msr_info->data = vmx->pt_desc.guest.addr_a[index / 2];
>> 		break;
>> +	case MSR_IA32_U_CET:
>> +	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
>> +		return kvm_get_msr_common(vcpu, msr_info);
> kvm_get_msr_common() is called for the "default" case. so this can be dropped.

yes, I can drop these in vmx_get_msr(), just wanted to make it clearer, 
Thanks!

>
>> +	case MSR_IA32_S_CET:
>> +	case MSR_KVM_GUEST_SSP:
>> +	case MSR_IA32_INT_SSP_TAB:
>> +		if (kvm_get_msr_common(vcpu, msr_info))
>> +			return 1;
>> +		if (msr_info->index == MSR_KVM_GUEST_SSP)
>> +			msr_info->data = vmcs_readl(GUEST_SSP);
>> +		else if (msr_info->index == MSR_IA32_S_CET)
>> +			msr_info->data = vmcs_readl(GUEST_S_CET);
>> +		else if (msr_info->index == MSR_IA32_INT_SSP_TAB)
>> +			msr_info->data = vmcs_readl(GUEST_INTR_SSP_TABLE);
>> +		break;
>> 	case MSR_IA32_DEBUGCTLMSR:
>> 		msr_info->data = vmcs_read64(GUEST_IA32_DEBUGCTL);
>> 		break;
>> @@ -2402,6 +2417,31 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>> 		else
>> 			vmx->pt_desc.guest.addr_a[index / 2] = data;
>> 		break;
>> +#define VMX_CET_CONTROL_MASK		(~GENMASK_ULL(9, 6))
> bits9-6 are reserved for both intel and amd. Shouldn't this check be
> done in the common code?

My thinking is, on AMD platform, bit 63:2 is anyway reserved since it 
doesn't support IBT,

so the checks in common code for AMD is enough, when the execution flow 
comes here,

it should be vmx, and need this additional check.

>
>> +#define CET_LEG_BITMAP_BASE(data)	((data) >> 12)
>> +#define CET_EXCLUSIVE_BITS		(CET_SUPPRESS | CET_WAIT_ENDBR)
>> +	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
>> +		return kvm_set_msr_common(vcpu, msr_info);
> this hunk can be dropped as well.

In patch 16, these lines still need to be added back for PL{0,1,2}_SSP, 
so would like keep it

here.

>
>> +		break;
>> +	case MSR_IA32_U_CET:
>> +	case MSR_IA32_S_CET:
>> +	case MSR_KVM_GUEST_SSP:
>> +	case MSR_IA32_INT_SSP_TAB:
>> +		if ((msr_index == MSR_IA32_U_CET ||
>> +		     msr_index == MSR_IA32_S_CET) &&
>> +		    ((data & ~VMX_CET_CONTROL_MASK) ||
>> +		     !IS_ALIGNED(CET_LEG_BITMAP_BASE(data), 4) ||
>> +		     (data & CET_EXCLUSIVE_BITS) == CET_EXCLUSIVE_BITS))
>> +			return 1;
> how about
>
> 	case MSR_IA32_U_CET:
> 	case MSR_IA32_S_CET:
> 		if ((data & ~VMX_CET_CONTROL_MASK) || ...
> 			...
>
> 	case MSR_KVM_GUEST_SSP:
> 	case MSR_IA32_INT_SSP_TAB:

Do you mean to use "fallthrough"?

If not, for  MSR_IA32_S_CET, we need vmcs_write() to handle it,

this is vmx specific code.

