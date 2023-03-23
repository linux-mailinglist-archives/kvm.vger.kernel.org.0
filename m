Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2439D6C6956
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 14:17:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231495AbjCWNRD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 09:17:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231168AbjCWNQ7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 09:16:59 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2061.outbound.protection.outlook.com [40.107.212.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BA511BAF2;
        Thu, 23 Mar 2023 06:16:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jVrcz9A1rP4rZd90JltB78FzdoPAztjStlBqhUzhvUAZju99KdbA2gSdDyfobNw5FJP7LhauVWG+mxEcgG/ugMMelu8insom8y9qqmH5mdYL0TJ0Y+Jer7n25NnPuL9nMrVj2dCDACBuKCp6kwCsHZnQxn2uuez/qmBv9V74GPmOfsPX+iVzvqetGGHhpwYSgpgDoMDPb3X1aRvu1xEcWRFYS/lnV4dWR62e/uC5HrNslq6C7MxikbgfXxuc1orEBWaQ6y6Wry7x8xPrLZO614vJ4EoY7rLfxRgdzYDXrk2/EgjYMUiviteienzZSSpTGNO8gxIVoMKBdpAKedlh2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KdMf4bTQznYFP5PSVGBjGnAgN2tK2V3y9OngIljpNBI=;
 b=ChnNPDV5G8qrcb6aiBNqL3VxozesHLPX/yCOAoa2Ce14OtYEHoK9tj3SN8aofxsFRYo72mOGM3VIfapdlk4mhE+okjdKhoETJpAUZ6M0T/wAXHOakVAvaNidgJzpxT5nIPjqpVh7i/MxWNaOboyeiaNBa2cv3AtbntPhZPi+vV9ojIBCP8cBTKa1YRP3yJm6M7W4O38mCaG69+ML+5JYv5RJqEwihmP9w9LCWanssV/Q0XjVEoxqmw58qiMcjpLlgrBamM88llIc4KLTL5vNYGRI/dUYexg80wl5pQ4Ikpl3zHHc6lhHYq9FkQttcfBVJTqupPgt/mv2wWF3RoqoKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KdMf4bTQznYFP5PSVGBjGnAgN2tK2V3y9OngIljpNBI=;
 b=h3fvvzTfq4uSlz1DwnXpevcNAjbcySDnhszxJjayHCAdK3lsHFCOWlU6tG+/KzJyw5OH9NGBh2JChPf9rZ9gz8u8+qwOMJ/Gzl54K7wDGvphyRrFAHfEDec9D+2+IPD4qkyjcUsFFoR2cbtXP8BzkdOh5jcobnmqFNNLaWRkJHA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by CH2PR12MB4232.namprd12.prod.outlook.com (2603:10b6:610:a4::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38; Thu, 23 Mar
 2023 13:16:53 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::5b56:bf13:70be:ea60]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::5b56:bf13:70be:ea60%6]) with mapi id 15.20.6178.037; Thu, 23 Mar 2023
 13:16:52 +0000
Message-ID: <2c3dd773-31ca-d4b1-78a2-b39f3785c7c5@amd.com>
Date:   Thu, 23 Mar 2023 08:16:49 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v16 8/8] x86/smpboot: Allow parallel bringup for SEV-ES
Content-Language: en-US
To:     Borislav Petkov <bp@alien8.de>,
        Usama Arif <usama.arif@bytedance.com>
Cc:     dwmw2@infradead.org, tglx@linutronix.de, kim.phillips@amd.com,
        brgerst@gmail.com, piotrgorski@cachyos.org,
        oleksandr@natalenko.name, arjan@linux.intel.com, mingo@redhat.com,
        dave.hansen@linux.intel.com, hpa@zytor.com, x86@kernel.org,
        pbonzini@redhat.com, paulmck@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        seanjc@google.com, pmenzel@molgen.mpg.de, fam.zheng@bytedance.com,
        punit.agrawal@bytedance.com, simon.evans@bytedance.com,
        liangma@liangbit.com, gpiccoli@igalia.com,
        David Woodhouse <dwmw@amazon.co.uk>,
        Sabin Rapan <sabrapan@amazon.com>
