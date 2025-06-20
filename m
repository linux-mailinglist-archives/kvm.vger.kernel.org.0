Return-Path: <kvm+bounces-50187-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 30047AE2548
	for <lists+kvm@lfdr.de>; Sat, 21 Jun 2025 00:23:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B17BE4A5484
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 22:23:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 197E625A2A7;
	Fri, 20 Jun 2025 22:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VRuzgIXq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f74.google.com (mail-io1-f74.google.com [209.85.166.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9901625487D
	for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 22:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750457936; cv=none; b=FX9h76HxFXRCbbnSWrWKafIE4Cz3p0g6iTHVlxpMeGVj+9v92tp8f6n4FKbYSrLMbr0X/k/8IYNlC1Hy2tPoeDlBYrzdasHkQRIKHpdko3qKp8SiRzQHYV7lKt8jRY6N6YWSsyJx1DiGm2Zh0Oje22bj89p8txotjcueQvnXm+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750457936; c=relaxed/simple;
	bh=M4XcPGm72140qEI7iQ0ptN69kSxOw9Z73/VRQYhovoM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IZjvMJERbYA1Gr/2CIFEADTICyeub0fUAyDAHbWDaDBwf3SUhE1QQYooFusjGrPJd51rcIk5GUOumbwqFoLUIYm6PXcDCSWOT8AYYTYEhuH0J08eAS/KUkJVqybo/2OWJYVFQ8hQpPCH7OlJ/usnsm3ak8hD3v1fVR6JZaLyRvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VRuzgIXq; arc=none smtp.client-ip=209.85.166.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-io1-f74.google.com with SMTP id ca18e2360f4ac-87632a0275dso42682939f.1
        for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 15:18:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750457932; x=1751062732; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=EUwcqeVf5KIMoAmCHhrWA0WRgfRVQt5PquOGXBH2GsU=;
        b=VRuzgIXq4ZgNE2gvTj71GUc9AU/hjLFwatQGAzWzjNevoK36wahhQY6S9aazL7KCwq
         ljqlE1RGHjnGvwijGn7kO5dSWBBT8eAt+o45gJB6ZC8/nPyYJwPTRRCj2k5qCdVKIh8G
         t/on6l8dAvs7clgdCUduiEl0pG/XSe2XUMB7vOVfRSIjOvWgllgG74CPpOSCPNHqKr5O
         lMyfQjJukJvgL2VyKMCoaRr+72yhG7dkOwgJ5Q5ozpaLuqa9wS9MtA6iE8NGFkqSyEVc
         eojhLOc3QH4t19pjDztmb4YBFXBfhCXkVYDyI2QFyVE3YgzyTOICYswaAOpVSMCznWNv
         6dqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750457932; x=1751062732;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EUwcqeVf5KIMoAmCHhrWA0WRgfRVQt5PquOGXBH2GsU=;
        b=IJe0uCpTCeJmv7grDCVkW8niaX6ZD0+61uakiPNP5iUBTP86YPYoV6PxanJKxPVTBn
         z/JvBrDNVG7y8m1HJ7RJdaaq3IvauPtoFbw6ZP38GNOWFY3/paedQAeErJ+SrggiqiGy
         t82oGGC8yRVWM/Py6CT0k2hc9VFEHNLSf90j2V1PrQFWX6fjWtZMr6IU45otLcO8NcHQ
         ufDV0u51fBNcpJGbgSlbCVeyLTy72IBgwEUKpH3cmw7Nefv0O98rhuZKcFQFTaGnhHwf
         SezmDV1iDOxyfvp47mh1VmKtxB2pbmAV9EFDwuaY1W0fYa5rO+kcBHUh/vhiTVx0NV5t
         pVig==
X-Gm-Message-State: AOJu0Yzp6t/ttipuyMlF4b93v39/qzdnscke81bPy/pMaPjyf2if7ctY
	glt/caS0ncFUMJSWo2mlU1aGjdpJsoMXBEQHzQsWj0Uc2tWmeJqjjJGHxZ1v1RP9pVHqEt35dOd
	Ewa8VmkBwX8qpmfwDoL4SPRsQc6NGGUGX/MhkYAg4agAGJRCLCvo9hlv9mp0m+31jdOqa38+SOh
	CreTtevWwk1+YsIMhR6DfuSS9Luh4J0Hba9csnwC3JOLwjCKOavzKn9iE9n3E=
X-Google-Smtp-Source: AGHT+IECQiJFomMTnsPbeme3Oi7RJjR0YLkrmdcXG9nsdHvxsNa0RAqjFaN0Cl+MqvohmdUapqaunpxSDwgZDSywoA==
X-Received: from ilff3.prod.google.com ([2002:a05:6e02:5e03:b0:3dd:a3df:9d57])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6e02:16ce:b0:3dd:d653:5a05 with SMTP id e9e14a558f8ab-3de38c1bec3mr55840665ab.3.1750457932182;
 Fri, 20 Jun 2025 15:18:52 -0700 (PDT)
Date: Fri, 20 Jun 2025 22:13:15 +0000
In-Reply-To: <20250620221326.1261128-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250620221326.1261128-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.50.0.714.g196bf9f422-goog
Message-ID: <20250620221326.1261128-16-coltonlewis@google.com>
Subject: [PATCH v2 14/23] KVM: arm64: Writethrough trapped PMOVS register
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Mark Rutland <mark.rutland@arm.com>, 
	Shuah Khan <shuah@kernel.org>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Colton Lewis <coltonlewis@google.com>
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
index 1880e426a559..3bddde5f4ebb 100644
--- a/arch/arm64/include/asm/arm_pmuv3.h
+++ b/arch/arm64/include/asm/arm_pmuv3.h
@@ -142,6 +142,16 @@ static inline u64 read_pmicfiltr(void)
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
index 3140d90849c1..627c31db84d2 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1174,6 +1174,19 @@ static bool access_pminten(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
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
@@ -1182,7 +1195,9 @@ static bool access_pmovs(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
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
2.50.0.714.g196bf9f422-goog


