Return-Path: <kvm+bounces-41604-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 43CABA6B0C9
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 23:31:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 136474A21D9
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 22:30:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4A1022ACDB;
	Thu, 20 Mar 2025 22:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="STs37TQ4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E001B228CB8
	for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 22:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742509818; cv=none; b=uTyiIAxaNh/rSbIicIBn3JZbKyp7UlkrlPGF0CWSoB+i+IOF3gugf1hCSh/9y7DoG2yjHPrVOxVh2S8WbLlqf5o/KlKMh+rGsKn9nnOph6J0tFlJmHfSfQAoLOxeMPvreTaM0EcyZd/CGCMKyI0gJCVp9zJXjf/7l45JrRGzttE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742509818; c=relaxed/simple;
	bh=8032EpNxG6iAj8mji3XCprkzPyTYvtWM95QAJORZa4w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=AnWkL4ron0Mo80/qnKaW+AdkPC9xySHhjaOErPTUNv8WNLLXpkjz2E1eHqdDUBAAozx1EKJzPeT2BWnA2XJqveAG7PXxze42xpmCccCTm/EEbcdeZXlZOmMLKi032G2EgkoINQB8WqhFv3bax8L0XZxP8mKPjtFpNJolh2GiCIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=STs37TQ4; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-224019ad9edso32560825ad.1
        for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 15:30:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742509815; x=1743114615; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EUQWJa8M2i9P17T56WC7L1ajUU3UpMhiv0rwi6K2NYA=;
        b=STs37TQ4hS/sTLR9F8zTxAIQQ5g/u1QMEHD351LTXegV+312/26R8AnTq3aHaxkc1l
         j4/rPXCANBAjKPNVV0aQT1qFmG+TMAmYDXVmv/UGpBb+Es1fs0FSnJJBPiN8hJjguMfB
         7Qvz7FRmWKD0PTKGcytX/ONMp8UU2coQcPyCMIU5zsJZQEn8rsymIZbKR75MZ4Xg6DX+
         gnhOOVw9wxToHfC1rSwAHZfSgPdZw5Eq/22yNZSrWIkmlflz9/AGhuGVf4K2BvecfapX
         grPKQ3WJKLtEER8TQaqtHvIcj9m2b2p4qpe2LG3R52pjNSM8rNnlwaLsGf5ERXKwoZVN
         tUfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742509815; x=1743114615;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EUQWJa8M2i9P17T56WC7L1ajUU3UpMhiv0rwi6K2NYA=;
        b=BXfZzyjkiGDoyTd6ztzoFVLB9xSu3kOpjaf9qyWkXD5bQtEk/D/btmyyInmmQ0zg86
         jBem/IA+xDgbtw8m+XJR1G82grgAuEun5Fq0oC7O/4/Au3HkvMqO9h141b0Levyvv6UA
         1buSL0JXY+xqbT5P8xqTrRZ10LwaUBa1X8+YcSkGrVsb6+eWe0HRmhp+VeBcwq/zDFC5
         NB/E7NZOZY3P25+InabMVYFVSNoVBcd69/lHbs5kwFFx0pi6NmGb6QUXKe4N9CFl32V/
         KPxFiIVbRjfF9THITp5lw6yDXwbN4HNcrgskbLMqjziU+baEJ0g5dLwt6bD2uDUgLHNB
         q5lA==
X-Gm-Message-State: AOJu0YzibG3e6aY3qnpabccxloqJkeQgm68mu+70/aKg3CBXBWqZYhJJ
	tVFsl9u+hIwpgpvBKLmUpndbN6V/Klr8ag2XEgKQI10wzTBoDg0en7DNGd/LhAE=
X-Gm-Gg: ASbGncsFlulNzDjrlcaK0j4xChTbWN1Y2hNB3Wg8x30XDQJEPUJshjo2WkA/1kFhPc8
	wqQNISd3J8THZ1IIJqH0cga2c828gUNqi/fZ4ar4IX0cr4sNT1bYxZuDV8D/un07l+Mv6pj344X
	yE2brvan6yrrkWlFgzutKaqDBMP50TKimtkHEd4Z3EwEGocDGudM+0iwgCK0XxPXt0+VQp7hMnT
	WFo3O1FtLSzG1Pac91VsCHuTjdINANgf/4+pHGYmtzXEFBS6/li/tbvwtU7F/cKI10gkZr/xR4/
	TB8sjrrn9YiWFkpee0zMUVQfroKcNrfyyNScCHgG2wiK
