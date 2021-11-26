Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7070145EEE4
	for <lists+kvm@lfdr.de>; Fri, 26 Nov 2021 14:12:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239863AbhKZNPj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Nov 2021 08:15:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244594AbhKZNNg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Nov 2021 08:13:36 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FFDCC07E5DB;
        Fri, 26 Nov 2021 04:31:33 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id x5so8879636pfr.0;
        Fri, 26 Nov 2021 04:31:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IoyiIhuBO35toVjduMiP3RkopuGRiCHYDSySxyyIdBY=;
        b=OOb1/B/dmggrfD8tcxEkIGsAPqhWjiLVc4Q2NEj93RX6Eyi18TTCLK7X3jW48l8Epf
         LcAXS5YOPV/NxuVZ15vTp6XbRDR/YKTjuE62BWwxLxiNX0OhYaVk0VO+iZg3YLymAik2
         x6iyMn1w/yWXSGJmjpKkj/ABvm0Ce6rw/ggM3QFK1ZdMy4pS6AzgfyFnQAVyZ1H+lDhb
         9POT3453gW1T46rMxL53qLcZydjEp0cwqUrEH0g/3CcKX1dulyB7wBF7RKQaLk2Ass8i
         KG2nuj2+Cjs/o3NcspxDSY9sNOIyEYRDrHlXwFtW9M+2CY9limr558p/ATjFQ3ywlzhc
         l12g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IoyiIhuBO35toVjduMiP3RkopuGRiCHYDSySxyyIdBY=;
        b=S8//nY6b3mj8Ux3wm63RgF8y37j7jgM1meELYh662zCKfmwLBx53f8FHnNU0yAy7Wr
         YiJiB6y/jg+hCCUfQDbQxIMvX94JI/5kuOnr51vf+qEiWMdnva3reNtLHm5YGqAFosJ8
         8oX1/65JhQciytcyTCEUT76m7/DYilMHLJovJGCcnk6S1xyKLIEdlrtgFsfc9fcSJMEv
         ebuU0ovPeLPyGjNesSGZYbTbV6AeN0F3ciymcxPSgtm+CF3PP+dWIUiC1l1xFiVw1OP5
         xdydiU57mFoFU0cLAlOYtPYA+xta0LfjHpVz63DwCpiDuATKBy7Al4GpdoX8eACSvfJe
         AduQ==
X-Gm-Message-State: AOAM530jr2tU7ZETGCj2LHdKQiUpjjA7fqECly5Zxzfpn1OKN2Mij2iu
        8dcgSScbPg09a9qy5PaIoDAgfDBGMSY=
X-Google-Smtp-Source: ABdhPJwRWB+gqE3nHRQbha/kG7xMnzgQ0lIoE5XaYK2g74bA7juDCgfvBXpI66CBksWqfwbW9ZU1Kw==
X-Received: by 2002:a05:6a00:179a:b0:49f:a821:8233 with SMTP id s26-20020a056a00179a00b0049fa8218233mr20808200pfg.66.1637929892688;
        Fri, 26 Nov 2021 04:31:32 -0800 (PST)
Received: from localhost ([47.251.3.230])
        by smtp.gmail.com with ESMTPSA id mg12sm10707968pjb.10.2021.11.26.04.31.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Nov 2021 04:31:32 -0800 (PST)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     x86@kernel.org, Lai Jiangshan <laijs@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, kvm@vger.kernel.org
Subject: [RFC PATCH] x86/kvm: Allow kvm_read_and_reset_apf_flags() to be instrumented
Date:   Fri, 26 Nov 2021 20:31:45 +0800
Message-Id: <20211126123145.2772-1-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

Both VMX and SVM made mistakes of calling kvm_read_and_reset_apf_flags()
in instrumentable code:
	vmx_vcpu_enter_exit()
		ASYNC PF induced VMEXIT
		save cr2
	leave noinstr section
	-- kernel #PF can happen here due to instrumentation
	handle_exception_nmi_irqoff
		kvm_read_and_reset_apf_flags()

If kernel #PF happens before handle_exception_nmi_irqoff() after leaving
noinstr section due to instrumentation, kernel #PF handler will consume
the incorrect apf flags and panic.

The problem might be fixed by moving kvm_read_and_reset_apf_flags()
into vmx_vcpu_enter_exit() to consume apf flags earlier before leaving
noinstr section like the way it handles CR2.

But linux kernel only resigters ASYNC PF for userspace and guest, so
ASYNC PF can't hit when it is in kernel, so apf flags can be changed to
be consumed only when the #PF is from guest or userspace.

It is natually that kvm_read_and_reset_apf_flags() in vmx/svm is for
page fault from guest.  So this patch changes kvm_handle_async_pf()
to be called only for page fault from userspace and renames it.

Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
 arch/x86/include/asm/kvm_para.h |  8 +++----
 arch/x86/kernel/kvm.c           | 10 +--------
 arch/x86/mm/fault.c             | 39 ++++++++++++---------------------
 3 files changed, 19 insertions(+), 38 deletions(-)

diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
index 56935ebb1dfe..3452e705dfda 100644
--- a/arch/x86/include/asm/kvm_para.h
+++ b/arch/x86/include/asm/kvm_para.h
@@ -104,14 +104,14 @@ unsigned int kvm_arch_para_hints(void);
 void kvm_async_pf_task_wait_schedule(u32 token);
 void kvm_async_pf_task_wake(u32 token);
 u32 kvm_read_and_reset_apf_flags(void);
