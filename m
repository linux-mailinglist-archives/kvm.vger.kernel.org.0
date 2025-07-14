Return-Path: <kvm+bounces-52392-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D8331B04B74
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 01:05:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 896113B45EF
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 23:04:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D29F2BCF48;
	Mon, 14 Jul 2025 22:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kShKSK6B"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f73.google.com (mail-io1-f73.google.com [209.85.166.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAD5A292B34
	for <kvm@vger.kernel.org>; Mon, 14 Jul 2025 22:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752533994; cv=none; b=V8vEd51uJuZEHMEIhXJYA3PWckRVOA8Md3P6pqFsxcYqwn5lGelqu1bJXvujykaTV98d7iZ0tbTyoXQH+N3yMBq8hzwgb0itURDeN6vmJRAmpt05i/iCjfO3p7D6FmjB2izJSyPKWomuMzSogbXqLBU6jPB/ATZ+8recnWVkkrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752533994; c=relaxed/simple;
	bh=0KMiE20SLJLD7kdsdsCqqE1XhXEsDWHdcA9/wtSWkSQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oN6VDEDW40qsV8F0V81rIrRUFonoNVyGDHIXExmEHT3BtT9YSTrhWAalouDs210/47Pwyexz/I1pqMmVNzdqC4f9pmIonR9Z0cnXpCOd2aANlaubLEigX9+06xymhJh0g/84puG4bbs9AV2F0Gj20ck8E9yyq4vmB7wCM83anGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kShKSK6B; arc=none smtp.client-ip=209.85.166.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-io1-f73.google.com with SMTP id ca18e2360f4ac-876a88d14baso981407739f.2
        for <kvm@vger.kernel.org>; Mon, 14 Jul 2025 15:59:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752533989; x=1753138789; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kYf1NlmF8/QTGj97Qxw1rCkue71OyUvLh0xkN4pVh4E=;
        b=kShKSK6Bl5pVcTV+IN3n2Gb/3CFTUHPnr2rY3s69to94bVu/ThyGiMHmyphDFM2SFd
         EC6n70zZRkxFpdkSl1WFcnqNvfIc8Wnfpp5owanfGv6A/pml8Bmj2NNLCuXCi+g5b57q
         e1zCLRBz30TyfqWWxD08/Mim1Tl6Bd7Q6SW+vu0lPUYOY3/UWg/3rL73/TBUHIyggvXu
         O2XIDfdoJtzKA4Zat/STylgM98ccae3I7UobCWHn4ylFEuOm2UlLbucOfWsQXI3XvcYM
         hQWrAFBuXabEyE30BF1/ohSmJkWqweU0nP6sZ9GpmgbPmu8E3Z3TGdmEvr72xB+aud+P
         CG7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752533989; x=1753138789;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kYf1NlmF8/QTGj97Qxw1rCkue71OyUvLh0xkN4pVh4E=;
        b=QoJ0GrTXvYKcLtmMMwOH0zzDPaSPOPPGeLTG0K4fTj+SnYzGUKt6sL33FxxPtkVQ8f
         BdFFVkH4ydc2D6J0ABXDth8RiuIkQAIPWOR7v6AUEfxK3L+ovoVJSmn5Bz71NpS3BDZ5
         h5MxA/D0ls9y2zISxyw8POoCzi7Xwl6DwQpfwInDZJmc4+F3UKFgNAxE+AmHJwTU12eD
         xMWNsHQgSATKuDCt4oMp+usq+mWBf6oMc7sb6hZNSb8RtH8KU0KpbfX/LtSG+tNpsBWB
         O3GMUCyOwt6y1e9CCiJOjZSHPbpbRkFdFFEk1UHZ/enEQUEnulJparE7ZQl3WeJ6CtlC
         y0+w==
