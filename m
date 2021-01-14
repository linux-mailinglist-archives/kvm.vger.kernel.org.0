Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AFBC2F6D8E
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 22:57:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729941AbhANVyv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 16:54:51 -0500
Received: from mail-mw2nam12on2073.outbound.protection.outlook.com ([40.107.244.73]:18048
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726755AbhANVyu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jan 2021 16:54:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b8MVHeEtsREyZOPE7jXZQ4sr59nIzVZe+UUWx2uFMeGPSFHD/hEg3zwcRSl9wgwGMCM+IGWSuf4JZMUlvKASN/SRjZB5h4WYRA3JwYbVZajhkbYH7+cXpH8ryis65H+Em4NwqduXDvq538pVo6xiyTEsOrO+w5W+zshZnkQPA2wJWK9pz7Q7YEpNZIChx9vAKpbxYjSpoef6kaDJ4bDyHV4KimMN7aobu6nQoJCOphDx4P91MfBOfhKHKTiGYUhYNDizTpFdioL72d1iJdIpNNzIqjbQORZbr2xxU0neO/aY/BF35Q7HdEjnxKeI0ElVuI1xPiBSSCL9yWPW7OnAHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zCoplVSf7jde8u4gD31aeMy0EA+zpZs8oiGsEyEMuMc=;
 b=V9eaMeeo43eu4xsuz4gOPE2wRRuSsGn8ionkOGwTd35benY3xju60uMZlZ//hFIC6GPVV3yfwIHCzGX2aeixMCNvoxjSVKDwovoJw5NoCRdaJ2fRCGuEl/q1ixZtUPCSobyH4Qixvbv6JJvVCCRq7iIvugNM/zu8y7OsYIH7ZdIApKFcEGMfP4G6OJ4q6uTJs4SKIqkMYehld0E79PR3CqaSpuYOOKPZpCo0IUD/cp5OGvsXajGPKdDk140aa3Zu8Ow5NDgXUuBcvtLC2VtEanSU8b8+k88cleHFZt9zS7zPuDJA3aa17yCjroUNGsiRiC1Txuo65+lyLLDEnS5ASQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zCoplVSf7jde8u4gD31aeMy0EA+zpZs8oiGsEyEMuMc=;
 b=TGpsCbmwyOWqmXu1vKxlmUWJWPHiwoKizSBLksoD1uiZxtcPrxoSH2/TtPg7OlD/ZRUzP9rD9pXhT0K5JNj5/XQs8dYKAO772e8sv0WmXS+HzUjh/vSMzpGgU3rtE5rn3TNAM22k9MKTflU66sztdcK0PlCg3ZVM0F7t5c51Qik=
Authentication-Results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB3769.namprd12.prod.outlook.com (2603:10b6:5:14a::26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3742.10; Thu, 14 Jan 2021 21:53:57 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845%12]) with mapi id 15.20.3763.011; Thu, 14 Jan 2021
 21:53:57 +0000
Subject: Re: [PATCH v2 11/14] KVM: SVM: Move SEV VMCB tracking allocation to
 sev.c
To:     Brijesh Singh <brijesh.singh@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@suse.de>
References: <20210114003708.3798992-1-seanjc@google.com>
 <20210114003708.3798992-12-seanjc@google.com>
 <10d43bb0-e19d-6d53-20f7-fa73983adb4a@amd.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <2873afaf-a390-39b0-b057-fb6a9a516a01@amd.com>
