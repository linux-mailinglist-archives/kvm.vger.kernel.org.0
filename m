Return-Path: <kvm+bounces-14090-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CA1E89ED9F
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 10:30:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 22676283122
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 08:30:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3786113D612;
	Wed, 10 Apr 2024 08:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yhYfRPM9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C277B8C1E
	for <kvm@vger.kernel.org>; Wed, 10 Apr 2024 08:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712737786; cv=none; b=jFjhLVGSSKhNpdsa2+Xn6G83QyNyGUSSpsp5vXb1HptfFRocktzL305GE0wMWz7AEB53X9pT1R4YBxGIOJQ5TJ240dTcHtdPY+KJQaabbCgCoUCnCEZkOCuwekqJeU7IJ8Q6tk50Lf6NVjdIKqdh3fi9oTvyxjHdFdnt/EdGgec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712737786; c=relaxed/simple;
	bh=sf0sDasYfNHboeUmoADUV0lyyWhLkNN4THpXFKwDkII=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=kSML64Wvit+exQ4hjpg7h41PrDW39VusBamt0BNatTqo0txo7jef9YoreGxBKuwfIQAmYaF7KdVa3qbK1KqWd9KPdbMQXFEfefUeKLkj7E7VT05JrOjC+Nmqx3kGx8BQtzSWNboN+1pseAdeTtDapCfwI6Ujzz6D5D46OQVuRQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yhYfRPM9; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-56e2b3e114fso6528428a12.2
        for <kvm@vger.kernel.org>; Wed, 10 Apr 2024 01:29:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712737783; x=1713342583; darn=vger.kernel.org;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/NZHDu7gaaGLVzR6sjGpXZZ06n1xRkbPQlKF9FVoL20=;
        b=yhYfRPM9pUwjpU35r+/vlVqbJEntYp4XYdC1zUq8ZtC0o9xeBXQYPwzZhuoMsxmJqt
         0lh4n4ARmKwXDjTN8US/X0fngzf3kJSaZGN3A0C0WjgNdRzffRH2GDpQ8Bk8rjSVhgok
         7h4UFXeCoGWmz6lY6+u0nWg5mmcO8/qDoOUDibfyKXezDWOhDSRzWG6FyiMcuIqp5F2x
         QQhepS4zsLK6prYOnnruzvYfQ6bJsMWQws/FG3Dy87LldJkHKwZYPpBAm4KSr3Fb/WmK
         6V9e0L9jEtFeu+EaaNieH3ZwsakTHDTVSWMPTG0tX7kVXby58jqFnndOnkr/GZWDg7X+
         h/ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712737783; x=1713342583;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/NZHDu7gaaGLVzR6sjGpXZZ06n1xRkbPQlKF9FVoL20=;
        b=LfXzRTmGuMuGnF+MUNappMQATAVhJDgC6Ho4I9crGeWVmXbCgNUxSSP6MQiLaTI/R6
         q5zZWQzZ4vKlIJdmWoKs0wCF1OIpCD6YvMyPozT/tWaSvDl/R/wJVjJqxsD76+ZvYtyB
         1ok+y9ZsVIkPItaNyKtRZnI8fPw4lGoLhfDvVyQfdxknAepI4G98r8E70caED6pkODsi
         d+PyGz4CXjSYFeWKC12IgG5/6SROa/1pGxxCxlm9G6AcFHZXuXeQarMKOCQ3MePDjVSE
         Arkfwub6b6Dy84hsuu3O2llyykWx+Ibj5qmpIgyaJyeL0VifD/HGEUKaH2hqoifUz/EV
         8ZPg==
X-Forwarded-Encrypted: i=1; AJvYcCUaSPGTtSYon1iywgCswT52upo7Vq4vXTfn5vQ2xtUAKLQsrqGLybFsOVNo317joOZx41l/0xryPZ2ZuLxq+VjyC8SG
X-Gm-Message-State: AOJu0YzQwS/3ZJf00A3DnMcPFcyZCwOgnVeCaUDpisX9qZxA9trFAFuV
	pRXWQlSWChJw4Tl0ilBn2TtCpQnVL1ZZ/uqBFwGfUsP4HSwd3D1EnwGcjKlzJQ==
X-Google-Smtp-Source: AGHT+IHk06Jj4qi1uxqsJ3TKZTuTcrqUHzkgKhb4lhb70e3Hy/FmNeOV4FhI393R0veGubX5c/yefQ==
X-Received: by 2002:a17:906:3554:b0:a51:fa56:4fc7 with SMTP id s20-20020a170906355400b00a51fa564fc7mr1066762eja.21.1712737783099;
        Wed, 10 Apr 2024 01:29:43 -0700 (PDT)
Received: from google.com (61.134.90.34.bc.googleusercontent.com. [34.90.134.61])
        by smtp.gmail.com with ESMTPSA id c22-20020a170906529600b00a51bbee7e55sm5299754ejm.53.2024.04.10.01.29.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Apr 2024 01:29:42 -0700 (PDT)
