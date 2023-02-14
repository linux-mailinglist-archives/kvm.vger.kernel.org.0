Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB5A1695826
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 06:08:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231350AbjBNFIa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 00:08:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230340AbjBNFIW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 00:08:22 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8FF2C3;
        Mon, 13 Feb 2023 21:08:21 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id rm7-20020a17090b3ec700b0022c05558d22so14346135pjb.5;
        Mon, 13 Feb 2023 21:08:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7f/RGDIwBGEKuVXDzcnVi9MBS4p0Tos6fWeLH3cbpCY=;
        b=HKWXX//Sw0gA7f15coHTwACZvYEcDEjr+lxnAQeDtyepUeBpFvaM8ljFW3ozP96CvE
         AIFOmhLIrXpqYBhy1tnGmrvm4Gr1jh20d6RyQAyj50CfEazIYJzNY9iPQAmUHja+NRm/
         HfSF9q3azA4+Bnfy6eP+X32sjL/AeEamFkXhw827tf3s5b1TZHuyY2f2snt3eKNijOzd
         YuhQ4cDUzRgpbMMdmyqTK41KFiHR3dXHH4/C2qH+49nHWe61yM8kn4y19syEndoDIZ//
         jVPfHoKF/jIzSNA5sCYnEnqH11D2txK7Fm9di8fROfzq4cWtnpa7GKuF1X2/aInWMi0a
         CK2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7f/RGDIwBGEKuVXDzcnVi9MBS4p0Tos6fWeLH3cbpCY=;
        b=XLpNb95fdO4s3U/v8GuIFtG/QxGOaW+eblAMHO1cqRRTKh+1Rh4MS8GWCGNqWIIsMe
         uMS1k52b3MKgONaCbacW8syG+YnUUU94EHZ6FBtyR2Ehr/mQbe9cBoE1XwO9Wu0sYg5Z
         OLdpGqJwbxfoIHRNKbKn+M7YkUNGhVsxjT4gMC4PmpEDMoi/QdhRR4jaGN6RChYACB23
         DoCAYvwfMFArqKb+rcJQxvZDeEE50f/he6kUUnMdJRJpM/t82OudCQOtAZEMT5lbp1hm
         zO97O5uFd4iLro4Tb8Q6xUTZoK13PR1jZQ3OtSTJoQPCiBeS0RBvhwaRrwZbG+dAqmMD
         tI0Q==
X-Gm-Message-State: AO0yUKWgH8GfCpuaLUflUyebjJ+g1YvYWfPz7Douoh8ms/Gz1eCKMlI3
        AJAFNVzUO+cMW8ETkqtZfnMy9dO1Z/t65GXOQHI=
X-Google-Smtp-Source: AK7set+7oPnA3mwLcq5mUFlIKGB3qHZYMN2X+Uph/F4hWY+O7oYp43O0jWdotmNgPhtWTIwrJxsNcw==
X-Received: by 2002:a05:6a20:244d:b0:c0:c905:7b23 with SMTP id t13-20020a056a20244d00b000c0c9057b23mr1229783pzc.48.1676351301426;
        Mon, 13 Feb 2023 21:08:21 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id j22-20020aa79296000000b005a79f5d9f53sm8738919pfa.165.2023.02.13.21.08.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Feb 2023 21:08:21 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 03/12] KVM: x86/pmu: Rewrite reprogram_counters() to improve performance
Date:   Tue, 14 Feb 2023 13:07:48 +0800
Message-Id: <20230214050757.9623-4-likexu@tencent.com>
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

A valid pmc is always tested before using pmu->reprogram_pmi. Eliminate
this part of the redundancy by setting the counter's bitmask directly,
and in addition, trigger KVM_REQ_PMU only once to save more cpu cycles.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/vmx/pmu_intel.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 6a2f8b4ed061..069e1aae418c 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -73,16 +73,16 @@ static struct kvm_pmc *intel_pmc_idx_to_pmc(struct kvm_pmu *pmu, int pmc_idx)
 	}
 }
 
-static void reprogram_counters(struct kvm_pmu *pmu, u64 diff)
+static inline void reprogram_counters(struct kvm_pmu *pmu, u64 diff)
 {
 	int bit;
-	struct kvm_pmc *pmc;
 
-	for_each_set_bit(bit, (unsigned long *)&diff, X86_PMC_IDX_MAX) {
-		pmc = intel_pmc_idx_to_pmc(pmu, bit);
-		if (pmc)
-			kvm_pmu_request_counter_reprogam(pmc);
-	}
+	if (!diff)
+		return;
+
+	for_each_set_bit(bit, (unsigned long *)&diff, X86_PMC_IDX_MAX)
+		set_bit(bit, pmu->reprogram_pmi);
+	kvm_make_request(KVM_REQ_PMU, pmu_to_vcpu(pmu));
 }
 
 static bool intel_hw_event_available(struct kvm_pmc *pmc)
-- 
2.39.1

