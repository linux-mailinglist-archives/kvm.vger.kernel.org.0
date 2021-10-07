Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88A38426093
	for <lists+kvm@lfdr.de>; Fri,  8 Oct 2021 01:39:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242363AbhJGXha (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Oct 2021 19:37:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242353AbhJGXhG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Oct 2021 19:37:06 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5BEBC061570
        for <kvm@vger.kernel.org>; Thu,  7 Oct 2021 16:35:11 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id v19-20020a17090ac91300b0019fb4310e88so3873290pjt.4
        for <kvm@vger.kernel.org>; Thu, 07 Oct 2021 16:35:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=nkCzPFgOJztBJ0PQFO3yLXxYkMFo6+sOQFUA9flKBVo=;
        b=qIEp/mw1Fg8Yf1raio1KjNBQpvMThqVC27jDw7TFFKUVwmSmxIf9kcfbMtMb4xLuh1
         TqxDv3zeD7163ziETqd4Nlc/1v7wdrVWClnSpICosTfIwTLVD3nobC2rWO6b2BNvUePO
         gnLdM09pNNi21tdLYufksj4K1u4PWwI/PNtH9OS4gfhVoKR+//msDWyrzzE61xZUE8Vv
         RsmVezCne62HXXTub3gBKuC6dIRxtVonEv2VKxAu2YqQSARZ5UxP560D3vhniSVtIQSY
         UzxexI3EPgtXuHRYrn4pCwLA+GforI1Dd0poR8lm8m3+4iq/rs1m8m9cwZ8KEbgf+t8o
         x8kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=nkCzPFgOJztBJ0PQFO3yLXxYkMFo6+sOQFUA9flKBVo=;
        b=Yp52MYn958WQQxN9/GKy3lwbS5NLJMI+ewAkVaVXq5PTjahEGLV0HzI6DUSCaOPBXD
         Iq3ueTjuKNeBDsPyns5SDi6hDJPc88YRfEY+lDyQrnAbJD3zby2p9XIZylr4ClCUAJQC
         BozAL0yXc3sYUb0K/IwG2FD7CzMj48YKbjmAx8+ibZeqtoJ06g6JfYF5nUZb699KUpHU
         JrgWV3POEeu2khkfDxwTexWoVA53VFpczgdtB1KSMn4cQircJh7I3QtUD53WgCSF9c55
         IV0ULHtNV+XddxH/Ya77g9GiwDrU7Pw/J54OendOKiQuvlFEjMrkEG9Hzwpn2aAQmlj0
         Emlw==
X-Gm-Message-State: AOAM5326i0ZYBgfMsOoXIRzchbQcwoEfMwJ7sejH7QW++KZkD1yG7woH
        Dwf+K8129DAMYs7kpP/G10S47zt60Uhe
X-Google-Smtp-Source: ABdhPJyF285C27p4CHJ8ZoPVE07j8+batfUwCNrzEr36gltXnfaZXtP8+IsE/rtmvNVJDMCV0IKk2/DYj4uR
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a17:902:b188:b029:11b:1549:da31 with SMTP
 id s8-20020a170902b188b029011b1549da31mr6330570plr.7.1633649711389; Thu, 07
 Oct 2021 16:35:11 -0700 (PDT)
Date:   Thu,  7 Oct 2021 23:34:34 +0000
In-Reply-To: <20211007233439.1826892-1-rananta@google.com>
Message-Id: <20211007233439.1826892-11-rananta@google.com>
Mime-Version: 1.0
References: <20211007233439.1826892-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH v8 10/15] KVM: arm64: selftests: Add guest support to get the vcpuid
From:   Raghavendra Rao Ananta <rananta@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

At times, such as when in the interrupt handler, the guest wants
to get the vcpuid that it's running on to pull the per-cpu private
data. As a result, introduce guest_get_vcpuid() that returns the
vcpuid of the calling vcpu. The interface is architecture
independent, but defined only for arm64 as of now.

Suggested-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
Reviewed-by: Ricardo Koller <ricarkol@google.com>
Reviewed-by: Reiji Watanabe <reijiw@google.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
---
 tools/testing/selftests/kvm/include/kvm_util.h      | 2 ++
 tools/testing/selftests/kvm/lib/aarch64/processor.c | 6 ++++++
 2 files changed, 8 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 010b59b13917..bcf05f5381ed 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -400,4 +400,6 @@ uint64_t get_ucall(struct kvm_vm *vm, uint32_t vcpu_id, struct ucall *uc);
 int vm_get_stats_fd(struct kvm_vm *vm);
 int vcpu_get_stats_fd(struct kvm_vm *vm, uint32_t vcpuid);
 
+uint32_t guest_get_vcpuid(void);
+
 #endif /* SELFTEST_KVM_UTIL_H */
diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
index 34f6bd47661f..b4eeeafd2a70 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -277,6 +277,7 @@ void aarch64_vcpu_setup(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_vcpu_init
 	set_reg(vm, vcpuid, KVM_ARM64_SYS_REG(SYS_TCR_EL1), tcr_el1);
 	set_reg(vm, vcpuid, KVM_ARM64_SYS_REG(SYS_MAIR_EL1), DEFAULT_MAIR_EL1);
 	set_reg(vm, vcpuid, KVM_ARM64_SYS_REG(SYS_TTBR0_EL1), vm->pgd);
+	set_reg(vm, vcpuid, KVM_ARM64_SYS_REG(SYS_TPIDR_EL1), vcpuid);
 }
 
 void vcpu_dump(FILE *stream, struct kvm_vm *vm, uint32_t vcpuid, uint8_t indent)
@@ -426,3 +427,8 @@ void vm_install_exception_handler(struct kvm_vm *vm, int vector,
 	assert(vector < VECTOR_NUM);
 	handlers->exception_handlers[vector][0] = handler;
 }
+
+uint32_t guest_get_vcpuid(void)
+{
+	return read_sysreg(tpidr_el1);
+}
-- 
2.33.0.882.g93a45727a2-goog

