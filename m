Return-Path: <kvm+bounces-20244-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EE32E912533
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 14:27:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 98E711F232C0
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 12:27:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD777152177;
	Fri, 21 Jun 2024 12:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Gp7jphKC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B1C1152175
	for <kvm@vger.kernel.org>; Fri, 21 Jun 2024 12:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718972811; cv=none; b=bUY+52DeHy81vLY7yzFDW+6B+jUjxzHYMOxO+vOPincRi9E13JXRB34kyo98xi1wbJ7yt4Yv1kMBgUNBzAzDKMm7JLApEbj6fM9eo68j5RPKc7MUzqIr9AY8tTHo7yWACOW7z7oZGhZIL1rHqkPJ8g1t0XwPzfcrTLTHhVAbFZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718972811; c=relaxed/simple;
	bh=LgW+0d96kc7ohGQOm01kKeq9+FwZT2gj4n5dZKHOTiw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=kX4Vzfl8Sp44/qxFpnWll7jXTACd7ko9CsqEQZOv1bv0zrfGdnkAzvwz+EN3NAQThbYamtYFKUnxIJZVSG3zYtF3tMb1BT5z+gUYyMyOd0ykRYTw7w5YYqwk0ytSCujYNOPdBeoow7lP26Y5HlXoAdiDv2WEVT48CtXITuRCs5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Gp7jphKC; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1f64ecb1766so14959965ad.1
        for <kvm@vger.kernel.org>; Fri, 21 Jun 2024 05:26:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718972806; x=1719577606; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=TviJfEL1iYIgc1pLe5SU4HRDZORM4DRoCu52e4CotQo=;
        b=Gp7jphKC+y3jooEa7v3ApotNZCdvTRCUWdfNhxqRAe9XspPALmBZzd25bCAi8hBVYN
         1Ai/sDsYVzHWK4coHT8B1pUqo/0wmq7/D813g5wVIIS77+TX5zLVS12HXI9ACq2nswZp
         YDPgSZBw9oA0bGXBBIjIjKPQsi6A+dT/56AfqwEQhcWLwF7u8f6yAaDcN82fzhDr0PF3
         CmpedHH285WwSWmQHp0neljjOhhEZQ8TJfDjeXdFx0LJML6eI2I07kvST8HRcNSOWinj
         rx2hreTOifdAS32uS8WCa62d9pWVUdpDMq/LAyeIADjOvktBbyFePcwJKf9tNLRG3B8J
         0FAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718972806; x=1719577606;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TviJfEL1iYIgc1pLe5SU4HRDZORM4DRoCu52e4CotQo=;
        b=GFcuOynfCWCQAANtVSnTMLb8wrALnETljBZ/3PEqyUkt7V0ibTdoq2o+OQGAFfsM+/
         sLbPkqflKuf9mQ5hLn43uDCF3piJhVfL3vP7BwnPTk5LHPpvtUDuTrnfPky4pUlXjbNC
         hZNuhg96Aw1Q5rY3wA/A3OL3REY6tdgjqO/vDBCnp6p41WUz3jLFELL8NiiJCTpYcfy8
         HcJe+7GIelPdQLZIoFoesHPYshfd38owexPaMLpLKLfRRMAMNnqTMsaHPFqS7A+s9QB5
         mLvyKjTiMxzectP1llYRHVzOrs+9z1za7Z1ws7YnZqng9X8tWsdr/cEhZNE2ku+fOA/Z
         Ef5Q==
X-Gm-Message-State: AOJu0Yxs1Swi+TTGAslG72zRCaPfStyzGbW5WAXGwFOOhdn4fkqb3FQJ
	cagguUK15foU5/2lM8MRbjfU/anji+lzFT8eziIilexPLApblc4M/MY9wRvkyB8=
X-Google-Smtp-Source: AGHT+IGl4DaKAEJE0Xx66xWXqDrRzrg3XVU6xeXMJlm6LxwT/Mq/w67s4x/56o1DrabXMKKzUt+dug==
X-Received: by 2002:a17:902:eb49:b0:1f7:1ba5:85ff with SMTP id d9443c01a7336-1f9aa462935mr71581245ad.57.1718972806199;
        Fri, 21 Jun 2024 05:26:46 -0700 (PDT)
Received: from oslab.. (104.160.44.83.16clouds.com. [104.160.44.83])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f9eb2f02e3sm13002095ad.62.2024.06.21.05.26.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jun 2024 05:26:45 -0700 (PDT)
From: Hang SU <darcysail@gmail.com>
X-Google-Original-From: Hang SU <darcy.sh@antgroup.com>
To: kvm@vger.kernel.org
Cc: darcy.sh@antgroup.com,
	jiangshan.ljs@antgroup.com,
	houwenlong.hwl@antgroup.com
Subject: [kvm-unit-tests PATCH] x86: replace segment selector magic number with macro definition
Date: Fri, 21 Jun 2024 20:26:40 +0800
Message-Id: <20240621122640.2347541-1-darcy.sh@antgroup.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add assembly check in desc.h, to replace segment selector
magic number with macro definition.

Signed-off-by: Hang SU <darcy.sh@antgroup.com>
---
 lib/x86/desc.h    | 12 +++++++++---
 x86/cstart64.S    |  6 +++---
 x86/trampolines.S |  8 +++++---
 3 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/lib/x86/desc.h b/lib/x86/desc.h
index 7778a0f8..61000257 100644
--- a/lib/x86/desc.h
+++ b/lib/x86/desc.h
@@ -1,8 +1,6 @@
 #ifndef _X86_DESC_H_
 #define _X86_DESC_H_
 
-#include <setjmp.h>
-
 #ifdef __ASSEMBLY__
 #define __ASM_FORM(x, ...)	x,## __VA_ARGS__
 #else
@@ -15,6 +13,9 @@
 #define __ASM_SEL(a,b)		__ASM_FORM(b)
 #endif
 
+#if !defined(__ASSEMBLY__) && !defined(__ASSEMBLER__)
+#include <setjmp.h>
+
 void setup_idt(void);
 void load_idt(void);
 void setup_alt_stack(void);
@@ -119,6 +120,7 @@ static inline bool is_fep_available(void)
 fep_unavailable:
 	return false;
 }
+#endif //#if !defined(__ASSEMBLY__) && !defined(__ASSEMBLER__)
 
 /*
  * selector     32-bit                        64-bit
@@ -176,6 +178,8 @@ fep_unavailable:
 #define FIRST_SPARE_SEL 0x50
 #define TSS_MAIN 0x80
 
+#if !defined(__ASSEMBLY__) && !defined(__ASSEMBLER__)
+
 typedef struct {
 	unsigned short offset0;
 	unsigned short selector;
@@ -320,4 +324,6 @@ do {									\
 
 #define asm_safe_report_ex __asm_safe_report
 
-#endif
+
+#endif //#if !defined(__ASSEMBLY__) && !defined(__ASSEMBLER__)
+#endif //#ifndef _X86_DESC_H_
diff --git a/x86/cstart64.S b/x86/cstart64.S
index 4dff1102..c78d1a9f 100644
--- a/x86/cstart64.S
+++ b/x86/cstart64.S
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
2.34.1


