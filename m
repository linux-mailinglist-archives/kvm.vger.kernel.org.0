Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31158750C28
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 17:17:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233557AbjGLPRF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 11:17:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232376AbjGLPRA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 11:17:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FDCA1727
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 08:16:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E2C46185C
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 15:16:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A9D0C433CB;
        Wed, 12 Jul 2023 15:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689175014;
        bh=rfxI7Sh9daFDuE8ouniGrC/3Vk1JdjRjJ9OUx9/VLdg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KMKeYsya5PcJ1PtxOW7lr9SsNCGIlpBS4RgZDi9spoonwzK6Fywv5JfBdfqrQoPP4
         67FiLml9Wl1fNXt3VDNjpsSBCywXH5ZZWmk2bdRmuC5Nt2o2749kPBcoH79Zstkr6p
         U3Mibteh8EB3df20HcVGupr/nITiXT8zaSWExQlmF25UQnOQKeqzv3ZfUtRMaYgGu8
         nUOewh6/MpXl+pC24nRZc9xQIeXDpNEwUW7s0J8CoMxvyHwCGkpa0wRWDetfSNDhiF
         B3LqcvwE0kTpchzryySreP0Q9rW5stN7LI6p+MK4VCRSmGVFjblvSIluDmCAaZdSnh
         Ip3v+U16fzeeg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1qJbIu-00CUNF-1W;
        Wed, 12 Jul 2023 15:58:56 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Chase Conklin <chase.conklin@arm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Darren Hart <darren@os.amperecomputing.com>,
        Miguel Luis <miguel.luis@oracle.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 26/27] KVM: arm64: Move HCRX_EL2 switch to load/put on VHE systems
Date:   Wed, 12 Jul 2023 15:58:09 +0100
Message-Id: <20230712145810.3864793-27-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230712145810.3864793-1-maz@kernel.org>
References: <20230712145810.3864793-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com, eric.auger@redhat.com, broonie@kernel.org, mark.rutland@arm.com, will@kernel.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, gankulkarni@os.amperecomputing.com, darren@os.amperecomputing.com, miguel.luis@oracle.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Although the nVHE behaviour requires HCRX_EL2 to be switched
on each switch between host and guest, there is nothing in
this register that would affect a VHE host.

It is thus possible to save/restore this register on load/put
on VHE systems, avoiding unnecessary sysreg access on the hot
path. Additionally, it avoids unnecessary traps when running
with NV.

To achieve this, simply move the read/writes to the *_common()
helpers, which are called on load/put on VHE, and more eagerly
on nVHE.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 5fa1ae26f075..f07523d7d4ec 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -196,6 +196,9 @@ static inline void __activate_traps_common(struct kvm_vcpu *vcpu)
 	vcpu->arch.mdcr_el2_host = read_sysreg(mdcr_el2);
 	write_sysreg(vcpu->arch.mdcr_el2, mdcr_el2);
 
+	if (cpus_have_final_cap(ARM64_HAS_HCX))
+		write_sysreg_s(HCRX_GUEST_FLAGS, SYS_HCRX_EL2);
+
 	__activate_traps_hfgxtr(vcpu);
 }
 
@@ -212,6 +215,9 @@ static inline void __deactivate_traps_common(struct kvm_vcpu *vcpu)
 		vcpu_clear_flag(vcpu, PMUSERENR_ON_CPU);
 	}
 
+	if (cpus_have_final_cap(ARM64_HAS_HCX))
+		write_sysreg_s(HCRX_HOST_FLAGS, SYS_HCRX_EL2);
+
 	__deactivate_traps_hfgxtr(vcpu);
 }
 
@@ -226,9 +232,6 @@ static inline void ___activate_traps(struct kvm_vcpu *vcpu)
 
 	if (cpus_have_final_cap(ARM64_HAS_RAS_EXTN) && (hcr & HCR_VSE))
 		write_sysreg_s(vcpu->arch.vsesr_el2, SYS_VSESR_EL2);
-
-	if (cpus_have_final_cap(ARM64_HAS_HCX))
-		write_sysreg_s(HCRX_GUEST_FLAGS, SYS_HCRX_EL2);
 }
 
 static inline void ___deactivate_traps(struct kvm_vcpu *vcpu)
@@ -243,9 +246,6 @@ static inline void ___deactivate_traps(struct kvm_vcpu *vcpu)
 		vcpu->arch.hcr_el2 &= ~HCR_VSE;
 		vcpu->arch.hcr_el2 |= read_sysreg(hcr_el2) & HCR_VSE;
 	}
-
-	if (cpus_have_final_cap(ARM64_HAS_HCX))
-		write_sysreg_s(HCRX_HOST_FLAGS, SYS_HCRX_EL2);
 }
 
 static inline bool __populate_fault_info(struct kvm_vcpu *vcpu)
-- 
2.34.1