-bool __kvm_handle_async_pf(struct pt_regs *regs, u32 token);
+bool __kvm_handle_async_user_pf(struct pt_regs *regs, u32 token);
 
 DECLARE_STATIC_KEY_FALSE(kvm_async_pf_enabled);
 
-static __always_inline bool kvm_handle_async_pf(struct pt_regs *regs, u32 token)
+static inline bool kvm_handle_async_user_pf(struct pt_regs *regs, u32 token)
 {
 	if (static_branch_unlikely(&kvm_async_pf_enabled))
-		return __kvm_handle_async_pf(regs, token);
+		return __kvm_handle_async_user_pf(regs, token);
 	else
 		return false;
 }
@@ -148,7 +148,7 @@ static inline u32 kvm_read_and_reset_apf_flags(void)
 	return 0;
 }
 
-static __always_inline bool kvm_handle_async_pf(struct pt_regs *regs, u32 token)
+static inline bool kvm_handle_async_user_pf(struct pt_regs *regs, u32 token)
 {
 	return false;
 }
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 59abbdad7729..285eeddf98f2 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -240,17 +240,13 @@ noinstr u32 kvm_read_and_reset_apf_flags(void)
 }
 EXPORT_SYMBOL_GPL(kvm_read_and_reset_apf_flags);
 
-noinstr bool __kvm_handle_async_pf(struct pt_regs *regs, u32 token)
+bool __kvm_handle_async_user_pf(struct pt_regs *regs, u32 token)
 {
 	u32 flags = kvm_read_and_reset_apf_flags();
-	irqentry_state_t state;
 
 	if (!flags)
 		return false;
 
-	state = irqentry_enter(regs);
-	instrumentation_begin();
-
 	/*
 	 * If the host managed to inject an async #PF into an interrupt
 	 * disabled region, then die hard as this is not going to end well
@@ -260,16 +256,12 @@ noinstr bool __kvm_handle_async_pf(struct pt_regs *regs, u32 token)
 		panic("Host injected async #PF in interrupt disabled region\n");
 
 	if (flags & KVM_PV_REASON_PAGE_NOT_PRESENT) {
-		if (unlikely(!(user_mode(regs))))
-			panic("Host injected async #PF in kernel mode\n");
 		/* Page is swapped out by the host. */
 		kvm_async_pf_task_wait_schedule(token);
 	} else {
 		WARN_ONCE(1, "Unexpected async PF flags: %x\n", flags);
 	}
 
-	instrumentation_end();
-	irqentry_exit(regs, state);
 	return true;
 }
 
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 4bfed53e210e..dadef2afa185 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -1501,30 +1501,6 @@ DEFINE_IDTENTRY_RAW_ERRORCODE(exc_page_fault)
 
 	prefetchw(&current->mm->mmap_lock);
 
-	/*
-	 * KVM uses #PF vector to deliver 'page not present' events to guests
-	 * (asynchronous page fault mechanism). The event happens when a
-	 * userspace task is trying to access some valid (from guest's point of
-	 * view) memory which is not currently mapped by the host (e.g. the
-	 * memory is swapped out). Note, the corresponding "page ready" event
-	 * which is injected when the memory becomes available, is delivered via
-	 * an interrupt mechanism and not a #PF exception
-	 * (see arch/x86/kernel/kvm.c: sysvec_kvm_asyncpf_interrupt()).
-	 *
-	 * We are relying on the interrupted context being sane (valid RSP,
-	 * relevant locks not held, etc.), which is fine as long as the
-	 * interrupted context had IF=1.  We are also relying on the KVM
-	 * async pf type field and CR2 being read consistently instead of
-	 * getting values from real and async page faults mixed up.
-	 *
-	 * Fingers crossed.
-	 *
-	 * The async #PF handling code takes care of idtentry handling
-	 * itself.
-	 */
-	if (kvm_handle_async_pf(regs, (u32)address))
-		return;
-
 	/*
 	 * Entry handling for valid #PF from kernel mode is slightly
 	 * different: RCU is already watching and rcu_irq_enter() must not
@@ -1538,7 +1514,20 @@ DEFINE_IDTENTRY_RAW_ERRORCODE(exc_page_fault)
 	state = irqentry_enter(regs);
 
 	instrumentation_begin();
-	handle_page_fault(regs, error_code, address);
+
+	/*
+	 * KVM uses #PF vector to deliver 'page not present' events to guests
+	 * (asynchronous page fault mechanism). The event happens when a
+	 * userspace task is trying to access some valid (from guest's point of
+	 * view) memory which is not currently mapped by the host (e.g. the
+	 * memory is swapped out). Note, the corresponding "page ready" event
+	 * which is injected when the memory becomes available, is delivered via
+	 * an interrupt mechanism and not a #PF exception
+	 * (see arch/x86/kernel/kvm.c: sysvec_kvm_asyncpf_interrupt()).
+	 */
+	if (!user_mode(regs) || !kvm_handle_async_user_pf(regs, (u32)address))
+		handle_page_fault(regs, error_code, address);
+
 	instrumentation_end();
 
 	irqentry_exit(regs, state);
-- 
2.19.1.6.gb485710b