Date: Wed, 10 Apr 2024 09:29:39 +0100
From: =?utf-8?Q?Pierre-Cl=C3=A9ment?= Tosi <ptosi@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Vincent Donnefort <vdonnefort@google.com>
Subject: [PATCH v2 08/12] arm64: Move esr_comment() to <asm/esr.h>
Message-ID: <d7bs5iq4lb6yeza5y7evj6rqqqogclij5wat76b3asn7xvtmwz@x6lu7v3yih4p>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

As it is already defined twice and is about to be needed for kCFI error
detection, move esr_comment() to a header for re-use, with a clearer
name.

Signed-off-by: Pierre-Clément Tosi <ptosi@google.com>
---
 arch/arm64/include/asm/esr.h       | 5 +++++
 arch/arm64/kernel/debug-monitors.c | 4 +---
 arch/arm64/kernel/traps.c          | 8 +++-----
 arch/arm64/kvm/handle_exit.c       | 2 +-
 4 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
index 81606bf7d5ac..2bcf216be376 100644
--- a/arch/arm64/include/asm/esr.h
+++ b/arch/arm64/include/asm/esr.h
@@ -379,6 +379,11 @@
 #ifndef __ASSEMBLY__
 #include <asm/types.h>
 
+static inline unsigned long esr_brk_comment(unsigned long esr)
+{
+	return esr & ESR_ELx_BRK64_ISS_COMMENT_MASK;
+}
+
 static inline bool esr_is_data_abort(unsigned long esr)
 {
 	const unsigned long ec = ESR_ELx_EC(esr);
diff --git a/arch/arm64/kernel/debug-monitors.c b/arch/arm64/kernel/debug-monitors.c
index 64f2ecbdfe5c..024a7b245056 100644
--- a/arch/arm64/kernel/debug-monitors.c
+++ b/arch/arm64/kernel/debug-monitors.c
@@ -312,9 +312,7 @@ static int call_break_hook(struct pt_regs *regs, unsigned long esr)
 	 * entirely not preemptible, and we can use rcu list safely here.
 	 */
 	list_for_each_entry_rcu(hook, list, node) {
-		unsigned long comment = esr & ESR_ELx_BRK64_ISS_COMMENT_MASK;
-
-		if ((comment & ~hook->mask) == hook->imm)
+		if ((esr_brk_comment(esr) & ~hook->mask) == hook->imm)
 			fn = hook->fn;
 	}
 
diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
index 215e6d7f2df8..2652247032ae 100644
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -1105,8 +1105,6 @@ static struct break_hook ubsan_break_hook = {
 };
 #endif
 
-#define esr_comment(esr) ((esr) & ESR_ELx_BRK64_ISS_COMMENT_MASK)
-
 /*
  * Initial handler for AArch64 BRK exceptions
  * This handler only used until debug_traps_init().
@@ -1115,15 +1113,15 @@ int __init early_brk64(unsigned long addr, unsigned long esr,
 		struct pt_regs *regs)
 {
 #ifdef CONFIG_CFI_CLANG
-	if ((esr_comment(esr) & ~CFI_BRK_IMM_MASK) == CFI_BRK_IMM_BASE)
+	if ((esr_brk_comment(esr) & ~CFI_BRK_IMM_MASK) == CFI_BRK_IMM_BASE)
 		return cfi_handler(regs, esr) != DBG_HOOK_HANDLED;
 #endif
 #ifdef CONFIG_KASAN_SW_TAGS
-	if ((esr_comment(esr) & ~KASAN_BRK_MASK) == KASAN_BRK_IMM)
+	if ((esr_brk_comment(esr) & ~KASAN_BRK_MASK) == KASAN_BRK_IMM)
 		return kasan_handler(regs, esr) != DBG_HOOK_HANDLED;
 #endif
 #ifdef CONFIG_UBSAN_TRAP
-	if ((esr_comment(esr) & ~UBSAN_BRK_MASK) == UBSAN_BRK_IMM)
+	if ((esr_brk_comment(esr) & ~UBSAN_BRK_MASK) == UBSAN_BRK_IMM)
 		return ubsan_handler(regs, esr) != DBG_HOOK_HANDLED;
 #endif
 	return bug_handler(regs, esr) != DBG_HOOK_HANDLED;
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 617ae6dea5d5..0bcafb3179d6 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -395,7 +395,7 @@ void __noreturn __cold nvhe_hyp_panic_handler(u64 esr, u64 spsr,
 	if (mode != PSR_MODE_EL2t && mode != PSR_MODE_EL2h) {
 		kvm_err("Invalid host exception to nVHE hyp!\n");
 	} else if (ESR_ELx_EC(esr) == ESR_ELx_EC_BRK64 &&
-		   (esr & ESR_ELx_BRK64_ISS_COMMENT_MASK) == BUG_BRK_IMM) {
+		   esr_brk_comment(esr) == BUG_BRK_IMM) {
 		const char *file = NULL;
 		unsigned int line = 0;
 
-- 
2.44.0.478.gd926399ef9-goog


-- 
Pierre

