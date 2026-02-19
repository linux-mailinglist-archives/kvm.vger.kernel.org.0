Return-Path: <kvm+bounces-71321-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EAknJLSLlmkBhQIAu9opvQ
	(envelope-from <kvm+bounces-71321-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 05:04:04 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id E9D2D15BF58
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 05:04:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 60ABF3074F13
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 04:02:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AFDB2773EC;
	Thu, 19 Feb 2026 04:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="rev5SZVH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f193.google.com (mail-pl1-f193.google.com [209.85.214.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C35528469B
	for <kvm@vger.kernel.org>; Thu, 19 Feb 2026 04:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771473743; cv=none; b=uE2N0VBmagqv1AIDb1DbrJfziWKIKdpjXsklvP32w6CLZsR33gFmHDx2Kju5f7dt5+SDm7mkf7vZy3tZO1AR+o2nIk76q7aa7WEjxInKYN7BWmQcJ/rogudu6lctnuX6Mfrd8Vcr0HYHFq8zKYju3nVZC6+BWZ980TmftNj8Vyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771473743; c=relaxed/simple;
	bh=hMDb6/J2fAagx2dY6eFPI0Sq3qz7/j4FhSq8XngnPqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fUB/iTaC9CpqX5QYSpfPQdXy1jTpvoKeqqa6B9cwgSaTd+ThfW6rJwJUzOhXnhtL9iszTUmf+91oWWLXp8eDV3gd/vjJUpa039GHbQaU+O0gd76E7Wu5MmWSGtmyBcfzSwP6Wzbe4stVYi8yL1f0FtYB1icz6kDxlCNkCTNlYFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=rev5SZVH; arc=none smtp.client-ip=209.85.214.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f193.google.com with SMTP id d9443c01a7336-2a8a7269547so4393955ad.0
        for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 20:02:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1771473742; x=1772078542; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8BtQ7bhjPsJSS0UXCY2rgGt0bRWuOuYRQy8L3yquKrE=;
        b=rev5SZVHCR3Gh8sViIIEFL3nOZwmwqHBcDyLf3FYDADsPGzXiQky/SD01VFgz13Nhb
         28Dc+3mJWCXpUUcmvTsf6OB1jqzfHKh7YOdP+XDjV/TFJtROKph5oRrJuDj2RbhmPyLz
         r+H8fkpDcn/8di9Yg+xGhZB4WW2uQOjpL44kW1IwAApUP0TpbTlQqWfUSFZvgPPNQy47
         gmTLcQ4mRI2JJDzt+6KTl30mJQMSSIdVOyAoPB4tTrmBlzGlUoF2ie9qf9wPsSEJN8IR
         0JwQwsGP5GC2qxOVdPLIf1gSEbYU4DXXlEnSd6zEShbH4zO65r+dZKz4W61P1WYu6x1v
         ZmtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771473742; x=1772078542;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8BtQ7bhjPsJSS0UXCY2rgGt0bRWuOuYRQy8L3yquKrE=;
        b=FQpnfGo3e8SA9LLawlwRSiECSMGtrryz5VIBZh+w89xjlEny8d/SG4+YfKc4X0CBDx
         oLGfZio9xwwiVFsgrPBsToXvaHeRvP5ByZrQsArSzYKIB2vVUcTFKram6ZegJKH/OycH
         MN8IIvxM93uU5dMFXe+31c51zDi4KJ117S6ad4BtB/tqqTXH39zvrXvj0lwdVeyLqn5d
         Z9aZ2LKkQWN9HahltH0zZciDGDVcTyUwcA1GWFd/loYwZgynbUeSsPMdo2xt+yehJG7k
         EzwtW+sfEJY8DM8yBKvJUs1YSLHh5+3buziaGe67Ro8GaV7RmFMFNxJ7h0vwrN4WRjdy
         Xg5A==
X-Forwarded-Encrypted: i=1; AJvYcCV5Yg3mBVNyNlooxNrpZXPEEzaDGp6Hdn8lt8/chXBCqxAbIf+cwtCagg5BRZl+TlSlSJQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzUvRtiyuRuVZcrUoH7UYvzHa8HEj+maymrd0UuHCQ0LjBMPjs8
	GVw3EYpnICC0QPMbRc9XqsA2czCYS6QUwi2SmDdakU+YkKZOmBdnoTSIjTdA0SUe/E4=
X-Gm-Gg: AZuq6aI+fLmEsDBG3y5Wn29B48GSaS4uNrpOXJk6KzNA7/ekDIOm+yHrLwJoJI5q+U8
	rRVYY+s7IPqet0UuuK/0OzPE/L9lLa8S1G7/Om+iCBBXtGoSH4ZhhrY3IyMOTjkneJ8Ks/Fxi2Q
	yicvUnWnJLOBro40Qmgt+PBhuQYLGOBjxSvAMBUsjv6NxEsbbQATsAgotmWEJJxEx2Yl9jqq7iF
	HwGwahm+d4INCtRotDSyYr99zFMFWuG8Hb9OBsNAlpbLgWrbl4dX+l43ZUAfQhUSL1TXmyDIcmZ
	Pqvif+zlKe7ZKfkl5bstuPi2DouBTQ/EYwvduTu9RaDC0ZieX+NOjW9AHFZDG/CDNFJL5f9Q0C7
	M7gzmyRVy6Zx7bYuwuQrk3OKd7odYWSd696jVXNVL2/03S/1UkyFrOqrp8OfQP+zvyknoPa7QVV
	0Phn7YACcl5ekzbQh5LslKBV01TiM+nDHrsnnS/M9oKxsI4WstX50eIzYsx5udBuQ/4KSM4EuL3
	I3R
X-Received: by 2002:a17:903:198b:b0:2aa:f0d6:bf3b with SMTP id d9443c01a7336-2ab4d09b924mr182971155ad.53.1771473741589;
        Wed, 18 Feb 2026 20:02:21 -0800 (PST)
Received: from pc.taild8403c.ts.net (216-71-219-44.dyn.novuscom.net. [216.71.219.44])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ad1a73200asm147636225ad.36.2026.02.18.20.02.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Feb 2026 20:02:21 -0800 (PST)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	qemu-arm@nongnu.org,
	kvm@vger.kernel.org,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	anjo@rev.ng,
	Peter Maydell <peter.maydell@linaro.org>,
	Jim MacArthur <jim.macarthur@linaro.org>
Subject: [PATCH v4 13/14] target/arm/tcg/translate.h: replace target_long with int64_t
Date: Wed, 18 Feb 2026 20:01:49 -0800
Message-ID: <20260219040150.2098396-14-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260219040150.2098396-1-pierrick.bouvier@linaro.org>
References: <20260219040150.2098396-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[linaro.org,none];
	R_DKIM_ALLOW(-0.20)[linaro.org:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[linaro.org:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71321-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pierrick.bouvier@linaro.org,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[11];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,linaro.org:mid,linaro.org:dkim,linaro.org:email]
X-Rspamd-Queue-Id: E9D2D15BF58
X-Rspamd-Action: no action

target_long is used to represent a pc diff. Checked all call sites to
make sure we were already passing signed values, so extending works as
expected.

Use vaddr for pc_curr and pc_save.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/tcg/translate-a32.h |  2 +-
 target/arm/tcg/translate.h     | 12 ++++++------
 target/arm/tcg/translate.c     | 18 +++++++++---------
 3 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/target/arm/tcg/translate-a32.h b/target/arm/tcg/translate-a32.h
index 0b1fa57965c..a8df364171b 100644
--- a/target/arm/tcg/translate-a32.h
+++ b/target/arm/tcg/translate-a32.h
@@ -40,7 +40,7 @@ void write_neon_element64(TCGv_i64 src, int reg, int ele, MemOp memop);
 TCGv_i32 add_reg_for_lit(DisasContext *s, int reg, int ofs);
 void gen_set_cpsr(TCGv_i32 var, uint32_t mask);
 void gen_set_condexec(DisasContext *s);
-void gen_update_pc(DisasContext *s, target_long diff);
+void gen_update_pc(DisasContext *s, int64_t diff);
 void gen_lookup_tb(DisasContext *s);
 long vfp_reg_offset(bool dp, unsigned reg);
 long neon_full_reg_offset(unsigned reg);
diff --git a/target/arm/tcg/translate.h b/target/arm/tcg/translate.h
index 2c8358dd7fa..3e3094a463e 100644
--- a/target/arm/tcg/translate.h
+++ b/target/arm/tcg/translate.h
@@ -27,8 +27,8 @@ typedef struct DisasLabel {
 typedef struct DisasDelayException {
     struct DisasDelayException *next;
     TCGLabel *lab;
-    target_long pc_curr;
-    target_long pc_save;
+    vaddr pc_curr;
+    vaddr pc_save;
     int condexec_mask;
     int condexec_cond;
     uint32_t excp;
@@ -359,14 +359,14 @@ static inline int curr_insn_len(DisasContext *s)
 
 #ifdef TARGET_AARCH64
 void a64_translate_init(void);
-void gen_a64_update_pc(DisasContext *s, target_long diff);
+void gen_a64_update_pc(DisasContext *s, int64_t diff);
 extern const TranslatorOps aarch64_translator_ops;
 #else
 static inline void a64_translate_init(void)
 {
 }
 
-static inline void gen_a64_update_pc(DisasContext *s, target_long diff)
+static inline void gen_a64_update_pc(DisasContext *s, int64_t diff)
 {
 }
 #endif
@@ -377,9 +377,9 @@ void arm_gen_test_cc(int cc, TCGLabel *label);
 MemOp pow2_align(unsigned i);
 void unallocated_encoding(DisasContext *s);
 void gen_exception_internal(int excp);
-void gen_exception_insn_el(DisasContext *s, target_long pc_diff, int excp,
+void gen_exception_insn_el(DisasContext *s, int64_t pc_diff, int excp,
                            uint32_t syn, uint32_t target_el);
-void gen_exception_insn(DisasContext *s, target_long pc_diff,
+void gen_exception_insn(DisasContext *s, int64_t pc_diff,
                         int excp, uint32_t syn);
 TCGLabel *delay_exception_el(DisasContext *s, int excp,
                              uint32_t syn, uint32_t target_el);
diff --git a/target/arm/tcg/translate.c b/target/arm/tcg/translate.c
index 3f57006f9df..f9d1b8897d2 100644
--- a/target/arm/tcg/translate.c
+++ b/target/arm/tcg/translate.c
@@ -253,12 +253,12 @@ static inline int get_a32_user_mem_index(DisasContext *s)
 }
 
 /* The pc_curr difference for an architectural jump. */
-static target_long jmp_diff(DisasContext *s, target_long diff)
+static int64_t jmp_diff(DisasContext *s, int64_t diff)
 {
     return diff + (s->thumb ? 4 : 8);
 }
 
-static void gen_pc_plus_diff(DisasContext *s, TCGv_i32 var, target_long diff)
+static void gen_pc_plus_diff(DisasContext *s, TCGv_i32 var, int64_t diff)
 {
     assert(s->pc_save != -1);
     if (tb_cflags(s->base.tb) & CF_PCREL) {
@@ -738,7 +738,7 @@ void gen_set_condexec(DisasContext *s)
     }
 }
 
-void gen_update_pc(DisasContext *s, target_long diff)
+void gen_update_pc(DisasContext *s, int64_t diff)
 {
     gen_pc_plus_diff(s, cpu_R[15], diff);
     s->pc_save = s->pc_curr + diff;
@@ -1058,7 +1058,7 @@ static void gen_exception(int excp, uint32_t syndrome)
                                        tcg_constant_i32(syndrome));
 }
 
-static void gen_exception_insn_el_v(DisasContext *s, target_long pc_diff,
+static void gen_exception_insn_el_v(DisasContext *s, int64_t pc_diff,
                                     int excp, uint32_t syn, TCGv_i32 tcg_el)
 {
     if (s->aarch64) {
@@ -1071,14 +1071,14 @@ static void gen_exception_insn_el_v(DisasContext *s, target_long pc_diff,
     s->base.is_jmp = DISAS_NORETURN;
 }
 
-void gen_exception_insn_el(DisasContext *s, target_long pc_diff, int excp,
+void gen_exception_insn_el(DisasContext *s, int64_t pc_diff, int excp,
                            uint32_t syn, uint32_t target_el)
 {
     gen_exception_insn_el_v(s, pc_diff, excp, syn,
                             tcg_constant_i32(target_el));
 }
 
-void gen_exception_insn(DisasContext *s, target_long pc_diff,
+void gen_exception_insn(DisasContext *s, int64_t pc_diff,
                         int excp, uint32_t syn)
 {
     if (s->aarch64) {
@@ -1313,7 +1313,7 @@ static void gen_goto_ptr(void)
  * cpu_loop_exec. Any live exit_requests will be processed as we
  * enter the next TB.
  */
-static void gen_goto_tb(DisasContext *s, unsigned tb_slot_idx, target_long diff)
+static void gen_goto_tb(DisasContext *s, unsigned tb_slot_idx, int64_t diff)
 {
     if (translator_use_goto_tb(&s->base, s->pc_curr + diff)) {
         /*
@@ -1340,7 +1340,7 @@ static void gen_goto_tb(DisasContext *s, unsigned tb_slot_idx, target_long diff)
 }
 
 /* Jump, specifying which TB number to use if we gen_goto_tb() */
-static void gen_jmp_tb(DisasContext *s, target_long diff, int tbno)
+static void gen_jmp_tb(DisasContext *s, int64_t diff, int tbno)
 {
     if (unlikely(s->ss_active)) {
         /* An indirect jump so that we still trigger the debug exception.  */
@@ -1383,7 +1383,7 @@ static void gen_jmp_tb(DisasContext *s, target_long diff, int tbno)
     }
 }
 
-static inline void gen_jmp(DisasContext *s, target_long diff)
+static inline void gen_jmp(DisasContext *s, int64_t diff)
 {
     gen_jmp_tb(s, diff, 0);
 }
-- 
2.47.3


