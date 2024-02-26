Return-Path: <kvm+bounces-9913-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EC5C5867928
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 15:55:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D8A8C1F2DC7E
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 14:55:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21AE9145359;
	Mon, 26 Feb 2024 14:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ix21bWJv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAD45145B0E;
	Mon, 26 Feb 2024 14:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708958246; cv=none; b=hNGFW77DOcvTzUUgFTNqEBNxxEfp1zc8lA21X29Pp4/XS+cAhHsw/czkUp4M///29urYH4pxHa72yzwKjWJ5vRXf9wrCbSA0ccxjgnADydksaMxlrpa8e4bGYXNoYaoKt8PltSWv/1vOMVdB03Oc29niYDIMfiSfYUOIG8/OKM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708958246; c=relaxed/simple;
	bh=dqCBbEmV/ZV8A16xi0OdKKYnGJMxg43dgKZF/SkcABw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fK/6Vh0GNrKeCKY0vO/dKcO8dn1V8fFP+up1QLh4/kIQlzBqFigmoMPBYB4nkk5LJDs+rrNXhv0nT+1WeboqPEFBnZUQZW2DvJ5XHctL/8k5uDGbaazEhdR6SPqavUTDwqsbbJt5lVDCQxWcLGA18/J+Yth8vdvRe8Xsl/s6vb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ix21bWJv; arc=none smtp.client-ip=209.85.161.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-5a0932aa9ecso390233eaf.3;
        Mon, 26 Feb 2024 06:37:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708958243; x=1709563043; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2ObDfmX3udGGUccUu3hcZNpHGnDogYqHkynq3vwZFUA=;
        b=Ix21bWJvGhsRoCwFDzngd6U456jeRk0imiJfCnYe7z1qfvJ1zLfUGWvCcRzU+SIMQ1
         bKN7YawYlEu91Asq+FVHbDrrIZmV96ScKDyCyUVWd951ZymcFslTc32hJWEAQP8Uhyk1
         4mwPfVK21wCB60anGBKtaNxdksWVWfD4ccBomByS7X5NdvvXIY0TiPZgPJ3/r87hOZQf
         xgVYKopcJ+L+MOsDJPV01Z6VlSpDjQCsP6oMxs6L+bOZAkEAmjpGyzTJFE1J4SQUoc3K
         3gUCgbUPXm44yzsPvMQ/5ZpHeKsY724psROH41GWMaK5vFPMKub0IbwiNUlfK/zLKidA
         ckaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708958243; x=1709563043;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2ObDfmX3udGGUccUu3hcZNpHGnDogYqHkynq3vwZFUA=;
        b=taRsOBUbZrPIGA3eXoGztE0eajD8B6UmN8UTJlje+Bn+qyu/M1wcO+zo6u9Nm/cg6n
         GDihOXs5zD/jImjlxzm+uDzB+khlYgvZ7FYMx4Ce03xCfxDaBUgWvnW/IF6fDHBVIXnh
         E8Tb+KrbZqVjfRyv9Hw2TwQS9tsv5+7H+nIwhZK+40AgWUMY5poh/njGUf0Q15bJr8kt
         KnOn/lzozZ4N+/89ZaCu4gQ7aN+d1z0DCneYonLkChf3Gx6RsD0rp6SZGVVWIJCKx8+N
         u3nYCEkztQ+3gn8dUWdygJVqVCv8flTisb78+a+F4xm17YaoBZBORU0jyQ0S+A/CO+Nl
         udWQ==
X-Forwarded-Encrypted: i=1; AJvYcCUK7HhCb/AKRWRircaVysBPXBwSEP26uOfyvq0hdcQknLcXBT8ruukyQ3sH+2T/4nAZD2//8K0Bn12ft0IijpL+gXYF
X-Gm-Message-State: AOJu0YzVBuzJNnbyk42kZoVksHn1XkAe4kjNhHbKrMZPhbAr0LPlrXPA
	WxZ8cQM0WTK2Y+Wy590tXdBc8OBAfoj8aAmDmmiv0f+0nAqbgIYDHehZJXH3
X-Google-Smtp-Source: AGHT+IHLN/SUYjzssbaEOh6SOBt5tP/VwGseuF8PdDF5OrypYo5qkGwk/tshDYpQEUenhcMGQma/mQ==
X-Received: by 2002:a05:6358:e483:b0:17b:b13e:5b31 with SMTP id by3-20020a056358e48300b0017bb13e5b31mr1130781rwb.6.1708958243486;
        Mon, 26 Feb 2024 06:37:23 -0800 (PST)
