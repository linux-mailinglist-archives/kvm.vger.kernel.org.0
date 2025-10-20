Return-Path: <kvm+bounces-60504-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 41D87BF09D2
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 12:41:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 183071899D42
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 10:41:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 163062FB609;
	Mon, 20 Oct 2025 10:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="x89lFk+s"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 502562FB092
	for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 10:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760956745; cv=none; b=lcPgyADIr0llMIInDobHjjQ/zop3c/D7oFXNPMDyU3RUVb1n9ffhPlRfHoHeZVCo2WyPXWV5S4yC8D9/UmnEZTt0jTI21WsdlByMwJ+WOGLz1WEebGm44addImU4WKNsguoLaBVgFMEPzgb1KGQc3PBt8KjLk/S1a1+nQKmSrjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760956745; c=relaxed/simple;
	bh=076bFyz/pFMOFEoj9DqRTvFVUVaYlH8uI7lkonux1Bo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HgwolhURH+RlPTJsSfZCC9mDyA/+eg/2lvV5UN7D/gDYZoLZD6ziesFC9Luq1Gj5R/5isy0QcXIi1ypEDcSJUKLPZqqHF02uak+L2zyFAhxJl6G32/AwJz5zt8aAKeLvYOyz4Lp2/fOTCgIIRZogcwPxXtroVf5CF6Fxo+g/mR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=x89lFk+s; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4711f3c386eso17667845e9.0
        for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 03:39:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1760956741; x=1761561541; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6xuVM3VBVeU3OiQAywkIH3HRIqyaSbIK3vlGaxdyGbI=;
        b=x89lFk+smJFqfei6Mz+9zpeshVt+I8rt1F9tLPLfZEHcaXzA5NawI3HbMJwmjLDIh0
         vVlh+oEXWXi18J2howraWUpF691fqdDCCMqlRjsoJ3itx202iJXHDE42w3sK27V6wRDR
         bLjK19ezd0pPgmzLmhUCsffclfY8Sxw0eLAGS2L/fJbI4QDmfQl0o2iK83dFtlgUQjID
         mBAJANnPouNU6wuQ8hfjmp+AH17nEeiwnzjsRMiPCjJggo+DN1DzOfo8xxeP5xL5sUVd
         iO6Yri9CkyrGUWeM8IIOvv1S466Fh+LwOUzQR1V7UHZOc226zlYzlP6E92xKD5pNfbFg
         9AYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760956741; x=1761561541;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6xuVM3VBVeU3OiQAywkIH3HRIqyaSbIK3vlGaxdyGbI=;
        b=aTQG2D0ILgAnfLnNBwYL2lo86OZutEkwjva7wJfVsLje4Xvs7ls8+QSOD15g5hrC/Z
         xM/JiU4CKSpFrsljvgemX0PJib7tsigOsfMOf91ZPY4n/c2RYRkDHmhe3TPJTQsDWEPp
         OJbwnH9/RAthBmfZ7KlidcWoQXMXG6/WntEhE+zPV2T4ten/62Ye/eUTj1T5Aap4XO4B
         4t4bz40N0y06/7GoQ66akLU0y6srMI3tKv1kFd45KmmhnvOBIvgW4+09pLSdpUQEcQNU
         YsPFMaDWR4Q3KpwY48IWDzoc4pzytVsoQchrd8IxrZNDpRxfqksLgP9TofmpRKOxLc4U
         gsmw==
X-Forwarded-Encrypted: i=1; AJvYcCU4iKy+xiwzmUxPqyz0ZTTxE46ieTaCKqz/vbWR0h+Sc1qNKnGMDpSfTVy+EkAF8qEGj18=@vger.kernel.org
X-Gm-Message-State: AOJu0YyMX2ZBBxAjfFie18muBKmVZO8A18SMWAYejrYotO3mNW7Mg9rC
	9GR/RqdZe/kK5bsQUr8PpXEPZ91V0aoDcd1JVVAmndgutdQPbeQpS1Tt32U0o+PzoDw=
X-Gm-Gg: ASbGncvnNueciHwuRwDgJMJGyl9de7bbusG3xIE0qs/cTrYTPu1RFCzAxVangy1VJqs
	LUkxkxGRiJUWUp+b7pdjc2UEXBGDxsOaDar8jTwQ1cZdznAnvT7lobmq/lNOCDEcvXQeQtOCPZ9
	YzwEHqKHQvgJm99olBDIK/guehs6C+c5AQsfI/6fLxUKSuznQ230Zz3hT4sy6bRnOc5UHsjK/vz
	jXVOdtnHD4Ny+yrLf4q9MCjLZCst6PDW71/LLm8SDIHU9ZOwRXiujWvHzBLOqRTAnWMdVoutadg
	6XIpZrui3o39rdNR6lztkCQ2Je+AtcwuxCwljpkdPTnkEW6KXXBLgMr+qQjCY0h8oXLYl0ihmYv
	rH3OBnabTjmarhLe7SyKUy6JKZrJ8pm43OIM11zbvDRiETnvczl8571ZHXbAsZKSJ5Fkl+FahAI
	rbIglPYfArLDb1B8G/LyppG48/oh2zNEz1lSolTRR5TzOszFkr0xGxoiVViHbl
