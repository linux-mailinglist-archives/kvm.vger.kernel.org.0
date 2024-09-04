Return-Path: <kvm+bounces-25910-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AE29696C8C6
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 22:43:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D29EB1C25900
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 20:43:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0E3A1E6329;
	Wed,  4 Sep 2024 20:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4S+wh8uN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43E7B1714AA
	for <kvm@vger.kernel.org>; Wed,  4 Sep 2024 20:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725482554; cv=none; b=tqmyybOKlThsEJiPMH2qOGX7LKCj2w2RoK/pU4FptnK1gFEfcyvdUiJaLpaSMvypmarXsQ9aPunEG5f+mKY05uTw/uOXsf00HePNJ9IU350qrtE5tw7Ah+A9piwDdfOT8Wlo7smDAmESpoQcpE7uOaRLhJ2AcJbxG3GxRCh8vTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725482554; c=relaxed/simple;
	bh=03a6lGwIb8EWUW/4KBYQo75tG5sBT5AYfr3dT9mgeS0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=reIiPZbBvdBkL8Wv3Jt2vfdiYb0LlCX33ldrHCOj8gfh/0yqm5f2OnSfkgMHHxduFYFxDPssI/+65oQ08FaIpikFgremBNQ2d3uvK5XgXsrmprf7YQJ2gxYtL78IGRUiowfH75OvMUffniJUkRtin8wZsCIWQzI6KNLcS6eAJ/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4S+wh8uN; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e1a892d8438so184264276.3
        for <kvm@vger.kernel.org>; Wed, 04 Sep 2024 13:42:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725482551; x=1726087351; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=i72PSOIXWhCeY4HgM9YgFlmZggdii21Cl4McUfu+68c=;
        b=4S+wh8uNZ3ym7p8zyrL46a8R8YwwDozrfeoySjY8kWPmyxGdbsIe4FIvvBsajmBuQi
         mjP61vSG8qXdW9ObKBqC9CuoP2JI6oNPrlnpOlyHHSgtgbn3bJRN1aDcCJzL2QyhpKnL
         ACwv3DVuq/x3JUWDfa0Zfc/xiglVxr0otDl4tQc8wlH0MVd50Llrk8rVXoIIY2uQ25E5
         6mDmvJPqH94d34n6xTVBjvyAtLFpdAQ3nptw0aYrnBDjL0qOfTU6GrVfS9Y7VL2nA6qR
         zr4CJeOC7dCCD8ynMlJTbe3nnLvsgRKb4TZ9jwPAtAhmkRnYRLQDtJjYSszmVkwQd7Ou
         mriA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725482551; x=1726087351;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=i72PSOIXWhCeY4HgM9YgFlmZggdii21Cl4McUfu+68c=;
        b=NZX10P940ZoiBopovEh1Cmi1Q9kFRS9kALAsgTA3/Gknei7PeKlh0d+NDEEveUHh1R
         HdTrpxymc3DPOFaPDAcwmFVPZgmAFk1fsLas4OKRNpv98hqWWSOd/0hljUeAJNLnKcxp
         f+CeXslrHMdFWu+4qnie+rHjiDCPzmDQ9JxGhNCFgF+vB6gi6aRy60/lr+r9sUUhuhe3
         KhUpQFrpmPr6YA9xum1o4O5SVbyLDMLqr18PO17Xxa6VfaY8RGNHfCrpr731nmY3Swkk
         0xrebHVyzSkXeQfHQNACvyYBvcSUvgFP3K/BMftHNBCRdaOiqRvWRzVKKmry6DXfGP+v
         H03Q==
X-Gm-Message-State: AOJu0Yz3b7IKxAfjjZYC/mFcn37ytR0H2ziMbHIaBMru47QxRCRBHWDU
	uRysHSNqVKOCwuUbKGTdwEkxS5+WZM3GQybreaOR9NB+xonP3F45K8OZEGUT8MNLDGaHfju3Qd6
	YryjL+uqhl5zAtQCDhYl897C43qaAFQRUiOaxS9CS02k3JLFhFhObSFRU06M69TZLJjBSE+HqB3
	mZ2qaXvUdmjb/BE3iNRvtpvKdcSTOwE+AdH78c93hyo18y7EurhaJgx5Q=
