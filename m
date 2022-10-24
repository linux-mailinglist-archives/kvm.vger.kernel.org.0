Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A3DD609DA9
	for <lists+kvm@lfdr.de>; Mon, 24 Oct 2022 11:14:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbiJXJO4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Oct 2022 05:14:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231262AbiJXJOF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Oct 2022 05:14:05 -0400
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE32968CC1
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 02:13:44 -0700 (PDT)
Received: by mail-oi1-x22c.google.com with SMTP id p127so10180847oih.9
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 02:13:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W0exMknsHAhrgvmnsuI1Ey6Y7vpYTw5SLOBYL5aM5Jk=;
        b=WtxS9JPp1hXw2GSTQ2s3TI1XBjBD6fIxtOlg70S8Kf4rv7FXW3eweBAkRmMvpcgws9
         tNcfdHdzdLL24gyVHX523elXKo7sFqV2Ba9YQorJMKTnBhW966TxVVNlME6VhNnpkoJN
         501N3yRMEYlFPl5bElx9NdAAh3TzSi/VkcX1IXdZ+Tlod8ab+Y2B7Okp+aVKf/dXTRDb
         UstUGWvFKdLvXFbTuqNqFKt+vzd+i/xKwjxMlacl5zj/oEYxsDOYR6K5ZSazxz2Vouzn
         l+RaC+GuQaqA7c9YNRMtAnI8r5AZK2wxgq3x1X1x+T2ipIJWZuonmtZzfEBJTlKFTPFH
         VMVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W0exMknsHAhrgvmnsuI1Ey6Y7vpYTw5SLOBYL5aM5Jk=;
        b=NzOcu86GCxPVH2+YP/sTwB4xilqt7Q/nrgSgU6CLkWcXtD8P43n89E007n7AqsKaNn
         7Mb0upiNdnDHEB6cjaYn5jMG3FKWwEcJSDnxcaXmP1HdFOtRCd4Gt6ZH0a/ugDx/JEBQ
         lv58puPz6QsdzcgXlYAmrMt1d7qW4oEh/S7W24CN8xYsbSWlvVahdRm4BZctMqFsDAkR
         rmjoWNuFrLqiSvpA4s5g3ZJydT/EvJOcls9yr46Gn0I9IWjKUud0MrLqTsSbIbkbqOCN
         gHS+9vLvQdgArM9nEBrEkW8pGOxN4Enu18hWyWdyHuW7DaVNifSaLWPm0b2Byqgk8Prk
         5wIg==
X-Gm-Message-State: ACrzQf0/+AvYOf8BZI+twXYXgwF0jaTNPchwldru1hZ4pghhV9wS3IHq
        WR9oZIKh2CCLFTK2VT23MlttVEdMGtF0Mg6S
X-Google-Smtp-Source: AMsMyM5S/gaqAUvKCVpIP7PB6eXwqWlCU4W/6EdGOMi6SQZDAqlJBYkE3uXngjWWEH8Vn/vSdDK/Gw==
X-Received: by 2002:a17:90b:1b05:b0:20d:3b10:3800 with SMTP id nu5-20020a17090b1b0500b0020d3b103800mr73181402pjb.91.1666602809264;
        Mon, 24 Oct 2022 02:13:29 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id r15-20020aa79ecf000000b00535da15a252sm19642213pfq.165.2022.10.24.02.13.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Oct 2022 02:13:29 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v4 17/24] x86/pmu: Add GP/Fixed counters reset helpers
Date:   Mon, 24 Oct 2022 17:12:16 +0800
Message-Id: <20221024091223.42631-18-likexu@tencent.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024091223.42631-1-likexu@tencent.com>
References: <20221024091223.42631-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

In generic pmu testing, it is very common to initialize the test env by
resetting counters registers. Add these helpers to for code reusability.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 lib/x86/pmu.c |  1 +
 lib/x86/pmu.h | 38 ++++++++++++++++++++++++++++++++++++++
 x86/pmu.c     |  2 +-
 3 files changed, 40 insertions(+), 1 deletion(-)

diff --git a/lib/x86/pmu.c b/lib/x86/pmu.c
index c0d100d..0ce1691 100644
--- a/lib/x86/pmu.c
+++ b/lib/x86/pmu.c
@@ -10,4 +10,5 @@ void pmu_init(void)
         pmu.perf_cap = rdmsr(MSR_IA32_PERF_CAPABILITIES);
     pmu.msr_gp_counter_base = MSR_IA32_PERFCTR0;
     pmu.msr_gp_event_select_base = MSR_P6_EVNTSEL0;
+    reset_all_counters();
 }
\ No newline at end of file
diff --git a/lib/x86/pmu.h b/lib/x86/pmu.h
index 7487a30..564b672 100644
--- a/lib/x86/pmu.h
+++ b/lib/x86/pmu.h
@@ -156,4 +156,42 @@ static inline bool pmu_use_full_writes(void)
 	return gp_counter_base() == MSR_IA32_PMC0;
 }
 
+static inline u32 fixed_counter_msr(unsigned int i)
+{
+	return MSR_CORE_PERF_FIXED_CTR0 + i;
+}
+
+static inline void write_fixed_counter_value(unsigned int i, u64 value)
+{
+	wrmsr(fixed_counter_msr(i), value);
+}
+
+static inline void reset_all_gp_counters(void)
+{
+	unsigned int idx;
+
+	for (idx = 0; idx < pmu_nr_gp_counters(); idx++) {
+		write_gp_event_select(idx, 0);
+		write_gp_counter_value(idx, 0);
+	}
+}
+
+static inline void reset_all_fixed_counters(void)
+{
+    unsigned int idx;
+
+	if (!pmu_nr_fixed_counters())
+		return;
+
+	wrmsr(MSR_CORE_PERF_FIXED_CTR_CTRL, 0);
+	for (idx = 0; idx < pmu_nr_fixed_counters(); idx++)
+		write_fixed_counter_value(idx, 0);
+}
+
+static inline void reset_all_counters(void)
+{
+    reset_all_gp_counters();
+    reset_all_fixed_counters();
+}
+
 #endif /* _X86_PMU_H_ */
diff --git a/x86/pmu.c b/x86/pmu.c
index 589c7cb..7786b49 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -397,7 +397,7 @@ static void check_rdpmc(void)
 			.idx = i
 		};
 
-		wrmsr(MSR_CORE_PERF_FIXED_CTR0 + i, x);
+		write_fixed_counter_value(i, x);
 		report(rdpmc(i | (1 << 30)) == x, "fixed cntr-%d", i);
 
 		exc = test_for_exception(GP_VECTOR, do_rdpmc_fast, &cnt);
-- 
2.38.1

