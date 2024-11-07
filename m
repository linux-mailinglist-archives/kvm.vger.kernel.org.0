Return-Path: <kvm+bounces-31148-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DF1969C0E4F
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 20:05:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0EAE71C220F5
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 19:05:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 299212170A3;
	Thu,  7 Nov 2024 19:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Lb/QGDWn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f73.google.com (mail-io1-f73.google.com [209.85.166.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FA12217910
	for <kvm@vger.kernel.org>; Thu,  7 Nov 2024 19:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731006270; cv=none; b=UFPwtMR/x+X4dKFZYf9g9EEXoqirfdloNgiUcfaGxAyNrQJMr2XPzLjpzdYVuKup7zKgQ2OdIoe7j/oFDGyMaZHdlAJt0pHeeHn/D10z4T5VTKdNwLSv0Nk2uVo77077emVefDf5w8Vkjn/X5yIxfs72HtdQYzg8TtL6pxrKuZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731006270; c=relaxed/simple;
	bh=KDOpYvQvaexnS4ROlfUY/AOVb+PMrJotsVbv9tdnmmk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=AqIVsgRnZC+syuZP3o9MpGo/1SGiXHG1r5f8jsrT9QF+A8ipzdf0bXjHAjkdWj8FNoedYXSGL1dB2v2nJmrxHgOXmQ3YTzDsZr1/bzFSNkYTA6F4zp+sJpDVU2hlF09CVnVPNk8ykI+LbTxW8na7jgLzEal2OTaPTnYCZORXLjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Lb/QGDWn; arc=none smtp.client-ip=209.85.166.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-io1-f73.google.com with SMTP id ca18e2360f4ac-83a8c0df400so142190939f.1
        for <kvm@vger.kernel.org>; Thu, 07 Nov 2024 11:04:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731006267; x=1731611067; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=z8sUtURqCyFCOn8JOOFBrrh4KEoVslcfr90vq+LFgUg=;
        b=Lb/QGDWnLPqNIYp5cyBBAcApr667uZhyLg2fTzDMJsDrrs1HWoIdKtXf6ltPzIKOtQ
         0bq8NWVYL1ehknHtwM2sRvdIsZpbxpWfTyzSCn6GyFYyJlPK6US3IEr+m999I7EUAe2+
         WbTJ5h/ERzD+NnbeR3RgIIASHkiIiZcLotDfQlj/pS5wlhDHLfeowpTi5UguVmez9Qg6
         k1N//SkjZUGPSXNa7Jrcx5Dg/NB5ZZc+gQPtJAN8JO6B0Pxx6Ftf/5dIBi5gAemStEu6
         CJwlj2zQk5YJjPxwguiEvwZMqLvuSssyqEhnoV/cpF4wmcvbbxnGgicXdoKvB/WzoFjf
         ONsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731006267; x=1731611067;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=z8sUtURqCyFCOn8JOOFBrrh4KEoVslcfr90vq+LFgUg=;
        b=h2Qg1l+0+EtNf+/00T+bVpVOY+ObvOFUoZ+ioKER6xVqimnhBSiXl8CxtlqG5feCvv
         yKs7q2sZKyyDlwaG0x1torXH0ddzgFOKC/mGcPU7FiASSW9cgbItHDL5MqThBAo+ONZ1
         CKaqBrbhl4V0mTDEqJ5ieNIum6GsSmD5PgM6zigLWaNzydnq8p3yDdvbMIElWQGEVSaJ
         OrubtAHY5xCMb5+XbzK97eYjHVjoHDpEjMR1uAqANlP16Rc8Z4hJQossUIMafe116JZl
         NKgt88WcOVUoPhKrNl2tQnFCn4frb9wIF/o7tQH4GGMQPSN1AXSURUkWWG3Rupz+V4nl
         VSxw==
X-Gm-Message-State: AOJu0YwlsUV/HCsoNLfj45sQfvBZ5hsUzPRZrisXupkQnrLEgUVagt7A
	BIjPeKDCn/NMHUh+4+KwlzTQp72zoX+HopROOl19P5mKV9Lo1GlVxD0UC0GSHcE4yy4nYoXYggG
	GCdxHor98nQNQxVvEOvoP/UIsu3NmfMVbumSbdE0C3177PrmtL/eXwKWbPH3Dj29QLoewSBga2R
	3sU+i21Fcyh6Kql6UEIsWL3sjrUUZ0ldr17QtKJaqaDMjCuTwU2u5FHjw=
X-Google-Smtp-Source: AGHT+IEPRr/IQdodyqcpTfvB5PFu6DqvhssHdY7ZGS0GFH2h0T2KiHTqbilJA81LBD/MlyV7/G5K+PfGhK0HNCVbEQ==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:11b:3898:ac11:fa18])
 (user=coltonlewis job=sendgmr) by 2002:a05:6638:890d:b0:4db:e85c:f17 with
 SMTP id 8926c6da1cb9f-4de6a5fdc31mr24173.4.1731006266688; Thu, 07 Nov 2024
 11:04:26 -0800 (PST)
Date: Thu,  7 Nov 2024 19:03:34 +0000
In-Reply-To: <20241107190336.2963882-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241107190336.2963882-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.47.0.277.g8800431eea-goog
Message-ID: <20241107190336.2963882-4-coltonlewis@google.com>
Subject: [PATCH v7 3/5] powerpc: perf: Use perf_arch_instruction_pointer()
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
2.47.0.277.g8800431eea-goog


