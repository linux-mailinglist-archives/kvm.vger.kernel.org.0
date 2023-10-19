Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34EB07D0226
	for <lists+kvm@lfdr.de>; Thu, 19 Oct 2023 20:56:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346232AbjJSS4e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Oct 2023 14:56:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345973AbjJSS4c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Oct 2023 14:56:32 -0400
Received: from out-196.mta0.migadu.com (out-196.mta0.migadu.com [IPv6:2001:41d0:1004:224b::c4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1B9193
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 11:56:30 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1697741789;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=i94PANWETdPAR98nH+gCNOlHJvzUuTkQZVQCN2pXeh8=;
        b=Fz7SwHOhWpllGaMiiYAuz+EBE53qR/YLysMhFuKrghQEiUpzk7B941jn70BLgC7BS1kbg5
        P0Q+0FNST5BkRiSC2ORXvkq0NrEtTp9JzWo23fjoNfZ+BhxQYV9sZVWmj8BnuH36ZdOOga
        EICGD84LA4Dib/ApJ6MrL6FgHsuuYuE=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 0/2] KVM: arm64: PMU event filtering fixes
Date:   Thu, 19 Oct 2023 18:56:16 +0000
Message-ID: <20231019185618.3442949-1-oliver.upton@linux.dev>
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

PMU event exception level filtering fixes

Fixes to KVM's handling of the PMUv3 exception level filtering bits:

 - NSH (count at EL2) and M (count at EL3) should be stateful when the
   respective EL is advertised in the ID registers but have no effect on
   event counting.

 - NSU and NSK modify the event filtering of EL0 and EL1, respectively.
   Though the kernel may not use these bits, other KVM guests might.
   Implement these bits exactly as written in the pseudocode if EL3 is
   advertised.

v2: https://lore.kernel.org/kvmarm/20231013052901.170138-1-oliver.upton@linux.dev/

v2 -> v3:
 - Make the bits conditional on the ID register values
 - Allow the guest to set the M and NSH bits without effect (Marc)

Oliver Upton (2):
  KVM: arm64: Make PMEVTYPER<n>_EL0.NSH RES0 if EL2 isn't advertised
  KVM: arm64: Add PMU event filter bits required if EL3 is implemented

 arch/arm64/kvm/pmu-emul.c      | 36 +++++++++++++++++++++++++---------
 arch/arm64/kvm/sys_regs.c      |  8 ++++++--
 include/kvm/arm_pmu.h          |  5 +++++
 include/linux/perf/arm_pmuv3.h |  9 ++++++---
 4 files changed, 44 insertions(+), 14 deletions(-)


base-commit: 6465e260f48790807eef06b583b38ca9789b6072
-- 
2.42.0.655.g421f12c284-goog

