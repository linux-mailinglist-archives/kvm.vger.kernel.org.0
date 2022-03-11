Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D434B4D5D5B
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 09:31:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237025AbiCKIbW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Mar 2022 03:31:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236470AbiCKIbT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Mar 2022 03:31:19 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69FEA1B988B;
        Fri, 11 Mar 2022 00:30:15 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id z16so7309133pfh.3;
        Fri, 11 Mar 2022 00:30:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=4jbCwzr0mct8OKs/Lgqse4ZkWggPrV/4VXWHupxqHk0=;
        b=VqrLn451/V+9LmXpVS924CzvE55eM93ytE7ZgyeTObSH2OrmQXwl9qDfSaFJ/vazxR
         AODWzxxPe5qwA4AO7E6sUHWvtmCTUlQVPgu8wmZ8H05v3RPixnsKTEMtE5t9z7ehRSuI
         18prbPVHZ8xhGX4LdwK5xRsK1GJU/gRpl29QQ+bdAUriUyuR3vHW+3vg9eSzeXOnj6vH
         pQ9xSN7CksgJkbOEcJmwR1cqFBpkZGodZJOMigZjJOpRiVwUWppFuoINEzsXIO+bPyTJ
         Q+6HbzGdD5gmEaiVq2zUrAvb3g9/lM/Kv9BYcRggrDqB6vb7DRLRhhzlUG7T6czvaUia
         qs0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=4jbCwzr0mct8OKs/Lgqse4ZkWggPrV/4VXWHupxqHk0=;
        b=M7ZIwkjLDhbNqt6yAeTKCs+kbBKNDf4eaFc53dZZ8c+EIKfgxAItFyYE+WeIzCcrDT
         QNy2C3XLUuM355lApIt88p36MgN4VgMkmWbKXNdvmBL0QBnyUwpLuyPutt/TtHQVmQls
         b4unoTuatD6onDqWQzjAe0Y8CzYM1z+uIwgdNiecX0isqUklmOFRTDSMqAPf9+zQpjjD
         12YB1aTyNHiVtAST2H4uAlmTvnO8wmETTr88NEny/LHZA78cgtxmwPkD2R5IzbzXerUe
         683YRLeHVskS4K6dkwi4gZn1amlwzZ99i275nixzc4D2lKhWZUawU/W3N1Wm7rIhbw7T
         Zwag==
X-Gm-Message-State: AOAM530OHxHQbrp4IawIYVKmoYjyYrtk8u8uEyIMnMQKi2BOOc9vLtir
        YPvUhZED+bsdtA2nywBkJwNKBVxX1kM=
X-Google-Smtp-Source: ABdhPJxkwC/ucfh7BHQHX2m5BBwxJbpRbTv0HYpts41pL4Iwh309L3G4S9C8putZrR2mYydEc+WHOQ==
X-Received: by 2002:a05:6a00:885:b0:4f4:17d8:be31 with SMTP id q5-20020a056a00088500b004f417d8be31mr9128043pfj.57.1646987414815;
        Fri, 11 Mar 2022 00:30:14 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.111])
        by smtp.googlemail.com with ESMTPSA id l1-20020a17090aec0100b001bfa1bafeadsm9090576pjy.53.2022.03.11.00.30.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 11 Mar 2022 00:30:14 -0800 (PST)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH 4/5] x86/kvm: Add MSR_KVM_PREEMPT_COUNT guest support
Date:   Fri, 11 Mar 2022 00:29:13 -0800
Message-Id: <1646987354-28644-5-git-send-email-wanpengli@tencent.com>
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

The x86 guest passes the per-cpu preempt_count value to the hypervisor,
so the hypervisor knows whether the guest is running in the critical 
section.

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kernel/kvm.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 21933095a10e..e389fa4393ae 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -366,6 +366,14 @@ static void kvm_guest_cpu_init(void)
 
 	if (has_steal_clock)
 		kvm_register_steal_time();
+
+	if (kvm_para_has_feature(KVM_FEATURE_PREEMPT_COUNT)) {
+		u64 pa = slow_virt_to_phys(this_cpu_ptr(&__preempt_count))
+			| KVM_MSR_ENABLED;
+		wrmsrl(MSR_KVM_PREEMPT_COUNT, pa);
+
+		pr_debug("setup pv preempt_count: cpu %d\n", smp_processor_id());
+	}
 }
 
 static void kvm_pv_disable_apf(void)
@@ -442,6 +450,8 @@ static void kvm_guest_cpu_offline(bool shutdown)
 	if (!shutdown)
 		apf_task_wake_all();
 	kvmclock_disable();
+	if (kvm_para_has_feature(KVM_FEATURE_PREEMPT_COUNT))
+		wrmsrl(MSR_KVM_PREEMPT_COUNT, 0);
 }
 
 static int kvm_cpu_online(unsigned int cpu)
-- 
2.25.1

