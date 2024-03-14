Return-Path: <kvm+bounces-11831-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 892A487C440
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 21:25:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F287F1F22B96
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 20:25:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F5DF762C7;
	Thu, 14 Mar 2024 20:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JFqPui9A"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DC647317E
	for <kvm@vger.kernel.org>; Thu, 14 Mar 2024 20:25:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710447936; cv=none; b=e8ekpp3RAWMlP7mP/pwct4jfRfxDAQBnmbGc6xJXJjKf/l3Nlo+KOnNiYvs3JeEfI5yer3GmmFaxoLKHwLqAALbGsib2pEiWD9GMIFUyugNVUS+oAglqQSMZ0sexONjZa9YxQtB1zZQBNn6zuZ7IZaRiz+txyccxh+l+mCetdjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710447936; c=relaxed/simple;
	bh=lkeAZpZwnGU6VpgChdZkLs5vz+1Qca88xONJCmcdPt0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UiwccHXpWyZOwCaLI/p/zkmP3kcaMzpIY4FwxCQbPkXyUT5GMizeM6AA4dtlEvWXmy0qi8Nrv5OLAmdl03yudzkvw1pU4Bu9NZxKm7Ox81aTN7nRfp1qug+AiY1jY9dF9dLcjm9QyLFqgdsc80l2TJzAWoedR+Ge1vxb7QUn+8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JFqPui9A; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-a45f257b81fso175900266b.0
        for <kvm@vger.kernel.org>; Thu, 14 Mar 2024 13:25:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710447933; x=1711052733; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=NdkPYJlECk/ZyZUB9HYwKBtygG9TYfy3Je51QsbOPR4=;
        b=JFqPui9AM7fDE+9U0Lg+U60IfLIN51+kob/F5QFM3bfmoRVLwiuJehtJMNALQDk9lP
         DNIpoFWlGH3iJ2fozigg4KfUpa4bwm213SBx8MbFQfjDPyGEztH9JZb0SKgstyqNpY0L
         OrOb2egGgSWEQTKn5D1nmKU2BC7X3ph7Yk+gtP4Ti0Pr91Lhuw/gJ5r3zXdF/jqfunxe
         5Qfb7BI88g4YtjxpPuk1MRc5dRrUMlfrGusllQF1NnYwbe4V11k51GLD2WqXR4YbIxsE
         4Yfv+hwdhz3Jn3MI6TgkzrSFZTv3mvesI+g1QvdZXIFoc5lQV9yo8+H91bT2OcP5oltG
         EAQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710447933; x=1711052733;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NdkPYJlECk/ZyZUB9HYwKBtygG9TYfy3Je51QsbOPR4=;
        b=r2g+o8nCAm2+nD+LFJHwsF8cz3MaxPOjcqK83pxkmOWerHWSAYKI2HZAWBCvdtq3lP
         2bNe7voK8Zj2VrgrrjGZwEryVjpE+XBybon8+G3lKT1jbGRzfqy8A/VAiNApWjiErJow
         GM9PJbKNkellW/N8mPuedOcBmUiZVfzavGA25+KGH659HD5z8uv2Z3Py9NFDcOUa9GnD
         EY/LYMuTxHufsMIqTr1PT9WFeyLlekC31KhwRS/5dlREU3dvbjLTlgu48Y40Fr8lQwj0
         fDzv7/9XmXr0z1toAdNQbfP7nSl9VIGNvP+YHzAPTCgZg8DT44OfXA3JBjaLJfIjCsEE
         ImgQ==
X-Forwarded-Encrypted: i=1; AJvYcCVE6Tb1cVmqWjbemq8yIiZviFFVboSt0lh43yS4bnr8qLlbNJdY2kMJKyhq014GaKy4WE4w2EJGpARTX02kl6pJSShi
X-Gm-Message-State: AOJu0YzIlqWmvvRwiMo+TJusV1OYevsy87T+d9iOfS6DJYXbfxhzYIgM
	YwhT6wOjLshKd2G24GsAMh8jnA0dO6Pjh1wK0sP1cNPlTfn3hjDwgFzeZGA8kg==
