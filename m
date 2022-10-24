Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B655609D9E
	for <lists+kvm@lfdr.de>; Mon, 24 Oct 2022 11:13:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbiJXJNs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Oct 2022 05:13:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231168AbiJXJNj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Oct 2022 05:13:39 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AB0E68CF7
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 02:13:27 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id g62so4456016pfb.10
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 02:13:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SFaZTlHcQRjsut1B3hTFdCAleH/8KeDEboCMJpbltJY=;
        b=OdXXQ9l/AcIKaLGrGL3g8hXErt8vIm/WWPm1dNWLtlBDqgf9GZgu+sivR/Fm+Hizk7
         uQ05z/67P127edRmQgmwKWfINEHB+ch3jWxMpPmhSvoAaQ0Tlz2TFBa4uAqR7E4uU0o6
         HxwLB9kxElUo8bFMRG5SqJ7SdvOzb1dYOnQuI14gNk8j9xFLFlNcxwzL7qJlDL3JPlVB
         +8KipnlHEb1ruLQOv9h+n46ruGzwgnox6U9++7zfADacO8N5OATRC8c195o/AgEnkqMF
         LfrNF9GKbG8nZMg8xCir68xNS+o43/KTF4PCFeCUF0pJfXMjQVRvHNVFiJG0GjzcRBWC
         34/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SFaZTlHcQRjsut1B3hTFdCAleH/8KeDEboCMJpbltJY=;
        b=nZhaKUDslAI0nQa7ithw43H27SrWvC22Y7r5IqOLKreo4kCWe56oo/kgNzYU0a5nqw
         LgVBrUpM/Ff6XccnuBiEC0b3kbEvB91i0hOLvxiJFqgzzO+2ELhXWbvhewk6UyekYh/t
         ViNfDYvpJa8ENU5rtViOI732MMqA4n0a6tNdIdHdBBCQWKMAXJlxzkyw0EI9FKt2jVh6
         5plLA072vkooBDpcSEosJo71upr7kZoD/bcIU6nAXcPTcfnRD+QPuO7WRzYG0HVxc+3n
         iy2ajRuWNKTGZ1RZ3QOE1yg+mtDIbPiX19W8hHOh3NwYS0/qoRr3nXTem5lhtVASSNPm
         8ajw==
X-Gm-Message-State: ACrzQf2+Hmo7uaNVi2Oa0cTPsdxU1P8RtTAE7fLdfJHkNXUYyHbkoYyi
        vU5B90eMXOZYWjTZX525ZPgeWiT+NKFqAkOO
X-Google-Smtp-Source: AMsMyM7fHyZ1hIs9Pr45JadiCY0b96PPVnevD/C0zJPdTCFChJlvxltoticSGBssd5do5lKKl9AVMQ==
X-Received: by 2002:aa7:9292:0:b0:56b:c4d3:a723 with SMTP id j18-20020aa79292000000b0056bc4d3a723mr5168641pfa.57.1666602804465;
        Mon, 24 Oct 2022 02:13:24 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id r15-20020aa79ecf000000b00535da15a252sm19642213pfq.165.2022.10.24.02.13.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Oct 2022 02:13:24 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v4 14/24] x86/pmu: Read cpuid(10) in the pmu_init() to reduce VM-Exit
Date:   Mon, 24 Oct 2022 17:12:13 +0800
Message-Id: <20221024091223.42631-15-likexu@tencent.com>
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

The type of CPUID accessors can also go in the common pmu. Re-reading
cpuid(10) each time when needed, adding the overhead of eimulating
CPUID isn't meaningless in the grand scheme of the test.

A common "PMU init" routine would allow the library to provide helpers
access to more PMU common information.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Like Xu <likexu@tencent.com>
---
 lib/x86/pmu.c |  7 +++++++
 lib/x86/pmu.h | 26 +++++++++++++-------------
 lib/x86/smp.c |  2 ++
 3 files changed, 22 insertions(+), 13 deletions(-)

diff --git a/lib/x86/pmu.c b/lib/x86/pmu.c
index 9d048ab..e8b9ae9 100644
--- a/lib/x86/pmu.c
+++ b/lib/x86/pmu.c
@@ -1 +1,8 @@
 #include "pmu.h"
+
+struct cpuid cpuid_10;
+
+void pmu_init(void)
+{
+    cpuid_10 = cpuid(10);
+}
\ No newline at end of file
diff --git a/lib/x86/pmu.h b/lib/x86/pmu.h
index 078a974..7f4e797 100644
--- a/lib/x86/pmu.h
+++ b/lib/x86/pmu.h
@@ -33,9 +33,13 @@
 #define EVNTSEL_INT	(1 << EVNTSEL_INT_SHIFT)
 #define EVNTSEL_INV	(1 << EVNTSEL_INV_SHIF)
 
+extern struct cpuid cpuid_10;
+
+void pmu_init(void);
+
 static inline u8 pmu_version(void)
 {
-	return cpuid(10).a & 0xff;
+	return cpuid_10.a & 0xff;
 }
 
 static inline bool this_cpu_has_pmu(void)
@@ -50,35 +54,31 @@ static inline bool this_cpu_has_perf_global_ctrl(void)
 
 static inline u8 pmu_nr_gp_counters(void)
 {
-	return (cpuid(10).a >> 8) & 0xff;
+	return (cpuid_10.a >> 8) & 0xff;
 }
 
 static inline u8 pmu_gp_counter_width(void)
 {
-	return (cpuid(10).a >> 16) & 0xff;
+	return (cpuid_10.a >> 16) & 0xff;
 }
 
 static inline u8 pmu_gp_counter_mask_length(void)
 {
-	return (cpuid(10).a >> 24) & 0xff;
+	return (cpuid_10.a >> 24) & 0xff;
 }
 
 static inline u8 pmu_nr_fixed_counters(void)
 {
-	struct cpuid id = cpuid(10);
-
-	if ((id.a & 0xff) > 1)
-		return id.d & 0x1f;
+	if ((cpuid_10.a & 0xff) > 1)
+		return cpuid_10.d & 0x1f;
 	else
 		return 0;
 }
 
 static inline u8 pmu_fixed_counter_width(void)
 {
-	struct cpuid id = cpuid(10);
-
-	if ((id.a & 0xff) > 1)
-		return (id.d >> 5) & 0xff;
+	if ((cpuid_10.a & 0xff) > 1)
+		return (cpuid_10.d >> 5) & 0xff;
 	else
 		return 0;
 }
@@ -86,7 +86,7 @@ static inline u8 pmu_fixed_counter_width(void)
 static inline bool pmu_gp_counter_is_available(int i)
 {
 	/* CPUID.0xA.EBX bit is '1 if they counter is NOT available. */
-	return !(cpuid(10).b & BIT(i));
+	return !(cpuid_10.b & BIT(i));
 }
 
 static inline u64 this_cpu_perf_capabilities(void)
diff --git a/lib/x86/smp.c b/lib/x86/smp.c
index b9b91c7..29197fc 100644
--- a/lib/x86/smp.c
+++ b/lib/x86/smp.c
@@ -4,6 +4,7 @@
 #include <asm/barrier.h>
 
 #include "processor.h"
+#include "pmu.h"
 #include "atomic.h"
 #include "smp.h"
 #include "apic.h"
@@ -155,6 +156,7 @@ void smp_init(void)
 		on_cpu(i, setup_smp_id, 0);
 
 	atomic_inc(&active_cpus);
+	pmu_init();
 }
 
 static void do_reset_apic(void *data)
-- 
2.38.1

