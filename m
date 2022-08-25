Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F142F5A0858
	for <lists+kvm@lfdr.de>; Thu, 25 Aug 2022 07:10:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233467AbiHYFK1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Aug 2022 01:10:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233371AbiHYFKY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Aug 2022 01:10:24 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AFB180F7B
        for <kvm@vger.kernel.org>; Wed, 24 Aug 2022 22:10:21 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-33da75a471cso59064257b3.20
        for <kvm@vger.kernel.org>; Wed, 24 Aug 2022 22:10:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc;
        bh=EmnP6URNfHv6I0nbxGmg1XJ0KHdi317moIKFVeeAsc8=;
        b=odzh+413GPIsjI66IJBEHSOJ1TAozjY8/5h10hAgbwXYR+m8+Bq098asyIJO31M6XX
         FG6XQOp4j4ukN2HsJ06YJmmH7orlAaws2A+dvnD8GzU49lsEM59llnl7vYysAlJjgJkB
         Z9sSIQCG/bNvPvmJkwVn3TuSSS3HX7RGRbtoLkCPKctFswbbcSHV14tjLpeVjQWTS/3U
         74fuO1j9abX4bH4TwtyH1divYl7Kc0o51RcxSyPowqEfdSqwcMMuUC8p7UUGhR3wso3K
         bgUqyEQlUfxjPBGEj9/3GzXGK/Y/DNJHWiAHHQS6DuztTtwkFMrAa/O5D1XFFaAaC9wU
         XO+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=EmnP6URNfHv6I0nbxGmg1XJ0KHdi317moIKFVeeAsc8=;
        b=2wfJV2AO6kUATxLmLyU/UTje4kBkFNW8CsH9qJBxbpCV1T6zMN01XXeOw0aREcuICc
         ovfmqPIdYBW962KPtR10/vWX8puIxRiqXidT4IFFUeOGDzVWce01niU+tVTA4P3qfr/7
         jJaspKMuOqHNiw8hF0COOCKOr6sHkq/jdc4OmdWwqn7cpyKX5wIs2jcKPhkjrTI14qB6
         EcenBGNUK7dQCm4rjceaDqJ+fk/c7CLNaLjdH97N3E+YGAHixrdkp7QuNHvmkYFi2qeB
         mstjV5f2GJbHLcLZlFl8c3+Xr0iankEklbefJ1HsC0E+VTAgjKeIA8S7WYJohz48KwM0
         mWLw==
X-Gm-Message-State: ACgBeo1+D2GSlJAspAYKxSFLmHEWaKvEdLVol87KodmDQam+odatwVyC
        dJi4xbJS7eYl5MtOueU8dcyJxyrgytE=
X-Google-Smtp-Source: AA6agR4ONormzDuDs7YpdVMH6kwTbayc6AXSuIT5cwIOH9liK5R8puxixgYLfHyko+rG1K4Ic3X2+t6qTmc=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a5b:dd2:0:b0:695:7965:1747 with SMTP id
 t18-20020a5b0dd2000000b0069579651747mr1981297ybr.415.1661404221149; Wed, 24
 Aug 2022 22:10:21 -0700 (PDT)
Date:   Wed, 24 Aug 2022 22:08:43 -0700
In-Reply-To: <20220825050846.3418868-1-reijiw@google.com>
Message-Id: <20220825050846.3418868-7-reijiw@google.com>
Mime-Version: 1.0
References: <20220825050846.3418868-1-reijiw@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [PATCH 6/9] KVM: arm64: selftests: Change debug_version() to take ID_AA64DFR0_EL1
From:   Reiji Watanabe <reijiw@google.com>
To:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Change debug_version() to take the ID_AA64DFR0_EL1 value instead of
vcpu as an argument, and change its callsite to read ID_AA64DFR0_EL1
(and pass it to debug_version()).
Subsequent patches will reuse the register value in the callsite.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 tools/testing/selftests/kvm/aarch64/debug-exceptions.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
index 17b17359ac41..ab8860e3a9fa 100644
--- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
+++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
@@ -315,11 +315,8 @@ static void guest_svc_handler(struct ex_regs *regs)
 	svc_addr = regs->pc;
 }
 
-static int debug_version(struct kvm_vcpu *vcpu)
+static int debug_version(uint64_t id_aa64dfr0)
 {
-	uint64_t id_aa64dfr0;
-
-	vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64DFR0_EL1), &id_aa64dfr0);
 	return cpuid_get_ufield(id_aa64dfr0, ID_AA64DFR0_DEBUGVER_SHIFT);
 }
 
@@ -329,6 +326,7 @@ int main(int argc, char *argv[])
 	struct kvm_vm *vm;
 	struct ucall uc;
 	int stage;
+	uint64_t aa64dfr0;
 
 	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
 	ucall_init(vm, NULL);
@@ -336,7 +334,8 @@ int main(int argc, char *argv[])
 	vm_init_descriptor_tables(vm);
 	vcpu_init_descriptor_tables(vcpu);
 
-	__TEST_REQUIRE(debug_version(vcpu) >= 6,
+	vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64DFR0_EL1), &aa64dfr0);
+	__TEST_REQUIRE(debug_version(aa64dfr0) >= 6,
 		       "Armv8 debug architecture not supported.");
 
 	vm_install_sync_handler(vm, VECTOR_SYNC_CURRENT,
-- 
2.37.1.595.g718a3a8f04-goog

