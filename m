Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D9A15BC503
	for <lists+kvm@lfdr.de>; Mon, 19 Sep 2022 11:10:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbiISJKb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Sep 2022 05:10:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbiISJK3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Sep 2022 05:10:29 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 886E41F2DB;
        Mon, 19 Sep 2022 02:10:27 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id w2so17177198pfb.0;
        Mon, 19 Sep 2022 02:10:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=fHlvLY2fBY7qCknCJOOeuGtv0KePhJoB00BYpU6dnmw=;
        b=nNwzshRdgEWE/MO/GPprreTpuj+ILWJkxexLesnRfQdLx4ZJo71fDAkFjJr2EMUcDQ
         /fqpF8BiC+FjNJVJbtY0vyMGEC5L9YVRObirBmZGh3YX7ljiLi73zDFhKsCQXmuwkIe7
         JTj5alQPZjafv1GYgOlukWPLTAQERLBQt1b+gkhQ+SOU3lWqnJmAGTus7/ve8tPhThT9
         7omWpUR39CR+KUKBha2nKunOcP9iaIZdhCnnoxtFEowNyTo1+rK+7rR5MKdQYOP4GtaT
         TYCeuoYo3/+iOUcoWqEpuDdwutu/4WOg3DXKSjJQMPfNHMIjgmSGpZRuYtEnc5WUlIUU
         JCWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=fHlvLY2fBY7qCknCJOOeuGtv0KePhJoB00BYpU6dnmw=;
        b=5sSz6AQCX/Nxt641vAh8WJCe1HLsPNpbcQelsttcK/hIFhTg4hr6OZvquJfo3/iPQF
         nKHSMuuQSWbFn+jl9Dz4L3LgqzRSIeNcM31TNUCeRZtAq6aqbMPJq/x+uAcHA/Q1OxkH
         aD4leqJ0FhZuE1wOx4RCcVCnAncR0c352PwfS3E4IMEnIiLtzPozDUqIGrm1K+8y3zZH
         BcS/s/qiguIyG9YIJkZJZ0oAuC3hMMKU/XxPn8YcjC/wRlA+J3MJz0Cyv5tuRV0VTfWn
         IECTRTSpAWQ4Jhfznhvjvh7uuwfZw9oT362zfkVFZiIZjQ3nizf7sNkKNhlotvhrbHSL
         Qghg==
X-Gm-Message-State: ACrzQf3yBruPoh7bpJGcLgAF3ArlRlVqImlcH/2bPSzgl2ojdjJ58qxa
        JcEEjCyVQGj+tRFFRD2oEK+XwCqQU4Qegg==
X-Google-Smtp-Source: AMsMyM4jDnMr8lkr/hIXydKwr/NoWoK2J7CSAgF0rXwfF1A1PX7FitKJVC2x8Q1PyP1dy5bJC93RwA==
X-Received: by 2002:a05:6a00:8d0:b0:53b:2cbd:fab6 with SMTP id s16-20020a056a0008d000b0053b2cbdfab6mr17681522pfu.3.1663578627049;
        Mon, 19 Sep 2022 02:10:27 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id r15-20020a63a54f000000b0043395af24f6sm18185684pgu.25.2022.09.19.02.10.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Sep 2022 02:10:26 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH v3 1/3] KVM: x86/pmu: Stop adding speculative Intel GP PMCs that don't exist yet
Date:   Mon, 19 Sep 2022 17:10:06 +0800
Message-Id: <20220919091008.60695-1-likexu@tencent.com>
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

The Intel April 2022 SDM - Table 2-2. IA-32 Architectural MSRs adds
a new architectural IA32_OVERCLOCKING_STATUS msr (0x195), plus the
presence of IA32_CORE_CAPABILITIES (0xCF), the theoretical effective
maximum value of the Intel GP PMCs is 14 (0xCF - 0xC1) instead of 18.

But the conclusion of this speculation "14" is very fragile and can
easily be overturned once Intel declares another meaningful arch msr
in the above reserved range, and even worse, just conjecture, Intel
probably put PMCs 8-15 in a completely different range of MSR indices.

A conservative proposal would be to stop at the maximum number of Intel
GP PMCs supported today. Also subsequent changes would limit both AMD
and Intel on the number of GP counter supported by KVM.

