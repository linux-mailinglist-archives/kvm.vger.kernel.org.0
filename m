Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 448D85AB5C8
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 17:54:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237455AbiIBPyV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 11:54:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237541AbiIBPxv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 11:53:51 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1872B57565
        for <kvm@vger.kernel.org>; Fri,  2 Sep 2022 08:48:16 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1662133694;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=IFb0nw1kmQc9o54dv6z8DN+QQpTAUMEEVUEkFaEPX18=;
        b=ZVELD/JOd3tkB4ZVOrh91thYGAv273RtRfM8U4a1xvnsTh8fg82X/hhVR/juYQQSlvTpht
        sHzc4GMiwRdicxUlACT2dFnkTzr+GbNdx7TDyw5qtjuyspFVxP0cxEKJY3cudO5gkFm5xc
        KHcAuJnhNzbqg8eyUCm+6ENTCD8SZwE=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Reiji Watanabe <reijiw@google.com>,
        Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 0/7] KVM: arm64: Use visibility hook to treat ID regs as RAZ
Date:   Fri,  2 Sep 2022 15:47:56 +0000
Message-Id: <20220902154804.1939819-1-oliver.upton@linux.dev>
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
  KVM: selftests: Add test for RAZ/WI AArch32 ID registers

 arch/arm64/kvm/sys_regs.c                     | 150 +++++++++---------
 arch/arm64/kvm/sys_regs.h                     |  24 ++-
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../kvm/aarch64/aarch64_only_id_regs.c        | 135 ++++++++++++++++
 5 files changed, 225 insertions(+), 86 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/aarch64/aarch64_only_id_regs.c


base-commit: b90cb1053190353cc30f0fef0ef1f378ccc063c5
-- 
2.37.2.789.g6183377224-goog

