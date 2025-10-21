Return-Path: <kvm+bounces-60646-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id CD914BF5541
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 10:44:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 511E63513E1
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 08:44:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1FB1302175;
	Tue, 21 Oct 2025 08:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="za9jamKF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B778320A2C
	for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 08:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761036271; cv=none; b=k0xZGnJXUny7CMthq80VF7S3gWCUpm6UkLLDc9bA523nuTKEn+IU5gPo8iWsi2cPYl9dpgoajvT/kCGgyihPIgwgj6E7KnZxUa3RZri3b2cip7W1DJYgsiJCKQOtHF3bW1ZdvR8BaGKEeESmTELaA+miJjisdaIjpqRgg5QkNks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761036271; c=relaxed/simple;
	bh=Sx8Bz8sA582Y3VnVegCV7d2iA/O/8xkFXMxBlOPPLf8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lgy+RbNXhpKWoS/oanACcmSULa5+tZ2nge3IBxrgtnyOoSp+TDNRxpdAm53nLejPl1okb4A6PHunN8fV8p7nzBzaZdBGcpjwD4Z9J3vVAE2lnJ1bIFR5HpwGGBrNAXQuEvMQxm20zNo8IMnkgxfR03p20Fy+HG3L2o7HJn51C5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=za9jamKF; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-426edfffc66so3917516f8f.1
        for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 01:44:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1761036267; x=1761641067; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=da9rOiPMCykHVjkJsbrqebc9pkYcny2T2/SQshegPgk=;
        b=za9jamKF8P1da8UhPv2b98Zr/RA4LCfwAziGe2Sdq2Msdmq45+Rsg07dTT44vYpYhw
         NXZLkeBBaDJstKMOsVt45nTx4wt2RWRadM7AaVmdkQ7deAB+t0XGypN6J+KP07F05bcZ
         058pt/MDm3W6NhmVVqgekpBX8EodO79kOn2kKbUHQc0f4woqpN0HtwGa1SSAamc2jpOS
         z31SpvLYeu21rE1/pMa0LFzD7gtJsDkQhFSDEnn6xStMlRpicJvLW7l1sp2PlVO4QYRo
         /rw6W0TuUv13uVkj3nMKcSkHIdjnk5lTYUVrIMaTWLsTvGFGwOzMpkF6ApElOMJPBr89
         vHKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761036267; x=1761641067;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=da9rOiPMCykHVjkJsbrqebc9pkYcny2T2/SQshegPgk=;
        b=rojRggiGVpSatr/w03xvxImfQb1puifsTEyj1+WrUfeAP7Ap7WuqYXNzSTU6+QXoKm
         Vt7LWVd3SsnVc7ZYn/nMAIoMM11R8iA2b3Us6SHQht6TNKA+ggQItaO4Rzj94COs1swr
         BeuxPlMj2PS5R85e2WoeC7/T1Bow1vg+A6i24x/JWYjuHPoPJnAa5Mqa8aZbDLulVKBa
         A21iN16TOOmrzIVa9wuw9MWZKzB73P2cuHpKRWj2PDnOse+UCDZRFunvIx67wyEIA/Gk
         D+oQm4xG1wEraRfrNrKGz59leRA3ma8OvPgAPUyyBy2rgirn51i36ldE7KgJg0kBDprr
         zNqQ==
X-Forwarded-Encrypted: i=1; AJvYcCWwGBunNuWKd177b0NvNlUV4CzOJbmdZ/ENZC/3UvKg15mjC6ZeocHcrER3wYxlQ6rR7FU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyseytVQpJ4B6j8GZBc9rVuASj0Vp/DMLpU1T2fv6vWG9WCj5+q
	n0/HquGUryPbpRGFEfVh5QIl2JETbXcotSN5hNW2/E3MhH0lwwAFfYHSCRLg+7nPwf4=
