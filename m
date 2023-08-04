Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A29D776F77D
	for <lists+kvm@lfdr.de>; Fri,  4 Aug 2023 04:08:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbjHDCIS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 22:08:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbjHDCIQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 22:08:16 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B533A3
        for <kvm@vger.kernel.org>; Thu,  3 Aug 2023 19:08:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691114891; x=1722650891;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=XvvZPfQ/jKBzndF00KTyAA4+V7MfJq5UoGRisLgjnP8=;
  b=cXZIN/Xm84TTCyf7fckcrfVmcfFai22tanF0KWys9H/jSc8m2RaD6GuQ
   Jmr5fm7PuYbIxWXC5FwUPGuiY3YOnHG1rRPNSyCvnNC7VmZYcy9qYdIfG
   IOlytZOj84OERz9vhhV7wRgihcdECtpzKTXNOy8IoKEfOtiL1VmVokFlE
   BqvhS8Z+OQMbJdFJ3kzMrMayJRjuMYCY1HZTIvfezrCTR1Wg/nbbqVouq
   rPgzYlMUWi07j7amTknUj2NEQrlzIep5VrOibnPA91TLzhvWGI2a9iFnH
   dwuDpwu87877Tld3fltppGwvLYFMGbZ5jnalFg2c6akVbgC4WxgqTp9PG
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10791"; a="370035089"
X-IronPort-AV: E=Sophos;i="6.01,253,1684825200"; 
   d="scan'208";a="370035089"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2023 19:08:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10791"; a="706793708"
X-IronPort-AV: E=Sophos;i="6.01,253,1684825200"; 
   d="scan'208";a="706793708"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga006.jf.intel.com with ESMTP; 03 Aug 2023 19:08:10 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 3 Aug 2023 19:08:10 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 3 Aug 2023 19:08:09 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Thu, 3 Aug 2023 19:08:09 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.109)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Thu, 3 Aug 2023 19:08:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iQ+5+Pd/IWTKEJlmOZyWC4+qwmJrLVwPy3xWONbIXSWnyeok7Cj4HhB3gtd4rBJjmqAm30InxSzFhmrl4EKbWW6WUeN0irpxz+OJojSmZNE0rWpTXkNBGHbtIReFAdTVxXJ43U+mmq6ooRCO5JozinHRYOaIh2QufL1aRHPh8WcsFcisaYpp4FnoNy1F9ndNvXr1bwdwh+Dbwgo8ztPeqDShiljPse9Ob3bgKwueBH1w/2Wb+0C8qd4a56I5FdiV1szxWhUh+8ddOMm1PTRKFyP5RqhNHRn1w1JZ/t+j/MMsLUcoq7fCF07umLlLpC1FRa+Q8h4t04qpK0iLD4/6wQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qKguu9QQr+iBExgsD/CYvhjCMXu9cU6myaQWjVTlwb8=;
 b=cG4ygybmCdIyJZgDbLFAN1niYtVZfSAgsh2Eug6yqNiAy91CWZuCpcKxAC6/Is273wejZFhW4h1MXk7b23XH2eoXKGx8soZy2lFHxeBuNUFjLWVskJtu+WAjhO7cfkjei8CIDstYblAfJe1b9ZHQShBbWeeVXSPXteUwZss6AoZ/I4nUE2iWV2GYUH9UOuqbpKdGYHvEMl1uej0e63vCK5qR+pWZPf+XRYhY/RZV9FhFfJXeDS9uISXqK1hJK6ZmJHglSXWKAHB3k53KrZ9DZq6F7uhTgsoq2shNfCtk2DZe86KFV5yj4uDsYR5D8+RzIBT6tbIcfmoLTvSUayRbJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by SJ0PR11MB5616.namprd11.prod.outlook.com (2603:10b6:a03:3aa::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.20; Fri, 4 Aug
 2023 02:08:08 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::94f8:4717:4e7c:2c6b]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::94f8:4717:4e7c:2c6b%6]) with mapi id 15.20.6652.021; Fri, 4 Aug 2023
 02:08:08 +0000
