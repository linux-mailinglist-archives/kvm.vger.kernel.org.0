Return-Path: <kvm+bounces-54859-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CE0C9B294F3
	for <lists+kvm@lfdr.de>; Sun, 17 Aug 2025 22:22:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4B11A2035A1
	for <lists+kvm@lfdr.de>; Sun, 17 Aug 2025 20:22:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF8692FC880;
	Sun, 17 Aug 2025 20:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X6katjZc"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58B95242D84;
	Sun, 17 Aug 2025 20:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755462126; cv=none; b=SwS3UOL33veMoyHIF3cypmKkNozjTMS0msQpq6cGwOw6rgp2y1oJ9Hr1t5vwqe1s2EoCPnGRsOjyHqmgC4d4QDP/Hu8CzHonAhhJmchrqhfVTR3CHIz+wCxyh7lG3sq3iX0yfEoOLPs0kdyHkwxtGkEeuEAimv2EItkX32I3lVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755462126; c=relaxed/simple;
	bh=a1ciFFHUrNYknE+TBc4JNqPphY8KkfsdZHtRRnEBglw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=b93+mWKA65Qn8TNWqwVrvXHmf3cEkATqhx+t0NpLVPwgvq7m9Nn067/NQ3lQBMr+m+v0IA07rOS9aQTjOdhS9SSRUoWWqZlvipD65fs3Qo4P1CBWE6O3gqTsfRpz5vhN4VSs53vYkNQoGhfjF3ztn91ayFI6oot9Dh/CYEYQkW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X6katjZc; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 094A3C19421;
	Sun, 17 Aug 2025 20:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755462126;
	bh=a1ciFFHUrNYknE+TBc4JNqPphY8KkfsdZHtRRnEBglw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X6katjZc6Di9tkdax2Rt6GMVr3B0dVqmTJqZhcsxj02MGrRGOw4MfuI1K89uvKWKY
	 Ql9REr9TklwrJo6NFpbn+EvCMBqL7tnkgVrla/cHUJaNaUTZN8QKG4voHK7PI0tAj/
	 2SJQQNfCHpNILCSV25f+Gc2PpCPxY91M5yIekWRS5ndN4w9+y+O0knUWm2cc98R7Us
	 1r/DY0GYG7p1HfqO4F/nFJPxskSvya3LuHMeaJ1bkkSNjRv2Zi9OOpl1unhwmgB0gw
	 uDZUzzHfugTbMqE+VllkcwXGzgsEGrntZ4RBculR1Ak721Bqv2xV6C1W1bcyjYk9l5
	 cbEQY4l/SekCQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1unjtD-008PX0-Vc;
	Sun, 17 Aug 2025 21:22:04 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Cornelia Huck <cohuck@redhat.com>
Subject: [PATCH v3 5/6] KVM: arm64: Make ID_AA64PFR1_EL1.RAS_frac writable
Date: Sun, 17 Aug 2025 21:21:57 +0100
Message-Id: <20250817202158.395078-6-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250817202158.395078-1-maz@kernel.org>
References: <20250817202158.395078-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, will@kernel.org, catalin.marinas@arm.com, cohuck@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Allow userspace to write to RAS_frac, under the condition that
the host supports RASv1p1 with RAS_frac==1. Other configurations
will result in RAS_frac being exposed as 0, and therefore implicitly
not writable.

To avoid the clutter, the ID_AA64PFR1_EL1 sanitisation is moved to
its own function.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/nested.c   |  3 ++-
 arch/arm64/kvm/sys_regs.c | 41 ++++++++++++++++++++++++++-------------
 2 files changed, 29 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 153b3e11b115d..1b0aedacc3f59 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1458,9 +1458,10 @@ u64 limit_nv_id_reg(struct kvm *kvm, u32 reg, u64 val)
 		break;
 
 	case SYS_ID_AA64PFR1_EL1:
