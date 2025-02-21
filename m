Return-Path: <kvm+bounces-38912-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 12D75A4030C
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 23:54:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A21DF3A9BC4
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 22:54:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15EBF255E2B;
	Fri, 21 Feb 2025 22:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="s6mZlJQU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A84BB254AE0
	for <kvm@vger.kernel.org>; Fri, 21 Feb 2025 22:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740178455; cv=none; b=FoRoPZ8A7CVPEmvauBCGy29fDZSPlZOpFaL4xtVrLSlpdyZRXk5q/2ecb/qmiFKErCe4HmEp5P9X4cpLvZpDCJDwGsPUzZNir3nwIdTb1auRb3BEFZq0Gq6eR2LIlWepNp/pppyVUlMQRYUsMvw2BowH4GfM/fJfNUy6t/gEcGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740178455; c=relaxed/simple;
	bh=zICg1q31qexijKRdIoRsJTp/MMS16c4Nm2MeZK2eGVM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nei8EidvjZh6u7UqQM9rWg0tSCKy1oVovmWnN9Jpo1Kmqar9bHreuT0Fn2COedacWOJ2OR3pI+eyHfGMg1r5qPNU98u7anfQyZAg2R1Pz27Lfo1SSyGuoPkr9IUKGKy3+GmWhHaccuclNFgyWNo/nB1DGK7P3eH2j5cpmuGDOY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=s6mZlJQU; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fc4fc93262so5750467a91.1
        for <kvm@vger.kernel.org>; Fri, 21 Feb 2025 14:54:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740178453; x=1740783253; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=g9P0xwPdy6iFMXrJqHv4yRjV0aWb0ZuzTZ9aojlgcvw=;
        b=s6mZlJQUZTTLhl8yukvUC6rRxzT7iK6mKbv8x5ItV4bF3XjrYtzPOV4+uzPIhkuYIo
         Jg2BdMpbZc5W39TpOvxDU49ilOoyy4ba/Kreuyc6ymHM+GsFHL8VVh8mh9YmMIfRamGE
         JZVEyTyqcPGIZokac143BTrlepqu3WzMiAm5fqn3nT+99I9abP3Y5EEVmuNqwtXMg2p9
         ClIJjoQEX2hh3GQnYYFL375a2b7BsucqWn0Yg0bYKDx4hSTN6iww92F3WkMWYiJan6vS
         ld5VrB4P89CYwZRWcMsi+vS3tKSQq32lB/5hU1Zw4F1pB0xfQF5oPm3MB4Jq2TcMbzVx
         2ynw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740178453; x=1740783253;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=g9P0xwPdy6iFMXrJqHv4yRjV0aWb0ZuzTZ9aojlgcvw=;
        b=t9YQMYMRt+XxEi0ig2IaCQ0QC+ImPSblsA2rB5KVZFiXt1e2may14EAgcpIKp1VUxP
         RQv0wMAZuXoJnelL18g98yQTuWxM0vPbfnHBPWKUdsMk12gqIk/6O10qxHvP/oNlfq38
         TXdlIHCHk5PO6vEMcmb3BZ4nFjHfgf4k8hrqOiOT6u4fzDq8B5wtu2F1MwVXMdGYLN5/
         JNLjQUal3R+ct2amHlO7HmydD291ctlAXkHsCEK47XMETkjejP9oyKUNqDDryg1Xal5M
         4tJy8Rj+4SS18GPcv5vMek0roblLPU94qKbpIi0yzQw6bZv2Hwp2ZivE1XmaCx0wGApT
         8rcQ==
X-Gm-Message-State: AOJu0Yyzq8RXZk+qEDknpIJygxgZ2xxSZzyqpAzt+9chRWbHHwWd6RW3
	xcYivLcu2Z26b3nAn6G4dO7b6Qf37AjsK6HmO3733vKpUQn5OlWov71D/dgkp51uF45seI8N5b1
	law==
