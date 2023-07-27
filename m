Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D27BF76448E
	for <lists+kvm@lfdr.de>; Thu, 27 Jul 2023 05:48:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231502AbjG0Dst (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jul 2023 23:48:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229819AbjG0Dsr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jul 2023 23:48:47 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7098F26AC;
        Wed, 26 Jul 2023 20:48:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690429726; x=1721965726;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=kFb8Vxp4AS6FIoHUiT9pFmgtrwpn2t3Zr/4BBhFL/3U=;
  b=O6KKXnxAWAkXaTbDrsPKOcLarHBzjYcwyuDtt20wXGHQ+BiwSz01IFYs
   fsvzeE/FyKHmq3y0b/gw4gJIhR1zECEAYgWdyeC20lYgygE4GtsEuk3nM
   4UsdSZWb+u8e8pir5RWb95vM2oQDjTELhC1meFCyTSY0c+zkBL7ZQgUWM
   FkOs53Xmz3ZfF/Sx+MGbxBUH5Z1JiZcrUiOcwZ7OCtCjzgDpE66F8zeDB
   vqLNF344NoFyAaQr1g9J8Vxxhp1O5DSiG8MhyynNbnZlZK5SmFVG8luIg
   ACvNaNzrl87WeSwJ04C7rfC7xIU+MFaLtpC8N4czGU4L1+3gVwyYBN1wd
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10783"; a="454561602"
X-IronPort-AV: E=Sophos;i="6.01,233,1684825200"; 
   d="scan'208";a="454561602"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2023 20:48:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10783"; a="726785105"
X-IronPort-AV: E=Sophos;i="6.01,233,1684825200"; 
   d="scan'208";a="726785105"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga002.jf.intel.com with ESMTP; 26 Jul 2023 20:48:41 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 26 Jul 2023 20:48:41 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 26 Jul 2023 20:48:40 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 26 Jul 2023 20:48:40 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.105)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 26 Jul 2023 20:48:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LjGRKwb5zJrIY1Gt8DdwTh4GmLPNoJ3sviWUKT5Ixrq+5lNipWb4n1zNimACiedTd1EWPEUeWfOEcm5mNPHxyLW4bWIZNG3ZlyQv2y8mzXzuZrxh+nP5Qpwbh6YsSFuPIziVMUH3FvYJU5E8QcthUpxn7jZx8rezcsKzFNFGSVSNxQAhz+tjOJ9EcGXSD1I0jUuiz1taHuPhOIBuvQ6BEq9z79jj/llC+3mYqRRv4tVAd42lOD1z7X1mdN1j6Ju2pSWrMtjEJLuYKUwXqNC9qDKzrkhEpNuaFps3t/6unRTx5bq6OTa8gPf5mhD0qUFkcKhgKF5Ywtrx95WBr7Nalg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iZVlZvspojvkP2WZeX5ePdP7TSDVyYEA/1WBxdy4n8U=;
 b=Cv5wUARtkji1J9uoWj3mM4ZbbkG4CmZsU1mqTbBBWfZX/pfIMQM8UguynSnD6VMl7P8UnmNPd6AKATJYqOCSUNCUvCJCZ63uo7NZ5gLkWrtO6B2jTn+0F2BKvTmmLzQKXLs7ict/LUglGDEUZY/i4Tx3j2ME0NHhi6iHS5qljb9uA4UNpRazM8CPr9l8tqf8DlWdfed2Yv7TIHYVVejfihtODM3gVee7BFsx03fdWW1wN1g99HUkiK1gex+zvHenX5oX2q1e+b08dtQSfgK+hkqWe/lK8oJGg8ou241mD73Gj8NTZ5jLwHWhD8Tn01UFMjdMN16PaLvbNEY17igbkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by PH0PR11MB4774.namprd11.prod.outlook.com (2603:10b6:510:40::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.29; Thu, 27 Jul
 2023 03:48:38 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::e19b:4538:227d:3d37]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::e19b:4538:227d:3d37%6]) with mapi id 15.20.6631.026; Thu, 27 Jul 2023
 03:48:38 +0000
Message-ID: <e3751a2d-7eb9-2add-8c3f-172bf133af75@intel.com>
Date:   Thu, 27 Jul 2023 11:48:27 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v4 14/20] KVM:VMX: Set up interception for CET MSRs
Content-Language: en-US
To:     Chao Gao <chao.gao@intel.com>
CC:     <seanjc@google.com>, <pbonzini@redhat.com>, <peterz@infradead.org>,
        <john.allen@amd.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <rick.p.edgecombe@intel.com>,
        <binbin.wu@linux.intel.com>