Received: from localhost ([47.254.32.37])
        by smtp.gmail.com with ESMTPSA id z25-20020a631919000000b005dc85821c80sm3976552pgl.12.2024.02.26.06.37.22
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Feb 2024 06:37:23 -0800 (PST)
From: Lai Jiangshan <jiangshanlai@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Hou Wenlong <houwenlong.hwl@antgroup.com>,
	Lai Jiangshan <jiangshan.ljs@antgroup.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@alien8.de>,
	Ingo Molnar <mingo@redhat.com>,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	x86@kernel.org,
	Kees Cook <keescook@chromium.org>,
	Juergen Gross <jgross@suse.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alexey Dobriyan <adobriyan@gmail.com>,
	Thomas Garnier <thgarnie@chromium.org>
Subject: [RFC PATCH 50/73] x86/tools/relocs: Cleanup cmdline options
Date: Mon, 26 Feb 2024 22:36:07 +0800
Message-Id: <20240226143630.33643-51-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20240226143630.33643-1-jiangshanlai@gmail.com>
References: <20240226143630.33643-1-jiangshanlai@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Hou Wenlong <houwenlong.hwl@antgroup.com>

Collect all cmdline options into a structure to make code
clean and to be easy to add new cmdline option.

Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/tools/relocs.c        | 30 ++++++++++++++----------------
 arch/x86/tools/relocs.h        | 19 +++++++++++++------
 arch/x86/tools/relocs_common.c | 27 +++++++++------------------
 3 files changed, 36 insertions(+), 40 deletions(-)

diff --git a/arch/x86/tools/relocs.c b/arch/x86/tools/relocs.c
index cf28a8f05375..743e5e44338b 100644
--- a/arch/x86/tools/relocs.c
+++ b/arch/x86/tools/relocs.c
@@ -125,13 +125,13 @@ static int is_reloc(enum symtype type, const char *sym_name)
 		!regexec(&sym_regex_c[type], sym_name, 0, NULL, 0);
 }
 
-static void regex_init(int use_real_mode)
+static void regex_init(void)
 {
         char errbuf[128];
         int err;
 	int i;
 
-	if (use_real_mode)
+	if (opts.use_real_mode)
 		sym_regex = sym_regex_realmode;
 	else
 		sym_regex = sym_regex_kernel;
@@ -1164,7 +1164,7 @@ static int write32_as_text(uint32_t v, FILE *f)
 	return fprintf(f, "\t.long 0x%08"PRIx32"\n", v) > 0 ? 0 : -1;
 }
 
-static void emit_relocs(int as_text, int use_real_mode)
+static void emit_relocs(void)
 {
 	int i;
 	int (*write_reloc)(uint32_t, FILE *) = write32;
@@ -1172,12 +1172,12 @@ static void emit_relocs(int as_text, int use_real_mode)
 			const char *symname);
 
 #if ELF_BITS == 64
-	if (!use_real_mode)
+	if (!opts.use_real_mode)
 		do_reloc = do_reloc64;
 	else
 		die("--realmode not valid for a 64-bit ELF file");
 #else
-	if (!use_real_mode)
+	if (!opts.use_real_mode)
 		do_reloc = do_reloc32;
 	else
 		do_reloc = do_reloc_real;
@@ -1186,7 +1186,7 @@ static void emit_relocs(int as_text, int use_real_mode)
 	/* Collect up the relocations */
 	walk_relocs(do_reloc);
 
-	if (relocs16.count && !use_real_mode)
+	if (relocs16.count && !opts.use_real_mode)
 		die("Segment relocations found but --realmode not specified\n");
 
 	/* Order the relocations for more efficient processing */
@@ -1199,7 +1199,7 @@ static void emit_relocs(int as_text, int use_real_mode)
 #endif
 
 	/* Print the relocations */
