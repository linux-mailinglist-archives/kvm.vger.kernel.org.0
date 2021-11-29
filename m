Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 023014621BF
	for <lists+kvm@lfdr.de>; Mon, 29 Nov 2021 21:09:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232114AbhK2UM7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Nov 2021 15:12:59 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:51366 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232115AbhK2UK6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Nov 2021 15:10:58 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5C423CE13D8
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 20:07:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C94E3C53FCD;
        Mon, 29 Nov 2021 20:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638216457;
        bh=9drlAwh2leh8BhdKijYQ2wL0kV3gJrPM63BYQ9ujVxU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tq1+FEw6be9oWD6aDpE0DK7ixkrprlJLK8LULkipLNCJfD2d26EbBIfkJ9x3ScjN9
         gE6MqTDHIn23HZDUmvzzETQrRZkZgRxdCUFMKVdEzhK3k+5WI3S8bRyBnrGqihpoSt
         kj6UcKkCInlqR/Slo7+UqfPHd6F/zusNVoNZU9QhK4eQr9M8WynJh/15ifQndJ4otn
         zBsevBRyo7zVSc8ya+JGrWeMOgKD1K3vmWxT2oJk/RAE+Bq5DznfLdpM90VDNChq3i
         0yeNi2eoI4iFBFBwh9w8ROYKeimC/JrdZaCniA6F1zHOC0KCCd8QZ8vcpJeWaJxPVG
         mG5JmyTL3dzhw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1mrmqy-008gvR-8N; Mon, 29 Nov 2021 20:02:20 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Haibo Xu <haibo.xu@linaro.org>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Subject: [PATCH v5 34/69] KVM: arm64: nv: Configure HCR_EL2 for nested virtualization
Date:   Mon, 29 Nov 2021 20:01:15 +0000
Message-Id: <20211129200150.351436-35-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211129200150.351436-1-maz@kernel.org>
References: <20211129200150.351436-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com, christoffer.dall@arm.com, jintack@cs.columbia.edu, haibo.xu@linaro.org, gankulkarni@os.amperecomputing.com, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jintack Lim <jintack.lim@linaro.org>

We enable nested virtualization by setting the HCR NV and NV1 bit.

When the virtual E2H bit is set, we can support EL2 register accesses
via EL1 registers from the virtual EL2 by doing trap-and-emulate. A
better alternative, however, is to allow the virtual EL2 to access EL2
register states without trap. This can be easily achieved by not traping
EL1 registers since those registers already have EL2 register states.

Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_arm.h |  1 +
 arch/arm64/kvm/hyp/vhe/switch.c  | 38 +++++++++++++++++++++++++++++---
 2 files changed, 36 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 68af5509e4b0..b8a0d410035b 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -87,6 +87,7 @@
 			 HCR_BSU_IS | HCR_FB | HCR_TACR | \
 			 HCR_AMO | HCR_SWIO | HCR_TIDCP | HCR_RW | HCR_TLOR | \
 			 HCR_FMO | HCR_IMO | HCR_PTW )
+#define HCR_GUEST_NV_FILTER_FLAGS (HCR_ATA | HCR_API | HCR_APK | HCR_RW)
 #define HCR_VIRT_EXCP_MASK (HCR_VSE | HCR_VI | HCR_VF)
 #define HCR_HOST_NVHE_FLAGS (HCR_RW | HCR_API | HCR_APK | HCR_ATA)
 #define HCR_HOST_NVHE_PROTECTED_FLAGS (HCR_HOST_NVHE_FLAGS | HCR_TSC)
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 57f43e607819..da80c969e623 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -36,9 +36,41 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
 	u64 hcr = vcpu->arch.hcr_el2;
 	u64 val;
 
-	/* Trap VM sysreg accesses if an EL2 guest is not using VHE. */
-	if (vcpu_mode_el2(vcpu) && !vcpu_el2_e2h_is_set(vcpu))
-		hcr |= HCR_TVM | HCR_TRVM;
+	if (is_hyp_ctxt(vcpu)) {
+		hcr |= HCR_NV;
+
+		if (!vcpu_el2_e2h_is_set(vcpu)) {
+			/*
+			 * For a guest hypervisor on v8.0, trap and emulate
+			 * the EL1 virtual memory control register accesses.
+			 */
+			hcr |= HCR_TVM | HCR_TRVM | HCR_NV1;
+		} else {
+			/*
+			 * For a guest hypervisor on v8.1 (VHE), allow to
+			 * access the EL1 virtual memory control registers
+			 * natively. These accesses are to access EL2 register
+			 * states.
+			 * Note that we still need to respect the virtual
+			 * HCR_EL2 state.
+			 */
+			u64 vhcr_el2 = __vcpu_sys_reg(vcpu, HCR_EL2);
+
+			vhcr_el2 &= ~HCR_GUEST_NV_FILTER_FLAGS;
+
+			/*
+			 * We already set TVM to handle set/way cache maint
+			 * ops traps, this somewhat collides with the nested
+			 * virt trapping for nVHE. So turn this off for now
+			 * here, in the hope that VHE guests won't ever do this.
+			 * TODO: find out whether it's worth to support both
+			 * cases at the same time.
+			 */
+			hcr &= ~HCR_TVM;
+
+			hcr |= vhcr_el2 & (HCR_TVM | HCR_TRVM);
+		}
+	}
 
 	___activate_traps(vcpu, hcr);
 
-- 
2.30.2

