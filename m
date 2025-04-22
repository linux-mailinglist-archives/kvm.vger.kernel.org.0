Return-Path: <kvm+bounces-43833-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5064BA97228
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 18:13:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CAF9E7A5F99
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 16:12:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 467E42918F5;
	Tue, 22 Apr 2025 16:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="ZR1QcWTD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 563152900A4
	for <kvm@vger.kernel.org>; Tue, 22 Apr 2025 16:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745338402; cv=none; b=n0EzUvOZjI9SqkdQLmBorygg4FpC32//KG6+vgtjV9BdI99yqeawgb/nhQvfvWWJsCWfQMjJ2cx7h5cWbhex32UAsbje68QaVG7xPnWFuVlNOPP1/er/C5B5fmXZeuxtvWgQbQXwAo1UreM3A/KEztt5dTu/r5sZPvDBZYE92Tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745338402; c=relaxed/simple;
	bh=uQkzKMYG+oOO2bQjLC5J0HJgmAddyYMVWvJwpNpsZ8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kAj8wWLCdK8ro40Apzi2lQKNeYlDodQFU46k/KthCy4jM1V2VNapJJB2IyJIdFOnLVP9YTg7uQqp7msAbfwVfREBYIIbtMDzTgXdPV/njzMhSAJyvpxkX5KfzDuLPs0/CBpfkuqwaKhwvzduJ+SonPn4xxAZ5jafNlcqeEsIcio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=ZR1QcWTD; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2254e0b4b79so81335945ad.2
        for <kvm@vger.kernel.org>; Tue, 22 Apr 2025 09:13:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1745338399; x=1745943199; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pFQip2/6pWUxH9sfNJUznE0s73zrMeQgY/B+MiDq7iw=;
        b=ZR1QcWTDZXbsaeuMg1tylOny6Y/13rP3ngxO+d8NXY3w3cK7+RC8S1NaNoxu88Lex/
         LHawTDL3JzR1hDWZPgQ7uCuYYbzTc6Jh5teFLxV7KNZVJqT3uAk6qY/VS8XMDU1duR3S
         avqv6vth1n0yqDL3aINMT+8m3dbFgNC3cstbo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745338399; x=1745943199;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pFQip2/6pWUxH9sfNJUznE0s73zrMeQgY/B+MiDq7iw=;
        b=we/aYf77KrlVlEfhiQncizbl45OrcB7Ive6Khkzwn6TRurnivu6JY8tGbj793Sxyeo
         zVpkyv/27Q33g8ASbhnulp9t7+96p19UajyR1Ie3XlV4QDs6vGgr6Ecg3/EKHSSfpZXC
         A1Bs4MwpYM2lK/Q0RpzFk0Cm8e0eCHdMFTkU4I+mFFDIBVjXM35n8AZ+NPO4LIWZnSa5
         fOnEst51DtpKn6J6VWm486Ey0Vdj53O34CFl3YsMuh1hTplTadHGTQxyqm8MCZhveR5w
         vCWVpK1oKbR+ymTYCPNW2S6anV96HVeqoTIUrA1mlK6f48hhKdiAhQclLNRvPsNDSpZD
         clvw==
X-Forwarded-Encrypted: i=1; AJvYcCXbDBdBsf250Brbx3oVVhzjfWAS8asa5vP0jEIWE/a9/lSR2+sQvGopc0ACnat5G2tpx0E=@vger.kernel.org
X-Gm-Message-State: AOJu0YyehW9moQJDPabvRHbYCyXbO9UlWFcbvoAKHtYT9uS9GBQu7bYv
	XXpVHsmoChmDjdKbsZaJT3swZve1YING4XbNwld1mIqaobLbqpiOZJ316216bA==
