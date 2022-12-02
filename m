Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD287640DDA
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 19:52:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233945AbiLBSwU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 13:52:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiLBSwP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 13:52:15 -0500
Received: from out-66.mta0.migadu.com (out-66.mta0.migadu.com [IPv6:2001:41d0:1004:224b::42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64874E2AB0
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 10:52:13 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1670007131;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=MpKufAjAF/g+30wBdMSCH1h9pcp+y/qwWl4scHSVwd4=;
        b=wcSk4Oflw5w66Zb3y27I3DVuLOMQIEX76IgGexKJezpSQlE5vmVXPET/3ip7LhrWnDFOd+
        FJ0GAe3PLG97aPbXwdKnt6bIMgiiNw5tjqCGKWTKKg09t/29Ba6u4EEr5oajOsQPc0BxHS
        7T/8dWxxJcOIM1fPgY3A8AXwuBTWajI=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 0/6] KVM: arm64: Parallel access faults
Date:   Fri,  2 Dec 2022 18:51:50 +0000
Message-Id: <20221202185156.696189-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When I implemented the parallel faults series I was mostly focused on
improving the performance of 8.1+ implementations which bring us
FEAT_HAFDBS. In so doing, I failed to put access faults on the read side
of the MMU lock.

Anyhow, this small series adds support for handling access faults in
parallel, piling on top of the infrastructure from the first parallel
faults series.

Patch 1 is a nit I had when working on this series.

Patches 2-4 improve the retry logic to avoid unnecessarily serializing
and/or invalidating when an attr walker has no effect on the page
tables due to a race.

I added a flag to indicate whether or not a table walk takes place
within a fault handler to decide whether or not an early return is
necessary for EAGAIN. We could probably pile even more onto this in the
future with lock contention and need_resched() detection.

Patch 5 rolls over access faults to the read lock.

Finally, patch 6 guards KVM's use of VTCR_EL2.HA with the corresponding
kernel config option for FEAT_HAFDBS. FWIW, it is rather useful for
testing access faults on systems that implement FEAT_HAFDBS.

Applies to kvmarm/next. Tested on Ampere Altra w/ VTCR_EL2.HA=0 and
lockdep enabled.

v1 -> v2:
 - Don't serialize if attr walker fails due to an invalid PTE (Ricardo)
 - Rejig the error handling path in the table walker to suppress EAGAIN
   in non-fault handling paths

v1: https://lore.kernel.org/kvmarm/20221129191946.1735662-1-oliver.upton@linux.dev

Oliver Upton (6):
  KVM: arm64: Use KVM's pte type/helpers in handle_access_fault()
  KVM: arm64: Ignore EAGAIN for walks outside of a fault
  KVM: arm64: Return EAGAIN for invalid PTE in attr walker
  KVM: arm64: Don't serialize if the access flag isn't set
  KVM: arm64: Handle access faults behind the read lock
  KVM: arm64: Condition HW AF updates on config option

 arch/arm64/include/asm/kvm_pgtable.h |  8 ++++++
 arch/arm64/kvm/hyp/pgtable.c         | 43 ++++++++++++++++++++++++----
 arch/arm64/kvm/mmu.c                 | 18 ++++++------
 3 files changed, 54 insertions(+), 15 deletions(-)


base-commit: edf3e6d30db78cc37bb57944b2255225aa73bbe8
-- 
2.39.0.rc0.267.gcb52ba06e7-goog

