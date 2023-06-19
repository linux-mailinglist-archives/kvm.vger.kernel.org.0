Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F6F0734BCF
	for <lists+kvm@lfdr.de>; Mon, 19 Jun 2023 08:42:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbjFSGmJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jun 2023 02:42:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbjFSGmH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jun 2023 02:42:07 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B16ED138;
        Sun, 18 Jun 2023 23:42:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687156925; x=1718692925;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=oEmhAB0DWxOkufFaBhCDtyopsEsdOzxghZHPynk7A90=;
  b=SyXx05qt5uGqFvlCqzN8V4zOXOuwKqlzpgUbOEdQkm3X7AUMxj6gLpVD
   cjB7IqHU6DgKMJPaqyhXoMKfpZGOUyL4bOR8ibHTyyFcf8qHRKKpgrkqy
   Lx8aSjrnnNyJhb2HmCAQTtYfrzIgx7O1QB0Z1J/5gdV6lARvjoSQJuwGt
   OeQxY4ay0UfGVk9YamU9Y+xIYrnNillGNzB8gnywySF+mtcCcgSRWklkM
   HhoZxCB4E61rwCoNd3GalmneqdRtBLUR+jEAy4ARgSkYNJWvyruxEQQOB
   xKbEJcj+M/pDKUzhEsc7vvKjp7H4gpa0Ny11y0nZaAs2gdICWlmjxJy1G
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10745"; a="339892486"
X-IronPort-AV: E=Sophos;i="6.00,254,1681196400"; 
   d="scan'208";a="339892486"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2023 23:42:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10745"; a="707780291"
X-IronPort-AV: E=Sophos;i="6.00,254,1681196400"; 
   d="scan'208";a="707780291"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga007.jf.intel.com with ESMTP; 18 Jun 2023 23:42:04 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sun, 18 Jun 2023 23:42:04 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sun, 18 Jun 2023 23:42:03 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Sun, 18 Jun 2023 23:42:03 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.177)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Sun, 18 Jun 2023 23:42:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FuNSY0p6ppzFN+A+5em5kSq+EdIrDuhBjilNWB/NHwKn1u13cx3+vBE6HgvDORPfTBNtMqTuOFuOEdkiUPzFy17157Qz5WKmKRaOtl1Vi/NbiP1i/NUcDB8SD4TShubeOqESiArqdtSPl93vwLp7qj0u01WGC9EiYu3Br1ovjGW3j+bZe5DWRpYwoLJ/1cHR6Z4pOW8WAe6I2BRhKCs61EpOeugJdVK9TO/fvxQAdBbz2ocSr9SAjYD8bjJ08u9UIu0w0CUcz4UnNBmRTmJxg9sKn9BpGH+Mx+xnUFZimVIUaofvYmbjJ89UipyBY4zBQr+kHhuaM32nknJqjnDF4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BJQOpvan12PJAM3bGNoaspfLuiUJPGLkCKnwVJ94UM0=;
 b=Oizu3uDbN5Qk3eb/NFw3z2i6Iv7bhfXesJ+rshxUdRAwmQy3ryVGh/4rkpBJ3M9MhWx9oLtzg1YQ9eV6iV4q9c2Dap5igLB99LushJHHMGY0IPLoc4AI4rcdh48c2HPnYpOygH57qxjjjteVJN6hRXgT4C7uV1lPKoQ85exUmGf34CCnczu6341kulqqG+jiLT7wQiM6Fbxw9NAw1DpdhkiS/C4zN6WfGh++95e8i/9bps4A4adscoAnQjhKuq/4KxZZACQwUoLkMGqKyySMeJ+p3DCWenukCZcvuOudZEKGzS7GDjX7e4b2O4q1xTBbhISSxxpT43yKYItKDgGNcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by SN7PR11MB6679.namprd11.prod.outlook.com (2603:10b6:806:269::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.37; Mon, 19 Jun
 2023 06:42:00 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::4707:8818:a403:f7a9]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::4707:8818:a403:f7a9%6]) with mapi id 15.20.6500.036; Mon, 19 Jun 2023
 06:42:00 +0000
Message-ID: <c438b5b1-b34d-3e77-d374-37053f4c14fa@intel.com>
Date:   Mon, 19 Jun 2023 14:41:50 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v3 00/21] Enable CET Virtualization
To:     Sean Christopherson <seanjc@google.com>
CC:     <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <peterz@infradead.org>,
        <rppt@kernel.org>, <binbin.wu@linux.intel.com>,
        <rick.p.edgecombe@intel.com>, <john.allen@amd.com>
