Return-Path: <kvm+bounces-65599-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CB93CB118A
	for <lists+kvm@lfdr.de>; Tue, 09 Dec 2025 22:04:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4CADF3142663
	for <lists+kvm@lfdr.de>; Tue,  9 Dec 2025 21:02:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6FAE30C602;
	Tue,  9 Dec 2025 20:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LEcrEpzi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f73.google.com (mail-ot1-f73.google.com [209.85.210.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 760DD308F36
	for <kvm@vger.kernel.org>; Tue,  9 Dec 2025 20:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765313556; cv=none; b=aFLiUN5F2u9AK0/w7b++J7TQMckiFe61EmClh2bI+fWakO6NIF2NMpwlrmvACLqIEMr3ucACQkBW00Q1RsXQlY+U9VkB9kmbMZGM1oaMAFETFk4yNvoNazbBDdLtduVdtfP42T2Ge/c4FW295m3QrOxYhlgSimlXislnR6zZOJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765313556; c=relaxed/simple;
	bh=Df9Qx2xfEKI6+qK1rsPflT7Kf/FfYXCuJ7XJVpUi3Es=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=APQNBc0TUhm+W8Kd7FlZCRZPOT/cHlBtlJWey3+sQXh03w8mx98SsEF9cu/UkqiybUOMOH7TZ2YjRKxKxr+C5jKYpegSvsDqA1hHVcTtJsUcs0bznwAnUhL9OV9/kaEKQdsYxWnaxFGrko1Pt+WwY4IT3cbcL9PO/NZXUUr5Ma0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LEcrEpzi; arc=none smtp.client-ip=209.85.210.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-ot1-f73.google.com with SMTP id 46e09a7af769-7c75663feaeso6997808a34.3
        for <kvm@vger.kernel.org>; Tue, 09 Dec 2025 12:52:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765313551; x=1765918351; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3zDt0iNU+euTK/TFW8J/j2N0ChdqTjom0mpiCcHEvBA=;
        b=LEcrEpzihMjp2njP1jN5eCDWcZczAbvE/b5FiUHKHA5Uxun3XAUqkxSeNsn7d7rmd0
         gMqqivjzE36KEh3Cy3kH2UCASrGCiZGEhn2E2lMmr77ELnIU+tpHIVkb4RoN2L20HC7n
         tVUcmSS2dTnYlCPOMPh8+7kEgE/eQh0V9JNr6NsG9CfyUhzh9xTH3a9X6jzSgfgqQDue
         N33AD6wZgPXQ//mMOlqGbwh61AbWesd+lk/Bd4pSiphmfJl2RiZo3k91d1PU9GsgxZ2O
         GB8x3RtmQBI6as+0qGIruhFwJaVV23EbVPnkUFVstrQUwZH/D/lnnZTLrlJWAoYOyxqz
         pwkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765313551; x=1765918351;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3zDt0iNU+euTK/TFW8J/j2N0ChdqTjom0mpiCcHEvBA=;
        b=OOE0TGluRA86/V8ikE/F3kFnSamnQcZO2o1EXjSR5eMRZ6BTf6XZ5FHyduNVtGMvu4
         qlT/P/YTdpj+feHhM8+3GrPsBJilijMf+Uy2olFD6/qEl4bxM1S/G9ctkF2kGmLI0TB1
         Ow4AWOon2fB2WPWDPN1vztw/Ccd1FOp8HW/W/kPPpc4ipjo2wDOuAfyrEQ9PSJaSzZ1N
         gOKLiosjEV41c/aTRF2nZtdmJO/Lww7YHu3N0+6ZVqSUSA31y3GMoGQ2Kj+vD7+pk2A8
         tKly0yb6B9FdYySqotsARRgySqzDgxmhrkETYgxO/1OJTtEsqJecCkBjOq2sLuw1FaN1
         9OBA==
X-Gm-Message-State: AOJu0YzemzPozAc+x4txXoiZ/Z4Rowz5sG/Mp1HZe0zH/6G3qRC4PkCl
	pk9Ogi5ytTv29O3chN0ZJ26QWQq+SbyLVjIuBBoG/12g8tW7JQ+AEkAStzJK5vcJhkbIA5XcWT6
	4M4st2h6HUYNXS6WRLdlYeJfD4bSawEHaLMs+wFt5YhvG61dvS+gI9dBLw0W9g922qE0J5RinKH
	clDRCq587OhAsHq3JVn1H7TdEkSZEZbGq8weUVxdl/Wti1jovOJemmfXhNM10=
X-Google-Smtp-Source: AGHT+IEKtn0WDN0qJ9sLPEWZNEZ7Ha5CeZ3q/VCsbWa648/vK4db/UbIl9YHdIzflWwFx6OplmDw/cVFnsD3PMM3vw==
X-Received: from oty4-n1.prod.google.com ([2002:a05:6830:4d84:10b0:7c7:5343:40d1])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6830:618a:b0:7ab:e111:1a57 with SMTP id 46e09a7af769-7cacec3df9fmr64282a34.31.1765313550662;
 Tue, 09 Dec 2025 12:52:30 -0800 (PST)
Date: Tue,  9 Dec 2025 20:51:02 +0000
In-Reply-To: <20251209205121.1871534-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251209205121.1871534-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.52.0.239.gd5f0c6e74e-goog
Message-ID: <20251209205121.1871534-6-coltonlewis@google.com>
Subject: [PATCH v5 05/24] KVM: arm64: Reorganize PMU includes
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Mingwei Zhang <mizhang@google.com>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Mark Rutland <mark.rutland@arm.com>, Shuah Khan <shuah@kernel.org>, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Marc Zyngier <maz@kernel.org>

Including *all* of asm/kvm_host.h in asm/arm_pmuv3.h is a bad idea
because that is much more than arm_pmuv3.h logically needs and creates
a circular dependency that makes it easy to introduce compiler errors
when editing this code.

asm/kvm_host.h includes asm/kvm_pmu.h includes perf/arm_pmuv3.h
includes asm/arm_pmuv3.h includes asm/kvm_host.h

Reorganize the PMU includes to be more sane. In particular:

* Remove the circular dependency by removing the kvm_host.h include
  from asm/arm_pmuv3.h since 99% of it isn't needed.

* Move the remaining tiny bit of KVM/PMU interface from kvm_host.h
  into kvm_pmu.h

* Conditionally on ARM64, include the more targeted kvm_pmu.h directly
  in the arm_pmuv3.c driver.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/include/asm/arm_pmuv3.h |  2 --
 arch/arm64/include/asm/kvm_host.h  | 14 --------------
 arch/arm64/include/asm/kvm_pmu.h   | 15 +++++++++++++++
 drivers/perf/arm_pmuv3.c           |  5 +++++
 4 files changed, 20 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/include/asm/arm_pmuv3.h b/arch/arm64/include/asm/arm_pmuv3.h
index 8a777dec8d88a..cf2b2212e00a2 100644
--- a/arch/arm64/include/asm/arm_pmuv3.h
+++ b/arch/arm64/include/asm/arm_pmuv3.h
@@ -6,8 +6,6 @@
 #ifndef __ASM_PMUV3_H
 #define __ASM_PMUV3_H
 
-#include <asm/kvm_host.h>
-
 #include <asm/cpufeature.h>
 #include <asm/sysreg.h>
 
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 7f19702eac2b9..c7e52aaf469dc 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1410,25 +1410,11 @@ void kvm_arch_vcpu_ctxflush_fp(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_ctxsync_fp(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu);
 
-static inline bool kvm_pmu_counter_deferred(struct perf_event_attr *attr)
-{
-	return (!has_vhe() && attr->exclude_host);
-}
-
 #ifdef CONFIG_KVM
-void kvm_set_pmu_events(u64 set, struct perf_event_attr *attr);
-void kvm_clr_pmu_events(u64 clr);
-bool kvm_set_pmuserenr(u64 val);
 void kvm_enable_trbe(void);
 void kvm_disable_trbe(void);
 void kvm_tracing_set_el1_configuration(u64 trfcr_while_in_guest);
 #else
-static inline void kvm_set_pmu_events(u64 set, struct perf_event_attr *attr) {}
-static inline void kvm_clr_pmu_events(u64 clr) {}
-static inline bool kvm_set_pmuserenr(u64 val)
-{
-	return false;
-}
 static inline void kvm_enable_trbe(void) {}
 static inline void kvm_disable_trbe(void) {}
 static inline void kvm_tracing_set_el1_configuration(u64 trfcr_while_in_guest) {}
diff --git a/arch/arm64/include/asm/kvm_pmu.h b/arch/arm64/include/asm/kvm_pmu.h
index baf028d19dfc9..ad3247b468388 100644
--- a/arch/arm64/include/asm/kvm_pmu.h
+++ b/arch/arm64/include/asm/kvm_pmu.h
@@ -11,9 +11,15 @@
 #include <linux/kvm_types.h>
 #include <linux/perf_event.h>
 #include <linux/perf/arm_pmuv3.h>
+#include <linux/perf/arm_pmu.h>
 
 #define KVM_ARMV8_PMU_MAX_COUNTERS	32
 
+#define kvm_pmu_counter_deferred(attr)			\
+	({						\
+		!has_vhe() && (attr)->exclude_host;	\
+	})
+
 #if IS_ENABLED(CONFIG_HW_PERF_EVENTS) && IS_ENABLED(CONFIG_KVM)
 struct kvm_pmc {
 	u8 idx;	/* index into the pmu->pmc array */
@@ -68,6 +74,9 @@ int kvm_arm_pmu_v3_has_attr(struct kvm_vcpu *vcpu,
 int kvm_arm_pmu_v3_enable(struct kvm_vcpu *vcpu);
 
 struct kvm_pmu_events *kvm_get_pmu_events(void);
+void kvm_set_pmu_events(u64 set, struct perf_event_attr *attr);
+void kvm_clr_pmu_events(u64 clr);
+bool kvm_set_pmuserenr(u64 val);
 void kvm_vcpu_pmu_restore_guest(struct kvm_vcpu *vcpu);
 void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu);
 void kvm_vcpu_pmu_resync_el0(void);
@@ -161,6 +170,12 @@ static inline u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1)
 
 #define kvm_vcpu_has_pmu(vcpu)		({ false; })
 static inline void kvm_pmu_update_vcpu_events(struct kvm_vcpu *vcpu) {}
+static inline void kvm_set_pmu_events(u64 set, struct perf_event_attr *attr) {}
+static inline void kvm_clr_pmu_events(u64 clr) {}
+static inline bool kvm_set_pmuserenr(u64 val)
+{
+	return false;
+}
 static inline void kvm_vcpu_pmu_restore_guest(struct kvm_vcpu *vcpu) {}
 static inline void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu) {}
 static inline void kvm_vcpu_reload_pmu(struct kvm_vcpu *vcpu) {}
diff --git a/drivers/perf/arm_pmuv3.c b/drivers/perf/arm_pmuv3.c
index 69c5cc8f56067..513122388b9da 100644
--- a/drivers/perf/arm_pmuv3.c
+++ b/drivers/perf/arm_pmuv3.c
@@ -9,6 +9,11 @@
  */
 
 #include <asm/irq_regs.h>
+
+#if defined(CONFIG_ARM64)
+#include <asm/kvm_pmu.h>
+#endif
+
 #include <asm/perf_event.h>
 #include <asm/virt.h>
 
-- 
2.52.0.239.gd5f0c6e74e-goog


