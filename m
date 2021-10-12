Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B025D429A31
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 02:07:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235352AbhJLAJb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Oct 2021 20:09:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232381AbhJLAI2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Oct 2021 20:08:28 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FF08C061570;
        Mon, 11 Oct 2021 17:06:27 -0700 (PDT)
Message-ID: <20211011223610.705049376@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1633997183;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=i9xeaFxN1PyesYRvXe7tDSiQSxGVh/JmtQE1TkpD0JE=;
        b=j45F7Vitxq3lCuzU93riBz9DtA+FAoeuCa+gNjcBtjf9nHP32il5sYITMxGNlplsO4lx6X
        YDM7e2nI5HgZJUqCLnaO4AP0Z6rzlgroOLRf7p8iKELaCbobMAEXb5FZiznX1YjG+BqVcc
        QXfOC7yYXFXnMSvL7EOKugdnCG9l05698LKE43FMnEhZn+EFm6PfBfmccA5NGaWdpWnXDU
        Zmpng034tsjINxRoFbYlpd0HJcF5c7N0uQ0vmUiXC123jgo6ZyZaLDft97/MtYoECZkk5C
        zvHhDERn2ON8sXuhpF0qLWs6Az3B8CV5eop78u81QmbGPHeR/oSQvZKP4Q8Y8A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1633997183;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=i9xeaFxN1PyesYRvXe7tDSiQSxGVh/JmtQE1TkpD0JE=;
        b=++J6xEi63QztqsISM8+l0+isaMoD1sO50WbgDxdtWfZuZ+/FRtbX/StaAtSdyO7YapgWNA
        unZa1HP6lRRvH5DA==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [patch 07/31] x86/process: Clone FPU in copy_thread()
References: <20211011215813.558681373@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Tue, 12 Oct 2021 02:00:08 +0200 (CEST)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There is no reason to clone FPU in arch_dup_task_struct(). Quite the
contrary it prevents optimizations. Move it to copy_thread()

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/process.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -87,7 +87,7 @@ int arch_dup_task_struct(struct task_str
 #ifdef CONFIG_VM86
 	dst->thread.vm86 = NULL;
 #endif
-	return fpu_clone(dst);
+	return 0;
 }
 
 /*
@@ -154,6 +154,8 @@ int copy_thread(unsigned long clone_flag
 	frame->flags = X86_EFLAGS_FIXED;
 #endif
 
+	fpu_clone(p);
+
 	/* Kernel thread ? */
 	if (unlikely(p->flags & PF_KTHREAD)) {
 		p->thread.pkru = pkru_get_init_value();

