Return-Path: <kvm+bounces-60509-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 99BD7BF0DDA
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 13:36:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id D081C4F2582
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 11:35:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE462255222;
	Mon, 20 Oct 2025 11:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="weVSsMOL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A1B620C023
	for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 11:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760960127; cv=none; b=AVMvkk9X+y1tbJBIKEJjwxzEKy+ZmAYUcq/a8eqsJoOXKxcvHQa9z9+2VJfYIzEp31DASV/MDzgIejD8zcfcMNyn+yGPx0JPe2Tw3QtqwHYavjozbYQpwJr0Ab/AyXTl9UeDC1cQ1qxt/b6QX6SygQio8hc2W9sUK5bUMRFel48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760960127; c=relaxed/simple;
	bh=FN1Z8K95Q+gxrgTBCrfjlh4Q8q5HHmR10NqdaSeKgkQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZQCA83qiY+Mvfcyw6/THkN1niGxknIxZpf2RziTxnsmi19bgexI2dQ+NjfuCPMMwBuho846xkdVxEhswfpEze8G6A+dOSC6A7175e3hzKcUCxiMyiPMzd9SjzIZM/+ULvXiITakVw9BjnTjY4Pa5Vvgq6bjDsOntu/WwcgCyefY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=weVSsMOL; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-427015003eeso3102986f8f.0
        for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 04:35:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1760960123; x=1761564923; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MzhPWMtAsbDZTthftO9YhohXMbNw1TnHtRaGw5lyOng=;
        b=weVSsMOL3In22fM9+qg41Ma4scnD3Dn2Q3FaJ7DuvIBeDMaZfWpQ2ibYjY12kgNolv
         IXriPSGa1KWftBF0WngQ8IwOF/qd0tzkkXVqiv6luKiF1v9gAYBWR0ZsHbFQu3M6IsPc
         3O6Yb0fu3fILfSr6zkt4W3iq/FkTZY1CGom+Vw1267keAXMM8kd9Ewd9dBqgCqWaEZtI
         X+DO4Q3bxWniVrhPgs6ayGi5I6I9UBndhprxU1iDnEiIJbAec92DykEK00QAGIKysLkE
         Cd2jkeXHEMDUz3cggEOETr9apYuVu2tqM+iT2bX0SKWZnLnxAHUER8/LETmsHRIQMk4C
         D78A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760960123; x=1761564923;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MzhPWMtAsbDZTthftO9YhohXMbNw1TnHtRaGw5lyOng=;
        b=TVMLH2wuFD1k1Ki5SyemwqhhcO5uD5Y0F3iVHo2L9/Gg3XyKwTwv3UzAt+6xZa/c3c
         PX4XuS7phFCPQ8R8r237UhjxLOdV+4Pomj5R0/i90wghJMSRjCdhWOGUPVoY6WzZa7p9
         N86LiL8wPomvexYRsWr07mxDH4/APW43b1wfZ5YY2dzEXk322zoNarg3qUAfb0zdVaXl
         kOZt0cp86e9DQ0gI7v6KnW4ehCXCvOdeuESp1dPLeEf7jIPlNdl5N759/3mnslKtuHHz
         rpX3VgTvIHb7Hm07Jm8Hbs/i8A2+Eob/Gx7FbzbyPi7Wxb+ogoA8YURddeL9FFVuaHHj
         Ecvg==
X-Forwarded-Encrypted: i=1; AJvYcCXXAzupFCccgRXqrvfW2Y6qhXPa14+FrXhV/H32B2PweUkEy5bSMSF+2s0NTFUaTYJEymI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzIqtdOErf0ShV3OGYqLfsH75N2i6vAqdfIp+tugkxiNoW/SQVV
	9qlCYT7FT0J19gMduh4fM9dvqXCMIzsI6NLxmlmToWTaPesW/gFSNIJFM+E20Cd5Bbw=
X-Gm-Gg: ASbGncsCwJPpRIhNNipVrVOuOaNQTTLRACnR/kIY+dFwDFcmtfRhw7CEykC38y191wR
	XtQ8b76WvOBzH1ClMqrVALi/ZpO5nXUcOIVIkyzDWr87AeyBmnl1qT5V+gKcZvLyE8Zt2R0Vfp5
	TISP0IL38kdPuJSvVY1mCFMRErbup5vDdpPOssbnQXX9MHqBZrRDOzi945A5BgGWSQ/WkggQ/21
	zMilg/G10o40QKKwC9xf6NOGf/kxzvuOFOxwH+COXsxxx8TuFFQWfMiWg/FgCWfb9dMwS+URT/u
	PA4aEpqgAOoZAvBfC7yp2GcsxZCUk3vBclp6Z1fNREgodqRPgjdFllXbb1S6DWKcYvK1i2vb673
	yZPsF8Jm7sDx7u9TGGQFpfJ6d1FosblTytOKnWmV/ME7sm1WYStUMrfQuNqby23yafbu7NITSY7
	tWGLblSamdu7smCbGybY1MRr8ez/o3lj7otxcjazqEqBwEwE1p0i/zJQHmfohqcAwxGDLarRc=
X-Google-Smtp-Source: AGHT+IGx8/bW0BfFog+BbHV+wdKKj9MN2FMI8wIhdy1epDQbm/zZcQw4pC1e+iagJ9rBjrQOXHtOEA==
X-Received: by 2002:a05:6000:240c:b0:426:ee84:25a1 with SMTP id ffacd0b85a97d-42704daed04mr9705653f8f.38.1760960123281;
        Mon, 20 Oct 2025 04:35:23 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-427ea5b3d4csm14554230f8f.19.2025.10.20.04.35.22
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 20 Oct 2025 04:35:22 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Chinmay Rath <rathc@linux.ibm.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	qemu-ppc@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	Nicholas Piggin <npiggin@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH 14/18] hw/ppc/spapr: Remove deprecated pseries-4.1 machine
Date: Mon, 20 Oct 2025 13:35:17 +0200
Message-ID: <20251020113521.81495-1-philmd@linaro.org>
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
 hw/ppc/spapr.c | 20 --------------------
 1 file changed, 20 deletions(-)

diff --git a/hw/ppc/spapr.c b/hw/ppc/spapr.c
index 200e68b8bc2..546e100c9cd 100644
--- a/hw/ppc/spapr.c
+++ b/hw/ppc/spapr.c
@@ -4944,26 +4944,6 @@ static void spapr_machine_4_2_class_options(MachineClass *mc)
 
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


