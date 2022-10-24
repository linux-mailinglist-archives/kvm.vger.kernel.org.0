Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09226609DA5
	for <lists+kvm@lfdr.de>; Mon, 24 Oct 2022 11:14:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231194AbiJXJO1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Oct 2022 05:14:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231208AbiJXJN4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Oct 2022 05:13:56 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DD636A535
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 02:13:41 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id y4so7951533plb.2
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 02:13:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x5bWOD+v2BlHUhIdaS0K1ucB/W7XeYKRWhxTgH+JxYc=;
        b=Bto57ZTybUsuftiCJ9+JzaXGtwjk2Qvd16kA4CyTfzQ1lgJpMcaaAiiQsIL6JeMmSF
         E9mq5q80o9ypVZaiHQ2gaUQltMN/y/A8alzwdBc0tN9sjw/XEfwRBHgKRnpt6KEJ7CbE
         k0DLNGIIaSrEehiqai8I6vOfV+s2eMuJzzON0jbgnWJKTj2Pujk3VdtW4sJ2DF15RG5A
         AekrNUrg6daITmebrq/2mMHrP/fcqmnVm3nhHS7ZK5muzwUypog75FNA7iLLHMf1sFSt
         3pl3m9Te8PEyGHJpT2xALiZvmDvQs3253SndDPJ5tOImNJm+appYXLXX5dqaog3v0LBq
         VhfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x5bWOD+v2BlHUhIdaS0K1ucB/W7XeYKRWhxTgH+JxYc=;
        b=OJx+hBZZJU2bp9JBd4C95vgJV3bwnUNhMXXoeZmcAEH2tOnNjvsM+tZ0PJW18JGJqG
         OrtTJQcuDIkwKJc3EEqcSEXCSnYoRb/NE8egw2iPjiBNlyjynOunQ9YV4COI3gFDQKSm
         AJ8cgU2AkxHWMrXI00OOjSUBcHxmX95anpCiJAWIshgi/MVznnelTG60yC4/lowR3IZJ
         4HG1+0BBrwygGKMMPW78EceXdJUisYVWhCJxZSWqf6dCsSRGLsFRj7f4YAyKGnGW0VGS
         ZxLEIspgt4U2QBUrWm63DfBFzxTY/+RcOYUxjSskeEwXtOoeozQ6CL/CWroDb01AE4CK
         It6w==
X-Gm-Message-State: ACrzQf1y4MnpcuHUaZbX/hy8Tx0enrXUs348LQkqnzuXp/IvX9/FZ+xu
        M2sW8SWk83K4Z5c18JRLf6mIqZKKgbSc8eT9
X-Google-Smtp-Source: AMsMyM5A1GEBXISLDJOCrZgBb9x6sv3zCe9ItgsiYhxMi3eqfFq7LJoGRdYyTrPN1PMUDltfuQmoGw==
X-Received: by 2002:a17:902:690a:b0:17a:32d:7acc with SMTP id j10-20020a170902690a00b0017a032d7accmr32790443plk.18.1666602817582;
        Mon, 24 Oct 2022 02:13:37 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id r15-20020aa79ecf000000b00535da15a252sm19642213pfq.165.2022.10.24.02.13.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Oct 2022 02:13:37 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v4 22/24] x86/pmu: Add nr_gp_counters to limit the number of test counters
Date:   Mon, 24 Oct 2022 17:12:21 +0800
Message-Id: <20221024091223.42631-23-likexu@tencent.com>
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

The number of counters in amd is fixed (4 or 6), and the test code
can be reused by dynamically switching the maximum number of counters
(and register base addresses), with no change for Intel side.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 lib/x86/pmu.c | 1 +
 lib/x86/pmu.h | 9 ++++++++-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/lib/x86/pmu.c b/lib/x86/pmu.c
index 43e6a43..25e21e5 100644
--- a/lib/x86/pmu.c
+++ b/lib/x86/pmu.c
@@ -10,6 +10,7 @@ void pmu_init(void)
         pmu.perf_cap = rdmsr(MSR_IA32_PERF_CAPABILITIES);
     pmu.msr_gp_counter_base = MSR_IA32_PERFCTR0;
     pmu.msr_gp_event_select_base = MSR_P6_EVNTSEL0;
+    pmu.nr_gp_counters = (cpuid_10.a >> 8) & 0xff;
     if (this_cpu_support_perf_status()) {
         pmu.msr_global_status = MSR_CORE_PERF_GLOBAL_STATUS;
         pmu.msr_global_ctl = MSR_CORE_PERF_GLOBAL_CTRL;
diff --git a/lib/x86/pmu.h b/lib/x86/pmu.h
index fa49a8f..4312b6e 100644
--- a/lib/x86/pmu.h
+++ b/lib/x86/pmu.h
@@ -54,6 +54,7 @@ struct pmu_caps {
     u32 msr_global_status;
     u32 msr_global_ctl;
     u32 msr_global_status_clr;
+    unsigned int nr_gp_counters;
 };
 
 extern struct cpuid cpuid_10;
@@ -123,7 +124,13 @@ static inline bool this_cpu_support_perf_status(void)
 
 static inline u8 pmu_nr_gp_counters(void)
 {
-	return (cpuid_10.a >> 8) & 0xff;
+	return pmu.nr_gp_counters;
+}
+
+static inline void set_nr_gp_counters(u8 new_num)
+{
+	if (new_num < pmu_nr_gp_counters())
+		pmu.nr_gp_counters = new_num;
 }
 
 static inline u8 pmu_gp_counter_width(void)
-- 
2.38.1

