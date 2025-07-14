Return-Path: <kvm+bounces-52386-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C662B04B5E
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 01:03:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1B3F516E086
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 23:03:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97C272951CB;
	Mon, 14 Jul 2025 22:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="se0CURER"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f74.google.com (mail-io1-f74.google.com [209.85.166.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E2DC28B40D
	for <kvm@vger.kernel.org>; Mon, 14 Jul 2025 22:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752533987; cv=none; b=gK6DPk3ieePhgHDOPG3ohkwQfZMchYYKSagZxmuKyaivU1swYJGBJGBMD5gGhGdfJqeWnBlAmwjJvlaZEptusrEybGpNW2pM8/Xw/pAQaZPPyN2XotUHa5ooaLAU/8PGeUCrhc0XtAf5NVG9lehrmtgFMBG/EVthoqRU6Y6UOOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752533987; c=relaxed/simple;
	bh=/fFdI8wVfZFbSMTxD9yoD8XUlrA4EM1qvQESFfNH+cI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CJhx0qkoGfyuvjYQNIL13Tw72TesR5LdoHB4o/R7Ps2EvYdYMWUfc22n330sT7DRiUkwkVN1OBzmsylJoXPU/zQH2r3kWKD7vtOlFnOXjm3etCCZv8bTju2EKCAkWuXJHQfE4RwujO4GqwDnRsTJqoX3CpxlVMokdEIq0ViYKbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=se0CURER; arc=none smtp.client-ip=209.85.166.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-io1-f74.google.com with SMTP id ca18e2360f4ac-8760733a107so544740539f.3
        for <kvm@vger.kernel.org>; Mon, 14 Jul 2025 15:59:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752533982; x=1753138782; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HKFKaT34CSY+XrjUi/PaqmOwj/haOI4Kmp3zrewTJxs=;
        b=se0CURERzQun2hfI6uslzyyGyejXi/W/9G9kNuUPc4elIyyIUTJ8IwyRNv0//4ysLT
         kwQPQZ6hN4/3RDytzgg3Rxo9D8S1xB0N6TSYcVUuFjY1ZOEXXwf3VX5LPepobOf3LlAy
         Pjguu+bLOA+WuOagZPzcPSbbXyPct7iYvuwZlz1BTW2ksCYpxtXqknQSFTjMIbZl/96L
         enNlLWSEhiHNj45rnDVQV8TaxaZhZ0YadYGJNiKHLg7196LzM3vGWUgpNwO5kMW+orFe
         1ifRWRE4U6UbelnYTwrEONY9zGtuBbKepWlQ9hUMfByTVAq42ifCIg6PVy6xr9YO1Hce
         SMew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752533982; x=1753138782;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HKFKaT34CSY+XrjUi/PaqmOwj/haOI4Kmp3zrewTJxs=;
        b=sEnH/tipHkiaD19XxdjRODxz4NOslBHecg1kNLYsbWb8iFtkD/RPMLGKA8z9HktFen
         A3zLcxKezqRuPbUKEJJzcIpgzZoilJDt21H8L9r6+X5YL3iowox+HoUVReRmNHU49Yle
         5wgnZOg9cLQgnlvt0jmxgtrYmd1iQwPe5EchOWVGIlqyTOlfWJ3frNBjlH7Il4JtkKdE
         gCPyeAp0hrup9L1+BxIg5Q6jL7CtggE/l48osZllwNBCwG0TePIhwLX+xduqDiyBFxnT
         h2NiYfCaADmhYFGps1dSh0uGEyekRE+tI6DvqeHxMk1ROJCZPvYpvsIe9BYdC1itgLTt
         57Og==
X-Gm-Message-State: AOJu0YxGF8HARaHi98agP7mIp6iFuQ02sYJATK2aLp/EV5cJp9DygwnQ
	OT9vkhV2blKK18K9vpUB23MDq4J57ek9vtDS1wfcUKVRmlNR2MnYvl+lSF/n4euUdSlEMPU7iAb
	TY09FNWxGH6hnybNeWeet0eicWxiJz7hvXlIDIyMd46HefKI8T5RgY9t5Un2c4Gg6IfWpPJU5Cs
	mPJ6jsgfO0vFW92WgUWfO8hOwll6LI2AnIAanLhG9g4xUr/8Qv1IlNgHEhSK8=
X-Google-Smtp-Source: AGHT+IFHDkydm6wR47l1+EJ847BUB3r6NTWQGkm6LnVFFK97D4N3qaxOkSTSlfCSEPiOoL+l6dOgeUU/KUc+l3ngkQ==
X-Received: from ioy17.prod.google.com ([2002:a05:6602:a111:b0:876:c211:2aad])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6602:4019:b0:876:7876:a587 with SMTP id ca18e2360f4ac-87977e98946mr1665370139f.0.1752533982373;
 Mon, 14 Jul 2025 15:59:42 -0700 (PDT)
Date: Mon, 14 Jul 2025 22:59:06 +0000
In-Reply-To: <20250714225917.1396543-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250714225917.1396543-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250714225917.1396543-13-coltonlewis@google.com>
Subject: [PATCH v4 12/23] KVM: arm64: Writethrough trapped PMOVS register
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Mingwei Zhang <mizhang@google.com>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Mark Rutland <mark.rutland@arm.com>, Shuah Khan <shuah@kernel.org>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

With FGT in place, the remaining trapped registers need to be written
through to the underlying physical registers as well as the virtual
ones. Failing to do this means delaying when guest writes take effect.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/include/asm/arm_pmuv3.h | 10 ++++++++++
 arch/arm64/kvm/sys_regs.c          | 17 ++++++++++++++++-
 2 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/arm_pmuv3.h b/arch/arm64/include/asm/arm_pmuv3.h
index 60600f04b590..3e25c0313263 100644
--- a/arch/arm64/include/asm/arm_pmuv3.h
+++ b/arch/arm64/include/asm/arm_pmuv3.h
@@ -140,6 +140,16 @@ static inline u64 read_pmicfiltr(void)
 	return read_sysreg_s(SYS_PMICFILTR_EL0);
 }
 
+static inline void write_pmovsset(u64 val)
+{
+	write_sysreg(val, pmovsset_el0);
+}
+
+static inline u64 read_pmovsset(void)
+{
+	return read_sysreg(pmovsset_el0);
+}
+
 static inline void write_pmovsclr(u64 val)
 {
 	write_sysreg(val, pmovsclr_el0);
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index e761538e1e17..68457655a10b 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1171,6 +1171,19 @@ static bool access_pminten(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	return true;
 }
 
+static void writethrough_pmovs(struct kvm_vcpu *vcpu, struct sys_reg_params *p, bool set)
+{
+	u64 mask = kvm_pmu_accessible_counter_mask(vcpu);
+
+	if (set) {
+		__vcpu_rmw_sys_reg(vcpu, PMOVSSET_EL0, |=, (p->regval & mask));
+		write_pmovsset(p->regval & mask);
+	} else {
+		__vcpu_rmw_sys_reg(vcpu, PMOVSSET_EL0, &=, ~(p->regval & mask));
+		write_pmovsclr(p->regval & mask);
+	}
+}
+
 static bool access_pmovs(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 			 const struct sys_reg_desc *r)
 {
@@ -1179,7 +1192,9 @@ static bool access_pmovs(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	if (pmu_access_el0_disabled(vcpu))
 		return false;
 
-	if (p->is_write) {
+	if (kvm_vcpu_pmu_is_partitioned(vcpu) && p->is_write) {
+		writethrough_pmovs(vcpu, p, r->CRm & 0x2);
+	} else if (p->is_write) {
 		if (r->CRm & 0x2)
 			/* accessing PMOVSSET_EL0 */
 			__vcpu_rmw_sys_reg(vcpu, PMOVSSET_EL0, |=, (p->regval & mask));
-- 
2.50.0.727.gbf7dc18ff4-goog


