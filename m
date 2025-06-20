Return-Path: <kvm+bounces-50088-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A83BCAE1BA7
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 15:12:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E54BE1783D4
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 13:11:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEA4928E56B;
	Fri, 20 Jun 2025 13:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="mvHTniti"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5240228DF41
	for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 13:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750424954; cv=none; b=OACUKK+gU8U5kQQhhUquIEnaGQPsfFKkM514OQKDHk/jdGc1//VnY/93685J6F4q1etGiXcIvN7S5e/yoluY07WQ6uyuvA/ZabFcTLVJI64eXcwLOtkaK+7vufVX70eit6B9CRxt5sB7HlgAGikeLaKsHzDGgZ+zoMXBE0/zyRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750424954; c=relaxed/simple;
	bh=+vQnqa3V77e8tZcvqIaoKebiTeUrRkbDiwBagwuvrb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mAuv67suwp88xh+2/RmGCP8TKmxoCllwx7j3DxPlZWMXTWSf2qIdz+a5ZiHD0ibA6f1O2N2iMQPKUwdX4TwCreIkhay78Z6A2REIai/8Gc8xfVF6ck+XfKyUJrBCAQGKbUvvAXLU+hTqb/T1i199vCiPWeL4ZAAZE2Ved+t5Sa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=mvHTniti; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-3a4fb9c2436so949158f8f.1
        for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 06:09:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750424951; x=1751029751; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y5LZcCqNpH4GazYoT4HEePjvcf7hcAUKrr97H91/oS0=;
        b=mvHTnitiih8CCAFqCWIlLmuVUWwqPC/3iulIiZRqkEfclS4wimj6b/mtm1rHAczL6o
         qaws4bN6Ks/RvWiTHpovYZ5mljAJG783x5zGHsrbuxACd5Xo/EBDjJRPhIC7iCD1uf8S
         Iani8IX5pDIYvHAypCXpGmhpu/Te/2io9gJphAzvIV2M/ZN1REU/eqC4FvU2/eicbpjZ
         zHNkLQ5wRi2PqivrFTWwsJEPBS+svoVKU/UG2ZE48BvHYRXwBp7Yrw6D5GzaP+QCQ9ST
         P6audnhXMypuSMV3raqXkTFGuxKXBp+aE2Odpm+tDRjJDbzo4ZxsgCrDy+AxbBZ+0VLx
         /U3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750424951; x=1751029751;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=y5LZcCqNpH4GazYoT4HEePjvcf7hcAUKrr97H91/oS0=;
        b=oN9lab/VbrIcEyJQE47U7vDr/NFiLT0Om9zHnkX4ttNk1DPRKTgaZNVhQt+6jEBX/u
         LtIv7Glxl1MtlLAUWcpzfiNKLbiT0sEQefkAuUXSaL8u8RJJ8rHZYpCZBC0+eghEFFap
         0UFnT+rgtrcwePSnG0BPiLyY/xmXRMGUts4VN5edlbyi6yM7vOaKGUSCys5rD+tnWT23
         LNBzTuOU6ccSB3CdWj0z982A4Q1nTAgxjkju3LGh3eZfUhFy03vqlKWgiDJOGNAr0Yx2
         p0gtRZ378cBnX0hxoqrDbreCxgdVQuY7hKo8OQhz/HqB8vpG7fejKnL+4mMLIpQDfEMb
         sYAQ==
X-Forwarded-Encrypted: i=1; AJvYcCXfhfkDbmMYL5XsnuQ2wNN3F+kyO6O+EATCDK2/DyTJHXc1v5jZIOPXTvFQwnXTDxG+Wt0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxueztlAhvbTSn0DQh7GMiaollNVYCC58t5o11hTEjYSHUW4iBY
	sDfFe/x6ZuDqaCFCoDBh/EXzUu6bCbMLPFIe7uf6QmnXxzzC05M0SXSnxwx3W89TEYg=
X-Gm-Gg: ASbGnctxG7wjI+n97zCVJ6AJbDnEPhbgfepjCBrXdVAt4FgK3S4Al1TAwCu11sD58ZA
	msYxZWgxRBcjh4wLDc9gpWI1scYcYQSItE5KmtLyKWND3h/2IIxohz+SntDSRd/N/F29i5P5g5T
	9US6tc/ec9mDFQiCkIrlGtYxxpod4gMOwSwUQ8XsGStdrrMYUPBKIXu3wha+g/fcjgxMyTiNjxf
	4P2QOTFQQtIaU6yNcvXGHBrDTn5fO+WkMbLp2bqWCOYdv1Z/7CwtI48rRufbQA1mKEY5JSxftvs
	BMP6OeznDLkBZr7Xi8ua7S5aqtYWwjzuUXN1u6mojD2rjHdWT9fccnbpfRoxhZVILJmD04mJb4j
	huIXVUMZRq/oAwc+089OXIwdZGKOJyXwbb4Qg
X-Google-Smtp-Source: AGHT+IFC6yofAEZU9uIg4ElHVXtdVlW8O/y3B6pNs8rlLb+5bVvaCqliz0NCeVD+ukrt5UnUQmDjdA==
X-Received: by 2002:a5d:584e:0:b0:3a4:e841:b236 with SMTP id ffacd0b85a97d-3a6d12d8c86mr2406728f8f.33.1750424950626;
        Fri, 20 Jun 2025 06:09:10 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a6d117bfd9sm2076809f8f.57.2025.06.20.06.09.09
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 20 Jun 2025 06:09:10 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Leif Lindholm <leif.lindholm@oss.qualcomm.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Radoslaw Biernacki <rad@semihalf.com>,
	Alexander Graf <agraf@csgraf.de>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Phil Dennis-Jordan <phil@philjordan.eu>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Bernhard Beschow <shentey@gmail.com>,
	Cleber Rosa <crosa@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Cameron Esfahani <dirty@apple.com>,
	kvm@vger.kernel.org,
	qemu-arm@nongnu.org,
	Eric Auger <eric.auger@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	John Snow <jsnow@redhat.com>
Subject: [PATCH v2 21/26] hw/arm/virt: Rename cpu_post_init() -> post_cpus_gic_realized()
Date: Fri, 20 Jun 2025 15:07:04 +0200
Message-ID: <20250620130709.31073-22-philmd@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250620130709.31073-1-philmd@linaro.org>
References: <20250620130709.31073-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

QDev uses _post_init() during instance creation, before being
realized. Since here both vCPUs and GIC are REALIZED, rename
as virt_post_cpus_gic_realized() for clarity.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 hw/arm/virt.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/hw/arm/virt.c b/hw/arm/virt.c
index a9099570faa..da453768cce 100644
--- a/hw/arm/virt.c
+++ b/hw/arm/virt.c
@@ -2032,7 +2032,8 @@ static void finalize_gic_version(VirtMachineState *vms)
  * virt_cpu_post_init() must be called after the CPUs have
  * been realized and the GIC has been created.
  */
-static void virt_cpu_post_init(VirtMachineState *vms, MemoryRegion *sysmem)
+static void virt_post_cpus_gic_realized(VirtMachineState *vms,
+                                        MemoryRegion *sysmem)
 {
     int max_cpus = MACHINE(vms)->smp.max_cpus;
     bool aarch64, pmu, steal_time;
@@ -2349,7 +2350,7 @@ static void machvirt_init(MachineState *machine)
 
     create_gic(vms, sysmem);
 
-    virt_cpu_post_init(vms, sysmem);
+    virt_post_cpus_gic_realized(vms, sysmem);
 
     fdt_add_pmu_nodes(vms);
 
-- 
2.49.0


