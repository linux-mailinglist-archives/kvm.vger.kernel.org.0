Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E2204BD81F
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 09:40:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346814AbiBUIGU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Feb 2022 03:06:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346808AbiBUIGT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Feb 2022 03:06:19 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0262AC67;
        Mon, 21 Feb 2022 00:05:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645430757; x=1676966757;
  h=from:to:cc:subject:date:message-id;
  bh=GkbqwLH63vmJ3yZDmeVUzOLZbboEsgFRLd+XjuJr6vU=;
  b=hrF++hOtsBT8KsQbooaiJeiQ+owH3jQTvhiUDf7iQhPerVqIEWKcB7qh
   kKwAxJSIGqyC7eM9X4aZLugkLETVmzGWET5ZcDKyVpj3718F54m5I+RdW
   HjbvSrzZpA3Lf4dy9LvBcwgm3xilQVpifei+QVjUUxOqDkhql0J6dZbA0
   H00g1KF8+lIbelHhvmou0vFUVjA8XXTbXu16kZFtQxqQx9MigdOPMKVwg
   ewgmTzippUBolcYNYScgWkQ48cIAMEe1y43XMm+1KkQtvUfV9hdwF41OM
   T9pI7MDlHV3gj8MYgBvwxg/trOTcZvOk7yCtYk4zyMj12lkCkRjFqwrLs
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10264"; a="250277836"
X-IronPort-AV: E=Sophos;i="5.88,385,1635231600"; 
   d="scan'208";a="250277836"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2022 00:05:38 -0800
X-IronPort-AV: E=Sophos;i="5.88,385,1635231600"; 
   d="scan'208";a="638472221"
Received: from unknown (HELO chenyi-pc.sh.intel.com) ([10.239.159.73])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2022 00:05:35 -0800
From:   Chenyi Qiang <chenyi.qiang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Chenyi Qiang <chenyi.qiang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v6 0/7] KVM: PKS Virtualization support
Date:   Mon, 21 Feb 2022 16:08:33 +0800
Message-Id: <20220221080840.7369-1-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch series is based on top of v8 PKS core support kernel patchset:
https://lore.kernel.org/lkml/20220127175505.851391-1-ira.weiny@intel.com/

Note: If you read the SDM section 4.6.1 and has some confusion about the
statement of Data writes to supervisor-mode address:

  If CR0.WP = 0, data may be written to any supervisor-mode address with
  a protection key for which write access is permitted.

Which may seems a little conflict with 4.6.2:

  if WDi = 1, write accesses are not permitted if CR0.WP = 1. (If CR0.WP
  = 0, IA32_PKRS.WDi does not affect write accesses to supervisor-mode
  address with protection key i.)

In fact, the statement in 4.6.1 doesn't say "a protection key with the
appropriate WDi bit set." The reader should instead refer to Section
4.6.2 to find the definition of what that means. We will follow up
this with someone internally to make it more clear in SDM.

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

 arch/x86/include/asm/kvm_host.h |  17 ++++--
 arch/x86/include/asm/vmx.h      |   6 ++
 arch/x86/kvm/cpuid.c            |  13 ++--
 arch/x86/kvm/kvm_cache_regs.h   |   7 +++
 arch/x86/kvm/mmu.h              |  27 +++++----
 arch/x86/kvm/mmu/mmu.c          | 101 ++++++++++++++++++++------------
 arch/x86/kvm/vmx/capabilities.h |   6 ++
 arch/x86/kvm/vmx/nested.c       |  38 +++++++++++-
 arch/x86/kvm/vmx/vmcs.h         |   1 +
 arch/x86/kvm/vmx/vmcs12.c       |   2 +
 arch/x86/kvm/vmx/vmcs12.h       |   4 ++
 arch/x86/kvm/vmx/vmx.c          |  92 ++++++++++++++++++++++++++---
 arch/x86/kvm/vmx/vmx.h          |   7 ++-
 arch/x86/kvm/x86.c              |  10 +++-
 arch/x86/kvm/x86.h              |   8 +++
 arch/x86/mm/pkeys.c             |   6 ++
 include/linux/pkeys.h           |   6 ++
 17 files changed, 280 insertions(+), 71 deletions(-)

-- 
2.17.1

