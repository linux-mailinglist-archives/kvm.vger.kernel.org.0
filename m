Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24A6573AE5C
	for <lists+kvm@lfdr.de>; Fri, 23 Jun 2023 03:35:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230343AbjFWBft (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jun 2023 21:35:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbjFWBfs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Jun 2023 21:35:48 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on20616.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eaa::616])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46D7F1FE9;
        Thu, 22 Jun 2023 18:35:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eOw89lJj21+jo9fmc4YTHqFAjWIfUBG0QmQ0saxgB6KYcudPPq8Rkn0Qyt9KRUrrwJ/92fnOcO6/RV8FIKhdeQizszXsgxBJ4RGjHnnYMU5uc0Yn02J2o3UBo3wnj+RcitgEYbmHlDGGeQlJKpLX7IiTBxaH6nQCrh/wHcwgMEsh5x4sOuNdFu/0ne1JXaPY6Sko7PahinbShTocCpGfp+26KIpxi9nAZZhzA44DUhxkxv2utJ5vAwMjPQ/8xcJXBJmbQfGrPoStb+8gDSYqEe6Ur6Nd67NLEGRtlplvKhXGs2I5dSTOZakSpHfKieDM6q6QRL/LdeiPHr5jUTGZQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yz8iD0aQgIWSkXMgSfeB83x+jZ0U8dBozexCsUeMArc=;
 b=OZiE8+al7Qlscc2zybg4+muzfkQ1GejrxBkYyIAd/iHae2VXmtmfvCjd/gMvrq6mIjyL8lDQrHrlfGMHErjtmE4xdXEEg5r/ipxif2IOsi0XCXOc+O8vPgdnx4m3OyJn+YGebYjQgGRp5sBjcFe6GfLWhn8SZbAn4CgIsvQCn+q9lYYXzGvcN/NdLPYVSYlZ5tBYszaWR/EmK5RaU1AJJ9vhl5pagAaViC3LsLCiEIKKN5Q7iWfm4366tK8zay5FnPQ3DzDO4fp5vyrfWQbnhawMIOkiGVsqbkzEyTA2aeh/OgafGsNIPBDattIjpUjAAf/xJGOw4whj+4Mdc1ntxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yz8iD0aQgIWSkXMgSfeB83x+jZ0U8dBozexCsUeMArc=;
 b=I/O8aZYhoNKLXZMEwOOJNv+ucvW+4keaZeSDCSd7w4Dmf2YSstjSNJRY5CxqnyC0EUCV91jYKQNBVLf6qva6Oa8RcLc/MjgtkdiSr1Qi2VYj8tDSIsAHWwyjWqt0L9GGfcpRCJHgWJnNSqQTJblRv6Y/iV6g99dm+tzQP/vYro0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM6PR12MB2843.namprd12.prod.outlook.com (2603:10b6:5:48::24) by
 MN0PR12MB6198.namprd12.prod.outlook.com (2603:10b6:208:3c5::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.21; Fri, 23 Jun
 2023 01:35:43 +0000
Received: from DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::ff22:cffa:293:5cef]) by DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::ff22:cffa:293:5cef%3]) with mapi id 15.20.6521.024; Fri, 23 Jun 2023
 01:35:42 +0000
Message-ID: <6c5d1e74-0f6d-7c9d-c4e7-a42342ca60aa@amd.com>
Date:   Fri, 23 Jun 2023 11:35:31 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.5.1
Subject: Re: [PATCH kernel 0/9 v6] KVM: SEV: Enable AMD SEV-ES DebugSwap
Content-Language: en-US
From:   Alexey Kardashevskiy <aik@amd.com>
To:     kvm@vger.kernel.org
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Sean Christopherson <seanjc@google.com>
References: <20230615063757.3039121-1-aik@amd.com>
 <a209f165-b9ae-a0b3-743c-9711f5123855@amd.com>