References: <20230321194008.785922-1-usama.arif@bytedance.com>
 <20230321194008.785922-9-usama.arif@bytedance.com>
 <20230322224735.GAZBuFh9ld6FuYEyoH@fat_crate.local>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20230322224735.GAZBuFh9ld6FuYEyoH@fat_crate.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0323.namprd03.prod.outlook.com
 (2603:10b6:610:118::6) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|CH2PR12MB4232:EE_
X-MS-Office365-Filtering-Correlation-Id: fea24352-2b6f-42ce-92ac-08db2ba0dde8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4NLH85oDcpBGrBToqdmkGLroLdV8rrWo2c3QnRQex7Rkhnlg3ugJlvKTNOtin66cB7vT8Ch4QmVw1SorY+AHivUMl94H/MtiTf+RxAQLyaRnyMGywvJETCIHloRij4ReDNDV3j0CgWQi/Etlyn+w7yejWHuXvz35pWLtk7tZHou0WAcuxK4PV2YCcI6G8uvIjngGr/S7HTEQv9IRkGfj3tIMQp4Pn7VjH9OidkF4sdS0LEd5QMk8lZBkXJDcB9vLduPIRO0HGIt9/XIFskjfEru+UApTSF298ru1LhZG9H/ErvJ/RoxWtAZEf4lLichRc/2cryVlXpeyeavtP3M2YLD2esa+KPtz+JcA0hsgRZmqDdwcMwd59sa+qlKhqSNiJ5QhTxiXhUbCSpmaLErAUeZz9lzbYFEJRjc3TuqkMnPQBASt/vRpC4Np9Zl/KfBd4q3iv+usP6kU8l356PrBBkSqkxv+doCXbWqocXh8+tSAMPzcZB7WX4rShR3tMYMzSJq9q4B252Db247TdvxMMMxWxwGWZMCmhu3Yq49nxox38mJqdwO1PmbI7q46Y8vpG+zE65Cvk69T9BzcPQRBFMRuyrDOwO15RZhjO5Tf0+OhdNz+OUIUjAjVcT5fZtth0N5h7VfDPhpxuiviWroXDX7iAXsdgDxkQ1IzdXxp6bUr7gkovLLLcLhC0ycLbpmPs2tv1SVieN0lIgDBekPHWNO7eeENlIuSyfdj4z2NBS4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(366004)(376002)(396003)(39860400002)(136003)(451199018)(66476007)(4326008)(8676002)(66946007)(66556008)(110136005)(316002)(54906003)(7416002)(5660300002)(41300700001)(8936002)(53546011)(6512007)(6506007)(26005)(6666004)(2616005)(186003)(83380400001)(478600001)(966005)(6486002)(31696002)(86362001)(36756003)(38100700002)(2906002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RzM2K0lUWUswZjRVY2wyS3N2amNtTkQ5UkY3cW1pSmhQYytXTG9JQmZwanFC?=
 =?utf-8?B?QVRzVkNpaDBTZ2RCaW9mQnlyV0FtUm5rSUIvUnVVZGE2YkJaMGpibFZaeUdx?=
 =?utf-8?B?N0hxKzdlclVqT1FaeTBRbXRpcWJlenhYaTNsU0VhY2ErOVpNMk0ySFhicGpF?=
 =?utf-8?B?ZlgxRW8vNlQxakVpdnZFakswejgwRHByZTdLTVhlVTNEZ2FRRzBYbEZ2M1Zr?=
 =?utf-8?B?N2tzQjVSblhyWWh3akFrZ0U4dlB2YkF0eWlvSVdmUVdRVjVUb1N5dXlUVEhr?=
 =?utf-8?B?WmxJMVNJUldMd3ZCZWRmUHFKQnpWMnQ3MHhsQmtLOFVVUDFzWkh6NjZWVkU4?=
 =?utf-8?B?ZEF4dmRRYWxQY0JzNFBEWXZoSzdjQ1hkMWVlZHBpalMxbmZZNXZtWlRKd1Fx?=
 =?utf-8?B?QytqU0FnTXQyUW5IbTR3YWl2L1JzOTNyVXU0ektNTWZVNDNsbWZqNkJWNStl?=
 =?utf-8?B?TzlrdGNFTHk1c1RaQ3BJaXpMWU1YOHFlSzY1NDBZazBsNkFCV1R5MS9MSnVo?=
 =?utf-8?B?N3dXUWc4WTY2Yzc5N0RQTHpJZTRPbm51Zk1qemRPL0RTZ05EYmJyVG9xUEo0?=
 =?utf-8?B?aE1ZSmpVRUV0a1o2SU9yZEtWZkh2bXk1T2ZOdkt2SXJxbm8xdURuZW1mOGlL?=
 =?utf-8?B?WWl2ay9Ld1F6b3VFK2MxaDY4ejc2Q0hUYisyMGFjWHlHZnFIL2V1MG8xVEhp?=
 =?utf-8?B?Q25pbHl1U0s1L0RRQVVDMU1HUmpTV0xSdlFLQzZvdkF2Z2M4UzhMbEFkeVY1?=
 =?utf-8?B?MXJZK0JmVzZvWDR0cUxuN3JXQUZGVnFXSEdTdHhZM0VEa3RxSVcxYnJhbDJi?=
 =?utf-8?B?TGorWk1qdVN0c1NoQU90NktzamRXeldyd0ZQT20reEpnTUoxRFdGWmhpOW9O?=
 =?utf-8?B?eUhTTnZtWlROQU5VOFAvcStkWkRTc1o5SXNGZ1BGWFcxMGRJL0hNNXVOb1hr?=
 =?utf-8?B?MkFwd2c3OStCb3pjNEFFQXBCQTl1bVBSTjZCZFVaQnZWdjJjQ2hnL1FreXpt?=
 =?utf-8?B?K244d09jRGZlR1RGRlVwaE5maUNGZXNDQ3g3dGJLZCtiQnBFYTVxbHNsYitL?=
 =?utf-8?B?WkdCOXpFSWNKNDJlN2QzQzJndUF5VTNOTE5mQytHbjVPQWpLUXoxa3ltemxE?=
 =?utf-8?B?aTlEZkNuTUJBTXRjMTdaQW92aUZ4Zks5eEcrZTJPejRxR3hSbEozVUt1NkhH?=
 =?utf-8?B?U2tMeDEwNWZlblhIb1EzaFo4d0pjVnUyT2x2Z0JUZzFTVHUvWURmSXdxT1lD?=
 =?utf-8?B?NVYwK1RZRW5HYVFDZWNadG43WVFYQ2EwMEFCYnk2WEtQb0oxYk1aVTJNcW5w?=
 =?utf-8?B?VzVDeU1kaWRzendiYjZZMHh4clJOZjhXdkMvRHl3Q085Nkd3Z0JRWmNGL2xD?=
 =?utf-8?B?WEIwRDc5L2t4dnJ2WFRFeVhnTXphNmg0NlB6TDRVeUswTXh6TkkxYWZ2WEFv?=
 =?utf-8?B?ZSt4VUVteldMa2hzVXlFejRBUFhCTjBDTis5WFRjN0ZyNm0wRklveWpQaE9X?=
 =?utf-8?B?bXRIcTErby80cXNMQlZjRm9PdmtIbDc4OGZPbGpoLy9CZEJpeHRyT2wwNVor?=
 =?utf-8?B?NG0wM1g0dTFZUmorZkxDTXQxYSt4OCtabnhTSEtYQmhnbnJzZVhSdU9KTzhN?=
 =?utf-8?B?REFVV1JJTlBKR1hiZ2tSc211ZnZwdGhzWVUybExaNnNmSFUvOU15L0tDbUJi?=
 =?utf-8?B?a1U4bWNwTDFKK0hkKzFJclBRTUZ4VmtraVpWVCtyVDd4NWtvVUdoSHJJc3NK?=
 =?utf-8?B?Z2NQV0U3RU1meXZWd2VWVU5OZm52UzFIQ0p4L1pkVGI1SUN0TmNoM0YvUlVE?=
 =?utf-8?B?NVB3QTNUWFpZQTdYZHJ4UHFMM3M0dWdrR292T0lIQWxDUUdHTTNQcGZ2NUs2?=
 =?utf-8?B?c25iZ3FIemZmUHVtdmpxaEh2YnRlM1dOVUd6WXYzOFFKM0paVTNkUmhBUzJz?=
 =?utf-8?B?TW5rcWRrZTJGcUlXWndQQlFzN3ZwaUFDNUxBcjRIZm1TNkZNQWY5M3BBWVpj?=
 =?utf-8?B?VTJUZzk3a1hIL0FZTDhLY3UwbThQWkhKczdoS2p1Vnh1ZWFRcXZsVXdZYWo4?=
 =?utf-8?B?cVFzckxWSVVwMWdVb090a3JHd3RXYU5zVG1VZmJlZkZqcWNSN1d1Rmo0YnhU?=
 =?utf-8?Q?B5oLP4yHz3RFOKig4fEglHDTR?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fea24352-2b6f-42ce-92ac-08db2ba0dde8
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2023 13:16:52.6761
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M2UDgv6leL8Q6F5BjAWXD7F9zrD8PMw31rvdOUjT03/Km054ml9PqtFeejAa5LymfYo47rQFDLsxnuwOhwWwtQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4232
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/22/23 17:47, Borislav Petkov wrote:
> On Tue, Mar 21, 2023 at 07:40:08PM +0000, Usama Arif wrote:
>> From: David Woodhouse <dwmw@amazon.co.uk>
>>
>> Enable parallel bringup for SEV-ES guests. The APs can't actually
>> execute the CPUID instruction directly during early startup, but they
>> can make the GHCB call directly instead, just as the VC trap handler
>> would do.
>>
>> Thanks to Sabin for talking me through the way this works.
>>
>> Suggested-by: Sabin Rapan <sabrapan@amazon.com>
>> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
>> Signed-off-by: Usama Arif <usama.arif@bytedance.com>
>> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
>> ---
>>   arch/x86/coco/core.c              |  5 ++++
>>   arch/x86/include/asm/coco.h       |  1 +
>>   arch/x86/include/asm/sev-common.h |  3 +++
>>   arch/x86/include/asm/smp.h        |  5 +++-
>>   arch/x86/kernel/head_64.S         | 30 ++++++++++++++++++++++++
>>   arch/x86/kernel/smpboot.c         | 39 ++++++++++++++++++++++++++-----
>>   6 files changed, 76 insertions(+), 7 deletions(-)
> 
> How's the below (totally untested yet but it builds) instead after
> applying those two prerequisites:
> 
> https://lore.kernel.org/r/20230318115634.9392-1-bp@alien8.de
> 
> ---

...

> diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
> index ce371f62167b..96ff63cb5622 100644
> --- a/arch/x86/kernel/sev.c
> +++ b/arch/x86/kernel/sev.c
> @@ -1142,6 +1142,24 @@ void snp_set_wakeup_secondary_cpu(void)
>   	apic->wakeup_secondary_cpu = wakeup_cpu_via_vmgexit;
>   }
>   
> +u32 sev_get_cpuid_0b(void)

Maybe call this sev_early_get_cpuid_0b() or such to imply that the MSR 
protocol is being used and only retrieving / returning edx.

Also, since it is a function now and can be used at any point, the current 
GHCB MSR should be saved on entry and restored on exit.

Thanks,
Tom

> +{
> +	u32 eax, edx;
> +
> +	/* Request CPUID 0xB_EDX through GHCB protocol */
> +	native_wrmsr(MSR_AMD64_SEV_ES_GHCB,
> +		     (GHCB_CPUID_REQ_EDX << 30) | GHCB_MSR_CPUID_REQ,
> +		     0xb);
> +	VMGEXIT();
> +
> +	native_rdmsr(MSR_AMD64_SEV_ES_GHCB, eax, edx);
> +
> +	if ((eax & GHCB_MSR_INFO_MASK) == GHCB_MSR_CPUID_RESP)
> +		return edx;
> +
> +	return 0;
> +}
> +
>   int __init sev_es_setup_ap_jump_table(struct real_mode_header *rmh)
>   {
>   	u16 startup_cs, startup_ip;
