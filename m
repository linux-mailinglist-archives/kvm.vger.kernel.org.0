Return-Path: <kvm+bounces-64713-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id D1826C8B8C3
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 20:17:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 5580335BBF9
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 19:17:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0717833FE0C;
	Wed, 26 Nov 2025 19:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="x5zNNvzU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A551833F8D2
	for <kvm@vger.kernel.org>; Wed, 26 Nov 2025 19:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764184661; cv=none; b=O40h6q7Tm0dDXuj4T2V06mEnOx/HBh+TMV8aPuFtt2wKDYBEZ07YstOQR3vgZfsFiKoaoFOdifbnwmhvYl6K8MBWyUu7kwhgRF134lazxIgoAE8om7EWCz9OzUppAF//cgjA1MhAYFH7TDUO8Ol1LinweC5GUG2auvIkkkXB5u4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764184661; c=relaxed/simple;
	bh=C5xbA9tyL0ZrFW18BGDh5IBT8BCzFIVZqeg2c00AXnc=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=Osyyzt8IxEJICmHvIi9qUf5sAHh3O7CohW/7hFhoojyUg5Ei+rF/mKSIfNJwanuMVtBqNfAK92wm0dug+34lKYgC2ascr1KT5S8SXiCgHFVhDV3GtZ2ElRqAyGWakg5mRLXNk7spYMOLKXnDswhWvZSE7tQB0GObV5d7DuI+J+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=x5zNNvzU; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3418ad76023so133019a91.0
        for <kvm@vger.kernel.org>; Wed, 26 Nov 2025 11:17:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764184659; x=1764789459; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iNYA6X16t1KQImSYTKJgBNPOrPlPV0jyF3Cmsma79vQ=;
        b=x5zNNvzUbu6doqub/1ebwa2DWVkgWnfQJvE3Q7/9wMh/kb8Wxfae7I0eSIPX23PVP8
         0oRn6FbXRr9/Wko7nx9WVAUJ0bQJU+WYNPgg8ttsfGzzQtlV6+khdYoL9tJp9CRUo/GP
         YqDxaUsTo+NjLtD2SbEQch2Zj/A2JTsCLpJK0jHuLNmc7S66mt62SXZ1JjP4oGYChv6v
         89snBBW3Sctz9TXzBrzyjrKE05vrHETjfVBxZzYZz+AfsgXPXv/0E3nuHirTrTnEx3Si
         mbksTK4H6hLMYyZqAC4vR+mKlTZSLoAqWidK9GypEGkY2NwDpd9j4CUkryusi7n8e5/+
         hQ9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764184659; x=1764789459;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iNYA6X16t1KQImSYTKJgBNPOrPlPV0jyF3Cmsma79vQ=;
        b=kymaU50ryMJ1fvJIFxxgORbrKhaKqnySvcoabJkaGeK1TYBzmsJzks9C4xBZMTrWJ5
         xD5njUoZeMcTY8if94lSrFyh5nq2Ib2My2hc6TYt/bhTAn0hXx00cjZKlmSEnOVPBK1k
         HtSMYXkxwtJLZA8rN4uB/LEL2zG68CYZzR70FSN8RyF0XdKVgpx/YDUwk+LgWEVLRzEU
         GpsGJGwDfBnjcCcLsU3UYKeKrxGhNRBh+WBWAffwWOjs1qUjSby/JovR/bviZaqQvViC
         NwY/w5oZEYYAUl0vJEmB62J8TArC7yBhUiMhWxGYSCwKWg9HRVJ8Sk7o/T9z6zJv+YeL
         qCUA==
X-Gm-Message-State: AOJu0Yw0uDTnHQCHDAtUjRMt9/ru/D6vL9bytW4ia67qd2voGQj6I0Su
	/pGR6ylfznr2uHWuLiH66ady66sRVzW8ySJbO3G12RQ9e6r0GUxFrbbqNWmQ+mqL1L4/SdOBThz
	IitBUGg==
