Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78F6F3106EA
	for <lists+kvm@lfdr.de>; Fri,  5 Feb 2021 09:41:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbhBEIkh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Feb 2021 03:40:37 -0500
Received: from mga09.intel.com ([134.134.136.24]:19410 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229750AbhBEIeq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Feb 2021 03:34:46 -0500
IronPort-SDR: FeCdQxe93Ab1vDsXQy3vwqXQ5eX8rxiYJ1z+iha1Omhlsonwo5nlYkfmZKG9BSADV1C+fIwFWF
 RhLwhSl6vjHg==
X-IronPort-AV: E=McAfee;i="6000,8403,9885"; a="181550683"
X-IronPort-AV: E=Sophos;i="5.81,154,1610438400"; 
   d="scan'208";a="181550683"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2021 00:34:00 -0800
IronPort-SDR: gcyCPVjwdmD29JNIJ70FkW2fkUHXLGkYOMRuR6IzWewdO8HBRgCgQvwwiFkg+FmRIFRwgVlz8Z
 psIVrTt/05Kw==
X-IronPort-AV: E=Sophos;i="5.81,154,1610438400"; 
   d="scan'208";a="393761878"
Received: from chenyi-pc.sh.intel.com ([10.239.159.24])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2021 00:33:57 -0800
From:   Chenyi Qiang <chenyi.qiang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 0/5] KVM: PKS Virtualization support
Date:   Fri,  5 Feb 2021 16:37:01 +0800
Message-Id: <20210205083706.14146-1-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Protection Keys for Supervisor Pages(PKS) is a feature that extends the
Protection Keys architecture to support thread-specific permission
restrictions on supervisor pages.

PKS works similar to an existing feature named PKU(protecting user pages).
They both perform an additional check after all legacy access
permissions checks are done. If violated, #PF occurs and PFEC.PK bit will
be set. PKS introduces MSR IA32_PKRS to manage supervisor protection key
rights. The MSR contains 16 pairs of ADi and WDi bits. Each pair
advertises on a group of pages with the same key which is set in the
leaf paging-structure entries(bits[62:59]). Currently, IA32_PKRS is not
supported by XSAVES architecture.

This patchset aims to add the virtualization of PKS in KVM. It
implemented PKS CPUID enumeration, vmentry/vmexit configuration, MSR
exposure, nested supported etc. Currently, PKS is not yet supported for
shadow paging. 

PKS bare metal support:
https://lore.kernel.org/lkml/20201106232908.364581-1-ira.weiny@intel.com/

Detailed information about PKS can be found in the latest Intel 64 and
IA-32 Architectures Software Developer's Manual.

---

Changelogs:

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

Chenyi Qiang (5):
  KVM: VMX: Introduce PKS VMCS fields
  KVM: X86: Expose PKS to guest
  KVM: MMU: Rename the pkru to pkr
  KVM: MMU: Add support for PKS emulation
  KVM: VMX: Enable PKS for nested VM

 arch/x86/include/asm/kvm_host.h | 17 +++---
 arch/x86/include/asm/pkeys.h    |  1 +
 arch/x86/include/asm/vmx.h      |  6 ++
 arch/x86/kvm/cpuid.c            |  3 +-
 arch/x86/kvm/mmu.h              | 23 ++++----
 arch/x86/kvm/mmu/mmu.c          | 81 +++++++++++++++------------
 arch/x86/kvm/vmx/capabilities.h |  6 ++
 arch/x86/kvm/vmx/nested.c       | 38 ++++++++++++-
 arch/x86/kvm/vmx/vmcs.h         |  1 +
 arch/x86/kvm/vmx/vmcs12.c       |  2 +
 arch/x86/kvm/vmx/vmcs12.h       |  6 +-
 arch/x86/kvm/vmx/vmx.c          | 99 +++++++++++++++++++++++++++++++--
 arch/x86/kvm/vmx/vmx.h          |  1 +
 arch/x86/kvm/x86.c              | 11 +++-
 arch/x86/kvm/x86.h              |  8 +++
 arch/x86/mm/pkeys.c             |  6 ++
 include/linux/pkeys.h           |  4 ++
 17 files changed, 249 insertions(+), 64 deletions(-)

-- 
2.17.1

