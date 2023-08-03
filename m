Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F31376DF91
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 07:11:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232085AbjHCFLy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 01:11:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbjHCFLt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 01:11:49 -0400
Received: from mgamail.intel.com (unknown [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EED6A1;
        Wed,  2 Aug 2023 22:11:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691039508; x=1722575508;
  h=message-id:date:from:subject:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=5WTGYQYQaMcdR/WihX0XQ+355U2Af22hiP81AZNHCFI=;
  b=Zjh79DchUphIJNexgbzhAwRa0rKLgKm+PNabC7zOeUOGjddnLL2Tshxx
   GL2hfX1zAx/WG57Me0p4u3t2LapsMUqm+pudSe+FUJsV4eGsIVmmaqf8N
   bdVN0CH91lZrQUPhNWRYZWgiRnAi3dD86wey61lavtDHp0J+0hhh8T8vN
   CKWm3sDXp0RSO3psItb88w1UbEZQ95vLtGZoOC/t0Ty/DGA/f/lgU5Ujw
   zn8PlGLG7zAasnneFbMQpGIiLZ5q3PNhIFD7cumjjivELoe5ZToYIV2Ge
   u85461ocwKSTNeJI8cPdgj//MykZ4lrIa1UQGTYUZM4G0wa4zx3TjA4Rm
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10790"; a="359809893"
X-IronPort-AV: E=Sophos;i="6.01,251,1684825200"; 
   d="scan'208";a="359809893"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2023 22:11:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10790"; a="853106229"
X-IronPort-AV: E=Sophos;i="6.01,251,1684825200"; 
   d="scan'208";a="853106229"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga004.jf.intel.com with ESMTP; 02 Aug 2023 22:11:46 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 2 Aug 2023 22:11:46 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 2 Aug 2023 22:11:45 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 2 Aug 2023 22:11:45 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.103)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 2 Aug 2023 22:11:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QWsDqejb6dnnTHD9QR55m9MPwygdyOtMKJwe5Y5PlEDJACiXKOe8l8wa1PZ1R1mOy+6q+3WgA46lEFax5D6NKV+vYx0VO2CEuGiWnglEPaMrcAkRPI0hChlLlRVpvf4NJ66Na8OEJt6JwyHRW+Sah7o9uNkpXxaXTiyxjiEv1Yox4Tyl2VUl96QMulowkv937IMSFjHv2qdSX0s3VpDyK729PJWPJYIfI2iTLiHUerOEioHoPdxS2vHDDH6CjGiJ0CRZG3xAhACtSbPU3sk8GxDGF6smTVlHXu1EALQLfQyyoMhqfBfKQtWRi5ZXE6tzEWJ8l+j1avt58AFxoz7YFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CnRkA5hzowUt3CsaJMe/z4E5pdGtDkQbTOgMNG/lSvE=;
 b=Jf1cF/OBmaQDMjzk8IckkmLyjhAnfsG6KEvI3AfUvkpHSdtTL7lJB8Y2N8JZmGrNQb5uvcO/uyYawp163Dh83YMC19q2HYIWVIps4MCHqjyBHEVit5k8x1/ud4Awi7vBjV2QWi6BTZBhZx0ELoW/mr/+hXYZsn8HPQzJEqwATSqKCCbRR3t+MSRnbEqVjqHlYku1sNUlL4deh4FsXjDaBLSeDBpyKJ3eJd56A2OVaub94xCN+pdJWcmPIPtROOp3min+qnE2hERvqLvHsxf4FskGaetUrwkGTVek9a5JAupfpHySPlvPmAtIdxNmuk86+m9uJJT1FJrP26CLvnGI2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by CY8PR11MB7946.namprd11.prod.outlook.com (2603:10b6:930:7e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.47; Thu, 3 Aug
 2023 05:11:43 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::e19b:4538:227d:3d37]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::e19b:4538:227d:3d37%6]) with mapi id 15.20.6631.045; Thu, 3 Aug 2023
 05:11:43 +0000
