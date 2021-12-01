Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0838464D7A
	for <lists+kvm@lfdr.de>; Wed,  1 Dec 2021 13:04:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349112AbhLAMIL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Dec 2021 07:08:11 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:54904 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349148AbhLAMII (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Dec 2021 07:08:08 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BEAB1CE1DD5
        for <kvm@vger.kernel.org>; Wed,  1 Dec 2021 12:04:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72751C58321;
        Wed,  1 Dec 2021 12:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638360284;
        bh=mGMA0LdI86boJc0KzjqubEoj0yuCdbIywxvtvcR4UZQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KBVpPhPnx4WCCeo8UdKJkpMJ1uU1UI/jjwkKwL0olZVAxBn0+6pNJ53yZM2TvYzaE
         b1N2LmKsqSNyIG8ODMFs3AK/XTutaWZj/oZ1XSG/bfLDsjWOk1gG3qI96O1VQHpp3v
         dA8goNAYUOlB3z/t3cxvvQWBEbsNhpoeJV+fzeY4szG/6jpFJO5lB7t3WVJiGY+TAR
         pb5cZe2YNKupZRSLyjAEyzuTIG3cll4MT2zSoWlyf75x8aUJbibFmXBLvJpcQb3KtV
         RAljay7YQ0kFwJTJgxL+HQ6e0XllS8jhmoU16JDKfGZEV2QKzM5uSLvK4aGu9Iurmi
         tnY5zg9BBBtZw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1msOLq-0097Ab-Jh; Wed, 01 Dec 2021 12:04:42 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>, broonie@kernel.org,
        Zenghui Yu <yuzenghui@huawei.com>, kernel-team@android.com
Subject: [PATCH v3 6/6] arm64/fpsimd: Document the use of TIF_FOREIGN_FPSTATE by KVM
Date:   Wed,  1 Dec 2021 12:04:36 +0000
Message-Id: <20211201120436.389756-7-maz@kernel.org>
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

The bit of documentation that talks about TIF_FOREIGN_FPSTATE
does not mention the ungodly tricks that KVM plays with this flag.

Try and document this for the posterity.

Reviewed-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kernel/fpsimd.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index fa244c426f61..6fb361e8bed8 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -78,7 +78,11 @@
  * indicate whether or not the userland FPSIMD state of the current task is
  * present in the registers. The flag is set unless the FPSIMD registers of this
  * CPU currently contain the most recent userland FPSIMD state of the current
- * task.
+ * task. If the task is behaving as a VMM, then this is will be managed by
+ * KVM which will clear it to indicate that the vcpu FPSIMD state is currently
+ * loaded on the CPU, allowing the state to be saved if a FPSIMD-aware
+ * softirq kicks in. Upon vcpu_put(), KVM will save the vcpu FP state and
+ * flag the register state as invalid.
  *
  * In order to allow softirq handlers to use FPSIMD, kernel_neon_begin() may
  * save the task's FPSIMD context back to task_struct from softirq context.
-- 
2.30.2

