Return-Path: <kvm+bounces-48021-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 868BDAC840E
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 00:20:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 508DC165493
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 22:20:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E00E242928;
	Thu, 29 May 2025 22:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="T+AUPhT1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 291CF244673
	for <kvm@vger.kernel.org>; Thu, 29 May 2025 22:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748557196; cv=none; b=IjHsXfnm9uXb3ix68WCiDP5LZV5QaxgT2HAPrsBOmiz2Ru4vNwH/MyuTNzyb7h4rqdLErJdVy12OcUcHZIfxeax1fohIwMIfA8P3U/4yzYCtoYdE8mV00GkWWaXhluYY6BiBW2Gy0gTXXh+kwFjvhSLuz+Hnzwq81WqriweVskU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748557196; c=relaxed/simple;
	bh=A4LFvqZ5ENWY34mGIemBrERpDHvc2DqMGrkrdUc+6to=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RjIMcopGcJHk10lMDJjmjyicPgEjND/vk3ID4MbA4cug5Ze2FXlMukYETcOvBzyslB63JWpX43IVJ/mKsbqgaaGjZZzml8UE9el7oQL1Kk7quOVlaIkyuWaCWkl2myaBzfkKp4B6RQiUwBNVJqvrGVDgXeYiqZ4KHRuzmPL2UAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=T+AUPhT1; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7394772635dso957193b3a.0
        for <kvm@vger.kernel.org>; Thu, 29 May 2025 15:19:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748557194; x=1749161994; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=nX98HJbRuSQ6xNdc0MwlmdF7eZrXWtOe+GKwLLWx4iA=;
        b=T+AUPhT1snCB9zW1C3cw9aF0FwU5iVrWGUbe+WRjw2l2nUQueDMl2mKWuEg0N9tgPX
         Uw94XsFoiFlrF/qqbzjRRPOCUwOduKKlUJ5QAI/JCMbo+5wWw+3bg0WTHW+OIoahO+FK
         XQiZVOhQ5Gg7DFUjx45bp6/NwtQi3OSehPqa4vJhIa3QNxISiU3Ahw8ex4+3a2X60Bbw
         PpHcmXjKJUgqxxOz1KR4ykaQXzIus44rP/nqBC3pLJrskHZNMwER6ETYhjDr9b2Ql1MD
         DbQRzqsE67BffYGljZ49fELQ5udE8DLKjzws2g9L6v+NEP7hGZNDgk7ZQaj/DB47SXaR
         UiwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748557194; x=1749161994;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nX98HJbRuSQ6xNdc0MwlmdF7eZrXWtOe+GKwLLWx4iA=;
        b=noIYW12yqadar6vj0coYHvaEqY37JzqMxgjFEV+OMFxy7uIxlVrp+fyCm0Z9HwqvMC
         FjRpE8oxCfu25QAbCYZMwJrWd+qpuYSc4KvrwOgPDdh4AAUYgTkhUiAL8pMb/7L9ei4C
         vGAKWFyFbA6eMDw9VwQAfoYMvTxpRx6DsmystT5+oAw5dLg20Yiuv+468/D2V0fjX5KF
         LCy/4xPG2iiZFoRtoHVucr7f2TSnx885sfoZVv7GZNcqFGBjaraWTOzbHxE7dxDVvUr1
         GUiqmkv1YpSAT/4un/x39ETBaqUratdrH1DJ65iHlq5xJ32TSrF2W/FdFoPg4q3rVnaw
         84DQ==
X-Forwarded-Encrypted: i=1; AJvYcCU8FckwBEmkFllwG0n/+2VdK0McDFHMScQwezynUCYXU1oO4UiS6NmPzpgsZkXp4eBPtZI=@vger.kernel.org
X-Gm-Message-State: AOJu0YySWYeKD5zneSntAzPyt/D9QkwxCsgrodgNojockRZFrQoLj6+j
	Mf+k0HogT4GUJdj/e9byknrqmNifffr3zMhKBUdyk3nnQbq/NOfGmwuhLl8B+3KL69bqlIuM6vK
	7fX33aA==
