Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 370FD5BB52F
	for <lists+kvm@lfdr.de>; Sat, 17 Sep 2022 03:06:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbiIQBGO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Sep 2022 21:06:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbiIQBGM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Sep 2022 21:06:12 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05150A3D06
        for <kvm@vger.kernel.org>; Fri, 16 Sep 2022 18:06:12 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id n85-20020a254058000000b006b0148d96f7so8258191yba.2
        for <kvm@vger.kernel.org>; Fri, 16 Sep 2022 18:06:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date;
        bh=FPmIZ20vcTUeBFUMKdaLzmUVq8vMch7/heQIwOJWf6I=;
        b=tAFTWGiHh8oW2k7UJWEM5Y3bG6bkwLfnpOBuOdCuxk+rZNbmhhM1l8IU4cBn4WFKrb
         f+bB///QmF1d/7+xnOluIe6aNNzsU/lygE9MKZ4u5pHcwCw01d1aCJb/eoO1IAQizUT1
         6U32afXpbaY8kj719kzrUygp/nfRYIjZ49AaIQimpwnLpBydSoAhrYNGHWF7BDK+beNY
         3wc+w1VqMEwZgog2px86mTYdBFIMt91uyhZLoqfnUawrlKGjR6xLgPAUPmuK2glEmm3u
         zEij4qYIZUMQyO+6hI7HsBWaQ/MSXHMgD1vc6NGkoxA3wz4TLKzIJUoeMbADXFusTCs1
         u5lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date;
        bh=FPmIZ20vcTUeBFUMKdaLzmUVq8vMch7/heQIwOJWf6I=;
        b=SKIWKZU3HdfGY5nm0cLqq7tnbTaflUQL3wdBoyjK7afRTtXHSt7zXcmPIicHKRkrMK
         CvYPb1hilzwmBbY215Jdnudy9718N2PszfjzcYyQ48K6Kaomj59PMWRKsFT/ji4c4Zsh
         y662bxlRf9AMMqa4u4XtBVzQH/v9IwyqoqQONnhRR2VvBx4KZJ/zflIww5sI6viCxUih
         t2Ql91JSN2YaUTaL44/icEAzAxxm8pRri9M0KGQ1Rb/C2AzSbNK39ziRK9VYI3XSFNIn
         8sQKEM+a1SOB0OL3uTiy41m70GSr5KTvDywrcqFdaQ3CVnlL2/MsnzrKfPCiJfGeuMkK
         pS5g==
X-Gm-Message-State: ACrzQf1HOBK3mktzp+KjAxLeOmZMiAIac0s6IWjHzRbQ8qCElewsP4Xf
        e29oCwrsFyoiAlh2hTPGtITa5oYDcfA=
X-Google-Smtp-Source: AMsMyM7+y1N9+gTgvFSbs1C1oHCJr2OfSIB0qnRQXA92Ps+jtzT3rtMrAlli+ZateJjndneNoW56QwXzWzI=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a25:8c07:0:b0:6af:ef09:be31 with SMTP id
 k7-20020a258c07000000b006afef09be31mr6435316ybl.285.1663376770905; Fri, 16
 Sep 2022 18:06:10 -0700 (PDT)
Date:   Fri, 16 Sep 2022 18:05:56 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220917010600.532642-1-reijiw@google.com>
Subject: [PATCH v2 0/4] KVM: arm64: Fix bugs of single-step execution enabled
 by userspace
From:   Reiji Watanabe <reijiw@google.com>
To:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series fixes two bugs of single-step execution enabled by
userspace, and add a test case for KVM_GUESTDBG_SINGLESTEP to
the debug-exception test to verify the single-step behavior.

Patch 1 fixes a bug that KVM might unintentionally change PSTATE.SS
for the guest when single-step execution is enabled for the vCPU by
userspace.

Patch 2 fixes a bug that KVM could erroneously perform an extra
single step (without returning to userspace) due to setting PSTATE.SS
to 1 on every guest entry, when single-step execution is enabled for
the vCPU by userspace.

Patch 3-4 adds a test for KVM_GUESTDBG_SINGLESTEP to the
debug-exception test to verify the single-step behavior.

The series is based on 6.0-rc5.

v2:
 - Change kvm_handle_guest_debug() to use switch/case statement [Marc]
 - Clear PSTATE.SS on guest entry if the Software step state at the
   last guest exit was "Active-pending" to make DBG_SS_ACTIVE_PENDING
   and PSTATE.SS consistent [Marc]
 - Add a fix to preserve PSTATE.SS for the guest.

v1: https://lore.kernel.org/all/20220909044636.1997755-1-reijiw@google.com/

Reiji Watanabe (4):
  KVM: arm64: Preserve PSTATE.SS for the guest while single-step is
    enabled
  KVM: arm64: Clear PSTATE.SS when the Software Step state was
    Active-pending
  KVM: arm64: selftests: Refactor debug-exceptions to make it amenable
    to new test cases
  KVM: arm64: selftests: Add a test case for KVM_GUESTDBG_SINGLESTEP

 arch/arm64/include/asm/kvm_host.h             |   4 +
 arch/arm64/kvm/debug.c                        |  34 +++-
 arch/arm64/kvm/guest.c                        |   1 +
 arch/arm64/kvm/handle_exit.c                  |   8 +-
 .../selftests/kvm/aarch64/debug-exceptions.c  | 149 +++++++++++++++++-
 5 files changed, 190 insertions(+), 6 deletions(-)


base-commit: 80e78fcce86de0288793a0ef0f6acf37656ee4cf
-- 
2.37.3.968.ga6b4b080e4-goog

