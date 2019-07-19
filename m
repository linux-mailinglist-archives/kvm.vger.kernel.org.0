Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8521D6EA15
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2019 19:26:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731362AbfGSRZo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Jul 2019 13:25:44 -0400
Received: from mga14.intel.com ([192.55.52.115]:21962 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729425AbfGSRZo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Jul 2019 13:25:44 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Jul 2019 10:25:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,283,1559545200"; 
   d="scan'208";a="252213010"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.165])
  by orsmga001.jf.intel.com with ESMTP; 19 Jul 2019 10:25:42 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     kvm@vger.kernel.org
Subject: [PATCH 4/4] KVM: x86: Drop ____kvm_handle_fault_on_reboot()
Date:   Fri, 19 Jul 2019 10:25:40 -0700
Message-Id: <20190719172540.7697-5-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190719172540.7697-1-sean.j.christopherson@intel.com>
References: <20190719172540.7697-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove the variation of __kvm_handle_fault_on_reboot() that accepts a
post-fault cleanup instruction now that its previous sole user, VMREAD,
uses a different method for handling faults.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_host.h | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 0cc5b611a113..fefc5c4b3cad 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1503,12 +1503,11 @@ enum {
  */
 asmlinkage void kvm_spurious_fault(void);
 
-#define ____kvm_handle_fault_on_reboot(insn, cleanup_insn)	\
+#define __kvm_handle_fault_on_reboot(insn)	\
 	"666: " insn "\n\t" \
 	"668: \n\t"                           \
 	".pushsection .fixup, \"ax\" \n" \
 	"667: \n\t" \
-	cleanup_insn "\n\t"		      \
 	"cmpb $0, kvm_rebooting \n\t"	      \
 	"jne 668b \n\t"      		      \
 	__ASM_SIZE(push) " $666b \n\t"	      \
@@ -1516,9 +1515,6 @@ asmlinkage void kvm_spurious_fault(void);
 	".popsection \n\t" \
 	_ASM_EXTABLE(666b, 667b)
 
-#define __kvm_handle_fault_on_reboot(insn)		\
-	____kvm_handle_fault_on_reboot(insn, "")
-
 #define KVM_ARCH_WANT_MMU_NOTIFIER
 int kvm_unmap_hva_range(struct kvm *kvm, unsigned long start, unsigned long end);
 int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end);
-- 
2.22.0

