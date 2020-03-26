Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 623CD193AA4
	for <lists+kvm@lfdr.de>; Thu, 26 Mar 2020 09:16:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727656AbgCZIP7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Mar 2020 04:15:59 -0400
Received: from mga02.intel.com ([134.134.136.20]:27555 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726298AbgCZIP7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Mar 2020 04:15:59 -0400
IronPort-SDR: gETYUXWuPltYKHUr6p9v9L11Zo/TK0QCIxDnf2STY5FmrWkI2Z0W+3CxOSFJocdJKliVRCau93
 qNCd6zs9Nc3Q==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2020 01:15:58 -0700
IronPort-SDR: xk+6ZvxFpr0srCx4pxzWjlrkRVfTarECFniJ5feN/lkD/u/kKDbVGaadgS3ZZvaDdCnfeDvz/O
 wiXc/zX24y+Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,307,1580803200"; 
   d="scan'208";a="393898809"
Received: from local-michael-cet-test.sh.intel.com ([10.239.159.128])
  by orsmga004.jf.intel.com with ESMTP; 26 Mar 2020 01:15:55 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, sean.j.christopherson@intel.com,
        jmattson@google.com
Cc:     yu.c.zhang@linux.intel.com, Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v11 0/9] Introduce support for guest CET feature
Date:   Thu, 26 Mar 2020 16:18:37 +0800
Message-Id: <20200326081847.5870-1-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Control-flow Enforcement Technology (CET) provides protection against
Return/Jump-Oriented Programming (ROP/JOP) attack. It includes two
sub-features: Shadow Stack (SHSTK) and Indirect Branch Tracking (IBT).

KVM needs to update to enable guest CET feature.
This patchset implements CET related CPUID/XSAVES enumeration, MSRs
and vmentry/vmexit configuration etc.so that guest kernel can setup CET
runtime infrastructure based on them. Some CET MSRs and related feature
flags used reference the definitions in kernel patchset.

CET kernel patches are here:
https://lkml.org/lkml/2020/2/5/593
https://lkml.org/lkml/2020/2/5/604

v10 -> v11
- Fixed a guest vmentry failure issue when guest reboots.
- Used vm_xxx_control_{set, clear}bit() to avoid side effect, it'll
  clear cached data instead of pure VMCS field bits.
- Added vcpu->arch.guest_supported_xss dedidated for guest runtime mask,
  this avoids supported_xss overwritten issue caused by an old qemu.
- Separated vmentry/vmexit state setting with CR0/CR4 dependency check
  to make the patch more clear.
- Added CET VMCS states in dump_vmcs() for debugging purpose.
- Other refactor based on testing.
- This patch serial is built on top of below branch and CET kernel patches
  for seeking xsaves support:
  https://git.kernel.org/pub/scm/virt/kvm/kvm.git/log/?h=cpu-caps

v9 -> v10
- Refactored code per Sean's review feedback.
- Added CET support for nested VM.
- Removed fix-patch for CPUID(0xd,N) enumeration as this part is done
  by Paolo and Sean.
- This new patchset is based on Paolo's queued cpu_caps branch.
- Modified patch per XSAVES related change.
- Consolidated KVM unit-test patch with KVM patches.

v8 -> v9:
- Refactored msr-check functions per Sean's feedback.
- Fixed a few issues per Sean's suggestion.
- Rebased patch to kernel-v5.4.
- Moved CET CPUID feature bits and CR4.CET to last patch.

v7 -> v8:
- Addressed Jim and Sean's feedback on: 1) CPUID(0xD,i) enumeration. 2)
  sanity check when configure guest CET. 3) function improvement.
- Added more sanity check functions.
- Set host vmexit default status so that guest won't leak CET status to
  host when vmexit.
- Added CR0.WP vs. CR4.CET mutual constrains.

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



Sean Christopherson (1):
  KVM: X86: Load guest fpu state when access MSRs managed by XSAVES

Yang Weijiang (8):
  KVM: VMX: Introduce CET VMX fields and flags
  KVM: VMX: Set guest CET MSRs per KVM and host configuration
  KVM: VMX: Set host/guest CET states for vmexit/vmentry
  KVM: VMX: Check CET dependencies on CR settings
  KVM: X86: Refresh CPUID once guest XSS MSR changes
  KVM: X86: Add userspace access interface for CET MSRs
  KVM: VMX: Enable CET support for nested VM
  KVM: X86: Set CET feature bits for CPUID enumeration

 arch/x86/include/asm/kvm_host.h |   4 +-
 arch/x86/include/asm/vmx.h      |   8 ++
 arch/x86/include/uapi/asm/kvm.h |   1 +
 arch/x86/kvm/cpuid.c            |  25 +++-
 arch/x86/kvm/vmx/capabilities.h |  10 ++
 arch/x86/kvm/vmx/nested.c       |  41 +++++-
 arch/x86/kvm/vmx/vmcs12.c       |   6 +
 arch/x86/kvm/vmx/vmcs12.h       |  14 +-
 arch/x86/kvm/vmx/vmx.c          | 232 +++++++++++++++++++++++++++++++-
 arch/x86/kvm/x86.c              |  46 ++++++-
 arch/x86/kvm/x86.h              |   2 +-
 11 files changed, 376 insertions(+), 13 deletions(-)

-- 
2.17.2

