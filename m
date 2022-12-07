Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C697C646363
	for <lists+kvm@lfdr.de>; Wed,  7 Dec 2022 22:48:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbiLGVsZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Dec 2022 16:48:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbiLGVsY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Dec 2022 16:48:24 -0500
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 574AF554EE
        for <kvm@vger.kernel.org>; Wed,  7 Dec 2022 13:48:23 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1670449701;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=16LMNcduUmJXQJNzhs+CPaMIYUMzlfOKY+rOo3K6LbQ=;
        b=u63UBWyhpAxMlem/etDv9iTa0u6y7HKmhxIez0MD8dedIZiU5ViY2yr9IXP3CuYiD3RfWe
        J/6c2HMI5Lq/sZ/WcKkd8IWu6JHyh4J0YjR4lmfLolPHXcfudpJ5PoxihxSG4TSDFBnt8l
        PNKkzvRIBpGlvjTvrx90ImyS1fcbAwg=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        Ricardo Koller <ricarkol@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 0/4] KVM: selftests: Fixes for ucall pool + page_fault_test
Date:   Wed,  7 Dec 2022 21:48:04 +0000
Message-Id: <20221207214809.489070-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

The combination of the pool-based ucall implementation + page_fault_test
resulted in some 'fun' bugs, not the least of which is that our handling
of the VA space on arm64 is completely wrong.

Small series to fix up the issues on kvm/queue. Patches 1-2 can probably
be squashed into Paolo's merge resolution, if desired.

Mark Brown (1):
  KVM: selftests: Fix build due to ucall_uninit() removal

Oliver Upton (3):
  KVM: selftests: Setup ucall after loading program into guest memory
  KVM: arm64: selftests: Align VA space allocator with TTBR0
  KVM: selftests: Allocate ucall pool from MEM_REGION_DATA

 .../selftests/kvm/aarch64/page_fault_test.c       |  9 +++++++--
 .../testing/selftests/kvm/include/kvm_util_base.h |  1 +
 .../testing/selftests/kvm/lib/aarch64/processor.c | 10 ++++++++++
 tools/testing/selftests/kvm/lib/kvm_util.c        | 15 ++++++++++-----
 tools/testing/selftests/kvm/lib/ucall_common.c    |  2 +-
 5 files changed, 29 insertions(+), 8 deletions(-)

-- 
2.39.0.rc0.267.gcb52ba06e7-goog

