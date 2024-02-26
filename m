Return-Path: <kvm+bounces-9914-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 055958679F3
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 16:19:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EA5A0B316EE
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 14:56:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E010D145B2D;
	Mon, 26 Feb 2024 14:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SSH0Ggjj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4459145B0E;
	Mon, 26 Feb 2024 14:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708958252; cv=none; b=FT4R0EY/BbE32KDvjQsmrXMGFWNIbZvQOqPDrmQg9V9nZNk6xR2fH+vGm1EOIPvJueCqL9BW0z7s4+fRQPoiI4aTxVoHIqa7B4HG04+QK6BFWu5zNJMgRN2yrjTC8YRDKpeaODy9q+wKbDZuEjSWUaceX3s2SyBHcEZZKpy4nLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708958252; c=relaxed/simple;
	bh=DqsbfnlhZd45ReX+1hNDTDjtMxI2uW4PJFOcWdXla1Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QPpynbd6B4hxAfRT6PgaqB56GunSPpvo8mwXDHpeQg7xsSCDmqA/mGhCAXeLl0OJbrux+Fd22WoUAdJBQR33gn8SFN0SW3xOBlhliqGGHoD3QNjcbssjTDR25TZHkqwxtzX6CNk9LUaD6kBuQOV7tDR0iLGjKUIuwqoIJq71EEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SSH0Ggjj; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-6e4560664b5so2527321b3a.1;
        Mon, 26 Feb 2024 06:37:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708958250; x=1709563050; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2sxoFnLvmFsQ0Zs/11Gmenjh9ftrykz5AQVG07AFVn4=;
        b=SSH0Ggjj1gAJ0K3C3cVUZ/MrQ7nJska8H9LvDo1G2S9x3XJVd+Ooh3x8jF5DZNjzHJ
         dW98wKLLpYRaFFkOybPlNeuBdOF7ERKVOBdygNEbkuaREFuKNzA8heT8uq6Z4H8BLC85
         5y5/IBQZByH+OhMEx8F+9xTooPRen1JucYk3UiftjyVVvT0fFp03ZAIrQAY6a3MsdaD7
         p8ZKNhGpBWBP1rjCa/IodO9eWg8nBqNsD5oAjHJ0TwPpdYB+IOka3t/ym4X3cZYKw9UR
         IaWrMLXqVt6lCLrOoxfXjJj3j8mdNarDXrxxA1bToPPOhooiZq2TEltQWDx1CO8Rdk5w
         aNPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708958250; x=1709563050;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2sxoFnLvmFsQ0Zs/11Gmenjh9ftrykz5AQVG07AFVn4=;
        b=ZYJmkIlqZBANtWBS/PDCNBnTXDk78vedPXj5CfcQa2tMafsQJNLXfxqdzeS7I9Df3G
         FDMR3SaXlyMW1Ac9Qayyn1SrbNLz5JD1w1Xppq+Ji/doSYAZmPR3Nnr6LeFDs9p0e6ai
         zviZjNCoAs+aadBVRBIzWox35yupTEK5dFhbBx+IaXkLm9Wm6m2o7niWXrlYTW9rJIAC
         LgCQSYdQ6Fl3bQUeYz1MafAILuCRN+2WbjSuEKw+zyILI4zdpoFUfsCO2Lym+CS34dSB
         xkk7oJVYXK443oMw2/7ZsLZB/l8V0lTtlvHY+5UlMWZywWeyPFyiC3WL06QZE/9Ronz9
         OdcQ==
X-Forwarded-Encrypted: i=1; AJvYcCWR79IbYr2pjJa/0Oe9zAqR03Jm6WsTA5ImHIfTEVYeFjPB56ZlUmfD+M91Cm6qX0OEb2aLNcG7Asvm6BUckbngVdU/
X-Gm-Message-State: AOJu0YzszJ3afYmF6bBXxErFnMYFzVx8LCB8TfPJgYywSzOkH+/JUTUP
	EmdC4M0EP/0zrhR01KvfZGIyGCjCkjwR635EiR76IaFMq15ZThElsRjyi2sm