References: <20230511040857.6094-1-weijiang.yang@intel.com>
 <ZIufL7p/ZvxjXwK5@google.com>
 <147246fc-79a2-3bb5-f51f-93dfc1cffcc0@intel.com>
 <ZIyiWr4sR+MqwmAo@google.com>
Content-Language: en-US
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZIyiWr4sR+MqwmAo@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI1PR02CA0032.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::12) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|SN7PR11MB6679:EE_
X-MS-Office365-Filtering-Correlation-Id: cbf76bc2-85f0-48a2-2eea-08db70904860
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V7YUJEm1cTITlw/U6itVfnVLF/yEnp5iYlqlILZMEUje3dxmc60dhS96NeIV7ju7OeNsJ4ZY39KZKBQLnHu7r3ecH5bIvusNgoJCnQPW5IDveTeV4drVzcg4gmQPpwl+ihyVlk5UYilA/IJfXDnIhdX+eTZJ97MMT+BbDPamJa82IZD3IWkh30exEJ7DqjT1uoawwFBJmNQ/Gh35PDLDFtpLWPQtcr2ygjqsScDNWSvlKoNB46dWlm69ePjtnO/GhaTb35Yx3OhcP7KfhsBo0P7MMKpaz3HRcDC8Iu7mKLh1MChkEgCNRGc8wlBO4j/QPA58BMi53KixW08keGHhNtZK4fQqEBGDBhoYtYnaEp4F6s0htVSfWfejGZFI6pOxdrNzf8riwoKB4K8vvVBDrdACoi/fLOaDZqKceOIJ76hbzVpMi8u1Qpd76vNIlfGI0uKtIHz9+7bg+mEJBwyHQd0f56zzCriTIjERj383YK7kCiMdaqrrpUtCded8N6G8V5cua7Pr7yYOssOWG3gv9TU3zDBuVcKiATUcbjCUMdxVthGSLcPVv28vB0xU6j8WJLN9XCvel8xdkyGqXIik1j8uFbTRCPULq26aoNb2fAGnfdYtcXgxyU8I5WYPXU4gjyJ1DiTVil+VbEYNmtSpnw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(376002)(39860400002)(366004)(136003)(346002)(451199021)(31696002)(478600001)(2906002)(6666004)(6486002)(2616005)(86362001)(36756003)(26005)(186003)(6506007)(6512007)(53546011)(8936002)(8676002)(66476007)(66556008)(66946007)(5660300002)(38100700002)(316002)(6916009)(4326008)(31686004)(82960400001)(83380400001)(41300700001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T3JuSy9VRlVmUWV2VmpQYVQ5QnludFgwZUVUUWZCMzkrV1JtNlk1cU1EQVph?=
 =?utf-8?B?UEkxZnk4dkNRaXFYakQ2QUZ1aGx3Y2IramlpTVVUVkV3ejBGMXF6alJndjNm?=
 =?utf-8?B?R2MzVU8zM0piYmQ3ZEttZXRaeWoxRWJsSDBYTHRwd2pUczF2bVpLdWdkM1Ax?=
 =?utf-8?B?VWdlVlg4RkVLeU1mb0V1R041M0FSVXVBMVM5V0xmWXJwTUpxM1FldXluMDhh?=
 =?utf-8?B?Q0NNR1RSWDh1TDBqSFFsUFduUStXa0IycW1NUEYvOGZtWUpSUTFPRno4RTBq?=
 =?utf-8?B?YzBqbG9TZzhJZFh6dDA5bHZPMnJBYjEwZnNNeG8rRHc0V1VKVkpFZkdXczE0?=
 =?utf-8?B?V3JFVFRMVmp4M2xuaHFBdHRlZlRtNXJXN3VQOWt0K0VaV09SSitDN2lWeG9a?=
 =?utf-8?B?ZGJMVVVLbEdUNXhnK0tEM3BTSndNQWlVeEtiZjh6SW1xOUN3T2lWQmRXUGVK?=
 =?utf-8?B?MUw0WnJGQjRmUjdZUnRSd21NRi9BNGdHWjdzM1FpTlRTRmhwOWpUN2M4OVdW?=
 =?utf-8?B?VjBJSHMwcHhCd21NenZiK1VYcng1c3RITXdxRlQ0VUJSaVM1QnF4R3BMcCs3?=
 =?utf-8?B?c0tzd3dySmgyTU9Jd1l2a2g4UldleWJrNmdIamxGWGJrc3c2T3piVDJ3eUxj?=
 =?utf-8?B?YUlOMTlSRFRSbWd1TTQ4YUs1SjRmQVFpdnMvWXJIVFg4RGcxVXhmbUdaOHhs?=
 =?utf-8?B?LzJhc21NWEpkVGdiOGx1N1lSSkgyTFdMcHJkNWgrVklsdG5NTndIcnhXTTVp?=
 =?utf-8?B?Z0VzN2RSQktOVDFtZFhNWnhVd0E2RmdMcnJhZUo1SkFmbnA3cnB5NG9OUXF2?=
 =?utf-8?B?QnRDNXlCaEpVbGtLVDRTaVFOajFzaVRYY0lkVlBQTm1qa1RGaXdSZUxRWnA0?=
 =?utf-8?B?cjV3ODlJdS9PN3ZObTlkOFBmSVVwYkEvOVJabHJLRjR5ZTF5bE5QLzlZanJ4?=
 =?utf-8?B?RlI4OGV2TDFMY0pkZ0xrdnIrTnZnTCtZa01SbmttbElSV2J1bzczQ3p4MGI4?=
 =?utf-8?B?S2R5UysvTXFrZ1EySUpLbDFzeFV5MjlJLzFaeXo3RHdESVBmYVFhVHVPMzVS?=
 =?utf-8?B?VG5iMUpRRjRaY2hIdUdyOFB5Q05kNjNzbDVyc3ppQnBlcm5TQVltWldNZ2Z0?=
 =?utf-8?B?dE5KQjY4TFFsQ3JKbklXbTBvWjFkUVpHSmpDcVRNQ1ZrMmhjS29QUE9SRTJs?=
 =?utf-8?B?STZLUVJlMDBIbm1wZ3FML01iRkFFZ0kxZFVhMmh0eU5pbHNyUGtQRnlKRzlP?=
 =?utf-8?B?TVVyVWpnNXVOMUwvZmFXcTJ3OVhsUlRQUFZ6L0RPOGJHc21hejlLdGtkRjNw?=
 =?utf-8?B?aWlJaUNHVDBXeWY4bU9KNVNFdG4wT1lrUmNNNytpTXV2b0ZNZVVpUERXMlZW?=
 =?utf-8?B?cjE3YXg1aGF5SlZTbXV3NFdYaUhRaFp3ZGtOd1ptY3U2TlVNZ1ppUFg2WGp4?=
 =?utf-8?B?UXV3OXJ4SzY0Y3I2bkhmbEZWMW9FUlJGc2NPdE9NODBZR2pRSkJLdzc3STdN?=
 =?utf-8?B?OG94bnFwTHV3OEFSalIySkxLNmcvSk1rM08xd282YXpGcTF2WG9uTU51V1BX?=
 =?utf-8?B?Vzg3blNxQW5MOHcyTmhVNitsdXp3dmNicWI5cXVERGtZL3BqVkYwa014TjRK?=
 =?utf-8?B?ZnR2SmpqblorT3pPdDBDdnh5K0t5WXlqMUMxb2lpSVdyL2NrLzZ1WTMzTC8x?=
 =?utf-8?B?UElSTmdvSDEydGl1eE5VdE56T2xWa0hnQXhLeDZ6dXQ5TWlPYkpUc1prbzJJ?=
 =?utf-8?B?Rkt0cVJ1dkJFYWkwNFg0NFRqempLdnI5QWEvbmdWN1Z4bWdsdVFDTkFFL0ZF?=
 =?utf-8?B?Y2hPdk1VR3BoUXdWYjVTUFlsODVjMmpTbVdNdjZkd0RYUzVpVUh5R1VNWXQ5?=
 =?utf-8?B?dFpiSzAvNjhjUE5LbnYrL05YeEZ2a3pDNHFOVWpaby9HL0UvM2NTL1dOUzhs?=
 =?utf-8?B?Zm5La2FsV1NYT1FyVFIrcTAvbmVXaU5BWjB6ekpBTWpITmpxYnA0RWJHSXJx?=
 =?utf-8?B?a2w5c05LanZ6NFE4Uzh3WCtJQXhiSU04RUZ4eFFGRElMWTBQN3FKcTJrR1RT?=
 =?utf-8?B?Yk9XbUJ6QW00SHlVSXFxaUIvZytrOGRsWngzVk1CT0lZZFFQTkpTNzZQYXEr?=
 =?utf-8?B?STgxUHlheG82TVlEOHJFRVpmMGlNSklpbmxMSENkM2NscW9tTkVOV2RrMmVx?=
 =?utf-8?B?Z1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cbf76bc2-85f0-48a2-2eea-08db70904860
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2023 06:41:59.8075
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j5vZAzSmmlrzruIxt55A8ERAfHODEJo7/DMwm4f2aWTmQs5IKAZMgFBAZpEOSVyLaWlVA1enAeUrV+I623dpzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6679
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,TRACKER_ID,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 6/17/2023 1:56 AM, Sean Christopherson wrote:
> On Fri, Jun 16, 2023, Weijiang Yang wrote:
>> On 6/16/2023 7:30 AM, Sean Christopherson wrote:
>>> On Thu, May 11, 2023, Yang Weijiang wrote:
>>>> The last patch is introduced to support supervisor SHSTK but the feature is
>>>> not enabled on Intel platform for now, the main purpose of this patch is to
>>>> facilitate AMD folks to enable the feature.
>>> I am beyond confused by the SDM's wording of CET_SSS.
>>>
>>> First, it says that CET_SSS says the CPU isn't buggy (or maybe "less buggy" is
>>> more appropriate phrasing).
>>>
>>>     Bit 18: CET_SSS. If 1, indicates that an operating system can enable supervisor
>>>     shadow stacks as long as it ensures that certain supervisor shadow-stack pushes
>>>     will not cause page faults (see Section 17.2.3 of the Intel® 64 and IA-32
>>>     Architectures Software Developer’s Manual, Volume 1).
>>>
>>> But then it says says VMMs shouldn't set the bit.
>>>
>>>     When emulating the CPUID instruction, a virtual-machine monitor should return
>>>     this bit as 0 if those pushes can cause VM exits.
>>>
>>> Based on the Xen code (which is sadly a far better source of information than the
>>> SDM), I *think* that what the SDM is trying to say is that VMMs should not set
>>> CET_SS if VM-Exits can occur ***and*** the bit is not set in the host CPU.  Because
>>> if the SDM really means "VMMs should never set the bit", then what on earth is the
>>> point of the bit.
>> I need to double check for the vague description.
>>
>>  From my understanding, on bare metal side, if the bit is 1, OS can enable
>> SSS if pushes won't cause page fault. But for VM case, it's not recommended
>> (regardless of the bit state) to set the bit as vm-exits caused by guest SSS
>> pushes cannot be fully excluded.
>>
>> In other word, the bit is mainly for bare metal guidance now.
>>
>>>> In summary, this new series enables CET user SHSTK/IBT and kernel IBT, but
>>>> doesn't fully support CET supervisor SHSTK, the enabling work is left for
>>>> the future.
>>> Why?  If my interpretation of the SDM is correct, then all the pieces are there.
> ...
>
>> And also based on above SDM description, I don't want to add the support
>> blindly now.
> *sigh*
>
> I got filled in on the details offlist.
>
> 1) In the next version of this series, please rework it to reincorporate Supervisor
>     Shadow Stack support into the main series, i.e. pretend Intel's implemenation
>     isn't horribly flawed.

