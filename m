Return-Path: <kvm+bounces-45152-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B94FBAA62D5
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 20:33:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6CAAF7A3E6F
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 18:32:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B822225417;
	Thu,  1 May 2025 18:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="t6uJhr+o"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6BDA2253FD
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 18:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746124408; cv=none; b=KSVsUw78hWJaKnV18lCuCEshOzKXUO7UQz+YAWPXgIeltLnMLDpx0RPMYYGCOrsU8m6di45ZIEDy/wq9gunBqUMS1hR5E5w5xW7zeyWDf4fGK/qqaBQcZvjZSFMkcujVrz3mqV74z3G5n++myIt5m1fRMIMHFUAraqZFUXhASeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746124408; c=relaxed/simple;
	bh=0VCzdFs14Yow09pwhlni5FGJycbkqXupqE6+SdFxv6w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=j2JmMsHrk5WLHSHNlq+J9k47YmN4sgPcYB4NeYdtjAXMofcUSR0xTmpPXmrXJjxPEz5/OG6kFKhCXAl0joicbMSfnnlu9wk4frkjbJCzE1b0sTKX+vUfeG9dXU8FT39XWmXk7O8iLEHtkfNzC4dn73rGFfppTT1J9osj6SQqm/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=t6uJhr+o; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-736cd36189bso1793177b3a.2
        for <kvm@vger.kernel.org>; Thu, 01 May 2025 11:33:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746124406; x=1746729206; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8qNHq0SIhTmNxKhTx3tC44zxjWyK0Dj0ScUzyvuVNlQ=;
        b=t6uJhr+owmRH2+BFeVkvRqEtPjy2Gca6HlxJwS+lnn9csI9EvEupHu3c24+awIDee1
         lqtBIhd7Hrluba3BWmHFtQ+3e81DdL0IzfhGSQOLTnPhTJksPKj9+ZkhXT6Gvglxh3BM
         ajKGstNrsdBbrB9WQyc5wKKpEObcRyt6FjMOTUl3Ou/Ltyu8372dQR2j6Z5Fb1+2ytZG
         kStW6VG95AkTD9jJS46RjU5uiSAts6vo2ARvttYcahuHPuwiOSWIkyUoKM/YyHsvRkoR
         UNOl6f/wv48vJSPxLMwaTmrgcUBYNuGaU7vdCQ4OUAn6gbSuQ+NP+LG7rGqBs3anTVEn
         jL6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746124406; x=1746729206;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8qNHq0SIhTmNxKhTx3tC44zxjWyK0Dj0ScUzyvuVNlQ=;
        b=lGsQ1++RLfg84hhsai0lUgflcDWRKOKJIGuW62Tqyu2lXb5jjs4nRNMP5yLdhGf1x/
         KuYUUyZYrUgC5cGAT3HVnxddVrOIKRCbS9Tnt5U7ajeyTftFxSBBIKaOHujs3SI0GETB
         eFlftz3bmJrmQYQzE7K6z2qccTaGCDGq258F3D//YWBYbPRgd1T40ORltj3LtfNDhtoT
         vvmQZP/uUfdArcwsoR28T+p0DkQHsTSrNTmKu9Cfk9sZcxnGKqBBJXxumZQ51PJqhsdW
         pnxpJGzXbWY5Co614S1jMfd2pjZmfDboqRwrR/feHDe75kjTOeAB3EeIJ7GBBF2r/f55
         YktA==
X-Forwarded-Encrypted: i=1; AJvYcCVEiF+qGYBQMq1Fx0yjVo/nGaw3yGO0UzQ7iIJv9XViX6q0mwDpud2gaen2FH6lWZ95OZo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxzTSOFl7R3Is6NfkKPCgnyNZJFJlzv0SZoBZL2/e/ISq/sX+AV
	aO5qp+pPcxhCux4cVCpwyNMCSTNcmlVmadiuru+TUFB/gr4gKMhtbcGWKleacJWNHkCJOZfpDTm
	9k9h0WU/rnw==
X-Google-Smtp-Source: AGHT+IFKCJy5QtPU13VuKMr9mFb8aJkCwRtWAJ+xW0sweTVsenbE6xlefcq15jGKqhd6hJdIsGl1FFtKDY+i1w==
X-Received: from pfun12.prod.google.com ([2002:a05:6a00:7cc:b0:73c:28d4:aca4])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:928e:b0:736:2a73:6756 with SMTP id d2e1a72fcca58-7403a831702mr10825890b3a.21.1746124406032;
 Thu, 01 May 2025 11:33:26 -0700 (PDT)
