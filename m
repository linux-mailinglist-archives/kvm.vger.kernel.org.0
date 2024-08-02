Return-Path: <kvm+bounces-23103-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A0A80946331
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 20:28:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 566CB283330
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 18:28:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47ECD1AA9FA;
	Fri,  2 Aug 2024 18:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LcyhGZeJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f74.google.com (mail-io1-f74.google.com [209.85.166.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E853B1A7048
	for <kvm@vger.kernel.org>; Fri,  2 Aug 2024 18:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722623013; cv=none; b=osrKpVSDrz45LEOrQuH/Xzi+kQvOinxxWJVjBNzIajbCkMh/SK7B1DCHky5Ge6H1lYGMASSVVwQ56mZbTL6SVsNQfhcF40/MQwJO3byNJwCJEWGJ2Lzxbnwpq9r5MtT/avQYemfQ6Ky7xuIwypQZujJb9CP8ecjzg6w4XtLP59c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722623013; c=relaxed/simple;
	bh=tgoIWaFUxQM33b8qbHZPnhnEYawHBB93RkKWU1DvJ5U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JoRdeCkc3vTgYhDs1E6gg+FtQwZ3CaG2YyCh1iCaGkJVwhzGAG1rZMLZG9S4x+o8q51mGNYSaFq49Z8bx4OGXaBFZ1Bp9Idj/MgB5dxql0lvj3Vc3jBb2s45q7z9FuARi01iNOftAwVQY552iw3LxWOHP7xjAlmkw5RACdBx0Qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LcyhGZeJ; arc=none smtp.client-ip=209.85.166.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-io1-f74.google.com with SMTP id ca18e2360f4ac-81fa12a11b7so941886639f.1
        for <kvm@vger.kernel.org>; Fri, 02 Aug 2024 11:23:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722623011; x=1723227811; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=TPSm5NDWiDpCdwUb4qZlzg9JxWn3iBSQZ4jPnuSz7Zk=;
        b=LcyhGZeJwk56GBN/EP4/Wq6x/gixCHn+xbY0DrUv+pNUrIkSm1J9Ejx5zztxpkJSfI
         1Ft3wP7iRQJGoZrdI7HD/UF9Yu8aM8EvYfynFAjWej9bJktjTETPDTXaOTLyfx763oVb
         y6/PIuc2NFT9xc+eCPiu7z+jtBH0B7QYgLsQ3Abwb/XQHJ/Un3qME3U3v9D+x53af5Wm
         cOLi0SYPEDp5a1zteAQBWJW8EV+TOlA9zBqriot9eQzdmp+vEVU2BndMxiX6aUj6Xxvg
         bsNYnihQz+903gt9O7V0aHxeHnsAtcDJmyPor4esn8WOyHJg7Jv/mX8a3+x/IDEKcqqU
         Yxhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722623011; x=1723227811;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TPSm5NDWiDpCdwUb4qZlzg9JxWn3iBSQZ4jPnuSz7Zk=;
        b=Zd53+cHrcXzDBGVrPpDktdyc7Dn1fpAxLBbr45SVkjWpIfuyO2Z1ldCLhO+nMjQWbH
         qMeCdI0P3WfKJNTKsXWYqrXLLCmsgSi+wCCNHWsFp0WdpAvK1OUV0gSrGhzJvufmS+r+
         DOFKd9b6QAAZOwKRmKH9Uzc7jfqZ1TOpvobyrtQwmhI+7xRQz/gn2aRcSEikkVCMT9Go
         S3iMQsM7R+940FhNBOLlnKHilNthKX2BMsO8XZaxcgGkicoMy5rKT6iQqDUAkD0PlRdO
         ur7F1tYkky3JLaKiORSS6To02haSpAIE7jNoX/aHairSt3Ib2zd6LN+BZqF74Af6e3EX
         pIvw==
X-Gm-Message-State: AOJu0Yz1HOqwUTmdZS0Zz9svUyKX8Y2+KkpJ0fQ2dUpqhlN8RDBDAvJp
	7F6FBUfKDv+18GGRvKmzpYpXv8kixur+7YAdiWoCltai09hQrJCq8PDHghrShw+Xtpuqxbdl/tP
	+Zd/czyzCzxnVFpDkXV4c0ju751VxJgkJfQ+usnLPvlX3UMpYvp8xsK3IPblb/5DplSf0ahb6yq
	baPzYRbk7CT7CAVtwVkDQwrxCO0epnPdLTHos3FdzgsZgtj8MPlNUuhf4=
X-Google-Smtp-Source: AGHT+IGsFTuzpN6+gjclXj8JUDgT+VULd2GmamyAkeXPWpy0H9xcVwD8Jmzh08GAnse9QMclSk9M4TynhXIDCWzm3Q==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:6638:410b:b0:4c2:7945:5a32 with
 SMTP id 8926c6da1cb9f-4c8d56c392amr239836173.5.1722623010994; Fri, 02 Aug
 2024 11:23:30 -0700 (PDT)
Date: Fri,  2 Aug 2024 18:22:40 +0000
In-Reply-To: <20240802182240.1916675-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240802182240.1916675-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.46.0.rc2.264.g509ed76dc8-goog
Message-ID: <20240802182240.1916675-7-coltonlewis@google.com>
Subject: [PATCH 6/6] KVM: x86: selftests: Test PerfMonV2
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Mingwei Zhang <mizhang@google.com>, Jinrong Liang <ljr.kernel@gmail.com>, 
	Jim Mattson <jmattson@google.com>, Aaron Lewis <aaronlewis@google.com>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Test PerfMonV2, which defines global registers to enable multiple
performance counters with a single MSR write, in its own function.

If the feature is available, ensure the global control register has
the ability to start and stop the performance counters and the global
status register correctly flags an overflow by the associated counter.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 .../selftests/kvm/x86_64/pmu_counters_test.c  | 53 +++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
index fae078b444b3..a6aa37ee460a 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
@@ -750,10 +750,63 @@ static void guest_test_core_events(void)
 	}
 }
 
