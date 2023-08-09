Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66FF6775287
	for <lists+kvm@lfdr.de>; Wed,  9 Aug 2023 08:07:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230418AbjHIGHx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Aug 2023 02:07:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229832AbjHIGHx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Aug 2023 02:07:53 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 404D4E5F;
        Tue,  8 Aug 2023 23:07:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691561272; x=1723097272;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=AwFhxoaENmYhXXbS/e6ahxEgNHRlc7CSgnz12IcJkIM=;
  b=faodnI9CSdrjD6WYTNooIHhqUPUol1PwvbmvWqKOwOY/vp8Cyb75cDKp
   wlULMXB8Ea0pEXE4jxlGs7WYWG9GFloogv3TVJONW/ucMOIz1/kidQJLz
   2xmpwRne5c7W6zJHoSZeP8/4+fHSYqynIkP73EkXMimRs5YIJQsHaxH/R
   P9UaT7t3MhtyuUlqmwuM3Ki/te8nC58eahfkjXH6PmOGEQt2Bundctf1z
   oKYE1m5189LmKCO6Sf3oD8ZHp/DJV9ADYD50DDZF6NtZUykHoYmSSBO4H
   jl5XbS81Jn5OZ9LHcyFWQ6gCtH0oKM1PDlJjmJ9LmckOklsyX9BiTsY1p
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="369933610"
X-IronPort-AV: E=Sophos;i="6.01,158,1684825200"; 
   d="scan'208";a="369933610"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2023 23:07:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="801618831"