X-Google-Smtp-Source: AGHT+IH6ZvqlVmR/vgYitM0gTW8xnrCBbOkByuhosGlG4c0RqGsCkRYzWH0d/KpBtFj4JuB9Fwyv6A==
X-Received: by 2002:a17:902:f20c:b0:224:256e:5e3f with SMTP id d9443c01a7336-22780d8370amr16464875ad.25.1742509815082;
        Thu, 20 Mar 2025 15:30:15 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22780f4581csm3370145ad.59.2025.03.20.15.30.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Mar 2025 15:30:11 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org,
	qemu-arm@nongnu.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v2 01/30] exec/cpu-all: remove BSWAP_NEEDED
Date: Thu, 20 Mar 2025 15:29:33 -0700
Message-Id: <20250320223002.2915728-2-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250320223002.2915728-1-pierrick.bouvier@linaro.org>
References: <20250320223002.2915728-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This identifier is poisoned, so it can't be used from common code
anyway. We replace all occurrences with its definition directly.

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 include/exec/cpu-all.h    | 12 ------------
 linux-user/syscall_defs.h |  2 +-
 bsd-user/elfload.c        |  6 +++---
 hw/ppc/mac_newworld.c     |  4 +---
 hw/ppc/mac_oldworld.c     |  4 +---
 hw/sparc/sun4m.c          |  6 +-----
 hw/sparc64/sun4u.c        |  6 +-----
 linux-user/elfload.c      |  8 ++++----
 8 files changed, 12 insertions(+), 36 deletions(-)

diff --git a/include/exec/cpu-all.h b/include/exec/cpu-all.h
index 981a08e3bb3..013fcc9412a 100644
--- a/include/exec/cpu-all.h
+++ b/include/exec/cpu-all.h
@@ -28,18 +28,6 @@
 #include "system/memory.h"
 #endif
 
-/* some important defines:
- *
- * HOST_BIG_ENDIAN : whether the host cpu is big endian and
- * otherwise little endian.
- *
- * TARGET_BIG_ENDIAN : same for the target cpu
- */
-
-#if HOST_BIG_ENDIAN != TARGET_BIG_ENDIAN
-#define BSWAP_NEEDED
-#endif
-
 /* page related stuff */
 #include "exec/cpu-defs.h"
 #include "exec/target_page.h"
diff --git a/linux-user/syscall_defs.h b/linux-user/syscall_defs.h
index 86d773add75..5d227599924 100644
--- a/linux-user/syscall_defs.h
+++ b/linux-user/syscall_defs.h
@@ -462,7 +462,7 @@ typedef struct {
     abi_ulong sig[TARGET_NSIG_WORDS];
 } target_sigset_t;
 
-#ifdef BSWAP_NEEDED
+#if HOST_BIG_ENDIAN != TARGET_BIG_ENDIAN
 static inline void tswap_sigset(target_sigset_t *d, const target_sigset_t *s)
 {
     int i;
diff --git a/bsd-user/elfload.c b/bsd-user/elfload.c
index 833fa3bd057..3bca0cc9ede 100644
--- a/bsd-user/elfload.c
+++ b/bsd-user/elfload.c
@@ -44,7 +44,7 @@ static inline void memcpy_fromfs(void *to, const void *from, unsigned long n)
     memcpy(to, from, n);
 }
 
-#ifdef BSWAP_NEEDED
+#if HOST_BIG_ENDIAN != TARGET_BIG_ENDIAN
 static void bswap_ehdr(struct elfhdr *ehdr)
 {
     bswap16s(&ehdr->e_type);            /* Object file type */
@@ -111,7 +111,7 @@ static void bswap_note(struct elf_note *en)
     bswap32s(&en->n_type);
 }
 
-#else /* ! BSWAP_NEEDED */
+#else
 
 static void bswap_ehdr(struct elfhdr *ehdr) { }
 static void bswap_phdr(struct elf_phdr *phdr, int phnum) { }
@@ -119,7 +119,7 @@ static void bswap_shdr(struct elf_shdr *shdr, int shnum) { }
 static void bswap_sym(struct elf_sym *sym) { }
 static void bswap_note(struct elf_note *en) { }
 
-#endif /* ! BSWAP_NEEDED */
+#endif /* HOST_BIG_ENDIAN != TARGET_BIG_ENDIAN */
 
 #include "elfcore.c"
 