X-Gm-Gg: ASbGnct9s2M/kBuvPdzGeeIA1MzMForqajvik+0lAkyShRnMSx8Dyu1B+VXtRh9LhMK
	1xhsrdAx8mpeqFuCKttCkVo3Dr10glW+55IfuYvwtwcktBmVBu0Nqo5/H4mPQxGa+KdweyQnkZK
	E2g3zA/l+1yXWFFFfSvVE0LFmPEj0A2+L/YEpOBp3vkwxZTC/lSBg7FAmMqwYgLYNmdt51LHlFi
	PX50IIdFFiDWcUBl++qWojccm1NU3Z7lGtuf8c61fpIzQ+uY+szshdQ5uGUq/AxHhFH7knpqzex
	h7MM7ghD9UOOgagpUb23/yV3iUC7Gn6eefLdMxR4+hZ2vJ3yqPtZGAeaFBYBNDyj1VyiBiMJDVw
	MxmJIlo6GsM+8i51Shn/Ttu2+qVNtGZNn+oXEpjXCyVTfdFtAZkhThwoyUfXSTybMXqz5buhdt0
	FEo7CWHVX/vgjzr74BKnlyIsr13v5/owHgXuW9MtgSUn8qSGXivA==
X-Google-Smtp-Source: AGHT+IGdNU6grxDa0fovZHVQYjLk03VGAqM6vVuoTYaGlfenMJOg7eXSZCsDKxqPUFu1TflYXqOl4A==
X-Received: by 2002:a5d:5849:0:b0:3e7:6424:1b47 with SMTP id ffacd0b85a97d-42704b3db46mr13625580f8f.6.1761036267320;
        Tue, 21 Oct 2025 01:44:27 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-427ea5b3dabsm20200098f8f.16.2025.10.21.01.44.26
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 21 Oct 2025 01:44:26 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Chinmay Rath <rathc@linux.ibm.com>,
	qemu-ppc@nongnu.org,
	Nicholas Piggin <npiggin@gmail.com>,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@redhat.com>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v2 08/11] ppc/spapr: remove deprecated machine pseries-4.0
Date: Tue, 21 Oct 2025 10:43:42 +0200
Message-ID: <20251021084346.73671-9-philmd@linaro.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251021084346.73671-1-philmd@linaro.org>
References: <20251021084346.73671-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Harsh Prateek Bora <harshpb@linux.ibm.com>

pseries-4.0 had been deprecated and due for removal now as per policy.
Also remove pre-4.1 migration hacks which were introduced for backward
compatibility.

Suggested-by: Cédric Le Goater <clg@kaod.org>
Signed-off-by: Harsh Prateek Bora <harshpb@linux.ibm.com>
Reviewed-by: Cédric Le Goater <clg@redhat.com>
[PMD: Remove SpaprMachineClass::pre_4_1_migration field]
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/hw/ppc/spapr.h |  3 ---
 hw/ppc/spapr.c         | 27 ---------------------------
 hw/ppc/spapr_caps.c    | 12 +-----------
 3 files changed, 1 insertion(+), 41 deletions(-)

