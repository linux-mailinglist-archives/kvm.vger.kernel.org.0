Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 253B0203164
	for <lists+kvm@lfdr.de>; Mon, 22 Jun 2020 10:07:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726023AbgFVIG6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 04:06:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:42178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725977AbgFVIG4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 04:06:56 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B5C78208B8;
        Mon, 22 Jun 2020 08:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592813215;
        bh=4nG2b3jaPjznFD/NfnCd4lwrsEBsRWemjhTf0Sa8kGs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1QcwT2LdGzYbQ4WrK2MAJLcBXxUUtmRWcG/BcBlXrB5Mvkxx801VfvZrkGMekCGcf
         volfud8JcHtQ/+STXSZyMbFz9TmEYHYEfUyACVmDGEnDUSGdJ+M/4lpAUtpH66otp+
         fsBWeoDh8Cnk6z2LswTAEdyDUK58WWPvm2Pvt610=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jnHTi-005FG8-9V; Mon, 22 Jun 2020 09:06:54 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrew Scull <ascull@google.com>,
        Dave Martin <Dave.Martin@arm.com>, kernel-team@android.com
Subject: [PATCH v2 5/5] KVM: arm64: Simplify PtrAuth alternative patching
Date:   Mon, 22 Jun 2020 09:06:43 +0100
Message-Id: <20200622080643.171651-6-maz@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200622080643.171651-1-maz@kernel.org>
References: <20200622080643.171651-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, mark.rutland@arm.com, ascull@google.com, Dave.Martin@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We currently decide to execute the PtrAuth save/restore code based
on a set of branches that evaluate as (ARM64_HAS_ADDRESS_AUTH_ARCH ||
ARM64_HAS_ADDRESS_AUTH_IMP_DEF). This can be easily replaced by
a much simpler test as the ARM64_HAS_ADDRESS_AUTH capability is
exactly this expression.

Suggested-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_ptrauth.h | 26 +++++++++-----------------
 1 file changed, 9 insertions(+), 17 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_ptrauth.h b/arch/arm64/include/asm/kvm_ptrauth.h
index f1830173fa9e..7a72508a841b 100644
--- a/arch/arm64/include/asm/kvm_ptrauth.h
+++ b/arch/arm64/include/asm/kvm_ptrauth.h
@@ -61,44 +61,36 @@
 
 /*
  * Both ptrauth_switch_to_guest and ptrauth_switch_to_host macros will
- * check for the presence of one of the cpufeature flag
- * ARM64_HAS_ADDRESS_AUTH_ARCH or ARM64_HAS_ADDRESS_AUTH_IMP_DEF and
+ * check for the presence ARM64_HAS_ADDRESS_AUTH, which is defined as
+ * (ARM64_HAS_ADDRESS_AUTH_ARCH || ARM64_HAS_ADDRESS_AUTH_IMP_DEF) and
  * then proceed ahead with the save/restore of Pointer Authentication
- * key registers.
+ * key registers if enabled for the guest.
  */
 .macro ptrauth_switch_to_guest g_ctxt, reg1, reg2, reg3
-alternative_if ARM64_HAS_ADDRESS_AUTH_ARCH
+alternative_if_not ARM64_HAS_ADDRESS_AUTH
 	b	1000f
 alternative_else_nop_endif
-alternative_if_not ARM64_HAS_ADDRESS_AUTH_IMP_DEF
-	b	1001f
-alternative_else_nop_endif
-1000:
 	mrs	\reg1, hcr_el2
 	and	\reg1, \reg1, #(HCR_API | HCR_APK)
-	cbz	\reg1, 1001f
+	cbz	\reg1, 1000f
 	add	\reg1, \g_ctxt, #CPU_APIAKEYLO_EL1
 	ptrauth_restore_state	\reg1, \reg2, \reg3
-1001:
+1000:
 .endm
 
 .macro ptrauth_switch_to_host g_ctxt, h_ctxt, reg1, reg2, reg3
-alternative_if ARM64_HAS_ADDRESS_AUTH_ARCH
+alternative_if_not ARM64_HAS_ADDRESS_AUTH
 	b	2000f
 alternative_else_nop_endif
-alternative_if_not ARM64_HAS_ADDRESS_AUTH_IMP_DEF
-	b	2001f
-alternative_else_nop_endif
-2000:
 	mrs	\reg1, hcr_el2
 	and	\reg1, \reg1, #(HCR_API | HCR_APK)
-	cbz	\reg1, 2001f
+	cbz	\reg1, 2000f
 	add	\reg1, \g_ctxt, #CPU_APIAKEYLO_EL1
 	ptrauth_save_state	\reg1, \reg2, \reg3
 	add	\reg1, \h_ctxt, #CPU_APIAKEYLO_EL1
 	ptrauth_restore_state	\reg1, \reg2, \reg3
 	isb
-2001:
+2000:
 .endm
 
 #else /* !CONFIG_ARM64_PTR_AUTH */
-- 
2.27.0