There are some boxes like Intel P4 (non Architectural PMU) may indeed
have 18 counters , but those counters are in a completely different msr
address range and is not supported by KVM.

Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Fixes: cf05a67b68b8 ("KVM: x86: omit "impossible" pmu MSRs from MSR list")
Suggested-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Like Xu <likexu@tencent.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
---
Previous:
https://lore.kernel.org/kvm/20220907104838.8424-1-likexu@tencent.com/
V2 -> V3 Changelog:
- Append "Reviewed-by" from Jim;
- Refine commit message a little bit; (Jim)
- Put the "Fixes" tag back; (Jim)

 arch/x86/kvm/x86.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d7374d768296..9f74c3924377 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1428,20 +1428,10 @@ static const u32 msrs_to_save_all[] = {
 	MSR_ARCH_PERFMON_PERFCTR0 + 2, MSR_ARCH_PERFMON_PERFCTR0 + 3,
 	MSR_ARCH_PERFMON_PERFCTR0 + 4, MSR_ARCH_PERFMON_PERFCTR0 + 5,
 	MSR_ARCH_PERFMON_PERFCTR0 + 6, MSR_ARCH_PERFMON_PERFCTR0 + 7,
-	MSR_ARCH_PERFMON_PERFCTR0 + 8, MSR_ARCH_PERFMON_PERFCTR0 + 9,
-	MSR_ARCH_PERFMON_PERFCTR0 + 10, MSR_ARCH_PERFMON_PERFCTR0 + 11,
-	MSR_ARCH_PERFMON_PERFCTR0 + 12, MSR_ARCH_PERFMON_PERFCTR0 + 13,
-	MSR_ARCH_PERFMON_PERFCTR0 + 14, MSR_ARCH_PERFMON_PERFCTR0 + 15,
-	MSR_ARCH_PERFMON_PERFCTR0 + 16, MSR_ARCH_PERFMON_PERFCTR0 + 17,
 	MSR_ARCH_PERFMON_EVENTSEL0, MSR_ARCH_PERFMON_EVENTSEL1,
 	MSR_ARCH_PERFMON_EVENTSEL0 + 2, MSR_ARCH_PERFMON_EVENTSEL0 + 3,
 	MSR_ARCH_PERFMON_EVENTSEL0 + 4, MSR_ARCH_PERFMON_EVENTSEL0 + 5,
 	MSR_ARCH_PERFMON_EVENTSEL0 + 6, MSR_ARCH_PERFMON_EVENTSEL0 + 7,
-	MSR_ARCH_PERFMON_EVENTSEL0 + 8, MSR_ARCH_PERFMON_EVENTSEL0 + 9,
-	MSR_ARCH_PERFMON_EVENTSEL0 + 10, MSR_ARCH_PERFMON_EVENTSEL0 + 11,
-	MSR_ARCH_PERFMON_EVENTSEL0 + 12, MSR_ARCH_PERFMON_EVENTSEL0 + 13,
-	MSR_ARCH_PERFMON_EVENTSEL0 + 14, MSR_ARCH_PERFMON_EVENTSEL0 + 15,
-	MSR_ARCH_PERFMON_EVENTSEL0 + 16, MSR_ARCH_PERFMON_EVENTSEL0 + 17,
 	MSR_IA32_PEBS_ENABLE, MSR_IA32_DS_AREA, MSR_PEBS_DATA_CFG,
 
 	MSR_K7_EVNTSEL0, MSR_K7_EVNTSEL1, MSR_K7_EVNTSEL2, MSR_K7_EVNTSEL3,
@@ -6926,12 +6916,12 @@ static void kvm_init_msr_list(void)
 				intel_pt_validate_hw_cap(PT_CAP_num_address_ranges) * 2)
 				continue;
 			break;
-		case MSR_ARCH_PERFMON_PERFCTR0 ... MSR_ARCH_PERFMON_PERFCTR0 + 17:
+		case MSR_ARCH_PERFMON_PERFCTR0 ... MSR_ARCH_PERFMON_PERFCTR0 + 7:
 			if (msrs_to_save_all[i] - MSR_ARCH_PERFMON_PERFCTR0 >=
 			    min(INTEL_PMC_MAX_GENERIC, kvm_pmu_cap.num_counters_gp))
 				continue;
 			break;
-		case MSR_ARCH_PERFMON_EVENTSEL0 ... MSR_ARCH_PERFMON_EVENTSEL0 + 17:
+		case MSR_ARCH_PERFMON_EVENTSEL0 ... MSR_ARCH_PERFMON_EVENTSEL0 + 7:
 			if (msrs_to_save_all[i] - MSR_ARCH_PERFMON_EVENTSEL0 >=
 			    min(INTEL_PMC_MAX_GENERIC, kvm_pmu_cap.num_counters_gp))
 				continue;
-- 
2.37.3

