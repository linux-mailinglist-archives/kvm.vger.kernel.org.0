Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78B426EBBA
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2019 22:41:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731247AbfGSUlU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Jul 2019 16:41:20 -0400
Received: from mga12.intel.com ([192.55.52.136]:46747 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728051AbfGSUlU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Jul 2019 16:41:20 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Jul 2019 13:41:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,283,1559545200"; 
   d="scan'208";a="168655824"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.165])
  by fmsmga008.fm.intel.com with ESMTP; 19 Jul 2019 13:41:19 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, Josh Poimboeuf <jpoimboe@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/5] KVM: VMX: Optimize VMX instrs error/fault handling
Date:   Fri, 19 Jul 2019 13:41:05 -0700
Message-Id: <20190719204110.18306-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A recent commit reworked __kvm_handle_fault_on_reboot() to play nice with
objtool.  An unfortunate side effect is that JMP is now inserted after
most VMX instructions so that the reboot macro can use an actual CALL to
kvm_spurious_fault() instead of a funky PUSH+JMP facsimile in .fixup.

Rework the low level VMX instruction helpers to handle unexpected faults
manually instead of relying on the "fault on reboot" macro.  By using
asm-goto, most helpers can branch directly to an in-function call to
kvm_spurious_fault(), which can then be optimized by compilers to reside
out-of-line at the end of the function instead of inline as done by
"fault on reboot".

The net impact relative to the current code base is more or less a nop
when building with a compiler that supports __GCC_ASM_FLAG_OUTPUTS__.
A bunch of code that was previously in .fixup gets moved into the slow
paths of functions, but the fast paths are more basically unchanged.

Without __GCC_ASM_FLAG_OUTPUTS__, manually coding the Jcc is a net
positive as CC_SET() without compiler support almost always generates a
SETcc+CMP+Jcc sequence, which is now replaced with a single Jcc.

A small bonus is that the Jcc instrs are hinted to predict that the VMX
instr will be successful.

v2:
  - Rebased to x86/master, commit eceffd88ca20 ("Merge branch 'x86/urgent'")
  - Reworded changelogs to reference the commit instead lkml link for
    the recent changes to __kvm_handle_fault_on_reboot().
  - Added Paolo's acks for patch 1-4
  - Added patch 5 to do more cleanup, which was made possible by rebasing
    on top of the __kvm_handle_fault_on_reboot() changes.
  
Sean Christopherson (5):
  objtool: KVM: x86: Check kvm_rebooting in kvm_spurious_fault()
  KVM: VMX: Optimize VMX instruction error and fault handling
  KVM: VMX: Add error handling to VMREAD helper
  KVM: x86: Drop ____kvm_handle_fault_on_reboot()
  KVM: x86: Don't check kvm_rebooting in __kvm_handle_fault_on_reboot()

 arch/x86/include/asm/kvm_host.h | 16 ++----
 arch/x86/kvm/vmx/ops.h          | 93 ++++++++++++++++++++-------------
 arch/x86/kvm/vmx/vmx.c          | 42 +++++++++++++++
 arch/x86/kvm/x86.c              |  3 +-
 tools/objtool/check.c           |  1 -
 5 files changed, 104 insertions(+), 51 deletions(-)

-- 
2.22.0