+static void guest_test_perf_mon_v2(void)
+{
+	uint64_t i;
+	uint64_t eventsel = ARCH_PERFMON_EVENTSEL_OS |
+		ARCH_PERFMON_EVENTSEL_ENABLE |
+		AMD_ZEN_CORE_CYCLES;
+	bool core_ext = this_cpu_has(X86_FEATURE_PERF_CTR_EXT_CORE);
+	uint64_t sel_msr_base = core_ext ? MSR_F15H_PERF_CTL : MSR_K7_EVNTSEL0;
+	uint64_t cnt_msr_base = core_ext ? MSR_F15H_PERF_CTR : MSR_K7_PERFCTR0;
+	uint64_t msr_step = core_ext ? 2 : 1;
+	uint8_t nr_counters = this_cpu_property(X86_PROPERTY_NUM_PERF_CTR_CORE);
+	bool perf_mon_v2 = this_cpu_has(X86_FEATURE_PERF_MON_V2);
+	uint64_t sel_msr;
+	uint64_t cnt_msr;
+
+	if (!perf_mon_v2)
+		return;
+
+	for (i = 0; i < nr_counters; i++) {
+		sel_msr = sel_msr_base + msr_step * i;
+		cnt_msr = cnt_msr_base + msr_step * i;
+
+		/* Ensure count stays 0 when global register disables counter. */
+		wrmsr(MSR_AMD64_PERF_CNTR_GLOBAL_CTL, 0);
+		wrmsr(sel_msr, eventsel);
+		wrmsr(cnt_msr, 0);
+		__asm__ __volatile__("loop ." : "+c"((int){NUM_LOOPS}));
+		GUEST_ASSERT(!_rdpmc(i));
+
+		/* Ensure counter is >0 when global register enables counter. */
+		wrmsr(MSR_AMD64_PERF_CNTR_GLOBAL_CTL, BIT_ULL(i));
+		__asm__ __volatile__("loop ." : "+c"((int){NUM_LOOPS}));
+		wrmsr(MSR_AMD64_PERF_CNTR_GLOBAL_CTL, 0);
+		GUEST_ASSERT(_rdpmc(i));
+
+		/* Ensure global status register flags a counter overflow. */
+		wrmsr(cnt_msr, -1);
+		wrmsr(MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR, 0xff);
+		wrmsr(MSR_AMD64_PERF_CNTR_GLOBAL_CTL, BIT_ULL(i));
+		__asm__ __volatile__("loop ." : "+c"((int){NUM_LOOPS}));
+		wrmsr(MSR_AMD64_PERF_CNTR_GLOBAL_CTL, 0);
+		GUEST_ASSERT(rdmsr(MSR_AMD64_PERF_CNTR_GLOBAL_STATUS) &
+			     BIT_ULL(i));
+
+		/* Ensure global status register flag is cleared correctly. */
+		wrmsr(MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR, BIT_ULL(i));
+		GUEST_ASSERT(!(rdmsr(MSR_AMD64_PERF_CNTR_GLOBAL_STATUS) &
+			     BIT_ULL(i)));
+	}
+}
+
+
 static void guest_test_core_counters(void)
 {
 	guest_test_rdwr_core_counters();
 	guest_test_core_events();
+	guest_test_perf_mon_v2();
 	GUEST_DONE();
 }
 
-- 
2.46.0.rc2.264.g509ed76dc8-goog


