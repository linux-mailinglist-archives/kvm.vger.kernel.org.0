Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D6487C4CE0
	for <lists+kvm@lfdr.de>; Wed, 11 Oct 2023 10:17:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230177AbjJKIRT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Oct 2023 04:17:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbjJKIRS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Oct 2023 04:17:18 -0400
Received: from out-205.mta1.migadu.com (out-205.mta1.migadu.com [IPv6:2001:41d0:203:375::cd])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10E8E92
        for <kvm@vger.kernel.org>; Wed, 11 Oct 2023 01:17:14 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1697012232;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=1hHZDVIa3yDoGKax+wmO5RAUIx6mrtYgB/XXBr+eb8Y=;
        b=uFEnhuM+BGPf1YuGb9CPn2gfCts1MbrrWNExCJpBpN9lmXEkzzSeBEmbda8Bek4yNGGXwc
        iRGPh1cLkFxLaTI7jXUK1mcchyzX43L1B9Fkk/dnWklAFzwBQJfkgNpcIDzTzUsjG+BVke
        3b3JL800ai1t79zg2Eu3br0fx0wUmLA=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will@kernel.org>,
        James Clark <james.clark@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 0/2] KVM: arm64: vPMU fixes for NV/EL2
Date:   Wed, 11 Oct 2023 08:16:46 +0000
Message-ID: <20231011081649.3226792-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM allows userspace to select both the vPMU and NV feature flags, which
is an absolute no-go since we do not handle any of the EL2 controls.
Furthermore, our sysreg emulation allows the guest to set the NSH bit
responsible for counting events at EL2 despite the fact it does
absolutely nothing.

Series to address the both of these issues. While neither of them are
really a big deal at the moment, the second patch is relevant to James
C's PMU event threshold series [*].

[*] https://lore.kernel.org/kvmarm/20231010141551.2262059-1-james.clark@arm.com/

Oliver Upton (2):
  KVM: arm64: Disallow vPMU for NV guests
  KVM: arm64: Treat PMEVTYPER<n>_EL0.NSH as RES0

 arch/arm64/kvm/arm.c      | 5 +++--
 arch/arm64/kvm/pmu-emul.c | 3 +--
 2 files changed, 4 insertions(+), 4 deletions(-)

-- 
2.42.0.609.gbb76f46606-goog