X-Gm-Message-State: AOJu0YwTW+1S6XAW6a55eYKVahyCMgdrt0bFBP89Bu/RnmomMZChXTwt
	DL3cSMdGH2BdpJ7IBagS4XFhHyX6DzP0d+lkYbb2BpSVoDuIROBwmZW5pEnEBSgc6FxKANn7H+9
	RE1OxG6hvTmQmuBHXmlrtolAOTddqkxJTzzb3pFIv1jQgtm6cYp9ky7iwrTtRsvdbssOSxifpwj
	3SScIsNL/aRqBPS6wwk1gZR1CBOP3VJKwpDHo4VR+BR4pxJKD7iO0/af6d3sg=
X-Google-Smtp-Source: AGHT+IEqn9WMczkmgGJMqe3Pfe69AM+/PU1iKi1PXg3+tmFjAie5sPccK6SXrZKFiKE60xITkz3trTASZ14i+omdNw==
X-Received: from ilos18.prod.google.com ([2002:a92:cb12:0:b0:3df:53d6:5d35])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6e02:3388:b0:3df:3d1a:2e76 with SMTP id e9e14a558f8ab-3e255571390mr143216325ab.1.1752533989026;
 Mon, 14 Jul 2025 15:59:49 -0700 (PDT)
Date: Mon, 14 Jul 2025 22:59:12 +0000
In-Reply-To: <20250714225917.1396543-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250714225917.1396543-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250714225917.1396543-19-coltonlewis@google.com>
Subject: [PATCH v4 18/23] KVM: arm64: Extract enum debug_owner to enum vcpu_register_owner
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

The concept of a register or set of registers being owned by the host,
guest, or neither and choosing how to handle traps based on that state
applies equally well to PMU registers as other debug registers.

