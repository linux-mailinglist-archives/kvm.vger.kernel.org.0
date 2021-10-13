Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57E1842C430
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 16:56:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238193AbhJMO6M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 10:58:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238160AbhJMO5u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Oct 2021 10:57:50 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A643DC061766;
        Wed, 13 Oct 2021 07:55:42 -0700 (PDT)
Message-ID: <20211013145322.711347464@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634136941;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=B29BT66jlj++7fWsfB9NcdvP87OUUfI5ksLz0CH91gw=;
        b=H5RIqkfdE3KyL6LbTepBBzIUqlw5P25ljlvHVfU8Y33SUnevXh+KMvSQeQjDi/5vUWRlmy
        UaHEujbjbkDVAsX01I6qtgPMYDwYuQAJp0EN4OA2WEOOKQwDbYJgOFD97k2Jk0JqBv/bYk
        zDwYemoFm/OHzgnLw4NQKuBc/QqxfrvXfVNLB5oEZa6uE5/WoUzHVpYuTJRd04d0F9lOgz
        byYA8clyOHmFaW4/QMHU9/Zb8Ked9/EEfmQ61tWe+LF1G7X4PeiAIPnaTCHrYl9LRWdgwl
        vZwmVsqmb/b57VR/UAwN47GdEtshqelgeylfv7hz94CKkRijOcRAbLNkd6puVA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634136941;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=B29BT66jlj++7fWsfB9NcdvP87OUUfI5ksLz0CH91gw=;
        b=U1F8w8MwDlmax2DIbfHWhKnkg7iKpHCAEyyJZZbUFfla5W3JvgoD5XGRkKYbmy+pYVCUqQ
        k/8YI14hJTcUauBg==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [patch 10/21] x86/math-emu: Convert to fpstate
References: <20211013142847.120153383@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Wed, 13 Oct 2021 16:55:40 +0200 (CEST)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Convert math emulation code to the new register storage
mechanism in preparation for dynamically sized buffers.

No functional change.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/math-emu/fpu_aux.c    |    2 +-
 arch/x86/math-emu/fpu_entry.c  |    4 ++--
 arch/x86/math-emu/fpu_system.h |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

--- a/arch/x86/math-emu/fpu_aux.c
+++ b/arch/x86/math-emu/fpu_aux.c
@@ -53,7 +53,7 @@ void fpstate_init_soft(struct swregs_sta
 
 void finit(void)
 {
-	fpstate_init_soft(&current->thread.fpu.state.soft);
+	fpstate_init_soft(&current->thread.fpu.fpstate->regs.soft);
 }
 
 /*
--- a/arch/x86/math-emu/fpu_entry.c
+++ b/arch/x86/math-emu/fpu_entry.c
@@ -640,7 +640,7 @@ int fpregs_soft_set(struct task_struct *
 		    unsigned int pos, unsigned int count,
 		    const void *kbuf, const void __user *ubuf)
 {
-	struct swregs_state *s387 = &target->thread.fpu.state.soft;
+	struct swregs_state *s387 = &target->thread.fpu.fpstate->regs.soft;
 	void *space = s387->st_space;
 	int ret;
 	int offset, other, i, tags, regnr, tag, newtop;
@@ -691,7 +691,7 @@ int fpregs_soft_get(struct task_struct *
 		    const struct user_regset *regset,
 		    struct membuf to)
 {
-	struct swregs_state *s387 = &target->thread.fpu.state.soft;
+	struct swregs_state *s387 = &target->thread.fpu.fpstate->regs.soft;
 	const void *space = s387->st_space;
 	int offset = (S387->ftop & 7) * 10, other = 80 - offset;
 
--- a/arch/x86/math-emu/fpu_system.h
+++ b/arch/x86/math-emu/fpu_system.h
@@ -73,7 +73,7 @@ static inline bool seg_writable(struct d
 	return (d->type & SEG_TYPE_EXECUTE_MASK) == SEG_TYPE_WRITABLE;
 }
 
-#define I387			(&current->thread.fpu.state)
+#define I387			(&current->thread.fpu.fpstate->regs)
 #define FPU_info		(I387->soft.info)
 
 #define FPU_CS			(*(unsigned short *) &(FPU_info->regs->cs))

