Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CC9DA4C33
	for <lists+kvm@lfdr.de>; Sun,  1 Sep 2019 23:13:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729118AbfIAVM6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 1 Sep 2019 17:12:58 -0400
Received: from foss.arm.com ([217.140.110.172]:46424 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728891AbfIAVM6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 1 Sep 2019 17:12:58 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EB155360;
        Sun,  1 Sep 2019 14:12:57 -0700 (PDT)
Received: from why.lan (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9A22C3F718;
        Sun,  1 Sep 2019 14:12:56 -0700 (PDT)
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 1/3] arm64: KVM: Drop hyp_alternate_select for checking for ARM64_WORKAROUND_834220
Date:   Sun,  1 Sep 2019 22:12:35 +0100
Message-Id: <20190901211237.11673-2-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190901211237.11673-1-maz@kernel.org>
References: <20190901211237.11673-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There is no reason for using hyp_alternate_select when checking
for ARM64_WORKAROUND_834220, as each of the capabilities is
also backed by a static key. Just replace the KVM-specific
construct with cpus_have_const_cap(ARM64_WORKAROUND_834220).

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/switch.c | 17 ++---------------
 1 file changed, 2 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index adaf266d8de8..a15baca9aca0 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -229,20 +229,6 @@ static void __hyp_text __hyp_vgic_restore_state(struct kvm_vcpu *vcpu)
 	}
 }
 
-static bool __hyp_text __true_value(void)
-{
-	return true;
-}
-
-static bool __hyp_text __false_value(void)
-{
-	return false;
-}
-
-static hyp_alternate_select(__check_arm_834220,
-			    __false_value, __true_value,
-			    ARM64_WORKAROUND_834220);
-
 static bool __hyp_text __translate_far_to_hpfar(u64 far, u64 *hpfar)
 {
 	u64 par, tmp;
@@ -298,7 +284,8 @@ static bool __hyp_text __populate_fault_info(struct kvm_vcpu *vcpu)
 	 * resolve the IPA using the AT instruction.
 	 */
 	if (!(esr & ESR_ELx_S1PTW) &&
-	    (__check_arm_834220()() || (esr & ESR_ELx_FSC_TYPE) == FSC_PERM)) {
+	    (cpus_have_const_cap(ARM64_WORKAROUND_834220) ||
+	     (esr & ESR_ELx_FSC_TYPE) == FSC_PERM)) {
 		if (!__translate_far_to_hpfar(far, &hpfar))
 			return false;
 	} else {
-- 
2.20.1

