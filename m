Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC280443D47
	for <lists+kvm@lfdr.de>; Wed,  3 Nov 2021 07:28:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231979AbhKCGbX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 02:31:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232050AbhKCGbP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Nov 2021 02:31:15 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82ED2C06120C
        for <kvm@vger.kernel.org>; Tue,  2 Nov 2021 23:28:39 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id 84-20020a621457000000b0048080f5764dso826108pfu.13
        for <kvm@vger.kernel.org>; Tue, 02 Nov 2021 23:28:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ugTp3pj0zYJHc3RiE+6osaY4VwnihaeWletwlGqcNzU=;
        b=R3uU4a/mva3/sHp7C4ovXEbTpY7IYU6h/nzYCMUJp+ghGJCGhatLHR1IKqI10LJdsq
         metLBMGZYNoR04MfVYDKXlUey3kGDSwo0EjdTYks9XJKbommPpi8BgxoxZsCJFWVn+FH
         suf/FuoQtsLvDHUgsMRQSKYW6N1T76XjKMIT5Nofnr4EqXt5x9/XND18vMR8omRCh86s
         lmj2LyQP8xjLWfKoCds4tFt8KtCS6W5Xvnfb9Ast3913Gm3/3W7g9o2hEZ70yRhH9PIb
         d85b0EGtsmqV1k28mIcfQVqisSh3ApCaLI0unMYmbjVQtkJP9vVP6MdUcTHer2id1sPz
         46RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ugTp3pj0zYJHc3RiE+6osaY4VwnihaeWletwlGqcNzU=;
        b=Tks3IMWu3O0fJmlkfAzW75tTl2znxoBgyVB/9aR6J2zi64AnV2o/Mk+TNwDxqyuWv4
         dpDD2vn33yNfUMrHUWGLOf+zkbIAKRiuslLD+GzFD/C3UG/gjHNeF7sr8FOylE3l4TT6
         i7M6vNd5IR2fRb3MKsVstwm9ArGy5L/psf8MvlDzTbxltZ0h0K4ci/AhKU6hvyM1V3Df
         vXQgK6AdMzJxofQOTOK+o2IQp12GFnADWkV8tJyr52bU0AmBFcffgPuVWmAG/YyL7T57
         IXN7HDZCB4qrA5ACQj0Fxr9jt19SNl42jgJU/3Rviw4HrghHT0LltNsijEGdty23n+KG
         Uxgw==
X-Gm-Message-State: AOAM533Yo5NAZxQIybdBGl2h0N34pplNT6uQK96vEmjRsBMOSwNBx/vP
        jwD8Swts5aXggeoiO2x9kChE6Hdn3CY=
X-Google-Smtp-Source: ABdhPJxwjlhoTqnj4E9V//tM6ijYmQGHJIKCJ/YZeqcBnm3mpZgLE3LmRBu6b58jjITFPpnfBiYA1pEZdDg=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:90a:353:: with SMTP id
 19mr12674037pjf.83.1635920918981; Tue, 02 Nov 2021 23:28:38 -0700 (PDT)
Date:   Tue,  2 Nov 2021 23:25:19 -0700
In-Reply-To: <20211103062520.1445832-1-reijiw@google.com>
Message-Id: <20211103062520.1445832-28-reijiw@google.com>
Mime-Version: 1.0
References: <20211103062520.1445832-1-reijiw@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [RFC PATCH v2 27/28] KVM: arm64: Activate trapping of disabled CPU
 features for the guest
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

Call kvm_vcpu_id_regs_trap_activate() at the first KVM_RUN
to activate trapping of disabled CPU features.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 1 +
 arch/arm64/kvm/arm.c              | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 691cb6ee0f5c..41f785fdc2e6 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -743,6 +743,7 @@ long kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
 				struct kvm_arm_copy_mte_tags *copy_tags);
 
 int kvm_id_regs_consistency_check(const struct kvm_vcpu *vcpu);
+void kvm_vcpu_id_regs_trap_activate(struct kvm_vcpu *vcpu);
 
 /* Guest/host FPSIMD coordination helpers */
 int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index afc49d2faa9a..330a35217987 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -583,6 +583,8 @@ static int kvm_vcpu_first_run_init(struct kvm_vcpu *vcpu)
 		return -EPERM;
 	}
 
+	kvm_vcpu_id_regs_trap_activate(vcpu);
+
 	kvm_arm_vcpu_init_debug(vcpu);
 
 	if (likely(irqchip_in_kernel(kvm))) {
-- 
2.33.1.1089.g2158813163f-goog

