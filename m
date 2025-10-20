Return-Path: <kvm+bounces-60498-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 48F79BF0951
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 12:38:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id C0A0234589E
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 10:38:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6784C2F9C37;
	Mon, 20 Oct 2025 10:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="lf1w1Amj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75890242D89
	for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 10:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760956716; cv=none; b=AQRcw8+6KUFMuev5TVlIo1ewPSzovKRT0b2mqmXpxrvezgg1HldrGc8B7EVeETerI+Xq4v27QWJBgTcZpEGMLeZHM1GQ6HnEJnZbWgXmpTMbZ/5F/6z0961mwx+zYP6A+seJqaGbyu/7+A6dlqsVT42yQyk1AkXsiW1YEhLpKZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760956716; c=relaxed/simple;
	bh=DRFl9COkQJ939qAuZ2H5ybtuA2X0m4HcWgVU7kgYBXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Tkqi52fy/2zPgFcOkrB3jNEB5o+yMUxqdVBq0YoiyS10530blX7/vxBLL2HQ2m3O0RFD8dGtydPsl+fHrKLV6BCIX1wElFG9owrWktPxLEAZENquUaQgxdseHSkxLbgfyanxL0C6OthP/JBLPLtSJDBmI2t3kDzd+nH7wfL3Bwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=lf1w1Amj; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-471075c0a18so44357665e9.1
        for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 03:38:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1760956713; x=1761561513; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yCVCJzBQFldWaH4w+gbsije/shLLiDepBPxOaxlrC0k=;
        b=lf1w1AmjNI/PE7OH8u/u2IXPBhP4j0rSi1pLuR4Ne4yjDw3QgxDGs/rh8q6uqbNK+a
         J29nMN8bNSqsyvppTbzb5/fx/+mnYo/tOdk4seCIRikWCfXwqBUTo5IlT/Mm2nxVQg6e
         ycxYvOnpNBW1bzmsygjdiW/SQXFF1NFNDmBFv93Ww8LHiwkbu66qlFYDsj4jCkEkVK2S
         89SCOfsBfZXqaHjqKyzPrPtih+EviMDTEfQ9zDLmQAV45SihY+LnMWn58OwxZ8/U1OZZ
         g2SB7YlLqoXEcxs3olFum7SknslVFEDUb/kk3JW/XeRetK2T4DFVdp6HWQ3ZrJwB4Ep8
         qYxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760956713; x=1761561513;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yCVCJzBQFldWaH4w+gbsije/shLLiDepBPxOaxlrC0k=;
        b=g0f6/ZdUdz5FZI+ccWo0zpUjkp7pY/AphvlpCO/n4bQMNt186aRpyr7uNRpXxoARKs
         diO+1rcfoe44ZTBPpkV4aWUMOj3W3luV3U5iFrjq2mUpccKuJ6rgtuMoUpZ/ESnglSj5
         dqohs/mLGcvIAQLHKQXVeJR2wNCyBC6GEzIaV6RO4KHphZFj0x+OnoN8OOVuWG12gmI0
         icuHKDTfl0hiBgs1KGvBO7Iul8HYSgij4MiuPQ0aiVVAxDmJk9XBY3sg96AhhaQ2nCt9
         EO7hPrfidDjkkxqc7uHRpeTqyn+yvrwCcXNOO5dOPkKmi0Yx3O0AFmNPUnNJvb8mdoBN
         4R4A==
X-Forwarded-Encrypted: i=1; AJvYcCXx6lZG/dQsD+GwwrqToyAZvmRJSpeviNjSciqbLudYrd6KsP4+uDZVIOkIBqqkE3/wX+s=@vger.kernel.org
X-Gm-Message-State: AOJu0YxGfdRY7InQPH2oKiggbM9IHo9roUvgi65aYcXM5hyTpYY1OsBj
	Q4zxexmSOEPwKD80BOrUeATNynjHBzclNL3rVGiJ7Axc5PTVz0BgQNkBiiHlhCGhWTY=
