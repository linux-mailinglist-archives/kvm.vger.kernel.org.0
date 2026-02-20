Return-Path: <kvm+bounces-71379-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sPJzNGyul2nO5QIAu9opvQ
	(envelope-from <kvm+bounces-71379-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 01:44:28 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B3A4163F22
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 01:44:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 04BDA30518CE
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 00:43:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33766280A51;
	Fri, 20 Feb 2026 00:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="T29ulQZr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F2F526B2AD
	for <kvm@vger.kernel.org>; Fri, 20 Feb 2026 00:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771548170; cv=none; b=MEdZr8iEbfc6YThvg7yzoVaQu1LbNgcQoaqraDwxsz3myNXsLMHc7Q7Zgxt3/1sP2o4MgeqyIILgj3C6xabb7xEN/g1/hP3qDuMhvoD5E2VK5Y7CZWQEkhnhFFgc0nflymlkszzVIsqRorg7JQzzknL4Fbt3dJtodV15/fjhTr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771548170; c=relaxed/simple;
	bh=HssReSiAlT9GEXO7mAzhj5J3aEcuKLz/8VblparhWCo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HyQbfUeU8b5AnczEoLo7kPp0hA0D2Ko3HyF8PCsUXiu05Q6PQISGgT3izaRFbEuuZ37ij+/mr8lAA5pOhbEuC1nw2VoxmemKiZ4W8Dh4U+74BDtOGWsdmPdO1ZxqjM2Zqpj2yMpq2CnHGn57XwRI65+VoYvbEDdmN/5krxUUKX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=T29ulQZr; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-354c0234c1fso1408343a91.2
        for <kvm@vger.kernel.org>; Thu, 19 Feb 2026 16:42:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771548166; x=1772152966; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=GQ2slfqXqEtWCx20U8reQyZN3PZwYuE3292l0oaA+/E=;
        b=T29ulQZrpZtJ1Rqw8pKn+Hn5divKs9tEPaK9d0Yebjd+SbBmJAi/LwEK6tGZZ2fdyr
         A9CoS3NGi5pvVcDi5o+rSl6DgWxeOLe/978w8E7fXxJLqApUxMcjglS9LDFHNNbszA8c
         TTGG7nPoRdR8T5LYb0mjsl730QYbwacjtQ+vb0myh6odyfkoYcJO5sRJ+GV7idowdfY8
         cHfWJaHc/4yYomr3IF4OgYaeN8USVxXGY6AJ+7WOdqC3P8eIp8AAdiZsZQgFfvE6MnGG
         DK5pDIfW5TyfN1koqsvcRfm7lxiGlGkZ+WOI7GA19nMw4cj/3wBKFl2o+qOsIxfGI2Px
         zgew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771548166; x=1772152966;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GQ2slfqXqEtWCx20U8reQyZN3PZwYuE3292l0oaA+/E=;
        b=wNZ/UMvbKQjovSvkgfnMXTwmuqswhoOi6LK4FVr+jop5et/msjvmUBXqWoNBMWgtjh
         uPNIsk9SmfxPWrxLOJWBVnjYJ7gcspwh+oWAEKT2mjPo4JZgBU1HldTopIx7GxWPuMmk
         irBwstO5hdZw4PK8jhKS32pCnNWa79kAmFAHbk2IRjimq+VYeNK6pa16ti9/xpacMqxC
         Z/2/NXhy4bFBKu162yD6c7yNFnykGwqfYBHuD9WAWcRF/oSsdYAGiGr2520SP4xGSHLa
         Q5KpZ3OImNvILHYIJ7ufHJxo6hUbqyBPz1bUv+Nw6InmMzrnqsAnH4IzlWoBM0Lak9jN
         duRw==
X-Forwarded-Encrypted: i=1; AJvYcCXAesXo9Gzi4L8vnEnQ4ZYTXZLdJWSM5ifoLsxfMdZcKKjFPo4xBNQzY/iPqjBntIEynpQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwyNGY+2EofHSBikT5d0NTWKrQhZy186oK9NAodVjw+Jc4H6jhM
	vaPz31xyOh3tSe0ePNWajxZj9d8HfpbkKRmA6KvDtOShNc8FAcEKTHydqRx/6keovJZpdRtvCdz
	jVRBs4izMnc4cKQ==
X-Received: from pjbso13.prod.google.com ([2002:a17:90b:1f8d:b0:34a:c039:1428])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:5282:b0:34c:635f:f855 with SMTP id 98e67ed59e1d1-3584481e367mr17810869a91.7.1771548166016;
 Thu, 19 Feb 2026 16:42:46 -0800 (PST)
Date: Fri, 20 Feb 2026 00:42:20 +0000
In-Reply-To: <20260220004223.4168331-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260220004223.4168331-1-dmatlack@google.com>
X-Mailer: git-send-email 2.53.0.414.gf7e9f6c205-goog
Message-ID: <20260220004223.4168331-8-dmatlack@google.com>
Subject: [PATCH v2 07/10] KVM: selftests: Use s32 instead of int32_t
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Ackerley Tng <ackerleytng@google.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, Andrew Jones <ajones@ventanamicro.com>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atish.patra@linux.dev>, 
	Bibo Mao <maobibo@loongson.cn>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Colin Ian King <colin.i.king@gmail.com>, 
	David Hildenbrand <david@kernel.org>, David Matlack <dmatlack@google.com>, Fuad Tabba <tabba@google.com>, 
	Huacai Chen <chenhuacai@kernel.org>, James Houghton <jthoughton@google.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Joey Gouly <joey.gouly@arm.com>, kvmarm@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-riscv@lists.infradead.org, 
	Lisa Wang <wyihan@google.com>, loongarch@lists.linux.dev, 
	Marc Zyngier <maz@kernel.org>, Maxim Levitsky <mlevitsk@redhat.com>, Nutty Liu <nutty.liu@hotmail.com>, 
	Oliver Upton <oupton@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>, 
	"Pratik R. Sampat" <prsampat@amd.com>, Rahul Kumar <rk0006818@gmail.com>, 
	Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Wu Fei <wu.fei9@sanechips.com.cn>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Zenghui Yu <yuzenghui@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71379-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[42];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dmatlack@google.com,kvm@vger.kernel.org];
	FREEMAIL_CC(0.00)[google.com,eecs.berkeley.edu,ghiti.fr,ventanamicro.com,brainfault.org,linux.dev,loongson.cn,linux.ibm.com,gmail.com,kernel.org,arm.com,lists.linux.dev,lists.infradead.org,vger.kernel.org,redhat.com,hotmail.com,dabbelt.com,amd.com,sanechips.com.cn,huawei.com];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,checkpatch.pl:url]
