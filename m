Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 920524E749D
	for <lists+kvm@lfdr.de>; Fri, 25 Mar 2022 14:59:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359028AbiCYOBS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Mar 2022 10:01:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358938AbiCYOBN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Mar 2022 10:01:13 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06A9360A92;
        Fri, 25 Mar 2022 06:59:35 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id m18so3214506plx.3;
        Fri, 25 Mar 2022 06:59:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=4jbCwzr0mct8OKs/Lgqse4ZkWggPrV/4VXWHupxqHk0=;
        b=nT728+6kR20X1SoIl0V5jnB6v7lr0+IpMj+2Vafc9rc9beExEQmjLTm2p2TOZLz2rN
         VfynJ8uduC92IgQRDDXKz/VEJvV4l2XdlT1yKY7wOAjqJQcsXG7iuyruqR/wOpQGAsWo
         pjPvTowRroLFlAwJab3PdPh3/3TplhmVsRinWI3HXC2hBRNC0SVDAc47xfj17McKbNPW
         bXB3QzVuCLiyXA92OtOv2/lh7VxfeEDuVGshLX8LhatAr+lEyXIByScvhSnMFYduKAr1
         LvsMoIO5xvdO8X0BTnDrDXMrmaS76+bW51+kwbvFDCCQkvEDbKng68ovq4G5ueo8VW4c
         wZLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=4jbCwzr0mct8OKs/Lgqse4ZkWggPrV/4VXWHupxqHk0=;
        b=jj1j6yKEs+dk5k8FXd9ddVXbz9DfaWWqGV+5ggJOXig+2KIRnohCxRHgxn5Y4pdqc6
         dJZYjKo28dqJZkTpImpyGl0m8u0mSAy/S14CNSocvFj2O+iOPdVbth/MUKJFQke2G4IT
         WpogTS0HeJbwIpNXRPFUjKY0DIQDPtr5xnFmQSLiv1OSWeiRsMWjlgeKSYzx84Qq/gbQ
         +s0FxDBa/4cpqZQqll0TOx9XM7iLq27U0zIcM9a3aaCg76+PjF9fr1YbbuR3HnKib/nZ
         k3jOEkaaBa10ZvZF5sEkiXQ+EZAp+0z+nJy/oyKnsy65H8GQsIte74/fpUyZqBZvNEC7
         R9/w==
X-Gm-Message-State: AOAM533hMVg9f024QL3ppAJWcydy4pleHivKxZvMFxs6z1HLXxxM6jqK
        P4N3wJrqpMgdKW8eLS0IpR2rwA7Uml8=
X-Google-Smtp-Source: ABdhPJxjmkgO4hGCqv5qcydxjfqbeQere/uio1LGQxcMv22iZukZrTDZQvjrF16csQcLHjItIV2f8w==
X-Received: by 2002:a17:90b:1d08:b0:1c7:5523:6a1f with SMTP id on8-20020a17090b1d0800b001c755236a1fmr25263357pjb.225.1648216775134;
        Fri, 25 Mar 2022 06:59:35 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.113])
        by smtp.googlemail.com with ESMTPSA id lw4-20020a17090b180400b001c7327d09c3sm14470875pjb.53.2022.03.25.06.59.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 25 Mar 2022 06:59:34 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH RESEND 4/5] x86/kvm: Add MSR_KVM_PREEMPT_COUNT guest support
Date:   Fri, 25 Mar 2022 06:58:28 -0700
Message-Id: <1648216709-44755-5-git-send-email-wanpengli@tencent.com>
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

