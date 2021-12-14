Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C15FB473A1C
	for <lists+kvm@lfdr.de>; Tue, 14 Dec 2021 02:18:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240739AbhLNBSn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Dec 2021 20:18:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237215AbhLNBSn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Dec 2021 20:18:43 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CF3EC061574
        for <kvm@vger.kernel.org>; Mon, 13 Dec 2021 17:18:43 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id e12-20020aa7980c000000b0049fa3fc29d0so11036033pfl.10
        for <kvm@vger.kernel.org>; Mon, 13 Dec 2021 17:18:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=cs3OJ+F2rO8WRibDoWfVPoWtuNoT5ZR+6yS9ZBrTGd8=;
        b=qT7rL4CCP9fXLjVmPH+NDDOq1H7NmNUeKAemFVpIvLGVKz3AUU1JKW/WawKt92M8vV
         wWdD4jg7/wa29wDJoLlDhcEpfwllwqdIun0UZPhD2E1rjg81HKDRSZV+ln5bqLRS5ZfV
         66fMZYv4CRPDHvKhz1uMWNumKwBwYTg8mP3LJoNdcmNTv4o1UpNeXIwdKUM8TdvvGot4
         4Y6HAT/MvH6KuRoNWA9SNEQfeJrbSngDi3PWdys15zyTvGsedpAiI8KQOYn3Tb/GGxxf
         W7TZEbpzNOLRb+RCyhLfOoSg+ubYI67CpaIBPdyMhbt7svAqt+Hrb1T42QAofpFTkJFu
         PHWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=cs3OJ+F2rO8WRibDoWfVPoWtuNoT5ZR+6yS9ZBrTGd8=;
        b=LXnwfz+pWomBjw0rBuxWONSoOPhXXrzN51+5sERIam7jIgcJPCsn7Jl0RL3I4HybE7
         J5TaowKc2hdwj7lfJVNxaMc9KTfD/BLQg1+coLLtw8TmUpfFCiSfXTe1hCZF3nlDnfYS
         dgXtkhFUkC4pC/R8fVBuHaObqxkHwStsbNd6vsLow2FWRHdtkRhYeGS9gcJPw8Wllbho
         TowFOYayzcM8FwfjEkbtdUBKHy65AWF+uUUz0S/0jykWi0eIBEvFbQzKIc9BEQIyTULv
         B+qeflxQOaraWQZdUeL+FJ4zRdhnV6bdopBb7Dj+wkh/tW4kLxHG0q49he2xLFx4M6tZ
         IlRQ==
X-Gm-Message-State: AOAM531VIJIzZ4q6BvxQwHpVL7GsO2ElFb3iftV4oxzhIkWNmqWxPKau
        GihoguFIlLdfaCZvn3SRauR5+WWxpXANFQhda0yyj4RZaW6pWgKgTSZTOuox1GYzZj66s2G724n
        GVxCX5ga887jHLK/YYEnKEFIuWDBS/SygamAXfBzFdF347EmS47Dp8UYp6EyBdDrnkydG
X-Google-Smtp-Source: ABdhPJwnRxfLIOimTAgsBCgaySQLv8bvVSSCkkEJVzelMg9nFdsrIE+wkR5et0LSkGg+TZBAEfoBTPUw/bEcGb0j
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a17:902:6b8c:b0:148:8a86:a01c with SMTP
 id p12-20020a1709026b8c00b001488a86a01cmr1948181plk.50.1639444722553; Mon, 13
 Dec 2021 17:18:42 -0800 (PST)
Date:   Tue, 14 Dec 2021 01:18:21 +0000
In-Reply-To: <20211214011823.3277011-1-aaronlewis@google.com>
Message-Id: <20211214011823.3277011-3-aaronlewis@google.com>
Mime-Version: 1.0
References: <20211214011823.3277011-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.34.1.173.g76aa8bc2d0-goog
Subject: [kvm-unit-tests PATCH v2 2/4] x86: Align L2's stacks
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Setting the stack to PAGE_SIZE - 1 sets the stack to being 1-byte
aligned, which fails in usermode with alignment checks enabled (ie: with
flags cr0.am set and eflags.ac set).  This was causing an #AC in
usermode.c when preparing to call the callback in run_in_user().
Aligning the stack fixes the issue.

For the purposes of fixing the #AC in usermode.c the stack has to be
aligned to at least an 8-byte boundary.  Setting it to a page aligned
boundary ensures any stack alignment requirements are met as x86_64
stacks generally want to be 16-byte aligned.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 x86/vmx.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/x86/vmx.c b/x86/vmx.c
index 6dc9a55..f4fbb94 100644
--- a/x86/vmx.c
+++ b/x86/vmx.c
@@ -42,7 +42,7 @@
 u64 *bsp_vmxon_region;
 struct vmcs *vmcs_root;
 u32 vpid_cnt;
-void *guest_stack, *guest_syscall_stack;
+u64 guest_stack_top, guest_syscall_stack_top;
 u32 ctrl_pin, ctrl_enter, ctrl_exit, ctrl_cpu[2];
 struct regs regs;
 
@@ -1241,8 +1241,7 @@ static void init_vmcs_guest(void)
 	vmcs_write(GUEST_CR3, guest_cr3);
 	vmcs_write(GUEST_CR4, guest_cr4);
 	vmcs_write(GUEST_SYSENTER_CS,  KERNEL_CS);
-	vmcs_write(GUEST_SYSENTER_ESP,
-		(u64)(guest_syscall_stack + PAGE_SIZE - 1));
+	vmcs_write(GUEST_SYSENTER_ESP, guest_syscall_stack_top);
 	vmcs_write(GUEST_SYSENTER_EIP, (u64)(&entry_sysenter));
 	vmcs_write(GUEST_DR7, 0);
 	vmcs_write(GUEST_EFER, rdmsr(MSR_EFER));
@@ -1292,7 +1291,7 @@ static void init_vmcs_guest(void)
 
 	/* 26.3.1.4 */
 	vmcs_write(GUEST_RIP, (u64)(&guest_entry));
-	vmcs_write(GUEST_RSP, (u64)(guest_stack + PAGE_SIZE - 1));
+	vmcs_write(GUEST_RSP, guest_stack_top);
 	vmcs_write(GUEST_RFLAGS, X86_EFLAGS_FIXED);
 
 	/* 26.3.1.5 */
@@ -1388,8 +1387,8 @@ void init_vmx(u64 *vmxon_region)
 static void alloc_bsp_vmx_pages(void)
 {
 	bsp_vmxon_region = alloc_page();
-	guest_stack = alloc_page();
-	guest_syscall_stack = alloc_page();
+	guest_stack_top = (uintptr_t)alloc_page() + PAGE_SIZE;
+	guest_syscall_stack_top = (uintptr_t)alloc_page() + PAGE_SIZE;
 	vmcs_root = alloc_page();
 }
 
-- 
2.34.1.173.g76aa8bc2d0-goog

