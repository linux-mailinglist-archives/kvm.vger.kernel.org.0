Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FF7364546C
	for <lists+kvm@lfdr.de>; Wed,  7 Dec 2022 08:15:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbiLGHPe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Dec 2022 02:15:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbiLGHPa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Dec 2022 02:15:30 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4F7341993;
        Tue,  6 Dec 2022 23:15:29 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id y17so16243764plp.3;
        Tue, 06 Dec 2022 23:15:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tSjXL3el8itvunz/kkodAyXJASEfYFJJyxPXVJ+LMlQ=;
        b=F4SFDwDkaiLiWCTp1x41oama4Paex8vbGJ+/CGeQdi02LuS1pkCjqF9Lx0FjUNrcQq
         ZQiZNRN/jhR/rEyXTW6FDUDrZkgTRCydTza6t9mu4Ffjjw9mbEApt0lsjeBOZdeugVHu
         LXxy0yxFJ59IHOUQT50/028PutxYd+nITZEEb2UVbIFBvnJ1ZfQI4BLyetEzmbgzMA5H
         SuSvRBefGz1Y0tE+ZSp1LUkXe4+l5C9QE4gHrJUJfH1gE5isGfArShJ8Sd+5sDHP4DuH
         X1ylEXZHZJo2ZUpab6XejfbyF+BZRMJzjPWhaToObdBCtefeNQN3aGe9KFSII8Y4jJNV
         aHHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tSjXL3el8itvunz/kkodAyXJASEfYFJJyxPXVJ+LMlQ=;
        b=kKW1sINFVhYkVl81O8+JlXWq2Fob9SfXMKNk0ca+LxbBKxsXntB2/rdur5R39xmuE8
         5OdgzQZWbw0WglNZFKHj7/4RQHrOm+lZ8yJcY04lmtyxNunNbd+Ue+4ydTrHqCtVeh6b
         yuWJfsrFZ7z5cDhUnuDa84uaVXxF7EvJciI5AO2ZwwGbJsuUwbPx0abyfKRPdVEGsWdo
         6NJGAsG3kmFhBmv62b/ehKhFNvwDQ2SxxTNKtoF8xNrtBfIS1oJ8TYRG36dqZIjO78kT
         qTD9eSjdQ1BNe1Jm5pxYSKHeWVRzpjbK8zAUfqajb30is2TtTq0xa1PsC1HOaNEZCA0Y
         BGiw==
X-Gm-Message-State: ANoB5pk1Ewzm2JG7zJynZjrQSEJkx7srEJjwahCxu6Yp07/IoOeI44qp
        Hc8QE04+mwNjQJlSKgFAxuHDueYCEts4cQ==
X-Google-Smtp-Source: AA0mqf4kxn/tqHv5woAQczBjsfUFvhLllTl+OLkuKfDKMPkXWfFqqrrAKaCDcihaz8iGRv1WmqdIaQ==
X-Received: by 2002:a17:902:b705:b0:189:e711:16c with SMTP id d5-20020a170902b70500b00189e711016cmr8725979pls.67.1670397329091;
        Tue, 06 Dec 2022 23:15:29 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id c126-20020a621c84000000b005629b6a8b53sm13198561pfc.15.2022.12.06.23.15.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 23:15:28 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86/pmu: Prevent zero period event from being repeatedly released
Date:   Wed,  7 Dec 2022 15:15:06 +0800
Message-Id: <20221207071506.15733-2-likexu@tencent.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221207071506.15733-1-likexu@tencent.com>
References: <20221207071506.15733-1-likexu@tencent.com>
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

The current vPMU can reuse the same pmc->perf_event for the same
hardware event via pmc_pause/resume_counter(), but this optimization
does not apply to a portion of the TSX events (e.g., "event=0x3c,in_tx=1,
in_tx_cp=1"), where event->attr.sample_period is legally zero at creation,
thus making the perf call to perf_event_period() meaningless (no need to
adjust sample period in this case), and instead causing such reusable
perf_events to be repeatedly released and created.

Avoid releasing zero sample_period events by checking is_sampling_event()
to follow the previously enable/disable optimization.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/pmu.c | 3 ++-
 arch/x86/kvm/pmu.h | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 684393c22105..eb594620dd75 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -238,7 +238,8 @@ static bool pmc_resume_counter(struct kvm_pmc *pmc)
 		return false;
 
 	/* recalibrate sample period and check if it's accepted by perf core */
-	if (perf_event_period(pmc->perf_event,
+	if (is_sampling_event(pmc->perf_event) &&
+	    perf_event_period(pmc->perf_event,
 			      get_sample_period(pmc, pmc->counter)))
 		return false;
 
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 85ff3c0588ba..cdb91009701d 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -140,7 +140,8 @@ static inline u64 get_sample_period(struct kvm_pmc *pmc, u64 counter_value)
 
 static inline void pmc_update_sample_period(struct kvm_pmc *pmc)
 {
-	if (!pmc->perf_event || pmc->is_paused)
+	if (!pmc->perf_event || pmc->is_paused ||
+	    !is_sampling_event(pmc->perf_event))
 		return;
 
 	perf_event_period(pmc->perf_event,
-- 
2.38.1

