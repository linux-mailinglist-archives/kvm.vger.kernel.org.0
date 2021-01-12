Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20A562F3DE0
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 01:44:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731466AbhALVvw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 16:51:52 -0500
Received: from mail-dm6nam12on2077.outbound.protection.outlook.com ([40.107.243.77]:39072
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732935AbhALVvt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jan 2021 16:51:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IUZlN5fmYj6vBU60LOt3YKm9Himm4np9egBTjsFii7kf+mMVFhwrH2wMK/ork3XgEFgoEE/iVVJ/rvDeX6sU5BKmj4R2yzKuysq2AL7FHmL7IMe9pR1ft9waNik9s1P4OgO1z3xBGUFxNVRtpgK/ZG+dWj2n7vAdMTz3dMkbjv/F+vy9Db5ja1+aZvutR6Ytc4L5u6NvhB5fPbgdaJQnRKdY3us99dbUXMEiT8MmmXwtOZpB1U3smgaj1DOlZ7HMvqoWYSiObfULIepOc2BexgVXrAiz4RMofQaOTSUISYV7an2QaCuqn5/Oyha8QLWGx187RbjJfYhwJjbKSGJ2PA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vJ+E1tS0j8INXQ91Eb16GrpqS1+LYWHN3fcxVkHNYcE=;
 b=ArmNhDB+GxYrfwej4j/IWHxbaZo9wpC1BL32KVIGlW/qPPQcYmKLCQynjkXwFK/MgcGkWVnA5VJfzcFYxqXlLufL073rovh397mhOyYxJNtFbvwjYPwxz8aqHodVOct17nJ983v89FBH8ufLbOkXsNv+7gD9DrSHI+veCrYGN0GENWqtbVT8S7n6iEdjKAdFeqqTiEcQMyXk8DMN30UVOc9UZKm2cJSelmORZlouTbaz/ycM9swDrwMBhQwFVDvQQtUjU5gbcol4GKGijYHvX4gR7T/pOMjWQyhk0nCkgYUSGRpBeWakoL/szVH9amYXiA0WrsEyl7zk9huBkaIOgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vJ+E1tS0j8INXQ91Eb16GrpqS1+LYWHN3fcxVkHNYcE=;
 b=yAKSxPx6XHEwuUV6anRMJk0FR1OpL2bw6EP4AiYAOhTOZLkrkHkA95eP4GBhtS1xBFOCQw1p+k1Zg079OZVNShY+YqYx5zCSAF/lecBtp/LDP+/PYGHxb3sXIMDLbCt9OlFfIY8jIAlm1sX65NjcmA0ls3dzGp2vAfMSTuc0Lv0=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from MWHPR12MB1502.namprd12.prod.outlook.com (2603:10b6:301:10::20)
 by MWHPR12MB1632.namprd12.prod.outlook.com (2603:10b6:301:10::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Tue, 12 Jan
 2021 21:50:52 +0000
Received: from MWHPR12MB1502.namprd12.prod.outlook.com
 ([fe80::4d9d:16b8:3399:ce90]) by MWHPR12MB1502.namprd12.prod.outlook.com
 ([fe80::4d9d:16b8:3399:ce90%5]) with mapi id 15.20.3742.012; Tue, 12 Jan 2021
 21:50:52 +0000
Subject: Re: [PATCH 1/2] KVM: x86: Add emulation support for #GP triggered by
 VM instructions
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        seanjc@google.com, joro@8bytes.org, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        jmattson@google.com, wanpengli@tencent.com, bsd@redhat.com,
        dgilbert@redhat.com, mlevitsk@redhat.com
References: <20210112063703.539893-1-wei.huang2@amd.com>
 <87eeiq8i7k.fsf@vitty.brq.redhat.com>
From:   Wei Huang <wei.huang2@amd.com>
Message-ID: <984b1877-66c7-c735-61ee-1ed8a0964730@amd.com>
Date:   Tue, 12 Jan 2021 15:50:48 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
In-Reply-To: <87eeiq8i7k.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [70.113.46.183]
X-ClientProxiedBy: SA9PR13CA0089.namprd13.prod.outlook.com
 (2603:10b6:806:23::34) To MWHPR12MB1502.namprd12.prod.outlook.com
 (2603:10b6:301:10::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.38] (70.113.46.183) by SA9PR13CA0089.namprd13.prod.outlook.com (2603:10b6:806:23::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.2 via Frontend Transport; Tue, 12 Jan 2021 21:50:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ae199c5a-52bd-42c8-ceec-08d8b74421c6
X-MS-TrafficTypeDiagnostic: MWHPR12MB1632:
X-Microsoft-Antispam-PRVS: <MWHPR12MB16321467F276A3DD4AF1F0F3CFAA0@MWHPR12MB1632.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1247;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bBtIwEhjbMiUv8iizItiTyh3hNGICe78N7lbKOk42BUXF1Oo8wGU8jNWUWwbgEh9G9v0jmi0QoO1yP49uFyExHweb+7zyrD70s6tR4t9Bq7IOmlTL2TT49drO9N3X75rX3M1V9j1hld4l77zC+t8kT9AhettJHjuB76MShwZ3TbWKb+Gt/In/cwym6fVZvciVn9NyHQcrSu/ucTEeyvDm1iK8Btyfl6aXaalu7gDaQp2r1dc1WqMUAhXuS3GEuExVxetKs3JHDkRImEIItG458qzDxUEar9Ze0xuwRDGsuhW5gO8wBjQjhZe2A/OUFWcn4kFlubpsYkXd5a8UTLUhOw8sOud0f5h1oWBU+JS2EoC+b/ynwnG96NtiNokDUzC8p2dR2h05t67OBY+4MxpMQBgKZMv5B8gjsyOOakhvRn4M6ZelkAo3tJWmCaYItEevdLdypej2xq0rDUFVlGnuAymJSTf4SczIXbvBvS9BTo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR12MB1502.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(376002)(366004)(136003)(346002)(396003)(2616005)(956004)(316002)(26005)(16576012)(186003)(66946007)(52116002)(2906002)(7416002)(478600001)(4326008)(30864003)(66556008)(66476007)(8676002)(31696002)(5660300002)(31686004)(86362001)(8936002)(83380400001)(6486002)(36756003)(16526019)(53546011)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?bU1aSmhUNENZSHdQUTNLT2xtNXhnMnhrUWN5cWtnZnpwaExwd2NzVnROUmdq?=
 =?utf-8?B?RWJJaG90YkdSQ2t4alBZQmhUYTV6TWN5bG0vck1CUW55ek52QjB0WGltekZD?=
 =?utf-8?B?a2tLUjNtTWtod0crdnNjeTZIaXBkdUI3TFhZU21rcGxKSE84RS9Vc3ZiVnNV?=
 =?utf-8?B?SStUYmxGY2t0R0xmVld6QkdPVXJHdExYTVVydGdnV2VWQWY2R2FocWtValBl?=
 =?utf-8?B?UzhyUnhUUU9FMGwxVlpOMEoycFZycnVpVG1DTDV5MnFnT0ZpclMvVHVRZG02?=
 =?utf-8?B?VDdNK2dNM2FicEtJZkJlTjNmVUZ0V1ozaVJMcmtEeG0wOWYvQ0loYitsdHlw?=
 =?utf-8?B?VEcrbDZhT0Z0UHJjd2VTTFJIYUIvNTh4c2ZRNkFJV1lZMFNja0dYeHExRTJn?=
 =?utf-8?B?bjJjTSthbWVMajhuM3ErSGpuems0bjB4VnFGMUdEd1hoUDgrbVdRTHlxWXJa?=
 =?utf-8?B?M29YMldZaHpXcTBCOWZPSWtSUmJCbTZ6bDB2emZWdG1JVldTWVArRDNldE1a?=
 =?utf-8?B?Uk9uYTdsN0pGamtzWlpRdVMrTmIveTJiWEVmMHRsQS81MW9Ub2VpZ2haWU5Z?=
 =?utf-8?B?K1BQcURmQU9Ra1I0dm9kOWNmWGYwNmNOVzk2c1dkV3o4SzZ4ejY2SU9PVjB1?=
 =?utf-8?B?TlNnSThFVVhTOCtTNUZIbHRMdnhxc0F5TU0zY21HLytCbngzL2dTT1Q2RUtX?=
 =?utf-8?B?TU84TFIraFIxNlMyRC9sYUxUaXREbkNqOVlxUmFYVVArcmlabVptZXJtazNU?=
 =?utf-8?B?YWcwVHZXM3k2Mk5yODV3Mjdla0dYMXNOa0pNMiszQUtNeHlaS1h1czJqdVor?=
 =?utf-8?B?eTVwMEl2L3hsYlJSbFc3WTZmQkFSNVhzaFBOWkpRbW9mU0dTYU5lWmgvZU1D?=
 =?utf-8?B?aGpVQTJySEtqZDVhb0FhbnhDdnVibUN1YW1JYlFCbkJsNDVsdU1KQXFDMTNI?=
 =?utf-8?B?S2xpR2c5bjNWMzE0UEFCeDFDMG5wRitCcHc1amhQQ0hMQ3NVL284SVBnSTdB?=
 =?utf-8?B?QjM1dFpGR2pMKy95UGRTYlc2aU1EeXpDVE5rYy8vaHY5WjRvdkdZUXZiaXh4?=
 =?utf-8?B?c1FHcG5PQnU2TlFXUTlFQmxNbXFEVzFLSWV4Z3VEdm0rZlRRSmdPUUpmcTNm?=
 =?utf-8?B?SC9XS2U4Ym50REZ0Y1JCbHlUQU4rRm90N3RBWWl4Sm1MRHNRQUE0d05aL2xK?=
 =?utf-8?B?TTBKYWJTek1seEhMYjg3Q2ZzdnFNVEVQTFdJMGlqTDRSQXBjRFBFZU5URDhw?=
 =?utf-8?B?MmNPTzllcVZOK0JnbUlrcVM5WGtuOWFpemhXbDMxaExZZGMyKzRmN1NBTk9l?=
 =?utf-8?Q?YUIHq3x3pC3/W5qiU5q/HJl8YZL3NslZuQ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: MWHPR12MB1502.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2021 21:50:52.3822
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: ae199c5a-52bd-42c8-ceec-08d8b74421c6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8paBZojHhCSvLZ+orTQPghrVc5EO0SSlP6vNe6sAsspnSMq+jBqiaxdp/dP5PqAr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1632
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/12/21 6:15 AM, Vitaly Kuznetsov wrote:
> Wei Huang <wei.huang2@amd.com> writes:
> 
>> From: Bandan Das <bsd@redhat.com>
>>
>> While running VM related instructions (VMRUN/VMSAVE/VMLOAD), some AMD
>> CPUs check EAX against reserved memory regions (e.g. SMM memory on host)
>> before checking VMCB's instruction intercept. If EAX falls into such
>> memory areas, #GP is triggered before VMEXIT. This causes problem under
>> nested virtualization. To solve this problem, KVM needs to trap #GP and
>> check the instructions triggering #GP. For VM execution instructions,
>> KVM emulates these instructions; otherwise it re-injects #GP back to
>> guest VMs.
>>
>> Signed-off-by: Bandan Das <bsd@redhat.com>
>> Co-developed-by: Wei Huang <wei.huang2@amd.com>
>> Signed-off-by: Wei Huang <wei.huang2@amd.com>
>> ---
>>   arch/x86/include/asm/kvm_host.h |   8 +-
>>   arch/x86/kvm/mmu.h              |   1 +
>>   arch/x86/kvm/mmu/mmu.c          |   7 ++
>>   arch/x86/kvm/svm/svm.c          | 157 +++++++++++++++++++-------------
>>   arch/x86/kvm/svm/svm.h          |   8 ++
>>   arch/x86/kvm/vmx/vmx.c          |   2 +-
>>   arch/x86/kvm/x86.c              |  37 +++++++-
>>   7 files changed, 146 insertions(+), 74 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index 3d6616f6f6ef..0ddc309f5a14 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -1450,10 +1450,12 @@ extern u64 kvm_mce_cap_supported;
>>    *			     due to an intercepted #UD (see EMULTYPE_TRAP_UD).
>>    *			     Used to test the full emulator from userspace.
>>    *
>> - * EMULTYPE_VMWARE_GP - Set when emulating an intercepted #GP for VMware
>> + * EMULTYPE_PARAVIRT_GP - Set when emulating an intercepted #GP for VMware
>>    *			backdoor emulation, which is opt in via module param.
>>    *			VMware backoor emulation handles select instructions
>> - *			and reinjects the #GP for all other cases.
>> + *			and reinjects #GP for all other cases. This also
>> + *			handles other cases where #GP condition needs to be
>> + *			handled and emulated appropriately
>>    *
>>    * EMULTYPE_PF - Set when emulating MMIO by way of an intercepted #PF, in which
>>    *		 case the CR2/GPA value pass on the stack is valid.
>> @@ -1463,7 +1465,7 @@ extern u64 kvm_mce_cap_supported;
>>   #define EMULTYPE_SKIP		    (1 << 2)
>>   #define EMULTYPE_ALLOW_RETRY_PF	    (1 << 3)
>>   #define EMULTYPE_TRAP_UD_FORCED	    (1 << 4)
>> -#define EMULTYPE_VMWARE_GP	    (1 << 5)
>> +#define EMULTYPE_PARAVIRT_GP	    (1 << 5)
>>   #define EMULTYPE_PF		    (1 << 6)
>>   
>>   int kvm_emulate_instruction(struct kvm_vcpu *vcpu, int emulation_type);
>> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
>> index 581925e476d6..1a2fff4e7140 100644
>> --- a/arch/x86/kvm/mmu.h
>> +++ b/arch/x86/kvm/mmu.h
>> @@ -219,5 +219,6 @@ int kvm_arch_write_log_dirty(struct kvm_vcpu *vcpu);
>>   
>>   int kvm_mmu_post_init_vm(struct kvm *kvm);
>>   void kvm_mmu_pre_destroy_vm(struct kvm *kvm);
>> +bool kvm_is_host_reserved_region(u64 gpa);
> 
> Just a suggestion: "kvm_gpa_in_host_reserved()" maybe?

Will do in v2.

> 
>>   
>>   #endif
>> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
>> index 6d16481aa29d..c5c4aaf01a1a 100644
>> --- a/arch/x86/kvm/mmu/mmu.c
>> +++ b/arch/x86/kvm/mmu/mmu.c
>> @@ -50,6 +50,7 @@
>>   #include <asm/io.h>
>>   #include <asm/vmx.h>
>>   #include <asm/kvm_page_track.h>
>> +#include <asm/e820/api.h>
>>   #include "trace.h"
>>   
>>   extern bool itlb_multihit_kvm_mitigation;
>> @@ -5675,6 +5676,12 @@ void kvm_mmu_slot_set_dirty(struct kvm *kvm,
>>   }
>>   EXPORT_SYMBOL_GPL(kvm_mmu_slot_set_dirty);
>>   
>> +bool kvm_is_host_reserved_region(u64 gpa)
>> +{
>> +	return e820__mbapped_raw_any(gpa-1, gpa+1, E820_TYPE_RESERVED);
>> +}
> 
> While _e820__mapped_any()'s doc says '..  checks if any part of the
> range <start,end> is mapped ..' it seems to me that the real check is
> [start, end) so we should use 'gpa' instead of 'gpa-1', no?

I think you are right. The statement of "entry->addr >= end || 
entry->addr + entry->size <= start" shows the checking is against the 
area of [start, end).

> 
>> +EXPORT_SYMBOL_GPL(kvm_is_host_reserved_region);
>> +
>>   void kvm_mmu_zap_all(struct kvm *kvm)
>>   {
>>   	struct kvm_mmu_page *sp, *node;
>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>> index 7ef171790d02..74620d32aa82 100644
>> --- a/arch/x86/kvm/svm/svm.c
>> +++ b/arch/x86/kvm/svm/svm.c
>> @@ -288,6 +288,7 @@ int svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
>>   		if (!(efer & EFER_SVME)) {
>>   			svm_leave_nested(svm);
>>   			svm_set_gif(svm, true);
>> +			clr_exception_intercept(svm, GP_VECTOR);
>>   
>>   			/*
>>   			 * Free the nested guest state, unless we are in SMM.
>> @@ -309,6 +310,10 @@ int svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
>>   
>>   	svm->vmcb->save.efer = efer | EFER_SVME;
>>   	vmcb_mark_dirty(svm->vmcb, VMCB_CR);
>> +	/* Enable GP interception for SVM instructions if needed */
>> +	if (efer & EFER_SVME)
>> +		set_exception_intercept(svm, GP_VECTOR);
>> +
>>   	return 0;
>>   }
>>   
>> @@ -1957,22 +1962,104 @@ static int ac_interception(struct vcpu_svm *svm)
>>   	return 1;
>>   }
>>   
>> +static int vmload_interception(struct vcpu_svm *svm)
>> +{
>> +	struct vmcb *nested_vmcb;
>> +	struct kvm_host_map map;
>> +	int ret;
>> +
>> +	if (nested_svm_check_permissions(svm))
>> +		return 1;
>> +
>> +	ret = kvm_vcpu_map(&svm->vcpu, gpa_to_gfn(svm->vmcb->save.rax), &map);
>> +	if (ret) {
>> +		if (ret == -EINVAL)
>> +			kvm_inject_gp(&svm->vcpu, 0);
>> +		return 1;
>> +	}
>> +
>> +	nested_vmcb = map.hva;
>> +
>> +	ret = kvm_skip_emulated_instruction(&svm->vcpu);
>> +
>> +	nested_svm_vmloadsave(nested_vmcb, svm->vmcb);
>> +	kvm_vcpu_unmap(&svm->vcpu, &map, true);
>> +
>> +	return ret;
>> +}
>> +
>> +static int vmsave_interception(struct vcpu_svm *svm)
>> +{
>> +	struct vmcb *nested_vmcb;
>> +	struct kvm_host_map map;
>> +	int ret;
>> +
>> +	if (nested_svm_check_permissions(svm))
>> +		return 1;
>> +
>> +	ret = kvm_vcpu_map(&svm->vcpu, gpa_to_gfn(svm->vmcb->save.rax), &map);
>> +	if (ret) {
>> +		if (ret == -EINVAL)
>> +			kvm_inject_gp(&svm->vcpu, 0);
>> +		return 1;
>> +	}
>> +
>> +	nested_vmcb = map.hva;
>> +
>> +	ret = kvm_skip_emulated_instruction(&svm->vcpu);
>> +
>> +	nested_svm_vmloadsave(svm->vmcb, nested_vmcb);
>> +	kvm_vcpu_unmap(&svm->vcpu, &map, true);
>> +
>> +	return ret;
>> +}
>> +
>> +static int vmrun_interception(struct vcpu_svm *svm)
>> +{
>> +	if (nested_svm_check_permissions(svm))
>> +		return 1;
>> +
>> +	return nested_svm_vmrun(svm);
>> +}
>> +
>> +/* Emulate SVM VM execution instructions */
>> +static int svm_emulate_vm_instr(struct kvm_vcpu *vcpu, u8 modrm)
>> +{
>> +	struct vcpu_svm *svm = to_svm(vcpu);
>> +
>> +	switch (modrm) {
>> +	case 0xd8: /* VMRUN */
>> +		return vmrun_interception(svm);
>> +	case 0xda: /* VMLOAD */
>> +		return vmload_interception(svm);
>> +	case 0xdb: /* VMSAVE */
>> +		return vmsave_interception(svm);
>> +	default:
>> +		/* inject a #GP for all other cases */
>> +		kvm_queue_exception_e(vcpu, GP_VECTOR, 0);
>> +		return 1;
>> +	}
>> +}
>> +
>>   static int gp_interception(struct vcpu_svm *svm)
>>   {
>>   	struct kvm_vcpu *vcpu = &svm->vcpu;
>>   	u32 error_code = svm->vmcb->control.exit_info_1;
>> -
>> -	WARN_ON_ONCE(!enable_vmware_backdoor);
>> +	int rc;
>>   
>>   	/*
>> -	 * VMware backdoor emulation on #GP interception only handles IN{S},
>> -	 * OUT{S}, and RDPMC, none of which generate a non-zero error code.
>> +	 * Only VMware backdoor and SVM VME errata are handled. Neither of
>> +	 * them has non-zero error codes.
>>   	 */
>>   	if (error_code) {
>>   		kvm_queue_exception_e(vcpu, GP_VECTOR, error_code);
>>   		return 1;
>>   	}
>> -	return kvm_emulate_instruction(vcpu, EMULTYPE_VMWARE_GP);
>> +
>> +	rc = kvm_emulate_instruction(vcpu, EMULTYPE_PARAVIRT_GP);
>> +	if (rc > 1)
>> +		rc = svm_emulate_vm_instr(vcpu, rc);
>> +	return rc;
>>   }
>>   
>>   static bool is_erratum_383(void)
>> @@ -2113,66 +2200,6 @@ static int vmmcall_interception(struct vcpu_svm *svm)
>>   	return kvm_emulate_hypercall(&svm->vcpu);
>>   }
>>   
>> -static int vmload_interception(struct vcpu_svm *svm)
>> -{
>> -	struct vmcb *nested_vmcb;
>> -	struct kvm_host_map map;
>> -	int ret;
>> -
>> -	if (nested_svm_check_permissions(svm))
>> -		return 1;
>> -
>> -	ret = kvm_vcpu_map(&svm->vcpu, gpa_to_gfn(svm->vmcb->save.rax), &map);
>> -	if (ret) {
>> -		if (ret == -EINVAL)
>> -			kvm_inject_gp(&svm->vcpu, 0);
>> -		return 1;
>> -	}
>> -
>> -	nested_vmcb = map.hva;
>> -
>> -	ret = kvm_skip_emulated_instruction(&svm->vcpu);
>> -
>> -	nested_svm_vmloadsave(nested_vmcb, svm->vmcb);
>> -	kvm_vcpu_unmap(&svm->vcpu, &map, true);
>> -
>> -	return ret;
>> -}
>> -
>> -static int vmsave_interception(struct vcpu_svm *svm)
>> -{
>> -	struct vmcb *nested_vmcb;
>> -	struct kvm_host_map map;
>> -	int ret;
>> -
>> -	if (nested_svm_check_permissions(svm))
>> -		return 1;
>> -
>> -	ret = kvm_vcpu_map(&svm->vcpu, gpa_to_gfn(svm->vmcb->save.rax), &map);
>> -	if (ret) {
>> -		if (ret == -EINVAL)
>> -			kvm_inject_gp(&svm->vcpu, 0);
>> -		return 1;
>> -	}
>> -
>> -	nested_vmcb = map.hva;
>> -
>> -	ret = kvm_skip_emulated_instruction(&svm->vcpu);
>> -
>> -	nested_svm_vmloadsave(svm->vmcb, nested_vmcb);
>> -	kvm_vcpu_unmap(&svm->vcpu, &map, true);
>> -
>> -	return ret;
>> -}
>> -
>> -static int vmrun_interception(struct vcpu_svm *svm)
>> -{
>> -	if (nested_svm_check_permissions(svm))
>> -		return 1;
>> -
>> -	return nested_svm_vmrun(svm);
>> -}
>> -
> 
> Maybe if you'd do it the other way around and put gp_interception()
> after vm{load,save,run}_interception(), the diff (and code churn)
> would've been smaller?

Agreed.

> 
>>   void svm_set_gif(struct vcpu_svm *svm, bool value)
>>   {
>>   	if (value) {
>> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
>> index 0fe874ae5498..d5dffcf59afa 100644
>> --- a/arch/x86/kvm/svm/svm.h
>> +++ b/arch/x86/kvm/svm/svm.h
>> @@ -350,6 +350,14 @@ static inline void clr_exception_intercept(struct vcpu_svm *svm, u32 bit)
>>   	recalc_intercepts(svm);
>>   }
>>   
>> +static inline bool is_exception_intercept(struct vcpu_svm *svm, u32 bit)
>> +{
>> +	struct vmcb *vmcb = get_host_vmcb(svm);
>> +
>> +	WARN_ON_ONCE(bit >= 32);
>> +	return vmcb_is_intercept(&vmcb->control, INTERCEPT_EXCEPTION_OFFSET + bit);
>> +}
>> +
>>   static inline void svm_set_intercept(struct vcpu_svm *svm, int bit)
>>   {
>>   	struct vmcb *vmcb = get_host_vmcb(svm);
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index 2af05d3b0590..5fac2f7cba24 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -4774,7 +4774,7 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
>>   			kvm_queue_exception_e(vcpu, GP_VECTOR, error_code);
>>   			return 1;
>>   		}
>> -		return kvm_emulate_instruction(vcpu, EMULTYPE_VMWARE_GP);
>> +		return kvm_emulate_instruction(vcpu, EMULTYPE_PARAVIRT_GP);
>>   	}
>>   
>>   	/*
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 9a8969a6dd06..c3662fc3b1bc 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -7014,7 +7014,7 @@ static int handle_emulation_failure(struct kvm_vcpu *vcpu, int emulation_type)
>>   	++vcpu->stat.insn_emulation_fail;
>>   	trace_kvm_emulate_insn_failed(vcpu);
>>   
>> -	if (emulation_type & EMULTYPE_VMWARE_GP) {
>> +	if (emulation_type & EMULTYPE_PARAVIRT_GP) {
>>   		kvm_queue_exception_e(vcpu, GP_VECTOR, 0);
>>   		return 1;
>>   	}
>> @@ -7267,6 +7267,28 @@ static bool kvm_vcpu_check_breakpoint(struct kvm_vcpu *vcpu, int *r)
>>   	return false;
>>   }
>>   
>> +static int is_vm_instr_opcode(struct x86_emulate_ctxt *ctxt)
> 
> Nit: it seems we either return '0' or 'ctxt->modrm' which is 'u8', so
> 'u8' instead of 'int' maybe?

Agreed. Also Paolo has some comments around this area as well. We will 
take these comments into consideration in v2.

> 
>> +{
>> +	unsigned long rax;
>> +
>> +	if (ctxt->b != 0x1)
>> +		return 0;
>> +
>> +	switch (ctxt->modrm) {
>> +	case 0xd8: /* VMRUN */
>> +	case 0xda: /* VMLOAD */
>> +	case 0xdb: /* VMSAVE */
>> +		rax = kvm_register_read(emul_to_vcpu(ctxt), VCPU_REGS_RAX);
>> +		if (!kvm_is_host_reserved_region(rax))
>> +			return 0;
>> +		break;
>> +	default:
>> +		return 0;
>> +	}
>> +
>> +	return ctxt->modrm;
>> +}
>> +
>>   static bool is_vmware_backdoor_opcode(struct x86_emulate_ctxt *ctxt)
>>   {
>>   	switch (ctxt->opcode_len) {
>> @@ -7305,6 +7327,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>>   	struct x86_emulate_ctxt *ctxt = vcpu->arch.emulate_ctxt;
>>   	bool writeback = true;
>>   	bool write_fault_to_spt;
>> +	int vminstr;
>>   
>>   	if (unlikely(!kvm_x86_ops.can_emulate_instruction(vcpu, insn, insn_len)))
>>   		return 1;
>> @@ -7367,10 +7390,14 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>>   		}
>>   	}
>>   
>> -	if ((emulation_type & EMULTYPE_VMWARE_GP) &&
>> -	    !is_vmware_backdoor_opcode(ctxt)) {
>> -		kvm_queue_exception_e(vcpu, GP_VECTOR, 0);
>> -		return 1;
>> +	if (emulation_type & EMULTYPE_PARAVIRT_GP) {
>> +		vminstr = is_vm_instr_opcode(ctxt);
>> +		if (!vminstr && !is_vmware_backdoor_opcode(ctxt)) {
>> +			kvm_queue_exception_e(vcpu, GP_VECTOR, 0);
>> +			return 1;
>> +		}
>> +		if (vminstr)
>> +			return vminstr;
>>   	}
>>   
>>   	/*
> 
