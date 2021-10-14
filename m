Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 437CF42E49A
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 01:09:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234400AbhJNXLs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 19:11:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234338AbhJNXLi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Oct 2021 19:11:38 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50A7DC061753;
        Thu, 14 Oct 2021 16:09:33 -0700 (PDT)
Message-ID: <20211014230739.184014242@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634252971;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=3waKzyY1T7PuMxjCNrXEk0Bp26hUU6HXuRX+FyaOY24=;
        b=Qn1Pkzn87g4uwvEYpSI7nYS57SA4ObeHiCQZ5y0kMmkvM1C2ApRv6/cnfB+owMlLVDdbU3
        sY9BiZ1KyIrNbdRapRfyistRccNgREG8jcqs2PuHWAg2w/GYlpw6z66a+aUUNosYCBM/Ll
        roXHhaUVbvXDeMMzpvTqGCFVpbC9806ErwFFKCnbnETVia5d+LKwoE0+7e9fmjfgEaMmzy
        xXmrRV2oZVPRZwpipRDHp2eeIp/J4eTdyQ5JOTytEDr/Kh46DZx/DaKWq3QJWnHroEAUjo
        zDwWRdBtbd5hv60ml4Vgq/xEAgjEPkxDrVLld1zIxG3MdF//LIWvuC4bsA1F9A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634252971;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=3waKzyY1T7PuMxjCNrXEk0Bp26hUU6HXuRX+FyaOY24=;
        b=NoV8jzCW56WvEkPIoOlHQ1aOs4l8psUBuTtBL3Xt6hVJJIQB0SmOEEfbwtfKAfU35G2VL3
        oj0eGj8p8aLE97BQ==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [patch 2/8] x86/fpu: Cleanup fpu__init_system_xstate_size_legacy()
References: <20211014225711.615197738@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Fri, 15 Oct 2021 01:09:31 +0200 (CEST)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Clean the function up before making changes.

No functional change.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/fpu/init.c |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

--- a/arch/x86/kernel/fpu/init.c
+++ b/arch/x86/kernel/fpu/init.c
@@ -199,17 +199,12 @@ static void __init fpu__init_system_xsta
 	 * Note that xstate sizes might be overwritten later during
 	 * fpu__init_system_xstate().
 	 */
-
-	if (!boot_cpu_has(X86_FEATURE_FPU)) {
+	if (!cpu_feature_enabled(X86_FEATURE_FPU))
 		fpu_kernel_xstate_size = sizeof(struct swregs_state);
-	} else {
-		if (boot_cpu_has(X86_FEATURE_FXSR))
-			fpu_kernel_xstate_size =
-				sizeof(struct fxregs_state);
-		else
-			fpu_kernel_xstate_size =
-				sizeof(struct fregs_state);
-	}
+	else if (cpu_feature_enabled(X86_FEATURE_FXSR))
+		fpu_kernel_xstate_size = sizeof(struct fxregs_state);
+	else
+		fpu_kernel_xstate_size = sizeof(struct fregs_state);
 
 	fpu_user_xstate_size = fpu_kernel_xstate_size;
 	fpstate_reset(&current->thread.fpu);

