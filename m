Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C533643EA4
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 09:30:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234126AbiLFIab (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 03:30:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233928AbiLFIaP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 03:30:15 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AAE51AD97;
        Tue,  6 Dec 2022 00:30:13 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id b13-20020a17090a5a0d00b0021906102d05so14075761pjd.5;
        Tue, 06 Dec 2022 00:30:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x4H9uEd2CTHNwSO9zkkhB6GGsRkjPW9q6aNFznzOIuA=;
        b=eqXU0JrlUMmKM/33ndMGd7IBaBh2rYY1aFwhSs4o2njfDwpmTiUEQ5qiv8z5icJ+9n
         VNM5IaLFLG16GTmtxYeYecs/Pc5+Z+OHU173oCl2VaYDlEyhVAhhJQmqm4ZWV5vqQd+o
         lmIXdoRYO8v3J+HwnGsaXuA5kuADrEx97ogBkQcopnqQIZTqg8RjOFL6STJO6GpxExHR
         0dxwOaVeHtVSNhZqCQs9UO6r9WzV5ySA9D4c2PE2z16E03yWfXcXvLxh+K8A4OvCR7UJ
         +Kf2I6vfhKb90HEF1IGyDpFOsOKYrE7O6h1zreV/4Hc5KkrCzDPWVu/lcr4+UvGJPDqe
         us2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x4H9uEd2CTHNwSO9zkkhB6GGsRkjPW9q6aNFznzOIuA=;
        b=1BhwCg14xlHJulzGlqnR2s7OdctL/Jme7rg8Qx0XaSkvoQrRgrynMpQlS+wK+zpyMr
         dGfHdcQMAseDYwj0+UA5AFBScLDhuVZ2LWMxn99IgSQoI5XizxoyR35voPv6/gEskTw6
         0512+yRp6mcZYMu7lDp63hmdjt5Rt/+5u4raecNL/8YmsSbFFmw26zShMMXv3swM/XMo
         cghKdCozl0wTwTostNZZlBaDk0ZX6vRK3FWFQU2e/TlXvN7Ov/IbxpR3Gsjc+QcPxBJt
         +2n7ns6AFAGFpqOx3L6rK9Dl5PvgN/+Lre9Jz3wMYDwsWCGmgSNJdvE4yl8Vr5ltpG6/
         rLqw==
X-Gm-Message-State: ANoB5pnKaaV50UEoWqLtPaTY0PLztrtRnmAoDDCm8+5QMnnq7b1hmf+D
        7Og389BTn3EwdFASo1oqg5EMkVWA3J4ejg==
X-Google-Smtp-Source: AA0mqf4i9nNQHsxtunW4a6J3718BD8rfqPS2sYMY6QgGEbPHrv3j0GhcZjGlJdiD6KfpjFlUPFTXCw==
X-Received: by 2002:a17:90b:3941:b0:215:db2e:bb17 with SMTP id oe1-20020a17090b394100b00215db2ebb17mr93396774pjb.166.1670315412841;
        Tue, 06 Dec 2022 00:30:12 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id h15-20020a056a00000f00b00574d38f4d37sm11203330pfk.45.2022.12.06.00.30.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 00:30:12 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        linux-perf-users@vger.kernel.org,
        Kan Liang <kan.liang@linux.intel.com>
Subject: [PATCH RESEND v3 3/3] perf/x86/intel: Expose EPT-friendly PEBS for SPR and future models
Date:   Tue,  6 Dec 2022 16:29:44 +0800
Message-Id: <20221206082944.59837-4-likexu@tencent.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221206082944.59837-1-likexu@tencent.com>
References: <20221206082944.59837-1-likexu@tencent.com>
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
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
Nit: This change is proposed to be applied via the KVM tree.

 arch/x86/events/intel/core.c | 1 +
 arch/x86/events/intel/ds.c   | 4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 1b92bf05fd65..e7e31b9d24d3 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -6351,6 +6351,7 @@ __init int intel_pmu_init(void)
 		x86_pmu.pebs_constraints = intel_spr_pebs_event_constraints;
 		x86_pmu.extra_regs = intel_spr_extra_regs;
 		x86_pmu.limit_period = spr_limit_period;
+		x86_pmu.pebs_ept = 1;
 		x86_pmu.pebs_aliases = NULL;
 		x86_pmu.pebs_prec_dist = true;
 		x86_pmu.pebs_block = true;
diff --git a/arch/x86/events/intel/ds.c b/arch/x86/events/intel/ds.c
index 446d2833efa7..7258dca6882f 100644
--- a/arch/x86/events/intel/ds.c
+++ b/arch/x86/events/intel/ds.c
@@ -2303,8 +2303,10 @@ void __init intel_ds_init(void)
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

