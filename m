Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF6AE4D7ABA
	for <lists+kvm@lfdr.de>; Mon, 14 Mar 2022 07:22:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229921AbiCNGX1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Mar 2022 02:23:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbiCNGX0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Mar 2022 02:23:26 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 884EC403CF
        for <kvm@vger.kernel.org>; Sun, 13 Mar 2022 23:22:17 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id 184-20020a6215c1000000b004f6dc47ec08so8881424pfv.21
        for <kvm@vger.kernel.org>; Sun, 13 Mar 2022 23:22:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=6PVulGo8PUqZzVS4FQCQESr0wP4UDOtzRfsUiSpPSzU=;
        b=NMTHcfQ//XkUn0hFLjVC8DV6m2SeAkUsxvrHVx1PDOK7/ZDB4u/CaWkMUe1eUX1KUu
         oeWxc0jrL5ItjthiRDO8371DRjwU6H4tDrgeZRHvcnJ9TQaUJ5dYy73EDcbbJ+OJamsp
         u/gnzwiwxo27r86aAstrIVXL2wUXwb4D2Q7P3FwPRgBjiatwul1mp8Zp8Q+CKD2TbQNp
         J44/0PEURgqLrP49oTQJ9ozS6cl6V9/u1udMFKsqYilq+o+qVUQcozRCnco1kamSOAn0
         jDpWAaZEsrJ3rZQ/lXmprnstFDU7dRHMa1id9zxWeOfUTNaE38HJoTarnCJWj6itYWDX
         tcyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=6PVulGo8PUqZzVS4FQCQESr0wP4UDOtzRfsUiSpPSzU=;
        b=MT2MTTAs0IkPPeURxWvaFtOOLznUPHxKMka+tcPEcEAEruGyRGIP6ZZOqRfuDPpeNo
         HUbEsA2q+W3961NBxJXeZSZ/BaFnm+rizRmt1+FGpiXPq3PJawHA6SCFLCOlJgociCqy
         kV/xwmc3XNsGxkFGyuQqq0jw/xQ47BBeqoAPSnmuEyRZzA/AOp7ZiraN3dg52mdgzUVy
         HZ+vXrdEFC+qd8lebpVUdtkJxMiB9eBQsjLS6czikaZgKJyYky7RXAGTjwUwwlqXzZdW
         eD7R6IVT8P2GeFti4OgnIYc1LyFNiXpKYKNEusBuYU3yz19fSxCKuZ7/V0DtgJFRKuNo
         LRxg==
X-Gm-Message-State: AOAM531zALnRYDtJnWnY+AJPp3VeVwMYDTLyc3kNxg5ApVuxBl+luyFi
        arG+wjuF4u4rd1Zb4rfggV7/tZjzgrM=
X-Google-Smtp-Source: ABdhPJxsAV1KsLam10OQrLQ3Mk1lzfy04OADsgT2PIWmgxVOee5D2EHoQAqFiUQHfbSsA2dOXD3LguvkztI=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a05:6a00:b8e:b0:4f7:c63c:f2fd with SMTP id
 g14-20020a056a000b8e00b004f7c63cf2fdmr4623111pfj.8.1647238936995; Sun, 13 Mar
 2022 23:22:16 -0700 (PDT)
Date:   Sun, 13 Mar 2022 23:19:56 -0700
Message-Id: <20220314061959.3349716-1-reijiw@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v4 0/3] KVM: arm64: mixed-width check should be skipped for
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
        Peng Liang <liangpeng10@huawei.com>,
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

Patch-1 introduces a new field 'flags' for kvm_arch (authored by Marc [1]).
The flags will replace a set of booleans for VM features.

Patch-2 introduces KVM_ARCH_FLAG_EL1_32BIT and
KVM_ARCH_FLAG_REG_WIDTH_CONFIGURED bits for kvm->arch.flags and
uses them to check vcpu's register width to fix the problem.

Patch-3 introduces a selftest that can test non-mixed-width vCPUs (all
64bit vCPUs or all 32bit vcPUs) can be configured, and mixed-width
vCPUs cannot be configured.

The series is based on v5.17-rc7.

v4:
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

Marc Zyngier (1):
  KVM: arm64: Generalise VM features into a set of flags

Reiji Watanabe (2):
  KVM: arm64: mixed-width check should be skipped for uninitialized
    vCPUs
  KVM: arm64: selftests: Introduce vcpu_width_config

 arch/arm64/include/asm/kvm_emulate.h          |  27 ++--
 arch/arm64/include/asm/kvm_host.h             |  21 ++-
 arch/arm64/kvm/arm.c                          |   5 +-
 arch/arm64/kvm/mmio.c                         |   3 +-
 arch/arm64/kvm/reset.c                        |  64 ++++++---
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/aarch64/vcpu_width_config.c | 125 ++++++++++++++++++
 8 files changed, 209 insertions(+), 38 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/aarch64/vcpu_width_config.c

-- 
2.35.1.723.g4982287a31-goog

