Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F185A597935
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 23:50:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242431AbiHQVtd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Aug 2022 17:49:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238964AbiHQVtS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Aug 2022 17:49:18 -0400
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4177ADCDF
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 14:48:39 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1660772917;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=cDVlBOelWFV15LvLWa+pCIh5Az2QchuTMm2O7H0MfZk=;
        b=puD8I3PkQRNayksEy0wOfU5b0YzxoKZaMjrXlFl+3KOT9ZugR1UJ41zWBQ4rIUp7WgJmYP
        zer8g0/Qivf8EkqpyOrgj/kSI9u4kcW+RqBS5h0Sw26FxOJKXuml5SvL9BIxtorjjBp7Ck
        3/FsLgpUpC7mZFkmblRFxfhBznj563c=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        maz@kernel.org, james.morse@arm.com, alexandru.elisei@arm.com,
        suzuki.poulose@arm.com, will@kernel.org,
        Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 0/6] KVM: arm64: Treat 32bit ID registers as RAZ/WI on 64bit-only system
Date:   Wed, 17 Aug 2022 21:48:12 +0000
Message-Id: <20220817214818.3243383-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
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

Patches 1-2 clean up some of the ID register accessors, taking advantage
of the fact that the generic ones already know how to handle RAZ
registers.

Patches 3-4 wire in a new visibility bit to indicate a register ignores
writes from userspace.

Patch 5 moves all exposed 32-bit ID registers to have RAZ/WI behavior on
64-bit only systems. Note that hidden 32-bit registers continue to have
RAZ behavior and carry the additional requirement of invariance.

Lastly, patch 6 tests that userspace and guest indeed see the registers
as RAZ/WI.

Applies to 6.0-rc1 + the mismatched system fixes [2] picked up earlier
today. Tested on the fast model, both with mismatched AArch32 support
and no AArch32 support whatoever.

[1]: DDI0487H.a Table D12-2 'Instruction encodings for non-Debug System Register accesses'
[2]: https://lore.kernel.org/kvmarm/20220816192554.1455559-1-oliver.upton@linux.dev/

Oliver Upton (6):
  KVM: arm64: Use visibility hook to treat ID regs as RAZ
  KVM: arm64: Remove internal accessor helpers for id regs
  KVM: arm64: Spin off helper for calling visibility hook
  KVM: arm64: Add a visibility bit to ignore user writes
  KVM: arm64: Treat 32bit ID registers as RAZ/WI on 64bit-only system
  KVM: selftests: Add test for RAZ/WI AArch32 ID registers

 arch/arm64/kvm/sys_regs.c                     | 137 +++++++++---------
 arch/arm64/kvm/sys_regs.h                     |  24 ++-
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../kvm/aarch64/aarch64_only_id_regs.c        | 135 +++++++++++++++++
 5 files changed, 222 insertions(+), 76 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/aarch64/aarch64_only_id_regs.c

-- 
2.37.1.595.g718a3a8f04-goog

