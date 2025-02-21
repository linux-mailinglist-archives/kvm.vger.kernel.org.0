Return-Path: <kvm+bounces-38910-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E398A40312
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 23:55:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DA7E619E17E7
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 22:54:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 277C7254B13;
	Fri, 21 Feb 2025 22:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xJJXHez9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE703253B4A
	for <kvm@vger.kernel.org>; Fri, 21 Feb 2025 22:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740178453; cv=none; b=DqmAxhJXdKuiRIENCGi8DVZpQUC1mHCofgAzRpDwCXyaV05IiAQCSNkbavTli+aPkiF/gnN2h4idFoHFQalMfnON485J46InziXA9eBf8mCiWGC2RRKsOsvdOgplcbIXLD8Sxp2E4TkGNy9qaDb2yOQpyMQSzEoEw2NioJMYw7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740178453; c=relaxed/simple;
	bh=7c9YtpinxJ2An9V7LGd7mTdvQHnPOsyYvsvt8jLKWsM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Q0ditNkLM/hcPLYg0YNWFdrP/KL6GKrcupNxfXLvAIy2jXXeNa/K5/KK/ObyVvClk7IDlQaZMeem8pBxLrzLVPyT1VkHrvzq3gyoEzht2GqO9VZwwzAkTQKyr4IkmXORcW86EU8ZbNzI9Q6hQk5H3iumxrUsjywfHB8BuPodM5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xJJXHez9; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2f2a9f056a8so5735464a91.2
        for <kvm@vger.kernel.org>; Fri, 21 Feb 2025 14:54:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740178450; x=1740783250; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=o/FJi2X6SuwclR0PYWXyyYTo/Qtd0AY0J67XWAl+how=;
        b=xJJXHez97/t32r7xFcC1QnWeDAT094o0tAy2dfk3YstQDwn+WFrfbq8yU8tyctNJ2l
         UcM9fRrfpI7NQo8EBwFJF41dsqgYeRoRrDU+yVLQDz/qiNQNqd68F/nychzncbVDGqN0
         WmDf/s+oFj9B1C8xTOlRYlLQBYjuWGK/yMB40GklQuTB1xc8Ygh0t6XPO3+YJMfYkn1t
         XdaV9dBzw+/jzFr0l+G67hafT3cNi1eT0P0nAqgHCCik8d/ejtB4DN9sOilHpaVgbZfg
         4jqrXhhK8MpKIrJ9PED+8OFtUGvWNC6sDD+PyOHHNeFJ5SqU0/PatrxuQe3+H4ZTWVCI
         8+kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740178450; x=1740783250;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=o/FJi2X6SuwclR0PYWXyyYTo/Qtd0AY0J67XWAl+how=;
        b=HfChK37rJR7omNI/anvUOvBCGcKudrMP1qTpUJVlgSLmXMqZcAMmBnOkztMGdJWfle
         YR4bBm8poJQgOj2v+kh+ouJvnST0NE2Pm+5eiiDsGau+WwI7/mgAgF2PHF/VYyAxjPwV
         xDjRc+7okYiATPWkBxVMgz/wApakR6aEgLurhjRdAFhgHSMQv8jdmy1HE72gRmv7gwit
         DlfV5KMrkJFDtgYJrEjP9a5OhRgnCxwq2jBUqVZsb0oQQiTiCiMYUUXKdeZo8ubc5thO
         IcihuaWMVLk+pkd4V+OLCVYxjfT2y66TOjl1GcxTx87OX9Xo09o/G6oDeqJePqz16Lj9
         mcow==
X-Gm-Message-State: AOJu0YwO/tQZZ8izJQvqanqbZFeCPx/d+jHBJZM/oK3Pk0vAyiLE4pU5
	NCjL3lTMRxnURnsYwuUIY8PWCrB8Iy+aZtTO9PrvCPxvzRUJH5x7t6gjNmrYRn6E+sowKWkpCd7
	cOA==
X-Google-Smtp-Source: AGHT+IELzXpdzD2DAnoll9k5nfB4rwHnK9En4kd5OfyY8fQeYvROvsP8fkKDoSQo7YODMq3F1X1lKskgHp0=
X-Received: from pjbsc1.prod.google.com ([2002:a17:90b:5101:b0:2fc:2c9c:880])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2e0d:b0:2f2:ab09:c256
 with SMTP id 98e67ed59e1d1-2fce7b07205mr8916738a91.33.1740178449957; Fri, 21
 Feb 2025 14:54:09 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 21 Feb 2025 14:54:04 -0800
In-Reply-To: <20250221225406.2228938-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250221225406.2228938-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <20250221225406.2228938-2-seanjc@google.com>
Subject: [kvm-unit-tests PATCH 1/3] x86: Move descriptor table selector
 #defines to the top of desc.h
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>, Hang SU <darcy.sh@antgroup.com>
Content-Type: text/plain; charset="UTF-8"

Hoist the selector #defines in desc.h to the very top so that they can be
exposed to assembly code with minimal #ifdefs.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/desc.h | 114 ++++++++++++++++++++++++-------------------------
 1 file changed, 57 insertions(+), 57 deletions(-)

diff --git a/lib/x86/desc.h b/lib/x86/desc.h
index 92c45a48..a4459127 100644
--- a/lib/x86/desc.h
+++ b/lib/x86/desc.h
@@ -1,7 +1,61 @@
 #ifndef _X86_DESC_H_
 #define _X86_DESC_H_
 