X-Rspamd-Queue-Id: 7B3A4163F22
X-Rspamd-Action: no action

Use s32 instead of int32_t to make the KVM selftests code more concise
and more similar to the kernel (since selftests are primarily developed
by kernel developers).

This commit was generated with the following command:

  git ls-files tools/testing/selftests/kvm | xargs sed -i 's/int32_t/s32/g'

Then by manually adjusting whitespace to make checkpatch.pl happy.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 .../kvm/arm64/arch_timer_edge_cases.c         | 24 +++++++++----------
 .../selftests/kvm/include/arm64/arch_timer.h  |  4 ++--
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/arch_timer_edge_cases.c b/tools/testing/selftests/kvm/arm64/arch_timer_edge_cases.c
index f8b183f13864..f7625eb711d6 100644
--- a/tools/testing/selftests/kvm/arm64/arch_timer_edge_cases.c
+++ b/tools/testing/selftests/kvm/arm64/arch_timer_edge_cases.c
@@ -25,8 +25,8 @@
 /* Depends on counter width. */
 static u64 CVAL_MAX;
 /* tval is a signed 32-bit int. */
-static const int32_t TVAL_MAX = INT32_MAX;
-static const int32_t TVAL_MIN = INT32_MIN;
+static const s32 TVAL_MAX = INT32_MAX;
+static const s32 TVAL_MIN = INT32_MIN;
 
 /* After how much time we say there is no IRQ. */
 static const u32 TIMEOUT_NO_IRQ_US = 50000;
@@ -355,7 +355,7 @@ static void test_timer_cval(enum arch_timer timer, u64 cval,
 	test_timer_xval(timer, cval, TIMER_CVAL, wm, reset_state, reset_cnt);
 }
 
