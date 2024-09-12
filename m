Return-Path: <kvm+bounces-26763-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B22A5977300
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 22:52:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CB5DD1C2401A
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 20:52:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7ACB01C2DCE;
	Thu, 12 Sep 2024 20:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aAq+qRU4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0C0D1C2313
	for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 20:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726174302; cv=none; b=rqMYPBq4gw/pIsq+STblA8w8f6M9iHs1JL3tW9JZ95VbGT6Yz18qAS0mOTXJuQQcNmqfv+Y+ykyHwYwQGqTyODwy42WTQGdTVIUFggORr4gc9PKkH14LXT2M5ibq+mo4yY5DtQXvKvtOXQj1Y+m3B4IjSzskrQT5rZ/gf9NClH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726174302; c=relaxed/simple;
	bh=pmE1v3lPafn5e/IdEGvJX2LgNHvxAhIJEOQCTre4Ijg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jNvRBxCSaljclsxZkgUoeuj24CQE/OCTCYPM2wFGy1nQI/Y0UZldfDfPRJk+uCMsBnbdDZ7zl1pARCTqRauM7O/SDYJL9ns+FIf2gqCz6v0oGZ9s3GRcDWO82ALpF7CrLsdcJGENTJ023Om+fln92or9XPG5JFSML68DMrtRHKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aAq+qRU4; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6d7124938d1so35385237b3.0
        for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 13:51:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726174300; x=1726779100; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2R8Y3DFBOrXpT6Dp+2pnByuz3JsPwrzU4P/6bkl9CfA=;
        b=aAq+qRU4OOTsoEhZW+BE9Z805/rdVNQWDgd1+kWbrmqX0RjCzqNSqFfQFPwyjLMBq7
         pqmqfLDtV/1CzXNX9L2vMSuBdDEgicTcKdTpngKCL47dP/SxSJZQtLbAxIjiyJd0LXs4
         e9og+vnguIg3tH++PnIbtOaPRyQ1t+o+cFEisKS/W894Qvy/UxBE9mPWtYZGqHyJkRDv
         uP9JEueI+HvAID6i2c54xNtsVUpIRKO60ZbEO7j4fk6n5+jJe+FhzzChAWf87qdjQn+2
         oO0GTnH8w6rS9mgsP3qdbEo3/jxbVCziymyKlcMD+PbUG1UHNFQO+rTA6+KQPOVF2mvg
         YiKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726174300; x=1726779100;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2R8Y3DFBOrXpT6Dp+2pnByuz3JsPwrzU4P/6bkl9CfA=;
        b=Zyc17C2dFjIdYZMc0NEmisW6Gjzc6SQ+W7sP/TRHM7RGziZHNuxErYFoJEi5yo7tZa
         aWH7viBCGtI8r8lvWQvujObozN3o+nU7CSc4tyE30FP3I3BFiZIr4+KhVU7DWFlSZ9Wu
         FEPRuCoD437hiE3qpIpNJ5wUC9HoMxkf6Mvb9dv7e7xXbMBCVdE3RpaP3bWqRHTPOIXT
         td4eiw7kwDPn4UJzvyeUDr5Nr9DhNkAvWew7BxF2ZDELjaQfruyuttQ4BzNsOoow7Dw9
         SPJRHq48GcgpbQIjECwfgYwWwJnLZ25AgpGfI62G86Sn6XMJNciHYhKnmFyRxUuy0+L/
         qapw==
X-Gm-Message-State: AOJu0YyaeaxmmmgOYJdwzpx8B4gL0kZPXVO9iSMHuCelIJwmMuCtPInW
	VZySm/Du5yzU0xsp7V33iPDgJz1Ms2sj6xfqzOEpp/Ru/tiG+w7kyIJjJvU4dO+CMSdtWDR1orr
	IMtGdsTab95X909rWkFFJDkyUDHH3hfgBIet1uKsJD3AOcwmb2YtEZbkb8u4oLwNU4A4FfTE/DU
	XquI39HFSCBUa3ufMhCr3wPqc48XswfIP/FTXC/uyqn+6oGgX7cZdgbQY=
