Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60A936EBBC
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2019 22:41:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388308AbfGSUlp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Jul 2019 16:41:45 -0400
Received: from mga12.intel.com ([192.55.52.136]:46747 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728346AbfGSUlU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Jul 2019 16:41:20 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Jul 2019 13:41:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,283,1559545200"; 
   d="scan'208";a="168655827"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.165])
  by fmsmga008.fm.intel.com with ESMTP; 19 Jul 2019 13:41:20 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, Josh Poimboeuf <jpoimboe@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/5] objtool: KVM: x86: Check kvm_rebooting in kvm_spurious_fault()
Date:   Fri, 19 Jul 2019 13:41:06 -0700
Message-Id: <20190719204110.18306-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190719204110.18306-1-sean.j.christopherson@intel.com>
References: <20190719204110.18306-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Explicitly check kvm_reboot in kvm_spurious_fault() prior to invoking
BUG(), as opposed to assuming the caller has already done so.  Letting
kvm_spurious_fault() be called "directly" will allow VMX to better
optimize its low level assembly flows.

As a happy side effect, kvm_spurious_fault() no longer needs to be
marked as a dead end since it doesn't unconditionally BUG().

Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_host.h | 2 +-
 arch/x86/kvm/x86.c              | 3 ++-
 tools/objtool/check.c           | 1 -
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 8282b8d41209..9739ed615faf 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1496,7 +1496,7 @@ enum {
 #define kvm_arch_vcpu_memslots_id(vcpu) ((vcpu)->arch.hflags & HF_SMM_MASK ? 1 : 0)
 #define kvm_memslots_for_spte_role(kvm, role) __kvm_memslots(kvm, (role).smm)
 
-asmlinkage void __noreturn kvm_spurious_fault(void);
+asmlinkage void kvm_spurious_fault(void);
 
 /*
  * Hardware virtualization extension instructions may fault if a
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4a0b74ecd1de..6bc012afb86a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -356,7 +356,8 @@ EXPORT_SYMBOL_GPL(kvm_set_apic_base);
 asmlinkage __visible void kvm_spurious_fault(void)
 {
 	/* Fault while not rebooting.  We want the trace. */
-	BUG();
+	if (!kvm_rebooting)
+		BUG();
 }
 EXPORT_SYMBOL_GPL(kvm_spurious_fault);
 
diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 5f26620f13f5..688a9af8124d 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -138,7 +138,6 @@ static bool __dead_end_function(struct objtool_file *file, struct symbol *func,
 		"do_task_dead",
 		"__module_put_and_exit",
 		"complete_and_exit",
-		"kvm_spurious_fault",
 		"__reiserfs_panic",
 		"lbug_with_loc",
 		"fortify_panic",
-- 
2.22.0