X-IronPort-AV: E=Sophos;i="6.01,158,1684825200"; 
   d="scan'208";a="801618831"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga004.fm.intel.com with ESMTP; 08 Aug 2023 23:07:48 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 8 Aug 2023 23:07:47 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 8 Aug 2023 23:07:47 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Tue, 8 Aug 2023 23:07:47 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Tue, 8 Aug 2023 23:07:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Duy1VuFRVYc+HMqn7RSwMQsDiJp2ZWl09T1vnlE6inGcP046+KLvHkjnuCceDDk6nneUBUgEjg/o4TBEThfBnmVL0JOM8vpExw2VGG7SQ28J8FfUCDe0Zh1sM7Up7J5oLGFQ8BVzp6EMz/NL+oHRsUba2vlxzd0IyTVyACI3Lb9oszz7j9A+awxmTT7LUrlcosW8lgD5bv1y/UYXwlJfK6187nsXSbV7Je2SJA8yWuf9A82PkC74NOy/6frFoa/q8X15IwQT7KbfXSf6NyKpSAr+akY0gB9LHmZbQ6GloZOS/SxMkkcfoZB0WXnl1AXqdj6lGTmHnQwGjeNyUjG0kA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AwFhxoaENmYhXXbS/e6ahxEgNHRlc7CSgnz12IcJkIM=;
 b=d3KV9ZN5ntPjLJA3NWgWaBPyPIxHIpSp4xEn3yDEwaVHRy7In8m9RE7WlYG8zGs6zuYG95v5myIA27FwqkgO5Xcef5QyvpWUJBnKuMXK+FCUlo0ABgRks8W+cjn4ash9LRwL/BipSXRBv6Sidc2JsIjZmpVFnf7KKi7NT59MqIQZ50PM9QCBFvkGB70pAiw6QkKtofTOX2aPivVWbvi/lp4DK5YK/3s1dpDd3i8ppg1SHIlPV+41lITiFN8D/ll1wk3xN8D1Fy6YFzrTMKEWP28k0ZPJj/tYrhBXcA0jzyKlK3mhS7nUjj1Ea5knaBhto6LcV33KUtl3D1GMG2GP2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA2PR11MB4972.namprd11.prod.outlook.com (2603:10b6:806:fb::21)
 by MW4PR11MB6957.namprd11.prod.outlook.com (2603:10b6:303:22a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.27; Wed, 9 Aug
 2023 06:07:40 +0000
Received: from SA2PR11MB4972.namprd11.prod.outlook.com
 ([fe80::2685:1ce9:ec17:894f]) by SA2PR11MB4972.namprd11.prod.outlook.com
 ([fe80::2685:1ce9:ec17:894f%6]) with mapi id 15.20.6652.026; Wed, 9 Aug 2023
 06:07:40 +0000
Message-ID: <5f11dda2-76bd-b238-e9b8-9c9833960c7b@intel.com>
Date:   Wed, 9 Aug 2023 14:07:29 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [PATCH v5 17/19] KVM:x86: Enable guest CET supervisor xstate bit
 support
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     <rick.p.edgecombe@intel.com>, <chao.gao@intel.com>,
        <binbin.wu@linux.intel.com>, <seanjc@google.com>,
        <peterz@infradead.org>, <john.allen@amd.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20230803042732.88515-1-weijiang.yang@intel.com>
 <20230803042732.88515-18-weijiang.yang@intel.com>
 <3075190f-d8a5-0d7d-56e9-671a2052d20f@redhat.com>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <3075190f-d8a5-0d7d-56e9-671a2052d20f@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR02CA0013.apcprd02.prod.outlook.com
 (2603:1096:4:194::21) To SA2PR11MB4972.namprd11.prod.outlook.com
 (2603:10b6:806:fb::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PR11MB4972:EE_|MW4PR11MB6957:EE_
X-MS-Office365-Filtering-Correlation-Id: ec31b155-f870-460b-fd72-08db989eefa8
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nBaCuCeUydLFsBrcLq6dG7Sdh+VPNSg+X7mxN6bonhHa4FMUL+QCuQvhQrNtlxx191xou54jpEK4XEwsdWzXijflEmEVg3XxefZQcxyivN+bP3aVCaeObIzsDDpfsEEJyCTsfEKIXHyo/4pd9X8GgmO+YqGe/SgNDDRV0pZYpJEJAUeKII4GB0O+9ZdOW4RhSS31ZZ0whJqjAbY8OVr5RPbdiKjLe4N5aCVmvgXAAC9k3Ud0Gz4bNRuei4yX4fNZPQFYXDXgfap1QfhUQ6rHyQzcM9aUCaJA03+4MHb0sQOcFRx4czrrHUwmeVR5cQEYtMmOtxC54X/Xg9yOjzseO9WgQIqWAHInVc3QS35pNOOj4Q87iItCQxXwcMqVaSAWwg8JJna3FjwqBUNhqV4hxMG7/sTUhcUC6sPTDVDCp9uFGwlOadsXBBYMk2moJko73M8w2WmjUD5Lxm2KAzZC0TBoBGbCZJKvHi6Cnfmhdej3RBQfoUBf31NPZ1ktJXbcufySFAHXZtrab/CjwSvVSCR91V+h+/D2uozLWXP4MioRXIBzEqdt5fVnwLjEyyIFh2gwV/HCinCqjlQqDJZgyzsa5N6UjTXYesA3VLVvuGzmO3j6b3Cy0V7g5A22JbmuSuBWoUGzxpFMeVFcTYs0ww==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR11MB4972.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(396003)(39860400002)(346002)(136003)(376002)(451199021)(1800799006)(186006)(8676002)(8936002)(5660300002)(4326008)(6916009)(316002)(41300700001)(86362001)(83380400001)(31696002)(4744005)(2906002)(6666004)(6512007)(6486002)(2616005)(53546011)(26005)(6506007)(36756003)(66476007)(66556008)(66946007)(82960400001)(478600001)(31686004)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q0tjWU5SUzRYRHdpbFZRRGZVaTZMVHVyemhFditKcWROZnIrNTBFbUQ3NFNy?=
 =?utf-8?B?VzN2REFCRU9TbDU4ZXduTERlY2ZEOEx2NFk5OWdGWUpoTVR1RmNoSFFYSlJa?=
 =?utf-8?B?T2VCUXVJRVZqSHpudE5WUmJOU082OENJbGFZeWh1ck5EWGc3TzQ5ZHd0RExE?=
 =?utf-8?B?WnFTcGp4TDE5YW9sc3RQTnc5T01CSTNURTYvQlI1dC9UQklORzA4LytxQ0pu?=
 =?utf-8?B?VTFtQk9BZkdkSjBndkoyRTUxd2FLRlkzSVVhV2JjdU40Z09kNlJCWGU5UUc0?=
 =?utf-8?B?RHVmakZ2K0FwV2E4dlZURUFVVFZKT2ZLbnljaCt5OFBMOE5wdzhEcWxGYTNT?=
 =?utf-8?B?Q1hlT1hIZ0MvOFZQRHVFY3QvK2EzQWkwVDVaYlNRc242N2lIV0EySEpHM3Aw?=
 =?utf-8?B?QVM1ZHBxQW1XYXhieTB6R2h3aXFTTk50WWU5TWlxQldjbTdPZlhMRU04UGNR?=
 =?utf-8?B?MHRpUkJ5WEdIRnI0VEZoMVVFTnFiUUM5Yi9xV2RXa1I4NXFLSU5MVXpyTFIv?=
 =?utf-8?B?M0NlWGdVUWc1UkVQb0JOaUlZSTFWVWRVaFQ1TEVNcmVJYzdMblNjdWg0MTZM?=
 =?utf-8?B?NVhacDNpbExSSDlNNnEySVAza3RRSjdOaDFLL2hYT25MZHNjYmowRHJSUVNa?=
 =?utf-8?B?R3RtVGc3dUg2WEkxVU1HWVVjR0lIcWhCUXBLMytabXJBa2E1Y3NkQ3ZiMDdj?=
 =?utf-8?B?U0g1MHhlSlpNa0t0M3VSQVFmWDBIS1Bhdk92bktDRkNodS9xL0R6VnBXS0Zm?=
 =?utf-8?B?d2l3Rit3cjZjTklKd3JHWkxYS0VZaWR1WGtZenVMZEt2MGFOakNNZnNDRzM5?=
 =?utf-8?B?dWpObm1FWUR2SHM5RzJyMlNmbUtWdXlxSTBlSWx4bE1GNFhsUjVDTVM4dFBE?=
 =?utf-8?B?U2dETjc1YzFTOFR4QmQwTS9FdkVXd0VjMVJKbURNS0J3NVJEcXJubzJtNkgv?=
 =?utf-8?B?RWtsMUZVdFoyVUJMUDdKSnNlQUtLbnNkWTdzR2pZY1dmTjJxZWVkVkxUM24w?=
 =?utf-8?B?ejROM2RrQmJOaG1ISmdSTWFFc1R4TzdFRGhLaFQ2SndoS3lDaXd1Nkl4ei91?=
 =?utf-8?B?bTdub3dUYjk2ZnFYb1g2NDhvd0M2ZTR2ditwVHYvSkVJNG4yQk5lcTNCLzJ3?=
 =?utf-8?B?T3dTWVVzYnVtaW9KTUdUNU5zN1FucTNWOWkwbHFNZHN3M0hLZjczNXZhVlFS?=
 =?utf-8?B?R1ZMcURlSmVjdVRqTXQzcDhTc3p6SDRkL0cxam1LSG54TVV0ck9CRDJPR0F2?=
 =?utf-8?B?aXNtZ2FpbEw1cmRXd3FEUjhCOEJrL2MrTUNVYTRYMDB3VEs4OVp4ZUJLQ2w0?=
 =?utf-8?B?YSt2K08wbThoeHgxOGJsajkzN0pncVpGR3RYamFUMUYvSU9uTHpQU3E1ZFl0?=
 =?utf-8?B?UWgxaWtVSENldjhDWjU5Q3dkMDNzeG4vVVhUUVV1SEo5VHFsbWNyalFkZlJL?=
 =?utf-8?B?OVJuaGhWOVkxRHNiOTVCamZUOHM5MGZhYzM4ZWx2eTU5T1BOQkE3bElIdTVv?=
 =?utf-8?B?SlNOTVhoZW9QSXFaRkJQenNvN1FZaE9QZTh6cWhxcm96QWpCVmsydFRqTDhZ?=
 =?utf-8?B?a29ablVzKzh3dHg0dDJKTzJMYkxEVDZPdzZQYnNlTEZncGZRRUpUUjMwM1hu?=
 =?utf-8?B?eEZ3THhRYmlRTjZVWTVaT1g4M212bGhUaFM5aWt3L0haSXYrVFhvZ2FOSnBR?=
 =?utf-8?B?c21aT2ttZUxMQVd5SjVtMmZIQ3p3djY1cnZvNFB4UzY5YktDakFBb2NkQVhW?=
 =?utf-8?B?M1NnRm1xOHpNazFTWVkrem5oaE5ySjhVd1JQWitheGtSR1hMMkppcjEwRCtv?=
 =?utf-8?B?eXlqMmtBeTZUV05GNjBNWHFLYVFHSFNlLzN6M1J0ZHVjQTZBTmNaVStQYjYv?=
 =?utf-8?B?NHlrOXJhWmo3S1dNRTlMZ2dVMmcwa1RTa3orOWZEMXByWmNYalVVVko3RWhE?=
 =?utf-8?B?WW0rTjdJd0RXamNPczJEeVJPbHIycjZlM1NoNGYzMGo0cTVTWnVEWW1Vb0pG?=
 =?utf-8?B?eER1ZUhiYWVLc0FnQTZteTVsdEdQc0pPaXlGQjdhekNJbEFKcEsvclN4MjlZ?=
 =?utf-8?B?U2VCMzAyT00ralFPcHk0bFZtb3lIQnM2TExMMnM3dGFvM1IyazAxTDZYQzMy?=
 =?utf-8?B?NVZFaGZOMVF0TjdtTmlsN0xxNWJ1eHQ0dXNDODBPM2ZkQjJaNnJjTlNzeURQ?=
 =?utf-8?B?UlE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ec31b155-f870-460b-fd72-08db989eefa8
X-MS-Exchange-CrossTenant-AuthSource: SA2PR11MB4972.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2023 06:07:39.9844
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: avjtsUj3wTe18kPwwWHTcEs44Qee0NgPNkby/hinW8gGtvUL58QQEYcWxrTpzZwA2gXpZjQLd++qeAskqt53vw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6957
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/5/2023 6:02 AM, Paolo Bonzini wrote:
> On 8/3/23 06:27, Yang Weijiang wrote:
>>       if (boot_cpu_has(X86_FEATURE_XSAVES)) {
>> +        u32 eax, ebx, ecx, edx;
>> +
>> +        cpuid_count(0xd, 1, &eax, &ebx, &ecx, &edx);
>>           rdmsrl(MSR_IA32_XSS, host_xss);
>>           kvm_caps.supported_xss = host_xss & KVM_SUPPORTED_XSS;
>> +        if (ecx & XFEATURE_MASK_CET_KERNEL)
>> +            kvm_caps.supported_xss |= XFEATURE_MASK_CET_KERNEL;
>>       }
>
> This is a bit hackish and makes me lean more towards adding support for XFEATURE_MASK_CET_KERNEL in host MSR_IA32_XSS (and then possibly hide it in the actual calls to XSAVE/XRSTORS for non-guest FPU).
Yes, if kernel can support CET_U/S bits in XSS, things would be much easier.
But if CET_S bit cannot be enabled for somehow,  we may have KVM emulation
for it.
> Paolo
>

