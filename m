Return-Path: <kvm+bounces-60499-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A42CDBF096C
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 12:39:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DBE3D188CFA6
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 10:39:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31AEF2FC031;
	Mon, 20 Oct 2025 10:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="x3gcNhSD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35F3D2F90DE
	for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 10:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760956721; cv=none; b=XP+cG1jKSDgT+p/BLaBVuSvE4xMHMu0gXROtNUJfREUEuVWb+dyJtVTmjPJjh79EENqW1nKyFcNUJSSo3UlsQ5KwwE3zH/jqhJuc9ABYWn6zVrLdNQYcT8bz37Db1UO/h9mccfxi2oZr9AZOIMToBgngJXkKBKk/fCl26ngTykI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760956721; c=relaxed/simple;
	bh=9IdtXgoM1psHMmEsBb7pIWvV2CneqgHwrqaa/jBqbto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hGR6HvmrAsg9V5hCJdURWrS0mGW6+NaLjbcoZQYc7OTPPs/R1NXNk47v4gznw5EvbwWxnjJh1kSk26X4jTPrY1tvK6qpJ1tbCjW1UADfFiTrcseYXlLD/EOGh6pSyd+PCiuUwe1i/LEkgzPBzXYN9tHAvITzhK1yOGdcpUPFwzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=x3gcNhSD; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-3ee64bc6b85so5700557f8f.3
        for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 03:38:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1760956717; x=1761561517; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0ihxvz/zYsaWUtfE9vP9orWGk1XOSmxd+RXF63zIcqM=;
        b=x3gcNhSDJ2gGLVtFdWW2j1pK4PIpFHVqkPvCvitXgcVxqYzT4eQptxxkoTbgIs1FUR
         cnAxUiPMcZ/zdjvmOdXpIKOBEfLb31Oxg08jL7em0rdlWIKnWV40AgwvZrn7fFJHVjHh
         kRLcxPu8xNBAdb8NtuLvYX5KvGE/liUTvWEZK8RX3KmkYyuqndAKeoOGirudA86rOiaX
         zhKGZWLlfyWCgzM8PMjqvZ+A059h8KFr4r92cuj3ZtrfiNu1Zk6CNoxBwhUWuziMeY6l
         H2iRTmrAh/Bbgxw5TpP1s4WHUtLKJCRTUhQ3aGRMLQSkOZGHe48k00omyMwtwyInNpBE
         2h1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760956717; x=1761561517;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0ihxvz/zYsaWUtfE9vP9orWGk1XOSmxd+RXF63zIcqM=;
        b=C71STIavb4peCsbuwc9S189vFWJX4Arw7Baxgns78dv0lfiNOt1mevJWgIa4y3T3qU
         t4+Fv76N703Sku2dkgIqCrTVkp9edICdZoOAOvv1ZFUOIGGdnL+F8MFp9S36Ss9FVcfb
         mZkH4Hz9+g9ppwxuHd+PFp5Di8cKfgy9HWNVjL63uiejuW/1kKK1PAUjVUnz+tBl6JWQ
         6vaVpUTMMs3c7QbOVZaceS2d7mUTK+6QRhihozBiinDX+/SR4dp8Lmc2yZX7qzCkMau0
         a75BfoVcQ0lEdiV8jwjcQfouelhqvz70JH7xXpPOf0gJpqWPgvPH2+qBNBZDKbja2pEh
         p0RQ==
X-Forwarded-Encrypted: i=1; AJvYcCVF4ohuc2yGdeLt54fhJgGumIM/T7sZoMxVmGGzEk1mBEJ42rj4h+/PdsEnxiBASABvkps=@vger.kernel.org
X-Gm-Message-State: AOJu0YwFhP9oo9s5p3ZC51VHttJG/cutD0lmd+64UG7Sp1ARXctIbrEg
	WU1shiTT94ZwTyw8MrCD+KCWQLXEBKm6MsRk25jhJf+v5a8EzfY9uMdtSH77bj9bl9M=
