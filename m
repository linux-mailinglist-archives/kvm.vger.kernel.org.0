Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21877429A0B
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 02:06:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235005AbhJLAIa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Oct 2021 20:08:30 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:51286 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231351AbhJLAIY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Oct 2021 20:08:24 -0400
Message-ID: <20211011223611.008987641@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1633997180;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=vJplmk5mLqHish4MRg29kcJ/vnY99dO9+83MpoObvg0=;
        b=4g850/Yt3H3l3cl9haoFNQ+WNNd1tjBIMr+pGb5RAqQGPCw0OkRttRgiCAinaeDcLuhD+7
        TjhfSzNEbyTGix9z0Nggg6cvxuSMTdtckbMCt9AYN4LRhZa2EQS3E2nQHZw6E9jlhZCYJ1
        S8NXR8XRhGJrrw4ylc63fU1E97DO7pw2Um6EiGNM0seOowC+8G0/QPKGUOFMiJ1GLd4846
        pnKzOVV7Bo9QMcvSxSS5OUN2Qnsaiaqu2W4ctlbJNvdu8nYeKTCIIgtzze4Z0vP71N5E+C
        0VtpHRE17dl2OYv94/xFN/ulTmKREOZLOu4slitalIiQjUkTfXQAWgFZZ0uuaA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1633997180;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=vJplmk5mLqHish4MRg29kcJ/vnY99dO9+83MpoObvg0=;
        b=zWVTD6BkuA8n22nt7clyuxFZSb+Bf5WS87149Y+h/SWtaCl/bIM1fOYabgQ2VOOG+mgeDM
        imogWjg/IETJxcDA==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [patch 12/31] x86/fpu/xstate: Mark all init only functions __init
References: <20211011215813.558681373@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Tue, 12 Oct 2021 02:00:16 +0200 (CEST)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

No point to keep them around after boot.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/fpu/xstate.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -462,7 +462,7 @@ static int validate_user_xstate_header(c
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
@@ -544,7 +544,7 @@ static void check_xstate_against_struct(
  * covered by these checks. Only the size of the buffer for task->fpu
  * is checked here.
  */
-static void do_extra_xstate_size_checks(void)
+static void __init do_extra_xstate_size_checks(void)
 {
 	int paranoid_xstate_size = FXSAVE_SIZE + XSAVE_HDR_SIZE;
 	int i;
@@ -646,7 +646,7 @@ static unsigned int __init get_xsave_siz
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

