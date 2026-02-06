Return-Path: <kvm+bounces-70421-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qMgJDdtuhWnqBQQAu9opvQ
	(envelope-from <kvm+bounces-70421-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 05:32:27 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BCD2FA1A6
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 05:32:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 7F27030F1A01
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 04:25:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25D6B34B1A1;
	Fri,  6 Feb 2026 04:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="pfDtiQFv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f193.google.com (mail-pf1-f193.google.com [209.85.210.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 469DD34A799
	for <kvm@vger.kernel.org>; Fri,  6 Feb 2026 04:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770351731; cv=none; b=UcBT+Wi5IiSQ4KI6R4JxYNb2GDgvtJ7Hhb7Zf4WKMFcq7XXvC35HF5CcE7AQ/QNalUOkCg/ZSyVxWBe4DCJIW2R8kGEB9cX1H/hLg3iDfmDhO+HhtDz6Pf0dId8ttHSWEgyAQJJdcs90xjN8WKoRErGshCrsRR7FuYXbxzs4x74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770351731; c=relaxed/simple;
	bh=1Owqs2gycUa22pWObL0U2hf7Gppjelf0mrByvizBytk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HrjKPKl3ALw7aXo2xKVU9WKDXvX2XlTfkn6IqfpBSp1lPeuQrzvA9ptBKeRicmV+uhbkA1n949ZeRwVtBvyVcE/0QqElLOEo2LcwCceYfQYOSmdaTJfO1Qn7tq5zudBOi+KPPjGrynR5hYetA66J0TL8zf6y9xWZsGwaY90RNj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=pfDtiQFv; arc=none smtp.client-ip=209.85.210.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f193.google.com with SMTP id d2e1a72fcca58-81e8a9d521dso216864b3a.2
        for <kvm@vger.kernel.org>; Thu, 05 Feb 2026 20:22:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1770351730; x=1770956530; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BZQOTv1ZWaw7/m+ukhNnjzXfOk5Em/QF1TWzcoaJze0=;
        b=pfDtiQFvWP4CRxm593XWNEcnD94pLuPRolAjue2pXItoUFzUFbvokrmHPuXn+rS5Yw
         6A7DAngTwnYR4pY8SmV5sSjoV3hw53a/uX5Juau+EIWVOYkQDcZhnOurYWhntkMTuR5L
         9kyLITHqLOGQL2YsGyxznSbIdw1ByCr4790NNqTPKSvkfJf2cARTtP0Z8LgVPVMpE/PL
         S5zKijctZFDuhJFH7YgrIS+lLX3mVPIhQEU9iUX+o6VGTuXMCv01+ebbZ5BMKGD48lLB
         I13lFa4/nEwS8lvq3RskjDILCrlTR4H8Y1dFT11ZrsaGZmdLWnhcbxy9zVpMKsomUPO9
         j0xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770351730; x=1770956530;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BZQOTv1ZWaw7/m+ukhNnjzXfOk5Em/QF1TWzcoaJze0=;
        b=rtnz32s/9h9UELcNziuZtbDAB0AUBaTBTSZlrkO9y//SdCwJuGZ4YagEIT6B+lPwRj
         LriBEKp8ftSokfCt52R3c3cPSJQYmXOT8YvIQ51hrPfc6ggk7+bi8aMlLH7k18Mjil7X
         LaqQyurTYLZSDjgQktLW4ouuBkRNhe8RD3rD+cdhK4Q2JzKccoFh+e6UBlZbUV5IGMwe
         AT2izWIVGdDxOehW4tithzCfxLyIsw8xe2hs6bh/a9XGdinTljNoo2oVJtK8ixYTpRa9
         wcI4NZNcD6m5Z+5P43oeGDcqpCAbfhX3p00o2kpdxGz2h+X+Xg13QBkeUe2Jpdwc5Ur3
         UbXQ==
X-Forwarded-Encrypted: i=1; AJvYcCWIU7E/j1dDdchgwLDZhl79c6JRCoGrces2ukCaev79ifjA1rNkrN6fgBChjOui2nn2R0I=@vger.kernel.org
X-Gm-Message-State: AOJu0YxO7sR0A05ZXQgkxhzdpTD2ifxsFJXorx70uoSdd7rV2hIoFV66
	uFUV7lZkRW0+AQMtB1qEZTqPLaU+sNG0oxb/uZ1esqcVOzmSn/S7qg6AT3rTxzLRdPk=
X-Gm-Gg: AZuq6aInAv02sEq9cyreVI72xFBy1eCYXxyblNEDd7HJ65q6ZHjKy8ghWkwRB2arENE
	HUxqMPn4ufVna3IHuyEBNslBY0L0Z1j6LvfCYIlIpZvck0NEK6+G3+8fVZW4KHLS7Ii9Ri9j2XI
	zoTWYYf+A/mrdTyOe6TkwEw5BLK9I+6Q/qU/MXr4GSos8rHuV/doGBY9DKa6NkyVEEsmKv1otm7
	0FA9vm4Wdkha+KPhI9kQt6r9xGbTUUeG38ObbTQvlpZY3o9/faXyIAkUklKmYniiyemYGhFS23I
	wjYUsKvrwyAKJZLE0JjbnPD7Z6KfZthmsXHwZx1Az92IgJEFo53lI3Yv2vpn9bhnomX6kfocz3T
	l+7JOGjjxhk4/XasZW7Uer5ZPNwHwn7IyPMf8B6TdQN3H/qX0lrbzXL3bR4yGtInx5RO4nSSe1T
	RCZbNglbv/xq+QmGnZGVI3N56Cx9AP9niHi/bdRg51fIaKkKmFZqZblVwmboPJsopj
X-Received: by 2002:a05:6a00:240b:b0:823:1094:2458 with SMTP id d2e1a72fcca58-824413c12b8mr1285493b3a.0.1770351730491;
        Thu, 05 Feb 2026 20:22:10 -0800 (PST)
Received: from pc.taild8403c.ts.net (216-71-219-44.dyn.novuscom.net. [216.71.219.44])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8244168fdf5sm926914b3a.17.2026.02.05.20.22.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Feb 2026 20:22:10 -0800 (PST)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: anjo@rev.ng,
	Richard Henderson <richard.henderson@linaro.org>,
	Jim MacArthur <jim.macarthur@linaro.org>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	qemu-arm@nongnu.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v2 12/12] target/arm/tcg/translate.h: replace target_long with int64_t
