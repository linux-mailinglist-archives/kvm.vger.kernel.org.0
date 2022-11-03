Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A94DD6188AD
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 20:21:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231749AbiKCTVN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Nov 2022 15:21:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231684AbiKCTUw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Nov 2022 15:20:52 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76ADA23169
        for <kvm@vger.kernel.org>; Thu,  3 Nov 2022 12:18:32 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id q1-20020a17090aa00100b002139a592adbso4166793pjp.1
        for <kvm@vger.kernel.org>; Thu, 03 Nov 2022 12:18:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=GmelCOWbpJOuT596TpUXLsWGplfU0uDeku5OsugjLP4=;
        b=TvrF1k5riIuc6RKOaBcjgm+H62ubUl+G6bsb/vZWNogiLYC8uUC4vK/DWs1+xn6IUG
         myXe2OUVCncw1uKA9pZ93Gl/nhnKwJT+iA0uhuGJ5L4EvivUM9XVXhnxoNu1p5XTh2Xi
         e9GnugRLYTn5aIhpIsTOhwHeyz+kCWBVSksTT/HKq4z/6vl9grhlgvLS3w/Y+FWQHCz1
         S8FdbYPRQKx870QToMV9p0ysypWq2XKJHVowBBRiKeJZNyIRuv7jQzt3ErlQ8Jq0zCCP
         1AVZQ/jw8l9n9+mtLJmr8z+OJfZjxpSPR4AMZevbER1w2LQ3ybJpTv0Y4v8qQ/vHHCP6
         Ckuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GmelCOWbpJOuT596TpUXLsWGplfU0uDeku5OsugjLP4=;
        b=HGAWjJ7RDKt/q9TuvBzJXdjFG1yd/e24WyqG5OKYJxYX4OT64OmzPRI/7dbMzu4CQ3
         46KSMcpWcL1o0CxU2ImK89KY1MoAZYzu+oGDFub33dMpSTUlOogX2p0FZRe2cBniXJ/r
         pvg7dlCZ3ERRUwwuW7SHnloI6Rsn/SMIW1blIV0Ua0Ux8XOxXqkt6my4ycWzQ/Lfno8U
         EJWX37XPCBcK3iWv9jr2tMyimlqF/1FlBBVtQ5z7uOWrQtIv/2bzfXVX0MnS2tZK4wEQ
         j/5rfv2/BXPOPIkKG6bQDy34nqzqoKmz+Pa8m2Qds8NPSoCarNVddSWr1dU7qpnC15Xi
         IbMg==
X-Gm-Message-State: ACrzQf3VtgPr1XLGGm8pW7Tkuu+Bsvdz8L8dkNpP17DRCMHqJ6heF+3T
        BUaoOr0yTQhv/gv9zyDIeqF5Xxj87PuK18tZs1JNpfJBh8ap+WXAbKHh3jaoiiAy4UxWZl81Jbj
        i/BW7bBG8TzjB4vo7BrdH6/tA9jYJjmQ97apcOv3udE9NoalyOAKJp9y31h7qHTgm7gpp
X-Google-Smtp-Source: AMsMyM4GxY+cNoWZfr4p0X7e6Z18ZE6hk9N6t+TZbijpkEv50V8W+HpWylSAHDjX5w4lvfARuzp7CBO8E0nqfMI1
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a65:5583:0:b0:461:25fe:e982 with SMTP
 id j3-20020a655583000000b0046125fee982mr27387849pgs.4.1667503107241; Thu, 03
 Nov 2022 12:18:27 -0700 (PDT)
Date:   Thu,  3 Nov 2022 19:17:34 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221103191733.3153803-1-aaronlewis@google.com>
Subject: [PATCH] KVM: x86: Omit PMU MSRs from KVM_GET_MSR_INDEX_LIST if !enable_pmu
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When the PMU is disabled, don't bother sharing the PMU MSRs with
userspace through KVM_GET_MSR_INDEX_LIST.  Instead, filter them out so
userspace doesn't have to keep track of them.

Note that 'enable_pmu' is read-only, so userspace has no control over
whether the PMU MSRs are included in the list or not.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 arch/x86/kvm/x86.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 521b433f978c..19bc42a6946d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7042,13 +7042,20 @@ static void kvm_init_msr_list(void)
 				continue;
 			break;
 		case MSR_ARCH_PERFMON_PERFCTR0 ... MSR_ARCH_PERFMON_PERFCTR0 + 17:
-			if (msrs_to_save_all[i] - MSR_ARCH_PERFMON_PERFCTR0 >=
-			    min(INTEL_PMC_MAX_GENERIC, kvm_pmu_cap.num_counters_gp))
+			if ((msrs_to_save_all[i] - MSR_ARCH_PERFMON_PERFCTR0 >=
+			    min(INTEL_PMC_MAX_GENERIC, kvm_pmu_cap.num_counters_gp)) ||
+			    !enable_pmu)
 				continue;
 			break;
 		case MSR_ARCH_PERFMON_EVENTSEL0 ... MSR_ARCH_PERFMON_EVENTSEL0 + 17:
-			if (msrs_to_save_all[i] - MSR_ARCH_PERFMON_EVENTSEL0 >=
-			    min(INTEL_PMC_MAX_GENERIC, kvm_pmu_cap.num_counters_gp))
+			if ((msrs_to_save_all[i] - MSR_ARCH_PERFMON_EVENTSEL0 >=
+			    min(INTEL_PMC_MAX_GENERIC, kvm_pmu_cap.num_counters_gp)) ||
+			    !enable_pmu)
+				continue;
+			break;
+		case MSR_F15H_PERF_CTL0 ... MSR_F15H_PERF_CTR5:
+		case MSR_K7_EVNTSEL0 ... MSR_K7_PERFCTR3:
+			if (!enable_pmu)
 				continue;
 			break;
 		case MSR_IA32_XFD:
-- 
2.38.1.431.g37b22c650d-goog

