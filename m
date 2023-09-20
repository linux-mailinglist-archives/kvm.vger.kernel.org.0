Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 546147A8D1D
	for <lists+kvm@lfdr.de>; Wed, 20 Sep 2023 21:50:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbjITTuz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Sep 2023 15:50:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjITTuy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Sep 2023 15:50:54 -0400
Received: from out-220.mta0.migadu.com (out-220.mta0.migadu.com [91.218.175.220])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2E5BD7
        for <kvm@vger.kernel.org>; Wed, 20 Sep 2023 12:50:47 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1695239445;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=u36CLFE7Of0P0rwCIt+hVWkI368S5yyzMyNNtCtqKEQ=;
        b=PjY68ibaZR2B7bCRmBSaK1GhcVuPiNjntzaizKAPMVDKtc0KnMIPg/p7wMDemRfl1xVPMZ
        M4riS/Zg+F1CvWUfaIZfgRFECgU3+L7DYnBjhkxV12le6ZWQga1ah1sJ6+J5ZRd/ESCqFt
        oQGoWGvDHdahDDLT4zd15LAImfGl0Nc=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 0/8] KVM: arm64: Cleanup + fix to vCPU reset, feature flags
Date:   Wed, 20 Sep 2023 19:50:28 +0000
Message-ID: <20230920195036.1169791-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The way we do vCPU feature flag checks is a bit of a scattered mess
between the KVM_ARM_VCPU_INIT ioctl handler and kvm_reset_vcpu(). Let's
move all the feature flag checks up into the ioctl() handler to
eliminate failure paths from kvm_reset_vcpu(), as other usage of this
function no not handle returned errors.

Nobody screamed about the VM-wide feature flag change, so its also a
good time to rip out the vestiges of the vCPU-scoped bitmap.

I also spotted a bug with the NV feature flag where we allow it
regardless of system support.

Oliver Upton (8):
  KVM: arm64: Add generic check for system-supported vCPU features
  KVM: arm64: Hoist PMUv3 check into KVM_ARM_VCPU_INIT ioctl handler
  KVM: arm64: Hoist SVE check into KVM_ARM_VCPU_INIT ioctl handler
  KVM: arm64: Hoist PAuth checks into KVM_ARM_VCPU_INIT ioctl
  KVM: arm64: Prevent NV feature flag on systems w/o nested virt
  KVM: arm64: Hoist NV+SVE check into KVM_ARM_VCPU_INIT ioctl handler
  KVM: arm64: Remove unused return value from kvm_reset_vcpu()
  KVM: arm64: Get rid of vCPU-scoped feature bitmap

 arch/arm64/include/asm/kvm_emulate.h | 13 +++---
 arch/arm64/include/asm/kvm_host.h    |  5 +--
 arch/arm64/include/asm/kvm_nested.h  |  3 +-
 arch/arm64/kvm/arch_timer.c          |  4 +-
 arch/arm64/kvm/arm.c                 | 62 +++++++++++++++++++++-------
 arch/arm64/kvm/hypercalls.c          |  2 +-
 arch/arm64/kvm/reset.c               | 56 +++++--------------------
 include/kvm/arm_arch_timer.h         |  2 +-
 include/kvm/arm_pmu.h                |  2 +-
 include/kvm/arm_psci.h               |  2 +-
 10 files changed, 72 insertions(+), 79 deletions(-)


base-commit: ce9ecca0238b140b88f43859b211c9fdfd8e5b70
-- 
2.42.0.515.g380fc7ccd1-goog

