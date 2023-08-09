Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC67C7753C0
	for <lists+kvm@lfdr.de>; Wed,  9 Aug 2023 09:12:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231500AbjHIHMm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Aug 2023 03:12:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231509AbjHIHMg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Aug 2023 03:12:36 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7FCA1BFF;
        Wed,  9 Aug 2023 00:12:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691565154; x=1723101154;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=5rsEvGRuZFKhUOskBnqvwMZ1UjnYQftLOHaNX9EUEUo=;
  b=Sm6hI+YjAQlZV4kMFG9Y7IM8kIU+Wcft+Yy26CLGRl/Y6dpmTKd3xhCk
   wKVMjJyJ0BTd4FO9QEwvAc/lRCYsak0q6I71eUkjUQMwGFZ/MuPWaUjKN
   uF8kUYf5szKzrfxbVFUOWPs1MX7Q0JIvT0w8dTzvgqzaFuD1hBJFyLjzg
   xIR8rgMgUkWMxvJyoynoJD88dV3vxVyJ6YoEQioWJy4Afh9ilsY80C+Xd
   OcrWVKD05ZD+hWcpznjlEkTVkX77CtCnarjOigv4YGnKXWrKfX0JJ2nyo
   SD27v2Br0LDqIRAr54uvyzul9oyaPiUr1WtNcHckNKRSkSKrEjeCM+Zfz
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="374754341"
X-IronPort-AV: E=Sophos;i="6.01,158,1684825200"; 
   d="scan'208";a="374754341"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2023 00:12:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="905526620"
X-IronPort-AV: E=Sophos;i="6.01,158,1684825200"; 
   d="scan'208";a="905526620"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga005.jf.intel.com with ESMTP; 09 Aug 2023 00:12:34 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 9 Aug 2023 00:12:34 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 9 Aug 2023 00:12:33 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 9 Aug 2023 00:12:33 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 9 Aug 2023 00:12:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KSFk1FlZp4+amAxjaXv6u9DJFXselF+CtOml/6vDbFiJWsec7GPKj44FS5l0Y0PtBT967NFRhgUlEPe1dh+MiySXELxwjRdqL3vWEIuME9x20+yzQy/S3dH07ZlhlSYbEeKga01ZZxA3+AHI9HOYiB5XJml5W5fjl7DFfFv5GhQ36hgAgX815CjDknLAuVbnObWdHlcsAbqV688wGUoMWWetji4gBhifPp5IyMTrPQNJWEnw526g8KjbckwdFa+sGlruNBzjZ/ZZVjKZEvr7ya1kWJ4WZeemZylkVOFIMttpAtq23SEQh7ueOUCT55WtiU3bkQYj4aWLcR4CCU+zbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YezKTqNzdaeUwmhjdh9AUV63zh01w6dw380xy4zaAI0=;
 b=VPJX9U0yE/dbPZHo8Poe5+a2nsq+IEMKMHu9jV6qkt8PvLp8gZD669hb9d+/k2FWUQo8FqrJZy33GJ6WfuxmAcgn8BnDXHpT3LHTsxxnSAkxaH/OrahWulKi7qYew5m8fTdsaPuW1orHz7L1WTkyyordkhQ7dLNg54mn04HIBSUHoI1rf1Viww/aCf104mZd8TpXjrDG1GSDZATiXmXIOU26Ml6877wWmOiCBb4WazJQdl9ds8P+QqP94cP0/tukdelJTzsrpjXSrXBZeezrdBcbloHrUUssV4Fel+PtOeC78/MxjCPJtalvqJY0+KgWGlHkB83C5z2JipE7YEFR2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by MW3PR11MB4748.namprd11.prod.outlook.com (2603:10b6:303:2e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.27; Wed, 9 Aug
 2023 07:12:31 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::94f8:4717:4e7c:2c6b]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::94f8:4717:4e7c:2c6b%6]) with mapi id 15.20.6652.028; Wed, 9 Aug 2023
 07:12:31 +0000
Message-ID: <1143c305-df42-d823-fb52-4a32d39e0b7a@intel.com>
Date:   Wed, 9 Aug 2023 15:12:21 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [PATCH v5 11/19] KVM:VMX: Emulate read and write to CET MSRs
Content-Language: en-US
To:     Chao Gao <chao.gao@intel.com>
CC:     <seanjc@google.com>, <pbonzini@redhat.com>, <peterz@infradead.org>,
        <john.allen@amd.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <rick.p.edgecombe@intel.com>,
        <binbin.wu@linux.intel.com>
References: <20230803042732.88515-1-weijiang.yang@intel.com>
 <20230803042732.88515-12-weijiang.yang@intel.com>
 <ZMy2xB/RizQElStJ@chao-email>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZMy2xB/RizQElStJ@chao-email>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2P153CA0017.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:140::10) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|MW3PR11MB4748:EE_
