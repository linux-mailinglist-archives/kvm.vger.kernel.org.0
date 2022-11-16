Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23D9762C596
	for <lists+kvm@lfdr.de>; Wed, 16 Nov 2022 17:57:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbiKPQ5T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Nov 2022 11:57:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238946AbiKPQ5M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Nov 2022 11:57:12 -0500
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9FFB3BA
        for <kvm@vger.kernel.org>; Wed, 16 Nov 2022 08:57:10 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1668617829;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=TdFPell1GyLBX2SIEk5RntQAA4Vog6nIAXIY95c98cY=;
        b=SOKzPo9L8c2aAODZKx24AXi3Um/xxFEqfqF+qClyOQk8l/W5JKOLZSoadwrDaURh9kKj7g
        R1EvOLI2gkz/G1vwxqkqABx1MOHaD9pxY1A3tpAVN93p2TWFicEUs7mPkhMdgKji4JOrCH
        of38SMfEsMvBHuPjfeI5HhspUIrtvwE=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        Will Deacon <will@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 0/2] KVM: arm64: Fixes for parallel faults series
Date:   Wed, 16 Nov 2022 16:56:53 +0000
Message-Id: <20221116165655.2649475-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Small set of fixes for the parallel faults series. Most importantly,
stop taking the RCU read lock for walking hyp stage-1. For the sake of
consistency, take a pointer to kvm_pgtable_walker in
kvm_dereference_pteref() as well.

Tested on an Ampere Altra system with kvm-arm.mode={nvhe,protected}.
Applies to the parallel faults series picked up last week.

v2: https://lore.kernel.org/kvmarm/20221115225502.2240227-1-oliver.upton@linux.dev/

v2 -> v3:
 - Pass a pointer to the walker instead of a bool (Marc)
 - Apply the aforementioned change to kvm_dereference_pteref()

Oliver Upton (2):
  KVM: arm64: Take a pointer to walker data in kvm_dereference_pteref()
  KVM: arm64: Don't acquire RCU read lock for exclusive table walks

 arch/arm64/include/asm/kvm_pgtable.h | 154 +++++++++++++++------------
 arch/arm64/kvm/hyp/pgtable.c         |  10 +-
 2 files changed, 88 insertions(+), 76 deletions(-)

-- 
2.38.1.431.g37b22c650d-goog

