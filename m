Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38CEC21022F
	for <lists+kvm@lfdr.de>; Wed,  1 Jul 2020 04:47:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726771AbgGACrH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Jun 2020 22:47:07 -0400
Received: from mga01.intel.com ([192.55.52.88]:49452 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725988AbgGACrG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Jun 2020 22:47:06 -0400
IronPort-SDR: uU9AFxyPn45Kiz9qlzNkJoqS8nmwGp82REXK7TAOkyILyIhu/IoLx5I3zEd1z0O+H/hTwQKX1j
 GwyHPqCjQ2tw==
X-IronPort-AV: E=McAfee;i="6000,8403,9668"; a="164450711"
X-IronPort-AV: E=Sophos;i="5.75,298,1589266800"; 
   d="scan'208";a="164450711"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2020 19:47:05 -0700
IronPort-SDR: 8Cs/5Imglx6YXbyj/1U9UILEStcYRGXt8qyJb10gai2Mz57OqXtWbKqw1eR/LDZXaS2OCSvGLI
 rhtMJJCJ44rA==
X-IronPort-AV: E=Sophos;i="5.75,298,1589266800"; 
   d="scan'208";a="454836339"
Received: from unknown (HELO [10.239.13.99]) ([10.239.13.99])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2020 19:47:02 -0700
Subject: Re: [PATCH v9 0/8] KVM: Add virtualization support of split lock
 detection
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@kernel.org>, peterz@infradead.org,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>
References: <20200509110542.8159-1-xiaoyao.li@intel.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <45214dc8-08eb-5754-4c5c-e2de18592eb7@intel.com>
Date:   Wed, 1 Jul 2020 10:46:59 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200509110542.8159-1-xiaoyao.li@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ping for comments.

On 5/9/2020 7:05 PM, Xiaoyao Li wrote:
> This series aims to add the virtualization of split lock detection in
> KVM.
> 
> Due to the fact that split lock detection is tightly coupled with CPU
> model and CPU model is configurable by host VMM, we elect to use
> paravirt method to expose and enumerate it for guest.
> 
> Changes in v9
>   - rebase to v5.7-rc4
>   - Add one patch to rename TIF_SLD to TIF_SLD_DISABLED;
>   - Add one patch to remove bogus case in handle_guest_split_lock;
>   - Introduce flag X86_FEATURE_SPLIT_LOCK_DETECT_FATAL and thus drop
>     sld_state;
>   - Use X86_FEATURE_SPLIT_LOCK_DETECT and X86_FEATURE_SPLIT_LOCK_DETECT_FATAL
>     to determine the SLD state of host;
>   - Introduce split_lock_virt_switch() and two wrappers for KVM instead
>     of sld_update_to();
>   - Use paravirt to expose and enumerate split lock detection for guest;
>   - Split lock detection can be exposed to guest when host is sld_fatal,
>     even though host is SMT available.
> 
> Changes in v8:
> https://lkml.kernel.org/r/20200414063129.133630-1-xiaoyao.li@intel.com
>   - rebase to v5.7-rc1.
>   - basic enabling of split lock detection already merged.
>   - When host is sld_warn and nosmt, load guest's sld bit when in KVM
>     context, i.e., between vmx_prepare_switch_to_guest() and before
>     vmx_prepare_switch_to_host(), KVM uses guest sld setting.
> 
> Changes in v7:
> https://lkml.kernel.org/r/20200325030924.132881-1-xiaoyao.li@intel.com
>   - only pick patch 1 and patch 2, and hold all the left.
>   - Update SLD bit on each processor based on sld_state.
> 
> Changes in v6:
> https://lkml.kernel.org/r/20200324151859.31068-1-xiaoyao.li@intel.com
>   - Drop the sld_not_exist flag and use X86_FEATURE_SPLIT_LOCK_DETECT to
>     check whether need to init split lock detection. [tglx]
>   - Use tglx's method to verify the existence of split lock detectoin.
>   - small optimization of sld_update_msr() that the default value of
>     msr_test_ctrl_cache has split_lock_detect bit cleared.
>   - Drop the patch3 in v5 that introducing kvm_only option. [tglx]
>   - Rebase patch4-8 to kvm/queue.
>   - use the new kvm-cpu-cap to expose X86_FEATURE_CORE_CAPABILITIES in
>     Patch 6.
> 
> Changes in v5:
> https://lkml.kernel.org/r/20200315050517.127446-1-xiaoyao.li@intel.com
>   - Use X86_FEATURE_SPLIT_LOCK_DETECT flag in kvm to ensure split lock
>     detection is really supported.
>   - Add and export sld related helper functions in their related usecase
>     kvm patches.
> 
> Xiaoyao Li (8):
>    x86/split_lock: Rename TIF_SLD to TIF_SLD_DISABLED
>    x86/split_lock: Remove bogus case in handle_guest_split_lock()
>    x86/split_lock: Introduce flag X86_FEATURE_SLD_FATAL and drop
>      sld_state
>    x86/split_lock: Introduce split_lock_virt_switch() and two wrappers
>    x86/kvm: Introduce paravirt split lock detection enumeration
>    KVM: VMX: Enable MSR TEST_CTRL for guest
>    KVM: VMX: virtualize split lock detection
>    x86/split_lock: Enable split lock detection initialization when
>      running as an guest on KVM
> 
>   Documentation/virt/kvm/cpuid.rst     | 29 +++++++----
>   arch/x86/include/asm/cpu.h           | 35 ++++++++++++++
>   arch/x86/include/asm/cpufeatures.h   |  1 +
>   arch/x86/include/asm/thread_info.h   |  6 +--
>   arch/x86/include/uapi/asm/kvm_para.h |  8 ++--
>   arch/x86/kernel/cpu/intel.c          | 59 ++++++++++++++++-------
>   arch/x86/kernel/kvm.c                |  3 ++
>   arch/x86/kernel/process.c            |  2 +-
>   arch/x86/kvm/cpuid.c                 |  6 +++
>   arch/x86/kvm/vmx/vmx.c               | 72 +++++++++++++++++++++++++---
>   arch/x86/kvm/vmx/vmx.h               |  3 ++
>   arch/x86/kvm/x86.c                   |  6 ++-
>   arch/x86/kvm/x86.h                   |  7 +++
>   13 files changed, 196 insertions(+), 41 deletions(-)
> 