X-Gm-Gg: ASbGnct5Hp9393Mz0aZUi/SjIKGzrLsbZhQb4EAN8CI8tAhNUxAnTqqTLoCHixJEgqd
	g2bsuR2FBb+sA7ogGElroHm0CXfAvE1VmUk/TJM7g08fZz2Z/bn3dHoGsBxEr114OH/RM/XKb6r
	KA3Y6m1RicKB8Sbv+4tXRsP1KZFBxpx9uGNJnuv7pFSj9ZAMtTzhJXLXpXVIdxpLpoPYwlW0zi8
	wA3Sdm3NmbndydZwpRE7qwUJZ0MRwh5avClZ46ms9gsos6jCZGUyJl0h6Nh3NehdJ3Y2e/JL3jJ
	cmBCDbNVOX3vdeyLnLASCE2aDTAypc7dw7x56tn31DcnE1D7ngkyngaXIKDoQ2nw4RlulDPM5/+
	YGybZMU7g9FNAAtHyBtNYOm1AQHlNPUfFZr6SUQI8Ypm85uM+YCRDW+6cRzmbwG85Gy2Z47M4DW
	SLriPnAOEN4rgiLx248y+JXSQ6f2oGN3kuN2Whf8u1eFX5JPdlLw==
X-Google-Smtp-Source: AGHT+IE1F5AkBjZ2Kcl+ql57kKPzckKqh+6Vz8ZzF/8zSDBRUEs2BLnaHom0/e3CLqeN/DyttLrGiQ==
X-Received: by 2002:a05:600c:548a:b0:46e:6d5f:f68 with SMTP id 5b1f17b1804b1-4711787a2cdmr85471925e9.12.1760956712528;
        Mon, 20 Oct 2025 03:38:32 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4715e2ee446sm61701135e9.6.2025.10.20.03.38.31
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 20 Oct 2025 03:38:32 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	qemu-ppc@nongnu.org,
	kvm@vger.kernel.org,
	Chinmay Rath <rathc@linux.ibm.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH 03/18] hw/ppc/spapr: Remove SpaprMachineClass::legacy_irq_allocation field
Date: Mon, 20 Oct 2025 12:37:59 +0200
Message-ID: <20251020103815.78415-4-philmd@linaro.org>
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

The SpaprMachineClass::legacy_irq_allocation field was only used by the
pseries-3.0 machine, which got removed. Remove it as now unused.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/hw/ppc/spapr.h |  1 -
 hw/ppc/spapr.c         |  5 -----
 hw/ppc/spapr_events.c  | 20 ++++----------------
 hw/ppc/spapr_irq.c     | 11 +----------
 hw/ppc/spapr_pci.c     | 32 ++++----------------------------
 hw/ppc/spapr_vio.c     |  9 ---------
 6 files changed, 9 insertions(+), 69 deletions(-)

