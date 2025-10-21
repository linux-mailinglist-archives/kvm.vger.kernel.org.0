Return-Path: <kvm+bounces-60648-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F2E3ABF555F
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 10:45:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E2EBC3A5518
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 08:44:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74EAA32038D;
	Tue, 21 Oct 2025 08:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ihZpJh7/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B18D731DD98
	for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 08:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761036280; cv=none; b=CVvgaCUBhOx2IuGwcrtIqRXrPKTiN1zwim1/FaXrQkrO31P/dC0Adoqe1sZ8bXxd/KU8F8KDmUD9nyduC+teXd5SLdOQn3N42eauGC85tV33sK2EHuEujtaXbkug80DZU2tMdCAfbBkIV8KVSaItvIU0eiGY8FDQHTEO9fc1a14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761036280; c=relaxed/simple;
	bh=7N/zpyHlAcXpOBR0niVruxmWHTN1Gp0hd5NuorQ6648=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tGRukhhephTEOwDGSoQNhhjQWgYBL7jCJ4xIOfqUwsnD7k6XB/rFMfihFIJJzLtRkkD/4sWn/2SurNzLzQn5h6t4wdgzmnXBXGUblcEM5Axu8u2f0iTHG4q96sn/Y22rT084vuVwvkMelU1k/oRl0m5MzshGFkuiglDZTE/M4vE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ihZpJh7/; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4711810948aso35877335e9.2
        for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 01:44:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1761036277; x=1761641077; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YiNDg4LVvxXZPHJPsAi2okquB/BtvFBYXh1pXELbRqU=;
        b=ihZpJh7/wMPWxNltLF6uT56iiOCfSGI4jRidtLeoZAnQlG5nWaenOjdRwqVkgcDDUT
         sR/cXz3cpW4WeN6evxbt0bbUr85LfM0ZGfSRjRHjVJ0dvvfLEZhOxl87Hv+3Vq+CYw2Z
         dSyOp3NYo16rbicxuBBpYTbkRBBwJvBShVKxoi6nswhkoaGa7ouQRq6am68SkCslU28R
         wEysBB1tS1YPECMzclvAucLgxPzvq6UJ8nmCKKrDn/49/mT1mCuBTKRhslEN7atoe102
         64/Mxd9SXHSU2djZo4xsnNqWYIUu/iavHgX5edSeAUPWloxRORRyVu+jGqvdbUlz9onn
         3WvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761036277; x=1761641077;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YiNDg4LVvxXZPHJPsAi2okquB/BtvFBYXh1pXELbRqU=;
        b=rIKOpGp2WRnFRLBGLo1oG+LTE2Jz2sG2GObV8dJY8IycTuscE7TzHNgmtSLcA5NY5R
         hq3kmEhel5ayQnH0fyz5k1gym/8s0tNMj58WhaBjGoWp5mBBu5OIbYnfZu55WXvyLdvg
         DbbYJVsTOKzO3wWbOlOudsXkQAF7+IWFtZjcCnop6yCnj2hdcpgbgO8b+FwVt2beqtAe
         p3kE0YrkiJ6mDGKUaBtHaObXCwkwnXXlKeCZWc3QGpDQH6aY89udNj4+Wll+3PL0dMbl
         kZHFBDIFoVCNn5xtLbl0dC8E1goxUwhp2qqTucMaKFMf3ymT0YKPRD1n6l8JLHsrWKoC
         MOVQ==
X-Forwarded-Encrypted: i=1; AJvYcCVRFdHuQQj4OxaPtfCwI2cYFDCEwzIx9ffKPLCuFQEFb2FP1fuBTZxBxUvewL2CvPeCTHc=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywh3wrAZ9Pr5AgMd9bgA3zZt4lu2zP7E8OHSUleFDr+D4EZcBeu
	lGgXbMrQXtn783uBzcTGnj2BcK/Ovi+rdjiPMNF40xOUhZs8ccnAsg5oN3p1EyJ9iSW3/qLxwdF
	QRfGKu4I=
X-Gm-Gg: ASbGnctt5un8cpyzy4yeVsvXcDSBIY2NLfMndXnDyaiX77Wb4WEyt3OEZbKCsL001c2
	6T3CgbyqHQBOq5ccZplb3oQOW7ZOU18xOEeqUsm1VBc9VBFtv9swmQKlWscSHToYMHu8bkMVIHC
	JkV/OJgJLWZVU1jlk7L4ybHPle3xh2wIV1AUg02u6C70G80uCtrS069d4SLWsDOKmb+bLvr7cfW
	BPj6er47hVuD4joKkRXooIQKDxCbrQiKyEMD/QP6CA9DwxXDYAN0bqndQb1ALQJ1znhgIEP0lwD
	4cfkbH5tyBqGeBHKyq2ul4AJ8Q8khJYcYvjwwZn7eJamcL1HMYGubYXniLRku9i22z0DC5f1cko
	hDaHPFwwiAzaDaEAROzIKPY1o91D2lpiFsRtlFBxUadBpjc6UgvlBrl5rczpeiJ93Uq+TjLcMqP
	iWiVWP94nTC8a57OoPDMWKBhPiRfmmGSIld8cnmE01eTBnb1L7PQ==
X-Google-Smtp-Source: AGHT+IFhdkGQ+xzP76a1LK0Af58A5E8eJm2BpI+tUG3OCKUOZ2eJKgJRKsDfRIa0WxL1F37pxSSykw==
X-Received: by 2002:a05:600c:828a:b0:46e:39e1:fc3c with SMTP id 5b1f17b1804b1-4711787617amr115466015e9.5.1761036276871;
        Tue, 21 Oct 2025 01:44:36 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-427f00ba070sm19433697f8f.42.2025.10.21.01.44.35
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 21 Oct 2025 01:44:36 -0700 (PDT)
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
Subject: [PATCH v2 10/11] ppc/spapr: remove deprecated machine pseries-4.1
Date: Tue, 21 Oct 2025 10:43:44 +0200
Message-ID: <20251021084346.73671-11-philmd@linaro.org>
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

