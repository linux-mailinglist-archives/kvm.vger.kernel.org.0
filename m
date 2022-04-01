Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87D034EE994
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 10:12:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344250AbiDAINb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 04:13:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344293AbiDAINC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 04:13:02 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD4A920A97A;
        Fri,  1 Apr 2022 01:11:13 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id y16so1751634pju.4;
        Fri, 01 Apr 2022 01:11:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=TZ6Va3/+y3V6v2Y3p92U6OT9/1I7oLnm/gWi+nTj8w4=;
        b=Db0dHl5Nb4Z7FC3ZIPNhial2UQcrkej6YsUpFfjjObjtyj+y2CUtgItUo6IGGRRRpN
         hX5M6qqZfzzk395bR0i7Xagk4c4yDWx9ZQDGDOizXKd2ykooJxz9L9ZEB4Kr0N2FRCRW
         XsQzJuohuSgmrzynOyUKMX+RvBp8TzJn5Lo2SX3OjyBF+zwzqqlgg2SpgKUN/OJ28d9Z
         KbNBKMSbetRcrB9Uh3/3QhvPFvXc8N4alGGDgcBPi1syEcnypaCWX1TzQxNWHJSe25B8
         gO0bkC47sN/0qjyDO43MIEdcGVvKIlD+rH0TOewjr8Vy5qD3t2zk/9UmfqatBx/FYlZu
         JJRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=TZ6Va3/+y3V6v2Y3p92U6OT9/1I7oLnm/gWi+nTj8w4=;
        b=Bm/XDuy3BaEiLG3VnvRgHyATyV0hxhUTIJafe2p4xGErAVmWBLmY8I8ZLCnRzUzVkT
         fRXk27oCWRxXwhKLp9yOKCQY/IlZ0xEbmYJOuGz/DJf9HLbaPOQmZzN6L5C1LglFLOga
         4k0ptM8+L3cpbbmAu//17a231fNIAscNnt6wRZDt7FPxVarqiTH1H1vDyFRf/N609UZs
         TAnFIE90a+HfwLATIF8GtIjWiukB2GiV5LYnQLwGw/+yOCPK4gccdZoNYJD51zh/D/OM
         LuMDy6xD1XHbS1BwEYqYJYMraGx9TCG/ZXRYoLbhDK+PzF/dckf8NeUISCS0E5FXkZR/
         wfZQ==
X-Gm-Message-State: AOAM533BJwqOuXCsAz/kHKm//KKZs4cgTt4Xm2IIv2QQp3BbYMDUKRWm
        T2am/6xLMKKXB4OkIZWF96SuYXf2PXk=
X-Google-Smtp-Source: ABdhPJzh3y4A3uDHCtvJ4AZuJ9uWAuoYQqRzuwbs9cG6/RGOWF6sxK8NxMs/g/TCC1lgSGehcyA0Gw==
X-Received: by 2002:a17:902:e8d2:b0:156:32bf:b1b9 with SMTP id v18-20020a170902e8d200b0015632bfb1b9mr9162389plg.107.1648800673182;
        Fri, 01 Apr 2022 01:11:13 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.113])
        by smtp.googlemail.com with ESMTPSA id hg5-20020a17090b300500b001c795eedcffsm11634790pjb.13.2022.04.01.01.11.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 01 Apr 2022 01:11:12 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH v2 5/5] KVM: X86: Expose PREEMT_COUNT CPUID feature bit to guest
Date:   Fri,  1 Apr 2022 01:10:05 -0700
Message-Id: <1648800605-18074-6-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1648800605-18074-1-git-send-email-wanpengli@tencent.com>
References: <1648800605-18074-1-git-send-email-wanpengli@tencent.com>
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
index a00cd97b2623..c514c0419593 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1072,7 +1072,8 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
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

