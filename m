Return-Path: <kvm+bounces-38915-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CC2D5A40391
	for <lists+kvm@lfdr.de>; Sat, 22 Feb 2025 00:39:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5982A70491B
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 23:38:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BECE620B1F7;
	Fri, 21 Feb 2025 23:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fXa+fG9Q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70AAF18DB0B
	for <kvm@vger.kernel.org>; Fri, 21 Feb 2025 23:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740181117; cv=none; b=aMRELPxebOKN8wBBJ4/yR/2mY3zAN/nHwRXvbu3oKrdZWMRRZnSy4ajEvmk68lA3ATPQ7cyptfPjkHKBi8JCi5zWEQe96VYrLNLSp7UNmxj/gFtcXJIuV0aED+e1tCAeMWyDZgeMCjk+pRyNpEIOBzjzZdKVSwJ8/tgrHiUgTDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740181117; c=relaxed/simple;
	bh=zsbN1KW2DxXzaund738OKY9qG1w2P2roMK834Y5jgGg=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=l4j48YW6wQS7YBG9Fva545wisUYGxPwY0LVtkpbvIVceF2IAUSl/ZUg7d+pXZy80bFbV/Z61XfNsAaYKpUOY/gpzkv9qfeOjr0mKs2h2RjQtSSvketnq0QSTxw8NXRTUg6r9T2sk0pfozErZbvCQ02HjDY9ylt6QLmjXeNFUWG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fXa+fG9Q; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-220d8599659so53280695ad.0
        for <kvm@vger.kernel.org>; Fri, 21 Feb 2025 15:38:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740181114; x=1740785914; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zkzvwT7TdLGHmq3253lfTa+HVI8Qa/GtJxC4JD86osQ=;
        b=fXa+fG9QAaCFs5OwvU7GL7JvnwPpidTNyO8kS9d1bYNAd3cwYQHZS7vKWt9AihrthB
         lo6gO9nBmYh6mivZWCf3Y8ywx7SIV4RZ4pG0Wwk+d1gt0tWk4EHDBGucU2VQrgfpWypC
         aJkXEzXYDLL270zNC8fS6k+fKYAXIGzWSheLxFS9ggKZjSRpXNqzyvjZc6H9gvkp9rbL
         iPMxRkqOLgFtG8X1Uh/nZltJV3nl9WHKISgNR/W8VJgOergQIYgw7yAvQZP/ePAYXmQP
         rV0Lw77n4pIFkJswVqTQrxUUXjxWEOjJB/ImGmGe3gtGPGk16Xs/yiDGxzoY9IMDU5z6
         Pxbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740181114; x=1740785914;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zkzvwT7TdLGHmq3253lfTa+HVI8Qa/GtJxC4JD86osQ=;
        b=ZoKyZw2QdoFgYknWSozZr3HQpYj6n4i6bkzP/vvD5Q4S3PUXOa9xiyNkvyPZCU/H1e
         KLP/y3NLMCRmgm9p67TWS49AhjUuGGC9H+FEDDvsF4pWRv9furw6he4XKzCGpl5W+3Yu
         jtv9PSXW0nv3BmTsv/IhyCqm4bJQPTdYK5PZnrbrQWJWzWt5S0G5/ZAhC2sLXC6GEchE
         vjL4VwTRl7+sFGX8Z1Nz3P84qPGqpmP4OG1tSh2IqJW/dhvqTjg33c12CDiN92oYZm5A
         TcCJOs9fGtUAVlMhQNOGk0XcQfIQ1Itd+EHDQTJpSOhcBVCDza6xOG8gy6y2azBsnBj/
         6Pkw==
X-Gm-Message-State: AOJu0YwZyimKuQUsWj4ZD/CUJytBCxKLaMhdNnDzpzyPNeVdbifhHDhO
	OSi2mGhVD2JbdApDVnKcFmOVZ9BF7ZRHz2tTSVRtlEDeUS2CxQm81t0DDW1uam+Rs0LkXAgtdKM
	QKQ==
X-Google-Smtp-Source: AGHT+IGotodv0xde0oPlJJ5bgUVo1/EAhLRr7Oh6TrTTGC+ltwR+ikCmnsTY/FI5baHAaTGA3QepkaPySjg=
X-Received: from pjz8.prod.google.com ([2002:a17:90b:56c8:b0:2fc:c98:ea47])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ce85:b0:215:6995:1ef3
 with SMTP id d9443c01a7336-2219ff32f6fmr57808365ad.3.1740181114699; Fri, 21
 Feb 2025 15:38:34 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 21 Feb 2025 15:38:32 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <20250221233832.2251456-1-seanjc@google.com>
Subject: [kvm-unit-tests PATCH] x86: Move SMP #defines from apic-defs.h to smp.h
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Now that the __ASSEMBLY__ versus __ASSEMBLER_ mess is sorted out, move
the SMP related #defines from apic-defs.h to smp.h, and drop the comment
that explains the hackery.

Opportunistically make REALMODE_GDT_LOWMEM visible to assembly code as
well, and drop efistart64.S's local copy.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---

