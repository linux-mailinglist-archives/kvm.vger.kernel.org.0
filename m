Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 482F657C91C
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 12:36:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233303AbiGUKgK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 06:36:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233280AbiGUKgF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 06:36:05 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 193CE10F7;
        Thu, 21 Jul 2022 03:36:04 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id 70so1393814pfx.1;
        Thu, 21 Jul 2022 03:36:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eFWQxgmoOmb0OXJQ/pZFCZuTJ4aZfLkbiYFQ43Ipza4=;
        b=phLpZKgJUCca2MNXFSj7jUoVdqQrWwulesLvEoe7ojliOoavpkNnI5EvlaZKu2XHi8
         w7JTFKlHfgQox1tmYzRK4fS6CBH3hqfOBnmx/u7I4DktajZoL560ap1IswAp/LHURXUj
         b6U1SCCPI2HKOg81+ziNbd+IopWjvTCZZLfGMtcNh164odPg18iK0bbZwW0a94vylAwH
         NYCehxkioPtYKeBTnO5P+ppYWrN6LQ8R+pTC31J2m4kIE9sBAqmHjFSSyGS659VDPAVv
         1DWJzeWI0Ry3MG6mK63JppRubrFZ0/CD/i1yYL+sjWS67RzlX3ikvVl1ploXIqEW/D3o
         jDrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eFWQxgmoOmb0OXJQ/pZFCZuTJ4aZfLkbiYFQ43Ipza4=;
        b=GiNgHy5O/1syaZzlKmSjwNKFnpU2GBu/8LCyUX69EIbd61wkSdr6IFCl1Jl7M6r67K
         XS5u3omEOS7w7iH/5s7FdtjJsEOSYBpeXTpUmxRfwBwmZ8rACtmsVOTRdseAAebnOLko
         ff7FUgtjEG1k0jhMgzSYC5H/Ayo/ANp6FDIweOKWA3M82fQPINZfTkom4y/IV+3rX8B5
         wz/qM6qcp814It8nHDMt1qSgSMpIc2SKRMTsdmHaLtKVWMwAn/3Dn8TXYAlZxEwvSAvC
         G68OiMT08u+BQs3gEgxWQhAMxRSK3PFlED+Z7mWvQml1lcqs3yos2ytMhB5Rxb5jKKmu
         D0kQ==
X-Gm-Message-State: AJIora8/IPuUjXubFvV7z6sr88bSDpAhvTVBA8GfRvYQMB5lI1JiUixK
        /RBe+b51EFVSmKng731+Zow=
X-Google-Smtp-Source: AGRyM1v9f/CPoSpHsCfRwb3fbhYN2WhLVkyAvAo38NyFTK8Ye5td8wRcdZNqi+b7pMLQuo2rYYHa5Q==
X-Received: by 2002:a63:1648:0:b0:41a:49f9:77ae with SMTP id 8-20020a631648000000b0041a49f977aemr11979681pgw.377.1658399763573;
        Thu, 21 Jul 2022 03:36:03 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id q12-20020a65494c000000b00419aa0d9a2esm1161887pgs.28.2022.07.21.03.36.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 03:36:03 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH v2 3/7] KVM: x86/pmu: Avoid setting BIT_ULL(-1) to pmu->host_cross_mapped_mask
Date:   Thu, 21 Jul 2022 18:35:44 +0800
Message-Id: <20220721103549.49543-4-likexu@tencent.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220721103549.49543-1-likexu@tencent.com>
References: <20220721103549.49543-1-likexu@tencent.com>
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

In the extreme case of host counters multiplexing and contention, the
perf_event requested by the guest's pebs counter is not allocated to any
actual physical counter, in which case hw.idx is bookkept as -1,
resulting in an out-of-bounds access to host_cross_mapped_mask.

Fixes: 854250329c02 ("KVM: x86/pmu: Disable guest PEBS temporarily in two rare situations")
Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/vmx/pmu_intel.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 4bc098fbec31..22793348aa14 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -783,20 +783,20 @@ static void intel_pmu_cleanup(struct kvm_vcpu *vcpu)
 void intel_pmu_cross_mapped_check(struct kvm_pmu *pmu)
 {
 	struct kvm_pmc *pmc = NULL;
-	int bit;
+	int bit, hw_idx;
 
 	for_each_set_bit(bit, (unsigned long *)&pmu->global_ctrl,
 			 X86_PMC_IDX_MAX) {
 		pmc = intel_pmc_idx_to_pmc(pmu, bit);
 
 		if (!pmc || !pmc_speculative_in_use(pmc) ||
-		    !intel_pmc_is_enabled(pmc))
+		    !intel_pmc_is_enabled(pmc) || !pmc->perf_event)
 			continue;
 
-		if (pmc->perf_event && pmc->idx != pmc->perf_event->hw.idx) {
-			pmu->host_cross_mapped_mask |=
-				BIT_ULL(pmc->perf_event->hw.idx);
-		}
+		hw_idx = pmc->perf_event->hw.idx;
+		/* make it a little less dependent on perf's exact behavior */
+		if (hw_idx != pmc->idx && hw_idx > -1)
+			pmu->host_cross_mapped_mask |= BIT_ULL(hw_idx);
 	}
 }
 
-- 
2.37.1

