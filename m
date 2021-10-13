Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9C5F42C43D
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 16:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238539AbhJMO6r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 10:58:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238542AbhJMO6K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Oct 2021 10:58:10 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A471C06177B;
        Wed, 13 Oct 2021 07:55:53 -0700 (PDT)
Message-ID: <20211013145323.077781448@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634136951;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=YP1CP9Xf5ROQgVwmt9Wg47yzn0wbL0Hvqv4B5Z8LC0g=;
        b=a3XrpP/QAAwl7aTu2bdzhdpXK7fruh6y4RBIfqlgXGwH2p2GImGM42rpiLw96ZDlnHhbUN
        jvDe3MCJtFcwOObynShkDoYeKt3aSCynP4BWckYPyzAL7PWH04nqOnKIPYJMVpuo1y1h30
        t/eUM834PHdBiZAvQd7atWwtos09i3diKoMBgFZyorKf5tjIkKOV1KsjKWzESxpWMvo4RD
        pDKs76DwaGd0vLf8oKLU3nWcmGDNjCFG7Kn0uH64LUYPtWkcwGyopamwfQgPevMbjnnRkf
        u6sn66WGlHMXHRG+BRKOxeCVeLiSkMu3ahMc7dCOnMKXqk7YJnn3GZWZwsq/gA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634136951;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=YP1CP9Xf5ROQgVwmt9Wg47yzn0wbL0Hvqv4B5Z8LC0g=;
        b=HSjC3R/EMwQCMCTflIjYBjT/7dtqDDL+aP6wHkEA//57Pcc+jJxaFLJDTSKsH8QqbDRcwh
        O6PDOqMjD0Xc9GAg==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [patch 17/21] x86/fpu/xstate: Use fpstate for xsave_to_user_sigframe()
References: <20211013142847.120153383@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Wed, 13 Oct 2021 16:55:51 +0200 (CEST)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With dynamically enabled features the sigframe code must know the features
which are enabled for the task. Get them from fpstate.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/fpu/xstate.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/fpu/xstate.h
+++ b/arch/x86/kernel/fpu/xstate.h
@@ -149,7 +149,7 @@ static inline int xsave_to_user_sigframe
 	 * internally, e.g. PKRU. That's user space ABI and also required
 	 * to allow the signal handler to modify PKRU.
 	 */
-	u64 mask = xfeatures_mask_uabi();
+	u64 mask = current->thread.fpu.fpstate->user_xfeatures;
 	u32 lmask = mask;
 	u32 hmask = mask >> 32;
 	int err;

