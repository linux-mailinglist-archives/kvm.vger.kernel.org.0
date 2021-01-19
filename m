Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F0592FC37C
	for <lists+kvm@lfdr.de>; Tue, 19 Jan 2021 23:31:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729320AbhASWak (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jan 2021 17:30:40 -0500
Received: from mail-co1nam11on2050.outbound.protection.outlook.com ([40.107.220.50]:52385
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728977AbhASWab (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jan 2021 17:30:31 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a5g8hga+OfJiAmrDYGjx3A9SSmFFo+dT0B8LRDLRLO4y5I5e9KrKHzTxYBzbsTcUtVCDB0vWUcXk8T/qo4plDyxwjyRUudyX9WJwL88snAHnhqCryu+mmFp2jZW46RdMwImwGfa5B0ZeD8ncTFPr/5gs9Jo7+lQWeaE8VLrOpXi6Fd0mtTCBf5SxbRF5MAfYobvrMkVU7eyxoMY+IuUHHQuVwC16hc6Hc/gZIke9j5ZnGi+oUwegOIfmNanhhue2hSAAhh4d0OgcCYPrCJDsTBsNeW0aMtBlBMMRRWEYbxEYrbtsEFk1eiGo/60PbFzkUxajmB/gcIUer8BMwKsV7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kRfDC/GuRGi+rkZ4h294Bt+yxRogy/8aCWje634oqNE=;
 b=gxLDPnzUiagATxi9QKnLsRaYnhPQU9DPmgqo/mPKyq4O66AkJuQg4ldBmkQUDa83uxvpY4aDHjFwBY70pva5iHktpI7aUsfT75+Xdgj8CVQKPP28GGo+DXoKTFqKQHhhxMqDfG1AZe36A0I7Cy055/z1et5FUNufLWWEDUfNvbf9vLsXuSxhBLirFfWmfZxVvgfK1kfvS6VYQ50jLrof66q+zamDWNYVRHG7s7V06qmDcT0yQFXNBbUvj19a3iEYisyiYoMJkiolsVuhY0ZDbwAXQx1KsWMgqrJU5Jzw7fP7X7i0KLPEoJInhPn5q+WgfPcFHfX3B+VbuREyLSpHgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kRfDC/GuRGi+rkZ4h294Bt+yxRogy/8aCWje634oqNE=;
 b=uQsYFOV43SoR8Rmyex9tdt2zcMbxKvVB2JXipJG7oT8WFfZqbZjwDqxdRktdGn6gfauY34qDtcovY/56OnDQiCTv57kErYhrL9hGwEUs4LVpyCg70lM4J9ysAH0juXeSZ603Fhz+p2npwP3WoiYuuCm73JNpvk/Eq3ZDzLYZivE=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN1PR12MB2591.namprd12.prod.outlook.com (2603:10b6:802:30::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.12; Tue, 19 Jan
 2021 22:29:36 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::8c0e:9a64:673b:4fff]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::8c0e:9a64:673b:4fff%5]) with mapi id 15.20.3763.014; Tue, 19 Jan 2021
 22:29:36 +0000
From:   Babu Moger <babu.moger@amd.com>
Subject: Re: [PATCH v3 2/2] KVM: SVM: Add support for Virtual SPEC_CTRL
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, fenghua.yu@intel.com, tony.luck@intel.com,
        wanpengli@tencent.com, kvm@vger.kernel.org,
        thomas.lendacky@amd.com, peterz@infradead.org, joro@8bytes.org,
        x86@kernel.org, kyung.min.park@intel.com,
        linux-kernel@vger.kernel.org, krish.sadhukhan@oracle.com,
        hpa@zytor.com, mgross@linux.intel.com, vkuznets@redhat.com,
        kim.phillips@amd.com, wei.huang2@amd.com, jmattson@google.com
References: <161073115461.13848.18035972823733547803.stgit@bmoger-ubuntu>
 <161073130040.13848.4508590528993822806.stgit@bmoger-ubuntu>
 <YAclaWCL20at/0n+@google.com>
Message-ID: <c3a81da0-4b6a-1854-1b67-31df5fbf30f6@amd.com>
Date:   Tue, 19 Jan 2021 16:29:32 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <YAclaWCL20at/0n+@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: CH2PR08CA0021.namprd08.prod.outlook.com
 (2603:10b6:610:5a::31) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.31.136] (165.204.77.1) by CH2PR08CA0021.namprd08.prod.outlook.com (2603:10b6:610:5a::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.11 via Frontend Transport; Tue, 19 Jan 2021 22:29:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a7f4e893-c881-4dd6-e0a4-08d8bcc9b378
X-MS-TrafficTypeDiagnostic: SN1PR12MB2591:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB2591802D305E146BD57E871E95A30@SN1PR12MB2591.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PLBwC7fwv12JIJJb4EZXKeFhkS21tq2lXeKKQL/4u6xePOLzDQoIGksKqcgbpI/LxnH94o+DB+KsoPUonT6+URzCiAmCW54v+cVYtHygC2VahMw+xki0Ovm1swG59Vp0cGu7HX+cY0GS/PwIFdsiL+6GQjfaD3bSw29brEf6onu0ALjNviMTkPAfOjNfy+pFuu7QopvTxXcE/OXtczss5CWIjGpXX0QlW/rIIWzQUnLuDaKXRY6JIrpsaOiU/sd4+nfMlwSyvo/1RxFS7ijAu8XpEauKehaqUM+LINQF3d0AteJ+zGgq611erV+H2OOP38nejWR02zJ0YwdD9emwcsvlH2ZSzgKBP+uOlu4W71jUFQ87fGAkB0gOKklHY6bFiaiEKhSTi6hGkXDrRINXHKhQqZKV8jeK77+HtRpMOrU9W/CvW7I1Yvuy5B2rZhZjEoALAYWH2O8VB/aOdR+C7nfrXFWdDapDLWCoFxu6joc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39850400004)(376002)(396003)(136003)(346002)(7416002)(16526019)(53546011)(31686004)(36756003)(66476007)(6916009)(66556008)(66946007)(2906002)(2616005)(956004)(6486002)(186003)(26005)(52116002)(83380400001)(8676002)(44832011)(86362001)(478600001)(31696002)(4326008)(8936002)(316002)(16576012)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?RUU1azRhK3I4SHZLV2IxTm1wZlp1b24vdlJFMzF6M0g3TXNJcTFhR3hscklJ?=
 =?utf-8?B?dHMrQ3pvdzBDZVhtOW1lOXJZb01Rc2dMS3hVMWNpNmlnNDlyc01GTGhNVElX?=
 =?utf-8?B?RlVLbDdHUmJNb09Na05wYmJhSkhQYjRxNzlCdmlFR0RaSDNzd0o0SW5ZWjAx?=
 =?utf-8?B?Y3VrWXk1VDNNMFBDbUs3bEF6clVkVWErb0RUWDBSWEYyZXZ1YlVUT2ZsQWFU?=
 =?utf-8?B?RGM2WFpBV2JaY0xWM0FaNWhEckFDcGgvYVk2LzFObEpCSkZmdmVFWlVHbDkw?=
 =?utf-8?B?NUpGK29ncWNiM0VYc0FCTThOMWRBMWtxbkd3TnNtbWREQ3ZteTJYWHk5NHVU?=
 =?utf-8?B?NDlWZTRkWkFuaGZNOVdlVUdjekZROGNTQUc4eGFrZ2R5cmFiRU04NC94ZmRX?=
 =?utf-8?B?emk5SWJFUFI1TGRIQlJiTFB4R1YzZncrQUc1T1A2Yk14am1MWkNiRHJoUFgr?=
 =?utf-8?B?eWliOUtOTUlNK3JQN0tmZG9VUm1VQ2EyVllJOGVlWmhPcGdYRGRQL3ZKWVUw?=
 =?utf-8?B?WDJJci9ialI4T3NJSDNRbFEraEZZajFTSC81dlR3cmZjM0hRU1lBeUJoczZ2?=
 =?utf-8?B?MmpsTWZJb1ZFekNqdU9hTXA2SGwvejIwbWJPVVFiRUYxNmwzV3pnM2k0Z3RR?=
 =?utf-8?B?Y015bit3RkdkMUhBVUx5S2xUWlJjUmEyaW9lUFdBbXEvR0JJbzhxbGlmRVU3?=
 =?utf-8?B?U0JCbkJIcWxWaDFlbkZNMElQQ2NPTDNNK0RwUkxnRVJQcy9TNWhhNldXdjMw?=
 =?utf-8?B?WHVhZzM5bXo4cmJCYkVKTzBXQ3VSczVuczY5bTdycXk3WHJubVBGL0Y1R2hL?=
 =?utf-8?B?MDBLeHZrNHN5REdhYjZlUGZSWW5td3R6eWJQRUVXSGFOSzVDZXZPbVFQeVJR?=
 =?utf-8?B?RElMeGt0TUc5WE1tQWdNMGxaU1ZhampGSkpIcDA2dmF5OTVRL0gzMWxWM0do?=
 =?utf-8?B?RzUzaG5QTXk3TmdLaFBBVHVubXVIZXEzcllQKzJEZEQ4VVFaSXQrT3Z6RW10?=
 =?utf-8?B?R0VuYTZPajNXN3dRd0lwWjFIc1JLbDNodWpySW1NUXBsV1htTTQ5ZE9yWm5H?=
 =?utf-8?B?MVVoN3VVOU5nWjE3RmlWcjNUeUloZWpHdm03NVBQaGdhekdmTHVsY2tYb21v?=
 =?utf-8?B?LzRLaVd2eVVBMmw5SWxvNEpLaUxIeW12bTVxcFEwMDRQaU9oR0llSE11OElu?=
 =?utf-8?B?RzNvTXRxcTN6WTFrOHFBQmhERkxpbzJrSG0yOU5ENURSQWY1SEc3Tm1acExj?=
 =?utf-8?B?ZHpQRVViSWw5d3VVTG9wbFZPU2xOWVREMnpzRkgxaXQ1YW9JOFlON3FxcU51?=
 =?utf-8?Q?JlOZPHMdq2Bag=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7f4e893-c881-4dd6-e0a4-08d8bcc9b378
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2021 22:29:36.1475
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2VIuCGNjygYuqPikX/zmfnMnyNCWtd2WhTpa/2ueSn9vyQHLJEtKEEobAOqsU3YS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2591
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/19/21 12:31 PM, Sean Christopherson wrote:
> On Fri, Jan 15, 2021, Babu Moger wrote:
>> ---
>>  arch/x86/include/asm/svm.h |    4 +++-
>>  arch/x86/kvm/svm/sev.c     |    4 ++++
>>  arch/x86/kvm/svm/svm.c     |   19 +++++++++++++++----
>>  3 files changed, 22 insertions(+), 5 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
>> index 1c561945b426..772e60efe243 100644
>> --- a/arch/x86/include/asm/svm.h
>> +++ b/arch/x86/include/asm/svm.h
>> @@ -269,7 +269,9 @@ struct vmcb_save_area {
>>  	 * SEV-ES guests when referenced through the GHCB or for
>>  	 * saving to the host save area.
>>  	 */
>> -	u8 reserved_7[80];
>> +	u8 reserved_7[72];
>> +	u32 spec_ctrl;		/* Guest version of SPEC_CTRL at 0x2E0 */
>> +	u8 reserved_7b[4];
> 
> Don't nested_prepare_vmcb_save() and nested_vmcb_checks() need to be updated to
> handle the new field, too?

Ok. Sure. I will check and test few combinations to make sure of these
changes.

> 
>>  	u32 pkru;
>>  	u8 reserved_7a[20];
>>  	u64 reserved_8;		/* rax already available at 0x01f8 */
>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>> index c8ffdbc81709..959d6e47bd84 100644
>> --- a/arch/x86/kvm/svm/sev.c
>> +++ b/arch/x86/kvm/svm/sev.c
>> @@ -546,6 +546,10 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
>>  	save->pkru = svm->vcpu.arch.pkru;
>>  	save->xss  = svm->vcpu.arch.ia32_xss;
>>  
>> +	/* Update the guest SPEC_CTRL value in the save area */
>> +	if (boot_cpu_has(X86_FEATURE_V_SPEC_CTRL))
>> +		save->spec_ctrl = svm->spec_ctrl;
> 
> I think this can be dropped if svm->spec_ctrl is unused when V_SPEC_CTRL is
> supported (see below).  IIUC, the memcpy() that's just out of sight would do
> the propgation to the VMSA.

Yes, That is right. I will remove this.

> 
>> +
>>  	/*
>>  	 * SEV-ES will use a VMSA that is pointed to by the VMCB, not
>>  	 * the traditional VMSA that is part of the VMCB. Copy the
>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>> index 7ef171790d02..a0cb01a5c8c5 100644
>> --- a/arch/x86/kvm/svm/svm.c
>> +++ b/arch/x86/kvm/svm/svm.c
>> @@ -1244,6 +1244,9 @@ static void init_vmcb(struct vcpu_svm *svm)
>>  
>>  	svm_check_invpcid(svm);
>>  
>> +	if (boot_cpu_has(X86_FEATURE_V_SPEC_CTRL))
>> +		save->spec_ctrl = svm->spec_ctrl;
>> +
>>  	if (kvm_vcpu_apicv_active(&svm->vcpu))
>>  		avic_init_vmcb(svm);
>>  
>> @@ -3789,7 +3792,10 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
>>  	 * is no need to worry about the conditional branch over the wrmsr
>>  	 * being speculatively taken.
>>  	 */
>> -	x86_spec_ctrl_set_guest(svm->spec_ctrl, svm->virt_spec_ctrl);
>> +	if (static_cpu_has(X86_FEATURE_V_SPEC_CTRL))
>> +		svm->vmcb->save.spec_ctrl = svm->spec_ctrl;
>> +	else
>> +		x86_spec_ctrl_set_guest(svm->spec_ctrl, svm->virt_spec_ctrl);
> 
> Can't we avoid functional code in svm_vcpu_run() entirely when V_SPEC_CTRL is
> supported?  Make this code a nop, disable interception from time zero, and

Sean, I thought you mentioned earlier about not changing the interception
mechanism. Do you think we should disable the interception right away if
V_SPEC_CTRL is supported?

> read/write the VMBC field in svm_{get,set}_msr().  I.e. don't touch
> svm->spec_ctrl if V_SPEC_CTRL is supported.  
> 
> 	if (!static_cpu_has(X86_FEATURE_V_SPEC_CTRL))
> 		x86_spec_ctrl_set_guest(svm->spec_ctrl, svm->virt_spec_ctrl);
> 
> 	svm_vcpu_enter_exit(vcpu, svm);
> 
> 	if (!static_cpu_has(X86_FEATURE_V_SPEC_CTRL) &&
> 	    unlikely(!msr_write_intercepted(vcpu, MSR_IA32_SPEC_CTRL)))
> 		svm->spec_ctrl = native_read_msr(MSR_IA32_SPEC_CTRL);

Ok. It appears the above code might work fine with changes in
svm_{get,set}_msr() to update save spec_ctlr. I will retest few
combinations to make sure it works.
Thanks
Babu

> 
>>  	svm_vcpu_enter_exit(vcpu, svm);
>>  
>> @@ -3808,13 +3814,18 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
>>  	 * If the L02 MSR bitmap does not intercept the MSR, then we need to
>>  	 * save it.
>>  	 */
>> -	if (unlikely(!msr_write_intercepted(vcpu, MSR_IA32_SPEC_CTRL)))
>> -		svm->spec_ctrl = native_read_msr(MSR_IA32_SPEC_CTRL);
>> +	if (unlikely(!msr_write_intercepted(vcpu, MSR_IA32_SPEC_CTRL))) {
>> +		if (static_cpu_has(X86_FEATURE_V_SPEC_CTRL))
>> +			svm->spec_ctrl = svm->vmcb->save.spec_ctrl;
>> +		else
>> +			svm->spec_ctrl = native_read_msr(MSR_IA32_SPEC_CTRL);
>> +	}
>>  
>>  	if (!sev_es_guest(svm->vcpu.kvm))
>>  		reload_tss(vcpu);
>>  
>> -	x86_spec_ctrl_restore_host(svm->spec_ctrl, svm->virt_spec_ctrl);
>> +	if (!static_cpu_has(X86_FEATURE_V_SPEC_CTRL))
>> +		x86_spec_ctrl_restore_host(svm->spec_ctrl, svm->virt_spec_ctrl);
>>  
>>  	if (!sev_es_guest(svm->vcpu.kvm)) {
>>  		vcpu->arch.cr2 = svm->vmcb->save.cr2;
>>
