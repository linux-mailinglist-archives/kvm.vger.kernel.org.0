Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35A4D50D10C
	for <lists+kvm@lfdr.de>; Sun, 24 Apr 2022 12:16:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238996AbiDXKTA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 24 Apr 2022 06:19:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238962AbiDXKS7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 24 Apr 2022 06:18:59 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9366140A5;
        Sun, 24 Apr 2022 03:15:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650795358; x=1682331358;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=jZlRG8AqX1Ezm6cxswh52LD9bW0bpmqIXQ5DvoEol1Y=;
  b=Lk6pNcYYOQxuJNNgg0hAhHGQ4kGyYPo8SooqwZcfZzmNsCt6rybG63vJ
   oPfjA24UaSeKPftbCf9SbyA8HWoqh/JbNB9ElOHxtBFEBLvvGjarycE4f
   Qxbb9p72CXKWGJcqbJhPcb/NqmcIpaxLu6jGknrJqZUL+8CuX5eZovitW
   I7F4v2eV5m3oKHh3m2x+aPE3i5OXoliBAt1vaWqAiJi/UN/AKMbBr9Wee
   tYIsOja4ywZGQf6iQBXP+Bga+zoNkP8vuVyo5HYcxnHE6bQH74ps0Ih6W
   iv/QpdJPCoUkwy5scUTI7rmk67MRPWCp12GupNdMI0JYK2Kn2l+J3oOI/
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10326"; a="264813941"
X-IronPort-AV: E=Sophos;i="5.90,286,1643702400"; 
   d="scan'208";a="264813941"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2022 03:15:58 -0700
X-IronPort-AV: E=Sophos;i="5.90,286,1643702400"; 
   d="scan'208";a="616086703"
Received: from 984fee00be24.jf.intel.com ([10.165.54.246])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2022 03:15:58 -0700
From:   Lei Wang <lei4.wang@intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org
Cc:     lei4.wang@intel.com, chenyi.qiang@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v7 0/8] KVM: PKS Virtualization support
Date:   Sun, 24 Apr 2022 03:15:49 -0700
Message-Id: <20220424101557.134102-1-lei4.wang@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch series is based on top of v10 PKS core support kernel patchset:
https://lore.kernel.org/lkml/20220419170649.1022246-1-ira.weiny@intel.com/

---

Protection Keys for Supervisor Pages(PKS) is a feature that extends the
Protection Keys architecture to support thread-specific permission
restrictions on supervisor pages.

PKS works similar to an existing feature named PKU(protecting user pages).
They both perform an additional check after normal paging permission
checks are done. Access or Writes can be disabled via a MSR update
without TLB flushes when permissions changes. If violating this
addional check, #PF occurs and PFEC.PK bit will be set.

PKS introduces MSR IA32_PKRS to manage supervisor protection key
rights. The MSR contains 16 pairs of ADi and WDi bits. Each pair
advertises on a group of pages with the same key which is set in the
leaf paging-structure entries(bits[62:59]). Currently, IA32_PKRS is not
supported by XSAVES architecture.

This patchset aims to add the virtualization of PKS in KVM. It
implemented PKS CPUID enumeration, vmentry/vmexit configuration, MSR
exposure, nested supported etc. Currently, PKS is not yet supported for
shadow paging. 

Detailed information about PKS can be found in the latest Intel 64 and
IA-32 Architectures Software Developer's Manual.

---

Changelogs:

v6->v7
- Add documentation to note that it's nice-to-have cache tracking for PKRS,
  and we also needn't hesitate to rip it out in the future if there's a strong
  reason to drop the caching. (Sean)
- Blindly reading PKRU/PKRS is wrong, fixed. (Sean)
- Add a non-inline helper kvm_mmu_pkr_bits() to read PKR bits. (Sean)
- Delete the comment for exposing the PKS because the pattern is common and the
  behavior is self-explanatory. (Sean)
- Add a helper vmx_set_host_pkrs() for setting host pkrs and rewrite the
  related code for concise. (Sean)
- Align an indentation in arch/x86/kvm/vmx/nested.c. (Sean)
- Read the current PKRS if from_vmentry == false under the nested condition.
  (Sean)
- v6: https://lore.kernel.org/lkml/20220221080840.7369-1-chenyi.qiang@intel.com/

v5->v6
- PKRS is preserved on INIT. Add the PKRS reset operation in kvm_vcpu_reset.
  (Sean)
