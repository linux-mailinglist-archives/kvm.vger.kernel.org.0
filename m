Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C91723E978
	for <lists+kvm@lfdr.de>; Fri,  7 Aug 2020 10:46:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727120AbgHGIqp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Aug 2020 04:46:45 -0400
Received: from mga06.intel.com ([134.134.136.31]:65145 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726382AbgHGIqo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Aug 2020 04:46:44 -0400
IronPort-SDR: CbtsCIDR6q+mkLh1K2pvuEuwRTwq93Tbc25iLu/0YtEctwWGifAZkn1MrAunKGF+UCmJ4hxFzb
 Z/1n2xfN7DTQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9705"; a="214565716"
X-IronPort-AV: E=Sophos;i="5.75,445,1589266800"; 
   d="scan'208";a="214565716"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2020 01:46:44 -0700
IronPort-SDR: M0ulD5ZOVtxaO1LRSJ0sZZJarJy5PFWv+Z8cUPzeo/eSTZwi67YNWYRrSpWzW3czYvyq3tC7AB
 C9q4dWuK/M/g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,445,1589266800"; 
   d="scan'208";a="307317136"
Received: from chenyi-pc.sh.intel.com ([10.239.159.72])
  by orsmga002.jf.intel.com with ESMTP; 07 Aug 2020 01:46:41 -0700
From:   Chenyi Qiang <chenyi.qiang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC 0/7] KVM: PKS Virtualization support
Date:   Fri,  7 Aug 2020 16:48:34 +0800
Message-Id: <20200807084841.7112-1-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This RFC series introduce the KVM support for PKS which have dependency
on PKS kernel patches for some definitions. The latest kernel patch set
can be found at
https://lore.kernel.org/lkml/20200717072056.73134-1-ira.weiny@intel.com/

---

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

Detailed information about PKS can be found in the latest Intel 64 and
IA-32 Architectures Software Developer's Manual.

Chenyi Qiang (7):
  KVM: VMX: Introduce PKS VMCS fields
  KVM: VMX: Expose IA32_PKRS MSR
  KVM: MMU: Rename the pkru to pkr
  KVM: MMU: Refactor pkr_mask to cache condition
  KVM: MMU: Add support for PKS emulation
  KVM: X86: Expose PKS to guest and userspace
  KVM: VMX: Enable PKS for nested VM

 arch/x86/include/asm/kvm_host.h | 13 ++---
 arch/x86/include/asm/pkeys.h    |  1 +
 arch/x86/include/asm/vmx.h      |  6 +++
 arch/x86/kvm/cpuid.c            |  3 +-
 arch/x86/kvm/mmu.h              | 36 +++++++------
 arch/x86/kvm/mmu/mmu.c          | 78 +++++++++++++++-------------
 arch/x86/kvm/vmx/capabilities.h |  6 +++
 arch/x86/kvm/vmx/nested.c       | 33 ++++++++++++
 arch/x86/kvm/vmx/vmcs.h         |  1 +
 arch/x86/kvm/vmx/vmcs12.c       |  2 +
 arch/x86/kvm/vmx/vmcs12.h       |  6 ++-
 arch/x86/kvm/vmx/vmx.c          | 91 +++++++++++++++++++++++++++++++--
 arch/x86/kvm/vmx/vmx.h          |  1 +
 arch/x86/kvm/x86.c              |  7 ++-
 arch/x86/kvm/x86.h              |  6 +++
 arch/x86/mm/pkeys.c             |  6 +++
 include/linux/pkeys.h           |  4 ++
 17 files changed, 234 insertions(+), 66 deletions(-)

-- 
2.17.1

