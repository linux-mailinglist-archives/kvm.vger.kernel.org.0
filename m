Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3705F716263
	for <lists+kvm@lfdr.de>; Tue, 30 May 2023 15:43:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232854AbjE3Nni (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 May 2023 09:43:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232822AbjE3Nn2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 May 2023 09:43:28 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A80C1107;
        Tue, 30 May 2023 06:43:22 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id 98e67ed59e1d1-2566ed9328eso2258517a91.2;
        Tue, 30 May 2023 06:43:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685454202; x=1688046202;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JzrLqGASDYbFqNvtdsUdZw0OXPyNhRJjMakw+o6kIZM=;
        b=pv2xczRMb0JtpSrUKsb/fnu2pROR0KUcTTGV8oJ2k4vuRypKvrq335pEgTzFM0llly
         3n6A8k/HkCorK+t7vRRmNQJy3fV/dsHwLvVZvi/IeynGJYAHx0yAH7WLk6jmtVrzGSgy
         9xX2CzyRCjBo8YuSvYsNq1bYh1MWaJLsu9x32ZlzfyORyArtveNADfIz81avMkPsqUQQ
         PQtCnMeYwQpFyjH+owwtPGmXm3Fr0Ql+jN/65ygk2R8ccn9aGfZu3/HcYjgGj1ozgUKy
         wMlbgzurqGBQIKTs0t0kv+LqJNvVzm8U8WHITXDszKJ7eNmIGCFXaipE0KP8HabsyKGO
         Ugew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685454202; x=1688046202;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JzrLqGASDYbFqNvtdsUdZw0OXPyNhRJjMakw+o6kIZM=;
        b=aEL1c+OU7hp4XFOQUlK5kT5Skif8lI6I2WfBRIpy8s3qytgX9dSo3VIQ6NfzLwM6sI
         6Lcdc25Tedi4V44wvWE0wv6ZwGBTa7QCMO9IOa4VYWQDSA4wTudoO0+bweS+IX2S6kv+
         Nt6vA0T5XU7ERu7gxS0vez0pDQdkxE4uBt7BTod9mFqXDUraTvlTpNl7+4ITFkLA0WVW
         HQk+zkv0eHsPIz1DuAR6vDCptvgexTkXNum8Ce3YbUBRnv6BUK1OrkALK3UITg6Yi3qk
         /EN6DBhJwMFhabrSG9GjPr9t6heTihjRcvQ23tPuKuij4cSJ/IedooaENrGnZYtBsuru
         VPew==
X-Gm-Message-State: AC+VfDz+Rml8MVSnI0AJmOLlji8CiP1TBbbfOZfDuJos3dGT1EhQFvVY
        osuTq0E1pNKa2vNsdHVRN40=
X-Google-Smtp-Source: ACHHUZ7JCOcPgNoT2p9J+8ah1IDTQAoKoJD4mpkIcQy2aPy+pzxVCgw6RB8uZUnkwNgO6hfPU3ojag==
X-Received: by 2002:a17:90a:ba87:b0:256:4d27:a300 with SMTP id t7-20020a17090aba8700b002564d27a300mr2120577pjr.35.1685454201997;
        Tue, 30 May 2023 06:43:21 -0700 (PDT)
Received: from CLOUDLIANG-MB2.tencent.com ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id d10-20020a17090ac24a00b00256a4d59bfasm1977186pjx.23.2023.05.30.06.43.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 May 2023 06:43:21 -0700 (PDT)
From:   Jinrong Liang <ljr.kernel@gmail.com>
X-Google-Original-From: Jinrong Liang <cloudliang@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Like Xu <likexu@tencent.com>,
        David Matlack <dmatlack@google.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jinrong Liang <cloudliang@tencent.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/8] KVM: selftests: Test Intel PMU architectural events on fixed counters
Date:   Tue, 30 May 2023 21:42:44 +0800
Message-Id: <20230530134248.23998-5-cloudliang@tencent.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230530134248.23998-1-cloudliang@tencent.com>
References: <20230530134248.23998-1-cloudliang@tencent.com>
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

From: Jinrong Liang <cloudliang@tencent.com>

Update test to cover Intel PMU architectural events on fixed counters.
Per Intel SDM, PMU users can also count architecture performance events
on fixed counters (specifically, FIXED_CTR0 for the retired instructions
and FIXED_CTR1 for cpu core cycles event). Therefore, if guest's CPUID
indicates that an architecture event is not available, the corresponding
fixed counter will also not count that event.

Co-developed-by: Like Xu <likexu@tencent.com>
Signed-off-by: Like Xu <likexu@tencent.com>
Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
---
 .../kvm/x86_64/pmu_basic_functionality_test.c | 28 +++++++++++++++++--
 1 file changed, 25 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/pmu_basic_functionality_test.c b/tools/testing/selftests/kvm/x86_64/pmu_basic_functionality_test.c
index 1f100fd94d67..81029d05367a 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_basic_functionality_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_basic_functionality_test.c
@@ -47,7 +47,8 @@ static uint64_t run_vcpu(struct kvm_vcpu *vcpu, uint64_t *ucall_arg)
 }
 
 static void intel_guest_run_arch_event(uint8_t version, uint8_t max_gp_num,
-				       uint32_t ctr_base_msr, uint64_t evt_code)
+				       uint32_t ctr_base_msr, uint64_t evt_code,
+				       uint8_t max_fixed_num)
 {
 	uint32_t global_msr = MSR_CORE_PERF_GLOBAL_CTRL;
 	unsigned int i;
@@ -66,6 +67,27 @@ static void intel_guest_run_arch_event(uint8_t version, uint8_t max_gp_num,
 		GUEST_SYNC(_rdpmc(i));
 	}
 
+	/* No need to test independent arch events on fixed counters. */
+	if (version <= 1 || max_fixed_num <= 1)
+		goto done;
+
+	if (evt_code == evt_code_for_fixed_ctr(0))
+		i = 0;
+	else if (evt_code == evt_code_for_fixed_ctr(1))
+		i = 1;
+	else
+		goto done;
+
+	wrmsr(MSR_CORE_PERF_FIXED_CTR0 + i, 0);
+	wrmsr(MSR_CORE_PERF_FIXED_CTR_CTRL, BIT_ULL(4 * i));
+	wrmsr(global_msr, BIT_ULL(INTEL_PMC_IDX_FIXED + i));
+
+	__asm__ __volatile__("loop ." : "+c"((int){NUM_BRANCHES}));
+
+	wrmsr(global_msr, 0);
+	GUEST_SYNC(_rdpmc(RDPMC_FIXED_BASE | i));
+
+done:
 	GUEST_DONE();
 }
 
@@ -90,8 +112,8 @@ static void test_arch_events_cpuid(struct kvm_vcpu *vcpu, uint8_t evt_vector,
 	is_supported = !(entry->ebx & BIT_ULL(idx)) &&
 		(((entry->eax & EVT_LEN_MASK) >> EVT_LEN_OFS_BIT) > idx);
 
-	vcpu_args_set(vcpu, 4, X86_INTEL_PMU_VERSION, X86_INTEL_MAX_GP_CTR_NUM,
-		      ctr_msr, arch_events[idx]);
+	vcpu_args_set(vcpu, 5, X86_INTEL_PMU_VERSION, X86_INTEL_MAX_GP_CTR_NUM,
+		      ctr_msr, arch_events[idx], X86_INTEL_MAX_FIXED_CTR_NUM);
 
 	while (run_vcpu(vcpu, &counter_val) != UCALL_DONE)
 		TEST_ASSERT(is_supported == !!counter_val,
-- 
2.31.1