X-Gm-Gg: ASbGncsXoDMAxCnMPuWQgtXp4utcaeePZINJUlpw7zLaqZpbd5U5RYvnFwRGOQG+Sxd
	np1AwWeSmh8giTNfHrBezMremdwYUr9YP/jLrthkDsl11d2d7zi10vbcwPjz90j2LAk5ZXHKqyL
	ErSHis4pcqQa8B0YiTa2dkX1Ci4csdiwNThDGYxAitU3O0FPVLbkr9ze1JEVtgbIWitLjaPEaie
	GbxwmMLKR+FbvOBmD1HhBgLFcuNLNKeECmuoULiktasKuStsb2b2JkSpyL9a61bHs/cl+kS97ug
	A76H1jmw5U3s8VqHig9yq8a4+2r5ha5Yv+YG/F2hluE9XndypAlqELz/Cf3UKfrCwcN/Eaaqj8m
	jVzis8MEY9hNuYE9TMm3EsYESE9zhDYtn
X-Google-Smtp-Source: AGHT+IHtovCShIvJiNBgt8iMZrzuVrvKl//hAdxffepXgRmduApdsvhpsn1LWjiwKZbbvIAyUMFGWw==
X-Received: by 2002:a17:903:2441:b0:224:26f5:9c1e with SMTP id d9443c01a7336-22c535683f0mr227489315ad.2.1745338399478;
        Tue, 22 Apr 2025 09:13:19 -0700 (PDT)
Received: from localhost.localdomain (pool-173-49-113-140.phlapa.fios.verizon.net. [173.49.113.140])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22c50eb03d2sm87462375ad.142.2025.04.22.09.13.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Apr 2025 09:13:19 -0700 (PDT)
From: Zack Rusin <zack.rusin@broadcom.com>
To: linux-kernel@vger.kernel.org
Cc: Zack Rusin <zack.rusin@broadcom.com>,
	Doug Covelli <doug.covelli@broadcom.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	kvm@vger.kernel.org
Subject: [PATCH v2 1/5] KVM: x86: Centralize KVM's VMware code
Date: Tue, 22 Apr 2025 12:12:20 -0400
Message-ID: <20250422161304.579394-2-zack.rusin@broadcom.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250422161304.579394-1-zack.rusin@broadcom.com>
References: <20250422161304.579394-1-zack.rusin@broadcom.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Centralize KVM's VMware specific code and introduce CONFIG_KVM_VMWARE to
isolate all of it.

Code used to support VMware backdoor has been scattered around the KVM
codebase making it difficult to reason about, maintain it and change
it. Introduce CONFIG_KVM_VMWARE which, much like CONFIG_KVM_XEN and
CONFIG_KVM_VMWARE for Xen and Hyper-V, abstracts away VMware specific
parts.

In general CONFIG_KVM_VMWARE should be set to y and to preserve the
current behavior it defaults to Y.

Signed-off-by: Zack Rusin <zack.rusin@broadcom.com>
Cc: Doug Covelli <doug.covelli@broadcom.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: x86@kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Zack Rusin <zack.rusin@broadcom.com>
Cc: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
---
 MAINTAINERS               |   9 +++
 arch/x86/kvm/Kconfig      |  13 ++++
 arch/x86/kvm/emulate.c    |  11 ++--
 arch/x86/kvm/kvm_vmware.h | 127 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/pmu.c        |  39 +-----------
 arch/x86/kvm/pmu.h        |   4 --
 arch/x86/kvm/svm/svm.c    |   7 ++-
 arch/x86/kvm/vmx/vmx.c    |   5 +-
 arch/x86/kvm/x86.c        |  34 +---------
 arch/x86/kvm/x86.h        |   2 -
 10 files changed, 166 insertions(+), 85 deletions(-)
 create mode 100644 arch/x86/kvm/kvm_vmware.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 00e94bec401e..9e38103ac2bb 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13051,6 +13051,15 @@ F:	arch/x86/kvm/svm/hyperv.*
 F:	arch/x86/kvm/svm/svm_onhyperv.*
 F:	arch/x86/kvm/vmx/hyperv.*
 