Extract the enum debug_owner previously defined inside struct
kvm_vcpu_arch to it's own type and add a the field to struct kvm_pmu
as well.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/include/asm/kvm_host.h         | 12 ++++--------
 arch/arm64/include/asm/kvm_pmu.h          |  1 +
 arch/arm64/include/asm/kvm_types.h        |  7 ++++++-
 arch/arm64/kvm/debug.c                    |  8 ++++----
 arch/arm64/kvm/hyp/include/hyp/debug-sr.h |  6 +++---
 5 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 463dbf7f0821..21e32d7fa19b 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -846,11 +846,7 @@ struct kvm_vcpu_arch {
 	struct kvm_guest_debug_arch external_debug_state;
 	u64 external_mdscr_el1;
 
-	enum {
-		VCPU_DEBUG_FREE,
-		VCPU_DEBUG_HOST_OWNED,
-		VCPU_DEBUG_GUEST_OWNED,
-	} debug_owner;
+	enum vcpu_register_owner debug_owner;
 
 	/* VGIC state */
 	struct vgic_cpu vgic_cpu;
@@ -1467,11 +1463,11 @@ void kvm_debug_handle_oslar(struct kvm_vcpu *vcpu, u64 val);
 	(!!(__vcpu_sys_reg(vcpu, OSLSR_EL1) & OSLSR_EL1_OSLK))
 
 #define kvm_debug_regs_in_use(vcpu)		\
-	((vcpu)->arch.debug_owner != VCPU_DEBUG_FREE)
+	((vcpu)->arch.debug_owner != VCPU_REGISTER_FREE)
 #define kvm_host_owns_debug_regs(vcpu)		\
-	((vcpu)->arch.debug_owner == VCPU_DEBUG_HOST_OWNED)
+	((vcpu)->arch.debug_owner == VCPU_REGISTER_HOST_OWNED)
 #define kvm_guest_owns_debug_regs(vcpu)		\
-	((vcpu)->arch.debug_owner == VCPU_DEBUG_GUEST_OWNED)
+	((vcpu)->arch.debug_owner == VCPU_REGISTER_GUEST_OWNED)
 
 int kvm_arm_vcpu_arch_set_attr(struct kvm_vcpu *vcpu,
 			       struct kvm_device_attr *attr);
diff --git a/arch/arm64/include/asm/kvm_pmu.h b/arch/arm64/include/asm/kvm_pmu.h
index 4f0741bf6779..58c1219adf54 100644
--- a/arch/arm64/include/asm/kvm_pmu.h
+++ b/arch/arm64/include/asm/kvm_pmu.h
@@ -38,6 +38,7 @@ struct kvm_pmu {
 	int irq_num;
 	bool created;
 	bool irq_level;
+	enum vcpu_register_owner owner;
 };
 
 struct arm_pmu_entry {
diff --git a/arch/arm64/include/asm/kvm_types.h b/arch/arm64/include/asm/kvm_types.h
index 9a126b9e2d7c..1d951fb1ad78 100644
--- a/arch/arm64/include/asm/kvm_types.h
+++ b/arch/arm64/include/asm/kvm_types.h
@@ -4,5 +4,10 @@
 
 #define KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE 40
 
-#endif /* _ASM_ARM64_KVM_TYPES_H */
+enum vcpu_register_owner {
+	VCPU_REGISTER_FREE,
+	VCPU_REGISTER_HOST_OWNED,
+	VCPU_REGISTER_GUEST_OWNED,
+};
 
+#endif /* _ASM_ARM64_KVM_TYPES_H */
diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index 8ae9d141cad4..fa8b4f846b68 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -161,7 +161,7 @@ void kvm_vcpu_load_debug(struct kvm_vcpu *vcpu)
 	 *    context needs to be loaded on the CPU.
 	 */
 	if (vcpu->guest_debug || kvm_vcpu_os_lock_enabled(vcpu)) {
-		vcpu->arch.debug_owner = VCPU_DEBUG_HOST_OWNED;
+		vcpu->arch.debug_owner = VCPU_REGISTER_HOST_OWNED;
 		setup_external_mdscr(vcpu);
 
 		/*
@@ -183,9 +183,9 @@ void kvm_vcpu_load_debug(struct kvm_vcpu *vcpu)
 		mdscr = vcpu_read_sys_reg(vcpu, MDSCR_EL1);
 
 		if (mdscr & (MDSCR_EL1_KDE | MDSCR_EL1_MDE))
-			vcpu->arch.debug_owner = VCPU_DEBUG_GUEST_OWNED;
+			vcpu->arch.debug_owner = VCPU_REGISTER_GUEST_OWNED;
 		else
-			vcpu->arch.debug_owner = VCPU_DEBUG_FREE;
+			vcpu->arch.debug_owner = VCPU_REGISTER_FREE;
 	}
 
 	kvm_arm_setup_mdcr_el2(vcpu);
@@ -222,7 +222,7 @@ void kvm_debug_set_guest_ownership(struct kvm_vcpu *vcpu)
 	if (kvm_host_owns_debug_regs(vcpu))
 		return;
 
-	vcpu->arch.debug_owner = VCPU_DEBUG_GUEST_OWNED;
+	vcpu->arch.debug_owner = VCPU_REGISTER_GUEST_OWNED;
 	kvm_arm_setup_mdcr_el2(vcpu);
 }
 
diff --git a/arch/arm64/kvm/hyp/include/hyp/debug-sr.h b/arch/arm64/kvm/hyp/include/hyp/debug-sr.h
index 502a5b73ee70..048234439a41 100644
--- a/arch/arm64/kvm/hyp/include/hyp/debug-sr.h
+++ b/arch/arm64/kvm/hyp/include/hyp/debug-sr.h
@@ -91,12 +91,12 @@
 static struct kvm_guest_debug_arch *__vcpu_debug_regs(struct kvm_vcpu *vcpu)
 {
 	switch (vcpu->arch.debug_owner) {
-	case VCPU_DEBUG_FREE:
+	case VCPU_REGISTER_FREE:
 		WARN_ON_ONCE(1);
 		fallthrough;
-	case VCPU_DEBUG_GUEST_OWNED:
+	case VCPU_REGISTER_GUEST_OWNED:
 		return &vcpu->arch.vcpu_debug_state;
-	case VCPU_DEBUG_HOST_OWNED:
+	case VCPU_REGISTER_HOST_OWNED:
 		return &vcpu->arch.external_debug_state;
 	}
 
-- 
2.50.0.727.gbf7dc18ff4-goog


