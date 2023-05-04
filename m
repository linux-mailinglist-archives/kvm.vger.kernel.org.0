Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA4026F6562
	for <lists+kvm@lfdr.de>; Thu,  4 May 2023 09:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbjEDHAQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 May 2023 03:00:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbjEDHAM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 May 2023 03:00:12 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 787E02D5F;
        Wed,  3 May 2023 23:59:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683183595; x=1714719595;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=LjNVqFDvy6jAiz9ETktRA8N7cRgVAuXCjmZ7d01My/4=;
  b=NF0pbDPBqZChFIpFzLRAqJ/fMQMFzIZyhPdu6Z4ldMDyjOeOP0qE1z9Y
   eeytwAKeknyWAiQpJMm9cgjB85Axi9SY2kgzPwpw/Ag91YBwEntZcFVmC
   M+Fqr8oa2SymTMCUMdVY2hLWfizV9Ex40P2KC3pkxZJySzs7UgtGnhKiV
   Rshwo9KL9VSPShaI2e0INAQ1xW6c6z6eJlgZ2EG21+ZlD+yVtg9n3shYA
   2TCfZKZfVDcPmuPo6Sy986IUMy1/Pg4ImPC+q//Pn75VXSHeXPLDtRsKj
   qqgfjjsTpPFhgYTaA4/IfbTCGsN5P2KUcGKLg9d95BiMIrQihyysBdJkO
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10699"; a="348893767"
X-IronPort-AV: E=Sophos;i="5.99,249,1677571200"; 
   d="scan'208";a="348893767"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2023 23:59:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10699"; a="729681375"
X-IronPort-AV: E=Sophos;i="5.99,249,1677571200"; 
   d="scan'208";a="729681375"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga001.jf.intel.com with ESMTP; 03 May 2023 23:59:52 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 3 May 2023 23:59:51 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 3 May 2023 23:59:50 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 3 May 2023 23:59:50 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 3 May 2023 23:59:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CKPB5osOr2o4Cx2pK8nMiR6SvhX8LJxpZ/pklf5i0DuVQIeciwxeOZBl3w7rva6FC6agH6H3pp7VyBs+YWlKW4U1EMDQV1hGs9wm+xW81hw8Wbr9btl6oZJEMOVcZnqPCMNek9i9iUmbt7V3chzRNY1zVW/Tmx+TB73XAPCHMy0HGkXbWvBEuaVcaa7SE2MAcjd5yIPsXPByUkGaI82iIq9zdXQ6FmSJkOun2aHDpSPegWtEeUSCEI0cfiodpZG4YGyGYv6ILN4C851kEJ7TNYmIUf4QhX3qivO5aAIAH523pkLIXWh11NMtwxA8w5FkY2VTyy7Su8ho3jWZ2vLltQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dYn/NI619lPD+SPHJ7jFaa+6uhQBuOoAV5pzAvIC59s=;
 b=JsO0kKpXPIQ3da+qN8euCac5S7d2nR+xvq4O5Cw4vKvtk9MC65Qr4lXODUgme8Xwepzq26B+lIBNCMXc2CVaiZjb6W3YF/L0jcnDDFqZ8YWSM44Lh/ldHHHZz6QoJT9j7nIeG1x7p/Zsj487f6gk7GexLH6nQM7+RfYLIicmvsgksHkcSu16PF2plnwjDvT1wdwM14IToUCwbXdt2SVmUYwSvfrxyPpFaubf7TBNdMCX64a/Yd+nciBCsnQhPJhk8x1S6wAdfaNxMc25W6Ml3hK+UcprUmeLFrpHOQ7rYnDQRRdWqWBInpVaqM6El3KvVYbHyo65B3p4Svk5qN8Aig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by CH3PR11MB7724.namprd11.prod.outlook.com (2603:10b6:610:123::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.26; Thu, 4 May
 2023 06:59:47 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::1ff:c7e7:87de:6d97]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::1ff:c7e7:87de:6d97%5]) with mapi id 15.20.6363.026; Thu, 4 May 2023
 06:59:47 +0000
