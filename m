Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B275E520D0E
	for <lists+kvm@lfdr.de>; Tue, 10 May 2022 06:44:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236492AbiEJEsL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 May 2022 00:48:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230185AbiEJEsJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 May 2022 00:48:09 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48F44293B61;
        Mon,  9 May 2022 21:44:13 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id d22so15711172plr.9;
        Mon, 09 May 2022 21:44:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6+sQlTltbJMISkmfPebzAVn4VW2b92jPEnbl/JJQPtA=;
        b=krLLYW13kDlgS57yxnDgLiF6KhAhX7/BxaD11cYnloCT5JEA6ksWD9bth6XpqoW0EE
         inWZVdt2YIlSoSBy9cco9yCipuaSECVSHoQ9J2WYVWA34EMxud//wZT1PZiDjsz53WEd
         x4g5n75USwpB8+Yitqk6aSNFkg70IIuDdOY5hLtO4RshUhtecoHTcXZep7/6oyexLRRZ
         hg6YPJWrAq0aIoGil6HPEfMkgmBNGeqTzQfSIFOIg1AaL9dTXd/px99e0pb9tZ7MOeaI
         oO3iLsT/jMiDIY8Si4LLk+q5P3+8+99mawyLloBTd9dNSOzr5zTz4RWG0yZbQ0DEdaht
         adJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6+sQlTltbJMISkmfPebzAVn4VW2b92jPEnbl/JJQPtA=;
        b=pufp454T175thDYxQEMCv0bWNzrRBkdMkFxMkgxfogmyftGzUxcJd3O5qbgl9J7L8N
         fH1ENc3ZU6WDl0PqeJotpZqstJxzeIyP7gPcmZNKGO2zxUd6qgoI5UELDP5kxkn0ipra
         vnQn+VatOh6dhqZMEFqDFCe7dF6FGEbLNxoI5yAiuQNHR8fRc2JcWeBTBmNTZFaYA5m0
         1oNOuE8n/RhQjoUFUtHzVXp7dEHrAtZS1om7DlwNQMGmGY546FVpnsBJZuMJOC4feCGO
         uiJlWIXInQrYdHLjKLZc2g1U0xsu5SqQRPAyNduxnE0ofs08fvc826vE7tzXjsNazsXq
         sI6Q==
X-Gm-Message-State: AOAM532Yb6dsSYWOUrCpER9cVdcx0m4Aa9OLZxH8ZEqWoBo97+/XJyIW
        gJKopFgUrZ1jJCfJNAtPZbQ=
X-Google-Smtp-Source: ABdhPJwBKpiNFXJ3fxQfjWX14unnnowuPRW8gh0tOZR+V8vw/F7/AjerayoZ7uHOzdu/yEcgd9lHRg==
X-Received: by 2002:a17:90b:4b12:b0:1dc:dfdb:446 with SMTP id lx18-20020a17090b4b1200b001dcdfdb0446mr19476441pjb.150.1652157852878;
        Mon, 09 May 2022 21:44:12 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.85])
        by smtp.gmail.com with ESMTPSA id o10-20020a170903300a00b0015e9d4a5d27sm828012pla.23.2022.05.09.21.44.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 21:44:12 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     pbonzini@redhat.com
Cc:     jmattson@google.com, like.xu.linux@gmail.com, joro@8bytes.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com
Subject: [PATCH v2] KVM: x86/pmu: Don't pre-set the pmu->global_ctrl when refreshing
Date:   Tue, 10 May 2022 12:44:07 +0800
Message-Id: <20220510044407.26445-1-likexu@tencent.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220509102204.62389-2-likexu@tencent.com>
References: <20220509102204.62389-2-likexu@tencent.com>
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

Assigning a value to pmu->global_ctrl just to set the value of
pmu->global_ctrl_mask in a more readable way leaves a side effect of
not conforming to the specification. The value is reset to zero on
Power up and Reset but keeps unchanged on INIT, like an ordinary MSR.

Signed-off-by: Like Xu <likexu@tencent.com>
---
v1 -> v2 Changelog:
- Explicitly add parentheses around;

 arch/x86/kvm/vmx/pmu_intel.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index b82b6709d7a8..7829ec457b28 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -522,9 +522,8 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 		setup_fixed_pmc_eventsel(pmu);
 	}
 
-	pmu->global_ctrl = ((1ull << pmu->nr_arch_gp_counters) - 1) |
-		(((1ull << pmu->nr_arch_fixed_counters) - 1) << INTEL_PMC_IDX_FIXED);
-	pmu->global_ctrl_mask = ~pmu->global_ctrl;
+	pmu->global_ctrl_mask = ~(((1ull << pmu->nr_arch_gp_counters) - 1) |
+		(((1ull << pmu->nr_arch_fixed_counters) - 1) << INTEL_PMC_IDX_FIXED));
 	pmu->global_ovf_ctrl_mask = pmu->global_ctrl_mask
 			& ~(MSR_CORE_PERF_GLOBAL_OVF_CTRL_OVF_BUF |
 			    MSR_CORE_PERF_GLOBAL_OVF_CTRL_COND_CHGD);
-- 
2.36.1

