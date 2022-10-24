Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E2B4609D94
	for <lists+kvm@lfdr.de>; Mon, 24 Oct 2022 11:13:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230525AbiJXJNO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Oct 2022 05:13:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230058AbiJXJNL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Oct 2022 05:13:11 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 592875C376
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 02:13:10 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id b11so1553864pjp.2
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 02:13:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wgGMC5SYMjT91BuTv+EO5nwnbbtDDIxJAEUbq8MFlhY=;
        b=eP7rI0Zu2+BFGsbWxEDs+USiHPooJMRAYzYJfccOihsuCJPWGQG/lyvN3NbZcCz6Gt
         MKjZLQOr0wcr7SQ9PvLulx+Pm67Ojj1pwBqFn4mDmqs1rYeeCNLYzDMq1f3M3anNvNY2
         v25sDkiZxxAWCjXZNxjzBsMBN/ZZLYZyRIJM2RvTdLA5Ym3lVeppXpwBtQ54lRdJ7Cfp
         EwhdN3+ZFgfjfiaX7QLjk3FrfLYyBvz5I4cC0DzKokXrXKzg7p0G5H8I6Qx59aE6JnM5
         vP6aOMlQ4LgYT2ZSfPXNCDSh7cnqMNUl3i5LksISxIRhTkPXvOhm/79P3GqA/M4NcdB1
         rGtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wgGMC5SYMjT91BuTv+EO5nwnbbtDDIxJAEUbq8MFlhY=;
        b=aI1CTKG+EkrT9JL1md7yGAnDaTNc3m34alZxrTXe1helaRbo/gKCdllbkXKU82eaiE
         DO44sbsQxYY+ZX/oY4ywsyC7OERIDXfrOP/t7VdiavB3arAwTYpR4MYs0mtRzoqoJ8Ol
         6ompUfcLnubjohFa+5+xOTfYtWSM1DI1u4rVOL0/CFZ4OHGN/6RVKSw6lB2DbJDy5a0Q
         cjKRejssy77456jorDe7ioAx8lZ8uTAiLI88TE8guwCo64ExkEpFSgReUwJP/Xxf50tD
         sZmTeoVdlb4T4yD/RF/zrqRTrXBMnNMQWloa4oj/vPvv9wi8VekBkHvylTN0aoHC/FVT
         vpCQ==
X-Gm-Message-State: ACrzQf3d+LNAEu+Af+9Tk4n1Weq447vLnj8Uaru+fahPtzBVgurYq2Ay
        SjhwSiS8XfRHuEUWHx8sE+I=
X-Google-Smtp-Source: AMsMyM7/ZRoNtlV0Akv7pRj/mqCksu421NpXCoFFvbnFzaTZWY4lbmGZdttIoEGw+mf6hx87/zPl3g==
X-Received: by 2002:a17:902:7c8a:b0:17b:6eaa:5da3 with SMTP id y10-20020a1709027c8a00b0017b6eaa5da3mr31804237pll.33.1666602789848;
        Mon, 24 Oct 2022 02:13:09 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id r15-20020aa79ecf000000b00535da15a252sm19642213pfq.165.2022.10.24.02.13.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Oct 2022 02:13:09 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        Sandipan Das <sandipan.das@amd.com>
Subject: [kvm-unit-tests PATCH v4 05/24] x86/pmu: Fix printed messages for emulated instruction test
Date:   Mon, 24 Oct 2022 17:12:04 +0800
Message-Id: <20221024091223.42631-6-likexu@tencent.com>
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

This test case uses MSR_IA32_PERFCTR0 to count branch instructions
and PERFCTR1 to count instruction events. The same correspondence
should be maintained at report(), specifically this should use
status bit 1 for instructions and bit 0 for branches.

Fixes: 20cf914 ("x86/pmu: Test PMU virtualization on emulated instructions")
Reported-by: Sandipan Das <sandipan.das@amd.com>
Signed-off-by: Like Xu <likexu@tencent.com>
---
 x86/pmu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index c8a2e91..d303a36 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -512,8 +512,8 @@ static void check_emulated_instr(void)
 	       "branch count");
 	// Additionally check that those counters overflowed properly.
 	status = rdmsr(MSR_CORE_PERF_GLOBAL_STATUS);
-	report(status & 1, "instruction counter overflow");
-	report(status & 2, "branch counter overflow");
+	report(status & 1, "branch counter overflow");
+	report(status & 2, "instruction counter overflow");
 
 	report_prefix_pop();
 }
-- 
2.38.1

