Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD1A3170941
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2020 21:13:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727478AbgBZUNT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Feb 2020 15:13:19 -0500
Received: from mail-pl1-f202.google.com ([209.85.214.202]:40546 "EHLO
        mail-pl1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727456AbgBZUNS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Feb 2020 15:13:18 -0500
Received: by mail-pl1-f202.google.com with SMTP id y2so346987plt.7
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2020 12:13:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=uryJ2eJtKXOKe1NBEqWHoftgOZIJi7Y8qJbiVJC4L00=;
        b=oBMC1lt73FTYgaCNM3nuHuWGgV10AKArjOUyRD1q9cpxO7oQtUBVonZvTL+MB+tG5L
         Yc9kLSTX8pYR3Arjzudwdt7OJoYdNJwhM644mzY7lsYHhD2CrXAhASq9rrtVqMWrVb3y
         q5PpARK+Kx1TMas1/4Eykbk3YUIvI+nFozDfooRUbTbT7RGg5pcXc53ydCjHHaHT0RGp
         xnCT5AEdSqHEyJ8Pbaod6czbbSFyOvOOvjA+c0G9HDbVyjN1ay35ledJEQWdBnOa0tH1
         8ShU3IjwyQu5tfysCgFsNqPYrbNC6/R8qxSG6qkEd8qe70AtrjnS2XWl0QnT+YpPkOwG
         0GHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=uryJ2eJtKXOKe1NBEqWHoftgOZIJi7Y8qJbiVJC4L00=;
        b=KD9mB0PTH1sjs7Ll9PftGMPjw2/9XVlSxwAW7UZ9ZgeA122FmLuxBRLxXz+4pcAXnj
         v80TvVEu2BlFjhaRiux0FtUnVjkgs5vfD/y6kR6MRGWgK/LBw5k/aD9aC11LPLEVo3Wy
         4OcOnoSyLb9IliJPDiHYfEcYW/qByZPoW1NqmzSKjLGofb+7lzb7NWJX77KCiQqrK8IT
         gNgcF0GznwvQUbFrJfy3Wtg5C05maCJIam80XD8X0bSflBflaNmjRW4LW1icmTW0UIy8
         OnXp8to5bUwfwFT8oXJ/zIR9B4pYIOOBoenXVPYGx9B97+ijuUFtwfCQegrUmyQ5pba4
         RiDw==
X-Gm-Message-State: APjAAAWUyX55c/v+5SrCxYxDxRzGHZ1nqPQphKpU7u6pUAr/7s+47mpq
        t0i++7LEy9O6zTKwB8WXWw5I/mfJCyHVhFIF5b3MYcK4+XxKskbd7poQb9gemwJFXL9isxjh8Mw
        cqO8vnKW/5h5pOSOmjlKtvk62hkyj0Yx22piRUjXkK7WcZb4haurk0Q==
X-Google-Smtp-Source: APXvYqwtrTqGzOark/axu9TKwytDJxgzUcUNkQ1HaMrEzmRX0uy+OZ44KJbdei3O+BvJ0sn/f7t8v9af0A==
X-Received: by 2002:a63:fb04:: with SMTP id o4mr508775pgh.423.1582747997337;
 Wed, 26 Feb 2020 12:13:17 -0800 (PST)
Date:   Wed, 26 Feb 2020 12:12:42 -0800
In-Reply-To: <20200226201243.86988-1-morbo@google.com>
Message-Id: <20200226201243.86988-7-morbo@google.com>
Mime-Version: 1.0
References: <20200226094433.210968-1-morbo@google.com> <20200226201243.86988-1-morbo@google.com>
X-Mailer: git-send-email 2.25.1.481.gfbce0eb801-goog
Subject: [kvm-unit-tests PATCH v3 6/7] x86: VMX: use inline asm to get stack pointer
From:   Bill Wendling <morbo@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, oupton@google.com, drjones@redhat.com,
        Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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
2.25.1.481.gfbce0eb801-goog

