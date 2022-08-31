Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 074BB5A797D
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 10:53:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbiHaIx4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 04:53:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231475AbiHaIxx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 04:53:53 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 662FDCAC40;
        Wed, 31 Aug 2022 01:53:49 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id d12so13519413plr.6;
        Wed, 31 Aug 2022 01:53:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=uKjXaCvraXKdFShGCWadz+/E1NVHvgjhtf2XIArgSac=;
        b=GWUqEesQbD5/Q9UnVR3R1W9wGubBzOeCuDhCRAJM9YFlj9i/uFMw+0GsT/Dck5kUtg
         w0sPTopTebcUmcOmywdE44BNiz13noJHi2DMCP0D0j2Syze16gaSzUWoyhcspVKp6Xdq
         S0FXMEszLrTUQlkC4jW3vcQ/AWrk7CWjk4sBOTB3EemlqqLgk6xTSsAOS6+lYgp93618
         8hB/6lJ0W8sHQEsZmUT1IkqNSmQAZ24VQnVn8nTmVZfn8mNIvN4Rg28XSPyfmTYRMXCC
         GPKrZ7bA8RcMWZd2eVuSt/Nd7vuX6wTt1JUn0ANhrgDT9QasVD47XXB9HjwioBxwhTMA
         Fs8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=uKjXaCvraXKdFShGCWadz+/E1NVHvgjhtf2XIArgSac=;
        b=zq5ByVlh49l9gk3dr/FEMU+7afWrxgNf44jKoKYNI544bgaU/BzgAWOBDQrcQgXUCg
         HVpiT5X4YeqiJhGsJUAxf0HznRZLmzZptQKRuBXOsYSfwF/aynSL+OfbTS3Bp/veUC51
         bO+ycUFfYYqWRyWKMdWHcQBs8LTQGlYLIomFh8G7ngRaVy3Y/DysRgaQb0eAz2vx4bP6
         7Q7Hj10ewWx6BS+w44ScgblbxpEhzbApY+Ls6jEvnUDF/OlKm3mgk3Znmmbhz09XF5N/
         B0/0q1zPXnUc+Ms9bnYt9v4BcF53Nq39GhLitEMbTxaze6rNXc/+DsGZ0DDQ/Gp04KGt
         uK4g==
X-Gm-Message-State: ACgBeo2Ci1xBJJP5xBldTIc0tkoMNy/3bYJOhDeQugsO/BfMDoCGV9O3
        Kp/pQHTzoLo/URnJ3klt6Mo=
X-Google-Smtp-Source: AA6agR4sUkABqoKYIWRVOfJfk77ZcNzOkJqZCIoCyvSudVU2xCRVF3PVf9PKAn+v4ElShCJ93GxDNQ==
X-Received: by 2002:a17:902:f641:b0:172:e2f8:7efb with SMTP id m1-20020a170902f64100b00172e2f87efbmr24210882plg.140.1661936028708;
        Wed, 31 Aug 2022 01:53:48 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id 26-20020a17090a1a1a00b001fab208523esm868772pjk.3.2022.08.31.01.53.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Aug 2022 01:53:48 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/7] KVM: x86/pmu: Avoid setting BIT_ULL(-1) to pmu->host_cross_mapped_mask
Date:   Wed, 31 Aug 2022 16:53:22 +0800
Message-Id: <20220831085328.45489-2-likexu@tencent.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220831085328.45489-1-likexu@tencent.com>
References: <20220831085328.45489-1-likexu@tencent.com>
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
2.37.3