Let me make it clear, you want me to do two things:

1)Add Supervisor Shadow Stack  state support(i.e., XSS.bit12(CET_S)) 
into kernel so that host can

support guest Supervisor Shadow Stack MSRs in g/h FPU context switch.

2) Add Supervisor Shadow stack support into KVM part so that guest OS is 
able to use SSS with risk.

is it correct?

> KVM can't guarantee that a VM-Exit won't occur, i.e.
>     can't advertise CET_SS, but I want the baseline support to be implemented,
>     otherwise the series as a whole is a big confusing mess with unanswered question
>     left, right, and center.  And more importantly, architecturally SSS exists if
>     X86_FEATURE_SHSTK is enumerated, i.e. the guest should be allowed to utilize
>     SSS if it so chooses, with the obvious caveat that there's a non-zero chance
>     the guest risks death by doing so.  Or if userspace can ensure no VM-Exit will
>     occur, which is difficult but feasible (ignoring #MC), e.g. by statically
>     partitioning memory, prefaulting all memory in guest firmware, and not dirty
>     logging SSS pages.  In such an extreme setup, userspace can enumerate CET_SSS
>     to the guest, and KVM should support that.

Make sense, provide support but take risk on your own.

>   
> 2) Add the below patch to document exactly why KVM doesn't advertise CET_SSS.
>     While Intel is apparently ok with treating KVM developers like mushrooms, I
>     am not.

