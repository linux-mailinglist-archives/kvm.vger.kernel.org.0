Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F2E827030B
	for <lists+kvm@lfdr.de>; Fri, 18 Sep 2020 19:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726343AbgIRRR0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Sep 2020 13:17:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:34840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726139AbgIRRRY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Sep 2020 13:17:24 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67A4021741;
        Fri, 18 Sep 2020 17:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600449444;
        bh=cAgxLXePeYCs/M26SYLkziKIDoRBbatCmklPQ+trqT0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y/u2oVlXb5KeDrKPcI/EU4XxJ5GMbUd49XQXmguldfr5lslVpkcGCY9doHqnbu+lh
         fXVraqfum/Hl11QjQ8cVy+ac+4ygzB/I2lGmcdSSVblWompMvK2BDEOYh+/z8G/9rc
         RuZJkG0w6haHsyV9JnGJW/JL6xLgdtzGNcKF44v8=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1kJK0g-00D4ZN-TG; Fri, 18 Sep 2020 18:17:23 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Will Deacon <will@kernel.org>, kernel-team@android.com,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 2/2] KVM: arm64: Remove S1PTW check from kvm_vcpu_dabt_iswrite()
Date:   Fri, 18 Sep 2020 18:16:51 +0100
Message-Id: <20200918171651.1340445-3-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200918171651.1340445-1-maz@kernel.org>
References: <20200918171651.1340445-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, will@kernel.org, kernel-team@android.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that kvm_vcpu_trap_is_write_fault() checks for S1PTW, there
is no need for kvm_vcpu_dabt_iswrite() to do the same thing, as
we already check for this condition on all existing paths.

Drop the check and add a comment instead.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20200915104218.1284701-3-maz@kernel.org
---
 arch/arm64/include/asm/kvm_emulate.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 4f618af660ba..1cc5f5f72d0b 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -303,10 +303,10 @@ static __always_inline bool kvm_vcpu_abt_iss1tw(const struct kvm_vcpu *vcpu)
 	return !!(kvm_vcpu_get_esr(vcpu) & ESR_ELx_S1PTW);
 }
 
+/* Always check for S1PTW *before* using this. */
 static __always_inline bool kvm_vcpu_dabt_iswrite(const struct kvm_vcpu *vcpu)
 {
-	return !!(kvm_vcpu_get_esr(vcpu) & ESR_ELx_WNR) ||
-		kvm_vcpu_abt_iss1tw(vcpu); /* AF/DBM update */
+	return kvm_vcpu_get_esr(vcpu) & ESR_ELx_WNR;
 }
 
 static inline bool kvm_vcpu_dabt_is_cm(const struct kvm_vcpu *vcpu)
-- 
2.28.0

