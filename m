Return-Path: <kvm+bounces-70795-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ACzUE0ySi2kmWQAAu9opvQ
	(envelope-from <kvm+bounces-70795-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 21:17:16 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id BB09C11EF8E
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 21:17:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 6391B3079A64
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 20:16:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A677E3346A5;
	Tue, 10 Feb 2026 20:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="kUQM276h"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4057333859A
	for <kvm@vger.kernel.org>; Tue, 10 Feb 2026 20:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770754557; cv=none; b=gjTSECoSiR78EdyvY5z0nmUdaGmh0rxoslJh8knd3e93Iszbww/GZdAjYelFk+Beigl0cTZyNB1u8gGVv0ngC5DM3JDi6nYal2+ie9CFCYZAE7/pNOaSn+JL9MDrAjSS0jSG0n3Y8joPIw2NqvAlixF2qC6SGUtnGwGi9uDjdKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770754557; c=relaxed/simple;
	bh=hLmmGwPJErDU169HPk9U+NztJtVsS6d8KgPeaB+zPPA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=svY0fzqrmlrZmsGxh768uOeXY5JTWEhEK+kHx1iKIEiVcrv8QMzJx5O5t5/e05sKKjwbbvGPl6Ap3xHLskV/pOzhnopgR3czFQPoAoOpszcDTh7Ch4oIeDM71qwl8plZ5dFWZd3jhy4zS+vqbYNp0wMGnCSLV7gfFx/xbicgVn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=kUQM276h; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2a102494058so965015ad.0
        for <kvm@vger.kernel.org>; Tue, 10 Feb 2026 12:15:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1770754555; x=1771359355; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iUFL9nxPB9bUeP42+0V7hNRdWE9EqDSh0B0IVvPLqNg=;
        b=kUQM276hBPH6SwBRlRbJEpuG9z2/f4PmMfuJ1U6aq9MhBakw/kh9vDGBBl2z8VW4zq
         Y719A3Hq68i1+T4AIYN1qvu4bNuIDMoHPB3HObAjm22SK+qTBlpwPKzwX7rsKvTb1AIX
         zcbiEYXWacH3rT95u88rByBsltrLB43ugjKjyZ9ca2mUtqRTqjxqNtdtNI7V9VkjN+UL
         Sz/lH3+eanOcDhHyRbPjH9CwekaqzmTDNX16T+n08x06h6wmIRV5SBkoIpo0FwlouP2M
         iWrAnzDMcGq4ljzYV5WV4RS1ofSVpFWQDF13Fz1GMp9VWklcMe3NynRKU/ySg+pMzIrX
         KdQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770754555; x=1771359355;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=iUFL9nxPB9bUeP42+0V7hNRdWE9EqDSh0B0IVvPLqNg=;
        b=dhXdKhkWKnhzuyQ1XHvXE7oQxPQfcfRsk8zTEjiF+DLt7aOOTD1N3EaKQ5yh4ECkLK
         sbLPZ/4R8oav7VOccMTwUBfw74UcGJz6DWDA22hx0j8RIjI3sELt83xWDxHHQxSRfuUh
         UUeZAOKMPEDtnmmKQF7hVO7nJx65KmSh9Rp4NMA45jaTPPPoOrvR/Om+7JzwUoQi0Msv
         yQoEnpxWHX+oSOSH89ND5CY6J/aG44SS13fks5PAZf6T6UK2lDFd1taONYbrQgavfTLE
         WfioLnxNg8zuFyw3n1CKSFh18nowNTdHMcqiA7dxi4RTzGitPAGNrJC9HWaP/Ujn8AvT
         oBVw==
X-Forwarded-Encrypted: i=1; AJvYcCUsl0m8MVcgBHyw04hnFnElI4NrCxBwz3/agw5HuP+LWxUu76ba9dlW6sI5iKca41d/uCc=@vger.kernel.org
X-Gm-Message-State: AOJu0YynAAKHuTz+trlMHqw4ZyEHUIFu1AiLmAbqA+qc9blL0pHLZiSI
	aI5JfVjmXwdPpmDh/64zIpEbSlrOoYD5UphC0EI50SDCO8GeFA5jyKeCr6Tq2RmdCUw=
X-Gm-Gg: AZuq6aJ+KvN9xrs9sY5yKzBC49tjdbbHKxP6XiXky2q2cXUD3Fk9u4sJjV92FIgs9Cr
	/RTC1cIZ3v0dLgl04OmJ9h8Sp7dj8v2qkdqB36njazlCfjfezgl/GrJdM3BmL0foXe2gjpgUVdT
	0m7NA/SV0RtjbatKg0mYey/Nnf7Ppqu3Zgom2LiHEg7l7mp/7iN+0L2K9YaZ9gwq2+dlVyXev3R
	XSkczI8BcubMfXoodS+eAE1PfXwT801TJPGWhoXHDs/kcsHxE/mrfKecVshefidxONK70fJyRpv
	JdN8AKsrFrv+gL25uQOrZuS0+WpUajDHqn9seQNhU+3FejZ6ayAjNu7FRd2I9Psy0bhV+bwZApK
	gdQhypnUeV5QSj3zbR+sOo/qdUSAKoGYqZG8u3oH8AI8YqXEbDGbISzE2cwBu2zWhkI9D1HBrHh
	UmiuASS363dd6uK7vRxISERC7k2yZ4lqmBX19SEqAO/MfJvmdX+YQL+flzjaaNus9+4GuoBiVRW
	+rC
X-Received: by 2002:a17:903:2c0d:b0:2aa:e1f0:5481 with SMTP id d9443c01a7336-2ab0feb8d59mr32910465ad.30.1770754555306;
        Tue, 10 Feb 2026 12:15:55 -0800 (PST)
Received: from pc.taild8403c.ts.net (216-71-219-44.dyn.novuscom.net. [216.71.219.44])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ab0b392cb5sm38523225ad.70.2026.02.10.12.15.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Feb 2026 12:15:54 -0800 (PST)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: anjo@rev.ng,
	Jim MacArthur <jim.macarthur@linaro.org>,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	qemu-arm@nongnu.org,
	Richard Henderson <richard.henderson@linaro.org>
Subject: [PATCH v3 12/12] include/tcg/tcg-op.h: eradicate TARGET_INSN_START_EXTRA_WORDS
Date: Tue, 10 Feb 2026 12:15:40 -0800
Message-ID: <20260210201540.1405424-13-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260210201540.1405424-1-pierrick.bouvier@linaro.org>
References: <20260210201540.1405424-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[linaro.org,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[linaro.org:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70795-lists,kvm=lfdr.de];
	RCVD_COUNT_FIVE(0.00)[5];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pierrick.bouvier@linaro.org,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[11];
	DKIM_TRACE(0.00)[linaro.org:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,linaro.org:mid,linaro.org:dkim,linaro.org:email]
X-Rspamd-Queue-Id: BB09C11EF8E
X-Rspamd-Action: no action

This commit removes TARGET_INSN_START_EXTRA_WORDS and force all arch to
call the same version of tcg_gen_insn_start, with additional 0 arguments
if needed. Since all arch have a single call site (in translate.c), this
is as good documentation as having a single define.

The notable exception is target/arm, which has two different translate
files for 32/64 bits. Since it's the only one, we accept to have two
call sites for this.

As well, we update parameter type to use uint64_t instead of
target_ulong, so it can be called from common code.

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 include/tcg/tcg-op-common.h      |  8 ++++++++
 include/tcg/tcg-op.h             | 29 -----------------------------
 target/alpha/cpu-param.h         |  2 --
 target/arm/cpu-param.h           |  7 -------
 target/avr/cpu-param.h           |  2 --
 target/hexagon/cpu-param.h       |  2 --
 target/hppa/cpu-param.h          |  2 --
 target/i386/cpu-param.h          |  2 --
 target/loongarch/cpu-param.h     |  2 --
 target/m68k/cpu-param.h          |  2 --
 target/microblaze/cpu-param.h    |  2 --
 target/mips/cpu-param.h          |  2 --
 target/or1k/cpu-param.h          |  2 --
 target/ppc/cpu-param.h           |  2 --
 target/riscv/cpu-param.h         |  7 -------
 target/rx/cpu-param.h            |  2 --
 target/s390x/cpu-param.h         |  2 --
 target/sh4/cpu-param.h           |  2 --
 target/sparc/cpu-param.h         |  2 --
 target/tricore/cpu-param.h       |  2 --
 target/xtensa/cpu-param.h        |  2 --
 target/alpha/translate.c         |  4 ++--
 target/avr/translate.c           |  2 +-
 target/hexagon/translate.c       |  2 +-
 target/i386/tcg/translate.c      |  2 +-
 target/loongarch/tcg/translate.c |  2 +-
 target/m68k/translate.c          |  2 +-
 target/microblaze/translate.c    |  2 +-
 target/or1k/translate.c          |  2 +-
 target/ppc/translate.c           |  2 +-
 target/rx/translate.c            |  2 +-
 target/sh4/translate.c           |  4 ++--
 target/sparc/translate.c         |  2 +-
 target/tricore/translate.c       |  2 +-
 target/xtensa/translate.c        |  2 +-
 35 files changed, 24 insertions(+), 93 deletions(-)

diff --git a/include/tcg/tcg-op-common.h b/include/tcg/tcg-op-common.h
index f752ef440b2..e02f209c093 100644
--- a/include/tcg/tcg-op-common.h
+++ b/include/tcg/tcg-op-common.h
@@ -30,6 +30,14 @@ TCGv_i64 tcg_global_mem_new_i64(TCGv_ptr reg, intptr_t off, const char *name);
 TCGv_ptr tcg_global_mem_new_ptr(TCGv_ptr reg, intptr_t off, const char *name);
 
 /* Generic ops.  */
+static inline void tcg_gen_insn_start(uint64_t pc, uint64_t a1,
+                                      uint64_t a2)
+{
+    TCGOp *op = tcg_emit_op(INDEX_op_insn_start, INSN_START_WORDS);
+    tcg_set_insn_start_param(op, 0, pc);
+    tcg_set_insn_start_param(op, 1, a1);
+    tcg_set_insn_start_param(op, 2, a2);
+}
 
 void gen_set_label(TCGLabel *l);
 void tcg_gen_br(TCGLabel *l);
diff --git a/include/tcg/tcg-op.h b/include/tcg/tcg-op.h
index ee379994e76..7024be938e6 100644
--- a/include/tcg/tcg-op.h
+++ b/include/tcg/tcg-op.h
@@ -28,35 +28,6 @@
 # error Mismatch with insn-start-words.h
 #endif
 
-#if TARGET_INSN_START_EXTRA_WORDS == 0
-static inline void tcg_gen_insn_start(target_ulong pc)
-{
-    TCGOp *op = tcg_emit_op(INDEX_op_insn_start, INSN_START_WORDS);
-    tcg_set_insn_start_param(op, 0, pc);
-    tcg_set_insn_start_param(op, 1, 0);
-    tcg_set_insn_start_param(op, 2, 0);
-}
-#elif TARGET_INSN_START_EXTRA_WORDS == 1
-static inline void tcg_gen_insn_start(target_ulong pc, target_ulong a1)
-{
-    TCGOp *op = tcg_emit_op(INDEX_op_insn_start, INSN_START_WORDS);
-    tcg_set_insn_start_param(op, 0, pc);
-    tcg_set_insn_start_param(op, 1, a1);
-    tcg_set_insn_start_param(op, 2, 0);
-}
-#elif TARGET_INSN_START_EXTRA_WORDS == 2
-static inline void tcg_gen_insn_start(target_ulong pc, target_ulong a1,
-                                      target_ulong a2)
-{
-    TCGOp *op = tcg_emit_op(INDEX_op_insn_start, INSN_START_WORDS);
-    tcg_set_insn_start_param(op, 0, pc);
-    tcg_set_insn_start_param(op, 1, a1);
-    tcg_set_insn_start_param(op, 2, a2);
-}
-#else
-#error Unhandled TARGET_INSN_START_EXTRA_WORDS value
-#endif
-
 #if TARGET_LONG_BITS == 32
 typedef TCGv_i32 TCGv;
 #define tcg_temp_new() tcg_temp_new_i32()
diff --git a/target/alpha/cpu-param.h b/target/alpha/cpu-param.h
index a799f42db31..c9da620ab3e 100644
--- a/target/alpha/cpu-param.h
+++ b/target/alpha/cpu-param.h
@@ -24,6 +24,4 @@
 # define TARGET_VIRT_ADDR_SPACE_BITS  (30 + TARGET_PAGE_BITS)
 #endif
 
-#define TARGET_INSN_START_EXTRA_WORDS 0
-
 #endif
diff --git a/target/arm/cpu-param.h b/target/arm/cpu-param.h
index 8b46c7c5708..7de0099cbfa 100644
--- a/target/arm/cpu-param.h
+++ b/target/arm/cpu-param.h
@@ -32,11 +32,4 @@
 # define TARGET_PAGE_BITS_LEGACY 10
 #endif /* !CONFIG_USER_ONLY */
 
-/*
- * ARM-specific extra insn start words:
- * 1: Conditional execution bits
- * 2: Partial exception syndrome for data aborts
- */
-#define TARGET_INSN_START_EXTRA_WORDS 2
-
 #endif
diff --git a/target/avr/cpu-param.h b/target/avr/cpu-param.h
index f74bfc25804..ea7887919a7 100644
--- a/target/avr/cpu-param.h
+++ b/target/avr/cpu-param.h
@@ -25,6 +25,4 @@
 #define TARGET_PHYS_ADDR_SPACE_BITS 24
 #define TARGET_VIRT_ADDR_SPACE_BITS 24
 
-#define TARGET_INSN_START_EXTRA_WORDS 0
-
 #endif
diff --git a/target/hexagon/cpu-param.h b/target/hexagon/cpu-param.h
index 635d509e743..45ee7b46409 100644
--- a/target/hexagon/cpu-param.h
+++ b/target/hexagon/cpu-param.h
@@ -23,6 +23,4 @@
 #define TARGET_PHYS_ADDR_SPACE_BITS 36
 #define TARGET_VIRT_ADDR_SPACE_BITS 32
 
-#define TARGET_INSN_START_EXTRA_WORDS 0
-
 #endif
diff --git a/target/hppa/cpu-param.h b/target/hppa/cpu-param.h
index 9bf7ac76d0c..e0b2c7c9157 100644
--- a/target/hppa/cpu-param.h
+++ b/target/hppa/cpu-param.h
@@ -19,6 +19,4 @@
 
 #define TARGET_PAGE_BITS 12
 
-#define TARGET_INSN_START_EXTRA_WORDS 2
-
 #endif
diff --git a/target/i386/cpu-param.h b/target/i386/cpu-param.h
index ebb844bcc83..909bc027923 100644
--- a/target/i386/cpu-param.h
+++ b/target/i386/cpu-param.h
@@ -22,6 +22,4 @@
 #endif
 #define TARGET_PAGE_BITS 12
 
-#define TARGET_INSN_START_EXTRA_WORDS 1
-
 #endif
diff --git a/target/loongarch/cpu-param.h b/target/loongarch/cpu-param.h
index 58cc45a377e..071567712b3 100644
--- a/target/loongarch/cpu-param.h
+++ b/target/loongarch/cpu-param.h
@@ -13,6 +13,4 @@
 
 #define TARGET_PAGE_BITS 12
 
-#define TARGET_INSN_START_EXTRA_WORDS 0
-
 #endif
diff --git a/target/m68k/cpu-param.h b/target/m68k/cpu-param.h
index 256a2b5f8b2..7afbf6d302d 100644
--- a/target/m68k/cpu-param.h
+++ b/target/m68k/cpu-param.h
@@ -17,6 +17,4 @@
 #define TARGET_PHYS_ADDR_SPACE_BITS 32
 #define TARGET_VIRT_ADDR_SPACE_BITS 32
 
-#define TARGET_INSN_START_EXTRA_WORDS 1
-
 #endif
diff --git a/target/microblaze/cpu-param.h b/target/microblaze/cpu-param.h
index e0a37945136..6a0714bb3d7 100644
--- a/target/microblaze/cpu-param.h
+++ b/target/microblaze/cpu-param.h
@@ -27,6 +27,4 @@
 /* FIXME: MB uses variable pages down to 1K but linux only uses 4k.  */
 #define TARGET_PAGE_BITS 12
 
-#define TARGET_INSN_START_EXTRA_WORDS 1
-
 #endif
diff --git a/target/mips/cpu-param.h b/target/mips/cpu-param.h
index 58f450827f7..a71e7383d24 100644
--- a/target/mips/cpu-param.h
+++ b/target/mips/cpu-param.h
@@ -20,6 +20,4 @@
 #endif
 #define TARGET_PAGE_BITS 12
 
-#define TARGET_INSN_START_EXTRA_WORDS 2
-
 #endif
diff --git a/target/or1k/cpu-param.h b/target/or1k/cpu-param.h
index b4f57bbe692..3011bf5fcca 100644
--- a/target/or1k/cpu-param.h
+++ b/target/or1k/cpu-param.h
@@ -12,6 +12,4 @@
 #define TARGET_PHYS_ADDR_SPACE_BITS 32
 #define TARGET_VIRT_ADDR_SPACE_BITS 32
 
-#define TARGET_INSN_START_EXTRA_WORDS 1
-
 #endif
diff --git a/target/ppc/cpu-param.h b/target/ppc/cpu-param.h
index e4ed9080ee9..ca7602d8983 100644
--- a/target/ppc/cpu-param.h
+++ b/target/ppc/cpu-param.h
@@ -37,6 +37,4 @@
 # define TARGET_PAGE_BITS 12
 #endif
 
-#define TARGET_INSN_START_EXTRA_WORDS 0
-
 #endif
diff --git a/target/riscv/cpu-param.h b/target/riscv/cpu-param.h
index cfdc67c258c..039e877891a 100644
--- a/target/riscv/cpu-param.h
+++ b/target/riscv/cpu-param.h
@@ -17,13 +17,6 @@
 #endif
 #define TARGET_PAGE_BITS 12 /* 4 KiB Pages */
 
-/*
- * RISC-V-specific extra insn start words:
- * 1: Original instruction opcode
- * 2: more information about instruction
- */
-#define TARGET_INSN_START_EXTRA_WORDS 2
-
 /*
  * The current MMU Modes are:
  *  - U mode 0b000
diff --git a/target/rx/cpu-param.h b/target/rx/cpu-param.h
index 84934f3bcaf..ef1970a09e9 100644
--- a/target/rx/cpu-param.h
+++ b/target/rx/cpu-param.h
@@ -24,6 +24,4 @@
 #define TARGET_PHYS_ADDR_SPACE_BITS 32
 #define TARGET_VIRT_ADDR_SPACE_BITS 32
 
-#define TARGET_INSN_START_EXTRA_WORDS 0
-
 #endif
diff --git a/target/s390x/cpu-param.h b/target/s390x/cpu-param.h
index abfae3bedfb..a5f798eeae7 100644
--- a/target/s390x/cpu-param.h
+++ b/target/s390x/cpu-param.h
@@ -12,6 +12,4 @@
 #define TARGET_PHYS_ADDR_SPACE_BITS 64
 #define TARGET_VIRT_ADDR_SPACE_BITS 64
 
-#define TARGET_INSN_START_EXTRA_WORDS 2
-
 #endif
diff --git a/target/sh4/cpu-param.h b/target/sh4/cpu-param.h
index f328715ee86..2b6e11dd0ac 100644
--- a/target/sh4/cpu-param.h
+++ b/target/sh4/cpu-param.h
@@ -16,6 +16,4 @@
 # define TARGET_VIRT_ADDR_SPACE_BITS 32
 #endif
 
-#define TARGET_INSN_START_EXTRA_WORDS 1
-
 #endif
diff --git a/target/sparc/cpu-param.h b/target/sparc/cpu-param.h
index 45eea9d6bac..6e8e2a51469 100644
--- a/target/sparc/cpu-param.h
+++ b/target/sparc/cpu-param.h
@@ -21,6 +21,4 @@
 # define TARGET_VIRT_ADDR_SPACE_BITS 32
 #endif
 
-#define TARGET_INSN_START_EXTRA_WORDS 1
-
 #endif
diff --git a/target/tricore/cpu-param.h b/target/tricore/cpu-param.h
index eb33a67c419..790242ef3d2 100644
--- a/target/tricore/cpu-param.h
+++ b/target/tricore/cpu-param.h
@@ -12,6 +12,4 @@
 #define TARGET_PHYS_ADDR_SPACE_BITS 32
 #define TARGET_VIRT_ADDR_SPACE_BITS 32
 
-#define TARGET_INSN_START_EXTRA_WORDS 0
-
 #endif
diff --git a/target/xtensa/cpu-param.h b/target/xtensa/cpu-param.h
index 7a0c22c9005..06d85218b84 100644
--- a/target/xtensa/cpu-param.h
+++ b/target/xtensa/cpu-param.h
@@ -16,6 +16,4 @@
 #define TARGET_VIRT_ADDR_SPACE_BITS 32
 #endif
 
-#define TARGET_INSN_START_EXTRA_WORDS 0
-
 #endif
diff --git a/target/alpha/translate.c b/target/alpha/translate.c
index 4442462891e..4d22d7d5a45 100644
--- a/target/alpha/translate.c
+++ b/target/alpha/translate.c
@@ -2899,9 +2899,9 @@ static void alpha_tr_insn_start(DisasContextBase *dcbase, CPUState *cpu)
     DisasContext *ctx = container_of(dcbase, DisasContext, base);
 
     if (ctx->pcrel) {
-        tcg_gen_insn_start(dcbase->pc_next & ~TARGET_PAGE_MASK);
+        tcg_gen_insn_start(dcbase->pc_next & ~TARGET_PAGE_MASK, 0, 0);
     } else {
-        tcg_gen_insn_start(dcbase->pc_next);
+        tcg_gen_insn_start(dcbase->pc_next, 0, 0);
     }
 }
 
diff --git a/target/avr/translate.c b/target/avr/translate.c
index 78ae83df219..649dd4b0112 100644
--- a/target/avr/translate.c
+++ b/target/avr/translate.c
@@ -2689,7 +2689,7 @@ static void avr_tr_insn_start(DisasContextBase *dcbase, CPUState *cs)
 {
     DisasContext *ctx = container_of(dcbase, DisasContext, base);
 
-    tcg_gen_insn_start(ctx->npc);
+    tcg_gen_insn_start(ctx->npc, 0, 0);
 }
 
 static void avr_tr_translate_insn(DisasContextBase *dcbase, CPUState *cs)
diff --git a/target/hexagon/translate.c b/target/hexagon/translate.c
index e88e19cc1af..1c9ab29bd12 100644
--- a/target/hexagon/translate.c
+++ b/target/hexagon/translate.c
@@ -978,7 +978,7 @@ static void hexagon_tr_insn_start(DisasContextBase *dcbase, CPUState *cpu)
 {
     DisasContext *ctx = container_of(dcbase, DisasContext, base);
 
-    tcg_gen_insn_start(ctx->base.pc_next);
+    tcg_gen_insn_start(ctx->base.pc_next, 0, 0);
 }
 
 static bool pkt_crosses_page(CPUHexagonState *env, DisasContext *ctx)
diff --git a/target/i386/tcg/translate.c b/target/i386/tcg/translate.c
index 7186517239c..14210d569f7 100644
--- a/target/i386/tcg/translate.c
+++ b/target/i386/tcg/translate.c
@@ -3501,7 +3501,7 @@ static void i386_tr_insn_start(DisasContextBase *dcbase, CPUState *cpu)
     if (tb_cflags(dcbase->tb) & CF_PCREL) {
         pc_arg &= ~TARGET_PAGE_MASK;
     }
-    tcg_gen_insn_start(pc_arg, dc->cc_op);
+    tcg_gen_insn_start(pc_arg, dc->cc_op, 0);
 }
 
 static void i386_tr_translate_insn(DisasContextBase *dcbase, CPUState *cpu)
diff --git a/target/loongarch/tcg/translate.c b/target/loongarch/tcg/translate.c
index 30f375b33f0..b9ed13d19c6 100644
--- a/target/loongarch/tcg/translate.c
+++ b/target/loongarch/tcg/translate.c
@@ -159,7 +159,7 @@ static void loongarch_tr_insn_start(DisasContextBase *dcbase, CPUState *cs)
 {
     DisasContext *ctx = container_of(dcbase, DisasContext, base);
 
-    tcg_gen_insn_start(ctx->base.pc_next);
+    tcg_gen_insn_start(ctx->base.pc_next, 0, 0);
 }
 
 /*
diff --git a/target/m68k/translate.c b/target/m68k/translate.c
index a0309939012..abc1c79f3cd 100644
--- a/target/m68k/translate.c
+++ b/target/m68k/translate.c
@@ -6041,7 +6041,7 @@ static void m68k_tr_tb_start(DisasContextBase *dcbase, CPUState *cpu)
 static void m68k_tr_insn_start(DisasContextBase *dcbase, CPUState *cpu)
 {
     DisasContext *dc = container_of(dcbase, DisasContext, base);
-    tcg_gen_insn_start(dc->base.pc_next, dc->cc_op);
+    tcg_gen_insn_start(dc->base.pc_next, dc->cc_op, 0);
 }
 
 static void m68k_tr_translate_insn(DisasContextBase *dcbase, CPUState *cpu)
diff --git a/target/microblaze/translate.c b/target/microblaze/translate.c
index 0be3c98dc17..2af67beecec 100644
--- a/target/microblaze/translate.c
+++ b/target/microblaze/translate.c
@@ -1630,7 +1630,7 @@ static void mb_tr_insn_start(DisasContextBase *dcb, CPUState *cs)
 {
     DisasContext *dc = container_of(dcb, DisasContext, base);
 
-    tcg_gen_insn_start(dc->base.pc_next, dc->tb_flags & ~MSR_TB_MASK);
+    tcg_gen_insn_start(dc->base.pc_next, dc->tb_flags & ~MSR_TB_MASK, 0);
 }
 
 static void mb_tr_translate_insn(DisasContextBase *dcb, CPUState *cs)
diff --git a/target/or1k/translate.c b/target/or1k/translate.c
index ce2dc466dc7..de81dc6ef8d 100644
--- a/target/or1k/translate.c
+++ b/target/or1k/translate.c
@@ -1552,7 +1552,7 @@ static void openrisc_tr_insn_start(DisasContextBase *dcbase, CPUState *cs)
     DisasContext *dc = container_of(dcbase, DisasContext, base);
 
     tcg_gen_insn_start(dc->base.pc_next, (dc->delayed_branch ? 1 : 0)
-                       | (dc->base.num_insns > 1 ? 2 : 0));
+                       | (dc->base.num_insns > 1 ? 2 : 0), 0);
 }
 
 static void openrisc_tr_translate_insn(DisasContextBase *dcbase, CPUState *cs)
diff --git a/target/ppc/translate.c b/target/ppc/translate.c
index e9acfa239ec..a09a6df93fd 100644
--- a/target/ppc/translate.c
+++ b/target/ppc/translate.c
@@ -6575,7 +6575,7 @@ static void ppc_tr_tb_start(DisasContextBase *db, CPUState *cs)
 
 static void ppc_tr_insn_start(DisasContextBase *dcbase, CPUState *cs)
 {
-    tcg_gen_insn_start(dcbase->pc_next);
+    tcg_gen_insn_start(dcbase->pc_next, 0, 0);
 }
 
 static bool is_prefix_insn(DisasContext *ctx, uint32_t insn)
diff --git a/target/rx/translate.c b/target/rx/translate.c
index 26d41548294..a245b9db8fe 100644
--- a/target/rx/translate.c
+++ b/target/rx/translate.c
@@ -2217,7 +2217,7 @@ static void rx_tr_insn_start(DisasContextBase *dcbase, CPUState *cs)
 {
     DisasContext *ctx = container_of(dcbase, DisasContext, base);
 
-    tcg_gen_insn_start(ctx->base.pc_next);
+    tcg_gen_insn_start(ctx->base.pc_next, 0, 0);
 }
 
 static void rx_tr_translate_insn(DisasContextBase *dcbase, CPUState *cs)
diff --git a/target/sh4/translate.c b/target/sh4/translate.c
index b3ae0a3814c..b1057727c55 100644
--- a/target/sh4/translate.c
+++ b/target/sh4/translate.c
@@ -2181,7 +2181,7 @@ static void decode_gusa(DisasContext *ctx, CPUSH4State *env)
      * tb->icount * insn_start.
      */
     for (i = 1; i < max_insns; ++i) {
-        tcg_gen_insn_start(pc + i * 2, ctx->envflags);
+        tcg_gen_insn_start(pc + i * 2, ctx->envflags, 0);
         ctx->base.insn_start = tcg_last_op();
     }
 }
@@ -2241,7 +2241,7 @@ static void sh4_tr_insn_start(DisasContextBase *dcbase, CPUState *cs)
 {
     DisasContext *ctx = container_of(dcbase, DisasContext, base);
 
-    tcg_gen_insn_start(ctx->base.pc_next, ctx->envflags);
+    tcg_gen_insn_start(ctx->base.pc_next, ctx->envflags, 0);
 }
 
 static void sh4_tr_translate_insn(DisasContextBase *dcbase, CPUState *cs)
diff --git a/target/sparc/translate.c b/target/sparc/translate.c
index 57b50ff8b9a..7e8558dbbd8 100644
--- a/target/sparc/translate.c
+++ b/target/sparc/translate.c
@@ -5735,7 +5735,7 @@ static void sparc_tr_insn_start(DisasContextBase *dcbase, CPUState *cs)
             g_assert_not_reached();
         }
     }
