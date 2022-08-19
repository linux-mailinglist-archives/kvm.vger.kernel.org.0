Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD354599AA6
	for <lists+kvm@lfdr.de>; Fri, 19 Aug 2022 13:18:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348713AbiHSLKO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Aug 2022 07:10:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348704AbiHSLKN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Aug 2022 07:10:13 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6700FBA6A
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 04:10:12 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id s4-20020a17090a5d0400b001fabc6bb0baso4455601pji.1
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 04:10:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=RRIrXHQwZ3S+bg/R1JplX5ItK+RwG3sr4MtSf2FKtng=;
        b=enswTMYUmwG1NFALvRJnrC7wdXhQjysRXvq6ErjhwpOGEZrjYNVStu96tXyO83EbCe
         8/tQZWSazb1XE6DRxKcSdKk4Et7XgBTSkWjibalJddWyP5N4w7yfH8ozOLGZNXRh3LOE
         TSbeCdGWUREOwAKIeH9Gj5+NJ5mNKnJJ5VBLhV4g9gA0HmHl1rSMPihHVGSIRfFg+z+n
         gF4huhwZutBh7zKdHi78LAMVUlS9suqUZyY9DJUJz1isOUyIxDe8UV0CUXga6/YLQmuJ
         yRB0qoTSHtNdcK/Sguy1/EBpVpJjycSsK5DQ3N6SQvGzfrTVjSVdIuhJ7ivRTEgW87mb
         VPxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=RRIrXHQwZ3S+bg/R1JplX5ItK+RwG3sr4MtSf2FKtng=;
        b=V6Z8nJExTbrXLosec+MCgbXZvRTroXvFRVyRXOmkMU1xV7MAa6It9RS/XwXXzSSZEc
         dlH9jLtNa9FefS+ipoAIfCpCX1knFTLKzT7qf5TAprWs0ZvU0r9U0Tcc6tSmXDN9RRBr
         YgwLOMgjxDq6EY/bu0ONZizKsc/DvUzbjlQjUHkPIlpfcaAWrYiJykv4LJEbTjHD8WH1
         AvnCMBN+SDEh72h0ryPx0klY0xL0PeO/aFHgzSyQyS+sjrcuRLU/jSAE4rkkgghQDeoE
         eKMBDtDM+y9al3PWNy3TtnE1Tst4YZv/Mznul0mKJDuGU2Gb3OSJq3xL4IY4bnnOYlUe
         NsHQ==
X-Gm-Message-State: ACgBeo1sH+Cuh7Z1QXIvmP2VR9zFYkGS83f04ynk57XNrPkjRyOrQlF0
        LCoKRRgqzXosxid5AqVGBFWbOKTJ4sahvg==
X-Google-Smtp-Source: AA6agR5+vBadt4Sab8K4yAh3fzk9VuLJ7RUCk72cSngQdBWKXTQBz9VoHTJg8clhHcKVvQg5OQHftQ==
X-Received: by 2002:a17:90b:1a8f:b0:1f4:fb36:a9b3 with SMTP id ng15-20020a17090b1a8f00b001f4fb36a9b3mr7910020pjb.186.1660907412346;
        Fri, 19 Aug 2022 04:10:12 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id jd7-20020a170903260700b0016bfbd99f64sm2957778plb.118.2022.08.19.04.10.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Aug 2022 04:10:11 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v3 08/13] x86/pmu: Add PDCM check before accessing PERF_CAP register
Date:   Fri, 19 Aug 2022 19:09:34 +0800
Message-Id: <20220819110939.78013-9-likexu@tencent.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819110939.78013-1-likexu@tencent.com>
References: <20220819110939.78013-1-likexu@tencent.com>
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

On virtual platforms without PDCM support (e.g. AMD), #GP
failure on MSR_IA32_PERF_CAPABILITIES is completely avoidable.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 x86/pmu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index 4eb92d8..25fafbe 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -669,7 +669,8 @@ int main(int ac, char **av)
 
 	check_counters();
 
-	if (rdmsr(MSR_IA32_PERF_CAPABILITIES) & PMU_CAP_FW_WRITES) {
+	if (this_cpu_has(X86_FEATURE_PDCM) &&
+	    (rdmsr(MSR_IA32_PERF_CAPABILITIES) & PMU_CAP_FW_WRITES)) {
 		gp_counter_base = MSR_IA32_PMC0;
 		report_prefix_push("full-width writes");
 		check_counters();
-- 
2.37.2

