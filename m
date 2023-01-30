Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A4D7680F2F
	for <lists+kvm@lfdr.de>; Mon, 30 Jan 2023 14:39:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236159AbjA3NjQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Jan 2023 08:39:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230464AbjA3NjO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Jan 2023 08:39:14 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CA9714489;
        Mon, 30 Jan 2023 05:39:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675085953; x=1706621953;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xZwgwGOiweVzTWY4zO/5A45yQnV2OrOpWrrK5qViefE=;
  b=NKRMBFijjJH3Vj7RURl5vNuXGhmgfWL/hPR/n2iqzqm286G2bTFgeel1
   6dvd8gEw7K6ZRanL+9z0XpzA6IbuQ2B2k2BAPwx2jVK5T9JGv+/gLpwg0
   ccuVrf6bcgOEyp9JikeI5nzRwhUpWtlPGXVyttxqy2m7agK/t/H4x4fo+
   dvNXcHGMGshNLua+BJXPGa42zIasaCKrwrx8vGc9yQoRNeHYEn2xou5Hx
   GzVne5pNUhbBIZ3cP5aTfIVwRwQ5Is88nBiIIKvPzDUwriIrm4z+MGz5f
   Xl0ddNRBROA/Q6lUAl+MSP4T0N2uGVbRf5/S2UhaMnEf04FnxTMEtNeuS
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10606"; a="307901375"
X-IronPort-AV: E=Sophos;i="5.97,258,1669104000"; 
   d="scan'208";a="307901375"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2023 05:39:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10606"; a="657455517"
X-IronPort-AV: E=Sophos;i="5.97,258,1669104000"; 
   d="scan'208";a="657455517"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga007.jf.intel.com with ESMTP; 30 Jan 2023 05:39:06 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 30 Jan 2023 05:39:06 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 30 Jan 2023 05:39:05 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 30 Jan 2023 05:39:05 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 30 Jan 2023 05:39:05 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CxwJfGElv+1jwXaHKH8mU4/3xrey5YHfvCZQKlz8GSZZZ9TQ99hbwWilVj6eEZLsXLkD2WPdcBRvF3+mTzo+vj4nLSige31SPwVc3EsBpdYIbgiXySyhGzauatMDNxG+7QurwqYKjgFD27GFWMqUrrDMHySm/l6EajXmGjl2D9jle2H7ydVG9/gPO5LILhBxWm4GUpRhvrFSnz3LSDSx6ur8US2sF38dDW81KlPRPaaEn88y9Lc+d0Ak2OejKPZYXcFHhBqA4s1CUZZqelSCotSf84oTsf11V2bnjQ4OQee3wk5TiMP7UTgIGrVWWBNMHd0WmNY2trseqFq4SJcHIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v8RkANzZs/S2gmLOpcwmC97nvHJe5YP05N5iJRY3Fxo=;
 b=M8nRFtnF2du9BI7qn8gcsoSrlMWJBfk25RZE7JD4/OivJ0j4P96D2McCo00ayrjpnZDHpm3mwsWcWI+S3oIwRUvaO8oFABEsSpz5u0zi4ROTL9f79BA+l0v7fkKIkMPlHKr/BtRF7dYJYJYNc+J/BdaUSBc/IQ/AmPQtWWP/UCRt4QBDCoTNjSS/Wvl4lLO4g4KDY6BkZdqKGK84nW2Cw5bE0jgNzk4fAqAKm4RLbTikHdqbfH8k4a2or6Xo3pVkXQBFpNZKfTKrEJsOF4bWe+2kU0AKb+nHSabBG80wSNwU4Gp46LDPTh3kbZ9sH9sYb0W5WJ1F3ihAfytyljZxRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by CH0PR11MB8213.namprd11.prod.outlook.com (2603:10b6:610:18b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Mon, 30 Jan
 2023 13:39:03 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::7d42:36a8:6101:4ccf]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::7d42:36a8:6101:4ccf%2]) with mapi id 15.20.6043.036; Mon, 30 Jan 2023
 13:39:02 +0000
Message-ID: <74421cf1-30e9-e9a3-cf87-d0e7f12917af@intel.com>
Date:   Mon, 30 Jan 2023 21:38:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v2 00/15] Introduce Architectural LBR for vPMU
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
CC:     <pbonzini@redhat.com>, <jmattson@google.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <like.xu.linux@gmail.com>, <kan.liang@linux.intel.com>,
        <wei.w.wang@intel.com>
References: <20221125040604.5051-1-weijiang.yang@intel.com>
 <Y9RUOvJ5dkCU9J8C@google.com>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <Y9RUOvJ5dkCU9J8C@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0040.apcprd02.prod.outlook.com
 (2603:1096:3:18::28) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|CH0PR11MB8213:EE_
