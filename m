Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5013B62FC81
	for <lists+kvm@lfdr.de>; Fri, 18 Nov 2022 19:23:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242643AbiKRSXF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Nov 2022 13:23:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242731AbiKRSWh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Nov 2022 13:22:37 -0500
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1004B7DEC8
        for <kvm@vger.kernel.org>; Fri, 18 Nov 2022 10:22:34 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1668795752;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=X3QgCq9Cs1WQYoJL0dvRfozZCN58kkuvkY3dlbpQxA0=;
        b=lNR7BG2xlqj9DA3KvAaQJbfmbXR8ph56cTV2x9m89DaPyumgHHR9/DGSNBKAvckoa0b6Pp
        UuDMc2gPhsNp+XbYnttyuhGhZMPnLOYzmcYsbalOM2noVK3bZ7f0fHCPves1FwYShNimdp
        tFDjE/qc/9BtPLR32uCBbZu2VNneSdg=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        Will Deacon <will@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v4 0/3] KVM: arm64: Fixes for parallel faults series
Date:   Fri, 18 Nov 2022 18:22:19 +0000
Message-Id: <20221118182222.3932898-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Small set of fixes for the parallel faults series. Most importantly,
stop taking the RCU read lock for walking hyp stage-1. For the sake of
consistency, take a pointer to kvm_pgtable_walker in
kvm_dereference_pteref() as well.

Tested on an Ampere Altra system with kvm-arm.mode={nvhe,protected} and
lockdep. Applies on top of the parallel faults series picked up last
week.

v3: https://lore.kernel.org/kvmarm/20221116165655.2649475-1-oliver.upton@linux.dev/

v3 -> v4:
 - Return an error instead of WARN() in hyp for shared walks (Will)

Oliver Upton (3):
  KVM: arm64: Take a pointer to walker data in kvm_dereference_pteref()
  KVM: arm64: Don't acquire RCU read lock for exclusive table walks
  KVM: arm64: Reject shared table walks in the hyp code

 arch/arm64/include/asm/kvm_pgtable.h | 159 +++++++++++++++------------
 arch/arm64/kvm/hyp/pgtable.c         |  13 ++-
 2 files changed, 96 insertions(+), 76 deletions(-)

-- 
2.38.1.584.g0f3c55d4c2-goog

