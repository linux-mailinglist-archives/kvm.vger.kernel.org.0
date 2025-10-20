Return-Path: <kvm+bounces-60505-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 953C4BF0A2F
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 12:44:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DE19B3E699D
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 10:41:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E24302F83AF;
	Mon, 20 Oct 2025 10:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="i7FBd0Ce"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3889C2F83A5
	for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 10:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760956750; cv=none; b=RutweymypdRXR+Xnw2SiTW8bARrVBfWnrWIe9NN0dmL6BVXJvshL08yJF4g/8gc6s/OcPlNQeeiDm9E3M2nKpu/vXDmIH4RDxgxej8LWy2RiGsneFOXkH4zDvKhHaFQLzd9cMgi4MoB+oJgmKGLA3JkXcyqy1XFr8OEwqepObkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760956750; c=relaxed/simple;
	bh=lPi0dg1Faqeyw+l/sbcnlVTegeu/vUl9KdCx4XkTEVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TFfQlWCE/YQlS1KtYGgAVf3xXLDlGV2PBaGNpn0PMcHnjVvAdffL5+SvgxegaebI0wrnwBp38t78t27VOxZzQ87U48wHvTg4NmixG+5reM/LA/ViupGCYueEFFvUGXt/wMofOGW+YXX+/944GbmdhcNdF3vBZIuCz6WJKDYyDDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=i7FBd0Ce; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-421851bcb25so2436370f8f.2
        for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 03:39:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1760956746; x=1761561546; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G71RzqW1rRM1q68VyBiXz7BShoBGdhsR1BgR0TIYzSw=;
        b=i7FBd0Ce7tWlbfWdl1bgFJP4sEO6KBqxr+b90RWTX0sTaIsyyn7cB84xqjKknlF7Qv
         gXaTaA7QIqzYTlPLuircHYUpbw/CpWWWQ/ltTSPbro0JJuh40+l18fNGiaR2gcSRkWzw
         g/2HlPO8WgTaxSsiMA+CBONH478/hswI/azsW5wmwdLpB+C3vwfZtfIRqlnEdzhvRvhm
         mqIZdTuA4w58tbeVMgr6tQf82v5QxT/jnIn6dPc0kAwvUIhDTF/Wm84jZIgWRHYJjgeN
         D++hanpDQU3y4+amTDO4Dyz5F8sC858BEp5lGJvR55+X86vmZcLWjz0FbIC55QB/zTU4
         v4+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760956746; x=1761561546;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G71RzqW1rRM1q68VyBiXz7BShoBGdhsR1BgR0TIYzSw=;
        b=w0OQ8HmtZr4bR5Gnd1x3agQjrEi1puu+ctHMD9rIkEN5CH4251Obdda9/LciXHwtAB
         WeOXGOXcYS4nep5sbVHLms3KLa2c6Zkzv3kMFL3AicrypgJ+/2/l+/U++xv7TY5Hav3J
         rfUTfbGpdmkR4vVBJ6JyFDm3eq/cRbtrwVG9kMiMBisy9lTrn39+vM1F931cLFAx/wUZ
         SrcIwMhY4kof6s5q2BXWI4dgoXsl/BnmXlDEijyeNpnNJrv1oJVIsbwQ08HdgZi5CKEj
         06cCSUuNJC3Ncja6XVaGcpwofGIS+PXKZifdbYr7hftuZy7FoGaZhO0Vo4W6PM3zVTPp
         jS/A==
X-Forwarded-Encrypted: i=1; AJvYcCWEnJ9GNmtzwCANHNGgneGlNvYiYps86PAHK5G5WFxRDW8jtogtPzuWL5OINeefmgqt10k=@vger.kernel.org
X-Gm-Message-State: AOJu0YxpfVX4rHk/tpkOOziHYVsN62N68A6ohJqIRHkY3JtMkFl4yDCq
	sG99Wu64oLjWZTqfaPYcfnHe1MJ37rZxSN9B/qjZCL2iG7dRyaIGU2OUR4R+orcCqU0=
