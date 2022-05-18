Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7FD452C06B
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 19:10:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240673AbiERRBg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 13:01:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240653AbiERRBc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 13:01:32 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F354333E1E;
        Wed, 18 May 2022 10:01:29 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id i1so2349627plg.7;
        Wed, 18 May 2022 10:01:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RcLHuOHV+RcpwGuZbYj1dwn0uVanHpALeVRluvJ4g1I=;
        b=K04yJM6DTJUgL8ulQk9SeqQC4aMUlA0X9pcm/57phnuJEd8CJpCNkJ53QfDFtTCd29
         1z4efV2UH/LoajUWyy9G98L46LR0FKlvEA3JC/fC9f0fGvu84OcftYWXlfNTowf5VFOT
         GzlVf8UhUQSW9CtN4neQwhArRRFr2C7oZiGsL0FnruJF0tkpJMSr71FIwFk27Qpk2zsm
         vQwoSZm2vgRaMuyqYsEaFVFJ7ea+XatN1hnmzpGBstBCq16R8txpKOlzHtKDvRoJZQpC
         TqeOrnGnQHDGypzLstsrySlutf/CBsGfqEOslSTa6b0GsBiMFBQP1atedfF7w7tjb4YH
         47VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RcLHuOHV+RcpwGuZbYj1dwn0uVanHpALeVRluvJ4g1I=;
        b=bN4Kl9WEyiETuVgM64Z6V7qb6CIooimgLKwJv3ALXFjUIPap2sKw/Hc5SX0xHQzgdV
         2jer88HyuG5aP2zQMkU/uNolXo/8qq13iLkt4xhjZKxIjiktEajoxbftS9QRElt0+jOg
         zlrwKEtkYcTclhJOfJ0pWxokztlaUH9/pHmo01Kw8//Z0KifxWxXA0GxVcAXSVXesxYx
         CU1dYSIXJhxD7RJ5PRcRTZNiq1NppHNQfrJhDk4F/+LVIAafPDVC+Y7OFAWZG8MVKz1Z
         DqL1B1fnEf714vMflp7BHYh1mvpE/8xn9V4SiE4fMRfhS2wFbwl5uXBP6CjjkSH1oOfa
         w3PA==
X-Gm-Message-State: AOAM532uBtvD6pZwJmGnO6eDpE3gQEHNzuc3hiijlYuR0KVFoXUPOEvx
        R8ADIC7ldzX7PXgr7e2aqSE=
X-Google-Smtp-Source: ABdhPJx0XLUuLwYHCSHly5djoS/xd+ihCGXyWkcmfhvIY5k20ccuv0i5oQYvMkcbWEEftuSU5Zlbog==
X-Received: by 2002:a17:902:f64c:b0:156:7ceb:b579 with SMTP id m12-20020a170902f64c00b001567cebb579mr496428plg.73.1652893288645;
        Wed, 18 May 2022 10:01:28 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.117])
        by smtp.gmail.com with ESMTPSA id p42-20020a056a0026ea00b0050dc762818dsm2283240pfw.103.2022.05.18.10.01.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 May 2022 10:01:28 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] KVM: x86/pmu: Update global enable_pmu when PMU is undetected
Date:   Thu, 19 May 2022 01:01:18 +0800
Message-Id: <20220518170118.66263-3-likexu@tencent.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220518170118.66263-1-likexu@tencent.com>
References: <20220518170118.66263-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

On some virt platforms (L1 guest w/o PMU), the value of module parameter
'enable_pmu' for nested L2 guests should be updated at initialisation.

Considering that there is no concept of "architecture pmu" in AMD or Hygon
and that the versions (prior to Zen 4) are all 0, but that the theoretical
available counters are at least AMD64_NUM_COUNTERS, the utility
check_hw_exists() is reused in the initialisation call path.

Opportunistically update Intel specific comments.

Fixes: 8eeac7e999e8 ("KVM: x86/pmu: Add kvm_pmu_cap to optimize perf_get_x86_pmu_capability")
Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/events/core.c |  6 ++++++
 arch/x86/kvm/pmu.h     | 15 ++++++++++-----
 2 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index 7f1d10dbabc0..865eeb500a71 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -2982,6 +2982,12 @@ unsigned long perf_misc_flags(struct pt_regs *regs)
 
 void perf_get_x86_pmu_capability(struct x86_pmu_capability *cap)
 {
+	if (!check_hw_exists(&pmu, x86_pmu.num_counters,
+			     x86_pmu.num_counters_fixed)) {
+		memset(cap, 0, sizeof(*cap));
+		return;
+	}
+
 	cap->version		= x86_pmu.version;
 	/*
 	 * KVM doesn't support the hybrid PMU yet.
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index ecf2962510e4..b200d080a8a3 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -150,14 +150,19 @@ extern struct x86_pmu_capability kvm_pmu_cap;
 
 static inline void kvm_init_pmu_capability(void)
 {
+	bool is_intel = boot_cpu_data.x86_vendor == X86_VENDOR_INTEL;
+
 	perf_get_x86_pmu_capability(&kvm_pmu_cap);
 
-	/*
-	 * Only support guest architectural pmu on
-	 * a host with architectural pmu.
-	 */
-	if (!kvm_pmu_cap.version)
+	 /*
+	  * For Intel, only support guest architectural pmu
+	  * on a host with architectural pmu.
+	  */
+	if ((is_intel && !kvm_pmu_cap.version) || !kvm_pmu_cap.num_counters_gp) {
 		memset(&kvm_pmu_cap, 0, sizeof(kvm_pmu_cap));
+		enable_pmu = false;
+		return;
+	}
 
 	kvm_pmu_cap.version = min(kvm_pmu_cap.version, 2);
 	kvm_pmu_cap.num_counters_fixed = min(kvm_pmu_cap.num_counters_fixed,
-- 
2.36.1

