Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 586F9573649
	for <lists+kvm@lfdr.de>; Wed, 13 Jul 2022 14:25:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236362AbiGMMZd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jul 2022 08:25:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236340AbiGMMZa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jul 2022 08:25:30 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6378AE395;
        Wed, 13 Jul 2022 05:25:29 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id z12-20020a17090a7b8c00b001ef84000b8bso3406536pjc.1;
        Wed, 13 Jul 2022 05:25:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sGw98pQzA/OzIltzhNgUUf9pAcra/Fm3uI9aTke5FqA=;
        b=TyIVPchdiF/GzdH7oRyJr0rn4OyBgjY4caeb5LS4BVSg1H5ztWt2j2lkBoAZ7CosUu
         f1wrAcxsLxpb1xaegh3GneIq97RBve3yn13DzDr04QxamYcSLt+mwRSA9k3a89mgELaK
         WSuMk6S3uxgO3Mopdiw7cGKxPRLbMLZNwEYfV99NiEgOSv26ckAK4r0/RpXM8PAlKlLP
         VTRQscBdWXw5XGJoPH/pwSynvl5om1KmFJwAi0acwS5v9C2tTUdJNdCwRzGSBjNJd0Sm
         QR0UWUKop8ukCbTxghqtiV7ow0OJYouZms8om0uCf24eozvx3RD7IZy1WZNNZa0srdoR
         KPKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sGw98pQzA/OzIltzhNgUUf9pAcra/Fm3uI9aTke5FqA=;
        b=mppshnSiZt4RuIgaI6VAH3J/AR1J4MuJhP/YmXyiRSbKze2UTO/h3LnAtv6w1gjDaf
         NphcUBoC9FL/nWi8QW4czPClewjFlFMbw4wqj1NIsilAKG/njAjRgfcM9suq9H8TkWzq
         AUtDmX+Yv/jaq2Lu1OHUgO0gl6QewqfgNiUv4/FpWyqG5Qc6v924772rZYLSk08k5lxT
         /h3p1/52dzJCqMrOnmscQVAudb63191VkoanRN6di2E3mpVuOGxBecVbzmGWlBgrXODQ
         5b9aCU3liXpw1lpirRbCYzf1jVeafiAknK3CSJ4+I+yNbuwHy5BicUA/cA067moJEzUf
         xYoA==
X-Gm-Message-State: AJIora/ntVBrNn+3q1n9Ah1k1wNGitaGiuQSd+aPDUqoIs2gBtW7j9TA
        j89sKSKw4aw25JX1ybaREHg=
X-Google-Smtp-Source: AGRyM1u5TQOQ4BD2wrwBRekcnatgoY2J1u9IDj2UQNp826QlH4Mx6whVQK93J2HtMk03ULlkCmvBaQ==
X-Received: by 2002:a17:903:228c:b0:16c:2f61:9158 with SMTP id b12-20020a170903228c00b0016c2f619158mr3160488plh.140.1657715129461;
        Wed, 13 Jul 2022 05:25:29 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id m7-20020a170902bb8700b0016bf1ed3489sm8719233pls.143.2022.07.13.05.25.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jul 2022 05:25:28 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Like Xu <likexu@tencent.com>,
        Kan Liang <kan.liang@linux.intel.com>
Subject: [PATCH 1/7] perf/x86/core: Update x86_pmu.pebs_capable for ICELAKE_{X,D}
Date:   Wed, 13 Jul 2022 20:25:00 +0800
Message-Id: <20220713122507.29236-2-likexu@tencent.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220713122507.29236-1-likexu@tencent.com>
References: <20220713122507.29236-1-likexu@tencent.com>
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

Ice Lake microarchitecture with EPT-Friendly PEBS capability also support
the Extended feature, which means that all counters (both fixed function
and general purpose counters) can be used for PEBS events.

Update x86_pmu.pebs_capable like SPR to apply PEBS_ALL semantics.

Cc: Kan Liang <kan.liang@linux.intel.com>
Fixes: fb358e0b811e ("perf/x86/intel: Add EPT-Friendly PEBS for Ice Lake Server")
Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/events/intel/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 4e9b7af9cc45..e46fd496187b 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -6239,6 +6239,7 @@ __init int intel_pmu_init(void)
 	case INTEL_FAM6_ICELAKE_X:
 	case INTEL_FAM6_ICELAKE_D:
 		x86_pmu.pebs_ept = 1;
+		x86_pmu.pebs_capable = ~0ULL;
 		pmem = true;
 		fallthrough;
 	case INTEL_FAM6_ICELAKE_L:
-- 
2.37.0

