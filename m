Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9650695829
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 06:08:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231309AbjBNFIe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 00:08:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231276AbjBNFIZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 00:08:25 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E6DD72AD;
        Mon, 13 Feb 2023 21:08:24 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id ct17so3848921pfb.12;
        Mon, 13 Feb 2023 21:08:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GUQki7H5qpN4QCO0DqYXuFNVqC2bqcgqgvxbR7osp/o=;
        b=K1drwbqX9SkiRCZGRTQKYZHT/cLGIGGY2cxShLt2OE/2QqrwaZgfEl0jShhLhImkNm
         pi3Uf3cVc/ML1D88dZ1yWf0f6rBx/NF+3iZCgbKxX3oO8xMc8uNq+z7b+O9vsL9ErHnW
         zTcPNyEWBhAG0fo2zq8ehOhHvPcYh0xKU7Pw0s7PHrj7EVhzJAGwyRKkDygYV1fw6J5H
         3IJZkNhwa5VPq06QRI+y3FvuVtUby6BUNo5Lg6r6LIZYMKNFYxcC8Deb/6DbiOwua+2W
         NadROIFn0C9g5cgDkquzX6+PS1Q3RVtfsDkAaeegBVdpIiDGPN+nFT0o8cOWofzVy2EU
         bjWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GUQki7H5qpN4QCO0DqYXuFNVqC2bqcgqgvxbR7osp/o=;
        b=s6kMiCMeSD9/M340RSRd0R37YHGWtMnSEeoZ7DHMTTPzKvJmFOXILRnW7XcIvcCxw3
         0drUJ9zvPOZag0+w0Ylv6nNhhyh1JHzgNdD/A9feCZ0GEqPfB69OklF1hPvKSH/HF93Y
         s3p6fB+nRCvQi2sA3HFE5zzxDziYomBtxNWk5Td7UdRhrC5qdANgHu7Riwms2MW29DHs
         qtfNOSs61dyC8v36uM9y4phMJFeYTwD2EUGksh7xiZdbRorLSIrxjGh3h1Jwe6pEc+63
         iAvMJrvEn+fe1YGXed0CvTHs+dytZXSlkzsmB4CisDhZ+WA/JR7KJYzFM+ZO/UkgEr+T
         gUuQ==
X-Gm-Message-State: AO0yUKWhKdybrG9Yke8L4RXkmx3xdGqR6RgMt8MpyICKWC+nWLN09poM
        axx0Ay/P7JTZqVNUxMNgSC2Ey9ZbxYSz7Yw9MNM=
X-Google-Smtp-Source: AK7set+440hRqimiqcm7llh4OfHDKuLc3dRP9WriVm3pOk0peMyRYtdf4FHpeA8Zow5XfxjCvPdJ4Q==
X-Received: by 2002:aa7:9f49:0:b0:5a8:c90d:ab17 with SMTP id h9-20020aa79f49000000b005a8c90dab17mr906427pfr.15.1676351303761;
        Mon, 13 Feb 2023 21:08:23 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id j22-20020aa79296000000b005a79f5d9f53sm8738919pfa.165.2023.02.13.21.08.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Feb 2023 21:08:23 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 04/12] KVM: x86/pmu: Expose reprogram_counters() in pmu.h
Date:   Tue, 14 Feb 2023 13:07:49 +0800
Message-Id: <20230214050757.9623-5-likexu@tencent.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230214050757.9623-1-likexu@tencent.com>
References: <20230214050757.9623-1-likexu@tencent.com>
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

The optimization stands on its own, whereas the code movement is
justified only by the incoming AMD PMU v2 support.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/pmu.h           | 12 ++++++++++++
 arch/x86/kvm/vmx/pmu_intel.c | 12 ------------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 79988dafb15b..1eb50129fae7 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -189,6 +189,18 @@ static inline void kvm_pmu_request_counter_reprogam(struct kvm_pmc *pmc)
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
index 069e1aae418c..904f832fc55d 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -73,18 +73,6 @@ static struct kvm_pmc *intel_pmc_idx_to_pmc(struct kvm_pmu *pmu, int pmc_idx)
 	}
 }
 
-static inline void reprogram_counters(struct kvm_pmu *pmu, u64 diff)
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
2.39.1

