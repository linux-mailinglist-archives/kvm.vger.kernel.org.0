Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4947B5F814F
	for <lists+kvm@lfdr.de>; Sat,  8 Oct 2022 01:42:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbiJGXmO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Oct 2022 19:42:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbiJGXmF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Oct 2022 19:42:05 -0400
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9CE3A98F7
        for <kvm@vger.kernel.org>; Fri,  7 Oct 2022 16:42:04 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1665186123;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=8gk76JRqjPqMzkfoKmXkwFy1NQbQ1ICsFcGyhsYU5J0=;
        b=v/KiVBTDrWvVn+101zSX+yMTklfcDfKoScD2vAnF13qg7YbpUTAe7yBbTpCiXRoBauVVq6
        u4QQyKsJyiZHkTVlzpoDMQoMyEwou6RWbcC1OnniQKHbu1HXKUNwF+xXqNFfUlc4wCga/N
        PJeClBh18muHjmvswN/3a9VXwgI940o=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Ricardo Koller <ricarkol@google.com>,
        David Matlack <dmatlack@google.com>,
        Quentin Perret <qperret@google.com>, kvmarm@lists.linux.dev,
        Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 0/2] KVM: arm64: Limit stage2_apply_range() batch size to largest block
Date:   Fri,  7 Oct 2022 23:41:49 +0000
Message-Id: <20221007234151.461779-1-oliver.upton@linux.dev>
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

Continuing with MMU patches to post, a small series fixing some soft
lockups caused by stage2_apply_range(). Depending on the paging setup,
we could walk a very large amount of memory before dropping the lock and
rescheduling.

Applies to kvmarm-6.1. Tested with KVM selftests and kvm-unit-tests with
all supported page sizes (4K, 16K, 64K). Additionally, I no longer saw
soft lockups with the following:

  ./dirty_log_perf_test -m -2 -s anonymous_thp -b 4G -v 48

v2: https://lore.kernel.org/kvmarm/20220926222146.661633-1-oliver.upton@linux.dev/

v2 -> v3:
 - Just use the largest block size as the batch size (Marc)

Oliver Upton (2):
  KVM: arm64: Work out supported block level at compile time
  KVM: arm64: Limit stage2_apply_range() batch size to largest block

 arch/arm64/include/asm/kvm_pgtable.h    | 18 +++++++++++++-----
 arch/arm64/include/asm/stage2_pgtable.h | 20 --------------------
 arch/arm64/kvm/mmu.c                    |  9 ++++++++-
 3 files changed, 21 insertions(+), 26 deletions(-)


base-commit: b302ca52ba8235ff0e18c0fa1fa92b51784aef6a
-- 
2.38.0.rc1.362.ged0d419d3c-goog