X-Gm-Gg: ASbGncsm1E+qlYG1r/SAk6C9Mo/bBFrKu/g+wZCyI0t7ZG9xqadNbDy8CNieaSc3l7u
	k7DiMPW2+Uo6Amqoe9E6jqrudHgpqMKzvlTQfbImJiilAImUgvGGMWtMInEOhaUa3Q9axHmtasR
	ADz1Tnfbv3WJOrc5Ev3Ga0vTKsdy3LaPr5zEjblSlLkDssKSEHN3HB4CK72RjjpGYYXD7JQn4wg
	Jls2KCk+36Wt4Q24iNa0CaRqwhKmnMuyynVpz91+RiLvp/PMAWTS1pJAlm+5q7/m0E3ewGQ2q0O
	OqHMwCYWRL9d8Tf2Y2ZFRcjjADIt7uDaWxyIhzzFXWSNXyo77Zab0hHOQ/QMMP83Rrvenbg0MoU
	gGvzqTmrqsbYbKVWSlWQ86fB+/anw1gpc9qTscRJDTTZXDztJm7gNIGjieoLySDixzZsqlXwjNm
	eyVo0yw7ClP01BwY//11JxlvXoXR4mfNPws0ocbHdIHOeEDtpVrO+Ouj5MxUL2yxSm6QfCaGc=
X-Google-Smtp-Source: AGHT+IEA6OS/cJN8d7ANvIfUdQD0HaQc+Ga96+ciiQUpkqRgsXl2JRuNNPFZgrzIZpTMTtzjZnOK/A==
X-Received: by 2002:a05:6000:18a8:b0:427:7f5:2b8 with SMTP id ffacd0b85a97d-42707f50382mr6302454f8f.43.1760956746374;
        Mon, 20 Oct 2025 03:39:06 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-471144239bdsm270295285e9.3.2025.10.20.03.39.05
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 20 Oct 2025 03:39:05 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	qemu-ppc@nongnu.org,
	kvm@vger.kernel.org,
	Chinmay Rath <rathc@linux.ibm.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH 10/18] hw/ppc/spapr: Remove SpaprMachineClass::update_dt_enabled field
Date: Mon, 20 Oct 2025 12:38:06 +0200
Message-ID: <20251020103815.78415-11-philmd@linaro.org>
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

The SpaprMachineClass::update_dt_enabled field was only used by the
pseries-3.1 machine, which got removed. Remove it as now unused.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/hw/ppc/spapr.h | 1 -
 hw/ppc/spapr.c         | 9 ---------
 hw/ppc/spapr_hcall.c   | 5 -----
 3 files changed, 15 deletions(-)

diff --git a/include/hw/ppc/spapr.h b/include/hw/ppc/spapr.h
index bc75e29084b..1db67784de8 100644
--- a/include/hw/ppc/spapr.h
+++ b/include/hw/ppc/spapr.h
@@ -143,7 +143,6 @@ struct SpaprMachineClass {
     MachineClass parent_class;
 
     /*< public >*/
-    bool update_dt_enabled;    /* enable KVMPPC_H_UPDATE_DT */
     bool pre_4_1_migration; /* don't migrate hpt-max-page-size */
     bool linux_pci_probe;
     bool smp_threads_vsmt; /* set VSMT to smp_threads by default */
diff --git a/hw/ppc/spapr.c b/hw/ppc/spapr.c
index b81eb7ffe73..feb1e78b7c0 100644
--- a/hw/ppc/spapr.c
+++ b/hw/ppc/spapr.c
@@ -2052,13 +2052,6 @@ static const VMStateDescription vmstate_spapr_irq_map = {
     },
 };
 
-static bool spapr_dtb_needed(void *opaque)
-{
-    SpaprMachineClass *smc = SPAPR_MACHINE_GET_CLASS(opaque);
-
-    return smc->update_dt_enabled;
-}
-
 static int spapr_dtb_pre_load(void *opaque)
 {
     SpaprMachineState *spapr = (SpaprMachineState *)opaque;
@@ -2074,7 +2067,6 @@ static const VMStateDescription vmstate_spapr_dtb = {
     .name = "spapr_dtb",
     .version_id = 1,
     .minimum_version_id = 1,
-    .needed = spapr_dtb_needed,
     .pre_load = spapr_dtb_pre_load,
     .fields = (const VMStateField[]) {
         VMSTATE_UINT32(fdt_initial_size, SpaprMachineState),
@@ -4607,7 +4599,6 @@ static void spapr_machine_class_init(ObjectClass *oc, const void *data)
     hc->unplug_request = spapr_machine_device_unplug_request;
     hc->unplug = spapr_machine_device_unplug;
 
-    smc->update_dt_enabled = true;
     mc->default_cpu_type = POWERPC_CPU_TYPE_NAME("power10_v2.0");
     mc->has_hotpluggable_cpus = true;
     mc->nvdimm_supported = true;
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