-static void test_timer_tval(enum arch_timer timer, int32_t tval,
+static void test_timer_tval(enum arch_timer timer, s32 tval,
 			    irq_wait_method_t wm, bool reset_state,
 			    u64 reset_cnt)
 {
@@ -385,10 +385,10 @@ static void test_cval_no_irq(enum arch_timer timer, u64 cval,
 	test_xval_check_no_irq(timer, cval, usec, TIMER_CVAL, wm);
 }
 
-static void test_tval_no_irq(enum arch_timer timer, int32_t tval, u64 usec,
+static void test_tval_no_irq(enum arch_timer timer, s32 tval, u64 usec,
 			     sleep_method_t wm)
 {
-	/* tval will be cast to an int32_t in test_xval_check_no_irq */
+	/* tval will be cast to an s32 in test_xval_check_no_irq */
 	test_xval_check_no_irq(timer, (u64)tval, usec, TIMER_TVAL, wm);
 }
 
@@ -463,7 +463,7 @@ static void test_timers_fired_multiple_times(enum arch_timer timer)
  * timeout for the wait: we use the wfi instruction.
  */
 static void test_reprogramming_timer(enum arch_timer timer, irq_wait_method_t wm,
-				     int32_t delta_1_ms, int32_t delta_2_ms)
+				     s32 delta_1_ms, s32 delta_2_ms)
 {
 	local_irq_disable();
 	reset_timer_state(timer, DEF_CNT);
@@ -504,7 +504,7 @@ static void test_reprogram_timers(enum arch_timer timer)
 
 static void test_basic_functionality(enum arch_timer timer)
 {
-	int32_t tval = (int32_t) msec_to_cycles(test_args.wait_ms);
+	s32 tval = (s32)msec_to_cycles(test_args.wait_ms);
 	u64 cval = DEF_CNT + msec_to_cycles(test_args.wait_ms);
 	int i;
 
@@ -685,7 +685,7 @@ static void test_set_cnt_after_xval_no_irq(enum arch_timer timer,
 }
 
 static void test_set_cnt_after_tval(enum arch_timer timer, u64 cnt_1,
-				    int32_t tval, u64 cnt_2,
+				    s32 tval, u64 cnt_2,
 				    irq_wait_method_t wm)
 {
 	test_set_cnt_after_xval(timer, cnt_1, tval, cnt_2, wm, TIMER_TVAL);
@@ -699,7 +699,7 @@ static void test_set_cnt_after_cval(enum arch_timer timer, u64 cnt_1,
 }
 
 static void test_set_cnt_after_tval_no_irq(enum arch_timer timer,
-					   u64 cnt_1, int32_t tval,
+					   u64 cnt_1, s32 tval,
 					   u64 cnt_2, sleep_method_t wm)
 {
 	test_set_cnt_after_xval_no_irq(timer, cnt_1, tval, cnt_2, wm,
@@ -718,7 +718,7 @@ static void test_set_cnt_after_cval_no_irq(enum arch_timer timer,
 static void test_move_counters_ahead_of_timers(enum arch_timer timer)
 {
 	int i;
-	int32_t tval;
+	s32 tval;
 
 	for (i = 0; i < ARRAY_SIZE(irq_wait_method); i++) {
 		irq_wait_method_t wm = irq_wait_method[i];
@@ -753,7 +753,7 @@ static void test_move_counters_behind_timers(enum arch_timer timer)
 
 static void test_timers_in_the_past(enum arch_timer timer)
 {
-	int32_t tval = -1 * (int32_t) msec_to_cycles(test_args.wait_ms);
+	s32 tval = -1 * (s32)msec_to_cycles(test_args.wait_ms);
 	u64 cval;
 	int i;
 
@@ -789,7 +789,7 @@ static void test_timers_in_the_past(enum arch_timer timer)
 
 static void test_long_timer_delays(enum arch_timer timer)
 {
-	int32_t tval = (int32_t) msec_to_cycles(test_args.long_wait_ms);
+	s32 tval = (s32)msec_to_cycles(test_args.long_wait_ms);
 	u64 cval = DEF_CNT + msec_to_cycles(test_args.long_wait_ms);
 	int i;
 
diff --git a/tools/testing/selftests/kvm/include/arm64/arch_timer.h b/tools/testing/selftests/kvm/include/arm64/arch_timer.h
index 4fe0e0d07584..a5836d4ab7ee 100644
--- a/tools/testing/selftests/kvm/include/arm64/arch_timer.h
+++ b/tools/testing/selftests/kvm/include/arm64/arch_timer.h
@@ -79,7 +79,7 @@ static inline u64 timer_get_cval(enum arch_timer timer)
 	return 0;
 }
 
-static inline void timer_set_tval(enum arch_timer timer, int32_t tval)
+static inline void timer_set_tval(enum arch_timer timer, s32 tval)
 {
 	switch (timer) {
 	case VIRTUAL:
@@ -95,7 +95,7 @@ static inline void timer_set_tval(enum arch_timer timer, int32_t tval)
 	isb();
 }
 
-static inline int32_t timer_get_tval(enum arch_timer timer)
+static inline s32 timer_get_tval(enum arch_timer timer)
 {
 	isb();
 	switch (timer) {
-- 
2.53.0.414.gf7e9f6c205-goog


