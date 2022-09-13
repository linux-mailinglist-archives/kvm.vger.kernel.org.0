Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DAE25B676D
	for <lists+kvm@lfdr.de>; Tue, 13 Sep 2022 07:39:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230070AbiIMFj4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Sep 2022 01:39:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230036AbiIMFjy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Sep 2022 01:39:54 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 907AC13F09
        for <kvm@vger.kernel.org>; Mon, 12 Sep 2022 22:39:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fop5Uu4PwXMUuNAz47cnhqVdj3l9w8uaE0tU+bhm6KcPkPZyY+9PDxtzrWplXB7mqY/fLlH/FRFwTZthgvhwfWPYb8EC2tPG9XlwGb2M2FF/dRgaZg6XncJPZcxY0LnrDs/pPpNz3iQATw8gM7dxGXNGmZ1CNKgZ92SpdEXutXVxs7QtgRAJzW9lMkakTljWXIMVxQ16Hb4HQtNuL+M3PCk96V40xd+UIHJKxmncvyaTSv35LODtLP57RQfeUJLOMZurJiwLDGE74+rRxBcmT0hlNbA6cjB/LgLBUyWHUICsslK8aog6MLO4QYqW7p/t3vCQRNI8gysvIGTihs/6nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xXCYdVNWIVExOi3O9RjIIMjqCx9BBWDQEOwBjwfbQeE=;
 b=Cek9hPZBkn353Ce/I0VUxS2f1D/aRKa8PUAru3iTWn0anosdVvuRr0ffUd0hUb9+aHylXm4uwJT3U+8Zp2FCawOLDMLWtwGas5j1VH4RfCMS8DmmeV3c0T8HyFFO3AdFY3LjF2pv8pA4tbg/bmRYIud0rpfk15iKnHbe6HQeACX9RjSGkDoYoLeZaERedIySwtIVmj2wlRkuoNJc7woBBn9reA1y5YBRJCvy4VzY5lMkDU8RfcoxWIhgDCviZotsfy/GRPn4GLHIMR4TUWD+4/0m7O4j4yeCjwM63n8ZtYPs93sUibdXcJ1/DJ7Qalf4Yr5cRenxn/kfr+Wjo5BfAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xXCYdVNWIVExOi3O9RjIIMjqCx9BBWDQEOwBjwfbQeE=;
 b=dIdkZLshoGNfpygFr9rjV61+XZ3lx6H0sNZ1qvLUgOoHI+g5WGRxj3zxWjV8sdDKQzSWmvBw936/N+vCqoQSIZmXeiekreo1MolEY0dzFfi0K3PLPtKD9hcFKKWngd1i5QkViTz/az/RPZmRFSSnYF1ZZp02i39x3s/D+57Ojeg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM6PR12MB2843.namprd12.prod.outlook.com (2603:10b6:5:48::24) by
 CY8PR12MB7635.namprd12.prod.outlook.com (2603:10b6:930:9e::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5612.22; Tue, 13 Sep 2022 05:39:49 +0000
Received: from DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::3406:3c9:8fac:5cfa]) by DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::3406:3c9:8fac:5cfa%6]) with mapi id 15.20.5612.022; Tue, 13 Sep 2022
 05:39:49 +0000
