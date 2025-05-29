Return-Path: <kvm+bounces-48022-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A923CAC840F
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 00:20:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 75AE74A4C2C
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 22:20:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC665253340;
	Thu, 29 May 2025 22:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EsN/k++M"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6F8C21E08B
	for <kvm@vger.kernel.org>; Thu, 29 May 2025 22:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748557198; cv=none; b=AM0JROnHS0MT0TZyxSGopfb2bKiu/DMgE/A+AIir0qPq/tmYjsxk4EEJhE263Y75McZffKPfCauMSZ5vNQjHGbJoEEaJvf3GkTzMvdY4zZYwe20WK5yV22tn3Ii+SsBkVLDEfjrv8qXUVGZIdc4kahvXdWGHfh4E7uCQ3kyWaSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748557198; c=relaxed/simple;
	bh=xD8CaSmWHVco43IcwheB+/1JP29rOKkKM0+y6oEr2XU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rMLSqac2ncnOr1x9+Hi2mi9FlFLgwEEe34B8ONNKInjYu93kSiZ2xATIFIT8fJqByRw1Y3nHuVTsVGPMn9+zHFCnekPaDd9ZOPNXoG2BOLEaAEHULx0vKyuZsadnZfF6UneVVSuIvNPCPiaHIoKTklR3ZLP7NbE3NOLrYGEKf14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EsN/k++M; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-31215238683so1156674a91.2
        for <kvm@vger.kernel.org>; Thu, 29 May 2025 15:19:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748557196; x=1749161996; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=gxZgXphd2adbipZSwhEJv6yb2Dq/xt7bO+6gJulJvt8=;
        b=EsN/k++Mxg52GdmJqAumVuOopn1j544MnalL6863jyTdBN4HYR0muRwrP1rt7GPbOu
         fKNQRzKMJz8Wmq0a+mqBVdUZXe0nvlos0jLpTE+dQP17SCdDmfSw4h99tiuvKXcOhW6h
         92McO9DGpK5U79wg8ikNgSFMfIYZ2s8+4VFme9FqdytKAZ1fztURXZkoQBKV2JBA3z2D
         VJPwKQxhEQiuSDUi3lEoTwqwoBgF4cpyObZtarB3rjTRkqGMJsB1zGbytOIbS857seL9
         +6TqKHWL0mYbwpd5wvXj5Yyb/yxkJo0bBx9aCgaBziBrYzTu3csGCeACXCUbLm3Tnf6S
         X9mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748557196; x=1749161996;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gxZgXphd2adbipZSwhEJv6yb2Dq/xt7bO+6gJulJvt8=;
        b=JyZHZ8pAKRBHfcz0Ai/AaE1jDBzDY9EC5wI1w4R/pZIZ2x1ysR25Hv4IsRhqzKUSTA
         s0hmbeUcSYsYH5UFY8iIqGlbohp8eb6AtBbkUgEiCL9oeLPXbeXlc47K1ViqNWPk+YxQ
         3Af1x1PmqPdcmi1bKSIjuMih1xcAtd9GZ3UVlxV8AFvLTb/E1H77lcGa/mMWMWNSLmiX
         ruPXmLWW2Vu5kfBOb8+mSD0wAOhjmRel0dO+rhxpqOmuZ5Hvjs1DYsggNCox1orwwEeT
         UvPM1LThEDyAPMleXbhWd5DyaxOt4UAdAdlIhdoeJvvyx733sCsFC9rFM7UplXNJPuww
         VEFQ==
X-Forwarded-Encrypted: i=1; AJvYcCV6SWmJ85tktbIA0+fY8q8tBrjVD4NDqZVptiC0MWxes4Av7ECzGgbMRteH1fONdY5hHH4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzWPQbtu9aTNYM3COOND5cb8T/qZORc2ZjrKfG5W75QZrel8jKG
	0F+dORzqGsf8yzXSEGayW4o37UTD6RYKZplaJahEKssGzxgmhv4BaENEQEf5tZx5BCIbHFBuE66
	ReLkcHQ==
X-Google-Smtp-Source: AGHT+IH0w/roq09Dtn3umfqlUM69m8mqnFe3o9acCe/5LRHUakJnkAfciNzMMbljEJ1XyxaZ7+27T8v406s=
X-Received: from pjbrr6.prod.google.com ([2002:a17:90b:2b46:b0:30e:5bd5:880d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3c8a:b0:312:2bb:aa89
 with SMTP id 98e67ed59e1d1-3124173d8bamr1566838a91.20.1748557196086; Thu, 29
 May 2025 15:19:56 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 29 May 2025 15:19:22 -0700
In-Reply-To: <20250529221929.3807680-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250529221929.3807680-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1204.g71687c7c1d-goog
Message-ID: <20250529221929.3807680-10-seanjc@google.com>
Subject: [kvm-unit-tests PATCH 09/16] x86/pmu: Mark all arch events as
 available on AMD
From: Sean Christopherson <seanjc@google.com>
To: Andrew Jones <andrew.jones@linux.dev>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, "=?UTF-8?q?Nico=20B=C3=B6hr?=" <nrb@linux.ibm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Mark all arch events as available on AMD, as AMD PMUs don't provide the
"not available" CPUID field, and the number of GP counters has nothing to
do with which events are supported.

Fixes: b883751a ("x86/pmu: Update testcases to cover AMD PMU")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/pmu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/x86/pmu.c b/lib/x86/pmu.c
index b97e2c4a..44449372 100644
--- a/lib/x86/pmu.c
+++ b/lib/x86/pmu.c
@@ -50,8 +50,8 @@ void pmu_init(void)
 			pmu.msr_gp_event_select_base = MSR_K7_EVNTSEL0;
 		}
 		pmu.gp_counter_width = PMC_DEFAULT_WIDTH;
-		pmu.arch_event_mask_length = pmu.nr_gp_counters;
-		pmu.arch_event_available = (1u << pmu.nr_gp_counters) - 1;
+		pmu.arch_event_mask_length = 32;
+		pmu.arch_event_available = -1u;
 
 		if (this_cpu_has_perf_global_status()) {
 			pmu.msr_global_status = MSR_AMD64_PERF_CNTR_GLOBAL_STATUS;
-- 
2.49.0.1204.g71687c7c1d-goog