Message-ID: <481cee78-d058-119c-1e5f-06315d296b06@intel.com>
Date:   Thu, 3 Aug 2023 13:11:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
Subject: Re: [RFC PATCH v2 4/6] KVM: SVM: Save shadow stack host state on
 VMRUN
To:     Sean Christopherson <seanjc@google.com>
CC:     John Allen <john.allen@amd.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <pbonzini@redhat.com>,
        <rick.p.edgecombe@intel.com>, <x86@kernel.org>,
        <thomas.lendacky@amd.com>, <bp@alien8.de>
References: <20230524155339.415820-1-john.allen@amd.com>
 <20230524155339.415820-5-john.allen@amd.com> <ZJYKksVIORhPtD6T@google.com>
 <ZMkie3B7obtTTpLu@johallen-workstation> <ZMkymz22bHTsFCTD@google.com>
 <ZMk6xzfVF0C+sTuK@johallen-workstation>
 <580d2f69-a282-9b01-cd2d-0c46d9e1e8dd@intel.com>
 <ZMqGd582DGxOvmBG@google.com>
Content-Language: en-US
In-Reply-To: <ZMqGd582DGxOvmBG@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR04CA0001.apcprd04.prod.outlook.com
 (2603:1096:4:197::12) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|CY8PR11MB7946:EE_
