Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 015D13D52D8
	for <lists+kvm@lfdr.de>; Mon, 26 Jul 2021 07:33:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231570AbhGZEu6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jul 2021 00:50:58 -0400
Received: from mga04.intel.com ([192.55.52.120]:64123 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229579AbhGZEu5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jul 2021 00:50:57 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10056"; a="210272248"
X-IronPort-AV: E=Sophos;i="5.84,270,1620716400"; 
   d="scan'208";a="210272248"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2021 22:31:27 -0700
X-IronPort-AV: E=Sophos;i="5.84,270,1620716400"; 
   d="scan'208";a="504644556"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.249.175.15]) ([10.249.175.15])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2021 22:31:23 -0700
Subject: Re: [RFC PATCH v2 65/69] KVM: X86: Introduce initial_tsc_khz in
 struct kvm_arch
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "erdemaktas@google.com" <erdemaktas@google.com>,
        Connor Kuehl <ckuehl@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
References: <cover.1625186503.git.isaku.yamahata@intel.com>
 <5f87f0b888555b52041a0fe32280adee0d563e63.1625186503.git.isaku.yamahata@intel.com>
 <792040b0-4463-d805-d14e-ba264a3f8bbf@redhat.com>
 <YO3YDXLV7RQzMmXX@google.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <2705e8a4-6783-cfb7-e24d-0ffcffbefd6a@intel.com>
Date:   Mon, 26 Jul 2021 13:31:21 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <YO3YDXLV7RQzMmXX@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/14/2021 2:14 AM, Sean Christopherson wrote:
> On Tue, Jul 06, 2021, Paolo Bonzini wrote:
>> On 03/07/21 00:05, isaku.yamahata@intel.com wrote:
>>> From: Xiaoyao Li <xiaoyao.li@intel.com>
>>>
>>> Introduce a per-vm variable initial_tsc_khz to hold the default tsc_khz
>>> for kvm_arch_vcpu_create().
>>>
>>> This field is going to be used by TDX since TSC frequency for TD guest
>>> is configured at TD VM initialization phase.
>>>
>>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>>> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>>> ---
>>>    arch/x86/include/asm/kvm_host.h | 1 +
>>>    arch/x86/kvm/x86.c              | 3 ++-
>>>    2 files changed, 3 insertions(+), 1 deletion(-)
>>
>> So this means disabling TSC frequency scaling on TDX.  

No. It still supports TSC frequency scaling on TDX. Only that we need to 
configure TSC frequency for TD guest at VM level, not vcpu level.

>> Would it make sense
>> to delay VM creation to a separate ioctl, similar to KVM_ARM_VCPU_FINALIZE
>> (KVM_VM_FINALIZE)?
> 
> There's an equivalent of that in the next mega-patch, the KVM_TDX_INIT_VM sub-ioctl
> of KVM_MEMORY_ENCRYPT_OP.  The TSC frequency for the guest gets provided at that
> time.
> 

