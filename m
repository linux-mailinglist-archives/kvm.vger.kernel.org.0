Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED5AF2F19D8
	for <lists+kvm@lfdr.de>; Mon, 11 Jan 2021 16:38:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730517AbhAKPh0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jan 2021 10:37:26 -0500
Received: from mail-co1nam11on2049.outbound.protection.outlook.com ([40.107.220.49]:42468
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727180AbhAKPh0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jan 2021 10:37:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qqo17xVFrhFldRy/INinVTjUsBVKt9jMqMcqhPsXR8RKXXg0GN4sSgf2/Ceo7LvBXURFul2xD4/DcHJPwP/W0wHmEFTonH1vAfnTZ9zCvhm8qg6KXjzuccqvaM0WfRY0+Ysij3w6AUA1AdbcW6r5vV3+inA6JxkRiTUbraZhTMNBNL3FHHdQm/U6EbvD7tZEw5NsgEIw2/GL6tALuDrikFEovepF03pVCkIrZ6Q+t7PYHWew+9ewlmwyNAZpIFJywYlSvY1tHiLSfl48uX65VcdkfAxGTZCdcJn0eGq5wM6Adoz9VH8/NwwF4iOkMeVNmAmD+Pt6PcX1A8YPpvXzbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XxoxZNF2O5Lhidf85TVbu3v1lJi+5PVw9SkOSiTinq8=;
 b=LZgMTc3Oc9pdsR1iRCu99Fnco9xVZVrVVTiw8xW3EynLBGEtpt5G7ZFNwI1VV4i+3yipOA6vXlHBbYwKFdCuxx/IqZLhy5Hx0UH0qJbzdTkWOglibiAGZtLrKVXvfgE8QiLaXxIuHScRuwYn9F/IPe/UFctetHfTjGEljKj3MFbL3uqUEsfpnRHTnrAmEoud98B3fn1lAKVyzIGFv/uKIVp9s6/c38+CB9sACd6I9nEVcXQYrh1dEW9NpMeQtDAQUjHSwBFkJ1jBDM3w3lkFJpzW33C/++EJByn+iTbNKnXvalR5UOGppyPaCJf9mTraYw6uwNUtEkCnEQCMJ6HRCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XxoxZNF2O5Lhidf85TVbu3v1lJi+5PVw9SkOSiTinq8=;
 b=xaoQkzpcKts0VK/Na2+67YMaYaxAd5tmagJfs+cEsJXBnggDjL3Ns698dL3nbH2m/bDkL75Emiz19Ehmbs1sTN2COeipcF//z2ajIETfkFNDAU6c4jXqfsRWc2AGYr20G3/Qvi8INSFQ9Dn3vnhiutsscbTtfALTR4wz5dFaKv0=
Authentication-Results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB3370.namprd12.prod.outlook.com (2603:10b6:5:38::25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3742.9; Mon, 11 Jan 2021 15:36:32 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845%12]) with mapi id 15.20.3742.012; Mon, 11 Jan 2021
 15:36:32 +0000
Subject: Re: [PATCH 03/13] KVM: SVM: Move SEV module params/variables to sev.c
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
References: <20210109004714.1341275-1-seanjc@google.com>
 <20210109004714.1341275-4-seanjc@google.com>
 <87sg7792l3.fsf@vitty.brq.redhat.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <672e86f7-86c7-0377-c544-fe52c8d7c1b9@amd.com>
