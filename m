Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31EDE655C5E
	for <lists+kvm@lfdr.de>; Sun, 25 Dec 2022 05:29:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230442AbiLYE3e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 24 Dec 2022 23:29:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiLYE3a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 24 Dec 2022 23:29:30 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2546E65C0;
        Sat, 24 Dec 2022 20:29:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671942570; x=1703478570;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ISz2utlcEIdv6IU2Ujib/8lGYBLcEXZzf/LhLGjCWXc=;
  b=HiYpaADq72safxHZXIAtayA+nCdzaORk4c55k9WbSoueuHcLNAFWqZS4
   ZBIJn1V7iP93knzSFvTAaX/gEEpTzamQKhp54ObRHCEjm+5gzLYxTzMdX
   BV9bcbRyK/bsnZRrITD/nj0/fREHsqRj8egkbvHvyPoCid7yB/+DtwOAF
   OyaepiUa8qX7kB8P614vK4or0zIHgAv8s3Nn6ay6n8Kg9tUWJE8qoBp45
   LL/f5aC4Gxlxfb8q0dxBnLan3Yb3uAQxq3urzNAw56+9lzl8RYyG40mj9
   oOcLcUrlGPgOi12DGvqnF3fS4lV0rYWB8SN4danZgCrPi/W5IG73Hwrwh
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10571"; a="347635086"
X-IronPort-AV: E=Sophos;i="5.96,272,1665471600"; 
   d="scan'208";a="347635086"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Dec 2022 20:28:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10571"; a="741187914"
X-IronPort-AV: E=Sophos;i="5.96,272,1665471600"; 
   d="scan'208";a="741187914"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by FMSMGA003.fm.intel.com with ESMTP; 24 Dec 2022 20:28:38 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sat, 24 Dec 2022 20:28:38 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sat, 24 Dec 2022 20:28:38 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Sat, 24 Dec 2022 20:28:38 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.46) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Sat, 24 Dec 2022 20:28:38 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h9j+cAdERUn54iT2jhiO7gAkne0aNNOgKgkhGZyLG9twDyxKK9AfesQjMXYz2X7QNY+e8kwuCwIhIRBngbQhurznOch2b3wuJ887Dl4tLxP4F3493NgpAQUPCfPPaYoMQt/lotvL2docMl0XGt2h6HCA6lP0EQg06bAHv6xTbkWIKzM2j99ssoYm2GfOHOwg4CYsKmQjwA+dVIWGAeAY9DWS04Mn6yOToE1PlOzxfJX5opsUGifugWfEO/pJE5XeHJjNlDa519mm5K375vJWUUHu6VYwxVfgILLIgPn5LPC6JRYlWzRo0bNQhhgf/fcw7mGZxfQ/4b3JNeVzIfDKlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yTTsDt+OhxK9OrR/nM/qzImYMNqBTEb5B9d9eaZ1ib0=;
 b=dVT5yq1C1cwySntG+H1RC5oyi1oeIvbEiNyRrVku73J+VJMDmQLiR0rGvy7WHPQ0cCRM7KCliQv42G/2+86E9ouZJkNnmjzvVoTn5g9/smOPaNT2WZpBfHYxZB98UQ7Q8gA8I5gJvNoicsRqSDvxeNrbYOm5dT/qqjZ/NS7DFVKqeinNCIvhIGIU5R0d0ZNx3R/o6daE1GGRypURnKrkzXfpWbmsNEkuM8s81xsdaYpzSGvDxAp9+Lj7DCrMlfqhyk4KhEHptxhHL6Q3dEIJHBJwFKdw56HsA2VEGyy3tDZZJrbW2uKByuBxN/rtq+Rd1/WuqJSxHJbm6ZJOCzHXIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by DM4PR11MB6237.namprd11.prod.outlook.com (2603:10b6:8:a9::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.15; Sun, 25 Dec
 2022 04:28:35 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ae1a:fa3e:e36e:c2fe]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ae1a:fa3e:e36e:c2fe%3]) with mapi id 15.20.5944.014; Sun, 25 Dec 2022
 04:28:35 +0000
Message-ID: <22caaa56-6881-247d-ec3b-2786345a3005@intel.com>
Date:   Sun, 25 Dec 2022 12:28:25 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v2 10/15] KVM: x86/vmx: Check Arch LBR config when return
 perf capabilities
Content-Language: en-US
To:     Like Xu <like.xu.linux@gmail.com>
CC:     <kan.liang@linux.intel.com>, <wei.w.wang@intel.com>,
        <seanjc@google.com>, <pbonzini@redhat.com>, <jmattson@google.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20221125040604.5051-1-weijiang.yang@intel.com>
 <20221125040604.5051-11-weijiang.yang@intel.com>
 <e96d7310-69c0-1e76-fad5-fde818a2c41a@gmail.com>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <e96d7310-69c0-1e76-fad5-fde818a2c41a@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR04CA0206.apcprd04.prod.outlook.com
 (2603:1096:4:187::21) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|DM4PR11MB6237:EE_
