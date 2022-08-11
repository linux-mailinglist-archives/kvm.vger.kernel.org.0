Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A8E0590590
	for <lists+kvm@lfdr.de>; Thu, 11 Aug 2022 19:15:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235881AbiHKRP4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Aug 2022 13:15:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236576AbiHKRPj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Aug 2022 13:15:39 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C330AC53
        for <kvm@vger.kernel.org>; Thu, 11 Aug 2022 10:02:34 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1660237353;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=aRu2Qz6xb8tRmhzinXW+uqzNL8wj7Il9t5HyZbqL6Tg=;
        b=SNu3vi3owseg596wltVqJROBlTin96X5tvt0yK/GkSaYWcOt6/lp6NMQ45Ni63ZoaGOi4x
        CMavQI/m2OuZPnzo5X14fxUNJG9AnbeV4LHHRWBrrfQcaoVsdQ0t2C8TbE+1pTFW4mqtgF
        3cT0+yIXdS5WBRGSAxdpM1Tu7rmW2MI=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        maz@kernel.org, james.morse@arm.com, alexandru.elisei@arm.com,
        suzuki.poulose@arm.com, will@kernel.org,
        Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 0/2] KVM: arm64: Uphold 64bit-only behavior on asymmetric systems
Date:   Thu, 11 Aug 2022 17:02:19 +0000
Message-Id: <20220811170221.3771048-1-oliver.upton@linux.dev>
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

Oliver Upton (2):
  KVM: arm64: Treat PMCR_EL1.LC as RES1 on asymmetric systems
  KVM: arm64: Reject 32bit user PSTATE on asymmetric systems

 arch/arm64/include/asm/kvm_host.h | 4 ++++
 arch/arm64/kvm/arm.c              | 3 +--
 arch/arm64/kvm/guest.c            | 2 +-
 arch/arm64/kvm/sys_regs.c         | 4 ++--
 4 files changed, 8 insertions(+), 5 deletions(-)


base-commit: 21f9c8a13bb2a0c24d9c6b86bc0896542a28c197
-- 
2.37.1.559.g78731f0fdb-goog

