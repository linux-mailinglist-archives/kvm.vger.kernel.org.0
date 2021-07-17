Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 143A83CC0E2
	for <lists+kvm@lfdr.de>; Sat, 17 Jul 2021 05:55:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232454AbhGQD6r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jul 2021 23:58:47 -0400
Received: from mga18.intel.com ([134.134.136.126]:57567 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229982AbhGQD6q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jul 2021 23:58:46 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10047"; a="198076984"
X-IronPort-AV: E=Sophos;i="5.84,246,1620716400"; 
   d="scan'208";a="198076984"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2021 20:55:50 -0700
X-IronPort-AV: E=Sophos;i="5.84,246,1620716400"; 
   d="scan'208";a="497327097"
Received: from zengguan-mobl.ccr.corp.intel.com (HELO [10.254.211.215]) ([10.254.211.215])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2021 20:55:45 -0700
Subject: Re: [PATCH 6/6] KVM: VMX: enable IPI virtualization
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Kai Huang <kai.huang@intel.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        Robert Hu <robert.hu@intel.com>, Gao Chao <chao.gao@intel.com>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>
References: <20210716064808.14757-1-guang.zeng@intel.com>
 <20210716064808.14757-7-guang.zeng@intel.com>
 <8aed2541-082d-d115-09ac-e7fcc05f96dc@redhat.com>
From:   Zeng Guang <guang.zeng@intel.com>
Message-ID: <89f240cb-cb3a-c362-7ded-ee500cc12dc3@intel.com>
Date:   Sat, 17 Jul 2021 11:55:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <8aed2541-082d-d115-09ac-e7fcc05f96dc@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/16/2021 5:52 PM, Paolo Bonzini wrote:
> On 16/07/21 08:48, Zeng Guang wrote:
>>
>> +    if (!(_cpu_based_3rd_exec_control & TERTIARY_EXEC_IPI_VIRT))
>> +        enable_ipiv = 0;
>> +
>>       }
>
> Please move this to hardware_setup(), using a new function 
> cpu_has_vmx_ipiv() in vmx/capabilities.h.
>
ok, we will change it to follow current framework.
>>      if (_cpu_based_exec_control & 
>> CPU_BASED_ACTIVATE_TERTIARY_CONTROLS) {
>> -        u64 opt3 = 0;
>> +        u64 opt3 = enable_ipiv ? TERTIARY_EXEC_IPI_VIRT : 0;
>>          u64 min3 = 0;
>
> I like the idea of changing opt3, but it's different from how 
> setup_vmcs_config works for the other execution controls.  Let me 
> think if it makes sense to clean this up, and move the handling of 
> other module parameters from hardware_setup() to setup_vmcs_config().
>
May be an exception for ipiv feature ?
>> +
>> +    if (vmx->ipiv_active)
>> +        install_pid(vmx);
>
> This should be if (enable_ipiv) instead, I think.
>
> In fact, in all other places that are using vmx->ipiv_active, you can 
> actually replace it with enable_ipiv; they are all reached only with 
> kvm_vcpu_apicv_active(vcpu) == true.
>
enable_ipiv as a global variable indicates the hardware capability to 
enable IPIv. Each VM may have different IPIv configuration according to 
kvm_vcpu_apicv_active status. So we use ipiv_active per VM to enclose 
IPIv related operations.
>> +    if (!enable_apicv) {
>> +        enable_ipiv = 0;
>> +        vmcs_config.cpu_based_3rd_exec_ctrl &= ~TERTIARY_EXEC_IPI_VIRT;
>> +    }
>
> The assignment to vmcs_config.cpu_based_3rd_exec_ctrl should not be 
> necessary; kvm_vcpu_apicv_active will always be false in that case and 
> IPI virtualization would never be enabled.
>
We originally intend to make vmcs_config consistent with the actual ipiv 
capability and decouple it from other factors. As you mentioned , it's 
not necessary to update vmcs_config.cpu_based_3rd_exec_ctrl in this 
case. We will remove it.

Thanks.

> Paolo
>
