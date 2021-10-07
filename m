Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAA4142608F
	for <lists+kvm@lfdr.de>; Fri,  8 Oct 2021 01:35:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242021AbhJGXhV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Oct 2021 19:37:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241497AbhJGXhE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Oct 2021 19:37:04 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B50C4C06176D
        for <kvm@vger.kernel.org>; Thu,  7 Oct 2021 16:35:09 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id oo5-20020a17090b1c8500b0019e585e8f6fso6435049pjb.9
        for <kvm@vger.kernel.org>; Thu, 07 Oct 2021 16:35:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=3YTqSaquht49DYwV2xuwN1X0OlaTExbB3K3aGCLZvU4=;
        b=iWyDlCyt++mvNVjpsszZMVe3mrpU8G5zxbRwKZBxglKbMvcprMFNqT75wIu/ofn5d5
         lu0nTdWxnEubwCSc3gXsnw4gCeRt7s8eKxarEEnfGimMtNYqqtsALGYqmHmUt0+OA7BR
         EoHYaeNjZjRscVlw6dAkXJNM6chFPwlREiYoYa4lXmK9YrEt2CqjrnBVEUNVvufovVi9
         FLJ5zJpLGVEnIHwMhk7WUnxjoxA1Qk0eJYfTmg8XdDxsBYpB6g5WeTMyn4HeNjo4FGrP
         Ey/66+bshubWicxpL1Og+qwaNfnRpVZs9/n8t1uok9Gc8LZQ40TRSDMJ+vkH75eG6mQs
         4NXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=3YTqSaquht49DYwV2xuwN1X0OlaTExbB3K3aGCLZvU4=;
        b=pnGOuecPekn/hPYmKM6ymnQbbzpCGdf2WUSJ+u3EUKq4vFydfjB/owDZBkBrLB1Cjy
         DaHR1Vorv/gAWhpxOTs+l1BRodce1KPVRimwC4ytmufKykK0NVMy7UgdQbNBlDYbQUaU
         5Xp9UThHbSwWHSxyhLcN74XQo2hKWL2gxoPYsdL1vjX18ULqvQF4LjdUlIAV871AePup
         YHOM/2QTxLbzxFEPBfUAt+jMbT63He1Er3YoRYItZY0usSPcMurWnwPUa0NqpYzy9FoD
         uPN8pSH28M6JIo+8tF55d8N9dNNfRvDcQ+ycTDOtYd1anTO2X1LlyP8Xg5Bj7XXFmLnC
         /Kfg==
X-Gm-Message-State: AOAM532o4WZN0CVKcNZb/NmsxohA5Mzi1Hq4OUVj2jVpli2LSiLrC4xC
        puvYHH6mLEG4v+64dMo4kTCy23Udgy4U
X-Google-Smtp-Source: ABdhPJxa/UqZJH8wMTzMrpOdYqAB4XnezhGeu0Toy/yEJFz2+kvRBNn3w8lt6T7GB7p01L3yhlcFcVlfnFux
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a63:cd48:: with SMTP id
 a8mr2038837pgj.180.1633649709219; Thu, 07 Oct 2021 16:35:09 -0700 (PDT)
Date:   Thu,  7 Oct 2021 23:34:33 +0000
In-Reply-To: <20211007233439.1826892-1-rananta@google.com>
Message-Id: <20211007233439.1826892-10-rananta@google.com>
Mime-Version: 1.0
References: <20211007233439.1826892-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH v8 09/15] KVM: arm64: selftests: Maintain consistency for
 vcpuid type
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

The prototype of aarch64_vcpu_setup() accepts vcpuid as
'int', while the rest of the aarch64 (and struct vcpu)
carries it as 'uint32_t'. Hence, change the prototype
to make it consistent throughout the board.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
---
 tools/testing/selftests/kvm/include/aarch64/processor.h | 2 +-
 tools/testing/selftests/kvm/lib/aarch64/processor.c     | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
index 515d04a3c27d..27d8e1bb5b36 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -63,7 +63,7 @@ static inline void set_reg(struct kvm_vm *vm, uint32_t vcpuid, uint64_t id, uint
 	vcpu_ioctl(vm, vcpuid, KVM_SET_ONE_REG, &reg);
 }
 
-void aarch64_vcpu_setup(struct kvm_vm *vm, int vcpuid, struct kvm_vcpu_init *init);
+void aarch64_vcpu_setup(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_vcpu_init *init);
 void aarch64_vcpu_add_default(struct kvm_vm *vm, uint32_t vcpuid,
 			      struct kvm_vcpu_init *init, void *guest_code);
 
diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
index db64ee206064..34f6bd47661f 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -212,7 +212,7 @@ void virt_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
 	}
 }
 
-void aarch64_vcpu_setup(struct kvm_vm *vm, int vcpuid, struct kvm_vcpu_init *init)
+void aarch64_vcpu_setup(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_vcpu_init *init)
 {
 	struct kvm_vcpu_init default_init = { .target = -1, };
 	uint64_t sctlr_el1, tcr_el1;
-- 
2.33.0.882.g93a45727a2-goog

