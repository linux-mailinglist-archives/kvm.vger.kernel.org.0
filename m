Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EBEA4C0AF7
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 05:19:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234742AbiBWEUV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Feb 2022 23:20:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238105AbiBWEUR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Feb 2022 23:20:17 -0500
Received: from mail-io1-xd4a.google.com (mail-io1-xd4a.google.com [IPv6:2607:f8b0:4864:20::d4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C5034091E
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 20:19:47 -0800 (PST)
Received: by mail-io1-xd4a.google.com with SMTP id x16-20020a6bfe10000000b006409f03e39eso8581298ioh.7
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 20:19:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=wVJSZRZwihrGXsYBdQrl6MVYBmihMEt9qMrxhWCnPXM=;
        b=N/JCXhOQbZYBtBap29e0M9kthtoVctwJ3DWY9n2yCxNcrsh71ds4U8uyVEgHm/j/5P
         uDWmdYQuTo/8LK9xaR6tqWPtyDm41EL6yVK6uQmhvwMkI3ghkwLuB2HFxzaoSBVB7Xgi
         PjH3fMWodmUAnyGuivMpQOHxD01Yio7g9K8mJQhvCMQ20+qWOMh3PA9qIAFbYoishMP/
         n7OX0dn6R3LWXThUMB4RHLzSxlCyOI13gABtaFlGWVkI6sCzUPcMvRNynX1VVQYqLKb4
         5lEfU/gopvUmZZU94Vcc2qTVZ2ylbc8vk2STfUyrLEYL+H/HZ0DiKswbxaA/yXe9HpPz
         pXRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=wVJSZRZwihrGXsYBdQrl6MVYBmihMEt9qMrxhWCnPXM=;
        b=njtUY2XwlzfYMx+Nc954jXrimWuBJNv+t2nGTWL2uQpJJyV9ZKxDLnsW8EBGBckVbc
         +DNdgN5Aoyyq5CItLPIMr0tkiJpLeBMRzkrT1QjUQKVkDsQklML+efIdNII2ZlriDEGi
         OPPD2+XhrWyQu47c3hVo97mg9T7L3w4vLd/pO2eClibunEDODP5vVwUHXYTvS9q4sAVz
         E8zHDVBUsxV46bhrd6akcV0WPAmqKbqpwRdVKYitVaQB0YeYloKJ2YUuvmySMoegM7yK
         JbE9HIok+9IokDvTj/ReSWrQkgGg15J6vRqn0tiwTDTSL+DkzofLxSJgF3vaqzb7bjGf
         J1CA==
X-Gm-Message-State: AOAM5332h3y4reloPuydFBPkX5lKUOUSpkHv5FIwQVUxblZXjVENbJt4
        EAJ9vRAPpzFgjsTC1XGMm0hfWSGDChs=
X-Google-Smtp-Source: ABdhPJwoH+KbUWMS62f0vLQp0EEfYidZ9n2pGeH/otXeHZB0fgbVAZB0q/pMxaHf3iUu51F+xuNUW44FvvY=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a6b:661a:0:b0:640:dd42:58ff with SMTP id
 a26-20020a6b661a000000b00640dd4258ffmr11611644ioc.64.1645589987008; Tue, 22
 Feb 2022 20:19:47 -0800 (PST)
Date:   Wed, 23 Feb 2022 04:18:36 +0000
In-Reply-To: <20220223041844.3984439-1-oupton@google.com>
Message-Id: <20220223041844.3984439-12-oupton@google.com>
Mime-Version: 1.0
References: <20220223041844.3984439-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [PATCH v3 11/19] KVM: arm64: Return a value from check_vcpu_requests()
From:   Oliver Upton <oupton@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Peter Shier <pshier@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A subsequent change to KVM will introduce a vCPU request that could
result in an exit to userspace. Change check_vcpu_requests() to return a
value and document the function. Unconditionally return 1 for now.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/kvm/arm.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 6af680675810..f6ce97c0069c 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -719,7 +719,16 @@ void kvm_vcpu_wfi(struct kvm_vcpu *vcpu)
 	preempt_enable();
 }
 
-static void check_vcpu_requests(struct kvm_vcpu *vcpu)
+/**
+ * check_vcpu_requests - check and handle pending vCPU requests
+ * @vcpu:	the VCPU pointer
+ *
+ * Return: 1 if we should enter the guest
+ *	   0 if we should exit to userspace
+ *	   <= 0 if we should exit to userspace, where the return value indicates
+ *	   an error
+ */
+static int check_vcpu_requests(struct kvm_vcpu *vcpu)
 {
 	if (kvm_request_pending(vcpu)) {
 		if (kvm_check_request(KVM_REQ_SLEEP, vcpu))
@@ -749,6 +758,8 @@ static void check_vcpu_requests(struct kvm_vcpu *vcpu)
 			kvm_pmu_handle_pmcr(vcpu,
 					    __vcpu_sys_reg(vcpu, PMCR_EL0));
 	}
+
+	return 1;
 }
 
 static bool vcpu_mode_is_bad_32bit(struct kvm_vcpu *vcpu)
@@ -859,7 +870,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 
 		update_vmid(&vcpu->arch.hw_mmu->vmid);
 
-		check_vcpu_requests(vcpu);
+		if (ret > 0)
+			ret = check_vcpu_requests(vcpu);
 
 		/*
 		 * Preparing the interrupts to be injected also
-- 
2.35.1.473.g83b2b277ed-goog

