Return-Path: <kvm+bounces-68820-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8OrACahZcWkNEwAAu9opvQ
	(envelope-from <kvm+bounces-68820-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 23:56:40 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B1A65F26F
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 23:56:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 2A0555C5C1D
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 22:56:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B629544CAEF;
	Wed, 21 Jan 2026 22:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dDjn+3ty"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8A63425CF9
	for <kvm@vger.kernel.org>; Wed, 21 Jan 2026 22:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769036115; cv=none; b=EVRg092QoEij3vQ8CRdqv2v97hwtDgd0pStSKrneQRZ62MoIQDUh066uyl+XhTtbamMOF/S1sDibqJIQpjuitYZNarUvhJVkqCND0rESmK9ZLTqSTfpuhSrfeyWhJn3RgM4USVMaWaq9fiBkVvjaPapiQXBPF7VWxP6Qb4d2dk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769036115; c=relaxed/simple;
	bh=eLiijBQvPYZP6MiOgHZ396bWTv5T0sqkDVoO56oopeg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VexNhr3Mww0/7v0rzfiT1B7PRVxX4kuW8MiLr9xehG3GkEkYssqaa0tpauWIQuWsWMkmqhdRCjhGitZap13B+luy0Kvr2NpLpjdUnVMpC0LpXxcPFWa592pbtNIdI0qCTU8Nuo+CGsk3obDGAKVcAZ4B2pFkq2eR1Mcd8Hk0IpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dDjn+3ty; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34c213419f5so226875a91.2
        for <kvm@vger.kernel.org>; Wed, 21 Jan 2026 14:55:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769036108; x=1769640908; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=eo4w6WPgEag9hYMxl6UJDX8Oqwe0fHdOT48tYz5B9VA=;
        b=dDjn+3tyZrkm5IsFL4KUBMFVzoPRGltw9JAvI9tOWo+Oh57Sf6uRX2FT1jKdeNarke
         rereMcI+1/YoFQmqhEYJZ8DnJeyAcXYV4T7LDr9kGn9PH/+nVb24FpTi2rZ+qDzYl2Bu
         HL3c69yhDtNnfA8PDznXDPRZG+coBEt/fWQfAoTzcqagsZ6HFshO67hLYp2FkG9x/LMT
         kt6GfNSTOD9FWq2iH5BWdOreeABm0A0Vd/2uokF3/wPIRMzhwQvbUVDA06cSBJxKxW7/
         0cO+0IG3nEUilSICd2A0dQeFRL6E0u007c8vLipenuxg0E574AxmS+QfRySy4fbwpWj5
         LLfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769036108; x=1769640908;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eo4w6WPgEag9hYMxl6UJDX8Oqwe0fHdOT48tYz5B9VA=;
        b=lkuUk/Hm0EGnB/Wsrj9Y0028/ejmKz1gvBzmoLPtRErzL6LpTJ87fta6aIE1pdYEGe
         eJXDhPoUV0LWPFP0R4r+xhAL0VL2boSOPBnU4b9OkAtFcyMwPTFDqr9SiZavikcthBTr
         ffw8G8hrd1VYcDEiWCpKD+JcVwIhBZHtJTmpdFC+lPcxT6WsP2HF822MGgLuj56/Q73J
         1CrEhNGq320XlPDuf4Si6bh3AugELrZpBvaDHri2NNiq3zvV+Zod8YVzicp2DeK1C5Nb
         g354iGx/JhW+gn4UF1ODfqzRvFJAv7lYPAc4q93shBA0juVVycDZNhh42Y3N1AW7+vAs
         Dd/Q==
X-Forwarded-Encrypted: i=1; AJvYcCWfcARAxnGmIWUSWfDpxYaoSSRAmyH5JjQQQXkF9t+crDs/9wmJP9oxw2cOTSvVV2hYf0Q=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy5E9hiMUMHnQyfnQBcV1wJKYzhnWygez8hoxk4uw1//M/DrAKD
	n36Cn0XX95UfVrY1KEzT0T+P8G9O9/3qJjzWnJjG1D9pZ+DuwA3E6wxYmxKp3xXT8GlA4fEeskU
	mWBM2XsJEQ/a42Q==
X-Received: from pjyj8.prod.google.com ([2002:a17:90a:e608:b0:34e:90d2:55c0])
 (user=jmattson job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:3950:b0:340:bc27:97bd with SMTP id 98e67ed59e1d1-352c3e49bc7mr5864249a91.9.1769036108004;
 Wed, 21 Jan 2026 14:55:08 -0800 (PST)
Date: Wed, 21 Jan 2026 14:54:01 -0800
In-Reply-To: <20260121225438.3908422-1-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260121225438.3908422-1-jmattson@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260121225438.3908422-4-jmattson@google.com>
Subject: [PATCH 3/6] KVM: x86/pmu: Track enabled AMD PMCs with Host-Only xor
 Guest-Only bits set
From: Jim Mattson <jmattson@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, 
	Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, 
	James Clark <james.clark@linaro.org>, Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Cc: Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.46 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	MV_CASE(0.50)[];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[23];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-68820-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jmattson@google.com,kvm@vger.kernel.org];
	DMARC_POLICY_ALLOW(0.00)[google.com,reject];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	ASN(0.00)[asn:7979, ipnet:2a01:60a::/32, country:US];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[ams.mirrors.kernel.org:helo,ams.mirrors.kernel.org:rdns]
X-Rspamd-Queue-Id: 0B1A65F26F
X-Rspamd-Action: no action

Add pmc_hostonly and pmc_guestonly bitmaps to struct kvm_pmu to track which
guest-enabled performance counters have just one of the Host-Only and
Guest-Only event selector bits set. PMCs that are disabled, have neither
HG_ONLY bit set, or have both HG_ONLY bits set are not tracked, because
they don't require special handling at vCPU state transitions.

Update the bitmaps when the guest writes to an event selector MSR.

Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/include/asm/kvm_host.h |  4 ++++
 arch/x86/kvm/pmu.c              |  2 ++
 arch/x86/kvm/svm/pmu.c          | 28 ++++++++++++++++++++++++++++
 3 files changed, 34 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index ecd4019b84b7..92050f76f84b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -593,6 +593,10 @@ struct kvm_pmu {
 	DECLARE_BITMAP(pmc_counting_instructions, X86_PMC_IDX_MAX);
 	DECLARE_BITMAP(pmc_counting_branches, X86_PMC_IDX_MAX);
 
+	/* AMD only: track PMCs with Host-Only or Guest-Only bits set */
+	DECLARE_BITMAP(pmc_hostonly, X86_PMC_IDX_MAX);
+	DECLARE_BITMAP(pmc_guestonly, X86_PMC_IDX_MAX);
+
 	u64 ds_area;
 	u64 pebs_enable;
 	u64 pebs_enable_rsvd;
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index bd6b785cf261..833ee2ecd43f 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -921,6 +921,8 @@ static void kvm_pmu_reset(struct kvm_vcpu *vcpu)
 	pmu->need_cleanup = false;
 
 	bitmap_zero(pmu->reprogram_pmi, X86_PMC_IDX_MAX);
+	bitmap_zero(pmu->pmc_hostonly, X86_PMC_IDX_MAX);
+	bitmap_zero(pmu->pmc_guestonly, X86_PMC_IDX_MAX);
 
 	kvm_for_each_pmc(pmu, pmc, i, pmu->all_valid_pmc_idx) {
 		pmc_stop_counter(pmc);
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index f619417557f9..c06013e2b4b1 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -147,6 +147,33 @@ static int amd_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	return 1;
 }
 
+static void amd_pmu_update_hg_bitmaps(struct kvm_pmc *pmc)
+{
+	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
+	u64 eventsel = pmc->eventsel;
+
+	if (!(eventsel & ARCH_PERFMON_EVENTSEL_ENABLE)) {
+		bitmap_clear(pmu->pmc_hostonly, pmc->idx, 1);
+		bitmap_clear(pmu->pmc_guestonly, pmc->idx, 1);
+		return;
+	}
+
+	switch (eventsel & AMD64_EVENTSEL_HG_ONLY) {
+	case AMD64_EVENTSEL_HOSTONLY:
+		bitmap_set(pmu->pmc_hostonly, pmc->idx, 1);
+		bitmap_clear(pmu->pmc_guestonly, pmc->idx, 1);
+		break;
+	case AMD64_EVENTSEL_GUESTONLY:
+		bitmap_clear(pmu->pmc_hostonly, pmc->idx, 1);
+		bitmap_set(pmu->pmc_guestonly, pmc->idx, 1);
+		break;
+	default:
+		bitmap_clear(pmu->pmc_hostonly, pmc->idx, 1);
+		bitmap_clear(pmu->pmc_guestonly, pmc->idx, 1);
+		break;
+	}
+}
+
 static bool amd_pmu_dormant_hg_event(struct kvm_pmc *pmc)
 {
 	u64 hg_only = pmc->eventsel & AMD64_EVENTSEL_HG_ONLY;
@@ -196,6 +223,7 @@ static int amd_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (data != pmc->eventsel) {
 			pmc->eventsel = data;
 			amd_pmu_set_eventsel_hw(pmc);
+			amd_pmu_update_hg_bitmaps(pmc);
 			kvm_pmu_request_counter_reprogram(pmc);
 		}
 		return 0;
-- 
2.52.0.457.g6b5491de43-goog