X-MS-Office365-Filtering-Correlation-Id: 49c0205d-4428-4e06-a004-08db02c75968
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N4+CKl7FXw0Jr0bfw2Ppl1wkw2HkIiBIpqtBSI3Jy/DqyE/75hCNTEAC4Iry3Vd+40GKo8f5rrMQW7iN9f5hBXbb5q+cUDoIhe3wGsjNnvlgKeL+jF5RWE8YU7faxZXyf/2bAzQEe0/tsd7GSi7eMYYEeQJtryhHJ+nMhaKY+Au+gF5ixgFCjNvxFa2vbSZg9G+DiLetzXg+wAG3XgA7ZFktNGwzbh3CkJJrsweCQFYSHuk/TZsdbOv+aEpFbFVxkHEKKN1ghRxLLHwJGvRLzed2ZqpkUdYSO560bz3cM4P4kOGlxsFEqTti/yMM/Md2URI2vO8zyxr1m8fgmrwJ2gcrlXHo2z3VdnPaAVzgfTs7qyDXYIMYlrf4nKQw/aGtc5Gj1RBVaLTNJbq1ronnauJfTFIasWx78uxZ3m2FiiOnHRCka3nGyeTMHRvuhzoPAlRdm16tNjGa+pWauXXtwgUx9tLWFLMjCs49L6nIQ6T7TdWmEc6Sz62osQT43GkeRe0wxr1x1Y7Nt/y5pVvQvGcyAt9hxNRv2dC/wBs7uSBrSMqUQiWScqCKP8dNeIi0BS48m1uNNR8u4CkBOCpCamcoXvPdJ+u7+nCKB1myIBOMvrj/iDgx9/FT5H9b9ztRCsZatvO5gl0dBTJPNSEB0v3YnRlyzPIt/6UE7Z0R2TChnDkoxOktWyt6vCJ5M90PuXMjBWNpbNp7AxY0yi29J9KPbAq35CoWERL5D82r1cc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(346002)(376002)(396003)(39860400002)(136003)(451199018)(31696002)(31686004)(8676002)(66476007)(66556008)(6916009)(4326008)(41300700001)(66946007)(8936002)(83380400001)(478600001)(86362001)(82960400001)(316002)(2906002)(38100700002)(6666004)(6486002)(26005)(6506007)(53546011)(5660300002)(186003)(6512007)(36756003)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?akdOdnE2cDlxeml3cGppS3l4MUFoKzBoVDZtaVNFNlFYTXNQVHp6NE5VM2t3?=
 =?utf-8?B?dHZRVHh6N3B2OVZMQUdhQ2VFeWIrK050RTJ1WXoxT3hSWG1Vc3pDQ3g4TGFx?=
 =?utf-8?B?VU94WnZEYm91SXFNZmk1VTRVTlgzbXlZRnB4RjBJblpSRGFVYmVnMCthckhv?=
 =?utf-8?B?TTNHR1ZrMEdsREdlanVLVE84aHNMYjdBd0ovamV5MWYvdEtVMU9hRnlVL1lm?=
 =?utf-8?B?Uzh4YWVGenNUWk5TUnVzbWZmVGNCUUlHR0w3bWZqZkhFMS9GSWtaTzhLbzlT?=
 =?utf-8?B?WWVNZU0wM2lVMCtJSW9CUXNZVUpiblJKQjZETGFDUEN3K2hqZmNGMnc2V3kr?=
 =?utf-8?B?ZDB1dzZZbE9IVmNmNUpkaTZLY1N6MmV4TEhKNWRGOHlZNWxzbEVWazZEM3VY?=
 =?utf-8?B?RGd5RGpGQVdzMlBTTGx4QVVXYVlYdEdvb1FsVHgyMU5LT3d4bUlVbkhYKy9s?=
 =?utf-8?B?SVV4RlZZcnBvZzNiRUE5L3V6c2N1RllCWjB0dUE4V3ZFejdCaTM4VDZzRE5j?=
 =?utf-8?B?Y2VwUWlkcm11QzZjNW5JbHdpZko0TXpTV1orcmtzenk3Ym9DcVJHVzFqNGd5?=
 =?utf-8?B?VGJZMXhZNnhqbEJLa1YrVU5vbEQ4Z3ZabVlVS0Nxd00zWnlORVgxYlhqa2ly?=
 =?utf-8?B?TjFMOWxrQzNubHJTV2MwSUY3LzNTeFRGejc4ekdCZzZ5blVHSVp0aVlIaFhJ?=
 =?utf-8?B?a1BEVCs2U2tyWDdaRHNrdkcyaXNOMDVCQ2s4WElEMHE4WmQ5V2VFUXdwYWo3?=
 =?utf-8?B?Zms4SFZSaVlhWStJbU5ROENsbDRGeHY1T1BNYy8wZ2VDdFhsUkZZRHRaTHQ5?=
 =?utf-8?B?Z20wLzdOUUZLYmk1ZUF3SVhSNjM0SVhzd3Vka0xPL2VHYkUwRUFmUHZ6Wnlj?=
 =?utf-8?B?RHNwUWUzQkFTQTJZdncyY0hEVEVaQ05ROG91U05RZHhJNUtjQjdTaUl0MDMz?=
 =?utf-8?B?by9SNURmcitCNVNoU0xFeWRmelBxc2JZUExzaGxJNFlKbTZ4cThvbjZwK08w?=
 =?utf-8?B?L2g2bzRHQU9NVk1zdU5XZkUvZS9PckJwNkZXZnNKcXh0aEJIZUxXUngydGxh?=
 =?utf-8?B?T0VVOHhicmpXSjA0RVV4V2dpem13cGk1Q2lab1kyanE1MFEycmc0cmNSZUVZ?=
 =?utf-8?B?Z2E2UnBpMjY5MWk1WFllYjRPSmN1WUk0Sit5Vjd2UW9mSHdNa0NTTTJZb01w?=
 =?utf-8?B?MDlkWkVqcWt2L05lYnJWbmRsdzlEVEFSSFgzQmM2ZzlJOWVSUTF0amxUZTk5?=
 =?utf-8?B?KzlFRTBuRE5aN3pXc2UzS0FaSTZwL1dSU2g4dnY5dXAzZzFuQll0allxbjhJ?=
 =?utf-8?B?MmlUbHJhRmxCRmh2ajMvS1RVc3U5eFhkNmZLWkZLTWpWOXpyQzhQOGpoelZR?=
 =?utf-8?B?WnVVZlVzbVM1N0oyODVMdUNqY2J4YXg2cFFGVndXaTNZZjR2aklJT0Fhdk5G?=
 =?utf-8?B?cUxYbzlPTjV6eVpXRzhvekJHQjliYzFvbUU2N2krN1UrcHdGNmRiR0pwd3dB?=
 =?utf-8?B?VDBtTHhiSG1JVUlobk4xVUc3QXN3UWZNdUdsSlJLdW5Yc0UzZ01WVndyb254?=
 =?utf-8?B?N2EwZ3cxZDNRWWZTalh2YXVrYTMzbWRQYUtUMjMzbERjQ3Q2TlZJSW9BYms3?=
 =?utf-8?B?c1Jlbm5SanN4SzdNeU05OGVOSXMrRkN6MTJUeC8xdXVHWUlkY1lObDVobjJi?=
 =?utf-8?B?SnpRMFVmaTZJSWdQMDlxU05EdHNLOVZnSkNENGhEQlNBeUhtdG5kVEs0bzI4?=
 =?utf-8?B?Ykg0eXlUZ1hVTWlSOWZtOVJSdmVLalQ0NUVac0UrS1hobk4vYzhXWW1kSEZV?=
 =?utf-8?B?SjZSNXBkUFlocmg5NFFDcFJjQldEMVJxd1JuSmxLVENnRGtlYnNucFU3ZEVB?=
 =?utf-8?B?UDIycVR3eFE4R1hYTTJxRjRxb1JlNkdMcmlJc2hqMkVIclp2TjVBZGZYOWFv?=
 =?utf-8?B?Z29KakxHcGNjcUtzczVkc2dwMnFpWXdiV3NtOFZaTnkvQno1c1pDYXRxUjh2?=
 =?utf-8?B?T1Fza2t4QnhsUmYzeFZwWkhVaUpURXpIRVUzc25ySkxTQ1JNQXhUaEVYNWRp?=
 =?utf-8?B?dHphYThPSkwrMzRvekNld2pJYmJlTUhNUDgzWVJBaXlPenFDb2hieVg4VlhZ?=
 =?utf-8?B?ejNhQWJvY3IySUpvUFJVcDdid1hDTFFHbnJPb21qUjFkcDl5SWhzZUJuWmtX?=
 =?utf-8?B?dVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 49c0205d-4428-4e06-a004-08db02c75968
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2023 13:39:02.8270
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G6uNMJKxKGtNIXRULScu0JPY+fXw67SGzPU7PQ+DZ5abBWJFAF5qLMcl4Tt+RmuXKabsZUyXrdlYm7k/9ATxug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB8213
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 1/28/2023 6:46 AM, Sean Christopherson wrote:
> On Thu, Nov 24, 2022, Yang Weijiang wrote:
>> Intel CPU model-specific LBR(Legacy LBR) has evolved to Architectural
>> LBR(Arch LBR [0]), it's the replacement of legacy LBR on new platforms.
>> The native support patches were merged into 5.9 kernel tree, and this
>> patch series is to enable Arch LBR in vPMU so that guest can benefit
>> from the feature.
>>
>> The main advantages of Arch LBR are [1]:
>> - Faster context switching due to XSAVES support and faster reset of
>>    LBR MSRs via the new DEPTH MSR
>> - Faster LBR read for a non-PEBS event due to XSAVES support, which
>>    lowers the overhead of the NMI handler.
>> - Linux kernel can support the LBR features without knowing the model
>>    number of the current CPU.
>>
>>  From end user's point of view, the usage of Arch LBR is the same as
>> the Legacy LBR that has been merged in the mainline.
>>
>> Note, in this series, there's one restriction for guest Arch LBR, i.e.,
>> guest can only set its LBR record depth the same as host's. This is due
>> to the special behavior of MSR_ARCH_LBR_DEPTH:
>> 1) On write to the MSR, it'll reset all Arch LBR recording MSRs to 0s.
>> 2) XRSTORS resets all record MSRs to 0s if the saved depth mismatches
>> MSR_ARCH_LBR_DEPTH.
>> Enforcing the restriction keeps KVM Arch LBR vPMU working flow simple
>> and straightforward.
>>
>> Paolo refactored the old series and the resulting patches became the
>> base of this new series, therefore he's the author of some patches.
> To be very blunt, this series is a mess.  I don't want to point fingers as there
> is plenty of blame to go around.  The existing LBR support is a confusing mess,
> vPMU as a whole has been neglected for too long, review feedback has been relatively
> non-existent, and I'm sure some of the mess is due to Paolo trying to hastily fix
> things up back when this was temporarily queued.
>
> However, for arch LBR support to be merged, things need to change.
>
> First and foremost, the existing LBR support needs to be documented.  Someone,
> I don't care who, needs to provide a detailed writeup of the contract between KVM
> and perf.  Specifically, I want to know:
>
>    1. When exactly is perf allowed to take control of LBR MRS.  Task switch?  IRQ?
>       NMI?
>
>    2. What is the expected behavior when perf is using LBRs?  Is the guest supposed
>       to be traced?
>
>    3. Why does KVM snapshot DEBUGCTL with IRQs enabled, but disables IRQs when
>       accessing LBR MSRs?
>
> It doesn't have to be polished, e.g. I'll happily wordsmith things into proper
> documentation, but I want to have a very clear understanding of how LBR support
> is _intended_ to function and how it all _actually_ functions without having to
> make guesses.
>
> And depending on the answers, I want to revisit KVM's LBR implementation before
> tackling arch LBRs.  Letting perf usurp LBRs while KVM has the vCPU loaded is
> frankly ridiculous.  Just have perf set a flag telling KVM that it needs to take
> control of LBRs and have KVM service the flag as a request or something.  Stealing
> the LBRs back in IRQ context adds a stupid amount of complexity without much value,
> e.g. waiting a few branches for KVM to get to a safe place isn't going to meaningfully
> change the traces.  If that can't actually happen, then why on earth does KVM need
> to disable IRQs to read MSRs?
>
> And AFAICT, since KVM unconditionally loads the guest's DEBUGCTL, whether or not
> guest branches show up in the LBRs when the host is tracing is completely up to
> the whims of the guest.  If that's correct, then again, what's the point of the
> dance between KVM and perf?
>
> Beyond the "how does this work" issues, there needs to be tests.  At the absolute
> minimum, there needs to be selftests showing that this stuff actually works, that
> save/restore (migration) works, that the MSRs can/can't be accessed when guest
> CPUID is (in)correctly configured, etc. And I would really, really like to have
> tests that force contention between host and guests, e.g. to make sure that KVM
> isn't leaking host state or outright exploding, but I can understand that those
> types of tests would be very difficult to write.
>
> I've pushed a heavily reworked, but definitely broken, version to
>
>    git@github.com:sean-jc/linux.git x86/arch_lbrs
>
> It compiles, but it's otherwise untested and there are known gaps.  E.g. I omitted
> toggling load+clear of ARCH_LBR_CTL because I couldn't figure out the intended
> behavior.

Appreciated for your elaborate review and comments!

I'll check your reworked version and discuss with stakeholders on how to 
move the work forward.


