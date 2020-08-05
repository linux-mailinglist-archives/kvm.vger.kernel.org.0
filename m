Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96A0523CEFA
	for <lists+kvm@lfdr.de>; Wed,  5 Aug 2020 21:11:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728854AbgHETL1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Aug 2020 15:11:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:35360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728874AbgHESaU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Aug 2020 14:30:20 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3184222DFB;
        Wed,  5 Aug 2020 18:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596652020;
        bh=dxhW8/AeZjUnxe+PJofqSFXP/Hhd4d4Rgqxp0UL3Rfc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OCKl2X3oe9wXjLFurVAeHdP02wRsYLxTJPSrwI5Xnp4773wX2wIO8FHHnvH5Hp5N7
         RdBoiRlt5IVezZFmJxo0gpzGobpPMkQrWEsq3Bz8qJjpRoGizmClanAG0IG41kUJQL
         c+UHH4NQxwHnB7a8HoanNI8UAHcEbITs75NnATng=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1k3Nfe-0004w9-UK; Wed, 05 Aug 2020 18:57:47 +0100
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
Subject: [PATCH 28/56] KVM: arm64: vgic-its: Change default outer cacheability for {PEND, PROP}BASER
Date:   Wed,  5 Aug 2020 18:56:32 +0100
Message-Id: <20200805175700.62775-29-maz@kernel.org>
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

From: Alexander Graf <graf@amazon.com>

PENDBASER and PROPBASER define the outer caching mode for LPI tables.
The memory backing them may not be outer sharable, so we mark them as nC
by default. This however, breaks Windows on ARM which only accepts
SameAsInner or RaWaWb as values for outer cachability.

We do today already allow the outer mode to be set to SameAsInner
explicitly, so the easy fix is to default to that instead of nC for
situations when an OS asks for a not fulfillable cachability request.

This fixes booting Windows in KVM with vgicv3 and ITS enabled for me.

Signed-off-by: Alexander Graf <graf@amazon.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20200701140206.8664-1-graf@amazon.com
---
 arch/arm64/kvm/vgic/vgic-mmio-v3.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index d2339a2b9fb9..5c786b915cd3 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -389,7 +389,7 @@ u64 vgic_sanitise_outer_cacheability(u64 field)
 	case GIC_BASER_CACHE_nC:
 		return field;
 	default:
-		return GIC_BASER_CACHE_nC;
+		return GIC_BASER_CACHE_SameAsInner;
 	}
 }
 
-- 
2.27.0

