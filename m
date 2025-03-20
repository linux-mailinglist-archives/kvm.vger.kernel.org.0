Return-Path: <kvm+bounces-41628-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A03EAA6B0F0
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 23:33:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7074D3BD95E
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 22:32:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02F5B22D7BE;
	Thu, 20 Mar 2025 22:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="CavtcBHq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC0352222DD
	for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 22:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742509838; cv=none; b=GzmSIAdlKCWRCP3TuVG0jClhNImMB+56IOr/gggOspU47LVO/P7AVlHprBHC2gGH3KqNWY6gm0tA25ZGSL81wpGsWcXRaCXN+8T693QbjNEMVpOgJjqVk5UDtDuRGx2nlui9SH3CeRqvWEZdcL6QBR9+oATekcv941IuP3BCHSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742509838; c=relaxed/simple;
	bh=cCgQ1iv1rpyvtEQBDxwwLHmPnp6McSiMDewZMYyVGl8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Kg8NJ5LtlOPxdPyM/RRk98O86Y/VkRkTOA+gawxex1+8iTd3itE8WQnXEmC/hQHE8DjqvYEJ9RBF8H1VYpR2107o6O5vJEWt7uSaBcHgXoDeihYYFkSZAvKJvhAnOUM5vIIu2avrSSg7nzZG/77hNSnzrqnj2D15PTEtl8hR9DE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=CavtcBHq; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-22359001f1aso33500125ad.3
        for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 15:30:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742509836; x=1743114636; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fL3ZYVUJJ3Fd0+aNoGxPeRJrA53EVcQamm5mrQ+p0v0=;
        b=CavtcBHqOWp1pUwaFSH9dGS6LnXmqnjAfAhtpbHTTAcPfUqNqaVtJ8xVKWzSCabA7L
         LT0KpP0QTBlDxDDvHiEWxrXnEFogws+7aLuIFUaHjtbOp8DQ/fefBmjVMVNcoGeh3o9J
         ldrA8HuszeoOuHun2waOWXSGM5FgB+Bv8A8aGuE/W/m81phEWPHnUt1mgBYGgxeG6Cfk
         F3m818IefDmG00dHaUUK3AgLe72k5ih1ww63KnzaJa53NAJ/OFE1XiWYCpmz55heSyOZ
         cvky3DMA6mncO5gXqKMjjocnRr58jdURnZgOLDGTu9PxelZXmFPMf517MFKitGGmvcWl
         kXCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742509836; x=1743114636;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fL3ZYVUJJ3Fd0+aNoGxPeRJrA53EVcQamm5mrQ+p0v0=;
        b=vAe67LQooBZGuTzRpaQ2Zjq9rzWbiTDC6+U6rvCl5ldqhPo6b1wQcWa8l7V1SxHxoq
         cvtIPbu4iucrbV9/GS2N4992oM51EY0/2kiAfnwlfDwL/bG6RH70MA06jT8HxBY5NvaH
         Sz2+dZIyCv/aOOeODiyBaVfvdtrQduoIa7nTcw0jWfUQpdJ7cLCftbCuIrK8hNRBbT19
         pjw/ylQ8G3RvMX9v3hYuDZQzVYumc67o7e2vtD9waO56mIqK4dcQS/+B/R6tui+6SD01
         EYUQbW6FTKxQErkCtOIZ0cPs9qIthQVPWzyGYbZBTUPoINs/K9Yo5lzczIsg2HuBfXFJ
         q7sA==
X-Gm-Message-State: AOJu0Yz05AH3WReoESaJVDjpqQyKMaO1C0b+PRmB9An3OPz2fi+OeWMx
	/HsW5VFzp5IQDPcULI/yRUMqs6KO7dopmMf4IekTM8PVZqTMtO4wv8uBKjKh6dc=
X-Gm-Gg: ASbGncvbbGb6PXp9GHwdmsO4vxcuMNhgceMC16W7IF7Ms75gpxAod7MGx7MwGdEZ0Sa
	PfZ6wrI7n4cK/nqfCIx3SkfUM7opmzrskfqliGIjuqOX8htOfQTerV+1QqJef6VJVFOpJJe2/3c
	pYKCBANW/A7+HcqIIiPWH++BGKBA8conGWKZLJpWgb8Vtj79qMJYGlDCSb7dKWE1HtkACsDhmN+
	rLctNOs0VXTg9hapwXVtcCj9qtNLUtapgCNWgt+JA2GMl1MkNqhhrGeuXD3kKUyvJvQsnAip7oj
	Jp/30DVvfSNX7dPdkgqKMsE67OdV0PoO1GY+cONciNYY
X-Google-Smtp-Source: AGHT+IFSTCeT7YVoPbAHuUe991xoUWlgfGrS/bDdF4/Ez/lU2sHP5ScxJ+1FSK8cU5+QipVe/utZzg==
X-Received: by 2002:a17:903:250:b0:223:635d:3e38 with SMTP id d9443c01a7336-22780c76135mr18937465ad.15.1742509836244;
        Thu, 20 Mar 2025 15:30:36 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22780f4581csm3370145ad.59.2025.03.20.15.30.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Mar 2025 15:30:35 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org,
	qemu-arm@nongnu.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v2 25/30] hw/arm/boot: make compilation unit hw common
Date: Thu, 20 Mar 2025 15:29:57 -0700
Message-Id: <20250320223002.2915728-26-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250320223002.2915728-1-pierrick.bouvier@linaro.org>
References: <20250320223002.2915728-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Now we eliminated poisoned identifiers from headers, this file can now
be compiled once for all arm targets.

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 hw/arm/boot.c      | 1 +
 hw/arm/meson.build | 5 ++++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/hw/arm/boot.c b/hw/arm/boot.c
index d3811b896fd..f94b940bc31 100644
--- a/hw/arm/boot.c
+++ b/hw/arm/boot.c
@@ -14,6 +14,7 @@
 #include <libfdt.h>
 #include "hw/arm/boot.h"
 #include "hw/arm/linux-boot-if.h"
+#include "cpu.h"
 #include "exec/target_page.h"
 #include "system/kvm.h"
 #include "system/tcg.h"
diff --git a/hw/arm/meson.build b/hw/arm/meson.build
index ac473ce7cda..9e8c96059eb 100644
--- a/hw/arm/meson.build
+++ b/hw/arm/meson.build
@@ -1,5 +1,5 @@
 arm_ss = ss.source_set()
-arm_ss.add(files('boot.c'))
+arm_common_ss = ss.source_set()
 arm_ss.add(when: 'CONFIG_ARM_VIRT', if_true: files('virt.c'))
 arm_ss.add(when: 'CONFIG_ACPI', if_true: files('virt-acpi-build.c'))
 arm_ss.add(when: 'CONFIG_DIGIC', if_true: files('digic_boards.c'))
@@ -75,4 +75,7 @@ system_ss.add(when: 'CONFIG_SX1', if_true: files('omap_sx1.c'))
 system_ss.add(when: 'CONFIG_VERSATILE', if_true: files('versatilepb.c'))
 system_ss.add(when: 'CONFIG_VEXPRESS', if_true: files('vexpress.c'))
 
+arm_common_ss.add(fdt, files('boot.c'))
+
 hw_arch += {'arm': arm_ss}
+hw_common_arch += {'arm': arm_common_ss}
-- 
2.39.5


