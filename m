Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 463823F804B
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 04:04:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236968AbhHZCFf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Aug 2021 22:05:35 -0400
Received: from mga01.intel.com ([192.55.52.88]:8789 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236103AbhHZCFf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Aug 2021 22:05:35 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10087"; a="239841228"
X-IronPort-AV: E=Sophos;i="5.84,352,1620716400"; 
   d="scan'208";a="239841228"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2021 19:04:44 -0700
X-IronPort-AV: E=Sophos;i="5.84,352,1620716400"; 
   d="scan'208";a="527568030"
Received: from cqiang-mobl.ccr.corp.intel.com (HELO [10.238.0.162]) ([10.238.0.162])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2021 19:04:42 -0700
Subject: Re: [PATCH v5 0/7] KVM: PKS Virtualization support
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210811101126.8973-1-chenyi.qiang@intel.com>
From:   Chenyi Qiang <chenyi.qiang@intel.com>
Message-ID: <90935936-4e5a-ad28-84b7-a38f6e642543@intel.com>
Date:   Thu, 26 Aug 2021 10:04:40 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210811101126.8973-1-chenyi.qiang@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ping for comments.

One thing to pay attention:
The previous statement was incorrect – PKRS should be preserved on INIT, 
not cleared.


On 8/11/2021 6:11 PM, Chenyi Qiang wrote:
> This patch series is based on top of kernel patchset:
> https://lore.kernel.org/lkml/20210804043231.2655537-1-ira.weiny@intel.com/
> 
> To help patches review, one missing info in SDM is that PKSR will be
> cleared on Powerup/INIT/RESET, which should be listed in Table 9.1
> "IA-32 and Intel 64 Processor States Following Power-up, Reset, or INIT"
> 
> ---
> 
> Protection Keys for Supervisor Pages(PKS) is a feature that extends the
> Protection Keys architecture to support thread-specific permission
> restrictions on supervisor pages.
> 
> PKS works similar to an existing feature named PKU(protecting user pages).
> They both perform an additional check after normal paging permission
> checks are done. Access or Writes can be disabled via a MSR update
> without TLB flushes when permissions changes. If violating this
> addional check, #PF occurs and PFEC.PK bit will be set.
> 
> PKS introduces MSR IA32_PKRS to manage supervisor protection key
> rights. The MSR contains 16 pairs of ADi and WDi bits. Each pair
> advertises on a group of pages with the same key which is set in the
> leaf paging-structure entries(bits[62:59]). Currently, IA32_PKRS is not
> supported by XSAVES architecture.
> 
> This patchset aims to add the virtualization of PKS in KVM. It
> implemented PKS CPUID enumeration, vmentry/vmexit configuration, MSR
> exposure, nested supported etc. Currently, PKS is not yet supported for
> shadow paging.
> 
> Detailed information about PKS can be found in the latest Intel 64 and
> IA-32 Architectures Software Developer's Manual.
> 
> 
> ---
> 
> Changelogs:
> 
> v4->v5
> - Make setting of MSR intercept/vmcs control bits not dependent on guest.CR4.PKS.
>    And set them if PKS is exposed to guest. (Suggested by Sean)
> - Add pkrs to standard register caching mechanism to help update
>    vcpu->arch.pkrs on demand. Add related helper functions. (Suggested by Sean)
> - Do the real pkrs update in VMCS field in vmx_vcpu_reset and
>    vmx_sync_vmcs_host_state(). (Sean)
> - Add a new mmu_role cr4_pks instead of smushing PKU and PKS together.
>    (Sean & Paolo)
> - v4: https://lore.kernel.org/lkml/20210205083706.14146-1-chenyi.qiang@intel.com/
> 
> v3->v4
> - Make the MSR intercept and load-controls setting depend on CR4.PKS value
> - shadow the guest pkrs and make it usable in PKS emultion
> - add the cr4_pke and cr4_pks check in pkr_mask update
> - squash PATCH 2 and PATCH 5 to make the dependencies read more clear
> - v3: https://lore.kernel.org/lkml/20201105081805.5674-1-chenyi.qiang@intel.com/
> 
> v2->v3:
> - No function changes since last submit
> - rebase on the latest PKS kernel support:
>    https://lore.kernel.org/lkml/20201102205320.1458656-1-ira.weiny@intel.com/
> - add MSR_IA32_PKRS to the vmx_possible_passthrough_msrs[]
> - RFC v2: https://lore.kernel.org/lkml/20201014021157.18022-1-chenyi.qiang@intel.com/
> 
> v1->v2:
> - rebase on the latest PKS kernel support:
>    https://github.com/weiny2/linux-kernel/tree/pks-rfc-v3
> - add a kvm-unit-tests for PKS
> - add the check in kvm_init_msr_list for PKRS
> - place the X86_CR4_PKS in mmu_role_bits in kvm_set_cr4
> - add the support to expose VM_{ENTRY, EXIT}_LOAD_IA32_PKRS in nested
>    VMX MSR
> - RFC v1: https://lore.kernel.org/lkml/20200807084841.7112-1-chenyi.qiang@intel.com/
> 
> ---
> 
> Chenyi Qiang (7):
>    KVM: VMX: Introduce PKS VMCS fields
>    KVM: VMX: Add proper cache tracking for PKRS
>    KVM: X86: Expose IA32_PKRS MSR
>    KVM: MMU: Rename the pkru to pkr
>    KVM: MMU: Add support for PKS emulation
>    KVM: VMX: Expose PKS to guest
>    KVM: VMX: Enable PKS for nested VM
> 
>   arch/x86/include/asm/kvm_host.h | 17 ++++---
>   arch/x86/include/asm/vmx.h      |  6 +++
>   arch/x86/kvm/cpuid.c            |  2 +-
>   arch/x86/kvm/kvm_cache_regs.h   |  7 +++
>   arch/x86/kvm/mmu.h              | 25 +++++----
>   arch/x86/kvm/mmu/mmu.c          | 68 ++++++++++++++-----------
>   arch/x86/kvm/vmx/capabilities.h |  6 +++
>   arch/x86/kvm/vmx/nested.c       | 41 ++++++++++++++-
>   arch/x86/kvm/vmx/vmcs.h         |  1 +
>   arch/x86/kvm/vmx/vmcs12.c       |  2 +
>   arch/x86/kvm/vmx/vmcs12.h       |  4 ++
>   arch/x86/kvm/vmx/vmx.c          | 89 ++++++++++++++++++++++++++++++---
>   arch/x86/kvm/vmx/vmx.h          |  7 ++-
>   arch/x86/kvm/x86.c              |  6 ++-
>   arch/x86/kvm/x86.h              |  8 +++
>   arch/x86/mm/pkeys.c             |  6 +++
>   include/linux/pkeys.h           |  5 ++
>   17 files changed, 243 insertions(+), 57 deletions(-)
> 