Message-ID: <e9244de0-6fa8-e737-a38c-f0a6859ae592@intel.com>
Date:   Thu, 4 May 2023 14:59:35 +0800
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
 <7bf51510-ca6e-d4b2-31bf-405258fd08e7@intel.com>
 <a11560cd-d6ad-ddb9-24ce-b45cd879227d@linux.intel.com>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <a11560cd-d6ad-ddb9-24ce-b45cd879227d@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR06CA0186.apcprd06.prod.outlook.com (2603:1096:4:1::18)
 To PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|CH3PR11MB7724:EE_
X-MS-Office365-Filtering-Correlation-Id: def39337-608e-4f46-584f-08db4c6d25cf
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 78lpOfDhfSytUg1b2IJPZZKGX4+6a5cL3uUSXr0AM01WcfTwq5ZrDk9xvbhsYebDTAzWs6FO5QZ+z5vyIxjNhSfkPMA7tAqt3LuPrkBNAT6bRE0wGR12esZgCugyzAvLzHLYj9xXoCaarq5/XS4UQk0ZUn8uu1HFjKA5MOQnS5CwknoMM+QeSW3hIX8l2HAdoLvygvzvgYZjnWuNNYDDpcvfpxBY9hbsy22sUg1Pam4rEKyq67ZBPORDyshbq+pKUZCH9lY4KS0EjB9aOEV+AwzLn5bLucnDmomvE3pD725iY6Tb6FF4zV/VvbPS8HwQK/mWP7dU2ihWNZjn7ozmqpWuUOMRwpzxtgDRDz2Yw0AvlqzYzRwOXmHUPAJrj21UetouFL0hcIZNgQvOn5uRSXBdSDQJincsAqu02fQymRibHC2pPAAOHj2L2BVRXVduSEK78d5JqYM4iTK62xzG5kGg0C1k+JRqCYqgbxKA6fBcE55+LuqAGJxEnCuDB00XQfxFwIzOODraas0F7cFBXXl1Yx5bpX5jx0KAPMk63vCWDkkJg0RVnltdOdlHSxqU8VL7uYDiQH6t2pfSCCDF4pguViIlJpfDOBv+LogioOdbeKjPVYDv6K86gsHhsALg8l4FuZg5FAR3aT1QMpAAJA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(39860400002)(346002)(366004)(396003)(376002)(451199021)(41300700001)(83380400001)(2906002)(316002)(5660300002)(66556008)(478600001)(66476007)(38100700002)(4326008)(6916009)(86362001)(82960400001)(31696002)(6486002)(36756003)(6666004)(186003)(26005)(6512007)(6506007)(31686004)(53546011)(2616005)(8936002)(66946007)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L0FBbFluRitBOStYRzJ4d05KOWUvcXArSFpuYzRoSWM1Rlk0RzhmN09xTEN6?=
 =?utf-8?B?WHUyQkcyVC9XdUczZEExdUl3U25hRlFVdkxSUU5PVjVVcEFMWVN0aUFIZ2NY?=
 =?utf-8?B?ckNleU5mM091ZXhnVUNLQ1BnUzNVbE9EM3dBRUdPZlp2aTF1cThodkxTd2FE?=
 =?utf-8?B?bEpzUWdDVzhCTGJqck04Ym5YamhkdTNQd0ZPQUFNK1BXMlFyUTVzMGsxL0s0?=
 =?utf-8?B?UWY4dUlZMVp1MksvZ3dHMGQrK0NzUStld2E1VkRUQjR6OUEzUkZWR3lMYnBw?=
 =?utf-8?B?ZmlST2FMNHRVQWplbU0rUCt6R0hIRUJyUGlOcU9VNzY5elZqdldYQVc1QitO?=
 =?utf-8?B?Szg2MTE1Ly82SDhUOWMxNWJOUWd2WXpoZ2tWWTJyMkdmQmVSRmtrL2JuM2Ni?=
 =?utf-8?B?U09IeHZ5Mk42L1RJcGlmQzQvQmpHWlBicEEzaU1SOXdkalBuWmtuZHlabFJ1?=
 =?utf-8?B?ZklsenY1Q0ZGUXpoQmZZajlNMUxpSDFGWTJ4SjdLOGdnM04ya2xZam4weElB?=
 =?utf-8?B?aVZOWFZlbzdxR0Z5NGpza1hDSkpLSVorS29ZSWdlaHhialBGK0wzazJxWC9M?=
 =?utf-8?B?NkEycklENTR4Z3k2ei90Y051ZXJnWHdOOE1KWGJnNmc1N1hwQThoRUtKK1du?=
 =?utf-8?B?Zzl0QzRtbnFRZUNHOEcrK0p0cFN0L1Z0cHZOVUJUeFA1MGx3ZkxYN2R1dkhS?=
 =?utf-8?B?YnpHWGhnYndsK1l0cklqc3BMbU4rT2c5WFBkdnV0Ty83bWpHMFhHVmx5TUVW?=
 =?utf-8?B?NGZVSzFINzVWZlp4VFBoRlRXNkMyRXRTNHZsMXNLMWtKL0NDM2lsYVRzdHVM?=
 =?utf-8?B?RDVXNEYvYmhySStHMlBROUVObnFZNXNMMGpQVk9iY2NHSXBNVHFwdXVCd1E3?=
 =?utf-8?B?R3c5anpMdHl2L1BVRVhCWnUwUGNGUmRGcXFxd09uMEJGRmI0YjR5MUpNUnN6?=
 =?utf-8?B?eW5lR1I4UGRrNWRBcjdOTDdRZm1oZ1FvWHR6SXpHelJtSFBqSjZoeUMxWHlK?=
 =?utf-8?B?QVRtTzdIeGZ5SzFpd3NIUUtOc3k0RWUzMm1GQ1laSGlYdWIrVzVMMUdTa0E4?=
 =?utf-8?B?U0w4SlNzdWhjZDZtU1NwNUNSNnF4eG9HWUkva2JMbXNOem9BV3piWUNCTDlR?=
 =?utf-8?B?VlFUTjczYmkvbjBEeHdieldWenptdkx5aDVHNVRNQ25JTEg4OVl6bEdKQjhT?=
 =?utf-8?B?TjFIZHRNcWhqa1BtRDF3V1hPU0tkNmxVZXZ1VEpENjg3RUxSUGM4dkpaemZ2?=
 =?utf-8?B?OTVZOVZFZWdkeVgvZ2hzNExOYlN5dnNROXE5ZWN0RjRhWDVCcDBWcXJxR0NJ?=
 =?utf-8?B?MHQwYXoyb1JhN0MwajdlZnZEOVl3OHhLWlNjZHlKeVgzN2hHTTBNOU5YN0d6?=
 =?utf-8?B?WERObCtXSHZCZ3l4THVUL1VFZ1Q1ZTNzKzdEMWxqcGVybE9XcWMrUUdQQlg3?=
 =?utf-8?B?c2JrWE5FaEtzb1ZyTVVXRTRYN1dTUjBnNmM1S0J2OEs5M2ZFRXhZeDlrN0N1?=
 =?utf-8?B?bG1HU3hUQkF2WW9UcFd6aFFVeFpZbVk5VFkwSmo4R0pvK2MyVVJ6Q29PMXJ0?=
 =?utf-8?B?UEJZMUZ5U0NSNlBUczRRUkI2aytxSTVHcEhoUUgzV2NCMjhmeXlxREpaZWww?=
 =?utf-8?B?M2JqNVFPMFpNTndnWS94aE1wa3RmUjhUcnd5Qm5FTElYWWNJU3JVaUYxV0o3?=
 =?utf-8?B?MEtGMGRRU0JXa3VqajhCcENiOVlZV2FJQWRCN1VITEU5UjlXc2RMN3B1K3lB?=
 =?utf-8?B?Q0l5ZTJkQll0cm0vdTRXd002NVZhbEdSNjd0M3V5RUo5c0NOZkFtaUpQcEY2?=
 =?utf-8?B?OWo1K3NjUVcxVTU0dzJNOHRvQm9KZitKeW5JTXhNYWNnQ1lubkFOODNjcmZr?=
 =?utf-8?B?R0NKRTQwdVJvMEo0a0UrWXhOY2lMSDlYYTJ4dk5la0xZeEp2c28wc3RJQndw?=
 =?utf-8?B?QTFaeWJjRURjOTNacThSRDdaWDFZVjNTcE9DRlVxRkh6dXlBRFpBVjV2VklZ?=
 =?utf-8?B?bWhtL1ZNdjcwMTRkV0NOOWkyOElTUEI2QXNsMEhrSlRyU0Y0ZVNOZVp4aUZT?=
 =?utf-8?B?N1hSRmhKSVJqTUdDaElqbjF2Tm1wdHhaMElCTE1YU0hmRDVOYi9COE1IR05S?=
 =?utf-8?B?L3hTSTlqbUUzK3ZPekJOTE1GbzJHQVYwcTJOSUpvc2FIYXhBeGMrWGZjMGRI?=
 =?utf-8?B?YXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: def39337-608e-4f46-584f-08db4c6d25cf
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2023 06:59:47.5505
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6FYbo9Ij0BXsNkgtaqMvvXxP9hQ9vbq7G4sqYrk7sIHXHEMGueTp7SCEt2jZNyOoeMkjK4M2r2yAq6SOD211IA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7724
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-8.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/4/2023 1:36 PM, Binbin Wu wrote:
>
>
> On 5/4/2023 11:41 AM, Yang, Weijiang wrote:
>>
>> On 4/28/2023 2:09 PM, Binbin Wu wrote:
>>>
>>>
>>> On 4/21/2023 9:46 PM, Yang Weijiang wrote:
>>>> Add handling for Control Protection (#CP) exceptions(vector 21).
>>>> The new vector is introduced for Intel's Control-Flow Enforcement
>>>> Technology (CET) relevant violation cases.
>>>> See Intel's SDM for details.
>>>>
>> [...]
>>>>   -static int exception_class(int vector)
>>>> +static int exception_class(struct kvm_vcpu *vcpu, int vector)
>>>>   {
>>>>       switch (vector) {
>>>>       case PF_VECTOR:
>>>>           return EXCPT_PF;
>>>> +    case CP_VECTOR:
>>>> +        if (vcpu->arch.cr4_guest_rsvd_bits & X86_CR4_CET)
>>>> +            return EXCPT_BENIGN;
>>>> +        return EXCPT_CONTRIBUTORY;
>>> By definition, #CP is Contributory.
>>> Can you explain more about this change here which treats #CP as 
>>> EXCPT_BENIGN when CET is not enabled in guest?
>>
>> I check the history of this patch, found maintainer modified the 
>> patch due to some unit test issue in L1. You can check the
>>
>> details here:
>>
>> Re: [PATCH v15 04/14] KVM: x86: Add #CP support in guest exception 
>> dispatch - Sean Christopherson (kernel.org) 
>> <https://lore.kernel.org/all/YBsZwvwhshw+s7yQ@google.com/>
>>
> OK, is it better to add the reason in changelog?
>
> IIUC, a new contributory exception vector (if any) should be handled 
> similarly (i.e., treated as contributory conditionally) in the future, 
> right?

Agree although the issue happens in an uncommon case, I'll add some 
description in changelog in following version, thanks!

>
>
>>
>>>
>>> In current KVM code, there is suppose no #CP triggered in guest if 
>>> CET is not enalbed in guest, right?
>>
>> Yes.
>>
>>>>       case DE_VECTOR:
>>>>       case TS_VECTOR:
>>>>       case NP_VECTOR:
>>
>>
>> [...]
>>
>
