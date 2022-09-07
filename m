Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 261F25B020D
	for <lists+kvm@lfdr.de>; Wed,  7 Sep 2022 12:49:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbiIGKs7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Sep 2022 06:48:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbiIGKs5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Sep 2022 06:48:57 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AFFE85FF4;
        Wed,  7 Sep 2022 03:48:57 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id y136so9273804pfb.3;
        Wed, 07 Sep 2022 03:48:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=TeQlVcT77pEQtuTbf7OOQb9vpiZRFZqlXe4X8qaQLZQ=;
        b=hnsvqfhuUA55epY9rfkfpSssISb5V7LmfXGduqnJSdY91WYQH704F/AxVEO1hlI5Jg
         3+Gj/Tk5c0lMP5WTUbQK6idPtTAJ53brKLNpmX/gxhdoMwJnfqiUdhOjoWWGX9djgiCr
         GGI21an9QH8JF/lPmZBfKIEyJ9eyWjk5ipMn6rnbDopuquW5KVDKCwE9PPUdFoE4yiTo
         ewUieeOwx8l69kZ+v7tWnG2jrJ0oxMtj2bbvfmlav/kvvM4p0XgXmUP4glLk80jXAABd
         D/oZnTLKUUcN2248bLT0ZJQTUzSKoEH9IX/kPXh6eO5eb76hr6mTaDB9xUS9Kin93iQ1
         wusg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=TeQlVcT77pEQtuTbf7OOQb9vpiZRFZqlXe4X8qaQLZQ=;
        b=xExwlylsRA89rJGJLr8WWPLavRdyMReOTnkROBe/rdcycx7MQfO1HG6t6aEz3t3iGk
         1EVlC8O3eMwGLDHUjc3zW8SQYBaIefb9Sfbam3pOSw/o6FbTIfXQ7s4ULpYELunDYDX2
         wme4aWbq5smloMYRZ/7R97kQ/+8/4G7ZW0qUDgm9zrZkiALeUWgI8WsNBFpuC+WJngxt
         D4a7dwxxrIYwQtVRjfngGKWtJYHIAF9hIRB0BxE/StSZhxjHO9Jp6jlE/tHGdokOwDdm
         g6UIAgt5FDT9eX2q/zhTfOACZprJ440ndFXflAmlZ+eJStq8er+DIMxeKhyGIMBSXgkx
         6KQw==
X-Gm-Message-State: ACgBeo2986m36Sa6pbZZjYJZS+D+KJPIw4jaUg0aP3qaGtmay91RhOu+
        qtpuX4H8T5aVt8VdfbJwA+E=
X-Google-Smtp-Source: AA6agR7DQtvn0PvFjeuiADxzE0kJBFyK1O5StlJvBR9RCLvr3sfWj68GbVSZ7XrldEqdfNp7fD0++Q==
X-Received: by 2002:a63:5757:0:b0:434:fe36:3fe8 with SMTP id h23-20020a635757000000b00434fe363fe8mr860920pgm.619.1662547736634;
        Wed, 07 Sep 2022 03:48:56 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id x14-20020aa79a4e000000b0053e22fc5b4fsm4044044pfj.0.2022.09.07.03.48.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Sep 2022 03:48:56 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>
Subject: [PATCH v2 1/3] KVM: x86/pmu: Stop adding speculative Intel GP PMCs that don't exist yet
Date:   Wed,  7 Sep 2022 18:48:36 +0800
Message-Id: <20220907104838.8424-1-likexu@tencent.com>
X-Mailer: git-send-email 2.37.3
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

The Intel April 2022 SDM - Table 2-2. IA-32 Architectural MSRs adds
a new architectural IA32_OVERCLOCKING_STATUS msr (0x195), plus the
presence of IA32_CORE_CAPABILITIES (0xCF), the theoretical effective
maximum value of the Intel GP PMCs is 14 (0xCF - 0xC1) instead of 18.

But the conclusion of this speculation "14" is very fragile and can
easily be overturned once Intel declares another meaningful arch msr
in the above reserved range, and even worse, Intel probably put PMCs
8-15 in a completely different range of MSR indices.

A conservative proposal would be to stop at the maximum number of Intel
GP PMCs supported today. Also subsequent changes would limit both AMD
and Intel on the number of GP counter supported by KVM.

There are some boxes like Intel P4 may indeed have 18 counters, but
those counters are in a completely different msr address range and do
not strictly adhere to the Intel Arch PMU specification, and will not
be supported by KVM in the near future.

Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Suggested-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Like Xu <likexu@tencent.com>
---
Previous:
https://lore.kernel.org/kvm/20220906081604.24035-1-likexu@tencent.com/
V1 -> V2 Changelog:
- Stop at the maximum number of GP PMCs supported today; (Jim)

 arch/x86/kvm/x86.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 43a6a7efc6ec..884f6de11a33 100644
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
@@ -6943,12 +6933,12 @@ static void kvm_init_msr_list(void)
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