X-Google-Smtp-Source: AGHT+IEAguWOtI6oTSg0qIM4uQ4GgBItzXtzQUetPHeB42cik8WVSDP20zLH80zcpirES87Iw6GvQg==
X-Received: by 2002:a17:906:d798:b0:a46:7cb1:51da with SMTP id pj24-20020a170906d79800b00a467cb151damr653684ejb.52.1710447933392;
        Thu, 14 Mar 2024 13:25:33 -0700 (PDT)
Received: from google.com (64.227.90.34.bc.googleusercontent.com. [34.90.227.64])
        by smtp.gmail.com with ESMTPSA id l15-20020a1709065a8f00b00a3d2d81daafsm1024436ejq.172.2024.03.14.13.25.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Mar 2024 13:25:33 -0700 (PDT)
Date: Thu, 14 Mar 2024 20:25:29 +0000
From: =?utf-8?Q?Pierre-Cl=C3=A9ment?= Tosi <ptosi@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Zenghui Yu <yuzenghui@huawei.com>, Marc Zyngier <maz@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Subject: [PATCH 08/10] arm64: Move esr_comment() to <asm/esr.h>
Message-ID: <6374e3f9d15663e0ea55fa4261ac42f3348ad809.1710446682.git.ptosi@google.com>
References: <cover.1710446682.git.ptosi@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cover.1710446682.git.ptosi@google.com>

As it is already defined twice and is about to be needed for CFI error
detection, move esr_comment() to a header so that it can be reused.

Signed-off-by: Pierre-Clément Tosi <ptosi@google.com>
---
 arch/arm64/include/asm/esr.h       | 5 +++++
 arch/arm64/kernel/debug-monitors.c | 4 +---
 arch/arm64/kernel/traps.c          | 2 --
 arch/arm64/kvm/handle_exit.c       | 2 +-
 4 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
index 353fe08546cf..b0c23e7d6595 100644
--- a/arch/arm64/include/asm/esr.h
+++ b/arch/arm64/include/asm/esr.h
@@ -385,6 +385,11 @@
 #ifndef __ASSEMBLY__
 #include <asm/types.h>
 
+static inline unsigned long esr_comment(unsigned long esr)
+{
+	return esr & ESR_ELx_BRK64_ISS_COMMENT_MASK;
+}
+
 static inline bool esr_is_data_abort(unsigned long esr)
 {
 	const unsigned long ec = ESR_ELx_EC(esr);
diff --git a/arch/arm64/kernel/debug-monitors.c b/arch/arm64/kernel/debug-monitors.c
index 64f2ecbdfe5c..647134ffa9b9 100644
--- a/arch/arm64/kernel/debug-monitors.c
+++ b/arch/arm64/kernel/debug-monitors.c
@@ -312,9 +312,7 @@ static int call_break_hook(struct pt_regs *regs, unsigned long esr)
 	 * entirely not preemptible, and we can use rcu list safely here.
 	 */
 	list_for_each_entry_rcu(hook, list, node) {
-		unsigned long comment = esr & ESR_ELx_BRK64_ISS_COMMENT_MASK;
-
-		if ((comment & ~hook->mask) == hook->imm)
+		if ((esr_comment(esr) & ~hook->mask) == hook->imm)
 			fn = hook->fn;
 	}
 
diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
index 215e6d7f2df8..56317ca48519 100644
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
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 617ae6dea5d5..ffa67ac6656c 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -395,7 +395,7 @@ void __noreturn __cold nvhe_hyp_panic_handler(u64 esr, u64 spsr,
 	if (mode != PSR_MODE_EL2t && mode != PSR_MODE_EL2h) {
 		kvm_err("Invalid host exception to nVHE hyp!\n");
 	} else if (ESR_ELx_EC(esr) == ESR_ELx_EC_BRK64 &&
-		   (esr & ESR_ELx_BRK64_ISS_COMMENT_MASK) == BUG_BRK_IMM) {
+		   esr_comment(esr) == BUG_BRK_IMM) {
 		const char *file = NULL;
 		unsigned int line = 0;
 

-- 
Pierre

