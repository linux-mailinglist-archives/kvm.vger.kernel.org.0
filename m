Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7F7D647CFF
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 05:46:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229500AbiLIEqK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 23:46:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbiLIEqH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 23:46:07 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 070A26591
        for <kvm@vger.kernel.org>; Thu,  8 Dec 2022 20:46:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670561166; x=1702097166;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=JBo0d22aB7hZNffR5F1SoaOjlqLnz2CrQhqLLrwCz3o=;
  b=Sk6pfNdZhSfINSh869pHYmz3qMzdmyTdBwWnFX+VCZ8pe5gr01DR/41b
   ynK7MzAwmxi2DDe8mfBKGJ5j7d7C4xfyPh1H9G8+R4NeE4zFxdvAymYZL
   I06fpS90PNKg/IHVdgZuHpL8zJ3NURgU2BnG75hqqk8sB46pmIWX8Xe/e
   DpdZOJxhIZ2OIWB8qitrS5WxUY5Vi1NC1lqNjqMCfh3FXtt+18ptSzVEa
   pYXMotdfBS1jYghDNhhXNXeLM6BGEhWHlnijlJ5MAejy32oyk1ko4sbUl
   0vAVZ1ifUSK3N6nHvdglnSZXB6NtyUzc3Nt8YEWJx5/0l5RpILPij97AS
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="318530814"
X-IronPort-AV: E=Sophos;i="5.96,230,1665471600"; 
   d="scan'208";a="318530814"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 20:46:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="892524427"
X-IronPort-AV: E=Sophos;i="5.96,230,1665471600"; 
   d="scan'208";a="892524427"
Received: from sqa-gate.sh.intel.com (HELO robert-clx2.tsp.org) ([10.239.48.212])
  by fmsmga006.fm.intel.com with ESMTP; 08 Dec 2022 20:46:03 -0800
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     pbonzini@redhat.com, seanjc@google.com,
        kirill.shutemov@linux.intel.com, kvm@vger.kernel.org
Cc:     Robert Hoo <robert.hu@linux.intel.com>
Subject: [PATCH v3 0/9] Linear Address Masking (LAM) KVM Enabling
Date:   Fri,  9 Dec 2022 12:45:48 +0800
Message-Id: <20221209044557.1496580-1-robert.hu@linux.intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

[1] ISE Chap10 https://cdrdv2.intel.com/v1/dl/getContent/671368 (Section 10.6 VMX interaction)
[2] Thus currently, Kernel enabling patch only enables LAM57 mode. https://lore.kernel.org/lkml/20220815041803.17954-1-kirill.shutemov@linux.intel.com/

---
Changelog
v2 --> v3:
As LAM Kernel patches are in tip tree now, rebase to it.
https://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git/

v1 --> v2:
1. Fixes i386-allyesconfig build error on get_pgd(), where
   CR3_HIGH_RSVD_MASK isn't applicable.
   (Reported-by: kernel test robot <lkp@intel.com>)
2. In kvm_set_cr3(), be conservative on skip tlb flush when only LAM bits
   toggles. (Kirill)

Robert Hoo (9):
  KVM: x86: Rename cr4_reserved/rsvd_* variables to be more readable
  KVM: x86: Add CR4.LAM_SUP in guest owned bits
  KVM: x86: MMU: Rename get_cr3() --> get_pgd() and clear high bits for
    pgd
  KVM: x86: MMU: Commets update
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
 arch/x86/kvm/mmu/mmu.c                 | 18 ++++++---
 arch/x86/kvm/vmx/vmx.c                 |  8 +++-
 arch/x86/kvm/x86.c                     | 51 ++++++++++++++++++++------
 arch/x86/kvm/x86.h                     | 43 +++++++++++++++++++++-
 9 files changed, 115 insertions(+), 27 deletions(-)


base-commit: a5dadcb601b4954c60494d797b4dd1e03a4b1ebe
-- 
2.31.1

