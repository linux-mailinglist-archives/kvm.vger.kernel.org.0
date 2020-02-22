Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 980EF168C0D
	for <lists+kvm@lfdr.de>; Sat, 22 Feb 2020 03:35:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727874AbgBVCfT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Feb 2020 21:35:19 -0500
Received: from mail-pl1-f201.google.com ([209.85.214.201]:50542 "EHLO
        mail-pl1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727646AbgBVCfT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Feb 2020 21:35:19 -0500
Received: by mail-pl1-f201.google.com with SMTP id g5so2185655plq.17
        for <kvm@vger.kernel.org>; Fri, 21 Feb 2020 18:35:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=YWE+MLnOjK4IvZZLwvQEPG2A0OjN+JMmVnFRhQHYJMc=;
        b=eBgFXXFGkeT5/uAIvCLjYTs5ZF9zNsG77UJxFH5+o2fO8jOjzd7BGMrmBVaoruIcmq
         0A3nJSGzQJTcqWdmwClNEhhIfJT3RlBglY+KM212kLV0k99Kbd5YtWGs1PoXp9H5jKW7
         fOVGEWwtGLq/x6MQYFehTUpvgfVhndZL3KtWiczoGdaDqaOkzgAe2HIPD1oYzkop/d27
         bXetWVCGNsizjssAiZ9RuI2W44NN+s0ZBRdbbT2JTQeO7T2JvyAGrQlT75NsjEnh0hXu
         nA+4nlUufuZ0rl4P2+7v2D0jKFxRABY0AtwEUBgHKOAZbdzS1ZRBPGY3g0DaClPuv9pw
         NDjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=YWE+MLnOjK4IvZZLwvQEPG2A0OjN+JMmVnFRhQHYJMc=;
        b=Mo/vYEux0So3aQQAkSKV2TeZwYNp55zPFjvi7XXM86DLfqEf9PzbN6jCVLNqOM+Anw
         gsiA9e4IGWeyq6z22Lrwy3zHAQmuwcF4dvWx9X52hDUxeb70R+xeBAy7X3KhGFHTOahg
         qEtOB5LgOLmy5Bwnrc2Ma43JbnFKuPG5bD43+omvrFnAY09zVRHPOQfSZYrcCDNL1Zoi
         EDiHsrlqfhSA4LcH/bognDUPFVu090hVzTbwRzWdlXQKFaF58XhucTtuNZIv46sKaXFa
         ojnGiO32h/4PMceiu/EDX+wNzDjVjCfnge84ROLp5K9UZax5sdUA+WHfgBlXq2z48dyZ
         Zv2w==
X-Gm-Message-State: APjAAAVKStRZOceonxN0lP8g5EEy75D9juMzr//Z37qgvYVudXNDH92A
        55+62YZOXJQ6npeLz7VZW63MveyAODe9ilw=
X-Google-Smtp-Source: APXvYqz/5nZSxiCEMANum1t9/MuA4rvyDGQUbSoYAmrDG89Qk66FIjDXtoFPXPLbgqYWY+92O8YQeM6VQxVkOk8=
X-Received: by 2002:a63:a807:: with SMTP id o7mr40015719pgf.407.1582338917117;
 Fri, 21 Feb 2020 18:35:17 -0800 (PST)
Date:   Fri, 21 Feb 2020 18:34:13 -0800
Message-Id: <20200222023413.78202-1-ehankland@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.25.0.265.gbab2e86ba0-goog
Subject: [PATCH] KVM: x86: Adjust counter sample period after a wrmsr
From:   Eric Hankland <ehankland@google.com>
To:     Jim Mattson <jmattson@google.com>, Peter Shier <pshier@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Eric Hankland <ehankland@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The sample_period of a counter tracks when that counter will
overflow and set global status/trigger a PMI. However this currently
only gets set when the initial counter is created or when a counter is
resumed; this updates the sample period after a wrmsr so running
counters will accurately reflect their new value.

Signed-off-by: Eric Hankland <ehankland@google.com>
---
 arch/x86/kvm/pmu.c           | 4 ++--
 arch/x86/kvm/pmu.h           | 8 ++++++++
 arch/x86/kvm/vmx/pmu_intel.c | 6 ++++++
 3 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index bcc6a73d6628..d1f8ca57d354 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -111,7 +111,7 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
 		.config = config,
 	};
 
-	attr.sample_period = (-pmc->counter) & pmc_bitmask(pmc);
+	attr.sample_period = get_sample_period(pmc, pmc->counter);
 
 	if (in_tx)
 		attr.config |= HSW_IN_TX;
@@ -158,7 +158,7 @@ static bool pmc_resume_counter(struct kvm_pmc *pmc)
 
 	/* recalibrate sample period and check if it's accepted by perf core */
 	if (perf_event_period(pmc->perf_event,
-			(-pmc->counter) & pmc_bitmask(pmc)))
+			      get_sample_period(pmc, pmc->counter)))
 		return false;
 
 	/* reuse perf_event to serve as pmc_reprogram_counter() does*/
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 13332984b6d5..354b8598b6c1 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -129,6 +129,15 @@ static inline struct kvm_pmc *get_fixed_pmc(struct kvm_pmu *pmu, u32 msr)
 	return NULL;
 }
 
+static inline u64 get_sample_period(struct kvm_pmc *pmc, u64 counter_value)
+{
+	u64 sample_period = (-counter_value) & pmc_bitmask(pmc);
+
+	if (!sample_period)
+		sample_period = pmc_bitmask(pmc) + 1;
+	return sample_period;
+}
+
 void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel);
 void reprogram_fixed_counter(struct kvm_pmc *pmc, u8 ctrl, int fixed_idx);
 void reprogram_counter(struct kvm_pmu *pmu, int pmc_idx);
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index fd21cdb10b79..e933541751fb 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -263,9 +263,15 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			if (!msr_info->host_initiated)
 				data = (s64)(s32)data;
 			pmc->counter += data - pmc_read_counter(pmc);
+			if (pmc->perf_event)
+				perf_event_period(pmc->perf_event,
+						  get_sample_period(pmc, data));
 			return 0;
 		} else if ((pmc = get_fixed_pmc(pmu, msr))) {
 			pmc->counter += data - pmc_read_counter(pmc);
+			if (pmc->perf_event)
+				perf_event_period(pmc->perf_event,
+						  get_sample_period(pmc, data));
 			return 0;
 		} else if ((pmc = get_gp_pmc(pmu, msr, MSR_P6_EVNTSEL0))) {
 			if (data == pmc->eventsel)
