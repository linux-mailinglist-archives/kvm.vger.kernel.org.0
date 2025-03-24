Return-Path: <kvm+bounces-41842-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BEEC6A6E152
	for <lists+kvm@lfdr.de>; Mon, 24 Mar 2025 18:45:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 14AFB1899F00
	for <lists+kvm@lfdr.de>; Mon, 24 Mar 2025 17:42:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14B1E26A0E2;
	Mon, 24 Mar 2025 17:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="r2ltvTN5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 686E0269D1C
	for <kvm@vger.kernel.org>; Mon, 24 Mar 2025 17:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742837618; cv=none; b=pohhW0HfgVlbImYtZqd78K+puFmyCQY8mAQVVYF79qfaUcCb+gW/B2wYwDzF1CFFRy8xb0Ppx4iRDIni2MinOX7J4fucYXS9FREO6syO7EQEBubY0JbqMPbVhYVR3XHQNpwpl4Mc74alSICfhEx4iSYaxJximvObjaXBDvtDs94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742837618; c=relaxed/simple;
	bh=HK3sVTz5/StFQ9UqVyNVhdMzjLv+XOymilAVSqlp0yI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rymlL6UUIbbdTlmvCsm5pe0IAJCaQaY9Yeb/bQIRh46kkPtoAJJbPo6RowGAbDT5YqGFG601BwGbPoW/Ryb8P7k+yQHtwWa68jk7Jhrshw42HDS+huCtSWEARgT4e/VVzdFfoYwZBM9fIp1wnL72MFD+1NhYEOsID88C/Na0G2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=r2ltvTN5; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2240c997059so104607825ad.0
        for <kvm@vger.kernel.org>; Mon, 24 Mar 2025 10:33:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742837615; x=1743442415; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=BBjwYLkShPCK2VrztwK2kT4zbSZ0SiX7EhvMfBHkH9E=;
        b=r2ltvTN5aTvtWebOo9YjXBnFya/ngtp8YlLkOqyjMtT9VJvDglxpACMARKlSE8dpmb
         aefs+WNZLM+V5qXV12rybUzAvW/ZPr30CSC0AseO0wxvunlorX8Z223wNZtht1x0WGof
         CDsUs3N8Dmy2PnOlrmdh8pzYhocu7U508LjHyHxKqFwRzbPcozGZE+q0FgGNqpyCFesV
         k2sQIdD5B/JGNLLE/ciKRzO8m13NOmQL1x99xSXZi4rYexlGS0jkoV9rjkZk5fj8oYgp
         2A/dI8TDSk8Y8jeCR55ykGUhezJJitWFSHYryvWXwJvDNJ3ZqMdOz8oh8ZlahG+KYmJR
         xFqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742837615; x=1743442415;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BBjwYLkShPCK2VrztwK2kT4zbSZ0SiX7EhvMfBHkH9E=;
        b=CWCtwJ32otjlBiuX2+p4uGoc57MER49DwhpK6P+KD70N3VvUPC2N97S5QzLHxhrQDm
         lUu2iH0spHLVVZ/8Kc3hLQnUahAJ5uYOCfybcknQIKCIWLFpy4v+dNpJB6KabVaMWiYG
         yATIdCpR6MAxjhT9jYOOoIyQEV1z+tj+q/4a5j1avs04HWgbRiV4Q8mc0Cy5u0mfFpG6
         gP35BWR261kZaZ97vB6DuYN20vxQC4KnPaK1Qd2pFXMuv3VuakwbDSMO6pvHS2/fmqH+
         AJSFp4cFfVfk9wR5DWiTiFzDB1O5nzzbeS5KDRmU1BsYl5PiKPvPb9Ue/BT2CQtCPnLX
         FUNA==
X-Forwarded-Encrypted: i=1; AJvYcCV/zsQB7JGIyYmpffgBEk8pIYplEZ6+6ADKKHVh3Vp9agP2nGjjt0T20mNbn7LSlYawiJY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx3gPPljY6oR4G1GtnKMbJTUkgYYRNrNLLvwJ7Ea36epoFu2HUS
	LB9khPEtmSdMba+7j9yIT+fo5+6KiDnX0wKSP/AKEnWMGpLvt9T0CEIz9YryPq8/ZX25/maWUkJ
	QKNkjJA==
