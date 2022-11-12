Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 309FA626613
	for <lists+kvm@lfdr.de>; Sat, 12 Nov 2022 01:46:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234606AbiKLAqx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Nov 2022 19:46:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229830AbiKLAqv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Nov 2022 19:46:51 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2080.outbound.protection.outlook.com [40.107.101.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9022C7723E;
        Fri, 11 Nov 2022 16:46:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kwF5mgCwdyhsleeX4FlPRgE/hvau0BiccnqZssvXIvFsy2y4QDdZjm4/J6uuWOqI+c7Jc56ISuOhNiemG2j5rOi9678b6TfV+G4AGUf1mPFwI/sLfnt4V2dBSkc0dAJ6ci6xTcEMI3N+icoDqAyWdmEjoIzBxECXtVDnybL4xmFrTfXQ9pi9bANT/3urPyrpw+Jtf5JAvINgW9T5vBXxSj9CHHayfXZhM+MHyO0uDLdHJa4NIrV+rFi0gcJnIf1NAXljcz164Sc3pcvQg+dan68/i7BAuLJlYOEKuSIZLZIhPGHn+RCqIZejGG7TZk/nlyQzYT9qJcbxeg1ErcQAig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QMa5OkQ/aGJZWSfVoCiWXvbq1TC3XmnSDnNwjTQKFDk=;
 b=b5Gnoi3iabBe/4L0FVIGeBl/CD/LrBhmxZLG4Fs+q37ZcJ0HxX1QP5ncQSjnIqlQ4JR6/w//6lhOsQAbBZ0TeU5sdCpue0B6wpMQ7mhTP3ci9PG5GzADzaGcjn6cxMUGh3KycshmhMI3Dcp160FJITd3Q5RxPk21s7+xb9Th8eTw6OVkWG0c67BvmGJNt7g3OwcdGrIsBQMOFVSQ1CBiaPRTpCBFDYPfSbhMZ4NpAIOLw654GjPXBKUSRfpIB21hZ4Tox5aBl5fDVT6J8CHmW0xLVFNjli4Aa/wZJhz9T3MKwMM5Fy02O1/m0dr3CbT+s3l01ZXVW3TAtexmJbDTOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QMa5OkQ/aGJZWSfVoCiWXvbq1TC3XmnSDnNwjTQKFDk=;
 b=vzmbeoH4DpChBm1Vwdz9W54pPtnDWDvXKQeAUL9jHHwSZ+4LUQE7Xt4CIxVd2KYPEAp/ScYLtTORMtcRU98kOMmoEQpM12Xvfm6gErzAkKoREhVKwjwv7/dvFWJzS9+s0mwiM3A8Aph5027VmBKIy4Ow+Vb2HafTGwBjlHDYxLQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6263.namprd12.prod.outlook.com (2603:10b6:8:95::17) by
 SJ0PR12MB5673.namprd12.prod.outlook.com (2603:10b6:a03:42b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27; Sat, 12 Nov
 2022 00:46:46 +0000
Received: from DS7PR12MB6263.namprd12.prod.outlook.com
 ([fe80::818b:be51:fc53:5adc]) by DS7PR12MB6263.namprd12.prod.outlook.com
 ([fe80::818b:be51:fc53:5adc%5]) with mapi id 15.20.5813.013; Sat, 12 Nov 2022
 00:46:46 +0000
Message-ID: <fb91bbc0-7a25-2f2a-163c-517f20dff6db@amd.com>
Date:   Fri, 11 Nov 2022 18:46:40 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 2/3] x86/speculation: Support Automatic IBRS
Content-Language: en-US
To:     Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Borislav Petkov <bp@alien8.de>
Cc:     Peter Zijlstra <peterz@infradead.org>, x86@kernel.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Juergen Gross <jgross@suse.com>,
        Tony Luck <tony.luck@intel.com>,
        Babu Moger <Babu.Moger@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jim Mattson <jmattson@google.com>
References: <20221104213651.141057-1-kim.phillips@amd.com>
 <20221104213651.141057-3-kim.phillips@amd.com> <Y2WJjdY3wwQl9/q9@zn.tnic>
 <Y2ZEinL+wlIX+1Sn@hirez.programming.kicks-ass.net>
 <d413c064-ee9b-5853-9cf1-544adde22c8a@amd.com> <Y247gY9NKYi34er6@zn.tnic>
 <Y25CwmylusloNKsr@quatroqueijos.cascardo.eti.br>
From:   Kim Phillips <kim.phillips@amd.com>
Organization: AMD
In-Reply-To: <Y25CwmylusloNKsr@quatroqueijos.cascardo.eti.br>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0032.namprd03.prod.outlook.com
 (2603:10b6:610:b3::7) To DS7PR12MB6263.namprd12.prod.outlook.com
 (2603:10b6:8:95::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6263:EE_|SJ0PR12MB5673:EE_
X-MS-Office365-Filtering-Correlation-Id: c10bfa88-8a68-48fa-8cbb-08dac447602f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5X8tWdayqqF0qsyxkm1StAiYJCKUf2hDtlQ9QZoKZ0HqUqfwgKYXG7zCMNe2MQi1tHuI7yZZkL23cin/NJHEJ24NrigJjlfA7vuy7OO2ixtGxsm7QAaxuVYbqgn/q2kEhllfa2MbKTzsJqF4B+9FO6pvlyTYXZIoNZXtIFpePSFEF7Y7Uju0uEqFmMGfBX6yNlhaup54sKJl7h50rT9uPR7QqhWkX79UzzH5Y1jYXjy9p/HNgfolLdP1gYcpIOZhjS+l95iLc+Xj5nlOIP96aM6NOOjD5aHNHtGPg1hDt3nIyOOo7u923qVM5IwHESCLXk3yiLVP8oAtzeNx6FuHFtRPSuSAxQee8dlXRzw2LCML9FkU/O3m4UHqt67VqhIbWyD/dVkNcOrl9y5PM/ptQTMumUdF7saFjYH3BuIA5fndFvzQVfX5DTff9r1hGUv+5o2W/7jsaoqs5tXe/KOXbrJCMs/geFjybuBGC8gmZP4YgtKdlkJMrFECx6CVZYf0kg1oSnnhtaOyZYaGWgGTHEfG89Qrc+p7ugqThDEIHF4aYb4vO2baYbG8YYv37W5Wbg96CXlE332iqv5JLS8O0qEaC6h3svh7/MHPgGwGldvCqB3aRWVumDz6y6xF8/yPUpBCDeXv0L4EXSry7HvteaSUfxIq95A4kk9fWfecH3sNksEYP932xWtJS3kfMPC0IX0YSwf+RL8YmCKa3PwmiJ80UII6WIREG8EkSPxCZ9kd15aDzea28aFB6xoxoWAYY9nZmjk5mKAA+DmxACFt8lrDaWTlyQs6MbPBOVMrTuo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6263.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(39860400002)(346002)(366004)(376002)(451199015)(86362001)(6666004)(31696002)(66946007)(66476007)(8676002)(186003)(44832011)(7416002)(66556008)(5660300002)(4326008)(6512007)(2906002)(41300700001)(8936002)(2616005)(31686004)(83380400001)(316002)(53546011)(110136005)(54906003)(36756003)(6506007)(38100700002)(478600001)(6486002)(36916002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ajc3ZENqYmlFb0l6UXpaWjlrTGZNbFp6N25RRWs4N1FwcjQrMm9Sd3ZvYVcv?=
 =?utf-8?B?U3F0NUVjZ0RNTzBOR1pMekFZenE1MkdwSUx6aE1YRDY1NUtOemloazlQVFNq?=
 =?utf-8?B?cGlNcHdLYjhyS0I4UjFqcFhrQzFlTUR0VWtXTHVpRDA3eE94K0xxcDBuMFdz?=
 =?utf-8?B?RlBjZjRzZnB2UTNObDRSeUNpZDMvalM3eW9rVHhOditRQ1ZWU3FOd2Y0Tmdm?=
 =?utf-8?B?V1IvZ0hraVJzTGpBaEZIQ0lUOXcrZ3dwVHpqUXg1alhGdVQ2Y1A1V29TRUZR?=
 =?utf-8?B?MWJpY2J4a2JyVnczYVVDRUt4Yno5bklNTnl1ZWhLVU5UQ3VhN1d5V24xME5j?=
 =?utf-8?B?MFFONHFidVBOdlFLR0VlTC9XN1o5TDFxdCszT0tHLzVNTGlSN2svaWFUS1Rq?=
 =?utf-8?B?VFZEdGxUN3lXTE1MSktwSWZhV0ZXOHppOVd5em9CL2UwM3N2OGwvY0taODEv?=
 =?utf-8?B?bjdTL1kvY1ZxTHNRbDNReFBHSEJ3L1g0SEtTc2dWVXJVMFhOK3hrSEpBc2di?=
 =?utf-8?B?SzZQM0NDc05VVVkwQWR5ZFJDN3NVOThsaHZrWEJiMHZVS3UzL2hHNjJaTG5E?=
 =?utf-8?B?bTlUWjlXY2xFYXRwcWN0dTVzTm1QR2tRTzV5eHFJVXFWQkNtWHVpTnZrZXlx?=
 =?utf-8?B?UXcwaytwUkhJa1hwM3I1Vjl4ZTM3SEw1eDdoMzkybkE4N3ViWFZpN2hBQy9F?=
 =?utf-8?B?aVpuS1FwajRDdjNudjVzS0ZLREM1REE5dW1XU21qMUZKVjlEbGNCOU9xSEdL?=
 =?utf-8?B?ZWpjWE5aS1NGWEJ1cHNjaGtGTFk1SEc1T2xWK09uN0N2K05jR2g4eGtQaFBm?=
 =?utf-8?B?MGhxcVlzNVRMZ1VkS3l0bFl6cG1LM3c3MUExYlFYWWM1enY1ZUJQOU5OVXR4?=
 =?utf-8?B?azViTnlNSE9FMmwrQ2RQSmhxVFJCVmI3QmczTTVxZVFRRS9QR21EdkdFVkJ5?=
 =?utf-8?B?azNwZ2xaaGlHK1kzbVQ1KytzZUlNdHBGZ28xdVpEK1oyc1BhNzcrTzhJM3J6?=
 =?utf-8?B?eDdROExrSFFZRTFzQ0JSQmZSRmhDWk0wc1FvOFJzbmhtV1l4NExDbERqd1dQ?=
 =?utf-8?B?MHZyc2NnNHhTQko3M3RQRVRuVkF4V0RKWFAxbTlSaGxOT05odXNWcG43VTJs?=
 =?utf-8?B?YU1WS0FUeWhZTGcwN3Z6RXE0eE01L2FEa0IyVTArL29BRlBVdHUzSmlpUWZx?=
 =?utf-8?B?T0N4MDVRUndWMkJtNHFXdUxUUCtlNWY5TGVRTFRaOE5rRk9tcW84eUxYVUZw?=
 =?utf-8?B?UFgrR0h5ZldzRFlZSTRHdXN4bFc5aFRLcTE0enVrUDQxOU82NVhPdzZmQS9J?=
 =?utf-8?B?djVTZGw3NnhrV3Z6ZVVKS1VjZ3VzWkhDcUhpVE0rQ1E5Z0EzNzY0Q1F3bTRO?=
 =?utf-8?B?TjRNZ3ZJQmF4OEpjUk1XMkF3OWpBZzVDLzNiaEhOaDRvQ1hNSGtNa0Q1dWNo?=
 =?utf-8?B?Y3RvdlptNStqdXUyU0hkR1QxL0NGb2ZDcVFQTXNpWlVEamphT1lKdDkrQ3ZD?=
 =?utf-8?B?REZ3YkFibjZCcnVwdktrbVN4ZHJyRFR0Q0YxOVN6eDl5ZU5vYkk5OFNIOHlC?=
 =?utf-8?B?YWloOW5KbXBHajBNTFVUY1RNQlAzbWNXNEVxbmVDRWY3V2tZeVZMbVcvVWdM?=
 =?utf-8?B?OFJubEdia0xqM0MveHp1d0Fpd3Uwc1B5MENnbmx2dDNVYW1ocllzNlJ6eXIx?=
 =?utf-8?B?d0FCOUZGV053VHRHOUxYR3crdHVFdmlaeUJUdWJ1VHZOYW1abTZXL0J2aXZI?=
 =?utf-8?B?d2hINU9XTWxpQUVkaXI3cCs0NElFanhqdVJvSWlNU0RGNlQ2VW5uSndqVnhY?=
 =?utf-8?B?MUdnbFdnMjI5RmMydU56bXpYSURiK3c3UWlCMXRabE5ITDhSOFpIVFpOaDJM?=
 =?utf-8?B?U2xsZHVFQ0hFUGl6cElBbEhnWEYvR3FzUzQyVHJKUmlVaXNrZUFBMjR1V2R0?=
 =?utf-8?B?NFp6VWxtWWxIL0U0Mkl4UE5lN21tK2FVWlRSbEpiMExpZXIvM29XK1ZpTlk3?=
 =?utf-8?B?ZVlJaHNVOGxNMDl6OGhQWnozd1QxdmRIQzhreFhVbm53dGVTNmg4WW1DcXpa?=
 =?utf-8?B?c0hleCtkcFBsRmxpZ0E0bXUzOTBMWjRxTVVaRjQ4R3BlN3RwSXozQmVtTkx0?=
 =?utf-8?B?OHE0dDVZcVJlMTBYN1lxNG9USVpDZzgrTXpWeDlEUjhkVXlIU1FjcVRCOVYv?=
 =?utf-8?Q?Ju8MKtFLuK3tYFCOWDouMi4XFbsRQHdNTUfFj1jO+rUQ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c10bfa88-8a68-48fa-8cbb-08dac447602f
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6263.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2022 00:46:46.4921
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XYF8DO1m6qN4ZmVt09mH+/0aYr1jILL5flLDYFIuF9I427N3VaEYmp8iYZvxjUIsYwGGTJBFJIqdtwTRaolAMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5673
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/11/22 6:40 AM, Thadeu Lima de Souza Cascardo wrote:
> On Fri, Nov 11, 2022 at 01:09:37PM +0100, Borislav Petkov wrote:
>> On Mon, Nov 07, 2022 at 04:39:02PM -0600, Kim Phillips wrote:
>>> I've started a version that has AUTOIBRS reuse SPECTRE_V2_EIBRS
>>> spectre_v2_mitigation enum, but, so far, it's change to bugs.c
>>> looks bigger: 58 lines changed vs. 34 (see below).
>>
>> It can be smaller. You simply do:
>>
>> 	if (cpu_has(c, X86_FEATURE_AUTOIBRS))
>> 		setup_force_cpu_cap(X86_FEATURE_IBRS_ENHANCED);
>>
>> and the rest should just work - see below.
>>
>> And yes, as Peter says, when the user requests something, the user
>> should get it. No matter whether it makes sense or not.

OK & thanks.

>> @@ -1474,11 +1477,19 @@ static void __init spectre_v2_select_mitigation(void)
>>   		break;
>>   
>>   	case SPECTRE_V2_CMD_EIBRS_LFENCE:
>> -		mode = SPECTRE_V2_EIBRS_LFENCE;
>> +		if (boot_cpu_has(X86_FEATURE_AUTOIBRS)) {
>> +			pr_err(SPECTRE_V2_EIBRS_AMD_MSG);
>> +			mode = SPECTRE_V2_EIBRS;
>> +		} else
>> +			mode = SPECTRE_V2_EIBRS_LFENCE;
>>   		break;
>>   
>>   	case SPECTRE_V2_CMD_EIBRS_RETPOLINE:
>> -		mode = SPECTRE_V2_EIBRS_RETPOLINE;
>> +		if (boot_cpu_has(X86_FEATURE_AUTOIBRS)) {
>> +			pr_err(SPECTRE_V2_EIBRS_AMD_MSG);
>> +			mode = SPECTRE_V2_EIBRS;
>> +		} else
>> +			mode = SPECTRE_V2_EIBRS_RETPOLINE;
>>   		break;
>>   	}
>>   
> 
> I am confused here. Isn't the agreement that the user should get what they
> asked for? That is, instead of warning and changing the mode to
> SPECTRE_V2_EIBRS, the kernel should still use lfence or retpoline as requested?
> 
> The point of those options was to protect against Branch History Injection
> attacks and Intra-Mode Branch Target Injection attacks. The first one might not
> affect the CPUs that support AUTOIBRS, though we haven't heard that.
> 
> The second one (IMBTI) is very likely still possible with AUTOIBRS and
> retpolines should still protect against those attacks. So users who want to be
> paranoid should still be able to opt for "eibrs,retpoline" and have retpolines
> enabled.

I've removed the above and have the complete diff below.  It includes patch 1/3 and
drops 3/3 for now due to Jim Mattson's comments.  After some more testing, I'll
resubmit.

Thanks,

Kim


diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index a465d5242774..b260a36dc3ef 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -5698,9 +5698,10 @@
  			retpoline,generic - Retpolines
  			retpoline,lfence  - LFENCE; indirect branch
  			retpoline,amd     - alias for retpoline,lfence
-			eibrs		  - enhanced IBRS
-			eibrs,retpoline   - enhanced IBRS + Retpolines
-			eibrs,lfence      - enhanced IBRS + LFENCE
+			eibrs		  - Enhanced/Auto IBRS
+			autoibrs	  - Enhanced/Auto IBRS
+			eibrs,retpoline   - Enhanced/Auto IBRS + Retpolines
+			eibrs,lfence      - Enhanced/Auto IBRS + LFENCE
  			ibrs		  - use IBRS to protect kernel
  
  			Not specifying this option is equivalent to
diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 97669aaf1202..ec9a4eb8e7b9 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -84,7 +84,7 @@
  
  /* CPU types for specific tunings: */
  #define X86_FEATURE_K8			( 3*32+ 4) /* "" Opteron, Athlon64 */
-/* FREE, was #define X86_FEATURE_K7			( 3*32+ 5) "" Athlon */
+#define X86_FEATURE_AUTOIBRS		( 3*32+ 5) /* AMD Automatic IBRS */
  #define X86_FEATURE_P3			( 3*32+ 6) /* "" P3 */
  #define X86_FEATURE_P4			( 3*32+ 7) /* "" P4 */
  #define X86_FEATURE_CONSTANT_TSC	( 3*32+ 8) /* TSC ticks at a constant rate */
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index a3eb4d3e70b8..56e4f3aab31c 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -30,6 +30,7 @@
  #define _EFER_SVME		12 /* Enable virtualization */
  #define _EFER_LMSLE		13 /* Long Mode Segment Limit Enable */
  #define _EFER_FFXSR		14 /* Enable Fast FXSAVE/FXRSTOR */
+#define _EFER_AUTOIBRS		21 /* Enable Automatic IBRS */
  
  #define EFER_SCE		(1<<_EFER_SCE)
  #define EFER_LME		(1<<_EFER_LME)
@@ -38,6 +39,7 @@
  #define EFER_SVME		(1<<_EFER_SVME)
  #define EFER_LMSLE		(1<<_EFER_LMSLE)
  #define EFER_FFXSR		(1<<_EFER_FFXSR)
+#define EFER_AUTOIBRS		(1<<_EFER_AUTOIBRS)
  
  /* Intel MSRs. Some also available on other CPUs */
  
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 66d7addf1784..4060ca8c2c60 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1229,7 +1229,7 @@ static const char * const spectre_v2_strings[] = {
  	[SPECTRE_V2_NONE]			= "Vulnerable",
  	[SPECTRE_V2_RETPOLINE]			= "Mitigation: Retpolines",
  	[SPECTRE_V2_LFENCE]			= "Mitigation: LFENCE",
-	[SPECTRE_V2_EIBRS]			= "Mitigation: Enhanced IBRS",
+	[SPECTRE_V2_EIBRS]			= "Mitigation: Enhanced / Automatic IBRS",
  	[SPECTRE_V2_EIBRS_LFENCE]		= "Mitigation: Enhanced IBRS + LFENCE",
  	[SPECTRE_V2_EIBRS_RETPOLINE]		= "Mitigation: Enhanced IBRS + Retpolines",
  	[SPECTRE_V2_IBRS]			= "Mitigation: IBRS",
@@ -1247,6 +1247,7 @@ static const struct {
  	{ "retpoline,lfence",	SPECTRE_V2_CMD_RETPOLINE_LFENCE,  false },
  	{ "retpoline,generic",	SPECTRE_V2_CMD_RETPOLINE_GENERIC, false },
  	{ "eibrs",		SPECTRE_V2_CMD_EIBRS,		  false },
+	{ "autoibrs",		SPECTRE_V2_CMD_EIBRS,		  false },
  	{ "eibrs,lfence",	SPECTRE_V2_CMD_EIBRS_LFENCE,	  false },
  	{ "eibrs,retpoline",	SPECTRE_V2_CMD_EIBRS_RETPOLINE,	  false },
  	{ "auto",		SPECTRE_V2_CMD_AUTO,		  false },
@@ -1300,7 +1301,7 @@ static enum spectre_v2_mitigation_cmd __init spectre_v2_parse_cmdline(void)
  	     cmd == SPECTRE_V2_CMD_EIBRS_LFENCE ||
  	     cmd == SPECTRE_V2_CMD_EIBRS_RETPOLINE) &&
  	    !boot_cpu_has(X86_FEATURE_IBRS_ENHANCED)) {
-		pr_err("%s selected but CPU doesn't have eIBRS. Switching to AUTO select\n",
+		pr_err("%s selected but CPU doesn't have Enhanced or Automatic IBRS. Switching to AUTO select\n",
  		       mitigation_options[i].option);
  		return SPECTRE_V2_CMD_AUTO;
  	}
@@ -1486,8 +1487,12 @@ static void __init spectre_v2_select_mitigation(void)
  		pr_err(SPECTRE_V2_EIBRS_EBPF_MSG);
  
  	if (spectre_v2_in_ibrs_mode(mode)) {
-		x86_spec_ctrl_base |= SPEC_CTRL_IBRS;
-		write_spec_ctrl_current(x86_spec_ctrl_base, true);
+		if (boot_cpu_has(X86_FEATURE_AUTOIBRS)) {
+			msr_set_bit(MSR_EFER, _EFER_AUTOIBRS);
+		} else {
+			x86_spec_ctrl_base |= SPEC_CTRL_IBRS;
+			write_spec_ctrl_current(x86_spec_ctrl_base, true);
+		}
  	}
  
  	switch (mode) {
@@ -1571,8 +1576,8 @@ static void __init spectre_v2_select_mitigation(void)
  	/*
  	 * Retpoline protects the kernel, but doesn't protect firmware.  IBRS
  	 * and Enhanced IBRS protect firmware too, so enable IBRS around
-	 * firmware calls only when IBRS / Enhanced IBRS aren't otherwise
-	 * enabled.
+	 * firmware calls only when IBRS / Enhanced / Automatic IBRS aren't
+	 * otherwise enabled.
  	 *
  	 * Use "mode" to check Enhanced IBRS instead of boot_cpu_has(), because
  	 * the user might select retpoline on the kernel command line and if
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 423a760fa9de..287b356ccf92 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1340,6 +1340,10 @@ static void __init cpu_set_bug_bits(struct cpuinfo_x86 *c)
  	if (ia32_cap & ARCH_CAP_IBRS_ALL)
  		setup_force_cpu_cap(X86_FEATURE_IBRS_ENHANCED);
  
+	/* AMD's AutoIBRS is equivalent to Intel's eIBRS - use the Intel flag. */
+	if (cpu_has(c, X86_FEATURE_AUTOIBRS))
+		setup_force_cpu_cap(X86_FEATURE_IBRS_ENHANCED);
+
  	if (!cpu_matches(cpu_vuln_whitelist, NO_MDS) &&
  	    !(ia32_cap & ARCH_CAP_MDS_NO)) {
  		setup_force_cpu_bug(X86_BUG_MDS);
diff --git a/arch/x86/kernel/cpu/scattered.c b/arch/x86/kernel/cpu/scattered.c
index f53944fb8f7f..cef8c3e688b4 100644
--- a/arch/x86/kernel/cpu/scattered.c
+++ b/arch/x86/kernel/cpu/scattered.c
@@ -45,8 +45,10 @@ static const struct cpuid_bit cpuid_bits[] = {
  	{ X86_FEATURE_CPB,		CPUID_EDX,  9, 0x80000007, 0 },
  	{ X86_FEATURE_PROC_FEEDBACK,    CPUID_EDX, 11, 0x80000007, 0 },
  	{ X86_FEATURE_MBA,		CPUID_EBX,  6, 0x80000008, 0 },
+	{ X86_FEATURE_AUTOIBRS,		CPUID_EAX, 20, 0x80000021, 0 },
  	{ X86_FEATURE_PERFMON_V2,	CPUID_EAX,  0, 0x80000022, 0 },
  	{ X86_FEATURE_AMD_LBR_V2,	CPUID_EAX,  1, 0x80000022, 0 },
+
  	{ 0, 0, 0, 0, 0 }
  };
  
