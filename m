Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8B014A5ACE
	for <lists+kvm@lfdr.de>; Tue,  1 Feb 2022 12:02:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237069AbiBALC6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Feb 2022 06:02:58 -0500
Received: from mail-dm6nam12on2061.outbound.protection.outlook.com ([40.107.243.61]:51238
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237053AbiBALC4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Feb 2022 06:02:56 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j5Sg3m8EGfK8NyuqKc5lbWiKr8wrIzSOmiXRt3WvVYUgGED4tnCmyoTyUe7kPe68oR2aohB/CHCdjd7JoKZz9TD1S9gnz3el1L8iaCO3fyzE1Y97usv49l/rbSWoYVHOMIZ0go0kNkeMHKp2wOMEwH43DzPXf39fHC5kaG3+LbCO34W/bW0mRhd5v0gWngrMOtyqqzJmS2HCAsKBOF22bw568gRJMrkV9UNeWs5Ys3e0/FgDki/GILxxRuNdj/f+NQnTVwK799o2ll+bSbljDcxWgQu4w5zfHn48QQaP3N+EgQDVvmlXlTikMrGCaVH+HgcRYFpyDEqaC0bcCWobew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yi/uKTI7qLEgRJe+q8J7TT/zNZSBc3IPysaSIh1qwCk=;
 b=T/jEOwyA8uwNAy9pyNlVeFxWEYqFnrbatDXFWntDDnwhKnu3dNVKIihhkV27Vk6VwaFBc6nhX3edZ4GRbjR6e4iaUL6GvxsDzs2A2akQrE2KCYwRF9DPQP9sOTbuVohDZuGD8ubJuzt1axO2w5ReXVVwnbrOeUUhqdH+8NXZ7+Vv5e6qcHpPyh0QvYcIv9dTs+TpMW4BS0yLrsJSnrEwvx/jToZR6GK4oJN9IvmLenQ8/Rz5L8BxZLo4TIpjK3sTiDcM8WogEUee6pQOUdn5j/VIwv8wc7oLPEYx1R/lBA0Ps82ezB8kz1o60CadwvRikKwXIsAumQ1y2OiKl41BCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yi/uKTI7qLEgRJe+q8J7TT/zNZSBc3IPysaSIh1qwCk=;
 b=oc02fW9losCSeTbzdSLyIfVDSg6mm5Mh8xuEHulk1WE6xifYS/YX0zr92RGUJSHIZVifHUdB68URU2sgjEQRDdIlN2k1r6vVxLdKY0nMgvNkNai/UpFtOuI6P5pT4V0iOEp1grePhwhnCNgQyfv09QcFB3KBpp/fRigt18ZMKmo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7) by
 DM5PR12MB1449.namprd12.prod.outlook.com (2603:10b6:4:10::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4930.20; Tue, 1 Feb 2022 11:02:54 +0000
Received: from DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::389b:4009:8efc:8643]) by DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::389b:4009:8efc:8643%5]) with mapi id 15.20.4930.022; Tue, 1 Feb 2022
 11:02:54 +0000
Message-ID: <7ccec879-ae8d-a0c9-708e-c72abc82b7b1@amd.com>
Date:   Tue, 1 Feb 2022 18:02:42 +0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v3 1/3] KVM: SVM: Refactor AVIC hardware setup logic into
 helper function
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        pbonzini@redhat.com, joro@8bytes.org, mlevitsk@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        peterz@infradead.org, hpa@zytor.com, thomas.lendacky@amd.com,
        jon.grimm@amd.com
References: <20211213113110.12143-1-suravee.suthikulpanit@amd.com>
 <20211213113110.12143-2-suravee.suthikulpanit@amd.com>
 <Yc3r1U6WFVDtJCZn@google.com>
