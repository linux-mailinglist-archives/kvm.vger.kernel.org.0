Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04D256EA74D
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 11:41:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230506AbjDUJlj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 05:41:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbjDUJlh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 05:41:37 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 050E8AD24
        for <kvm@vger.kernel.org>; Fri, 21 Apr 2023 02:40:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682070053; x=1713606053;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=aPqOxhsjpGgsxi9z2kgOy/dMNtBfiT11OkD4z5wk/vE=;
  b=D6XP7y+ufiwWx0k86PJBDDWTxdZ0a4uvZ15Wc3nX1aRI8TWmhYTCmgUe
   ngzGL0ofQPfiP7+6XvseieVw+YVW/u4XrJAxr7sjjNJpCzTSmUiPu47Hq
   01+ET6wpgbtB5QhIXw4tPIMTPJAPEPp3MxNeCyFXWX90Zpwc3Xg0NmAmT
   WJ+gI6hch0LWRbqU4pfszuQKrIHIzhL3HB+1Q1Fl7pCbDp/65jwUGhwZZ
   Zz09HVNY+85XWRyyKU89jWRqgg7pf1IJg55x0RLb6Rs+gnthpOYiRGLNW
   aPJ4pQyZinPzD7RkmgZ+oXg55z0Uto9L5KC5e5C0Eyksj/yN1oxFBzCdh
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="343444640"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="343444640"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2023 02:40:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="938421875"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="938421875"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.254.214.158]) ([10.254.214.158])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2023 02:40:50 -0700
Message-ID: <759238a2-146d-6c26-2d61-378df75a763f@linux.intel.com>
Date:   Fri, 21 Apr 2023 17:40:48 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v7 0/5] Linear Address Masking (LAM) KVM Enabling
To:     kvm@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com
Cc:     kai.huang@intel.com, chao.gao@intel.com, xuelian.guo@intel.com,
        robert.hu@linux.intel.com
References: <20230404130923.27749-1-binbin.wu@linux.intel.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20230404130923.27749-1-binbin.wu@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Gentle ping on the patch series.

Best regards,
Binbin

