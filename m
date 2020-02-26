Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 575D716F8B3
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2020 08:45:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727359AbgBZHpH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Feb 2020 02:45:07 -0500
Received: from mail-pg1-f202.google.com ([209.85.215.202]:38806 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727350AbgBZHpG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Feb 2020 02:45:06 -0500
Received: by mail-pg1-f202.google.com with SMTP id x16so1308867pgg.5
        for <kvm@vger.kernel.org>; Tue, 25 Feb 2020 23:45:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=7wW5RNchVTlItAFZhajd4+Ejg/4+T3uP4HbdOkXgmio=;
        b=bv274DrRU5vCxbKG6elhIw5NMfIZycw7uUH9xLoFC/9gN49dxS10JixwugF/AJJNZ3
         Y6ukDxMbkkJJQpA0b65qeQ3YtVpxdvLtg/Cd68oQyeubXgSARMNow4TVOVGwt0QomycA
         2alw6ld2T+6SLgyTnYsrg3ffSBoFvRN5FRy2gptYk6htqdZx3j6wv81UH/f+u6a3ds7N
         pHb/1z4ueRV1ZrwV5QZAApWPYrxCgPuM0H//CVg3gBbh3Nr9GGlPRIfDoJCxpo7o4oAj
         FMJhmUc/yE/NAo2z9UEjiJGDloYwbvWtFerQ6RsaM0DrcRJVvkpiPv0mLwCSrjtley6R
         j0RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=7wW5RNchVTlItAFZhajd4+Ejg/4+T3uP4HbdOkXgmio=;
        b=bzHdIOapezIhTwBYL46DTcf7fmywbMkw9DNTP/wqqhimZqZnVRij3YuZ3kouh1NRWI
         JdghrKBlVfGGLBN4nmyH4R5qEAbKeOOKp3eFVIsIVD3PzaBKvxfUnOmoWWctOyqGcNq1
         ZvMvck5mDXWmbvdi1W/Dw+71AnF+V9B8ppKVfYGA5oyXB33+YyZ8UE4lQAZPv81z0CS1
         3fzfvqq6ePyTl1z8x8zhcGNBEBv5hQpi5a/UBf7BIxKIyvsZaiRNY8TzZKMjjuhkadSM
         ba0k3I+DmtPYtskkwBH1+k/bIkOL6eRRR4id4lH1GUzHXxZ6d2YZLYpWsti8eB85zTvv
         C6qQ==
X-Gm-Message-State: APjAAAX09i86D1rO4gS4GoCFRFIBjCApW3xk44VbZkoa7UhkZ/stYmc6
        ztDNb0Pcu5yBYChL4moWILxp4YL+zbccb3Duq5vkU4M+tU82p1r/wtOqV+hLJ+ewfMDZkg0DdQ/
        maaWu6T/BXxRMMooDuKarg5KYvvfwdgn8nd8WRUfXB6ATpfufuMluwA==
X-Google-Smtp-Source: APXvYqx4XzVQ6tdvnt+VZ1Zz7gfRbv2eBMmPBXI/kfHLe08x8HtKpaYvBPgUlaHNp5CFOvsOCgqWiIVZnA==
X-Received: by 2002:a63:7e49:: with SMTP id o9mr2670979pgn.80.1582703105074;
 Tue, 25 Feb 2020 23:45:05 -0800 (PST)
Date:   Tue, 25 Feb 2020 23:44:26 -0800
In-Reply-To: <20200226074427.169684-1-morbo@google.com>
Message-Id: <20200226074427.169684-7-morbo@google.com>
Mime-Version: 1.0
References: <20200226074427.169684-1-morbo@google.com>
X-Mailer: git-send-email 2.25.0.265.gbab2e86ba0-goog
Subject: [kvm-unit-tests PATCH 6/7] x86: VMX: use inline asm to get stack pointer
From:   morbo@google.com
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Bill Wendling <morbo@google.com>

The only supported use of a local register variable is to specify
registers for input and output operands when calling Extended asm. Using
it to automatically collect the value in the register isn't supported as
the contents of the register aren't guaranteed. Instead use inline asm
to get the stack pointer explicitly.

Signed-off-by: Bill Wendling <morbo@google.com>
---
 x86/vmx_tests.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index a7abd63..ad8c002 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -2165,8 +2165,9 @@ static void into_guest_main(void)
 		.offset = (uintptr_t)&&into,
 		.selector = KERNEL_CS32,
 	};
-	register uintptr_t rsp asm("rsp");
+	uintptr_t rsp = 0;
 
+	asm volatile ("mov %%rsp, %0" : "=r" (rsp));
 	if (fp.offset != (uintptr_t)&&into) {
 		printf("Code address too high.\n");
 		return;
@@ -3261,8 +3262,9 @@ static void try_compat_invvpid(void *unused)
 		.offset = (uintptr_t)&&invvpid,
 		.selector = KERNEL_CS32,
 	};
-	register uintptr_t rsp asm("rsp");
+	register uintptr_t rsp = 0;
 
+	asm volatile ("mov %%rsp, %0" : "=r" (rsp));
 	TEST_ASSERT_MSG(fp.offset == (uintptr_t)&&invvpid,
 			"Code address too high.");
 	TEST_ASSERT_MSG(rsp == (u32)rsp, "Stack address too high.");
-- 
2.25.0.265.gbab2e86ba0-goog