Message-ID: <a3ae5c68-effd-c916-3e2e-50aeb9c38756@intel.com>
Date:   Fri, 4 Aug 2023 10:07:59 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [kvm-unit-tests PATCH] x86:VMX: Fixup for VMX test failures
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
CC:     <pbonzini@redhat.com>, <kvm@vger.kernel.org>
References: <20230720115810.104890-1-weijiang.yang@intel.com>
 <ZMqxxH5mggWYDhEx@google.com>
 <a5bc09c4-cc24-1e70-b70f-dbbce4251717@intel.com>
 <ZMvfxFgHlWMyrvbq@google.com>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZMvfxFgHlWMyrvbq@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI1PR02CA0042.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::17) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|SJ0PR11MB5616:EE_
X-MS-Office365-Filtering-Correlation-Id: 47fa64dc-39c6-472b-8dfd-08db948fa55a
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p2mCzN3GxRM6jG4e5JOGDA5xpvKYrQ2kFkquBrGvhyOYRLOqCyhmGCAg+c5pTeLZ8aQL2diY0eK92evl3QxbQEHZvMxLO+ctF2/5Vp1yFEWMuc1kmMEzKN43CGM9w86b4RaEshTgkgr/j4MhGJV2yrkOR0kpS9tNU/9KlKx0rBW9kcFllhK7b4UNqsD/2UBP1wtaDD9p10szM0vaFDQz+Q6K54ydN+nBE1+eOC0orwD0Nqj1W7nsesbgGprKyNZp+9O2Ni3jk62S51EfHD0J2fjSL1HJ4ApwIPCa3lgrRogw0CP8wyH8W+RfryitMMCbtdliTFNAzOAWmAb3N4empEJ3drsO8149Eq8tPzq4fZK1JD0lB3lDukGMkAK6t3JiF5TBz3rsRU/jMx/EGyko2MXUE1KVGVgq1ZM2uqw5CJKMEigrcUH2cFuzBW5Gp2Hm2CBRVGuLA/8qtT/1SIyPgK81k///cfu0E3gAPd+RdWReMdEm9JYQwElhwrZ8yZlUN7TgCwo3xLfq/sSn8re/wasH6iCKL/XDR3BymThDWK0Yf4+LMx6nsRRX93of7jpG7evJPl9iLlG84nWIR5wnQK/DAIg68rvq1b76vwieSAQ0MPMt+xELD4Iuyy23w16IkiLHBzuC12PgS7OVLeDT0w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(136003)(366004)(376002)(39860400002)(346002)(1800799003)(186006)(451199021)(2906002)(83380400001)(2616005)(86362001)(31696002)(36756003)(82960400001)(38100700002)(41300700001)(6666004)(31686004)(6486002)(6512007)(316002)(66476007)(6916009)(4326008)(66946007)(66556008)(26005)(6506007)(53546011)(5660300002)(478600001)(8936002)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aWJ1dGt1Q2hld0dTK1lvSFE5ZmhjSkhpcXR4cHhrWXQ4M3RHNGJCNVJUMU9P?=
 =?utf-8?B?bWlzdjJrelR1YVRQODBsN2RRc2RYbjYrZkF5dm9LSGxhVEpmd0pBMlhwQkFK?=
 =?utf-8?B?WVNYK1NaZVVJdndwWUpBYjM0eUJUVHI1dnZTUVdpam56MnByY29QL2xUSzd5?=
 =?utf-8?B?VTh0VDdNS0NFYVptOXhmWENPUUhML0hlV0RxZnFaZ3VVYjhwNXQ5V3BjYWph?=
 =?utf-8?B?aWozYmZETHB6enVKb25lNEJ6NWsvMTBocmFBeERORVpzME5GNWN6RTdwakRG?=
 =?utf-8?B?c0haSXJGVmlXeU1LMFpJZ2JNelZ1QW9XdS84UkgyWkNBUXJSVERVWlU2YlBl?=
 =?utf-8?B?YWpONHdockdxM2tONi9TekdpaDJvMHBQaGFUTFVtaFh4Z3lhcmtYODZsbHY2?=
 =?utf-8?B?Rms4YXpSN2Nrc2RscHEwSGxteCttbkU1VjVhcUpGd002YXB0NjkzeWEwOXVv?=
 =?utf-8?B?Y2kvV0s2cGlza0g5VnhTdDhPYTdMNUNnUzBDa1dCQ2YvNEwwZTZ0UlBJeVdo?=
 =?utf-8?B?QjdmT0dRUG1BeEJ2a1RSS1locHVFWGZlZ1RoZElYTkp1VzgxYk5qRVE1eElj?=
 =?utf-8?B?M095emg5eTBJNWM4T1Q2RG5RMFF3SklDWnpvUG5hNlp2bkkrNG1ubkE2VDdj?=
 =?utf-8?B?ams0bmVqZkdjalFuMnJPd08xMHpzUHQxZGIrdkxOc2kyS0NYcjQ1TkttSy9u?=
 =?utf-8?B?TXJhOW10cGFxbUhCOGVKVkkyTUhjYkFIT1VxeE8waTBnK2ZOMDRrMG9iTGNF?=
 =?utf-8?B?Rk1nZitXcnc2UmFzM2VNekxmSzUvM2RIeDllNzhzMmtmV25rcjhoVzlHbUxS?=
 =?utf-8?B?ajRMdERmSGJFaUFxOG1oMkRSOGk0c3BQQW9CTEtyMDJ5V210L2NwU0ZaQzlE?=
 =?utf-8?B?WGsvRGZ5ZFp5QUphOG53TDR3M3VvWVpJMytwcmcwcXVXa0tiMUJ6dXBqYi9q?=
 =?utf-8?B?WE42OXR5UVBuRzYxQytXSEhLT0VvZGVxaHF3QVl5UHdBZkRGd2kxMm5DUDVH?=
 =?utf-8?B?V2R4c0ZKV2xtK24wU3R1VzhnRFRyWUJIVjh3TVNUcVhrWGtZT214eHE5MTBG?=
 =?utf-8?B?eE1meEU5eldYTFNtUFRnM3dpQS8xZk1PNjhuOHVZL1RGRVhPek9kc1AxSzI4?=
 =?utf-8?B?WlBGUFhxNDNweis5UUN0eFFwUU1VNlhIenVESzZHSG1IUzhORmRKTXdJQUJX?=
 =?utf-8?B?bXo5d0V6R3VDWVh6dVM0U1BjdnhQR0g3TDJmSHhTMmc0dm9qbER3QmsvbTNT?=
 =?utf-8?B?aURMRGdoZndVMzl3QWVpOUFWakJTemRZNjdIS3l3UnNXYUxQbkNrSC9vcHVr?=
 =?utf-8?B?aURQYXI3aVBVcnN5OE5mQnFPYnhKSzB0b3puaGhkblJjKzZpdmY4dFZTa2tZ?=
 =?utf-8?B?dW8yaHE0clU2WlpFcHVncW01cDBvZVZzS1Z1Q05vc0orY2NPWDNSTXl1SFM4?=
 =?utf-8?B?SVBXY1RRa1BjaGo2MGVoV1hwc2pOVDRJZzhJSk5QYTZZenBiVll0MUVjOUx0?=
 =?utf-8?B?ZFZyK1RrQ3ZITEVOTWREa0ZIalNsQkFOeXJ2N3RjUHRqOG95MTlHb2pRTG12?=
 =?utf-8?B?M2lwSkdFSklHWXhVUWplZGkwbHlEYXgrdWNKSStRc2Z5OTJzQnhveFRDd05r?=
 =?utf-8?B?TVNGd1ZvQWF5UnNFei92YTdHWGNpdCtRSlpQUGZMMXJiVTRNNVhoRVVSL3JH?=
 =?utf-8?B?YmNOZ1JNelFxcWkyY2IxVjZoUDZsQlNSQmkydU5PemJxSXR6WGtENzhmWEFO?=
 =?utf-8?B?MVZQRmkyWXBBclhPUDlGWWF5NGhBTDFLSlNQMmxqTEVZcUVuSkpHMDVGd0FL?=
 =?utf-8?B?UkdLTFpseHIrYi9ZaGVKcG5mT0NRT1c3b1FMTDdBMTdrWnpkSkR0RGdFbm05?=
 =?utf-8?B?L2NWaFJkZVRxQWdVbysxWm5SNlYxbEVBRFRDaWRSdk5iR3lPZHVxb291R1h1?=
 =?utf-8?B?K3NCRFZjZXlnQjVKQXRac2VWZGY2cVBSTUZMVjBIU3c1bFFUczdubkpZM1F3?=
 =?utf-8?B?cnRpdk9oTVFsWWxhQlZZVnRZODY4SytCbU1sbUZlRVNubE5lZmNEMWZPVjRz?=
 =?utf-8?B?eFhzOURpeHY5ZUluSEFUUEhVNXUrQ0JGM3JUdko1R01vTmZTbTBBcmQ2dWJF?=
 =?utf-8?B?cnBvKytFazFLREUvZGo5TjNwbzVQU2crSU5FNE9NQzBtMEticnRkWUZiZ3Jt?=
 =?utf-8?B?clE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 47fa64dc-39c6-472b-8dfd-08db948fa55a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2023 02:08:08.1543
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e2WWO4ebiGD/EIgQC21Yo3ZDr4q44SAJIyZ9dbNzVcGcl5Xz6mZiqFz/OGfkf1A86SOz+2UmqA7DRud3MgoaGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5616
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/4/2023 1:11 AM, Sean Christopherson wrote:
> On Thu, Aug 03, 2023, Weijiang Yang wrote:
>> On 8/3/2023 3:43 AM, Sean Christopherson wrote:
>>>> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
>>>> index 7952ccb..b6d4982 100644
>>>> --- a/x86/vmx_tests.c
>>>> +++ b/x86/vmx_tests.c
>>>> @@ -4173,7 +4173,10 @@ static void test_invalid_event_injection(void)
>>>>    			    ent_intr_info);
>>>>    	vmcs_write(GUEST_CR0, guest_cr0_save & ~X86_CR0_PE & ~X86_CR0_PG);
>>>>    	vmcs_write(ENT_INTR_INFO, ent_intr_info);
>>>> -	test_vmx_invalid_controls();
>>>> +	if (basic.errcode)
>>>> +		test_vmx_valid_controls();
>>>> +	else
>>>> +		test_vmx_invalid_controls();
>>> This is wrong, no?  The consistency check is only skipped for PM, the above CR0.PE
>>> modification means the target is RM.
>> I think this case is executed with !CPU_URG, so RM is "converted" to PM because we
>> have below in KVM:
>>                  bool urg = nested_cpu_has2(vmcs12,
>> SECONDARY_EXEC_UNRESTRICTED_GUEST);
>>                  bool prot_mode = !urg || vmcs12->guest_cr0 & X86_CR0_PE;
>> ...
>>                  if (!prot_mode || intr_type != INTR_TYPE_HARD_EXCEPTION ||
>>                      !nested_cpu_has_no_hw_errcode(vcpu)) {
>>                          /* VM-entry interruption-info field: deliver error code */
>>                          should_have_error_code =
>>                                  intr_type == INTR_TYPE_HARD_EXCEPTION &&
>>                                  prot_mode &&
>> x86_exception_has_error_code(vector);
>>                          if (CC(has_error_code != should_have_error_code))
>>                                  return -EINVAL;
>>                  }
>>
>> so on platform with basic.errcode == 1, this case passes.
> Huh.  I get the logic, but IMO based on the SDM, that's a ucode bug that got
> propagated into KVM (or an SDM bug, which is my bet for how this gets treated).
>
> I verified HSW at least does indeed generate VM-Fail and not VM-Exit(INVALID_STATE),
> so it doesn't appear that KVM is making stuff (for once).  Either that or I'm
> misreading the SDM (definite possibility), but the only relevant condition I see is:
>
>    bit 0 (corresponding to CR0.PE) is set in the CR0 field in the guest-state area
>
> I don't see anything in the SDM that states the CR0.PE is assumed to be '1' for
> consistency checks when unrestricted guest is disabled.
>
> Can you bug a VMX architect again to get clarification, e.g. to get an SDM update?
> Or just point out where I missed something in the SDM, again...
Sure, let me throw the ball to the architect, will update here once got reply.
Thanks!

