Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40A2652D488
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 15:46:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239026AbiESNo7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 09:44:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238989AbiESNnW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 09:43:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C0E3473AA
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 06:43:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 393716173E
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 13:43:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D2A7C3411A;
        Thu, 19 May 2022 13:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652967800;
        bh=nNZBdOA5NigbPc1M0gOv4ihVOwnmvSo9vvj+XEN8QEE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j7NoBFU8bwOn6I+AuPUl7vI/GLMz9EE1gyvmRDAPQCAsqxaCXQgvzkWTxTMlEeU4b
         nKCxfCfk3UAb5Suzl20gX+EIh86HcGnn/OVC84fZm+c7yPrBTo3kkTEYMFXPqY6oFW
         Yrf5KPq7DWjcBRqtOYodbQ/2zfa6ms8Hj++BSXMMV18576Jr+Ka305u6AiCBu0sH6E
         q2B6ltG0V+vBJyh0Cgl3M7bU1BaqLxC1QbN+a9R5qehpeFQV1QOk8+LxfmURxMkP7T
         XI1N9IfmeI2Vjenox9AJWKR12NwgBNPZqsfx/CCNqX0/MBm6hSRr5GzRoWB0ObjjuD
         40tH47LOOXvkw==
From:   Will Deacon <will@kernel.org>
To:     kvmarm@lists.cs.columbia.edu
Cc:     Will Deacon <will@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Quentin Perret <qperret@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Michael Roth <michael.roth@amd.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Oliver Upton <oupton@google.com>,
        Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 14/89] KVM: arm64: Add hyp_spinlock_t static initializer
Date:   Thu, 19 May 2022 14:40:49 +0100
Message-Id: <20220519134204.5379-15-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220519134204.5379-1-will@kernel.org>
References: <20220519134204.5379-1-will@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Fuad Tabba <tabba@google.com>

Having a static initializer for hyp_spinlock_t simplifies its
use when there isn't an initializing function.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/include/nvhe/spinlock.h | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/spinlock.h b/arch/arm64/kvm/hyp/include/nvhe/spinlock.h
index 4652fd04bdbe..7c7ea8c55405 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/spinlock.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/spinlock.h
@@ -28,9 +28,17 @@ typedef union hyp_spinlock {
 	};
 } hyp_spinlock_t;
 
+#define __HYP_SPIN_LOCK_INITIALIZER \
+	{ .__val = 0 }
+
+#define __HYP_SPIN_LOCK_UNLOCKED \
+	((hyp_spinlock_t) __HYP_SPIN_LOCK_INITIALIZER)
+
+#define DEFINE_HYP_SPINLOCK(x)	hyp_spinlock_t x = __HYP_SPIN_LOCK_UNLOCKED
+
 #define hyp_spin_lock_init(l)						\
 do {									\
-	*(l) = (hyp_spinlock_t){ .__val = 0 };				\
+	*(l) = __HYP_SPIN_LOCK_UNLOCKED;				\
 } while (0)
 
 static inline void hyp_spin_lock(hyp_spinlock_t *lock)
-- 
2.36.1.124.g0e6072fb45-goog

