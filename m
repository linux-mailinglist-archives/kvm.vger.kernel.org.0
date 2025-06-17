Return-Path: <kvm+bounces-49736-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 215DEADD801
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 18:51:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 443E22C5E43
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 16:40:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F6312EA752;
	Tue, 17 Jun 2025 16:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="uHxVAb8V"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36C5A2F94A2
	for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 16:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178040; cv=none; b=jxtofT/UWgCgZajTWIulUr1eyQRXLpV+msr5ozTP5Da4QCNCK4MPdLw03xF1mD78bwtkn1XF0mj5XOEOf7Rfoc7BvgxladB+1/M97KARpD6ZVgIsYrXOxLIJNTyRIIvjzqn9QCSBEEaC6rKb8Xi/6Ub/2y6coJlV7eCFL6OH0xY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178040; c=relaxed/simple;
	bh=urgUQGW6SsLAoKzARg1S7NcAXebgTbf199FvKgJwGcI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kjuYLq7ezI2tDeD9l64Cnd03QQmDaNW8eoFaKei38An3DF1ZajyrPb/IyA9y20js1BIkMrlu8pDHdoCcZOITmI1e9FZgK6HE9mRAFbHCoXtAfHSejgzkzX5JTvGXntnfDtJrYvnXs2Y0STiA+8MyzKai+8z6CCliMrXMPIxYiQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=uHxVAb8V; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-3a57c8e247cso2554245f8f.1
        for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 09:33:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750178036; x=1750782836; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rbBMXE6agkH4y/ezmub6pqd0ynNZ26J7iJ0lGND0r7M=;
        b=uHxVAb8VepNVCM2kbrMoPZ8y57rOsFvv5zagc97Gi2bkravDXPPXrtxMrqMQPzH+GN
         z8xULS+HMuxhdCMKsTSeZtKoL0OHu04+jmFRXIz+V474VnLr8ERtK81fkvcWXH2QQin3
         yh3xCuYzE1G1PJG/DzvBqClWOu7QS/LtyE/c89TR9LXqJPakj+uVtSP5YSy1DbF0/quw
         KZh07ZCx4vzPxwir9tgx1dahTD1i7/c+s4dpk0V4GNsqHCpMa1OyKE3CKrTsc68tx+xd
         mToWDm1h4fq0/nIgt0k1G0zWzRdkGbXcp6V8RNK+3TzyyeFthSMuMg9sjoGl7rKpEhQy
         AiuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750178036; x=1750782836;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rbBMXE6agkH4y/ezmub6pqd0ynNZ26J7iJ0lGND0r7M=;
        b=VARLIhG5jCu7uoC8VDS62Lw491hHu4l6L/Mg3lU8DY1fSiucMoSjOqGrDc1WoYwCzg
         9NRBvtIIpviIbUmcZNSqti92e473mFsiCCXVPir+6beRjfZwfu3L2ceJbNGjxRvWc66J
         fqjFEc3AdzZfjCL/UNAVYRq6kO4u6UlYIrec8v+a+rSfO0n2tVf7CoktUXBfqZR+olAY
         uCOcZfRqVRcOBitF6fodXiLUjvw6znqOp6jr1t8iY96zz26Sfps6FlNgV2K1gyNpbIqZ
         GoRJQPnwicpFxzwGBYrg2ITGwkmbPbmE87XiN3XxmkrB4p66oCNyx/tJeMdXSGk0nan7
         SpmQ==
X-Forwarded-Encrypted: i=1; AJvYcCXFVMqd6AVmQ5Bovf7nohHtz9nkPem5IlG4WMJonwtQqGFtpjUMYtaoQZ8d5gkx1DcDvrY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw1zhjXc0YC0Y85XydVvcCVIZVgCY3FIwB8KyGcRzHpgQyoXQME
	L9nmkNJo/7324fjY53BvHRJvObEzDpVmxLQr65HrJJO/B6iRmCuv/ITR5LuPs7GzeLQ=
X-Gm-Gg: ASbGncsP/8YJatDQ44Tyl3XtRDpi+kqZk8Ts4tz1B58FNldWbOgJdZktTlgpX5AO3SH
	zybIK3Pq3N0ajkBBFRhgvGb9lBYMUjfM1jA91yGiCVz3GgwkRML3vokPFZlKYW+Uc0i3FABrIz1
	Bhw9QLMTTQi0unDbMgmAVWUUovA3qkf5smNJyvrfxJx+U7/PjGrJzlQixb27vnjMK5w99oEEcl8
	BF19qv9/WE9L265g1phPuzrGyqe8SLy9VskIT6TYgY5Ed10AqiFu3HSuZhShjXsquob2VZpMcrZ
	VQXSaYzUUOoUEfRa5SvrNF/4/+Pt0CGxana1w4wDFtumb/6lHTz77d97OZO+hFU=
X-Google-Smtp-Source: AGHT+IHa+tTRhzZC5JgvxX7eaDorwkAI71UFHvcJbR60AGJdJK9kAKmeytdmd5ysTcE1li+eFVBMhw==
X-Received: by 2002:a05:6000:2507:b0:3a4:efc0:c90b with SMTP id ffacd0b85a97d-3a5723974e2mr12693214f8f.15.1750178036481;
        Tue, 17 Jun 2025 09:33:56 -0700 (PDT)
Received: from draig.lan ([185.126.160.19])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a568a54d1fsm14265133f8f.2.2025.06.17.09.33.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jun 2025 09:33:54 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 77B535F90B;
	Tue, 17 Jun 2025 17:33:52 +0100 (BST)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: qemu-devel@nongnu.org