X-Google-Smtp-Source: AGHT+IFV1m07CCTdDWX2FOgecLasTDjDmm3XH/XZUgTEGDR6/YrsS27OTSnLSt+SciKeVBgsQCat9dX1tnl2/VgIOw==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:11b:3898:ac11:fa18])
 (user=coltonlewis job=sendgmr) by 2002:a05:6902:1743:b0:e03:3cfa:1aa7 with
 SMTP id 3f1490d57ef6-e1d9db9e1b8mr5314276.1.1726174299130; Thu, 12 Sep 2024
 13:51:39 -0700 (PDT)
Date: Thu, 12 Sep 2024 20:51:31 +0000
In-Reply-To: <20240912205133.4171576-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240912205133.4171576-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.46.0.662.g92d0881bb0-goog
Message-ID: <20240912205133.4171576-4-coltonlewis@google.com>
Subject: [PATCH v3 3/5] powerpc: perf: Use perf_arch_instruction_pointer()
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Oliver Upton <oliver.upton@linux.dev>, Sean Christopherson <seanjc@google.com>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, 
	Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, 
	Kan Liang <kan.liang@linux.intel.com>, Will Deacon <will@kernel.org>, 
	Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
	Christophe Leroy <christophe.leroy@csgroup.eu>, Naveen N Rao <naveen@kernel.org>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H . Peter Anvin" <hpa@zytor.com>, linux-perf-users@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org, 
	Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Make sure powerpc uses the arch-specific function now that those have
been reorganized.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/powerpc/perf/callchain.c    | 2 +-
 arch/powerpc/perf/callchain_32.c | 2 +-
 arch/powerpc/perf/callchain_64.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/perf/callchain.c b/arch/powerpc/perf/callchain.c
index 6b4434dd0ff3..26aa26482c9a 100644
--- a/arch/powerpc/perf/callchain.c
+++ b/arch/powerpc/perf/callchain.c
@@ -51,7 +51,7 @@ perf_callchain_kernel(struct perf_callchain_entry_ctx *entry, struct pt_regs *re
 
 	lr = regs->link;
 	sp = regs->gpr[1];
-	perf_callchain_store(entry, perf_instruction_pointer(regs));
+	perf_callchain_store(entry, perf_arch_instruction_pointer(regs));
 
 	if (!validate_sp(sp, current))
 		return;
diff --git a/arch/powerpc/perf/callchain_32.c b/arch/powerpc/perf/callchain_32.c
index ea8cfe3806dc..ddcc2d8aa64a 100644
--- a/arch/powerpc/perf/callchain_32.c
+++ b/arch/powerpc/perf/callchain_32.c
@@ -139,7 +139,7 @@ void perf_callchain_user_32(struct perf_callchain_entry_ctx *entry,
 	long level = 0;
 	unsigned int __user *fp, *uregs;
 
-	next_ip = perf_instruction_pointer(regs);
+	next_ip = perf_arch_instruction_pointer(regs);
 	lr = regs->link;
 	sp = regs->gpr[1];
 	perf_callchain_store(entry, next_ip);
diff --git a/arch/powerpc/perf/callchain_64.c b/arch/powerpc/perf/callchain_64.c
index 488e8a21a11e..115d1c105e8a 100644
--- a/arch/powerpc/perf/callchain_64.c
+++ b/arch/powerpc/perf/callchain_64.c
@@ -74,7 +74,7 @@ void perf_callchain_user_64(struct perf_callchain_entry_ctx *entry,
 	struct signal_frame_64 __user *sigframe;
 	unsigned long __user *fp, *uregs;
 
-	next_ip = perf_instruction_pointer(regs);
+	next_ip = perf_arch_instruction_pointer(regs);
 	lr = regs->link;
 	sp = regs->gpr[1];
 	perf_callchain_store(entry, next_ip);
-- 
2.46.0.662.g92d0881bb0-goog