From:   "Suthikulpanit, Suravee" <suravee.suthikulpanit@amd.com>
In-Reply-To: <Yc3r1U6WFVDtJCZn@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR06CA0228.apcprd06.prod.outlook.com
 (2603:1096:4:68::36) To DM8PR12MB5445.namprd12.prod.outlook.com
 (2603:10b6:8:24::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 609c0048-cc72-4ad0-b540-08d9e5726516
X-MS-TrafficTypeDiagnostic: DM5PR12MB1449:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB1449338FB04374E47F342621F3269@DM5PR12MB1449.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5O1MKB7YCx9wsL8O2cM49nTTQCblchU5FU4cG5uX6m25j97tdm/6gux1vcawSK8AmATLgM3tuclxBqZVnDAhTrIxIt6J7ErsXKEoO2cx6RaNUC91VU/wU6juYlmSgBqTa7T5VKegRHagFhsXVxSn37Zwo5VP1qawcjooSa/aYnFbGbf+WBdkBpMcWfbAbLFliEEBGzDSHsJS8/tpg5jUnz17O+VxQrdRqLLXyZsHUw9f1Y2bsm1ZJ6DymdYHT7kw6wtKMqxvQrBz4NYe6zq6UhbQL+FBkwZmvJJFBUKno4bcRR+m962OBUrm2gKwC3Uh/HpVgPxizw686YjAD4nxxsE6lbTu4k5/NjJQH8yJTM1ok7ipjiM33UtuAPUWTDQw7hzknXY6Q3RYTZ5dO+QLz2Aa659ng3q2pD8qThVwuT5YKwgv0wYP+bCyEFPpE2q+Buz9ar3XZym+z2GUIPgcm0OEED1v0mROm0nY2EGHFawy9/KqUxqR0aQvkEfDgBLBZsycS91+ROkrxGs+w6UfspSKCekgTEt1/onGyCgt55twwSehmGbLBgzFgoMQtdUiDZRnlWTGJ8vV96ov6jPZTL3FM6pBNMHAFOE8uP7JsTFz28DCS9IVDPMEV109hitkDuuHzvmM+TfMsQhKQ7OoxLAZNPPPWlfEvJM9STF++vqmRzxt8EfzW7tVXLKnWfeBS9xrQAMOEeN7GL00+KCGPv9iwSMzUiP2pkR5FERIy4U=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5445.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(36756003)(4326008)(86362001)(5660300002)(38100700002)(66556008)(53546011)(6486002)(7416002)(31696002)(316002)(6916009)(6512007)(508600001)(6506007)(66946007)(8936002)(8676002)(66476007)(6666004)(31686004)(2616005)(83380400001)(2906002)(186003)(26005)(43740500002)(45980500001)(20210929001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ekEzb0dkSEZPaFI5Q2FnV1kvUTd5OFBpWndNMUNiY3Zud0IwQVQyeWhlQmNu?=
 =?utf-8?B?VEEzRmVzeDhaaEVwTmZjVGhrYVF2SFk0NlJRcFFqN0NiaHkwSDRYbXErU3hh?=
 =?utf-8?B?YVFsNlByMFErd2xrUjJaUnNPUlRnY1c3ajNLRXJ5MVBKemlBVUV5YjdMMEx0?=
 =?utf-8?B?L292VnFPNlNHV3BnUVRkWUFuNjhicloxSUQ2UnJXTHFaOTZVamxqN1JNVE1L?=
 =?utf-8?B?ZmdMMW9taEt2a3M3WkNBNSt4RktsS3RJNjRJWEU2Z1UrMVRqUUZqMnVadjZG?=
 =?utf-8?B?M1JiN2lzSlJLcFlsdURCZXM4UUpoL3JPRVVZK3dCOVpVQXhxUlVjeFpqTG9H?=
 =?utf-8?B?QTkxWFNvWXZBbkUwOE9sUy9ZOFBhaHlNU0J0ZGx5UlA4Mkd4UGdZV2E3K2NE?=
 =?utf-8?B?K3F0VnF2Z3BJUXZZcDlkTHFxMldiSGNlc05zKzJxcGMvdkJyR081dFJHWG5i?=
 =?utf-8?B?ZU5odXFmMDNPNndRUTNCU09VU2xyQnhzcG5ONGhDQzVJMGp4cW9CUm9UaHV3?=
 =?utf-8?B?bElUNTFBbmh3a1hKL1lXOElBQnNWTTRxdEFDc0VENXdDRG83SW9DYUpkTTUz?=
 =?utf-8?B?MWtFSEx0TkFYNS9mMElEU3lBRGxtZlJnRXdFeE41RUg0UkJWRnFMRUtPaU5v?=
 =?utf-8?B?OUhxdkpGOUlMZThlVG9JUnhPeXJKZWhPUkRuaWpQWXpkZ2kvWWNCM2gwcnFj?=
 =?utf-8?B?eFFzdVZETkJUbm9Jbit6M0twL3FBaWxEeWtPSmZmN2J2V3JPL0hwSDkwT2lO?=
 =?utf-8?B?SDhBakl2ZVltL0RaM3NWS3NaQWNJYXhCcjhWZG55VGRFclZRdnZaSWNCS0RY?=
 =?utf-8?B?SXM2R25EYm1PWkdmREoyYTc3QTg0RHBvRFJOaU83akhJY2QvWlErMEdwUnRj?=
 =?utf-8?B?K3d3TFRNS25zTXpPN04yNGx0ZU5tanV4QmU1ZDFnTnhYNlhpK21RL21DeWVo?=
 =?utf-8?B?TThCenVpVUM2QXlpTTB0Wm5SMU5ndzZwKzgwczJ3d2dyYmFiN1puUFJEeXlI?=
 =?utf-8?B?SU5ZTHRmTGgvYmc5aFFOVHZKVXFzWlU2OFhkS1FTRm9Icm5UcTZ1TDVEcnhL?=
 =?utf-8?B?UzhWQ1BQRmw5cDlEbDlNZHR6SnFhV2xmcCs3bzR0am80clRDQTVNYjNRODVX?=
 =?utf-8?B?Z09CekJvUW1TTStIWVRmUFdGemRwc2FQVGtneWZqUkVNNFB1ek9oNVZBMXpN?=
 =?utf-8?B?ZWdyWFQ1VHJ1M2g4UFFYb3BubHQyZDgrMkxCTVFOQU01TUlpcERqMnZHcUdU?=
 =?utf-8?B?TGlDWHRuY3ZacWQvSjhLaHkwU3JrakpiK1NHWDFEcjV3NjlwM1lRRExqODZH?=
 =?utf-8?B?MnhjZHp1eXRoM2l2ZEs2RWZJc2x0TG9STUYxakcwZDFtMFhVdmpFQjZXL1Vx?=
 =?utf-8?B?cUJ6TklaMHY4aWNSMysyM0dzVnVycjhoYkE3OFllTHNQYVlVdXZhQ1pndmp4?=
 =?utf-8?B?ZUQ1VnJaNThnRHJsT09uVTBaQndXSk1hVVphM1JZNVhJQllsSmNzcVB5UEMw?=
 =?utf-8?B?WHZYN2xwZTdENkdMdnl5T3hyOVVoaDhMUXdacnVsVE1ZbldndTJJTVY4SFJk?=
 =?utf-8?B?V2UrZFZXaEJhWHBhSjZIeFhFMXhCZUdVWGZ1MUh3aFgvMWxENC8wNFQrTy9j?=
 =?utf-8?B?YzZUbXFBN3lFVzJ3N0FRWjVKeTJVVVFxV09ZUHYvemdZR3JJaDYzcXdReWZO?=
 =?utf-8?B?dVpZa1RVa3BMZmloVHhqZXVpUWFaWTFQODYyZmE4U3hxSnZST1hNZkhVUkZm?=
 =?utf-8?B?Y3BLL2tZR0ZWOHFzTUZSVGkxZ0pzekg2YnVBZUpEQ0FEQk50SWs0Ly9tOGFO?=
 =?utf-8?B?RE9kY2tMaVUySjhPM1hjY2VsblkvbzZjbWNTM0NNWXRzc1FyeGxJcUZCeGkx?=
 =?utf-8?B?d0tFV3dwYlI4TTAyRTh4SkJQaW9CRkZpY3Btdll4ek52eWxnaWs5ZFJkakhE?=
 =?utf-8?B?L1dSRWE5Z00xcGpRRnMxOGxpU3EyYTNPa2twdlVwK3VUMjN4M3VyZUw2VHYw?=
 =?utf-8?B?K0tNbXgzVVlVUisrMW02VEtSRWIxZnRiMEZtOUxORGxISFVUcU9RT1ZOWmN2?=
 =?utf-8?B?VWtNU0NGbCtrKzJqSSt0eTRKd2psY0EvWkFkZkRGWHJUcHZyWWxOa2pSMFZM?=
 =?utf-8?B?V01tYytSbnk3Z1ZSanhkZTBXbm9wYlI0MWEwdzlsNWNsdHgzdUpsdkJkSXNN?=
 =?utf-8?Q?gtqO/JCLZhiVCM5qTepR8AI=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 609c0048-cc72-4ad0-b540-08d9e5726516
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5445.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2022 11:02:53.9185
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LOVq7z1ZZjkCrChJVk1txs8uys+wUIQBlaFh94co2bQghawvyUxMGGXoyTiWqg52RkKXMsM6XVKmKf2GJVqx4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1449
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean,

Thanks for the suggestion. I'll update this in v4.

Regards,
Suravee

On 12/31/2021 12:26 AM, Sean Christopherson wrote:
> On Mon, Dec 13, 2021, Suravee Suthikulpanit wrote:
>> To prepare for upcoming AVIC changes. There is no functional change.
>>
>> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
>> ---
>>   arch/x86/kvm/svm/avic.c | 10 ++++++++++
>>   arch/x86/kvm/svm/svm.c  |  8 +-------
>>   arch/x86/kvm/svm/svm.h  |  1 +
>>   3 files changed, 12 insertions(+), 7 deletions(-)
>>
>> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
>> index 8052d92069e0..63c3801d1829 100644
>> --- a/arch/x86/kvm/svm/avic.c
>> +++ b/arch/x86/kvm/svm/avic.c
>> @@ -1011,3 +1011,13 @@ void svm_vcpu_unblocking(struct kvm_vcpu *vcpu)
>>   		kvm_vcpu_update_apicv(vcpu);
>>   	avic_set_running(vcpu, true);
>>   }
>> +
>> +bool avic_hardware_setup(bool avic)
>> +{
>> +	if (!avic || !npt_enabled || !boot_cpu_has(X86_FEATURE_AVIC))
>> +		return false;
>> +
>> +	pr_info("AVIC enabled\n");
>> +	amd_iommu_register_ga_log_notifier(&avic_ga_log_notifier);
>> +	return true;
>> +}
>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>> index 989685098b3e..e59f663ab8cb 100644
>> --- a/arch/x86/kvm/svm/svm.c
>> +++ b/arch/x86/kvm/svm/svm.c
>> @@ -1031,13 +1031,7 @@ static __init int svm_hardware_setup(void)
>>   			nrips = false;
>>   	}
>>   
>> -	enable_apicv = avic = avic && npt_enabled && boot_cpu_has(X86_FEATURE_AVIC);
>> -
>> -	if (enable_apicv) {
>> -		pr_info("AVIC enabled\n");
>> -
>> -		amd_iommu_register_ga_log_notifier(&avic_ga_log_notifier);
>> -	}
>> +	enable_apicv = avic = avic_hardware_setup(avic);
> 
> Rather than pass in "avic", just do
> 
> 	enable_apicv = avic == avic && avic_hardware_setup();
> 
> This also conflicts with changes sitting in kvm/queue to nullify vcpu_(un)blocking
> when AVIC is disabled.  But moving AVIC setup to avic.c provides an opportunity for
> further cleanup, as it means vcpu_(un)blocking can be NULL by default and set to
> the AVIC helpers if and only if AVIC is enable.  That will allow making the helpers
> static in avic.c.  E.g.
> 
> ---
>   arch/x86/kvm/svm/avic.c | 17 +++++++++++++++--
>   arch/x86/kvm/svm/svm.c  | 13 +------------
>   arch/x86/kvm/svm/svm.h  |  3 +--
>   3 files changed, 17 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index 90364d02f22a..f5c6cab42d74 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -1027,7 +1027,7 @@ void avic_vcpu_put(struct kvm_vcpu *vcpu)
>   	WRITE_ONCE(*(svm->avic_physical_id_cache), entry);
>   }
> 
> -void avic_vcpu_blocking(struct kvm_vcpu *vcpu)
> +static void avic_vcpu_blocking(struct kvm_vcpu *vcpu)
>   {
>   	if (!kvm_vcpu_apicv_active(vcpu))
>   		return;
> @@ -1052,7 +1052,7 @@ void avic_vcpu_blocking(struct kvm_vcpu *vcpu)
>   	preempt_enable();
>   }
> 
> -void avic_vcpu_unblocking(struct kvm_vcpu *vcpu)
> +static void avic_vcpu_unblocking(struct kvm_vcpu *vcpu)
>   {
>   	int cpu;
> 
> @@ -1066,3 +1066,16 @@ void avic_vcpu_unblocking(struct kvm_vcpu *vcpu)
> 
>   	put_cpu();
>   }
> +
> +bool avic_hardware_setup(struct kvm_x86_ops *x86_ops)
> +{
> +	if (!npt_enabled || !boot_cpu_has(X86_FEATURE_AVIC))
> +		return false;
> +
> +	x86_ops->vcpu_blocking = avic_vcpu_blocking,
> +	x86_ops->vcpu_unblocking = avic_vcpu_unblocking,
> +
> +	pr_info("AVIC enabled\n");
> +	amd_iommu_register_ga_log_notifier(&avic_ga_log_notifier);
> +	return true;
> +}
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 6cb38044a860..6cb0f58238cd 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4390,8 +4390,6 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
>   	.prepare_guest_switch = svm_prepare_guest_switch,
>   	.vcpu_load = svm_vcpu_load,
>   	.vcpu_put = svm_vcpu_put,
> -	.vcpu_blocking = avic_vcpu_blocking,
> -	.vcpu_unblocking = avic_vcpu_unblocking,
> 
>   	.update_exception_bitmap = svm_update_exception_bitmap,
>   	.get_msr_feature = svm_get_msr_feature,
> @@ -4674,16 +4672,7 @@ static __init int svm_hardware_setup(void)
>   			nrips = false;
>   	}
> 
> -	enable_apicv = avic = avic && npt_enabled && boot_cpu_has(X86_FEATURE_AVIC);
> -
> -	if (enable_apicv) {
> -		pr_info("AVIC enabled\n");
> -
> -		amd_iommu_register_ga_log_notifier(&avic_ga_log_notifier);
> -	} else {
> -		svm_x86_ops.vcpu_blocking = NULL;
> -		svm_x86_ops.vcpu_unblocking = NULL;
> -	}
> +	enable_apicv = avic = avic && avic_hardware_setup(&svm_x86_ops);
> 
>   	if (vls) {
>   		if (!npt_enabled ||
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index daa8ca84afcc..59d91b969bd7 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -573,6 +573,7 @@ extern struct kvm_x86_nested_ops svm_nested_ops;
> 
>   #define VMCB_AVIC_APIC_BAR_MASK		0xFFFFFFFFFF000ULL
> 
> +bool avic_hardware_setup(struct kvm_x86_ops *ops);
>   int avic_ga_log_notifier(u32 ga_tag);
>   void avic_vm_destroy(struct kvm *kvm);
>   int avic_vm_init(struct kvm *kvm);
> @@ -593,8 +594,6 @@ int svm_deliver_avic_intr(struct kvm_vcpu *vcpu, int vec);
>   bool svm_dy_apicv_has_pending_interrupt(struct kvm_vcpu *vcpu);
>   int svm_update_pi_irte(struct kvm *kvm, unsigned int host_irq,
>   		       uint32_t guest_irq, bool set);
> -void avic_vcpu_blocking(struct kvm_vcpu *vcpu);
> -void avic_vcpu_unblocking(struct kvm_vcpu *vcpu);
> 
>   /* sev.c */
> 
> --
> 
> 
