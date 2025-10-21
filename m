Return-Path: <kvm+bounces-60641-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 57EC6BF553E
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 10:44:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CFB9E461E7C
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 08:44:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D97B31E0FE;
	Tue, 21 Oct 2025 08:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="l69F/rJs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5768231A042
	for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 08:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761036246; cv=none; b=urWFiD9sg0Y3scGP3zu9wciCLr8mkeZimGXOMWuuXInZ/l07fPnBvmkRpyG2tPJ77ehTkn7sMWMPKTJPHiR78aaNXzxQJ3YBWJrNmWZRTzsopAiabucQ5qMwP5RtsKS6Ml+v3DV0lQWvSE5R2EcT8iR7nlXKOKrUoVOKKgUiGM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761036246; c=relaxed/simple;
	bh=WFQA12OecectHpWYTpd9/1pjsGPyyO9GbvPWwYHJjvk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZX6Hus8ld/PxMMuPMBEaRPQr+xvAgdIFMy0W2S+kCqiib68NUjiJo1SaiBOBUGhN+UcMxBE4la//aYwsALjUJhnH4cP+fgWl0TPMtjpgWjmjnr4qN831Iz3u1JiCnrldYc5mljUo6AhIm227UMikZaSazrnrp6AlYoBAdWOMUD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=l69F/rJs; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-47112a73785so40127735e9.3
        for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 01:44:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1761036243; x=1761641043; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Wkrg0aZa1WjauUtDHq9tPYBBcjWPVRSRJlbYYy68XEA=;
        b=l69F/rJszdmVTYKNKIrQVVhBxbguCKKyYI9Af0X7eMu0krDCIiKdCH1zONtQhG+vjB
         aol9ISS72cD9yG1o9tlUcLoY9t2GNELqGaCy6HcTXEnEuHun6i9wJlHzIVCd/pRwd6p3
         zGVwzvPKLhv64GbeOPrPd5bDNflen47JaHpaYGVZvvr965bME8avpFM/PSXzjkKy2fQA
         vv7/H5ZNuBKWa1pYHAbvwVlprr1iEMC2L/vJMKwFL8XH2ryZZWBdRV+svJL0E5kyCx0q
         tRTD7qYrvAW5Bz8CCn/69zquf6JOqxYrKluP0ihfd+2b91DG/AlK8QEOgMyhI8VyAAVa
         wswA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761036243; x=1761641043;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Wkrg0aZa1WjauUtDHq9tPYBBcjWPVRSRJlbYYy68XEA=;
        b=W9jMUAIdC6xvHEcIB85OfPo7kwSkDUGmzqq02ngh83HeCu0V6sWSUkXWDQWLLU+l5C
         KL7BvXLlXF1AERFiwkfWxmGU8M+aHErmCfFS21LCj20ArXv/w5wO14SfTtIC+7jp2jV8
         Ct1dvqJqBpboWquiu43vtl2zs/o4zGGjpyuDI4GTwB1vQHmy7Jf1e8rZqjFiozfI32UQ
         ejW7jBdFTLgqaLsV6cWsK8tWJffMd3fR3FL7BvG4jXlwAWcsrpY8XddVp/qllFPcttYL
         slQskrhfOCGBPpXH6k10Z8mos5NwkTm57CbTCc1jowkDpwjpiNg3G7sAiCBGghtDYhNL
         fY8Q==
X-Forwarded-Encrypted: i=1; AJvYcCViJuQRiGdDUVY7tMfwiuTluMJaYbivsyUXe3LqdgWIgm5Iq2y3YzGGpfHlMkIMQ7C0L2Y=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzznukbz3bT4n7wWmP6hoN4VzURPsVgb2FR8RigRFV0gaGUPzqV
	LGYrdvq99NsMoe2LPQraC2dxOERs6kdUkAYJ32qHyWFuFCXG7jHntOkfC0dJWULzax4=
