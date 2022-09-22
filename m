Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E91335E5A97
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 07:19:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbiIVFTy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 01:19:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229788AbiIVFTv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 01:19:51 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05C81474DF;
        Wed, 21 Sep 2022 22:19:51 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id o99-20020a17090a0a6c00b002039c4fce53so1054293pjo.2;
        Wed, 21 Sep 2022 22:19:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=GMkU1fcxIyUL21eoHYe2jKHkE16Hr771WCkqjLcwYtQ=;
        b=a/O4rKKT7Kv3eslRbh+88BtpBD0P8l4ruNM3RRxvb6HZGewie2O3XXjTpv6THavl8t
         q0ro46K08595GLN2FI/Ecc+9Kkp5eFswR5hsKMiDIfHD+kaiEP/biv8JF33TRPJsFHnB
         SF3eIyTpAb3YGoCx+t5QSwGVa/0un+b12HG/sRV2C+Te/DiaunPMC2MbaoHXR1XqoKWY
         IXHgN0aIGoJC1CDwDGe8SoGcn0ymBAhwQeyiecI9NMzxDUCXAbvJWmV5GlbokXfabJjf
         y75/5rENdR2VVDHRtE/N1BpfgBXGh4Wdg6j/NPmAKMweRMcnLPoc+1vDJA4zBv8exuHs
         Gwng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=GMkU1fcxIyUL21eoHYe2jKHkE16Hr771WCkqjLcwYtQ=;
        b=kFe0wCdAl+OtMkNmMZzUbbYWttUe38me5wn6FnJBI1/ujH1LfNl1mM417fZcun/Ulj
         G7ac6ON+Xclm3yl4SbuQZ819ZkYHEEicZtPn7/5FiOynjBS/XgWvPWxf+McXjjpWsQZF
         JzCD6k5t4o9tGd6ZB726ZTQACFhtC20qeMZYq6Mg5mdGUqAZSPclp6JnIUS7N8PLW34x
         2nXJIHljo3mdQ3S3jqJB2yUQJVstyMnd8CIz/zzLGaw8SU6ACOlS5svwmK/zJUSo/wtz
         cPYiG0iUP2AsXKw6P5VPWOL0a7aXspotHx1LEKjUCcvwJaG1F5at4obFe+fffwDI7Bx4
         2otw==
X-Gm-Message-State: ACrzQf3Un6/+XxEQSwEWWjc5LgRmHWDEUF1nF84M8UjiMvzgCMtXSTMB
        P9+Pp8nMy9X8CBwMviy3eYAD4UfA0mS3fQ==
X-Google-Smtp-Source: AMsMyM574gPz7vjNosZQoXrztx9lPl1MgEp7iRPI9JGASkpN+LI/pxLffmg8+/92XqFPR6iFooH7Pw==
X-Received: by 2002:a17:90a:4502:b0:202:7a55:558f with SMTP id u2-20020a17090a450200b002027a55558fmr13175584pjg.108.1663823990416;
        Wed, 21 Sep 2022 22:19:50 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id b7-20020a170903228700b001780a528540sm3045067plh.93.2022.09.21.22.19.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 22:19:49 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-perf-users@vger.kernel.org,
        Kan Liang <kan.liang@linux.intel.com>
Subject: [PATCH v2 1/2] perf/x86/intel: Expose EPT-friendly PEBS for SPR and future models
Date:   Thu, 22 Sep 2022 13:19:28 +0800
Message-Id: <20220922051929.89484-1-likexu@tencent.com>
X-Mailer: git-send-email 2.37.3
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
---
V1 -> V2 Changelog:
- the perf part should be a separate patch; (Kan)
- apply PEBS format 5 to avoid patching every future model; (Kan)

 arch/x86/events/intel/core.c | 1 +
 arch/x86/events/intel/ds.c   | 4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 2db93498ff71..804540ba4599 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -6288,6 +6288,7 @@ __init int intel_pmu_init(void)
 		x86_pmu.pebs_constraints = intel_spr_pebs_event_constraints;
 		x86_pmu.extra_regs = intel_spr_extra_regs;
 		x86_pmu.limit_period = spr_limit_period;
+		x86_pmu.pebs_ept = 1;
 		x86_pmu.pebs_aliases = NULL;
 		x86_pmu.pebs_prec_dist = true;
 		x86_pmu.pebs_block = true;
diff --git a/arch/x86/events/intel/ds.c b/arch/x86/events/intel/ds.c
index ba60427caa6d..4e937f685cdc 100644
--- a/arch/x86/events/intel/ds.c
+++ b/arch/x86/events/intel/ds.c
@@ -2253,8 +2253,10 @@ void __init intel_ds_init(void)
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
2.37.3

