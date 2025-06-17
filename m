Return-Path: <kvm+bounces-49735-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DDC77ADD81E
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 18:52:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 59F864A4D9C
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 16:40:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C14A2EA739;
	Tue, 17 Jun 2025 16:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="r8QjzoJm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A7512F9489
	for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 16:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178039; cv=none; b=Ll7SbeHTXQiSQVpVRLFBzWJ0+VwCwFfqPTMffyno2hosx0gagNohdFLgnmTOXl9ydc3Z8CcNUO4y3Co38DN2K0p/60JZSAiPqRmn+msxlqLnlvARxqBOj/OGULl93h0lfv/pmOUJAPD5LBquGR7fnQTYM26Q977/7MKdhHJInLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178039; c=relaxed/simple;
	bh=F7eqhAqPvH1FmuTfxqowUlpVP/4bzD82FGVkk0aLhgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e2AucpatPcNwWGCTA5wDqS8Q48zvTuuWb0jZCXJAdP1fT7HP+xjRuPdC6hYJDGs9pALkMjcjfT6uAEUyS3YROO4u2RErXQvn1Z3EZkxcUIDpXtjYuUHX5NNMQS8OJcJGEMzGs/n+rimGX8/7G5zuKdkNS7YLyxhUHX9lk/aL4To=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=r8QjzoJm; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-441ab63a415so68566845e9.3
        for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 09:33:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750178036; x=1750782836; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I4mTaJwkAe0rgPcWQ6kEwY/uI1enES5AbvkajjNAiL4=;
        b=r8QjzoJmngC5IC5Zh4axZjDI4XsfIh6UhTUg8pcP8h8EKJSAQZno+BaK2w4yJ0ugWz
         fLds8lmRvQ3u5nk8Cm8++q3tzXGUCMiFKT1cT98A9pVdLKnEnBO1pJ0WvpUCgiK7a9pp
         Nw2tkYoSdS45SmouUE7W7bBk85AU53d2Sj5KTXUEkVXDXZkM8B7gv2HozqoToEUjvXo7
         HXLeHk5AF1VK4dU4y0JxFKZ6W+NI1yuxaN5hAkwZTFxzS/P8Kx60q3MPHgqf3WID9M4x
         hVDcU9nlfWtMPX7/SRh94G4QsQwAjBdTY2oAHTKmpHwnfE5tGmu2wx4pICxb+OjvJDTJ
         iINA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750178036; x=1750782836;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I4mTaJwkAe0rgPcWQ6kEwY/uI1enES5AbvkajjNAiL4=;
        b=VQ+MrCtOg+JGkBKdXwXsfLu8sI+4acTOj/3oFHT8cRW6dK6i9iYaewvPN717HBpIjg
         ATaRmSjAavkePV+IUB9pGkDOw00sbElHyXRM2p+g++CJWv/SBotICKw2ZdFAL6iXBvER
         o7sLxvgT/f+c5ATD09P1J9K2XUMqwMnCHzRuLTILjBQnf2slNEge1bNKtom5hifIl66D
         iitefQ/B3lKFcHa4TkZX6hGLOOCwAyb6+CjHo71hHpcw491niyvFoqrwN1FkQQ5T4omK
         4IKvNvxRegG8HToUJRzBLKKJL+Io/YcPNMpRLWkjCUx2SuRgOD8aeI0WZhyyI1JzpOgs
         goCA==
X-Forwarded-Encrypted: i=1; AJvYcCXXFLXY77Q1njS08xayW/WHqKI4jJerih3ByMDdFxxtSAE28ANOIcMxuWDEQ1BYYf47fRk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzTKmMY4TRVxmcr4sTy1xTUqT5BeOW/Cj0hKQ827sELi993x44+
	trD0GkXf+c9s+gYBAe5CNyOJzdVGmM3tWVyXeeigIxw3VN97mOROz6iG8qBRocTboAU=
