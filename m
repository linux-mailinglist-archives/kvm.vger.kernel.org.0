Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A880A7B7474
	for <lists+kvm@lfdr.de>; Wed,  4 Oct 2023 01:04:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232572AbjJCXEi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Oct 2023 19:04:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231504AbjJCXEg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Oct 2023 19:04:36 -0400
Received: from out-192.mta0.migadu.com (out-192.mta0.migadu.com [91.218.175.192])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51E14BB
        for <kvm@vger.kernel.org>; Tue,  3 Oct 2023 16:04:33 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1696374271;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mMultn6AEC8Df2iZISrV6G7YfIfbkGpjMKDyA89GDDU=;
        b=IkRS2S9KUG3qPxJb8hUX3CyCY40G1y3kBKJAxJwFbr39Chza7q05ZXR+ZEQXZGmLUGK0V7
        nSqEuvfRNJYqLqKKyZqkxoNyWmMstUGTA7tdkrhDaCGhP0ssu91dMYqoJMm/sr7LilH9ea
        t+xh+ExtXFFZUkWxcwVwfUDzjPzBqWc=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Jing Zhang <jingzhangos@google.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v11 07/12] KVM: arm64: Allow userspace to change ID_AA64MMFR{0-2}_EL1
Date:   Tue,  3 Oct 2023 23:04:03 +0000
Message-ID: <20231003230408.3405722-8-oliver.upton@linux.dev>
In-Reply-To: <20231003230408.3405722-1-oliver.upton@linux.dev>
References: <20231003230408.3405722-1-oliver.upton@linux.dev>
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

From: Jing Zhang <jingzhangos@google.com>

Allow userspace to modify the guest-visible values of these ID
registers. Prevent changes to any of the virtualization features until
KVM picks up support for nested and we have a handle on managing NV
features.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
[oliver: prevent changes to EL2 features for now]
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/sys_regs.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 09be55338e0a..9e31887ee0f4 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2099,9 +2099,23 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	ID_UNALLOCATED(6,7),
 
 	/* CRm=7 */
-	ID_SANITISED(ID_AA64MMFR0_EL1),
-	ID_SANITISED(ID_AA64MMFR1_EL1),
-	ID_SANITISED(ID_AA64MMFR2_EL1),
+	ID_WRITABLE(ID_AA64MMFR0_EL1, ~(ID_AA64MMFR0_EL1_RES0 |
+					ID_AA64MMFR0_EL1_TGRAN4_2 |
+					ID_AA64MMFR0_EL1_TGRAN64_2 |
+					ID_AA64MMFR0_EL1_TGRAN16_2)),
+	ID_WRITABLE(ID_AA64MMFR1_EL1, ~(ID_AA64MMFR1_EL1_RES0 |
+					ID_AA64MMFR1_EL1_HCX |
+					ID_AA64MMFR1_EL1_XNX |
+					ID_AA64MMFR1_EL1_TWED |
+					ID_AA64MMFR1_EL1_XNX |
+					ID_AA64MMFR1_EL1_VH |
+					ID_AA64MMFR1_EL1_VMIDBits)),
+	ID_WRITABLE(ID_AA64MMFR2_EL1, ~(ID_AA64MMFR2_EL1_RES0 |
+					ID_AA64MMFR2_EL1_EVT |
+					ID_AA64MMFR2_EL1_FWB |
+					ID_AA64MMFR2_EL1_IDS |
+					ID_AA64MMFR2_EL1_NV |
+					ID_AA64MMFR2_EL1_CCIDX)),
 	ID_SANITISED(ID_AA64MMFR3_EL1),
 	ID_UNALLOCATED(7,4),
 	ID_UNALLOCATED(7,5),
-- 
2.42.0.609.gbb76f46606-goog