Date:   Mon, 11 Jan 2021 09:36:29 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <87sg7792l3.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SA9PR11CA0026.namprd11.prod.outlook.com
 (2603:10b6:806:6e::31) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SA9PR11CA0026.namprd11.prod.outlook.com (2603:10b6:806:6e::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.22 via Frontend Transport; Mon, 11 Jan 2021 15:36:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f02395be-7b13-4785-374e-08d8b646ac4a
X-MS-TrafficTypeDiagnostic: DM6PR12MB3370:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB33706710F88C9E83B0819673ECAB0@DM6PR12MB3370.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WmeFAD54rHGnoLhLW6VOzffFKvSdv8zqY8rR0pTogKQlXKANoFPN+eUa5MGuWErX7UUeKB+iiHRQypplsZqei0ZbdmITqHk4xG8lYEHKbsIa0r3rhzhNqw6tHpHRdC1YSiy6cQmUagTvZQDTvNTx0w522bi2WIO8seveXEVx3uEEStru6xpEntPBHWK7WjMnD6lY5k888EpDCkVmiZmSaWl2/UV4yqg6LROWD6nT4yJ4MiJbtd9rjqF8ln341KGbwo9BuC447JcBQJ/u9tgh8BIcOchhcjR4zeXiIAvm9buvXM5DOcfT2pOD5bS1oVPlk57ClTkzh4vV3qTvPIPIdtokX5k4BRPdwwuiE8G+pfX/ytjOCXaw+57372rRQwFIekqvHSPRY/2YotgLaSlh+pSJsjq5o9xedEApt+K0PLN73zd+xq72qFpSobeW5ziIWg7RKnpel+o/H+Krf16gkushl8xTkr+q8LC9GubjpFk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(396003)(376002)(346002)(136003)(2906002)(16526019)(8676002)(53546011)(7416002)(6486002)(186003)(26005)(956004)(66476007)(31696002)(6506007)(4326008)(86362001)(36756003)(6512007)(316002)(66946007)(66556008)(83380400001)(52116002)(31686004)(478600001)(110136005)(2616005)(5660300002)(54906003)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Q2VsUVNyMEI0L1VmbEN2Z1Bqc1dOVEhtak5rVytRa1JPZTNBWjhYTkZrVEIv?=
 =?utf-8?B?NDYxQUROUkdQbS9ZT2Nnc3cvVDQ0TTJOVHFhSHdzZE1GTkhXSzZCc3JCamxY?=
 =?utf-8?B?eXNYcDNBNGd1KzFEcFg1dTAyMU9LbXZUaVczeUhkaHdQK3RneXdjMGJFcnhZ?=
 =?utf-8?B?bC80RjFhdGV4UlF4NHFmK1NmaExBdVhKRDkwM2dyOGFwaGxGQ0pwaUEyUHV0?=
 =?utf-8?B?QXBES1lLRW1lYVNXc2R2MktqVC8xMi80ZzRXakd0cjVmSGl1KzZ6WlpzdmtM?=
 =?utf-8?B?T0txOHVQWTNIL2wrK2w5a0JEREIyVEpraEFrbDhGL3FxWW1ncFNZZjFEdkxr?=
 =?utf-8?B?QmxUVHNubUIvTm9acTNKS1dOTjNmQlJRQlRaNFdranNsVG9iaytUUmRJd1gz?=
 =?utf-8?B?VmIrd2pWYXdJU2c2R2pzWUJaYlZReEhzUUltWkd5cDdUWlduZ2lTamtKOHgw?=
 =?utf-8?B?YWdGKzgwaC8wR2w5YVZWdzVQTlhZc2NwMHAwTXMwK3A1MldmU2Z6KzIvbm1D?=
 =?utf-8?B?K3ZuU2txeHRCVERyTlFCb3hycEFBeWxNU0N2Z2czeTJYVTlma3RBckhEOUxY?=
 =?utf-8?B?YUdWNGliTWVzak5RVlc1T3ZoL2VJazkyUHZZUnFkTXN5QnYvVkR5RDRYZURQ?=
 =?utf-8?B?MTR3bWt5KytJT3VCZlBjc0g4cDc3Nm9EN2FWb2xTd2Y1WUlKMDN3NnMrUERy?=
 =?utf-8?B?cmlVNEhUWjJFbWRQaHMreWFTcGxXb3p2LzNqWGlabkJHS3E0YUh4UTdsUDFL?=
 =?utf-8?B?aStlSXFpK1pOODZZVjF3MFp3ZmI3bTRmdWRuQWIrOVpWYVdHQXFmR1hpMmZk?=
 =?utf-8?B?R28rZDRDUmNvbmtMUEZiYTc0LzB0ZXkrcDZ5bkExNy9oRUp1ckkxaTUyUysw?=
 =?utf-8?B?QU82bnpiTitJYmg1ZGFUMTFQMEo4UFpTT1ZwMFVSWkt2ZVNSOEFtNlhRaVU2?=
 =?utf-8?B?c2ExYjJLZlR5czcxUFFpTjk2YzlPTVNxdmtndzNCMEZSdkt0TTA1QnhBZENJ?=
 =?utf-8?B?dzJxdTRINkRjbTR5UVMrdldsTmNiR2pFTDhMbW9RT2czYWtIaGVPZ0xCNWpy?=
 =?utf-8?B?UUVwQlF5L2FGaGEzZUdXUTRKak5La0gxakEvUHFxQ0lzM3V3ZTJrMklwOVJ0?=
 =?utf-8?B?c3ZoVGo0NmwwWUZlVE1EVmpNWldzNXI2Q0hpZnhUd3pYU3BrZDEwWEg3dkVq?=
 =?utf-8?B?Q3dOUFdHRk5nSTZVallJTFllSStENDJhS1BYRGJFSDJ5bDJ5M3RUQU15U042?=
 =?utf-8?B?TWN6RXo0dEFHNUMxbkNrR2lYWDA1SFo1MWNsNWRvMmppS1BkVktlZ013SWx5?=
 =?utf-8?Q?pujLqeYKQm6XceItSlH4u8KeNhYearm2kY?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2021 15:36:32.6346
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: f02395be-7b13-4785-374e-08d8b646ac4a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XnMo+BQmJzmRBn2kDBqny9WgmGKILVQGT+Vuf+gKLz2oNy39PTjknLPHt+XI9FXSJs3RROl64zdKsVh5p//ccg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3370
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/11/21 4:42 AM, Vitaly Kuznetsov wrote:
> Sean Christopherson <seanjc@google.com> writes:
> 
>> Unconditionally invoke sev_hardware_setup() when configuring SVM and
>> handle clearing the module params/variable 'sev' and 'sev_es' in
>> sev_hardware_setup().  This allows making said variables static within
>> sev.c and reduces the odds of a collision with guest code, e.g. the guest
>> side of things has already laid claim to 'sev_enabled'.
>>
>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>> ---
>>   arch/x86/kvm/svm/sev.c | 11 +++++++++++
>>   arch/x86/kvm/svm/svm.c | 15 +--------------
>>   arch/x86/kvm/svm/svm.h |  2 --
>>   3 files changed, 12 insertions(+), 16 deletions(-)
>>
>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>> index 0eeb6e1b803d..8ba93b8fa435 100644
>> --- a/arch/x86/kvm/svm/sev.c
>> +++ b/arch/x86/kvm/svm/sev.c
>> @@ -27,6 +27,14 @@
>>   
>>   #define __ex(x) __kvm_handle_fault_on_reboot(x)
>>   
>> +/* enable/disable SEV support */
>> +static int sev = IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT);
>> +module_param(sev, int, 0444);
>> +
>> +/* enable/disable SEV-ES support */
>> +static int sev_es = IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT);
>> +module_param(sev_es, int, 0444);
> 
> Two stupid questions (and not really related to your patch) for
> self-eduacation if I may:
> 
> 1) Why do we rely on CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT (which
> sound like it control the guest side of things) to set defaults here?

