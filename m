Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AC2D4E1FC9
	for <lists+kvm@lfdr.de>; Mon, 21 Mar 2022 06:08:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244464AbiCUFJl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Mar 2022 01:09:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229982AbiCUFJk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Mar 2022 01:09:40 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8E1921250
        for <kvm@vger.kernel.org>; Sun, 20 Mar 2022 22:08:15 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id q8-20020a656a88000000b003810f119b61so6845322pgu.10
        for <kvm@vger.kernel.org>; Sun, 20 Mar 2022 22:08:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=cGQsgNjFRYhDeev7uNz7LWwt7GNAQoUSmq7BQTxGuxE=;
        b=QbWh7YTxiSYyD6RXVVXrIEKuySt/Re66x+0XKN3JEQ9LWDEVJ4nhXNX/7X2+4r0ssk
         TWbE/y/86HA3KcljsIZ3ZpGa7K2sRNO3iRkQ3GBEXDYJsz1D8olXJCZXIpjIvtNjapQJ
         YM/FKobD8zF+xqXV6VVv+VaASxr5DAj6264OVGux4V5vvxakSiYRs5R//XsoIs5vrzBe
         yYNEuzF9qWAffWHm9xVDWOGcunMOWIqFNtLkqVVQbHxKJWFjt/yvx9Qr77GQGnbJeu5U
         dQg8GSAyW9zA8z8aqLkX+axB5uUo1CIJ8dkuubePda3RrQG7aKlbyyHHxBUjrgkb7ChU
         rtwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=cGQsgNjFRYhDeev7uNz7LWwt7GNAQoUSmq7BQTxGuxE=;
        b=EgkwbSb9ZjoULddWsVt4aiRrXtEbkWbYb6871Ho1zbaPcEckl2Ndq4CavNnFBlKWzJ
         Kz8xMJ7ammQdgQfZTmisjxRBkMatFrCxBIS+Mm4Kke10DQTnXOEj6ZhpcbvgjSJGl2Gn
         T9EQSng96wI2a7S/it/714yqJc6kScJeJn42ODvCaoufjO0L3Y/pp8Ym72f3cojw+Dx9
         Ao+hWXEnJS0KlMUuU7BV8xo7ZICJ975DNIH8Tb+MhwXp3WsGu1/SEIdUSYYHXKJCo8zv
         d5sXo1G4cTkD+54KhTKC36daRDPuGpJyCn8wiH+Dd6XGazAOQ4u1JMS1FSAyniF1duGO
         czNA==
X-Gm-Message-State: AOAM533v6qucvfUUF3/2T+DqDa6k5VQXagnyhYyMlkhPwKKuCu3Ewt+b
        Ti7GFEZ9aWIc7o5QvrDRaSFwVPe20gg=
X-Google-Smtp-Source: ABdhPJx2nPYTXS5zVdFBXtlwohrhTS1zH8bM5qyThixl3/KmV68bmIjNvzrfmY5I61S9Rnn1fvAUTWUHR+E=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:90a:858b:b0:1c6:5bc8:781a with SMTP id
 m11-20020a17090a858b00b001c65bc8781amr1265206pjn.0.1647839294798; Sun, 20 Mar
 2022 22:08:14 -0700 (PDT)
Date:   Sun, 20 Mar 2022 22:08:02 -0700
Message-Id: <20220321050804.2701035-1-reijiw@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.894.gb6a874cedc-goog
Subject: [PATCH v5 0/2] KVM: arm64: mixed-width check should be skipped for
 uninitialized vCPUs
From:   Reiji Watanabe <reijiw@google.com>
To:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
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

KVM allows userspace to configure either all EL1 32bit or 64bit vCPUs
for a guest.  At vCPU reset, vcpu_allowed_register_width() checks
if the vcpu's register width is consistent with all other vCPUs'.
Since the checking is done even against vCPUs that are not initialized
(KVM_ARM_VCPU_INIT has not been done) yet, the uninitialized vCPUs
are erroneously treated as 64bit vCPU, which causes the function to
incorrectly detect a mixed-width VM.

This series will fix this problem by introducing a new VM flag that
indicates the guest needs to be configured with all 32bit or 64bit
vCPUs and checking vcpu's register width against the new flag at
the vcpu's KVM_ARM_VCPU_INIT (instead of against other vCPUs'
register width).

Patch-1 introduces KVM_ARCH_FLAG_EL1_32BIT and
KVM_ARCH_FLAG_REG_WIDTH_CONFIGURED bits for kvm->arch.flags and
uses them to check vcpu's register width to fix the problem.

Patch-2 introduces a selftest that can test non-mixed-width vCPUs (all
64bit vCPUs or all 32bit vcPUs) can be configured, and mixed-width
vCPUs cannot be configured.

The series is based on kvmarm/next's at tag: kvmarm-5.18.

v5:
  - Rebase to kvmarm/next (and drop the patch-1 "KVM: arm64: Generalise
    VM features into a set of flags")
  - Use kernel-doc style comments for kvm_set_vm_width() [Oliver]
  - Change kvm_set_vm_width() to use if/else instead of a ternary
    operator for KVM_ARCH_FLAG_EL1_32BIT check [Oliver]

v4: https://lore.kernel.org/all/20220314061959.3349716-1-reijiw@google.com/
  - Use different implementation of vcpu_el1_is_32bit() depending on
    the context. [Marc]
  - Rename kvm_register_width_check_or_init() to kvm_set_vm_width(), and
    call it from kvm_rest_vcpu() instead of from kvm_vcpu_set_target()
  - Remove vcpu_allowed_register_width(), and does the same checking
    in kvm_set_vm_width() instead.

v3: https://lore.kernel.org/all/20220303035408.3708241-1-reijiw@google.com/
  - Introduced 'flags' to kvm_arch, and use bits of the flags for
    a set of booleans for VM feature.
  - Changed 'el1_reg_width' to two bits of 'flags' of kvm_arch.

v2: https://lore.kernel.org/all/20220118041923.3384602-1-reijiw@google.com/
  - Introduced 'el1_reg_width' for kvm_arch and use it to check vcpu's
    register width against the flag at the vcpu's KVM_ARM_VCPU_INIT.

v1: https://lore.kernel.org/all/20220110054042.1079932-1-reijiw@google.com/

[1] https://lore.kernel.org/all/20210715163159.1480168-2-maz@kernel.org/

Reiji Watanabe (2):
  KVM: arm64: mixed-width check should be skipped for uninitialized
    vCPUs
  KVM: arm64: selftests: Introduce vcpu_width_config

 arch/arm64/include/asm/kvm_emulate.h          |  27 ++--
 arch/arm64/include/asm/kvm_host.h             |  10 ++
 arch/arm64/kvm/reset.c                        |  65 ++++++---
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/aarch64/vcpu_width_config.c | 125 ++++++++++++++++++
 6 files changed, 199 insertions(+), 30 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/aarch64/vcpu_width_config.c

-- 
2.35.1.894.gb6a874cedc-goog

