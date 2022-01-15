Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AC3C48F44B
	for <lists+kvm@lfdr.de>; Sat, 15 Jan 2022 03:08:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232130AbiAOCIZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jan 2022 21:08:25 -0500
Received: from mga05.intel.com ([192.55.52.43]:50569 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231258AbiAOCIY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jan 2022 21:08:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642212504; x=1673748504;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=56svY1AMQsubSQkVshEHRawYB4F98372l1HmddsGc+c=;
  b=Maz0Fwrp6SJ8SnRQf3GGmfMluTvx4G3rZR3DpkGkZ1QodE/7UmiTNUjr
   2h1g99Y2dEkbBy5psBkw48ft0VhLKhjU5xnMgL+xYS6TsdW/TUs7BW2n3
   Wbw/QLwmQd8Aa8LnjOgzgX+8ufCXy6p9tc/SifeeFyW5O+8FVda8OHP6/
   wqpvioV61LW4yTW4jfiwhRi0849zdN9i3C3Co8jZDEQTPnW/BRF0rDAb+
   iiHaEZ7g1qK8aMUkXODOEOOIQStHEWr5JE3+GCB+w9bC7xxN8bpwf7N1q
   pqOVvi/9ZBwcBzsvDvILwcWv4ugoMt/FBZYl+8treTPZclmBWRmWRQ81A
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10227"; a="330715278"
X-IronPort-AV: E=Sophos;i="5.88,290,1635231600"; 
   d="scan'208";a="330715278"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2022 18:08:24 -0800
X-IronPort-AV: E=Sophos;i="5.88,290,1635231600"; 
   d="scan'208";a="516615072"
Received: from zengguan-mobl.ccr.corp.intel.com (HELO [10.254.213.217]) ([10.254.213.217])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2022 18:08:19 -0800
Message-ID: <8ab5f976-1f3e-e2a5-87f6-e6cf376ead2f@intel.com>
Date:   Sat, 15 Jan 2022 10:08:10 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.4.1
Subject: Re: [PATCH v5 5/8] KVM: x86: Support interrupt dispatch in x2APIC
 mode with APIC-write VM exit
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
References: <20211231142849.611-1-guang.zeng@intel.com>
 <20211231142849.611-6-guang.zeng@intel.com> <YeCZpo+qCkvx5l5m@google.com>
 <ec578526-989d-0913-e40e-9e463fb85a8f@intel.com>
 <YeG0Fdn/2++phMWs@google.com>
From:   Zeng Guang <guang.zeng@intel.com>
In-Reply-To: <YeG0Fdn/2++phMWs@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/15/2022 1:34 AM, Sean Christopherson wrote:
> On Fri, Jan 14, 2022, Zeng Guang wrote:
>> kvm_lapic_reg_read() is limited to read up to 4 bytes. It needs extension to
>> support 64bit read.
> Ah, right.
>
>> And another concern is here getting reg value only specific from vICR(no
>> other regs need take care), going through whole path on kvm_lapic_reg_read()
>> could be time-consuming unnecessarily. Is it proper that calling
>> kvm_lapic_get_reg64() to retrieve vICR value directly?
> Hmm, no, I don't think that's proper.  Retrieving a 64-bit value really is unique
> to vICR.  Yes, the code does WARN on that, but if future architectural extensions
> even generate APIC-write exits on other registers, then using kvm_lapic_get_reg64()
> would be wrong and this code would need to be updated again.
Split on x2apic and WARN on (offset != APIC_ICR) already limit register 
read to vICR only. Actually
we just need consider to deal with 64bit data specific to vICR in 
APIC-write exits. From this point of
view, previous design can be compatible on handling other registers even 
if future architectural
extensions changes. :)
>
> What about tweaking my prep patch from before to the below?  That would yield:
>
> 	if (apic_x2apic_mode(apic)) {
> 		if (WARN_ON_ONCE(offset != APIC_ICR))
> 			return 1;
>
> 		kvm_lapic_msr_read(apic, offset, &val);

I think it's problematic to use kvm_lapic_msr_read() in this case. It 
premises the high 32bit value
already valid at APIC_ICR2, while in handling "nodecode" x2APIC writes 
we need get continuous 64bit
data from offset 300H first and prepare emulation of APIC_ICR2 write. At 
this time, APIC_ICR2 is not
ready yet.

> 		kvm_lapic_msr_write(apic, offset, val);
> 	} else {
> 		kvm_lapic_reg_read(apic, offset, 4, &val);
> 		kvm_lapic_reg_write(apic, offset, val);
> 	}
>
> I like that the above has "msr" in the low level x2apic helpers, and it maximizes
> code reuse.  Compile tested only...
>
> From: Sean Christopherson <seanjc@google.com>
> Date: Fri, 14 Jan 2022 09:29:34 -0800
> Subject: [PATCH] KVM: x86: Add helpers to handle 64-bit APIC MSR read/writes
>
> Add helpers to handle 64-bit APIC read/writes via MSRs to deduplicate the
> x2APIC and Hyper-V code needed to service reads/writes to ICR.  Future
> support for IPI virtualization will add yet another path where KVM must
> handle 64-bit APIC MSR reads/write (to ICR).
>
> Opportunistically fix the comment in the write path; ICR2 holds the
> destination (if there's no shorthand), not the vector.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/lapic.c | 59 ++++++++++++++++++++++----------------------
>   1 file changed, 29 insertions(+), 30 deletions(-)
>
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index f206fc35deff..cc4531eb448f 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -2787,6 +2787,30 @@ int kvm_lapic_set_vapic_addr(struct kvm_vcpu *vcpu, gpa_t vapic_addr)
>   	return 0;
>   }
>
> +static int kvm_lapic_msr_read(struct kvm_lapic *apic, u32 reg, u64 *data)
> +{
> +	u32 low, high = 0;
> +
> +	if (kvm_lapic_reg_read(apic, reg, 4, &low))
> +		return 1;
> +
> +	if (reg == APIC_ICR &&
> +	    WARN_ON_ONCE(kvm_lapic_reg_read(apic, APIC_ICR2, 4, &high)))
> +		return 1;
> +
> +	*data = (((u64)high) << 32) | low;
> +
> +	return 0;
> +}
> +
> +static int kvm_lapic_msr_write(struct kvm_lapic *apic, u32 reg, u64 data)
> +{
> +	/* For 64-bit ICR writes, set ICR2 (dest) before ICR (command). */
> +	if (reg == APIC_ICR)
> +		kvm_lapic_reg_write(apic, APIC_ICR2, (u32)(data >> 32));
> +	return kvm_lapic_reg_write(apic, reg, (u32)data);
> +}
> +
>   int kvm_x2apic_msr_write(struct kvm_vcpu *vcpu, u32 msr, u64 data)
>   {
>   	struct kvm_lapic *apic = vcpu->arch.apic;
> @@ -2798,16 +2822,13 @@ int kvm_x2apic_msr_write(struct kvm_vcpu *vcpu, u32 msr, u64 data)
>   	if (reg == APIC_ICR2)
>   		return 1;
>
> -	/* if this is ICR write vector before command */
> -	if (reg == APIC_ICR)
> -		kvm_lapic_reg_write(apic, APIC_ICR2, (u32)(data >> 32));
> -	return kvm_lapic_reg_write(apic, reg, (u32)data);
> +	return kvm_lapic_msr_write(apic, reg, data);
>   }
>
>   int kvm_x2apic_msr_read(struct kvm_vcpu *vcpu, u32 msr, u64 *data)
>   {
>   	struct kvm_lapic *apic = vcpu->arch.apic;
> -	u32 reg = (msr - APIC_BASE_MSR) << 4, low, high = 0;
> +	u32 reg = (msr - APIC_BASE_MSR) << 4;
>
>   	if (!lapic_in_kernel(vcpu) || !apic_x2apic_mode(apic))
>   		return 1;
> @@ -2815,45 +2836,23 @@ int kvm_x2apic_msr_read(struct kvm_vcpu *vcpu, u32 msr, u64 *data)
>   	if (reg == APIC_DFR || reg == APIC_ICR2)
>   		return 1;
>
> -	if (kvm_lapic_reg_read(apic, reg, 4, &low))
> -		return 1;
> -	if (reg == APIC_ICR)
> -		kvm_lapic_reg_read(apic, APIC_ICR2, 4, &high);
> -
> -	*data = (((u64)high) << 32) | low;
> -
> -	return 0;
> +	return kvm_lapic_msr_read(apic, reg, data);
>   }
>
>   int kvm_hv_vapic_msr_write(struct kvm_vcpu *vcpu, u32 reg, u64 data)
>   {
> -	struct kvm_lapic *apic = vcpu->arch.apic;
> -
>   	if (!lapic_in_kernel(vcpu))
>   		return 1;
>
> -	/* if this is ICR write vector before command */
> -	if (reg == APIC_ICR)
> -		kvm_lapic_reg_write(apic, APIC_ICR2, (u32)(data >> 32));
> -	return kvm_lapic_reg_write(apic, reg, (u32)data);
> +	return kvm_lapic_msr_write(vcpu->arch.apic, reg, data);
>   }
>
>   int kvm_hv_vapic_msr_read(struct kvm_vcpu *vcpu, u32 reg, u64 *data)
>   {
> -	struct kvm_lapic *apic = vcpu->arch.apic;
> -	u32 low, high = 0;
> -
>   	if (!lapic_in_kernel(vcpu))
>   		return 1;
>
> -	if (kvm_lapic_reg_read(apic, reg, 4, &low))
> -		return 1;
> -	if (reg == APIC_ICR)
> -		kvm_lapic_reg_read(apic, APIC_ICR2, 4, &high);
> -
> -	*data = (((u64)high) << 32) | low;
> -
> -	return 0;
> +	return kvm_lapic_msr_read(vcpu->arch.apic, reg, data);
>   }
>
>   int kvm_lapic_set_pv_eoi(struct kvm_vcpu *vcpu, u64 data, unsigned long len)
> --
