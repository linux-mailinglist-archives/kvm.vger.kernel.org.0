Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 485F573502D
	for <lists+kvm@lfdr.de>; Mon, 19 Jun 2023 11:30:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230395AbjFSJ3d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jun 2023 05:29:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231696AbjFSJ3A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jun 2023 05:29:00 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCAE11A3;
        Mon, 19 Jun 2023 02:28:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687166922; x=1718702922;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wrj03kIv6sIYd/32lrO+gJxZXU2Mrhdeovm51AEXscw=;
  b=GftKC3HgOqhHX+h/woNn6etyFBlQvmhVm32Q6zfypMG2WSs+MAh8uWZH
   C5NkumljvwtFv+tGeA2xqWCZ9VnGIg1nvI7fFL+30cFTIaA6NtcqrjBGZ
   sIBfB23pBotriQ9bNjR2E1JiK7diRCT/Czy5aZ5XTVX41I2SYOi00WNcj
   kQUWutu/2RTI91Z3Bajr/AlUBYiU8kSzwwhIkJWLsLMkHFggnlEVawNa2
   1hhMsYCF7+Pn2z3k5stxujPeBbv5bupO7sdfcl6M5UpjaC3PkH7k9eMKw
   hPRvHCm9fG6Eah/cCvVQ3ihLdoN5CdMEeitx+pv5taveXVazEksSLGY0o
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10745"; a="425539875"
X-IronPort-AV: E=Sophos;i="6.00,254,1681196400"; 
   d="scan'208";a="425539875"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2023 02:28:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10745"; a="743382500"
X-IronPort-AV: E=Sophos;i="6.00,254,1681196400"; 
   d="scan'208";a="743382500"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga008.jf.intel.com with ESMTP; 19 Jun 2023 02:28:41 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 19 Jun 2023 02:28:40 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 19 Jun 2023 02:28:40 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 19 Jun 2023 02:28:40 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.41) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 19 Jun 2023 02:28:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L7Vza/Srn86IEJwji5/Q2xsADBlNAoZf7/eX+t10AiqINWVA8S3scsc10a5ARUD1+Jpv8ZhldVfNJs4bPZrXv0X9vxMCHJFwUCEBdzwN1ojMu/CVOUCPbxuQm99ExYktHKVtcesW/+nHNEkLYRzUUznoApNZG/44VeBYRNNuvnPB3aE9NuOvXKJ+bQL6M4dYLI14AVbGvVZ7vAGGByy3FBXPvuFkFBFllGEef5pmsY+eZNvw5TcV3nIrmS4spxx25udRKQ+vBEb3wThzI8v2w4L3g2dBExJrBRrrkQpYz+Jz3REq2192pSNJkF75GofJxTnp+tgzZclF6pOf6sP/wA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BYa/AB1FDESC+bnG1cgihV06fAwy9m/vJC1Nb+qE8rU=;
 b=S8SuHSTCnZEDW6AF2DnZf1zi+OX/Wn6CCGW9cH5IR6pftCwUenVov88ILKvxAOSMoRD/ZS48w5CGEH3KmNzJYHpTGjxAP+H1wWL6JTWE9m/DjTHoCCt7sOzxavRinXVLLg09nMl2VD3tdHIfKADP9poC6u0XXKGOUxQ08LdGVhQaoXBb4xlz60Rg/L/dEX654IG43iWcJdZFKrmsyEDkbU/UyCIGljPPYh8BAlEM8WQVDbI6NeCgtYJny4ryPI8Cx6MyH7jPG5CgwaOnTZfVG+Oz3rjBFgZpqiNWWpKGEowWUB7WYGHJSSnP8yEB5Hf5xb59nOEYH5SYBmOv797TGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by PH7PR11MB6547.namprd11.prod.outlook.com (2603:10b6:510:211::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.35; Mon, 19 Jun
 2023 09:28:36 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::4707:8818:a403:f7a9]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::4707:8818:a403:f7a9%6]) with mapi id 15.20.6500.036; Mon, 19 Jun 2023
 09:28:36 +0000
Message-ID: <0ec4d1c2-d88c-7f35-0776-d2f57821cbd4@intel.com>
Date:   Mon, 19 Jun 2023 17:28:26 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v3 10/21] KVM:x86: Add #CP support in guest exception
 classification