Message-ID: <699404b6-dfa7-f286-8e66-6d9cadd10250@amd.com>
Date:   Tue, 13 Sep 2022 15:39:40 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH kernel] KVM: SVM: Fix function name in comment
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        kvm@vger.kernel.org
References: <20220912075219.70379-1-aik@amd.com> <Yx79ugW49M3FT/Zp@google.com>
From:   Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <Yx79ugW49M3FT/Zp@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SYAPR01CA0028.ausprd01.prod.outlook.com (2603:10c6:1:1::16)
 To DM6PR12MB2843.namprd12.prod.outlook.com (2603:10b6:5:48::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB2843:EE_|CY8PR12MB7635:EE_
X-MS-Office365-Filtering-Correlation-Id: 8977c2da-5204-4004-fea1-08da954a5fa3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SBP6x9NbBFlqPfOvwudKnY2yoJY5WFYctz9fY2Hs5jyL3orBnQwvIjoupufR7iOk5KbLE76BKWSoKaQM+FI4tZOMljzYhvY0HxPZSJveB1x1o5mwCr4CWC5235/rqCvJ2kQE1bgQoF2xEkmAsmd7TWCWGs/8m2piTwSdpTTMVjzTHYk2cS0IYkActixDA0RkxDoEZzZEGwwLKhKuxKhMVh6wD5cg+Gwein8koZFHFZ/d/ClTSAWfpvLYCR8qaeVDftMGbDeqxWR7e2LD53x9EcmxRUuYjrDRI13A3xqEBv3lXFJ96L/f2KDXH2v/liUKmVetoAbTKdCUGOUCTZ2CJdqJkLwrxOU3a0oBN5ewEEyA078GTpDDtriNK+aBwh1fBADnU+ahx9sOA5SyAZcZhEvtbuuQGetLgRJMer9fEniKieDE8pqWehenzjsIyzYp/koVZ9indu7Rlz4uZDRsPiXKbxSxd4XaEUx8iQUqowD7dWeJQ3bTmUxr1GNdrAHSDnRbj7BCcOGCqSV4GaUwgEytXWfi+0fCuLhIC7ly4zwQFKHC7kR2bzOG0dKGSqvZTJAqE2gj+tZcFe9oWWs1192r3rp8mONj5okuRrPEOO4BDTkQUO2aLRv4J+2pnl0MCdQffgYK9IkZ4s9k02RNrlDvORIturoWE2auhT3wgOt+Eoi2/rcnJwC3sMyOIH+H7qJNXNHqLICCxysEdIDdzB7PbDFwNVGYomZya6XcQOQWN5qiwOL4AJiSPDkUakD8P2nbaHxPMeNVQd+PEpFD8upHUhrseiozXLTREwW9Ttg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB2843.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(39860400002)(346002)(376002)(136003)(396003)(451199015)(6506007)(8676002)(4326008)(66556008)(66476007)(66946007)(186003)(6916009)(26005)(31686004)(2906002)(316002)(36756003)(31696002)(41300700001)(478600001)(5660300002)(6486002)(53546011)(2616005)(6666004)(38100700002)(8936002)(6512007)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TXd3RzU2MmVJREVwMDRZOFA0ZU96ZHBrZnBXVnljQ3RMbWRnWG1XRHBWUkow?=
 =?utf-8?B?VituTFVJUUc5Sk9jWms3YVVGQUVPbEFnNlNrU2czbWtuczVlSDJvNVEzUXA2?=
 =?utf-8?B?MTRjbE81M0h6Y3NXOGJEM3BEaXVsVFVqTlVaMnVrVDhWZTNTQmVyTUdkOXBk?=
 =?utf-8?B?UWU0bFBVRWpxNW1nTUpWeVp4NW5YVTVPZ21BQ3BNOWdMNnJPVzZjNkNveVlj?=
 =?utf-8?B?K1lmbTg2OWhYdVY4QWtVY1dSN1FHRmNqTEZtNU9kNTNOVk9TTUptK1VZTFhF?=
 =?utf-8?B?cTZUM1F5eFJ0N0c0WUFiUWVnUXAxeHBBOVRMTmFqNllreWc4aFI1d2FFVExP?=
 =?utf-8?B?NG1meERlVmRqWGRpbnZ0SlZ1dkZmamVKeCtvTEkxWUhRYzRYa1VkSUloMHY3?=
 =?utf-8?B?MTRCM3Rza2Y0Sjdsb25WWTQ0WHIwVUdVK3VPM0tNQ1YxT3BNM2dRQ1Z0Y3Ex?=
 =?utf-8?B?TGZJVjljaFVkdXhGM09ucUEwNWh1ejlNV25Kd0x3VkNsTmZlZXllV2x2NGI4?=
 =?utf-8?B?SHNmbFk4SEtiMnR3U2h0U05TSXhiS0lrazZTZVdOWjhhNEtWeXpROUU4enJU?=
 =?utf-8?B?US8wMS9nMGZaZzNBMmRRc2w1MFhMUnZLZTZKQ2wxQk8rQlJrV1hDR2xRU2FE?=
 =?utf-8?B?Y3REbWN4NlhEZWo4L1ZDNlNpOGJqTGM5ZHluYnZKZjRLNUQ4SG1NWFAvSWNJ?=
 =?utf-8?B?dDlIKy9IRnViV25OYWI1djBUdC9ma010M09OWUYzWlNQQ3hUQVVENDI2bHR2?=
 =?utf-8?B?ODQxZGRRazMvSFhPa3ZFMkFLS0dJUFZYbnFDeXNibVpyYXRSUjBFQkJSTGg0?=
 =?utf-8?B?SjlVSVFFdEZSaFdSVGR2TmhjbjZYaG9Ic2crenN1blI1NFJib29LVlowWE5H?=
 =?utf-8?B?eWtjSk5jd2M3MmY2U2tqSm1oNGJZaVl6OERlQmx4VWRqdnd4VkxRTktBTVNq?=
 =?utf-8?B?cG1rck53YUtKOURVbG9vR2FVNFovcGMramk5ckU3eUg2U3ZhZ1pHa3JNLy9z?=
 =?utf-8?B?b3BxWUlUeW9UbVJjRFBNYStCWVIrVWJMWUUyR2lLdzJRbUNEZktVam9sOC8y?=
 =?utf-8?B?Qy84S1NTbEFYUzVud2IvS1ozUENYY0VuQVJCRStWMkN3Qk5RN0hBZGRpb1FK?=
 =?utf-8?B?MTJnRDk5aFBkbWg5VmpKNlZacnpiNVdoVW10WUlWWXh5azU3QnJvSk5PQlZT?=
 =?utf-8?B?eEdPS0hrRzRMZlpibEZkV2tuWWFGZldvVnkxeXRPWmRiekVkL2hjYTQ0TnBp?=
 =?utf-8?B?d25leEJFY0laQ2J3ZmcycDNVeVByVW1GMXJERXJsMnQyYm1XNWRxYVhlL3Yr?=
 =?utf-8?B?a1JqV0ppWlF0eGUzditkdzlVb3NjSWtqMk1ZMmFaZ2hLa2J5ZGVlK1FrTEZ0?=
 =?utf-8?B?a1VaYkZzZ2tZMWk1TENrdFBZc2pFcGllTTJrWFFpaVJaUVNUUndRRFZiN1dJ?=
 =?utf-8?B?RXNhMWhxSE83T0gxK21oQ0ZBVkZzQXd2dHNxaGQzM3VZN2NnMG1uR3p6eHRt?=
 =?utf-8?B?aFZsbUsxc3k5NVI4cFNSNE9MSmhKZklmcktURkZaL2wrWUJLdzMwZjZsNlJn?=
 =?utf-8?B?S2I3L3AzUXcxeG4weUtyN2pvZlMzTldxSEZiYTBPcENkWG5DYU1mM3NmL29D?=
 =?utf-8?B?UlRSQUp2em5qUldKR2l2SEVhaTNqWGYrb3FCVStuQ2kwSUJ3eFRrVTZzdVoy?=
 =?utf-8?B?dndCWjVPdmpQMFRiMHFDSk5Sa05aMFhIQng1ais2UXZoZzdOTlU0V1pqTld2?=
 =?utf-8?B?RHZyTkE1SEIrTlU3VTkrbUlRc2dRZlJhMHc2OEdFeGFNakM2ajNxODA1eDBL?=
 =?utf-8?B?VkEyc1hxVjVtdVE0cEFFU1d5NWNUeEpWUUVqR25VUWNUVzJjNGY2SDlLUHkr?=
 =?utf-8?B?SnhZVHFnV0lrQ0JpNnp3WE9JZHBNbGRrVnBMaDFHVERzRWszeHVCSDN2aDBD?=
 =?utf-8?B?RFEwK1ZWQUx3cFdqRkVDZCtRRmYwODBsTzc1MWxsZ29ScWt2eElMSUcwaDhE?=
 =?utf-8?B?T3l5NzhFbTJvQ2tSSXlWOUJwU1pyQjV4MEZRS0Qxa0gwSmpYQ0lTOG1kMi84?=
 =?utf-8?B?QXZJNGU3RjBDVy9obXNZY3N3WUFHVXFsdGIxbDRkZUNIK0hPYTdmczIySUYy?=
 =?utf-8?Q?cNDb1Wc/OAg2GECxvIXPKEvkV?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8977c2da-5204-4004-fea1-08da954a5fa3
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB2843.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2022 05:39:49.4329
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Lm6j5vhXgv7fILh9VM0I7IW4kSu/FfXOnvwvfGR9/vKrwiwC3pJB17RZAns7/5X8gJUEzpAk2BlUhzrhXKcM6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7635
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/9/22 19:36, Sean Christopherson wrote:
> On Mon, Sep 12, 2022, Alexey Kardashevskiy wrote:
>> A recent renaming patch missed 1 spot, fix it.
>>
>> This should cause no behavioural change.
>>
>> Fixes: 23e5092b6e2a ("KVM: SVM: Rename hook implementations to conform to kvm_x86_ops' names")
>> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
>> ---
>>   arch/x86/kvm/svm/sev.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>> index 28064060413a..3b99a690b60d 100644
>> --- a/arch/x86/kvm/svm/sev.c
>> +++ b/arch/x86/kvm/svm/sev.c
>> @@ -3015,7 +3015,7 @@ void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa)
>>   	/*
>>   	 * As an SEV-ES guest, hardware will restore the host state on VMEXIT,
>>   	 * of which one step is to perform a VMLOAD.  KVM performs the
>> -	 * corresponding VMSAVE in svm_prepare_guest_switch for both
>> +	 * corresponding VMSAVE in svm_prepare_switch_to_guest for both
>>   	 * traditional and SEV-ES guests.
>>   	 */
> 
> Rather than match the rename, what about tweaking the wording to not tie the comment
> to the function name, e.g. "VMSAVE in common SVM code".

