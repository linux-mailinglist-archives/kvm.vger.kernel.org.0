Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 826CD42E5E0
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 03:16:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234761AbhJOBSc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 21:18:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233617AbhJOBSS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Oct 2021 21:18:18 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEF48C061755;
        Thu, 14 Oct 2021 18:16:12 -0700 (PDT)
Message-ID: <20211015011539.017919252@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634260571;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=KIumDjyjiVF2o609MDPzkt6ytEuSTGly13lmlNZ3VVg=;
        b=Ibb4Oz4X1Rre/dyRwgz7HNwHLJgsGi0Bf7sFq56bz6F9w4MY9b3mr6uQlszVoH6GOtqFbU
        qmjeZeoqBsm9gOSSfQq71OF6DGVo3gQ7UbNeq5izzxS0lWalNRBV5nsLMyXwRj7QjwRrcx
        LCnw4drHfsatNOkGEYoALrZfhFQ1zv5AqUuo7vvSpTNM8d5uTEkQltBghRV9mKVkqc0KLo
        UA3TH9s0BW1Sd328qhnHV8/INQjnVkiEMHz87pkDswRraZzSBqW5NdMtFEJSv7T2iuDW+Q
        0u4BILIMfljrG5+YnGxAS3jKr8LrW4HvctxMhqQSuRNQleKW/bruVTQA7GG5aw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634260571;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=KIumDjyjiVF2o609MDPzkt6ytEuSTGly13lmlNZ3VVg=;
        b=Y/ueOgmP7SS/CY0eHEgZ1xIFWnaflpBQpmithNc33jnhY4MKKpmYtkgPTmv19SUM2qMpsA
        l7KQu2UMEfddPECA==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [patch V2 11/30] x86/fpu/xstate: Mark all init only functions __init
References: <20211015011411.304289784@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Fri, 15 Oct 2021 03:16:10 +0200 (CEST)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

No point to keep them around after boot.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 arch/x86/kernel/fpu/xstate.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)
---
diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index a2bdc0cf8687..b35ecfa8d450 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -462,7 +462,7 @@ static int validate_user_xstate_header(const struct xstate_header *hdr)
 	return 0;
 }
 
-static void __xstate_dump_leaves(void)
+static void __init __xstate_dump_leaves(void)
 {
 	int i;
 	u32 eax, ebx, ecx, edx;
@@ -502,7 +502,7 @@ static void __xstate_dump_leaves(void)
  * that our software representation matches what the CPU
  * tells us about the state's size.
  */
-static void check_xstate_against_struct(int nr)
+static void __init check_xstate_against_struct(int nr)
 {
 	/*
 	 * Ask the CPU for the size of the state.
@@ -544,7 +544,7 @@ static void check_xstate_against_struct(int nr)
  * covered by these checks. Only the size of the buffer for task->fpu
  * is checked here.
  */
-static void do_extra_xstate_size_checks(void)
+static void __init do_extra_xstate_size_checks(void)
 {
 	int paranoid_xstate_size = FXSAVE_SIZE + XSAVE_HDR_SIZE;
 	int i;
@@ -646,7 +646,7 @@ static unsigned int __init get_xsave_size(void)
  * Will the runtime-enumerated 'xstate_size' fit in the init
  * task's statically-allocated buffer?
  */
-static bool is_supported_xstate_size(unsigned int test_xstate_size)
+static bool __init is_supported_xstate_size(unsigned int test_xstate_size)
 {
 	if (test_xstate_size <= sizeof(union fpregs_state))
 		return true;
@@ -691,7 +691,7 @@ static int __init init_xstate_size(void)
  * We enabled the XSAVE hardware, but something went wrong and
  * we can not use it.  Disable it.
  */
-static void fpu__init_disable_system_xstate(void)
+static void __init fpu__init_disable_system_xstate(void)
 {
 	xfeatures_mask_all = 0;
 	cr4_clear_bits(X86_CR4_OSXSAVE);