X-MS-Office365-Filtering-Correlation-Id: e2c50f31-1671-49df-5af2-08db93e02075
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6jJoXiM+mQdc9WtsPuQvN0ylYhncqx4sreFTPGiYkCMQ2khEjkpIWYqgaGyQUeRBDYs5fWCf2WVzlgZJb5yJfWNNulRQ/s8xVz4SqyTNajz4vBYocRHZUD9iPmmqFLBQmQ64tUdqR/AdglyNqFLHGiXfC6LQ6guMqcDx72AwfABCStH2h6YtSCU/VXWn9/stsf7/vqnt+KrM8D9HYWYiqqnbWe37BbVAuJjzQWIOkcDcKAdPa4ivnmbxqGaoSwz+HWVcqzTTWm7+GNDSzbP7DYGCD5RNNWKTcgxPv2nXCZGnWyOoFBgh4n9yzS9QDtJG1/PVlhXRmZUJVWGfES3pmeF88PsC+K6uOesbM2eWiaIqVpwaQDlqxvjeTbAC+jRfIkJRWLCsWKhiM8H8DNYFteL3IVM6Ef+v376gFtCz0iDhWMoB/yeMcqfmPCVK+7D1a4eUIyOR9Sai7QE/7DTYX8SQmkHqybqjQfY55G3kvs+dgHBEV3sN0NxeaOgg8B381weE94u1++NB000/ojN9j1SfrGD0ZK1sVsqQroATP35FHwMEb2vXE4EmUREg6jTnPpBclj7kkq+m9agb/DoQ8RDfKbTlX0VE4EXJuRwMeQRSMY+ptS9dekDZr039jco2397GKPVG2ga4zo8fWrfrBA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(136003)(366004)(376002)(346002)(39860400002)(451199021)(2616005)(53546011)(6506007)(83380400001)(26005)(186003)(316002)(2906002)(66946007)(4326008)(6916009)(66476007)(66556008)(5660300002)(41300700001)(8676002)(8936002)(6666004)(6486002)(6512007)(478600001)(38100700002)(82960400001)(36756003)(31696002)(86362001)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dzZTdVJsMHo4TkVpczdkc00xNTVsdjhnb0t4eVR4aU1JbWtJZE12dnBVVEtv?=
 =?utf-8?B?TEwrL1h1S0JQVzBRSFB0b3hPYjRUUldrVDVZNm8vOGpvdXVQeEdFT0JNOXgy?=
 =?utf-8?B?WU9MKzkvTHJkOGJMcDNGVkRSbDJTM2dySTRuTGJSTU1EZERIMkFHY0RhMlBY?=
 =?utf-8?B?OC9wVExDZndhc2pWVUZtcHRhcERyQ1RHUVE5TGpVajRiaTJjT1g1VlczNWd4?=
 =?utf-8?B?aTNFTlVCTmZTYkNhQ0ZXMWpzZkR6dkhHWFVlSHZNMndiVVhqemY1RzRrb2I4?=
 =?utf-8?B?OHAzRUNNeE5tRE95V25NUTBMbXlhMnNLbzlKYzJhdms1NnJwaG05VzdqKzk3?=
 =?utf-8?B?WjNFaFAxSitDdDFvaVBQS205YlI1Q3V2RDhZYzFVdHFlYU53VVFDZUpEMCtR?=
 =?utf-8?B?amU0YWdBZ2krRU9GQ1kwWDNocW9aU2drTlZhSGZ5MmFnaE4wM2pmU3kzZnBS?=
 =?utf-8?B?bDBiTm04TFdWNDQ1MndSUE1DMHpWK05kY0JlY1k1cmdrQW11RHZCMDdtRHN4?=
 =?utf-8?B?bU5yWmc2NkN6S3l4T3lGVDZRRXBKYUhZWUtyakgvRXdIelFvUWxQNnRRYTlh?=
 =?utf-8?B?N3BmL1RuK1BhRUNpUk9paTUxbmpjdUxMMndyclYwc29TWUV4Vk1YN2V5bC9H?=
 =?utf-8?B?OUpqWlJ4QjdlczJ1REdtS3dRRHFtUjNEdG0wRExhSnhoNXRrTXltc3FvZGRE?=
 =?utf-8?B?VHM4NzZOUlp4T0VzY3RnSEI4cXJ2d2JYdzR1NWh1UjlFSkNNRjcvWk9HK04w?=
 =?utf-8?B?ZTc2bCtqUWJFQ2pRM1hZN2tmTms1Znp5eXkwNUxUUzludWhsZkhPY1hNaURI?=
 =?utf-8?B?YmpEWjEwcFFhR0VHaC9kQXJONktSdkJUZlFQK1RRdGsvamdxeHZ0WE92cWVW?=
 =?utf-8?B?bFZtcVJlNlhiMStFTnQySUFBSkVKREtMR3JCc1FNcE1uUDMzSjZpZHFhRnVN?=
 =?utf-8?B?cW9aUlZsdk5iMEsyb3hIdlM1NFpYTUJ6ODBmK3NOV25oVndNV0VQUjM1UDFl?=
 =?utf-8?B?SUZWNFlic2kraUFCVFNZeGlUQldiSDJlTzlkMnN2eDBtaEhMcnNzVUt4Nnl3?=
 =?utf-8?B?Yko2SEw2SVo5UU9qLzZpaEZXVDByZWh0SGN0eHd2d1hXMkRCYTJSZWc4Y3p5?=
 =?utf-8?B?cU1xbU1kQTFJYit3MHJPdFA1bmtyMk5tQ0czeENMRXJqeEx6ZVg4eUp2aHQv?=
 =?utf-8?B?bGJXSFl2aGhvNlVIOGJTVURIbVJ4OEhCL2wyNStDbHhsR0Y3TmU1dEJPTXdU?=
 =?utf-8?B?Q3lOL0dxYUU3ME8yOUtYbzBCYllYVWY1cXRUYzQxTjYxYnNyVU8vd2tvWTVH?=
 =?utf-8?B?WldqU1pTUjBkcUZETWlvWUNmMEFkL0o5dkNDWjBFNWFxL1pFdDNxaG93dlhl?=
 =?utf-8?B?RkpnRW1qSTJ0VS9VaDFCWjVVMktjR0xFSWpZOFRuSnh0a2N1dlRUUzd4Q3Rh?=
 =?utf-8?B?Ti9sRS9QM3VRdnhSUjVLVzFFOCtJdUhoemI3TkVEWkpIQm5hWDhqaHdDWUcy?=
 =?utf-8?B?RzRTcU0xTVBJK3hKK1VpcnJ3bGJuL2dYcnNhVG9uUWhtOE84aDg2eE8wSW4z?=
 =?utf-8?B?OTdGZ2Jodk5oNUNhbXVCN1ROeWlwaVM0SDZyV3FjU1lBUHgxSWJkVS8vVFQ4?=
 =?utf-8?B?cmdHbk0yelBXc3k2amRZSWpDcjhGLytTdlBlVTNLL3V1dDltejc2VWVhRlJH?=
 =?utf-8?B?NzNYaUIyY3dPTVBxeVdYcWNDb0taYjNpVm12Nm1UL0Y5TkNoZHhTejc0UDFD?=
 =?utf-8?B?aGhYekVoNkFKNHI3OFIxT2swQjNkNUhKTzBlNEtFdkg2RTNRa2xtQkE2SHdF?=
 =?utf-8?B?WmlsZ1B2ZEY3ZE1BQi9wV2pYdnRsSk1IeUNCS3Q4MTdOcldSWi9mT2dvemF3?=
 =?utf-8?B?RzFzVU1ERHNmTS9yRTVNbEhOOUtFV1hlWVcrYTdZanRERVh5cVBqNmVrdHJT?=
 =?utf-8?B?SkhKVXpUQkE1cHJUWFZqMmJGNWhGSWxNMlRPcHpBVlNmbVExWTJJWnRoQU1H?=
 =?utf-8?B?bmlVRklQanZCUWV6YUdYeGh4TkIyZXhaTkkvU20wMzlkMUtOY3YzblpqL2ZP?=
 =?utf-8?B?S2R6OGJpeXJ5bEVBN05nVnJjVlh6OVJmMVRiOFhsc2Nuak1USVdsL1lEMVJh?=
 =?utf-8?B?ZVkxOGlLd3lnZ3hmWW9ZcGQ1SmE1RGJzQXc4dU5vODIyWlA4WnBhdGJTRTBa?=
 =?utf-8?B?aGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e2c50f31-1671-49df-5af2-08db93e02075
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2023 05:11:43.3314
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HVwXlh55RL+hjErb45tdWqZIQWgsmXHL+XAWI/P0k5mNc/vx8CQuY3qeHLJCciSMWHGDVDTYOakiCnGXo9WKJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7946
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/3/2023 12:38 AM, Sean Christopherson wrote:
> On Wed, Aug 02, 2023, Weijiang Yang wrote:
>> On 8/2/2023 1:03 AM, John Allen wrote:
>>> On Tue, Aug 01, 2023 at 09:28:11AM -0700, Sean Christopherson wrote:
>>>> On Tue, Aug 01, 2023, John Allen wrote:
>>>>> On Fri, Jun 23, 2023 at 02:11:46PM -0700, Sean Christopherson wrote:
>>>>>> On Wed, May 24, 2023, John Allen wrote:
>>>>>> As for the values themselves, the kernel doesn't support Supervisor Shadow Stacks
>>>>>> (SSS), so PL0-2_SSP are guaranteed to be zero.  And if/when SSS support is added,
>>>>>> I doubt the kernel will ever use PL1_SSP or PL2_SSP, so those can probably be
>>>>>> ignored entirely, and PL0_SSP might be constant per task?  In other words, I don't
>>>>>> see any reason to try and track the host values for support that doesn't exist,
>>>>>> just do what VMX does for BNDCFGS and yell if the MSRs are non-zero.  Though for
>>>>>> SSS it probably makes sense for KVM to refuse to load (KVM continues on for BNDCFGS
>>>>>> because it's a pretty safe assumption that the kernel won't regain MPX supported).
>>>>>>
>>>>>> E.g. in rough pseudocode
>>>>>>
>>>>>> 	if (boot_cpu_has(X86_FEATURE_SHSTK)) {
>>>>>> 		rdmsrl(MSR_IA32_PLx_SSP, host_plx_ssp);
>>>>>>
>>>>>> 		if (WARN_ON_ONCE(host_pl0_ssp || host_pl1_ssp || host_pl2_ssp))
>>>>>> 			return -EIO;
>>>>>> 	}
>>>>> The function in question returns void and wouldn't be able to return a
>>>>> failure code to callers. We would have to rework this path in order to
>>>>> fail in this way. Is it sufficient to just WARN_ON_ONCE here or is there
>>>>> some other way we can cause KVM to fail to load here?
>>>> Sorry, I should have been more explicit than "it probably make sense for KVM to
>>>> refuse to load".  The above would go somewhere in __kvm_x86_vendor_init().
>>> I see, in that case that change should probably go up with:
>>> "KVM:x86: Enable CET virtualization for VMX and advertise to userspace"
>>> in Weijiang Yang's series with the rest of the changes to
>>> __kvm_x86_vendor_init(). Though I can tack it on in my series if
>>> needed.
>> The downside with above WARN_ON check is, KVM has to clear PL{0,1,2}_SSP for
>> all CPUs when SVM/VMX module is unloaded given guest would use them, otherwise,
>> it may hit the check next time the module is reloaded.
> Off topic, can you please try to fix your mail client?  Almost of your replies
> have extra newlines.  I'm guessing something is auto-wrapping at 80 chars, and
> doing it poorly.
Sorry for that. Some of the blank lines are added by me, and some are auto-added by the
editor. I changed the settings and will avoid to do so.
>> Can we add  check as below to make it easier?
> Hmm, yeah, that makes sense.  I based my suggestion off of what KVM does for MPX,
> but I forgot that KVM clears MSR_IA32_BNDCFGS on VM-Exit via the VMCS, i.e.
> effectively does preserve the host value so long as the host value is zero.
>
> Not clearing the MSRs on module exit is a bit uncouth, but this is more or less
> the same situation/argument for not doing INVEPT on module exit.  It's unsafe for
> a module to assume that there aren't TLB entries for a given EP4TA, because even
> if all sources of EPTPs (hypervisor/KVM modules) are well-intentioned and *try*
> to clean up after themselves, it's always possible that a module crashed or was
> buggy.  I.e. asserting the the PLx_SSP MSRs are zero is simply wrong, whereas
> asserting that SSS is not enabled is correct.
OK.
>> @@ -9616,6 +9618,24 @@ static int __kvm_x86_vendor_init(struct
>> kvm_x86_init_ops *ops)
>>                  return -EIO;
>>          }
>>
>> +       if (boot_cpu_has(X86_FEATURE_SHSTK)) {
>> +               rdmsrl(MSR_IA32_S_CET, host_s_cet);
>> +               if (host_s_cet & CET_SHSTK_EN) {
> Make this a WARN_ON_ONCE() and drop the pr_err().  Hitting this would very much
> be a kernel bug, e.g. either someone added SSS support and neglected to update
> KVM, or the kernel's MSR_IA32_S_CET is corrupted.
OK, will change it.
>> +                       /*
>> +                        * Current CET KVM solution assumes host supervisor
>> +                        * shadow stack is always disable. If it's enabled
>> +                        * on host side, the guest supervisor states would
>> +                        * conflict with that of host's. When host
>> supervisor
>> +                        * shadow stack is enabled one day, part of guest
>> CET
>> +                        * enabling code should be refined to make both
>> parties
>> +                        * work properly. Right now stop KVM module loading
>> +                        * once host supervisor shadow stack is detected on.
> I don't think we need to have a super elaborate comment, stating that SSS isn't
> support and so KVM doesn't save/restore PLx_SSP MSRs should suffice.
>
>> +                        */
> Put the comment above the if-statment that has the WARN.  That reduces the
> indentation, and avoids the question of whether or not a comment above a single
> line is supposed to have curly braces.
>
> E.g. something like this, though I think even the below comment is probably
> unnecessarily verbose.
>
> 		/*
> 		 * Linux doesn't yet support supervisor shadow stacks (SSS), so
> 		 * so KVM doesn't save/restore the associated MSRs, i.e. KVM
> 		 * may clobber the host values.  Yell and refuse to load if SSS
> 		 * is unexpectedly enabled, e.g. to avoid crashing the host.
> 		 */
> 		if (WARN_ON_ONCE(host_s_cet & CET_SHSTK_EN))
I will keep these comments as some hints to end users when something unexpected happens!
Thanks a lot!