-#include <setjmp.h>
+/*
+ * selector     32-bit                        64-bit
+ * 0x00         NULL descriptor               NULL descriptor
+ * 0x08         ring-0 code segment (32-bit)  ring-0 code segment (64-bit)
+ * 0x10         ring-0 data segment (32-bit)  ring-0 data segment (32/64-bit)
+ * 0x18         ring-0 code segment (P=0)     ring-0 code segment (64-bit, P=0)
+ * 0x20         intr_alt_stack TSS            ring-0 code segment (32-bit)
+ * 0x28         ring-0 code segment (16-bit)  same
+ * 0x30         ring-0 data segment (16-bit)  same
+ * 0x38 (0x3b)  ring-3 code segment (32-bit)  same
+ * 0x40 (0x43)  ring-3 data segment (32-bit)  ring-3 data segment (32/64-bit)
+ * 0x48 (0x4b)  **unused**                    ring-3 code segment (64-bit)
+ * 0x50-0x78    free to use for test cases    same
+ * 0x80-0x870   primary TSS (CPU 0..254)      same
+ * 0x878-0x1068 percpu area (CPU 0..254)      not used
+ *
+ * Note that the same segment can be used for 32-bit and 64-bit data segments
+ * (the L bit is only defined for code segments)
+ *
+ * Selectors 0x08-0x10 and 0x3b-0x4b are set up for use with the SYSCALL
+ * and SYSRET instructions.
+ */
+
+#define KERNEL_CS   0x08
+#define KERNEL_DS   0x10
+#define NP_SEL      0x18
+#ifdef __x86_64__
+#define KERNEL_CS32 0x20
+#else
+#define TSS_INTR    0x20
+#endif
+#define KERNEL_CS16 0x28
+#define KERNEL_DS16 0x30
+#define USER_CS32   0x3b
+#define USER_DS     0x43
+#ifdef __x86_64__
+#define USER_CS64   0x4b
+#endif
+
+/* Synonyms */
+#define KERNEL_DS32 KERNEL_DS
+#define USER_DS32   USER_DS
+
+#ifdef __x86_64__
+#define KERNEL_CS64 KERNEL_CS
+#define USER_CS     USER_CS64
+#define KERNEL_DS64 KERNEL_DS
+#define USER_DS64   USER_DS
+#else
+#define KERNEL_CS32 KERNEL_CS
+#define USER_CS     USER_CS32
+#endif
+
+#define FIRST_SPARE_SEL 0x50
+#define TSS_MAIN 0x80
 
 #ifdef __ASSEMBLY__
 #define __ASM_FORM(x, ...)	x,## __VA_ARGS__
@@ -15,6 +69,8 @@
 #define __ASM_SEL(a,b)		__ASM_FORM(b)
 #endif
 
+#include <setjmp.h>
+
 void setup_idt(void);
 void load_idt(void);
 void setup_alt_stack(void);
@@ -120,62 +176,6 @@ fep_unavailable:
 	return false;
 }
 
-/*
- * selector     32-bit                        64-bit
- * 0x00         NULL descriptor               NULL descriptor
- * 0x08         ring-0 code segment (32-bit)  ring-0 code segment (64-bit)
- * 0x10         ring-0 data segment (32-bit)  ring-0 data segment (32/64-bit)
- * 0x18         ring-0 code segment (P=0)     ring-0 code segment (64-bit, P=0)
- * 0x20         intr_alt_stack TSS            ring-0 code segment (32-bit)
- * 0x28         ring-0 code segment (16-bit)  same
- * 0x30         ring-0 data segment (16-bit)  same
- * 0x38 (0x3b)  ring-3 code segment (32-bit)  same
- * 0x40 (0x43)  ring-3 data segment (32-bit)  ring-3 data segment (32/64-bit)
- * 0x48 (0x4b)  **unused**                    ring-3 code segment (64-bit)
- * 0x50-0x78    free to use for test cases    same
- * 0x80-0x870   primary TSS (CPU 0..254)      same
- * 0x878-0x1068 percpu area (CPU 0..254)      not used
- *
- * Note that the same segment can be used for 32-bit and 64-bit data segments
- * (the L bit is only defined for code segments)
- *
- * Selectors 0x08-0x10 and 0x3b-0x4b are set up for use with the SYSCALL
- * and SYSRET instructions.
- */
-
-#define KERNEL_CS   0x08
-#define KERNEL_DS   0x10
-#define NP_SEL      0x18
-#ifdef __x86_64__
-#define KERNEL_CS32 0x20
-#else
-#define TSS_INTR    0x20
-#endif
-#define KERNEL_CS16 0x28
-#define KERNEL_DS16 0x30
-#define USER_CS32   0x3b
-#define USER_DS     0x43
-#ifdef __x86_64__
-#define USER_CS64   0x4b
-#endif
-
-/* Synonyms */
-#define KERNEL_DS32 KERNEL_DS
-#define USER_DS32   USER_DS
-
-#ifdef __x86_64__
-#define KERNEL_CS64 KERNEL_CS
-#define USER_CS     USER_CS64
-#define KERNEL_DS64 KERNEL_DS
-#define USER_DS64   USER_DS
-#else
-#define KERNEL_CS32 KERNEL_CS
-#define USER_CS     USER_CS32
-#endif
-
-#define FIRST_SPARE_SEL 0x50
-#define TSS_MAIN 0x80
-
 typedef struct {
 	unsigned short offset0;
 	unsigned short selector;
-- 
2.48.1.601.g30ceb7b040-goog


