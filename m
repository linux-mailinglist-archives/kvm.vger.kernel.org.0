Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D23BC3D8D77
	for <lists+kvm@lfdr.de>; Wed, 28 Jul 2021 14:07:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234956AbhG1MHT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jul 2021 08:07:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234758AbhG1MHR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jul 2021 08:07:17 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E7E0C061757;
        Wed, 28 Jul 2021 05:07:16 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id f13so2418886plj.2;
        Wed, 28 Jul 2021 05:07:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pzNje+eEaJYZU+DxBipnEI0TOsk5q1STrYyOmtqwUmw=;
        b=e7qqtcYhnfdctT6rgsOSi4ZWSdffnSx0c8FrQXLY0JgJjKCB3So9UY8TWMVIjKwIBp
         SK+mq1gckdIxGgRh/OYfuMuLMnAGIaZYUhwpJEQq9Bo/+Fh7XkjHHIKjkUpxfgu7zv8T
         ltNIOkdq6vCCMmzizL57P/oKwnLO7wM/l0AUlUKk8g/Vft8QfbDNz02GGb4BXovNcMZt
         P9xXfJxa2kLVe4VojHa52BLND4GFlpvarDTIl4anoUAZVd2UfdsqfxBx3OlDcI6A/5YS
         8IpBfqayz+VfDftWwVp6eEyEBIrHCXnFMN4c6pBS+IGojkytvlo7hUSx+HVIeEAEBGcE
         YuYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pzNje+eEaJYZU+DxBipnEI0TOsk5q1STrYyOmtqwUmw=;
        b=t9XWMu1mIOji9j7bk8oyJscfMEjZfDthViCaXDjiWuuKL7sOprEeE2d9FEozpdylT7
         c+tJEQfvLytY5+wl2slvEiJul62UCEjOwgFH+17pKTr50RUp01aA8IbMXYi8ewP3vTFF
         Ku+Bwz+5w9vRfASxRi9k/gdmfT+dIR0qEWhz3Z/C7QdsC9cNBIaY4j7B0OdBT3HDO9Xv
         NyNqgsIW2yhtEnL2PfJkYhRmRjtEh71r4/Gxj7UN6SuJTdmeLOeNLvStkx9AQfhYrAF9
         ZTnhQIzOQBCNl8s8XEp3O0Yfpfz7Z4qLv/1qL4Q6dgoMwBYH0yT0NW5CP51AvdY9vYAT
         5qcA==
X-Gm-Message-State: AOAM533yQcHpakIj3teNx5fwJ2Q/N/JUuwZ753NnY/EAy6MJL1KJioLO
        ENFOFY88KHY8QRwyU05jXNw=
X-Google-Smtp-Source: ABdhPJxf/w2TK+hJYnsreVKPhj+fRyufvn+X6h+fruvET1ca3iuEj1Kh+w8bPIk/FSHYliEClzVlCA==
X-Received: by 2002:a63:5506:: with SMTP id j6mr9677935pgb.19.1627474035630;
        Wed, 28 Jul 2021 05:07:15 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id i24sm5887142pfr.207.2021.07.28.05.07.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 28 Jul 2021 05:07:15 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86/pmu: Introduce pmc->is_paused to reduce the call time of perf interfaces
Date:   Wed, 28 Jul 2021 20:07:05 +0800
Message-Id: <20210728120705.6855-1-likexu@tencent.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

Based on our observations, after any vm-exit associated with vPMU, there
are at least two or more perf interfaces to be called for guest counter
emulation, such as perf_event_{pause, read_value, period}(), and each one
will {lock, unlock} the same perf_event_ctx. The frequency of calls becomes
more severe when guest use counters in a multiplexed manner.

Holding a lock once and completing the KVM request operations in the perf
context would introduce a set of impractical new interfaces. So we can
further optimize the vPMU implementation by avoiding repeated calls to
these interfaces in the KVM context for at least one pattern:

After we call perf_event_pause() once, the event will be disabled and its
internal count will be reset to 0. So there is no need to pause it again
or read its value. Once the event is paused, event period will not be
updated until the next time it's resumed or reprogrammed. And there is
also no need to call perf_event_period twice for a non-running counter,
considering the perf_event for a running counter is never paused.

Based on this implementation, for the following common usage of
sampling 4 events using perf on a 4u8g guest:

  echo 0 > /proc/sys/kernel/watchdog
  echo 25 > /proc/sys/kernel/perf_cpu_time_max_percent
  echo 10000 > /proc/sys/kernel/perf_event_max_sample_rate
  echo 0 > /proc/sys/kernel/perf_cpu_time_max_percent
  for i in `seq 1 1 10`
  do
  taskset -c 0 perf record \
  -e cpu-cycles -e instructions -e branch-instructions -e cache-misses \
  /root/br_instr a
  done

the average latency of the guest NMI handler is reduced from
37646.7 ns to 32929.3 ns (~1.14x speed up) on the Intel ICX server.
Also, in addition to collecting more samples, no loss of sampling
accuracy was observed compared to before the optimization.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/pmu.c              | 5 ++++-
 arch/x86/kvm/pmu.h              | 2 +-
 arch/x86/kvm/vmx/pmu_intel.c    | 4 ++--
 4 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 99f37781a6fc..a079880d4cd5 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -482,6 +482,7 @@ struct kvm_pmc {
 	 * ctrl value for fixed counters.
 	 */
 	u64 current_config;
+	bool is_paused;
 };
 
 struct kvm_pmu {
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 827886c12c16..0772bad9165c 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -137,18 +137,20 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
 	pmc->perf_event = event;
 	pmc_to_pmu(pmc)->event_count++;
 	clear_bit(pmc->idx, pmc_to_pmu(pmc)->reprogram_pmi);
+	pmc->is_paused = false;
 }
 
 static void pmc_pause_counter(struct kvm_pmc *pmc)
 {
 	u64 counter = pmc->counter;
 
-	if (!pmc->perf_event)
+	if (!pmc->perf_event || pmc->is_paused)
 		return;
 
 	/* update counter, reset event value to avoid redundant accumulation */
 	counter += perf_event_pause(pmc->perf_event, true);
 	pmc->counter = counter & pmc_bitmask(pmc);
+	pmc->is_paused = true;
 }
 
 static bool pmc_resume_counter(struct kvm_pmc *pmc)
@@ -163,6 +165,7 @@ static bool pmc_resume_counter(struct kvm_pmc *pmc)
 
 	/* reuse perf_event to serve as pmc_reprogram_counter() does*/
 	perf_event_enable(pmc->perf_event);
+	pmc->is_paused = false;
 
 	clear_bit(pmc->idx, (unsigned long *)&pmc_to_pmu(pmc)->reprogram_pmi);
 	return true;
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 67e753edfa22..0e4f2b1fa9fb 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -55,7 +55,7 @@ static inline u64 pmc_read_counter(struct kvm_pmc *pmc)
 	u64 counter, enabled, running;
 
 	counter = pmc->counter;
-	if (pmc->perf_event)
+	if (pmc->perf_event && !pmc->is_paused)
 		counter += perf_event_read_value(pmc->perf_event,
 						 &enabled, &running);
 	/* FIXME: Scaling needed? */
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 9efc1a6b8693..10cc4f65c4ef 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -437,13 +437,13 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			    !(msr & MSR_PMC_FULL_WIDTH_BIT))
 				data = (s64)(s32)data;
 			pmc->counter += data - pmc_read_counter(pmc);
-			if (pmc->perf_event)
+			if (pmc->perf_event && !pmc->is_paused)
 				perf_event_period(pmc->perf_event,
 						  get_sample_period(pmc, data));
 			return 0;
 		} else if ((pmc = get_fixed_pmc(pmu, msr))) {
 			pmc->counter += data - pmc_read_counter(pmc);
-			if (pmc->perf_event)
+			if (pmc->perf_event && !pmc->is_paused)
 				perf_event_period(pmc->perf_event,
 						  get_sample_period(pmc, data));
 			return 0;
-- 
2.32.0