-		/* Only support BTI, SSBS, CSV2_frac */
+		/* Only support BTI, SSBS, RAS_frac, CSV2_frac */
 		val &= (ID_AA64PFR1_EL1_BT	|
 			ID_AA64PFR1_EL1_SSBS	|
+			ID_AA64PFR1_EL1_RAS_frac|
 			ID_AA64PFR1_EL1_CSV2_frac);
 		break;
 
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 3306fef432cbb..e149786f8bde0 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1584,6 +1584,7 @@ static u8 pmuver_to_perfmon(u8 pmuver)
 }
 
 static u64 sanitise_id_aa64pfr0_el1(const struct kvm_vcpu *vcpu, u64 val);
+static u64 sanitise_id_aa64pfr1_el1(const struct kvm_vcpu *vcpu, u64 val);
 static u64 sanitise_id_aa64dfr0_el1(const struct kvm_vcpu *vcpu, u64 val);
 
 /* Read a sanitised cpufeature ID register by sys_reg_desc */
@@ -1606,19 +1607,7 @@ static u64 __kvm_read_sanitised_id_reg(const struct kvm_vcpu *vcpu,
 		val = sanitise_id_aa64pfr0_el1(vcpu, val);
 		break;
 	case SYS_ID_AA64PFR1_EL1:
-		if (!kvm_has_mte(vcpu->kvm)) {
-			val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_EL1_MTE);
-			val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_EL1_MTE_frac);
-		}
-
-		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_EL1_SME);
-		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_EL1_RNDR_trap);
-		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_EL1_NMI);
-		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_EL1_GCS);
-		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_EL1_THE);
-		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_EL1_MTEX);
-		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_EL1_PFAR);
-		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_EL1_MPAM_frac);
+		val = sanitise_id_aa64pfr1_el1(vcpu, val);
 		break;
 	case SYS_ID_AA64PFR2_EL1:
 		val &= ID_AA64PFR2_EL1_FPMR |
@@ -1836,6 +1825,31 @@ static u64 sanitise_id_aa64pfr0_el1(const struct kvm_vcpu *vcpu, u64 val)
 	return val;
 }
 
+static u64 sanitise_id_aa64pfr1_el1(const struct kvm_vcpu *vcpu, u64 val)
+{
+	u64 pfr0 = read_sanitised_ftr_reg(SYS_ID_AA64PFR0_EL1);
+
+	if (!kvm_has_mte(vcpu->kvm)) {
+		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_EL1_MTE);
+		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_EL1_MTE_frac);
+	}
+
+	if (!(cpus_have_final_cap(ARM64_HAS_RASV1P1_EXTN) &&
+	      SYS_FIELD_GET(ID_AA64PFR0_EL1, RAS, pfr0) == ID_AA64PFR0_EL1_RAS_IMP))
+		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_EL1_RAS_frac);
+
+	val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_EL1_SME);
+	val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_EL1_RNDR_trap);
+	val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_EL1_NMI);
+	val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_EL1_GCS);
+	val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_EL1_THE);
+	val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_EL1_MTEX);
+	val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_EL1_PFAR);
+	val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_EL1_MPAM_frac);
+
+	return val;
+}
+
 static u64 sanitise_id_aa64dfr0_el1(const struct kvm_vcpu *vcpu, u64 val)
 {
 	val = ID_REG_LIMIT_FIELD_ENUM(val, ID_AA64DFR0_EL1, DebugVer, V8P8);
@@ -2954,7 +2968,6 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 				       ID_AA64PFR1_EL1_SME |
 				       ID_AA64PFR1_EL1_RES0 |
 				       ID_AA64PFR1_EL1_MPAM_frac |
-				       ID_AA64PFR1_EL1_RAS_frac |
 				       ID_AA64PFR1_EL1_MTE)),
 	ID_WRITABLE(ID_AA64PFR2_EL1,
 		    ID_AA64PFR2_EL1_FPMR |
-- 
2.39.2


