Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A8B740BB97
	for <lists+kvm@lfdr.de>; Wed, 15 Sep 2021 00:32:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235826AbhINWd0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Sep 2021 18:33:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235927AbhINWdE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Sep 2021 18:33:04 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02BEBC0613CF
        for <kvm@vger.kernel.org>; Tue, 14 Sep 2021 15:31:43 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id x29-20020aa7941d000000b0043c26e9eeddso442744pfo.5
        for <kvm@vger.kernel.org>; Tue, 14 Sep 2021 15:31:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=wauNwIwmja2q2Jg5bPFVhyVB/9NFZO9dAmOByqwKIHE=;
        b=GxzJdEKoi4NpRi08FJiVjpv24DdGyPJUWcN9gW/uSdAhLxMXXuhGlshuhdAsJd+XCH
         C1RUeXk46jm2J3liTO0ZWgSU4wk16C4LWyjvtoxQSK96FEpWoMuuSpCQ6isi86tGeho5
         icu9UaD+sm3/wKOkzhwl0tju2R7f6yqM4P+yRI2lQDh7mWSd4FDAfeSTJC6ncz9K9pk3
         7aOlXYiEj7dmRldEnnLZQytgtEk4nLw8iTNyN9bAvmfkzSvMqqqwfgScuRYEK3S65cYH
         +IRTfdqQ+l0DdJ7RJ0cp38Quez2Ux0KsGHpD64jaUFzwPVC0jHxDGjKCAwWA1M2pbdKt
         hvzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=wauNwIwmja2q2Jg5bPFVhyVB/9NFZO9dAmOByqwKIHE=;
        b=3YSAdIT2jcZb989v7nB3ag8lFs/p08F2CALPrgcCEBplX0JmIHJY/gCu/kxjybPJxl
         8gGNjye5nV2Ohh93B0RAiXAg7KNWsv4iXQxRykH86VXsYJxkMGNjNtJhJLtUlmWC1Wgc
         DklLAhwXTsiyBUlF1KmZagqbIBBvfPk1mjyEABPIPwcjRhy4arM1ri69yfOSylr7r9zJ
         adqFKoaqrGYSFkwEqc/hSYWJ602Tr1og+iAN47XGLrU38d740FnSYQECxuWxat7f6sS5
         68hh8y4PouNoylE2KEuSD005PlnCoF/WIpQXHZycvQbxa2npFfSUvoRDIbV7aibIJ3sc
         ptcQ==
X-Gm-Message-State: AOAM532Czl85WsOGjWqdPkSarjj8DkcLTms0ZKksdO1wPzzNUHJhINwI
        NPToulHbxEws+03tIPELaP0x4521Jin0
X-Google-Smtp-Source: ABdhPJwraibtgDwt+aMWBczNgOCVVTCAtCVQFbLYOLSXu8hvCj2vOUYR+M2U4dlOaah4JO7ydfm+C8fxPZ30
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a17:90b:3909:: with SMTP id
 ob9mr663472pjb.151.1631658702532; Tue, 14 Sep 2021 15:31:42 -0700 (PDT)
Date:   Tue, 14 Sep 2021 22:31:08 +0000
In-Reply-To: <20210914223114.435273-1-rananta@google.com>
Message-Id: <20210914223114.435273-10-rananta@google.com>
Mime-Version: 1.0
References: <20210914223114.435273-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.309.g3052b89438-goog
Subject: [PATCH v7 09/15] KVM: arm64: selftests: Maintain consistency for
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
2.33.0.309.g3052b89438-goog

