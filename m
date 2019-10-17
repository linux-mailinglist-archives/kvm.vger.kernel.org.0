Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70B5BDA30F
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2019 03:25:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406074AbfJQBZU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Oct 2019 21:25:20 -0400
Received: from mail-vk1-f201.google.com ([209.85.221.201]:34780 "EHLO
        mail-vk1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405786AbfJQBZT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Oct 2019 21:25:19 -0400
Received: by mail-vk1-f201.google.com with SMTP id b11so342351vkn.1
        for <kvm@vger.kernel.org>; Wed, 16 Oct 2019 18:25:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=5svmfLF9OWcBQ7FqMuoYLjWL4gl8GT6cQKYC/kv0LSY=;
        b=nVL6UJ8fOukT8kJH0A3YfAfpKFB0U+hfzE593lTM/lLeup04mSrjSG+rmwuqQuRxff
         X/KxfldbUZraVo4lCq8E3Kk3w25xVrtOjExtqeQtr5bWwbmR9NQRmz9iU9EWi2Y4Jvtt
         3XaXCUw1XzZQrd+xbZ6YrWD0BXdQjvnILFYg1wPHBueIBYDb75Xh4tkb4YGncWtIsQyL
         2Ao0uPpM/6Pe0aSuFygxsewXs5VHViNaqCR4Lqw9ILrCi60+UIrDell7zJIp0tmkvI8A
         LRokmUWRZ1i7CZQDK/Dj4+sYdrGAVMsrKuPD/2NlF8a79wuh/rE+YL+vXc7kRmlR7/8S
         noxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=5svmfLF9OWcBQ7FqMuoYLjWL4gl8GT6cQKYC/kv0LSY=;
        b=AfMeVehI/bOiTKDpM1ZjrGHaYlSLCKApBkOMiEnYL30dW5FOZOobdYzguF1Ss6pVhp
         3ieI0BIP+D9i8CsIRY3ey83XeGkrhevz6vZoAiDCSczm3UImJTofdRj+Bk20hfOyBkgw
         Pzqv0KB2olbJlESm/Q/4JFXLUxWE2WpEb1ziT49Mp7q37Z/TsINWs611NdkHPCt+Cx+0
         o7K6K4MdzhNJoCc/GoON7nQyI2agSNvGhx5sr5ucPkUnt1gA2ilj26kuc+5RV3QHk/so
         PWPwcuEZCTYYOZSyQ0vgLBZKut6QxOpgE9sbTXr6993KniWjzySgTWn1rAdFH9tD2wcy
         hiPw==
X-Gm-Message-State: APjAAAVr38B/GgEzRZ1fdO0UGhrHjF07C1iUVfqv9/vakdvT+eZZ4ruW
        H38+vZr8kM10yEo7j+48zvHckAUSbkiJyYVkYga+K5UMpVfzLdAxCbhgzj1kRDfhYOlUmoYzYBh
        W6CDin2IDw6uMurIlfu+0Fp+h467HbQnB+Xmm9lGlAwUSmV8LpNDlvw==
X-Google-Smtp-Source: APXvYqyDqBKGGb0lpsPWXOn4DfqfYGrrIafw1WAnctLjpq1CUt5He1+piPwEL429YSJu7Hpyg3x7jMSh7A==
X-Received: by 2002:a67:e1c3:: with SMTP id p3mr489441vsl.209.1571275518505;
 Wed, 16 Oct 2019 18:25:18 -0700 (PDT)
Date:   Wed, 16 Oct 2019 18:25:02 -0700
In-Reply-To: <20191017012502.186146-1-morbo@google.com>
Message-Id: <20191017012502.186146-3-morbo@google.com>
Mime-Version: 1.0
References: <20191012235859.238387-1-morbo@google.com> <20191017012502.186146-1-morbo@google.com>
X-Mailer: git-send-email 2.23.0.700.g56cf767bdb-goog
Subject: [kvm-unit-tests v2 PATCH 2/2] x86: realmode: fix esp in call test
From:   Bill Wendling <morbo@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, alexandru.elisei@arm.com,
        thuth@redhat.com
Cc:     jmattson@google.com, Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

esp needs to point at the end of the stack, or it will corrupt memory.

Signed-off-by: Bill Wendling <morbo@google.com>

This is a port of Avi Kivity patch for the long jump test:
4aa229495b0e4159642b4a77e9adfdc81501c095.

Signed-off-by: Bill Wendling <morbo@google.com>
---
 x86/realmode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/realmode.c b/x86/realmode.c
index 41b8592..f318910 100644
--- a/x86/realmode.c
+++ b/x86/realmode.c
@@ -520,7 +520,7 @@ static void test_call(void)
 	u32 addr;
 
 	inregs = (struct regs){ 0 };
-	inregs.esp = (u32)esp;
+	inregs.esp = (u32)(esp+16);
 
 	MK_INSN(call1, "mov $test_function, %eax \n\t"
 		       "call *%eax\n\t");
-- 
2.23.0.700.g56cf767bdb-goog

