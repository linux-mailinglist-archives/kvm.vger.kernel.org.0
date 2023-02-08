Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD0BF68EB94
	for <lists+kvm@lfdr.de>; Wed,  8 Feb 2023 10:36:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230471AbjBHJga (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Feb 2023 04:36:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230376AbjBHJgY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Feb 2023 04:36:24 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2087.outbound.protection.outlook.com [40.107.237.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB9416EA0;
        Wed,  8 Feb 2023 01:36:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JK2E26ck/ixnfGT55lmNl4jRXO74Gd8GjzgMolVSy+9Q/wBTBJ4WnLQzHUxxYjYkGGf4X1xMJ/aIsAj3rMGLUxHGv6SxcUW0CXY21GdQ7ujyFm8oQcc9dgVrtrQnzHpVdBgCBuzMfb1zmli0HBDXFS2ttw3JrKYy071nUz4iTY6ZiJL06Cp0sfp8JhPosKspD1ibtIX+irlsepp3HOYifLmbclpACCbHdxIE/GE9aOfOmK822H3Q+2klg6ubdgsXVqoWrtTTcnWOQv9SLt/lRLOgo0u95Uqzb6rMNww7DKYvmGTYi/wxO6sKD7VB1wRhDI+g7D3CsvQdCZcDPipXuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R9GE08vBVLKjVPGl0X/0OoidnF0bVSasjovp7xNUZHQ=;
 b=ofCa/Er9r5gWyY+T5h70bvWtvIkTUmo9ulB5R4SF2/MMJB4/4oMCl+afvFL5i2GNi+4puoUqAg7aKLQZMc3Ya/1Uu23OAxQN0aOO0TG1N6XKvv9QwdyFc2n1xbHlHPsy7zO8JT1Wmv1+BASrJ85vwYwa07KgJmvD4VhuW33iaZS6Stpwx+CquWhIhIw0mZ7KYEdOVZNVqfrraSf+rEzPZKVoKuq96clMW0gPMppz90wHkZfC3Z2TsOExaVXKpCwjnUkOxKGwVJKVydWO3YdaAJdTM6K4v1GV2UYePCslvB9XfJ2XunrJRbQokHDTYm9kWqsXfpIg9Bxg+jJC7YDAdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R9GE08vBVLKjVPGl0X/0OoidnF0bVSasjovp7xNUZHQ=;
 b=RtxDsFwnlhTE7Pd8enTfbS0B/6gcm+KymEAad6r24k/ZOvhyw+OcbTWFaElE1i+SGLjZ/F4yA9yeReA37XMVKHUkGI8e/FS2lGbBDuqc9j+Zt+6eHo2YSWmW4cbIojq0BDqomZieqTOnb5UdKUCwo6OA+McBWIMV5l13zelwNMI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CY5PR12MB6323.namprd12.prod.outlook.com (2603:10b6:930:20::11)
 by IA1PR12MB6332.namprd12.prod.outlook.com (2603:10b6:208:3e2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.36; Wed, 8 Feb
 2023 09:36:03 +0000
Received: from CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::caf0:cffe:94c4:df18]) by CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::caf0:cffe:94c4:df18%2]) with mapi id 15.20.6064.031; Wed, 8 Feb 2023
 09:36:03 +0000
Message-ID: <93051e27-ae2f-826c-d2fb-03d3144d092e@amd.com>
Date:   Wed, 8 Feb 2023 15:05:46 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v2 07/11] KVM: x86: add a delayed hardware NMI injection
 interface
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Sandipan Das <sandipan.das@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Jiaxi Chen <jiaxi.chen@linux.intel.com>,
        Babu Moger <babu.moger@amd.com>, linux-kernel@vger.kernel.org,
        Jing Liu <jing2.liu@intel.com>,
        Wyes Karny <wyes.karny@amd.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
References: <20221129193717.513824-1-mlevitsk@redhat.com>
 <20221129193717.513824-8-mlevitsk@redhat.com> <Y9R1w8kfQjCNnEfl@google.com>
 <Y9mEMNGXe8lG5oW8@google.com>
