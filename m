Return-Path: <kvm+bounces-15235-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F01B38AACDA
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 12:31:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 58640B20C62
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 10:31:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 737558120D;
	Fri, 19 Apr 2024 10:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Nsx5reaj"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B70897EEE2;
	Fri, 19 Apr 2024 10:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713522592; cv=none; b=K4dG/DGpUHlfmGlvhNcEK/4ZM1H8KGxF375f0KrlBKp/+XnZAE3aCzuaJiiGXS47uEsagt4kQG7+YDN6PviCA+eMQXF+qlisAfro0Zqc9yoWarnCSkqZgxgwrUFypRGj+YF8KpKzydg2gwfx0EoQ4q4XNGjuob3ueJI+4NoPEQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713522592; c=relaxed/simple;
	bh=rJmMMlu/EinsrjbvBVICmMTEOhhWE5CChovNG2i8Ifw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Ip5pnqqxtoAfxyHf6oyaM0/U6s9b6JzAJmX/Qrh/tFxQ7/9LWDLjzdcjuyORonAJ9X5xx1bymbIjhwywB98EmecyllZPzx6usGVqoEHBSMaKzXHVC6ik0wso5qz6pCp61YP1ykYKmMboJjWYoYCklGpUSeN4myTzyv1m3o68btI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Nsx5reaj; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DCF4C32786;
	Fri, 19 Apr 2024 10:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713522592;
	bh=rJmMMlu/EinsrjbvBVICmMTEOhhWE5CChovNG2i8Ifw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nsx5reaj/IYZtKKl7cIFwaMF4js+8ZgAmTEug7a3YxT2WCwb7gADYE7wVKKywMAzw
	 9odbFlDhtB9EtCpkXrNtmDxmHkvEyrKlgsVXJJim+OVRjSnHY1XWLqyFeB/q5XfVlH
	 WvI7OaavUQ+xh/nV82gQ1cCuhNlVQtdBbj69St/kCl9lReF0/t5LQXwfw8r03XatJL
	 OaF6Vu9DafapjVZbRPiFViAlE6P42iIOOKzSQUViPvXvuSqoAMdYNYZWHhOV1o71MQ
	 F/qUlIm8lXz7sDfa081s5uqKbLXUmVf7kn2eByXY7M1UNIfjuHhHZAS+BfSzT4V+uj
	 P19goBh3hSF5A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rxlV8-00636W-UR;
	Fri, 19 Apr 2024 11:29:51 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Mostafa Saleh <smostafa@google.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH v4 09/15] KVM: arm64: nv: Handle HCR_EL2.{API,APK} independently
Date: Fri, 19 Apr 2024 11:29:29 +0100
Message-Id: <20240419102935.1935571-10-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240419102935.1935571-1-maz@kernel.org>
References: <20240419102935.1935571-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, tabba@google.com, smostafa@google.com, will@kernel.org, catalin.marinas@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Although KVM couples API and APK for simplicity, the architecture
makes no such requirement, and the two can be independently set or
cleared.

Check for which of the two possible reasons we have trapped here,
and if the corresponding L1 control bit isn't set, delegate the
handling for forwarding.

Otherwise, set this exact bit in HCR_EL2 and resume the guest.
Of course, in the non-NV case, we keep setting both bits and
be done with it. Note that the entry core already saves/restores
the keys should any of the two control bits be set.

This results in a bit of rework, and the removal of the (trivial)
vcpu_ptrauth_enable() helper.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_emulate.h    |  5 ----
 arch/arm64/kvm/hyp/include/hyp/switch.h | 32 +++++++++++++++++++++----
 2 files changed, 27 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 975af30af31f..87f2c31f3206 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -125,11 +125,6 @@ static inline void vcpu_set_wfx_traps(struct kvm_vcpu *vcpu)
 	vcpu->arch.hcr_el2 |= HCR_TWI;
 }
 
-static inline void vcpu_ptrauth_enable(struct kvm_vcpu *vcpu)
-{
-	vcpu->arch.hcr_el2 |= (HCR_API | HCR_APK);
-}
-
 static inline void vcpu_ptrauth_disable(struct kvm_vcpu *vcpu)
 {
 	vcpu->arch.hcr_el2 &= ~(HCR_API | HCR_APK);
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index f5f701f309a9..a0908d7a8f56 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -480,11 +480,35 @@ DECLARE_PER_CPU(struct kvm_cpu_context, kvm_hyp_ctxt);
 static bool kvm_hyp_handle_ptrauth(struct kvm_vcpu *vcpu, u64 *exit_code)
 {
 	struct kvm_cpu_context *ctxt;
-	u64 val;
+	u64 enable = 0;
 
 	if (!vcpu_has_ptrauth(vcpu))
 		return false;
 
+	/*
+	 * NV requires us to handle API and APK independently, just in
+	 * case the hypervisor is totally nuts. Please barf >here<.
+	 */
+	if (vcpu_has_nv(vcpu) && !is_hyp_ctxt(vcpu)) {
+		switch (ESR_ELx_EC(kvm_vcpu_get_esr(vcpu))) {
+		case ESR_ELx_EC_PAC:
+			if (!(__vcpu_sys_reg(vcpu, HCR_EL2) & HCR_API))
+				return false;
+
+			enable |= HCR_API;
+			break;
+
+		case ESR_ELx_EC_SYS64:
+			if (!(__vcpu_sys_reg(vcpu, HCR_EL2) & HCR_APK))
+				return false;
+
+			enable |= HCR_APK;
+			break;
+		}
+	} else {
+		enable = HCR_API | HCR_APK;
+	}
+
 	ctxt = this_cpu_ptr(&kvm_hyp_ctxt);
 	__ptrauth_save_key(ctxt, APIA);
 	__ptrauth_save_key(ctxt, APIB);
@@ -492,11 +516,9 @@ static bool kvm_hyp_handle_ptrauth(struct kvm_vcpu *vcpu, u64 *exit_code)
 	__ptrauth_save_key(ctxt, APDB);
 	__ptrauth_save_key(ctxt, APGA);
 
-	vcpu_ptrauth_enable(vcpu);
 
-	val = read_sysreg(hcr_el2);
-	val |= (HCR_API | HCR_APK);
-	write_sysreg(val, hcr_el2);
+	vcpu->arch.hcr_el2 |= enable;
+	sysreg_clear_set(hcr_el2, 0, enable);
 
 	return true;
 }
-- 
2.39.2


