Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 836B46E0FE
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2019 08:32:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbfGSGbl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Jul 2019 02:31:41 -0400
Received: from mga03.intel.com ([134.134.136.65]:8305 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725616AbfGSGbk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Jul 2019 02:31:40 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Jul 2019 23:31:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,281,1559545200"; 
   d="scan'208";a="168469654"
Received: from txu2-mobl.ccr.corp.intel.com (HELO [10.239.198.19]) ([10.239.198.19])
  by fmsmga008.fm.intel.com with ESMTP; 18 Jul 2019 23:31:37 -0700
Subject: Re: [PATCH v8 0/3] KVM: x86: Enable user wait instructions
To:     pbonzini@redhat.com, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, corbet@lwn.net,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        fenghua.yu@intel.com, xiaoyao.li@linux.intel.com,
        jingqi.liu@intel.com
References: <20190716065551.27264-1-tao3.xu@intel.com>
From:   Tao Xu <tao3.xu@intel.com>
Message-ID: <d01e6b8b-279c-84da-1f08-7b01baf9fdbf@intel.com>
Date:   Fri, 19 Jul 2019 14:31:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190716065551.27264-1-tao3.xu@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ping for comments :)

On 7/16/2019 2:55 PM, Tao Xu wrote:
> UMONITOR, UMWAIT and TPAUSE are a set of user wait instructions.
> 
> UMONITOR arms address monitoring hardware using an address. A store
> to an address within the specified address range triggers the
> monitoring hardware to wake up the processor waiting in umwait.
> 
> UMWAIT instructs the processor to enter an implementation-dependent
> optimized state while monitoring a range of addresses. The optimized
> state may be either a light-weight power/performance optimized state
> (c0.1 state) or an improved power/performance optimized state
> (c0.2 state).
> 
> TPAUSE instructs the processor to enter an implementation-dependent
> optimized state c0.1 or c0.2 state and wake up when time-stamp counter
> reaches specified timeout.
> 
> Availability of the user wait instructions is indicated by the presence
> of the CPUID feature flag WAITPKG CPUID.0x07.0x0:ECX[5].
> 
> The patches enable the umonitor, umwait and tpause features in KVM.
> Because umwait and tpause can put a (psysical) CPU into a power saving
> state, by default we dont't expose it to kvm and enable it only when
> guest CPUID has it. If the instruction causes a delay, the amount
> of time delayed is called here the physical delay. The physical delay is
> first computed by determining the virtual delay (the time to delay
> relative to the VM’s timestamp counter).
> 
> The release document ref below link:
> Intel 64 and IA-32 Architectures Software Developer's Manual,
> https://software.intel.com/sites/default/files/\
> managed/39/c5/325462-sdm-vol-1-2abcd-3abcd.pdf
> 
> Changelog:
> v8:
> 	Add vmx_waitpkg_supported() helper (Sean)
> 	Add an accessor to expose umwait_control_cached (Sean)
> 	Set msr_ia32_umwait_control in vcpu_vmx u32 and raise #GP when
> 	[63:32] is set when rdmsr. (Sean)
> 	Introduce a common exit helper handle_unexpected_vmexit (Sean)
> v7:
> 	Add nested support for user wait instructions (Paolo)
> 	Use the test on vmx->secondary_exec_control to replace
> 	guest_cpuid_has (Paolo)
> v6:
> 	add check msr_info->host_initiated in get/set msr(Xiaoyao)
> 	restore the atomic_switch_umwait_control_msr()(Xiaoyao)
> 
> Tao Xu (3):
>    KVM: x86: Add support for user wait instructions
>    KVM: vmx: Emulate MSR IA32_UMWAIT_CONTROL
>    KVM: vmx: Introduce handle_unexpected_vmexit and handle WAITPKG vmexit
> 
>   arch/x86/include/asm/vmx.h      |  1 +
>   arch/x86/include/uapi/asm/vmx.h |  6 ++-
>   arch/x86/kernel/cpu/umwait.c    |  6 +++
>   arch/x86/kvm/cpuid.c            |  2 +-
>   arch/x86/kvm/vmx/capabilities.h |  6 +++
>   arch/x86/kvm/vmx/nested.c       |  5 ++
>   arch/x86/kvm/vmx/vmx.c          | 83 ++++++++++++++++++++++++++-------
>   arch/x86/kvm/vmx/vmx.h          |  9 ++++
>   arch/x86/kvm/x86.c              |  1 +
>   9 files changed, 101 insertions(+), 18 deletions(-)
> 