X-Gm-Gg: ASbGncviNr7+bJ3Rn/Nz+nNWLt9/KYLYD3hcoROsbTFwNs7aiLpUHH6xOlxDg6vyAbM
	Fbn8scDYr3bPUazypucc5kAse+Ootebm1L2lLMf4ERh0WTLoUmFI13+xTBRFchKacsxlxrOB8Iz
	nM5MtPMr7SxFHBEx2g6vRRusKZEx6LnphRdhMAVKxgqyXJXp6VTxQoerjNkZvKma4Um9qsLulqY
	QzANWL6qRwbNnLCRJ9L5NR/FqZFRksTfH2SIlr1mjpN7dFKS9k8GzvVL7sBAHPRfsoeyrF6sjU/
	fLiu2SOtLqdgTf/lZDIrKpuKgEXnkSLNwnkTO11jL30K+Y2NQ/WOakGt48Ry+DQe0PPOXzKu9Th
	RonIzLtazImXlrOy1uzVQ6+Y7gReLyWVKSdElkNqw2koTLQryi5QNNnxcgYtu4/pT1jDdw0/nNA
	SXj4rQc9aipcRpJMxecqho9U8U93Wbw6HqHnLfnJI4CA0MxWGCNIuexA0PGO8f
X-Google-Smtp-Source: AGHT+IFxCHaLufk14XE5nX0AAEVGB8FvcIDFeS8snE/LozpgkoX/10SV+mciQRu6gpCSHDLuCGf/jA==
X-Received: by 2002:a05:6000:4021:b0:426:d836:f323 with SMTP id ffacd0b85a97d-42704d7e928mr8617320f8f.13.1760956717468;
        Mon, 20 Oct 2025 03:38:37 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-427ea5a0e9csm14845298f8f.5.2025.10.20.03.38.36
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 20 Oct 2025 03:38:37 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	qemu-ppc@nongnu.org,
	kvm@vger.kernel.org,
	Chinmay Rath <rathc@linux.ibm.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH 04/18] hw/ppc/spapr: Remove SpaprMachineClass::nr_xirqs field
Date: Mon, 20 Oct 2025 12:38:00 +0200
Message-ID: <20251020103815.78415-5-philmd@linaro.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251020103815.78415-1-philmd@linaro.org>
References: <20251020103815.78415-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The SpaprMachineClass::nr_xirqs field was only used by the
pseries-3.0 machine, which got removed. Remove it as now unused.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/hw/ppc/spapr.h |  1 -
 hw/ppc/spapr.c         |  1 -
 hw/ppc/spapr_irq.c     | 22 +++++++---------------
 3 files changed, 7 insertions(+), 17 deletions(-)

