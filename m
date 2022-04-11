Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0682F4FB7A6
	for <lists+kvm@lfdr.de>; Mon, 11 Apr 2022 11:36:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241028AbiDKJil (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Apr 2022 05:38:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344519AbiDKJic (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Apr 2022 05:38:32 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E42D3403DA;
        Mon, 11 Apr 2022 02:36:14 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id k14so13727096pga.0;
        Mon, 11 Apr 2022 02:36:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0lNg07ndjB2kKYwDQW/rQ71vN8BifPDdB+cJa5N9I38=;
        b=O17PN1yxtmfNyhlur6FhCIUdVeuxzkT2+LYesYPUbadLvBp2MGgGtxUX/sJENQCDYn
         UIuCkI+3JMAzKSSlcBY9lrtI1Qs3hy6dI2MkM4WkdPAzav6l+mQP7iVFPPLfbPEOyTRw
         43Q8EEFI79zxmy2p1Y8W/v9DW6ZCKGJ7N/VYKpyKJk75FS3TIBxX2+4tfluaIiNi2Blh
         vYPKv+NDpMECLjADLRuoETyZ3DQuzbwbDeff6bZxGSFGICUeHo67RkqfkB+E5I1wziP5
         IrH/RZnhtkFuNkGbJLctyJcH9qQAsXRx8MZoP2+3t1+lJM7Bg/jLo4oFNgYWIkbqCyZu
         egQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0lNg07ndjB2kKYwDQW/rQ71vN8BifPDdB+cJa5N9I38=;
        b=gmrqSf6gx6VRvbLJ1NWYs0viP/XncDZrmza+d8ZiYwUssDW/w1d0RI3oXtrgcwioFw
         oagsJQ0dGH01KtYh9uW2jU1XvmrxM+4nKw1kBbjNMYcYGfxtiwMjiQL88cg3epE6ASjv
         W1HnYaVeJnNXtcob/6dA4gVk1I5xbT/npd7NMV/G9pxAxndUGdXtwLNbKmhmncbMMnLP
         Rpb3dvuu2hvLIAaXJzrmA9cGyv8aNMTSc3r08+YD3tujNh8355G/rEIACp5sGd/MVAae
         zip/N6NrcDl2e9nyuOknpyahZ9fZi14ZuhG268ds5a9fCgA8YRgXik5RAXGnllXR4Uio
         RM8g==
X-Gm-Message-State: AOAM532rj5N0B7jmFjQKqvX4GpbFj6ClPITtrkvAl3OOsN3JCvZUfflO
        6KyMqdjz3UgpqB3jwnv+Lmk=
X-Google-Smtp-Source: ABdhPJw7hIujbGRibpue1vReKkyfm7nyjy22J61JWLAekQW+H5ARZ9vCem9r74AkuRI3JRlYXSPe3w==
X-Received: by 2002:a65:47c4:0:b0:39d:4f85:40e0 with SMTP id f4-20020a6547c4000000b0039d4f8540e0mr3925825pgs.309.1649669774366;
        Mon, 11 Apr 2022 02:36:14 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.111])
        by smtp.gmail.com with ESMTPSA id k10-20020a056a00168a00b004f7e2a550ccsm34034426pfc.78.2022.04.11.02.36.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 02:36:14 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Like Xu <likexu@tencent.com>
Subject: [PATCH v3 10/11] KVM: x86/pmu: Replace pmc_perf_hw_id() with perf_get_hw_event_config()
Date:   Mon, 11 Apr 2022 17:35:36 +0800
Message-Id: <20220411093537.11558-11-likexu@tencent.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220411093537.11558-1-likexu@tencent.com>
References: <20220411093537.11558-1-likexu@tencent.com>
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

With the help of perf_get_hw_event_config(), KVM could query the correct
EVENTSEL_{EVENT, UMASK} pair of a kernel-generic hw event directly from
the different *_perfmon_event_map[] by the kernel's pre-defined perf_hw_id.

Also extend the bit range of the comparison field to
AMD64_RAW_EVENT_MASK_NB to prevent AMD from
defining EventSelect[11:8] into perfmon_event_map[] one day.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/pmu.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 58960844f49f..f6fd85942a6b 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -493,13 +493,8 @@ static void kvm_pmu_incr_counter(struct kvm_pmc *pmc)
 static inline bool eventsel_match_perf_hw_id(struct kvm_pmc *pmc,
 	unsigned int perf_hw_id)
 {
-	u64 old_eventsel = pmc->eventsel;
-	unsigned int config;
-
-	pmc->eventsel &= (ARCH_PERFMON_EVENTSEL_EVENT | ARCH_PERFMON_EVENTSEL_UMASK);
-	config = static_call(kvm_x86_pmu_pmc_perf_hw_id)(pmc);
-	pmc->eventsel = old_eventsel;
-	return config == perf_hw_id;
+	return !((pmc->eventsel ^ perf_get_hw_event_config(perf_hw_id)) &
+		AMD64_RAW_EVENT_MASK_NB);
 }
 
 static inline bool cpl_is_matched(struct kvm_pmc *pmc)
-- 
2.35.1

