Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C55B3195FC
	for <lists+kvm@lfdr.de>; Thu, 11 Feb 2021 23:44:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbhBKWnn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Feb 2021 17:43:43 -0500
Received: from mail-dm6nam10on2052.outbound.protection.outlook.com ([40.107.93.52]:39649
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229936AbhBKWnl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Feb 2021 17:43:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EiP/fU0VUYEmaFWRnbXXBxL310yTTOUr4o5cKx0z1K+vtGusnHKDxkT9lMKOzulruU4CuNCgiA+QwHVkHPUZzvAEgbzTwClWFSR/Fgt47CmffjmHeLM90XFEWaUtXghj8jhjuXKVc+u6dIEjmQ0UmQpdweBADFnqQ+CdvgElrze+UjENCyC4ujcqqX7Ul+EkxnVvgkXlMWg/ifIluo/EdyC1hygCE4GuvPUono50ky5ksxOikNgwrxEcfv1/wop5ybGHbLVi5Tg+HKtMtAPTbYxDWxBMQhPe+p+CB/BbzOvZj69WA0yHBAMg4PRnYnE6wWDwWuWmJwpAdnzMuXQOZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yGbS+j/YVddvGlwV2EVo6bDbm0vfLBRUC2XB4HdSdkI=;
 b=LFik4K40VbwUvoxhlYQ6pKISZuQLd5Z5JlRrr3n2W4J/2zIzWu70TWmA1288LP/HnXUJiXDf/xbPeQ4L3l8sCsdFdp1mVH4vyi8ryU1jx0k9htNjmFekaMFb40ZiYqtk1AEGwnkVp08F2E270GYFcH4OtRMSDvBq9PBGhCZm9MOyDoZRj1JLyP9MeiLSSDorahScCMvYgCXBA2/zrTdGabEYtTcekfXHwRNVtvRzXV1ndKLrwcrcAo2gYQ63pfGdKQQABG6FXvM247+mS7RMClNVqmj7RAsWoGnHHv0UffhvOkNIfURUFkejxTUlbMKEEpjHnMNLqu2Xp+eCFe4WvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yGbS+j/YVddvGlwV2EVo6bDbm0vfLBRUC2XB4HdSdkI=;
 b=BYSmh24hnrtfULogNrMOsaNacPEkwxUFUO+gFQfwZV9Y84pZWnGt0Gd912q7F7AfXpffvwYepHpuiHGZ+DMoe0Ua9F4mLJjmP5enlmQb9SiAQUqDqUShSS1m/vnxXjspXblgVEIeaUYmpfYAICDzdr5nSQ50VV9R43u4SfnGJ/4=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SA0PR12MB4544.namprd12.prod.outlook.com (2603:10b6:806:70::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.26; Thu, 11 Feb
 2021 22:42:48 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::8c0e:9a64:673b:4fff]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::8c0e:9a64:673b:4fff%5]) with mapi id 15.20.3825.030; Thu, 11 Feb 2021
 22:42:48 +0000
Subject: Re: [PATCH v4 2/2] KVM: SVM: Add support for Virtual SPEC_CTRL
To:     Paolo Bonzini <pbonzini@redhat.com>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de
Cc:     fenghua.yu@intel.com, tony.luck@intel.com, wanpengli@tencent.com,
        kvm@vger.kernel.org, thomas.lendacky@amd.com, peterz@infradead.org,
        seanjc@google.com, joro@8bytes.org, x86@kernel.org,
        kyung.min.park@intel.com, linux-kernel@vger.kernel.org,
        krish.sadhukhan@oracle.com, hpa@zytor.com, mgross@linux.intel.com,
        vkuznets@redhat.com, kim.phillips@amd.com, wei.huang2@amd.com,
        jmattson@google.com
References: <161188083424.28787.9510741752032213167.stgit@bmoger-ubuntu>
 <161188100955.28787.11816849358413330720.stgit@bmoger-ubuntu>
 <addd9d50-4a2e-b3ae-ff32-5332ab664463@redhat.com>
