Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FC117320AF
	for <lists+kvm@lfdr.de>; Thu, 15 Jun 2023 22:12:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234203AbjFOUMj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jun 2023 16:12:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229969AbjFOUMh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jun 2023 16:12:37 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80C721BDB;
        Thu, 15 Jun 2023 13:12:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686859956; x=1718395956;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=cbAzvr+Ajvv1Z/vidWMYDMFl9TQ90crI2tO+uhbEtEc=;
  b=AbZOIceo19Bj+S4sDcHKp1ogezbkkwtwiS7JgR/+Pjr47vFS25txS0q9
   FbDJhvZiICV528LXsJeTOFyzgwLJk1YoNp85CKX99Sb2LXM0nFf+xciEV
   /Petia14VEHSuN0BMHlU9hZu3qSI+hd+NPo0Kb8FrtkQKRWj/TKy25fel
   A/01Kzt8OxdIFZ3FmSIFvvwh0W3lNSlewHb8whFAeJyXcFJ1hejKylGp5
   3mMi86FY32rW8M2VkSYpJUdyWMTgCt6yyRI+spvRyERSLMWcT1z2cszUg
   jTvlMmvMQmq8r5bHirLJ4sP4RAhuwY7Su8FEjgoMj1GdbHpiYneisxq2m
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="387611429"
X-IronPort-AV: E=Sophos;i="6.00,245,1681196400"; 
   d="scan'208";a="387611429"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2023 13:12:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="712576643"
X-IronPort-AV: E=Sophos;i="6.00,245,1681196400"; 
   d="scan'208";a="712576643"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2023 13:12:35 -0700
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
Subject: [RFC PATCH 0/6] KVM: guest memory: Misc enhacnement
Date:   Thu, 15 Jun 2023 13:12:13 -0700
Message-Id: <cover.1686858861.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

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
  KVM: x86: Introduce PFERR_GUEST_ENC_MASK to indicate fault is private
  KVM: Add flags to struct kvm_gfn_range
  KVM: x86: Add is_vm_type_supported callback

 arch/x86/include/asm/kvm-x86-ops.h               |  1 +
 arch/x86/include/asm/kvm_host.h                  |  5 +++++
 arch/x86/include/uapi/asm/kvm.h                  |  1 +
 arch/x86/kvm/mmu/mmu.c                           | 14 +++++++++-----
 arch/x86/kvm/mmu/mmu_internal.h                  |  8 ++++----
 arch/x86/kvm/mmu/mmutrace.h                      |  2 +-
 arch/x86/kvm/mmu/paging_tmpl.h                   |  4 ++--
 arch/x86/kvm/svm/svm.c                           |  7 +++++++
 arch/x86/kvm/vmx/vmx.c                           |  6 ++++++
 arch/x86/kvm/x86.c                               | 10 +++++++++-
 arch/x86/kvm/x86.h                               |  2 ++
 include/linux/kvm_host.h                         | 11 ++++++++++-
 tools/testing/selftests/kvm/guest_memfd_test.c   |  4 ++--
 .../selftests/kvm/set_memory_region_test.c       | 16 ++++++++++++++--
 virt/kvm/guest_mem.c                             | 10 +++++++---
 virt/kvm/kvm_main.c                              |  4 +++-
 16 files changed, 83 insertions(+), 22 deletions(-)


base-commit: be8abcec83c87d4e15ae04816b685fe260c4bcfd
-- 
2.25.1