X-Google-Smtp-Source: AGHT+IFmR24uVrOJthtOJz6K2WVb+jtHXjG+hacdDNR8Ql4EFrmp0GPrZ3zw2M5BxgYPY6TLAf+W8lj+BLe1iw09KQ==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a25:361a:0:b0:e0e:445b:606 with SMTP
 id 3f1490d57ef6-e1d0e58575emr4988276.0.1725482550264; Wed, 04 Sep 2024
 13:42:30 -0700 (PDT)
Date: Wed,  4 Sep 2024 20:41:32 +0000
In-Reply-To: <20240904204133.1442132-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240904204133.1442132-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.46.0.469.g59c65b2a67-goog
Message-ID: <20240904204133.1442132-5-coltonlewis@google.com>
Subject: [PATCH 4/5] x86: perf: Refactor misc flag assignments
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

Break the assignment logic for misc flags into their own respective
functions to reduce the complexity of the nested logic.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/x86/events/core.c            | 31 +++++++++++++++++++++++--------
 arch/x86/include/asm/perf_event.h |  2 ++
 2 files changed, 25 insertions(+), 8 deletions(-)

diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index 760ad067527c..87457e5d7f65 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -2948,16 +2948,34 @@ unsigned long perf_arch_instruction_pointer(struct pt_regs *regs)
 	return regs->ip + code_segment_base(regs);
 }
 
+static unsigned long common_misc_flags(struct pt_regs *regs)
+{
+	if (regs->flags & PERF_EFLAGS_EXACT)
+		return PERF_RECORD_MISC_EXACT_IP;
+
+	return 0;
+}
+
+unsigned long perf_arch_guest_misc_flags(struct pt_regs *regs)
+{
+	unsigned long guest_state = perf_guest_state();
+	unsigned long flags = common_misc_flags();
+
+	if (guest_state & PERF_GUEST_USER)
+		flags |= PERF_RECORD_MISC_GUEST_USER;
+	else if (guest_state & PERF_GUEST_ACTIVE)
+		flags |= PERF_RECORD_MISC_GUEST_KERNEL;
+
+	return flags;
+}
+
 unsigned long perf_arch_misc_flags(struct pt_regs *regs)
 {
 	unsigned int guest_state = perf_guest_state();
-	int misc = 0;
+	unsigned long misc = common_misc_flags();
 
 	if (guest_state) {
-		if (guest_state & PERF_GUEST_USER)
-			misc |= PERF_RECORD_MISC_GUEST_USER;
-		else
-			misc |= PERF_RECORD_MISC_GUEST_KERNEL;
+		misc |= perf_arch_guest_misc_flags(regs);
 	} else {
 		if (user_mode(regs))
 			misc |= PERF_RECORD_MISC_USER;
@@ -2965,9 +2983,6 @@ unsigned long perf_arch_misc_flags(struct pt_regs *regs)
 			misc |= PERF_RECORD_MISC_KERNEL;
 	}
 
-	if (regs->flags & PERF_EFLAGS_EXACT)
-		misc |= PERF_RECORD_MISC_EXACT_IP;
-
 	return misc;
 }
 
diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index feb87bf3d2e9..d95f902acc52 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -538,7 +538,9 @@ struct x86_perf_regs {
 
 extern unsigned long perf_arch_instruction_pointer(struct pt_regs *regs);
 extern unsigned long perf_arch_misc_flags(struct pt_regs *regs);
+extern unsigned long perf_arch_guest_misc_flags(struct pt_regs *regs);
 #define perf_arch_misc_flags(regs)	perf_arch_misc_flags(regs)
+#define perf_arch_guest_misc_flags(regs)	perf_arch_guest_misc_flags(regs)
 
 #include <asm/stacktrace.h>
 
-- 
2.46.0.469.g59c65b2a67-goog


