Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 965455BF69C
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 08:48:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbiIUGsu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 02:48:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbiIUGss (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 02:48:48 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7D7780F62;
        Tue, 20 Sep 2022 23:48:47 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id q3so5445040pjg.3;
        Tue, 20 Sep 2022 23:48:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=xurnjg6bo3Owb0E+vv7NZukh9QWZAaSruqg+66dadlY=;
        b=pKj7d6eQ8vGfmarpTQk/mOmGqK97CL1G3DQ5G1gqqLmmreBImdCWoaC0FFEXoAQMf7
         yANnTJgiTXKE1rSl/0b/mEkomFsdrg9L4eWTDDmXlo56hN3r75T84fA9okWrXMZshjL+
         peCH0sXazbPml9XnuiqgAj2jRz5FA9ZJ1TKx+3aX4TFlhlQhLvJWLnGpn+xEFwNd8MgL
         eROy97HwNxHcTvy8wfwxWJyhkCKBFzivpulX+BkpKj3BQaaYBiCaRtp93LnEZg7NxqVj
         pRHop+cJh/BQfPncmxEhfbJs94qpI7ZADhWA7H6neCNYrm5szYnACZXPxEM1rSCmT8/y
         OSRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=xurnjg6bo3Owb0E+vv7NZukh9QWZAaSruqg+66dadlY=;
        b=XOan4XHJs0wiXZj4ZHaTmPU8zGRPfKnpO/VYvdxwCr4pUART7nHKYz1xlMJTFHairL
         9uiRWsM96qxmxER9filE4CVMUiupYqHbmnKA8IYRedCGBs5zxfxEF+wUruvsvOKJmDIU
         SC5ulPEiCZwfW8BNXjU/X284yAKqTIOKEqgzSRsnZbhuSON73ES1LfF4DivY3/9NbDBp
         4UkjUMBITfTQdNgBf3A/nvBUvUqMw3JF3OW0A3h5yxoU+t8fBHc0PrYlEsnvF7dUO9kZ
         pg15S7IWmTW89g1fsjlnXB4zacf2X8K8tvkPbHdbcBQV+DbqIOxqqLLVa1xvAMfJBBeb
         IU1A==
X-Gm-Message-State: ACrzQf2ly76cnFCwEinZxO1kGbWYp0V5TP75epfZhX0YRBNSWSTLItPK
        03Bf8Zhro6BcP4llquYDkp0=
X-Google-Smtp-Source: AMsMyM7mVdKvFAF5LQMcscRjuFHOXhziJthXNKphDNdpbJqDhMsIVZyYp0B+p/Avfq2LesmEkn83uQ==
X-Received: by 2002:a17:902:c245:b0:178:3912:f1fe with SMTP id 5-20020a170902c24500b001783912f1femr3384019plg.13.1663742927300;
        Tue, 20 Sep 2022 23:48:47 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id b15-20020a170902d50f00b00174c235e1fdsm1086625plg.199.2022.09.20.23.48.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Sep 2022 23:48:46 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Kan Liang <kan.liang@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jim Mattson <jmattson@google.com>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH] KVM: x86/pmu: Add PEBS support for Intel Sapphire Rapids
Date:   Wed, 21 Sep 2022 14:48:27 +0800
Message-Id: <20220921064827.936-1-likexu@tencent.com>
X-Mailer: git-send-email 2.37.3
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

Virtualization support for SPR PEBS has officially available in the
Intel SDM (June 2022) and has been validated on late stepping machines:

Compared to Ice Lake Server, the PDIR counter available (Fixed 0) on SPR
is unchanged, but the capability is enhanced to Instruction-Accurate PDIR
(PDIR++), where PEBS is taken on the next instruction after the one that
caused the overflow. Also, it introduces a new Precise Distribution (PDist)
facility that eliminates the skid when a precise event is programmed
on general programmable counter 0.

For guest usage, KVM will raise attr.precise_ip to 3 in both cases
mentioned above, requesting the correct hardware counter (PRIR++
or PDist) from the perf sub-system on the host as usual.

Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/events/intel/core.c |  1 +
 arch/x86/kvm/pmu.c           | 17 ++++++++++++++---
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 2db93498ff71..804540ba4599 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -6288,6 +6288,7 @@ __init int intel_pmu_init(void)
 		x86_pmu.pebs_constraints = intel_spr_pebs_event_constraints;
 		x86_pmu.extra_regs = intel_spr_extra_regs;
 		x86_pmu.limit_period = spr_limit_period;
+		x86_pmu.pebs_ept = 1;
 		x86_pmu.pebs_aliases = NULL;
 		x86_pmu.pebs_prec_dist = true;
 		x86_pmu.pebs_block = true;
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 02f9e4f245bd..81e9d7c2332d 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -28,9 +28,18 @@
 struct x86_pmu_capability __read_mostly kvm_pmu_cap;
 EXPORT_SYMBOL_GPL(kvm_pmu_cap);
 
-static const struct x86_cpu_id vmx_icl_pebs_cpu[] = {
+/* Precise Distribution of Instructions Retired (PDIR) */
+static const struct x86_cpu_id vmx_pebs_pdir_cpu[] = {
 	X86_MATCH_INTEL_FAM6_MODEL(ICELAKE_D, NULL),
 	X86_MATCH_INTEL_FAM6_MODEL(ICELAKE_X, NULL),
+	/* Instruction-Accurate PDIR (PDIR++) */
+	X86_MATCH_INTEL_FAM6_MODEL(SAPPHIRERAPIDS_X, NULL),
+	{}
+};
+
+/* Precise Distribution (PDist) */
+static const struct x86_cpu_id vmx_pebs_pdist_cpu[] = {
+	X86_MATCH_INTEL_FAM6_MODEL(SAPPHIRERAPIDS_X, NULL),
 	{}
 };
 
@@ -181,12 +190,14 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
 		 * the accuracy of the PEBS profiling result, because the "event IP"
 		 * in the PEBS record is calibrated on the guest side.
 		 *
-		 * On Icelake everything is fine. Other hardware (GLC+, TNT+) that
+		 * On Icelake everything is fine. Other hardware (TNT+) that
 		 * could possibly care here is unsupported and needs changes.
 		 */
 		attr.precise_ip = 1;
-		if (x86_match_cpu(vmx_icl_pebs_cpu) && pmc->idx == 32)
+		if ((pmc->idx == 32 && x86_match_cpu(vmx_pebs_pdir_cpu)) ||
+		    (pmc->idx == 0 && x86_match_cpu(vmx_pebs_pdist_cpu))) {
 			attr.precise_ip = 3;
+		}
 	}
 
 	event = perf_event_create_kernel_counter(&attr, -1, current,
-- 
2.37.3