will add it, thanks a lot for detailed change logs!

>
> ---
> From: Sean Christopherson <seanjc@google.com>
> Date: Fri, 16 Jun 2023 10:04:37 -0700
> Subject: [PATCH] KVM: x86: Explicitly document that KVM must not advertise
>   CET_SSS
>
> Explicitly call out that KVM must NOT advertise CET_SSS to userspace,
> i.e. must not tell userspace and thus the guest that it is safe for the
> guest to enable Supervisor Shadow Stacks (SSS).
>
> Intel's implementation of SSS is fatally flawed for virtualized
> environments, as despite wording in the SDM that suggests otherwise,
> Intel CPUs' handling of shadow stack switches are NOT fully atomic.  Only
> the check-and-update of the supervisor shadow stack token's busy bit is
> atomic.  Per the SDM:
>
>    If the far CALL or event delivery pushes a stack frame after the token
>    is acquired and any of the pushes causes a fault or VM exit, the
>    processor will revert to the old shadow stack and the busy bit in the
>    new shadow stack's token remains set.
>
> Or more bluntly, any fault or VM-Exit that occurs when pushing to the
> shadow stack after the busy bit is set is fatal to the kernel, i.e. to
> the guest in KVM's case.  The (guest) kernel can protect itself against
> faults, e.g. by ensuring that the shadow stack always has a valid mapping,
> but a guest kernel obviously has no control over, or even knowledge of,
> VM-Exits due to host activity.
>
> To help software determine when it is safe to use SSS, Intel defined
> CPUID.0x7.1.EDX bit (CET_SSS) and updated Intel CPUs to enumerate CET_SS,
> i.e. bare metal Intel CPUs advertise to software that it is safe to enable
> SSS.
>
>    If CPUID.(EAX=07H,ECX=1H):EDX[bit 18] is enumerated as 1, it is
>    sufficient for an operating system to ensure that none of the pushes can
>    cause a page fault.
>
> But CET_SS also comes with an major caveat that is kinda sorta documented
> in the SDM:
>
>    When emulating the CPUID instruction, a virtual-machine monitor should
>    return this bit as 0 if those pushes can cause VM exits.
>
> In other words, CET_SSS (bit 18) does NOT enumerate that the underlying
> CPU prevents VM-Exits, only that the environment in which the software is
> running will not generate VM-Exits.  I.e. CET_SSS is a stopgap to stem the
> bleeding and allow kernels to enable SSS, not an indication that the
> underlying CPU is immune to the VM-Exit problem.
>
> And unfortunately, KVM itself effectively has zero chance of ensuring that
> a shadow stack switch can't trigger a VM-Exit, e.g. KVM zaps *all* SPTEs
> when any memslot is deleted, enabling dirty logging write-protects SPTEs,
> etc.  A sufficiently motivated userspace can, at least in theory, provide
> a safe environment for SSS, e.g. by statically partitioning and
> prefaulting (in guest firmware) all memory, disabling PML, never
> write-protecting guest shadow stacks, etc.  But such a setup is far, far
> beyond typical KVM deployments.
>
> Note, AMD CPUs have a similar erratum, but AMD CPUs *DO* perform the full
> shadow stack switch atomically so long as the stack is mapped WB and does
> not cross a page boundary, i.e. a "normal" KVM setup and a well-behaved
> guest play nice with SSS without additional shenanigans.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/cpuid.c | 10 +++++++++-
>   1 file changed, 9 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 1e3ee96c879b..ecf4a68aaa08 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -658,7 +658,15 @@ void kvm_set_cpu_caps(void)
>   	);
>   
>   	kvm_cpu_cap_init_kvm_defined(CPUID_7_1_EDX,
> -		F(AVX_VNNI_INT8) | F(AVX_NE_CONVERT) | F(PREFETCHITI)
> +		F(AVX_VNNI_INT8) | F(AVX_NE_CONVERT) | F(PREFETCHITI) |
> +
> +		/*
> +		 * Do NOT advertise CET_SSS, i.e. do not tell userspace and the
> +		 * guest that it is safe to use Supervisor Shadow Stacks under
> +		 * KVM when running on Intel CPUs.  KVM itself cannot guarantee
> +		 * that a VM-Exit won't occur during a shadow stack update.
> +		 */
> +		0 /* F(CET_SSS) */
>   	);
>   
>   	kvm_cpu_cap_mask(CPUID_D_1_EAX,
>
> base-commit: 9305c14847719870e9e08294034861360577ce08
