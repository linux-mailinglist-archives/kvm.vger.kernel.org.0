Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50CE15B6B05
	for <lists+kvm@lfdr.de>; Tue, 13 Sep 2022 11:44:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231378AbiIMJo4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Sep 2022 05:44:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231599AbiIMJoz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Sep 2022 05:44:55 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 978ADE021
        for <kvm@vger.kernel.org>; Tue, 13 Sep 2022 02:44:52 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1663062290;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=KxRL7D9m29hUiUTS4dxIxei/v3WjORArYpVDuknUprY=;
        b=I4N2H8wz/zJQGBqTo0ob43uuTm7abg5Uld1HFUnzo7Cl6zCxA17KpWVsWqKvl3BNdasgid
        Fiv8Y5My5cyPYrAf8gFOfcX5Kq6NJC1/svYhF7usaBgqIk8Lba7MZtcHXI337aoHRxG5lx
        L5iBJojrwJvhywU3NKrTtIo2lvPEVUQ=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Reiji Watanabe <reijiw@google.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 0/7] KVM: arm64: Use visibility hook to treat ID regs as RAZ
Date:   Tue, 13 Sep 2022 09:44:33 +0000
Message-Id: <20220913094441.3957645-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For reasons unknown, the Arm architecture defines the 64-bit views of
the 32-bit ID registers as UNKNOWN [1]. This combines poorly with the
fact that KVM unconditionally exposes these registers to userspace,
which could throw a wrench in migration between 64-bit only systems.

This series reworks KVM's definition of these registers to RAZ/WI with
the goal of providing consistent register values across 64-bit machines.

Patches 1-3 clean up the ID register accessors, taking advantage of the
fact that the generic accessors know how to handle RAZ.

Patches 4-6 start switch the handling of potentially nonzero AArch32 ID
registers to RAZ/WI. RAZ covers up the architecturally UNKNOWN values,
and WI allows for migration off of kernels that may provide garbage.
Note that hidden AArch32 ID registers continue to have RAZ behavior with
the additional expectation of invariance.

Lastly, patch 7 includes a small test for the issue.

Applies to 6.0-rc3. Tested with KVM selftests under the fast model w/
asymmetric 32 bit support and no 32 bit support whatsoever.

[1]: DDI0487H.a Table D12-2 'Instruction encodings for non-Debug System Register accesses'

v2: https://lore.kernel.org/kvmarm/20220902154804.1939819-1-oliver.upton@linux.dev/

v2 -> v3:
 - Collect more of Reiji's r-bs (thanks again!)
 - Test the RAZ+invariant registers (AFR0, DFR1, unallocated AA32 ID
   registers) (Drew)
 - Give the selftest a more sensible name

v1 -> v2:
 - Collect Reiji's r-b tags (thanks!)
 - Call sysreg_visible_as_raz() from read_id_reg() (Reiji)
 - Hoist sysreg_user_write_ignore() into kvm_sys_reg_set_user() (Reiji)

Oliver Upton (7):
  KVM: arm64: Use visibility hook to treat ID regs as RAZ
  KVM: arm64: Remove internal accessor helpers for id regs
  KVM: arm64: Drop raz parameter from read_id_reg()
  KVM: arm64: Spin off helper for calling visibility hook
  KVM: arm64: Add a visibility bit to ignore user writes
  KVM: arm64: Treat 32bit ID registers as RAZ/WI on 64bit-only system
  KVM: selftests: Add test for AArch32 ID registers

 arch/arm64/kvm/sys_regs.c                     | 150 ++++++++--------
 arch/arm64/kvm/sys_regs.h                     |  24 ++-
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/aarch64/aarch32_id_regs.c   | 169 ++++++++++++++++++
 5 files changed, 259 insertions(+), 86 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/aarch64/aarch32_id_regs.c


base-commit: b90cb1053190353cc30f0fef0ef1f378ccc063c5
-- 
2.37.2.789.g6183377224-goog