From:   Santosh Shukla <santosh.shukla@amd.com>
In-Reply-To: <Y9mEMNGXe8lG5oW8@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0207.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:e9::18) To CY5PR12MB6323.namprd12.prod.outlook.com
 (2603:10b6:930:20::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6323:EE_|IA1PR12MB6332:EE_
X-MS-Office365-Filtering-Correlation-Id: dddcf62e-d97e-4d53-8376-08db09b7e507
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KFxDaT2a3CJTesChBDQOHYBcENaTui8+0WTz6vvZmxdwiSMMr5lZtZB5hr/HSWKQlF/KguP7+iOgyUu5a0SUvF0jPvQuCpllCfSyE6PdNTIDHoTcqOgbNxiQL/eaTsUbqsO3n7pBs3WmRLhnhL4Yku7SsoO9qU/8qDnsk7sl3MAo8fPETaauqzTB/CP395liCOi7orvUK/mx7kldagGw6LgPh4bjHA8EMGT2Db64z2bkYhxeDWGHoubQNzyg7xk+qYBvvUV+gKiaWrKTqIYO3glSOs7mmrEpVm4XlkagHiE/rc7HszYvxw2fALyc4XjIRLOCWKPpsqT2q7n84TXcJW/hsNv5Ile8I7q+k0aBWJCgmAtj3gjY/U0C9H8DUQ5ivZMxWWb8JAKU+l3W4BmhvvQbrX2AOLCCnWsiy7WYsmHw/zodNi2xI8RReLHy1HEcMCPcwm+KMEZ3SWGkp2E6tzHMDsfpXMUFedGrAAqAGh5ZLcLDO1Ob1/hNpFEQoAUgSxs2Sjjnh4dZTcw5fFL+xof71hZ3cF4d8+MjICmQ17HDOWwr7H8zFHca2FJQlAVEkfm8mNq8CqlBf7CJZCdO90am0dxcicNevBA14BZBbyxotbSnZij9lk/NQkXs+C8iCtI2a+hxjlbTsK+BCpuhcJe31i4w/4bzNxzIYECHFoZm0MyG2HMXloSsaJqctlD85PWUiuSweS7Av5kZ94SxcFbDrf6fVremkuW3lmig2wE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6323.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(366004)(376002)(136003)(346002)(396003)(451199018)(7416002)(8936002)(5660300002)(2616005)(31696002)(66556008)(66476007)(6486002)(66946007)(8676002)(4326008)(38100700002)(478600001)(86362001)(41300700001)(54906003)(110136005)(2906002)(316002)(36756003)(53546011)(83380400001)(31686004)(6512007)(26005)(186003)(4744005)(44832011)(6666004)(6506007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eGkzUFRJK1RvcklzUUFEYlplSjBNVFlJRFZIWTZMQzNLZnNGWko2VnNTNjVm?=
 =?utf-8?B?TVF5VTRDakgvdTNINUtiT0gySWIzbXpENHBUaTlDc1BRZ3ZRWHFXam1RWkor?=
 =?utf-8?B?bWg0bTZzU29QZm0zZTY1K2RFeE16R1ROazZIMCtsdmp1ckRkM0VYMmFTTjRj?=
 =?utf-8?B?SlN3c3pvTHhuSVQraUNUdjA5dDZCOG01MURsTU93SG9CNlZMUElsc25vSWR3?=
 =?utf-8?B?ZXlYTlArSWZGU3Q1RmJHaEFoNE00TWd6K3hva3V0NU5jNEY0Rk04QzRqRysw?=
 =?utf-8?B?VkczN3YvbXE5OEdFUTA0T0I5WEFxZXBXS292bkwwQ2RUNVB1T3UzdUNWYktk?=
 =?utf-8?B?NDRJdWYwTUlROGZubm9HOHQ1Vk0xWkZ6MDduOVRKZHBoSmZSVHpOV3R5R2FB?=
 =?utf-8?B?bWg0SzI5cVBockhkQ0JvM1hsR3ZEeGJZRE9GUG1VZ3N1ZHcyK2dvSHZFL3Fy?=
 =?utf-8?B?SkZ5SEVscFZtamFVTkdHWjgzTjVlS3RabE5jRlhCNWR6ek5rek1rOU1ONHRM?=
 =?utf-8?B?OVdDZ05mdXo4MitLUjlDaFVuYVI1eXJtVzlhbHZ1a0Q4anRpWTdUdXVUWmZP?=
 =?utf-8?B?M080Tml4ZGMwTXFkcHZIdEh0ajB0SzFncWc2VDQzQVQvd2RCaFFiRkJpeHp2?=
 =?utf-8?B?NTFudXRRQkJqQzRMOUxiVk5JUFNXVTM3MWdoNmZZdlVJNUZKSCs5QTdJQnQ0?=
 =?utf-8?B?VEEyVVdiM3BKTXE4cDhhZ0FHQm10dEpvblVVOFJDL1hOVzdZeWw2ZGxnRjd1?=
 =?utf-8?B?QUthS1QrZ3BaWnVDcVJaelJ5S1hKZG5KOVFuZnd4dTdZRXNUMkFRVDkxcE04?=
 =?utf-8?B?Q3dPRWNuNmFVWkJ3ZUVscFh6N2NncFBrZ255eVd4YXZrWlA3eWh5d1NiNDRh?=
 =?utf-8?B?MnpVNlJjcDd4V1A2dElUMVZ0Zmk1NVhlMHpLODZZR3h6UmpBYlIyT3JPUWU2?=
 =?utf-8?B?MEhZWVRncGNiQXdRMW84SGMzTXJEM0tSNGdiaEpwY3k3ejJ0VWVvMCs2ejNU?=
 =?utf-8?B?d1cwVjJha0ZsSm1wSFlBSkptL1V6RWt5K3N5WUJFL2kvNnBLU0gzUithdDY1?=
 =?utf-8?B?SDhpQUtoWC9xUm1CUFhXN1Iya2wxd0xPUXZ5c3FjZ0ZnRGp0QUdmM1JaaDV5?=
 =?utf-8?B?aW1GL1hHVzUrSm5TeDR6NlZrQXBKNGFYanR0RC8xZlBOck9sQnZlVXhqNkpE?=
 =?utf-8?B?RlFCcWdYSWVxNUFnbjI0MDBuaE9Pd0VYSVpqYTZ5cTFYdkx2aHFpdzVqa2VT?=
 =?utf-8?B?V25IbWowZER6NTBrYjRYMjVCWlU5VmFZcHo2THJoc1NGS2VudFJ3TGlHVGNW?=
 =?utf-8?B?eWU5U1FxM1Bhb0VvNEg1SWh6WnpMcnJNYUswR0U2VUI3M0UycGVPdmpGU3hi?=
 =?utf-8?B?RVR5N2t6WmJOUUQ5a2lyVE5uaFhGYjdJczlMd25ReVU0ZGpuN3E3NDdmYjZa?=
 =?utf-8?B?NUJIR3RqaWk5NHlZL2dtbkNoY21Mem9ncUxsSU9DbUxmK2xOblNXMDFtcUtR?=
 =?utf-8?B?TzFSS0pMOTA1TW9makJkTlo0THkvMnh5dEg2MGRwOHRCOGc0MUo2ZExFR0VJ?=
 =?utf-8?B?a3lSTlNrZkkzaXdKeXE5eXBlRnlSaGZ6a0ZMYW9vUnVmcDY4MUVDa3dYaWJo?=
 =?utf-8?B?eVdxTHFjZERFUVhXZm5DWXFGVkdIMHlBTU5FbElid3o2UlJqYTRMUEFhUUZQ?=
 =?utf-8?B?ZHptd1I2bjk1dFowVkZKV2xHWXVqczJybkJDTG9WUjJENkVEQkM0WFM1OEsv?=
 =?utf-8?B?M2hHaUFUUzBVb08xZGlDam5TZTQ5bDFtYUY0cURBRWdhSmJLanRoRWdUa09H?=
 =?utf-8?B?Wm5MdnlaaEhYeENZcllZeUtGaFRlUWhRV1hqRjRHWDBIZFdPaHhsNHpUSitI?=
 =?utf-8?B?WmZobEdMMmkvck9TNWJya3JRV29oT2oxaWVOYXpkYjVqblZLZEd6eEpVR2lW?=
 =?utf-8?B?SFRzdW1HZGFFaWdVckVkcFcrMmlhWmZyQ0pLOENEWXc2V3lwajdpMnVzTSta?=
 =?utf-8?B?Yk1OaVRPS3FHV2M5ZW95c21KMVpHYlZ5cURuczhUWkFkdW1lUXNPZ2h2RXdM?=
 =?utf-8?B?YjFoSWRQY1lLMk01MVRrcHNTRlltckpiUFVqK3VXQWVXbTI2RGx2REFGRTVm?=
 =?utf-8?Q?+RPndURYv5UhKIcu8nOxmRfg4?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dddcf62e-d97e-4d53-8376-08db09b7e507
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6323.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2023 09:36:03.3102
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VJ4iUOvDzsk8xKCOcwxmPUlaMC4NtqxALtMdBUm1kbb0CMU136Ri0o15g7sZ0tt4dZDyOeBaC72zwF5UZnrSMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6332
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/1/2023 2:42 AM, Sean Christopherson wrote:
> On Sat, Jan 28, 2023, Sean Christopherson wrote:
>> On Tue, Nov 29, 2022, Maxim Levitsky wrote:
>>> @@ -10015,13 +10022,34 @@ static void process_nmi(struct kvm_vcpu *vcpu)
>>>  	 * Otherwise, allow two (and we'll inject the first one immediately).
>>>  	 */
>>>  	if (static_call(kvm_x86_get_nmi_mask)(vcpu) || vcpu->arch.nmi_injected)
>>> -		limit = 1;
>>> +		limit--;
>>> +
>>> +	/* Also if there is already a NMI hardware queued to be injected,
>>> +	 * decrease the limit again
>>> +	 */
>>
>> 	/*
>> 	 * Block comment ...
>> 	 */
>>
>>> +	if (static_call(kvm_x86_get_hw_nmi_pending)(vcpu))
>>
>> I'd prefer "is_hw_nmi_pending()" over "get", even if it means not pairing with
>> "set".  Though I think that's a good thing since they aren't perfect pairs.
> 
> Thinking more, I vote for s/hw_nmi/vnmi.  "hardware" usually means actual hardware,
> i.e. a pending NMI for the host.

Ah!,. better. 

Thanks,
Santosh
