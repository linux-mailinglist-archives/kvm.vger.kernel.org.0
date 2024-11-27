Return-Path: <kvm+bounces-32622-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A8DE9DB020
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 00:56:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2E444B21616
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 23:56:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BE0D1991C8;
	Wed, 27 Nov 2024 23:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="A3VrN+Pr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2421515E5CA
	for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 23:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732751791; cv=none; b=Y0+LbumOhavTE+XPeRCI6oKj364fBG2hO/La8ptsWCfop3Ie/A1OYK9e7C1bitydEsnSrP9m9jGFrqKbq6FD/r14xpZ3tUkFmczfmUlc7C/3rj7l/CnoZjfmcEie33ocjs4aZuopj7hpuZVWFUk6X2vfjJVqWam56uKJ26hZUyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732751791; c=relaxed/simple;
	bh=5w3tXEfpo9pqP3sWqwOJwR1PqviyBGAGGYvcFK/szxE=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=hW5tR7NOou+uoExLEcLtXHMnop/UYBzAsKvnU0EtxLfpuHj9L28ripb8bgyF4DdmHmRgPbdMxiFeUBf+QsOAscnOF+8lYW5J5FwUfP6UmoDQcawJ0yMWLGmM77JhbKIpGxumoeveYlpyb84BIZmZMGK3O/ZukhEJj6BnFko/Gi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=A3VrN+Pr; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ea396ba511so306076a91.3
        for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 15:56:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732751789; x=1733356589; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IUjYtrXQYviAFJPlV6rDA0QXqWM4eRKUdwjyydmGs50=;
        b=A3VrN+Prtv2entPxOOLjGgD+/nVX6cNAT8Co3jFFausk0SMMzIf/Sx86BooTT+3Uc5
         fdvTwkWrNJdEFPMsRxakaGF3Kb1gDxrjmuyfYuuZh+xQPiBG0rEY+M8fIPjLgBDpTexc
         9azBcwyEodzEh2e2jsuN/zQ6KudPzwCrHW/drP0RuEVmkoQD5SnySX+zg7dZ6etrut/T
         5XLasV3DBRi54iiELUKYIKsMEouT6+yLWd+2KMIGvhaZt1X0Hz722JaOAXTC7cZecOZO
         SE1y1S6o9Won3yXrRgOls72+G52AFmuLVfSUDgN38TsdCN6SDJ76OxIsJZQbW+UVcm5J
         i/oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732751789; x=1733356589;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IUjYtrXQYviAFJPlV6rDA0QXqWM4eRKUdwjyydmGs50=;
        b=XXGu0z1V7BUaI/JDv7o72fXwhKZsVx/g5p8TD0pT/ctO1A4dvYEhb0bOOybqybLROI
         5cKMfrnyPSKlgzyAtxaz9EyJ9khHNt5cDJ0O1Z9wxlhRJt4FPhRXvf5J7DNZj0v0O/+f
         v1n0HONPgcAo9+C5ocVTnZLPC6cfjI+2jZN7c6FUwggXP6DbiO6uw6hISgoE+7mVv9rp
         fPSg+Xd+J2gjhTQ2LndurCqgiBauXnvF3XJ4dEazC1ZsYl9HnjvZQPIj74/0GENmJSZE
         pXFhF/5dOG6ONcIPFfa6qUuiCfwBKh0JTF91X1H3kv9G2kC4V53rww2HL2vsGlL8o7zR
         U8Xw==
X-Gm-Message-State: AOJu0YwCLYQ4eBuVv++7xjES6CLWnG21N6r1ZpjFlQ51VoPjV2KSDe0Y
	4A+/xrtZQTzf0L85itXCuhUPu1rF3753CzaaByTz0/wQlcyMBs7DzZ2CirZNT+3xrTHMUyT5N7a
	fGw==
