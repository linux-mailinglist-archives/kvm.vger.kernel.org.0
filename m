Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0281D44AEE1
	for <lists+kvm@lfdr.de>; Tue,  9 Nov 2021 14:37:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234332AbhKINkc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Nov 2021 08:40:32 -0500
Received: from mga03.intel.com ([134.134.136.65]:15505 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233035AbhKINkb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Nov 2021 08:40:31 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10162"; a="232390240"
X-IronPort-AV: E=Sophos;i="5.87,220,1631602800"; 
   d="scan'208";a="232390240"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2021 05:37:45 -0800
X-IronPort-AV: E=Sophos;i="5.87,220,1631602800"; 
   d="scan'208";a="491658606"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.249.168.220]) ([10.249.168.220])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2021 05:37:40 -0800
Message-ID: <6f0d243c-4f40-d608-3309-5c37536ab866@intel.com>
Date:   Tue, 9 Nov 2021 21:37:38 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.3.0
Subject: Re: [RFC PATCH v2 24/69] KVM: x86: Introduce "protected guest"
 concept and block disallowed ioctls
Content-Language: en-US
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     isaku.yamahata@gmail.com,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>, x86@kernel.org,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <cover.1625186503.git.isaku.yamahata@intel.com>
 <482264f17fa0652faad9bd5364d652d11cb2ecb8.1625186503.git.isaku.yamahata@intel.com>
 <02ca73b2-7f04-813d-5bb7-649c0edafa06@redhat.com>
 <209a57e9-ca9c-3939-4aaa-4602e3dd7cdd@amd.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <209a57e9-ca9c-3939-4aaa-4602e3dd7cdd@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/21/2021 6:08 AM, Tom Lendacky wrote:
> On 7/6/21 8:59 AM, Paolo Bonzini wrote:
>> On 03/07/21 00:04, isaku.yamahata@intel.com wrote:
>>> From: Sean Christopherson <sean.j.christopherson@intel.com>
>>>
>>> Add 'guest_state_protected' to mark a VM's state as being protected by
>>> hardware/firmware, e.g. SEV-ES or TDX-SEAM.  Use the flag to disallow
>>> ioctls() and/or flows that attempt to access protected state.
>>>
>>> Return an error if userspace attempts to get/set register state for a
>>> protected VM, e.g. a non-debug TDX guest.  KVM can't provide sane data,
>>> it's userspace's responsibility to avoid attempting to read guest state
>>> when it's known to be inaccessible.
>>>
>>> Retrieving vCPU events is the one exception, as the userspace VMM is
>>> allowed to inject NMIs.
>>>
>>> Co-developed-by: Xiaoyao Li <xiaoyao.li@intel.com>
>>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>>> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
>>> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>>> ---
>>>    arch/x86/kvm/x86.c | 104 +++++++++++++++++++++++++++++++++++++--------
>>>    1 file changed, 86 insertions(+), 18 deletions(-)
>>
>> Looks good, but it should be checked whether it breaks QEMU for SEV-ES.
>>   Tom, can you help?
> 
> Sorry to take so long to get back to you... been really slammed, let me
> look into this a bit more. But, some quick thoughts...
> 
> Offhand, the SMI isn't a problem since SEV-ES doesn't support SMM.
> 
> For kvm_vcpu_ioctl_x86_{get,set}_xsave(), can TDX use what was added for
> SEV-ES:
>    ed02b213098a ("KVM: SVM: Guest FPU state save/restore not needed for SEV-ES guest")
> 
> Same for kvm_arch_vcpu_ioctl_{get,set}_fpu().

Tom,

I think what you did in this commit is not so correct. It just silently 
ignores the ioctls insteaf of returning an error to userspace to tell 
this IOCTL is not invalid to this VM. E.g., for 
kvm_arch_vcpu_ioctl_get_fpu(), QEMU just gets it succesful with fpu 
being all zeros.

So Paolo, what's your point on this?

> The changes to kvm_arch_vcpu_ioctl_{get,set}_sregs() might cause issues,
> since there are specific things allowed in __{get,set}_sregs. But I'll
> need to dig a bit more on that.
> 
> Thanks,
> Tom
> 


