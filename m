Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66B8E73E407
	for <lists+kvm@lfdr.de>; Mon, 26 Jun 2023 17:57:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231575AbjFZP5U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jun 2023 11:57:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229569AbjFZP5S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jun 2023 11:57:18 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A08AF9;
        Mon, 26 Jun 2023 08:57:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JAfxQ0raglTsw066JRcDOt1M8kuwzgVfYzuasMGDXlyyFGYrIMdR1eLN7OGlMh5EQFuhXOEKq5VtUBjESpsWtBMXSIiopVcXC73Oxd2Mzn877YMAf19lt6nkAmy94Td2gNLJvi/09hA4pOXTPyUQZuvKo/nZHPFmp8iTwo3AJsD0STPsWLRa25qiOVuV9UPVXwqiR0V734pr59ckenSbLgjiPpdRizd537ryJu42wyGFHUPqtBFI4onIZiDi0Wv1M6PyHTuQIiaI+zj5TPxh2b1yrewyXNnQ8IsC5p30fMyLCakji32dQ5vqkc8Ej8xuQB/o5r70y64jgb1zHkO7aQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xz8BRsDQ5lUaVGTuL1qMG+2EGIeb8Z5HZ+GF+HSiydo=;
 b=amm7npArrJH2vVgezj34tBV41RUeOLI3xXnulzsKDJAHfG8AYqLrb17vfnq7l564Y0PPyXiMGw+Mc9D/UqEeuCKNmUxND3zjuywBFhEp6w1cYiuNkFRUXdFBrLNVojCf9xwaHNP6L4ml397dPd6WJ17BbRVMFi2VxAnVVYns0B79AMDrTKb5I89g5w20nLt9gXl7wCz5V5NDKIWyQLeM03Nplz9XpJc/ym+Mm7rR8WnZoms7pF2moM3P7O6xhCqe9K+d4ELiEx4HSTdnkV9wdbPFEhVDTg017IZOURouYe2haoo5QQ7GO3Mono0bmyGc4JuAsFc4B8aeObPlV8Dwfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xz8BRsDQ5lUaVGTuL1qMG+2EGIeb8Z5HZ+GF+HSiydo=;
 b=JIDAeOvPiiwxcQEUxhEIojO+RuoNQtQS4UO4P4HM0FjTmXoMRUjebFqiY5UQAXh5IRdXAxWUZ/ggJdioliHodkfzwiE6hvdCUW0XNI8xfSeYdAnqy7/8QsMW+I5enKo1cShlA6eoLIUuv1vpQYqYRlNN+IKZ9TurMpz0kZkKDhU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by PH7PR12MB7938.namprd12.prod.outlook.com (2603:10b6:510:276::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.24; Mon, 26 Jun
 2023 15:57:14 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::1629:622f:93d0:f72f]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::1629:622f:93d0:f72f%7]) with mapi id 15.20.6521.023; Mon, 26 Jun 2023
 15:57:14 +0000
Message-ID: <52ea8386-8652-dd91-23de-9d35781cb131@amd.com>
Date:   Mon, 26 Jun 2023 10:57:12 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [RFC PATCH v2 6/6] KVM: SVM: Add CET features to supported_xss
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc:     "john.allen@amd.com" <john.allen@amd.com>,
        Weijiang Yang <weijiang.yang@intel.com>,
        "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>
References: <20230524155339.415820-1-john.allen@amd.com>
 <20230524155339.415820-7-john.allen@amd.com>
 <161174d013dff42ddfd2950fe33a8054f45c223e.camel@intel.com>
 <ZINGaJnNJ54+klsD@johallen-workstation.lan>
 <9ef2faeaa38e667bd4daa8ee338d4cade452c76c.camel@intel.com>
 <ZJYaNSzup+yuYxNy@google.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <ZJYaNSzup+yuYxNy@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR03CA0067.namprd03.prod.outlook.com
 (2603:10b6:5:3bb::12) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|PH7PR12MB7938:EE_
