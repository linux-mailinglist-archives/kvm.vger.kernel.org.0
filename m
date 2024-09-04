Return-Path: <kvm+bounces-25909-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BE8A496C8C4
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 22:43:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3F2631F26902
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 20:43:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52C9917BEA7;
	Wed,  4 Sep 2024 20:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="C50Rg7nT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB09A15532A
	for <kvm@vger.kernel.org>; Wed,  4 Sep 2024 20:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725482553; cv=none; b=BQpVQXj82wAoqYatmfVtp+2zyCgFjF2dNbqJkdnl6640rfqzATNP++F0kjdNMAPmORtMF8W5718AttAxPhgQyh1RintsjbNLjRgCwToii16K/N109gGooE/QvyR57JJN0oThlUHSZu6lRPiexliE7X43kg7yZnk6N5ePDh7Qni8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725482553; c=relaxed/simple;
	bh=DY32o9P9BJrjFnl8SkC7+4pBAbM3HVwNyOI1WxXRIXQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=J3jIm6STtuEF9R47iX/2sk8YrMByk0lUaEUtVQXG1bcJmKDEoKvIeuJp0bew5nImI+VgtGNrhg5cHHiObqXbxuxxlrAcjq9kIm5NUNvfyPWmr48wxLsjUh1osXr+3w3g+/6WqUJEXvijxLrXfZ4W+shLjVExemAkPVVMeMO5jmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=C50Rg7nT; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e178e745c49so120344276.2
        for <kvm@vger.kernel.org>; Wed, 04 Sep 2024 13:42:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725482550; x=1726087350; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yF63B/qB2C2mWkkN7Sev/IpM9OI4DaouC6axCITdljM=;
        b=C50Rg7nTBZSb8MMUJDA9stanU2xYM4H0Cfl7ZqLyvXzpwLG33aRD7QoPmKl6wVSTex
         UtcIGUt961JIKyqinz3uh/FJjSofPGkq6WDCPib1GWGqRJKr9QC7RJ/eOLuGBvfn30kx
         OZtsGOKG7TjWQuSaRl7L9GDTq6gQmEjEORIXdJ6KfRoCGWEKAvoD/4P7itHx//JHKslq
         nTk+ryBu+gvWQOejztOei8DntlzWmrwQSO90UO/2CKsC/2SxVo08rBsZRtysvdfg6epz
         bEpAzslzhjv8GEgIm0wj/j90Xq4HtChVhtIRYft+9PGfaumoqgCWzPVpB/ddLZExbfWj
         7dnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725482550; x=1726087350;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yF63B/qB2C2mWkkN7Sev/IpM9OI4DaouC6axCITdljM=;
        b=do+J1Z4Yz/V6oCnTkQ0v9JJtMi46Lt/BZcoyDahZ68xZ57JD4Ct4jA6M8uvMRhVVCm
         a+btdX/uxF+5Ssx/+IfVBEJV0n5kcIX+c8FTyGI63JWZXyyRcIyYW1NUwfc0TEC0rU34
         yj0BT3Tdq1or0jCX55oA+IfsaVuzSRz0iNAsW40QIG65Ce+3d7510Ryck7Ke4+4dB1kq
         +XPPpLEUFA/qR0+I9hcn8EZZnk4TCGprx6VSkUl/I2yaj275oK3A+NbXk3UybQUT83ly
         SHjtKDWbud94eFr6rPSaXCbPbyOlup2lIV5pQ3hyrVl9QdPTX+3STv0DKWWNtsClEdSP
         gK5A==
X-Gm-Message-State: AOJu0YxrdCiTmkm2zWRO98VaTeOFhUDYtakUHP290dYqUhJRvgUar64L
	jxv6eYUV+61NGRpZDdY+6jMtJIMczeWdKaiweaB9yCEhWD+RCj9r1VM+K8LfK4+bA6/IXY1qLBY
	BuEApsed5Fif8fbKDetd4xUQxclkfdzZz/+HBbBs/5ouCaakbE+JQiBX4sWDchpp0nbh6xzByQy
	ArwHWGoxVGwyPrc+a1GA4cMIeeAmZMVocLnBOdnayudWP5vfwPT5D48ls=
X-Google-Smtp-Source: AGHT+IHnCAVHhUCP2jsg9QIrX/diUprCN0SQ2aen+GiK4qTsvqjsoiEZxfc39AEm13a4QPmtILTk2j9/pAbTWP98xg==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a25:b612:0:b0:e0e:499f:3d9b with SMTP
 id 3f1490d57ef6-e1a79fb4d7bmr28585276.1.1725482549203; Wed, 04 Sep 2024
 13:42:29 -0700 (PDT)
Date: Wed,  4 Sep 2024 20:41:31 +0000
In-Reply-To: <20240904204133.1442132-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240904204133.1442132-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.46.0.469.g59c65b2a67-goog
Message-ID: <20240904204133.1442132-4-coltonlewis@google.com>
Subject: [PATCH 3/5] powerpc: perf: Use perf_arch_instruction_pointer()
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
2.46.0.469.g59c65b2a67-goog


