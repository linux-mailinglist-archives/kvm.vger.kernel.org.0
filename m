Return-Path: <kvm+bounces-38261-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 41744A36B17
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 02:37:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 096C616A07F
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 01:37:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02C701547E9;
	Sat, 15 Feb 2025 01:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="opLzxQa/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7C6C156F44
	for <kvm@vger.kernel.org>; Sat, 15 Feb 2025 01:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739583412; cv=none; b=sURd8LhQtUDW2tkIJue0Tr3e8rMrDGWMfkaMuH7whUVpfXckiPPhSvgCsF65xUrJ+vEHeQcZN4wUwkDM3ETzVPmuZvK/Xaq1+GuUfNJKbA4QlsmrCrS5hLaX5nqzDnSqTAgBUFcLSHscUMGitxlBFjP2Pw5OZgbpoJjwaAnZGWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739583412; c=relaxed/simple;
	bh=7zzB8c5IhHHPM9THa+2VA7wKVz2trueh/ZTKm7YxBVA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Cz0PUU7uCC4cfmP9l2p5pFYSniv2eWwMkAt5dcT+oDeRcwIvXy1WbRccZ3p9W41dAHd2ywuhZNe9BYfbqM9wLyiKcSHtmtiPFrTBD7Co14tPORpR7T7bEML2UeYQJDJyxRk3QjhD4x1p1quQugIHN/IruxhCxBJ3xhh7w9Gq/8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=opLzxQa/; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fc1a70935fso4674477a91.1
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 17:36:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739583410; x=1740188210; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=0rM1xWAcej7+IBKz0RDFgi1Xk/a2PfVotJRXmNEXMlw=;
        b=opLzxQa/1gZK4dm8+PDe09CZ4IQQhsI1pjRC8/95+Lz4l7QW5wUbY280KsykTt3JRN
         nCDLfEeAn5W6CyPVwnvMy95WfwG8tq+kgWe+hZIb+BlRfHdoK84U3rXCJcsElPJTecmt
         RDnwIYwzdDwIk1bPR2Rcpj6x+EpdoZT5XaSSZVAc3dmSVW71OBc2hrsIkD0u/TzMU1YS
         +PC5gsyfgz0dPw7g9JtvV7TosWwp6MZraVFdRBWml98w24NYdT7tUTKIsw/KSUORlFri
         OO3cqrEhSOg96/nRU7Om9VoQhltDibLQ6TL5DoLuhD8ahldpFoGCTYHGLSp829fXbBDp
         rOnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739583410; x=1740188210;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0rM1xWAcej7+IBKz0RDFgi1Xk/a2PfVotJRXmNEXMlw=;
        b=FrLz7bq84O7fUdQFU5M2b9/yPQLv+KTn1/uqFlNkD2hW7gyRHN4ILbP7QatOe7Ei0m
         tKrQLv1wkpggAD9W/DMCliI1U8PUAcAg/9KRqZE3qJOhXL4ntfxZgOfPxpeAoMzeKcCc
         herMW/ETmOidXOghDXMlauSvn3P3bX1vOXs2tBeBN0DoludUnVY2D6KIx3je4PgK7lCs
         KMOoTax+7zWkI4ylGyzYISKdhD2T4N9OX/9h7fJZhkIRR/F+K91tBr/va4qshXhaQ55O
         l7K6zMtUmrN9O7aJJdmezPIl7UkUO9GwnGIvOG4bY9FPelGU4OZ2oz+J+Sg9PU51DiMn
         ziIg==
X-Gm-Message-State: AOJu0Yz9cLtUj0F/1Vgv9R9//b12EoyaylCmFRMPHX9zmf5h+idqsUfX
	aaaEpfjHuO/3lOuXQFA+agl1yu4rtcgbHh4cIEL2adAXL3fzpWehnqqN/zfujye/WB5E4QYQsUK
	4og==
