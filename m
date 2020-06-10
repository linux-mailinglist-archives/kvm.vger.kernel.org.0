Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B421F1F534D
	for <lists+kvm@lfdr.de>; Wed, 10 Jun 2020 13:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728515AbgFJLeU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jun 2020 07:34:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:42810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728534AbgFJLeS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jun 2020 07:34:18 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B5E6420760;
        Wed, 10 Jun 2020 11:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591788857;
        bh=/Y2n7mh6J7qge+yb7uf2/26y9v3szN7Yyb7XyJnJfiU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2o1TioCfOCUpxyCEkhD2T3u4rcGK0ces6J+4y/9i0RuD5HVWJRC0AKmXDkK2VhoL9
         kXTUAqN2vUPP6LUZyAdRG/XYPeBpWU8arSSifhgKOdX3wlYzHlRjXExPhMdOxt6tgI
         ObD66mTj1QD7BPujKItC8tye7N+j96ssVBq+FHTE=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jiyzo-001lrp-AO; Wed, 10 Jun 2020 12:34:16 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrew Scull <ascull@google.com>, kernel-team@android.com
Subject: [PATCH v2 3/4] KVM: arm64: Stop sparse from moaning at __hyp_this_cpu_ptr
Date:   Wed, 10 Jun 2020 12:34:05 +0100
Message-Id: <20200610113406.1493170-4-maz@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200610113406.1493170-1-maz@kernel.org>
References: <20200610113406.1493170-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, will@kernel.org, catalin.marinas@arm.com, mark.rutland@arm.com, ascull@google.com, kernel-team@android.com
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

Notes:
    v2: Add __verify_pcpu_ptr() as suggested by Andrew Scull.

 arch/arm64/include/asm/kvm_asm.h | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 0c9b5fc4ba0a..d9b7da15dbca 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -81,12 +81,19 @@ extern u32 __kvm_get_mdcr_el2(void);
 
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
-		void *__ptr = hyp_symbol_addr(sym);			\
+		void *__ptr;						\
+		__verify_pcpu_ptr(&sym);				\
+		__ptr = hyp_symbol_addr(sym);				\
 		__ptr += read_sysreg(tpidr_el2);			\
-		(typeof(&sym))__ptr;					\
+		(typeof(sym) __kernel __force *)__ptr;			\
 	 })
 
 #define __hyp_this_cpu_read(sym)					\
-- 
2.26.2

