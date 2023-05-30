Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1BCE715546
	for <lists+kvm@lfdr.de>; Tue, 30 May 2023 08:05:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230230AbjE3GE5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 May 2023 02:04:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230055AbjE3GEv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 May 2023 02:04:51 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5803CD;
        Mon, 29 May 2023 23:04:45 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id 98e67ed59e1d1-2564dc37c3eso1632512a91.0;
        Mon, 29 May 2023 23:04:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685426685; x=1688018685;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5LqwYEX8StxyDFjMffsBz9nUfI7zk365IJiNxoDT46s=;
        b=pzFTGGxE1pJWaspfuQfqT+mf0JhPiqjdZOJkcNk5dN/j39WKzqWs160rjG/jiLkiZL
         TOuRdpTogZYWqm8wplmJJO5WMzquDIal9hZb4M7KGauQxRd6kVxkJq6oh+ciuQSzGOPY
         UGfYkAt869JBQANJlSZ+l0to+n2gZOngZRjt12mOtFjvId3opxy/JX1QkYYdSLHLBu0r
         Nreoj7ATle0UekO2XK8Iv4hABlj34jlHxhBWSAw4s4kme9FoRZJd0dsCzzRdLO22BbS9
         JLFnaoS/hyH0+Mmfg9sh28KVaAUNzPNndbosu1rIhLofJ544TTPjcRkbwJXFQGNn9xm7
         cZ5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685426685; x=1688018685;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5LqwYEX8StxyDFjMffsBz9nUfI7zk365IJiNxoDT46s=;
        b=XRc8yHXhrlbFr1MXtoQ99be3n1yMkZCJ6g5Ezcxmri4vBsgOiY+74hvUF+W0rwWw8+
         bEDkujCcn5e4R+5qfDx1WVHxIQf2xYCjtr1ydkNjWHF1iDt5FsKn723YZ31JnrIq6skO
         //z/V21JjegirkPPC3jEH2zfoYa5KsgsHRv9G9OPOmN+AlD0S53sdJdTNc6cV9yqaRx1
         x73J8695eMvWDt9GxuyVCyQNCuT0tPTDBekPjitl+PHQ5ZbiiP9kTxUlokznGeMUpbsg
         JgY3Ve5dhgwx96zOAR0VqPC1iZRjkMPgkdBh4F8+kKuzN7zYnhElS3a1OWY4MZIOKOTP
         xC3g==
X-Gm-Message-State: AC+VfDxgQAJEZNR26H5w+Mj2tx25eLC4LWKN2N6US3ix4xnZCBsUBy5n
        o5CfbUXBXb/80X+oB1A7B/g=
X-Google-Smtp-Source: ACHHUZ6xzVRaLcpMQbbxycSov/SBOb4+8HE78Ykdy9k84AXU6x+6SUF8MGkjSnDXTZkM7qRsA0WnnQ==
X-Received: by 2002:a17:90a:3d43:b0:250:50c5:cabc with SMTP id o3-20020a17090a3d4300b0025050c5cabcmr10629524pjf.3.1685426685413;
        Mon, 29 May 2023 23:04:45 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id gw8-20020a17090b0a4800b00256b67208b1sm638072pjb.56.2023.05.29.23.04.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 May 2023 23:04:45 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v6 01/10] KVM: x86/pmu: Expose reprogram_counters() in pmu.h
Date:   Tue, 30 May 2023 14:04:14 +0800
Message-Id: <20230530060423.32361-2-likexu@tencent.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230530060423.32361-1-likexu@tencent.com>
References: <20230530060423.32361-1-likexu@tencent.com>
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

The optimization stands on its own, whereas the code movement is
justified only by the incoming AMD PMU v2 support.

No functional change intended.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/pmu.h           | 12 ++++++++++++
 arch/x86/kvm/vmx/pmu_intel.c | 12 ------------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 5c7bbf03b599..986563aeeef8 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -201,6 +201,18 @@ static inline void kvm_pmu_request_counter_reprogram(struct kvm_pmc *pmc)
 	kvm_make_request(KVM_REQ_PMU, pmc->vcpu);
 }
 
+static inline void reprogram_counters(struct kvm_pmu *pmu, u64 diff)
+{
+	int bit;
+
+	if (!diff)
+		return;
+
+	for_each_set_bit(bit, (unsigned long *)&diff, X86_PMC_IDX_MAX)
+		set_bit(bit, pmu->reprogram_pmi);
+	kvm_make_request(KVM_REQ_PMU, pmu_to_vcpu(pmu));
+}
+
 void kvm_pmu_deliver_pmi(struct kvm_vcpu *vcpu);
 void kvm_pmu_handle_event(struct kvm_vcpu *vcpu);
 int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned pmc, u64 *data);
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 741efe2c497b..1f9c3e916a21 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -73,18 +73,6 @@ static struct kvm_pmc *intel_pmc_idx_to_pmc(struct kvm_pmu *pmu, int pmc_idx)
 	}
 }
 
-static void reprogram_counters(struct kvm_pmu *pmu, u64 diff)
-{
-	int bit;
-
-	if (!diff)
-		return;
-
-	for_each_set_bit(bit, (unsigned long *)&diff, X86_PMC_IDX_MAX)
-		set_bit(bit, pmu->reprogram_pmi);
-	kvm_make_request(KVM_REQ_PMU, pmu_to_vcpu(pmu));
-}
-
 static bool intel_hw_event_available(struct kvm_pmc *pmc)
 {
 	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
-- 
2.40.1