- Track the pkrs as u32. Add the code WARN on bits 64:32 being set in VMCS field.
  (Sean)
- Adjust the MSR intercept and entry/exit control in VMCS according to
  guest CPUID. This resolve the issue when userspace re-enable this feature.
  (Sean)
- Split VMX restriction on PKS support(entry/exit load controls) out of
  common x86. And put tdp restriction together with PKU in common x86.
  (Sean)
- Thanks for Sean to revise the comments in mmu.c related to
  update_pkr_bitmap, which make it more clear for pkr bitmask cache usage.
- v5: https://lore.kernel.org/lkml/20210811101126.8973-1-chenyi.qiang@intel.com/

v4->v5
- Make setting of MSR intercept/vmcs control bits not dependent on guest.CR4.PKS.
  And set them if PKS is exposed to guest. (Suggested by Sean)
- Add pkrs to standard register caching mechanism to help update
  vcpu->arch.pkrs on demand. Add related helper functions. (Suggested by Sean)
- Do the real pkrs update in VMCS field in vmx_vcpu_reset and
  vmx_sync_vmcs_host_state(). (Sean)
- Add a new mmu_role cr4_pks instead of smushing PKU and PKS together.
  (Sean & Paolo)
- v4: https://lore.kernel.org/lkml/20210205083706.14146-1-chenyi.qiang@intel.com/

v3->v4
- Make the MSR intercept and load-controls setting depend on CR4.PKS value
- shadow the guest pkrs and make it usable in PKS emultion
- add the cr4_pke and cr4_pks check in pkr_mask update
- squash PATCH 2 and PATCH 5 to make the dependencies read more clear
- v3: https://lore.kernel.org/lkml/20201105081805.5674-1-chenyi.qiang@intel.com/

v2->v3:
- No function changes since last submit
- rebase on the latest PKS kernel support:
  https://lore.kernel.org/lkml/20201102205320.1458656-1-ira.weiny@intel.com/
- add MSR_IA32_PKRS to the vmx_possible_passthrough_msrs[]
- RFC v2: https://lore.kernel.org/lkml/20201014021157.18022-1-chenyi.qiang@intel.com/

v1->v2:
- rebase on the latest PKS kernel support:
  https://github.com/weiny2/linux-kernel/tree/pks-rfc-v3
- add a kvm-unit-tests for PKS
- add the check in kvm_init_msr_list for PKRS
- place the X86_CR4_PKS in mmu_role_bits in kvm_set_cr4
- add the support to expose VM_{ENTRY, EXIT}_LOAD_IA32_PKRS in nested
  VMX MSR
- RFC v1: https://lore.kernel.org/lkml/20200807084841.7112-1-chenyi.qiang@intel.com/

---

Chenyi Qiang (7):
  KVM: VMX: Introduce PKS VMCS fields
  KVM: VMX: Add proper cache tracking for PKRS
  KVM: X86: Expose IA32_PKRS MSR
  KVM: MMU: Rename the pkru to pkr
  KVM: MMU: Add support for PKS emulation
  KVM: VMX: Expose PKS to guest
  KVM: VMX: Enable PKS for nested VM

Lei Wang (1):
  KVM: MMU: Add helper function to get pkr bits

 arch/x86/include/asm/kvm_host.h |  17 +++--
 arch/x86/include/asm/vmx.h      |   6 ++
 arch/x86/kvm/cpuid.c            |  13 +++-
 arch/x86/kvm/kvm_cache_regs.h   |   7 ++
 arch/x86/kvm/mmu.h              |  29 +++----
 arch/x86/kvm/mmu/mmu.c          | 130 +++++++++++++++++++++++---------
 arch/x86/kvm/vmx/capabilities.h |   6 ++
 arch/x86/kvm/vmx/nested.c       |  36 ++++++++-
 arch/x86/kvm/vmx/vmcs.h         |   1 +
 arch/x86/kvm/vmx/vmcs12.c       |   2 +
 arch/x86/kvm/vmx/vmcs12.h       |   4 +
 arch/x86/kvm/vmx/vmx.c          |  85 +++++++++++++++++++--
 arch/x86/kvm/vmx/vmx.h          |  14 +++-
 arch/x86/kvm/x86.c              |   9 ++-
 arch/x86/kvm/x86.h              |   8 ++
 arch/x86/mm/pkeys.c             |   6 ++
 include/linux/pks.h             |   7 ++
 17 files changed, 301 insertions(+), 79 deletions(-)

-- 
2.25.1