diff --git a/include/hw/ppc/spapr.h b/include/hw/ppc/spapr.h
index 0c1e5132de2..494367fb99a 100644
--- a/include/hw/ppc/spapr.h
+++ b/include/hw/ppc/spapr.h
@@ -145,7 +145,6 @@ struct SpaprMachineClass {
     /*< public >*/
     bool dr_phb_enabled;       /* enable dynamic-reconfig/hotplug of PHBs */
     bool update_dt_enabled;    /* enable KVMPPC_H_UPDATE_DT */
-    uint32_t nr_xirqs;
     bool broken_host_serial_model; /* present real host info to the guest */
     bool pre_4_1_migration; /* don't migrate hpt-max-page-size */
     bool linux_pci_probe;
diff --git a/hw/ppc/spapr.c b/hw/ppc/spapr.c
index 426a778d3e8..b5d20bc1756 100644
--- a/hw/ppc/spapr.c
+++ b/hw/ppc/spapr.c
@@ -4691,7 +4691,6 @@ static void spapr_machine_class_init(ObjectClass *oc, const void *data)
     smc->dr_phb_enabled = true;
     smc->linux_pci_probe = true;
     smc->smp_threads_vsmt = true;
-    smc->nr_xirqs = SPAPR_NR_XIRQS;
     xfc->match_nvt = spapr_match_nvt;
     vmc->client_architecture_support = spapr_vof_client_architecture_support;
     vmc->quiesce = spapr_vof_quiesce;
diff --git a/hw/ppc/spapr_irq.c b/hw/ppc/spapr_irq.c
index 14e47acc65b..2ce323457be 100644
--- a/hw/ppc/spapr_irq.c
+++ b/hw/ppc/spapr_irq.c
@@ -279,15 +279,11 @@ void spapr_irq_dt(SpaprMachineState *spapr, uint32_t nr_servers,
 
 uint32_t spapr_irq_nr_msis(SpaprMachineState *spapr)
 {
-    SpaprMachineClass *smc = SPAPR_MACHINE_GET_CLASS(spapr);
-
-    return smc->nr_xirqs + SPAPR_XIRQ_BASE - SPAPR_IRQ_MSI;
+    return SPAPR_NR_XIRQS + SPAPR_XIRQ_BASE - SPAPR_IRQ_MSI;
 }
 
 void spapr_irq_init(SpaprMachineState *spapr, Error **errp)
 {
-    SpaprMachineClass *smc = SPAPR_MACHINE_GET_CLASS(spapr);
-
     if (kvm_enabled() && kvm_kernel_irqchip_split()) {
         error_setg(errp, "kernel_irqchip split mode not supported on pseries");
         return;
@@ -308,7 +304,7 @@ void spapr_irq_init(SpaprMachineState *spapr, Error **errp)
         object_property_add_child(OBJECT(spapr), "ics", obj);
         object_property_set_link(obj, ICS_PROP_XICS, OBJECT(spapr),
                                  &error_abort);
-        object_property_set_int(obj, "nr-irqs", smc->nr_xirqs, &error_abort);
+        object_property_set_int(obj, "nr-irqs", SPAPR_NR_XIRQS, &error_abort);
         if (!qdev_realize(DEVICE(obj), NULL, errp)) {
             return;
         }
@@ -322,7 +318,7 @@ void spapr_irq_init(SpaprMachineState *spapr, Error **errp)
         int i;
 
         dev = qdev_new(TYPE_SPAPR_XIVE);
-        qdev_prop_set_uint32(dev, "nr-irqs", smc->nr_xirqs + SPAPR_IRQ_NR_IPIS);
+        qdev_prop_set_uint32(dev, "nr-irqs", SPAPR_NR_XIRQS + SPAPR_IRQ_NR_IPIS);
         /*
          * 8 XIVE END structures per CPU. One for each available
          * priority
@@ -349,7 +345,7 @@ void spapr_irq_init(SpaprMachineState *spapr, Error **errp)
     }
 
     spapr->qirqs = qemu_allocate_irqs(spapr_set_irq, spapr,
-                                      smc->nr_xirqs + SPAPR_IRQ_NR_IPIS);
+                                      SPAPR_NR_XIRQS + SPAPR_IRQ_NR_IPIS);
 
     /*
      * Mostly we don't actually need this until reset, except that not
@@ -364,11 +360,10 @@ int spapr_irq_claim(SpaprMachineState *spapr, int irq, bool lsi, Error **errp)
 {
     SpaprInterruptController *intcs[] = ALL_INTCS(spapr);
     int i;
-    SpaprMachineClass *smc = SPAPR_MACHINE_GET_CLASS(spapr);
     int rc;
 
     assert(irq >= SPAPR_XIRQ_BASE);
-    assert(irq < (smc->nr_xirqs + SPAPR_XIRQ_BASE));
+    assert(irq < (SPAPR_NR_XIRQS + SPAPR_XIRQ_BASE));
 
     for (i = 0; i < ARRAY_SIZE(intcs); i++) {
         SpaprInterruptController *intc = intcs[i];
@@ -388,10 +383,9 @@ void spapr_irq_free(SpaprMachineState *spapr, int irq, int num)
 {
     SpaprInterruptController *intcs[] = ALL_INTCS(spapr);
     int i, j;
-    SpaprMachineClass *smc = SPAPR_MACHINE_GET_CLASS(spapr);
 
     assert(irq >= SPAPR_XIRQ_BASE);
-    assert((irq + num) <= (smc->nr_xirqs + SPAPR_XIRQ_BASE));
+    assert((irq + num) <= (SPAPR_NR_XIRQS + SPAPR_XIRQ_BASE));
 
     for (i = irq; i < (irq + num); i++) {
         for (j = 0; j < ARRAY_SIZE(intcs); j++) {
@@ -408,8 +402,6 @@ void spapr_irq_free(SpaprMachineState *spapr, int irq, int num)
 
 qemu_irq spapr_qirq(SpaprMachineState *spapr, int irq)
 {
-    SpaprMachineClass *smc = SPAPR_MACHINE_GET_CLASS(spapr);
-
     /*
      * This interface is basically for VIO and PHB devices to find the
      * right qemu_irq to manipulate, so we only allow access to the
@@ -418,7 +410,7 @@ qemu_irq spapr_qirq(SpaprMachineState *spapr, int irq)
      * interfaces, we can change this if we need to in future.
      */
     assert(irq >= SPAPR_XIRQ_BASE);
-    assert(irq < (smc->nr_xirqs + SPAPR_XIRQ_BASE));
+    assert(irq < (SPAPR_NR_XIRQS + SPAPR_XIRQ_BASE));
 
     if (spapr->ics) {
         assert(ics_valid_irq(spapr->ics, irq));
-- 
2.51.0


