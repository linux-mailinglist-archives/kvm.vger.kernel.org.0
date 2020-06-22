Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEA60203165
	for <lists+kvm@lfdr.de>; Mon, 22 Jun 2020 10:07:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726079AbgFVIHA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 04:07:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:42092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725820AbgFVIG4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 04:06:56 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 32614208E4;
        Mon, 22 Jun 2020 08:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592813215;
        bh=cbHNqMTWM4XBTi8BcgqQ/MZT1LZ7/GYxlwpP7QQrJWc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nXVeq1uzLb1InSQd9SQIgO2gDFMzaM4rSkl14YkRnlhT1Z4QORqUGIGuItwEnO5nc
         M9MnLrET5AxRbgUwg+Z9F5p5BeN39NOTMzsmJtggb0/Yz7bHkvkiO6BXHohUf0aK+z
         yeg/uPP6zCcSDhcVg3TS+RSvr0PePDXqUNkNf4Mg=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jnHTh-005FG8-Nu; Mon, 22 Jun 2020 09:06:53 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrew Scull <ascull@google.com>,
        Dave Martin <Dave.Martin@arm.com>, kernel-team@android.com
Subject: [PATCH v2 4/5] KVM: arm64: Check HCR_EL2 instead of shadow copy to swap PtrAuth registers
Date:   Mon, 22 Jun 2020 09:06:42 +0100
Message-Id: <20200622080643.171651-5-maz@kernel.org>
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

When save/restoring PtrAuth registers between host and guest, it is
pretty useless to fetch the in-memory state, while we have the right
state in the HCR_EL2 system register. Use that instead.

Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_ptrauth.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_ptrauth.h b/arch/arm64/include/asm/kvm_ptrauth.h
index 6301813dcace..f1830173fa9e 100644
--- a/arch/arm64/include/asm/kvm_ptrauth.h
+++ b/arch/arm64/include/asm/kvm_ptrauth.h
@@ -74,7 +74,7 @@ alternative_if_not ARM64_HAS_ADDRESS_AUTH_IMP_DEF
 	b	1001f
 alternative_else_nop_endif
 1000:
-	ldr	\reg1, [\g_ctxt, #(VCPU_HCR_EL2 - VCPU_CONTEXT)]
+	mrs	\reg1, hcr_el2
 	and	\reg1, \reg1, #(HCR_API | HCR_APK)
 	cbz	\reg1, 1001f
 	add	\reg1, \g_ctxt, #CPU_APIAKEYLO_EL1
@@ -90,7 +90,7 @@ alternative_if_not ARM64_HAS_ADDRESS_AUTH_IMP_DEF
 	b	2001f
 alternative_else_nop_endif
 2000:
-	ldr	\reg1, [\g_ctxt, #(VCPU_HCR_EL2 - VCPU_CONTEXT)]
+	mrs	\reg1, hcr_el2
 	and	\reg1, \reg1, #(HCR_API | HCR_APK)
 	cbz	\reg1, 2001f
 	add	\reg1, \g_ctxt, #CPU_APIAKEYLO_EL1
-- 
2.27.0

