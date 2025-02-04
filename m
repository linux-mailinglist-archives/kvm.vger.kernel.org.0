Return-Path: <kvm+bounces-37275-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D3731A27C4A
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 20:57:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5D959165812
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 19:57:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1769219A9D;
	Tue,  4 Feb 2025 19:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3epTRhzh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f201.google.com (mail-il1-f201.google.com [209.85.166.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22DC82B9BB
	for <kvm@vger.kernel.org>; Tue,  4 Feb 2025 19:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738699042; cv=none; b=GYgwYqsI10faNqkZ0SHof2arv2MwN9YrQP0irOGBO/pAdaE4gnqOlmBnaJObi6S51F4AMVhYpW6/FmuAxRUUM3EMsyocLlSRcoreLD0UgtLnitBWYiteMPxvg1F6YDI4ZF9hpzbbbFWzkJ4UI88vdfs3GgkKyXLbqvnXak5m2Ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738699042; c=relaxed/simple;
	bh=iOVyrLDdjhClqri6WHcNTlHR5a0RTnuE85GltSUcA+A=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=C4B5ZUmXyGGb5fhMZnpj+5tDciUiEOt1N68Zp6EmRXXQ4Q8ahUcTWXclPSf74rTH/hfI9f/vD2JCqE/IUyugkvCbILrrEP7w+ZTnE0O258K5zU5Q0j4AtwpoLDTBrFIZqYHlN723mHIZ4oV/7HVMLfU5khxOKrRSc/Tbw5a6yWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3epTRhzh; arc=none smtp.client-ip=209.85.166.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-il1-f201.google.com with SMTP id e9e14a558f8ab-3ce8dadfb67so32955625ab.1
        for <kvm@vger.kernel.org>; Tue, 04 Feb 2025 11:57:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738699038; x=1739303838; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=x3nz+sLxzv+mI2fev0uHpyDdU92jr9O5Wy0bm9zvTf8=;
        b=3epTRhzhF6LrAGcWFz2nSMB1PHgxZRvz9YJPFXKTrGA11UM2DRtQUbCS0kU/eer8Qm
         Fcf6ZmEjBHg/PFxh9lBoIaTjvAcw64UtVzGhX9sYZs0Yt2Rpe3OL2zWTYGetDLznC7qg
         nVMrEHz8L5oFybiXteZxeXgz5/zj4zCm7kUEzdvC7vq+UGpwBW3mJ95Uo+94x/1lH3k3
         AjVMfpCds4hIn+OVo/X0rmRk0mwCXHoBNOS4j9YgdnwvYzzgA86joFYk8Ib97gHK745E
         MFgQpxTNTS0AnNM457fmn3Iz9RgqXeNCdVQNXjfVUw2CeKsSkelEH2qyWLNlSr/aC+4m
         nmlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738699038; x=1739303838;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=x3nz+sLxzv+mI2fev0uHpyDdU92jr9O5Wy0bm9zvTf8=;
        b=aJZ40temzQU25ANOg2yP4AcJPV7APs8OvJL82Xk7M4Sn7/mDkh6X1JDkasU10jgzqU
         UYW8rp+oJztA68Po7kR+YAPsppzo6gfCg1OCPpk+QV6Yu94KRHUorQ/SkXGwOWoJU/f3
         37za5funj6CXKhfxgD7pz3p/pm0Ru/v9p3aPGOSL3Ee96aNj0lOV0Dpkf8n2Sla9QDXu
         fkZUgefvcTcuEKNyEe8e5Pk0LMVVTGr6+NlcPi8fGApfPALsV5AdVAwTV7o0l55koBZc
         w3D/bvT7kTJ/X2s5SmzFfb7lj/nkKAowO/Uv/+FAeiPLrFpRcy0RTs5eQ3Y3dZ9vtY2U
         yBgg==
X-Gm-Message-State: AOJu0YyjHNE7+MX0Igp3mtOWmMl078wtmEhRjjBG95jejaGLajS+Ncre
	QAy5kDk5U+nMuT9S5FLUoN5ay7RpZE2xGq77/hVPhOgByR9fDJ921mj8vpx+cHsjOVPJgu0T8gA
	vW8MJ+auyCMGfqC4/6w1IGX7juEmhZMuSlX7PWmco36A74Ei+rbp1E/tz13bRn68ob/s/gEN4r2
	KwdGaVpeAwLK8fuTAEho998FRdVLOdj6Ow7Hyb2J5WepTJuWlQboC+67U=
X-Google-Smtp-Source: AGHT+IFCbd5TbwVMrhJK2bcQCyfCgg4ls4jmx2Zok6lCN7ChS3uIDAMydUcwYx7x9fORmL8hc1+yBurzn+Nb2fztvw==
X-Received: from ilbcr10.prod.google.com ([2002:a05:6e02:3a8a:b0:3ce:8bff:8b9d])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6e02:1746:b0:3d0:24c0:bd37 with SMTP id e9e14a558f8ab-3d04f459238mr1943175ab.11.1738699038254;
 Tue, 04 Feb 2025 11:57:18 -0800 (PST)
Date: Tue,  4 Feb 2025 19:57:07 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.48.1.362.g079036d154-goog
Message-ID: <20250204195708.1703531-1-coltonlewis@google.com>
Subject: [PATCH 1/2] perf: arm_pmuv3: Remove cyclical dependency with kvm_host.h
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Mark Rutland <mark.rutland@arm.com>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

asm/kvm_host.h includes asm/arm_pmu.h which includes perf/arm_pmuv3.h
which includes asm/arm_pmuv3.h which includes asm/kvm_host.h This
causes confusing compilation problems when trying to use anything in
the chain.

Break the cycle by taking asm/kvm_host.h out of asm/arm_pmuv3.h
because asm/kvm_host.h is huge and we only need a few functions from
it. Move the required declarations to asm/arm_pmuv3.h.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/include/asm/arm_pmuv3.h | 24 ++++++++++++++++++++++--
 arch/arm64/include/asm/kvm_host.h  | 18 ------------------
 include/kvm/arm_pmu.h              |  1 -
 3 files changed, 22 insertions(+), 21 deletions(-)

diff --git a/arch/arm64/include/asm/arm_pmuv3.h b/arch/arm64/include/asm/arm_pmuv3.h
index 8a777dec8d88..89fd6abb7da6 100644
--- a/arch/arm64/include/asm/arm_pmuv3.h
+++ b/arch/arm64/include/asm/arm_pmuv3.h
@@ -6,11 +6,31 @@
 #ifndef __ASM_PMUV3_H
 #define __ASM_PMUV3_H
 
-#include <asm/kvm_host.h>
-
 #include <asm/cpufeature.h>
 #include <asm/sysreg.h>
 
+#include <linux/perf_event.h>
+
+#ifdef CONFIG_KVM
+void kvm_set_pmu_events(u64 set, struct perf_event_attr *attr);
+void kvm_clr_pmu_events(u64 clr);
+bool kvm_set_pmuserenr(u64 val);
+#else
+static inline void kvm_set_pmu_events(u64 set, struct perf_event_attr *attr) {}
+static inline void kvm_clr_pmu_events(u64 clr) {}
+static inline bool kvm_set_pmuserenr(u64 val)
+{
+	return false;
+}
+#endif
+
+static inline bool kvm_pmu_counter_deferred(struct perf_event_attr *attr)
+{
+	return (!has_vhe() && attr->exclude_host);
+}
+
+void kvm_vcpu_pmu_resync_el0(void);
+
 #define RETURN_READ_PMEVCNTRN(n) \
 	return read_sysreg(pmevcntr##n##_el0)
 static inline unsigned long read_pmevcntrn(int n)
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index e18e9244d17a..3eeb762944c9 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1362,28 +1362,10 @@ void kvm_arch_vcpu_ctxflush_fp(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_ctxsync_fp(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu);
 
-static inline bool kvm_pmu_counter_deferred(struct perf_event_attr *attr)
-{
-	return (!has_vhe() && attr->exclude_host);
-}
-
 /* Flags for host debug state */
 void kvm_arch_vcpu_load_debug_state_flags(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_put_debug_state_flags(struct kvm_vcpu *vcpu);
 
-#ifdef CONFIG_KVM
-void kvm_set_pmu_events(u64 set, struct perf_event_attr *attr);
-void kvm_clr_pmu_events(u64 clr);
-bool kvm_set_pmuserenr(u64 val);
-#else
-static inline void kvm_set_pmu_events(u64 set, struct perf_event_attr *attr) {}
-static inline void kvm_clr_pmu_events(u64 clr) {}
-static inline bool kvm_set_pmuserenr(u64 val)
-{
-	return false;
-}
-#endif
-
 void kvm_vcpu_load_vhe(struct kvm_vcpu *vcpu);
 void kvm_vcpu_put_vhe(struct kvm_vcpu *vcpu);
 
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 147bd3ee4f7b..2c78b1b1a9bb 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -74,7 +74,6 @@ int kvm_arm_pmu_v3_enable(struct kvm_vcpu *vcpu);
 struct kvm_pmu_events *kvm_get_pmu_events(void);
 void kvm_vcpu_pmu_restore_guest(struct kvm_vcpu *vcpu);
 void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu);
-void kvm_vcpu_pmu_resync_el0(void);
 
 #define kvm_vcpu_has_pmu(vcpu)					\
 	(vcpu_has_feature(vcpu, KVM_ARM_VCPU_PMU_V3))

base-commit: 5bc55a333a2f7316b58edc7573e8e893f7acb532
-- 
2.48.1.362.g079036d154-goog


