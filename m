Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45F916F63A3
	for <lists+kvm@lfdr.de>; Thu,  4 May 2023 05:42:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbjEDDmA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 May 2023 23:42:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbjEDDl6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 May 2023 23:41:58 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50FB61B1;
        Wed,  3 May 2023 20:41:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683171696; x=1714707696;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ljHnkX5U0AQaaLLWMLKfyQ8/tZ8WJNpfC4Fd376E+2k=;
  b=bDIp6i3JnfWEZVJB6mOWrranGqmSTdsBKEHOCrvIAeVx0k3dXALm0HsK
   QGTa6K2xwdHaFol5b4DbnFYePZdrfWRODlb6GwsFBlmfXuIkYYWjdgbJB
   OGwV4MBczhNm08YzxnojsemHL7B9x5EHUof3beWAA7fc96knFBBYZleHL
   CnjqyHbB9TTVcqtdV7/oxRLuGaCrvgmvhfkJoXIX8jAjEMejZolEX8OvM
   P2qbaevO05DmAGLI3Qz0HzdYjVEuKvr38Ls+7o7NH2sMKHbHNULQUCvkW
   lL0nhn4KTeTHJtsNP/814t1pBlsA5qtYo5GXBqZbNF9Nhm1wR1BSPsHm9
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10699"; a="328445117"
X-IronPort-AV: E=Sophos;i="5.99,249,1677571200"; 
   d="scan'208";a="328445117"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2023 20:41:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10699"; a="727412093"
X-IronPort-AV: E=Sophos;i="5.99,249,1677571200"; 
   d="scan'208";a="727412093"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga008.jf.intel.com with ESMTP; 03 May 2023 20:41:33 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 3 May 2023 20:41:33 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 3 May 2023 20:41:33 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 3 May 2023 20:41:33 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.107)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 3 May 2023 20:41:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bqHkDXpRDTkTZf/wUXxPPIHWmkglUq6GPjr5CmWns/GJQ0YNk+4J0UO6bl7eFGJCSw0PJQP1yVAx8U4VQJPbBQoyGTlLVrE4WlYVKc+Pdr4XdXu679X1q5WteMFCYrLuGvcT7OrsrXGxGgva9O9UKSidgjjVfQFfpN0iUvkb5QnIdOr45T5yQhiIq6lLua0DeifbxEY+nvlRtNz/bAkeITM+5lFprIEE60wahm0kK9YjIiwtO2kpbSDDv06yvaQ7aS0IkdanKT1fMUCtnyhs0yKbaUNsdaGWD0FvT4gR8iOFtaJel3kQI0XNMdmhC5YbmgFXg/XTacfnyhNAoER5ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2lG9/euZ/yatc/gkFMol8XuXHNwJsma7nDhGudIN7pk=;
 b=LEBKN43dN2QpkU0UJ3ljoDPRpu7nGQFWsc5e9KL6HMlyPZMzJ05k0UL99lr7bO5szVyjubO5nxdU1l1auVfjMqUl5AjFFuIww3Lojo8uRfPjGHiijytAoTdN1wkf+wUi114pL3G2GQgapJEkBG61LY60h85FpjcAyJNAkUSfTcQXjE84Nw9uTv4HjNf1btwYg6X19EWL80DXeQJfC3NWHQiLbDaEnyPAF6l2SSSIdg3qGaCDxjCK1qt2tNPc5ItOW8/1tbOhXUo69vL5jU5+HwSFyhijS6k6yrzfdrL+F0YLi14wRi1UhDMt91iMfc7UxQtLk+ruzliZpkszat9+sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by CO1PR11MB4865.namprd11.prod.outlook.com (2603:10b6:303:9c::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.26; Thu, 4 May
 2023 03:41:30 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::1ff:c7e7:87de:6d97]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::1ff:c7e7:87de:6d97%5]) with mapi id 15.20.6363.026; Thu, 4 May 2023
 03:41:29 +0000
Message-ID: <7bf51510-ca6e-d4b2-31bf-405258fd08e7@intel.com>
Date:   Thu, 4 May 2023 11:41:17 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v2 10/21] KVM:x86: Add #CP support in guest exception
 classification
Content-Language: en-US
To:     Binbin Wu <binbin.wu@linux.intel.com>
CC:     <rick.p.edgecombe@intel.com>, <seanjc@google.com>,
        <pbonzini@redhat.com>, <peterz@infradead.org>,
        <john.allen@amd.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20230421134615.62539-1-weijiang.yang@intel.com>
 <20230421134615.62539-11-weijiang.yang@intel.com>
 <d923f839-7505-21fc-2976-673c9e698b6f@linux.intel.com>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <d923f839-7505-21fc-2976-673c9e698b6f@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR03CA0108.apcprd03.prod.outlook.com
 (2603:1096:4:7c::36) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|CO1PR11MB4865:EE_
