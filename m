Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07580DA30D
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2019 03:25:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405934AbfJQBZS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Oct 2019 21:25:18 -0400
Received: from mail-yw1-f74.google.com ([209.85.161.74]:54958 "EHLO
        mail-yw1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405786AbfJQBZS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Oct 2019 21:25:18 -0400
Received: by mail-yw1-f74.google.com with SMTP id 123so636207ywq.21
        for <kvm@vger.kernel.org>; Wed, 16 Oct 2019 18:25:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=2aXT99zRhARLZKfxO/1NXEG4WuQJvIfJjA9M7hKv2ns=;
        b=GLW2gUOkhgb4Kadhs5jiBl7jfhmtDnHJyD86dUzQh+Wf3Pi9xxA6/RtaDDMiDH6l4/
         N9dFGBxzXLNGH6xF7mO/wZ0NTEeqo490GHTAvRsdyhyUMSTbHgCe84vs+8XG9KaGi9O9
         4I67RAQ9Sjz6QoaXrqpjNXfSFnwZ2UsNMFCehZp9srdxHaM6hQ+g6F6FfHvg7WeaNrUF
         29701FAjEojNtWkKc1oli7VoLmBUlELuK04FbQ+7L97R+QLFjjJXlSpF1B7XA2bjlGkm
         WFoq8D4OsjU+olWCWov9ZV0qMtpmlAS7rGDwBjd118biWDtQvYU6gFIPfA20qwrntOnh
         nD6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=2aXT99zRhARLZKfxO/1NXEG4WuQJvIfJjA9M7hKv2ns=;
        b=aNGdr6KICiaGIz6AM6np2R+cehDp+BUhxydqcsearsxLOGu6rZB2DnbYimt5kWYQln
         cQjpgtezseFiMDZPqdo2wCSAYq7Oy9YadQlCoi8dSzTtOtIwuENky3ZU2YV3Hf3Dy0jj
         9cXm7StisMRZJNMzOlWxbRF+kk7TNR3UU6vZTcCtJgV4PXzfDMHlYY3l8BW/AWo4hMFK
         Hbo0op1/Lk/8P2d7YmFe6Pj0eYNBZYOPRmYyOV/vlCl+Tiim/mBGxtZcRtVhwP+d/IWk
         2jB09pjD1dRZiHXPBcSaqmvKZ/AF5N7lMVfxB7FN0b5sm+h7dsC34KwU5+gYqcsfbkTN
         UXHw==
X-Gm-Message-State: APjAAAV7duFUKr0fxqhvo3M3HjYJk5Wmj1Cy5u52SmrxOV3IdkFbnZ3G
        Fv7LCddp8w3PsfcFaZHURC7bZErArf5Dyc2sIcX/ds35GydxoGcpUUTbRThxYOcTnbIoZ6XPADn
        h0DCMSSgZZtrmgDQadzlwH9uFxx9apPJfHpvVZ9yDm6Pm3iUTzP7BdA==
X-Google-Smtp-Source: APXvYqyEqhxaqDleID8GRQkQIPOau8Dk/yvQpG0AV6j2z47E94b5IXI9WaRyics5JOqi1vepixopZTbf9g==
X-Received: by 2002:a25:72c1:: with SMTP id n184mr491531ybc.388.1571275515804;
 Wed, 16 Oct 2019 18:25:15 -0700 (PDT)
Date:   Wed, 16 Oct 2019 18:25:01 -0700
In-Reply-To: <20191017012502.186146-1-morbo@google.com>
Message-Id: <20191017012502.186146-2-morbo@google.com>
Mime-Version: 1.0
References: <20191012235859.238387-1-morbo@google.com> <20191017012502.186146-1-morbo@google.com>
X-Mailer: git-send-email 2.23.0.700.g56cf767bdb-goog
Subject: [kvm-unit-tests v2 PATCH 1/2] x86: realmode: explicitly copy regs structure
From:   Bill Wendling <morbo@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, alexandru.elisei@arm.com,
        thuth@redhat.com
Cc:     jmattson@google.com, Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Clang prefers to use a "rep;movsl" (or equivalent) to copy the "regs"
structure. This doesn't work in 16-bit mode, as it will end up copying
over half the number of bytes. Avoid this by copying over the structure
a byte at a time.

Signed-off-by: Bill Wendling <morbo@google.com>
---
 x86/realmode.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/x86/realmode.c b/x86/realmode.c
index 303d093..41b8592 100644
--- a/x86/realmode.c
+++ b/x86/realmode.c
@@ -140,6 +140,16 @@ struct insn_desc {
 
 static struct regs inregs, outregs;
 
+static inline void copy_regs(struct regs *dst_regs, struct regs *src_regs)
+{
+	char *dst = (char*)dst_regs;
+	char *src = (char*)src_regs;
+	u32 i;
+
+	for (i = 0; i < sizeof(struct regs); i++)
+		dst[i] = src[i];
+}
+
 static void exec_in_big_real_mode(struct insn_desc *insn)
 {
 	unsigned long tmp;
@@ -148,11 +158,11 @@ static void exec_in_big_real_mode(struct insn_desc *insn)
 	extern u8 test_insn[], test_insn_end[];
 
 	for (i = 0; i < insn->len; ++i)
-	    test_insn[i] = ((u8 *)(unsigned long)insn->ptr)[i];
+		test_insn[i] = ((u8 *)(unsigned long)insn->ptr)[i];
 	for (; i < test_insn_end - test_insn; ++i)
 		test_insn[i] = 0x90; // nop
 
-	save = inregs;
+	copy_regs(&save, &inregs);
 	asm volatile(
 		"lgdtl %[gdt_descr] \n\t"
 		"mov %%cr0, %[tmp] \n\t"
@@ -196,7 +206,8 @@ static void exec_in_big_real_mode(struct insn_desc *insn)
 		: [gdt_descr]"m"(gdt_descr), [bigseg]"r"((short)16)
 		: "cc", "memory"
 		);
-	outregs = save;
+	copy_regs(&outregs, &save);
+
 }
 
 #define R_AX 1
-- 
2.23.0.700.g56cf767bdb-goog

