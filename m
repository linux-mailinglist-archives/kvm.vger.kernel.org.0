Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43AA61F14DA
	for <lists+kvm@lfdr.de>; Mon,  8 Jun 2020 10:57:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729177AbgFHI5i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jun 2020 04:57:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:38442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725965AbgFHI5i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Jun 2020 04:57:38 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B800A2067B;
        Mon,  8 Jun 2020 08:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591606657;
        bh=1jjVeWaGUx/kF/HqHOM8YQv2fZBnnOM3q+tHNHIFYFw=;
        h=From:To:Cc:Subject:Date:From;
        b=OzXF5RzAUEJ0g14wlYmEZt2t4Rh6LFZBxDi/WVEybHBjWRvx5wxHE1x+eWp/ZgTOe
         uV06Z1DIwbKN64xBPA2OZNtIR/Zj34IKTgQ6qt9JZEjHXZE2KExlqiVwY5eovimJa+
         GzfFtVbUyAO3cdQlkBP8q/CYvA1s4clOGWNDglXY=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jiDb5-0015Cp-O0; Mon, 08 Jun 2020 09:57:36 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com
Subject: [PATCH] KVM: arm64: Stop sparse from moaning at __hyp_this_cpu_ptr
Date:   Mon,  8 Jun 2020 09:57:31 +0100
Message-Id: <20200608085731.1405854-1-maz@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sparse complains that __hyp_this_cpu_ptr() returns something
that is flagged noderef and not in the correct address space
(both being the result of the __percpu annotation).

Pretend that __hyp_this_cpu_ptr() knows what it is doing by
forcefully casting the pointer with __kernel __force.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_asm.h | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 0c9b5fc4ba0a..82691406d493 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -81,12 +81,17 @@ extern u32 __kvm_get_mdcr_el2(void);
 
 extern char __smccc_workaround_1_smc[__SMCCC_WORKAROUND_1_SMC_SZ];
 
-/* Home-grown __this_cpu_{ptr,read} variants that always work at HYP */
+/*
+ * Home-grown __this_cpu_{ptr,read} variants that always work at HYP,
+ * provided that sym is really a *symbol* and not a pointer obtained from
+ * a data structure. As for SHIFT_PERCPU_PTR(), the creative casting keeps
+ * sparse quiet.
+ */
 #define __hyp_this_cpu_ptr(sym)						\
 	({								\
 		void *__ptr = hyp_symbol_addr(sym);			\
 		__ptr += read_sysreg(tpidr_el2);			\
-		(typeof(&sym))__ptr;					\
+		(typeof(sym) __kernel __force *)__ptr;			\
 	 })
 
 #define __hyp_this_cpu_read(sym)					\
-- 
2.26.2

