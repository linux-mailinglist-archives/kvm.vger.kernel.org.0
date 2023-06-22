Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA3CC73AD08
	for <lists+kvm@lfdr.de>; Fri, 23 Jun 2023 01:17:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbjFVXRY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jun 2023 19:17:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231592AbjFVXRU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Jun 2023 19:17:20 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C3F813E;
        Thu, 22 Jun 2023 16:17:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687475831; x=1719011831;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=wII/YgahFD6pOu/PD+x55CaQ2xydlhbyXI2dGgWNIAI=;
  b=IvDwR9GMGrYuefhI8O1kABtJZcJcQmBTnwsBzsyiF540/9RAdIBA4hfk
   0qPaSss9fEUn+nD1eAIh/yUQa79buaSBp2HPWvnzzyCC3LqqlY9MtBMp4
   Grh6QE3fPfnDB6WfXT/BYCFQhnTDvYkFyp9yz2zvypS5p7HKaaFYOipn4
   MahQTeFtWMF5qUbdZqT44ptBpsfCa/tp40BECehc3Xn+P0mvb6osHfTDQ
   ks28iaJkdXJeVi2aDUmkLnh8XuvXEEz2VPqarYvbNcwJqDJ3IL/xXCsKg
   94u48f1OkjKx2rny8ryJhsP//Vcfj203GgJq9d7OIkqcn59CCeuw2p0lD
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10749"; a="358129710"
X-IronPort-AV: E=Sophos;i="6.01,150,1684825200"; 
   d="scan'208";a="358129710"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2023 16:17:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10749"; a="718285970"
X-IronPort-AV: E=Sophos;i="6.01,150,1684825200"; 
   d="scan'208";a="718285970"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2023 16:17:10 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        linux-coco@lists.linux.dev,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Michael Roth <michael.roth@amd.com>
Subject: [RFC PATCH v2 0/6] KVM: guest memory: Misc enhacnement
Date:   Thu, 22 Jun 2023 16:16:24 -0700
Message-Id: <cover.1687474039.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Hello. I've updated the patch series following Michael suggestion.
Here are the discussion points.

- 4/6 KVM: x86: Introduce fault type to indicate kvm page fault is private
  The moot point is where to put the logic to determine the fault is private.
  - The caller site of kvm_mmu_do_page_fault() (or kvm_mmu_page_fault()).
    The v1 patch approach.
    - npf_interception()
    - handle_ept_violation(), handle_ept_misconfig() and TDX counter part.
  - Open code in kvm_get_fault_type()
  
- 5/6 KVM: Add flags to struct kvm_gfn_range
  I think this patch doesn't interfere the SNP case because it passes more
  info to the callback.

- 6/6 KVM: x86: Add is_vm_type_supported callback
  Let's introduce KVM_X86_TDX_VM for TDX.  And revise KVM_X86_PROTECTED_VM.
  I won't address the name in this patch series.

Thanks,


Hello. This is an RFC patch series based on KVM gmem [1] and [2] 
for the common use of TDX and SEV-SNP.  I'd like to discuss three items.

* Flags for kvm_gfn_range:
Roth, By adding flags to kvm_gfn_range, kvm_arch_gmem_invalidate() won't be
needed.  Maybe x86 gmem_invalidate callback is still needed, though.

* Page fault error code or how to figure out the private page fault
There is an issue to set kvm_page_fault.is_private. I came up with two new
error codes.  Is this a way or any other way?

* VM type: Now we have KVM_X86_PROTECTED_VM. How do we proceed?
  - Keep KVM_X86_PROTECTED_VM for its use. Introduce KVM_X86_TDX_VM
  - Use KVM_X86_PROTECTED_VM for TDX. (If necessary, introduce another type in
    the future)
  - any other way?

[1] KVM gmem patches
https://github.com/sean-jc/linux/tree/x86/kvm_gmem_solo

[2] Add AMD Secure Nested Paging (SEV-SNP) Hypervisor Support
https://lore.kernel.org/lkml/20230612042559.375660-1-michael.roth@amd.com/

Isaku Yamahata (6):
  KVM: selftests: Fix test_add_overlapping_private_memory_regions()
  KVM: selftests: Fix guest_memfd()
  KVM: x86/mmu: Pass round full 64-bit error code for the KVM page fault
  KVM: x86: Introduce fault type to indicate kvm page fault is private
  KVM: Add flags to struct kvm_gfn_range
  KVM: x86: Add is_vm_type_supported callback

 arch/x86/include/asm/kvm-x86-ops.h            |  1 +
 arch/x86/include/asm/kvm_host.h               |  7 ++++
 arch/x86/include/uapi/asm/kvm.h               |  1 +
 arch/x86/kvm/mmu/mmu.c                        | 31 +++++++++++-----
 arch/x86/kvm/mmu/mmu_internal.h               | 37 +++++++++++++++++--
 arch/x86/kvm/mmu/mmutrace.h                   |  2 +-
 arch/x86/kvm/mmu/paging_tmpl.h                |  4 +-
 arch/x86/kvm/svm/svm.c                        |  7 ++++
 arch/x86/kvm/vmx/vmx.c                        |  6 +++
 arch/x86/kvm/x86.c                            | 10 ++++-
 arch/x86/kvm/x86.h                            |  2 +
 include/linux/kvm_host.h                      | 10 ++++-
 .../testing/selftests/kvm/guest_memfd_test.c  |  4 +-
 .../selftests/kvm/set_memory_region_test.c    | 16 +++++++-
 virt/kvm/guest_mem.c                          |  9 +++--
 virt/kvm/kvm_main.c                           |  4 +-
 16 files changed, 125 insertions(+), 26 deletions(-)


base-commit: be8abcec83c87d4e15ae04816b685fe260c4bcfd
-- 
2.25.1

