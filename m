Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAF3F443D19
	for <lists+kvm@lfdr.de>; Wed,  3 Nov 2021 07:27:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231749AbhKCGaN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 02:30:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231724AbhKCGaM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Nov 2021 02:30:12 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEE62C061714
        for <kvm@vger.kernel.org>; Tue,  2 Nov 2021 23:27:36 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id e4-20020a630f04000000b002cc40fe16afso976873pgl.23
        for <kvm@vger.kernel.org>; Tue, 02 Nov 2021 23:27:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=2kkWf9Zdg9qBQvwRcMyQK3V/8Ny7lbc2Hbppz7GxNUU=;
        b=ZLc1WdJUS93vqQce2eG799TQxbD2srN4onYKkVcfL2Qy9TnekNN3Vl6DK8+Ri32oM7
         YYTKpD6QQGLRVUs2Gep5QkIzNUqeJ3Xk3zrHbHMSNJv2EmE1u0worcGwk4rHrtl6x+Ey
         EGlfhtIg5LeD5CyBmJa9zwPtN17NgP+YlqYLEzSdMOo75fpLdVtX/9JyPaow0wpXj5Hh
         GIbKaWe1vB0I6uGb2fsaGUAWiLwVur8adMQn5JSZDCqMN2VCtyDl0k5CSAE1L1dpyJSd
         RCi61slMNASXPLLAxW4pmUBIseVDXZk+lfLUimHZPGz9agQQU/7wy2EsjEHbduCLM4zH
         T4SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=2kkWf9Zdg9qBQvwRcMyQK3V/8Ny7lbc2Hbppz7GxNUU=;
        b=sI11GhHaaQDjt21cv64XLJ/Zm4qKanEqhqzJW+Oz1UXLg3BLAvhodvNoTV/o6eCCUK
         67emWDJNnAcC6KFAriIUDL8ASM0LfJyXtmzoBtRB/5jPg/l9AmUY0w/h9NEdi48BAbW8
         jtimzNN3gfjTceph05rsv19INTXS7Yn5EQV/3oA/v3NPdR8mTWGr00lrJR1alhcfgnyW
         /IJFj8YifJjguB+hG/g13qtcOyWQiVTJzGxZMBtLH4nc8MkIwprfR46IStK5ex+98oeL
         c9zaialUEuzR1jZEcwNEx6FkGPDGpWTOrFb9oepp8Z7zDDhAz4kPgGT+nqKfNUdxWUrY
         CH8g==
X-Gm-Message-State: AOAM532sePqU3P76q8uWYMHv3oj3fw77uIk7qGqjVZMBiFfAP8QmKWHX
        jcnJgRe/2Uvr3N8WkQwjooOPTyPgtzY=
X-Google-Smtp-Source: ABdhPJziBhn4stzQ3o4JqWAXRAPRH2k+xrO4rqj56Fh+Dx8pv+gOVGokRNBtSBx8lVyj+81XUSJwFXkbmak=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a05:6a00:1254:b0:481:29f7:398 with SMTP id
 u20-20020a056a00125400b0048129f70398mr8484996pfi.33.1635920856329; Tue, 02
 Nov 2021 23:27:36 -0700 (PDT)
Date:   Tue,  2 Nov 2021 23:24:56 -0700
In-Reply-To: <20211103062520.1445832-1-reijiw@google.com>
Message-Id: <20211103062520.1445832-5-reijiw@google.com>
Mime-Version: 1.0
References: <20211103062520.1445832-1-reijiw@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [RFC PATCH v2 04/28] KVM: arm64: Keep consistency of ID registers
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
 arch/arm64/kvm/arm.c              |  4 ++++
 arch/arm64/kvm/sys_regs.c         | 31 +++++++++++++++++++++++++++++++
 3 files changed, 37 insertions(+)

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
index fe102cd2e518..83cedd74de73 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -595,6 +595,10 @@ static int kvm_vcpu_first_run_init(struct kvm_vcpu *vcpu)
 		return -EPERM;
 
 	vcpu->arch.has_run_once = true;
+	if (kvm_id_regs_consistency_check(vcpu)) {
+		vcpu->arch.has_run_once = false;
+		return -EPERM;
+	}
 
 	kvm_arm_vcpu_init_debug(vcpu);
 
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 64d51aa3aee3..e34351fdc66c 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1436,6 +1436,10 @@ static int __set_id_reg(struct kvm_vcpu *vcpu,
 	if (val != read_id_reg(vcpu, rd, raz) && !GET_ID_REG_INFO(encoding))
 		return -EINVAL;
 
+	/* Don't allow to change the reg after the first KVM_RUN. */
+	if (vcpu->arch.has_run_once)
+		return -EINVAL;
+
 	if (raz)
 		return 0;
 
@@ -3004,6 +3008,33 @@ int kvm_arm_copy_sys_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
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
2.33.1.1089.g2158813163f-goog