References: <20230721030352.72414-1-weijiang.yang@intel.com>
 <20230721030352.72414-15-weijiang.yang@intel.com>
 <ZMDZvfJu1yhBigXz@chao-email>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZMDZvfJu1yhBigXz@chao-email>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR04CA0156.apcprd04.prod.outlook.com (2603:1096:4::18)
 To PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|PH0PR11MB4774:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ed9be6b-a251-46b6-822e-08db8e545bca
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ogoIYRiQC9jByDYWeB/VotvSo9NBqhIM99VhbUJ5j/JExREmXV8rqsz1qVOIBiX9nWFlVhKrL9crtRSRAL+Z5KJhm3rrh0GhkM2NKufLOr6kjMfAfhCInHx5e9ZIX5fLk9lMpx44PcVchVyfsqXGswzmZnyn28dS1ivR2ECMhsdhNP1gu12qBHKlMLb7nM2WQyOsnbsWlMMJE15+pcbpZ58hFM+kVsZ/K73k/yaZEmoCpCEvVfkW863NJIg73nwLqCCn9wtgtqxXNJKCsOdcwFRAJ6XLN38k8W2r/iaQ+IxL9/7rAufe41mmNpfpVsR5ulXUJwa8rC7N5r46gDA+7Tbx8dAR05cBCeZrgHT6SaAOrL46pRalviRgXunGcOv8LKiicaG8VlYsmsrR0J28kTWlzkwHLiVvjbv+BDdYGO9Zd4vj4QJcTcaugDt9pkKSgZ0Nt84W0FjQzHzNPV2P+wxCYVkWvgwAcOJQ8H5mUdcPAKxZ87niZxfFV0EyI3ztpIaB/IOYk/l+m38VfMikG+5fqv6zLGEKyKlQBgyMK3g/DLj4r8z9/gV5TEvhgfliRMzLzEusEt4NMnGG5az0BcSFVva4Zx0Y/VkF/SAW+cN8xnmjCmi/y/1nqo/ZOeOx
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(366004)(136003)(39860400002)(396003)(346002)(451199021)(2906002)(316002)(41300700001)(5660300002)(8676002)(8936002)(6862004)(36756003)(86362001)(31696002)(53546011)(6512007)(966005)(6506007)(26005)(478600001)(6666004)(82960400001)(6486002)(83380400001)(186003)(2616005)(31686004)(38100700002)(4326008)(6636002)(66476007)(66946007)(66556008)(37006003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZUdWYUpwV0NvdEwwdXNWb3p5WTA4bUlaM1E4VVhuc01wWkhRdGZmY1FYK0Iy?=
 =?utf-8?B?bVdoSzdOOGV1QzAxbE5lNDdzQWoyeWNUTFVrNEY0elAvcFltVmRQbmJGVDdH?=
 =?utf-8?B?cEhNZ3AyNWEzdkVQUlRRYk81UnY5VzNnbGJPeWpuU2RSSVUxcDZ4cTgwR1dR?=
 =?utf-8?B?Tmk1eEcyU0Q4TW10TmxHemIvWjd2em1BbDdRWkd6WFVDS0ZKa0l5eHBZYmNR?=
 =?utf-8?B?cjdHTzdyOW5FQ0M0NWNoUC9CQTJIQXYvK0o2SDJ0cS9HclJybitXYWF1MDAw?=
 =?utf-8?B?Z3YzditwREFCbFp4b2x5cWNHQUxNNkdTVVNET0ZMUmJaV2lOQWlNeVlOVHRy?=
 =?utf-8?B?MEp3OXFjWEVQcDJuYXdtSFBwUjYydnRHR21heTZhWUphdDczWCtEU0FRdDNU?=
 =?utf-8?B?Ym84eVY0VE5HRE9ocUtvK1B5cExRbnhqTEJkY1c0bTg2bWZzbTczaE9jME5D?=
 =?utf-8?B?NHZ3ZDEyblc1R1ZxaHhzaWFXWFJBbjhwZFRzVzBIclh6VHI5aG4vODVTL1k2?=
 =?utf-8?B?S2Y3dDdTSW8yek9wWUN2U3E2UDVSZGhUNkprRWR1dE5aM1ExMUt5b2ZVUUs1?=
 =?utf-8?B?QVBxRXpjRHJWWVUwSlZ1THNTRXFDeFdodmxKVWp3SW41eWNRNVJGZ3ZmOUpN?=
 =?utf-8?B?YmxrMnkxcHFWV29zaTZRU3gyUVBid2xHUEhGRUh6S3FKc2xqU3VJYWRVQzVo?=
 =?utf-8?B?aWxDN2duZUZOSDFDcHBHWDBkN3JpMFBzaStJczZ4UUpGOWU1am9WS3dmazY2?=
 =?utf-8?B?cU9CSyt2UHZzZEVSUFRXU0pJWFNxMGlEOTVqZzdOQk11SVBkTlJscW5ENWVL?=
 =?utf-8?B?eWNhYmJqV0hvY0E1QU1DaDlpYVVUa1V5VWRyNTdUQStZc25NNzUrL0FXNFFx?=
 =?utf-8?B?T01DdXdBeXE4RUFBVGNmTEtVQkVQNWl0MktFVWJpanNlZG9TWkw2YUZEQnN2?=
 =?utf-8?B?ejI2Rmh2RXY1TGdGMmpYUndoYzdKSTRpRi9SRkJCb1FjbGxSTDVOcHIwN1RE?=
 =?utf-8?B?R1hoaGhNUnNHVGRvL3pGL3RKUkhTM0pic0lYbWtsNWswOXpGVlZIekh3MGpH?=
 =?utf-8?B?ajR2T1M1STJZdEpWVEx0VFB3djBJeVZEbm5WVnAzTEZMZ0tNS2xaSUxlRXlx?=
 =?utf-8?B?RlBIUkJBaW5jQS9qanZDYlJjMXFCVUExeFQwSE1rWnZTYm54aTQyMEs4aTZV?=
 =?utf-8?B?ZU5JTUNMN2VPb2tpQUUrWWRVZllETUhUNUQ3b0pjU0pIcUR4NnZYL0pYaFlI?=
 =?utf-8?B?TlNtVk9iN2dXWXZQemNqQVhuZjJUSW15Uk9pVk5SWTlPcnVrY0QxdjRiSFZj?=
 =?utf-8?B?TkpnTjh2bXdZTDNGSEF3QlpQemFZbFNLZVJRK0xiQksrVWc0Sks4bkFLWHB0?=
 =?utf-8?B?QVhEQzM0Sko1bXd2ZzV2M09qNEN3VmZjVGlxS24vZ28rcmxEbVExMWR0WHE1?=
 =?utf-8?B?eE9QcEcyTThqNHpvZElGZFF2bnFid3o4K1Z4L01NY09JSTA3TVUzUG1xVjBM?=
 =?utf-8?B?TlZJays2Y0dUZ1ArSVE5NlNmaEFQbElvNnFScDlSNmhtaWVXQ1EwcDNJdzEx?=
 =?utf-8?B?bktIR1Z1aForT2dHVXcwYzdZbENXdSsvcE05MlhubEQwMkU2YnEvaGxiUHdW?=
 =?utf-8?B?VU1nUGUyRGFJVGJmYzdqQy9sVGMvZ0xRcFEveFdjNi9nVlhlTlhjS0dHMFRi?=
 =?utf-8?B?c2VyVkIzTFBCSGd4Wlh1c1R3MjBnakRHRy9yTlBZbkRLTmxmMkcvQXZ2a1VJ?=
 =?utf-8?B?Y0RrZzk0MXhwTGJDZmIrTjdSMm5UdkU5QXFqOUZnWFg0UjZsZTlkVFBzRzZn?=
 =?utf-8?B?VEwwK0tyNEQvU05XSjU0RFpXdWNvbDFPbGpqSUxyVHhwUUpBdTc1eWgwQ1Fv?=
 =?utf-8?B?aFl6b2dlVU5KNVhNMStnclF3ZlhnQlZ5Tnh3MTBkdGdxS2ZXVWtLY3ZocW5K?=
 =?utf-8?B?TjdGZy9IbGtCL3MvSVJvRERKdWlrNGgxY1RKM0VjUnIrMDJIN0hjR24vemxu?=
 =?utf-8?B?bXFVUFNpMHJnUDNXbFdVQTJWa1hUOEJud2J3UmZxcHNrRnQxSlUrSlo4MzVR?=
 =?utf-8?B?UktFeGVFWnlZanEvVlNwQ2c3SCt0Q0VMcTM2ZFV1dXBqU3VuQkFpWndWbE80?=
 =?utf-8?B?d1NRWXNKaysxbFZicnJWMC9vTWM5S1I0L0hoLzg1c2VBMzVXaXplaVBDaDMr?=
 =?utf-8?B?MXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ed9be6b-a251-46b6-822e-08db8e545bca
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2023 03:48:37.9282
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +bol7uVirwyQtUY3djvkyeSdjjdDRXQxGFl3sdjYdKBm54AzWGmR3FesK7c7ww2XhyUkIQhqzJ9PxzUAbWpfQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4774
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 7/26/2023 4:30 PM, Chao Gao wrote:
> On Thu, Jul 20, 2023 at 11:03:46PM -0400, Yang Weijiang wrote:
>> Pass through CET MSRs when the associated feature is enabled.
>> Shadow Stack feature requires all the CET MSRs to make it
>> architectural support in guest. IBT feature only depends on
>> MSR_IA32_U_CET and MSR_IA32_S_CET to enable both user and
>> supervisor IBT.
> If a guest supports SHSTK only, KVM has no way to prevent guest from
> enabling IBT because the U/S_CET are pass-thru'd. it is a problem.

Yes, this is a CET architectural defect when only SHSTK is enabled. But 
it shouldn't

bring issues, right? I will highlight it in commit log.

>
> I am wondering if it is necessary to pass-thru U/S_CET MSRs. Probably
> the answer is yes at least for U_CET MSR because the MSR is per-task.

Agree,  also xsaves/xrstors in guest could fail if they're not pass-thrued.

>
>> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>> ---
>> arch/x86/kvm/vmx/vmx.c | 35 +++++++++++++++++++++++++++++++++++
>> 1 file changed, 35 insertions(+)
>>
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index b29817ec6f2e..85cb7e748a89 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -709,6 +709,10 @@ static bool is_valid_passthrough_msr(u32 msr)
>> 	case MSR_LBR_CORE_TO ... MSR_LBR_CORE_TO + 8:
>> 		/* LBR MSRs. These are handled in vmx_update_intercept_for_lbr_msrs() */
>> 		return true;
>> +	case MSR_IA32_U_CET:
>> +	case MSR_IA32_S_CET:
>> +	case MSR_IA32_PL0_SSP ... MSR_IA32_INT_SSP_TAB:
>> +		return true;
>> 	}
>>
>> 	r = possible_passthrough_msr_slot(msr) != -ENOENT;
>> @@ -7758,6 +7762,34 @@ static void update_intel_pt_cfg(struct kvm_vcpu *vcpu)
>> 		vmx->pt_desc.ctl_bitmask &= ~(0xfULL << (32 + i * 4));
>> }
>>
>> +static void vmx_update_intercept_for_cet_msr(struct kvm_vcpu *vcpu)
>> +{
>> +	if (guest_can_use(vcpu, X86_FEATURE_SHSTK)) {
>> +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_U_CET,
>> +					  MSR_TYPE_RW, false);
>> +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_S_CET,
>> +					  MSR_TYPE_RW, false);
>> +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL0_SSP,
>> +					  MSR_TYPE_RW, false);
>> +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL1_SSP,
>> +					  MSR_TYPE_RW, false);
>> +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL2_SSP,
>> +					  MSR_TYPE_RW, false);
>> +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL3_SSP,
>> +					  MSR_TYPE_RW, false);
>> +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_INT_SSP_TAB,
>> +					  MSR_TYPE_RW, false);
>> +		return;
>> +	}
>> +
>> +	if (guest_can_use(vcpu, X86_FEATURE_IBT)) {
>> +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_U_CET,
>> +					  MSR_TYPE_RW, false);
>> +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_S_CET,
>> +					  MSR_TYPE_RW, false);
>> +	}
> This is incorrect. see
>
> https://lore.kernel.org/all/ZJYzPn7ipYfO0fLZ@google.com/

Yes, will add the lost counterpart, thanks!

>
>> +}
>> +
>> static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>> {
>> 	struct vcpu_vmx *vmx = to_vmx(vcpu);
>> @@ -7825,6 +7857,9 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>>
>> 	/* Refresh #PF interception to account for MAXPHYADDR changes. */
>> 	vmx_update_exception_bitmap(vcpu);
>> +
>> +	if (kvm_is_cet_supported())
> Nit: this check is not necessary. here isn't a hot path. and if
> kvm_is_cet_supported() is false, guest_can_use(., X86_FEATURE_SHSTK/IBT)
> should be false.

Yes, I think it can be removed.

>
>> +		vmx_update_intercept_for_cet_msr(vcpu);
>> }
>>
>> static u64 vmx_get_perf_capabilities(void)
>> -- 
>> 2.27.0
>>
