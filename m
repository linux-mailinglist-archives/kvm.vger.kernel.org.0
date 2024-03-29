Return-Path: <kvm+bounces-13066-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 267098915F2
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 10:31:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CFEDA287335
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 09:31:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7FCF40866;
	Fri, 29 Mar 2024 09:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="ngyf2QmO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 922886A8AC
	for <kvm@vger.kernel.org>; Fri, 29 Mar 2024 09:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711704492; cv=none; b=lCKOspTlA8EqgmQ+5/0BA8tL2fPlZoCoZHxDjVuA6cubGRQx24+J2YNTvKrg5ghUZ8g/rSyTs7FQH/nhODqxhG82woTJb3OcQNzJaLpLvwukmzV8d8hkyv3BIDKiscbxhXri9CUHElDJOI1+kFYiFKGfZwNPAwCK+niWdMlp3QM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711704492; c=relaxed/simple;
	bh=pKwxjdFDS7fPWD1+VB8s01FYk9Vaq5YiFiXqXB5BVW4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=dIWed3R4zonEjoTjjYtjfx6JnEruLIMuJwWxXasC1o38kaOFtxr0U1rAJWwKkJVoEeQZuinV4fMH8BiOMdnTF6o+9ONALO8CAq/mu6mAaR+jIFAUwZNQ7UtR3zhqu9zTnP2I/okShnt3RdhRUH9PhEcoWvKWZryTn0XsP2tbtTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com; spf=pass smtp.mailfrom=sifive.com; dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b=ngyf2QmO; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sifive.com
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-5d3912c9a83so1065018a12.3
        for <kvm@vger.kernel.org>; Fri, 29 Mar 2024 02:28:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1711704489; x=1712309289; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kNl7zpQXvXrARiVNVkvkffUb5fHwj0L+2J3rA8qc0Og=;
        b=ngyf2QmO6mG4dNbKrt5LDN5cn6Nar4KHRC4hVBvFjGkXmP6iO9XOnfEp1MkpFrStIR
         UxuIgFD5ut95EU25UzZDldpka+SQ7WQBmQe31MO8ADOVMrT2Igsxfu1mzs70fHjECbRA
         N21jfvO4Ar4BisUSsHln1GL6SW8VmrUztkfMmBNP9Ced3F5AFXA7/Ya2Pw9HIqnv/zb/
         JD0x8/o8F9V5SmZqyFMaYkW+6ZqXqMF0aT/HlayEJwZRer0ElhieEs1xWV7j2Jasc9rv
         tiAbuQwnbec5rmLkdNDb49oDLvJ9w0Rc5DlvR7kR0SycalTfH1QMh+6z1Ogslt6xy7D8
         DO6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711704489; x=1712309289;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kNl7zpQXvXrARiVNVkvkffUb5fHwj0L+2J3rA8qc0Og=;
        b=dn3Xzw4pIw/ELGN3Yi/oaKMSCI24AYh3FVBZEcTuYuSCpLmjYxUxH4vQDIFdH5eCJb
         mnNAlsy58RQNkhEYnMrAARl5N0oZFyf/8G3ikIt3nvKU5BYvsMHDZQEkPL5U8BozZNFw
         S84WR4a8EfFMbu6W8KnE5M12zbQN6njbJ5CjhXAW7r+u7iljCqOic45EjRNKB5ZjI0Jw
         dMVTotCGluHfAWzWT35xpGgMbtts0PcR48pwxNV6VckDA7kPZ0KJxF/f6jAfV/0j4nSA
         TWZAaDDJLx8lHmFRssySPhlopHvu/U3/Dgmjzb5FETuV3O8FUFfXpxonyzS7vTS/0wXD
         Xy3w==
X-Forwarded-Encrypted: i=1; AJvYcCXR6cWSi0Rr6HkeTCDrT3mqZcAkqGWqd8YE0yF89PW3eFg/vxb/XATVrv2MrfCPFY9cWR65kH8DlB/DSbO2VO2A4D3y
X-Gm-Message-State: AOJu0YwhvveLSkTejp0irvSeibDxAK5jfl6ieeTPKQn8ZqFOdLGrFDKD
	Us2RYOvuvxMECOJybKif05DGp8tPfZm9TveJQNm5/pDot0PT8hxRAltxsuyfR4w=
X-Google-Smtp-Source: AGHT+IGke3TYJDotnJqdt1iP+scqdGmagpwPxA2ur5Kz3bFCD/ukFY00kNWufcTpRyFgA8aurgnlgg==
X-Received: by 2002:a17:90a:3ea7:b0:29d:dbaf:bd77 with SMTP id k36-20020a17090a3ea700b0029ddbafbd77mr1594311pjc.43.1711704488865;
        Fri, 29 Mar 2024 02:28:08 -0700 (PDT)
