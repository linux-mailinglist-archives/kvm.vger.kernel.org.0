Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BE7F4FAA63
	for <lists+kvm@lfdr.de>; Sat,  9 Apr 2022 20:46:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241259AbiDISsT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 9 Apr 2022 14:48:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243102AbiDISsN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 9 Apr 2022 14:48:13 -0400
Received: from mail-il1-x149.google.com (mail-il1-x149.google.com [IPv6:2607:f8b0:4864:20::149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24FC324959
        for <kvm@vger.kernel.org>; Sat,  9 Apr 2022 11:46:06 -0700 (PDT)
Received: by mail-il1-x149.google.com with SMTP id f18-20020a926a12000000b002be48b02bc6so7619910ilc.17
        for <kvm@vger.kernel.org>; Sat, 09 Apr 2022 11:46:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=a8ErjQkjJemApV/ArG2O1WzEXVxzEs6Cu64ADo489u4=;
        b=E6d759Z/bhHpp0/D3B+xqpOJBJs80FX++1SU7DHjYJBQhEqraMuQCF77w6lNUEuwWy
         seCONxq9h7jvFEvrK9pxx22jg6r5yAOe72z7duoT281XosOrsPIMih16pHltXbCefqvl
         SH6whpr+OTyW3MFdG+aGMeEHQ5Jo2Urp8LXo0/oghajD68dA/i/0zwT6DmbXDSLG3dgN
         q0Vz+vgqkFqgCacsPLUac59tFgLRZsb1MFYxoEc+2f2uFQWkFfajnFXJuvhqX5geHKlB
         4+JLxj9EABi7afYP65jYPoGXggMC59RFJxd9Z9cDeaGaUkQLkpZOXTut2sM5zqSaWCBP
         4cFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=a8ErjQkjJemApV/ArG2O1WzEXVxzEs6Cu64ADo489u4=;
        b=z/oPk/+FpS4KLsLYuwyP0A274t6M9YqcjoUmx9ozbIjHIhNjWFFRk1aQAjOr4CyqJm
         WhBqEz0mlQcvoZ59q2B89SsfKCp/UgbwdEQ+SVQTzT5HFicLzMG5lhcm2whzosbOBHki
         nHbKj1JRPinZlzrioLTkj51bGrYhspMp43QTMVV0ScDVj1ChJ/pmC8brJhkJ0z7N2ON2
         +633Bjh8p7S1Ul8r563g61J989Qq6uPGiQRN21SxB/W9YovulWdxuz+61ltSf8aXZNxQ
         1IV0CRxTF/BDFoodPJ7UgFObLM/adYtBDlxPK5C2i0KFVNcRH3YyCxjZfZU3meA72s/9
         coPQ==
X-Gm-Message-State: AOAM53243k6XiHG4EKwAMVwTMq6j7kHDEd8Q2ZShY9oQr6RM93wZ7OHm
        dLEDQhYItO564IE1f8lYRKXJksLYzEs=
X-Google-Smtp-Source: ABdhPJwM3NLh6dMiAtJ4udXU+7vQgFrC8s3Y1rHX2gzBrlErDj556HI9qaJ2Ilsl83NS+oCvkkk5pJNKs9Q=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6e02:18ce:b0:2ca:1f4c:f2b2 with SMTP id
 s14-20020a056e0218ce00b002ca1f4cf2b2mr11583960ilu.87.1649529965605; Sat, 09
 Apr 2022 11:46:05 -0700 (PDT)
Date:   Sat,  9 Apr 2022 18:45:42 +0000
In-Reply-To: <20220409184549.1681189-1-oupton@google.com>
Message-Id: <20220409184549.1681189-7-oupton@google.com>
Mime-Version: 1.0
References: <20220409184549.1681189-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
Subject: [PATCH v5 06/13] KVM: arm64: Return a value from check_vcpu_requests()
From:   Oliver Upton <oupton@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     alexandru.elisei@arm.com, anup@brainfault.org,
        atishp@atishpatra.org, james.morse@arm.com, jingzhangos@google.com,
        jmattson@google.com, joro@8bytes.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, maz@kernel.org,
        pbonzini@redhat.com, pshier@google.com, rananta@google.com,
        reijiw@google.com, ricarkol@google.com, seanjc@google.com,
        suzuki.poulose@arm.com, vkuznets@redhat.com, wanpengli@tencent.com,
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
index 77b8b870c0fc..efe54aba5cce 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -648,7 +648,16 @@ void kvm_vcpu_wfi(struct kvm_vcpu *vcpu)
 	preempt_enable();
 }
 
-static void check_vcpu_requests(struct kvm_vcpu *vcpu)
+/**
+ * check_vcpu_requests - check and handle pending vCPU requests
+ * @vcpu:	the VCPU pointer
+ *
+ * Return: 1 if we should enter the guest
+ *	   0 if we should exit to userspace
+ *	   < 0 if we should exit to userspace, where the return value indicates
+ *	   an error
+ */
+static int check_vcpu_requests(struct kvm_vcpu *vcpu)
 {
 	if (kvm_request_pending(vcpu)) {
 		if (kvm_check_request(KVM_REQ_SLEEP, vcpu))
@@ -678,6 +687,8 @@ static void check_vcpu_requests(struct kvm_vcpu *vcpu)
 			kvm_pmu_handle_pmcr(vcpu,
 					    __vcpu_sys_reg(vcpu, PMCR_EL0));
 	}
+
+	return 1;
 }
 
 static bool vcpu_mode_is_bad_32bit(struct kvm_vcpu *vcpu)
@@ -793,7 +804,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		if (!ret)
 			ret = 1;
 
-		check_vcpu_requests(vcpu);
+		if (ret > 0)
+			ret = check_vcpu_requests(vcpu);
 
 		/*
 		 * Preparing the interrupts to be injected also
-- 
2.35.1.1178.g4f1659d476-goog