-    tcg_gen_insn_start(dc->pc, npc);
+    tcg_gen_insn_start(dc->pc, npc, 0);
 }
 
 static void sparc_tr_translate_insn(DisasContextBase *dcbase, CPUState *cs)
diff --git a/target/tricore/translate.c b/target/tricore/translate.c
index 18d8726af6d..0eaf7a82f87 100644
--- a/target/tricore/translate.c
+++ b/target/tricore/translate.c
@@ -8410,7 +8410,7 @@ static void tricore_tr_insn_start(DisasContextBase *dcbase, CPUState *cpu)
 {
     DisasContext *ctx = container_of(dcbase, DisasContext, base);
 
-    tcg_gen_insn_start(ctx->base.pc_next);
+    tcg_gen_insn_start(ctx->base.pc_next, 0, 0);
 }
 
 static bool insn_crosses_page(DisasContext *ctx, CPUTriCoreState *env)
diff --git a/target/xtensa/translate.c b/target/xtensa/translate.c
index bb8d2ed86cf..5e3707d3fdf 100644
--- a/target/xtensa/translate.c
+++ b/target/xtensa/translate.c
@@ -1159,7 +1159,7 @@ static void xtensa_tr_tb_start(DisasContextBase *dcbase, CPUState *cpu)
 
 static void xtensa_tr_insn_start(DisasContextBase *dcbase, CPUState *cpu)
 {
-    tcg_gen_insn_start(dcbase->pc_next);
+    tcg_gen_insn_start(dcbase->pc_next, 0, 0);
 }
 
 static void xtensa_tr_translate_insn(DisasContextBase *dcbase, CPUState *cpu)
-- 
2.47.3