+KVM X86 VMware (KVM/VMware)
+M:	Zack Rusin <zack.rusin@broadcom.com>
+M:	Doug Covelli <doug.covelli@broadcom.com>
+M:	Paolo Bonzini <pbonzini@redhat.com>
+L:	kvm@vger.kernel.org
+S:	Supported
+T:	git git://git.kernel.org/pub/scm/virt/kvm/kvm.git
+F:	arch/x86/kvm/kvm_vmware.*
+
 KVM X86 Xen (KVM/Xen)
 M:	David Woodhouse <dwmw2@infradead.org>
 M:	Paul Durrant <paul@xen.org>
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index ea2c4f21c1ca..9e3be87fc82b 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -178,6 +178,19 @@ config KVM_HYPERV
 
 	  If unsure, say "Y".
 
+config KVM_VMWARE
+	bool "Features needed for VMware guests support"
+	depends on KVM
+	default y
+	help
+	  Provides KVM support for hosting VMware guests. Adds support for
+	  VMware legacy backdoor interface: VMware tools and various userspace
+	  utilities running in VMware guests sometimes utilize specially
+	  formatted IN, OUT and RDPMC instructions which need to be
+	  intercepted.
+
+	  If unsure, say "Y".
+
 config KVM_XEN
 	bool "Support for Xen hypercall interface"
 	depends on KVM
diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 60986f67c35a..b42988ce8043 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -26,6 +26,7 @@
 #include <asm/debugreg.h>
 #include <asm/nospec-branch.h>
 #include <asm/ibt.h>
+#include "kvm_vmware.h"
 
 #include "x86.h"
 #include "tss.h"
@@ -2547,9 +2548,6 @@ static bool emulator_bad_iopl(struct x86_emulate_ctxt *ctxt)
 	return ctxt->ops->cpl(ctxt) > iopl;
 }
 
