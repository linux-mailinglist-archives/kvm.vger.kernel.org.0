Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D1514E749E
	for <lists+kvm@lfdr.de>; Fri, 25 Mar 2022 14:59:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353432AbiCYOBU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Mar 2022 10:01:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358940AbiCYOBN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Mar 2022 10:01:13 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D3ED5F253;
        Fri, 25 Mar 2022 06:59:38 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id j13so8095732plj.8;
        Fri, 25 Mar 2022 06:59:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=EV0wmNwRVxX8NQcoop+BEUS5js89FYD4nmxPHK49pWQ=;
        b=MaTdW3To90ijPhW/yZNfIQWH8ozmuI4LzhKZZvBDJlsmUM8Q8KOcBH9ehtDzmtC3YW
         eBh8n4j26HCJ6UIWcx/uCWY44xhL2PQ0sfAA1+jRChFcFazSPdkTIVADj9Dv0lsOLPG8
         UI6O41pQBpGMsUUKkhL0jM5O/hLzOmYIEJMDkkVr9krBTgPBzhVDEh6+yZt7JQooPEVz
         /pAkUQoqYT62KUT1s8stfPcwAp1cuKUBU4np52nZnrjZQZwV4kFEl9zVyssIJ+qwZFc+
         sgY7F2ftMg5zXJ7ohNd1pPwnjmwomWxeC8VnAE0powpbiCvktOMAr80vds0yyEliKNyN
         3zww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=EV0wmNwRVxX8NQcoop+BEUS5js89FYD4nmxPHK49pWQ=;
        b=YELN5Lrk0E0oFZCpvqtW5YYzQesUqFNMWJwSBo8q2O+JfBgWeLOmPVJWTVU34EQK7A
         6AfDYd1nZo6wOIZHNyrO+CkycXq4xM/vep5R99obENEN9fIZE9AyvKN+mkcmV5sq+mYL
         DasVZAjawP5iWN8kNlB0xXW/Bm5fl0fUya2vB7Gdh0P1ekBt8aKPmoF4++rG31bcr7z6
         5gRAbPbpU/GxWxkYh2CDYuEkEJrrHIk/hnZr8PTDlYovaD6xIKxUcDXU20e1mCBkPby1
         2Ci/GY4+57P/Ze4zkGg5jcCyed+fVICsQIbtmiV9kvDHPPkD9OocWpFzi4Jwug/QQiXE
         VHmA==
X-Gm-Message-State: AOAM530lb9ID88TBVF4W42yiIU1Xk27QaYX6O0wH2xqqqQBDV8wUnf0x
        Xh8u5K6UAlnFOBCY2On2e8Ga7rqAQn0=
X-Google-Smtp-Source: ABdhPJzz7K+/5uo4/3em0DsU11ggYGjYid3uyziE4s7FG3CHnGx59o2D7meiWG5Ps8LDY3KfTEYf5g==
X-Received: by 2002:a17:90b:1e43:b0:1c7:46bf:ba29 with SMTP id pi3-20020a17090b1e4300b001c746bfba29mr12861850pjb.100.1648216777881;
        Fri, 25 Mar 2022 06:59:37 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.113])
        by smtp.googlemail.com with ESMTPSA id lw4-20020a17090b180400b001c7327d09c3sm14470875pjb.53.2022.03.25.06.59.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 25 Mar 2022 06:59:37 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH RESEND 5/5] KVM: X86: Expose PREEMT_COUNT CPUID feature bit to guest
Date:   Fri, 25 Mar 2022 06:58:29 -0700
Message-Id: <1648216709-44755-6-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1648216709-44755-1-git-send-email-wanpengli@tencent.com>
References: <1648216709-44755-1-git-send-email-wanpengli@tencent.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Expose the PREEMPT_COUNT feature bit to the guest, the guest can check this
feature bit before using MSR_KVM_PREEMPT_COUNT.

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 Documentation/virt/kvm/cpuid.rst | 3 +++
 arch/x86/kvm/cpuid.c             | 3 ++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/cpuid.rst b/Documentation/virt/kvm/cpuid.rst
index bda3e3e737d7..c45158af98a7 100644
--- a/Documentation/virt/kvm/cpuid.rst
+++ b/Documentation/virt/kvm/cpuid.rst
@@ -103,6 +103,9 @@ KVM_FEATURE_HC_MAP_GPA_RANGE       16          guest checks this feature bit bef
 KVM_FEATURE_MIGRATION_CONTROL      17          guest checks this feature bit before
                                                using MSR_KVM_MIGRATION_CONTROL
 
+KVM_FEATURE_PREEMPT_COUNT          18          guest checks this feature bit before
+                                               using MSR_KVM_PREEMPT_COUNT
+
 KVM_FEATURE_CLOCKSOURCE_STABLE_BIT 24          host will warn if no guest-side
                                                per-cpu warps are expected in
                                                kvmclock
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 58b0b4e0263c..4785f5a63d8d 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1071,7 +1071,8 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 			     (1 << KVM_FEATURE_PV_SEND_IPI) |
 			     (1 << KVM_FEATURE_POLL_CONTROL) |
 			     (1 << KVM_FEATURE_PV_SCHED_YIELD) |
-			     (1 << KVM_FEATURE_ASYNC_PF_INT);
+			     (1 << KVM_FEATURE_ASYNC_PF_INT) |
+			     (1 << KVM_FEATURE_PREEMPT_COUNT);
 
 		if (sched_info_on())
 			entry->eax |= (1 << KVM_FEATURE_STEAL_TIME);
-- 
2.25.1

