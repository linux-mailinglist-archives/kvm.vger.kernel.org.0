Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1B9F1596C0
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 18:51:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730364AbgBKRvf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 12:51:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:53974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730330AbgBKRvf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 12:51:35 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D14EA20870;
        Tue, 11 Feb 2020 17:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581443494;
        bh=nuQ0MN9/FGm7i28EpIRwCZK8BlzSNLL3qWI84G027to=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rolyyoPuIhxBuyT6P+LDNWJEt7S0gbHBnRuxoO3pDpiT1W3uvPTj54mfLnzGvNJn+
         KGORkhoUe9fKJI85d88XUE62BTUZwT1FxXGoyWmWoujF8nsrfh+zkCLbhaVjmtYsnp
         xDROX7tA1ILiT/6yP4V63hBMwenL6EBKRL7IXBU0=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1j1Zfp-004O7k-5C; Tue, 11 Feb 2020 17:50:13 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v2 34/94] KVM: arm64: nv: Use ARMv8.5-GTG to advertise supported Stage-2 page sizes
Date:   Tue, 11 Feb 2020 17:48:38 +0000
Message-Id: <20200211174938.27809-35-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200211174938.27809-1-maz@kernel.org>
References: <20200211174938.27809-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com, christoffer.dall@arm.com, Dave.Martin@arm.com, jintack@cs.columbia.edu, alexandru.elisei@arm.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

ARMv8.5-GTG gives the opportunity to advertize the supported Stage-2
page sizes to hypervisors, and allow them to differ from the page sizes
supported at Stage-1.

As KVM cannot support guest Stage-2 page sizes that are smaller than
PAGE_SIZE (it would break the guest's isolation guarantees), let's use
this feature to let the guest know (assuming it has been told about
ARMv8.5-GTG).

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/sysreg.h |  3 +++
 arch/arm64/kvm/nested.c         | 29 +++++++++++++++++++++++++++++
 2 files changed, 32 insertions(+)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 360ef9e8dfe4..a167219e42f4 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -701,6 +701,9 @@
 #define ID_AA64ZFR0_SVEVER_SVE2		0x1
 
 /* id_aa64mmfr0 */
+#define ID_AA64MMFR0_TGRAN4_2_SHIFT	40
+#define ID_AA64MMFR0_TGRAN64_2_SHIFT	36
+#define ID_AA64MMFR0_TGRAN16_2_SHIFT	32
 #define ID_AA64MMFR0_TGRAN4_SHIFT	28
 #define ID_AA64MMFR0_TGRAN64_SHIFT	24
 #define ID_AA64MMFR0_TGRAN16_SHIFT	20
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index cecea8d91196..c40bf753ead9 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -95,6 +95,35 @@ void access_nested_id_reg(struct kvm_vcpu *v, struct sys_reg_params *p,
 		break;
 
 	case SYS_ID_AA64MMFR0_EL1:
+		/* Hide unsupported S2 page sizes */
+		switch (PAGE_SIZE) {
+		case SZ_64K:
+			val &= ~FEATURE(ID_AA64MMFR0_TGRAN16_2);
+			val |= FIELD_PREP(FEATURE(ID_AA64MMFR0_TGRAN16_2), 0b0001);
+			/* Fall through */
+		case SZ_16K:
+			val &= ~FEATURE(ID_AA64MMFR0_TGRAN4_2);
+			val |= FIELD_PREP(FEATURE(ID_AA64MMFR0_TGRAN4_2), 0b0001);
+			/* Fall through */
+		case SZ_4K:
+			/* Support everything */
+			break;
+		}
+		/* Advertize supported S2 page sizes */
+		switch (PAGE_SIZE) {
+		case SZ_4K:
+			val &= ~FEATURE(ID_AA64MMFR0_TGRAN4_2);
+			val |= FIELD_PREP(FEATURE(ID_AA64MMFR0_TGRAN4_2), 0b0010);
+			/* Fall through */
+		case SZ_16K:
+			val &= ~FEATURE(ID_AA64MMFR0_TGRAN16_2);
+			val |= FIELD_PREP(FEATURE(ID_AA64MMFR0_TGRAN16_2), 0b0010);
+			/* Fall through */
+		case SZ_64K:
+			val &= ~FEATURE(ID_AA64MMFR0_TGRAN64_2);
+			val |= FIELD_PREP(FEATURE(ID_AA64MMFR0_TGRAN64_2), 0b0010);
+			break;
+		}
 		/* Cap PARange to 40bits */
 		tmp = FIELD_GET(FEATURE(ID_AA64MMFR0_PARANGE), val);
 		if (tmp > 0b0010) {
-- 
2.20.1

