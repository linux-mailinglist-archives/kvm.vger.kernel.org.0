Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0D0E51D25C
	for <lists+kvm@lfdr.de>; Fri,  6 May 2022 09:33:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1389587AbiEFHgt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 May 2022 03:36:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1389578AbiEFHgq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 May 2022 03:36:46 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C397F5D674;
        Fri,  6 May 2022 00:33:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651822384; x=1683358384;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=euQgzXLvQn3ayr8FKlpHcWJ7WQxDjNlbVam+n9glxV8=;
  b=USd4NKvkoN6ul5/jJCB3xE8MvcY8qnyzTDRwf0pg4tzzHT4qAHlV6kIp
   j6TPHmlB+4q7EcdA07qtaKJrBpmN6U35yWuIGmxh9cvM3MUaioSW3pbi2
   PF1scHhpAy+j6m/Sk0LyBw96F6RMKg57Q1eBBUYxrHLRpkORQcIix6mjq
   LKu256MFAEJIikLiFFIunwZg9u4mIrEW5HT4CiWrvfflH2TXlLwkgpgeB
   CLPD1encdwDqZXhfjTG6MxblOh3emS4SMhhLvjcCSfsdRGTj6Dmw6SOPv
   vCNmi3ToUCriCjpOnZKJCO31R0RDjKj/8UeVS+/unm+VFuK9yU8kdfytq
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10338"; a="248288564"
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="248288564"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2022 00:33:04 -0700
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="537758197"
Received: from leiwang7-mobl.ccr.corp.intel.com (HELO [10.254.213.160]) ([10.254.213.160])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2022 00:33:01 -0700
Message-ID: <db8b2633-374f-6845-aa7f-b009c5b4933c@intel.com>
Date:   Fri, 6 May 2022 15:32:58 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.8.1
Subject: Re: [PATCH v7 0/8] KVM: PKS Virtualization support
Content-Language: en-US
To:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org
Cc:     chenyi.qiang@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220424101557.134102-1-lei4.wang@intel.com>
From:   "Wang, Lei" <lei4.wang@intel.com>
In-Reply-To: <20220424101557.134102-1-lei4.wang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Kindly ping for the comments.

On 4/24/2022 6:15 PM, Lei Wang wrote:
> This patch series is based on top of v10 PKS core support kernel patchset:
> https://lore.kernel.org/lkml/20220419170649.1022246-1-ira.weiny@intel.com/
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
> v6->v7
> - Add documentation to note that it's nice-to-have cache tracking for PKRS,
>    and we also needn't hesitate to rip it out in the future if there's a strong
>    reason to drop the caching. (Sean)
> - Blindly reading PKRU/PKRS is wrong, fixed. (Sean)
> - Add a non-inline helper kvm_mmu_pkr_bits() to read PKR bits. (Sean)
> - Delete the comment for exposing the PKS because the pattern is common and the
>    behavior is self-explanatory. (Sean)
> - Add a helper vmx_set_host_pkrs() for setting host pkrs and rewrite the
>    related code for concise. (Sean)
> - Align an indentation in arch/x86/kvm/vmx/nested.c. (Sean)
> - Read the current PKRS if from_vmentry == false under the nested condition.
>    (Sean)
> - v6: https://lore.kernel.org/lkml/20220221080840.7369-1-chenyi.qiang@intel.com/
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
> Lei Wang (1):
>    KVM: MMU: Add helper function to get pkr bits
>
>   arch/x86/include/asm/kvm_host.h |  17 +++--
>   arch/x86/include/asm/vmx.h      |   6 ++
>   arch/x86/kvm/cpuid.c            |  13 +++-
>   arch/x86/kvm/kvm_cache_regs.h   |   7 ++
>   arch/x86/kvm/mmu.h              |  29 +++----
>   arch/x86/kvm/mmu/mmu.c          | 130 +++++++++++++++++++++++---------
>   arch/x86/kvm/vmx/capabilities.h |   6 ++
>   arch/x86/kvm/vmx/nested.c       |  36 ++++++++-
>   arch/x86/kvm/vmx/vmcs.h         |   1 +
>   arch/x86/kvm/vmx/vmcs12.c       |   2 +
>   arch/x86/kvm/vmx/vmcs12.h       |   4 +
>   arch/x86/kvm/vmx/vmx.c          |  85 +++++++++++++++++++--
>   arch/x86/kvm/vmx/vmx.h          |  14 +++-
>   arch/x86/kvm/x86.c              |   9 ++-
>   arch/x86/kvm/x86.h              |   8 ++
>   arch/x86/mm/pkeys.c             |   6 ++
>   include/linux/pks.h             |   7 ++
>   17 files changed, 301 insertions(+), 79 deletions(-)
>
