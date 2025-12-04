Return-Path: <kvm+bounces-65261-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BE58CA3139
	for <lists+kvm@lfdr.de>; Thu, 04 Dec 2025 10:49:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id C9CA43008BC9
	for <lists+kvm@lfdr.de>; Thu,  4 Dec 2025 09:48:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63114338932;
	Thu,  4 Dec 2025 09:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nYbUB4OH"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 748B6337B97;
	Thu,  4 Dec 2025 09:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764841717; cv=none; b=YZrF9SRclOteTkxJ7lzTXGM/rShwB1kMQhhRNUYJicQqdp5LMXrL6UTv7lL+7M0YxZRe9rcHzHo3vq2da449I1mObYaSEq+8jeeqeYdkszv75kSSKvtwax+I8GlU8K7/oFIEzguT6OKidRu6n1+i8Cya8abzQ8IpQhACGephrXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764841717; c=relaxed/simple;
	bh=4XVkua0rEg/vz2zwquEpsKlRnQFatRDvaCblm+Lr3ac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MF24L5+aRiCnMiXdUu810knww6MfjGQUNg9VX9MmpjRQdBmk4CK9AqCnAqsP9x2+J6/1dLvfhfBAc/OZyir96o/8R9kxcy0fiDJL70VoIXAkY6z9mZemeVIDhGQH/lL1EczktgiMR2GPB2B/DdpOqpCuTNhgqi2+Fb/g05HLr+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nYbUB4OH; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B776C116C6;
	Thu,  4 Dec 2025 09:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764841717;
	bh=4XVkua0rEg/vz2zwquEpsKlRnQFatRDvaCblm+Lr3ac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nYbUB4OHlg/w1pXC/ufdNxR2DhvnYpiuJagy6bN68/+EeySWZ41OrQpqQLm8cKSb7
	 p608CI9t+4j3uS+lS5VzSBhrFCBRizQsTBWURm5h9AJMJVwOKaAE6MRT/DuY6k2utF
	 HBu99WfUfDXnyYFV0MsqFdg7/DhsXxA/7iRimsL1SLFBqxga/53DOxOtqG9Tz83l1C
	 sDDeO8kXIonGXDyoYYDFhDlEQpNSXpbNu/GEGy7HdNNwaMHnGK5fP3mCAtR4X0lvpw
	 8DiGyBsNG5cIcuNHXL2rruOFOALzcnd8pCj7FClLuIu0DU1IQj19jBZ0obB1EEPKIC
	 Lh3huyyxenKsA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vR5wx-0000000AP90-0I6P;
	Thu, 04 Dec 2025 09:48:35 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Ben Horgan <ben.horgan@arm.com>,
	Yao Yuan <yaoyuan@linux.alibaba.com>
Subject: [PATCH v3 4/9] KVM: arm64: Handle FEAT_IDST for sysregs without specific handlers
Date: Thu,  4 Dec 2025 09:48:01 +0000
Message-ID: <20251204094806.3846619-5-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251204094806.3846619-1-maz@kernel.org>
References: <20251204094806.3846619-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, ben.horgan@arm.com, yaoyuan@linux.alibaba.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Add a bit of infrastrtcture to triage_sysreg_trap() to handle the
case of registers falling into the Feature ID space that do not
have a local handler.

For these, we can directly apply the FEAT_IDST semantics and inject
an EC=0x18 exception. Otherwise, an UNDEF will do.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/emulate-nested.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 616eb6ad68701..fac2707221b47 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -2588,6 +2588,26 @@ bool triage_sysreg_trap(struct kvm_vcpu *vcpu, int *sr_index)
 
 		params = esr_sys64_to_params(esr);
 
+		/*
+		 * This implements the pseudocode UnimplementedIDRegister()
+		 * helper for the purpose of fealing with FEAT_IDST.
+		 *
+		 * The Feature ID space is defined as the System register
+		 * space in AArch64 with op0==3, op1=={0, 1, 3}, CRn==0,
+		 * CRm=={0-7}, op2=={0-7}.
+		 */
+		if (params.Op0 == 3 &&
+		    !(params.Op1 & 0b100) && params.Op1 != 2 &&
+		    params.CRn == 0 &&
+		    !(params.CRm & 0b1000)) {
+			if (kvm_has_feat_enum(vcpu->kvm, ID_AA64MMFR2_EL1, IDS, IMP))
+				kvm_inject_sync(vcpu, kvm_vcpu_get_esr(vcpu));
+			else
+				kvm_inject_undefined(vcpu);
+
+			return true;
+		}
+
 		/*
 		 * Check for the IMPDEF range, as per DDI0487 J.a,
 		 * D18.3.2 Reserved encodings for IMPLEMENTATION
-- 
2.47.3


