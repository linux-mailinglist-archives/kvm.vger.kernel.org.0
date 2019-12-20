Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 750CC127D63
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2019 15:37:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727972AbfLTOdl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Dec 2019 09:33:41 -0500
Received: from foss.arm.com ([217.140.110.172]:51188 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727783AbfLTOah (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Dec 2019 09:30:37 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B569D106F;
        Fri, 20 Dec 2019 06:30:36 -0800 (PST)
Received: from e119886-lin.cambridge.arm.com (unknown [10.37.6.20])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DC14E3F718;
        Fri, 20 Dec 2019 06:30:34 -0800 (PST)
From:   Andrew Murray <andrew.murray@arm.com>
To:     Marc Zyngier <marc.zyngier@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>
Cc:     Sudeep Holla <sudeep.holla@arm.com>, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH v2 02/18] arm64: KVM: reset E2PB correctly in MDCR_EL2 when exiting the guest(VHE)
Date:   Fri, 20 Dec 2019 14:30:09 +0000
Message-Id: <20191220143025.33853-3-andrew.murray@arm.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191220143025.33853-1-andrew.murray@arm.com>
References: <20191220143025.33853-1-andrew.murray@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sudeep Holla <sudeep.holla@arm.com>

On VHE systems, the reset value for MDCR_EL2.E2PB=b00 which defaults
to profiling buffer using the EL2 stage 1 translations. However if the
guest are allowed to use profiling buffers changing E2PB settings, we
need to ensure we resume back MDCR_EL2.E2PB=b00. Currently we just
do bitwise '&' with MDCR_EL2_E2PB_MASK which will retain the value.

So fix it by clearing all the bits in E2PB.

Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Andrew Murray <andrew.murray@arm.com>
---
 arch/arm64/kvm/hyp/switch.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 72fbbd86eb5e..250f13910882 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -228,9 +228,7 @@ void deactivate_traps_vhe_put(void)
 {
 	u64 mdcr_el2 = read_sysreg(mdcr_el2);
 
-	mdcr_el2 &= MDCR_EL2_HPMN_MASK |
-		    MDCR_EL2_E2PB_MASK << MDCR_EL2_E2PB_SHIFT |
-		    MDCR_EL2_TPMS;
+	mdcr_el2 &= MDCR_EL2_HPMN_MASK | MDCR_EL2_TPMS;
 
 	write_sysreg(mdcr_el2, mdcr_el2);
 
-- 
2.21.0