Date:   Thu, 14 Jan 2021 15:53:53 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <10d43bb0-e19d-6d53-20f7-fa73983adb4a@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SA9PR13CA0062.namprd13.prod.outlook.com
 (2603:10b6:806:23::7) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SA9PR13CA0062.namprd13.prod.outlook.com (2603:10b6:806:23::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.4 via Frontend Transport; Thu, 14 Jan 2021 21:53:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2d0da31e-85d8-48ac-8623-08d8b8d6e4bb
X-MS-TrafficTypeDiagnostic: DM6PR12MB3769:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB3769C6B78BDFD07E61A8CF09ECA80@DM6PR12MB3769.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zD6yLzIJP+AB2d2WX0/KK0ccA+6wtx1fLglvZYHYJZlPJjS6Q24rLiRVYnjrRm/48smMHF3i/ZBe9yPo7Uby4PLpXBWcEhEpzd4fJrjRs58wITgXKlABh1Zydi7tmZ1Wth+1cFCHbUcQdaw/G4xFJEPD2cwdWviZzWDIQZFkxjV8Q0539UzPGo9bvyditMhtC54wXUmCQkdYB/DBJrmRqQGY8Tre5smvShchW8URIQ9msRJR5LEUZjFXProSRh2ggtcshMH5dQsMaI0Wsljxk+mKVzQHwAaB9hGMAaSLntyHjaOC7n2opkQzie4bLuwEFNOTltbLJGKG9px9SAcGVY+g/xCm/B1LN0KwuTEsB2sxnkVhC7/16htty6t/MAybqxFyG/CkwSr+myS3LDZcR63z0pOxULauydSETw6aL127ocgtJXB1E4yK5uaJL24/dgHWhd0lfrxle68dkR0sKSOpDJr68YMzC/HSzMl2GLM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(39860400002)(346002)(396003)(376002)(2906002)(6486002)(6506007)(26005)(53546011)(52116002)(316002)(956004)(110136005)(31696002)(86362001)(31686004)(478600001)(54906003)(16526019)(66556008)(8676002)(4326008)(6512007)(5660300002)(2616005)(83380400001)(186003)(66946007)(36756003)(66476007)(7416002)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?a21Wb1JOcHkwNlpsWUxDVnBrRHM3aWV1VUlBTklIdTZtZkVFY3pFem52Vll3?=
 =?utf-8?B?NlJrb0hKQnAvbEtobDZGRHVKRXU0czFBdzlEZ0FJa1pRazhpMlAvZW5FSTUw?=
 =?utf-8?B?V1QxS0o1V1ozYU80SEVUdmF2SzdSL1FQRW0ycmk3T0o4VU4zeGZSempnMnhi?=
 =?utf-8?B?cmdzQUZkaUI0QnhhK0pONkI0c1pZTkZldFpkcTBEVEZqM2ZsSDBxbUFRQVVt?=
 =?utf-8?B?Wm16NlBVdUxlclFGL3hlYk5SazJXUmhSaGZGbGdKZHViMW90bWd6UnJKeEhj?=
 =?utf-8?B?aUtKcm10YU5aU3dHc2Nsc1BJMERqTVhjOFRlWFBtU3RPMXFqYklENG5LVXpx?=
 =?utf-8?B?bkV5b2FPakJ0eDFETlRaZm5YS25GQWNydG9IekM0c3FsbVdFbEVDSlIwNEZ0?=
 =?utf-8?B?UG9wd1RWV3R1MlFwdzhnOE5XR0llYzkrK05HdDNwR2gyZXF5QlhjNGlteVhh?=
 =?utf-8?B?WTdTbmVDOEJDRGZsbTk5ZFkxTTNVTTJXTXdYaFIxd3VjYS9oM0NOTDNmcFkw?=
 =?utf-8?B?V1VDaHJONGFjSjJiN0Nodnc3T2hNV1oxNzZYVUZrek5tMjJZS0phT1NuUitF?=
 =?utf-8?B?MDhnckN0RnVxVjZ4M1FkQkRwMWsyYWROQlhQRS84Yjl6WTduR3h2N2twZkU1?=
 =?utf-8?B?aTdmSzA4RElaT21kSkhVMUhpc3hxMmE3cmRRaWVyUHBxTkJnUndPbDJraFZa?=
 =?utf-8?B?bXcyMkp1UHZickJxREEwYVdWRlZjWnZWWmtMVHc0VER0aXRWWjdpc0QyR01j?=
 =?utf-8?B?eG5NNXdadTRsNGNCVTJIVFZESDR1ZEVvUWZzY3Rkc3Z1aXg5ejNYQkhEOGJL?=
 =?utf-8?B?Y2dZaWNNLzYrcDh5anVrbmEzaFBoZXFwekUxeHlVUi9PVnRpRjBkeVVRQ0p3?=
 =?utf-8?B?cWZrTU1nVWUrZkwyRHgrMTZjc1BGNG5SNmFuQ3VuUVoxSXJIeWZYZHUwNU9j?=
 =?utf-8?B?K1ZnY21hL2YyQW1yMjlCVElSWE1zN1pJQllhbHlDZmFKd3ROaVN1ZzB4d3Zn?=
 =?utf-8?B?a3dHRm5TdkZWSXQxZ3FjZVVaV3ZDVWU0UDE0R1pSWFQzNHU5TnF3dmN2VldC?=
 =?utf-8?B?TVovK01NWUcvZm1jTHAxL2R5TjdYL1RGWUJybmIwemJSWmJDM3UwdFBkZ1BV?=
 =?utf-8?B?NFppa01uVmxJSlh2d2JyaDVrZUlRdmx6QmNIUGhmalFJdDVKd1RYMkRDaG5H?=
 =?utf-8?B?bmtEZnZDa092WS9BZXoxRElhMDBkSkYwakRndWhNQ0NTYkg3Mm8rVFluRWR6?=
 =?utf-8?B?eGFVRm9KTFlZV2xWSjcyemo0bGlRSTJhOHJ0YU9pRnhtL1piNWpTbEJwcmpJ?=
 =?utf-8?Q?vRzzFUEBBwWa0/eHEMIrKk+7DBW5VdR9eI?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2021 21:53:56.7674
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d0da31e-85d8-48ac-8623-08d8b8d6e4bb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hB3dyIsGScvDjj7UY163y99e60kIbM4XWjboHtd3xRoskXJHGdCv3+KCA/3sJrWu82v0E5GHQdh4BFx6yuDARA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3769
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/14/21 3:37 PM, Brijesh Singh wrote:
> 
> On 1/13/21 6:37 PM, Sean Christopherson wrote:
>> Move the allocation of the SEV VMCB array to sev.c to help pave the way
>> toward encapsulating SEV enabling wholly within sev.c.
>>
>> No functional change intended.
>>
>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>> ---
>>   arch/x86/kvm/svm/sev.c | 13 +++++++++++++
>>   arch/x86/kvm/svm/svm.c | 17 ++++++++---------
>>   arch/x86/kvm/svm/svm.h |  1 +
>>   3 files changed, 22 insertions(+), 9 deletions(-)
>>
>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>> index 1a143340103e..a2c3e2d42a7f 100644
>> --- a/arch/x86/kvm/svm/sev.c
>> +++ b/arch/x86/kvm/svm/sev.c
>> @@ -1330,6 +1330,19 @@ void sev_hardware_teardown(void)
>>   	sev_flush_asids();
>>   }
>>   
>> +int sev_cpu_init(struct svm_cpu_data *sd)
>> +{
>> +	if (!svm_sev_enabled())
>> +		return 0;
>> +
>> +	sd->sev_vmcbs = kmalloc_array(max_sev_asid + 1, sizeof(void *),
>> +				      GFP_KERNEL | __GFP_ZERO);
> 
> 
> I saw Tom recommended to use kzalloc.. instead of __GFP_ZERO in previous

kcalloc :)

