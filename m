Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 001C6D535C
	for <lists+kvm@lfdr.de>; Sun, 13 Oct 2019 02:11:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727751AbfJLX7J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 12 Oct 2019 19:59:09 -0400
Received: from mail-vk1-f202.google.com ([209.85.221.202]:56601 "EHLO
        mail-vk1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727184AbfJLX7I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 12 Oct 2019 19:59:08 -0400
Received: by mail-vk1-f202.google.com with SMTP id 63so5313824vkr.23
        for <kvm@vger.kernel.org>; Sat, 12 Oct 2019 16:59:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=zSF4K4KobVK0wAbhJ8ImjLlW0FtYSy+9RfQnkWgPq2s=;
        b=JY4TuIqeZpMKV3pfz3/t4yY+xRCx+eWa8WSue4ArrMk72WYBaO1fp+gl0b6VDp2U7g
         lxpfbdZuglXQC6oeaW6NceC4WmoK7/7n/Et6+TAS8p1BaK7NYsXU8k6VcRgeBGsciVoe
         RuL9F7fuNGVaHgPamm++o2PTFKPZdZsaYXe1hLOqRWz8mAo25ZJ0ExMRl6FhDJsJg5nf
         +SJ7dlCclKNUxhHROUFOofUl+VA+rBKmyXZ02TFyf2ltaai8RyMzV3Rvva3aLdHWDZpI
         sDq33SApopjENhm00j9RpJs9b1gCCBG+ZzxV9IYvyhlIpfOnPCUQPNm+iA9ojdX8Y67E
         0VcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=zSF4K4KobVK0wAbhJ8ImjLlW0FtYSy+9RfQnkWgPq2s=;
        b=O3tw5wdVz2QVouqNmh+3ZeK1UViDtMeCX7WiREiKgGyKHY5ndXCdeBGYK5snJkJDqk
         Fk093xT74V3R0Q+EjTodm2pLGJ9GYY6iPYDL84MT+mUeD3riaRT7tfcF7EWoMUsTaX1b
         h0K6koXzqpSeogRzFBzL5w80op+PTW3Q/O/JLi8aU3FbFjCu3SzGkYDXBhN2UecZcPs+
         BcVYBJRhxA5FpdpgAHDLx3wl7aCtMsZRZRiObdg7WmqWh9cIKQlI6khs61AOCuxBte6M
         fpEwFPD8nrYpJ/oVvnyCosJrFbnc9l/EBGlvZAV6BydVTi4bpmjWO17bQU4COd8YI///
         z06g==
X-Gm-Message-State: APjAAAU7YTIT0UOP9+uEQHeJ3c1LSPyboM+QfiSi8crfmNVwxWW82N8s
        KDnrz94WI5ckOxbULyFq6cYmewkHzLoVNNF7Fez1lZ1g5QhR8bpUw73y4q+JoV7JSWzn9vvyZLL
        kXIq/9SCzpmM9O9h3QBuCg8Trs7nB9G5dqOnySn2scIbFfvSbrnh19Q==
X-Google-Smtp-Source: APXvYqzqhjsc1ENu8a5PE/yUgA7ipRHZ22X+utfzNvFSEWpNwjCIYW8Ew2++2BLxJ8vwJAiJCS7M/ErWrQ==
X-Received: by 2002:a67:c783:: with SMTP id t3mr9169465vsk.113.1570924747493;
 Sat, 12 Oct 2019 16:59:07 -0700 (PDT)
Date:   Sat, 12 Oct 2019 16:58:58 -0700
In-Reply-To: <20191012235859.238387-1-morbo@google.com>
Message-Id: <20191012235859.238387-2-morbo@google.com>
Mime-Version: 1.0
References: <20191012235859.238387-1-morbo@google.com>
X-Mailer: git-send-email 2.23.0.700.g56cf767bdb-goog
Subject: [kvm-unit-tests PATCH 1/2] x86: realmode: explicitly copy structure
 to avoid memcpy
From:   Bill Wendling <morbo@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, alexandru.elisei@arm.com
Cc:     jmattson@google.com, Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Clang prefers to use a "mempcy" (or equivalent) to copy the "regs"
structure. This doesn't work in 16-bit mode, as it will end up copying
over half the number of bytes. GCC performs a field-by-field copy of the
structure, so force clang to do the same thing.

Signed-off-by: Bill Wendling <morbo@google.com>
---
 x86/realmode.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/x86/realmode.c b/x86/realmode.c
index 303d093..cf45fd6 100644
--- a/x86/realmode.c
+++ b/x86/realmode.c
@@ -117,6 +117,19 @@ struct regs {
 	u32 eip, eflags;
 };
 
+#define COPY_REG(name, dst, src) (dst).name = (src).name
+#define COPY_REGS(dst, src)				\
+	COPY_REG(eax, dst, src);			\
+	COPY_REG(ebx, dst, src);			\
+	COPY_REG(ecx, dst, src);			\
+	COPY_REG(edx, dst, src);			\
+	COPY_REG(esi, dst, src);			\
+	COPY_REG(edi, dst, src);			\
+	COPY_REG(esp, dst, src);			\
+	COPY_REG(ebp, dst, src);			\
+	COPY_REG(eip, dst, src);			\
+	COPY_REG(eflags, dst, src)
+
 struct table_descr {
 	u16 limit;
 	void *base;
@@ -148,11 +161,11 @@ static void exec_in_big_real_mode(struct insn_desc *insn)
 	extern u8 test_insn[], test_insn_end[];
 
 	for (i = 0; i < insn->len; ++i)
-	    test_insn[i] = ((u8 *)(unsigned long)insn->ptr)[i];
+		test_insn[i] = ((u8 *)(unsigned long)insn->ptr)[i];
 	for (; i < test_insn_end - test_insn; ++i)
 		test_insn[i] = 0x90; // nop
 
-	save = inregs;
+	COPY_REGS(save, inregs);
 	asm volatile(
 		"lgdtl %[gdt_descr] \n\t"
 		"mov %%cr0, %[tmp] \n\t"
@@ -196,7 +209,7 @@ static void exec_in_big_real_mode(struct insn_desc *insn)
 		: [gdt_descr]"m"(gdt_descr), [bigseg]"r"((short)16)
 		: "cc", "memory"
 		);
-	outregs = save;
+	COPY_REGS(outregs, save);
 }
 
 #define R_AX 1
-- 
2.23.0.700.g56cf767bdb-goog