X-MS-Office365-Filtering-Correlation-Id: 3271a20c-f5a0-43aa-2ae8-08db4c51722c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Evpm0UahVUZcztlximc46re++/6C9Xzs7ALbxee4BfeKgnxSjFf6j8Ez1wR3HgDPMtASR+gNfgWmRL0I7ptZEu0Y4eBMFgDJeOSxSHxYelXGGZmXMFN6zTfc/HSdlayEoPnUGd4vq2v0Amfp+sATR+EzBooUvUOF6xAlRZGV3KaqEi9d4Yh7bqBCq1NStdf+nvqfQ6mPV1OUZIDxS6Sidjue1uk0Z6BIZjo72iPOUtdXh9N0fiePYidDnCKy1vSRFAAQQcMZXyky/43/o6DNg1y71rykETfGaz5FdTXRmbXjDQcLW/xkQCJZO/RdIhyzuNbOCiiVWRClNbKB8YOGHMJ6bxnFRD55H9XffyImmdo0og1QUj0iyCm9oa+oDNav5f1PcjKXMwHmukPl+LHWvRMUYuaTkxtaqGDgh+mLVMdYd0OylKHIoFbfMfLLpryvJ4idM/1souBSwMieQQJrnXCFzwZFV0JwM6iTLDFuo+IT8CkDM2s8Qgbu1nIjYz3hR1n06eB5wov29O+MdQX8lQlXjwlcb6R2H/wrqQjJSUyQ6DcrQAG0ycXMPKOweIhcTj/aquREOFgKuNWLQ9SCgYxPAx62mFgacmgMkxbQ4QFN1EEezoa+iKjiwGyKjqmfVrcYfTfQ3G399S6G+oPNIQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(376002)(366004)(136003)(346002)(396003)(451199021)(31696002)(86362001)(6666004)(41300700001)(6486002)(478600001)(36756003)(66476007)(66556008)(66946007)(4326008)(6916009)(316002)(5660300002)(2616005)(31686004)(6506007)(6512007)(26005)(53546011)(2906002)(186003)(8936002)(8676002)(82960400001)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QzFWMFpyMng0eHhveGtVVFh3cE42bkc5bHVORmpCOW1aTXFNbmw3b0ZJWVM2?=
 =?utf-8?B?Uy9uRTZNaTdNL2lEaHNNYUs3cjFDcTRXNkZaRE9EUFN5aGt6UkRvWW9ZQWhC?=
 =?utf-8?B?allIRGw3RFpQRUV2VjU5WHFrOUh6bjdxRkhtOGZRaUZIZUhnb2VNb2E2NHZ1?=
 =?utf-8?B?dGdMcTI4RCtXYmozZmI2NmNDcllDYk5qZ0VBQm1NZXdiYk0vNGYwREZzWVBl?=
 =?utf-8?B?VVJaeCtpZmNlTUczODA1dWF3RmxHUCtKeDM1YXlVaVpTQm5KcWVKeHRqMHNH?=
 =?utf-8?B?Yi9za3E3eGZpQklHcXIzSTcwd051anQ3SGM2dDY1MkFBdGR1VlhjOXY3R3Zi?=
 =?utf-8?B?UXNwbW1FcjVkS2VmUk1xblRYSC9QSmYwU3lSZWVqM1lZalBsSzBxMVV2WGVs?=
 =?utf-8?B?R2NZSHZPcnZKVzJCb2hNL29xOHl5Znk3Tlh5Um1kLzJucy8yYjRTQWU4bjNm?=
 =?utf-8?B?YkxCcDhCaXJxaTVCNVh1aHhWRDF3SzAyLy8wWCtoUnN4ZC9QZ3VndVJ4WmlU?=
 =?utf-8?B?R015YnJMT0xEdU9kUmdqWThtbldOV21BdnFWNWVRYjF2VHpSOWt5dW5WMmFk?=
 =?utf-8?B?VURIZW9zK1lYMVYxbk9sclpDZEJDZFpBbWRvc2FQWkkvV0VFdXdvSUYrbzZh?=
 =?utf-8?B?cksyZEU2YjliOW43Nis1Q0djREx5aThkQi8xUlhUeFBTZHQva2JmM1NLOWVy?=
 =?utf-8?B?YllBVmhvRXltMFN2VXltREsvWS9GSHI2WVpnTE1UVWZmNy9QM3ltL2RMN3hs?=
 =?utf-8?B?Z2llK3pLYWlRalZTU1JYNE5lU0NPZUluVTFuSkpnWVhPNHlFRHVtcU9TMkpm?=
 =?utf-8?B?Q3FkOW0xMGplU2dpdUhlalRLVmRmMUExWXppRU9RRkRPcVhHME96RzdFNk9r?=
 =?utf-8?B?bkxHSWtwWHBsQmFEczIrSjZPNG8rdzl0LzdGMWlUb3JMdTVaMzBFTVU3Tnh3?=
 =?utf-8?B?VlZ4c2s0R0x4ODBYTzNVK2lVUERWem85b0xUK3owNk84dWtWNXpROWVVL2V2?=
 =?utf-8?B?M1M2ZWV1WU90VE5YZ2tMVE5XU1kwWmFYT09RdTIxL25qZEZ3WFBzdEVNYUx6?=
 =?utf-8?B?NXAySVp6Y2J1ZVJyMzlETitCeE1RcjgxWXFjZTYyZi9KV2o1VE5VamFNaXB5?=
 =?utf-8?B?dTZldGp1MVg0WGJIbWFEYnhRTzZ1c3N5VkZnSm9GSmNGM29OV09BdlRHL2RE?=
 =?utf-8?B?Y0huTkNpWUtIMUtSbTN0TVNVTDJETlQrellaRGxGMHZTVytsZW83elBGNFRr?=
 =?utf-8?B?S0U1bE9ud01zS0VqZ1U2aUhjZzJnZmUvdmxoZ2txZ2NtZlBwTlRZMzF6ZWhs?=
 =?utf-8?B?R2xnNEczRHFYOStkaDFFcTFqOEp6b2lEVUJieXNOcEQ2UTNjaCsvL0VtZzla?=
 =?utf-8?B?R0RiclZYZFZKb2xQSjVmeEd5alBjL09rS1VYTWwrd0gxc1NINWZDMTV5NnUw?=
 =?utf-8?B?Z1JKVnU1YjQzSVBhbXBzSDhKUmpkOXVDMVBVRXRHY3lqMXVqL0FMaGxBa1Yr?=
 =?utf-8?B?dFMvWG0rZm5oeGJjdnZuZzBJQjlMbDZWMTFpaW9RTmU0Vld1UlJNS0tIZVhE?=
 =?utf-8?B?amNaZnAzM1pIOTl6ZUVMdjMzM3d0eTNiZGF3c04xODc1TzBUdW9lUUwyc3Rx?=
 =?utf-8?B?Q0lwZmVwRXZiUTRpVDFYOTRVMHU4VjU4Z3gya1JOcFY3MGREUFh2VEtzTnVN?=
 =?utf-8?B?U0tOR3ZRTU5yOXR1ejBaenQxMzR6Unl0c2h5V2pOblRpUTBDS1hadjJBNThL?=
 =?utf-8?B?RUhEcEl5em1MNUZZQkl4SjRvMW9TT3FLL0x1TzFGU2NPNHozT1FLekFzOHFP?=
 =?utf-8?B?cmhIbDhBMzgzQXdxMVRNVUVNejZnM05ZZklTRUR3RzN1K1Z0VHpBTjh0UGlt?=
 =?utf-8?B?V0doVTcwK1B6d0Z5SDArU1RuS1N5RHNPYTM1QmVqU2N5bXdub1JXZDFYTWFM?=
 =?utf-8?B?UkJRUVJjZ3oxZkFxTE1qenc0SkRyekJRWWQ3U0NDSENrUkQwMlUrNHhYRUQ3?=
 =?utf-8?B?WlJtSVh6T0trK3VjY0NSLy9rVnZ1b1hFMFNYd1AxRmk0R2gxSCtWdzM1eWpV?=
 =?utf-8?B?cm5DYkFhczZxTDRIYTU2eWJBc2Y0NWp2V1YwUEVlNHB0SDd0RzZBSVo2a3Vl?=
 =?utf-8?B?eEhkbnhtc0V6VkhhV29FdGtwdWZNcjBPNklmbnl2QjFLS1grcmNRSEYwL0NS?=
 =?utf-8?B?Vmc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3271a20c-f5a0-43aa-2ae8-08db4c51722c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2023 03:41:29.7444
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YY8iGyXi5pu+w8YbxzSOjIjZDwj8dD2Q5G5+tTPxPwuNY/TUV4FwEqAbaI7MM/OvGdoF4XhVeGslPuaX00S1bg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4865
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-8.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/28/2023 2:09 PM, Binbin Wu wrote:
>
>
> On 4/21/2023 9:46 PM, Yang Weijiang wrote:
>> Add handling for Control Protection (#CP) exceptions(vector 21).
>> The new vector is introduced for Intel's Control-Flow Enforcement
>> Technology (CET) relevant violation cases.
>> See Intel's SDM for details.
>>
[...]
>>   -static int exception_class(int vector)
>> +static int exception_class(struct kvm_vcpu *vcpu, int vector)
>>   {
>>       switch (vector) {
>>       case PF_VECTOR:
>>           return EXCPT_PF;
>> +    case CP_VECTOR:
>> +        if (vcpu->arch.cr4_guest_rsvd_bits & X86_CR4_CET)
>> +            return EXCPT_BENIGN;
>> +        return EXCPT_CONTRIBUTORY;
> By definition, #CP is Contributory.
> Can you explain more about this change here which treats #CP as 
> EXCPT_BENIGN when CET is not enabled in guest?

I check the history of this patch, found maintainer modified the patch 
due to some unit test issue in L1. You can check the

details here:

Re: [PATCH v15 04/14] KVM: x86: Add #CP support in guest exception 
dispatch - Sean Christopherson (kernel.org) 
<https://lore.kernel.org/all/YBsZwvwhshw+s7yQ@google.com/>


>
> In current KVM code, there is suppose no #CP triggered in guest if CET 
> is not enalbed in guest, right?

Yes.

>>       case DE_VECTOR:
>>       case TS_VECTOR:
>>       case NP_VECTOR:


[...]

