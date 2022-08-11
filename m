Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 237EE590593
	for <lists+kvm@lfdr.de>; Thu, 11 Aug 2022 19:16:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235951AbiHKRP6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Aug 2022 13:15:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236587AbiHKRPj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Aug 2022 13:15:39 -0400
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C27132186
        for <kvm@vger.kernel.org>; Thu, 11 Aug 2022 10:02:38 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1660237357;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xwqZ0bZy9m3Az2vwdpC3agxh+PMnn/lB/GeOwmrcFP0=;
        b=gG2utxtom6M9C7erZq+CkAs+Mzw6v6mMY1XB/eb6nEgbN7Wsp4x5vPJtbWIJdVO9oHbPo5
        7Ei+YWfUnyPA58m3VxoGRdqkdmNGyWSX5kH0nglqYAKFpUPFzgAzP2SFFVUo4bxLwVOZbM
        pQCsyRnk/wQlNm3xoOegHm8O21rHF2Y=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        maz@kernel.org, james.morse@arm.com, alexandru.elisei@arm.com,
        suzuki.poulose@arm.com, will@kernel.org,
        Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 2/2] KVM: arm64: Reject 32bit user PSTATE on asymmetric systems
Date:   Thu, 11 Aug 2022 17:02:21 +0000
Message-Id: <20220811170221.3771048-3-oliver.upton@linux.dev>
In-Reply-To: <20220811170221.3771048-1-oliver.upton@linux.dev>
References: <20220811170221.3771048-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM does not support AArch32 EL0 on asymmetric systems. To that end,
prevent userspace from configuring a vCPU in such a state through
setting PSTATE.

It is already ABI that KVM rejects such a write on a system where
AArch32 EL0 is unsupported. Though the kernel's definition of a 32bit
system changed in commit 2122a833316f ("arm64: Allow mismatched
32-bit EL0 support"), KVM's did not.

Fixes: 2122a833316f ("arm64: Allow mismatched 32-bit EL0 support")
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/guest.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 8c607199cad1..f802a3b3f8db 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -242,7 +242,7 @@ static int set_core_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 		u64 mode = (*(u64 *)valp) & PSR_AA32_MODE_MASK;
 		switch (mode) {
 		case PSR_AA32_MODE_USR:
-			if (!system_supports_32bit_el0())
+			if (!kvm_supports_32bit_el0())
 				return -EINVAL;
 			break;
 		case PSR_AA32_MODE_FIQ:
-- 
2.37.1.559.g78731f0fdb-goog