diff --git a/include/hw/ppc/spapr.h b/include/hw/ppc/spapr.h
index 1db67784de8..58d31b096cd 100644
--- a/include/hw/ppc/spapr.h
+++ b/include/hw/ppc/spapr.h
@@ -139,11 +139,8 @@ struct SpaprCapabilities {
  * SpaprMachineClass:
  */
 struct SpaprMachineClass {
-    /*< private >*/
     MachineClass parent_class;
 
-    /*< public >*/
-    bool pre_4_1_migration; /* don't migrate hpt-max-page-size */
     bool linux_pci_probe;
     bool smp_threads_vsmt; /* set VSMT to smp_threads by default */
     hwaddr rma_limit;          /* clamp the RMA to this size */
diff --git a/hw/ppc/spapr.c b/hw/ppc/spapr.c
index ad9fc61c299..deab613e070 100644
--- a/hw/ppc/spapr.c
+++ b/hw/ppc/spapr.c
@@ -4969,33 +4969,6 @@ static void spapr_machine_4_1_class_options(MachineClass *mc)
 
 DEFINE_SPAPR_MACHINE(4, 1);
 
-/*
- * pseries-4.0
- */
-static bool phb_placement_4_0(SpaprMachineState *spapr, uint32_t index,
-                              uint64_t *buid, hwaddr *pio,
-                              hwaddr *mmio32, hwaddr *mmio64,
-                              unsigned n_dma, uint32_t *liobns, Error **errp)
-{
-    if (!spapr_phb_placement(spapr, index, buid, pio, mmio32, mmio64, n_dma,
-                             liobns, errp)) {
-        return false;
-    }
-    return true;
-}
-static void spapr_machine_4_0_class_options(MachineClass *mc)
-{
-    SpaprMachineClass *smc = SPAPR_MACHINE_CLASS(mc);
-
-    spapr_machine_4_1_class_options(mc);
-    compat_props_add(mc->compat_props, hw_compat_4_0, hw_compat_4_0_len);
-    smc->phb_placement = phb_placement_4_0;
-    smc->irq = &spapr_irq_xics;
-    smc->pre_4_1_migration = true;
-}
-
-DEFINE_SPAPR_MACHINE(4, 0);
-
 static void spapr_machine_register_types(void)
 {
     type_register_static(&spapr_machine_info);
diff --git a/hw/ppc/spapr_caps.c b/hw/ppc/spapr_caps.c
index 0f94c192fd4..170795ad6ad 100644
--- a/hw/ppc/spapr_caps.c
+++ b/hw/ppc/spapr_caps.c
@@ -66,7 +66,6 @@ typedef struct SpaprCapabilityInfo {
     void (*apply)(SpaprMachineState *spapr, uint8_t val, Error **errp);
     void (*cpu_apply)(SpaprMachineState *spapr, PowerPCCPU *cpu,
                       uint8_t val, Error **errp);
-    bool (*migrate_needed)(void *opaque);
 } SpaprCapabilityInfo;
 
 static void spapr_cap_get_bool(Object *obj, Visitor *v, const char *name,
@@ -336,11 +335,6 @@ static void cap_hpt_maxpagesize_apply(SpaprMachineState *spapr,
     spapr_check_pagesize(spapr, qemu_minrampagesize(), errp);
 }
 
-static bool cap_hpt_maxpagesize_migrate_needed(void *opaque)
-{
-    return !SPAPR_MACHINE_GET_CLASS(opaque)->pre_4_1_migration;
-}
-
 static bool spapr_pagesize_cb(void *opaque, uint32_t seg_pshift,
                               uint32_t pshift)
 {
@@ -793,7 +787,6 @@ SpaprCapabilityInfo capability_table[SPAPR_CAP_NUM] = {
         .type = "int",
         .apply = cap_hpt_maxpagesize_apply,
         .cpu_apply = cap_hpt_maxpagesize_cpu_apply,
-        .migrate_needed = cap_hpt_maxpagesize_migrate_needed,
     },
     [SPAPR_CAP_NESTED_KVM_HV] = {
         .name = "nested-hv",
@@ -982,11 +975,8 @@ int spapr_caps_post_migration(SpaprMachineState *spapr)
 static bool spapr_cap_##sname##_needed(void *opaque)    \
 {                                                       \
     SpaprMachineState *spapr = opaque;                  \
-    bool (*needed)(void *opaque) =                      \
-        capability_table[cap].migrate_needed;           \
                                                         \
-    return needed ? needed(opaque) : true &&            \
-           spapr->cmd_line_caps[cap] &&                 \
+    return spapr->cmd_line_caps[cap] &&                 \
            (spapr->eff.caps[cap] !=                     \
             spapr->def.caps[cap]);                      \
 }                                                       \
-- 
2.51.0


