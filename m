Return-Path: <kvm+bounces-60506-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 47D4EBF0A32
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 12:44:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 955E83E70AC
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 10:41:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 874F72FB997;
	Mon, 20 Oct 2025 10:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="g0s6027p"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD6FB2FA0F2
	for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 10:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760956755; cv=none; b=MYVWr8q1JDD+ZmX6BCfI/JV8rtmlq/OU752glZywljcY10yN3om1w6AluEqso2TtFv7zLVZeIjsi02fJDyHqeMBvxT0+cpMXzNiVLZdphUY1ASfrUix0ssdpC8XSi1YtQjy8ZUR55b4fpo7iiV2em9gfVoXIVpeJ1DRTzPKD+9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760956755; c=relaxed/simple;
	bh=kf9er8hlgJmvdNcRjQeX6lESWgxGR4CnMyDyNAinawg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Tyr/8KCoEVSD8H0YRwz0wTAq/sYZAtZ1xMwOiVZigoLhAZAMjvS8+HRwK/DNgcXRHF8c1cCV5G47qTWT8DoqeQI6IIc5T+j2DdYe6Wagp7s+h2IR/6eLFU+ZDVG8oNJImJ7sTwzDPIhle6kF/nxQtA2iioGTioK3O3I58DX1pWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=g0s6027p; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-471066cfc2aso38074765e9.0
        for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 03:39:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1760956752; x=1761561552; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TZHEWfyw9nXdEX4o90awyf1j98q0YkzoZ7smAeZYw1c=;
        b=g0s6027pdbQwu8sAe65kG3yWLWrMUjdfFmS142gl7yqFW/NNHmisujmpPgsP/T22Rq
         koqeuPACwZiOnH86gYGE9wVhSoWsOAC5ynqdBliE+0RvlUvkH9n40t4t1MoxeXrpyE8c
         gBXEmlpY4D7b89+WfI0E9iobfnSzuLcBWttdQlXGvMB7TY52SJlW3vIQFyPlps5eJsHN
         voHFDs5dFJyc2N77v1obqMYjuEV8KJ2ZjxuIrgqPfhhMIGRjAdcmxjYtLmmF1J8qhbBO
         9dPtYovo4ytBxqyyIddwkv8A3JMUs6qZcLYagjCphwzrNz6pQLHjF53EKE6BWLRe5Mn8
         ICgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760956752; x=1761561552;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TZHEWfyw9nXdEX4o90awyf1j98q0YkzoZ7smAeZYw1c=;
        b=xSc5VoxaEQK74XtaV+gvNlGx9IXfzYuUsIm/EXs4w+QaBmwfJq36i/01VlzNR7r4rY
         iajslucNipHeaFPROu6mD+Kgsl4UiJI9GdpdjZq1GxcjQZ20eaM4TDio9mPqV980Hc17
         UYrtZU0HCjXiJ5vyxxyGAcct7TNMNUGPiCBtEuI6GN4rkQnK8vGQDBmIgYWgoKAzOhqc
         LrxsmhsuYBoeqGYuhdWF97PjsQm99JhEK1Ba1spQ1wFQA8hhdupCTZRD2pBjfE73Yt4Y
         lLZONMsRrPQGcBEAlYfCG8kjyoHSDjYzB/nSl0bAaKplBLSX8aTPlxYHAeQ10mdIkES+
         /6fw==
X-Forwarded-Encrypted: i=1; AJvYcCVPcG8dTqZJxvvLItNeLgEbFm45PhAx4r5O3fPSiZYsqv6qF3YEIsK2RJmlrESXlW/3Yms=@vger.kernel.org
X-Gm-Message-State: AOJu0YwNfmdUd1DJHlMkepDLkGUl42whdoBAVwvF5iJeJnl/REZT3Gdr
	Va5cd/nhitI6B3eBgvmCuQXu8d9+pWsvGM9Ffl8v/nRmLb/cNo598JnmMsrT22KPOaQ=
X-Gm-Gg: ASbGncuYLf/CW8TfZm5680rYWwbLJrYvB044U8uYrPImEqgzAW5Ajicaws4FPWQHJNk
	442UNnRm2q8iTIS0ItV1CAfiheoLUiHXKXUGB+rP8zblG/V5FeawEsfyfD6h0Bm8qc0bkypHIl6
	cU2XTmgTeqCJkbktZfxGwAI+TNI18UZqIa+tNbgJidqQV1CxAFyaPsh7MD2xM8UzBxWIxP1V21W
	ayiBpSDr6Y71cZr2xfylrHngX+mUI8j1z8yYIktVcbgpWM+nGTR3+Ga9JxytOT1vmD6XtcPqg2h
	df95TiW2RxrjLlDQDtt/yyvHR1tUuf1Gyh+Wq/NlLvcT4g8FqL4MBwKiAEi28r+xANVi693ZYvo
	k6St9+p6IoLCnxBxQH+xsVfelKfwqKeeDfD9x8eFe4xdWZIGvUVPGf4rvOajXYeCeWrW6EgYUrb
	TVPcmP2Zqsz/28S1+DXrIal8uB03C9GnsC4As6i0mu0c8kRfeVXg==
X-Google-Smtp-Source: AGHT+IHt0NJvsiUGxeAB/Y5QARjE5h0PkET3wK8rookKp/FSOl9qyNOKlATuA3hZTZ2on/J37dayhQ==
X-Received: by 2002:a05:6000:2c09:b0:3ee:15bb:72c8 with SMTP id ffacd0b85a97d-42704daececmr10159066f8f.36.1760956752274;
        Mon, 20 Oct 2025 03:39:12 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-427ea5b3c65sm14592118f8f.15.2025.10.20.03.39.10
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 20 Oct 2025 03:39:10 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	qemu-ppc@nongnu.org,
	kvm@vger.kernel.org,
	Chinmay Rath <rathc@linux.ibm.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH 11/18] hw/ppc/spapr: Remove deprecated pseries-4.0 machine
Date: Mon, 20 Oct 2025 12:38:07 +0200
Message-ID: <20251020103815.78415-12-philmd@linaro.org>
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

This machine has been supported for a period of more than 6 years.
According to our versioned machine support policy (see commit
ce80c4fa6ff "docs: document special exception for machine type
deprecation & removal") it can now be removed.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 hw/ppc/spapr.c | 27 ---------------------------
 1 file changed, 27 deletions(-)

diff --git a/hw/ppc/spapr.c b/hw/ppc/spapr.c
index feb1e78b7c0..e861a2e7466 100644
--- a/hw/ppc/spapr.c
+++ b/hw/ppc/spapr.c
@@ -4968,33 +4968,6 @@ static void spapr_machine_4_1_class_options(MachineClass *mc)
 
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
-- 
2.51.0


