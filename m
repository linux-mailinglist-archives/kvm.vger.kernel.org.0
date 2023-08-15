Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41E2677C596
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 04:06:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234060AbjHOCGE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Aug 2023 22:06:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjHOCFw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Aug 2023 22:05:52 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B03E410F9;
        Mon, 14 Aug 2023 19:05:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692065150; x=1723601150;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=kOhEq5j6ZpVqxpqEhNJFGC3hZkEQkwoE6LRvKcKDsZA=;
  b=dXqygv7OtaCFISKTcEeTXNkRlzzNTtIYfEakIvflOYK7tWTOMs8Qo9/M
   7y5o7ODJU6ug/IkebuGFqocVjgLAJw2KrMfbFHrX9ihttY62wuNSFVR3C
   pqzBXBnmyIEHgoVMDjeyjtbCx4PnezR2ySlrwCnB/cNN+gRQPGX0ws82I
   1IZ1Vkt5lCORqvQLrQbU/b+Y9ufJ6kC1dRdElr7K2B9Q+NYCRTHj+HRjc
   dm12WF4t4g7g5xcI5qAhshZ5ZSlA/jv+uKBj1v+Bg2JQlXt6ipp1iJoYI
   Igp92LSgB4ngAcPD7+l8wpppDMgRVlNMmIGfhBSJozIKQFmqKJ0ciZdYl
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10802"; a="372176526"
X-IronPort-AV: E=Sophos;i="6.01,173,1684825200"; 
   d="scan'208";a="372176526"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2023 19:05:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10802"; a="823678580"
X-IronPort-AV: E=Sophos;i="6.01,173,1684825200"; 
   d="scan'208";a="823678580"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.10.52]) ([10.238.10.52])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2023 19:05:48 -0700
Message-ID: <6adf6bdd-4ba5-991e-9547-deec36819898@linux.intel.com>
Date:   Tue, 15 Aug 2023 10:05:45 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [PATCH v10 0/9] Linear Address Masking (LAM) KVM Enabling
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, chao.gao@intel.com,
        kai.huang@intel.com, David.Laight@ACULAB.COM,
        robert.hu@linux.intel.com, guang.zeng@intel.com
References: <20230719144131.29052-1-binbin.wu@linux.intel.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20230719144131.29052-1-binbin.wu@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Gentle ping.


