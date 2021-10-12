Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 743C2429CAE
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 06:37:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232598AbhJLEjS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 00:39:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233210AbhJLEjF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Oct 2021 00:39:05 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F3AAC061749
        for <kvm@vger.kernel.org>; Mon, 11 Oct 2021 21:36:56 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id o6-20020a170902bcc600b00138a9a5bc42so8385150pls.17
        for <kvm@vger.kernel.org>; Mon, 11 Oct 2021 21:36:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=eIUhuChkelcONVLGBJ0a2MPEEEhxwwehMuijtFOAuDI=;
        b=RuE+yIAI83dgKgc0EI81lpKKKdaCzCn8+SfDwPeU8Fln6xA4/deZlxo2DwtD71VRgy
         cw6TSj8JyRvn5oKLcvmqRuGF7hVSbUVdrEMEKUojpjZyBBQ+tJ1vSUHBrWlg1IuSMZPv
         R+rpCZeNhqGRUmc+stVB+dTUWZ147p6Jjc9tP2WejjahKq68g464d/gR3s99oJIo6lWp
         A/jaKj7gVcm9U7Tzh6Orb4tNznNnOji9vtaNMWche+5EZdUD4rHwml9Y4DQ6LY92/e/n
         yuPPhMOR//Z2EmHt3/Rk9H1biH/MgK7UmW3yEvDk4dlwnyojLI/KFQPcSc40TnGmCYIW
         ZXcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=eIUhuChkelcONVLGBJ0a2MPEEEhxwwehMuijtFOAuDI=;
        b=m1o8hmftfTdssyPEnaZaqCp7Xe/CWgBExXaORqH+b+fYBKi0E10Pj2okZHCnH87xKH
         34EvJqfTn1RsPX7vEI6Rmy4qA2tP8R3UzX4Y0d6UR93dpD8sPBUu6inm5YsyF3IX26zD
         bYBh2iJMtUVE9cgecp9LyDd+MYXtWcuZF8YwWd3Sh87pYj7o7IxXFrNoM8IIVCqVbjU2
         tFF30MBs/+z+OylwJdoYAlN6A2QHRFV+KiaD3vgmnV4hXfeGHeOPXIMJIMoPYgcYy7lc
         AhTzmSeNrkS+5wcpd7KbzdjGwW2JyK8EsskM23cijp6EDVtmaU+MP2bv7BSsH9s5TOCX
         4vWQ==
X-Gm-Message-State: AOAM530C160ISYsxccXAYbkfcvYZbdEMePYhMRY4xO5rTDm7SnG8jx/7
        9DTmSgs+BwjyLH3rNh5sl7a/txV5BOE=
X-Google-Smtp-Source: ABdhPJyTEEEJJ8ULSCGnE5RUuiEtmSCACpElVLQCVz7cpGVyLWG6TLcY5A92rMWKWU0CqVfHfvo0h0Ok6PA=
X-Received: from reiji-vws.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:15a3])
 (user=reijiw job=sendgmr) by 2002:a17:902:6ac4:b0:13f:52e1:8840 with SMTP id
 i4-20020a1709026ac400b0013f52e18840mr1435432plt.15.1634013416153; Mon, 11 Oct
 2021 21:36:56 -0700 (PDT)
Date:   Mon, 11 Oct 2021 21:35:34 -0700
In-Reply-To: <20211012043535.500493-1-reijiw@google.com>
Message-Id: <20211012043535.500493-25-reijiw@google.com>
Mime-Version: 1.0
References: <20211012043535.500493-1-reijiw@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [RFC PATCH 24/25] KVM: arm64: Activate trapping of disabled CPU
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
index 38301ddf8372..6b392d7feab7 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -606,6 +606,8 @@ static int kvm_vcpu_first_run_init(struct kvm_vcpu *vcpu)
 	if (kvm_id_regs_consistency_check(vcpu))
 		return -EPERM;
 
+	kvm_vcpu_id_regs_trap_activate(vcpu);
+
 	return ret;
 }
 
-- 
2.33.0.882.g93a45727a2-goog

