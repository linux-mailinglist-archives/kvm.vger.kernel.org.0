Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08886720CD6
	for <lists+kvm@lfdr.de>; Sat,  3 Jun 2023 03:11:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237065AbjFCBLL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jun 2023 21:11:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236989AbjFCBLI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jun 2023 21:11:08 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14FC6B9
        for <kvm@vger.kernel.org>; Fri,  2 Jun 2023 18:11:06 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id d2e1a72fcca58-6537ff2c93fso424237b3a.2
        for <kvm@vger.kernel.org>; Fri, 02 Jun 2023 18:11:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685754665; x=1688346665;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=zNS+2nUop8HSFhXhjGUsYHrKCz8noRLlXBPZS+z46QI=;
        b=zD9YgFffhnt58QHSD5hvMYuW98to2PwClt4O7Q5PboHoKYWMUYyrdJRIsO9wOabfrO
         wbIZ5xULWSadmjrlN0rX9UFk2OB96dKBbdLaudCvmoJUFEPojXphaikBq7HlrEo3Kc5B
         QUHmKGIPRHLHv+D2zzZVmj1V0GVVepFaZoJ1hUx+xFhXca0H1VaovUViPyU9u0WHtLnr
         TdbtyI2knorbbWKSj9JxzoWVtBh+3XM8xmV76f/l0Q6XIsMGRTSKTKF5r89qp9DiGQ4t
         q2hhevSK8TfoK8BDjKnq3gso1vshT8TMMUSvzYuPlEjNAJWuzxrT+i+LXQUOhHHhx5cP
         f8tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685754665; x=1688346665;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zNS+2nUop8HSFhXhjGUsYHrKCz8noRLlXBPZS+z46QI=;
        b=WjQ66ihUj2B7JBuBxr0+KRSj0Xa6U3ka7joIvOruO4i4GCu6NEj/XKqNTZS9aOkGCQ
         ZCwtGsodUh8PptPclOkrG6KoaRd5mzAxFftlZF/ZnsrsK7arXwpWHp89dUyFwEnJq1vH
         LZMZenGkzb+ocxFeMtmNCjs3vDLC6gQewnxwmbCcRv0aGQJfhZEwKDvxQJcUHtJEcLhD
         Xlc3dHYJ5JAPMu494T+x0O+aON7G7I0CYDAkCLNCZozbgycRR/3HHvCxrzuudmbikH93
         fxrAfl9BeyTMixZxq5zIrTNa2Dy4N715bqG0WOBOmdbUEL8jaNdSG0uqZoOGqaTXpeFg
         ILEg==
X-Gm-Message-State: AC+VfDwVJCqzKIClIp6aO14UDzBEZziTfwjObHLXgwffqFd3PVx8pzIW
        VBvL4n/BvgOGTkMzR0Y8B8LbkuXt1dU=
X-Google-Smtp-Source: ACHHUZ66VR1ERObfdJKcvipVCvg4VTNcwOGsEvlE1HEOn8bBw52eibfHaJuuXnFKXKd+qxws+6C6rP9MTXk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2e0e:b0:647:3f80:c607 with SMTP id
 fc14-20020a056a002e0e00b006473f80c607mr5051252pfb.4.1685754665454; Fri, 02
 Jun 2023 18:11:05 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  2 Jun 2023 18:10:48 -0700
In-Reply-To: <20230603011058.1038821-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230603011058.1038821-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.rc2.161.g9c6817b8e7-goog
Message-ID: <20230603011058.1038821-3-seanjc@google.com>
Subject: [PATCH v7 02/12] KVM: x86/pmu: Move reprogram_counters() to pmu.h
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Like Xu <like.xu.linux@gmail.com>,
        Like Xu <likexu@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Sandipan Das <sandipan.das@amd.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

Move reprogram_counters() out of Intel specific PMU code and into pmu.h so
that it can be used to implement AMD PMU v2 support.

No functional change intended.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Like Xu <likexu@tencent.com>
[sean: rewrite changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
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
index fb96cbfc9ae8..edcf8670eb4e 100644
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
2.41.0.rc2.161.g9c6817b8e7-goog

