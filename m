Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB6DA4EA5E3
	for <lists+kvm@lfdr.de>; Tue, 29 Mar 2022 05:20:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231623AbiC2DV6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Mar 2022 23:21:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230050AbiC2DV4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Mar 2022 23:21:56 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4652B31529
        for <kvm@vger.kernel.org>; Mon, 28 Mar 2022 20:20:14 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id om8-20020a17090b3a8800b001c68e7ccd5fso738900pjb.9
        for <kvm@vger.kernel.org>; Mon, 28 Mar 2022 20:20:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=sAGNmdLtBshVUh/KYJEFMIapacr3RW4pw1K+CiinPIg=;
        b=V/TJBz/iUJlEmkrMTjYoIS6WDNFPx87ejo/7vs1jet6SMwswMc4CzXzDjCkjps9egi
         127Cak4S3T6A/M28y5M1f1Hq86/nSXOBXnoz72c23voqPqxWYFWZnI6jzEb9ALYSAl/O
         eGM1GpOhJqrK/YSjdMpQwtvKFgIf31Cug8pGvOqxfsVfzfQU8QfaPEZNq4phzhj41nvT
         k5hPTFeGQsTKOd4ZJxaWR3C6ZwgDnjG1fyOQNb32py8ITkbMR7b6t6M/rg30q+JVozO0
         4vUgt86FSv6oIZvyLwC5YYTggVgcEthH8FWTKJcsX4HBs8fSrk0+4D3QqCPcYjRtH2bR
         AGQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=sAGNmdLtBshVUh/KYJEFMIapacr3RW4pw1K+CiinPIg=;
        b=dLg4HDeYiY0GPkXdabidMvooyCK2+/BwwlWJTlejOCaKEZ6LOD01DAubq9pWYrXK1j
         kNfkchMLTyrEFor174ietxcKweQ6gAMTQtwywR2qXQW30a3KYjE6CFZUoJGiRkbBQ0MY
         xYqUcFIRy20Hki185JCfhCNI2qlhuWOgPw8FnZaWqyJ4PNon7ONXrToAsRoAMDWT8ln5
         MGxWChKXLdX29ifNrulUeRegXpRDupFciAq+BcDsuxPitiCVYRlS+Haz2xm6nxtw4qFi
         qHx+ami7xlwZvrAAZUzguxWzPDOhHr686gFqi7u+AikpwHhMi4mT0lcuUf06nIZqH3PB
         Rjkw==
X-Gm-Message-State: AOAM5305gxgY7CK7oI8XkwOe8Bb7HSLnoVzACA1S8wbMPx2CMCproV4g
        Km5o07ZUlbFU4mxMfurbnepTpVxY6jQ=
X-Google-Smtp-Source: ABdhPJzL7MMvXVrrnBv7niD9JFw1J92Bl4gjNXuXN74eGBsYjblpq85cVrz7O16dqYjfIYwFFLWZVajk8pI=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a05:6a00:2310:b0:4fa:7eb1:e855 with SMTP id
 h16-20020a056a00231000b004fa7eb1e855mr26199966pfh.14.1648524013695; Mon, 28
 Mar 2022 20:20:13 -0700 (PDT)
Date:   Mon, 28 Mar 2022 20:19:22 -0700
Message-Id: <20220329031924.619453-1-reijiw@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.1021.g381101b075-goog
Subject: [PATCH v6 0/2] KVM: arm64: mixed-width check should be skipped for
 uninitialized vCPUs
From:   Reiji Watanabe <reijiw@google.com>
To:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Peter Shier <pshier@google.com>,
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

The series is based on kvmarm/fixes at:

  commit 8872d9b3e35a ("KVM: arm64: Drop unneeded minor version check from PSCI v1.x handler")

v6:
  - Fix typo and minor nits in the selftests [Oliver]

v5: https://lore.kernel.org/all/20220321050804.2701035-1-reijiw@google.com/
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
 arch/arm64/kvm/reset.c                        |  65 ++++++----
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/aarch64/vcpu_width_config.c | 122 ++++++++++++++++++
 6 files changed, 196 insertions(+), 30 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/aarch64/vcpu_width_config.c

-- 
2.35.1.1021.g381101b075-goog