This applies on top of two combined series:
  
  https://lore.kernel.org/all/20250221225406.2228938-1-seanjc@google.com
  https://lore.kernel.org/all/20250215012032.1206409-1-seanjc@google.com

 lib/x86/apic-defs.h  |  8 --------
 lib/x86/apic.h       |  2 ++
 lib/x86/smp.h        | 18 +++++++++++++++---
 x86/cstart.S         |  1 +
 x86/cstart64.S       |  1 +
 x86/efi/efistart64.S |  3 +--
 x86/trampolines.S    |  1 +
 7 files changed, 21 insertions(+), 13 deletions(-)

diff --git a/lib/x86/apic-defs.h b/lib/x86/apic-defs.h
index 5a1dff3a..fd82b815 100644
--- a/lib/x86/apic-defs.h
+++ b/lib/x86/apic-defs.h
@@ -1,14 +1,6 @@
 #ifndef _X86_APIC_DEFS_H_
 #define _X86_APIC_DEFS_H_
 
-/*
- * Abuse this header file to hold the number of max-cpus and the size of the
- * per-CPU stack/data area, making them available both in C and ASM.  One page
- * for per-CPU, and two pages for the stack (plus some buffer in-between).
- */
-#define MAX_TEST_CPUS (255)
-#define PER_CPU_SIZE  (3 * 4096)
-
 /*
  * Constants for various Intel APICs. (local APIC, IOAPIC, etc.)
  *
diff --git a/lib/x86/apic.h b/lib/x86/apic.h
index 8df889b2..23c771ed 100644
--- a/lib/x86/apic.h
+++ b/lib/x86/apic.h
@@ -3,7 +3,9 @@
 
 #include <bitops.h>
 #include <stdint.h>
+
 #include "apic-defs.h"
+#include "smp.h"
 
 extern u8 id_map[MAX_TEST_CPUS];
 
diff --git a/lib/x86/smp.h b/lib/x86/smp.h
index 08a440b3..bbe90daa 100644
--- a/lib/x86/smp.h
+++ b/lib/x86/smp.h
@@ -1,15 +1,25 @@
 #ifndef _X86_SMP_H_
 #define _X86_SMP_H_
 
+#define MAX_TEST_CPUS (255)
+
+/*
+ * Allocate 12KiB of data for per-CPU usage.  One page for per-CPU data, and
+ * two pages for the stack (plus some buffer in-between).
+ */
+#define PER_CPU_SIZE  (3 * 4096)
+
+/* Address where to store the address of realmode GDT descriptor. */
+#define REALMODE_GDT_LOWMEM (PAGE_SIZE - 2)
+
+#ifndef __ASSEMBLER__
+
 #include <stddef.h>
 #include <asm/spinlock.h>
 #include "libcflat.h"
 #include "atomic.h"
 #include "apic-defs.h"
 
-/* Address where to store the address of realmode GDT descriptor. */
-#define REALMODE_GDT_LOWMEM (PAGE_SIZE - 2)
-
 /* Offsets into the per-cpu page. */
 struct percpu_data {
 	uint32_t  smp_id;
@@ -90,4 +100,6 @@ void ap_online(void);
 extern atomic_t cpu_online_count;
 extern unsigned char online_cpus[(MAX_TEST_CPUS + 7) / 8];
 
+#endif /* __ASSEMBLER__ */
+
 #endif
diff --git a/x86/cstart.S b/x86/cstart.S
index 2e396e52..96e79a47 100644
--- a/x86/cstart.S
+++ b/x86/cstart.S
@@ -1,5 +1,6 @@
 
 #include "apic-defs.h"
+#include "smp.h"
 
 .global online_cpus
 
diff --git a/x86/cstart64.S b/x86/cstart64.S
index 018bac98..f3c398a5 100644
--- a/x86/cstart64.S
+++ b/x86/cstart64.S
@@ -1,5 +1,6 @@
 #include "apic-defs.h"
 #include "desc.h"
+#include "smp.h"
 
 ipi_vector = 0x20
 
diff --git a/x86/efi/efistart64.S b/x86/efi/efistart64.S
index 3fc16016..6025dc2f 100644
--- a/x86/efi/efistart64.S
+++ b/x86/efi/efistart64.S
@@ -3,7 +3,7 @@
 #include "apic-defs.h"
 #include "asm-generic/page.h"
 #include "crt0-efi-x86_64.S"
-
+#include "smp.h"
 
 /* Reserve stack in .data */
 .data
@@ -36,7 +36,6 @@ ptl4:
 .text
 
 .code16
-REALMODE_GDT_LOWMEM = PAGE_SIZE - 2
 
 .globl rm_trampoline
 rm_trampoline:
diff --git a/x86/trampolines.S b/x86/trampolines.S
index 02d9f321..c3f2bd29 100644
--- a/x86/trampolines.S
+++ b/x86/trampolines.S
@@ -3,6 +3,7 @@
  * transition from 32-bit to 64-bit code (x86-64 only)
  */
 #include "apic-defs.h"
+#include "smp.h"
 
 per_cpu_size = PER_CPU_SIZE
 

base-commit: 42bbd80783ab0985dbd195358aa89de8a69cb0ab
-- 
2.48.1.601.g30ceb7b040-goog


