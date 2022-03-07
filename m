Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62E354CF1A8
	for <lists+kvm@lfdr.de>; Mon,  7 Mar 2022 07:09:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234145AbiCGGKj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Mar 2022 01:10:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232119AbiCGGKi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Mar 2022 01:10:38 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 796401CFFA;
        Sun,  6 Mar 2022 22:09:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646633384; x=1678169384;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=vTvCJC12tOY0Rg3fomaST4NiFG83EXsDZ5ajgyCHhlQ=;
  b=bm2Lmrpk9+HVgLWrDSr5b4vrQpjFBpfqNzDFEUrb+p2y9jDmuJOem56h
   ZYXdicKIniKcDuJSdODy8JtD82UlQz1YkNQCYunBoF1F+8zzCwyZCF6Bb
   VuRxPPaeUoOp4Nh2TFhIEQBiGEWdbT12AYCJyC7l8psSquNM0unUwGti0
   xFJ0ZZhUWDnfGkbLzQzRa/ZwxDbzUvW3z/SfdgoGMZmWVj2s1xMz5cgUs
   lzQy5lYAe3t9pCfhOqMSUIWamzrIdTVLiNnavOG4riTxDnkzGCJnl5nf8
   xUTJhrzlOK/FKDdVK93NmH+71anBig4GgHBwxR/4D+sHEOebZuwTIgWxo
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10278"; a="251886040"
X-IronPort-AV: E=Sophos;i="5.90,161,1643702400"; 
   d="scan'208";a="251886040"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2022 22:09:44 -0800
X-IronPort-AV: E=Sophos;i="5.90,161,1643702400"; 
   d="scan'208";a="536981981"
Received: from cqiang-mobl.ccr.corp.intel.com (HELO [10.249.173.92]) ([10.249.173.92])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2022 22:09:40 -0800
Message-ID: <ca4a728c-6ec0-afab-935c-b45d73f6fc9c@intel.com>
Date:   Mon, 7 Mar 2022 14:09:34 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.6.1
Subject: Re: [PATCH v6 0/7] KVM: PKS Virtualization support
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220221080840.7369-1-chenyi.qiang@intel.com>
From:   Chenyi Qiang <chenyi.qiang@intel.com>
In-Reply-To: <20220221080840.7369-1-chenyi.qiang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Kindly ping for comments.

On 2/21/2022 4:08 PM, Chenyi Qiang wrote:
> This patch series is based on top of v8 PKS core support kernel patchset:
> https://lore.kernel.org/lkml/20220127175505.851391-1-ira.weiny@intel.com/
> 
> Note: If you read the SDM section 4.6.1 and has some confusion about the
> statement of Data writes to supervisor-mode address:
> 
>    If CR0.WP = 0, data may be written to any supervisor-mode address with
>    a protection key for which write access is permitted.
> 
> Which may seems a little conflict with 4.6.2:
> 
>    if WDi = 1, write accesses are not permitted if CR0.WP = 1. (If CR0.WP
>    = 0, IA32_PKRS.WDi does not affect write accesses to supervisor-mode
>    address with protection key i.)
> 
> In fact, the statement in 4.6.1 doesn't say "a protection key with the
> appropriate WDi bit set." The reader should instead refer to Section
> 4.6.2 to find the definition of what that means. We will follow up
> this with someone internally to make it more clear in SDM.
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
> ---
> 
> Changelogs:
> 
> v5->v6
> - PKRS is preserved on INIT. Add the PKRS reset operation in kvm_vcpu_reset.
>    (Sean)
> - Track the pkrs as u32. Add the code WARN on bits 64:32 being set in VMCS field.
>    (Sean)
> - Adjust the MSR intercept and entry/exit control in VMCS according to
>    guest CPUID. This resolve the issue when userspace re-enable this feature.
>    (Sean)
> - Split VMX restriction on PKS support(entry/exit load controls) out of
>    common x86. And put tdp restriction together with PKU in common x86.
>    (Sean)
> - Thanks for Sean to revise the comments in mmu.c related to
>    update_pkr_bitmap, which make it more clear for pkr bitmask cache usage.
> - v5: https://lore.kernel.org/lkml/20210811101126.8973-1-chenyi.qiang@intel.com/
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
>   arch/x86/include/asm/kvm_host.h |  17 ++++--
>   arch/x86/include/asm/vmx.h      |   6 ++
>   arch/x86/kvm/cpuid.c            |  13 ++--
>   arch/x86/kvm/kvm_cache_regs.h   |   7 +++
>   arch/x86/kvm/mmu.h              |  27 +++++----
>   arch/x86/kvm/mmu/mmu.c          | 101 ++++++++++++++++++++------------
>   arch/x86/kvm/vmx/capabilities.h |   6 ++
>   arch/x86/kvm/vmx/nested.c       |  38 +++++++++++-
>   arch/x86/kvm/vmx/vmcs.h         |   1 +
>   arch/x86/kvm/vmx/vmcs12.c       |   2 +
>   arch/x86/kvm/vmx/vmcs12.h       |   4 ++
>   arch/x86/kvm/vmx/vmx.c          |  92 ++++++++++++++++++++++++++---
>   arch/x86/kvm/vmx/vmx.h          |   7 ++-
>   arch/x86/kvm/x86.c              |  10 +++-
>   arch/x86/kvm/x86.h              |   8 +++
>   arch/x86/mm/pkeys.c             |   6 ++
>   include/linux/pkeys.h           |   6 ++
>   17 files changed, 280 insertions(+), 71 deletions(-)
> 
