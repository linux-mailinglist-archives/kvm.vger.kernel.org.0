Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A95942E5D7
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 03:16:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234079AbhJOBSQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 21:18:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232279AbhJOBSM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Oct 2021 21:18:12 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46514C061762;
        Thu, 14 Oct 2021 18:16:06 -0700 (PDT)
Message-ID: <20211015011538.780714235@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634260565;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=zDkaoeyhehBlXxI4Eb2zSF3/rxi3Kg/Q69UFd71ACTg=;
        b=Dgjh1w6GxEJJmwBfRKd3sAM8pdafHeV4V5+vMAzySOBMjhQ31NfvEGpRzcjO3X8ZSqKex7
        VbHWu0l5wFvi45smpiP3nKVOARqAoWdPVNoISrySz1i//CDcE//AVx5L9js6OmOXdxqjVf
        qSsWhtUGAoHWxK2WCNvP5/0O2RaE8vUVfTTBzrww+MiYlKx/Ymw3jOmbpN6ztsm7Xp4fFn
        BoeREMqF3bFu0CJPBjPAIJVWKeI1t7l+nb8Ee4u9WzdruSgeWtbHez7HPd9/IHiT1EzAFf
        lyW3ynn27UUKZhwdtbHWdR/Do36H5zTp2W/ZCmvJKblatkHyBg4ULZ9NMTgkTw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634260565;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=zDkaoeyhehBlXxI4Eb2zSF3/rxi3Kg/Q69UFd71ACTg=;
        b=l1kbDKe2XSVlNihUT7kTDoWV/NCXhfdnVQbYYRCULwyW9vrAmH/UiJAnMI1ugAzykrq/8Y
        /H66hkGdvxYnVaAw==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [patch V2 07/30] x86/process: Clone FPU in copy_thread()
References: <20211015011411.304289784@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Fri, 15 Oct 2021 03:16:04 +0200 (CEST)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There is no reason to clone FPU in arch_dup_task_struct(). Quite the
contrary it prevents optimizations. Move it to copy_thread()

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 arch/x86/kernel/process.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)
---
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 1d9463e3096b..d2227c55e683 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -87,7 +87,7 @@ int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src)
 #ifdef CONFIG_VM86
 	dst->thread.vm86 = NULL;
 #endif
-	return fpu_clone(dst);
+	return 0;
 }
 
 /*
@@ -154,6 +154,8 @@ int copy_thread(unsigned long clone_flags, unsigned long sp, unsigned long arg,
 	frame->flags = X86_EFLAGS_FIXED;
 #endif
 
+	fpu_clone(p);
+
 	/* Kernel thread ? */
 	if (unlikely(p->flags & PF_KTHREAD)) {
 		p->thread.pkru = pkru_get_init_value();

