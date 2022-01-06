Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C211A485E35
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 02:44:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344435AbiAFBol (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jan 2022 20:44:41 -0500
Received: from mga03.intel.com ([134.134.136.65]:61907 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344427AbiAFBoh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jan 2022 20:44:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641433477; x=1672969477;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=G6ngbjkjBS0fxtFM+fJf7muqpnq1GWTrwIY3RJJ+2bY=;
  b=Ve5Wj5SBolIv6xtu75v1ijux3SeXdHPisp5mfaLCnGveRT60T6KhNnn/
   q0CJrBGxzdEDvXZx+4OVVqt7uvQMk2zXWSCW/zh6fB6+OY1xOB8wHQ3hl
   r/mdy8LMJaeS2HxhydDP4GutTKMovx4kvSgS4yljcx+3q+XgXZh0YNiKa
   lNTH+qz4dFpJgZuPuyvVTkMx4rL/3oerGgyiusRTheS4Y5o/kqrQCTzz5
   O1Ejy+bMxHOrsF6K3vsmMsih7VdWIL6JxNfUYx+wVbTRhH+/Yu+zv6l7R
   DupgdHc5jIHih+lIfCV4r3dULkTQG4vJSegYiquX/sE72e6ZYw1P5GTFV
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="242526991"
X-IronPort-AV: E=Sophos;i="5.88,265,1635231600"; 
   d="scan'208";a="242526991"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2022 17:44:36 -0800
X-IronPort-AV: E=Sophos;i="5.88,265,1635231600"; 
   d="scan'208";a="526785362"
Received: from zengguan-mobl.ccr.corp.intel.com (HELO [10.238.0.214]) ([10.238.0.214])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2022 17:44:31 -0800
Message-ID: <4eee5de5-ab76-7094-17aa-adc552032ba0@intel.com>
Date:   Thu, 6 Jan 2022 09:44:20 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.4.1
Subject: Re: [PATCH v5 7/8] KVM: VMX: Update PID-pointer table entry when APIC
 ID is changed
Content-Language: en-US
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
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
        "Huang, Kai" <kai.huang@intel.com>
Cc:     "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Hu, Robert" <robert.hu@intel.com>,
        "Gao, Chao" <chao.gao@intel.com>
References: <20211231142849.611-1-guang.zeng@intel.com>
 <20211231142849.611-8-guang.zeng@intel.com>
 <640e82f3-489d-60af-1d31-25096bef1a46@amd.com>
From:   Zeng Guang <guang.zeng@intel.com>
In-Reply-To: <640e82f3-489d-60af-1d31-25096bef1a46@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/6/2022 3:13 AM, Tom Lendacky wrote:
> On 12/31/21 8:28 AM, Zeng Guang wrote:
>> In xAPIC mode, guest is allowed to modify APIC ID at runtime.
>> If IPI virtualization is enabled, corresponding entry in
>> PID-pointer table need change accordingly.
>>
>> Signed-off-by: Zeng Guang <guang.zeng@intel.com>
>> ---
>>    arch/x86/include/asm/kvm_host.h |  1 +
>>    arch/x86/kvm/lapic.c            |  7 +++++--
>>    arch/x86/kvm/vmx/vmx.c          | 12 ++++++++++++
>>    3 files changed, 18 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index 2164b9f4c7b0..753bf2a7cebc 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -1493,6 +1493,7 @@ struct kvm_x86_ops {
>>    	int (*complete_emulated_msr)(struct kvm_vcpu *vcpu, int err);
>>    
>>    	void (*vcpu_deliver_sipi_vector)(struct kvm_vcpu *vcpu, u8 vector);
>> +	void (*update_ipiv_pid_entry)(struct kvm_vcpu *vcpu, u8 old_id, u8 new_id);
>>    };
>>    
>>    struct kvm_x86_nested_ops {
>> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
>> index 3ce7142ba00e..83c2c7594bcd 100644
>> --- a/arch/x86/kvm/lapic.c
>> +++ b/arch/x86/kvm/lapic.c
>> @@ -2007,9 +2007,12 @@ int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
>>    
>>    	switch (reg) {
>>    	case APIC_ID:		/* Local APIC ID */
>> -		if (!apic_x2apic_mode(apic))
>> +		if (!apic_x2apic_mode(apic)) {
>> +			u8 old_id = kvm_lapic_get_reg(apic, APIC_ID) >> 24;
>> +
>>    			kvm_apic_set_xapic_id(apic, val >> 24);
>> -		else
>> +			kvm_x86_ops.update_ipiv_pid_entry(apic->vcpu, old_id, val >> 24);
> Won't this blow up on AMD since there is no corresponding SVM op?
>
> Thanks,
> Tom
Right, need check ops validness to avoid ruining AMD system. Same 
consideration on ops "update_ipiv_pid_table" in patch8.
I will revise in next version. Thanks.
>> +		} else
>>    			ret = 1;
>>    		break;
>>    
>>
