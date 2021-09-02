Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 073373FE728
	for <lists+kvm@lfdr.de>; Thu,  2 Sep 2021 03:32:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233130AbhIBBdM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Sep 2021 21:33:12 -0400
Received: from mga01.intel.com ([192.55.52.88]:35243 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233030AbhIBBdK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Sep 2021 21:33:10 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10094"; a="241195346"
X-IronPort-AV: E=Sophos;i="5.84,370,1620716400"; 
   d="scan'208";a="241195346"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2021 18:32:12 -0700
X-IronPort-AV: E=Sophos;i="5.84,370,1620716400"; 
   d="scan'208";a="532560568"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.255.28.137]) ([10.255.28.137])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2021 18:32:10 -0700
Subject: Re: [PATCH] KVM: nVMX: Fix nested bus lock VM exit
To:     Sean Christopherson <seanjc@google.com>,
        Chenyi Qiang <chenyi.qiang@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210827085110.6763-1-chenyi.qiang@intel.com>
 <YS/BrirERUK4uDaI@google.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <0f064b93-8375-8cba-6422-ff12f95af656@intel.com>
Date:   Thu, 2 Sep 2021 09:32:07 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <YS/BrirERUK4uDaI@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/2/2021 2:08 AM, Sean Christopherson wrote:
> On Fri, Aug 27, 2021, Chenyi Qiang wrote:
>> Nested bus lock VM exits are not supported yet. If L2 triggers bus lock
>> VM exit, it will be directed to L1 VMM, which would cause unexpected
>> behavior. Therefore, handle L2's bus lock VM exits in L0 directly.
>>
>> Fixes: fe6b6bc802b4 ("KVM: VMX: Enable bus lock VM exit")
>> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
>> ---
>>   arch/x86/kvm/vmx/nested.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>> index bc6327950657..754f53cf0f7a 100644
>> --- a/arch/x86/kvm/vmx/nested.c
>> +++ b/arch/x86/kvm/vmx/nested.c
>> @@ -5873,6 +5873,8 @@ static bool nested_vmx_l0_wants_exit(struct kvm_vcpu *vcpu,
>>   	case EXIT_REASON_VMFUNC:
>>   		/* VM functions are emulated through L2->L0 vmexits. */
>>   		return true;
>> +	case EXIT_REASON_BUS_LOCK:
>> +		return true;
> 
> Hmm, unless there is zero chance of ever exposing BUS_LOCK_DETECTION to L1, it
> might be better to handle this in nested_vmx_l1_wants_exit(), e.g.
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index b3f77d18eb5a..793534b7eaba 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -6024,6 +6024,8 @@ static bool nested_vmx_l1_wants_exit(struct kvm_vcpu *vcpu,
>                          SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE);
>          case EXIT_REASON_ENCLS:
>                  return nested_vmx_exit_handled_encls(vcpu, vmcs12);
> +       case EXIT_REASON_BUS_LOCK:
> +               return nested_cpu_has2(vmcs12, SECONDARY_EXEC_BUS_LOCK_DETECTION);

yes, for now, it equals

                   return false;

because KVM doesn't expose it to L1.

>          default:
>                  return true;
>          }
> 
> It's a rather roundabout way of reaching the same result, but I'd prefer to limit
> nested_vmx_l0_wants_exit() to cases where L0 wants to handle the exit regardless
> of what L1 wants.  This kinda fits that model, but it's not really that L0 "wants"
> the exit, it's that L1 can't want the exit.  Does that make sense?

something like below has to be in nested_vmx_l0_wants_exit()

--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5873,6 +5873,8 @@ static bool nested_vmx_l0_wants_exit(struct 
kvm_vcpu *vcpu,
         case EXIT_REASON_VMFUNC:
                 /* VM functions are emulated through L2->L0 vmexits. */
                 return true;
+       case EXIT_REASON_BUS_LOCK:
+               return vcpu->kvm->arch.bus_lock_detection_enabled;
         default:
                 break;
         }


L0 wants this VM exit because it enables BUS LOCK VM exit, not because 
L1 doesn't enable it.

> 
>>   	default:
>>   		break;
>>   	}
>> -- 
>> 2.17.1
>>