Date: Thu,  5 Feb 2026 20:21:50 -0800
Message-ID: <20260206042150.912578-13-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260206042150.912578-1-pierrick.bouvier@linaro.org>
References: <20260206042150.912578-1-pierrick.bouvier@linaro.org>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[linaro.org:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70421-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pierrick.bouvier@linaro.org,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[11];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linaro.org:email,linaro.org:dkim,linaro.org:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 9BCD2FA1A6
X-Rspamd-Action: no action

target_long is used to represent a pc diff. Checked all call sites to
make sure we were already passing signed values, so extending works as
expected.

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
index 2c8358dd7fa..1f455e4c434 100644
--- a/target/arm/tcg/translate.h
+++ b/target/arm/tcg/translate.h
@@ -27,8 +27,8 @@ typedef struct DisasLabel {
 typedef struct DisasDelayException {
     struct DisasDelayException *next;
     TCGLabel *lab;
-    target_long pc_curr;
-    target_long pc_save;
+    int64_t pc_curr;
+    int64_t pc_save;
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
index 982c83ef42a..42b2785fb06 100644
--- a/target/arm/tcg/translate.c
+++ b/target/arm/tcg/translate.c
@@ -250,12 +250,12 @@ static inline int get_a32_user_mem_index(DisasContext *s)
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
@@ -735,7 +735,7 @@ void gen_set_condexec(DisasContext *s)
     }
 }
 
-void gen_update_pc(DisasContext *s, target_long diff)
+void gen_update_pc(DisasContext *s, int64_t diff)
 {
     gen_pc_plus_diff(s, cpu_R[15], diff);
     s->pc_save = s->pc_curr + diff;
@@ -1055,7 +1055,7 @@ static void gen_exception(int excp, uint32_t syndrome)
                                        tcg_constant_i32(syndrome));
 }
 
-static void gen_exception_insn_el_v(DisasContext *s, target_long pc_diff,
+static void gen_exception_insn_el_v(DisasContext *s, int64_t pc_diff,
                                     int excp, uint32_t syn, TCGv_i32 tcg_el)
 {
     if (s->aarch64) {
@@ -1068,14 +1068,14 @@ static void gen_exception_insn_el_v(DisasContext *s, target_long pc_diff,
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
@@ -1310,7 +1310,7 @@ static void gen_goto_ptr(void)
  * cpu_loop_exec. Any live exit_requests will be processed as we
  * enter the next TB.
  */
-static void gen_goto_tb(DisasContext *s, unsigned tb_slot_idx, target_long diff)
+static void gen_goto_tb(DisasContext *s, unsigned tb_slot_idx, int64_t diff)
 {
     if (translator_use_goto_tb(&s->base, s->pc_curr + diff)) {
         /*
@@ -1337,7 +1337,7 @@ static void gen_goto_tb(DisasContext *s, unsigned tb_slot_idx, target_long diff)
 }
 
 /* Jump, specifying which TB number to use if we gen_goto_tb() */
-static void gen_jmp_tb(DisasContext *s, target_long diff, int tbno)
+static void gen_jmp_tb(DisasContext *s, int64_t diff, int tbno)
 {
     if (unlikely(s->ss_active)) {
         /* An indirect jump so that we still trigger the debug exception.  */
@@ -1380,7 +1380,7 @@ static void gen_jmp_tb(DisasContext *s, target_long diff, int tbno)
     }
 }
 
-static inline void gen_jmp(DisasContext *s, target_long diff)
+static inline void gen_jmp(DisasContext *s, int64_t diff)
 {
     gen_jmp_tb(s, diff, 0);
 }
-- 
2.47.3


