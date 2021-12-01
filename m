Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A290464D75
	for <lists+kvm@lfdr.de>; Wed,  1 Dec 2021 13:04:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349157AbhLAMIJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Dec 2021 07:08:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349155AbhLAMIH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Dec 2021 07:08:07 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E5B4C06174A
        for <kvm@vger.kernel.org>; Wed,  1 Dec 2021 04:04:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E3D7CCE1D28
        for <kvm@vger.kernel.org>; Wed,  1 Dec 2021 12:04:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16EB9C53FCD;
        Wed,  1 Dec 2021 12:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638360283;
        bh=Z8F4hu+2UX8yZ3oAmURSAWeQYhXWQ7dstt/xYNG5yCs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WK5UFODjBFou61gFuWRa8OrDvuAgUZRSgSOIWyydOZWPe0qKanM4gsaBNA9PKHMc2
         3lBcySaBPMRUGxwHk5LExBfAz23nNGgkPSZjBbOvLPkwgda3L+cOh0T8O7OIclGUqC
         n6E+mr8+lC2Q+aSxjXO6D/voqqoMGFXIlcFKB0EBMN3BZQ09JbyI/QQeghsTSaWlhK
         f4ROUJc8fWbRjJ9rlUKbgr214CMyExFGCPFp16IuzXc4Xg/ajIf+gdskbqNjkh4XiZ
         MLcjz6niF0oVV2dzQ31jcuhzOGIPJt/reQMlTkpw1fZ5TTzTsF72YLkBzLLQpyknux
         F0nlNHHKjdcdA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1msOLp-0097Ab-6Z; Wed, 01 Dec 2021 12:04:41 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>, broonie@kernel.org,
        Zenghui Yu <yuzenghui@huawei.com>, kernel-team@android.com
Subject: [PATCH v3 1/6] KVM: arm64: Reorder vcpu flag definitions
Date:   Wed,  1 Dec 2021 12:04:31 +0000
Message-Id: <20211201120436.389756-2-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211201120436.389756-1-maz@kernel.org>
References: <20211201120436.389756-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, qperret@google.com, will@kernel.org, broonie@kernel.org, yuzenghui@huawei.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The vcpu arch flags are in an interesting, semi random order.
As I have made the mistake of reusing a flag once, let's rework
this in an order that I find a bit less confusing.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 2a5f7f38006f..3bfd30137ce2 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -417,14 +417,12 @@ struct kvm_vcpu_arch {
 #define KVM_ARM64_VCPU_SVE_FINALIZED	(1 << 6) /* SVE config completed */
 #define KVM_ARM64_GUEST_HAS_PTRAUTH	(1 << 7) /* PTRAUTH exposed to guest */
 #define KVM_ARM64_PENDING_EXCEPTION	(1 << 8) /* Exception pending */
+/*
+ * Overlaps with KVM_ARM64_EXCEPT_MASK on purpose so that it can't be
+ * set together with an exception...
+ */
+#define KVM_ARM64_INCREMENT_PC		(1 << 9) /* Increment PC */
 #define KVM_ARM64_EXCEPT_MASK		(7 << 9) /* Target EL/MODE */
-#define KVM_ARM64_DEBUG_STATE_SAVE_SPE	(1 << 12) /* Save SPE context if active  */
-#define KVM_ARM64_DEBUG_STATE_SAVE_TRBE	(1 << 13) /* Save TRBE context if active  */
-
-#define KVM_GUESTDBG_VALID_MASK (KVM_GUESTDBG_ENABLE | \
-				 KVM_GUESTDBG_USE_SW_BP | \
-				 KVM_GUESTDBG_USE_HW | \
-				 KVM_GUESTDBG_SINGLESTEP)
 /*
  * When KVM_ARM64_PENDING_EXCEPTION is set, KVM_ARM64_EXCEPT_MASK can
  * take the following values:
@@ -442,11 +440,13 @@ struct kvm_vcpu_arch {
 #define KVM_ARM64_EXCEPT_AA64_EL1	(0 << 11)
 #define KVM_ARM64_EXCEPT_AA64_EL2	(1 << 11)
 
-/*
- * Overlaps with KVM_ARM64_EXCEPT_MASK on purpose so that it can't be
- * set together with an exception...
- */
-#define KVM_ARM64_INCREMENT_PC		(1 << 9) /* Increment PC */
+#define KVM_ARM64_DEBUG_STATE_SAVE_SPE	(1 << 12) /* Save SPE context if active  */
+#define KVM_ARM64_DEBUG_STATE_SAVE_TRBE	(1 << 13) /* Save TRBE context if active  */
+
+#define KVM_GUESTDBG_VALID_MASK (KVM_GUESTDBG_ENABLE | \
+				 KVM_GUESTDBG_USE_SW_BP | \
+				 KVM_GUESTDBG_USE_HW | \
+				 KVM_GUESTDBG_SINGLESTEP)
 
 #define vcpu_has_sve(vcpu) (system_supports_sve() &&			\
 			    ((vcpu)->arch.flags & KVM_ARM64_GUEST_HAS_SVE))
-- 
2.30.2

