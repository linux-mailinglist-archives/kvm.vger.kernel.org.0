Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC53C6EBB5
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2019 22:41:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388150AbfGSUlX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Jul 2019 16:41:23 -0400
Received: from mga12.intel.com ([192.55.52.136]:46747 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388132AbfGSUlW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Jul 2019 16:41:22 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Jul 2019 13:41:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,283,1559545200"; 
   d="scan'208";a="168655837"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.165])
  by fmsmga008.fm.intel.com with ESMTP; 19 Jul 2019 13:41:21 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, Josh Poimboeuf <jpoimboe@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/5] KVM: x86: Drop ____kvm_handle_fault_on_reboot()
Date:   Fri, 19 Jul 2019 13:41:09 -0700
Message-Id: <20190719204110.18306-5-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190719204110.18306-1-sean.j.christopherson@intel.com>
References: <20190719204110.18306-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove the variation of __kvm_handle_fault_on_reboot() that accepts a
post-fault cleanup instruction now that its sole user (VMREAD) uses
a different method for handling faults.

Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_host.h | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 9739ed615faf..92c59cd923b6 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1504,7 +1504,7 @@ asmlinkage void kvm_spurious_fault(void);
  * Usually after catching the fault we just panic; during reboot
  * instead the instruction is ignored.
  */
-#define ____kvm_handle_fault_on_reboot(insn, cleanup_insn)		\
+#define __kvm_handle_fault_on_reboot(insn)				\
 	"666: \n\t"							\
 	insn "\n\t"							\
 	"jmp	668f \n\t"						\
@@ -1513,16 +1513,12 @@ asmlinkage void kvm_spurious_fault(void);
 	"668: \n\t"							\
 	".pushsection .fixup, \"ax\" \n\t"				\
 	"700: \n\t"							\
-	cleanup_insn "\n\t"						\
 	"cmpb	$0, kvm_rebooting\n\t"					\
 	"je	667b \n\t"						\
 	"jmp	668b \n\t"						\
 	".popsection \n\t"						\
 	_ASM_EXTABLE(666b, 700b)
 
-#define __kvm_handle_fault_on_reboot(insn)		\
-	____kvm_handle_fault_on_reboot(insn, "")
-
 #define KVM_ARCH_WANT_MMU_NOTIFIER
 int kvm_unmap_hva_range(struct kvm *kvm, unsigned long start, unsigned long end);
 int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end);
-- 
2.22.0

