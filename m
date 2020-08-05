Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B301523CF5B
	for <lists+kvm@lfdr.de>; Wed,  5 Aug 2020 21:20:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728575AbgHETTf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Aug 2020 15:19:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:46334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728358AbgHER6N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Aug 2020 13:58:13 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 85E9122CBB;
        Wed,  5 Aug 2020 17:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596650237;
        bh=SsItzmgNSUJmbU2ivN3tQvkpomzT92B3KJRadAxB4FM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eRHZNbIPt+QywYxWJXmgi5qQTsm0ZEBXwWhf0Zhoog44OKuVGLY5QohJbXrDn4mBe
         H54ylpMsTikcPbcadEY61BoG3egxb91uctvvh4aazBuZZ1H36q3YyKGmzl8Crv7C95
         5nVqqKvd+4A4SdToplX2JpP8k+wNkP9V39quwxu8=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1k3NfA-0004w9-3y; Wed, 05 Aug 2020 18:57:16 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alexander Graf <graf@amazon.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andrew Scull <ascull@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        David Brazdil <dbrazdil@google.com>,
        Eric Auger <eric.auger@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        James Morse <james.morse@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Peng Hao <richard.peng@oppo.com>,
        Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, kernel-team@android.com
Subject: [PATCH 05/56] KVM: arm64: Simplify PtrAuth alternative patching
Date:   Wed,  5 Aug 2020 18:56:09 +0100
Message-Id: <20200805175700.62775-6-maz@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200805175700.62775-1-maz@kernel.org>
References: <20200805175700.62775-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, graf@amazon.com, alexandru.elisei@arm.com, ascull@google.com, catalin.marinas@arm.com, christoffer.dall@arm.com, dbrazdil@google.com, eric.auger@redhat.com, gshan@redhat.com, james.morse@arm.com, mark.rutland@arm.com, richard.peng@oppo.com, qperret@google.com, will@kernel.org, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, kernel-team@android.com
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
Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_ptrauth.h | 30 ++++++++++------------------
 1 file changed, 11 insertions(+), 19 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_ptrauth.h b/arch/arm64/include/asm/kvm_ptrauth.h
index f1830173fa9e..0ddf98c3ba9f 100644
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
-	b	1000f
+alternative_if_not ARM64_HAS_ADDRESS_AUTH
+	b	.L__skip_switch\@
 alternative_else_nop_endif
-alternative_if_not ARM64_HAS_ADDRESS_AUTH_IMP_DEF
-	b	1001f
-alternative_else_nop_endif
-1000:
 	mrs	\reg1, hcr_el2
 	and	\reg1, \reg1, #(HCR_API | HCR_APK)
-	cbz	\reg1, 1001f
+	cbz	\reg1, .L__skip_switch\@
 	add	\reg1, \g_ctxt, #CPU_APIAKEYLO_EL1
 	ptrauth_restore_state	\reg1, \reg2, \reg3
-1001:
+.L__skip_switch\@:
 .endm
 
 .macro ptrauth_switch_to_host g_ctxt, h_ctxt, reg1, reg2, reg3
-alternative_if ARM64_HAS_ADDRESS_AUTH_ARCH
-	b	2000f
-alternative_else_nop_endif
-alternative_if_not ARM64_HAS_ADDRESS_AUTH_IMP_DEF
-	b	2001f
+alternative_if_not ARM64_HAS_ADDRESS_AUTH
+	b	.L__skip_switch\@
 alternative_else_nop_endif
-2000:
 	mrs	\reg1, hcr_el2
 	and	\reg1, \reg1, #(HCR_API | HCR_APK)
-	cbz	\reg1, 2001f
+	cbz	\reg1, .L__skip_switch\@
 	add	\reg1, \g_ctxt, #CPU_APIAKEYLO_EL1
 	ptrauth_save_state	\reg1, \reg2, \reg3
 	add	\reg1, \h_ctxt, #CPU_APIAKEYLO_EL1
 	ptrauth_restore_state	\reg1, \reg2, \reg3
 	isb
-2001:
+.L__skip_switch\@:
 .endm
 
 #else /* !CONFIG_ARM64_PTR_AUTH */
-- 
2.27.0