X-Google-Smtp-Source: AGHT+IEASW1PZ9iosm1xJUBFUFI5wHyNRxTVoWB9CFeFDsXjfbwCfyQiju4QqiYGXy9XU5a0rYYuIX5W/aM=
X-Received: from pfbkm49.prod.google.com ([2002:a05:6a00:3c71:b0:730:7c5b:2e2b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:17a2:b0:732:24ad:8e08
 with SMTP id d2e1a72fcca58-73426c8555cmr7208224b3a.1.1740178452902; Fri, 21
 Feb 2025 14:54:12 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 21 Feb 2025 14:54:06 -0800
In-Reply-To: <20250221225406.2228938-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250221225406.2228938-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <20250221225406.2228938-4-seanjc@google.com>
Subject: [kvm-unit-tests PATCH 3/3] x86: replace segment selector magic number
 with macro definition
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>, Hang SU <darcy.sh@antgroup.com>
Content-Type: text/plain; charset="UTF-8"

From: Hang SU <darcysail@gmail.com>

Add assembly check in desc.h, to replace segment selector
magic number with macro definition.

Signed-off-by: Hang SU <darcy.sh@antgroup.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/desc.h    | 7 ++++++-
 x86/cstart64.S    | 8 ++++----
 x86/trampolines.S | 8 +++++---
 3 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/lib/x86/desc.h b/lib/x86/desc.h
index aa6213d1..5634de94 100644
--- a/lib/x86/desc.h
+++ b/lib/x86/desc.h
@@ -69,6 +69,8 @@
 #define __ASM_SEL(a,b)		__ASM_FORM(b)
 #endif
 
+#ifndef __ASSEMBLER__
+
 #include <setjmp.h>
 
 void setup_idt(void);
@@ -338,4 +340,7 @@ do {									\
 
 #define asm_safe_report_ex __asm_safe_report
 
-#endif
+
+#endif /* __ASSEMBLER__ */
+
+#endif /* _X86_DESC_H_ */
diff --git a/x86/cstart64.S b/x86/cstart64.S
index 4dff1102..2b14c076 100644
--- a/x86/cstart64.S
+++ b/x86/cstart64.S
@@ -1,5 +1,5 @@
-
 #include "apic-defs.h"
+#include "desc.h"
 
 ipi_vector = 0x20
 
@@ -66,7 +66,7 @@ start:
 	mov $stacktop, %esp
 	setup_percpu_area
 	call prepare_64
-	jmpl $8, $start64
+	jmpl $KERNEL_CS, $start64
 
 switch_to_5level:
 	/* Disable CR4.PCIDE */
@@ -86,11 +86,11 @@ switch_to_5level:
 	bts $12, %eax
 	mov %eax, %cr4
 
-	mov $0x10, %ax
+	mov $KERNEL_DS, %ax
 	mov %ax, %ss
 
 	call enter_long_mode
-	jmpl $8, $lvl5
+	jmpl $KERNEL_CS, $lvl5
 
 smp_stacktop:	.long stacktop - 4096
 
diff --git a/x86/trampolines.S b/x86/trampolines.S
index 6a3df9c1..f0b05ab5 100644
--- a/x86/trampolines.S
+++ b/x86/trampolines.S
@@ -3,6 +3,8 @@
  * transition from 32-bit to 64-bit code (x86-64 only)
  */
 
+#include "desc.h"
+
  /* EFI provides it's own SIPI sequence to handle relocation. */
 #ifndef CONFIG_EFI
 .code16
@@ -15,7 +17,7 @@ sipi_entry:
 	or $1, %eax
 	mov %eax, %cr0
 	lgdtl ap_rm_gdt_descr - sipi_entry
-	ljmpl $8, $ap_start32
+	ljmpl $KERNEL_CS32, $ap_start32
 sipi_end:
 
 .globl ap_rm_gdt_descr
@@ -66,7 +68,7 @@ MSR_GS_BASE = 0xc0000101
 	mov $MSR_GS_BASE, %ecx
 	rdmsr
 
-	mov $0x10, %bx
+	mov $KERNEL_DS, %bx
 	mov %bx, %ds
 	mov %bx, %es
 	mov %bx, %fs
@@ -123,7 +125,7 @@ ap_start32:
 	call prepare_64
 
 	load_absolute_addr $ap_start64, %edx
-	pushl $0x08
+	pushl $KERNEL_CS
 	pushl %edx
 	lretl
 #endif
-- 
2.48.1.601.g30ceb7b040-goog