diff --git a/hw/ppc/mac_newworld.c b/hw/ppc/mac_newworld.c
index cb3dc3ab482..624c2731a65 100644
--- a/hw/ppc/mac_newworld.c
+++ b/hw/ppc/mac_newworld.c
@@ -199,9 +199,7 @@ static void ppc_core99_init(MachineState *machine)
     if (machine->kernel_filename) {
         int bswap_needed = 0;
 
-#ifdef BSWAP_NEEDED
-        bswap_needed = 1;
-#endif
+        bswap_needed = HOST_BIG_ENDIAN != TARGET_BIG_ENDIAN;
         kernel_base = KERNEL_LOAD_ADDR;
         kernel_size = load_elf(machine->kernel_filename, NULL,
                                translate_kernel_address, NULL, NULL, NULL,
diff --git a/hw/ppc/mac_oldworld.c b/hw/ppc/mac_oldworld.c
index 0dbcea035c3..439953fc29e 100644
--- a/hw/ppc/mac_oldworld.c
+++ b/hw/ppc/mac_oldworld.c
@@ -155,9 +155,7 @@ static void ppc_heathrow_init(MachineState *machine)
     if (machine->kernel_filename) {
         int bswap_needed = 0;
 
-#ifdef BSWAP_NEEDED
-        bswap_needed = 1;
-#endif
+        bswap_needed = HOST_BIG_ENDIAN != TARGET_BIG_ENDIAN;
         kernel_base = KERNEL_LOAD_ADDR;
         kernel_size = load_elf(machine->kernel_filename, NULL,
                                translate_kernel_address, NULL, NULL, NULL,
diff --git a/hw/sparc/sun4m.c b/hw/sparc/sun4m.c
index a48d3622c5a..d27a9b693a5 100644
--- a/hw/sparc/sun4m.c
+++ b/hw/sparc/sun4m.c
@@ -235,11 +235,7 @@ static unsigned long sun4m_load_kernel(const char *kernel_filename,
     if (linux_boot) {
         int bswap_needed;
 
-#ifdef BSWAP_NEEDED
-        bswap_needed = 1;
-#else
-        bswap_needed = 0;
-#endif
+        bswap_needed = HOST_BIG_ENDIAN != TARGET_BIG_ENDIAN;
         kernel_size = load_elf(kernel_filename, NULL,
                                translate_kernel_address, NULL,
                                NULL, NULL, NULL, NULL,
diff --git a/hw/sparc64/sun4u.c b/hw/sparc64/sun4u.c
index 8ab5cf0461f..c7bccf584e6 100644
--- a/hw/sparc64/sun4u.c
+++ b/hw/sparc64/sun4u.c
@@ -170,11 +170,7 @@ static uint64_t sun4u_load_kernel(const char *kernel_filename,
     if (linux_boot) {
         int bswap_needed;
 
-#ifdef BSWAP_NEEDED
-        bswap_needed = 1;
-#else
-        bswap_needed = 0;
-#endif
+        bswap_needed = HOST_BIG_ENDIAN != TARGET_BIG_ENDIAN;
         kernel_size = load_elf(kernel_filename, NULL, NULL, NULL, kernel_entry,
                                kernel_addr, &kernel_top, NULL,
                                ELFDATA2MSB, EM_SPARCV9, 0, 0);
diff --git a/linux-user/elfload.c b/linux-user/elfload.c
index f54054dce3d..99811af5e7b 100644
--- a/linux-user/elfload.c
+++ b/linux-user/elfload.c
@@ -2122,7 +2122,7 @@ static inline void memcpy_fromfs(void * to, const void * from, unsigned long n)
     memcpy(to, from, n);
 }
 
-#ifdef BSWAP_NEEDED
+#if HOST_BIG_ENDIAN != TARGET_BIG_ENDIAN
 static void bswap_ehdr(struct elfhdr *ehdr)
 {
     bswap16s(&ehdr->e_type);            /* Object file type */
@@ -3144,7 +3144,7 @@ static bool parse_elf_properties(const ImageSource *src,
      * The contents of a valid PT_GNU_PROPERTY is a sequence of uint32_t.
      * Swap most of them now, beyond the header and namesz.
      */
-#ifdef BSWAP_NEEDED
+#if HOST_BIG_ENDIAN != TARGET_BIG_ENDIAN
     for (int i = 4; i < n / 4; i++) {
         bswap32s(note.data + i);
     }
@@ -4000,7 +4000,7 @@ struct target_elf_prpsinfo {
     char    pr_psargs[ELF_PRARGSZ]; /* initial part of arg list */
 };
 
-#ifdef BSWAP_NEEDED
+#if HOST_BIG_ENDIAN != TARGET_BIG_ENDIAN
 static void bswap_prstatus(struct target_elf_prstatus *prstatus)
 {
     prstatus->pr_info.si_signo = tswap32(prstatus->pr_info.si_signo);
@@ -4039,7 +4039,7 @@ static void bswap_note(struct elf_note *en)
 static inline void bswap_prstatus(struct target_elf_prstatus *p) { }
 static inline void bswap_psinfo(struct target_elf_prpsinfo *p) {}
 static inline void bswap_note(struct elf_note *en) { }
-#endif /* BSWAP_NEEDED */
+#endif /* HOST_BIG_ENDIAN != TARGET_BIG_ENDIAN */
 
 /*
  * Calculate file (dump) size of given memory region.
-- 
2.39.5


