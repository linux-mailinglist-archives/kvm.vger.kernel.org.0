Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 597A87785C0
	for <lists+kvm@lfdr.de>; Fri, 11 Aug 2023 05:05:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231659AbjHKDFK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Aug 2023 23:05:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231634AbjHKDFG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Aug 2023 23:05:06 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CA342D66;
        Thu, 10 Aug 2023 20:05:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691723105; x=1723259105;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=JwfIEwrTz0IcyohUG9eMruwUZb6T5WWKwe82FgYBngc=;
  b=PVgGe/sYYV/9a93xMUyNGDkuVVp2gzRzLNaQEc3hzRxIBxYzTtJ9txhs
   vCpI4GdZa3/+Mr8h+JC4qhQXdJeSHyCSzfYZZJi6DSdB0nmoT2icIUIYB
   7r8AK0QTqCBlpAfXJ9ncrVbTkwEcLSNm1aVuBsgmda18m+Zf3FMuScbbk
   wrTHYyvZmVzD/WA0haKRQyYMv7vnbkDD1Hif2B6Z47y5C5Sudy1d0ak9q
   cHR2EQvg8s6aiCm2cNWnF679Rbvooc0ET1NhGk08kKCu+OZ55JiKestNg
   kWdKYdyLZydNJVo44WfNlN0TSeOW54bizvUwQ9U8WR7dRrKef+9yuV8vr
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10798"; a="361719315"
X-IronPort-AV: E=Sophos;i="6.01,164,1684825200"; 
   d="scan'208";a="361719315"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2023 20:04:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10798"; a="767501646"
X-IronPort-AV: E=Sophos;i="6.01,164,1684825200"; 
   d="scan'208";a="767501646"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga001.jf.intel.com with ESMTP; 10 Aug 2023 20:04:11 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 10 Aug 2023 20:04:10 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 10 Aug 2023 20:04:10 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Thu, 10 Aug 2023 20:04:10 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.170)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Thu, 10 Aug 2023 20:04:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V8h09zJEiZI9X4oubOtgvvm0hxgAVwEEXLSAyqn7YNaUlNbQFfofJ9wACxBbGzTowzMFG4ZaebTlHjrL8Q5qZQ46pdtcs8cokUjeWKXCpbAyPhOTAYtvTcr74BKdckGxusdxcnK/09d62tPNrPbs5BCeTIngC3vx0ISOCSRa2/kQjLNrPV6/l9G7QGjpSGsU/BGvhKyY4oetiJdgkbsSHOYX9BvB8CG6UO5rY5ioxUDdC8dsOme57+hU0uRiAtkK/ag2qqCPNDBCv0uG3lHNiMGJxk5C1wvP/GHXsaAfbBpenmW18OlJatcTTnNseCA9g9beePFu83q28aiP6dLmUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JwfIEwrTz0IcyohUG9eMruwUZb6T5WWKwe82FgYBngc=;
 b=CWA4gQ5UpsqTJFg9zfRc9xmfCofpQ+E9pItON4vxnvV3o+LksgOE0yS3lziEqHz8Sqm6C8SA05Y0BR1+cs3W6PPKMPw4Fz6/7IX7Oy6zNZyyiwT67E7hnZz5WsNyD1tc851dvM6zfI8SF1DztfJ0uWw9V8222KE+3l7ZDMbSlsxLWzwqZY8eml8Mt76lTkjv2BWCn2oOwyXZYYD649sXDSp5MvGPOH9IcEMVCuFgPXY1AhIGL/zySMXce+zh+940P6UTCenCpMELwqetd79jJ8pN74UKEaeNRnnvviGgUIDe+YGMH9nZXE97jnESFSa6qFskXXEI2QB69Gq3j/rn1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by DS0PR11MB7959.namprd11.prod.outlook.com (2603:10b6:8:fd::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6652.30; Fri, 11 Aug 2023 03:04:06 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::94f8:4717:4e7c:2c6b]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::94f8:4717:4e7c:2c6b%6]) with mapi id 15.20.6652.028; Fri, 11 Aug 2023
 03:04:06 +0000
Message-ID: <c014fd8a-5456-478f-b643-44cfff27f931@intel.com>
Date:   Fri, 11 Aug 2023 11:03:53 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [PATCH v5 09/19] KVM:x86: Make guest supervisor states as
 non-XSAVE managed
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, <peterz@infradead.org>,
        "Sean Christopherson" <seanjc@google.com>