Date: Thu,  1 May 2025 11:33:01 -0700
In-Reply-To: <20250501183304.2433192-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250501183304.2433192-1-dmatlack@google.com>
X-Mailer: git-send-email 2.49.0.906.g1f30a19c02-goog
Message-ID: <20250501183304.2433192-8-dmatlack@google.com>
Subject: [PATCH 07/10] KVM: selftests: Use s32 instead of int32_t
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	David Hildenbrand <david@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	David Matlack <dmatlack@google.com>, Andrew Jones <ajones@ventanamicro.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, Reinette Chatre <reinette.chatre@intel.com>, 
	Eric Auger <eric.auger@redhat.com>, James Houghton <jthoughton@google.com>, 
	Colin Ian King <colin.i.king@gmail.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"

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
index 2d799823a366..b99eb6b4b314 100644
--- a/tools/testing/selftests/kvm/arm64/arch_timer_edge_cases.c
+++ b/tools/testing/selftests/kvm/arm64/arch_timer_edge_cases.c
@@ -24,8 +24,8 @@
 
 static const u64 CVAL_MAX = ~0ULL;
 /* tval is a signed 32-bit int. */
-static const int32_t TVAL_MAX = INT32_MAX;
-static const int32_t TVAL_MIN = INT32_MIN;
+static const s32 TVAL_MAX = INT32_MAX;
+static const s32 TVAL_MIN = INT32_MIN;
 
 /* After how much time we say there is no IRQ. */
 static const u32 TIMEOUT_NO_IRQ_US = 50000;
@@ -354,7 +354,7 @@ static void test_timer_cval(enum arch_timer timer, u64 cval,
 	test_timer_xval(timer, cval, TIMER_CVAL, wm, reset_state, reset_cnt);
 }
 
-static void test_timer_tval(enum arch_timer timer, int32_t tval,
+static void test_timer_tval(enum arch_timer timer, s32 tval,
 			    irq_wait_method_t wm, bool reset_state,
 			    u64 reset_cnt)
 {
@@ -384,10 +384,10 @@ static void test_cval_no_irq(enum arch_timer timer, u64 cval,
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
 
@@ -462,7 +462,7 @@ static void test_timers_fired_multiple_times(enum arch_timer timer)
  * timeout for the wait: we use the wfi instruction.
  */
 static void test_reprogramming_timer(enum arch_timer timer, irq_wait_method_t wm,
-				     int32_t delta_1_ms, int32_t delta_2_ms)
+				     s32 delta_1_ms, s32 delta_2_ms)
 {
 	local_irq_disable();
 	reset_timer_state(timer, DEF_CNT);
@@ -503,7 +503,7 @@ static void test_reprogram_timers(enum arch_timer timer)
 
 static void test_basic_functionality(enum arch_timer timer)
 {
-	int32_t tval = (int32_t) msec_to_cycles(test_args.wait_ms);
+	s32 tval = (s32)msec_to_cycles(test_args.wait_ms);
 	u64 cval = DEF_CNT + msec_to_cycles(test_args.wait_ms);
 	int i;
 
@@ -684,7 +684,7 @@ static void test_set_cnt_after_xval_no_irq(enum arch_timer timer,
 }
 
 static void test_set_cnt_after_tval(enum arch_timer timer, u64 cnt_1,
-				    int32_t tval, u64 cnt_2,
+				    s32 tval, u64 cnt_2,
 				    irq_wait_method_t wm)
 {
 	test_set_cnt_after_xval(timer, cnt_1, tval, cnt_2, wm, TIMER_TVAL);
@@ -698,7 +698,7 @@ static void test_set_cnt_after_cval(enum arch_timer timer, u64 cnt_1,
 }
 
 static void test_set_cnt_after_tval_no_irq(enum arch_timer timer,
-					   u64 cnt_1, int32_t tval,
+					   u64 cnt_1, s32 tval,
 					   u64 cnt_2, sleep_method_t wm)
 {
 	test_set_cnt_after_xval_no_irq(timer, cnt_1, tval, cnt_2, wm,
@@ -717,7 +717,7 @@ static void test_set_cnt_after_cval_no_irq(enum arch_timer timer,
 static void test_move_counters_ahead_of_timers(enum arch_timer timer)
 {
 	int i;
-	int32_t tval;
+	s32 tval;
 
 	for (i = 0; i < ARRAY_SIZE(irq_wait_method); i++) {
 		irq_wait_method_t wm = irq_wait_method[i];
@@ -758,7 +758,7 @@ static void test_move_counters_behind_timers(enum arch_timer timer)
 
 static void test_timers_in_the_past(enum arch_timer timer)
 {
-	int32_t tval = -1 * (int32_t) msec_to_cycles(test_args.wait_ms);
+	s32 tval = -1 * (s32)msec_to_cycles(test_args.wait_ms);
 	u64 cval;
 	int i;
 
@@ -794,7 +794,7 @@ static void test_timers_in_the_past(enum arch_timer timer)
 
 static void test_long_timer_delays(enum arch_timer timer)
 {
-	int32_t tval = (int32_t) msec_to_cycles(test_args.long_wait_ms);
+	s32 tval = (s32)msec_to_cycles(test_args.long_wait_ms);
 	u64 cval = DEF_CNT + msec_to_cycles(test_args.long_wait_ms);
 	int i;
 
diff --git a/tools/testing/selftests/kvm/include/arm64/arch_timer.h b/tools/testing/selftests/kvm/include/arm64/arch_timer.h
index 600ee9163604..9d32c196c7ab 100644
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
2.49.0.906.g1f30a19c02-goog


