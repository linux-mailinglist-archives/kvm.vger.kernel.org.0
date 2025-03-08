Return-Path: <kvm+bounces-40501-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F4151A57FA8
	for <lists+kvm@lfdr.de>; Sun,  9 Mar 2025 00:09:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1FCA716AB75
	for <lists+kvm@lfdr.de>; Sat,  8 Mar 2025 23:09:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9542B1F584B;
	Sat,  8 Mar 2025 23:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="V5mgZfrY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05714C2FA
	for <kvm@vger.kernel.org>; Sat,  8 Mar 2025 23:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741475369; cv=none; b=OdY8idiD3nnZwerBnG/DYYJS/fmwgNvmR1j82QjIJoSQ0rkAGXia5BNtBS0OmUNA/+0gL4qkzB2EtjW2SHRKR5Y1pmw1hNmFndXl+ma51cjy1Ajn+Bd3UdKQFVcIf03TzzEutX22PgLCf8Ybv10Bez+Vtzmhs6bmUoG+8zIw/7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741475369; c=relaxed/simple;
	bh=F+ZRtaTij26jduiPWk0rWAIbayT52I5DJ8DhJzphAuM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tPj0gXJZ5BBBM79tlrVfSK+O+3UsBeL7rQACA0+KkZNv/UOgPnbYKargTcwx+ZqirAN3uwxlPohBH9/Ah/u9hdiq0HpUsqmUyxYhNWIUHbQ171+2g1CnOSL1eajvM/fHDJ+iJ4sMEllqaZA8wXEqEbOBTshIG1NH89aYlOn26Zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=V5mgZfrY; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-43bd45e4d91so17609795e9.1
        for <kvm@vger.kernel.org>; Sat, 08 Mar 2025 15:09:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741475366; x=1742080166; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qxj25K64APubIeBFvAOvHKODmgZUFRmHVHXhc1AU81U=;
        b=V5mgZfrYKf60ULQa5pP1R2nlsTl70/I7Udyn9ICrYZ+TjpPdvY/9faukqZc8rET6XR
         mfD9htMoKYSYTWJzY3na5Hc8ETO6J7Okdpe/wFFmDlkXGgcqRE0o5ETLnNLs2q3zm2iT
         6wq/ckcrAZTnW4CJ81KZUB58/6DXP2X73bPqDH5JUkmZyPno2aJ4hcvPZsfSYOIc7x1P
         yYVAcXnN93Gf5h8s2T2hbQslvOU2QQnsdxvkAOAZROWHe8GhBN43WJr1p5wCNH+Rc5SW
         MPDHCGNhTfFwfSchVVfdLEE/JKshjBLiSwfKasfS1qYZ4+i7NEVlcHhE/ZWglbQsadRn
         yS3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741475366; x=1742080166;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Qxj25K64APubIeBFvAOvHKODmgZUFRmHVHXhc1AU81U=;
        b=rvSoXfupwjnwJcOB/yap+Fxck6YVLY3DXvBMQdnMZfS8ziu2c5JtEYbqRo8d+dM+1M
         TO9kD5xArv+ekpxusHP8251u+rniEZwshpjpixQYpeuUEkQTWwXWwA2xTTQgzzcif9mT
         J4TdVttFaIABEqZB6gZ+qZIJsAmjgpIzO9JXgTQP5EEHCMi5WE8kb6dXABsWVW/XKlYf
         Sl4wukULEtWZ2/o9bf2tc/Rmkn6H5i8BC57fsl9BAKFXBidtvm+rWc+aUl5rltBws6Lq
         XgdxvpQ+CxVuRtD5H9NnYH5L2fqr3LrWBylD02zc/ooZRnEq2kqAhiaIaZ2jesOOeJVF
         jjvw==
X-Forwarded-Encrypted: i=1; AJvYcCVmnyi/WlFk3G0IjTnk7vmXMrupIJTEo75TrN51QbqKBgfmpK5Nv0ZnCEPTppuuKscPNMU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyVUnXBebc6PoJOSVDRZKBAdjybAvwPWmfbmUnleNpX2H0m5PgF
	YsC7Tkk5pnK6oFxEwfCy8i2bcXpCdYs6Z06ry/LhaV8YaiKCFN+V2nK7n+FPCUc=
X-Gm-Gg: ASbGncsjFMiIN06mOCVWuHkabjuE0UtSMvOmClaEoDf5+SZ0oep2qTDfCAotpAlbcxN
	rRURAYLWQYkc0LFZ2zFX8pP3dh0wnzT0W33slvFcxKCbgfCQpWdGetA8m4mteoqdBF6lqVMPiVW
	2+0d+Kk7amdhEGvcnX6Z/lIG3vFx/zRLPVR0FKCDKBIOVOliYRVwe9grG1LyZf2yDlQsOwxhjg+
	ybwECF9ElNMpb0JYj0tWLtGxcRXAjgWMlDIwOqTvI4OcGS7zbFEdapuip/uhmBdhiD4A2HpWGii
	kkhr762otKdDjqJirSyqp93MY3k5EDR0ur7NyrywPDy/l1GN8JTiUvFu9O3u4d6Pw14vT3cl5de
	Ln2ELdqRlKiromCnMArg=
X-Google-Smtp-Source: AGHT+IHJ0NS/FfGXlmf4jylNvapCrpoM4pkS8c5smWzHWxpj3jWgC5iW6aWgueYm5DZwov9rUe2K1w==
X-Received: by 2002:a7b:ca53:0:b0:43b:dcc8:557c with SMTP id 5b1f17b1804b1-43ce4dd640fmr29552115e9.13.1741475366165;
        Sat, 08 Mar 2025 15:09:26 -0800 (PST)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43bdd8c324csm96428385e9.12.2025.03.08.15.09.24
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 08 Mar 2025 15:09:25 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Yi Liu <yi.l.liu@intel.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Tony Krowiak <akrowiak@linux.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Thomas Huth <thuth@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Tomita Moeko <tomitamoeko@gmail.com>,
	qemu-ppc@nongnu.org,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Eric Farman <farman@linux.ibm.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Peter Xu <peterx@redhat.com>,
	kvm@vger.kernel.org,
	Zhenzhong Duan <zhenzhong.duan@intel.com>,
	qemu-s390x@nongnu.org,
	Eric Auger <eric.auger@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@redhat.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Jason Herne <jjherne@linux.ibm.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v2 01/21] hw/vfio/common: Include missing 'system/tcg.h' header
Date: Sun,  9 Mar 2025 00:08:57 +0100
Message-ID: <20250308230917.18907-2-philmd@linaro.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250308230917.18907-1-philmd@linaro.org>
References: <20250308230917.18907-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Always include necessary headers explicitly, to avoid
when refactoring unrelated ones:

  hw/vfio/common.c:1176:45: error: implicit declaration of function ‘tcg_enabled’;
   1176 |                                             tcg_enabled() ? DIRTY_CLIENTS_ALL :
        |                                             ^~~~~~~~~~~

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Reviewed-by: Cédric Le Goater <clg@redhat.com>
---
 hw/vfio/common.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/hw/vfio/common.c b/hw/vfio/common.c
index 7a4010ef4ee..b1596b6bf64 100644
--- a/hw/vfio/common.c
+++ b/hw/vfio/common.c
@@ -42,6 +42,7 @@
 #include "migration/misc.h"
 #include "migration/blocker.h"
 #include "migration/qemu-file.h"
+#include "system/tcg.h"
 #include "system/tpm.h"
 
 VFIODeviceList vfio_device_list =
-- 
2.47.1


