Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4614454171
	for <lists+kvm@lfdr.de>; Wed, 17 Nov 2021 07:54:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233459AbhKQG4x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Nov 2021 01:56:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233983AbhKQG4u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Nov 2021 01:56:50 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CC22C06120B
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 22:53:52 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id p3-20020a170903248300b00143c00a5411so564538plw.12
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 22:53:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=cOVvD3SNDbIL6lfyzdxlcaoY7rN6G8I+IyW+oD8ignM=;
        b=Xlauq9wTt3xE6BYao1bY0HArMFV6nJ6xH/EuP9kpisaxTdt4ScYKFFQdkG9sKoH42R
         NkptaNYJUssNyX3+a9NogLBRKsc+T4nXMSPu5l6ecIZP9dgrCJ0LRj7ZvOKbho3fYKNy
         PhVcALbMCYQ5Ueoz0h1Zle1j3NxvJu/jDi42xUt/UJknbA+Lqr2OvLzYcpG7zS4LUpWS
         nkauUZlcLVqSJnhSegPKecNwi6FsaKPSVXQ2kuwbCvjFz60gmhYejZ728lE6cGAK8Onu
         SHWWKdpNNpAFDd8jo6+oW+sUESEmaN9xI1ziqCGHwbi6sB/ULtj398r4gUOZBz/AtQOk
         ALuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=cOVvD3SNDbIL6lfyzdxlcaoY7rN6G8I+IyW+oD8ignM=;
        b=htQFqSKfBjIxcNJ1u1xUibQhYPeF5WvQdfAOOGsTxtmRBRk8es8AM/jJz2fEOD8SqI
         Hn6l4/MJ18xx062XyXi/e99zamdsHbQZAtPVHRduThp8Apb/FUsN6r+hfMszNR1Tij9n
         uHWhaZg6VB3cX32I/efqR/IB1eNZvJgEWLUFZ+v8EjF3kxK/oejQpx21OR4kVbXzYjgq
         1CDXKiOVjXrrNutGWFb8nyOFupbaCI5yWq886Sp8bBd/j39HgCtlceTN64+NILs/Cdfa
         Ln/hz8+IjMBoMrozcDOCgubMczSGa2gNz99bM/EPZ+bC1YDmZ4RQHGQKe6L//WEa6Yib
         nzPg==
X-Gm-Message-State: AOAM530Hpsf3FCm3pw347kRQ9kXlMMv+Zj13uimLhUpiv/jAZuLI2vzs
        WPGjKRJQQGy3wWDNlP1f+7rvedHqXCs=
X-Google-Smtp-Source: ABdhPJxgZUPAeWfxD6o4eFhxbgg1xva8V+KS7wN7lmBeeEQdyhn13ZRClap0+p1FhSsGVbJnsbUOIWe02Cw=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:90a:390c:: with SMTP id
 y12mr314910pjb.0.1637132031567; Tue, 16 Nov 2021 22:53:51 -0800 (PST)
Date:   Tue, 16 Nov 2021 22:43:57 -0800
In-Reply-To: <20211117064359.2362060-1-reijiw@google.com>
Message-Id: <20211117064359.2362060-28-reijiw@google.com>
Mime-Version: 1.0
References: <20211117064359.2362060-1-reijiw@google.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [RFC PATCH v3 27/29] KVM: arm64: Initialize trapping of disabled CPU
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

Call kvm_vcpu_init_traps() at the first KVM_RUN to initialize trapping
of disabled CPU features for the guest.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 1 +
 arch/arm64/kvm/arm.c              | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 9dc9970a2d46..a53949cd53c6 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -747,6 +747,7 @@ long kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
 				struct kvm_arm_copy_mte_tags *copy_tags);
 
 int kvm_id_regs_consistency_check(const struct kvm_vcpu *vcpu);
+void kvm_vcpu_init_traps(struct kvm_vcpu *vcpu);
 
 /* Guest/host FPSIMD coordination helpers */
 int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 64b104ebee73..25a41ff92aa5 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -625,6 +625,8 @@ static int kvm_vcpu_first_run_init(struct kvm_vcpu *vcpu)
 	 */
 	if (kvm_vm_is_protected(kvm))
 		kvm_call_hyp_nvhe(__pkvm_vcpu_init_traps, vcpu);
+	else
+		kvm_vcpu_init_traps(vcpu);
 
 	return ret;
 }
-- 
2.34.0.rc1.387.gb447b232ab-goog

