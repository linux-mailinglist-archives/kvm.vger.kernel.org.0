Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66DB3B32F1
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2019 03:28:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729140AbfIPB2K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 15 Sep 2019 21:28:10 -0400
Received: from mga06.intel.com ([134.134.136.31]:10723 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729124AbfIPB2K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 15 Sep 2019 21:28:10 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Sep 2019 18:28:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,492,1559545200"; 
   d="scan'208";a="176903427"
Received: from txu2-mobl.ccr.corp.intel.com (HELO [10.239.197.66]) ([10.239.197.66])
  by orsmga007.jf.intel.com with ESMTP; 15 Sep 2019 18:28:07 -0700
Subject: Re: [PATCH v8 0/3] KVM: x86: Enable user wait instructions
To:     Paolo Bonzini <pbonzini@redhat.com>, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, corbet@lwn.net,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        jingqi.liu@intel.com
References: <20190716065551.27264-1-tao3.xu@intel.com>
 <d01e6b8b-279c-84da-1f08-7b01baf9fdbf@intel.com>
 <ad687740-1525-f9c2-b441-63613b7dd93e@redhat.com>
From:   Tao Xu <tao3.xu@intel.com>
Message-ID: <ca969df2-a42a-3e7c-f49c-6b59d097b3de@intel.com>
Date:   Mon, 16 Sep 2019 09:28:06 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <ad687740-1525-f9c2-b441-63613b7dd93e@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/20/2019 1:18 AM, Paolo Bonzini wrote:
> On 19/07/19 08:31, Tao Xu wrote:
>> Ping for comments :)
> 
> Hi, I'll look at it for 5.4, right after the merge window.
> 
> Paolo
> 
Hi paolo,

Linux 5.3 has released, could you review these patches. Thank you very much!

Tao
>> On 7/16/2019 2:55 PM, Tao Xu wrote:
>>> UMONITOR, UMWAIT and TPAUSE are a set of user wait instructions.
>>>
>>> UMONITOR arms address monitoring hardware using an address. A store
>>> to an address within the specified address range triggers the
>>> monitoring hardware to wake up the processor waiting in umwait.
>>>
>>> UMWAIT instructs the processor to enter an implementation-dependent
>>> optimized state while monitoring a range of addresses. The optimized
>>> state may be either a light-weight power/performance optimized state
>>> (c0.1 state) or an improved power/performance optimized state
>>> (c0.2 state).
>>>
>>> TPAUSE instructs the processor to enter an implementation-dependent
>>> optimized state c0.1 or c0.2 state and wake up when time-stamp counter
>>> reaches specified timeout.
>>>
>>> Availability of the user wait instructions is indicated by the presence
>>> of the CPUID feature flag WAITPKG CPUID.0x07.0x0:ECX[5].
>>>
>>> The patches enable the umonitor, umwait and tpause features in KVM.
>>> Because umwait and tpause can put a (psysical) CPU into a power saving
>>> state, by default we dont't expose it to kvm and enable it only when
>>> guest CPUID has it. If the instruction causes a delay, the amount
>>> of time delayed is called here the physical delay. The physical delay is
>>> first computed by determining the virtual delay (the time to delay
>>> relative to the VM’s timestamp counter).
>>>
>>> The release document ref below link:
>>> Intel 64 and IA-32 Architectures Software Developer's Manual,
>>> https://software.intel.com/sites/default/files/\
>>> managed/39/c5/325462-sdm-vol-1-2abcd-3abcd.pdf
>>>
>>> Changelog:
>>> v8:
>>>      Add vmx_waitpkg_supported() helper (Sean)
>>>      Add an accessor to expose umwait_control_cached (Sean)
>>>      Set msr_ia32_umwait_control in vcpu_vmx u32 and raise #GP when
>>>      [63:32] is set when rdmsr. (Sean)
>>>      Introduce a common exit helper handle_unexpected_vmexit (Sean)
>>> v7:
>>>      Add nested support for user wait instructions (Paolo)
>>>      Use the test on vmx->secondary_exec_control to replace
>>>      guest_cpuid_has (Paolo)
>>> v6:
>>>      add check msr_info->host_initiated in get/set msr(Xiaoyao)
>>>      restore the atomic_switch_umwait_control_msr()(Xiaoyao)
>>>
>>> Tao Xu (3):
>>>     KVM: x86: Add support for user wait instructions
>>>     KVM: vmx: Emulate MSR IA32_UMWAIT_CONTROL
>>>     KVM: vmx: Introduce handle_unexpected_vmexit and handle WAITPKG vmexit
>>>
>>>    arch/x86/include/asm/vmx.h      |  1 +
>>>    arch/x86/include/uapi/asm/vmx.h |  6 ++-
>>>    arch/x86/kernel/cpu/umwait.c    |  6 +++
>>>    arch/x86/kvm/cpuid.c            |  2 +-
>>>    arch/x86/kvm/vmx/capabilities.h |  6 +++
>>>    arch/x86/kvm/vmx/nested.c       |  5 ++
>>>    arch/x86/kvm/vmx/vmx.c          | 83 ++++++++++++++++++++++++++-------
>>>    arch/x86/kvm/vmx/vmx.h          |  9 ++++
>>>    arch/x86/kvm/x86.c              |  1 +
>>>    9 files changed, 101 insertions(+), 18 deletions(-)
>>>
>>
> 

