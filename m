Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B489449046C
	for <lists+kvm@lfdr.de>; Mon, 17 Jan 2022 09:53:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233396AbiAQIxg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jan 2022 03:53:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233394AbiAQIxY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jan 2022 03:53:24 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6FF7C06161C;
        Mon, 17 Jan 2022 00:53:23 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id a1-20020a17090a688100b001b3fd52338eso20325689pjd.1;
        Mon, 17 Jan 2022 00:53:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iLKh4jjpdruPr4hhY3zahQJ34QEJpoEkxu9u4zI2/uM=;
        b=QtOEoT9BrvTiuf0UOuXKHM63+F76N+lhoB9cndC51ZVvn6bUyLa9XY3GtYpDT65dMo
         eYtYNQ3PmruwfRG0Jw4S839eOEMwD1ZdhDgCU94C3PuuzPr+EVN4wbVuy+ufJEOMNh+h
         vHhGuXQB7c16ucFuIshesAL9r4wFdIaAM2egyXWMYjQpgRO0mkkoNSKTB3IcjaLBqBc+
         stCFOPXbtdhrqbx3lnB/VQKiVIF7gluM/jjmM7NYlgBRFHygYC3QsHNRs542OkX/cqo7
         9iU8nrOAERi2JjDUgSu7zlwoi6Q3pQ9PLzNMGeAKnw7c6O44BN6eYreEkuoHVAtWI/UH
         jrLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iLKh4jjpdruPr4hhY3zahQJ34QEJpoEkxu9u4zI2/uM=;
        b=lpWUXubuEyOcgarhoIgORG/e2EvttHfR1zaRUBhpBmtCCY+1YCFF5Y52HCPs3BuxEY
         NlThDbueHwL/1ERfrA9SL0d+VYI2HylPf/UVB1QS4d0wsexGtKAeqbVSqFUpoA6Xnv2d
         OgZd4DEhST9Fz2/YoTYGTAyKmcWloY+/1MAz/ykwzRZSGmrE2ikH2n4bIxFF6AgEqIsx
         DHKcuemPOiIR7Q1A6ZTa0BaHfaFHmwLMZE5ujPRQohUHE6ir69Il4BocJWxMEl0RzQgf
         HuBuh03NjvEvIZAXxjBejpROXWh3d6BXI1zh6qlZfCQxcjSq6nLlzOuNCiGtJ8QnGPtO
         3gpA==
X-Gm-Message-State: AOAM5304mcPLn4GIftZ88xsQAzGSXBu2JHDLLTKkjf4YiFCjoDxB8JFj
        7MuhtFZ8izq+nXtyuVHbT2Q=
X-Google-Smtp-Source: ABdhPJxgLuR8PzUg8G3nROpAJnFp6K4/2o0JaUq3K0gPO6CyaX8B5ux4AaA6tQfuVbBRUAnZIYN2Aw==
X-Received: by 2002:a17:902:8693:b0:148:a2e7:fb5a with SMTP id g19-20020a170902869300b00148a2e7fb5amr21100880plo.155.1642409603509;
        Mon, 17 Jan 2022 00:53:23 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id q4sm13849686pfj.84.2022.01.17.00.53.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jan 2022 00:53:23 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <likexu@tencent.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH kvm/queue v2 2/3] perf: x86/core: Add interface to query perfmon_event_map[] directly
Date:   Mon, 17 Jan 2022 16:53:06 +0800
Message-Id: <20220117085307.93030-3-likexu@tencent.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220117085307.93030-1-likexu@tencent.com>
References: <20220117085307.93030-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

Currently, we have [intel|knc|p4|p6]_perfmon_event_map on the Intel
platforms and amd_[f17h]_perfmon_event_map on the AMD platforms.

Early clumsy KVM code or other potential perf_event users may have
hard-coded these perfmon_maps (e.g., arch/x86/kvm/svm/pmu.c), so
it would not make sense to program a common hardware event based
on the generic "enum perf_hw_id" once the two tables do not match.

Let's provide an interface for callers outside the perf subsystem to get
the counter config based on the perfmon_event_map currently in use,
and it also helps to save bytes.

Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/events/core.c            | 9 +++++++++
 arch/x86/include/asm/perf_event.h | 2 ++
 2 files changed, 11 insertions(+)

diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index 38b2c779146f..751048f4cc97 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -693,6 +693,15 @@ void x86_pmu_disable_all(void)
 	}
 }
 
+u64 perf_get_hw_event_config(int perf_hw_id)
+{
+	if (perf_hw_id < x86_pmu.max_events)
+		return x86_pmu.event_map(perf_hw_id);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(perf_get_hw_event_config);
+
 struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr)
 {
 	return static_call(x86_pmu_guest_get_msrs)(nr);
diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 8fc1b5003713..d1e325517b74 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -492,9 +492,11 @@ static inline void perf_check_microcode(void) { }
 
 #if defined(CONFIG_PERF_EVENTS) && defined(CONFIG_CPU_SUP_INTEL)
 extern struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr);
+extern u64 perf_get_hw_event_config(int perf_hw_id);
 extern int x86_perf_get_lbr(struct x86_pmu_lbr *lbr);
 #else
 struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr);
+u64 perf_get_hw_event_config(int perf_hw_id);
 static inline int x86_perf_get_lbr(struct x86_pmu_lbr *lbr)
 {
 	return -1;
-- 
2.33.1

