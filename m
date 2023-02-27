Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0A396A3D8A
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 09:55:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229903AbjB0Izs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 03:55:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229900AbjB0IzB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 03:55:01 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 907A224CA7
        for <kvm@vger.kernel.org>; Mon, 27 Feb 2023 00:47:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677487641; x=1709023641;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=TrvM1KwzqqNx8mvyKW6VH3eQwWSN9FeVCpFbvKBz/Fo=;
  b=mmiK9kRW+NqT1dkCaGWurBOEWasubizIck2uT/UHgR4HmF3ELq6h1G1k
   v42u1zzjFyylcEsOtx5ZDQjvPPtN2b/fHW9J2LA+agkXRz4E9Wi2P9Q03
   AKZZwQcbqON0v5y5y5+EpDT2UQzwH5lbIfduH8Cy1J5QnKIKKaPHzYKS5
   5brnG+P2NR5YOd0z+FnYE7yQ2gnFcKIS9zxQAHUV/fM3ueZAMnLmhLzcy
   IC0Vsxe02Ye/OpiHwU4/KAWvjR0ECbFdOmgYWbzyjn6G6M9WZQopGVQFp
   Pz/3VBclR2adB41HCDY/kPbJ5PRdt6fclFZ3A92JuCpOAuoHjZozatvvU
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="322057673"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="322057673"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 00:46:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="651127068"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="651127068"
Received: from sqa-gate.sh.intel.com (HELO robert-clx2.tsp.org) ([10.239.48.212])
  by orsmga006.jf.intel.com with ESMTP; 27 Feb 2023 00:46:08 -0800
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, chao.gao@intel.com,
        binbin.wu@linux.intel.com
Cc:     kvm@vger.kernel.org, Robert Hoo <robert.hu@linux.intel.com>
Subject: [PATCH v5 0/5] Linear Address Masking (LAM) KVM Enabling
Date:   Mon, 27 Feb 2023 16:45:42 +0800
Message-Id: <20230227084547.404871-1-robert.hu@linux.intel.com>
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
   set, in this case, the effective usable linear address width is 48. [2]
4. When VM exit, the problematic address saved in VMCS field is clean, i.e.
   metadata cleared with canonical form.


===LAM KVM Design===

Intercept CR4.LAM_SUP by KVM, to avoid read VMCS field every time, with
expectation that guest won't toggle this bit frequently.

Under EPT mode, CR3 is fully under guest control, guest LAM is thus transparent to
KVM.

For Shadow paging (EPT = off), KVM need to handle guest CR3.LAM_U48 and CR3.LAM_U57
toggles.

In KVM emulator, when a linear address is calculated, imitate HW LAM rules
per LAM setting.

===Unit Test===
1. Run Kernel LAM kselftests in guest, with both EPT=Y/N.
2. Add a kvm-unit-test [3] for CR4.LAM_SUP part, as Kernel LAM selftests doesn't
cover this yet. This test covers CR4 LAM_SUP bits toggle, LAM supervisor
mode address masking, KVM emulator code patch. Run the unit test with both LAM feature
on/off (i.e. including negative cases).
3. Launch a nested guest.

All tests has passed in Simics environment.

[1] ISE Chap 10 https://cdrdv2.intel.com/v1/dl/getContent/671368 (Section 10.6 VMX interaction)
[2] Thus currently, Kernel enabling patch only enables LAM_U57. https://lore.kernel.org/lkml/20230123220500.21077-1-kirill.shutemov@linux.intel.com/ 
[3] https://lore.kernel.org/kvm/20230227082557.403584-1-robert.hu@linux.intel.com/

---
Changelog
v4 --> v5:
Reorder and melt patches surround CR3.LAM bits into Patch 3 of this
version.
Revise Patch 1's subject and description
Drop Patch 3
Use kvm_read_cr4_bits() instead of kvm_read_cr4()
Fix: No need to untag addr when write to msr, it should be legacy canonical check
Rename kvm_is_valid_cr3() --> kvm_vcpu_is_valid_cr3(), and update some call
sites of kvm_vcpu_is_valid_cr3() to use kvm_is_valid_cr3().
Other refactors and Miscs.

v3 --> v4:
Drop unrelated Patch 1 in v3 (Binbin, Sean, Xiaoyao)
Intercept CR4.LAM_SUP instead of pass through to guest (Sean)
Just filter out CR3.LAM_{U48, U57}, instead of all reserved high bits
(Sean, Yuan)
Use existing __canonical_address() helper instead write a new one (Weijiang)
Add LAM handling in KVM emulation (Yu, Yuan)
Add Jingqi's reviwed-by on Patch 7
Rebased to Kirill's latest code, which is 6.2-rc1 base.

v2 --> v3:
As LAM Kernel patches are in tip tree now, rebase to it.
https://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git/

v1 --> v2:
1. Fixes i386-allyesconfig build error on get_pgd(), where
   CR3_HIGH_RSVD_MASK isn't applicable.
   (Reported-by: kernel test robot <lkp@intel.com>)
2. In kvm_set_cr3(), be conservative on skip tlb flush when only LAM bits
   toggles. (Kirill)


Robert Hoo (5):
  KVM: x86: Virtualize CR4.LAM_SUP
  [Trivial]KVM: x86: Explicitly cast ulong to bool in kvm_set_cr3()
  KVM: x86: Virtualize CR3.LAM_{U48,U57}
  KVM: x86: emulation: Apply LAM mask when emulating data access in
    64-bit mode
  KVM: x86: LAM: Expose LAM CPUID to user space VMM

 arch/x86/include/asm/kvm_host.h |  3 +-
 arch/x86/kvm/cpuid.c            |  2 +-
 arch/x86/kvm/emulate.c          | 13 ++++++
 arch/x86/kvm/mmu.h              |  5 +++
 arch/x86/kvm/mmu/mmu.c          |  9 +++-
 arch/x86/kvm/mmu/paging_tmpl.h  |  2 +-
 arch/x86/kvm/vmx/nested.c       |  4 +-
 arch/x86/kvm/vmx/vmx.c          |  3 +-
 arch/x86/kvm/x86.c              | 35 +++++++++++++---
 arch/x86/kvm/x86.h              | 73 +++++++++++++++++++++++++++++++++
 10 files changed, 136 insertions(+), 13 deletions(-)

https://git.kernel.org/pub/scm/linux/kernel/git/kas/linux.git lam
base-commit: 03334443640f226f56f71b5dfa3b1be6d4a1a1bc
-- 
2.31.1

