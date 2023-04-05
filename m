Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2F3F6D8347
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 18:13:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232198AbjDEQNc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 12:13:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233686AbjDEQNZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 12:13:25 -0400
Received: from out-27.mta0.migadu.com (out-27.mta0.migadu.com [IPv6:2001:41d0:1004:224b::1b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3890A5590
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 09:12:58 -0700 (PDT)
Date:   Wed, 5 Apr 2023 09:12:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1680711173;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=7CkgZMZOVF7MbpZue7UsvX7LmMmfoQVPHzEDVenfrgw=;
        b=lcojLCqkONgW2SfBtg4a6NrQ3YjDDqXdKyYv4UAzFV1xRAgdzhwC4aiXEhAP13/vysW5ER
        FbKVqUI4qhrDjvr1Uew6BeHLbRkn0ibu2xSSfKveUeor4VjT3eiJl6nsLf2CRmNk/C7yCN
        G7A4GCArBLUM57KPGVdhPC75oYACwog=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, Fuad Tabba <tabba@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev,
        kvm@vger.kernel.org
Subject: [GIT PULL] KVM/arm64 fixes for 6.3, part #3
Message-ID: <ZC2eAXc9UE7Vesmn@thinky-boi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

Sending out what is likely the last batch of fixes for 6.3. Most
noteworthy is the PMU fix, as Reiji found that events counting in guest
userspace stopped working after live migration on VHE systems.
Additionally, Fuad found that pKVM was underselling the Spectre/Meltdown
mitigation state to protected VMs, so we have a fix for that too.

Also, FYI, Marc will reprise his role for the 6.4 kernel. Nothing is
set in stone but the working model is that we'll alternate the
maintainer duties each kernel release.

Please pull,

Oliver

The following changes since commit 8c2e8ac8ad4be68409e806ce1cc78fc7a04539f3:

  KVM: arm64: Check for kvm_vma_mte_allowed in the critical section (2023-03-16 23:42:56 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-6.3-3

for you to fetch changes up to e81625218bf7986ba1351a98c43d346b15601d26:

  KVM: arm64: Advertise ID_AA64PFR0_EL1.CSV2/3 to protected VMs (2023-04-04 15:52:06 +0000)

----------------------------------------------------------------
KVM/arm64 fixes for 6.3, part #3

 - Ensure the guest PMU context is restored before the first KVM_RUN,
   fixing an issue where EL0 event counting is broken after vCPU
   save/restore

 - Actually initialize ID_AA64PFR0_EL1.{CSV2,CSV3} based on the
   sanitized, system-wide values for protected VMs

----------------------------------------------------------------
Fuad Tabba (1):
      KVM: arm64: Advertise ID_AA64PFR0_EL1.CSV2/3 to protected VMs

Reiji Watanabe (1):
      KVM: arm64: PMU: Restore the guest's EL0 event counting after migration

 arch/arm64/kvm/arm.c                           | 26 +++++++++++++++++++++++++-
 arch/arm64/kvm/hyp/include/nvhe/fixed_config.h |  5 ++++-
 arch/arm64/kvm/hyp/nvhe/sys_regs.c             |  7 -------
 arch/arm64/kvm/pmu-emul.c                      |  1 +
 arch/arm64/kvm/sys_regs.c                      |  1 -
 5 files changed, 30 insertions(+), 10 deletions(-)
