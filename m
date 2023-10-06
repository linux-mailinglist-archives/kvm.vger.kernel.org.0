Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DCBB7BB450
	for <lists+kvm@lfdr.de>; Fri,  6 Oct 2023 11:36:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231429AbjJFJgR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Oct 2023 05:36:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbjJFJgQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Oct 2023 05:36:16 -0400
Received: from out-190.mta1.migadu.com (out-190.mta1.migadu.com [95.215.58.190])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ED5ED6
        for <kvm@vger.kernel.org>; Fri,  6 Oct 2023 02:36:14 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1696584973;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=4L7QKCIOuLwlmI4f8DHHeZCgEjiZggyjVQSyHHX4IiA=;
        b=qMeeXG8mB1qR2yjfqx1xXD732ta9yS/cPbDc9TeN/AVUWPhDCMZSIlgX1MakvBLDyryMy9
        0J7SmC3adV18e1/18temoN8nd8dKsxjp94L3sq1AwrYN313fVnmKbhYtaHweZu0pZJ/kOJ
        YNQg7P5WUTEQTzmAbIoRXl6BVvm/Hsw=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 0/3] KVM: arm64: Load the stage-2 MMU from vcpu_load() for VHE
Date:   Fri,  6 Oct 2023 09:35:57 +0000
Message-ID: <20231006093600.1250986-1-oliver.upton@linux.dev>
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

Unlike nVHE, there is no need to switch the stage-2 MMU around on guest
entry/exit in VHE mode as the host is running at EL2. Despite this KVM
reloads the stage-2 on every guest entry, which is needless.

This series moves the setup of the stage-2 MMU context to vcpu_load()
when running in VHE mode. This is likely to be a win across the board,
but also allows us to remove an ISB on the guest entry path for systems
with one of the speculative AT errata.

None of my machines affected by the AT errata are VHE-capable, so it'd
be appreciated if someone could give this series a go and make sure I
haven't wrecked anything.

Oliver Upton (3):
  KVM: arm64: Don't zero VTTBR in __tlb_switch_to_host()
  KVM: arm64: Rename helpers for VHE vCPU load/put
  KVM: arm64: Load the stage-2 MMU context in kvm_vcpu_load_vhe()

 arch/arm64/include/asm/kvm_host.h  |  4 ++--
 arch/arm64/include/asm/kvm_hyp.h   |  2 ++
 arch/arm64/kvm/arm.c               |  4 ++--
 arch/arm64/kvm/hyp/vhe/switch.c    | 33 ++++++++++++++++++------------
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c | 11 ++++------
 arch/arm64/kvm/hyp/vhe/tlb.c       |  1 -
 6 files changed, 30 insertions(+), 25 deletions(-)


base-commit: 6465e260f48790807eef06b583b38ca9789b6072
-- 
2.42.0.609.gbb76f46606-goog

