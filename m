Return-Path: <kvm+bounces-60511-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3296FBF0DF2
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 13:36:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5ADDC3AE04C
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 11:35:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 546C72FBDE6;
	Mon, 20 Oct 2025 11:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="h4IBJwEr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B059F2FB973
	for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 11:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760960136; cv=none; b=RkC3AUPNbdf9TIAFeb1IZgIbzAOIhgIZ/mpipyx+MPo0w1bLR03Md1/0+80Z3cmT9IYl34bQMhpWhOSqgPcEshZSwTETCt2pN2yyY9EtcVTwutYwSveNcZougHVBNbE/e3McXlqHzKQmDFUZwrlTUlBr3p2zGJ7myg3jFenXc20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760960136; c=relaxed/simple;
	bh=ClhwGgaOOU0ZHw7OFsVMsWbT+O8DksqHn4uB4XLJxB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TwoCX7oDRnVAVyoxkFtCD2zV1QDfQwR5qMYxc6I/LQBAQ+RGj+4RhMQL/kh4uSSPVhCHfwAqFVokBouV4YzxFXIdzuTdpMyDKOaYGGTkXZ75WCQAvY93CIKTw6FIYhtelyy6ljFaSktQ2hXuSaIygeHen502U97hDuJfrxxpiq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=h4IBJwEr; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4710683a644so37977905e9.0
        for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 04:35:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1760960133; x=1761564933; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S13OAGdaDHxB33SgD+W/tXYSpC7CzxHFsXBICbw81Dc=;
        b=h4IBJwErHKfeA+L2711zj+cqEHkjMTdT0wXDWwVQPuZl53VJ9wGNbME/3q9wBxJQvW
         dyq0w9pYHjBc/mbjjl7NH6nCmzcf7jLbPLvDew0T3sdDOJ2AG6fFb0+Gwmp0uqqOsXWC
         FafY/SJepOvJq/SDoLsHJNdf5MwXarD1G/KDJy5zQNHO8hXTDlqglXZfIeFRL/hNGEKi
         NBI/vFipTyFqAv4avwDbEctQQPfh46411lmtm3ZAuks48jzFoYu+8bNjc6wixRrP6AFr
         /TrGlR5bMXgCXVgYJgCm3xdvxs79uQD3/9cmkklQlkjNrWk+2KKZ+WLmJkAnGDa8L5Mr
         YlyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760960133; x=1761564933;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S13OAGdaDHxB33SgD+W/tXYSpC7CzxHFsXBICbw81Dc=;
        b=rBPKf964Up0E1quPm53ZqNmpyf0w7cM7RS+MRqW+NqceThmCVB+6+XPDzSefV2zMxT
         p1jiywkCm+qxLvYGuf9j1F/mCFK/SdcHwUCfIwuGXcF8DczV/znE464VY0kHhsrGSdJ6
         XTv2mVrMZ+RMPdY+gkbKS4Kg1QnC8dvi3/v382V+ZdlyTXryXpeFpZZwz63UoU0eYh+D
         4fsD/4msQlphYgD6rn/cP+lgY1PLVwzi5J4dKEVnSc2mOqezLMRlE5QBT3A61T+/+VpK
         GvLsKUQRSikwMHIsJsjqX+JRMAXptUzMCqYAtXKvDf4fsEb2ywppqFP+id1pqfKcdRZl
         eMMw==
X-Forwarded-Encrypted: i=1; AJvYcCVSChA2m54BrQVmGhaWa2ErOcYXqKBEYEeS/LNZD6sgNexrDQ5L6vVJVQ5kJxIfXcb4VyE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwVsHEJJC4di5T35V8sO996M+gGfpW1L+v1r8Hr2wTG79q7crc0
	1xVJpJKOV/Mv9MmPVK6lVjPwReH+AXzzqfY1udp5FgcSdUs5sWPJjIpfM+ro7eQ/ZZ9QJImOelU
	GoeKKIvQ=