To:     Sean Christopherson <seanjc@google.com>
CC:     Chao Gao <chao.gao@intel.com>, <pbonzini@redhat.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <peterz@infradead.org>, <rppt@kernel.org>,
        <binbin.wu@linux.intel.com>, <rick.p.edgecombe@intel.com>,
        <john.allen@amd.com>
References: <20230511040857.6094-1-weijiang.yang@intel.com>
 <20230511040857.6094-11-weijiang.yang@intel.com>
 <ZH73kDx6VCaBFiyh@chao-email>
 <21568052-eb0f-a8d6-5225-3b422e9470e9@intel.com>
 <ZIulniryqlj0hLnt@google.com>
 <dfdf6d93-a68c-bb07-e59e-8d888dd6ebb6@intel.com>
 <ZIywqx6xTAMFyDPT@google.com>
Content-Language: en-US
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZIywqx6xTAMFyDPT@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR01CA0037.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::9) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|PH7PR11MB6547:EE_
X-MS-Office365-Filtering-Correlation-Id: 15f63fb3-2326-48cc-d2c8-08db70a78ee6
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Eh2Y/vB/qdybEzTSN4olUj9kfLbZrsYxgnhsdXH2kKS79Rr4F7DLvucvWdkOOqOzIRtijy2MjbGHyQygKtAh4WSNwbgjjmhe92WzvmeILu73pBKIHs2ivpnjslh9CCKHepwT8CVeDDmBJ0zMwn964T1eZa+Xovv2IMXxkey9cuLLXCgFBFyxPiBNJGG2u3FNhdacad335JOUbk74xN7oG6gMqlKnG91Ri2tUISYvB4H5CIVciw+Ix8zcYPCzdKiiuk1/OXsdXePUb/8wuXm8qAm+v7pd6IW8GMzSXypV6QVFfpcf0JfKBSI8gnEF1RS8GLhtru7WPr4cEoYxigaH/RZmijTQPg37SdhvQejLhQDErmY3bvOynxrnD4mzc85ILChL0xQSdFZhRGTtRMPDpl24kHTFOWZ22e1ihvBpsK2TQgnfo9IQ09D0N49lwxOFanSVRxCv5j98lPfq3XoabBH+XxNITP0nG2iIvmxZPOLgMXpDRFQYBfOpLiy37XocrtC/r7Dy55sIlcCJUO/+3bkvmuwtCFE6HdBfIaAxGXbGvDZ/PqWbI8JgrFBduO1Y4qc5R/BvFGa9QDu6ZCRQz2h7TDFuCXmPj/PXBeDIVFJzaPrVYSN9Arc1pwgJFuFUHGbh9K/Q3VXjCT53/26qug==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(396003)(136003)(366004)(346002)(376002)(451199021)(31696002)(83380400001)(31686004)(6486002)(6666004)(38100700002)(316002)(8676002)(8936002)(2616005)(36756003)(6512007)(6506007)(86362001)(26005)(4326008)(186003)(41300700001)(5660300002)(6916009)(53546011)(66946007)(66556008)(66476007)(82960400001)(478600001)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Mm15SGpDZXMxRFhCN1ZoSnpibHExdGtHNzBmR1lobW9ub3ZrWk5URitNbWY5?=
 =?utf-8?B?Y0JqOFZGc0o0QWhhUmdLQ1p5Yk5EU2JYdmV2bTVEN1haWWd2WDlLT0V4Y1Jr?=
 =?utf-8?B?aVVDQXFELzN0djBKd21QbUY3RTFXdHFIOEQ0alltYStZc2s5NDh1OHk0WVFn?=
 =?utf-8?B?U2pTS3A4NlNNS2hUOHBuZ3pTSXZTc3BaQTZTQXJQNG5HbTlhSkt4T1VNTGxu?=
 =?utf-8?B?RHlxRVFHRmpyZnhmT1dKTDNiVElkdjdEWXJGZTc5QTBTWjVibXV2ODAzajc3?=
 =?utf-8?B?MldtRWU5MGM5L2FpbTY2RDN3dkxNTjBpdzhXb0prQUo2bm9IT2g5bDVzaHB6?=
 =?utf-8?B?bjdteEJtMHl5UG9scVFZWVBHQW9maDIwQjQ2L1ZLNDhmbTA3VkpmMnhqRmtj?=
 =?utf-8?B?YXIwcXY0Tk9FeTBXRy9mSFNBVFR5M0hxN3ZmSWVIL25RV2lneE94aDdUeE5w?=
 =?utf-8?B?ZGdKYlBHd1JIREEzczVIQk5SbmNxS1hqTWgwMHEvRTVtNzBXbkFiVjBiSGM3?=
 =?utf-8?B?Ti95RFo4TUFhQ1J4Y0hLNW9haVc4d3ZLMkkybXJRc3JBRk9vbUIxZElkRmRV?=
 =?utf-8?B?RExUcTdsRjU4eWl5NzdrRHJoNDQ4eDFSeDlyd3lvUElDMU5kWmoveDE1VkFi?=
 =?utf-8?B?ZndGbHBsczAyUy9PLzAxUUVZSkxLM3lRUWNMY1dGODBJdFFBblZ0aWEwTG44?=
 =?utf-8?B?K2ljQjdKUVN1bUhhdExTdE9HaTRKSkdOZndwTzgrazNHcTBuUDZMMHVDdHY3?=
 =?utf-8?B?ZzNMaFJ6RmlxbGNLL201cTVjeTRPY0dqc1B3dmxZdlROcDE1M09McG02d0xz?=
 =?utf-8?B?RUw1ejBFcWxIN3pBQTUxNCtCQTdCQ0VRRHJjbUREc3p2anBZbjQ4bkpQUi9U?=
 =?utf-8?B?eHZpL09SQjhqT0hObGhkb2xaQjZSRE5mOEpTVHFXL0dYdCtTa0tsYktvTC91?=
 =?utf-8?B?TEloeFZYK0JwK2dRWUpITGk3RDJIZitjMDVWMzVndXEvOGJFMHd5RWNYcDI4?=
 =?utf-8?B?TVhoSnQ1VW9LRUNxb3pLeDMyOVdmRG9udUxJdlpQODc5VHZRVUltQTQ0OXJw?=
 =?utf-8?B?WTBMQjBJM2o5YllJTEQ3WW1NTzNidzBzRk1oemx0WVc5amQwMXNoK21IcHJa?=
 =?utf-8?B?d0JhZXl1cUIzUjc2anR2VnM2aUFzY1lVOXhEY1FkN3VHMEJHMU5PSkQ2Tlpy?=
 =?utf-8?B?Q0tSNWpML1habmRqd3FyR1JUbFlEeWU1S1JvMUFMdWdMdjh5ay81TlFReWx3?=
 =?utf-8?B?d1NxYzgzK2pXQWM3bEMvRHVueFJ6a1BtMnpRTXQrZDdTUDRFU3hTRUdKam80?=
 =?utf-8?B?RU10S3l5UGN0N3NydDlGeUpDd0E1YWQwdkdOVHcvY29YSzlWVXRRZldTeHZs?=
 =?utf-8?B?elRlTDk3MnJQTzFLV0w2VTgyR1V4bXgrVUgraWM1cTRYWG1MeEpSZjJLcURW?=
 =?utf-8?B?MDh4ZnFwMlYwNVF5WG11QnBxbW4zNGhhVkpRZlFPY1lQMEZBUE9kZGoyRzR4?=
 =?utf-8?B?MVpHUnYyZzdqenREcTJrd0VKYzZwRWkvVXd0SFhNRWlpTWwzRVVpUUwzbHNz?=
 =?utf-8?B?dlBwZGV3c203VWxTd3JBdFQ2U1BXNUJBSzRuOTl3K2wxZkpqZmM0U0h5R1gz?=
 =?utf-8?B?TFFnbnZmdHpYd2FKdlFxWm5lTnZkTnFxMkZCSWNVK3JDWlFTc3IyR1RoWlZw?=
 =?utf-8?B?OE9ERXQzWnBHRC9uUERJc0xSVmR6ZDAxbTFUbmNUU1FZZmhPaHgvUzEvOXhl?=
 =?utf-8?B?STdRdVFYSkNNMFEraFRqMy9lZUdCVVIwb2FXVTQzbnpCRnZlRW1Ra1dvdGRM?=
 =?utf-8?B?N2Nkb1o5RHVkSEI4WHovOFp0RDdaVUpibGQ3b1NVK1JFRG1hVmY1Z2RObDZM?=
 =?utf-8?B?ZkpPNm53ZzVOM3RiWFZZejZ4VThnMEh6K216M1lxTHQzQmZmazFYN0dwMll6?=
 =?utf-8?B?b3hrU3FUWTZadzhwZEg1bTJ2VC85TmNUSXE5R05hakVQd1dFekhZQnVZUkVW?=
 =?utf-8?B?Ymsycm0vQ3lJODNUSWE0azltVjVMRUliNXZodjhMT21McWZMdGdoeHlkYnYx?=
 =?utf-8?B?VXhHNHNTWmV4Snp6Zlo1eGVNRlBGVmhTeWlJNDFUampEMEFVZ3pYWjEzdnJu?=
 =?utf-8?B?RHA4ay9idktScDc3TWFpaEcvTFA4VEV5L3gzNGdYcEI2bEIwUVJqRTNhRUNW?=
 =?utf-8?B?T2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 15f63fb3-2326-48cc-d2c8-08db70a78ee6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2023 09:28:36.5632
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hubL5PQTTfMoqkXjUBGiv00hJUJQgXaoWpNNzQTHsMI3+n9hmaJqQRaS40TmW7hDxu9lCgMrnMZVELP/Yye6iw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6547
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