I thought it was a review comment, but I'm not able to find it now.

Brijesh probably remembers better than me.

> 
> 2) It appears to be possible to do 'modprobe kvm_amd sev=0 sev_es=1' and
> this looks like a bogus configuration, should we make an effort to
> validate the correctness upon module load?

This will still result in an overall sev=0 sev_es=0. Is the question just 
about issuing a message based on the initial values specified?

Thanks,
Tom

> 
>> +
>>   static u8 sev_enc_bit;
>>   static int sev_flush_asids(void);
>>   static DECLARE_RWSEM(sev_deactivate_lock);
>> @@ -1249,6 +1257,9 @@ void __init sev_hardware_setup(void)
>>   	bool sev_es_supported = false;
>>   	bool sev_supported = false;
>>   
>> +	if (!IS_ENABLED(CONFIG_KVM_AMD_SEV) || !sev)
>> +		goto out;
>> +
>>   	/* Does the CPU support SEV? */
>>   	if (!boot_cpu_has(X86_FEATURE_SEV))
>>   		goto out;
>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>> index ccf52c5531fb..f89f702b2a58 100644
>> --- a/arch/x86/kvm/svm/svm.c
>> +++ b/arch/x86/kvm/svm/svm.c
>> @@ -189,14 +189,6 @@ module_param(vls, int, 0444);
>>   static int vgif = true;
>>   module_param(vgif, int, 0444);
>>   
>> -/* enable/disable SEV support */
>> -int sev = IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT);
>> -module_param(sev, int, 0444);
>> -
>> -/* enable/disable SEV-ES support */
>> -int sev_es = IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT);
>> -module_param(sev_es, int, 0444);
>> -
>>   bool __read_mostly dump_invalid_vmcb;
>>   module_param(dump_invalid_vmcb, bool, 0644);
>>   
>> @@ -976,12 +968,7 @@ static __init int svm_hardware_setup(void)
>>   		kvm_enable_efer_bits(EFER_SVME | EFER_LMSLE);
>>   	}
>>   
>> -	if (IS_ENABLED(CONFIG_KVM_AMD_SEV) && sev) {
>> -		sev_hardware_setup();
>> -	} else {
>> -		sev = false;
>> -		sev_es = false;
>> -	}
>> +	sev_hardware_setup();
>>   
>>   	svm_adjust_mmio_mask();
>>   
>> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
>> index 0fe874ae5498..8e169835f52a 100644
>> --- a/arch/x86/kvm/svm/svm.h
>> +++ b/arch/x86/kvm/svm/svm.h
>> @@ -408,8 +408,6 @@ static inline bool gif_set(struct vcpu_svm *svm)
>>   #define MSR_CR3_LONG_MBZ_MASK			0xfff0000000000000U
>>   #define MSR_INVALID				0xffffffffU
>>   
>> -extern int sev;
>> -extern int sev_es;
>>   extern bool dump_invalid_vmcb;
>>   
>>   u32 svm_msrpm_offset(u32 msr);
> 
