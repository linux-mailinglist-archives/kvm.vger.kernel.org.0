Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D30363C82B
	for <lists+kvm@lfdr.de>; Tue, 29 Nov 2022 20:21:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236768AbiK2TVP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 14:21:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236766AbiK2TUa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 14:20:30 -0500
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A0AE6CA0E
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 11:19:55 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1669749594;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=m0zZd4zUCb269/4WV/qmecpcPiXCIRgs1aacjO8LrGw=;
        b=pTlOrQHeV71gskFasm8wtT0s3vuYrWAs+URI7fzmgoko+UIiq4S4zJWYjZfDakZdKkZElj
        yyw5IKaB9OxuLLZktZ7xNwOu3DrtQdoo8xaftF8FXMCt9KrdFvc1Rj0BGTzMsSUDQRLUvn
        A/6zW4QHCMlhCcGwKnVVDL/0DAM5k6U=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 0/4] KVM: arm64: Parallel access faults
Date:   Tue, 29 Nov 2022 19:19:42 +0000
Message-Id: <20221129191946.1735662-1-oliver.upton@linux.dev>
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

When I implemented the parallel faults series I was mostly focused on
improving the performance of 8.1+ implementations which bring us
FEAT_HAFDBS. In so doing, I failed to put access faults on the read side
of the MMU lock.

Anyhow, this small series adds support for handling access faults in
parallel, piling on top of the infrastructure from the first parallel
faults series. As most large systems I'm aware of are 8.1+ anyway, I
don't expect this series to provide significant uplift beyond some
oddball machines Marc has lying around. Don't get me wrong, I'd love to
have a D05 to play with too...

Patches 1-3 are the significant portion of the series, and patch 4 was
used to test on an Ampere Altra system by guarding VTCR_EL2.HA with the
kernel's Kconfig option for FEAT_HAFDBS. I've included it as I find it
helpful for testing on newer hardware. Having said that, I won't throw a
fit if it gets dropped either.

Applies to kvmarm/next due to the dependency on the larger parallel
faults series. Tested on Ampere Altra w/ VTCR_EL2.HA=0 as well as a
Raspberry Pi 4.

Oliver Upton (4):
  KVM: arm64: Use KVM's pte type/helpers in handle_access_fault()
  KVM: arm64: Don't serialize if the access flag isn't set
  KVM: arm64: Handle access faults behind the read lock
  KVM: arm64: Condition HW AF updates on config option

 arch/arm64/include/asm/kvm_pgtable.h |  5 +++++
 arch/arm64/kvm/hyp/pgtable.c         | 12 +++++++++---
 arch/arm64/kvm/mmu.c                 | 14 ++++++--------
 3 files changed, 20 insertions(+), 11 deletions(-)


base-commit: 456ce3545dd06700df7fe82173a06b369288bcef
-- 
2.38.1.584.g0f3c55d4c2-goog

