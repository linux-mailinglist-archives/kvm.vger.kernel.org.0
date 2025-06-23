Return-Path: <kvm+bounces-50331-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DA878AE3FFA
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 14:26:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 15BD5178D41
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 12:21:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEF34246BAC;
	Mon, 23 Jun 2025 12:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Iu54AJWv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75D2B244678
	for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 12:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750681233; cv=none; b=f6e24wlhY9HS/Pn9VFW9f80EDPoSaGIYEOjwHAelG3yvkZWxr/Gtt66eILYUwtCf0KqPjIw5kRydO0QgRJroIPwdjU/+bmzpcvT2+oTuz3XJM43eH/E/1Yy49Y4m4mPEP7wA9HLUllATEOHCcPpLOQHLhoTRmOyyRgvtQmxeWRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750681233; c=relaxed/simple;
	bh=4ZM/UY4cGysfRCsTRUsZUIIg3oE8uirnVQ8HQLcBkLw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PU2xR/CTtEha1jbfjx/Va6I1Z83r/xpGb+qVzYdDWtADJzDduVzcnn4kMZCqfjaFaLgbC+uPNwJNLcnkSGaulryo4ngVnN3cYfN7yte2PIGCrA74c7BYZMIuJTUFjLcP3sp8bbtNQ4gDWPF5Uu4CMH4umYLNIDB+BQ6/8LEG0YQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Iu54AJWv; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-3a5123c1533so2047931f8f.2
        for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 05:20:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750681230; x=1751286030; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fvGV0OwfNAMYe1Mulybvoaq3k7G7T7tR2QdHLx3eR4k=;
        b=Iu54AJWvT/fdSoAByQIs5kaKILQzlMy8hdR0T0+H5txkMwIKlGjLVi+ZDezcvbwcix
         TgokNmGh6Fc6aEkGVzGj25W79AOZH8whYA/jsplS/9VKlzMHrVYGYxl2GVJLhRYPeVZB
         5JltM7sDZERTXHcD0jryd2Q/5o2Cr0JRGfWIniQ/oU3Lvwv7P8zBXfAhN5WR9gbPacO7
         pHkwJn2V8jd7D/QFGiEu/Xs51RTNymR1NTqZzf6f5Nov9rrmJrxfZoA+/Y3WdH1QcvXQ
         lUDv7tOmQTjXNrPj9P/p5pwN9GYPFBxuetSHr8BlQXHrr99lr7xSJ13yPCLdM8Qbckns
         Vmtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750681230; x=1751286030;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fvGV0OwfNAMYe1Mulybvoaq3k7G7T7tR2QdHLx3eR4k=;
        b=ViFc+ntzOFvoAP7rz707uhmV2tUUMEioiEcBqz7XJOh12lMpmUuQiQtGbFuEdCwbDY
         WvUUWsQsu2e0UWkAbVRfj7sJ6aMB388jr9cPHgNGnxU6CxrJx7rARKOHomWQjoDNnnLG
         uvwDlCS5olh379ITqa51zbER6khKUz5V9dJbSBi7P9SOLtr1lZgMDrTqDjb1y5NDKDYQ
         NQ1D+2vafBrUTYGwoED6djfxT2NGR1osb4npbYV5CB/YagrO1dMAfm9AXiqENGGhmyQv
         jw27FTWCjPOV896xeS8tS1VpnbPobeLSzGv1rfqAHKGpy8PjGIiGOfjyDRTJuSxWv57p
         v16A==
X-Forwarded-Encrypted: i=1; AJvYcCWQQCNG42ukwnmQpLy51YUzNUy5MDtrQmfr38sNX340FPQxhtRQ8SqyToTX02Ri4NA15U8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy/tpZwZ/VCzlPINaEuuqtTFJ6vc1gv7aCj4+ePUgQUvY+pEBrD
	yKBOPWVhVHBEDHd0HQ5SDtEUsBiytXJuY2rJBi/ewc/m25rAjP44xMDHTu+01c2H/ms=
X-Gm-Gg: ASbGncszon3OGNDOWikj83QVAh3M0amOrRQ8hUBBQWrVXz2AWukjK2pAMpF9FRHXZ+2
	VgTjCqMVmjhyWWYohRReVjxB6qMurOMIgmm1DDjzaPoaabEYPcXjxkOkvGdtwUuQJ/gxU3jY4H+
	4loXBdemlx6cO62reNe5LmXdH3b0Hc2fYOrt/BA782cV+iEdX2ieIZ/Ysjb7P4QXwJHonxNEu1k
	SrTd6NRO7p2FHopGQdMJy0X6m6DnZH+CFMNNTsQHvXdtq6b8IabUIwmF6pmwRCmZTsfCXKLCepL
	zQS2/T+ilS2kp9FqOBnYiI0tF/5SUOsFFf/pC/Yy+uP/JgFZ/kJ88UpVgDS5k7m5xfGKQRve974
	U/k6hzMlKXrkR3+ywQxNCyrRuWLPMWHuYv4ZJ
X-Google-Smtp-Source: AGHT+IFHvPu69hvLV8v46JK3gDouHS/oh+Msk1ox8QgY0quFrYsKcRStqL+fYhN7WRhsh7mvIZOwqg==
X-Received: by 2002:a05:6000:3c5:b0:3a5:2208:41e3 with SMTP id ffacd0b85a97d-3a6d11910bdmr10782043f8f.4.1750681229837;
        Mon, 23 Jun 2025 05:20:29 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a6d0f19b30sm9525253f8f.37.2025.06.23.05.20.28
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 23 Jun 2025 05:20:29 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Leif Lindholm <leif.lindholm@oss.qualcomm.com>,
	qemu-arm@nongnu.org,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Alexander Graf <agraf@csgraf.de>,
	Bernhard Beschow <shentey@gmail.com>,
	John Snow <jsnow@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	kvm@vger.kernel.org,
	Eric Auger <eric.auger@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Cameron Esfahani <dirty@apple.com>,
	Cleber Rosa <crosa@redhat.com>,
	Radoslaw Biernacki <rad@semihalf.com>,
	Phil Dennis-Jordan <phil@philjordan.eu>,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH v3 20/26] hw/arm/virt: Rename cpu_post_init() -> post_cpus_gic_realized()
Date: Mon, 23 Jun 2025 14:18:39 +0200
Message-ID: <20250623121845.7214-21-philmd@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250623121845.7214-1-philmd@linaro.org>
References: <20250623121845.7214-1-philmd@linaro.org>
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
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
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


