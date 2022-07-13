Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3337F573655
	for <lists+kvm@lfdr.de>; Wed, 13 Jul 2022 14:26:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236440AbiGMMZz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jul 2022 08:25:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236404AbiGMMZo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jul 2022 08:25:44 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1B08D64E0;
        Wed, 13 Jul 2022 05:25:39 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id g16-20020a17090a7d1000b001ea9f820449so3354399pjl.5;
        Wed, 13 Jul 2022 05:25:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=udbgFzljPHJNNNSaz06lLoXszbhtSudUqIf9IGRqT7U=;
        b=mj2n5SgIT+F2QDRM3BpZnyXs6Yh6Ygj9gh7+fWHqMJZwnuknJVNN0bl1YRotFIDQsJ
         GsI9i7jQBgJidSmd11GN2PHTgRt3i4ZZJtHfS9OMeNaaXgJUNrfH4uqoc06kdbZB8Hbh
         UvnWadpBCV21ZxwfGdQ/+0aIcYsVoZpCoXkJx2QwhynlVdlrJpeMTuGFch+eft4BXJXL
         p4Irowzfv5HKDiNXwzDyB7MwSJmhxZ/RdofEREmLk++E8zwypQpIASsTvJwp3l+UFcB4
         gG4cxujLUtV0zK5l+G98VnnkkiOxy7hDRwe7+d0WZMhGj42iVCc9SnbrVmYbtlbzudyK
         Rjig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=udbgFzljPHJNNNSaz06lLoXszbhtSudUqIf9IGRqT7U=;
        b=uPjdZXfSU93ht0zjGLz3H73vB/bgZ/b0z+eFRRTq6P6dtFe5wyiefqgylElyfK+SKq
         HT1Ctk7RJWuImC/hmXOIx7SafGhbpJSNLuzG3SdMPmYG0V2ArhBlfAhDVP+6JfgCfYp3
         97o52tVIPvVaKNkaO35cQEzlscUbhpDN9asdLBZ8hoBx5XAf8zyHQ/lHHWqEMS++LkJF
         OJo57sJsvBfh0YZV0tnPwe+oPMgX6qEKoPQtCdnIA5suRpe2twsSCKlQaEOqui684+rq
         nwcvrJIbcBxvxWx1x/fi9E/sc+6QC97Rf1Gr0J4+Uy9UF49CL6D0iP7SPl1rOs6E/T7X
         fTQA==
X-Gm-Message-State: AJIora8c3NV18I3DuflXJo5WE/MyF4QuhV/Ez4svHcu266OtDAXgbojm
        GxvMJ0vE3Ozklk1/iB4z2/A=
X-Google-Smtp-Source: AGRyM1vqSK3+LrdHAXn4Vtr3vZJPIpGgMg4bHBPX5fq9kvsvDnzTOPYcrKYznNm8XEY9vXrIMziutQ==
X-Received: by 2002:a17:90b:2384:b0:1ef:8506:374e with SMTP id mr4-20020a17090b238400b001ef8506374emr9991320pjb.99.1657715138574;
        Wed, 13 Jul 2022 05:25:38 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id m7-20020a170902bb8700b0016bf1ed3489sm8719233pls.143.2022.07.13.05.25.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jul 2022 05:25:38 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Like Xu <likexu@tencent.com>
Subject: [PATCH 5/7] KVM: x86/pmu: Avoid using PEBS perf_events for normal counters
Date:   Wed, 13 Jul 2022 20:25:04 +0800
Message-Id: <20220713122507.29236-6-likexu@tencent.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220713122507.29236-1-likexu@tencent.com>
References: <20220713122507.29236-1-likexu@tencent.com>
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

The check logic in the pmc_resume_counter() to determine whether
a perf_event is reusable is partial and flawed, especially when it
comes to a pseudocode sequence (not correct but clearly valid) like:

  - enabling a counter and its PEBS bit
  - enable global_ctrl
  - run workload
  - disable only the PEBS bit, leaving the global_ctrl bit enabled

In this corner case, a perf_event created for PEBS can be reused by
a normal counter before it has been released and recreated, and when this
normal counter overflows, it triggers a PEBS interrupt (precise_ip != 0).

To address this issue, the reuse check has been revamped and KVM will
go back to do reprogram_counter() when any bit of guest PEBS_ENABLE
msr has changed, which is similar to what global_ctrl_changed() does.

Fixes: 79f3e3b58386 ("KVM: x86/pmu: Reprogram PEBS event to emulate guest PEBS counter")
Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/pmu.c           |  4 ++--
 arch/x86/kvm/vmx/pmu_intel.c | 14 +++++++-------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 08ee0fed63d5..2c03fe208093 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -232,8 +232,8 @@ static bool pmc_resume_counter(struct kvm_pmc *pmc)
 			      get_sample_period(pmc, pmc->counter)))
 		return false;
 
-	if (!test_bit(pmc->idx, (unsigned long *)&pmc_to_pmu(pmc)->pebs_enable) &&
-	    pmc->perf_event->attr.precise_ip)
+	if (test_bit(pmc->idx, (unsigned long *)&pmc_to_pmu(pmc)->pebs_enable) !=
+	    (!!pmc->perf_event->attr.precise_ip))
 		return false;
 
 	/* reuse perf_event to serve as pmc_reprogram_counter() does*/
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 1588627974fa..5f6b9f596f16 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -68,15 +68,11 @@ static struct kvm_pmc *intel_pmc_idx_to_pmc(struct kvm_pmu *pmu, int pmc_idx)
 	}
 }
 
-/* function is called when global control register has been updated. */
-static void global_ctrl_changed(struct kvm_pmu *pmu, u64 data)
+static void reprogram_counters(struct kvm_pmu *pmu, u64 diff)
 {
 	int bit;
-	u64 diff = pmu->global_ctrl ^ data;
 	struct kvm_pmc *pmc;
 
-	pmu->global_ctrl = data;
-
 	for_each_set_bit(bit, (unsigned long *)&diff, X86_PMC_IDX_MAX) {
 		pmc = intel_pmc_idx_to_pmc(pmu, bit);
 		if (pmc)
@@ -404,7 +400,7 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	struct kvm_pmc *pmc;
 	u32 msr = msr_info->index;
 	u64 data = msr_info->data;
-	u64 reserved_bits;
+	u64 reserved_bits, diff;
 
 	switch (msr) {
 	case MSR_CORE_PERF_FIXED_CTR_CTRL:
@@ -425,7 +421,9 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (pmu->global_ctrl == data)
 			return 0;
 		if (kvm_valid_perf_global_ctrl(pmu, data)) {
-			global_ctrl_changed(pmu, data);
+			diff = pmu->global_ctrl ^ data;
+			pmu->global_ctrl = data;
+			reprogram_counters(pmu, diff);
 			return 0;
 		}
 		break;
@@ -440,7 +438,9 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (pmu->pebs_enable == data)
 			return 0;
 		if (!(data & pmu->pebs_enable_mask)) {
+			diff = pmu->pebs_enable ^ data;
 			pmu->pebs_enable = data;
+			reprogram_counters(pmu, diff);
 			return 0;
 		}
 		break;
-- 
2.37.0