X-MS-Office365-Filtering-Correlation-Id: d7baf183-3ec6-4454-f420-08dae6307c8b
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lyZ0LXKyS0EiwCOmXfDhKJxFnIz3TXk4hLZ823mJ3BsDjrObOKsVW8OLGzPuk9PRxyPKoW8HsLik8vk6JaaR8/n0G5IaSOSHUD/keH8HRNN10DcfJVzhxI/0sD0wxTt7xL2YzXPldY37XDlTGCsoKM6GNAJBNNvvfDyNYYOpnTc7y6Q6h5BxmR/507WzsuDFwAD5X99uFpVymt6j/9VQLY2QNjVrufDLq3QAkP0Sy90Sf38OnuCSWf9qeSbmJpRapkdjhkjxT/mHdUhLmH78piyh+VERT+MXdqgY+3sr1dxZCWqDdUadhi/XQ4n4LTmOacJwmrreukj7SvjmkamDDrgW0quoVkOFKFuA+JjiYjDbsK9ecueO/DtV+sfBAf1YAIuZhD1JFghvU8MhJFyvpOvjoCfF5g4ulYzuQZChXu4Vf+g7cww5t4BUa+l//6NXfjAGWjAniutzm4znldVj/WMfduKMbzf8wNzIlo8edWtF25fXDqGWiZAYGhkJ2F3bDB4n9INM/P3P3KKG/U4J7mHaE1mdEK6bJHkMRDsMWAr/Zi2sgDSDcriYp1N2CgpJTlaKA7Vb0wbh3UwbIRSkZBLOHYnuL0nlx6p1w74xdpp8mG7Td84VCVe7hCmw6beaa56DIj15oggk2zJEOyTXtityNJ5HCgw6LIjgAiyi1gFXxDbD5jr4wpmiVmSeFptlaXPjCA8bx4UEGpgeZ/rtMMfgFr40lrF7LnnJcO3a8bk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(346002)(396003)(376002)(136003)(39860400002)(451199015)(36756003)(2906002)(82960400001)(38100700002)(5660300002)(8936002)(41300700001)(4744005)(31696002)(83380400001)(86362001)(66946007)(66556008)(66476007)(316002)(6916009)(31686004)(6666004)(6506007)(478600001)(6486002)(6512007)(4326008)(8676002)(186003)(26005)(53546011)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NnBhREdzaW5COUZXY0gvSjh2dW5UWFBrcERCSTJEaVhKdmg2bVUzNUM0NWFi?=
 =?utf-8?B?ckR4Njg4MU15OW9ZekJXTVZ4bXJVdndJdkJzb0tkNmNCampDemErdDNqZHl4?=
 =?utf-8?B?STRKbnJyZmVtWmVOZGVKSnBoQTNjeWp0NlE5WDhYV3ROTWlzWGlVbmtVb0lv?=
 =?utf-8?B?QTM5M0ZJVU1iQkVxaEp4Uk1SOTIzUkdBbTlody9BcW9reEl3Y0JxbzlkbVJu?=
 =?utf-8?B?SFg1L0ZmTyswOUMxeFdFa1RsMGpCbE5oeTEzWnFqSlVJNm1XYmxiUFB5NGs0?=
 =?utf-8?B?L3dOaDRyeVRCUWxHK1hKUkcwNVVnSlpYeHV4YytORWZOT1FCSkxUdENWNDdr?=
 =?utf-8?B?RzFmZW9FcnNxOGJzNG5mWEJLOU1wQkJmY2dCRC9IYmtrejBCUENUZHo5MnBD?=
 =?utf-8?B?MU1uSEtWZXIxem41NXlrZU9VbkxmSzd3S2pXZEN0U24xaDNxdDNvWGppQXV2?=
 =?utf-8?B?NG84ZjZmWERydTdNczJqK25hUDhOamNmYWRnMk5oVjRVOXlFTWs5dTlhT2dY?=
 =?utf-8?B?d2tsV2xZeVZZdlhVZ0N1R21hV09LZTBsdFBxbjNGRElQS3hyS25rbTlmYUtx?=
 =?utf-8?B?NVQxWFE5RG9acFN4VHd1TG9CVFhCTExBWkd2NCtLWlU2YjJ6cUNzVk1XUTY1?=
 =?utf-8?B?eUN3QnVRTGFiM1NaMG1rRjltQ3Y4WTlxMnFKb2o2dTNGRzgwYmttNzRvSFly?=
 =?utf-8?B?MlVGdVZzTVpEOGFkVWRwZUJJRENheVhBcUlLZytLb0ZSODFVT0dpeEoyUkxi?=
 =?utf-8?B?eEJsc25Oa0ZENW15bVlqSTRkQ252Y05VaVZOUlhNOCtqS2VDMGlVYmVSOGh6?=
 =?utf-8?B?aktlUVpOQ2ZjOFFGaEVDdDB4M3J0c1ZxRUlGd0hTMGNlQzJyRzc3WnpKekZD?=
 =?utf-8?B?MTFMSUNZbU9vdzN5N1F0bXQvNXh3OVIrYVMwVkkvTGRUa1B0b2RYSlBEV1NE?=
 =?utf-8?B?VnFwZGhUOHNUMmZSdlFIMHE5bDNpUFhPZlJzSDlpdXE0WEdWeUdXUEdGRER3?=
 =?utf-8?B?TlBaSHBjS1lJSkNZM3dnVDZYQzRMS1QvQlNjTTI3YVRPNG9TZnk0TmpWS2xI?=
 =?utf-8?B?V0VaZFhtbHZSeCt6aitEVkdkN3B4Q3dwa1ZYZFg1SGNXZEZJbW9HWDR4ZDYr?=
 =?utf-8?B?c25rS0JWVVFkWFVkMkFhd1RNbUU4UlA2UmhiUkFBZmZWU3YyemlMWXJvUHVC?=
 =?utf-8?B?MkRKbE9CcUsyb3I5WWdYb1ZSQWR0UFlFSWhNaHdESXE1RklFYlUxZEZhd1Zr?=
 =?utf-8?B?NWRpOEZxMVFBaHlMSXpxU3dlYUlOK3RaSDVEWW9uVXZybi9FUlIyY2ZkdHpS?=
 =?utf-8?B?Qmo1dXRtWE8wV2N6U2hrdlZacnJQeHM1K2dFVm1TZ3o0dTRaV2FnZ3J4bHc5?=
 =?utf-8?B?NWwzSUpsVzVTQXdHb2QrVnJoOVJHZnIxaHJXalVmZmkydkpiYTFZa1VNM2Fz?=
 =?utf-8?B?cVNLcWRMdlk4S0tFTm5YM0RScXhESUk1TURTQ2ZKWE4wazQ1VnA2b0dObnIx?=
 =?utf-8?B?YVZzOHJZWkFHVGJlMGhXK1JYZjR4cUF4VVMwVFVvVEhYejJoUEpjM0h4VE91?=
 =?utf-8?B?UFpRenFxYUxGSjNPQU1ldjlWemZWWFlUSGkzMGxNWW1MaktIZXBYcFpSQ0I1?=
 =?utf-8?B?Nm9yMG9QSnpwSFBVUE5oUy8va1QwbFN4QmZlT1g4Sk1ldk91aktkbC9qc2VR?=
 =?utf-8?B?c2thbnFPUmwvU2Jxd29TejZxSENiRHkzb3JxQmJ6dng3TVhUeGRKRWxJaTVG?=
 =?utf-8?B?MWdUdmw5SFlSYlBNR1lFTXQzTUdBQ2VEUGJuS1IzQ0VHSEVrMld2VGxVRVRx?=
 =?utf-8?B?UWM2cDR1NGJqUVduT1JLNGx6SVlFN0JYTDgrekdMM1FhMkxubzkyZzJwNkFT?=
 =?utf-8?B?S0VPWjA3STBOYk8wZENLeThBdjdwYXVGenh5cmk5bThuK094aUd1dlZRaFpB?=
 =?utf-8?B?WWZDVDJqTVRPZ3R1dC9Pdlh4c3NmRTR5b2dxZThaME1waU93aW54UXhLSEEy?=
 =?utf-8?B?TmUxRExjOEEwODB4NHZscjZsT3BObXJ4R0l6aVVzSGFkeTRXVGpoTDUvL2VY?=
 =?utf-8?B?R2hSNkltdWV6VHN4cTNVZ3F6MVdGZklHOUdNSmRLVFlKYi9neUR5UmQxMEJD?=
 =?utf-8?B?NmV1Y0loSTJTdGkreGJMTUZ3NUxyU0grajBpb2Q4OHV3NUROY0R5YWZYdmhQ?=
 =?utf-8?B?eXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d7baf183-3ec6-4454-f420-08dae6307c8b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Dec 2022 04:28:35.1379
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NAWTviMhGPGGlDoppJxrNfcnaVuzl4GXaISt4djsA4fd9cwS4dHObcTh/9k6yN2lXTyTws42jfQOdBJoOgryZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6237
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 12/22/2022 7:06 PM, Like Xu wrote:
> On 25/11/2022 12:05 pm, Yang Weijiang wrote:
>> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>> index b28be793de29..59bdd9873fb5 100644
>> --- a/arch/x86/kvm/vmx/nested.c
>> +++ b/arch/x86/kvm/vmx/nested.c
>> @@ -2360,6 +2360,10 @@ static void prepare_vmcs02_early(struct 
>> vcpu_vmx *vmx, struct loaded_vmcs *vmcs0
>>           if (guest_efer != host_efer)
>>               exec_control |= VM_ENTRY_LOAD_IA32_EFER;
>>       }
>> +
>> +    if (cpu_has_vmx_arch_lbr())
>> +        exec_control &= ~VM_ENTRY_LOAD_IA32_LBR_CTL;
>
> Please verify that (arch) lbr is not available in the nested test case.
> Thus when we support nested lbr, the developer will be aware of the 
> need for test case updates


It's not available in either KUT or selftest cases now.



>
>> +
>>       vm_entry_controls_set(vmx, exec_control);
>>         /*
