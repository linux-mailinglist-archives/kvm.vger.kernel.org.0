Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D33C6600738
	for <lists+kvm@lfdr.de>; Mon, 17 Oct 2022 09:05:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230096AbiJQHFh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Oct 2022 03:05:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230102AbiJQHF1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Oct 2022 03:05:27 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6EDF29833
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 00:05:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665990323; x=1697526323;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=3hKtSk3rEu0egYDhxu0x2z57LwZ9C/Mw/de/BPxf04Q=;
  b=HshFrHXEPa8wAy9rDwG1AxMLjv3WqU31m+aDTE6HlKQyow1h7bb5kENO
   TFooESOnrMOPAtZyTc8gPOO46ny1M0BBRj7Aah7Sie2hOk3N1eo8XJiVI
   VaVD7LVSAKSlFHaoyvL1UVkJKS69UR1DehqgVScnf7lJigLleV8EDHVpH
   DnBXrx4Iila+wD7pvjt0nXekbQSag01dKDxNWoyIEzDYOocSjJkjowtg8
   EfurNXvNuehB7FzqSguRF2YKvLBhbkt82TXNGysKh+BNt0Bcw/aoZrFdC
   jscTidS2J+eY4PuEMjrwiZQaRE5Hc8RorpsA7okRuCPUzYzgmUMv84FMD
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10502"; a="306805984"
X-IronPort-AV: E=Sophos;i="5.95,190,1661842800"; 
   d="scan'208";a="306805984"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2022 00:05:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10502"; a="579271363"
X-IronPort-AV: E=Sophos;i="5.95,190,1661842800"; 
   d="scan'208";a="579271363"
Received: from sqa-gate.sh.intel.com (HELO robert-clx2.tsp.org) ([10.239.48.212])
  by orsmga003.jf.intel.com with ESMTP; 17 Oct 2022 00:05:12 -0700
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, Robert Hoo <robert.hu@linux.intel.com>
Subject: [PATCH 0/9] Linear Address Masking (LAM) KVM Enabling
Date:   Mon, 17 Oct 2022 15:04:41 +0800
Message-Id: <20221017070450.23031-1-robert.hu@linux.intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

===Feature Introduction===

Linear-address masking (LAM) [1], modifies the checking that is applied to
*64-bit* linear addresses, allowing software to use of the untranslated
address (upper) bits for metadata.
As for which upper bits of linear address can be borrowed, LAM has 2 modes:
LAM_48 (bits 62:48, i.e. LAM width of 15) and LAM_57 (bits 62:57, i.e. LAM
width of 6), controlled by these new bits: CR3[62] (LAM_U48), CR3[61]
(LAM_U57), and CR4[28] (LAM_SUP).

* LAM_U48 and LAM_U57 bits controls LAM for user mode address. I.e. if
  CR3.LAM_U57 = 1, LAM57 is applied; if CR3.LAM_U48 = 1 and CR3.LAM_U57 = 0,
  LAM48 is applied.
* LAM_SUP bit, combined with paging mode (4-level or 5-level), determines
  LAM status for supervisor mode address. I.e. when CR4.LAM_SUP =1, 4-level
  paging mode will have LAM48 for supervisor mode address while 5-level paging
  will have LAM57.

Note:
1. LAM applies to only data address, not to instructions.
2. LAM identification of an address as user or supervisor is based solely on the
   value of pointer bit 63 and does not, for the purposes of LAM, depend on the CPL.
3. For user mode address, it is possible that 5-level paging and LAM_U48 are both
   set, in this case, the effective usable linear address width is 48, i.e. bit
   56:47 is reserved by LAM. [2]


===LAM KVM Design===

Pass CR4.LAM_SUP under guest control.

Under EPT mode, CR3 is fully under guest control, guest LAM is thus transparent to
KVM. Nothing more need to do.

For Shadow paging (EPT = off), KVM need to handle guest CR3.LAM_U48 and CR3.LAM_U57
toggles.

Patch 1 -- This patch can be mostly independent from LAM enabling. It just renames
           CR4 reserved bits for better understanding, esp. for beginners.
	   
Patch 2, 9 -- Common part for both EPT and Shadow Paging modes enabling.

Patch 3 ~ 8 -- For Shadow Paging mode LAM enabling.


This patch set is based on Kirill's up-to-date LAM Kernel enabling
(e3e52d2898d66c34eefbe09cbeae0d3ba53fb989)
https://git.kernel.org/pub/scm/linux/kernel/git/kas/linux.git lam

Unit tested with self test tools in both host and VM, passed.

[1] ISE Chap10 https://cdrdv2.intel.com/v1/dl/getContent/671368 (Section 10.6 VMX interaction)
[2] Thus currently, Kernel enabling patch only enables LAM57 mode. https://lore.kernel.org/lkml/20220815041803.17954-1-kirill.shutemov@linux.intel.com/


Robert Hoo (9):
  KVM: x86: Rename cr4_reserved/rsvd_* variables to be more readable
  KVM: x86: Add CR4.LAM_SUP in guest owned bits
  KVM: x86: MMU: Rename get_cr3() --> get_pgd() and clear high bits for
    pgd
  [Trivial] KVM: x86: MMU: Commets update
  KVM: x86: MMU: Integrate LAM bits when build guest CR3
  KVM: x86: Untag LAM bits when applicable
  KVM: x86: When judging setting CR3 valid or not, consider LAM bits
  KVM: x86: When guest set CR3, handle LAM bits semantics
  KVM: x86: LAM: Expose LAM CPUID to user space VMM

 arch/x86/include/asm/kvm_host.h        |  7 ++--
 arch/x86/include/asm/processor-flags.h |  1 +
 arch/x86/kvm/cpuid.c                   |  6 +--
 arch/x86/kvm/kvm_cache_regs.h          |  3 +-
 arch/x86/kvm/mmu.h                     |  5 +++
 arch/x86/kvm/mmu/mmu.c                 | 16 +++++---
 arch/x86/kvm/vmx/vmx.c                 |  8 +++-
 arch/x86/kvm/x86.c                     | 53 ++++++++++++++++++++------
 arch/x86/kvm/x86.h                     | 43 ++++++++++++++++++++-
 9 files changed, 114 insertions(+), 28 deletions(-)

-- 
2.31.1

