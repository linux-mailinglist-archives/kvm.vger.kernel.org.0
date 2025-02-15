Return-Path: <kvm+bounces-38245-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ABD05A36ACD
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 02:20:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 963513B1051
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 01:20:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 350831465AD;
	Sat, 15 Feb 2025 01:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="02yOAk+b"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E64737CF16
	for <kvm@vger.kernel.org>; Sat, 15 Feb 2025 01:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739582439; cv=none; b=uRHHLP+PqMRlkjnQp5+0p1S18ieq8wNgrhmbX8HSDggYOLV4SJN0ypIOPH107sye0OMMrv1ELHvPvOIrE6txRLeyWImdMnrdHPAKveX2YJOB669hJs3rM92hH0pgHl/J2cBthBgOiS1r4xBPI7NryCWh0CnmVBacql89tPuxYcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739582439; c=relaxed/simple;
	bh=Uf92co6GsvMjbJeo6hIr90Jl8Jr6gPEVbxBeO4qVvbI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dbKFFBHLyrzQptC8ChGYZOlLUlg4MTWmznwEHNWCVQMSPoJ5ERcjFOcdiVYPy9yuZrij/+ZZt8oLSbfry2G2r6Tu9uscV+rJPxyPFeDbzTUwI5sxoKK9nA6WJNiiqk6lWojv8q6Beq6XEq5eOLMCw/p9Fi5grPuRv4JlasGPNDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=02yOAk+b; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fc45101191so83796a91.1
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 17:20:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739582437; x=1740187237; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=/wqJPL5rEOwh0uTD5V91WVlD44haZoP031krfIHlyrs=;
        b=02yOAk+bv9rsPmG/8IrwLhJktUG9fa7PxLGoYMr4WjlnUsAky877SXkRZf7GT7kriz
         y690ZEHs7JWiwpBEpapNp/x4RHonOU5zxHmEhUKOlXskJJkzfNKMVPOuDAESwULYoW/o
         bO9CwkG7GmiEdW6E4ZBbxIQZ8QEyhkTV5FjfkeCgYxH5x08vF89qn9j9s5Lb2gHnXXXb
         y9814YdIH6v+m0y0yvT8T+aZUhpvH2q/Bsd+XYLd8Q1CoMhP15XrkPcYWeDfdZ31e2nc
         Dupe+VKAdbUNjUDirHEVZ/+l1sv5H6wCU4AvEAKODKoq3JAvUdSfGW/C59GhZBQGiD/f
         wrgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739582437; x=1740187237;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/wqJPL5rEOwh0uTD5V91WVlD44haZoP031krfIHlyrs=;
        b=OXDsMPGaBLJerf0++mhlp8DRBiazTigI9oetBaWXfd+CNkhF4Ws5Ieo+iXI3Nb2JYz
         Afi+r+x1Of83xetR7eNtdoJ4slaInAlaxDkALQNX3HMkn7RbgYphMWLl8Z91ibuER1PO
         ji/kt2woYzFeyA1iREd25PhFT5Ie2wCMTEzEF1SMjfSvL62rc9h13s8fY1Wq8ohcrGic
         0xmIelrY9VsUvhOiwAaWdGkz8SGBFaom9nnwfgHhzTdcL2lZrCACRK5cqwlYF78JXqoc
         DIyQenmqGccdiNThFZKrCMREuCmp6SbBdlSMtB/79k0ieR5CLyNkaspsMa6TpfY1n6uL
         lAOQ==
X-Gm-Message-State: AOJu0Yx0R1F/lJ6rPgwPZd6CXwGLWsxyp8Rxud1xIap6exER6Max5sVB
	Hl5eG5cPxohcxYqz+lNbUWhGsL0vkPFJN7NV3J8zMYzEHirADxaVOhTf/J4C6pzGdUBeLv6pNeP
	afA==