Remove the pseries-4.1 machine specific logic as had been deprecated and
due for removal now as per policy.

Suggested-by: Cédric Le Goater <clg@kaod.org>
Signed-off-by: Harsh Prateek Bora <harshpb@linux.ibm.com>
Reviewed-by: Cédric Le Goater <clg@redhat.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/hw/ppc/spapr.h |  2 --
 hw/ppc/spapr.c         | 37 +------------------------------------
 2 files changed, 1 insertion(+), 38 deletions(-)

diff --git a/include/hw/ppc/spapr.h b/include/hw/ppc/spapr.h
index bd783e92e15..60d9a8a0377 100644
--- a/include/hw/ppc/spapr.h
+++ b/include/hw/ppc/spapr.h
@@ -141,8 +141,6 @@ struct SpaprCapabilities {
 struct SpaprMachineClass {
     MachineClass parent_class;
 
-    bool linux_pci_probe;
-    bool smp_threads_vsmt; /* set VSMT to smp_threads by default */
     hwaddr rma_limit;          /* clamp the RMA to this size */
     bool pre_5_1_assoc_refpoints;
     bool pre_5_2_numa_associativity;
diff --git a/hw/ppc/spapr.c b/hw/ppc/spapr.c
index 97736bba5a1..a06392beff1 100644
--- a/hw/ppc/spapr.c
+++ b/hw/ppc/spapr.c
@@ -1072,7 +1072,6 @@ static void spapr_dt_ov5_platform_support(SpaprMachineState *spapr, void *fdt,
 static void spapr_dt_chosen(SpaprMachineState *spapr, void *fdt, bool reset)
 {
     MachineState *machine = MACHINE(spapr);
-    SpaprMachineClass *smc = SPAPR_MACHINE_GET_CLASS(machine);
     int chosen;
 
     _FDT(chosen = fdt_add_subnode(fdt, 0, "chosen"));
@@ -1143,9 +1142,7 @@ static void spapr_dt_chosen(SpaprMachineState *spapr, void *fdt, bool reset)
          * We can deal with BAR reallocation just fine, advertise it
          * to the guest
          */
-        if (smc->linux_pci_probe) {
-            _FDT(fdt_setprop_cell(fdt, chosen, "linux,pci-probe-only", 0));
-        }
+        _FDT(fdt_setprop_cell(fdt, chosen, "linux,pci-probe-only", 0));
 
         spapr_dt_ov5_platform_support(spapr, fdt, chosen);
     }
@@ -2589,7 +2586,6 @@ static CPUArchId *spapr_find_cpu_slot(MachineState *ms, uint32_t id, int *idx)
 static void spapr_set_vsmt_mode(SpaprMachineState *spapr, Error **errp)
 {
     MachineState *ms = MACHINE(spapr);
-    SpaprMachineClass *smc = SPAPR_MACHINE_GET_CLASS(spapr);
     Error *local_err = NULL;
     bool vsmt_user = !!spapr->vsmt;
     int kvm_smt = kvmppc_smt_threads();
@@ -2625,15 +2621,6 @@ static void spapr_set_vsmt_mode(SpaprMachineState *spapr, Error **errp)
             return;
         }
         /* In this case, spapr->vsmt has been set by the command line */
-    } else if (!smc->smp_threads_vsmt) {
-        /*
-         * Default VSMT value is tricky, because we need it to be as
-         * consistent as possible (for migration), but this requires
-         * changing it for at least some existing cases.  We pick 8 as
-         * the value that we'd get with KVM on POWER8, the
-         * overwhelmingly common case in production systems.
-         */
-        spapr->vsmt = MAX(8, smp_threads);
     } else {
         spapr->vsmt = smp_threads;
     }
@@ -4649,8 +4636,6 @@ static void spapr_machine_class_init(ObjectClass *oc, const void *data)
     smc->default_caps.caps[SPAPR_CAP_AIL_MODE_3] = SPAPR_CAP_ON;
     spapr_caps_add_properties(smc);
     smc->irq = &spapr_irq_dual;
-    smc->linux_pci_probe = true;
-    smc->smp_threads_vsmt = true;
     xfc->match_nvt = spapr_match_nvt;
     vmc->client_architecture_support = spapr_vof_client_architecture_support;
     vmc->quiesce = spapr_vof_quiesce;
@@ -4945,26 +4930,6 @@ static void spapr_machine_4_2_class_options(MachineClass *mc)
 
 DEFINE_SPAPR_MACHINE(4, 2);
 
-/*
- * pseries-4.1
- */
-static void spapr_machine_4_1_class_options(MachineClass *mc)
-{
-    SpaprMachineClass *smc = SPAPR_MACHINE_CLASS(mc);
-    static GlobalProperty compat[] = {
-        /* Only allow 4kiB and 64kiB IOMMU pagesizes */
-        { TYPE_SPAPR_PCI_HOST_BRIDGE, "pgsz", "0x11000" },
-    };
-
-    spapr_machine_4_2_class_options(mc);
-    smc->linux_pci_probe = false;
-    smc->smp_threads_vsmt = false;
-    compat_props_add(mc->compat_props, hw_compat_4_1, hw_compat_4_1_len);
-    compat_props_add(mc->compat_props, compat, G_N_ELEMENTS(compat));
-}
-
-DEFINE_SPAPR_MACHINE(4, 1);
-
 static void spapr_machine_register_types(void)
 {
     type_register_static(&spapr_machine_info);
-- 
2.51.0


