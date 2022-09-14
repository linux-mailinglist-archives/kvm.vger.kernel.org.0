Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16B005B8306
	for <lists+kvm@lfdr.de>; Wed, 14 Sep 2022 10:36:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230189AbiINIgC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Sep 2022 04:36:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230188AbiINIft (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Sep 2022 04:35:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8EFA696E3
        for <kvm@vger.kernel.org>; Wed, 14 Sep 2022 01:35:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 877196192A
        for <kvm@vger.kernel.org>; Wed, 14 Sep 2022 08:35:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9CB1C43141;
        Wed, 14 Sep 2022 08:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663144544;
        bh=jj0KRwqJsGqbuaGft+eGpD/iOl0pF+Q/VTKAhx/Vl3g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A9eTgKz2mtqaXuLdjw/KaFDJc+kWSV9bEBbhWl01FO/LgYlfgGSu8h3dIde/xu7EH
         7GMhVUMeXNKBHXo1UmKzeMDF+rY79rYCDj9RR024LYoQgTe/qZZpUbx1aY77HLm3ol
         okw5euXVBmnxwwsD/ROlZxMgkssOrr87eOaByunbgCinPu8v4tGgQtDmWjZ6jPQjls
         p0ebENFRxss2zJA+aRAy1q9x+ijGOtTGi09vunPVx9AXTjj8/drdHsXWYlZzv8m0G+
         dh5gOFl7HVVMX50/ljdzWs03D68mrdxV4AH43Q7T7hM7FWSzjf88mzIMRzboOr6kVh
         UkNrYzavj/uTQ==
From:   Will Deacon <will@kernel.org>
To:     kvmarm@lists.cs.columbia.edu
Cc:     Will Deacon <will@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Vincent Donnefort <vdonnefort@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Quentin Perret <qperret@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH v3 10/25] KVM: arm64: Add hyp_spinlock_t static initializer
Date:   Wed, 14 Sep 2022 09:34:45 +0100
Message-Id: <20220914083500.5118-11-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220914083500.5118-1-will@kernel.org>
References: <20220914083500.5118-1-will@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Fuad Tabba <tabba@google.com>

Introduce a static initializer macro for 'hyp_spinlock_t' so that it is
straightforward to instantiate global locks at EL2. This will be later
utilised for locking the VM table in the hypervisor.

Signed-off-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
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
2.37.2.789.g6183377224-goog