X-Gm-Gg: ASbGncuVOTsTyV05tbVQJl521dmr6p3f0A60y9RAzkxhtBVJ79S1+joU4X/u0NSw48S
	1i3xUsllhC/E4lslza2ggudAAyi+Z4Z6eFdspoNYd5UFqEmddVxgoQRH+sRpJRkKu05yhf+DTyO
	CmgE+9BaLn24M6aS7lk8yF76TKDXyjcNI3WlM03DANVw/6/oY1q9C9bTgEouGdwV6qAM5I9jaNU
	nm079zJlbLwYY3Xu1lBTYn+QLSeKHEBQVlx2ZKfmhcRf4HEu8LlQtNRTd+xgy+Cvf0pRWus157Z
	+OAkJKdUXGK46xZbuom3K7cpcxs8JaYH27zdl4Tit/VeUr4J97ompp0CEAedX6EkgOoRKu6bVFL
	l3mCxueSsaeeR7tccAecR74UYNCM6A7azEx05Ca506l55KKlPPZt1jZsv95E+ndBGOEyhEj6VId
	oWIX7/3no8RBlDHYcaYO7LE6MKU1e+6REEv+dwxeZOW6zQt6YryHqk1r1z9b6W
X-Google-Smtp-Source: AGHT+IFirZECNQbu8fTMpQHw/i7BErvqCsfDdrQA40bf/Y4sMvLQvdzRegS8xxtTQnqeKY56pJvjEg==
X-Received: by 2002:a05:600c:4f95:b0:46e:345d:dfde with SMTP id 5b1f17b1804b1-471178ac017mr105182205e9.16.1761036242592;
        Tue, 21 Oct 2025 01:44:02 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4715520dd65sm181550785e9.15.2025.10.21.01.44.01
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 21 Oct 2025 01:44:02 -0700 (PDT)
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
Subject: [PATCH v2 03/11] ppc/spapr: remove deprecated machine pseries-3.1
Date: Tue, 21 Oct 2025 10:43:37 +0200
Message-ID: <20251021084346.73671-4-philmd@linaro.org>
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

pseries-3.1 had been deprecated and due for removal now as per policy.
Also remove backward compatibility flags and related code introduced for
pre pseries-4.0 machines.

Suggested-by: Cédric Le Goater <clg@kaod.org>
Signed-off-by: Harsh Prateek Bora <harshpb@linux.ibm.com>
Reviewed-by: Cédric Le Goater <clg@redhat.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/hw/ppc/spapr.h |  3 --
 hw/ppc/spapr.c         | 62 ++++--------------------------------------
 hw/ppc/spapr_hcall.c   |  5 ----
 3 files changed, 5 insertions(+), 65 deletions(-)