Cc: Cornelia Huck <cohuck@redhat.com>,
	qemu-arm@nongnu.org,
	Mark Burton <mburton@qti.qualcomm.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Alexander Graf <graf@amazon.com>,
	kvm@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [RFC PATCH 06/11] kvm/arm: allow out-of kernel GICv3 to work with KVM
Date: Tue, 17 Jun 2025 17:33:46 +0100
Message-ID: <20250617163351.2640572-7-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250617163351.2640572-1-alex.bennee@linaro.org>
References: <20250617163351.2640572-1-alex.bennee@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Previously we suppressed this option as KVM would get confused if it
started trapping GIC system registers without a GIC configured.
However if we know we are trapping harder we can allow it much like we
do for HVF.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 target/arm/kvm_arm.h       |  8 ++++++++
 hw/arm/virt.c              | 11 +++++++++--
 hw/intc/arm_gicv3_common.c |  4 ----
 target/arm/cpu.c           |  2 +-
 target/arm/kvm.c           |  6 ++++++
 hw/intc/Kconfig            |  2 +-
 6 files changed, 25 insertions(+), 8 deletions(-)

diff --git a/target/arm/kvm_arm.h b/target/arm/kvm_arm.h
index a4f68e14cb..008a72ccd4 100644
--- a/target/arm/kvm_arm.h
+++ b/target/arm/kvm_arm.h
@@ -200,6 +200,14 @@ bool kvm_arm_mte_supported(void);
  */
 int kvm_arm_get_type(MachineState *ms);
 
+/**
+ * kvm_arm_is_trapping_harder: return true if trapping harder
+ * @ms: Machine state handle
+ *
+ * return true if trapping harder
+ */
+bool kvm_arm_is_trapping_harder(MachineState *ms);
+
 /**
  * kvm_arm_get_max_vm_ipa_size:
  * @ms: Machine state handle
diff --git a/hw/arm/virt.c b/hw/arm/virt.c
index 55433f8fce..e117433cc7 100644
--- a/hw/arm/virt.c
+++ b/hw/arm/virt.c
@@ -1998,9 +1998,16 @@ static void finalize_gic_version(VirtMachineState *vms)
             gics_supported |= VIRT_GIC_VERSION_3_MASK;
         }
     } else if (kvm_enabled() && !kvm_irqchip_in_kernel()) {
-        /* KVM w/o kernel irqchip can only deal with GICv2 */
+        MachineState *ms = MACHINE(vms);
         gics_supported |= VIRT_GIC_VERSION_2_MASK;
-        accel_name = "KVM with kernel-irqchip=off";
+        if (kvm_arm_is_trapping_harder(ms) &&
+            module_object_class_by_name("arm-gicv3")) {
+            gics_supported |= VIRT_GIC_VERSION_3_MASK;
+            accel_name = "TMH KVM with kernel-irqchip=off";
+        } else {
+            /* KVM w/o kernel irqchip can only deal with GICv2 */
+            accel_name = "KVM with kernel-irqchip=off";
+        }
     } else if (tcg_enabled() || hvf_enabled() || qtest_enabled())  {
         gics_supported |= VIRT_GIC_VERSION_2_MASK;
         if (module_object_class_by_name("arm-gicv3")) {
diff --git a/hw/intc/arm_gicv3_common.c b/hw/intc/arm_gicv3_common.c
index 1cee68193c..9a46afaa0d 100644
--- a/hw/intc/arm_gicv3_common.c
+++ b/hw/intc/arm_gicv3_common.c
@@ -662,10 +662,6 @@ const char *gicv3_class_name(void)
     if (kvm_irqchip_in_kernel()) {
         return "kvm-arm-gicv3";
     } else {
-        if (kvm_enabled()) {
-            error_report("Userspace GICv3 is not supported with KVM");
-            exit(1);
-        }
         return "arm-gicv3";
     }
 }
diff --git a/target/arm/cpu.c b/target/arm/cpu.c
index e025e241ed..f7618a3038 100644
--- a/target/arm/cpu.c
+++ b/target/arm/cpu.c
@@ -1463,7 +1463,7 @@ static void arm_cpu_initfn(Object *obj)
 # endif
 #else
     /* Our inbound IRQ and FIQ lines */
-    if (kvm_enabled()) {
+    if (kvm_enabled() && kvm_irqchip_in_kernel()) {
         /*
          * VIRQ, VFIQ, NMI, VINMI are unused with KVM but we add
          * them to maintain the same interface as non-KVM CPUs.
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index ed0f6024d6..c5374d12cf 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -522,6 +522,12 @@ int kvm_arm_get_type(MachineState *ms)
     return s->trap_harder ? KVM_VM_TYPE_ARM_TRAP_ALL : 0;
 }
 
+bool kvm_arm_is_trapping_harder(MachineState *ms)
+{
+    KVMState *s = KVM_STATE(ms->accelerator);
+    return s->trap_harder;
+}
+
 int kvm_arch_get_default_type(MachineState *ms)
 {
     bool fixed_ipa;
diff --git a/hw/intc/Kconfig b/hw/intc/Kconfig
index 7547528f2c..0eb37364a7 100644
--- a/hw/intc/Kconfig
+++ b/hw/intc/Kconfig
@@ -23,7 +23,7 @@ config APIC
 
 config ARM_GIC
     bool
-    select ARM_GICV3 if TCG
+    select ARM_GICV3 # can be used by TCG, HVF or KVM
     select ARM_GIC_KVM if KVM
     select MSI_NONBROKEN
 
-- 
2.47.2