X-MS-Office365-Filtering-Correlation-Id: c89fa4bb-9d86-41ed-b3a4-08db765e0257
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LM9smBjHqwDSMYHfUoSEtnzMT+xafBdWwUvMon+AeePngw7kpTxm/hik7H+BaBnU0OwN8ZQzMzaVfSd3eomx9Pt7vBDDdms550vDrsOLes9CdLBrzdbYIPP1fSwCX89+RPK5o4B7QgLzNXX9Y+pPHB5XNtqxJ35M+a2yvLntixoRqFBzYkUktW0d3F2wa6G7oWW2X+kfLYEownZvSZjAESyO4wUm5NKe2H1dX3nHcS7zKDXl+pikj2Y953yPer2Vfim4182HsH2LBI3j5LlpPhTVaCctOOWeJPveMolFNgKrUvhFYGyvEX4VUR7YAdnuIzllBfZzivhdGcRGJDiX3r5VkyDex/c7zLA6viC1S9X6IiuT5kf31lXL76n2424003XVK1+pRlptmhnT2ppg+2RYOoGxnMi0kmIWGXDMLMsq7hXoVa7s9A1sG6jkIUSyP4JN4mlHcHb3nh3kMr8twNPCd8bldUYjA2LdmiE43zcoQFR/QY9PgpwYKOgE3J8dwJ7SSdJKAhSav/vUZAI1dzhX9DsVun28qUFg9BaaQaHJ5Yr/O5ZCGFK2nY0N3lmsKRn3qRoooTr6vDxXjBPGtTlOC2wlJ0TjRAobelNbE6OPsZNd0CREqjshj6kIIfLeq0RWLvQwgzXD1zsQnliD2g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(366004)(376002)(396003)(136003)(346002)(451199021)(31686004)(36756003)(5660300002)(41300700001)(316002)(86362001)(66476007)(8936002)(8676002)(66556008)(38100700002)(4326008)(31696002)(66946007)(6486002)(478600001)(26005)(6506007)(2906002)(53546011)(6512007)(186003)(110136005)(83380400001)(2616005)(54906003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a2FCMHp6UjBQc2xKaUlBVDVjK3U4NjBYbFRaY0xRRVRKZWlrMGU1cDNTOGlS?=
 =?utf-8?B?aDRQdmVVQnVKNVB0cFVwZWRldEVhZ1VZeU52TmJ1MVo5ZmdOQ05CQzI0YlAw?=
 =?utf-8?B?S2pXMTZXRlhxckFPMnFxUzFmRFNuRkk5VzhHWmJlQllFalMzOWRhVFdHQnhC?=
 =?utf-8?B?Y0hEOS95SmsxTHJUWEEyVWpsWjJXc2czZmEvUFdqM0xRWHZHSXhuUDJlQjZG?=
 =?utf-8?B?aHBKT3lCWjJPTmJtMnVYM0RkMnRnL1c3dzBYRnQzaHhuME94eEFtc2R5cGJm?=
 =?utf-8?B?bm9XZmI2N2k5a2hGSyt4NXVMcmJDQWVVRElucUtVSUgycUFWN3pQRE5FQzVQ?=
 =?utf-8?B?SDZ4T3ZWM2FuaVBNRzNrdkJkVjlZVmZnUGVhUHBwN0lTN2k0NVBMRlZYeEdT?=
 =?utf-8?B?RTVodi9yenp5bEpOaVFQUHoyZTVJT21neHdOZ1JLYzN1ekZaYWEwR0xqV2tn?=
 =?utf-8?B?SnJwUEFHZk5LM3lvSVprYU92cDJHNWVqbFdQVEN1cFFKRXB1SXpzeHBpUlhR?=
 =?utf-8?B?T3ZxTjBkaXpjUEMwcytCZm9Vb0lUQktQZkZqeWUzVDdDK3E0SFNnWjYxV1dP?=
 =?utf-8?B?KzRPUDNwVFI3bjlCYUpqODFxVVM2MWRXd3NqdU1EZWlTWmZRekY5RzNsY0Zo?=
 =?utf-8?B?VXUycFZnWnpKQzJKaFB4SDhRamRaZ2wyM3BqakludFd0UzgweDFCVGpkNDdt?=
 =?utf-8?B?NzhMRUF2UG11b0JKamNsbVZONXNmbXlGcVVVNTRTMHFqdWkwMmhVbFVkRmRj?=
 =?utf-8?B?TUVRaTRvWWc1SjFFRjcydWtVZVZHQkVjOFBKV0NSakcrbUFkMjkxWTFKNWlG?=
 =?utf-8?B?TFJKK3RlV0RKQkdyRC9Wd3l5T2lOQUZISlJUSXRPaSt6VGlLdzllMm1aRURW?=
 =?utf-8?B?bnB4V2pFNEhFbEFiMWZDaUpBRTUzN1V0Q0hzTVBiOHRuanJpek1rZ1p2RnVU?=
 =?utf-8?B?cldjenV2akEzSjY1OVM1akIxK2JVNmhpUGRzL2JNaTFWL01Ta0RML29Jc3V6?=
 =?utf-8?B?SUl5NnNsd0I1S0JVV2c1N3MzZ0lWQlZmT3hJdGxSN1NsdkNwN2hVWWtzUTBa?=
 =?utf-8?B?N0MvOWlGZHIzeEpKY2srRzU5c0dJN0RSellQcHVxTmh5QzNRd2gzUFpBWUZi?=
 =?utf-8?B?eG9rTUw1TmJjRFl4YWVmeG1jcGJOOHNPK2ZCK2pSa2luSEVnTDRMZFhjRWNK?=
 =?utf-8?B?UEJuWU5ERDZhTFpJRDBMdlJjQkVPNVVObkUrWlBXSFdUUkpuSFN6cGF5UGpB?=
 =?utf-8?B?TnQ3U1BQSmJCQlY5elIzZWhRN0xEazQxTUhWQXZXZ3QwUDRQYlNZVGJsUXc5?=
 =?utf-8?B?ZTBiV0tNdURFMWdWSzhTaE12YjRMYWwvTm5wTmpZcDhkbVZmL0pNT2Y2U0Jy?=
 =?utf-8?B?YWRaZXU5OVZTS0lSZnYzckVDWTJsWWFXWldwMGJxKzFoeGVtM25yWlZBdmRF?=
 =?utf-8?B?bVlmclM1UDlmVnZZRGhmTFhpZ3lEeU9wNlkvZERJRFdaVUFjWk9USzJhU0RX?=
 =?utf-8?B?blRCbmVrZ2pSU3JZMkcvWXJtZDNDTy9DenZNTDZMdkdHd1VMVFZTcVVNQjZM?=
 =?utf-8?B?SWVUdHBQUFFrd3JjeHd2MElJVk03b0d0Q2ttUllWUlJRLzhFbStva2Q5THJE?=
 =?utf-8?B?Ty9qL1FBZG4wa3JUbHNEQjkxSkoyWklNbTA2am9qaUVmZWZ2MzUvRWY0Mkto?=
 =?utf-8?B?dE9wR1BFQWQ2VjlBbDRmb1FsMHVOU1lycEVGM1dnU1dkcWw5bTVIaVRwWjFh?=
 =?utf-8?B?anN3b0NXWUFCS2VSQ0RBN0crTmRpTnpML0kzdDNHaEY4bGxYbjdMbklETlFu?=
 =?utf-8?B?dy9TK3hhWUdMR1dpSnJscG9yQ0FqSFhCYklmVm1lUDRZUXlCY2tVb2toOTJX?=
 =?utf-8?B?YkluSkY3VU90ZjliTUZscktiRjRKcWhzbzlmMXFUYUhldENVWWVTYUVHVjA0?=
 =?utf-8?B?YTZLY0VXNGJ0ODVmZ0VoNVJNdmU3WXIyWVVTYXZIVEFLK3RXY3Q0dHRObC9U?=
 =?utf-8?B?UDFYdXVGWi9xVStFbnhVNmh1aGNzTnZYOTA5SXFHQTVNQjlXdWR5WDZwcG82?=
 =?utf-8?B?YmxPeElIK1Q0K0lmSEhrV0k5TGFHU3l5eStKNm5nMDdvV3ZPOEpuY3Rtd2Fr?=
 =?utf-8?Q?x8GGJ0cSYemrV4XiwLQ8xQv07?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c89fa4bb-9d86-41ed-b3a4-08db765e0257
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2023 15:57:14.2703
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fhnmA4iuKNM02cZnGYrMfvskzdZxRRpeDAzkm6g2q7Rx6OAZutoUgpWijzopXlGp7FGwAGg6zaDHgx/Jm4V+QQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7938
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/23/23 17:18, Sean Christopherson wrote:
> On Fri, Jun 09, 2023, Rick P Edgecombe wrote:
>> On Fri, 2023-06-09 at 10:34 -0500, John Allen wrote:
>>>> Is setting XFEATURE_MASK_CET_KERNEL here ok? The host kernel will not
>>>> support XFEATURE_MASK_CET_KERNEL. I guess after this there is a small
>>>> window of time where host IA32_XSS could have non-host supported
>>>> supervisor state.
>>>>
>>>> Sort of separately, how does SVM work with respect to saving and
>>>> restoring guest supervisor CET state (I mean the CET_S stuff)?
>>>
>>> Apart from a minor exception involving SEV-ES, we are piggybacking on the
>>> state saving/restoring in Yang Weijiang's x86/VMX series. So by inspection,
>>> it looks like guest supervisor support is broken as the supervisor XSAVES
>>> state and MSRs are not included in that series. I currently don't have a
>>> way to test this case, but I think there are operating systems that support
>>> it. I'll work on getting a guest set up that can actually test this and
>>> hopefully have working guest supervisor support in the next version of the
>>> series.
>>
>> Hmm, interesting. VMX has some separate non-xsaves thing to save and
>> restore the guests supervisor CET state, so Weijiang's series doesn't
>> use the xsaves supervisor CET support.
> 
> Heh, that and Weijiang's series is a wee bit incomplete.
> 
>> Also, since the host might have CR4.CET set for its own reasons, if the host
>> handled an exit with the the guests MSR_IA32_S_CET set it could suddenly be
>> subjected to CET enforcement that it doesn't expect. Waiting to restore it
>> until returning to the guest is too late.
>>
>> At least that's the reasoning on the VMX side as I understand it
> 
> The APM doesn't come right out and say it, but I assume/hope that S_CET is saved
> on VMRUN and loaded on #VMEXIT, i.e. is the same as VMX for all intents and
> purposes.
> 
> The host save state definitely has a field for S_CET, and VMRUN documents that the
> guest values are loaded, I just can't find anything in the APM that explicitly states
> how host S_CET and friends are handled.  E.g. in theory, they could have been
> shoved into VMSAVE+VMLOAD, though I very much doubt that's the case.

Yes, the host value is saved/restored on VMRUN/#VMEXIT. Anything that is 
in the VMCB Save Area (the non-SEV-ES save area) is fully virtualized 
(unless noted otherwise) and doesn't require special processing to 
save/restore the host values.

S_CET is list in the SVM/SEV VMCB save area. Similarly, for 
SEV-ES/SEV-SNP, S_CET is swap type A and is saved/restored on VMRUN/#VMEXIT.

Thanks,
Tom

> 
> John?
