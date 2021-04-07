Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 823BB357843
	for <lists+kvm@lfdr.de>; Thu,  8 Apr 2021 01:08:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbhDGXIl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 19:08:41 -0400
Received: from mga11.intel.com ([192.55.52.93]:17067 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229460AbhDGXIk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Apr 2021 19:08:40 -0400
IronPort-SDR: B+Dyx+YO5AsOEipP30BeWxze4YzXdoHVsStRImhYcKchRCgAxqs35PaO2mYkDN8drSmys44D2S
 PCt8TTXJ1FNw==
X-IronPort-AV: E=McAfee;i="6000,8403,9947"; a="190210375"
X-IronPort-AV: E=Sophos;i="5.82,204,1613462400"; 
   d="scan'208";a="190210375"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2021 16:08:29 -0700
IronPort-SDR: hStFPeCgbJk4r/aUIlTY7MJQELyHan1TrMB858f8ZSh9MigJ9FHXURGmupxHvlv5DWR5CM0osb
 jElOjbivFA4w==
X-IronPort-AV: E=Sophos;i="5.82,204,1613462400"; 
   d="scan'208";a="415479328"
Received: from tkokeray-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.113.100])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2021 16:08:26 -0700
Date:   Thu, 8 Apr 2021 11:08:24 +1200
From:   Kai Huang <kai.huang@intel.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     <kvm@vger.kernel.org>, <linux-sgx@vger.kernel.org>,
        <seanjc@google.com>, <pbonzini@redhat.com>, <bp@alien8.de>,
        <jarkko@kernel.org>, <dave.hansen@intel.com>, <luto@kernel.org>,
        <rick.p.edgecombe@intel.com>, <haitao.huang@intel.com>
Subject: Re: [PATCH v4 00/11] KVM SGX virtualization support (KVM part)
Message-Id: <20210408110824.555ffa5eb664fb5efffab070@intel.com>
In-Reply-To: <cover.1617825858.git.kai.huang@intel.com>
References: <cover.1617825858.git.kai.huang@intel.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 8 Apr 2021 08:49:24 +1200 Kai Huang wrote:
> Hi Paolo, Sean,
> 
> Boris has merged x86 part patches to the tip/x86/sgx. This series is KVM part
> patches. Due to some code change in x86 part patches, two KVM patches need
> update so this is the new version. Please help to review. Thanks!
> 
> Specifically, x86 patch (x86/sgx: Add helpers to expose ECREATE and EINIT to
> KVM) was changed to return -EINVAL directly w/o setting trapnr when 
> access_ok()s fail on any user pointers, so KVM patches:
> 
> KVM: VMX: Add SGX ENCLS[ECREATE] handler to enforce CPUID restrictions
> KVM: VMX: Add ENCLS[EINIT] handler to support SGX Launch Control (LC)
> 
> were updated to handle this case.
> 
> This seris is still based on tip/x86/sgx (which is based on 5.12-rc3), since it
> requires x86 patches to work. I tried to rebase them to latest kvm/queue, but
> found patch 
> 
> KVM: VMX: Add SGX ENCLS[ECREATE] handler to enforce CPUID restrictions
> KVM: x86: Add capability to grant VM access to privileged SGX aattribute
> 
> have merge conflict, but the conflict is quite easy to resolve, so I didn't sent
> out the resolved version. Please let me know how would you like to proceed.

Hi Paolo, Sean,

Be more specifically, the first merge conflict is in patch (KVM: VMX: Add
emulation of SGX Launch Control LE hash MSRs) (sorry I made a mistake about
which patch above). The new added msr_ia32_sgxlepubkeyhash[4] to struct
vcpu_vmx{} conflicts with hyperv's hv_root_ept:

++<<<<<<< HEAD
 +#if IS_ENABLED(CONFIG_HYPERV)
 +      u64 hv_root_ept;
 +#endif
++=======
+       /* SGX Launch Control public key hash */
+       u64 msr_ia32_sgxlepubkeyhash[4];
+       u64 ept_pointer;
++>>>>>>> ebe348a4bbc1 (KVM: VMX: Add emulation of SGX Launch Control LE hash
MSRs)

The second conflict is the last patch (KVM: x86: Add capability to grant VM
access to privileged SGX aattribute), due to new added
KVM_CAP_VM_COPY_ENC_CONTEXT_FROM capability conflicts with
KVM_CAP_SGX_ATTRIBUTE.

They are both easy to resolve.

For the next version, I think I can do:

1) grab SGX x86 part patches from tip/x86/sgx, and rebase all patches to
kvm/queue (basically rebase tip/x86/sgx to kvm/queue + new KVM patches), and
send out the rebased patches.
2) Still base on existing tip/x86/sgx, and let you to handle merge conflict.

Which way do you prefer? Do you have any other suggestions?

> 
> Thank you all guys!
> 
> Sean Christopherson (11):
>   KVM: x86: Export kvm_mmu_gva_to_gpa_{read,write}() for SGX (VMX)
>   KVM: x86: Define new #PF SGX error code bit
>   KVM: x86: Add support for reverse CPUID lookup of scattered features
>   KVM: x86: Add reverse-CPUID lookup support for scattered SGX features
>   KVM: VMX: Add basic handling of VM-Exit from SGX enclave
>   KVM: VMX: Frame in ENCLS handler for SGX virtualization
>   KVM: VMX: Add SGX ENCLS[ECREATE] handler to enforce CPUID restrictions
>   KVM: VMX: Add emulation of SGX Launch Control LE hash MSRs
>   KVM: VMX: Add ENCLS[EINIT] handler to support SGX Launch Control (LC)
>   KVM: VMX: Enable SGX virtualization for SGX1, SGX2 and LC
>   KVM: x86: Add capability to grant VM access to privileged SGX
>     attribute
> 
>  Documentation/virt/kvm/api.rst  |  23 ++
>  arch/x86/include/asm/kvm_host.h |   5 +
>  arch/x86/include/asm/vmx.h      |   1 +
>  arch/x86/include/uapi/asm/vmx.h |   1 +
>  arch/x86/kvm/Makefile           |   2 +
>  arch/x86/kvm/cpuid.c            |  89 +++++-
>  arch/x86/kvm/cpuid.h            |  50 +++-
>  arch/x86/kvm/vmx/nested.c       |  28 +-
>  arch/x86/kvm/vmx/nested.h       |   5 +
>  arch/x86/kvm/vmx/sgx.c          | 500 ++++++++++++++++++++++++++++++++
>  arch/x86/kvm/vmx/sgx.h          |  34 +++
>  arch/x86/kvm/vmx/vmcs12.c       |   1 +
>  arch/x86/kvm/vmx/vmcs12.h       |   4 +-
>  arch/x86/kvm/vmx/vmx.c          | 109 ++++++-
>  arch/x86/kvm/vmx/vmx.h          |   2 +
>  arch/x86/kvm/x86.c              |  23 ++
>  include/uapi/linux/kvm.h        |   1 +
>  17 files changed, 855 insertions(+), 23 deletions(-)
>  create mode 100644 arch/x86/kvm/vmx/sgx.c
>  create mode 100644 arch/x86/kvm/vmx/sgx.h
> 
> -- 
> 2.30.2
> 
