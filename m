Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6A404165C9
	for <lists+kvm@lfdr.de>; Thu, 23 Sep 2021 21:16:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242841AbhIWTRu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Sep 2021 15:17:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242840AbhIWTRt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Sep 2021 15:17:49 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B4D6C061574
        for <kvm@vger.kernel.org>; Thu, 23 Sep 2021 12:16:18 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id q17-20020a0cf5d1000000b00380e60ef363so22581798qvm.9
        for <kvm@vger.kernel.org>; Thu, 23 Sep 2021 12:16:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=UCMYJurTFuTkCi0HgTfCB5voS1kc3wFR2T934tFa/Zw=;
        b=G3IeFE8bm7uUZsbXeSdob1ZhW9vy4lEwxbjMoMnJ/ggdGOjHFYeJBlrZ/BOqXzzZEM
         qX0u7YyYBe+/t26r2VKhI4LV5MqNOSqU3Tr8XzBJxQzRn7WfNy0EW3bxwaPxKS7LSqsm
         xZ7UIeodcMbXCGBuooPK+dt2KM+fgHg9519qV8DOah6lvf0UQp9tTXrIVsJbv68LeyTw
         ABS2jjrhuCXB8Yv2T9ZsW6OzsThl6b1xmGWcFdJUxOFpGqD00dLdZjdUU74XoXTOW8CG
         oBC+NucSCfdJpw6rfS+bS9SqwXichjKwCGbo5PnWQbUOZPSMFJfkO8xDyDmhLMnRHztd
         Fr+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=UCMYJurTFuTkCi0HgTfCB5voS1kc3wFR2T934tFa/Zw=;
        b=V9vn/se/L10ZPRawQQ/55KXgguicZJ/IhFoB5jbdt2bwl3kUGFD/Js5BPm8NDblSfv
         XiKFPsnJkW6VNdN9IWTPvFLD6+qMN1ECmVS58xztXQCsU95+vY6UeBZAPxp4cVb8R9Oj
         sWxlHoXhft2jhRJWU2YTatoSd7wL70DFylJvRDxxrNdFA/2eygTm5U/U7c0QDVrAjoIX
         WKiQwXQN7cJ7WUDWzbgnqpixihPjX9dRd0v5zILFdCOP6pR7gubsxEA05vKpZ7+oWITC
         qMGkyYLapAgqLRziBwsGNMR9opyY4hS3KTXq4ywGo6+evjK6UPAZp+eYT+tBLZe7KB+H
         mAnA==
X-Gm-Message-State: AOAM5327RGLyQ61jjyZtQaS4IooH/4uQixMteDm/FSHNNXMHsEO25cB5
        IJs/ICqx/X2V13pSMnZ6IJxVxh9tRiQ=
X-Google-Smtp-Source: ABdhPJxVi0BHEjOTgazTwOWIFtWnIaijjz0Tm9HsTJFcwKzjrq0cP/UG+fQwEF7wSEN7ptIoNhJ0GWQQG30=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6214:13e3:: with SMTP id
 ch3mr6061613qvb.35.1632424577208; Thu, 23 Sep 2021 12:16:17 -0700 (PDT)
Date:   Thu, 23 Sep 2021 19:16:00 +0000
In-Reply-To: <20210923191610.3814698-1-oupton@google.com>
Message-Id: <20210923191610.3814698-2-oupton@google.com>
Mime-Version: 1.0
References: <20210923191610.3814698-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [PATCH v2 01/11] KVM: arm64: Drop unused vcpu param to kvm_psci_valid_affinity()
From:   Oliver Upton <oupton@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        kvm@vger.kernel.org, Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The helper function does not need a pointer to the vCPU, as it only
consults a constant mask; drop the unused vcpu parameter.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/kvm/psci.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index 74c47d420253..d46842f45b0a 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -59,8 +59,7 @@ static void kvm_psci_vcpu_off(struct kvm_vcpu *vcpu)
 	kvm_vcpu_kick(vcpu);
 }
 
-static inline bool kvm_psci_valid_affinity(struct kvm_vcpu *vcpu,
-					   unsigned long affinity)
+static inline bool kvm_psci_valid_affinity(unsigned long affinity)
 {
 	return !(affinity & ~MPIDR_HWID_BITMASK);
 }
@@ -73,7 +72,7 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
 	unsigned long cpu_id;
 
 	cpu_id = smccc_get_arg1(source_vcpu);
-	if (!kvm_psci_valid_affinity(source_vcpu, cpu_id))
+	if (!kvm_psci_valid_affinity(cpu_id))
 		return PSCI_RET_INVALID_PARAMS;
 
 	vcpu = kvm_mpidr_to_vcpu(kvm, cpu_id);
@@ -132,7 +131,7 @@ static unsigned long kvm_psci_vcpu_affinity_info(struct kvm_vcpu *vcpu)
 	target_affinity = smccc_get_arg1(vcpu);
 	lowest_affinity_level = smccc_get_arg2(vcpu);
 
-	if (!kvm_psci_valid_affinity(vcpu, target_affinity))
+	if (!kvm_psci_valid_affinity(target_affinity))
 		return PSCI_RET_INVALID_PARAMS;
 
 	/* Determine target affinity mask */
-- 
2.33.0.685.g46640cef36-goog

