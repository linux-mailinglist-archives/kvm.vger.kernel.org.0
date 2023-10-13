Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 293D77C7CFE
	for <lists+kvm@lfdr.de>; Fri, 13 Oct 2023 07:29:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229532AbjJMF3R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Oct 2023 01:29:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjJMF3Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Oct 2023 01:29:16 -0400
Received: from out-198.mta0.migadu.com (out-198.mta0.migadu.com [91.218.175.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 033CEB7
        for <kvm@vger.kernel.org>; Thu, 12 Oct 2023 22:29:14 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1697174953;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=pU59iCAJ9xZuR3YWe8jYQ/I5AINYiPC0z4MP25i1zF0=;
        b=s7Z4VTmgzOsDFqiwVECfHXmDqrvqgi+fE/gn6b3ezdguPIosPNLdHbl0iciKkcjkTJC1u9
        iXxb11d69xkP26Euc6267dn3ZvSqVwCCuTYSjJg2UBPHYVtx2hGAN/mrqz5UgbIN3u1E05
        BflllugjG3LcAmbn42nvOwrcDZiBEPg=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 0/2] KVM: arm64: PMU event filtering fixes
Date:   Fri, 13 Oct 2023 05:28:59 +0000
Message-ID: <20231013052901.170138-1-oliver.upton@linux.dev>
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

Set of fixes to KVM's handling of the exception level event filtering in
the PMU event type registers.

I dropped the PMU+NV disablement this time around as we need a complete
fix for that problem. At the same time, I want to get a rework of our
sysreg masks upstream soon to avoid any negative interaction with new
PMU features going in on the driver side of things.

Additionally, I added a fix for the non-secure filtering bits that
Suzuki had spotted (thanks!)

Oliver Upton (2):
  KVM: arm64: Treat PMEVTYPER<n>_EL0.NSH as RES0
  KVM: arm64: Virtualise PMEVTYPER<n>_EL1.{NSU,NSK}

 arch/arm64/kvm/pmu-emul.c      | 26 +++++++++++++++++---------
 arch/arm64/kvm/sys_regs.c      |  8 ++++++--
 include/kvm/arm_pmu.h          |  5 +++++
 include/linux/perf/arm_pmuv3.h |  8 +++++---
 4 files changed, 33 insertions(+), 14 deletions(-)


base-commit: 6465e260f48790807eef06b583b38ca9789b6072
-- 
2.42.0.655.g421f12c284-goog

