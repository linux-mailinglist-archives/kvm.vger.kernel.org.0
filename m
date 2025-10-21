Return-Path: <kvm+bounces-60640-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A1611BF5535
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 10:44:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B53FB427BCD
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 08:44:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CA893164AF;
	Tue, 21 Oct 2025 08:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="HNarEEo1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86F8831DDB9
	for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 08:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761036241; cv=none; b=qwvjucHNVj33sCLFa9BAKOI79Hd/bpd8Hr3D9x7SUK0Xg+Yn2dtoVZYz0DXjNS6n/UINYOxtQhelXTvz1afWBlvlTnKdm9RBtlsinhfeEgcT9lRvzwvgJN09GeG6g3V5DO3DKUxecUFKX5ZrEMQy7PHsIeRJwYxdj3oC+UQRSAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761036241; c=relaxed/simple;
	bh=1lMMcSsQ7bWculwhfF/rWtOAyX62g8QAFIE2iFrE97E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Jb5SE5ockxQ4UlPVrUyng2ccyJGvJjWPxoXmga/v9+0m3skR1pKLY3F27BGhRICbta3AgjkI1UhXFZJgNuCu1onH9zg4eu6s2HgJwlmXHBCK4Gj7ytvGyUTATNDbopbpBDg/QDWcWckbfHT2OtzRacbGT075if4ImKhAREXyJqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=HNarEEo1; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-3f0ae439b56so3947071f8f.3
        for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 01:43:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1761036238; x=1761641038; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0M4ai3rHfvY9hawDUvi5q45cAeCDeC3osatMpD7h84s=;
        b=HNarEEo1DiCPiHtqmXFwVW74vqngr8l8ADH7uHs50wrUn/BB3GgDFtPllHGMOUrz+P
         7jouczzQ2AjHZ+f1wtx54ID0Q7EnfG1YsDSt9Sw5Cr7GhA62U08dg06co6toiZ9KX/ol
         uF9UCtWi34kCyG0clRIzqSziQe9GZxXqao5EqJbBye+T+aYfEs6jsTNTIJ5GKMP1CW8C
         sFBZuN3sH26+DFFy4VYdpG2DF4s94RJGMU9ApJ2dk4jx9fPOZYVVcXMuR6MdO+zkuGXk
         4OeR4gvfu6dZZ274gAbSNmr0zD9bZr5U42tNppKas59Jz16rD1NgzbmndLH5Pd1Ow4NQ
         aH9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761036238; x=1761641038;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0M4ai3rHfvY9hawDUvi5q45cAeCDeC3osatMpD7h84s=;
        b=BsOVsFOycM70AUI55NrNOeVz3onc9l2bBZV3v+xN+Y/f7TeaI9b0sNcNQ33Mw8Z35Y
         Gxod62Q+qSjwoBHaKJ0rPKXdKT2bhOUyun8+MQSH0j6/ztJHT9hxfnkAUDgOuxQb92Cz
         dUVucNRYvcODlxxn3y860mnjcy2kg14RPNxx5VfA5lb8lE/eF2jzJkLM8EUM5zsH8Kys
         iJiQAj7BvYnR8gA/7HJqZRZVflZ7n/wZEVkhhArJH89m1tetGYS/EHA1SpEICG6NBuw+
         rHZQxfBYOcN0oZSRsZj4UL4ajNSL2V4bHAZeTyLdy16yUqM9vSUzGp8l5DYUeiK5JdT2
         ADzw==
X-Forwarded-Encrypted: i=1; AJvYcCVZWTcdgb/j92CcIk0mOnaQvAzLjdlpmcTSUe4hyyToCl/6lYswTl9/4pSEtDGSoLVnLTI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxPxWaDkQO58WYMkPHtyOR1xh4718AYYXYXsp+lza4GYHiJnwY+
	S5lXIWb9NpTAxlR3dsNtXBTGNNQh5qzJh2/6fGED03WCleCpjoxcFBMSou782JzKmr4=
X-Gm-Gg: ASbGncvsbT8dD8yT4qvZqxgQ95xIF3IRe0AkP1yeucN6yyUnJdqPH5KNlcg4ykxcFMm
	vBiTM3zpTP8G9H2VNXp89lrrvasVDFRHRYhlrDF3Abqzk4tXIxGEPve6oloKJXvoVoLk5TAdJDT
	SCFXXumQrdnRRSXOnMzfng8mWvUE8q6hhnYQ0EkHQuUEW2S2cKVVdazvR4o4nS7wwlrJBHVx0tY
	tchnoyUXqO9IU3I3TeWofRR5pgVgbusyHDkt3/Eh0uDjV5mNQQA1wS3PoFm9EfAoOUZEytN8v3z
	mGMzI4CUElMqvc4F438v8o+zwzv0cx3ulyQG4jE/XJLTq5FuqQPit/42OXAIR21yQ11VpCIe4iN
	REcWPr62xf42Lh8ffWLslf3eWF4lxnjCc+ZMX2ay1fEODM7KLiEJSiy5pIORXuwSX6pYLNKrxlt
	OQkjXxPC+I+rM94kB3m4huTkC7zKTPuLiXxf5ckAuJrWRId7hz9t2cqRAvjmmO
X-Google-Smtp-Source: AGHT+IF8DS0Pay/oC0pJ1fYSBffefIYbS8RO4hSfwedEHxc9anqZvGqetbuBUGSMzHhFnNO4Qmql8Q==
X-Received: by 2002:a05:6000:2082:b0:425:7e40:1e02 with SMTP id ffacd0b85a97d-42704d49a0amr9499699f8f.7.1761036237724;
        Tue, 21 Oct 2025 01:43:57 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-427ea5a0f7dsm18932120f8f.4.2025.10.21.01.43.56
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 21 Oct 2025 01:43:57 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Chinmay Rath <rathc@linux.ibm.com>,
	qemu-ppc@nongnu.org,
	Nicholas Piggin <npiggin@gmail.com>,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v2 02/11] hw/ppc/spapr: Remove SpaprMachineClass::nr_xirqs field
Date: Tue, 21 Oct 2025 10:43:36 +0200
Message-ID: <20251021084346.73671-3-philmd@linaro.org>
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
index 317d57a3802..2ce323457be 100644
--- a/hw/ppc/spapr_irq.c
+++ b/hw/ppc/spapr_irq.c
@@ -279,15 +279,11 @@ void spapr_irq_dt(SpaprMachineState *spapr, uint32_t nr_servers,
 
 uint32_t spapr_irq_nr_msis(SpaprMachineState *spapr)
 {
-    SpaprMachineClass *smc = SPAPR_MACHINE_GET_CLASS(spapr);
-
-    return SPAPR_XIRQ_BASE + smc->nr_xirqs - SPAPR_IRQ_MSI;
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