X-Google-Smtp-Source: AGHT+IGpE1JBswCmZdI+P62zf261bTaAPnI3B5oXWGwwXXhYsEBSpl4lzhlzzW8eJz0nRuiROYZYDYhxsR5/
X-Received: from plog5.prod.google.com ([2002:a17:902:8685:b0:223:fbb0:59ae])
 (user=mizhang job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f608:b0:210:f706:dc4b
 with SMTP id d9443c01a7336-22780c7606emr192403565ad.13.1742837615660; Mon, 24
 Mar 2025 10:33:35 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Mon, 24 Mar 2025 17:31:07 +0000
In-Reply-To: <20250324173121.1275209-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250324173121.1275209-1-mizhang@google.com>
X-Mailer: git-send-email 2.49.0.395.g12beb8f557-goog
Message-ID: <20250324173121.1275209-28-mizhang@google.com>
Subject: [PATCH v4 27/38] KVM: x86/pmu: Handle PMU MSRs interception and event filtering
From: Mingwei Zhang <mizhang@google.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, 
	Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, Liang@google.com, 
	Kan <kan.liang@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Mingwei Zhang <mizhang@google.com>, Yongwei Ma <yongwei.ma@intel.com>, 
	Xiong Zhang <xiong.y.zhang@linux.intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Jim Mattson <jmattson@google.com>, Sandipan Das <sandipan.das@amd.com>, 
	Zide Chen <zide.chen@intel.com>, Eranian Stephane <eranian@google.com>, 
	Das Sandipan <Sandipan.Das@amd.com>, Shukla Manali <Manali.Shukla@amd.com>, 
	Nikunj Dadhania <nikunj.dadhania@amd.com>
Content-Type: text/plain; charset="UTF-8"

From: Dapeng Mi <dapeng1.mi@linux.intel.com>

Mediated vPMU needs to intercept EVENTSELx and FIXED_CNTR_CTRL MSRs to
filter out guest malicious perf events. Either writing these MSRs or
updating event filters would call reprogram_counter() eventually. Thus
check if the guest event should be filtered out in reprogram_counter().
If so, clear corresponding EVENTSELx MSR or FIXED_CNTR_CTRL field to
ensure the guest event won't be really enabled at vm-entry.

Besides, mediated vPMU intercepts the MSRs of these guest not owned
counters and it just needs simply to read/write from/to pmc->counter.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Co-developed-by: Mingwei Zhang <mizhang@google.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/kvm/pmu.c | 27 +++++++++++++++++++++++++++
 arch/x86/kvm/pmu.h |  3 +++
 2 files changed, 30 insertions(+)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 63143eeb5c44..e9100dc49fdc 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -305,6 +305,11 @@ static void pmc_update_sample_period(struct kvm_pmc *pmc)
 
 void pmc_write_counter(struct kvm_pmc *pmc, u64 val)
 {
+	if (kvm_mediated_pmu_enabled(pmc->vcpu)) {
+		pmc->counter = val & pmc_bitmask(pmc);
+		return;
+	}
+
 	/*
 	 * Drop any unconsumed accumulated counts, the WRMSR is a write, not a
 	 * read-modify-write.  Adjust the counter value so that its value is
@@ -455,6 +460,28 @@ static int reprogram_counter(struct kvm_pmc *pmc)
 	bool emulate_overflow;
 	u8 fixed_ctr_ctrl;
 
+	if (kvm_mediated_pmu_enabled(pmu_to_vcpu(pmu))) {
+		bool allowed = check_pmu_event_filter(pmc);
+
+		if (pmc_is_gp(pmc)) {
+			if (allowed)
+				pmc->eventsel_hw |= pmc->eventsel &
+						    ARCH_PERFMON_EVENTSEL_ENABLE;
+			else
+				pmc->eventsel_hw &= ~ARCH_PERFMON_EVENTSEL_ENABLE;
+		} else {
+			int idx = pmc->idx - KVM_FIXED_PMC_BASE_IDX;
+
+			if (allowed)
+				pmu->fixed_ctr_ctrl_hw = pmu->fixed_ctr_ctrl;
+			else
+				pmu->fixed_ctr_ctrl_hw &=
+					~intel_fixed_bits_by_idx(idx, 0xf);
+		}
+
+		return 0;
+	}
+
 	emulate_overflow = pmc_pause_counter(pmc);
 
 	if (!pmc_event_is_allowed(pmc))
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 509c995b7871..6289f523d893 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -113,6 +113,9 @@ static inline u64 pmc_read_counter(struct kvm_pmc *pmc)
 {
 	u64 counter, enabled, running;
 
+	if (kvm_mediated_pmu_enabled(pmc->vcpu))
+		return pmc->counter & pmc_bitmask(pmc);
+
 	counter = pmc->counter + pmc->emulated_counter;
 
 	if (pmc->perf_event && !pmc->is_paused)
-- 
2.49.0.395.g12beb8f557-goog


