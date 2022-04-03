Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B54EC4F08AE
	for <lists+kvm@lfdr.de>; Sun,  3 Apr 2022 12:18:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353647AbiDCKTs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 3 Apr 2022 06:19:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231140AbiDCKTr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 3 Apr 2022 06:19:47 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F39DD36B52;
        Sun,  3 Apr 2022 03:17:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648981073; x=1680517073;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=0DWWGhFxuAkvxZdt59vprTZ/AbZtR80Zrc1KiH+AU7k=;
  b=KhNTL6gW4hDbJ/ztEv9LfItmhCOAzDBsKGD/Ww5eHNN7wgKEWHIBLxp4
   xsbQLfLZcFs2r6prmBCOhjPmHDhH8/yMOCCHjhor5BQhF4bWbkC5s4Kj9
   PgivHB+0givTA9o2YucykyN/uu9o3cpH0lWhx03VeTGzt6A8o3N4qXFh4
   /2b0dDRZu6C2HCFHirgJYdicsMq5h0QjA5BEJr7ai0SGsEz16GG9LMqbF
   mH9hJDUcb7aSs9fliDlf4VlBL78tFechlCyaDzAfj2GGopHwuCrsGrog/
   zqU1H+E3Lyl9Qm6b6y/L8550E9N/CzNBruf2QXVuYiPm5Y4hRD06fHZ3L
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10305"; a="323549398"
X-IronPort-AV: E=Sophos;i="5.90,231,1643702400"; 
   d="scan'208";a="323549398"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2022 03:17:52 -0700
X-IronPort-AV: E=Sophos;i="5.90,231,1643702400"; 
   d="scan'208";a="568878443"
Received: from zengguan-mobl1.ccr.corp.intel.com (HELO [10.254.215.101]) ([10.254.215.101])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2022 03:17:47 -0700
Message-ID: <60879468-c54f-e7f1-2123-ba4cf4128ac3@intel.com>
Date:   Sun, 3 Apr 2022 18:17:37 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v7 7/8] KVM: x86: Allow userspace set maximum VCPU id for
 VM
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Huang, Kai" <kai.huang@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Hu, Robert" <robert.hu@intel.com>,
        "Gao, Chao" <chao.gao@intel.com>
References: <20220304080725.18135-1-guang.zeng@intel.com>
 <20220304080725.18135-8-guang.zeng@intel.com> <YkZc7cMsDaR5S2hM@google.com>
From:   Zeng Guang <guang.zeng@intel.com>
In-Reply-To: <YkZc7cMsDaR5S2hM@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/1/2022 10:01 AM, Sean Christopherson wrote:
> On Fri, Mar 04, 2022, Zeng Guang wrote:
>> Introduce new max_vcpu_id in KVM for x86 architecture. Userspace
>> can assign maximum possible vcpu id for current VM session using
>> KVM_CAP_MAX_VCPU_ID of KVM_ENABLE_CAP ioctl().
>>
>> This is done for x86 only because the sole use case is to guide
>> memory allocation for PID-pointer table, a structure needed to
>> enable VMX IPI.
>>
>> By default, max_vcpu_id set as KVM_MAX_VCPU_IDS.
>>
>> Suggested-by: Sean Christopherson <seanjc@google.com>
>> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
>> Signed-off-by: Zeng Guang <guang.zeng@intel.com>
>> ---
>>   arch/x86/include/asm/kvm_host.h |  6 ++++++
>>   arch/x86/kvm/x86.c              | 11 +++++++++++
> The new behavior needs to be documented in api.rst.

OK. I will prepare document for it.


>>   2 files changed, 17 insertions(+)
>>
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index 6dcccb304775..db16aebd946c 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -1233,6 +1233,12 @@ struct kvm_arch {
>>   	hpa_t	hv_root_tdp;
>>   	spinlock_t hv_root_tdp_lock;
>>   #endif
>> +	/*
>> +	 * VM-scope maximum vCPU ID. Used to determine the size of structures
>> +	 * that increase along with the maximum vCPU ID, in which case, using
>> +	 * the global KVM_MAX_VCPU_IDS may lead to significant memory waste.
>> +	 */
>> +	u32 max_vcpu_id;
> This should be max_vcpu_ids.  I agree the it _should_ be max_vcpu_id, but KVM's API
> for this is awful and we're stuck with the plural name.
>
>>   };
>>   
>>   struct kvm_vm_stat {
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 4f6fe9974cb5..ca17cc452bd3 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -5994,6 +5994,13 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>>   		kvm->arch.exit_on_emulation_error = cap->args[0];
>>   		r = 0;
>>   		break;
>> +	case KVM_CAP_MAX_VCPU_ID:
> I think it makes sense to change kvm_vm_ioctl_check_extension() to return the
> current max, it is a VM-scoped ioctl after all.

kvm_vm_ioctl_check_extension() can return kvm->arch.max_vcpu_ids
as it reflects runtime capability supported on current vm. I will
change it.

> Amusingly, I think we also need a capability to enumerate that KVM_CAP_MAX_VCPU_ID
> is writable.

IIUC, KVM_CAP_*  has intrinsic writable attribute. KVM will return invalid
If not implemented.

>> +		if (cap->args[0] <= KVM_MAX_VCPU_IDS) {
>> +			kvm->arch.max_vcpu_id = cap->args[0];
> This needs to be rejected if kvm->created_vcpus > 0, and that check needs to be
> done under kvm_lock, otherwise userspace can bump the max ID after KVM allocates
> per-VM structures and trigger buffer overflow.

Is it necessary to use kvm_lock ? Seems no use case to call it from multi-threads.

>> +			r = 0;
>> +		} else
> If-elif-else statements need curly braces for all paths if any path needs braces.
> Probably a moot point for this patch due to the above changes.
>
>> +			r = -E2BIG;
> This should be -EINVAL, not -E2BIG.
>
> E.g.
>
> 	case KVM_CAP_MAX_VCPU_ID:
> 		r = -EINVAL;
> 		if (cap->args[0] > KVM_MAX_VCPU_IDS)
> 			break;
>
> 		mutex_lock(&kvm->lock);
> 		if (!kvm->created_vcpus) {
> 			kvm->arch.max_vcpu_id = cap->args[0];
> 			r = 0;
> 		}
> 		mutex_unlock(&kvm->lock);
> 		break;
>
>
>> +		break;
>>   	default:
>>   		r = -EINVAL;
>>   		break;
>> @@ -11067,6 +11074,9 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>>   	struct page *page;
>>   	int r;
>>   
>> +	if (vcpu->vcpu_id >= vcpu->kvm->arch.max_vcpu_id)
>> +		return -E2BIG;
> Same here, it should be -EINVAL.
>
>> +
>>   	vcpu->arch.last_vmentry_cpu = -1;
>>   	vcpu->arch.regs_avail = ~0;
>>   	vcpu->arch.regs_dirty = ~0;
>> @@ -11589,6 +11599,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>>   	spin_lock_init(&kvm->arch.hv_root_tdp_lock);
>>   	kvm->arch.hv_root_tdp = INVALID_PAGE;
>>   #endif
>> +	kvm->arch.max_vcpu_id = KVM_MAX_VCPU_IDS;
>>   
>>   	INIT_DELAYED_WORK(&kvm->arch.kvmclock_update_work, kvmclock_update_fn);
>>   	INIT_DELAYED_WORK(&kvm->arch.kvmclock_sync_work, kvmclock_sync_fn);
>> -- 
>> 2.27.0
>>