X-Google-Smtp-Source: AGHT+IFs63sKEJ9O8o+/4f4IqxlHZOhBFAM0KjlVJcpvop4czNTrhKBZ7tHx88mHqVL3VGf2pV8SWheE1nI=
X-Received: from pjot10.prod.google.com ([2002:a17:90a:950a:b0:341:8ac7:27a9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:164a:b0:340:c261:f9db
 with SMTP id 98e67ed59e1d1-34733e60944mr19788764a91.10.1764184658805; Wed, 26
 Nov 2025 11:17:38 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 26 Nov 2025 11:17:36 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.487.g5c8c507ade-goog
Message-ID: <20251126191736.907963-1-seanjc@google.com>
Subject: [kvm-unit-tests PATCH] x86/debug: Fix macro definitions for DR7
 local/global enable bits
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Fix the shifts for the DR7 local/global enable bits.  As called out by the
comment, the local/global enable bits have a stride of 2, i.e. use every
other bit.

Use DR2 instead of DR0 in the debug test to create a data breakpoint to
demonstrate that using something other than DR0 actually works.

Fixes: f1dcfd54 ("x86: Overhaul definitions for DR6 and DR7 bits")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/asm/debugreg.h |  5 +++--
 x86/debug.c            | 22 +++++++++++++---------
 2 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/lib/x86/asm/debugreg.h b/lib/x86/asm/debugreg.h
index a30f9493..47c90ebf 100644
--- a/lib/x86/asm/debugreg.h
+++ b/lib/x86/asm/debugreg.h
@@ -37,8 +37,9 @@
  * by the CPU on task switch), bits 1, 3, 5, and 7 are global enable bits
  * (never cleared by the CPU).
  */
-#define DR7_LOCAL_ENABLE_DRx(x)		(BIT(0) << (x))
-#define DR7_GLOBAL_ENABLE_DRx(x)	(BIT(1) << (x))
+#define DR7_LOCAL_ENABLE_DRx(x)		(BIT(0) << ((x) * 2))
+#define DR7_GLOBAL_ENABLE_DRx(x)	(BIT(1) << ((x) * 2))
+
 #define DR7_ENABLE_DRx(x) \
 	(DR7_LOCAL_ENABLE_DRx(x) | DR7_GLOBAL_ENABLE_DRx(x))
 
diff --git a/x86/debug.c b/x86/debug.c
index 09f06ef5..1a4ee5c8 100644
--- a/x86/debug.c
+++ b/x86/debug.c
@@ -38,7 +38,7 @@ static void handle_db(struct ex_regs *regs)
 	db_addr[n] = regs->rip;
 	dr6[n] = read_dr6();
 
-	if (dr6[n] & 0x1)
+	if (dr6[n] & DR6_TRAP2)
 		regs->rflags |= X86_EFLAGS_RF;
 
 	if (++n >= 10) {
@@ -488,29 +488,33 @@ int main(int ac, char **av)
 	 * The CPU sets/clears bits 0-3 (trap bits for DR0-3) on #DB based on
 	 * whether or not the corresponding DR0-3 got a match.  All other bits
 	 * in DR6 are set if and only if their associated breakpoint condition
-	 * is active, and are never cleared by the CPU.  Verify a match on DR0
+	 * is active, and are never cleared by the CPU.  Verify a match on DR2
 	 * is reported correctly, and that DR6.BS is not set when single-step
 	 * breakpoints are disabled, but is left set (if set by software).
 	 */
 	n = 0;
 	extern unsigned char hw_bp1;
-	write_dr0(&hw_bp1);
-	write_dr7(DR7_FIXED_1 | DR7_GLOBAL_ENABLE_DR0);
+	write_dr2(&hw_bp1);
+	write_dr7(DR7_FIXED_1 | DR7_GLOBAL_ENABLE_DR2);
 	asm volatile("hw_bp1: nop");
 	report(n == 1 &&
 	       db_addr[0] == ((unsigned long)&hw_bp1) &&
-	       dr6[0] == (DR6_ACTIVE_LOW | DR6_TRAP0),
-	       "hw breakpoint (test that dr6.BS is not set)");
+	       dr6[0] == (DR6_ACTIVE_LOW | DR6_TRAP2),
+	       "Wanted #DB on 0x%lx w/ DR6 = 0x%lx, got %u #DBs, addr[0] = 0x%lx, DR6 = 0x%lx",
+	       ((unsigned long)&hw_bp1), DR6_ACTIVE_LOW | DR6_TRAP2,
+	       n, db_addr[0], dr6[0]);
 
 	n = 0;
 	extern unsigned char hw_bp2;
-	write_dr0(&hw_bp2);
+	write_dr2(&hw_bp2);
 	write_dr6(DR6_BS | DR6_TRAP1);
 	asm volatile("hw_bp2: nop");
 	report(n == 1 &&
 	       db_addr[0] == ((unsigned long)&hw_bp2) &&
-	       dr6[0] == (DR6_ACTIVE_LOW | DR6_BS | DR6_TRAP0),
-	       "hw breakpoint (test that dr6.BS is not cleared)");
+	       dr6[0] == (DR6_ACTIVE_LOW | DR6_BS | DR6_TRAP2),
+	       "Wanted #DB on 0x%lx w/ DR6 = 0x%lx, got %u #DBs, addr[0] = 0x%lx, DR6 = 0x%lx",
+	       ((unsigned long)&hw_bp1), DR6_ACTIVE_LOW | DR6_BS | DR6_TRAP2,
+	       n, db_addr[0], dr6[0]);
 
 	run_ss_db_test(singlestep_basic);
 	run_ss_db_test(singlestep_emulated_instructions);

base-commit: d2dc9294e25a34110feffb497a29c10f7e2a8ceb
-- 
2.52.0.487.g5c8c507ade-goog