In-Reply-To: <a209f165-b9ae-a0b3-743c-9711f5123855@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: OSTPR01CA0036.jpnprd01.prod.outlook.com
 (2603:1096:604:21b::9) To DM6PR12MB2843.namprd12.prod.outlook.com
 (2603:10b6:5:48::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB2843:EE_|MN0PR12MB6198:EE_
X-MS-Office365-Filtering-Correlation-Id: c476227e-67bf-4fb1-2aa2-08db738a2841
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7dNKK3tWo4ziKHflWgBK1bgKDNfV8ZrOiOPIeMKb3cWI+MhHRRhS+k0Y/y/fYDF5P3eWdY4bmuts9RBONmVMpwULfcSMJmW5U7TbFbT4u0kXtMRWY3Qgcd15ZK9KeVXYBRj0DTCicDqI2/P4IDRONwGJlpvT+uzg+Oms35JH39xJpI5cavKp2BoXEn6nDmFgs4owrlJukVaE9oqKYwoTc6RKumq6u1AIbs3XoQ/XnhrPekrsxEka+7yd2K22XKAs1m4dyoisIsxcuAl++bo0XGd+cDu0tqIYy9O3bL/CtLeuxOKK1Snt1/wYl7DDU9pyfACpnhD9BIN7uopkFPkpGphnWkSYWhg5JPe42+7mNNOSdIKYG/6qv8kE9YGBpyYSdd+vU661VjEV5g7uhm6f6rMGcQmavEOC7apbQdiGAEMzPWVgLVNnTSia+cgnqXMvxKPawKOyPkHEq+n4i5rlxlL+qEclaAXdMKNXtM+5OsXnIchgNV0+tlbbCXTu3ZzRDs90wGJYCpS0wRY5unnkLAP6CVJfdw/RS+065KGb2NZXERDLxaXf+F8nGMUDYR8ZA4wtC+WeUQfZilszdWG83slYk92oAyhTCDhlgtUSjGJBICv/MqS9j9UDZ7TDkwd05ezx33BA5ueD35irMe0Lgt+5dqmcyL6sBFCGjX+HlFaqnrgdOgHrvTuD1rG3uAJ4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB2843.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(376002)(396003)(346002)(39860400002)(136003)(451199021)(38100700002)(966005)(54906003)(478600001)(6666004)(2906002)(6486002)(5660300002)(6916009)(66556008)(316002)(66946007)(66476007)(41300700001)(4326008)(8936002)(8676002)(2616005)(83380400001)(6512007)(53546011)(186003)(6506007)(26005)(31686004)(36756003)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?clFZdFhiUDB4dElOKzNlYk5XUkgrMkJDNC9PTVNMTEZ0NG9TaDBHaEJZQ1hZ?=
 =?utf-8?B?L2V0VlB2Mm11NEUyNWh6VEw0RnozTllJYytyUElKUmN6N2owb3pCZG9wZito?=
 =?utf-8?B?MHdHVkZKdUxKVHZKL1JHU0syR2E4STg3b3BzeSsyck5CZlh2Ym8rbWNQWkNj?=
 =?utf-8?B?djFVbFI2WWRERmt6NnN1cWtnWnUrSzF2OFl1WGNXcmJpYTVGOFNjV0EzbkJj?=
 =?utf-8?B?aGJBNmE0TkRQTDVjdnl3UFBRelVLSnlzN0xVcDYwSmdMbTdKQy9VV0lVZUll?=
 =?utf-8?B?cExQb2JZVFhmeEtQS3V6cFNKZ2ZneitVU090UWZWRUh1d2FJclNUWDl0L3Fl?=
 =?utf-8?B?V29pMGptd0F3Z0NXNlRwVmNLSFZFa2xIb3B6NU1yY2htcTZYVTZ2NkxwazZo?=
 =?utf-8?B?RmZVQzNzZ25HU3QwdmR3Mng1Y1hsMlQxMTZtVmNNUUpENDI2S2ZmdHhzdUQ5?=
 =?utf-8?B?NHRyVzl4bEs1R0JCNzY1ZW15QzlLc1dybnU0QXVHcytnRU9BYzRKdDFyVUVK?=
 =?utf-8?B?SnFLclRhTFdwMTY4ZXRtdUtPRmdLWjF4SXBZVzM0TFF0VHVwZzQ1RlZiM0tY?=
 =?utf-8?B?SWsxNVUyaGJnbzNJMlUxSk5VOVpiZWVidTdXTjQ0NnE2MHZtdmdRUE8zNm9O?=
 =?utf-8?B?aWNWK3lLeTRhWk1XQ1RTdmJRdk4wTDVFYTNQZ1N4bnF5SDFnWlBaSUk0VEk2?=
 =?utf-8?B?SjdQdTZQN1pVWDBhWEFJL3lOdENvM09aYksxZHA2VmlMVGRCSzV5TEZYSEhz?=
 =?utf-8?B?WmY5OUxBUVluRlpmSFlrbnI1QnJXZFFPV0xXM2xEZUd6ZDFYUlVUTVB3eWlW?=
 =?utf-8?B?clRhQmJPOHBKQzFXdG94ejh3NjVoVDVBcmR1MENzeDFVbmJFRmFrODZ1ak1y?=
 =?utf-8?B?eGNzTXBTZGRMUllEeXNmdGwrZDlpYUpYSjFzUXQxMkFqbldySVhBQnc0aEJ0?=
 =?utf-8?B?em1GRmNsU0ttdmVleXVncFVGYUNQb3AyeG53dzZNWVA4Z2FlVThpS21McU50?=
 =?utf-8?B?Q2F5cWxRUS9SVWsxbExKYUs5cmpsdUpOVFpINDJGYjJuODdOTXI3RmhjbzFR?=
 =?utf-8?B?MEtqLzBscXRkVCtKS0htSXlxQkhSVFE3anUydHBZK092dzBoUHIvRmErWW4x?=
 =?utf-8?B?RDZXZWNCR3dJRTJqaUhzMEJ2RlJWSnhlblVwc2lHV3JwSkl3T3huNDhwMkVK?=
 =?utf-8?B?dnVwbUdPSERMNElhWlVtd25ZN2dLUFFHdUpKUzdtUmZ5ak1FcmdxNnpCaWht?=
 =?utf-8?B?ZmRTL0NmVGxtK2lmWXAzTHBvSFhkWml6V05WNEFrV214NGgzZDQybzRRWjNC?=
 =?utf-8?B?SjIrdThQZDFWSUtudjFFei9BK3JmSGZDTjR3SU1KcVk3cnpGMFZsdWlra2pn?=
 =?utf-8?B?OTFHQXM5Y0JYWVQ0czBCTTh6VGNZeTVsZnZlOHZuamU1cGNDQk9hQTFlU3E0?=
 =?utf-8?B?ZGRJVSt1enpGeFUybGdqMmZYQW12eHo3UUhEb2VBeDl4NWZvNVF0amF6bmNB?=
 =?utf-8?B?MFAxaDNqWWFJazNteUl4QzUrSWhodGJpK21GTlE0M1NibVY3MTJUZzMrMkVt?=
 =?utf-8?B?VFhRaVQzMG5hczVwc1k2dWplYmkvRlF5QXk4b1RORWpEbnZRbnV3cGRzdWJv?=
 =?utf-8?B?VU1oaFhDdEFJOE1nak5qaW5QU3BYSjhuZHlxV2k2cFBGZHJxa0hrZ0xmSnpT?=
 =?utf-8?B?VSthRnhxY0EvaFVpYUErdno3Vjk1bWtSTVp4dE5NVW5xaEl5RHFsZlowcE1n?=
 =?utf-8?B?UGRrTERyM2NRWWlyejlZK0lTYWVYaDhNRUJyUm5nRlJzVGc5MmlRMTBXUUlR?=
 =?utf-8?B?b0c3R2FBTUErMHNXczI3Y2lvYTZoRjJvbjZwaVAyMUtsd1BTV0JNb0YwRmNw?=
 =?utf-8?B?M1Ftc1NNZjRlK25ZNkFYOXIvUlp6TmVoQUpHWWp4VFFTb05ITXV5TTdQRWNu?=
 =?utf-8?B?ak1kSFE5SnVHSExlRzNuRi9tRHZWSW5PbmFGRU1CbGdDQ3BrL21ENEZhclBD?=
 =?utf-8?B?SlRWUXB0Q0VzZjZaZnpvdm85VXFMVTR3TXY4R0xVakFYbDlVdFBEKzFuUVZO?=
 =?utf-8?B?a1g0Z1ZuVzUyZkxIRXZ6VWt2RkdZNGp6RS9MS3NKMzZ5dVFuck1ucm9TQitX?=
 =?utf-8?Q?1QueCD2+UXGZnOU1T0F4rczBk?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c476227e-67bf-4fb1-2aa2-08db738a2841
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB2843.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2023 01:35:42.5872
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6XfGIWH4TpQD2f3S6uLVVbaV8LFTwlMu42ZzwksydENKVV5y6/H7pjNcho7ELWdLEYMsDGctl2i5o6MsVYdkZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6198
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean, do you want me to repost with "v6" in all patches or this will do? 
Thanks,


On 15/6/23 17:13, Alexey Kardashevskiy wrote:
> Ouch, forgot to mark this as "v6". Sorry...
> 
> 
> 
> On 15/6/23 16:37, Alexey Kardashevskiy wrote:
>> This is to use another AMD SEV-ES hardware assisted register swap,
>> more detail in 6/9. In the process it's been suggested to fix other
>> things, here is the attempt, with the great help of amders.
>>
>> The previous conversation is here:
>> https://lore.kernel.org/r/20230411125718.2297768-1-aik@amd.com
>>
>> This is based on sha1
>> 6e2e1e779912 Ingo Molnar "Merge branch into tip/master: 'x86/sgx'".
>>
>> The tree is here: https://github.com/aik/linux/tree/debugswap
>>
>> Please comment. Thanks.
>>
>>
>> Alexey Kardashevskiy (6):
>>    KVM: SEV: move set_dr_intercepts/clr_dr_intercepts from the header
>>    KVM: SEV: Move SEV's GP_VECTOR intercept setup to SEV
>>    KVM: SEV-ES: explicitly disable debug
>>    KVM: SVM/SEV/SEV-ES: Rework intercepts
>>    KVM: SEV: Enable data breakpoints in SEV-ES
>>    KVM: SEV-ES: Eliminate #DB intercept when DebugSwap enabled
>>
>> Sean Christopherson (3):
>>    KVM: SVM: Rewrite sev_es_prepare_switch_to_guest()'s comment about
>>      swap types
>>    KVM: SVM: Don't defer NMI unblocking until next exit for SEV-ES guests
>>    KVM: SVM: Don't try to pointlessly single-step SEV-ES guests for NMI
>>      window
>>
>>   arch/x86/include/asm/cpufeatures.h       |  1 +
>>   arch/x86/include/asm/svm.h               |  1 +
>>   arch/x86/kvm/svm/svm.h                   | 42 ----------
>>   tools/arch/x86/include/asm/cpufeatures.h |  1 +
>>   arch/x86/kvm/svm/sev.c                   | 86 +++++++++++++++++---
>>   arch/x86/kvm/svm/svm.c                   | 70 ++++++++++++++--
>>   6 files changed, 137 insertions(+), 64 deletions(-)
>>
> 

-- 
Alexey
