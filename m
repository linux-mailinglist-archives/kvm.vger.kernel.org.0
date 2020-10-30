Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D28A2A0B64
	for <lists+kvm@lfdr.de>; Fri, 30 Oct 2020 17:40:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727232AbgJ3Qke (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Oct 2020 12:40:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:56328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727230AbgJ3Qkc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Oct 2020 12:40:32 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF6E120724;
        Fri, 30 Oct 2020 16:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604076031;
        bh=OoL8wFiBGkmFWNmwb8QRh22k0yf0eXlE0e1LfiW3ud4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1rJ6cnNW7TMucvL6kaHJNUY5p661XpKIV1uZBiZJ5gfG9fBerUySQkzNJ2OGfjR5C
         +CXG+Y7Ji3g93Gd+zIST+z+W6iq/I7OmKXYPDubY3WZNKsp4+06JWmTKG3cQBnVkMQ
         jhl1MxZWv3cfsQDott+cyBzfmVRHrcAsQBwsf8tg=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1kYXS1-005noK-0n; Fri, 30 Oct 2020 16:40:29 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     David Brazdil <dbrazdil@google.com>, Gavin Shan <gshan@redhat.com>,
        James Morse <james.morse@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Qais Yousef <qais.yousef@arm.com>,
        Quentin Perret <qperret@google.com>,
        Santosh Shukla <sashukla@nvidia.com>,
        Vladimir Murzin <vladimir.murzin@arm.com>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 09/12] KVM: arm64: Factor out is_{vhe,nvhe}_hyp_code()
Date:   Fri, 30 Oct 2020 16:40:14 +0000
Message-Id: <20201030164017.244287-10-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201030164017.244287-1-maz@kernel.org>
References: <20201030164017.244287-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, dbrazdil@google.com, gshan@redhat.com, james.morse@arm.com, mark.rutland@arm.com, qais.yousef@arm.com, qperret@google.com, sashukla@nvidia.com, vladimir.murzin@arm.com, will@kernel.org, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kernel-team@android.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Mark Rutland <mark.rutland@arm.com>

Currently has_vhe() detects whether it is being compiled for VHE/NVHE
hyp code based on preprocessor definitions, and uses this knowledge to
avoid redundant runtime checks.

There are other cases where we'd like to use this knowledge, so let's
factor the preprocessor checks out into separate helpers.

There should be no functional change as a result of this patch.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Acked-by: Will Deacon <will@kernel.org>
Cc: David Brazdil <dbrazdil@google.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20201026134931.28246-2-mark.rutland@arm.com
---
 arch/arm64/include/asm/virt.h | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/virt.h b/arch/arm64/include/asm/virt.h
index 09977acc007d..300be14ba77b 100644
--- a/arch/arm64/include/asm/virt.h
+++ b/arch/arm64/include/asm/virt.h
@@ -83,16 +83,27 @@ static inline bool is_kernel_in_hyp_mode(void)
 	return read_sysreg(CurrentEL) == CurrentEL_EL2;
 }
 
+static __always_inline bool is_vhe_hyp_code(void)
+{
+	/* Only defined for code run in VHE hyp context */
+	return __is_defined(__KVM_VHE_HYPERVISOR__);
+}
+
+static __always_inline bool is_nvhe_hyp_code(void)
+{
+	/* Only defined for code run in NVHE hyp context */
+	return __is_defined(__KVM_NVHE_HYPERVISOR__);
+}
+
 static __always_inline bool has_vhe(void)
 {
 	/*
-	 * The following macros are defined for code specic to VHE/nVHE.
-	 * If has_vhe() is inlined into those compilation units, it can
-	 * be determined statically. Otherwise fall back to caps.
+	 * Code only run in VHE/NVHE hyp context can assume VHE is present or
+	 * absent. Otherwise fall back to caps.
 	 */
-	if (__is_defined(__KVM_VHE_HYPERVISOR__))
+	if (is_vhe_hyp_code())
 		return true;
-	else if (__is_defined(__KVM_NVHE_HYPERVISOR__))
+	else if (is_nvhe_hyp_code())
 		return false;
 	else
 		return cpus_have_final_cap(ARM64_HAS_VIRT_HOST_EXTN);
-- 
2.28.0