CC:     Chao Gao <chao.gao@intel.com>, <john.allen@amd.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <rick.p.edgecombe@intel.com>, <binbin.wu@linux.intel.com>
References: <20230803042732.88515-1-weijiang.yang@intel.com>
 <20230803042732.88515-10-weijiang.yang@intel.com>
 <ZMuMN/8Qa1sjJR/n@chao-email>
 <bfc0b3cb-c17a-0ad6-6378-0c4e38f23024@intel.com>
 <ZM1jV3UPL0AMpVDI@google.com>
 <806e26c2-8d21-9cc9-a0b7-7787dd231729@intel.com>
 <c871cc44-b6a0-06e3-493b-33ddf4fa6e05@intel.com>
 <8396a9f6-fbc4-1e62-b6a9-3df568fd15a2@redhat.com>
Content-Language: en-US
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <8396a9f6-fbc4-1e62-b6a9-3df568fd15a2@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: KL1PR02CA0016.apcprd02.prod.outlook.com
 (2603:1096:820:c::21) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|DS0PR11MB7959:EE_
X-MS-Office365-Filtering-Correlation-Id: aac0044c-df5f-449c-3925-08db9a179fdf
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ScFK50ktsRbu1H8gDxuooVWMMZIYWwnxbWhWXjlhG8yE+RYhEnvobt7w54clxPYIOBC8kcpkaQuU9ChYF0J+obRFylf5DHNzCVt6DDojqnpOYzKBVoYnubgMNhUk9f/YETLr8A1ax6qgSL7sgNNKiN0Ko1Y2bpQ+tqLk15DlMUlriNrY/FRT9lu509MpisO8fbyUHAxqS3kNDcRUUjk1Iy0SVUrsepOgffYx+9hySjif/nav6YcK84B7fD8R+CGg8tcqVXQRm9LIpv3hZ1AcovraCp7dOZjmLO1DmXo08oyWYnWDylZjL5ezxPuveLbmw4LR+uKCb/cMkXFXR+kEKALupmv2HE4EpR/2s/0+AWsbTSrmsER4aKkneF0sLI8tbJ46DR0jg2LhTR85/QTgj+6ZzXR68r/mZJqfRPh/kIuE7rhO4UimK1xLpYTh4z3E+sb4Udt1xXb7fV4CpNOd2UaeFBPOnY9ExW1u//edQ2+0CP4KqwThXr2MJ+TCCSToUwoF+4+5lpbhVU1zRNSLgm3pFuz3KtM05O447YufGApyHkGkAp0qHENUs/OeyBFHa/1xN9KuNCEUDFCw0XTo7oSzaiPgoyeTCJM4AivsFAiGif0cC0/wWUi2gSYFCzaIJBPeWhWNc/8HJQt+BL4o5A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(39860400002)(136003)(396003)(376002)(366004)(451199021)(186006)(1800799006)(53546011)(36756003)(110136005)(6666004)(478600001)(66946007)(66556008)(6506007)(6486002)(66476007)(26005)(6512007)(4326008)(2906002)(41300700001)(316002)(5660300002)(8936002)(82960400001)(38100700002)(8676002)(86362001)(31696002)(83380400001)(2616005)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K2NvWGd3NnEyQklMcktTdnlwSVlwa21mNlpickZacHVJK29Ibk9yb01wbTdF?=
 =?utf-8?B?K3IrY095dWVuTVRlZ2RoRkpVcTN3NWtReFB2QklyYlorRXJlbGpoRkYrdjRh?=
 =?utf-8?B?V1ZoUElkdkxmTUFBcTBkcWNFR0NBN0JwWGtReExoMjkvTFczMWt1TmZ1b2Ro?=
 =?utf-8?B?VXBmZ24xN2lzZzFmcjNHVm5WWnB3K3huNXFDUGRRaGVQemFEbTc0NWM4eDB2?=
 =?utf-8?B?cWhkM2dSaGxGS3JqVVR3ZjBKUWNoVWpqRVp0ZW85WkNjVmExUFdhVzlpVjRZ?=
 =?utf-8?B?bW03eThUOUVLK0JOVktlaG9DaElVUk5oSjIvWm1XVVU1ZXZLVFIvWlpLY0lr?=
 =?utf-8?B?RG1idU93c3ZsYU1HSlZXRFhHZkY5aWdIWEY5blUzbGYwNWtZWi9OcGRSSC9L?=
 =?utf-8?B?dWJSbXN4V21oTXJNN2FPNUdIZUhlSTZlUEVBWlZvUzVmK2tDcjAzeUc0MGMz?=
 =?utf-8?B?bmxaVDZIU0RiL2JhZGd3OGpsQ2oyUXRXbHg2MWpwdG9UcnNzN1hjeUpLaEl0?=
 =?utf-8?B?V21BbE93Sk51QnI1UW1QZjhPS2lZMTZ4RklYdXNZUk8zUkc1SzhaL1BzM2VM?=
 =?utf-8?B?WldxZ3Qra01NZVppYjNrNHNmRHZyRU12RGVlVURQeXlVNFFEZm1ZU0NqbnhU?=
 =?utf-8?B?K00yTGx5UXJycE8yZlNyZjl6WWI2dnEvbTZqRUtpQ0duV3BaU3BWM0EwNjl1?=
 =?utf-8?B?THhScXhVeHd6RkFlSGxYMUVmYkVlN09KMHFZTjdTYW9rZlR3cGtQSkVDMXJu?=
 =?utf-8?B?ZGc0NUlkbjVTWS9rc2R6bUNQTnpBa0pJcTF4eWFZWURkYjgxQWswekFPSXFp?=
 =?utf-8?B?c0NlWWUyMTNrb3h6eEZQaWF2dTJXcTJXRTlkNlpMU2w2OEkvaERYY3Vqd1lw?=
 =?utf-8?B?ZEhFYm9QQnVIK3NNK2JkN1Bvb2t2WUZxNm5TNk1MejdPMm1BRFJTdUFYRUpW?=
 =?utf-8?B?a01UaHhtcDNFYWp3WSt0WXE5TnQ0Y0xlSzlvYjNxUWdQOUNmVUROVHVBRVdw?=
 =?utf-8?B?eWkxWXFuak5QckttOWZtTkVDdkE3bHN1R2pkWWtseFBsTW5GUWpjZ1h3anFh?=
 =?utf-8?B?UU4zaCs5cmNmMTdkaVdQQWJ6R0JqaHJMeG9ZakEvZWU1UnlnOUFPSkpQUG5w?=
 =?utf-8?B?VURUaTdDTDdOVFpDT1p4dlZsVXY4c1IzZzhvcUE2YVk1SlpER0RNMnhWTXVv?=
 =?utf-8?B?cWJ0WlpGaHlITmg1cUN2NEhSYyttTnRMYnNQSHd6THBRbU9qTW9Nc1NicFFy?=
 =?utf-8?B?cVBwZ3Zad3JzUTR3S2E1QnhyVjh5eGJiUEErdlZ6Q0hTbUlWWlo3bFJRSEJ4?=
 =?utf-8?B?TU5iVHQwUlF0RXF2dGp3Zk1mZnI5SVB2ZEQxMHZ4UDFXRkJQaWdnNFpnSVo4?=
 =?utf-8?B?NDhIZUU1dDc0aGxFclZweFRxdFlCOXV2R2JLKzVUdjVEUk1HZHI3dTFsQkYr?=
 =?utf-8?B?RzlMNXpyaDg5azlCL0xpYm9sVUU5Skx4SG5lNVNLWGpRWG1QNkJHT25laitn?=
 =?utf-8?B?cm8vUGY0VG54NnZ5bmx0ZmRXcGRJRWxsRXppbGE1VmZ1emdOUklKMTNzNUpr?=
 =?utf-8?B?VEx6WUVHK2ozOGt4L2QzL0U0ZWEzRnpxYzJDSXZnTm82bENJa1dvZ2hDTFd2?=
 =?utf-8?B?NHpqZ1V0NFlISnh5eXJoKzFZSWtwYlRJQzd6TW1hOXpWdjcveUhhU3RYRi9J?=
 =?utf-8?B?QStRZHYyMmd5WVRoOUVrclhpd01kS1NnZm15dVFDVFdQRjBMc1JiVXFEQk56?=
 =?utf-8?B?bURKSnIrOWMvcFZSVmtJYmkyYmpmaElRblhkM1d4d0Jkc0tOZUd5Ly9oQnY1?=
 =?utf-8?B?TWVjRnlkb2lOWXN4bi9DVEI4akd5emxPT1RXWmlINzluM2lQL1hKbDJmaHll?=
 =?utf-8?B?dzZYYjcxOGsvY0tSMlVCazRtTVJnSGN4NnJXUkV3VFBqdHgrT0NaaWNTbGN5?=
 =?utf-8?B?eW9saU5QUGw4REFFR1psTWhLdTdMRnJNRUZqMk1zSHlMRHRwMHBSRmJyTSt4?=
 =?utf-8?B?NHlCMFFOWERPdXdIbnFZUHVBeFZoM2p1aDBIUWZ3a0k1WVlUbDVPQjQ1SGR1?=
 =?utf-8?B?bG1tVTRwcGYvaCtNN2Y5eEdPdE0wVS9YTGxkSGF1U0I1YjZQa2FCdTk4OUYv?=
 =?utf-8?B?NEU5QUg1MXJQQTdMSzV5cEJFbDdmemFWRDRleHlRamVLTkVCd2xIcjZJZ3B2?=
 =?utf-8?B?ckE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: aac0044c-df5f-449c-3925-08db9a179fdf
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2023 03:04:06.1321
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Pvcl17g69BW9eF/TYyFooycGKJ5uJ1Iymu771xLGclxMYJfscodEndPhKokhRfftjqns0orfE4u71qPrzgRcRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7959
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/10/2023 11:15 PM, Paolo Bonzini wrote:
> On 8/10/23 16:29, Dave Hansen wrote:
>> On 8/10/23 02:29, Yang, Weijiang wrote:
>> ...
>>> When KVM enumerates shadow stack support for guest in CPUID(0x7,
>>> 0).ECX[bit7], architecturally it claims both SS user and supervisor
>>> mode are supported. Although the latter is not supported in Linux,
>>> but in virtualization world, the guest OS could be non-Linux system,
>>> so KVM supervisor state support is necessary in this case.
>>
>> What actual OSes need this support?
>
> I think Xen could use it when running nested.  But KVM cannot expose support for CET in CPUID, and at the same time fake support for MSR_IA32_PL{0,1,2}_SSP (e.g. inject a #GP if it's ever written to a nonzero value).
>
> I suppose we could invent our own paravirtualized CPUID bit for "supervisor IBT works but supervisor SHSTK doesn't".  Linux could check that but I don't think it's a good idea.
>
> So... do, or do not.  There is no try. :)
>
>>> Two solutions are on the table:
>>> 1) Enable CET supervisor support in Linux kernel like user mode support.
>>
>> We _will_ do this eventually, but not until FRED is merged.  The core
>> kernel also probably won't be managing the MSRs on non-FRED hardware.
>>
>> I think what you're really talking about here is that the kernel would
>> enable CET_S XSAVE state management so that CET_S state could be managed
>> by the core kernel's FPU code.
>
> Yes, I understand it that way too.

