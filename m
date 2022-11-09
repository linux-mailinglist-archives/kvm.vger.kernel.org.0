Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B670622572
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 09:29:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbiKII3K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 03:29:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229955AbiKII2l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 03:28:41 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00CA42DF4;
        Wed,  9 Nov 2022 00:28:26 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id y203so16053316pfb.4;
        Wed, 09 Nov 2022 00:28:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rsRdQU8Ady+UGmrXI+CqXDPucP2vHJde8y88ZmpGZsM=;
        b=LKISIc2cB6Z6TO9vuFDS5ZgjgvbrRGTXBX69S8YrBIn0o1OHvc2k9kK8Kx6t6+VfuD
         o8bCBUU6n2Fzs+eSZm9X5jFoWEgpt4tl0w+bMyANW/Zpk2v/2BHzD7QL6Iq6X/MZtsCm
         rzmyM5DIu8P5S+7wi/49ISCXvUoPZDyDngxblUiYnY3oJ6PgYmMQKx/D4N0ft6YLewXf
         sk9cQMXrM5vgs16LzKtFy3d9dewRtMSGyyMoWBowgUZwmendk2wya/p2hiM3RDOkcFt2
         257FgWVBfrtCTtnYWk4ynJUnUugj9ZUga6NzbKbT2OOBIywsj6u0YytRIn8iTiYUcrzo
         q7jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rsRdQU8Ady+UGmrXI+CqXDPucP2vHJde8y88ZmpGZsM=;
        b=BMQ96bu9CBees8hdhpQmZXYb1keT7KvMqwdyziLq1ZHzzxpg9UHjOl+2+rKzFQuY76
         fuClxejPqS1id2ftkVHP6MXPHvBoFlYLGYDmqRVYU6Fb0HNk0Sqmnh+T9B4UBalHbTh2
         NRIgk1UJ/Ub24OM1eVtwjdJrRHgwn7Jy9wUmlY6GN+hpDGmhiMbkM0WuxF7YsSQ8xTtJ
         PZoauSQirVxofAwSGhhv5OOXxuu6e2g2o2JwY5rxQI8x9epStVYHe/ZSh1MWUiUXpzEu
         HMlF4axYm77J5lmp90kPtsw/wHhlPooQzrPOZLS5S91wUAn1JE3XoatLhqZfEF7FxrZE
         lqng==
X-Gm-Message-State: ACrzQf31ITDUByQfZ59GRsvlmEjCc4Ga980bMK5WPkVuMTWpC255E5W2
        JmlJS1953kbaHIjKxIHZreg=
X-Google-Smtp-Source: AMsMyM7uM/wr15aY5dKimOK9PE2hO2hPz/ddyvr/0+ef1EuLKlZcHLXgIJo1RN4nRzQ1ElZq3gS2mA==
X-Received: by 2002:a63:d14a:0:b0:470:3fc2:bed5 with SMTP id c10-20020a63d14a000000b004703fc2bed5mr21992121pgj.590.1667982506475;
        Wed, 09 Nov 2022 00:28:26 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id b14-20020a63d30e000000b00470537b9b0asm6587700pgg.51.2022.11.09.00.28.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Nov 2022 00:28:26 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        linux-perf-users@vger.kernel.org,
        Kan Liang <kan.liang@linux.intel.com>
Subject: [PATCH v3 3/3] perf/x86/intel: Expose EPT-friendly PEBS for SPR and future models
Date:   Wed,  9 Nov 2022 16:28:02 +0800
Message-Id: <20221109082802.27543-4-likexu@tencent.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221109082802.27543-1-likexu@tencent.com>
References: <20221109082802.27543-1-likexu@tencent.com>
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

According to Intel SDM, the EPT-friendly PEBS is supported by all the
platforms after ICX, ADL and the future platforms with PEBS format 5.

Currently the only in-kernel user of this capability is KVM, which has
very limited support for hybrid core pmu, so ADL and its successors do
not currently expose this capability. When both hybrid core and PEBS
format 5 are present, KVM will decide on its own merits.

Cc: Peter Zijlstra <peterz@infradead.org>
Cc: linux-perf-users@vger.kernel.org
Suggested-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Like Xu <likexu@tencent.com>
Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
---
Nit: This change is proposed to be applied via the KVM tree.

 arch/x86/events/intel/core.c | 1 +
 arch/x86/events/intel/ds.c   | 4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index a646a5f9a235..15e061fbb2f3 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -6350,6 +6350,7 @@ __init int intel_pmu_init(void)
 		x86_pmu.pebs_constraints = intel_spr_pebs_event_constraints;
 		x86_pmu.extra_regs = intel_spr_extra_regs;
 		x86_pmu.limit_period = spr_limit_period;
+		x86_pmu.pebs_ept = 1;
 		x86_pmu.pebs_aliases = NULL;
 		x86_pmu.pebs_prec_dist = true;
 		x86_pmu.pebs_block = true;
diff --git a/arch/x86/events/intel/ds.c b/arch/x86/events/intel/ds.c
index 7839507b3844..185e66b4ce31 100644
--- a/arch/x86/events/intel/ds.c
+++ b/arch/x86/events/intel/ds.c
@@ -2293,8 +2293,10 @@ void __init intel_ds_init(void)
 			x86_pmu.large_pebs_flags |= PERF_SAMPLE_TIME;
 			break;
 
-		case 4:
 		case 5:
+			x86_pmu.pebs_ept = 1;
+			fallthrough;
+		case 4:
 			x86_pmu.drain_pebs = intel_pmu_drain_pebs_icl;
 			x86_pmu.pebs_record_size = sizeof(struct pebs_basic);
 			if (x86_pmu.intel_cap.pebs_baseline) {
-- 
2.38.1