X-Gm-Gg: ASbGnctDmLAdCSHkUbUhBn060CFZpCsJQQPJCNIZ9t+Xyth12oAdUaTYtrgrLIsKvR5
	nVSdyMvIr5EhQkIqcYankrwKDv8Vc2WhP+AuQpgL4zE9UQUTh1q3GMrGNWBclc1Xsoe5qLrOFov
	jBuBs8Goh3ELk3Kc8dBI41BlXHLgi7uo7c8dHswAkINYVObvXEF2oY/grtyKhlbbW0GRXlyB5u+
	z0/Lc/DX9WasSll1ljN0G2mP/0et2VrbSighAAInofQ+5nle7s5UXrpyUDINj2hTy6HmxQ/4wmh
	ZMYODQvYeZeKimLN1jXMa9rvFi+8vYnd2A+KKdVIlpIz43VFGBU/NA+XUsom88c=
X-Google-Smtp-Source: AGHT+IESqAJjlJORLPBH6qBRxEOGX0LC6olwh+WEK+ySWojj+8sfKO3Ap0Z35PSoPGipXAysw/qWZQ==
X-Received: by 2002:a05:600c:1e02:b0:43d:fa59:af97 with SMTP id 5b1f17b1804b1-4533cac919bmr120131075e9.32.1750178035689;
        Tue, 17 Jun 2025 09:33:55 -0700 (PDT)
Received: from draig.lan ([185.126.160.19])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4532e232219sm178762495e9.9.2025.06.17.09.33.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jun 2025 09:33:54 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 5B8825F8B5;
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
Subject: [RFC PATCH 05/11] target/arm: enable KVM_VM_TYPE_ARM_TRAP_ALL when asked
Date: Tue, 17 Jun 2025 17:33:45 +0100
Message-ID: <20250617163351.2640572-6-alex.bennee@linaro.org>
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

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 target/arm/kvm_arm.h | 9 +++++++++
 hw/arm/virt.c        | 7 +++++--
 target/arm/kvm.c     | 7 +++++++
 3 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/target/arm/kvm_arm.h b/target/arm/kvm_arm.h
index 7dc83caed5..a4f68e14cb 100644
--- a/target/arm/kvm_arm.h
+++ b/target/arm/kvm_arm.h
@@ -191,6 +191,15 @@ bool kvm_arm_sve_supported(void);
  */
 bool kvm_arm_mte_supported(void);
 
+/**
+ * kvm_arm_get_type: return the base KVM type flags
+ * @ms: Machine state handle
+ *
+ * Returns the base type flags, usually zero. These will be combined
+ * with the IPA flags from bellow.
+ */
+int kvm_arm_get_type(MachineState *ms);
+
 /**
  * kvm_arm_get_max_vm_ipa_size:
  * @ms: Machine state handle
diff --git a/hw/arm/virt.c b/hw/arm/virt.c
index 9a6cd085a3..55433f8fce 100644
--- a/hw/arm/virt.c
+++ b/hw/arm/virt.c
@@ -3037,11 +3037,14 @@ static HotplugHandler *virt_machine_get_hotplug_handler(MachineState *machine,
 
 /*
  * for arm64 kvm_type [7-0] encodes the requested number of bits
- * in the IPA address space
+ * in the IPA address space.
+ *
+ * For trap-me-harder we apply KVM_VM_TYPE_ARM_TRAP_ALL
  */
 static int virt_kvm_type(MachineState *ms, const char *type_str)
 {
     VirtMachineState *vms = VIRT_MACHINE(ms);
+    int kvm_type = kvm_arm_get_type(ms);
     int max_vm_pa_size, requested_pa_size;
     bool fixed_ipa;
 
@@ -3071,7 +3074,7 @@ static int virt_kvm_type(MachineState *ms, const char *type_str)
      * the implicit legacy 40b IPA setting, in which case the kvm_type
      * must be 0.
      */
-    return fixed_ipa ? 0 : requested_pa_size;
+    return fixed_ipa ? kvm_type : deposit32(kvm_type, 0, 8, requested_pa_size);
 }
 
 static int virt_hvf_get_physical_address_range(MachineState *ms)
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 8b1719bfc1..ed0f6024d6 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -515,6 +515,13 @@ int kvm_arm_get_max_vm_ipa_size(MachineState *ms, bool *fixed_ipa)
     return ret > 0 ? ret : 40;
 }
 
+int kvm_arm_get_type(MachineState *ms)
+{
+    KVMState *s = KVM_STATE(ms->accelerator);
+
+    return s->trap_harder ? KVM_VM_TYPE_ARM_TRAP_ALL : 0;
+}
+
 int kvm_arch_get_default_type(MachineState *ms)
 {
     bool fixed_ipa;
-- 
2.47.2