diff --git a/include/hw/ppc/spapr.h b/include/hw/ppc/spapr.h
index 494367fb99a..1db67784de8 100644
--- a/include/hw/ppc/spapr.h
+++ b/include/hw/ppc/spapr.h
@@ -143,9 +143,6 @@ struct SpaprMachineClass {
     MachineClass parent_class;
 
     /*< public >*/
-    bool dr_phb_enabled;       /* enable dynamic-reconfig/hotplug of PHBs */
-    bool update_dt_enabled;    /* enable KVMPPC_H_UPDATE_DT */
-    bool broken_host_serial_model; /* present real host info to the guest */
     bool pre_4_1_migration; /* don't migrate hpt-max-page-size */
     bool linux_pci_probe;
     bool smp_threads_vsmt; /* set VSMT to smp_threads by default */
diff --git a/hw/ppc/spapr.c b/hw/ppc/spapr.c
index b5d20bc1756..458d1c29b4d 100644
--- a/hw/ppc/spapr.c
+++ b/hw/ppc/spapr.c
@@ -1182,7 +1182,6 @@ void *spapr_build_fdt(SpaprMachineState *spapr, bool reset, size_t space)
 {
     MachineState *machine = MACHINE(spapr);
     MachineClass *mc = MACHINE_GET_CLASS(machine);
-    SpaprMachineClass *smc = SPAPR_MACHINE_GET_CLASS(machine);
     uint32_t root_drc_type_mask = 0;
     int ret;
     void *fdt;
@@ -1213,16 +1212,10 @@ void *spapr_build_fdt(SpaprMachineState *spapr, bool reset, size_t space)
     /* Host Model & Serial Number */
     if (spapr->host_model) {
         _FDT(fdt_setprop_string(fdt, 0, "host-model", spapr->host_model));
-    } else if (smc->broken_host_serial_model && kvmppc_get_host_model(&buf)) {
-        _FDT(fdt_setprop_string(fdt, 0, "host-model", buf));
-        g_free(buf);
     }
 
     if (spapr->host_serial) {
         _FDT(fdt_setprop_string(fdt, 0, "host-serial", spapr->host_serial));
-    } else if (smc->broken_host_serial_model && kvmppc_get_host_serial(&buf)) {
-        _FDT(fdt_setprop_string(fdt, 0, "host-serial", buf));
-        g_free(buf);
     }
 
     _FDT(fdt_setprop_cell(fdt, 0, "#address-cells", 2));
@@ -1260,9 +1253,8 @@ void *spapr_build_fdt(SpaprMachineState *spapr, bool reset, size_t space)
 
     /* ibm,drc-indexes and friends */
     root_drc_type_mask |= SPAPR_DR_CONNECTOR_TYPE_LMB;
-    if (smc->dr_phb_enabled) {
-        root_drc_type_mask |= SPAPR_DR_CONNECTOR_TYPE_PHB;
-    }
+    root_drc_type_mask |= SPAPR_DR_CONNECTOR_TYPE_PHB;
+
     if (mc->nvdimm_supported) {
         root_drc_type_mask |= SPAPR_DR_CONNECTOR_TYPE_PMEM;
     }
@@ -2063,9 +2055,7 @@ static const VMStateDescription vmstate_spapr_irq_map = {
 
 static bool spapr_dtb_needed(void *opaque)
 {
-    SpaprMachineClass *smc = SPAPR_MACHINE_GET_CLASS(opaque);
-
-    return smc->update_dt_enabled;
+    return true; /* backward migration compat */
 }
 
 static int spapr_dtb_pre_load(void *opaque)
@@ -3009,10 +2999,8 @@ static void spapr_machine_init(MachineState *machine)
      * connectors for a PHBs PCI slots) are added as needed during their
      * parent's realization.
      */
-    if (smc->dr_phb_enabled) {
-        for (i = 0; i < SPAPR_MAX_PHBS; i++) {
-            spapr_dr_connector_new(OBJECT(machine), TYPE_SPAPR_DRC_PHB, i);
-        }
+    for (i = 0; i < SPAPR_MAX_PHBS; i++) {
+        spapr_dr_connector_new(OBJECT(machine), TYPE_SPAPR_DRC_PHB, i);
     }
 
     /* Set up PCI */
@@ -4095,11 +4083,6 @@ static bool spapr_phb_pre_plug(HotplugHandler *hotplug_dev, DeviceState *dev,
     const unsigned windows_supported = spapr_phb_windows_supported(sphb);
     SpaprDrc *drc;
 
-    if (dev->hotplugged && !smc->dr_phb_enabled) {
-        error_setg(errp, "PHB hotplug not supported for this machine");
-        return false;
-    }
-
     if (sphb->index == (uint32_t)-1) {
         error_setg(errp, "\"index\" for PAPR PHB is mandatory");
         return false;
@@ -4125,16 +4108,10 @@ static bool spapr_phb_pre_plug(HotplugHandler *hotplug_dev, DeviceState *dev,
 
 static void spapr_phb_plug(HotplugHandler *hotplug_dev, DeviceState *dev)
 {
-    SpaprMachineState *spapr = SPAPR_MACHINE(OBJECT(hotplug_dev));
-    SpaprMachineClass *smc = SPAPR_MACHINE_GET_CLASS(spapr);
     SpaprPhbState *sphb = SPAPR_PCI_HOST_BRIDGE(dev);
     SpaprDrc *drc;
     bool hotplugged = spapr_drc_hotplugged(dev);
 
-    if (!smc->dr_phb_enabled) {
-        return;
-    }
-
     drc = spapr_drc_by_id(TYPE_SPAPR_DRC_PHB, sphb->index);
     /* hotplug hooks should check it's enabled before getting this far */
     assert(drc);
@@ -4260,7 +4237,6 @@ static void spapr_machine_device_unplug_request(HotplugHandler *hotplug_dev,
 {
     SpaprMachineState *sms = SPAPR_MACHINE(OBJECT(hotplug_dev));
     MachineClass *mc = MACHINE_GET_CLASS(sms);
-    SpaprMachineClass *smc = SPAPR_MACHINE_CLASS(mc);
 
     if (object_dynamic_cast(OBJECT(dev), TYPE_PC_DIMM)) {
         if (spapr_memory_hot_unplug_supported(sms)) {
@@ -4275,10 +4251,6 @@ static void spapr_machine_device_unplug_request(HotplugHandler *hotplug_dev,
         }
         spapr_core_unplug_request(hotplug_dev, dev, errp);
     } else if (object_dynamic_cast(OBJECT(dev), TYPE_SPAPR_PCI_HOST_BRIDGE)) {
-        if (!smc->dr_phb_enabled) {
-            error_setg(errp, "PHB hot unplug not supported on this machine");
-            return;
-        }
         spapr_phb_unplug_request(hotplug_dev, dev, errp);
     } else if (object_dynamic_cast(OBJECT(dev), TYPE_SPAPR_TPM_PROXY)) {
         spapr_tpm_proxy_unplug(hotplug_dev, dev);
@@ -4634,7 +4606,6 @@ static void spapr_machine_class_init(ObjectClass *oc, const void *data)
     hc->unplug_request = spapr_machine_device_unplug_request;
     hc->unplug = spapr_machine_device_unplug;
 
-    smc->update_dt_enabled = true;
     mc->default_cpu_type = POWERPC_CPU_TYPE_NAME("power10_v2.0");
     mc->has_hotpluggable_cpus = true;
     mc->nvdimm_supported = true;
@@ -4688,7 +4659,6 @@ static void spapr_machine_class_init(ObjectClass *oc, const void *data)
     smc->default_caps.caps[SPAPR_CAP_AIL_MODE_3] = SPAPR_CAP_ON;
     spapr_caps_add_properties(smc);
     smc->irq = &spapr_irq_dual;
-    smc->dr_phb_enabled = true;
     smc->linux_pci_probe = true;
     smc->smp_threads_vsmt = true;
     xfc->match_nvt = spapr_match_nvt;
@@ -5032,28 +5002,6 @@ static void spapr_machine_4_0_class_options(MachineClass *mc)
 
 DEFINE_SPAPR_MACHINE(4, 0);
 
-/*
- * pseries-3.1
- */
-static void spapr_machine_3_1_class_options(MachineClass *mc)
-{
-    SpaprMachineClass *smc = SPAPR_MACHINE_CLASS(mc);
-
-    spapr_machine_4_0_class_options(mc);
-    compat_props_add(mc->compat_props, hw_compat_3_1, hw_compat_3_1_len);
-
-    mc->default_cpu_type = POWERPC_CPU_TYPE_NAME("power8_v2.0");
-    smc->update_dt_enabled = false;
-    smc->dr_phb_enabled = false;
-    smc->broken_host_serial_model = true;
-    smc->default_caps.caps[SPAPR_CAP_CFPC] = SPAPR_CAP_BROKEN;
-    smc->default_caps.caps[SPAPR_CAP_SBBC] = SPAPR_CAP_BROKEN;
-    smc->default_caps.caps[SPAPR_CAP_IBS] = SPAPR_CAP_BROKEN;
-    smc->default_caps.caps[SPAPR_CAP_LARGE_DECREMENTER] = SPAPR_CAP_OFF;
-}
-
-DEFINE_SPAPR_MACHINE(3, 1);
-
 static void spapr_machine_register_types(void)
 {
     type_register_static(&spapr_machine_info);
diff --git a/hw/ppc/spapr_hcall.c b/hw/ppc/spapr_hcall.c
index 8c1e0a4817b..8f03b3e7764 100644
--- a/hw/ppc/spapr_hcall.c
+++ b/hw/ppc/spapr_hcall.c
@@ -1475,16 +1475,11 @@ static target_ulong h_update_dt(PowerPCCPU *cpu, SpaprMachineState *spapr,
     target_ulong dt = ppc64_phys_to_real(args[0]);
     struct fdt_header hdr = { 0 };
     unsigned cb;
-    SpaprMachineClass *smc = SPAPR_MACHINE_GET_CLASS(spapr);
     void *fdt;
 
     cpu_physical_memory_read(dt, &hdr, sizeof(hdr));
     cb = fdt32_to_cpu(hdr.totalsize);
 
-    if (!smc->update_dt_enabled) {
-        return H_SUCCESS;
-    }
-
     /* Check that the fdt did not grow out of proportion */
     if (cb > spapr->fdt_initial_size * 2) {
         trace_spapr_update_dt_failed_size(spapr->fdt_initial_size, cb,
-- 
2.51.0


