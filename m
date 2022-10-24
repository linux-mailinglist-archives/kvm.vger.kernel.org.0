Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4483609D98
	for <lists+kvm@lfdr.de>; Mon, 24 Oct 2022 11:13:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231232AbiJXJNb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Oct 2022 05:13:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231194AbiJXJNZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Oct 2022 05:13:25 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B304B6A4AE
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 02:13:20 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id b29so4043335pfp.13
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 02:13:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YibZy+BFQ3euZlRWTAO2YccWowhNFq/VeLwfRP/m6QM=;
        b=bHzVuwu3wrjkp7HlWHall2En6UODNIY5FYvbbxpJK77MdoM0+RgnMA6MkdExV/2094
         ns69h1yIrE9+HzBRulNEcPALhW2SxClNwB8mtpNnEFSvj0lQhcbMiuMqtNMLFvTCzD2u
         of3eo76c7K0V1715zN9aG4QY52YJhrV0rU5FnZGArFGSg1DZwpy9WefQka/x9uR1Ozz9
         AFd6O2TfxDsnCu7K8r1xySZTzuf8HsHkUWAI9QGu3AQ/XLN/Y4droLmKpcmAO48q/Yoh
         g3LePWSA/TiPlZCNq5y1lm3r4behloYd/zgrWG1jAAIfvImJkhiWgHVWj6P0EguD/U+H
         AThQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YibZy+BFQ3euZlRWTAO2YccWowhNFq/VeLwfRP/m6QM=;
        b=Qsmht1AjpjTgFNu7ISOTjdDwaXI+O5m61fAJVlUVit2g1T1HT/i53y5TyYpluAwUSD
         tSQ5iKK3FyEwIhcwCm73zYsobv/ND1ftIJng5sFHDkuO6zjzqUyhg/A5gpGS0B8f8RKC
         uHux5KJEQRi0r9MjUviOiIHiH/+21nN9xxVJTieL1z4Eu4aQrRhFugMTt4jSp/YZa/Xm
         KImbFU0w1hHxeE9etPzQXUc/U0/WCsVz12sV4NJIZif5VvdYBbMJWbztLVcbJGiXsn8O
         ESUUGIv8iYc7olsRwh8iZA/cYYz6qqaqRLlVvVjkV+1RwjL3powyU5oPhjlCGaJD6nhH
         fNyw==
X-Gm-Message-State: ACrzQf3W//OGSjcuLFioOce52MDUlWOXUjKmojcxzTXfHZwPduKZvEZ7
        jgEwvN/2WL3D1e+j6soqAVs=
X-Google-Smtp-Source: AMsMyM58Jce/SNBl9snXAQT+O4akbHR9RYdwMF/Ft2JM4hia6XPOhbKTft9p7P9UMsx8SSpfRRnbCw==
X-Received: by 2002:a63:db14:0:b0:44d:e4f3:b45c with SMTP id e20-20020a63db14000000b0044de4f3b45cmr26643765pgg.267.1666602799604;
        Mon, 24 Oct 2022 02:13:19 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id r15-20020aa79ecf000000b00535da15a252sm19642213pfq.165.2022.10.24.02.13.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Oct 2022 02:13:19 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v4 11/24] x86/pmu: Update rdpmc testcase to cover #GP path
Date:   Mon, 24 Oct 2022 17:12:10 +0800
Message-Id: <20221024091223.42631-12-likexu@tencent.com>
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

Specifying an unsupported PMC encoding will cause a #GP(0).

There are multiple reasons RDPMC can #GP, the one that is being relied
on to guarantee #GP is specifically that the PMC is invalid. The most
extensible solution is to provide a safe variant.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Like Xu <likexu@tencent.com>
---
 lib/x86/processor.h | 21 ++++++++++++++++++---
 x86/pmu.c           | 10 ++++++++++
 2 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index f85abe3..cb396ed 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -438,11 +438,26 @@ static inline int wrmsr_safe(u32 index, u64 val)
 	return exception_vector();
 }
 
-static inline uint64_t rdpmc(uint32_t index)
+static inline int rdpmc_safe(u32 index, uint64_t *val)
 {
 	uint32_t a, d;
-	asm volatile ("rdpmc" : "=a"(a), "=d"(d) : "c"(index));
-	return a | ((uint64_t)d << 32);
+
+	asm volatile (ASM_TRY("1f")
+		      "rdpmc\n\t"
+		      "1:"
+		      : "=a"(a), "=d"(d) : "c"(index) : "memory");
+	*val = (uint64_t)a | ((uint64_t)d << 32);
+	return exception_vector();
+}
+
+static inline uint64_t rdpmc(uint32_t index)
+{
+	uint64_t val;
+	int vector = rdpmc_safe(index, &val);
+
+	assert_msg(!vector, "Unexpected %s on RDPMC(%d)",
+			exception_mnemonic(vector), index);
+	return val;
 }
 
 static inline int write_cr0_safe(ulong val)
diff --git a/x86/pmu.c b/x86/pmu.c
index 15572e3..d0de196 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -651,12 +651,22 @@ static void set_ref_cycle_expectations(void)
 	gp_events[2].max = (gp_events[2].max * cnt.count) / tsc_delta;
 }
 
+static void check_invalid_rdpmc_gp(void)
+{
+	uint64_t val;
+
+	report(rdpmc_safe(64, &val) == GP_VECTOR,
+	       "Expected #GP on RDPMC(64)");
+}
+
 int main(int ac, char **av)
 {
 	setup_vm();
 	handle_irq(PC_VECTOR, cnt_overflow);
 	buf = malloc(N*64);
 
+	check_invalid_rdpmc_gp();
+
 	if (!pmu_version()) {
 		report_skip("No Intel Arch PMU is detected!");
 		return report_summary();
-- 
2.38.1