X-Google-Smtp-Source: AGHT+IEBKjriVgxGk+BKu71J524sscOYWEh1dyyHEKyqWyY/JG1UDmL2b6mDtP1ardICqkEsw3RhMdZ0TiQ=
X-Received: from pfjg6.prod.google.com ([2002:a05:6a00:b86:b0:747:a049:d575])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:928a:b0:740:4fd8:a2bc
 with SMTP id d2e1a72fcca58-747bd958bb5mr1298997b3a.5.1748557194299; Thu, 29
 May 2025 15:19:54 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 29 May 2025 15:19:21 -0700
In-Reply-To: <20250529221929.3807680-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250529221929.3807680-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1204.g71687c7c1d-goog
Message-ID: <20250529221929.3807680-9-seanjc@google.com>
Subject: [kvm-unit-tests PATCH 08/16] x86/pmu: Rename gp_counter_mask_length
 to arch_event_mask_length
From: Sean Christopherson <seanjc@google.com>
To: Andrew Jones <andrew.jones@linux.dev>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, "=?UTF-8?q?Nico=20B=C3=B6hr?=" <nrb@linux.ibm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Rename gp_counter_mask_length to arch_event_mask_length to reflect what
the field actually tracks.  The availablity of architectural events has
nothing to do with the GP counters themselves.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/pmu.c | 4 ++--
 lib/x86/pmu.h | 2 +-
 x86/pmu.c     | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/lib/x86/pmu.c b/lib/x86/pmu.c
index 599168ac..b97e2c4a 100644
--- a/lib/x86/pmu.c
+++ b/lib/x86/pmu.c
@@ -18,7 +18,7 @@ void pmu_init(void)
 
 		pmu.nr_gp_counters = (cpuid_10.a >> 8) & 0xff;
 		pmu.gp_counter_width = (cpuid_10.a >> 16) & 0xff;
-		pmu.gp_counter_mask_length = (cpuid_10.a >> 24) & 0xff;
+		pmu.arch_event_mask_length = (cpuid_10.a >> 24) & 0xff;
 
 		/* CPUID.0xA.EBX bit is '1' if a counter is NOT available. */
 		pmu.arch_event_available = ~cpuid_10.b;
@@ -50,7 +50,7 @@ void pmu_init(void)
 			pmu.msr_gp_event_select_base = MSR_K7_EVNTSEL0;
 		}
 		pmu.gp_counter_width = PMC_DEFAULT_WIDTH;
-		pmu.gp_counter_mask_length = pmu.nr_gp_counters;
+		pmu.arch_event_mask_length = pmu.nr_gp_counters;
 		pmu.arch_event_available = (1u << pmu.nr_gp_counters) - 1;
 
 		if (this_cpu_has_perf_global_status()) {
diff --git a/lib/x86/pmu.h b/lib/x86/pmu.h
index d0ad280a..c7dc68c1 100644
--- a/lib/x86/pmu.h
+++ b/lib/x86/pmu.h
@@ -63,7 +63,7 @@ struct pmu_caps {
 	u8 fixed_counter_width;
 	u8 nr_gp_counters;
 	u8 gp_counter_width;
-	u8 gp_counter_mask_length;
+	u8 arch_event_mask_length;
 	u32 arch_event_available;
 	u32 msr_gp_counter_base;
 	u32 msr_gp_event_select_base;
diff --git a/x86/pmu.c b/x86/pmu.c
index 0ce34433..63eae3db 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -992,7 +992,7 @@ int main(int ac, char **av)
 	printf("PMU version:         %d\n", pmu.version);
 	printf("GP counters:         %d\n", pmu.nr_gp_counters);
 	printf("GP counter width:    %d\n", pmu.gp_counter_width);
-	printf("Mask length:         %d\n", pmu.gp_counter_mask_length);
+	printf("Event Mask length:   %d\n", pmu.arch_event_mask_length);
 	printf("Fixed counters:      %d\n", pmu.nr_fixed_counters);
 	printf("Fixed counter width: %d\n", pmu.fixed_counter_width);
 
-- 
2.49.0.1204.g71687c7c1d-goog