From:   Babu Moger <babu.moger@amd.com>
Message-ID: <7ef28201-4a14-fdc6-4a28-153378c1efc2@amd.com>
Date:   Thu, 11 Feb 2021 16:42:46 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <addd9d50-4a2e-b3ae-ff32-5332ab664463@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0501CA0141.namprd05.prod.outlook.com
 (2603:10b6:803:2c::19) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.31.136] (165.204.77.1) by SN4PR0501CA0141.namprd05.prod.outlook.com (2603:10b6:803:2c::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.11 via Frontend Transport; Thu, 11 Feb 2021 22:42:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e3236774-c983-4562-907e-08d8cede5b5f
X-MS-TrafficTypeDiagnostic: SA0PR12MB4544:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB454480A8C30217CE14EDA08B958C9@SA0PR12MB4544.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:372;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X24m3ei34+SBo2UZVGDtcZh8gAcb9pf1rwc3uGXZn//RxlS1wRRYfukyxNiyLE+nUZVX2T89KzBrd2t1YfEWcVBHY6ccMFNukfJTOHdj2+AxJGU97H7nfnM+t4KhqimzgusNwxvopitQASEp+tKNk/al1t1x2adPUvcE27zV6s+/m/aeo7eloN/ZA7IvUYvDX53vlOR94YNzNwIexWhSN0KUIO2kknQeNR3S7ZWy8GQ/z1xkGITItGpLs4JSTKdtssERyCF57jozuaWEcRyH3ZXwhQpe3vGABe+5l/u7kBFJ7JA9NFaYAKJd/KuXDHVNkqJ9g7/A0E1KwRXGleDRJ2k6F8K3xnbBC6eLlzIQahcVPbFaV/XrwAxx085DFixB1O186mOyeSYi/D+QBum85WD0snI1WApVWuxQXbn5J1/9eEd4skhmuvYpSDv2vPz7WygZK2xlAuRd+SKARUdvD8HoBofWYQ23KLcy1grqhblFAQCxLJn/JoK4zBTJfoKeiBl+QNUsWKEBRLudKoaHePzwGgKJIhtZ/8gSh+nuOs7WPOZSsiLmtK69JCfSFxoH/1iEC1CUyvKVJ4adGy8p5U2pkfB9PJ9A8lAHT5HEfxk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(346002)(136003)(39860400002)(396003)(16526019)(2616005)(31686004)(956004)(186003)(19627235002)(4326008)(83380400001)(53546011)(44832011)(478600001)(7416002)(8676002)(8936002)(36756003)(31696002)(26005)(66946007)(66556008)(66476007)(6486002)(52116002)(5660300002)(316002)(86362001)(2906002)(16576012)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?OUgrVmZYZ2poZzlSS3F4VUVxTFgwcUF5cWJ3QUJ3MDgvVC9QL2FRRFNic09K?=
 =?utf-8?B?SW5NcDh3WnZQTkpJYzQra1pXaXkyY2JBZHRNcDVoTFYvaS9iVmtnSmQrYnpu?=
 =?utf-8?B?VndweVNIU2hiSnZkN25KNnBpVk1pcHcxUEM5a3VGVnFHQmVGL2RENlJVY21D?=
 =?utf-8?B?cXgvTW44bG9JQVBMRStpd0t0cGYyVm5mQzgxOEFyZzBXUnhsby8zOXBOWWwv?=
 =?utf-8?B?YXArNnBlV05MZTlHcEV2OW1MWXAzZExOVU92R0FOVnZWNmdJUHdPeVduUldX?=
 =?utf-8?B?aW41bXhqcFYyL0s1VEYzOXplaXZ1SUJrOTFrbCtRUkF2Uzhadk5MNkZ1d1Ax?=
 =?utf-8?B?TlJpWkNiZjIrZzl4cktwNDdTT1ZySVpxc1VzS2ptWjNrSE5xQ2huQkw5b25I?=
 =?utf-8?B?ZDB3NTNGR1JKaWpxTUZKTE1neVR4MmEvNVRFL2JyWWRQZkdNR2VUeXcvc1E3?=
 =?utf-8?B?MktOOW9nQzZka1JtRHlqYVE1VXlSMnFKbGxGenBWWHBGQlJza3h3Smt6SlNW?=
 =?utf-8?B?eGxaMzI5TDNCRUFKNG4xWDVFV3FSaUVOYllGb0s0cHBaQjlha3NOSWVCMnpX?=
 =?utf-8?B?NlArdWtGYWROR1hpZmdvRWZjVm1aQU9OT3ZVZVlKM2g1MjJpbnFrODBHbGtz?=
 =?utf-8?B?bXhCa1hKZ01rU21nUUU4NFN1VDI0dEF4cGowSmM1VEpMYW9kOXltMVlWR1pz?=
 =?utf-8?B?UWlLMnRVKzBLRndRSWdhL1RHL2lRc1R3TFZUL1hTTTkwVW0yd2pwK0pxcGNQ?=
 =?utf-8?B?ODZ5QXpJNnBhWlhBSW0waG16MGYxUzBCdjYxZFQzamhZaEczUU5Jbi9WcGE5?=
 =?utf-8?B?WW1YeWJ1Z05TdUc4U1h4bXBPQXIxM3hxMUpXR3Q1Q3RmcnFISTZ2eU1PWE5m?=
 =?utf-8?B?bkNHb0NlNTdxMkFpM0JzdmFnR1Q4OHFKQ0Rjb0tRUWJQaGFid1BCZXNqZFQv?=
 =?utf-8?B?cmkybVVuMEdhNWN5c0wzekUyc1BQWFpybFNKaStMeTVqZ0JyRTQrMkRVUFA0?=
 =?utf-8?B?aUdPYU9iY0lLQWhvUzdMYVkxQkVjQUZKVmdXRUVGdm01OVNTOHRwakRLd2lo?=
 =?utf-8?B?dUdhdUN2SUJvSERXaGNrbGg4K2I1OGphWXpROTcxTjRidG1zeDBIVW0xdjJj?=
 =?utf-8?B?V1AxOUlGeXJDd1RZZGNJNzdHUkN5SGR3YUFjc3QxaFFFczZTUWEwc1dUbDBp?=
 =?utf-8?B?WGRmUGt3V2Y3TkJ2WDV3cnRRTEdaQ3VSMnpTRXpDaEhsK0poRTVZUDNrN0FO?=
 =?utf-8?B?YkR1a2hlbUVBT3hxdkhUeXdZc2wrcWlmTTQ0WEVvNGorVTlIVkVQYXhTZ3Av?=
 =?utf-8?B?WHdDYmNBQU9qM1cxdEFNbjhrZWxwS0pQQi83cGFwRjg2N0xVWCtZeUFZSjJ4?=
 =?utf-8?B?OGZwUUhWaDBKbENqUkV1ekM5d2kralBQa3ZGNzVlQjNtU1ZSMUVzb3hscE5P?=
 =?utf-8?B?U3Iybm9iQytod1FQOG43M2d3STdnWERWWHo4THlZL25BZFBZTzl4Y3NEcmpt?=
 =?utf-8?B?bUZVc1hOZ0JzWkhXWVlmb2gzRUNQZU90cFdaaUlISjR4eUxQMHVzRk5aYjhN?=
 =?utf-8?B?ZzVyNjhCUmhHZGtuZmVGeS9RVlExYlFGcUVreS9EQzFVeDlnQ1BINmVKSFJl?=
 =?utf-8?B?dUttaXd1THdmZCt3a0hDaG5OdU9SZThSblNBajNVUWlYYy9NQmlPTHluSG9s?=
 =?utf-8?B?dHFady9WcHJLRTdiMEU3Zi9zdTdEZWR6aGJ3cVJiZWMvaitRVzBTNjNWb08z?=
 =?utf-8?Q?mBOG7ERYCxzekyX01/M0scqhBp7SR7h7xon3qzy?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3236774-c983-4562-907e-08d8cede5b5f
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2021 22:42:48.7284
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3X57MTciTC6rFZ1n8yq77aFyqAwuXA56C+ApQJnr17S3dw4hSMFH0uEW9Jn7v8k9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4544
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/11/21 2:56 AM, Paolo Bonzini wrote:
> On 29/01/21 01:43, Babu Moger wrote:
>> This support also fixes an issue where a guest may sometimes see an
>> inconsistent value for the SPEC_CTRL MSR on processors that support this
>> feature. With the current SPEC_CTRL support, the first write to
>> SPEC_CTRL is intercepted and the virtualized version of the SPEC_CTRL
>> MSR is not updated.
> 
> This is a bit ugly, new features should always be enabled manually (AMD
> did it right for vVMLOAD/vVMSAVE for example, even though _in theory_
> assuming that all hypervisors were intercepting VMLOAD/VMSAVE would have
> been fine).
> 
> Also regarding nested virtualization:
> 
>> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
>> index 7a605ad8254d..9e51f9e4f631 100644
>> --- a/arch/x86/kvm/svm/nested.c
>> +++ b/arch/x86/kvm/svm/nested.c
>> @@ -534,6 +534,7 @@ int nested_svm_vmrun(struct vcpu_svm *svm)
>>          hsave->save.cr3    = vmcb->save.cr3;
>>      else
>>          hsave->save.cr3    = kvm_read_cr3(&svm->vcpu);
>> +    hsave->save.spec_ctrl = vmcb->save.spec_ctrl;
>>  
>>      copy_vmcb_control_area(&hsave->control, &vmcb->control);
>>  
>> @@ -675,6 +676,7 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
>>      kvm_rip_write(&svm->vcpu, hsave->save.rip);
>>      svm->vmcb->save.dr7 = DR7_FIXED_1;
>>      svm->vmcb->save.cpl = 0;
>> +    svm->vmcb->save.spec_ctrl = hsave->save.spec_ctrl;
>>      svm->vmcb->control.exit_int_info = 0;
>>  
>>      vmcb_mark_all_dirty(svm->vmcb);
> 
> I think this is incorrect.  Since we don't support this feature in the
> nested hypervisor, any writes to the SPEC_CTRL MSR while L2 (nested guest)
> runs have to be reflected to L1 (nested hypervisor).  In other words, this
> new field is more like VMLOAD/VMSAVE state, in that it doesn't change
> across VMRUN and VMEXIT.  These two hunks can be removed.

Makes sense. I have tested removing these two hunks and it worked fine.

> 
> If we want to do it, exposing this feature to the nested hypervisor will
> be a bit complicated, because one has to write host SPEC_CTRL |
> vmcb01.GuestSpecCtrl in the host MSR, in order to free the vmcb02
> GuestSpecCtrl for the vmcb12 GuestSpecCtrl.
> 
> It would also be possible to emulate it on processors that don't have it. 
> However I'm not sure it's a good idea because of the problem that you
> mentioned with running old kernels on new processors.
> 
> I have queued the patches with the small fix above.  However I plan to
> only include them in 5.13 because I have a bunch of other SVM patches,

Yes. 5.13 is fine.
thanks
Babu

> those have been tested already but I need to send them out for review
> before "officially" getting them in kvm.git.
> 
> Paolo
> 
