Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C306346F30D
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 19:26:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243304AbhLISaY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 13:30:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243219AbhLISaX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Dec 2021 13:30:23 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47933C061746
        for <kvm@vger.kernel.org>; Thu,  9 Dec 2021 10:26:50 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id jx2-20020a17090b46c200b001a62e9db321so4300955pjb.7
        for <kvm@vger.kernel.org>; Thu, 09 Dec 2021 10:26:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=9TsHDpZZNunckplei11gkoq/nGaC77zKlswD+hK5oSk=;
        b=syKJm4QeGqNc92iK1UGh/z+CLDHnR+R2XnkKNVcN16q6EsngXjvOQAJBvjIzcDgy6L
         EQUFKdBrIV3TiXCYT15N1oMPULZEm3X1cnAUqQpvI6WStV+awjyz3Ggcqye63Q+LXLr7
         SgZf/AWjRgY7KsmU6Ioat73RTenpxgdq9OzTOv+jwzOaDumI2xR2SCPbJr3zo3uyP7LC
         DSSG1x4e0G8oxrA6its9eiaMhEAgfNeqq4Q2ogv2PA/Wjixj7hTYzegWU+aWFobMJ5bf
         extC9fr8J0Avb5kUtbKEiGzFFZ7arvf2XHFizGjSx6UVHGyYimAjvC/MQAnlgm9+qATq
         eXPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=9TsHDpZZNunckplei11gkoq/nGaC77zKlswD+hK5oSk=;
        b=BgcpgZhJPL/tcuKDAHoy6xGRva5nGHBqgE224agLRKz/81XGI3ZL66bB2O59mI6vna
         9ZZi+YIeRXmNAUnLU73CkpzSsyu/E2B/2h3LpQoUpHg9csI1vv0ZpvsIisR9nOhaB5Bv
         4gBie4QSr1+VCsaR1WhdazNCLnDD1zixvnHxKevAYEHE/fUJtZiIDNvOzG19Qv+kiWrf
         TRtb7nA1nPpaOeJOET1UBoj0lrgXMWVdjQEaU4BwJ7RcgjSS+FR5NK/eOXka6EsfHfIC
         ZvOmhEP5XSLZ9u481A8YjiWizXy4luDahn1iJ7dGMuWHwginJaBRoWpLyz1TA2fJFJO5
         cw0A==
X-Gm-Message-State: AOAM5328QVubmaXK0RDhxwX6WUmBaftLiQ9GmJnwAHxM5oO0Ssk5ig+K
        duUrvaXlGP0bf8C27NgLPWcG1Yw3uRy/FvfFKQJHKhiRO0AZfZvWc1HVoh8LQPWOlyCIxGYD8pM
        SoAXRx9U4MgpVKz0Ivx/hXlq7QtBejIYVw/kybn4V7EQFnQxClkkQchZ+agbjTyIKOtHy
X-Google-Smtp-Source: ABdhPJySbMXU8f2oqXWYimZh3mCab6broVLgkKQU5/qtRrdiyi7Qn0qyzBD1pC+smdR3bRyIFbxjGi+yTsQKHMQ/
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a63:141d:: with SMTP id
 u29mr29650444pgl.412.1639074409627; Thu, 09 Dec 2021 10:26:49 -0800 (PST)
Date:   Thu,  9 Dec 2021 18:26:23 +0000
In-Reply-To: <20211209182624.2316453-1-aaronlewis@google.com>
Message-Id: <20211209182624.2316453-3-aaronlewis@google.com>
Mime-Version: 1.0
References: <20211209182624.2316453-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.34.1.173.g76aa8bc2d0-goog
Subject: [kvm-unit-tests PATCH 2/3] x86: Align L2's stacks
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
 x86/vmx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/x86/vmx.c b/x86/vmx.c
index 6dc9a55..44f4861 100644
--- a/x86/vmx.c
+++ b/x86/vmx.c
@@ -1242,7 +1242,7 @@ static void init_vmcs_guest(void)
 	vmcs_write(GUEST_CR4, guest_cr4);
 	vmcs_write(GUEST_SYSENTER_CS,  KERNEL_CS);
 	vmcs_write(GUEST_SYSENTER_ESP,
-		(u64)(guest_syscall_stack + PAGE_SIZE - 1));
+		(u64)(guest_syscall_stack + PAGE_SIZE));
 	vmcs_write(GUEST_SYSENTER_EIP, (u64)(&entry_sysenter));
 	vmcs_write(GUEST_DR7, 0);
 	vmcs_write(GUEST_EFER, rdmsr(MSR_EFER));
@@ -1292,7 +1292,7 @@ static void init_vmcs_guest(void)
 
 	/* 26.3.1.4 */
 	vmcs_write(GUEST_RIP, (u64)(&guest_entry));
-	vmcs_write(GUEST_RSP, (u64)(guest_stack + PAGE_SIZE - 1));
+	vmcs_write(GUEST_RSP, (u64)(guest_stack + PAGE_SIZE));
 	vmcs_write(GUEST_RFLAGS, X86_EFLAGS_FIXED);
 
 	/* 26.3.1.5 */
-- 
2.34.1.173.g76aa8bc2d0-goog

