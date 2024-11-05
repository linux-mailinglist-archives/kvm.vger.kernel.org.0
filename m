Return-Path: <kvm+bounces-30810-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C7E189BD64D
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 20:57:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 880C6283CCB
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 19:57:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FB142161FA;
	Tue,  5 Nov 2024 19:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FQqo0Ec+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E7B1215C73
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 19:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730836595; cv=none; b=f7992kDdYV1KvGi5zqQMNvipCebcXldnq8aGSx/bTfde7jBwXJhWs3zodK6mEEFb1k6wXoyRCdo7X/P75GHIF8HKiaVPJs+OZJ/Vt/Ke1k7/mv+OkkHdiT8gf8K5azlRO9yNPD8wiaI4Y4qdzuX1xN1agg8ak5njukZ3WSzaj1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730836595; c=relaxed/simple;
	bh=wSz2wg4Whtfo/EFpwfiSjTtt4Xe91rIimgScnrimpn4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NlSzAObZwGt0UppgUfoQAs4Ub8eG8CpP5K/0diVv0EUIOzR9PU1AwqndoDjR1F/SzCtISf7ZgHbGHlQmu9A6eAreywcI+aRbmFwc24u/3gac4KSJm/8NOeO6JHrrECQ9lwoQskviK+VJ2G4XqpRBQLhMJClLawN2kU/jO6ov+Ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FQqo0Ec+; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6e38fabff35so103802937b3.0
        for <kvm@vger.kernel.org>; Tue, 05 Nov 2024 11:56:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730836592; x=1731441392; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=sW1pAHD8RX7fvQhBgDL/ivZoJ4MMiFBudzlwbhbqZhM=;
        b=FQqo0Ec+hHd93ayT2azT+kPq4whnCYy27uq61IJFChMD09/8NELNvKIC42NigwCK6y
         n2XKmNDLBRQkoIYPMsE9oWOT+7Nrbl4y5e+dGZefFhav6tIPSXHTUbv7mlYgwO2V1hTI
         YABZZHCFoXwK2qm3my6Ro2fpD2Drg/D2RnRj+1F+ew3OL+sCt0VXpG4gzxJ76Yv8c9V3
         4OE8hiJZA9+ZaYxAiNVPhUYziBQMRm8XBdeUQ+LigSEafNnTPNUDZDaoHn8dqv4oF9YV
         LAKFaDIqF/K6OOPLeORRr1NBNJIW3r4JSIWfle+LBj7cfJQhKgC6VwSVDKMdyV2XbB21
         0ZKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730836592; x=1731441392;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sW1pAHD8RX7fvQhBgDL/ivZoJ4MMiFBudzlwbhbqZhM=;
        b=Wj8XdXai6AZwXHeKd0HBvu54eSX9zQ36EKN51SEZ7s3L4xlEdsXIM5OcsHfg+QUxCB
         Sm8FO/MBk2Gv9SOW82UZz97/6BTh1Kh1jFe4fZaihxfE+/DscLYf+kPaPG222Ysakdr2
         k6//Uw6reeSODuzP/H0oikpFIVWL/sObdPTp9r1arjJZjucH+2LUyqN1aksNHo34NolL
         VPJ2lppEOnb4jyquE//dxkLHoTP0YJrjZMQZPJfhU2ifychlcOzdRziYV0K/aXiFlJGZ
         oMRl4/8MH5kQeiNM79Z2fGzkGweenx7xHVWTZjGq7kPyndmcNPZs9rrD0+Z8xZRxi3vH
         AMSA==
X-Gm-Message-State: AOJu0YxHlEuUDfiWADFuiBPqQSp0JpqkvcWgrViggfQEf/AHeu1obUMq
	Zo/8hNIUcFV7tx0isdhPzPZQmuVn4quCsVm7vIBk7z1dsAG1A3ORMUQ0+sLYeReK/hZNU/y1lMV
	qHgRwaFODRlrOuZcgrsm8WevVvNSX74sY0CWbzB20HkPVkJVMmnUOHlmdKDviX3M91qFSJ7MDZm
	ZXyM8vFoe19IsdpWE+URC0rQz0tiTVOPXXjBUVrXKJJoVvPHZgXcRVXnk=
X-Google-Smtp-Source: AGHT+IFe5esZfmV8PpNtTKhf67GNSznritdlgCuivBreGx7Lwrw/eQ/PIB8HLPh/Mq6jxCM85J+7ZrWnfVuJw3jbsg==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:11b:3898:ac11:fa18])
 (user=coltonlewis job=sendgmr) by 2002:a05:690c:4489:b0:6db:c6eb:bae9 with
 SMTP id 00721157ae682-6e9d898f08bmr17263797b3.2.1730836592357; Tue, 05 Nov
 2024 11:56:32 -0800 (PST)
Date: Tue,  5 Nov 2024 19:56:00 +0000
In-Reply-To: <20241105195603.2317483-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241105195603.2317483-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.47.0.199.ga7371fff76-goog
Message-ID: <20241105195603.2317483-4-coltonlewis@google.com>
Subject: [PATCH v6 3/5] powerpc: perf: Use perf_arch_instruction_pointer()
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
2.47.0.199.ga7371fff76-goog