-#define VMWARE_PORT_VMPORT	(0x5658)
-#define VMWARE_PORT_VMRPC	(0x5659)
-
 static bool emulator_io_port_access_allowed(struct x86_emulate_ctxt *ctxt,
 					    u16 port, u16 len)
 {
@@ -2565,8 +2563,8 @@ static bool emulator_io_port_access_allowed(struct x86_emulate_ctxt *ctxt,
 	 * VMware allows access to these ports even if denied
 	 * by TSS I/O permission bitmap. Mimic behavior.
 	 */
-	if (enable_vmware_backdoor &&
-	    ((port == VMWARE_PORT_VMPORT) || (port == VMWARE_PORT_VMRPC)))
+	if (kvm_vmware_backdoor_enabled(ctxt->vcpu) &&
+	    kvm_vmware_io_port_allowed(port))
 		return true;
 
 	ops->get_segment(ctxt, &tr, &tr_seg, &base3, VCPU_SREG_TR);
@@ -3920,7 +3918,8 @@ static int check_rdpmc(struct x86_emulate_ctxt *ctxt)
 	 * VMware allows access to these Pseduo-PMCs even when read via RDPMC
 	 * in Ring3 when CR4.PCE=0.
 	 */
-	if (enable_vmware_backdoor && is_vmware_backdoor_pmc(rcx))
+	if (kvm_vmware_backdoor_enabled(ctxt->vcpu) &&
+	    kvm_vmware_is_backdoor_pmc(rcx))
 		return X86EMUL_CONTINUE;
 
 	/*
diff --git a/arch/x86/kvm/kvm_vmware.h b/arch/x86/kvm/kvm_vmware.h
new file mode 100644
index 000000000000..8f091687dcd9
--- /dev/null
+++ b/arch/x86/kvm/kvm_vmware.h
@@ -0,0 +1,127 @@
+/* SPDX-License-Identifier: GPL-2.0 OR MIT */
+/*
+ * Copyright (c) 2025 Broadcom. All Rights Reserved. The term
+ * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
+ */
+
+#ifndef __ARCH_X86_KVM_VMWARE_H__
+#define __ARCH_X86_KVM_VMWARE_H__
+
+#include <linux/kvm_host.h>
+
+#ifdef CONFIG_KVM_VMWARE
+
+#define VMWARE_BACKDOOR_PMC_HOST_TSC		0x10000
+#define VMWARE_BACKDOOR_PMC_REAL_TIME		0x10001
+#define VMWARE_BACKDOOR_PMC_APPARENT_TIME	0x10002
+
+extern bool enable_vmware_backdoor;
+
+static inline bool kvm_vmware_backdoor_enabled(struct kvm_vcpu *vcpu)
+{
+	return enable_vmware_backdoor;
+}
+
+static inline bool kvm_vmware_is_backdoor_pmc(u32 pmc_idx)
+{
+	switch (pmc_idx) {
+	case VMWARE_BACKDOOR_PMC_HOST_TSC:
+	case VMWARE_BACKDOOR_PMC_REAL_TIME:
+	case VMWARE_BACKDOOR_PMC_APPARENT_TIME:
+		return true;
+	}
+	return false;
+}
+
+static inline int kvm_vmware_pmu_rdpmc(struct kvm_vcpu *vcpu, u32 idx, u64 *data)
+{
+	u64 ctr_val;
+
+	switch (idx) {
+	case VMWARE_BACKDOOR_PMC_HOST_TSC:
+		ctr_val = rdtsc();
+		break;
+	case VMWARE_BACKDOOR_PMC_REAL_TIME:
+		ctr_val = ktime_get_boottime_ns();
+		break;
+	case VMWARE_BACKDOOR_PMC_APPARENT_TIME:
+		ctr_val = ktime_get_boottime_ns() +
+			  vcpu->kvm->arch.kvmclock_offset;
+		break;
+	default:
+		return 1;
+	}
+
+	*data = ctr_val;
+	return 0;
+}
+
+#define VMWARE_PORT_VMPORT	(0x5658)
+#define VMWARE_PORT_VMRPC	(0x5659)
+
+static inline bool kvm_vmware_io_port_allowed(u16 port)
+{
+	return (port == VMWARE_PORT_VMPORT || port == VMWARE_PORT_VMRPC);
+}
+
+static inline bool kvm_vmware_is_backdoor_opcode(u8 opcode_len, u8 b)
+{
+	switch (opcode_len) {
+	case 1:
+		switch (b) {
+		case 0xe4:	/* IN */
+		case 0xe5:
+		case 0xec:
+		case 0xed:
+		case 0xe6:	/* OUT */
+		case 0xe7:
+		case 0xee:
+		case 0xef:
+		case 0x6c:	/* INS */
+		case 0x6d:
+		case 0x6e:	/* OUTS */
+		case 0x6f:
+			return true;
+		}
+		break;
+	case 2:
+		switch (b) {
+		case 0x33:	/* RDPMC */
+			return true;
+		}
+		break;
+	}
+
+	return false;
+}
+
+#else /* !CONFIG_KVM_VMWARE */
+
+static inline bool kvm_vmware_backdoor_enabled(struct kvm_vcpu *vcpu)
+{
+	return false;
+}
+
+static inline bool kvm_vmware_is_backdoor_pmc(u32 pmc_idx)
+{
+	return false;
+}
+
+static inline bool kvm_vmware_io_port_allowed(u16 port)
+{
+	return false;
+}
+
+static inline int kvm_vmware_pmu_rdpmc(struct kvm_vcpu *vcpu, u32 idx, u64 *data)
+{
+	return 0;
+}
+
+static inline bool kvm_vmware_is_backdoor_opcode(u8 opcode_len, u8 len)
+{
+	return false;
+}
+
+#endif /* CONFIG_KVM_VMWARE */
+
+#endif /* __ARCH_X86_KVM_VMWARE_H__ */
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 75e9cfc689f8..00becf33d8ac 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -22,6 +22,7 @@
 #include "cpuid.h"
 #include "lapic.h"
 #include "pmu.h"
+#include "kvm_vmware.h"
 
 /* This is enough to filter the vast majority of currently defined events. */
 #define KVM_PMU_EVENT_FILTER_MAX_EVENTS 300
@@ -545,40 +546,6 @@ int kvm_pmu_check_rdpmc_early(struct kvm_vcpu *vcpu, unsigned int idx)
 	return kvm_pmu_call(check_rdpmc_early)(vcpu, idx);
 }
 
-bool is_vmware_backdoor_pmc(u32 pmc_idx)
-{
-	switch (pmc_idx) {
-	case VMWARE_BACKDOOR_PMC_HOST_TSC:
-	case VMWARE_BACKDOOR_PMC_REAL_TIME:
-	case VMWARE_BACKDOOR_PMC_APPARENT_TIME:
-		return true;
-	}
-	return false;
-}
-
-static int kvm_pmu_rdpmc_vmware(struct kvm_vcpu *vcpu, unsigned idx, u64 *data)
-{
-	u64 ctr_val;
-
-	switch (idx) {
-	case VMWARE_BACKDOOR_PMC_HOST_TSC:
-		ctr_val = rdtsc();
-		break;
-	case VMWARE_BACKDOOR_PMC_REAL_TIME:
-		ctr_val = ktime_get_boottime_ns();
-		break;
-	case VMWARE_BACKDOOR_PMC_APPARENT_TIME:
-		ctr_val = ktime_get_boottime_ns() +
-			vcpu->kvm->arch.kvmclock_offset;
-		break;
-	default:
-		return 1;
-	}
-
-	*data = ctr_val;
-	return 0;
-}
-
 int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned idx, u64 *data)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