X-Google-Smtp-Source: AGHT+IFGXwmZyDUi2kJcasxtfmddqXmccTttN0JSJ6MO/Cez6VoWssGgCICDRL8xVQEgAJv43imG5A==
X-Received: by 2002:a05:6a20:e68f:b0:1a0:7f3f:8d5d with SMTP id mz15-20020a056a20e68f00b001a07f3f8d5dmr10062037pzb.39.1708958249812;
        Mon, 26 Feb 2024 06:37:29 -0800 (PST)
Received: from localhost ([47.88.5.130])
        by smtp.gmail.com with ESMTPSA id w13-20020aa7858d000000b006e488553f09sm4092298pfn.81.2024.02.26.06.37.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Feb 2024 06:37:29 -0800 (PST)
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
Subject: [RFC PATCH 51/73] x86/tools/relocs: Append relocations into input file
Date: Mon, 26 Feb 2024 22:36:08 +0800
Message-Id: <20240226143630.33643-52-jiangshanlai@gmail.com>
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

Add a command line option to append relocations into a reserved section
named ".data.reloc" section of the input file. This is the same as the
implementation in MIPS.

Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/tools/relocs.c        | 62 +++++++++++++++++++++++++++-------
 arch/x86/tools/relocs.h        |  1 +
 arch/x86/tools/relocs_common.c | 11 ++++--
 3 files changed, 60 insertions(+), 14 deletions(-)

diff --git a/arch/x86/tools/relocs.c b/arch/x86/tools/relocs.c
index 743e5e44338b..97e0243b9abb 100644
--- a/arch/x86/tools/relocs.c
+++ b/arch/x86/tools/relocs.c
@@ -912,6 +912,17 @@ static int is_percpu_sym(ElfW(Sym) *sym, const char *symname)
 		strncmp(symname, "init_per_cpu_", 13);
 }
 
+static struct section *sec_lookup(const char *name)
+{
+	int i;
+
+	for (i = 0; i < shnum; i++) {
+		if (!strcmp(sec_name(i), name))
+			return &secs[i];
+	}
+
+	return NULL;
+}
 
 static int do_reloc64(struct section *sec, Elf_Rel *rel, ElfW(Sym) *sym,
 		      const char *symname)
@@ -1164,12 +1175,13 @@ static int write32_as_text(uint32_t v, FILE *f)
 	return fprintf(f, "\t.long 0x%08"PRIx32"\n", v) > 0 ? 0 : -1;
 }
 
-static void emit_relocs(void)
+static void emit_relocs(FILE *f)
 {
 	int i;
 	int (*write_reloc)(uint32_t, FILE *) = write32;
 	int (*do_reloc)(struct section *sec, Elf_Rel *rel, Elf_Sym *sym,
 			const char *symname);
+	FILE *outf = stdout;
 
 #if ELF_BITS == 64
 	if (!opts.use_real_mode)
@@ -1208,37 +1220,63 @@ static void emit_relocs(void)
 		write_reloc = write32_as_text;
 	}
 
