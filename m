Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 832D140BB99
	for <lists+kvm@lfdr.de>; Wed, 15 Sep 2021 00:32:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235895AbhINWdd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Sep 2021 18:33:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235770AbhINWdG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Sep 2021 18:33:06 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F259C0613E1
        for <kvm@vger.kernel.org>; Tue, 14 Sep 2021 15:31:45 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id f64-20020a2538430000b0290593bfc4b046so926333yba.9
        for <kvm@vger.kernel.org>; Tue, 14 Sep 2021 15:31:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=BW7fBGcKsdrR8mke56V7bzU7gD9WyqlXvKOO1bey3dM=;
        b=KKrMidevVqRU8tnCf4HU4OhnmV4gTubXrbIfa7ytYE6gg6NnqwIA73O/SeJOdKPaFS
         +aF6f8SR1NWh9ctn4JkR57SOSgLADPbjUTJXnTPMlWXteaQen7oI9433NcrMbrU9+6Vx
         IfOmq44ELPlXjNG5vZ8UGDbY8XrQNygpDmddOehD8XpaTdhS5CBvPXhFs97WUdE3mdlx
         +rlcewue0YSfqo1HwOKvI4mzWUA4vf5jcotMRA3l3ydvvLj8mozJhget75ThKDippFOI
         QQYqdf3SRHPJwf8tlda7NBau1BdAqms2EsS0QX+etXuBOJJaFOw6OK7Ykj4paUtyEafI
         le9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=BW7fBGcKsdrR8mke56V7bzU7gD9WyqlXvKOO1bey3dM=;
        b=cCscVswNUDxRZaVZg/beVYOxheKRetpeV17NqgFJab4jFdo/xiBgG9Zxgcg6npY/W8
         52Ij1g8GSW9ebCNjA2s9fd6MZqCbE341bLZx0lrT2fin/dMCzl1l6CvXk80Q0R7t08hn
         Rys9l8mjBbsj7CZMJI0arI7mzykwVVZhgZBTlWppKadHm4nc283b67kXQJOG2clWHyi1
         hO8/6jBCbkT3x+U3dfT/qDFiBbxzjUvQb4R4/UClry0IaclEXzLcZE4/MmkF+FY42KX7
         8HESHVx0UFdq6mg6G2+hWjn/1wvV80xUwnLqYNMWLjlxwCIU4GaQ7kED5d8xKRWZG/0d
         DFbg==
X-Gm-Message-State: AOAM530/sn7cRIp39k0gvBJqTRtJUNRt9MXulKkEk8waLBhklcz6x/iP
        83GOAeqBvddo0159Ssszm6mB0y4Cc2kp
X-Google-Smtp-Source: ABdhPJzPcqUzTM5tBKbzTFIOabctvphrNK79S1QDbS3uHmuEww5wKnVoFnhwbSzNggFM60aX3Wsu6DKNYmnL
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a25:5607:: with SMTP id
 k7mr2077562ybb.378.1631658704625; Tue, 14 Sep 2021 15:31:44 -0700 (PDT)
Date:   Tue, 14 Sep 2021 22:31:09 +0000
In-Reply-To: <20210914223114.435273-1-rananta@google.com>
Message-Id: <20210914223114.435273-11-rananta@google.com>
Mime-Version: 1.0
References: <20210914223114.435273-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.309.g3052b89438-goog
Subject: [PATCH v7 10/15] KVM: arm64: selftests: Add guest support to get the vcpuid
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
2.33.0.309.g3052b89438-goog

