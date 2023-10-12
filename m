Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3427B7C782C
	for <lists+kvm@lfdr.de>; Thu, 12 Oct 2023 22:54:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442540AbjJLUyg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Oct 2023 16:54:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347397AbjJLUyf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Oct 2023 16:54:35 -0400
Received: from out-199.mta1.migadu.com (out-199.mta1.migadu.com [95.215.58.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDC599D
        for <kvm@vger.kernel.org>; Thu, 12 Oct 2023 13:54:33 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1697144072;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=hH/6ryfUc+/tIlTi+eA+fuz2bDwWb8WV0AB+9dQDmYI=;
        b=NedOA8L32M+cDyND6QvzqfqcnLdb3In0MFMQTGs+kTKZ3vW7Y7+Kqu+ah1HfZXmKvHctMJ
        3QmhxnhCYVw7c9KUufz4iJK5WTm5PWLvkwr6wviD258P6i2XvuVUqxKyN0HZOhRagHed05
        z15uuhYNsvocYxIyG1q2e3jfQEC9aCU=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 0/5] KVM: arm64: Load stage-2 in vcpu_load() on VHE
Date:   Thu, 12 Oct 2023 20:54:17 +0000
Message-ID: <20231012205422.3924618-1-oliver.upton@linux.dev>
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

Clearly my half-assed attempt at this series needed a bit of TLC.
Respinning with Marc's diff to make sure the stage-2 is in a consistent
state after VMID rollover and MMU notifiers triggering TLB invalidation.

v2: https://lore.kernel.org/kvmarm/20231006093600.1250986-1-oliver.upton@linux.dev/

Marc Zyngier (2):
  KVM: arm64: Restore the stage-2 context in VHE's
    __tlb_switch_to_host()
  KVM: arm64: Reload stage-2 for VMID change on VHE

Oliver Upton (3):
  KVM: arm64: Don't zero VTTBR in __tlb_switch_to_host()
  KVM: arm64: Rename helpers for VHE vCPU load/put
  KVM: arm64: Load the stage-2 MMU context in kvm_vcpu_load_vhe()

 arch/arm64/include/asm/kvm_host.h  |  6 +++---
 arch/arm64/include/asm/kvm_hyp.h   |  2 ++
 arch/arm64/kvm/arm.c               |  9 +++++---
 arch/arm64/kvm/hyp/vhe/switch.c    | 33 ++++++++++++++++++------------
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c | 11 ++++------
 arch/arm64/kvm/hyp/vhe/tlb.c       | 18 ++++++++++++----
 arch/arm64/kvm/vmid.c              | 11 +++++++---
 7 files changed, 57 insertions(+), 33 deletions(-)


base-commit: 6465e260f48790807eef06b583b38ca9789b6072
-- 
2.42.0.655.g421f12c284-goog

