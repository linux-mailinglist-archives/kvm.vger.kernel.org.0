Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDEAE409E83
	for <lists+kvm@lfdr.de>; Mon, 13 Sep 2021 22:51:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348291AbhIMUwV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Sep 2021 16:52:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348111AbhIMUv5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Sep 2021 16:51:57 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0E67C0613E8
        for <kvm@vger.kernel.org>; Mon, 13 Sep 2021 13:50:04 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id k15-20020a25240f000000b0059efafc5a58so14552262ybk.11
        for <kvm@vger.kernel.org>; Mon, 13 Sep 2021 13:50:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=RPKmsJf8WZ0Uq/9BsypZtQKa6wrsTaT9QMXRWAn7wEs=;
        b=NDjvx97IgaGT85nBiadBaDpI0UyIxHU8mosTjqdDd23Myy+XgccitfxwvgnNa1wycF
         BjAIMUdokS5IbQddUTx1El2rI+tHfpoHmE05wEnmsnHH4nO66gT8nid2W9a8toph79Yw
         HonNemVZo3XdBYxEqdv0lYtjCypp28BCFvJJQ1OqRo0fCo1rpAkUmjHREeZnksnNWaZZ
         Qz1jeykeqiBTz8GThFoJ7kAhsTcwQ2QBmjpzvSfWUj12lk1DKqHOHvNlnbt8V41CUEmT
         V32bQXXBffJ2sy3aCgdxlQuqSIxwIySy+Y3KiMj3Nit75E3DZfcC/iSDvA8dFc98zQDL
         rM9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=RPKmsJf8WZ0Uq/9BsypZtQKa6wrsTaT9QMXRWAn7wEs=;
        b=4K+Nr7DiSpVxV5I+XhyitIG/2hUSMY2dxRtj9XFTbnJWzySDymATy20cLDm7Crlo8B
         B+8xonJqluur4aS5RbPnDQIqWn0FmevY0XtdQTGUHyH+T9+Qx784SOCPQQTW3iFKe2g/
         HlTsO+cO67f99L2oImSAEnMbpYur4vLuTmHrkYa/Bdu7sz3PKgAVPVp+MscKJqPCUt01
         EIVWeeNogmHDMbAvaEcH4wEWSl1v2ngKgQzYj2oc2BXmZxL93GdeFGOPcAH9CfrOLRA7
         M2WkK5QgQ0iob7fTrqGRUhda7A2mwOz8HT5pLrdB4qo0ItLiQc0Qwqin/iOPAgcqS6W+
         xUeA==
X-Gm-Message-State: AOAM5334H5mzjXU7LzX/WA95TWZjUNnkfQrjN6yv+Xjs2yJtd92WrG5c
        pBag/kxC/cpw0PofUpyTa24QzpUK4G9J
X-Google-Smtp-Source: ABdhPJyfvHspvKcMFJDqwp4bVITpxHQ5XcPoZyJH4ggpu00/5Mg05cH03Gxtzi5Vl/6xJeTsvycll8h+jzTh
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a25:9d01:: with SMTP id
 i1mr18564769ybp.88.1631566203899; Mon, 13 Sep 2021 13:50:03 -0700 (PDT)
Date:   Mon, 13 Sep 2021 20:49:25 +0000
In-Reply-To: <20210913204930.130715-1-rananta@google.com>
Message-Id: <20210913204930.130715-10-rananta@google.com>
Mime-Version: 1.0
References: <20210913204930.130715-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.309.g3052b89438-goog
Subject: [PATCH v5 09/14] KVM: arm64: selftests: Add guest support to get the vcpuid
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
---
 tools/testing/selftests/kvm/include/kvm_util.h      | 2 ++
 tools/testing/selftests/kvm/lib/aarch64/processor.c | 6 ++++++
 2 files changed, 8 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 010b59b13917..5770751a5735 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -400,4 +400,6 @@ uint64_t get_ucall(struct kvm_vm *vm, uint32_t vcpu_id, struct ucall *uc);
 int vm_get_stats_fd(struct kvm_vm *vm);
 int vcpu_get_stats_fd(struct kvm_vm *vm, uint32_t vcpuid);
 
+int guest_get_vcpuid(void);
+
 #endif /* SELFTEST_KVM_UTIL_H */
diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
index db64ee206064..f1255f44dad0 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -277,6 +277,7 @@ void aarch64_vcpu_setup(struct kvm_vm *vm, int vcpuid, struct kvm_vcpu_init *ini
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
+int guest_get_vcpuid(void)
+{
+	return read_sysreg(tpidr_el1);
+}
-- 
2.33.0.309.g3052b89438-goog

