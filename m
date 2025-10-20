Return-Path: <kvm+bounces-60496-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AE2F2BF094B
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 12:38:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 931941885220
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 10:38:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA8B4242D89;
	Mon, 20 Oct 2025 10:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="sI7bQa4l"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 393952EC0A9
	for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 10:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760956706; cv=none; b=D00p6PS3OqalDnRdzrZLLy7wsSQcXfIZHhf4Oldm6COlL9+qc3kShm7nW5vA3un7jkvTfXIiPxXzrFrkYvZYptNtD8fQbGfsjno5ac3++EkygRNek15WAMTXym5zjtXX5e+0xy9KOg57E0tc4NNasxK5ODOpy2Jvnfw76Q8QaZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760956706; c=relaxed/simple;
	bh=JYx0OPLtgqKNaaiZiR2lr3u1Ub29Hr7whZ1uTH1ePoc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eLcroNz8ml1IkFjlx/HOmQxdJtP09jYjYlveIDlhRkLimXuVIRfTurRRpJwaspd89z4lrI+yCyUpKZ/hs4YEpFJBc7SjcHYK5DxbqayaYsdAzRy46KINddIJl/mI0RV2lLVWZdBABuoGKF5DtIOIQpBC5OOFH1qfJ1eBxgRw3Ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=sI7bQa4l; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-42706c3b7cfso1282204f8f.2
        for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 03:38:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1760956702; x=1761561502; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Eb2zFhHkdjNt2ehW35HLRPZBhm40gE3e2lVHvPQ87tw=;
        b=sI7bQa4lQeR6nxMU0yGXoqxc3sroysCXEQkT8fy6xHrUS6sb8UP9RKX1UdAhB/izyb
         WquSn7kLraCmE5hafGdKEhe/qpkXn+GpUim9sJXvPUqFNmvRC0T1cYDexHgveFMACXg5
         4pTBc+estJn44Pe99+IEA/7jS9ftN4XPxu0k8dubWkmXpV8YsaNYzzUQunrUPgnSBH6W
         Xne/7S13QuBzA+s9Wr/R4FchwkMqbz9oTKEhi938GZWt2qjVOMzi+rVvvQRG8m3PIvLC
         1DqlsaeA9BI2y3IhwJXXhI1hw7GIIsaRPBT5EUIlJcccJ/v39vf8j9szf8IDql3TBH+q
         5zjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760956702; x=1761561502;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Eb2zFhHkdjNt2ehW35HLRPZBhm40gE3e2lVHvPQ87tw=;
        b=KMYl1jH/oXKHzllb3ihDtcFk5HKs0qfP7b/IkbFrOr0MoqAKJ4XYgLY3BYJ3V65eRA
         dd+fLLbD+fkBFmx5kOrskHnb6+3gjTBbxdGS1qABVUCT2G4WgGKM71Dn87HfjXrncNwc
         6wa7rOO4TOeEW94C/F9x0QCiq+GI20Pb89aq629Rw+kh50UcnfJSegZ8jWG7a8hSZcmX
         Ppf5twiNCJ7dgrKE16qSnoLYAC+RdT+Zf8/Sf+0z8WG0rgXzbll6hsdcle39xw/7nT29
         k7z8fskEepAbJgE1egR0BCZJpAWGOoL6X5W4NpylLkON6fFBygmnZBgQVXeIv+gvPA3N
         k+RQ==
X-Forwarded-Encrypted: i=1; AJvYcCVSM6ujY2Ozh428m8zZgPXrInI2McFs1QCR7N05WEu75cBabEnABN1Hh65L3w7v3uVFEdA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx36dKYWlVwI3/j7MmgoFnivoZaw7oishv/2L4h5dszemC2D/b8
	S9JzamLMXUlO5TtoAck2T72W9DPjE2NQJZdVx1DHFGgd0KVKjHhYSVEJ5Lrmu/sWjoo=
X-Gm-Gg: ASbGncua7uYvNCoRS4FEm0GsERIDOoFn+/aFWDBSUHvzxRMMoSgQdoE5jHRpKe52c/n
	nt8/bVfTeW7mDfev3lUh3h21NPWXYTVJSRh9eY+zkoGady5TAEGgKy7wYeZFKFxa78XXsUvHIMz
	fMf7FowWpbhvt6RtOkFpFoGCCvEq9W7sGEjznyb48m8Q6wqgnXs1SYW9AuvviV2ULfp2Y3T9PaK
	j+vV5R8f+qSlscuyt5Yxkhi57cmrJGLcbpwHhiqbWZINiu4ffD0bv6D4nd5NLdz5jcz65pOlZdo
	9fJpSkB8XKFuuaAgpRwP9vrY5zgHLRGoq//miUUNFLtrE1Jt6dAP0PPcRGG6X/tAy8L1QszjdWl
	2/3WIseP88T6dBZlfw+H74G0Q+clidg50sMQaSZq3H8Jodg95w1Wi4ezyPguZ8X78RZ04vfg0oz
	p21jbWRvgqFLyGcp5FIjKoiJgG5UJyCrfBnmH7Abpi0gNlvJKNTg==
X-Google-Smtp-Source: AGHT+IFXtCupIGDq2siVPGNf1Z5WcGOG8FPQCLDkC6kjb+5DMC1Dp8EAQOlPDFoxVNiZGk46JqVF8g==
X-Received: by 2002:a05:6000:25e1:b0:427:580:99a7 with SMTP id ffacd0b85a97d-42705809a1emr7079805f8f.59.1760956702518;
        Mon, 20 Oct 2025 03:38:22 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47154d382d8sm141032845e9.12.2025.10.20.03.38.21
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 20 Oct 2025 03:38:21 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	qemu-ppc@nongnu.org,
	kvm@vger.kernel.org,
	Chinmay Rath <rathc@linux.ibm.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH 01/18] hw/ppc/spapr: Remove deprecated pseries-3.0 machine
Date: Mon, 20 Oct 2025 12:37:57 +0200
Message-ID: <20251020103815.78415-2-philmd@linaro.org>
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
 hw/ppc/spapr.c | 18 ------------------
 1 file changed, 18 deletions(-)

diff --git a/hw/ppc/spapr.c b/hw/ppc/spapr.c
index 97ab6bebd25..85c27f36535 100644
--- a/hw/ppc/spapr.c
+++ b/hw/ppc/spapr.c
@@ -5062,24 +5062,6 @@ static void spapr_machine_3_1_class_options(MachineClass *mc)
 
 DEFINE_SPAPR_MACHINE(3, 1);
 
-/*
- * pseries-3.0
- */
-
-static void spapr_machine_3_0_class_options(MachineClass *mc)
-{
-    SpaprMachineClass *smc = SPAPR_MACHINE_CLASS(mc);
-
-    spapr_machine_3_1_class_options(mc);
-    compat_props_add(mc->compat_props, hw_compat_3_0, hw_compat_3_0_len);
-
-    smc->legacy_irq_allocation = true;
-    smc->nr_xirqs = 0x400;
-    smc->irq = &spapr_irq_xics_legacy;
-}
-
-DEFINE_SPAPR_MACHINE(3, 0);
-
 static void spapr_machine_register_types(void)
 {
     type_register_static(&spapr_machine_info);
-- 
2.51.0