X-Google-Smtp-Source: AGHT+IHl19JJ2UKucGuuO0XNfkEfsqE09G3BOcbK/WuekuVHYBYD4w7QlK7g+XkamPhG0Q0Hw+wLjTNt3so=
X-Received: from pghm23.prod.google.com ([2002:a63:f617:0:b0:ad5:45a5:645c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:b40a:b0:1db:e536:158e
 with SMTP id adf61e73a8af0-1ee8cb86946mr3272983637.22.1739583409981; Fri, 14
 Feb 2025 17:36:49 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 14 Feb 2025 17:36:24 -0800
In-Reply-To: <20250215013636.1214612-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250215013636.1214612-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <20250215013636.1214612-8-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v7 07/18] x86: pmu: Fix potential out of bound
 access for fixed events
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>, 
	Xiong Zhang <xiong.y.zhang@intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Mingwei Zhang <mizhang@google.com>, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Dapeng Mi <dapeng1.mi@linux.intel.com>

Current PMU code doesn't check whether PMU fixed counter number is
larger than pre-defined fixed events. If so, it would cause memory
access out of range.

So limit validated fixed counters number to
MIN(pmu.nr_fixed_counters, ARRAY_SIZE(fixed_events)) and print message
to warn that KUT/pmu tests need to be updated if fixed counters number
exceeds defined fixed events number.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/pmu.c | 27 +++++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index 89197352..4353d1da 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -54,6 +54,7 @@ char *buf;
 
 static struct pmu_event *gp_events;
 static unsigned int gp_events_size;
+static unsigned int fixed_counters_num;
 
 static inline void loop(void)
 {
@@ -113,8 +114,12 @@ static struct pmu_event* get_counter_event(pmu_counter_t *cnt)
 		for (i = 0; i < gp_events_size; i++)
 			if (gp_events[i].unit_sel == (cnt->config & 0xffff))
 				return &gp_events[i];
-	} else
-		return &fixed_events[cnt->ctr - MSR_CORE_PERF_FIXED_CTR0];
+	} else {
+		unsigned int idx = cnt->ctr - MSR_CORE_PERF_FIXED_CTR0;
+
+		if (idx < ARRAY_SIZE(fixed_events))
+			return &fixed_events[idx];
+	}
 
 	return (void*)0;
 }
@@ -204,8 +209,12 @@ static noinline void __measure(pmu_counter_t *evt, uint64_t count)
 
 static bool verify_event(uint64_t count, struct pmu_event *e)
 {
-	bool pass = count >= e->min && count <= e->max;
+	bool pass;
 
+	if (!e)
+		return false;
+
+	pass = count >= e->min && count <= e->max;
 	if (!pass)
 		printf("FAIL: %d <= %"PRId64" <= %d\n", e->min, count, e->max);
 
@@ -250,7 +259,7 @@ static void check_fixed_counters(void)
 	};
 	int i;
 
-	for (i = 0; i < pmu.nr_fixed_counters; i++) {
+	for (i = 0; i < fixed_counters_num; i++) {
 		cnt.ctr = fixed_events[i].unit_sel;
 		measure_one(&cnt);
 		report(verify_event(cnt.count, &fixed_events[i]), "fixed-%d", i);
@@ -271,7 +280,7 @@ static void check_counters_many(void)
 			gp_events[i % gp_events_size].unit_sel;
 		n++;
 	}
-	for (i = 0; i < pmu.nr_fixed_counters; i++) {
+	for (i = 0; i < fixed_counters_num; i++) {
 		cnt[n].ctr = fixed_events[i].unit_sel;
 		cnt[n].config = EVNTSEL_OS | EVNTSEL_USR;
 		n++;
@@ -420,7 +429,7 @@ static void check_rdpmc(void)
 		else
 			report(cnt.count == (u32)val, "fast-%d", i);
 	}
-	for (i = 0; i < pmu.nr_fixed_counters; i++) {
+	for (i = 0; i < fixed_counters_num; i++) {
 		uint64_t x = val & ((1ull << pmu.fixed_counter_width) - 1);
 		pmu_counter_t cnt = {
 			.ctr = MSR_CORE_PERF_FIXED_CTR0 + i,
@@ -745,6 +754,12 @@ int main(int ac, char **av)
 	printf("Fixed counters:      %d\n", pmu.nr_fixed_counters);
 	printf("Fixed counter width: %d\n", pmu.fixed_counter_width);
 
+	fixed_counters_num = MIN(pmu.nr_fixed_counters, ARRAY_SIZE(fixed_events));
+	if (pmu.nr_fixed_counters > ARRAY_SIZE(fixed_events))
+		report_info("Fixed counters number %d > defined fixed events %u.  "
+			    "Please update test case.", pmu.nr_fixed_counters,
+			    (uint32_t)ARRAY_SIZE(fixed_events));
+
 	apic_write(APIC_LVTPC, PMI_VECTOR);
 
 	check_counters();
-- 
2.48.1.601.g30ceb7b040-goog