Sorry for confusion, I missed the word "state" here.

>> That is, frankly, *NOT* like the user mode support at all.
>
> I agree.
>
>>> 2) Enable support in KVM domain.
>>>
>>> Problem:
>>> The Pros/Cons for each solution(my individual thoughts):
>>> In kernel solution:
>>> Pros:
>>> - Avoid saving/restoring 3 supervisor MSRs(PL{0,1,2}_SSP) at vCPU
>>>    execution path.
>>> - Easy for KVM to manage guest CET xstate bits for guest.
>>> Cons:
>>> - Unnecessary supervisor state xsaves/xrstors operation for non-vCPU
>>>    thread.
>>
>> What operations would be unnecessary exactly?
>
> Saving/restoring PL0/1/2_SSP when switching from one usermode task's fpstate to another.
>
>>> KVM solution:
>>> Pros:
>>> - Not touch current kernel FPU management framework and logic.
>>> - No extra space and operation for non-vCPU thread.
>>> Cons:
>>> - Manually saving/restoring 3 supervisor MSRs is a performance burden to
>>>    KVM.
>>> - It looks more like a hack method for KVM, and some handling logic
>>>    seems a bit awkward.
>>
>> In a perfect world, we'd just allocate space for CET_S in the KVM
>> fpstates.  The core kernel fpstates would have
>> XSTATE_BV[13]==XCOMP_BV[13]==0.  An XRSTOR of the core kernel fpstates
>> would just set CET_S to its init state.
>
> Yep.  I don't think it's a lot of work to implement.  The basic idea as you point out below is something like
>
> #define XFEATURE_MASK_USER_DYNAMIC XFEATURE_MASK_XTILE_DATA
> #define XFEATURE_MASK_USER_OPTIONAL \
>     (XFEATURE_MASK_DYNAMIC | XFEATURE_MASK_CET_KERNEL)
>
> where XFEATURE_MASK_USER_DYNAMIC is used for xfd-related tasks (including the ARCH_GET_XCOMP_SUPP arch_prctl) but everything else uses XFEATURE_MASK_USER_OPTIONAL.
>
> KVM would enable the feature by hand when allocating the guest fpstate. Disabled features would be cleared from EDX:EAX when calling XSAVE/XSAVEC/XSAVES.

OK, I'll move ahead in that direction.

>> But I suspect that would be too much work to implement in practice.  It
>> would be akin to a new lesser kind of dynamic xstate, one that didn't
>> interact with XFD and *NEVER* gets allocated in the core kernel
>> fpstates, even on demand.
>>
>> I want to hear more about who is going to use CET_S state under KVM in
>> practice.  I don't want to touch it if this is some kind of purely
>> academic exercise.  But it's also silly to hack some kind of temporary
>> solution into KVM that we'll rip out in a year when real supervisor
>> shadow stack support comes along.
>>
>> If it's actually necessary, we should probably just eat the 24 bytes in
>> the fpstates, flip the bit in IA32_XSS and move on.  There shouldn't be
>> any other meaningful impact to the core kernel.
>
> If that's good to you, why not.

Thanks to all of you for quickly helping out!

> Paolo
>

