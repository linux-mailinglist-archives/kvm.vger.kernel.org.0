Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CC1B609DA7
	for <lists+kvm@lfdr.de>; Mon, 24 Oct 2022 11:14:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbiJXJOc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Oct 2022 05:14:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231276AbiJXJOF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Oct 2022 05:14:05 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 154EE696E6
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 02:13:51 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id 20so8195661pgc.5
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 02:13:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Lw9Y59Kn+xhaw6POjvDvw41k8paQq3td8sumIgfruR8=;
        b=HUzOQscH4o8H+v0dhVH4qz3Igep9Vnd4woKHo4u5qbwBxLTla8t8JDanJ82vkvFS9g
         80pniZniMkSxZbpolBGzaYYkIHRbQ5AUEZN/07IOOTeLrrksE3K8biXdU0wdcwrCZsXP
         owRhNPOzXVxMfl7lQb32IIS9jKzFlU3aPejJ02wpiEk6nZkyHdLGnVj/KryUlNbW8RCr
         9jAyQwiVmofqNeNafuTCpfITM4MXSZ16HeEPgPt87xGRvuq0jUqKDi3ZzDCRJFs7yZ0l
         4+027pJeXhIh5O6CeQ7b5SYHIj+rE79NO4LL76wwNlnPZoGxhCOxDRQRvToNESGwhWVN
         6cHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Lw9Y59Kn+xhaw6POjvDvw41k8paQq3td8sumIgfruR8=;
        b=dlHEN0I/JEnUEa5dTN3UFqTGJAhA9EtzsH1KmaoYWqRnQLK8Peun1WQyLRnSsA2kt6
         kymg7zzc1k35HKcuINHbQXj9KT8os+GH7o0aBxcvzvBjHNpaEkq9kZA0yJ1CAfg9gwMB
         oB6GTWE4AKjJV9KLffO5xaGjftVNmOg9xTOtwFONLqJGripwGqtyQKLZvMZgsarBmbt6
         aMXDP6KlkeE5j0uwAI5T1WTIZhGX63CwqLKH+OP12f+raZIfeMRSesIjgzGkEzZ0/EyG
         jlDvQrBg4ojmg/8huBuN2t/ouRxzBgu0J6EAp6V9QDUF0/mmfDSUPkC/tLfbeNebCfcf
         mNnw==
X-Gm-Message-State: ACrzQf3RwPUfmIp1QzY0p0OndpweWg01loJ07s6syfm4ZJGLb2uzaKCO
        V37VFaDIOJ5h5eMn4yoVb+o=
X-Google-Smtp-Source: AMsMyM7lLAeTdPJNtwePcwQAkQ9ZpRNb4pQnz0KKu5t4nwKFLciG9wrwyepKL9O9dQ7qsLMM+7PdFA==
X-Received: by 2002:a63:4e66:0:b0:456:b3a7:7a80 with SMTP id o38-20020a634e66000000b00456b3a77a80mr26864919pgl.467.1666602821130;
        Mon, 24 Oct 2022 02:13:41 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id r15-20020aa79ecf000000b00535da15a252sm19642213pfq.165.2022.10.24.02.13.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Oct 2022 02:13:40 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v4 24/24] x86/pmu: Add AMD Guest PerfMonV2 testcases
Date:   Mon, 24 Oct 2022 17:12:23 +0800
Message-Id: <20221024091223.42631-25-likexu@tencent.com>
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

Updated test cases to cover KVM enabling code for AMD Guest PerfMonV2.

The Intel-specific PMU helpers were added to check for AMD cpuid, and
some of the same semantics of MSRs were assigned during the initialization
phase. The vast majority of pmu test cases are reused seamlessly.

On some x86 machines (AMD only), even with retired events, the same
workload is measured repeatedly and the number of events collected is
erratic, which essentially reflects the details of hardware implementation,
and from a software perspective, the type of event is an unprecise event,
which brings a tolerance check in the counter overflow testcases.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 lib/x86/msr.h       | 5 +++++
 lib/x86/pmu.c       | 9 ++++++++-
 lib/x86/pmu.h       | 6 +++++-
 lib/x86/processor.h | 2 +-
 4 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/lib/x86/msr.h b/lib/x86/msr.h
index 6cf8f33..c9869be 100644
--- a/lib/x86/msr.h
+++ b/lib/x86/msr.h
@@ -426,6 +426,11 @@
 #define MSR_CORE_PERF_GLOBAL_CTRL	0x0000038f
 #define MSR_CORE_PERF_GLOBAL_OVF_CTRL	0x00000390
 
+/* AMD Performance Counter Global Status and Control MSRs */
+#define MSR_AMD64_PERF_CNTR_GLOBAL_STATUS	0xc0000300
+#define MSR_AMD64_PERF_CNTR_GLOBAL_CTL		0xc0000301
+#define MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR	0xc0000302
+
 /* Geode defined MSRs */
 #define MSR_GEODE_BUSCONT_CONF0		0x00001900
 
diff --git a/lib/x86/pmu.c b/lib/x86/pmu.c
index 7fd2279..d4034cb 100644
--- a/lib/x86/pmu.c
+++ b/lib/x86/pmu.c
@@ -20,10 +20,17 @@ void pmu_init(void)
     } else {
         pmu.msr_gp_counter_base = MSR_F15H_PERF_CTR0;
         pmu.msr_gp_event_select_base = MSR_F15H_PERF_CTL0;
-        if (!has_amd_perfctr_core())
+        if (this_cpu_has(X86_FEATURE_AMD_PMU_V2))
+            pmu.nr_gp_counters = cpuid(0x80000022).b & 0xf;
+        else if (!has_amd_perfctr_core())
             pmu.nr_gp_counters = AMD64_NUM_COUNTERS;
         else
             pmu.nr_gp_counters = AMD64_NUM_COUNTERS_CORE;
+        if (this_cpu_support_perf_status()) {
+            pmu.msr_global_status = MSR_AMD64_PERF_CNTR_GLOBAL_STATUS;
+            pmu.msr_global_ctl = MSR_AMD64_PERF_CNTR_GLOBAL_CTL;
+            pmu.msr_global_status_clr = MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR;
+        }
     }
     reset_all_counters();
 }
\ No newline at end of file
diff --git a/lib/x86/pmu.h b/lib/x86/pmu.h
index a4e00c5..8f5b5ac 100644
--- a/lib/x86/pmu.h
+++ b/lib/x86/pmu.h
@@ -115,8 +115,12 @@ static inline void write_gp_event_select(unsigned int i, u64 value)
 
 static inline u8 pmu_version(void)
 {
-	if (!is_intel())
+	if (!is_intel()) {
+		/* Performance Monitoring Version 2 Supported */
+		if (this_cpu_has(X86_FEATURE_AMD_PMU_V2))
+			return 2;
 		return 0;
+	}
 
 	return cpuid_10.a & 0xff;
 }
diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index 64b36cf..7f884f7 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -266,7 +266,7 @@ static inline bool is_intel(void)
 #define X86_FEATURE_PAUSEFILTER		(CPUID(0x8000000A, 0, EDX, 10))
 #define X86_FEATURE_PFTHRESHOLD		(CPUID(0x8000000A, 0, EDX, 12))
 #define	X86_FEATURE_VGIF		(CPUID(0x8000000A, 0, EDX, 16))
-
+#define	X86_FEATURE_AMD_PMU_V2		(CPUID(0x80000022, 0, EAX, 0))
 
 static inline bool this_cpu_has(u64 feature)
 {
-- 
2.38.1