On 7/19/2023 10:41 PM, Binbin Wu wrote:
> ===Feature Introduction===
>
> Linear-address masking (LAM) [1], modifies the checking that is applied to
> *64-bit* linear addresses, allowing software to use of the untranslated address
> bits for metadata and masks the metadata bits before using them as linear
> addresses to access memory.
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
>     value of pointer bit 63 and does not depend on the CPL.
> 3. LAM doesn't apply to the writes to control registers or MSRs.
> 4. LAM masking applies before paging, so the faulting linear address in CR2
>     doesn't contain the metadata.
> 5  The guest linear address saved in VMCS doesn't contain metadata.
> 6. For user mode address, it is possible that 5-level paging and LAM_U48 are both
>     set, in this case, the effective usable linear address width is 48.
>     (Currently, only LAM_U57 is enabled in Linux kernel. [2])
>
> ===LAM KVM Design===
> LAM KVM enabling includes the following parts:
> - Feature Enumeration
>    LAM feature is enumerated by CPUID.7.1:EAX.LAM[bit 26].
>    If hardware supports LAM and host doesn't disable it explicitly (e.g. via
>    clearcpuid), LAM feature will be exposed to user VMM.
>
> - CR4 Virtualization
>    LAM uses CR4.LAM_SUP (bit 28) to configure LAM on supervisor pointers.
>    Add support to allow guests to set the new CR4 control bit for guests to enable
>    LAM on supervisor pointers.
>
> - CR3 Virtualization
>    LAM uses CR3.LAM_U48 (bit 62) and CR3.LAM_U57 (bit 61) to configure LAM on user
>    pointers.
>    Add support to allow guests to set two new CR3 non-address control bits for
>    guests to enable LAM on user pointers.
>
> - Modified Canonicality Check and Metadata Mask
>    When LAM is enabled, 64-bit linear address may be tagged with metadata. Linear
>    address should be checked for modified canonicality and untagged in instruction
>    emulations and VMExit handlers when LAM is applicable.
>
> LAM support in SGX enclave mode needs additional enabling and is not
> included in this patch series.
>
> This patch series depends on "governed" X86_FEATURE framework from Sean.
> https://lore.kernel.org/kvm/20230217231022.816138-2-seanjc@google.com/
>
> This patch series depends on the patches of refactor of instruction emulation flags,
> using flags to identify the access type of instructions, sent along with LASS patch series.
> https://lore.kernel.org/kvm/20230719024558.8539-2-guang.zeng@intel.com/
> https://lore.kernel.org/kvm/20230719024558.8539-3-guang.zeng@intel.com/
> https://lore.kernel.org/kvm/20230719024558.8539-4-guang.zeng@intel.com/
> https://lore.kernel.org/kvm/20230719024558.8539-5-guang.zeng@intel.com/
>
>
> LAM QEMU patch:
> https://lists.nongnu.org/archive/html/qemu-devel/2023-05/msg07843.html
>
> LAM kvm-unit-tests patch:
> https://lore.kernel.org/kvm/20230530024356.24870-1-binbin.wu@linux.intel.com/
>
> ===Test===
> 1. Add test cases in kvm-unit-test [3] for LAM, including LAM_SUP and LAM_{U57,U48}.
>     For supervisor pointers, the test covers CR4 LAM_SUP bits toggle, Memory/MMIO
>     access with tagged pointer, and some special instructions (INVLPG, INVPCID,
>     INVVPID), INVVPID cases also used to cover VMX instruction VMExit path.
>     For uer pointers, the test covers CR3 LAM bits toggle, Memory/MMIO access with
>     tagged pointer.
>     MMIO cases are used to trigger instruction emulation path.
>     Run the unit test with both LAM feature on/off (i.e. including negative cases).
>     Run the unit test in L1 guest with both LAM feature on/off.
> 2. Run Kernel LAM kselftests [2] in guest, with both EPT=Y/N.
> 3. Launch a nested guest.
>
> All tests have passed in Simics environment.
>
> [1] Intel ISE https://cdrdv2.intel.com/v1/dl/getContent/671368
>      Chapter Linear Address Masking (LAM)
> [2] https://lore.kernel.org/all/20230312112612.31869-9-kirill.shutemov@linux.intel.com/
> [3] https://lore.kernel.org/kvm/20230530024356.24870-1-binbin.wu@linux.intel.com/
>
> ---
> Changelog
> v10:
> - Split out the patch "Use GENMASK_ULL() to define __PT_BASE_ADDR_MASK". [Sean]
> - Split out the patch "Add & use kvm_vcpu_is_legal_cr3() to check CR3's legality". [Sean]
> - Use "KVM-governed feature framework" to track if guest can use LAM. [Sean]
> - Use emulation flags to describe the access instead of making the flag a command. [Sean]
> - Split the implementation of vmx_get_untagged_addr() for LAM from emulator and kvm_x86_ops definition. [Per Sean's comment for LASS]
> - Some improvement of implementation in vmx_get_untagged_addr(). [Sean]
>
> v9:
> https://lore.kernel.org/kvm/20230606091842.13123-1-binbin.wu@linux.intel.com/
>
> Binbin Wu (7):
>    KVM: x86/mmu: Use GENMASK_ULL() to define __PT_BASE_ADDR_MASK
>    KVM: x86: Add & use kvm_vcpu_is_legal_cr3() to check CR3's legality
>    KVM: x86: Use KVM-governed feature framework to track "LAM enabled"
>    KVM: x86: Virtualize CR3.LAM_{U48,U57}
>    KVM: x86: Introduce get_untagged_addr() in kvm_x86_ops and call it in
>      emulator
>    KVM: VMX: Implement and wire get_untagged_addr() for LAM
>    KVM: x86: Untag address for vmexit handlers when LAM applicable
>
> Robert Hoo (2):
>    KVM: x86: Virtualize CR4.LAM_SUP
>    KVM: x86: Expose LAM feature to userspace VMM
>
>   arch/x86/include/asm/kvm-x86-ops.h |  1 +
>   arch/x86/include/asm/kvm_host.h    |  5 +++-
>   arch/x86/kvm/cpuid.c               |  2 +-
>   arch/x86/kvm/cpuid.h               |  8 ++++++
>   arch/x86/kvm/emulate.c             |  2 +-
>   arch/x86/kvm/governed_features.h   |  2 ++
>   arch/x86/kvm/kvm_emulate.h         |  3 +++
>   arch/x86/kvm/mmu.h                 |  8 ++++++
>   arch/x86/kvm/mmu/mmu.c             |  2 +-
>   arch/x86/kvm/mmu/mmu_internal.h    |  1 +
>   arch/x86/kvm/mmu/paging_tmpl.h     |  2 +-
>   arch/x86/kvm/svm/nested.c          |  4 +--
>   arch/x86/kvm/vmx/nested.c          |  6 +++--
>   arch/x86/kvm/vmx/sgx.c             |  1 +
>   arch/x86/kvm/vmx/vmx.c             | 43 +++++++++++++++++++++++++++++-
>   arch/x86/kvm/vmx/vmx.h             |  2 ++
>   arch/x86/kvm/x86.c                 | 15 +++++++++--
>   arch/x86/kvm/x86.h                 |  2 ++
>   18 files changed, 97 insertions(+), 12 deletions(-)
>
>
> base-commit: fdf0eaf11452d72945af31804e2a1048ee1b574c
> prerequisite-patch-id: 3467bc611ce3774ba481ab72e187eba47000c01b
> prerequisite-patch-id: 1bf4c9da384b39c92c21c467a5c6ed0d306ec266
> prerequisite-patch-id: 226fd3d9a09ef80a5b8001a3bdc6fbf2c23d2a88
> prerequisite-patch-id: 0c31cc0dec011d7e22efde1f7dde9847c86024d8
> prerequisite-patch-id: f487db8bc77007679f4b0e670a9e487c1f63fcfe