X-Google-Smtp-Source: AGHT+IEN8RL4m+/RcKldii1cYxNUGp7pDK4+oi0ftiYKtfmdA7+iqRgp3SBVH0kqfU5dyQC9rM2QxBajLJE=
X-Received: from pjl5.prod.google.com ([2002:a17:90b:2f85:b0:2fc:1356:bcc3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:e7c3:b0:2ee:dd79:e046
 with SMTP id 98e67ed59e1d1-2fc40f105aemr1952332a91.13.1739582437350; Fri, 14
 Feb 2025 17:20:37 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 14 Feb 2025 17:20:31 -0800
In-Reply-To: <20250215012032.1206409-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250215012032.1206409-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <20250215012032.1206409-3-seanjc@google.com>
Subject: [kvm-unit-tests PATCH 2/3] x86: Add a macro for the size of the
 per-CPU stack/data area
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Add a macro to define the size of the per-CPU stack/data area so that it's
somewhat possible to make sense of the madness.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/apic-defs.h | 6 +++---
 lib/x86/setup.c     | 2 +-
 lib/x86/smp.c       | 2 +-
 x86/cstart.S        | 7 ++++---
 x86/cstart64.S      | 5 +++--
 x86/trampolines.S   | 7 +++++--
 6 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/lib/x86/apic-defs.h b/lib/x86/apic-defs.h
index 4db73da2..fde1db38 100644
--- a/lib/x86/apic-defs.h
+++ b/lib/x86/apic-defs.h
@@ -2,11 +2,11 @@
 #define _X86_APIC_DEFS_H_
 
 /*
- * Abuse this header file to hold the number of max-cpus, making it available
- * both in C and ASM
+ * Abuse this header file to hold the number of max-cpus and the size of the
+ * per-CPU stack/data area, making them available both in C and ASM.
  */
-
 #define MAX_TEST_CPUS (255)
+#define PER_CPU_SIZE  (4096)
 
 /*
  * Constants for various Intel APICs. (local APIC, IOAPIC, etc.)
diff --git a/lib/x86/setup.c b/lib/x86/setup.c
index d509a248..b4b7fec0 100644
--- a/lib/x86/setup.c
+++ b/lib/x86/setup.c
@@ -146,7 +146,7 @@ unsigned long setup_tss(u8 *stacktop)
 	set_gdt_entry(TSS_MAIN + id * 8,
 		      (unsigned long)tss_entry, 0xffff, 0x89, 0);
 	set_gdt_entry(TSS_MAIN + MAX_TEST_CPUS * 8 + id * 8,
-		      (unsigned long)stacktop - 4096, 0xfffff, 0x93, 0xc0);
+		      (unsigned long)stacktop - PER_CPU_SIZE, 0xfffff, 0x93, 0xc0);
 
 	return TSS_MAIN + id * 8;
 }
diff --git a/lib/x86/smp.c b/lib/x86/smp.c
index e297016c..9706072a 100644
--- a/lib/x86/smp.c
+++ b/lib/x86/smp.c
@@ -273,7 +273,7 @@ void bringup_aps(void)
 	setup_rm_gdt();
 
 #ifdef CONFIG_EFI
-	smp_stacktop = ((u64) (&stacktop)) - PAGE_SIZE;
+	smp_stacktop = ((u64) (&stacktop)) - PER_CPU_SIZE;
 #endif
 
 	/* INIT */
diff --git a/x86/cstart.S b/x86/cstart.S
index df3458fe..2e396e52 100644
--- a/x86/cstart.S
+++ b/x86/cstart.S
@@ -5,11 +5,12 @@
 
 ipi_vector = 0x20
 
+per_cpu_size = PER_CPU_SIZE
 max_cpus = MAX_TEST_CPUS
 
 .bss
 .align 4096
-	. = . + 4096 * max_cpus
+	. = . + PER_CPU_SIZE * max_cpus
 stacktop:
 
 .data
@@ -81,7 +82,7 @@ prepare_32:
 	mov %eax, %cr0
 	ret
 
-smp_stacktop:	.long stacktop - 4096
+smp_stacktop:	.long stacktop - per_cpu_size
 
 save_id:
 	movl $(APIC_DEFAULT_PHYS_BASE + APIC_ID), %eax
@@ -92,7 +93,7 @@ save_id:
 
 ap_start32:
 	setup_segments
-	mov $-4096, %esp
+	mov $-per_cpu_size, %esp
 	lock xaddl %esp, smp_stacktop
 	setup_tr_and_percpu
 	call prepare_32
diff --git a/x86/cstart64.S b/x86/cstart64.S
index bafb2017..a9db65ce 100644
--- a/x86/cstart64.S
+++ b/x86/cstart64.S
@@ -3,11 +3,12 @@
 
 ipi_vector = 0x20
 
+per_cpu_size = PER_CPU_SIZE
 max_cpus = MAX_TEST_CPUS
 
 .bss
 .align 4096
-	. = . + 4096 * max_cpus
+	. = . + PER_CPU_SIZE * max_cpus
 stacktop:
 
 .data
@@ -91,7 +92,7 @@ switch_to_5level:
 	call enter_long_mode
 	jmpl $8, $lvl5
 
-smp_stacktop:	.long stacktop - 4096
+smp_stacktop:	.long stacktop - per_cpu_size
 
 .align 16
 
diff --git a/x86/trampolines.S b/x86/trampolines.S
index 6a3df9c1..02713157 100644
--- a/x86/trampolines.S
+++ b/x86/trampolines.S
@@ -2,6 +2,9 @@
  * Common bootstrapping code to transition from 16-bit to 32-bit code, and to
  * transition from 32-bit to 64-bit code (x86-64 only)
  */
+#include "apic-defs.h"
+
+per_cpu_size = PER_CPU_SIZE
 
  /* EFI provides it's own SIPI sequence to handle relocation. */
 #ifndef CONFIG_EFI
@@ -56,7 +59,7 @@ rm_trampoline_end:
 MSR_GS_BASE = 0xc0000101
 
 .macro setup_percpu_area
-	lea -4096(%esp), %eax
+	lea -per_cpu_size(%esp), %eax
 	mov $0, %edx
 	mov $MSR_GS_BASE, %ecx
 	wrmsr
@@ -116,7 +119,7 @@ ap_start32:
 	setup_segments
 
 	load_absolute_addr $smp_stacktop, %edx
-	mov $-4096, %esp
+	mov $-per_cpu_size, %esp
 	lock xaddl %esp, (%edx)
 
 	setup_percpu_area
-- 
2.48.1.601.g30ceb7b040-goog


