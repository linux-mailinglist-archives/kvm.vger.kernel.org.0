Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 911EA59DFEA
	for <lists+kvm@lfdr.de>; Tue, 23 Aug 2022 14:36:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358730AbiHWLx1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 07:53:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358587AbiHWLw1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 07:52:27 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38D64D51E4;
        Tue, 23 Aug 2022 02:32:50 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id y4so12313406plb.2;
        Tue, 23 Aug 2022 02:32:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=zk5VkhKY6qv5m7v9uP9nYXO8clyUIi7rFMMrFFDGn7U=;
        b=kmwFktDd3ld3yM7m7f68NClI/f/GAAGO/5hY1Cwxkqlmc8A3BK6+Uey+KWM4tBBx7/
         qvznlJC54wouFVrRhbTlPhrXvsw2ycTYMVt9ExQFnZ7fXTfiJ8j88iI3+e5zUUfUm+sP
         3L48IEHxsKDcfQQcihzzi1wlc/eCmcrjV3koajdbWwEOsnOumwtnfNXwnDr92TrGchqA
         1fLRW8leTnKinX05mF4ZTplpJXTkxS4taJXKPIak0DhpMM0nIOZluT+Ptv1xf46GDW/c
         d5vGrzVg1RK5ZXy3n5FgOAO0IvzckjrUv2/2qZu9RKcfkOetWgELNXbI8jeDrXMQ5PPe
         LaZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=zk5VkhKY6qv5m7v9uP9nYXO8clyUIi7rFMMrFFDGn7U=;
        b=BuA6JrOoXk7fHYRUW8rvLho4AOOHdJp3HgeeAf5ayrVwieU1mt31MSxCz4giou36w6
         9eOpU+KWZog/c4l96ZQp4LZw2POFt3BolLd667eQ+OazMCUqFtbiQ7d3h+MEFxBza4vJ
         tBUmCs2LpwVPTIBpNWLFp1F4zuLMXmyKnJzrUoEvHP3qf6IEN8FdEgmFRRv06qYTyb1d
         JDA6zGxj75DtSChMmkWWWAloioP/pLwbZIlIIV4DsjOyXcZRWGfCQP8C3d418qdsJgwg
         6npBoUmR9cuTOyloX9cddpPKF4OEv0Zz+WuO4W8raRdRguCzS7gW+mIBWNZMkakD1K9s
         OdBg==
X-Gm-Message-State: ACgBeo1KNji4XbswCFnd1JYtzXmavEO+hXuPOP4knzv8enYs9Yabn4HT
        3bosqNtgnFCQNvnGrsKg8YE=
X-Google-Smtp-Source: AA6agR6LfsI8b0QU91H2HRcCWO5xh0n1GDvgAOO89yB7YmfaMO/CMqaH+0esbGYN8H0gThikx4h1Ng==
X-Received: by 2002:a17:90b:238b:b0:1fa:d833:30dd with SMTP id mr11-20020a17090b238b00b001fad83330ddmr2444336pjb.147.1661247169038;
        Tue, 23 Aug 2022 02:32:49 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id 13-20020a170902c24d00b0017297a6b39dsm10057212plg.265.2022.08.23.02.32.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Aug 2022 02:32:48 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH RESEND v2 3/8] KVM: x86/pmu: Don't generate PEBS records for emulated instructions
Date:   Tue, 23 Aug 2022 17:32:16 +0800
Message-Id: <20220823093221.38075-4-likexu@tencent.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823093221.38075-1-likexu@tencent.com>
References: <20220823093221.38075-1-likexu@tencent.com>
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

KVM will accumulate an enabled counter for at least INSTRUCTIONS or
BRANCH_INSTRUCTION hw event from any KVM emulated instructions,
generating emulated overflow interrupt on counter overflow, which
in theory should also happen when the PEBS counter overflows but
it currently lacks this part of the underlying support (e.g. through
software injection of records in the irq context or a lazy approach).

In this case, KVM skips the injection of this BUFFER_OVF PMI (effectively
dropping one PEBS record) and let the overflow counter move on. The loss
of a single sample does not introduce a loss of accuracy, but is easily
noticeable for certain specific instructions.

This issue is expected to be addressed along with the issue
of PEBS cross-mapped counters with a slow-path proposal.

Fixes: 79f3e3b58386 ("KVM: x86/pmu: Reprogram PEBS event to emulate guest PEBS counter")
Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/pmu.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 02f9e4f245bd..390d697efde1 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -106,9 +106,19 @@ static inline void __kvm_perf_overflow(struct kvm_pmc *pmc, bool in_pmi)
 		return;
 
 	if (pmc->perf_event && pmc->perf_event->attr.precise_ip) {
-		/* Indicate PEBS overflow PMI to guest. */
-		skip_pmi = __test_and_set_bit(GLOBAL_STATUS_BUFFER_OVF_BIT,
-					      (unsigned long *)&pmu->global_status);
+		if (!in_pmi) {
+			/*
+			 * TODO: KVM is currently _choosing_ to not generate records
+			 * for emulated instructions, avoiding BUFFER_OVF PMI when
+			 * there are no records. Strictly speaking, it should be done
+			 * as well in the right context to improve sampling accuracy.
+			 */
+			skip_pmi = true;
+		} else {
+			/* Indicate PEBS overflow PMI to guest. */
+			skip_pmi = __test_and_set_bit(GLOBAL_STATUS_BUFFER_OVF_BIT,
+						      (unsigned long *)&pmu->global_status);
+		}
 	} else {
 		__set_bit(pmc->idx, (unsigned long *)&pmu->global_status);
 	}
-- 
2.37.2

