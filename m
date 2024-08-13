Return-Path: <kvm+bounces-24045-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B7D0950AA5
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 18:45:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DF1A828189C
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 16:45:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CF2B1A4F31;
	Tue, 13 Aug 2024 16:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xQlIjD6n"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f201.google.com (mail-il1-f201.google.com [209.85.166.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2DF61A3BB8
	for <kvm@vger.kernel.org>; Tue, 13 Aug 2024 16:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723567402; cv=none; b=g1aLUmbXyaeaLLjFPE8HqneqEpySzoYhr6mFZTWf7J6Kq5iTfMfMibyF+5CtUd5rdYSH6hqZCiaJVkivIk8wRT8GNRXYPrYm58FS9Rk7rlgSgEsJZ72wBkSjzRUvIgAoMX9b2KIQUPnQhH5YZYvyS2rs6JSdfUoqCXjE8VBsbZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723567402; c=relaxed/simple;
	bh=hbna4WT6ykCjoJ+xsQHxPsp0+nTsv9npl8xnbl9uBlQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NdCXNeiWLKT28KEes8hZQYi6jos1eX5Pcfsr7vtzBLK2GW0lvcfiqVHpQWhFM7r+h7Nnenac0b7aa9R/47Z/HfxXggRiE9euAXzUgmI1aKzkje3QJEH6+0zMVBHj7MTPiVTMDp77Db/RUNvmppLcIHXZgXt7WMp5vrXKDD5jGfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xQlIjD6n; arc=none smtp.client-ip=209.85.166.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-il1-f201.google.com with SMTP id e9e14a558f8ab-39b349a0234so533065ab.0
        for <kvm@vger.kernel.org>; Tue, 13 Aug 2024 09:43:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723567400; x=1724172200; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=sxu2u9J8ROI353JNXDar5TUy9JdYSVQrvfs197UIlhk=;
        b=xQlIjD6nbccd9DDoZNij1kLNLgCr/bTdr+6twJbBKLJ+6/qw79+RXtbXAwGJ3QoVn+
         bKsGtS1/B0K8TsViqU3YoDBsZXUj+0MNg8odeW2sOcCS0iaEIjPgnWYW/66XSoTIk+8O
         91MKlusltWepRR0ue5P7QLuctqs0/ncQourPlxvBPviRLvmmpzpubcvs+LPS82wvzr+Q
         tJYIgBaBqDuv3x99QvueWC5TL7EAyZ+XVZkYauPjQKUbQl3U7D9nc/+ypmSChjbWFLsp
         lQYVMn63GiG5oFCfkOhH0DR78BN643gEnxINoVdTQhI4dS8V+8gLgai52m8Bvi+ibHDZ
         oQnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723567400; x=1724172200;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sxu2u9J8ROI353JNXDar5TUy9JdYSVQrvfs197UIlhk=;
        b=My+XFF8epknT/WzVZ31AxbNH8WxoJa/+n4tpuuwqLUqMis3ECH2rDc7Cs/vVXkabcc
         Zx+0UxRKTZWuuZkZzuj0WZ4p+vTQkJvONE35Y8gqQN3ZORV8fUFeVfjWhTL/GC6O8Pgt
         roRPpk1HwdqXc2LU7EnbGrPoeZLUPclTnLuAqx3jOQAjkGRdIo+p1A4UaC90qGyyqA4e
         uWOs+/qmHRJZGVMdgt2ir62fGtkhgaaL0rOhTXv7Cw/ggk1KuwK57Hld4imNH4XFmSr/
         UfLO780CERL+fUywgGcVxscYHh9gmH+53sBlYEub2EBy0hEm2uA+Y/lAK1rSh5nNm0Ve
         ErQA==
X-Gm-Message-State: AOJu0YzNVFh5SVcVKzbnn8gJvRA3TbWHriVpnpp3ud7AfqLHQfD6Ya3P
	0xVfT/KrMXv8Q1vReuXxxasn0xpuY9krrXVXtoAh2HfGpLzAG1ApAQxCZgGL9CLGZ2CJp08eLnC
	4gu79+4mPcMbdhzgb9mHzuTDoo6yL04wIimJdh/0TBlJ/l4RphBLupYyJtIQDDtDG0mPE/RslXj
	HwC5x438Nlp0UWJXNH3nmwHH2bwKA6QCbHo+wugraBUsgXqXEZZQbK2Ag=
X-Google-Smtp-Source: AGHT+IElI/1oLpRVwVZMfLBr3yjf0cJI9FMrVKLvemCl2STD5dQWccho2EdHMGhA6wjGDeXQ60Glka2UTwaKewegew==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:6638:9818:b0:4c2:31f5:3137 with
 SMTP id 8926c6da1cb9f-4caaf459bcfmr5907173.0.1723567399664; Tue, 13 Aug 2024
 09:43:19 -0700 (PDT)
Date: Tue, 13 Aug 2024 16:42:44 +0000
In-Reply-To: <20240813164244.751597-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240813164244.751597-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.46.0.76.ge559c4bf1a-goog
Message-ID: <20240813164244.751597-7-coltonlewis@google.com>
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
2.46.0.76.ge559c4bf1a-goog


