Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5BC426A368
	for <lists+kvm@lfdr.de>; Tue, 15 Sep 2020 12:44:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726440AbgIOKo3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Sep 2020 06:44:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:46174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726381AbgIOKmn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Sep 2020 06:42:43 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E3E720B1F;
        Tue, 15 Sep 2020 10:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600166562;
        bh=JpQAb6Gm2FYtY9xG2whFGPDFubcLeWuG9gg0NSevaxs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1WPqzQ4aQD2giZcrdNRC1eigtTWsqyH1+i6u597CO2//h+JBFboBpvKspQgu9+0za
         Vtk+uuOV4hXwuCWzwCX/t94/NOLZyd1kJE+wqRBfzav0Rl0WnTHx8ywA8SS02OX09C
         cqFYuVySais/VOfEomR/Mc3h6wauq8p2AHG1+E7o=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1kI8Q4-00ByDU-97; Tue, 15 Sep 2020 11:42:41 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Cc:     kernel-team@android.com, Will Deacon <will@kernel.org>
Subject: [PATCH v2 2/2] KVM: arm64: Remove S1PTW check from kvm_vcpu_dabt_iswrite()
Date:   Tue, 15 Sep 2020 11:42:18 +0100
Message-Id: <20200915104218.1284701-3-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915104218.1284701-1-maz@kernel.org>
References: <20200915104218.1284701-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kernel-team@android.com, will@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that kvm_vcpu_trap_is_write_fault() checks for S1PTW, there
is no need for kvm_vcpu_dabt_iswrite() to do the same thing, as
we already check for this condition on all existing paths.

Drop the check and add a comment instead.

Signed-off-by: Marc Zyngier <maz@kernel.org>
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