On 6/17/2023 2:57 AM, Sean Christopherson wrote:
> On Fri, Jun 16, 2023, Weijiang Yang wrote:
>> On 6/16/2023 7:58 AM, Sean Christopherson wrote:
>>> On Thu, Jun 08, 2023, Weijiang Yang wrote:
>>>> On 6/6/2023 5:08 PM, Chao Gao wrote:
>>>>> On Thu, May 11, 2023 at 12:08:46AM -0400, Yang Weijiang wrote:
>>>>>> Add handling for Control Protection (#CP) exceptions(vector 21).
>>>>>> The new vector is introduced for Intel's Control-Flow Enforcement
>>>>>> Technology (CET) relevant violation cases.
>>>>>>
>>>>>> Although #CP belongs contributory exception class, but the actual
>>>>>> effect is conditional on CET being exposed to guest. If CET is not
>>>>>> available to guest, #CP falls back to non-contributory and doesn't
>>>>>> have an error code.
>>>>> This sounds weird. is this the hardware behavior? If yes, could you
>>>>> point us to where this behavior is documented?
>>>> It's not SDM documented behavior.
>>> The #CP behavior needs to be documented.  Please pester whoever you need to in
>>> order to make that happen.
>> Do you mean documentation for #CP as an generic exception or the behavior in
>> KVM as this patch shows?
> As I pointed out two *years* ago, this entry in the SDM
>
>    — The field's deliver-error-code bit (bit 11) is 1 if each of the following
>      holds: (1) the interruption type is hardware exception; (2) bit 0
>      (corresponding to CR0.PE) is set in the CR0 field in the guest-state area;
>      (3) IA32_VMX_BASIC[56] is read as 0 (see Appendix A.1); and (4) the vector
>      indicates one of the following exceptions: #DF (vector 8), #TS (10),
>      #NP (11), #SS (12), #GP (13), #PF (14), or #AC (17).
>
> needs to read something like
>
>    — The field's deliver-error-code bit (bit 11) is 1 if each of the following
>      holds: (1) the interruption type is hardware exception; (2) bit 0
>      (corresponding to CR0.PE) is set in the CR0 field in the guest-state area;
>      (3) IA32_VMX_BASIC[56] is read as 0 (see Appendix A.1); and (4) the vector
>      indicates one of the following exceptions: #DF (vector 8), #TS (10),
>      #NP (11), #SS (12), #GP (13), #PF (14), #AC (17), or #CP (21)[1]
>
>      [1] #CP has an error code if and only if IA32_VMX_CR4_FIXED1 enumerates
>          support for the 1-setting of CR4.CET.

OK, I'll route the messages to related person, thanks!

