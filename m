Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D60B221AAD
	for <lists+kvm@lfdr.de>; Thu, 16 Jul 2020 05:18:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728189AbgGPDQ6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jul 2020 23:16:58 -0400
Received: from mga06.intel.com ([134.134.136.31]:8143 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728149AbgGPDQ4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jul 2020 23:16:56 -0400
IronPort-SDR: 1n3+rtKl315Fpj7xjL7c7EdpqVOBmZXVrlbcAynUN4EuST0RvSVFlJIC2ZRqF4w018/cru1jWs
 Fqf3HWyoVvjg==
X-IronPort-AV: E=McAfee;i="6000,8403,9683"; a="210844827"
X-IronPort-AV: E=Sophos;i="5.75,357,1589266800"; 
   d="scan'208";a="210844827"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2020 20:16:55 -0700
IronPort-SDR: WcX57bLryolWS71PxD9B4xqX2K/v7gerMW1I+hLtAkpIn0FpDYDeDdu/htFLlZlhBrTI4PGhli
 88dsjn2ksdww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,357,1589266800"; 
   d="scan'208";a="360910405"
Received: from unknown (HELO local-michael-cet-test.sh.intel.com) ([10.239.159.128])
  by orsmga001.jf.intel.com with ESMTP; 15 Jul 2020 20:16:53 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, sean.j.christopherson@intel.com,
        jmattson@google.com
Cc:     yu.c.zhang@linux.intel.com, Yang Weijiang <weijiang.yang@intel.com>
Subject: [RESEND PATCH v13 00/11] Introduce support for guest CET feature
Date:   Thu, 16 Jul 2020 11:16:16 +0800
Message-Id: <20200716031627.11492-1-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Control-flow Enforcement Technology (CET) provides protection against
Return/Jump-Oriented Programming (ROP/JOP) attack. There're two CET
sub-features: Shadow Stack (SHSTK) and Indirect Branch Tracking (IBT).
SHSTK is to prevent ROP programming and IBT is to prevent JOP programming.

Several parts in KVM have been updated to provide VM CET support, including:
CPUID/XSAVES config, MSR pass-through, user space MSR access interface, 
vmentry/vmexit config, nested VM etc. These patches have dependency on CET
kernel patches for xsaves support and CET definitions, e.g., MSR and related
feature flags.

CET kernel patches are here:
https://lkml.kernel.org/r/20200429220732.31602-1-yu-cheng.yu@intel.com

v13:
- Added CET definitions as a separate patch to facilitate KVM test.
- Disabled CET support in KVM if unrestricted_guest is turned off since
  in this case CET related instructions/infrastructure cannot be emulated
  well.
- Don't expose CET feature to guest if host kernel doesn't support CET.
- Rebased the series to v5.8-rc5, commit: 11ba468877bb

v12:
- Fixed a few issues per Sean and Paolo's review feeback.
- Refactored patches to make them properly arranged.
- Removed unnecessary hard-coded CET states for host/guest.
- Added compile-time assertions for vmcs_field_to_offset_table to detect
  mismatch of the field type and field encoding number.
- Added a custom MSR MSR_KVM_GUEST_SSP for guest active SSP save/restore.
- Rebased patches to 5.7-rc3.

v11:
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

v10:
- Refactored code per Sean's review feedback.
- Added CET support for nested VM.
- Removed fix-patch for CPUID(0xd,N) enumeration as this part is done
  by Paolo and Sean.
- This new patchset is based on Paolo's queued cpu_caps branch.
- Modified patch per XSAVES related change.
- Consolidated KVM unit-test patch with KVM patches.

v9:
- Refactored msr-check functions per Sean's feedback.
- Fixed a few issues per Sean's suggestion.
- Rebased patch to kernel-v5.4.
- Moved CET CPUID feature bits and CR4.CET to last patch.

v8:
- Addressed Jim and Sean's feedback on: 1) CPUID(0xD,i) enumeration. 2)
  sanity check when configure guest CET. 3) function improvement.
