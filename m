Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18ACB26510D
	for <lists+kvm@lfdr.de>; Thu, 10 Sep 2020 22:40:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727109AbgIJUkv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Sep 2020 16:40:51 -0400
Received: from mail-dm6nam11on2069.outbound.protection.outlook.com ([40.107.223.69]:31040
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727071AbgIJUke (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Sep 2020 16:40:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VoIKahxbtFgp1oL5n/JmyImHG/Y1xFaXXGg94oN9WTy59y3REAzkDkEnk4EGdXuIypLU3TbjhZpBy03o2qjCUWwte6oR8AfgfMxld5S63oqjTsZeRgjsveaQKaRS673GAKR6Cxj6Ol+6yH3CwlZbf02rhD3RK+9bo4nF1ukkdKI6x8NVAvyFPcsujds+WA4Yi0pgRxpdJo8hmVEah9YGqbqfRmlpSguIXpepUwUzOHM1XfBEL0CRvQRqSEcpMk15LZiV8Ceh9gQ4NoU/8YVAPhMXMPPB2kjuQq5nfABBVR03u2wEHLKr6KKVeS0l+HsztKaVVwgWkOnfJnog25OsdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Vni94a03+ZziY77TUzAnA6MToDWVHtvyH8fHQXKkSw=;
 b=SxOujho6D8WI4YYPP/U4RlDpKF8sbIUD6bhODeYBcW8uJ+iGXdVuXa4L5nDhTg+KgMcgGvAZ3cgBf3p8Vl8RGw6Np9+o84zSwMPYiT1p/Wha3Dz5lRrAjyZ8rYMMFONrlk5eVj1Rk3Oboj1dDo+MwwhWQ/+H5PSdGIc9pi9i3Oeuu9Z4yyTenxiQSoxjif6MRwDSWK27WeS/SjRSelF0ckKFgbNmU/t/zYmGJfJABWS+zlAxY0IYe/l0Kf6sAp212jcy8xUL28D73w+5aqrMCthApmHrFWJAw9ry4XXa/DW3D1mvCQYPYtD4RvxI1eqxHFFc84sIzB5lLbrW/RqZJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Vni94a03+ZziY77TUzAnA6MToDWVHtvyH8fHQXKkSw=;
 b=LoiRauduqpJU1BGg5hPN2V3op0R9EcYAxOAyB7roGmyP8tlzw3yXednbMtdlC5eAOv+QJ0Lt5Yxv/tcSV8Td1cpryl8zDc3H/P8ZQmWr19M636JcC+gGJ3oRcpZxoxntAkDKLfCrYOHsGKbcO00N6Fu3W2Cjs8KyO5PQYbXST54=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4124.namprd12.prod.outlook.com (2603:10b6:5:221::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3370.16; Thu, 10 Sep 2020 20:40:22 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346%3]) with mapi id 15.20.3370.016; Thu, 10 Sep 2020
 20:40:22 +0000
Subject: Re: [PATCH 2/3 v2] KVM: SVM: Add hardware-enforced cache coherency as
 a CPUID feature
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com
References: <20200910022211.5417-1-krish.sadhukhan@oracle.com>
 <20200910022211.5417-3-krish.sadhukhan@oracle.com>
 <fdf8b289-1e6d-9f3e-3d76-f48fcee2b236@amd.com>
 <88c2c23d-c2d9-66e2-1778-6f81d1eef04a@oracle.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <1476b0e8-824f-1061-1372-6b2fbbced015@amd.com>
Date:   Thu, 10 Sep 2020 15:40:20 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <88c2c23d-c2d9-66e2-1778-6f81d1eef04a@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0501CA0067.namprd05.prod.outlook.com
 (2603:10b6:803:41::44) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SN4PR0501CA0067.namprd05.prod.outlook.com (2603:10b6:803:41::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.5 via Frontend Transport; Thu, 10 Sep 2020 20:40:21 +0000
X-Originating-IP: [67.79.209.213]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5529e893-a962-40da-9b67-08d855c9bcec
X-MS-TrafficTypeDiagnostic: DM6PR12MB4124:
X-Microsoft-Antispam-PRVS: <DM6PR12MB412484C864275B151E5109BAEC270@DM6PR12MB4124.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yNsqrPuoYlxjb5IotUzoCFarBXj2Lkd6nMpKQpyKThdr6N/79U7/6y+Mdwfjny0hQaKBL/uYZMXEpqddZjOhHkrvk8KpuZKclrVVSFM2BjwezyiFZNSKZH6iCtse0HRogbOVVcIfEEE0eT7797U6veU9TwvaJGXUIp2qPRjjfss1XAN83XFUDM0NBW27/isjT0JsviMnt/haTpiwrpO4wtAW5Ve403eH36qN28vUwJBLYdMRm48lqojNvY3cgxvpz4ElK67/e6PODXmwRSKKflBAD4hB9aji25EG66LmJ1QLc3iDZsHsEQkTXtY0I4tQHHXen6EC0HeyKHW/dKwQU/j4g/ijgo0Mh7kx54+IHBEKHO4drz2SB9APVB6J2ihw
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(376002)(346002)(136003)(396003)(83380400001)(6512007)(2616005)(2906002)(5660300002)(6506007)(8936002)(8676002)(956004)(53546011)(52116002)(478600001)(31696002)(66946007)(31686004)(36756003)(16526019)(66556008)(186003)(66476007)(86362001)(26005)(6486002)(4326008)(316002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: gmwCAAdlxUQXyhisAS+fZj2bdhdbIz77zmiSW7DVHG5bV/v+brCmMeo3NKVJqDUJJeDnH3hne8WuXLMnRtRU5f1af02gJuadWGjCBYdu7zdwJOX66Y4by8jYAlPXxGMNWvyL0UczZkL1Ez8zNSXawKqCu52jJeUnCYG/fAj6Ijn6KF0NuhPOoZuMOas0ko0xXxVbMrnvQa3uPCLX/hxg+ZO+AL2/YLKMwA22GaasIpfQ14pphHAnu5LS39cB/e0A6sOl+vCggo6DCvfPK+PxP5FAHxkwb+VmfaN/Ht8LwhoJuFDIMCUXi96eC/TQjL8ALTRx1hawvwdlHcE7j1sO6mZJfXHH3sPGmMMbCmd5Y87uH2LFcXZWQSueXst1dh21pTmX+/BqD+izt0wOV7WxxewhJPLKqHXNY00uPqbFCBHDmEcMFPRft1rp5lJkeraPiqZg+TcBAtNLkRhsO0+q4h6fTfteRURr9O8rfKjKXzry1TGdIK2Elty07MFD/MVanhVOFdN0Uzj2G8XNtfnOF0QyE0/HWNA3MzMs0Hve2Sbf4c4Wa+ri2HPAji96Llox6N9Tbkw8AAtbeH4qtnUTlmxRXw6VRngIJjX2qu16JEX6ZYgIVOzDZxRO8+7a+ytlfMz5fMJMBEV8CTPt+jScGQ==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5529e893-a962-40da-9b67-08d855c9bcec
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2020 20:40:22.0944
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EQmtZsXz4LyvQxAprEnKwmzL3Qz3u0eizzhETWiMH0lvVZAjSSSBkoqInoyb2e9T/7t/jWRcxsADRrKmerlF5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4124
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/10/20 2:27 PM, Krish Sadhukhan wrote:
> 
> On 9/10/20 7:45 AM, Tom Lendacky wrote:
>> On 9/9/20 9:22 PM, Krish Sadhukhan wrote:
>>> Some AMD hardware platforms enforce cache coherency across encryption 
>>> domains.
>>> Add this hardware feature as a CPUID feature to the kernel.
>>>
>>> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
>>> ---
>>>   arch/x86/include/asm/cpufeatures.h | 1 +
>>>   arch/x86/kernel/cpu/amd.c          | 3 +++
>>>   2 files changed, 4 insertions(+)
>>>
>>> diff --git a/arch/x86/include/asm/cpufeatures.h 
>>> b/arch/x86/include/asm/cpufeatures.h
>>> index 81335e6fe47d..0e5b27ee5931 100644
>>> --- a/arch/x86/include/asm/cpufeatures.h
>>> +++ b/arch/x86/include/asm/cpufeatures.h
>>> @@ -293,6 +293,7 @@
>>>   #define X86_FEATURE_FENCE_SWAPGS_USER    (11*32+ 4) /* "" LFENCE in 
>>> user entry SWAPGS path */
>>>   #define X86_FEATURE_FENCE_SWAPGS_KERNEL    (11*32+ 5) /* "" LFENCE in 
>>> kernel entry SWAPGS path */
>>>   #define X86_FEATURE_SPLIT_LOCK_DETECT    (11*32+ 6) /* #AC for split 
>>> lock */
>>> +#define X86_FEATURE_HW_CACHE_COHERENCY (11*32+ 7) /* AMD 
>>> hardware-enforced cache coherency */
>>>     /* Intel-defined CPU features, CPUID level 0x00000007:1 (EAX), word 
>>> 12 */
>>>   #define X86_FEATURE_AVX512_BF16        (12*32+ 5) /* AVX512 BFLOAT16 
>>> instructions */
>>> diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
>>> index 4507ededb978..698884812989 100644
>>> --- a/arch/x86/kernel/cpu/amd.c
>>> +++ b/arch/x86/kernel/cpu/amd.c
>>> @@ -632,6 +632,9 @@ static void early_detect_mem_encrypt(struct 
>>> cpuinfo_x86 *c)
>>>            */
>>>           c->x86_phys_bits -= (cpuid_ebx(CPUID_AMD_SME) >> 6) & 0x3f;
>>>   +        if (cpuid_eax(CPUID_AMD_SME) & 0x400)
>>> +            set_cpu_cap(c, X86_FEATURE_HW_CACHE_COHERENCY);
>>
>> Why not add this to arch/x86/kernel/cpu/scattered.c?
> 
> 
> The reason why I put it in amd.c is because it's AMD-specific, though I 
> know we have SME and SEV in scattered.c. Shouldn't SME and SEV features be 
> ideally placed in AMD-specific files and scattered.c be used for common 
> CPUID features ?

No, it is perfectly fine to put them in scattered.c.

Thanks,
Tom

> 
> 
>>
>> Thanks,
>> Tom
>>
>>> +
>>>           if (IS_ENABLED(CONFIG_X86_32))
>>>               goto clear_all;
>>>