diff --git a/include/hw/ppc/spapr.h b/include/hw/ppc/spapr.h
index 39bd5bd5ed3..0c1e5132de2 100644
--- a/include/hw/ppc/spapr.h
+++ b/include/hw/ppc/spapr.h
@@ -145,7 +145,6 @@ struct SpaprMachineClass {
     /*< public >*/
     bool dr_phb_enabled;       /* enable dynamic-reconfig/hotplug of PHBs */
     bool update_dt_enabled;    /* enable KVMPPC_H_UPDATE_DT */
-    bool legacy_irq_allocation;
     uint32_t nr_xirqs;
     bool broken_host_serial_model; /* present real host info to the guest */
     bool pre_4_1_migration; /* don't migrate hpt-max-page-size */
diff --git a/hw/ppc/spapr.c b/hw/ppc/spapr.c
index ebc8e84512a..426a778d3e8 100644
--- a/hw/ppc/spapr.c
+++ b/hw/ppc/spapr.c
@@ -3361,11 +3361,6 @@ static void spapr_set_ic_mode(Object *obj, const char *value, Error **errp)
 {
     SpaprMachineState *spapr = SPAPR_MACHINE(obj);
 
-    if (SPAPR_MACHINE_GET_CLASS(spapr)->legacy_irq_allocation) {
-        error_setg(errp, "This machine only uses the legacy XICS backend, don't pass ic-mode");
-        return;
-    }
-
     /* The legacy IRQ backend can not be set */
     if (strcmp(value, "xics") == 0) {
         spapr->irq = &spapr_irq_xics;
diff --git a/hw/ppc/spapr_events.c b/hw/ppc/spapr_events.c
index 832b0212f31..892ddc7f8f7 100644
--- a/hw/ppc/spapr_events.c
+++ b/hw/ppc/spapr_events.c
@@ -1041,20 +1041,14 @@ void spapr_clear_pending_hotplug_events(SpaprMachineState *spapr)
 
 void spapr_events_init(SpaprMachineState *spapr)
 {
-    int epow_irq = SPAPR_IRQ_EPOW;
-
-    if (SPAPR_MACHINE_GET_CLASS(spapr)->legacy_irq_allocation) {
-        epow_irq = spapr_irq_findone(spapr, &error_fatal);
-    }
-
-    spapr_irq_claim(spapr, epow_irq, false, &error_fatal);
+    spapr_irq_claim(spapr, SPAPR_IRQ_EPOW, false, &error_fatal);
 
     QTAILQ_INIT(&spapr->pending_events);
 
     spapr->event_sources = spapr_event_sources_new();
 
     spapr_event_sources_register(spapr->event_sources, EVENT_CLASS_EPOW,
-                                 epow_irq);
+                                 SPAPR_IRQ_EPOW);
 
     /* NOTE: if machine supports modern/dedicated hotplug event source,
      * we add it to the device-tree unconditionally. This means we may
@@ -1065,16 +1059,10 @@ void spapr_events_init(SpaprMachineState *spapr)
      * checking that it's enabled.
      */
     if (spapr->use_hotplug_event_source) {
-        int hp_irq = SPAPR_IRQ_HOTPLUG;
-
-        if (SPAPR_MACHINE_GET_CLASS(spapr)->legacy_irq_allocation) {
-            hp_irq = spapr_irq_findone(spapr, &error_fatal);
-        }
-
-        spapr_irq_claim(spapr, hp_irq, false, &error_fatal);
+        spapr_irq_claim(spapr, SPAPR_IRQ_HOTPLUG, false, &error_fatal);
 
         spapr_event_sources_register(spapr->event_sources, EVENT_CLASS_HOT_PLUG,
-                                     hp_irq);
+                                     SPAPR_IRQ_HOTPLUG);
     }
 
     spapr->epow_notifier.notify = spapr_powerdown_req;
diff --git a/hw/ppc/spapr_irq.c b/hw/ppc/spapr_irq.c
index 363bfc00db4..14e47acc65b 100644
--- a/hw/ppc/spapr_irq.c
+++ b/hw/ppc/spapr_irq.c
@@ -33,11 +33,6 @@ static const TypeInfo spapr_intc_info = {
 
 static void spapr_irq_msi_init(SpaprMachineState *spapr)
 {
-    if (SPAPR_MACHINE_GET_CLASS(spapr)->legacy_irq_allocation) {
-        /* Legacy mode doesn't use this allocator */
-        return;
-    }
-
     spapr->irq_map_nr = spapr_irq_nr_msis(spapr);
     spapr->irq_map = bitmap_new(spapr->irq_map_nr);
 }
@@ -286,11 +281,7 @@ uint32_t spapr_irq_nr_msis(SpaprMachineState *spapr)
 {
     SpaprMachineClass *smc = SPAPR_MACHINE_GET_CLASS(spapr);
 
-    if (smc->legacy_irq_allocation) {
-        return smc->nr_xirqs;
-    } else {
-        return SPAPR_XIRQ_BASE + smc->nr_xirqs - SPAPR_IRQ_MSI;
-    }
+    return smc->nr_xirqs + SPAPR_XIRQ_BASE - SPAPR_IRQ_MSI;
 }
 
 void spapr_irq_init(SpaprMachineState *spapr, Error **errp)
diff --git a/hw/ppc/spapr_pci.c b/hw/ppc/spapr_pci.c
index f9095552e86..bdec8f0728d 100644
--- a/hw/ppc/spapr_pci.c
+++ b/hw/ppc/spapr_pci.c
@@ -268,7 +268,6 @@ static void rtas_ibm_change_msi(PowerPCCPU *cpu, SpaprMachineState *spapr,
                                 target_ulong args, uint32_t nret,
                                 target_ulong rets)
 {
-    SpaprMachineClass *smc = SPAPR_MACHINE_GET_CLASS(spapr);
     uint32_t config_addr = rtas_ld(args, 0);
     uint64_t buid = rtas_ldq(args, 1);
     unsigned int func = rtas_ld(args, 3);
@@ -373,13 +372,8 @@ static void rtas_ibm_change_msi(PowerPCCPU *cpu, SpaprMachineState *spapr,
     }
 
     /* Allocate MSIs */
-    if (smc->legacy_irq_allocation) {
-        irq = spapr_irq_find(spapr, req_num, ret_intr_type == RTAS_TYPE_MSI,
-                             &err);
-    } else {
-        irq = spapr_irq_msi_alloc(spapr, req_num,
-                                  ret_intr_type == RTAS_TYPE_MSI, &err);
-    }
+    irq = spapr_irq_msi_alloc(spapr, req_num,
+                              ret_intr_type == RTAS_TYPE_MSI, &err);
     if (err) {
         error_reportf_err(err, "Can't allocate MSIs for device %x: ",
                           config_addr);
@@ -393,9 +387,7 @@ static void rtas_ibm_change_msi(PowerPCCPU *cpu, SpaprMachineState *spapr,
             if (i) {
                 spapr_irq_free(spapr, irq, i);
             }
-            if (!smc->legacy_irq_allocation) {
-                spapr_irq_msi_free(spapr, irq, req_num);
-            }
+            spapr_irq_msi_free(spapr, irq, req_num);
             error_reportf_err(err, "Can't allocate MSIs for device %x: ",
                               config_addr);
             rtas_st(rets, 0, RTAS_OUT_HW_ERROR);
@@ -1789,12 +1781,9 @@ static void spapr_phb_unrealize(DeviceState *dev)
 static void spapr_phb_destroy_msi(gpointer opaque)
 {
     SpaprMachineState *spapr = SPAPR_MACHINE(qdev_get_machine());
-    SpaprMachineClass *smc = SPAPR_MACHINE_GET_CLASS(spapr);
     SpaprPciMsi *msi = opaque;
 
-    if (!smc->legacy_irq_allocation) {
-        spapr_irq_msi_free(spapr, msi->first_irq, msi->num);
-    }
+    spapr_irq_msi_free(spapr, msi->first_irq, msi->num);
     spapr_irq_free(spapr, msi->first_irq, msi->num);
     g_free(msi);
 }
@@ -1808,7 +1797,6 @@ static void spapr_phb_realize(DeviceState *dev, Error **errp)
     SpaprMachineState *spapr =
         (SpaprMachineState *) object_dynamic_cast(qdev_get_machine(),
                                                   TYPE_SPAPR_MACHINE);
-    SpaprMachineClass *smc = spapr ? SPAPR_MACHINE_GET_CLASS(spapr) : NULL;
     SysBusDevice *sbd = SYS_BUS_DEVICE(dev);
     SpaprPhbState *sphb = SPAPR_PCI_HOST_BRIDGE(sbd);
     PCIHostState *phb = PCI_HOST_BRIDGE(sbd);
@@ -1956,18 +1944,6 @@ static void spapr_phb_realize(DeviceState *dev, Error **errp)
     for (i = 0; i < PCI_NUM_PINS; i++) {
         int irq = SPAPR_IRQ_PCI_LSI + sphb->index * PCI_NUM_PINS + i;
 
-        if (smc->legacy_irq_allocation) {
-            irq = spapr_irq_findone(spapr, errp);
-            if (irq < 0) {
-                error_prepend(errp, "can't allocate LSIs: ");
-                /*
-                 * Older machines will never support PHB hotplug, ie, this is an
-                 * init only path and QEMU will terminate. No need to rollback.
-                 */
-                return;
-            }
-        }
-
         if (spapr_irq_claim(spapr, irq, true, errp) < 0) {
             error_prepend(errp, "can't allocate LSIs: ");
             goto unrealize;
diff --git a/hw/ppc/spapr_vio.c b/hw/ppc/spapr_vio.c
index 7759436a4f5..c21a2a3274e 100644
--- a/hw/ppc/spapr_vio.c
+++ b/hw/ppc/spapr_vio.c
@@ -507,15 +507,6 @@ static void spapr_vio_busdev_realize(DeviceState *qdev, Error **errp)
 
     dev->irq = spapr_vio_reg_to_irq(dev->reg);
 
-    if (SPAPR_MACHINE_GET_CLASS(spapr)->legacy_irq_allocation) {
-        int irq = spapr_irq_findone(spapr, errp);
-
-        if (irq < 0) {
-            return;
-        }
-        dev->irq = irq;
-    }
-
     if (spapr_irq_claim(spapr, dev->irq, false, errp) < 0) {
         return;
     }
-- 
2.51.0


