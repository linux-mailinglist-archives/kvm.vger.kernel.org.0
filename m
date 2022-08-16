Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D70659631B
	for <lists+kvm@lfdr.de>; Tue, 16 Aug 2022 21:26:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237165AbiHPT0L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Aug 2022 15:26:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237156AbiHPT0K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Aug 2022 15:26:10 -0400
Received: from out1.migadu.com (out1.migadu.com [91.121.223.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42932659EB
        for <kvm@vger.kernel.org>; Tue, 16 Aug 2022 12:26:09 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1660677967;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Qyb4P3aeu3kcSplqFQPf6DeNYTbLexPY2NVEpp1YSig=;
        b=LCbCsDpds/zG+Va7xHgoChxHXHa8DjiiGRazo1QLBulYW9xQfLToPoGcarurdlrzvJgTpt
        46OVyxAzuFiZBknosWlujn1sSL+OHdDKo3a1+m4GN5y54cxK5BSYjhHdakflruS7SQHXU+
        +VPuithtmqBASaYDnrJkRq+e6+PwX28=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        maz@kernel.org, james.morse@arm.com, alexandru.elisei@arm.com,
        suzuki.poulose@arm.com, will@kernel.org,
        Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 0/2] KVM: arm64: Uphold 64bit-only behavior on asymmetric systems
Date:   Tue, 16 Aug 2022 19:25:52 +0000
Message-Id: <20220816192554.1455559-1-oliver.upton@linux.dev>
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

Small series to fix a couple issues around when 64bit-only behavior is
applied. As KVM is more restrictive than the kernel in terms of 32bit
support (no asymmetry), we really needed our own predicate when the
meaning of system_supports_32bit_el0() changed in commit 2122a833316f
("arm64: Allow mismatched 32-bit EL0 support").

Lightly tested as I do not have any asymmetric systems on hand at the
moment. Attention on patch 2 would be appreciated as it affects ABI.

Applies to 6.0-rc1.

v1 -> v2:
 - Fix a silly logic inversion in vcpu_mode_is_bad_32bit()
 - Rebase to 6.0-rc1

Oliver Upton (2):
  KVM: arm64: Treat PMCR_EL1.LC as RES1 on asymmetric systems
  KVM: arm64: Reject 32bit user PSTATE on asymmetric systems

 arch/arm64/include/asm/kvm_host.h | 4 ++++
 arch/arm64/kvm/arm.c              | 3 +--
 arch/arm64/kvm/guest.c            | 2 +-
 arch/arm64/kvm/sys_regs.c         | 4 ++--
 4 files changed, 8 insertions(+), 5 deletions(-)


base-commit: 568035b01cfb107af8d2e4bd2fb9aea22cf5b868
-- 
2.37.1.595.g718a3a8f04-goog

