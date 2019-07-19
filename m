Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92FEA6EA13
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2019 19:26:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729873AbfGSRZn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Jul 2019 13:25:43 -0400
Received: from mga14.intel.com ([192.55.52.115]:21962 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729532AbfGSRZm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Jul 2019 13:25:42 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Jul 2019 10:25:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,283,1559545200"; 
   d="scan'208";a="252213002"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.165])
  by orsmga001.jf.intel.com with ESMTP; 19 Jul 2019 10:25:41 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     kvm@vger.kernel.org
Subject: [PATCH 1/4] objtool: KVM: x86: Check kvm_rebooting in kvm_spurious_fault()
Date:   Fri, 19 Jul 2019 10:25:37 -0700
Message-Id: <20190719172540.7697-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190719172540.7697-1-sean.j.christopherson@intel.com>
References: <20190719172540.7697-1-sean.j.christopherson@intel.com>
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

Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/x86.c    | 3 ++-
 tools/objtool/check.c | 1 -
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9d7b9e6a0939..7bbfed3877bd 100644
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
index 172f99195726..bc3b405acce9 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -127,7 +127,6 @@ static int __dead_end_function(struct objtool_file *file, struct symbol *func,
 		"do_task_dead",
 		"__module_put_and_exit",
 		"complete_and_exit",
-		"kvm_spurious_fault",
 		"__reiserfs_panic",
 		"lbug_with_loc",
 		"fortify_panic",
-- 
2.22.0