Received: from [127.0.1.1] (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id cv17-20020a17090afd1100b002a02f8d350fsm2628830pjb.53.2024.03.29.02.28.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Mar 2024 02:28:08 -0700 (PDT)
From: Max Hsu <max.hsu@sifive.com>
Date: Fri, 29 Mar 2024 17:26:24 +0800
Subject: [PATCH RFC 08/11] riscv: KVM: Add Sdtrig Extension Support for
 Guest/VM
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240329-dev-maxh-lin-452-6-9-v1-8-1534f93b94a7@sifive.com>
References: <20240329-dev-maxh-lin-452-6-9-v1-0-1534f93b94a7@sifive.com>
In-Reply-To: <20240329-dev-maxh-lin-452-6-9-v1-0-1534f93b94a7@sifive.com>
To: Conor Dooley <conor@kernel.org>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, 
 Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, Pavel Machek <pavel@ucw.cz>, 
 Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
 Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc: Palmer Dabbelt <palmer@sifive.com>, linux-riscv@lists.infradead.org, 
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-pm@vger.kernel.org, kvm@vger.kernel.org, 
 kvm-riscv@lists.infradead.org, linux-kselftest@vger.kernel.org, 
 Max Hsu <max.hsu@sifive.com>, Yong-Xuan Wang <yongxuan.wang@sifive.com>
X-Mailer: b4 0.13.0

From: Yong-Xuan Wang <yongxuan.wang@sifive.com>

We extend the KVM ISA extension ONE_REG interface to allow VMM
tools to detect and enable Sdtrig extension for Guest/VM. We
also save/restore the scontext CSR for guest VCPUs and set the
HSCONTEXT bit in hstateen0 CSR if the scontext CSR is available
for Guest/VM when the Smstateen extension is present.

Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
Co-developed-by: Max Hsu <max.hsu@sifive.com>
Signed-off-by: Max Hsu <max.hsu@sifive.com>
---
 arch/riscv/include/asm/kvm_host.h       | 11 +++++++++++
 arch/riscv/include/asm/kvm_vcpu_debug.h | 17 +++++++++++++++++
 arch/riscv/include/uapi/asm/kvm.h       |  1 +
 arch/riscv/kvm/Makefile                 |  1 +
 arch/riscv/kvm/vcpu.c                   |  8 ++++++++
 arch/riscv/kvm/vcpu_debug.c             | 29 +++++++++++++++++++++++++++++
 arch/riscv/kvm/vcpu_onereg.c            |  1 +
 7 files changed, 68 insertions(+)

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index 484d04a92fa6..d495279d99e1 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -21,6 +21,7 @@
 #include <asm/kvm_vcpu_sbi.h>
 #include <asm/kvm_vcpu_timer.h>
 #include <asm/kvm_vcpu_pmu.h>
+#include <asm/kvm_vcpu_debug.h>
 
 #define KVM_MAX_VCPUS			1024
 
@@ -175,6 +176,10 @@ struct kvm_vcpu_smstateen_csr {
 	unsigned long sstateen0;
 };
 
+struct kvm_vcpu_sdtrig_csr {
+	unsigned long scontext;
+};
+
 struct kvm_vcpu_arch {
 	/* VCPU ran at least once */
 	bool ran_atleast_once;
@@ -197,6 +202,9 @@ struct kvm_vcpu_arch {
 	unsigned long host_senvcfg;
 	unsigned long host_sstateen0;
 
+	/* SCONTEXT of Host */
+	unsigned long host_scontext;
+
 	/* CPU context of Host */
 	struct kvm_cpu_context host_context;
 
@@ -209,6 +217,9 @@ struct kvm_vcpu_arch {
 	/* CPU Smstateen CSR context of Guest VCPU */
 	struct kvm_vcpu_smstateen_csr smstateen_csr;
 
+	/* CPU Sdtrig CSR context of Guest VCPU */
+	struct kvm_vcpu_sdtrig_csr sdtrig_csr;
+
 	/* CPU context upon Guest VCPU reset */
 	struct kvm_cpu_context guest_reset_context;
 
diff --git a/arch/riscv/include/asm/kvm_vcpu_debug.h b/arch/riscv/include/asm/kvm_vcpu_debug.h
new file mode 100644
index 000000000000..6e7ce6b408a6
--- /dev/null
+++ b/arch/riscv/include/asm/kvm_vcpu_debug.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2024 SiFive
+ *
+ * Authors:
+ *	Yong-Xuan Wang <yongxuan.wang@sifive.com>
+ */
+
+#ifndef __KVM_VCPU_RISCV_DEBUG_H
+#define __KVM_VCPU_RISCV_DEBUG_H
+
+#include <linux/types.h>
+
+void kvm_riscv_debug_vcpu_swap_in_guest_context(struct kvm_vcpu *vcpu);
+void kvm_riscv_debug_vcpu_swap_in_host_context(struct kvm_vcpu *vcpu);
+
+#endif
diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
index b1c503c2959c..9f70da85ed51 100644
--- a/arch/riscv/include/uapi/asm/kvm.h
+++ b/arch/riscv/include/uapi/asm/kvm.h
@@ -167,6 +167,7 @@ enum KVM_RISCV_ISA_EXT_ID {
 	KVM_RISCV_ISA_EXT_ZFA,
 	KVM_RISCV_ISA_EXT_ZTSO,
 	KVM_RISCV_ISA_EXT_ZACAS,
+	KVM_RISCV_ISA_EXT_SDTRIG,
 	KVM_RISCV_ISA_EXT_MAX,
 };
 
diff --git a/arch/riscv/kvm/Makefile b/arch/riscv/kvm/Makefile
index c9646521f113..387be968d9ea 100644
--- a/arch/riscv/kvm/Makefile
+++ b/arch/riscv/kvm/Makefile
@@ -15,6 +15,7 @@ kvm-y += vmid.o
 kvm-y += tlb.o
 kvm-y += mmu.o
 kvm-y += vcpu.o
+kvm-y += vcpu_debug.o
 kvm-y += vcpu_exit.o
 kvm-y += vcpu_fp.o
 kvm-y += vcpu_vector.o
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index b5ca9f2e98ac..1d0e43ab0652 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -20,6 +20,7 @@
 #include <asm/csr.h>
 #include <asm/cacheflush.h>
 #include <asm/kvm_vcpu_vector.h>
+#include <asm/switch_to.h>
 
 const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
 	KVM_GENERIC_VCPU_STATS(),
@@ -504,6 +505,9 @@ static void kvm_riscv_vcpu_setup_config(struct kvm_vcpu *vcpu)
 					  SMSTATEEN0_AIA_ISEL;
 		if (riscv_isa_extension_available(isa, SMSTATEEN))
 			cfg->hstateen0 |= SMSTATEEN0_SSTATEEN0;
+
+		if (has_scontext())
+			cfg->hstateen0 |= SMSTATEEN0_HSCONTEXT;
 	}
 }
 
@@ -643,6 +647,8 @@ static __always_inline void kvm_riscv_vcpu_swap_in_guest_state(struct kvm_vcpu *
 	    (cfg->hstateen0 & SMSTATEEN0_SSTATEEN0))
 		vcpu->arch.host_sstateen0 = csr_swap(CSR_SSTATEEN0,
 						     smcsr->sstateen0);
+
+	kvm_riscv_debug_vcpu_swap_in_guest_context(vcpu);
 }
 
 static __always_inline void kvm_riscv_vcpu_swap_in_host_state(struct kvm_vcpu *vcpu)
@@ -656,6 +662,8 @@ static __always_inline void kvm_riscv_vcpu_swap_in_host_state(struct kvm_vcpu *v
 	    (cfg->hstateen0 & SMSTATEEN0_SSTATEEN0))
 		smcsr->sstateen0 = csr_swap(CSR_SSTATEEN0,
 					    vcpu->arch.host_sstateen0);
+
+	kvm_riscv_debug_vcpu_swap_in_host_context(vcpu);
 }
 
 /*
diff --git a/arch/riscv/kvm/vcpu_debug.c b/arch/riscv/kvm/vcpu_debug.c
new file mode 100644
index 000000000000..e7e9263c2e30
--- /dev/null
+++ b/arch/riscv/kvm/vcpu_debug.c
@@ -0,0 +1,29 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2024 SiFive
+ */
+
+#include <linux/kvm_host.h>
+#include <asm/switch_to.h>
+
+void kvm_riscv_debug_vcpu_swap_in_guest_context(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu_sdtrig_csr *csr = &vcpu->arch.sdtrig_csr;
+	unsigned long hcontext = vcpu->kvm->arch.hcontext;
+
+	if (has_hcontext())
+		csr_write(CSR_HCONTEXT, hcontext);
+	if (has_scontext())
+		vcpu->arch.host_scontext = csr_swap(CSR_SCONTEXT, csr->scontext);
+}
+
+void kvm_riscv_debug_vcpu_swap_in_host_context(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu_sdtrig_csr *csr = &vcpu->arch.sdtrig_csr;
+
+	/* Hypervisor uses the hcontext ID 0 */
+	if (has_hcontext())
+		csr_write(CSR_HCONTEXT, 0);
+	if (has_scontext())
+		csr->scontext = csr_swap(CSR_SCONTEXT, vcpu->arch.host_scontext);
+}
diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
index f4a6124d25c9..10dda5ddc0a6 100644
--- a/arch/riscv/kvm/vcpu_onereg.c
+++ b/arch/riscv/kvm/vcpu_onereg.c
@@ -34,6 +34,7 @@ static const unsigned long kvm_isa_ext_arr[] = {
 	[KVM_RISCV_ISA_EXT_M] = RISCV_ISA_EXT_m,
 	[KVM_RISCV_ISA_EXT_V] = RISCV_ISA_EXT_v,
 	/* Multi letter extensions (alphabetically sorted) */
+	KVM_ISA_EXT_ARR(SDTRIG),
 	KVM_ISA_EXT_ARR(SMSTATEEN),
 	KVM_ISA_EXT_ARR(SSAIA),
 	KVM_ISA_EXT_ARR(SSTC),

-- 
2.43.2