@@ -588,8 +555,8 @@ int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned idx, u64 *data)
 	if (!pmu->version)
 		return 1;
 
-	if (is_vmware_backdoor_pmc(idx))
-		return kvm_pmu_rdpmc_vmware(vcpu, idx, data);
+	if (kvm_vmware_is_backdoor_pmc(idx))
+		return kvm_vmware_pmu_rdpmc(vcpu, idx, data);
 
 	pmc = kvm_pmu_call(rdpmc_ecx_to_pmc)(vcpu, idx, &mask);
 	if (!pmc)
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index ad89d0bd6005..098ae5c7bf5f 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -17,10 +17,6 @@
 #define fixed_ctrl_field(ctrl_reg, idx) \
 	(((ctrl_reg) >> ((idx) * INTEL_FIXED_BITS_STRIDE)) & INTEL_FIXED_BITS_MASK)
 
-#define VMWARE_BACKDOOR_PMC_HOST_TSC		0x10000
-#define VMWARE_BACKDOOR_PMC_REAL_TIME		0x10001
-#define VMWARE_BACKDOOR_PMC_APPARENT_TIME	0x10002
-
 #define KVM_FIXED_PMC_BASE_IDX INTEL_PMC_IDX_FIXED
 
 struct kvm_pmu_emulated_event_selectors {
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index e67de787fc71..be106bd60553 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -51,6 +51,7 @@
 #include "svm_ops.h"
 
 #include "kvm_onhyperv.h"
+#include "kvm_vmware.h"
 #include "svm_onhyperv.h"
 
 MODULE_AUTHOR("Qumranet");
@@ -313,7 +314,7 @@ int svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
 			svm_leave_nested(vcpu);
 			svm_set_gif(svm, true);
 			/* #GP intercept is still needed for vmware backdoor */
-			if (!enable_vmware_backdoor)
+			if (!kvm_vmware_backdoor_enabled(vcpu))
 				clr_exception_intercept(svm, GP_VECTOR);
 
 			/*
@@ -1261,7 +1262,7 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
 	 * We intercept those #GP and allow access to them anyway
 	 * as VMware does.
 	 */
-	if (enable_vmware_backdoor)
+	if (kvm_vmware_backdoor_enabled(vcpu))
 		set_exception_intercept(svm, GP_VECTOR);
 
 	svm_set_intercept(svm, INTERCEPT_INTR);
@@ -2399,7 +2400,7 @@ static int gp_interception(struct kvm_vcpu *vcpu)
 	opcode = svm_instr_opcode(vcpu);
 
 	if (opcode == NONE_SVM_INSTR) {
-		if (!enable_vmware_backdoor)
+		if (!kvm_vmware_backdoor_enabled(vcpu))
 			goto reinject;
 
 		/*
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 3b92f893b239..416ef0d3f7a1 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -56,6 +56,7 @@
 #include "cpuid.h"
 #include "hyperv.h"
 #include "kvm_onhyperv.h"
+#include "kvm_vmware.h"
 #include "irq.h"
 #include "kvm_cache_regs.h"
 #include "lapic.h"
@@ -882,7 +883,7 @@ void vmx_update_exception_bitmap(struct kvm_vcpu *vcpu)
 	 * We intercept those #GP and allow access to them anyway
 	 * as VMware does.
 	 */
-	if (enable_vmware_backdoor)
+	if (kvm_vmware_backdoor_enabled(vcpu))
 		eb |= (1u << GP_VECTOR);
 	if ((vcpu->guest_debug &
 	     (KVM_GUESTDBG_ENABLE | KVM_GUESTDBG_USE_SW_BP)) ==
@@ -5259,7 +5260,7 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 		error_code = vmcs_read32(VM_EXIT_INTR_ERROR_CODE);
 
 	if (!vmx->rmode.vm86_active && is_gp_fault(intr_info)) {
-		WARN_ON_ONCE(!enable_vmware_backdoor);
+		WARN_ON_ONCE(!kvm_vmware_backdoor_enabled(vcpu));
 
 		/*
 		 * VMware backdoor emulation on #GP interception only handles
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4b64ab350bcd..1b0c6925d339 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -25,6 +25,7 @@
 #include "tss.h"
 #include "kvm_cache_regs.h"
 #include "kvm_emulate.h"
+#include "kvm_vmware.h"
 #include "mmu/page_track.h"
 #include "x86.h"
 #include "cpuid.h"
@@ -9023,37 +9024,6 @@ static bool kvm_vcpu_check_code_breakpoint(struct kvm_vcpu *vcpu,
 	return false;
 }
 
-static bool is_vmware_backdoor_opcode(struct x86_emulate_ctxt *ctxt)
-{
-	switch (ctxt->opcode_len) {
-	case 1:
-		switch (ctxt->b) {
-		case 0xe4:	/* IN */
-		case 0xe5:
-		case 0xec:
-		case 0xed:
-		case 0xe6:	/* OUT */
-		case 0xe7:
-		case 0xee:
-		case 0xef:
-		case 0x6c:	/* INS */
-		case 0x6d:
-		case 0x6e:	/* OUTS */
-		case 0x6f:
-			return true;
-		}
-		break;
-	case 2:
-		switch (ctxt->b) {
-		case 0x33:	/* RDPMC */
-			return true;
-		}
-		break;
-	}
-
-	return false;
-}
-
 /*
  * Decode an instruction for emulation.  The caller is responsible for handling
  * code breakpoints.  Note, manually detecting code breakpoints is unnecessary
@@ -9152,7 +9122,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	}
 
 	if ((emulation_type & EMULTYPE_VMWARE_GP) &&
-	    !is_vmware_backdoor_opcode(ctxt)) {
+	    !kvm_vmware_is_backdoor_opcode(ctxt->opcode_len, ctxt->b)) {
 		kvm_queue_exception_e(vcpu, GP_VECTOR, 0);
 		return 1;
 	}
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 91e50a513100..672c2c0c3ecc 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -428,8 +428,6 @@ static inline bool kvm_mpx_supported(void)
 
 extern unsigned int min_timer_period_us;
 
-extern bool enable_vmware_backdoor;
-
 extern int pi_inject_timer;
 
 extern bool report_ignored_msrs;
-- 
2.48.1


