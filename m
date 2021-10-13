Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD5F142C41B
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 16:55:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238019AbhJMO5p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 10:57:45 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:35396 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237654AbhJMO5j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Oct 2021 10:57:39 -0400
Message-ID: <20211013145322.503327333@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634136935;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=AMd0kJ1rCstUZs3aFFlbnYg4MBXkNT2VAG/LpBOLZqI=;
        b=uF3QNt9/6PFjzPUgh6ntRsDKFMDRftqBqtXaBiadHuX6cNB7SH/CjK7ySxAjGdJf3rnKvf
        o0MO35ItnMVHoN1hJPJpbnTDIvP0NyMmoraBZIG+VyFI6mA7OFHkcgHKfCa+USnwJytDux
        tgmRmKdo0iUH9lH5QTnOSODxKAfhZamiNGx3kM1lMjhuRhZVWCSyzbYlcGmEbp7EFaemew
        yuDZWRcIIsGDlkiXTrJWvaigdGQNd0CPeOQ7OncHAos/wCW+zOOpqsjRKjJX6fNvgsxXLk
        u927yqJoFQWHmEs/yp82be6s4iEmlc1sgAcSSLcjD0gDYluiK/FiDZuEdliQdQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634136935;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=AMd0kJ1rCstUZs3aFFlbnYg4MBXkNT2VAG/LpBOLZqI=;
        b=TEwdsL+cA/6XLn4GefYluLNy0pG7Lwlbp3v+65UiW3cVaYpgt/9PnjEgLa0TIzUUyc+StH
        5tlkCS5nwKVV/mAw==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [patch 06/21] x86/fpu: Convert tracing to fpstate
References: <20211013142847.120153383@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Wed, 13 Oct 2021 16:55:34 +0200 (CEST)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Convert FPU tracing code to the new register storage mechanism in
preparation for dynamically sized buffers.

No functional change.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/trace/fpu.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/include/asm/trace/fpu.h
+++ b/arch/x86/include/asm/trace/fpu.h
@@ -22,8 +22,8 @@ DECLARE_EVENT_CLASS(x86_fpu,
 		__entry->fpu		= fpu;
 		__entry->load_fpu	= test_thread_flag(TIF_NEED_FPU_LOAD);
 		if (boot_cpu_has(X86_FEATURE_OSXSAVE)) {
-			__entry->xfeatures = fpu->state.xsave.header.xfeatures;
-			__entry->xcomp_bv  = fpu->state.xsave.header.xcomp_bv;
+			__entry->xfeatures = fpu->fpstate->regs.xsave.header.xfeatures;
+			__entry->xcomp_bv  = fpu->fpstate->regs.xsave.header.xcomp_bv;
 		}
 	),
 	TP_printk("x86/fpu: %p load: %d xfeatures: %llx xcomp_bv: %llx",

