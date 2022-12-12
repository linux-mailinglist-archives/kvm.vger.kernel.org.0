Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D38F1649F32
	for <lists+kvm@lfdr.de>; Mon, 12 Dec 2022 13:59:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232494AbiLLM70 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 07:59:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232426AbiLLM7T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 07:59:19 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B51AE1082;
        Mon, 12 Dec 2022 04:59:18 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id s7so11984536plk.5;
        Mon, 12 Dec 2022 04:59:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V4wbgmOrD3DUv8ZzkSj5oeUj/UNys0rAmXMTByr8Jyg=;
        b=ZzhhQG8MG+rqrkCMIUAez/3prk2GWus/OM6jHIg0zYQL/mNme4EGro0cumi02KzI/g
         k2bYuGAyE+mVdelcHESmbN02tWwIdoFevT8TZmfgJwnatlim9RGV3I2yIHs64jqY2aXm
         o+fRS0nKb7UGVz/Uhtonm+W5BPf0wFCCGeydhO2QQdZ4n6BP2OOeZRI0lXYvYWOjeHAe
         qtT3/AR3WPbTUIiCZsdYVNovLAttvhXBS8EHDktrLQ2RUi6lPvu7WpHrFPDhpoPQnbbc
         YpTZv+pe95x0ncI5NKZHxH56Rrth8n64oaBzzYj68Cw+uF0i2qv4p9q6meatXy07zWbS
         D/mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V4wbgmOrD3DUv8ZzkSj5oeUj/UNys0rAmXMTByr8Jyg=;
        b=UHECMnTyCP2oS3SvdMaMRCh1Sxf+/eX/QrVwWpYs2I94AeuHHmX5OYL5SCr8oVFyIY
         izWC88pRl4oQ+18cg9tb/X7YPGF4F5CETZui/d4YSFJJfcToYUgQCbt88GSbLuk6lg9R
         e+8bmRoRMGMyZSH0CcDVhUzOAMXqf2NwOHdQSftCjjHcBVlqhvf0WoR2X90KWpmRcs3n
         R/96Dj3kG6xNOWYVHsPuYByyS9lHjKK2vaiIrjZUb/huVgRdVQvHcCfuFkdjvEQktwPX
         jjQc7N0jD3/GFgmpZ2K3KYdNXNqIUa45nDiOpfYtHEpodeAg7PvnN5+xUzehsNLaAvtp
         n5bA==
X-Gm-Message-State: ANoB5pkuDGRzrparPUmWRFg4UNS6J3BRACHKg9rQOQdwRhbAvWvsCtUh
        HvzzkNAbPPfm70kDy1is7kY=
X-Google-Smtp-Source: AA0mqf7/KyG/5JioQ3eTe1PgU3hbCVnMTrnBxOW44kyUrXK/XVQllGVcEDCPdpvHQP9cJ3gCLj0Bgg==
X-Received: by 2002:a17:902:a616:b0:18b:cea3:644 with SMTP id u22-20020a170902a61600b0018bcea30644mr13835148plq.36.1670849958305;
        Mon, 12 Dec 2022 04:59:18 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id jc3-20020a17090325c300b00186f608c543sm6273927plb.304.2022.12.12.04.59.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Dec 2022 04:59:18 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-perf-users@vger.kernel.org
Subject: [PATCH RFC 2/8] perf: x86/core: Expose the available number of the Topdown metrics
Date:   Mon, 12 Dec 2022 20:58:38 +0800
Message-Id: <20221212125844.41157-3-likexu@tencent.com>
X-Mailer: git-send-email 2.38.2
In-Reply-To: <20221212125844.41157-1-likexu@tencent.com>
References: <20221212125844.41157-1-likexu@tencent.com>
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

Intel Sapphire Rapids server has 8 metrics events, while the Intel Ice Lake
only supports 4 metrics events. The available number of the Topdown
metrics are model specific without architecture hint.

To support guest Topdown metrics,  KVM may only rely on the cpu model
to emulate the correct number of metrics event on the platforms. It would
be nice to have the perf core tell KVM the available number of Topdown
metrics, just like x86_pmu.num_counters.

Cc: Peter Zijlstra <peterz@infradead.org>
Cc: linux-perf-users@vger.kernel.org
Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/events/core.c            | 1 +
 arch/x86/include/asm/perf_event.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index b30b8bbcd1e2..d0d84c7a6876 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -3006,6 +3006,7 @@ void perf_get_x86_pmu_capability(struct x86_pmu_capability *cap)
 	 * which available for all cores.
 	 */
 	cap->num_counters_gp	= x86_pmu.num_counters;
+	cap->num_topdown_events = x86_pmu.num_topdown_events;
 	cap->num_counters_fixed	= x86_pmu.num_counters_fixed;
 	cap->bit_width_gp	= x86_pmu.cntval_bits;
 	cap->bit_width_fixed	= x86_pmu.cntval_bits;
diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 5d0f6891ae61..3e263d291595 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -219,6 +219,7 @@ struct x86_pmu_capability {
 	int		version;
 	int		num_counters_gp;
 	int		num_counters_fixed;
+	int		num_topdown_events;
 	int		bit_width_gp;
 	int		bit_width_fixed;
 	unsigned int	events_mask;
-- 
2.38.2