Thanks,
Tom

> patch. With that fixed,
> 
> Reviewed-by: Brijesh Singh <brijesh.singh@amd.com>
> 
> 
>> +	if (!sd->sev_vmcbs)
>> +		return -ENOMEM;
>> +
>> +	return 0;
>> +}
>> +
>>   /*
>>    * Pages used by hardware to hold guest encrypted state must be flushed before
>>    * returning them to the system.
>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>> index bb7b99743bea..89b95fb87a0c 100644
>> --- a/arch/x86/kvm/svm/svm.c
>> +++ b/arch/x86/kvm/svm/svm.c
>> @@ -552,23 +552,22 @@ static void svm_cpu_uninit(int cpu)
>>   static int svm_cpu_init(int cpu)
>>   {
>>   	struct svm_cpu_data *sd;
>> +	int ret;
>>   
>>   	sd = kzalloc(sizeof(struct svm_cpu_data), GFP_KERNEL);
>>   	if (!sd)
>>   		return -ENOMEM;
>>   	sd->cpu = cpu;
>>   	sd->save_area = alloc_page(GFP_KERNEL);
>> -	if (!sd->save_area)
>> +	if (!sd->save_area) {
>> +		ret = -ENOMEM;
>>   		goto free_cpu_data;
>> +	}
>>   	clear_page(page_address(sd->save_area));
>>   
>> -	if (svm_sev_enabled()) {
>> -		sd->sev_vmcbs = kmalloc_array(max_sev_asid + 1,
>> -					      sizeof(void *),
>> -					      GFP_KERNEL | __GFP_ZERO);
>> -		if (!sd->sev_vmcbs)
>> -			goto free_save_area;
>> -	}
>> +	ret = sev_cpu_init(sd);
>> +	if (ret)
>> +		goto free_save_area;
>>   
>>   	per_cpu(svm_data, cpu) = sd;
>>   
>> @@ -578,7 +577,7 @@ static int svm_cpu_init(int cpu)
>>   	__free_page(sd->save_area);
>>   free_cpu_data:
>>   	kfree(sd);
>> -	return -ENOMEM;
>> +	return ret;
>>   
>>   }
>>   
>> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
>> index 8e169835f52a..4eb4bab0ca3e 100644
>> --- a/arch/x86/kvm/svm/svm.h
>> +++ b/arch/x86/kvm/svm/svm.h
>> @@ -583,6 +583,7 @@ int svm_unregister_enc_region(struct kvm *kvm,
>>   void pre_sev_run(struct vcpu_svm *svm, int cpu);
>>   void __init sev_hardware_setup(void);
>>   void sev_hardware_teardown(void);
>> +int sev_cpu_init(struct svm_cpu_data *sd);
>>   void sev_free_vcpu(struct kvm_vcpu *vcpu);
>>   int sev_handle_vmgexit(struct vcpu_svm *svm);
>>   int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in);