Although I kinda like the pointer to the caller, it is not that useful 
with a single caller and working cscope :)

> Even better, This would be a good opportunity to reword this comment to make it more
> clear why SEV-ES needs a hook, and to absorb the somewhat useless comments below.
> 
> Would something like this be accurate?  Please modify and/or add details as necessary.
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 3b99a690b60d..c50c6851aedb 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -3013,19 +3013,14 @@ void sev_es_vcpu_reset(struct vcpu_svm *svm)
>   void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa)
>   {
>          /*
> -        * As an SEV-ES guest, hardware will restore the host state on VMEXIT,
> -        * of which one step is to perform a VMLOAD.  KVM performs the
> -        * corresponding VMSAVE in svm_prepare_switch_to_guest for both
> -        * traditional and SEV-ES guests.
> +        * Manually save host state that is automatically loaded by hardware on
> +        * VM-Exit from SEV-ES guests, but that is not saved by VMSAVE (which is
> +        * performed by common SVM code).  Hardware unconditionally restores
> +        * host state, and so KVM skips manually restoring this state in common
> +        * code.

I am new to this arch so not sure :) The AMD spec calls these three 
"Type B swaps" from the VMSA's "Table B-3. Swap Types" so may be just say:

===
These are Type B swaps which are not saved by VMSAVE (performed by 
common SVM code) but restored by VMEXIT unconditionally.
===

Thanks,

>           */
> -
> -       /* XCR0 is restored on VMEXIT, save the current host value */
>          hostsa->xcr0 = xgetbv(XCR_XFEATURE_ENABLED_MASK);
> -
> -       /* PKRU is restored on VMEXIT, save the current host value */
>          hostsa->pkru = read_pkru();
> -
> -       /* MSR_IA32_XSS is restored on VMEXIT, save the currnet host value */
>          hostsa->xss = host_xss;
>   }
>   
> 


-- 
Alexey
