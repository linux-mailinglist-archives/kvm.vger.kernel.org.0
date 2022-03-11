Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EBD44D5D59
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 09:31:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236636AbiCKIbZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Mar 2022 03:31:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236694AbiCKIbU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Mar 2022 03:31:20 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 156E31B45FD;
        Fri, 11 Mar 2022 00:30:18 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id o23so6871494pgk.13;
        Fri, 11 Mar 2022 00:30:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=EV0wmNwRVxX8NQcoop+BEUS5js89FYD4nmxPHK49pWQ=;
        b=RrVI3XYBW4Johmu7rVRoRIRMELwbIMEQGU6gIqjMpTGdMT8ebwN8sRXICZNvCvvu5j
         l/hb2+A5ZXJ5vqw3gXP4MwbmhAA4HGSZr+0IJH7DGxTVBjqkbrLeqhzE9fv6UzIx+QNj
         xj3JpteEUBMII006M1xmgqcp4q2G2hem5fEMpyzal58kW/U6ZXQCN/AvAn9m39qbuN2U
         P41237l1RVwxdvtfJ2ZOh7rIvBwrOe3JwfG3sEe9+jLU140EJ/F3C6z5i4JfddZikt7p
         bCHCoPSISq/ePfh8UIoEjfabIAP9g5i1bPIB41eWaVqAIMHS8U2gA8rJn7GxyoAYlNS5
         kcog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=EV0wmNwRVxX8NQcoop+BEUS5js89FYD4nmxPHK49pWQ=;
        b=yMR1fynUYq9YPX9QI19wAzpPpvHPHy0PCy+t853xja9xSrf0NpSrIoDs/Zaz47ToUk
         IkaivxMT91tr2pXJUamu4gIyyPLh/0ki+mnyzt8PQHI+5KIeC3nEpzDmZsGVPg42EZ83
         8MFYdM8HzDuULe3/UIiKJhiqRsF945We5QcXVvV6gVWQ/0sAdyPDl6ii8lacIBXHCMhh
         7azUvAHAc6N8oiDNLxlnWPVhH7tCAdY76Q5OFkKU4tgefV4Wrad2XYP6t8Wfe4Q14MWJ
         hM3QpDOya9srRylqGb/4Zb+LcgI2F3U3OKdkR9Bx+vnNx+0ndggOE+FsJpLKDiFMM7Ie
         FdKg==
X-Gm-Message-State: AOAM531ZRxEKsKrYs+E2jBtyEfirVitXSu3OjrbxynEg0rVlw/g7//UU
        DiPghfryqsI2v64fDQe+MJJGmE1BsFs=
X-Google-Smtp-Source: ABdhPJzlNsy3e1ptcNA1gVdmyGzeVVvFjO+vtZKTXz+mMFFivnXYL8Q+yd6xL5Xp3kOTB5m7PdGErg==
X-Received: by 2002:a63:82c2:0:b0:37c:942b:96db with SMTP id w185-20020a6382c2000000b0037c942b96dbmr7422065pgd.286.1646987417357;
        Fri, 11 Mar 2022 00:30:17 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.111])
        by smtp.googlemail.com with ESMTPSA id l1-20020a17090aec0100b001bfa1bafeadsm9090576pjy.53.2022.03.11.00.30.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 11 Mar 2022 00:30:17 -0800 (PST)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH 5/5] KVM: X86: Expose PREEMT_COUNT CPUID feature bit to guest
Date:   Fri, 11 Mar 2022 00:29:14 -0800
Message-Id: <1646987354-28644-6-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1646987354-28644-1-git-send-email-wanpengli@tencent.com>
References: <1646987354-28644-1-git-send-email-wanpengli@tencent.com>
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

