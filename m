Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D05EDCE08
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2019 20:34:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394377AbfJRSef (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Oct 2019 14:34:35 -0400
Received: from mga09.intel.com ([134.134.136.24]:18543 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394205AbfJRSef (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Oct 2019 14:34:35 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Oct 2019 11:34:34 -0700
X-IronPort-AV: E=Sophos;i="5.67,312,1566889200"; 
   d="scan'208";a="190446874"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.249.171.209]) ([10.249.171.209])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/AES256-SHA; 18 Oct 2019 11:34:32 -0700
Subject: Re: [PATCH v2 1/3] KVM: VMX: Move vmcs related resetting out of
 vmx_vcpu_reset()
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20191018093723.102471-1-xiaoyao.li@intel.com>
 <20191018093723.102471-2-xiaoyao.li@intel.com>
 <20191018165711.GD26319@linux.intel.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <86f134c6-c983-0184-7d7b-9a95507e0586@intel.com>
Date:   Sat, 19 Oct 2019 02:34:31 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191018165711.GD26319@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/19/2019 12:57 AM, Sean Christopherson wrote:
> On Fri, Oct 18, 2019 at 05:37:21PM +0800, Xiaoyao Li wrote:
>> Move vmcs related codes into a new function vmx_vmcs_reset() from
>> vmx_vcpu_reset(). So that it's more clearer which data is related with
>> vmcs and can be held in vmcs.
>>
>> Suggested-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> ---
>>   arch/x86/kvm/vmx/vmx.c | 65 ++++++++++++++++++++++++------------------
>>   1 file changed, 37 insertions(+), 28 deletions(-)
>>
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index e660e28e9ae0..ef567df344bf 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -4271,33 +4271,11 @@ static void vmx_vcpu_setup(struct vcpu_vmx *vmx)
>>   	}
>>   }
>>   
>> -static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>> +static void vmx_vmcs_reset(struct kvm_vcpu *vcpu, bool init_event)
> 
> I'd strongly prefer to keep the existing code.  For me, "vmcs_reset" means
> zeroing out the VMCS, i.e. reset the VMCS to a virgin state.  "vcpu_reset"
> means exactly that, stuff vCPU state to emulate RESET/INIT.
> 
> And the split is arbitrary and funky, e.g. EFER is integrated into the
> VMCS on all recent CPUs, but here it's handled in vcpu_reset.
>

I left EFER in vcpu_reset() because it doesn't directly lead to a 
vmcs_write in vmx_set_efer().

OK. I'll drop this patch.
