Return-Path: <kvm+bounces-31799-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C09DC9C7BDF
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 20:03:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6DA2F1F2465C
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 19:03:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 176E120896E;
	Wed, 13 Nov 2024 19:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="J3ek19d5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FC07206E78
	for <kvm@vger.kernel.org>; Wed, 13 Nov 2024 19:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731524527; cv=none; b=MuACYSQx6v7Mn1KO/K+s19SJeTPsWe629JMe9rF9YOraJdlaemkGt9gVcwcdnKErMweg4LVMD0GZ9qaMpZw3bpVH75Af9BrVct16JbprBklYrWLd4uu+yESiNODlrP+vjyCwjkOhz6fqQOJN1W9W3d13nxL2/xUt+whvkwEoNEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731524527; c=relaxed/simple;
	bh=zfHGGul4boURCIlF9sZ0v7jHEGbHHtIvQPtjpwKmZjI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EsfpzF5xU5ZRm7yz8dZvAggsjwT6hmeoITDkyNl6y5lxcgW1y5LBSC5U1f+PGD5EpbZyUg/PJerGwH7xK3fBHtBRrMMnvxULE8hxma/Ct5V/wDHHfb2swg7VEEhY2eEQiypNYKZqey//uiia4txP4lY2nq/PyoKUmnzkSNw29K8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=J3ek19d5; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e3808d76206so762779276.1
        for <kvm@vger.kernel.org>; Wed, 13 Nov 2024 11:02:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731524524; x=1732129324; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tgqFKvoVHXye/CyIJghap8jc4W684iliK9zLYmCZ1Zc=;
        b=J3ek19d5SzafdyqjgJsw4UrEG6aw3LRaSJM1tbuEUPFryd5x39/u8EijyF+sGNPmKl
         T3XOzhBNeq6AIknh2HQDQO8RNdoPBlmeTcrJXtI14Z/cAxt7+z0ViTpYQ3RbFvxVlHIy
         gm0GC/27X5NwsIYsR1s5b0SaaoG653C+6L91sHUaPSbxaxr3KoY5ij1NIhUjnseI2YlR
         wo7HTwWI8U+ZFcO8NJ7lZ+IShIa9u1F40fukwfGJuE+qKA/OZTiyqldj7wiPnbcTr63J
         K8AtUR+ABYBT+fvfK53nZSP/KtcmvezGoV5XAGJU8Ku0Sy5FKPIcU6XKm53LX0UAlE03
         JdaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731524524; x=1732129324;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tgqFKvoVHXye/CyIJghap8jc4W684iliK9zLYmCZ1Zc=;
        b=QWkwuAB6d6qs4srNEY3htYO97/0O9SrE5kJo/m0geymPw6urGah3+fyZxZs2pqipz5
         CsOgKdYCaA7y5B5uT4AMvFQVExMdWfXz+mkA3CzAjo5u80QmwLMp6UGkDbf/Q0JkkO4d
         54ntYIZe6h8Wqnre2rwBWkFB8mivM3JJ9P1/8Ki6T7jL3GIlOelJdimv/vClxOYUTN2C
         nVZGBUd21bv02o0S7+BQgMZfUQp4J7ZfpHvwpyoGSuEI1SkmDPiTeIN2hWBSgLHu3bcR
         ATqIpD1vURlNpTB3y6krmDdlPqSvqQy3joFdzvSinlciT9IhMfAqF+mzj/g5hYclK+LH
         u9LA==
X-Gm-Message-State: AOJu0YxP02QVyq8Ez/+8erSIh7+9usiik4UxUE8iX5FDOyLGrM8/YwGb
	SdvfI0XXYXM8O9yxsw3Lr4Ht9s5LubirP6egXRNmetjAoC9rjRL5pMxSx2PJ4Bhj0lE7YMgKk4r
	OOp1V1sLUvXuWH5Kk1ktpEcmmkZ4ZbXJ0qr6GjjJmhTwcLOSRRetJhp2HtmzvVKc5FJ1J1d+irO
	BF4S/aVkGTPjgfjN35gfZ4PVOWbSKyDDgAVOB9GCUHbQxSnVnmfKccqMY=
X-Google-Smtp-Source: AGHT+IFNr9w/0dGnK6PRtslGYFp20zZooyO9LSsLAArex0mr+uzyM7no72zQ+L4NJiH7IrVQOwJt58oXd0jflNUvgA==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:11b:3898:ac11:fa18])
 (user=coltonlewis job=sendgmr) by 2002:a05:6902:2411:b0:e38:c40:380f with
 SMTP id 3f1490d57ef6-e380c4039bfmr33947276.3.1731524524115; Wed, 13 Nov 2024
 11:02:04 -0800 (PST)
Date: Wed, 13 Nov 2024 19:01:53 +0000
In-Reply-To: <20241113190156.2145593-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241113190156.2145593-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241113190156.2145593-4-coltonlewis@google.com>
Subject: [PATCH v8 3/5] powerpc: perf: Use perf_arch_instruction_pointer()
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
	Colton Lewis <coltonlewis@google.com>, Madhavan Srinivasan <maddy@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"

Make sure powerpc uses the arch-specific function now that those have
been reorganized.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
Acked-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/powerpc/perf/callchain.c    | 2 +-
 arch/powerpc/perf/callchain_32.c | 2 +-
 arch/powerpc/perf/callchain_64.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/perf/callchain.c b/arch/powerpc/perf/callchain.c
index 6b4434dd0ff30..26aa26482c9ac 100644
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
index ea8cfe3806dce..ddcc2d8aa64a5 100644
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
index 488e8a21a11ea..115d1c105e8a8 100644
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
2.47.0.338.g60cca15819-goog


