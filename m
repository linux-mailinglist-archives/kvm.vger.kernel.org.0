Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD39B183D51
	for <lists+kvm@lfdr.de>; Fri, 13 Mar 2020 00:27:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbgCLX1y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Mar 2020 19:27:54 -0400
Received: from mga14.intel.com ([192.55.52.115]:14954 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726872AbgCLX1s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Mar 2020 19:27:48 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Mar 2020 16:27:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,546,1574150400"; 
   d="scan'208";a="261705945"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga002.jf.intel.com with ESMTP; 12 Mar 2020 16:27:46 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH 7/8] nVMX: Pass exit reason union to is_hypercall()
Date:   Thu, 12 Mar 2020 16:27:44 -0700
Message-Id: <20200312232745.884-8-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200312232745.884-1-sean.j.christopherson@intel.com>
References: <20200312232745.884-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Pass the exit reason captured in VM-Entry results into __enter_guest()'s
helpers to simplify code and eliminate extra VMREADS.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 x86/vmx.c | 19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/x86/vmx.c b/x86/vmx.c
index 35d7fc7..f7f9665 100644
--- a/x86/vmx.c
+++ b/x86/vmx.c
@@ -1553,15 +1553,10 @@ static void __attribute__((__used__)) hypercall(u32 hypercall_no)
 	asm volatile("vmcall\n\t");
 }
 
-static bool is_hypercall(void)
+static bool is_hypercall(union exit_reason exit_reason)
 {
-	ulong reason, hyper_bit;
-
-	reason = vmcs_read(EXI_REASON) & 0xff;
-	hyper_bit = hypercall_field & HYPERCALL_BIT;
-	if (reason == VMX_VMCALL && hyper_bit)
-		return true;
-	return false;
+	return exit_reason.basic == VMX_VMCALL &&
+	       (hypercall_field & HYPERCALL_BIT);
 }
 
 static int handle_hypercall(void)
@@ -1624,7 +1619,7 @@ static int exit_handler(union exit_reason exit_reason)
 
 	current->exits++;
 	regs.rflags = vmcs_read(GUEST_RFLAGS);
-	if (is_hypercall())
+	if (is_hypercall(exit_reason))
 		ret = handle_hypercall();
 	else
 		ret = current->exit_handler(exit_reason);
@@ -1816,9 +1811,9 @@ void test_set_guest(test_guest_func func)
 	v2_guest_main = func;
 }
 
-static void check_for_guest_termination(void)
+static void check_for_guest_termination(union exit_reason exit_reason)
 {
-	if (is_hypercall()) {
+	if (is_hypercall(exit_reason)) {
 		int ret;
 
 		ret = handle_hypercall();
@@ -1867,7 +1862,7 @@ void __enter_guest(u8 abort_flag, struct vmentry_result *result)
 	}
 
 	launched = 1;
-	check_for_guest_termination();
+	check_for_guest_termination(result->exit_reason);
 	return;
 
 do_abort:
-- 
2.24.1