- Added more sanity check functions.
- Set host vmexit default status so that guest won't leak CET status to
  host when vmexit.
- Added CR0.WP vs. CR4.CET mutual constrains.

v7:
- Rebased patch to kernel v5.3
- Sean suggested to change CPUID(0xd, n) enumeration code as alined with
  existing one, and I think it's better to make the fix as an independent patch 
  since XSS MSR are being used widely on X86 platforms.
- Check more host and guest status before configure guest CET
  per Sean's feedback.
- Add error-check before guest accesses CET MSRs per Sean's feedback.
- Other minor fixes suggested by Sean.

v6:
- Rebase patch to kernel v5.2.
- Move CPUID(0xD, n>=1) helper to a seperate patch.
- Merge xsave size fix with other patch.
- Other minor fixes per community feedback.

v5:
- Rebase patch to kernel v5.1.
- Wrap CPUID(0xD, n>=1) code to a helper function.
- Pass through MSR_IA32_PL1_SSP and MSR_IA32_PL2_SSP to Guest.
- Add Co-developed-by expression in patch description.
- Refine patch description.

v4:
- Add Sean's patch for loading Guest fpu state before access XSAVES
  managed CET MSRs.
- Melt down CET bits setting into CPUID configuration patch.
- Add VMX interface to query Host XSS.
- Check Host and Guest XSS support bits before set Guest XSS.
- Make Guest SHSTK and IBT feature enabling independent.
- Do not report CET support to Guest when Host CET feature is Disabled.

v3:
- Modified patches to make Guest CET independent to Host enabling.
- Added patch 8 to add user space access for Guest CET MSR access.
- Modified code comments and patch description to reflect changes.

v2:
- Re-ordered patch sequence, combined one patch.
- Added more description for CET related VMCS fields.
- Added Host CET capability check while enabling Guest CET loading bit.
- Added Host CET capability check while reporting Guest CPUID(EAX=7, EXC=0).
- Modified code in reporting Guest CPUID(EAX=D,ECX>=1), make it clearer.
- Added Host and Guest XSS mask check while setting bits for Guest XSS.

Sean Christopherson (1):
  KVM: x86: Load guest fpu state when access MSRs managed by XSAVES

Yang Weijiang (10):
  KVM: x86: Include CET definitions for KVM test purpose
  KVM: VMX: Introduce CET VMCS fields and flags
  KVM: VMX: Set guest CET MSRs per KVM and host configuration
  KVM: VMX: Configure CET settings upon guest CR0/4 changing
  KVM: x86: Refresh CPUID once guest changes XSS bits
  KVM: x86: Add userspace access interface for CET MSRs
  KVM: VMX: Enable CET support for nested VM
  KVM: VMX: Add VMCS dump and sanity check for CET states
  KVM: x86: Add #CP support in guest exception dispatch
  KVM: x86: Enable CET virtualization and advertise CET to userspace

 arch/x86/include/asm/kvm_host.h      |   4 +-
 arch/x86/include/asm/vmx.h           |   8 +
 arch/x86/include/uapi/asm/kvm.h      |   1 +
 arch/x86/include/uapi/asm/kvm_para.h |   7 +-
 arch/x86/kvm/cpuid.c                 |  28 ++-
 arch/x86/kvm/vmx/capabilities.h      |   5 +
 arch/x86/kvm/vmx/nested.c            |  34 ++++
 arch/x86/kvm/vmx/vmcs12.c            | 267 ++++++++++++++++-----------
 arch/x86/kvm/vmx/vmcs12.h            |  14 +-
 arch/x86/kvm/vmx/vmx.c               | 262 +++++++++++++++++++++++++-
 arch/x86/kvm/x86.c                   |  53 +++++-
 arch/x86/kvm/x86.h                   |   2 +-
 include/linux/kvm_host.h             |  32 ++++
 13 files changed, 590 insertions(+), 127 deletions(-)

-- 
2.17.2

