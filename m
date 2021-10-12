Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD8E9429C83
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 06:36:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232401AbhJLEi2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 00:38:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232419AbhJLEi1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Oct 2021 00:38:27 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9BA1C06161C
        for <kvm@vger.kernel.org>; Mon, 11 Oct 2021 21:36:26 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id my5-20020a17090b4c8500b001a0bf4025c1so88973pjb.8
        for <kvm@vger.kernel.org>; Mon, 11 Oct 2021 21:36:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=N5SZSA+fUqRTbjo35OUmhwDTNPioIOsC+zg6mLlAOeI=;
        b=Frtj842iBGMNrPh6OG3pi0Ms5HCdrLoaoymnVC+SUwO8+nKGBSOJVdpZwwm/QTQbF8
         OTYgVScpMIOT0ud7g2c8hytKJ2CjSjDz8M4XdeW7TJqSm2DEPdgyODcnwhB2ODPv6mBy
         aCnGplUEJ7fzS1cDJvyDiowSxXzf1dgt50MFJ/Uk5H21JMyKTRiuLsErBtQwO2+JItNz
         iBxKlc8wMy4/NwvNuNqhflcxOhfd2YbyIgr5mN/ngArSdHJllHqhq/3p1yIaKfs1EZGh
         Cvc+6I1dKsoE3RBupUrn125tyGYruhnhJUP/+o/18uTjunuMSuy2ARiKdbaEzViiwxtU
         j8Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=N5SZSA+fUqRTbjo35OUmhwDTNPioIOsC+zg6mLlAOeI=;
        b=TBml0uj5if1QHJwO8nh+V56DyVwbV3uuIC20ODA4Rx7wHtsdvAbzUPozwhuXM72lJ2
         vrfHYKZHz25yrtzycfKWZcx7Wr0qcXk0UrPXFEcRwcRMt/YSpi8XPfuV2Otwzhg8iLZV
         Vc5884c+R2q7tuMCaioGOEZCSBRqcUREyAHbrF0Z6l2dDiPdknhYlB4dtYK5vdmF81ic
         N7EyUFXNGDbVDQCgtLXCefKMK+7MAgcq9ZD2hwagEgaEZ51GRmStaZJLIEM2B0uMqRWn
         9lAb/HMnZq/ir7IVN9/75P2eZqHLINY4gxifO95uuNHw9pL7dASfI+cnd8rr2eyM4qOs
         gNPQ==
X-Gm-Message-State: AOAM530gWQwh2g7dfxHNL8qbuf0QVFa29wRz0imvdzV05+0lfMi4bpEs
        mbaRpF6I+zQifa88MR6HFO2QkgoDpI0=
X-Google-Smtp-Source: ABdhPJxq/Mk4VVM9slvxTOJugnOnUA71qyKTuAL0h3f8/ueBhLbCcxivpgKtoQVfP4/2KUnvpPsw8Foxo9o=
X-Received: from reiji-vws.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:15a3])
 (user=reijiw job=sendgmr) by 2002:a62:60c7:0:b0:40a:4bd7:752c with SMTP id
 u190-20020a6260c7000000b0040a4bd7752cmr29343562pfb.52.1634013386318; Mon, 11
 Oct 2021 21:36:26 -0700 (PDT)
Date:   Mon, 11 Oct 2021 21:35:15 -0700
In-Reply-To: <20211012043535.500493-1-reijiw@google.com>
Message-Id: <20211012043535.500493-6-reijiw@google.com>
Mime-Version: 1.0
References: <20211012043535.500493-1-reijiw@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [RFC PATCH 05/25] KVM: arm64: Keep consistency of ID registers
 between vCPUs
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

All vCPUs that are owned by a VM must have the same values of ID
registers.

Return an error at the very first KVM_RUN for a vCPU if the vCPU has
different values in any ID registers from any other vCPUs that have
already started KVM_RUN once.  Also, return an error if userspace
tries to change a value of ID register for a vCPU that already
started KVM_RUN once.

Changing ID register is still not allowed at present though.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  2 ++
 arch/arm64/kvm/arm.c              |  3 +++
 arch/arm64/kvm/sys_regs.c         | 31 +++++++++++++++++++++++++++++++
 3 files changed, 36 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 0cd351099adf..69af669308b0 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -745,6 +745,8 @@ int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
 long kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
 				struct kvm_arm_copy_mte_tags *copy_tags);
 
+int kvm_id_regs_consistency_check(const struct kvm_vcpu *vcpu);
+
 /* Guest/host FPSIMD coordination helpers */
 int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index fe102cd2e518..45ca72a37872 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -620,6 +620,9 @@ static int kvm_vcpu_first_run_init(struct kvm_vcpu *vcpu)
 
 	ret = kvm_arm_pmu_v3_enable(vcpu);
 
+	if (kvm_id_regs_consistency_check(vcpu))
+		return -EPERM;
+
 	return ret;
 }
 
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 8a0b88f9a975..2fe3121d50ca 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1331,6 +1331,10 @@ static int __set_id_reg(struct kvm_vcpu *vcpu,
 	if (val != read_id_reg(vcpu, rd, raz) && !GET_ID_REG_INFO(encoding))
 		return -EINVAL;
 
+	/* Don't allow to change the reg after the first KVM_RUN. */
+	if (vcpu->arch.has_run_once)
+		return -EINVAL;
+
 	if (raz)
 		return (val == 0) ? 0 : -EINVAL;
 
@@ -2901,6 +2905,33 @@ int kvm_arm_copy_sys_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
 	return write_demux_regids(uindices);
 }
 
+int kvm_id_regs_consistency_check(const struct kvm_vcpu *vcpu)
+{
+	int i;
+	const struct kvm_vcpu *t_vcpu;
+
+	/*
+	 * Make sure vcpu->arch.has_run_once is visible for others so that
+	 * ID regs' consistency between two vCPUs is checked by either one
+	 * at least.
+	 */
+	smp_mb();
+	WARN_ON(!vcpu->arch.has_run_once);
+
+	kvm_for_each_vcpu(i, t_vcpu, vcpu->kvm) {
+		if (!t_vcpu->arch.has_run_once)
+			/* ID regs still could be updated. */
+			continue;
+
+		if (memcmp(&__vcpu_sys_reg(vcpu, ID_REG_BASE),
+			   &__vcpu_sys_reg(t_vcpu, ID_REG_BASE),
+			   sizeof(__vcpu_sys_reg(vcpu, ID_REG_BASE)) *
+					KVM_ARM_ID_REG_MAX_NUM))
+			return -EINVAL;
+	}
+	return 0;
+}
+
 static void id_reg_info_init_all(void)
 {
 	int i;
-- 
2.33.0.882.g93a45727a2-goog

