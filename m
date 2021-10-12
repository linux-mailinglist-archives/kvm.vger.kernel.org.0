Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EDAB429C7C
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 06:36:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232361AbhJLEiO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 00:38:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbhJLEiN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Oct 2021 00:38:13 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 596FDC061570
        for <kvm@vger.kernel.org>; Mon, 11 Oct 2021 21:36:12 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id t3-20020a056214154300b00383496932feso8878593qvw.6
        for <kvm@vger.kernel.org>; Mon, 11 Oct 2021 21:36:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=MgUI8dr71wiUF9Cg1eutjpaNE80Sfg4+1lD1k7gsd/M=;
        b=VuhEW5SxS1LqbD1y6W2u5fujsSWvlKITcaC+DfzF+nbgthQHFlCdofRA8Pi8vjahVC
         zj5zQtHgIuUulE5UV8fh2IwmG0qfPMjxzv4Je1fkjXzNToQ1TIi+isd08BO+cHpf5mov
         GmjnInH4aCSFrGLvvSDPH1qi1c0JUrr9tj+w/BIlW7hXWPzqtAYmhtej7Tn4nhbt1g2L
         /0kQzyKo+7Q8e5Igsao58iALORgjb0FH2nN+mof+i0fYRMQZ6jHwDhydsKPpT3TPWrqi
         beLVi1ReaNB51oUSUxAxWkT0IUBzCucR/GAogYdticZGdaMWLM519PKt+Oh3nLkuZcym
         8cWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=MgUI8dr71wiUF9Cg1eutjpaNE80Sfg4+1lD1k7gsd/M=;
        b=lVE1++KYIdmRRsZZFHiKi0Xwp21Q+tMiSI7Itg8Wt4CXwUiT2YWZPUdGTsiuo9CllU
         gXdP7HqzvkQdyfwgcaLcNXq243C2hNFeltBskvFgJFT1D3dk0UZnvZk/Hs7yhk/fEfGW
         ZNMdWbZcmhGxoRFWHU5VN5JTUEn2FSV4iAObAq49K8Sg/wvPXQo0fkSMqSRcktM+Xp5e
         1vdg3igMWOkPpByFEVW7BaJ3MlwfzePNUwlSFIcr7K5yP0JdYI3C8cSClrY2d6CqjPkg
         yvLmeIpmqUUw3eMJ4YCfDxlXLyZK8H++/kYTPQFJ2tYNKtczPPVPL4f2uOO1928ZqV10
         fwBA==
X-Gm-Message-State: AOAM531YE4JZw6M5fKqIN7d8eDNamdyv+g/KMtXrvselCAKQy2Tl5c1j
        oc28qDUhukVeY493DLpP0wKqxD1iLI0=
X-Google-Smtp-Source: ABdhPJy2iKOySRcH3Ml4eFC4AOnvEXGxnJDRyYb6ehxJKmextSbm1vjwq+zjkblu6svI8PlWaI/8labARB4=
X-Received: from reiji-vws.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:15a3])
 (user=reijiw job=sendgmr) by 2002:ac8:202:: with SMTP id k2mr20117332qtg.398.1634013370868;
 Mon, 11 Oct 2021 21:36:10 -0700 (PDT)
Date:   Mon, 11 Oct 2021 21:35:11 -0700
In-Reply-To: <20211012043535.500493-1-reijiw@google.com>
Message-Id: <20211012043535.500493-2-reijiw@google.com>
Mime-Version: 1.0
References: <20211012043535.500493-1-reijiw@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [RFC PATCH 01/25] KVM: arm64: Add has_reset_once flag for vcpu
From:   Reiji Watanabe <reijiw@google.com>
To:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Peng Liang <liangpeng10@huawei.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce 'has_reset_once' flag in kvm_vcpu_arch, which indicates
if the vCPU reset has been done once, for later use.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 2 ++
 arch/arm64/kvm/reset.c            | 4 ++++
 2 files changed, 6 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index f8be56d5342b..9b5e7a3b6011 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -384,6 +384,7 @@ struct kvm_vcpu_arch {
 		u64 last_steal;
 		gpa_t base;
 	} steal;
+	bool has_reset_once;
 };
 
 /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
@@ -449,6 +450,7 @@ struct kvm_vcpu_arch {
 
 #define vcpu_has_sve(vcpu) (system_supports_sve() &&			\
 			    ((vcpu)->arch.flags & KVM_ARM64_GUEST_HAS_SVE))
+#define	vcpu_has_reset_once(vcpu) ((vcpu)->arch.has_reset_once)
 
 #ifdef CONFIG_ARM64_PTR_AUTH
 #define vcpu_has_ptrauth(vcpu)						\
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 5ce36b0a3343..4d34e5c1586c 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -305,6 +305,10 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 	if (loaded)
 		kvm_arch_vcpu_load(vcpu, smp_processor_id());
 	preempt_enable();
+
+	if (!ret && !vcpu->arch.has_reset_once)
+		vcpu->arch.has_reset_once = true;
+
 	return ret;
 }
 
-- 
2.33.0.882.g93a45727a2-goog