+#if ELF_BITS == 64
+	if (opts.keep_relocs) {
+		struct section *sec_reloc;
+		uint32_t size_needed;
+		unsigned long offset;
+
+		sec_reloc = sec_lookup(".data.reloc");
+		if (!sec_reloc)
+			die("Could not find relocation data section\n");
+
+		size_needed = (3 + relocs64.count + relocs32neg.count +
+			      relocs32.count) * sizeof(uint32_t);
+		if (size_needed > sec_reloc->shdr.sh_size)
+			die("Relocations overflow available space!\n" \
+			    "Please adjust CONFIG_RELOCATION_TABLE_SIZE" \
+			    "to at least 0x%08x\n", (size_needed + 0x1000) & ~0xFFF);
+
+		offset = sec_reloc->shdr.sh_offset + sec_reloc->shdr.sh_size -
+			 size_needed;
+		if (fseek(f, offset, SEEK_SET) < 0)
+			die("Seek to %ld failed: %s\n", offset, strerror(errno));
+
+		outf = f;
+	}
+#endif
+
 	if (opts.use_real_mode) {
-		write_reloc(relocs16.count, stdout);
+		write_reloc(relocs16.count, outf);
 		for (i = 0; i < relocs16.count; i++)
-			write_reloc(relocs16.offset[i], stdout);
+			write_reloc(relocs16.offset[i], outf);
 
-		write_reloc(relocs32.count, stdout);
+		write_reloc(relocs32.count, outf);
 		for (i = 0; i < relocs32.count; i++)
-			write_reloc(relocs32.offset[i], stdout);
+			write_reloc(relocs32.offset[i], outf);
 	} else {
 #if ELF_BITS == 64
 		/* Print a stop */
-		write_reloc(0, stdout);
+		write_reloc(0, outf);
 
 		/* Now print each relocation */
 		for (i = 0; i < relocs64.count; i++)
-			write_reloc(relocs64.offset[i], stdout);
+			write_reloc(relocs64.offset[i], outf);
 
 		/* Print a stop */
-		write_reloc(0, stdout);
+		write_reloc(0, outf);
 
 		/* Now print each inverse 32-bit relocation */
 		for (i = 0; i < relocs32neg.count; i++)
-			write_reloc(relocs32neg.offset[i], stdout);
+			write_reloc(relocs32neg.offset[i], outf);
 #endif
 
 		/* Print a stop */
-		write_reloc(0, stdout);
+		write_reloc(0, outf);
 
 		/* Now print each relocation */
 		for (i = 0; i < relocs32.count; i++)
-			write_reloc(relocs32.offset[i], stdout);
+			write_reloc(relocs32.offset[i], outf);
 	}
 }
 
@@ -1294,5 +1332,5 @@ void process(FILE *fp)
 		print_reloc_info();
 		return;
 	}
-	emit_relocs();
+	emit_relocs(fp);
 }
diff --git a/arch/x86/tools/relocs.h b/arch/x86/tools/relocs.h
index 1cb0e235ad73..20f729e4579f 100644
--- a/arch/x86/tools/relocs.h
+++ b/arch/x86/tools/relocs.h
@@ -37,6 +37,7 @@ struct opts {
 	bool show_absolute_syms;
 	bool show_absolute_relocs;
 	bool show_reloc_info;
+	bool keep_relocs;
 };
 
 extern struct opts opts;
diff --git a/arch/x86/tools/relocs_common.c b/arch/x86/tools/relocs_common.c
index 17d69baee0c3..87d94d9e4b97 100644
--- a/arch/x86/tools/relocs_common.c
+++ b/arch/x86/tools/relocs_common.c
@@ -14,7 +14,7 @@ void die(char *fmt, ...)
 
 static void usage(void)
 {
-	die("relocs [--abs-syms|--abs-relocs|--reloc-info|--text|--realmode]" \
+	die("relocs [--abs-syms|--abs-relocs|--reloc-info|--text|--realmode|--keep]" \
 	    " vmlinux\n");
 }
 
@@ -49,6 +49,10 @@ int main(int argc, char **argv)
 				opts.use_real_mode = true;
 				continue;
 			}
+			if (strcmp(arg, "--keep") == 0) {
+				opts.keep_relocs = true;
+				continue;
+			}
 		}
 		else if (!fname) {
 			fname = arg;
@@ -59,7 +63,10 @@ int main(int argc, char **argv)
 	if (!fname) {
 		usage();
 	}
-	fp = fopen(fname, "r");
+	if (opts.keep_relocs)
+		fp = fopen(fname, "r+");
+	else
+		fp = fopen(fname, "r");
 	if (!fp) {
 		die("Cannot open %s: %s\n", fname, strerror(errno));
 	}
-- 
2.19.1.6.gb485710b


