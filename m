Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89C94429A35
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 02:07:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236282AbhJLAJf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Oct 2021 20:09:35 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:51396 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231886AbhJLAIZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Oct 2021 20:08:25 -0400
Message-ID: <20211011223610.524176686@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1633997182;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=Az4teqBX37vif9hCrLNnZFZ28q4lgGFyyPMu6OSHNTs=;
        b=YYTQ0Nc1wQpJQxX5p8jGnIK1+jgqsu6Zc5pexORO+BSfUT7jwVS/6YL7tlAdItV67pOd91
        lkV3BlabkL1+VWUoebgKGJTWXYlEgbnq+K0wH+gHQReQSq/kzdoramTTv8vYVwXCWTalQa
        040xb4KYGYxkOHHnp3FXJ2NdB5g0EXc9KCbHoXXJ4wccz0yZzzC97nuZJQ6Td9cbi3JKG7
        tTEPk2954FEGedATF3ut8LroesSwTYSzMtNUrdQZZYKwI+PggxP4eL4RHFJhazq+m8hEVQ
        flmexavRBeoBZYlFE4XtjkQlfSabSc+as/56NuCLU7S/IAvgSJA+Nn3skk79dA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1633997182;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=Az4teqBX37vif9hCrLNnZFZ28q4lgGFyyPMu6OSHNTs=;
        b=jTftb3uApnXxQgYi1tryhvrgcEUsZxXp1Yba96DLlfeLAUGcEI3FNupn/U0qGFq1RX/7QX
        7REdTx33R9e6BeBw==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [patch 04/31] x86/fpu: Restrict xsaves()/xrstors() to independent states
References: <20211011215813.558681373@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Tue, 12 Oct 2021 02:00:04 +0200 (CEST)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

These interfaces are really only valid for features which are independently
managed and not part of the task context state for various reasons.

Tighten the checks and adjust the misleading comments.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/fpu/xstate.c |   14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -1182,13 +1182,9 @@ static bool validate_xsaves_xrstors(u64
 	if (WARN_ON_FPU(!cpu_feature_enabled(X86_FEATURE_XSAVES)))
 		return false;
 	/*
-	 * Validate that this is either a task->fpstate related component
-	 * subset or an independent one.
+	 * Validate that this is a independent compoment.
 	 */
-	if (mask & xfeatures_mask_independent())
-		xchk = ~xfeatures_mask_independent();
-	else
-		xchk = ~xfeatures_mask_all;
+	xchk = ~xfeatures_mask_independent();
 
 	if (WARN_ON_ONCE(!mask || mask & xchk))
 		return false;
@@ -1206,8 +1202,7 @@ static bool validate_xsaves_xrstors(u64
  * buffer should be zeroed otherwise a consecutive XRSTORS from that buffer
  * can #GP.
  *
- * The feature mask must either be a subset of the independent features or
- * a subset of the task->fpstate related features.
+ * The feature mask must be a subset of the independent features
  */
 void xsaves(struct xregs_state *xstate, u64 mask)
 {
@@ -1231,8 +1226,7 @@ void xsaves(struct xregs_state *xstate,
  * Proper usage is to restore the state which was saved with
  * xsaves() into @xstate.
  *
- * The feature mask must either be a subset of the independent features or
- * a subset of the task->fpstate related features.
+ * The feature mask must be a subset of the independent features
  */
 void xrstors(struct xregs_state *xstate, u64 mask)
 {

