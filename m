Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DE4D40A160
	for <lists+kvm@lfdr.de>; Tue, 14 Sep 2021 01:11:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349657AbhIMXMj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Sep 2021 19:12:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349424AbhIMXL5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Sep 2021 19:11:57 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E74FCC0613EF
        for <kvm@vger.kernel.org>; Mon, 13 Sep 2021 16:10:21 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id h9-20020a17090a470900b001791c0352aaso5981704pjg.2
        for <kvm@vger.kernel.org>; Mon, 13 Sep 2021 16:10:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=jdwTA49s72LWLd7aNpa4ghDw/4j1WuhjFn5j/D8GsKA=;
        b=n9IHIL7bqWWJD9kNSg5x8CuLrTI9h5Nlf3qcTL82NsOsbPvZjAM++dxfL1gcBp/ysQ
         QwfFtElGGknpfwz9plM5DZUQIg5HuDCKnAqSDlctEwAX/gZo62+5c8FEvib+ygdg6swf
         y98cfLdVHya9zyhXkc7DSH6X/1HmBnFcOWOgqhY9mYh+T9yBDK0/Bc9/8Est/tYdIMal
         JRfwQ/tzTwrwtVFJaXOgq9J7yKw6Pya7nTw9QoT+KV5MmebT1ghbtxvJK+kND2f8pENG
         /Aeu27Kh4Q/y1EbNcX4Iyhf9/84mPqNMD4KH9qUbT1Cz0wHc+vy7gpE5mBskMhWmAOX1
         Xi6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=jdwTA49s72LWLd7aNpa4ghDw/4j1WuhjFn5j/D8GsKA=;
        b=peI96Qr6pqSnU4ZUBOvg5elP+JrfEDlbwuLVOZcgThisSvnWUTQzfWtxcP5hEA/t9D
         /lbTtYOW2tLROjj0I0TzSE4yBzU7Gu3Wj9pNlI5rjaOnrnJDK5E+S+1nSbgm5Rk4NTwN
         YJfb8wwLIFaqxSQfSTNfCmUtbCwIBxh4W/XukvuESJTvS51rSZaYnaahxH+Ur+exOISH
         RlKCaVExYmlyo9Fym4yEA9Rmpn4e1B4J03KzYafN+STXzFVpVvguBLKhpZ1tV/N2xM37
         xexL2XKWmKgE3ySaX+3EBV/mqFBuc5Ult5oUe0v+2/9Gq8QOgGwrQAO85cMsvoAGo49F
         gV5A==
X-Gm-Message-State: AOAM530FtqLWjlPzDNsXixWaytBT16l4JCD8Kv0H5oCKTzfW7EIRDwzZ
        ZM6HJVdxg/krgOJf7yHgN9nyOv647PsJ
X-Google-Smtp-Source: ABdhPJz9fG9ixXo+sDZ6n+RdZIfFHnjUskmE5ujgE+bNojfUBpJxqnL7knfeD+0FzFBU55ltwscmWDw//1kC
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a62:5a47:0:b0:411:d83a:3db4 with SMTP id
 o68-20020a625a47000000b00411d83a3db4mr1689702pfb.35.1631574621438; Mon, 13
 Sep 2021 16:10:21 -0700 (PDT)
Date:   Mon, 13 Sep 2021 23:09:50 +0000
In-Reply-To: <20210913230955.156323-1-rananta@google.com>
Message-Id: <20210913230955.156323-10-rananta@google.com>
Mime-Version: 1.0
References: <20210913230955.156323-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.309.g3052b89438-goog
Subject: [PATCH v6 09/14] KVM: arm64: selftests: Add guest support to get the vcpuid
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