X-MS-Office365-Filtering-Correlation-Id: a09a0ff2-9467-4475-10ca-08db98a7ff47
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zktfw/JwlL8zT7Fgy1phoV3maUKfpos9GfGFUW7ZO5GtJxeJ87U7/vwrQ2MeibYyca1mutuMdbELjVpSLNvVDP1iMlS/14kV+svUkOyuSk3T8khceIJt5eQ38BPi6KmuZPuaFKae56x+5yBqQ5v9J7O6dO1IywLZudNfINgaLJR1wJmAbIV6Q+AIntQ4QiXKCqwdchfN/iWGMeeYat+a6y/CIzSdRvAYgNSXB6RUdpJkVoAf4eU/C40rB36V9w43C/0BOLqb5XYt9E1yrlTqcZXT+eMlI5nX6/Um86+cAAJWJXzikUZf79spe5rlWegJTvfFw/XdJBkuwrOW8NVwzstvttEEM+/wwobvxGMXcquYtSAcWSj/whXXuoipdwb26VpiIJ4ZRthb9U6bCTAiXhPDaeEfCUQtdbdHFJ7SZtVG64USiOJ4iwcQ3J/zYul+fuCwBQ0zLCzhLkJNC5kw7e8RcdYLHdFnd5W/HJER+8q4YvdIWsh+5gWZeNVvNmCp+sqR/gfEq+8iHlw1cuftOYg94dlFE7xuCDIbNutF/Y0zQQk6zhDphahryGw6zHpugNt2hUWIhm1K55UVBfw7mIe1ZE7UyHuo0UiSE6cJ3TuIwoaTNawsih4YCmXS0ZwqBttRsZYgVK4OH8/phRdX/Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(346002)(39860400002)(136003)(396003)(376002)(186006)(451199021)(1800799006)(2616005)(26005)(36756003)(6506007)(53546011)(31686004)(6486002)(6666004)(6512007)(478600001)(82960400001)(37006003)(38100700002)(66476007)(66946007)(66556008)(4326008)(6636002)(316002)(41300700001)(6862004)(8936002)(5660300002)(8676002)(4744005)(2906002)(83380400001)(86362001)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?alBTMCtyU2d4bDI3R0oxcVp6S3F0RVJESzMzWERQb2ZTc1VwOStOd0pqd1FL?=
 =?utf-8?B?MkF6MVJ2NWExSnAreXZRaU9BTXd1bFFXakJvVWdNTmVMVGFKN0hUNjhQRUd3?=
 =?utf-8?B?UUVZTDN4QVZJN0tFQWV2RWU4QmlmQWZ0Njd1S2VhK0p1bDcxRmhBaXNVN1pN?=
 =?utf-8?B?UmFOZWF2WDJkWm1udGUvbzlUTGx0ZlRaQVZlRERJRGt6UGFjamZmQ0F1Vjl4?=
 =?utf-8?B?TTk4cmRSUG0rTFJnSjB5ZTg1eWJWQlRQcmpVa2N3NFhzeHYxbFVwQ0o4L01H?=
 =?utf-8?B?NVd5OTh5NDJZUHc4S0JGeU5TQ0NaZnFCUXlhUHFza3o2SGMySmpTR2xOM3lB?=
 =?utf-8?B?RmNESnltTXd3aWVyQjg4V2pBTGZaWTlFc2dvWEpHKzFyM3NrVVdzWmRCSDVi?=
 =?utf-8?B?TGRFNlZVR2JzT2YwZWp3Z21WZ0U5MjNCVjhhWHJVOFY5cVR4OCtEUzFza1hT?=
 =?utf-8?B?dEhpMXdnMlBXKytPSjRNRStWa2M3UW96bWc5UWQvMG9qNXBXTEhXQ0RlNkpQ?=
 =?utf-8?B?b21xQ2xxVEJXUm9hYUJ5TVJIelBQTEk3VTMwTFlYU1BiMVNSb0dGRm1Cc0Uz?=
 =?utf-8?B?anhoamFtczdlMGNhTS9qdzZwYTQydG5ydVR0Z3ZRNEtEcG9TYzRObU1wTnNm?=
 =?utf-8?B?UTZiejRHVlE5V0t2M1d1NW1KQUxLTEcrWHFGVUlGZUNtS000TzRmeThkQjhX?=
 =?utf-8?B?bGFjVlhyck5RU1BqSkJzNXhRSTNkZXYxMnJQZExSY3VMUHhuSFRZcVY3VU5i?=
 =?utf-8?B?Rlc1ZEFDd09OOStRbFcwajRwRG84NTNlZ25FT3ZUZDA5ZUlmbS84VU5vNkM2?=
 =?utf-8?B?S2lhc1hjRnA5d3lUQXlkUElnZFkvdGFuMTdKRkF5d3FJcjhOQVJpME5UUVhn?=
 =?utf-8?B?ZlFRTVBSejFjbG8zYlJMbHZYdzcxS1U4Z29ERWpGV3c3dGdIRnFmMmlSaXZ4?=
 =?utf-8?B?TEFYWGJtbklMclBsRHJFOUVka2lKMW9KVFJQdi9UblJocjcybFVQN2VCSzJZ?=
 =?utf-8?B?b3ZBOVROK2hRbjlyMk1PQ2l4cEF2ZlFldDNPTGJCTzhCWC9xbERoTFExNzlk?=
 =?utf-8?B?MTdVbjJ4RWRvbExlUTVxZ2laZTMyeE1EU1NWRU81TU5KYmVob3J4aWYrdHEr?=
 =?utf-8?B?SkdDMDBSVHViQjN4SlZ2Q083UElhd0tpZkF0SUpXY3loRmdyanlraXYzWGo1?=
 =?utf-8?B?ZzV1RHFnR2NJcGNWd2lTVmhMcW9qMGMwV3U5cGhWQlVWWE9ST0JSQndhaThZ?=
 =?utf-8?B?QXNhOGJQRllESGNsV3VOTmtHd0N3SU9VQzgyUlZ4VUVxanFjY3hkODQ2N2ZR?=
 =?utf-8?B?aTNVaGZuOTJEbGpFR3d3bE5INHkyTW5WWkkxZllMUFZiUVlkT1ZkeGtCcysv?=
 =?utf-8?B?aHZaYzVVOW9OWkRrMGhYSms0K29EMHpoZkVWYVNtTDJUNFNucU93MWhQeUxI?=
 =?utf-8?B?bXJBMzB4N1JIb0tjTFBKcGtKN2lmNFhFbHJqR1ZSZjU3cUl5Z2oxYXF6TFha?=
 =?utf-8?B?Y1k4eGhMUWJJNGNtaklxaGtMMzRXMWlQRlg5TjBONXc4TERWZCtxMVQ1U0tD?=
 =?utf-8?B?cWw3WnRpTmQxRng0bTgzVFVlaUFWR0NMSE5HTjlsQ2NNRURYMTJTMnNlb2xr?=
 =?utf-8?B?M3lsQmxRZ2RDNTRjcDQxYVA5Q0Z2akhPSlovQ0VpaGlmeWUrU09VblNZaGVz?=
 =?utf-8?B?Qk9CMmEyR0NhUGVHbTYyYjFKdXZOMzhGZDdBUXgxTEd2YlhhK3RYRytCd1JD?=
 =?utf-8?B?UHRkM3Z3OG1FblNZaGVtakhOaGNEVTg0QWl3bXZWaTRKYVE5WDhLa1k1eDRE?=
 =?utf-8?B?K1M4MUJQSDVMa0dBdGlhc0hqeEluWUZLb04zeUkvSDY0Q1dZMG1KTHNTcEN2?=
 =?utf-8?B?dVZkc0pUdEJWTU5PSjJsY0ZFVjUzVmloMUxsMzlmczQ1WmpTTWVkdjBLMlF4?=
 =?utf-8?B?MzJwSXp5eVJyT1ZKUFdSVUt6NHBxSENCU1pVa21rNHZkUmxxYUpyZHVYNXJ4?=
 =?utf-8?B?Z2pYZ21USFFqMWdBUk5KQkFTZE9CV0tUWHcwWHp1VkZrbXU3a3Fwbm51dVF2?=
 =?utf-8?B?ZDJqWW9FMkNRS2ZLWVN5dTdLc2ZqaG9XM0pVeHJkRUtMYmpIOWdObWcySVJR?=
 =?utf-8?B?OVFpVTB1VU9jQWxuTjBVRkN4d0g2amFpVVUyb1JCeGtTVG14TnFOZmJvZnVx?=
 =?utf-8?B?cUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a09a0ff2-9467-4475-10ca-08db98a7ff47
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2023 07:12:31.5523
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z41APiFMjTvnNaz1726sYn3KtZsUYUeRNoPckqJus1AdMh83jRDIzr37EuD9uSYrgamUX0NT5LtVrxS1GkXKVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4748
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-6.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/4/2023 4:28 PM, Chao Gao wrote:
>> +	case MSR_IA32_PL0_SSP ... MSR_IA32_INT_SSP_TAB:
>> +		if (!kvm_cet_is_msr_accessible(vcpu, msr_info))
>> +			return 1;
>> +		if (is_noncanonical_address(data, vcpu))
>> +			return 1;
>> +		if (!IS_ALIGNED(data, 4))
>> +			return 1;
> Why should MSR_IA32_INT_SSP_TAB be 4-byte aligned? I don't see
> this requirement in SDM.
It must be something wrong in my memory, thanks for catching it!
> IA32_INTERRUPT_SSP_TABLE_ADDR:
>
> Linear address of a table of seven shadow
> stack pointers that are selected in IA-32e
> mode using the IST index (when not 0) from
> the interrupt gate descriptor. (R/W)
> This MSR is not present on processors that
> do not support Intel 64 architecture. This
> field cannot represent a non-canonical
> address.