-	if (as_text) {
+	if (opts.as_text) {
 		/* Print the relocations in a form suitable that
 		 * gas will like.
 		 */
@@ -1208,7 +1208,7 @@ static void emit_relocs(int as_text, int use_real_mode)
 		write_reloc = write32_as_text;
 	}
 
-	if (use_real_mode) {
+	if (opts.use_real_mode) {
 		write_reloc(relocs16.count, stdout);
 		for (i = 0; i < relocs16.count; i++)
 			write_reloc(relocs16.offset[i], stdout);
@@ -1271,11 +1271,9 @@ static void print_reloc_info(void)
 # define process process_32
 #endif
 
-void process(FILE *fp, int use_real_mode, int as_text,
-	     int show_absolute_syms, int show_absolute_relocs,
-	     int show_reloc_info)
+void process(FILE *fp)
 {
-	regex_init(use_real_mode);
+	regex_init();
 	read_ehdr(fp);
 	read_shdrs(fp);
 	read_strtabs(fp);
@@ -1284,17 +1282,17 @@ void process(FILE *fp, int use_real_mode, int as_text,
 	read_got(fp);
 	if (ELF_BITS == 64)
 		percpu_init();
-	if (show_absolute_syms) {
+	if (opts.show_absolute_syms) {
 		print_absolute_symbols();
 		return;
 	}
-	if (show_absolute_relocs) {
+	if (opts.show_absolute_relocs) {
 		print_absolute_relocs();
 		return;
 	}
-	if (show_reloc_info) {
+	if (opts.show_reloc_info) {
 		print_reloc_info();
 		return;
 	}
-	emit_relocs(as_text, use_real_mode);
+	emit_relocs();
 }
diff --git a/arch/x86/tools/relocs.h b/arch/x86/tools/relocs.h
index 4c49c82446eb..1cb0e235ad73 100644
--- a/arch/x86/tools/relocs.h
+++ b/arch/x86/tools/relocs.h
@@ -6,6 +6,7 @@
 #include <stdarg.h>
 #include <stdlib.h>
 #include <stdint.h>
+#include <stdbool.h>
 #include <inttypes.h>
 #include <string.h>
 #include <errno.h>
@@ -30,10 +31,16 @@ enum symtype {
 	S_NSYMTYPES
 };
 
-void process_32(FILE *fp, int use_real_mode, int as_text,
-		int show_absolute_syms, int show_absolute_relocs,
-		int show_reloc_info);
-void process_64(FILE *fp, int use_real_mode, int as_text,
-		int show_absolute_syms, int show_absolute_relocs,
-		int show_reloc_info);
+struct opts {
+	bool use_real_mode;
+	bool as_text;
+	bool show_absolute_syms;
+	bool show_absolute_relocs;
+	bool show_reloc_info;
+};
+
+extern struct opts opts;
+
+void process_32(FILE *fp);
+void process_64(FILE *fp);
 #endif /* RELOCS_H */
diff --git a/arch/x86/tools/relocs_common.c b/arch/x86/tools/relocs_common.c
index 6634352a20bc..17d69baee0c3 100644
--- a/arch/x86/tools/relocs_common.c
+++ b/arch/x86/tools/relocs_common.c
@@ -1,6 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0
 #include "relocs.h"
 
+struct opts opts;
+
 void die(char *fmt, ...)
 {
 	va_list ap;
@@ -18,40 +20,33 @@ static void usage(void)
 
 int main(int argc, char **argv)
 {
-	int show_absolute_syms, show_absolute_relocs, show_reloc_info;
-	int as_text, use_real_mode;
 	const char *fname;
 	FILE *fp;
 	int i;
 	unsigned char e_ident[EI_NIDENT];
 
-	show_absolute_syms = 0;
-	show_absolute_relocs = 0;
-	show_reloc_info = 0;
-	as_text = 0;
-	use_real_mode = 0;
 	fname = NULL;
 	for (i = 1; i < argc; i++) {
 		char *arg = argv[i];
 		if (*arg == '-') {
 			if (strcmp(arg, "--abs-syms") == 0) {
-				show_absolute_syms = 1;
+				opts.show_absolute_syms = true;
 				continue;
 			}
 			if (strcmp(arg, "--abs-relocs") == 0) {
-				show_absolute_relocs = 1;
+				opts.show_absolute_relocs = true;
 				continue;
 			}
 			if (strcmp(arg, "--reloc-info") == 0) {
-				show_reloc_info = 1;
+				opts.show_reloc_info = true;
 				continue;
 			}
 			if (strcmp(arg, "--text") == 0) {
-				as_text = 1;
+				opts.as_text = true;
 				continue;
 			}
 			if (strcmp(arg, "--realmode") == 0) {
-				use_real_mode = 1;
+				opts.use_real_mode = true;
 				continue;
 			}
 		}
@@ -73,13 +68,9 @@ int main(int argc, char **argv)
 	}
 	rewind(fp);
 	if (e_ident[EI_CLASS] == ELFCLASS64)
-		process_64(fp, use_real_mode, as_text,
-			   show_absolute_syms, show_absolute_relocs,
-			   show_reloc_info);
+		process_64(fp);
 	else
-		process_32(fp, use_real_mode, as_text,
-			   show_absolute_syms, show_absolute_relocs,
-			   show_reloc_info);
+		process_32(fp);
 	fclose(fp);
 	return 0;
 }
-- 
2.19.1.6.gb485710b


