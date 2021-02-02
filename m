Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC96230BA80
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 10:04:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232812AbhBBJCO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 04:02:14 -0500
Received: from mga02.intel.com ([134.134.136.20]:41952 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231860AbhBBJCG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Feb 2021 04:02:06 -0500
IronPort-SDR: XrMKU2HkKx9fiW3b+H1yepyU/f6S4zqM/oXovb0QfotGbQqPIk0nKyEpINDWtcnov1J7rPAf5C
 YgLi144x3qzw==
X-IronPort-AV: E=McAfee;i="6000,8403,9882"; a="167929199"
X-IronPort-AV: E=Sophos;i="5.79,394,1602572400"; 
   d="scan'208";a="167929199"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2021 01:01:22 -0800
IronPort-SDR: j3yg88fjdQC+eiSMyKy4p3zWzkI+sP40x0+NIYX0vo96ZYxg1B70EnzDxjKhf5KBBRDVDwY8lL
 k4TMvYAqMf3A==
X-IronPort-AV: E=Sophos;i="5.79,394,1602572400"; 
   d="scan'208";a="479491878"
Received: from chenyi-pc.sh.intel.com ([10.239.159.24])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2021 01:01:20 -0800
From:   Chenyi Qiang <chenyi.qiang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/3] Add KVM support for bus lock debug exception
Date:   Tue,  2 Feb 2021 17:04:30 +0800
Message-Id: <20210202090433.13441-1-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A bus lock is acquired either through split locked access to writeback
(WB) memory or by using locks to uncacheable (UC) memory. This is
typically > 1000 cycles slower than atomic opertaion within a cache
line. It also disrupts performance on other cores.

Bus lock debug exception is a sub-feature of bus lock detection. It is
an ability to notify the kernel by an #DB trap after the instruction
acquires a bus lock when CPL>0. This allows the kernel to enforce user
application throttling or mitigatioins.

Expose the bus lock debug exception to guest by the enumeration of
CPUID.(EAX=7,ECX=0).ECX[24]. Software in guest can enable these
exceptions by setting the DEBUGCTLMSR_BUS_LOCK_DETECT(bit 2) of
MSR_IA32_DEBUTCTL.

The bus lock #DB exception can also be intercepted by the VMM and
identified through the bit 11 of the exit qualification at VM exit. The
bit 11 (DR6_BUS_LOCK) of DR6 register is introduced to indicate a bus
lock #DB exception. DR6_BUS_LOCK has formerly always been 1 and delivery
of a bus lock #DB clears it. The VMM should emulate the exceptions by
clearing the bit 11 of the guest DR6.

Bus lock debug exception kernel patches are available at:
https://lore.kernel.org/lkml/20201124205245.4164633-1-fenghua.yu@intel.com

Document for Bus Lock Detection is now available at the latest "Intel
Architecture Instruction Set Extensions Programming Reference".

Document Link:
https://software.intel.com/content/www/us/en/develop/download/intel-architecture-instruction-set-extensions-programming-reference.html

---

Changelogs

v1->v2:
- rename the DR6_INIT to DR6_LOW_ACTIVE suggested by Paolo and split it
  out as a new commit.
- KVM v1:https://lore.kernel.org/lkml/20210108064924.1677-1-chenyi.qiang@intel.com


Chenyi Qiang (3):
  KVM: X86: Rename DR6_INIT to DR6_ACTIVE_LOW
  KVM: X86: Add support for the emulation of DR6_BUS_LOCK bit
  KVM: X86: Expose bus lock debug exception to guest

 arch/x86/include/asm/kvm_host.h | 14 +++++++--
 arch/x86/kvm/cpuid.c            |  3 +-
 arch/x86/kvm/emulate.c          |  2 +-
 arch/x86/kvm/svm/nested.c       |  2 +-
 arch/x86/kvm/svm/svm.c          |  6 ++--
 arch/x86/kvm/vmx/nested.c       |  4 +--
 arch/x86/kvm/vmx/vmx.c          | 27 ++++++++++++++---
 arch/x86/kvm/x86.c              | 52 +++++++++++++++------------------
 arch/x86/kvm/x86.h              |  2 ++
 9 files changed, 69 insertions(+), 43 deletions(-)

-- 
2.17.1