X-Google-Smtp-Source: AGHT+IHPTR3iWge3xhiU4XEekgqj03rdjRMWQnKnjuG0mueDT2UvjYmNwZ5lFL1tB4Ijj6JiY1HtjbZkmH0=
X-Received: from pjbsj2.prod.google.com ([2002:a17:90b:2d82:b0:2da:ac73:93e0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4b8e:b0:2ea:696d:732f
 with SMTP id 98e67ed59e1d1-2ee094caf27mr6418337a91.29.1732751789406; Wed, 27
 Nov 2024 15:56:29 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 27 Nov 2024 15:56:27 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241127235627.4049619-1-seanjc@google.com>
Subject: [PATCH] KVM: selftests: Use data load to trigger LLC
 references/misses in Intel PMU
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"

In the PMU counters test, add a data load in the measured loop and target
the data with CLFLUSH{OPT} in order to (try to) guarantee the loop
generates LLC misses and fills.  Per the SDM, some hardware prefetchers
are allowed to omit relevant PMU events, and Emerald Rapids (and possibly
Sapphire Rapids) appears to have gained an instruction prefetcher that
bypasses event counts.  E.g. the test will consistently fail on EMR CPUs,
but then pass with seemingly benign changes to the code.

  The event count includes speculation and cache line fills due to the
  first-level cache hardware prefetcher, but may exclude cache line fills
  due to other hardware-prefetchers.

Generate a data load as a last ditch effort to preserve the (minimal) test
coverage for LLC references and misses.

Cc: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---

As alluded to in the changelog, if the test continues to be flaky after this,
I'm inclined to remove the checks for LLC references/misses.

 tools/testing/selftests/kvm/x86_64/pmu_counters_test.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
index 698cb36989db..b05e262f9011 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
@@ -17,7 +17,7 @@
  * Number of instructions in each loop. 1 CLFLUSH/CLFLUSHOPT/NOP, 1 MFENCE,
  * 1 LOOP.
  */
-#define NUM_INSNS_PER_LOOP		3
+#define NUM_INSNS_PER_LOOP		4
 
 /*
  * Number of "extra" instructions that will be counted, i.e. the number of
@@ -162,13 +162,14 @@ do {										\
 			     "1:\n\t"						\
 			     clflush "\n\t"					\
 			     "mfence\n\t"					\
+			     "mov %[m], %%eax\n\t"				\
 			     FEP "loop 1b\n\t"					\
 			     FEP "mov %%edi, %%ecx\n\t"				\
 			     FEP "xor %%eax, %%eax\n\t"				\
 			     FEP "xor %%edx, %%edx\n\t"				\
 			     "wrmsr\n\t"					\
 			     :: "a"((uint32_t)_value), "d"(_value >> 32),	\
-				"c"(_msr), "D"(_msr)				\
+				"c"(_msr), "D"(_msr), [m]"m"(kvm_pmu_version)	\
 	);									\
 } while (0)
 
@@ -177,9 +178,9 @@ do {										\
 	wrmsr(pmc_msr, 0);							\
 										\
 	if (this_cpu_has(X86_FEATURE_CLFLUSHOPT))				\
-		GUEST_MEASURE_EVENT(_ctrl_msr, _value, "clflushopt .", FEP);	\
+		GUEST_MEASURE_EVENT(_ctrl_msr, _value, "clflushopt %[m]", FEP);	\
 	else if (this_cpu_has(X86_FEATURE_CLFLUSH))				\
-		GUEST_MEASURE_EVENT(_ctrl_msr, _value, "clflush .", FEP);	\
+		GUEST_MEASURE_EVENT(_ctrl_msr, _value, "clflush  %[m]", FEP);	\
 	else									\
 		GUEST_MEASURE_EVENT(_ctrl_msr, _value, "nop", FEP);		\
 										\

base-commit: 4d911c7abee56771b0219a9fbf0120d06bdc9c14
-- 
2.47.0.338.g60cca15819-goog