On 4/4/2023 9:09 PM, Binbin Wu wrote:
> ===Feature Introduction===
>
> Linear-address masking (LAM) [1], modifies the checking that is applied to
> *64-bit* linear addresses, allowing software to use of the untranslated address
> bits for metadata.
>
> When the feature is virtualized and exposed to guest, it can be used for efficient
> address sanitizers (ASAN) implementation and for optimizations in JITs and virtual
> machines.
>
> Regarding which pointer bits are masked and can be used for metadata, LAM has 2
> modes:
> - LAM_48: metadata bits 62:48, i.e. LAM width of 15.
> - LAM_57: metadata bits 62:57, i.e. LAM width of 6.
>
> * For user pointers:
>    CR3.LAM_U57 = CR3.LAM_U48 = 0, LAM is off;
>    CR3.LAM_U57 = 1, LAM57 is active;
>    CR3.LAM_U57 = 0 and CR3.LAM_U48 = 1, LAM48 is active.
> * For supervisor pointers:
>    CR4.LAM_SUP =0, LAM is off;
>    CR4.LAM_SUP =1 with 5-level paging mode, LAM57 is active;
>    CR4.LAM_SUP =1 with 4-level paging mode, LAM48 is active.
>
> The modified LAM canonicality check:
> * LAM_S48                : [ 1 ][ metadata ][ 1 ]
>                               63               47
> * LAM_U48                : [ 0 ][ metadata ][ 0 ]
>                               63               47
> * LAM_S57                : [ 1 ][ metadata ][ 1 ]
>                               63               56
> * LAM_U57 + 5-lvl paging : [ 0 ][ metadata ][ 0 ]
>                               63               56
> * LAM_U57 + 4-lvl paging : [ 0 ][ metadata ][ 0...0 ]
>                               63               56..47
>
> Note:
> 1. LAM applies to only data address, not to instructions.
> 2. LAM identification of an address as user or supervisor is based solely on the
>     value of pointer bit 63 and does not, for the purposes of LAM, depend on the CPL.
> 3. For user mode address, it is possible that 5-level paging and LAM_U48 are both
>     set, in this case, the effective usable linear address width is 48. [2]
> 4. When VM exit, the page faulting linear address saved in VMCS field is clean,
>     i.e. metadata cleared with canonical form.
>
> ===LAM KVM Design===
> LAM KVM enabling includes the following parts:
> - Feature Enumeration
>    LAM feature is enumerated by CPUID.7.1:EAX.LAM[bit 26].
>    If hardware supports LAM and host doesn't disable it explicitly (e.g. via
>    clearcpuid), LAM feature will be exposed to user VMM.
>
> - CR4 Virtualization
>    LAM uses CR4.LAM_SUP (bit 28) to configure LAM masking on supervisor pointers.
>    CR4.LAM_SUP is allowed to be set if vCPU supports LAM, including in nested guest.
>    CR4.LAM_SUP is allowed to be set even not in 64-bit mode, but it will not take
>    effect since LAM only applies to 64-bit linear address.
>    Change of CR4.LAM_SUP bit is intercepted to avoid vmread every time when KVM
>    fetches its value, with the expectation that guest won't toggle the bit frequently.
>    Hardware is not required to do TLB flush when CR4.LAM_SUP toggled, so KVM doesn't
>    need to emulate TLB flush based on it.
>
> - CR3 Virtualization
>    LAM uses CR3.LAM_U48 (bit 62) and CR3.LAM_U57 (bit 61) to configure LAM masking
>    for user mode pointers.
>
>    When EPT is on:
>    CR3 is fully under control of guest, guest LAM is thus transparent to KVM.
>
>    When EPT is off (shadow paging):
>      * KVM needs to handle guest CR3.LAM_U48 and CR3.LAM_U57 toggles.
>        The two bits are allowed to be set in CR3 if vCPU supports LAM.
>        The two bits should be kept as they are in the shadow CR3.
>      * Perform GFN calculation from guest CR3/PGD generically by extracting the
>        maximal base address mask.
>      * Leave LAM bits in root.pgd to force a new root for a CR3+LAM combination.
>      To be generic, introduce a field 'cr3_ctrl_bits' in kvm_vcpu_arch to record
>      the bits used to control supported features related to CR3 (e.g. LAM).
>
> - Modified Canonicality Check and Metadata Mask
>    When LAM is enabled, 64-bit linear address may be tagged with metadata. Linear
>    address should be checked for modified canonicality and untagged (i.e. metadata
>    bits should be masked by sign-extending the bit 47 or bit 56) in instruction
>    emulations and VMExit handlings when LAM is applicable.
>
> LAM inside nested guest is supported by this patch series.
> LAM inside SGX enclave mode is NOT supported by this patch series.
>
> The patch series is based on linux kernel v6.3-rc4, depends on two patches:
> - One from Kiril for LAM feature and flag definitions[3].
> - The other is a bug fix sent out speperatly[4].
>
> The patch series organized as following:
> Patch 1/2: CR4/CR3 virtualization
> Patch 3: Implementation of untag_addr
> Patch 4: Untag address when LAM applicable
> Patch 5: Expose LAM feature to userspace VMM
>
> The corresponding QEMU patch:
> https://lists.gnu.org/archive/html/qemu-devel/2023-02/msg08036.html
>
> ===Unit Test===
> 1. Add a kvm-unit-test [5] for LAM, including LAM_SUP and LAM_{U57,U48}.
>     For supervisor mode, this test covers CR4 LAM_SUP bits toggle, Memory/MMIO
>     access with tagged pointer, and some special instructions (INVLPG, INVPCID,
>     INVVPID), INVVIID cases also used to cover VMX instruction VMExit path.
>     For uer mode, this test covers CR3 LAM bits toggle, Memory/MMIO access with
>     tagged pointer.
>     MMIO cases are used to trigger instruction emulation path.
>     Run the unit test with both LAM feature on/off (i.e. including negative cases).
> 2. Run Kernel LAM kselftests in guest, with both EPT=Y/N.
> 3. Launch a nested guest.
>
> All tests have passed in Simics environment.
>
> [1] Intel ISE https://cdrdv2.intel.com/v1/dl/getContent/671368
>      Chapter Linear Address Masking (LAM)
> [2] Thus currently, LAM kernel enabling patch only enables LAM_U57.
>      https://lore.kernel.org/lkml/20230123220500.21077-1-kirill.shutemov@linux.intel.com/
> [3] https://lore.kernel.org/lkml/20230123220500.21077-4-kirill.shutemov@linux.intel.com/
> [4] https://lore.kernel.org/kvm/20230404032502.27798-1-binbin.wu@linux.intel.com/
> [5] https://lore.kernel.org/kvm/20230319083732.29458-1-binbin.wu@linux.intel.com/
>
> ---
> Changelog
> v6 --> v7:
> - Changes to CR3 virtualization when EPT off
>    * Leave LAM bits in root.pgd to force a new root for a CR3+LAM combination. (Sean)
>    * Perform GFN calculation from guest CR3/PGD generically by extracting the maximal
>      base address mask. (Sean)
> - Remove derefence of ctxt->vcpu in the emulator. (Sean)
> - Fix a bug in v6, which hardcoded "write" to "false" by mistake in linearize(). (Chao Gao)
> - Add Chao Gao's reviwed-by in Patch 5.
> - Add Xuelian Guo's tested-by in the patch set.
> - Seperate cleanup patches from the patch set.
>
> v5 --> v6:
> Add Patch 2 to fix the check of 64-bit mode.
> Add untag_addr() to kvm_x86_ops to hide vendor specific code.
> Simplify the LAM canonicality check per Chao's suggestion.
> Add cr3_ctrl_bits to kvm_vcpu_arch to simplify cr3 invalidation/extract/mask (Chao Gao)
> Extend the patchset scope to include nested virtualization and SGX ENCLS handling.
> - Add X86_CR4_LAM_SUP in cr4_fixed1_update for nested vmx. (Chao Gao)
> - Add SGX ENCLS VMExit handling
> - Add VMX insturction VMExit handling
> More descriptions in cover letter.
> Add Chao's reviwed-by on Patch 4.
> Add more test cases in kvm-unit-test.
>
> v4 --> v5:
> Reorder and melt patches surround CR3.LAM bits into Patch 3 of this
> version.
> Revise Patch 1's subject and description
> Drop Patch 3
> Use kvm_read_cr4_bits() instead of kvm_read_cr4()
> Fix: No need to untag addr when write to msr, it should be legacy canonical check
> Rename kvm_is_valid_cr3() --> kvm_vcpu_is_valid_cr3(), and update some call
> sites of kvm_vcpu_is_valid_cr3() to use kvm_is_valid_cr3().
> Other refactors and Miscs.
>
> v3 --> v4:
> Drop unrelated Patch 1 in v3 (Binbin, Sean, Xiaoyao)
> Intercept CR4.LAM_SUP instead of pass through to guest (Sean)
> Just filter out CR3.LAM_{U48, U57}, instead of all reserved high bits
> (Sean, Yuan)
> Use existing __canonical_address() helper instead write a new one (Weijiang)
> Add LAM handling in KVM emulation (Yu, Yuan)
> Add Jingqi's reviwed-by on Patch 7
> Rebased to Kirill's latest code, which is 6.2-rc1 base.
>
> v2 --> v3:
> As LAM Kernel patches are in tip tree now, rebase to it.
> https://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git/
>
> v1 --> v2:
> 1. Fixes i386-allyesconfig build error on get_pgd(), where
>     CR3_HIGH_RSVD_MASK isn't applicable.
>     (Reported-by: kernel test robot <lkp@intel.com>)
> 2. In kvm_set_cr3(), be conservative on skip tlb flush when only LAM bits
>     toggles. (Kirill)
>
> Binbin Wu (2):
>    KVM: x86: Introduce untag_addr() in kvm_x86_ops
>    KVM: x86: Untag address when LAM applicable
>
> Robert Hoo (3):
>    KVM: x86: Virtualize CR4.LAM_SUP
>    KVM: x86: Virtualize CR3.LAM_{U48,U57}
>    KVM: x86: Expose LAM feature to userspace VMM
>
>   arch/x86/include/asm/kvm-x86-ops.h |  1 +
>   arch/x86/include/asm/kvm_host.h    | 14 +++++-
>   arch/x86/kvm/cpuid.c               |  2 +-
>   arch/x86/kvm/cpuid.h               |  5 +++
>   arch/x86/kvm/emulate.c             | 23 +++++++---
>   arch/x86/kvm/kvm_emulate.h         |  2 +
>   arch/x86/kvm/mmu.h                 |  5 +++
>   arch/x86/kvm/mmu/mmu.c             |  6 ++-
>   arch/x86/kvm/mmu/mmu_internal.h    |  1 +
>   arch/x86/kvm/mmu/paging_tmpl.h     |  6 ++-
>   arch/x86/kvm/mmu/spte.h            |  2 +-
>   arch/x86/kvm/svm/svm.c             |  7 +++
>   arch/x86/kvm/vmx/nested.c          |  8 +++-
>   arch/x86/kvm/vmx/sgx.c             |  1 +
>   arch/x86/kvm/vmx/vmx.c             | 69 +++++++++++++++++++++++++++++-
>   arch/x86/kvm/vmx/vmx.h             |  2 +
>   arch/x86/kvm/x86.c                 | 14 +++++-
>   arch/x86/kvm/x86.h                 |  2 +
>   18 files changed, 155 insertions(+), 15 deletions(-)
>
>
> base-commit: 197b6b60ae7bc51dd0814953c562833143b292aa
> prerequisite-patch-id: 883dc8f73520b47a6c3690c1704f2e85a2713e4f
> prerequisite-patch-id: cf5655ce89a2390cd29f33c57a4fc307a6045f62
