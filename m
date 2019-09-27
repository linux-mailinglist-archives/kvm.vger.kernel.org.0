Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF8F8BFD13
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 04:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727897AbfI0CRJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Sep 2019 22:17:09 -0400
Received: from mga17.intel.com ([192.55.52.151]:25572 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726140AbfI0CRJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Sep 2019 22:17:09 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Sep 2019 19:17:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,553,1559545200"; 
   d="scan'208";a="193020627"
Received: from unknown (HELO local-michael-cet-test.sh.intel.com) ([10.239.159.128])
  by orsmga003.jf.intel.com with ESMTP; 26 Sep 2019 19:17:06 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, sean.j.christopherson@intel.com
Cc:     mst@redhat.com, rkrcmar@redhat.com, jmattson@google.com,
        Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v7 0/7] Introduce support for Guest CET feature
Date:   Fri, 27 Sep 2019 10:19:20 +0800
Message-Id: <20190927021927.23057-1-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Control-flow Enforcement Technology (CET) provides protection against
Return/Jump-Oriented Programming (ROP/JOP) attack. It includes two
sub-features: Shadow Stack (SHSTK) and Indirect Branch Tracking (IBT).

KVM modification is required to support Guest CET feature.
This patch serial implemented CET related CPUID/XSAVES enumeration, MSRs
and VMEntry configuration etc.so that Guest kernel can setup CET
runtime infrastructure based on them. Some MSRs and related feature
flags used in the patches reference the definitions in kernel patch.

CET kernel patches is here:
https://lkml.org/lkml/2019/8/13/1110
https://lkml.org/lkml/2019/8/13/1109

v6 -> v7:
- Rebased patch to kernel v5.3
- Sean suggested to change CPUID(0xd, n) enumeration code as alined with
  existing one, and I think it's better to make the fix as an independent patch 
  since XSS MSR are being used widely on X86 platforms.
- Check more host and guest status before configure guest CET
  per Sean's feedback.
- Add error-check before guest accesses CET MSRs per Sean's feedback.
- Other minor fixes suggested by Sean.

v5 -> v6:
- Rebase patch to kernel v5.2.
- Move CPUID(0xD, n>=1) helper to a seperate patch.
- Merge xsave size fix with other patch.
- Other minor fixes per community feedback.

v4 -> v5:
- Rebase patch to kernel v5.1.
- Wrap CPUID(0xD, n>=1) code to a helper function.
- Pass through MSR_IA32_PL1_SSP and MSR_IA32_PL2_SSP to Guest.
- Add Co-developed-by expression in patch description.
- Refine patch description.

v3 -> v4:
- Add Sean's patch for loading Guest fpu state before access XSAVES
  managed CET MSRs.
- Melt down CET bits setting into CPUID configuration patch.
- Add VMX interface to query Host XSS.
- Check Host and Guest XSS support bits before set Guest XSS.
- Make Guest SHSTK and IBT feature enabling independent.
- Do not report CET support to Guest when Host CET feature is Disabled.

v2 -> v3:
- Modified patches to make Guest CET independent to Host enabling.
- Added patch 8 to add user space access for Guest CET MSR access.
- Modified code comments and patch description to reflect changes.

v1 -> v2:
- Re-ordered patch sequence, combined one patch.
- Added more description for CET related VMCS fields.
- Added Host CET capability check while enabling Guest CET loading bit.
- Added Host CET capability check while reporting Guest CPUID(EAX=7, EXC=0).
- Modified code in reporting Guest CPUID(EAX=D,ECX>=1), make it clearer.
- Added Host and Guest XSS mask check while setting bits for Guest XSS.


PATCH 1    : Fix CPUID(0xD, n) enumeration to support XSS MSR.
PATCH 2    : Define CET VMCS fields and bits.
PATCH 3    : Pass through CET MSRs to Guest.
PATCH 4    : Load Guest CET states when CET is enabled.
PATCH 5    : Add CET CR4 bit and CET xsaves support in XSS MSR.
PATCH 6    : Load Guest FPU states for XSAVES managed MSRs.
PATCH 7    : Add user-space CET MSR access interface.


Sean Christopherson (1):
  KVM: x86: Load Guest fpu state when accessing MSRs managed by XSAVES

Yang Weijiang (6):
  KVM: CPUID: Fix IA32_XSS support in CPUID(0xd,i) enumeration
  KVM: VMX: Define CET VMCS fields and CPUID flags
  KVM: VMX: Pass through CET related MSRs to Guest
  KVM: VMX: Load Guest CET via VMCS when CET is enabled in Guest
  KVM: X86: Add CET CR4 bit and XSS support
  KVM: X86: Add user-space access interface for CET MSRs

 arch/x86/include/asm/kvm_host.h |   5 +-
 arch/x86/include/asm/vmx.h      |   8 ++
 arch/x86/kvm/cpuid.c            | 110 ++++++++++++++-------
 arch/x86/kvm/cpuid.h            |   2 +
 arch/x86/kvm/svm.c              |   7 ++
 arch/x86/kvm/vmx/vmx.c          | 169 +++++++++++++++++++++++++++++++-
 arch/x86/kvm/x86.c              |  22 ++++-
 arch/x86/kvm/x86.h              |   8 ++
 8 files changed, 287 insertions(+), 44 deletions(-)

-- 
2.17.2