X-Google-Smtp-Source: AGHT+IGj40Tm0Y+OPmraCNCsy+lwL4gLutxE0a+akPs+fVR+0b8fI4LoEZvRXbYntpUAMFO0RpfcpQ==
X-Received: by 2002:a05:6000:701:b0:427:614:83d9 with SMTP id ffacd0b85a97d-4270614848dmr7984928f8f.48.1760956741485;
        Mon, 20 Oct 2025 03:39:01 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-427f009a781sm15047517f8f.30.2025.10.20.03.39.00
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 20 Oct 2025 03:39:00 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	qemu-ppc@nongnu.org,
	kvm@vger.kernel.org,
	Chinmay Rath <rathc@linux.ibm.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH 09/18] hw/ppc/spapr: Remove SpaprMachineClass::dr_phb_enabled field
Date: Mon, 20 Oct 2025 12:38:05 +0200
Message-ID: <20251020103815.78415-10-philmd@linaro.org>
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

The SpaprMachineClass::dr_phb_enabled field was only used by the
pseries-3.1 machine, which got removed. Remove it as now unused.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/hw/ppc/spapr.h |  1 -
 hw/ppc/spapr.c         | 28 +++-------------------------
 2 files changed, 3 insertions(+), 26 deletions(-)

diff --git a/include/hw/ppc/spapr.h b/include/hw/ppc/spapr.h
index 06e2ad8ffe6..bc75e29084b 100644
--- a/include/hw/ppc/spapr.h
+++ b/include/hw/ppc/spapr.h
@@ -143,7 +143,6 @@ struct SpaprMachineClass {
     MachineClass parent_class;
 
     /*< public >*/
-    bool dr_phb_enabled;       /* enable dynamic-reconfig/hotplug of PHBs */
     bool update_dt_enabled;    /* enable KVMPPC_H_UPDATE_DT */
     bool pre_4_1_migration; /* don't migrate hpt-max-page-size */
     bool linux_pci_probe;
diff --git a/hw/ppc/spapr.c b/hw/ppc/spapr.c
index e06eefa3233..b81eb7ffe73 100644
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
@@ -1254,9 +1253,7 @@ void *spapr_build_fdt(SpaprMachineState *spapr, bool reset, size_t space)
 
     /* ibm,drc-indexes and friends */
     root_drc_type_mask |= SPAPR_DR_CONNECTOR_TYPE_LMB;
-    if (smc->dr_phb_enabled) {
-        root_drc_type_mask |= SPAPR_DR_CONNECTOR_TYPE_PHB;
-    }
+    root_drc_type_mask |= SPAPR_DR_CONNECTOR_TYPE_PHB;
     if (mc->nvdimm_supported) {
         root_drc_type_mask |= SPAPR_DR_CONNECTOR_TYPE_PMEM;
     }
@@ -3003,10 +3000,8 @@ static void spapr_machine_init(MachineState *machine)
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
@@ -4089,11 +4084,6 @@ static bool spapr_phb_pre_plug(HotplugHandler *hotplug_dev, DeviceState *dev,
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
@@ -4119,16 +4109,10 @@ static bool spapr_phb_pre_plug(HotplugHandler *hotplug_dev, DeviceState *dev,
 
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
@@ -4254,7 +4238,6 @@ static void spapr_machine_device_unplug_request(HotplugHandler *hotplug_dev,
 {
     SpaprMachineState *sms = SPAPR_MACHINE(OBJECT(hotplug_dev));
     MachineClass *mc = MACHINE_GET_CLASS(sms);
-    SpaprMachineClass *smc = SPAPR_MACHINE_CLASS(mc);
 
     if (object_dynamic_cast(OBJECT(dev), TYPE_PC_DIMM)) {
         if (spapr_memory_hot_unplug_supported(sms)) {
@@ -4269,10 +4252,6 @@ static void spapr_machine_device_unplug_request(HotplugHandler *hotplug_dev,
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
@@ -4682,7 +4661,6 @@ static void spapr_machine_class_init(ObjectClass *oc, const void *data)
     smc->default_caps.caps[SPAPR_CAP_AIL_MODE_3] = SPAPR_CAP_ON;
     spapr_caps_add_properties(smc);
     smc->irq = &spapr_irq_dual;
-    smc->dr_phb_enabled = true;
     smc->linux_pci_probe = true;
     smc->smp_threads_vsmt = true;
     xfc->match_nvt = spapr_match_nvt;
-- 
2.51.0


