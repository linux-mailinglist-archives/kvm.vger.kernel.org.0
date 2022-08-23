Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93E2759E133
	for <lists+kvm@lfdr.de>; Tue, 23 Aug 2022 14:39:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358725AbiHWLxU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 07:53:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358567AbiHWLw0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 07:52:26 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C00A4D4BF8;
        Tue, 23 Aug 2022 02:32:48 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id 1so5739064pfu.0;
        Tue, 23 Aug 2022 02:32:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=nsftH5dD52AwRoWk2NYBNp/4StwHh8764Sbyy9peaj4=;
        b=IEoQCpQziqDUsVDWLwDtk0AUe7uob+W+yrwymTEwEBsqTF8eQ7jbzjaQLrPDYPT2B4
         ZabGkAEqnzfOzwpF8C5sSoSsLhCuU3vzY42wDTkIKMFuZ5xDHYuq7n2ALcdSE2UFGHRH
         rd8o5fRFZXg8lQogm91SmrkOh8QgQm4umYz7bOarUIVjfEbz9DEDpxlQVYXvfDZ5WpP0
         a8IJRqGxzddXOvkConpS8bHshUU4kZpXfDz/dvKJecpb4/cOwc9gh2trOPz0toQRgphW
         IQCJrCS2tHrPxGmDuyuw1gxeL0XTyeCYZZ2eZRZwQXds+2tvkV9ecK+sDEUkUPrIfiVn
         XP/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=nsftH5dD52AwRoWk2NYBNp/4StwHh8764Sbyy9peaj4=;
        b=UODJVLbSaXWjx+usw6x2Ji/+xMBHWj+3Tf+Q+sVMtuNybN8k6Pu9go5A1IFe59/Wl3
         GGLETLVrxoT4OkArNtSgRH/DAJuClp8xHSgSroDkWsoCgdNxnHXpgwyaru9nj1H128mV
         tpMRPE+IxbT36JQCht4uv1fW/i4MsF41EthcDe4QjMhEkkUcTDUd1jA8mPPGtiWeoHEn
         AKXzZHSd5kPr4tGyZ70O5b0JZyy5noryj7gVLn4rv750Fw/ZIj25Il2Uxlj9nBFVYUZd
         VlrLzqIfP2q29YFNBlncVGgKRamhZJwL/08d2Pmmjd/jfMpmLX69L7AwbBoap4lGRBQa
         ZZyw==
X-Gm-Message-State: ACgBeo2FoOLPqpM1b4i3CuW5rDOpktdsJtwnJmIEfG0IdRQfRYFXd3b1
        53iPxIXaDzObjySj6M/MRto=
X-Google-Smtp-Source: AA6agR402iDPUq9rKI/l4S5qq+JgdB5XAVxduUDaKxvzj/vf7rHt3thUYW+JbMJb5BZYTaAcNk4Naw==
X-Received: by 2002:a05:6a00:1501:b0:52f:2556:9b7f with SMTP id q1-20020a056a00150100b0052f25569b7fmr23979938pfu.27.1661247167044;
        Tue, 23 Aug 2022 02:32:47 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id 13-20020a170902c24d00b0017297a6b39dsm10057212plg.265.2022.08.23.02.32.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Aug 2022 02:32:46 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH RESEND v2 2/8] KVM: x86/pmu: Avoid setting BIT_ULL(-1) to pmu->host_cross_mapped_mask
Date:   Tue, 23 Aug 2022 17:32:15 +0800
Message-Id: <20220823093221.38075-3-likexu@tencent.com>
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
index c399637a3a79..d595ff33d32d 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -776,20 +776,20 @@ static void intel_pmu_cleanup(struct kvm_vcpu *vcpu)
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
2.37.2

