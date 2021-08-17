Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D82553EE81B
	for <lists+kvm@lfdr.de>; Tue, 17 Aug 2021 10:12:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239083AbhHQIMd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Aug 2021 04:12:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239041AbhHQIMZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Aug 2021 04:12:25 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8BB2C0617AE
        for <kvm@vger.kernel.org>; Tue, 17 Aug 2021 01:11:51 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id o19-20020a05622a0093b029029624b5db4fso10667483qtw.23
        for <kvm@vger.kernel.org>; Tue, 17 Aug 2021 01:11:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=aHCf3CwNNBrmIRx2wJpLYl7QdQEwhZAoOTdqtlemKNA=;
        b=nmj5YInKovfYpQ7u2gu+Y7J66loXt+NDQNemJ7HGUcKXj0fC7wwCSMymCEi4G21L3p
         IArJSFzNsytGyM9Aj+pPYXesA9Vm/c7zfGQmeaSoLhwVGjTFnvS9R+lIcvVEM8C1k/YR
         vWzurZ7ebNzykXtZc9niVn9GYk9PSDHnApssgQ253v3a0E1TACnW+kba/jsCf/OUQST1
         lRY+I29CFT8E6+v1g/A8yjDZEgGVBkXRxQmXua664ZpNGjHjWAh/aYXWpdE3sTpV5KSC
         4F2hbJOwiqlbmgpuhHpxBsZ8LyTztDaiQNI7jgWINBi0Cz59uNMk+MX/4294lx7erU0g
         aByA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=aHCf3CwNNBrmIRx2wJpLYl7QdQEwhZAoOTdqtlemKNA=;
        b=dZS3GxMKcMxG7gnMzSo5UWZALW3+1/RsB2bb4fr04z9nxIBnZiePjRMkOSZqx5FEIi
         56N1RetuBmTZ/t6WGqsFJW/4+2htDnQv8gnh8QYpEUBHBAvw4g8IdYqWPiKfXPT322tV
         +HdQLcTXcGqNpzGx/pyVvOb8mz5pA1iyAiha2U46CBHQUmuO/CRh6tPTWR2GUIaEgrOP
         T715l8wA9zK1Skx+EyyVUlBZ58fjbqDqTULyngtYUog8rtjkFSSNVn71J+G0CChcAAB2
         RaXcDK64SkPmkOGJdbK3EC/DOeEvkT1jEnnh+EXBcyTjaybXQ13qCQFb37e4vMNSCIK6
         HY2Q==
X-Gm-Message-State: AOAM532qGoKP+Z6+pNCR1EwkT2zU+MeOXxQPCA7MO6/G4RJXZ2GGdGY3
        EnqtRXfOV0c46GfzpZhw1QU356ecDw==
X-Google-Smtp-Source: ABdhPJwo9+n3O7kUXlMfd9UmZiDXQnjQGGvtzSb/qI8QL6++MTL6aNWs0u51HkTG4jUJ6+mkEPCkxCl2mw==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a05:6214:1933:: with SMTP id
 es19mr2165343qvb.42.1629187910879; Tue, 17 Aug 2021 01:11:50 -0700 (PDT)
Date:   Tue, 17 Aug 2021 09:11:26 +0100
In-Reply-To: <20210817081134.2918285-1-tabba@google.com>
Message-Id: <20210817081134.2918285-8-tabba@google.com>
Mime-Version: 1.0
References: <20210817081134.2918285-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH v4 07/15] KVM: arm64: Keep mdcr_el2's value as set by __init_el2_debug
From:   Fuad Tabba <tabba@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     maz@kernel.org, will@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        mark.rutland@arm.com, christoffer.dall@arm.com,
        pbonzini@redhat.com, drjones@redhat.com, oupton@google.com,
        qperret@google.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
        tabba@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

__init_el2_debug configures mdcr_el2 at initialization based on,
among other things, available hardware support. Trap deactivation
doesn't check that, so keep the initial value.

No functional change intended. However, the value of mdcr_el2
might be different after deactivating traps than it was before
this patch.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/switch.c | 4 ----
 arch/arm64/kvm/hyp/vhe/switch.c  | 4 ----
 2 files changed, 8 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 2ea764a48958..1778593a08a9 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -90,10 +90,6 @@ static void __deactivate_traps(struct kvm_vcpu *vcpu)
 		isb();
 	}
 
-	vcpu->arch.mdcr_el2_host &= MDCR_EL2_HPMN_MASK |
-				    MDCR_EL2_E2PB_MASK << MDCR_EL2_E2PB_SHIFT |
-				    MDCR_EL2_E2TB_MASK << MDCR_EL2_E2TB_SHIFT;
-
 	__deactivate_traps_common(vcpu);
 
 	write_sysreg(this_cpu_ptr(&kvm_init_params)->hcr_el2, hcr_el2);
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index ec158fa41ae6..0d0c9550fb08 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -93,10 +93,6 @@ void activate_traps_vhe_load(struct kvm_vcpu *vcpu)
 
 void deactivate_traps_vhe_put(struct kvm_vcpu *vcpu)
 {
-	vcpu->arch.mdcr_el2_host &= MDCR_EL2_HPMN_MASK |
-				    MDCR_EL2_E2PB_MASK << MDCR_EL2_E2PB_SHIFT |
-				    MDCR_EL2_TPMS;
-
 	__deactivate_traps_common(vcpu);
 }
 
-- 
2.33.0.rc1.237.g0d66db33f3-goog