X-Gm-Gg: ASbGncvc3yuzeYk9p6Xn0OhSyNh024kW/P7xTayPmOn7970iPD1cLG4/GssvkRfum7L
	C5bZQqN0jrhPBtmEzzs0hc5a2JpD1ptIlmb8fUS5OqpXaZnyeNoeGwA5WGLzSrJ/YJKUm3K3/0P
	pxNvH8ryMHS4Q9duJEqXM9BmHBanouKn4ea/xlywKocS6E6AxS9257YsHpbGQB7m5lwUy3zmrQz
	iSGwUWwrr1aFPStjT1iDRMswKMZ1+mFWUourxw6se7lMIR2RvJjD7GdWDeeKa565zKaLOn81Nmf
	YTbTZ0X0CX6mNYrDLSlUusEYcBh3EkpZFCdVFoVVkDjeK8LwdCLiqa8/LUfTG+e0ruO6agUwW6y
	i9HnMACsBzsovwWPNLiftnAtY5le/gbpfFiDmSXWEL0xY3+ay6bB2ug746i81LkvfHDP6bRO6q1
	mtDGMHZYRPINujdPiBu9/mo0u3qyZevwbGoTtLnlOCXdicmog6UQ==
X-Google-Smtp-Source: AGHT+IHDgvdsyRBoa6BCavsmZEBa5Tkw6MjsxGG/H09wCivMI1OQ9hkaGo/cc3BuEl5TEQ0UmvIeFA==
X-Received: by 2002:a05:600c:8183:b0:45f:29eb:2148 with SMTP id 5b1f17b1804b1-4711724e5bcmr94251665e9.7.1760960133000;
        Mon, 20 Oct 2025 04:35:33 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-427ea5bbc50sm15087183f8f.21.2025.10.20.04.35.32
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 20 Oct 2025 04:35:32 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Chinmay Rath <rathc@linux.ibm.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	qemu-ppc@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	Nicholas Piggin <npiggin@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH 16/18] hw/ppc/spapr: Remove SpaprMachineClass::linux_pci_probe field
Date: Mon, 20 Oct 2025 13:35:19 +0200
Message-ID: <20251020113521.81495-3-philmd@linaro.org>
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

The SpaprMachineClass::linux_pci_probe field was only used by the
pseries-4.1 machine, which got removed. Remove it as now unused.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/hw/ppc/spapr.h | 3 ---
 hw/ppc/spapr.c         | 6 +-----
 2 files changed, 1 insertion(+), 8 deletions(-)

diff --git a/include/hw/ppc/spapr.h b/include/hw/ppc/spapr.h
index 1629baf12ac..60d9a8a0377 100644
--- a/include/hw/ppc/spapr.h
+++ b/include/hw/ppc/spapr.h
@@ -139,11 +139,8 @@ struct SpaprCapabilities {
  * SpaprMachineClass:
  */
 struct SpaprMachineClass {
-    /*< private >*/
     MachineClass parent_class;
 
-    /*< public >*/
-    bool linux_pci_probe;
     hwaddr rma_limit;          /* clamp the RMA to this size */
     bool pre_5_1_assoc_refpoints;
     bool pre_5_2_numa_associativity;
diff --git a/hw/ppc/spapr.c b/hw/ppc/spapr.c
index c8558e47db2..30ffcbf3d2b 100644
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
@@ -4638,7 +4635,6 @@ static void spapr_machine_class_init(ObjectClass *oc, const void *data)
     smc->default_caps.caps[SPAPR_CAP_AIL_MODE_3] = SPAPR_CAP_ON;
     spapr_caps_add_properties(smc);
     smc->irq = &spapr_irq_dual;
-    smc->linux_pci_probe = true;
     xfc->match_nvt = spapr_match_nvt;
     vmc->client_architecture_support = spapr_vof_client_architecture_support;
     vmc->quiesce = spapr_vof_quiesce;
-- 
2.51.0


