Return-Path: <kvm+bounces-41914-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 26563A6E911
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 06:01:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3AFB83AAA85
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 05:01:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C46BB1F30D1;
	Tue, 25 Mar 2025 04:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ey3Iq7uU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E8B61ACECD
	for <kvm@vger.kernel.org>; Tue, 25 Mar 2025 04:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742878787; cv=none; b=Nf0AQRlsYC2pN4PNMGy4Upai8YXSkTWQ0qWjt2kfw25jYBG2G4JiEE4phQi2FOuybTlJ6fXAys3+X9wsKNfLav20+bAAnGzGZjJD1BvfsbOTd7uNgaVVq5D0tIi25oVbqFGIFnSrOBaV69Oq3EnIreWKHknpwjQ9Ib0ajNEseuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742878787; c=relaxed/simple;
	bh=A89J5P4+ERiVfgcs92/c8Ae4eH+BZRGQ6Or51KFxkOA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QNmIxiZZqiDkmdaiVU5UagJxl8hPRi8mfGlBLlAZQvoVGiY+OXcOJfVsbzXBIUyLQAwSFbThIsgbx4+C3L/kMb5GHhP86eXvGGsy2oG6UafXMiZGHCsBuBeaA2GM9ituYmoRWP7z6O04NjpWSlcYHmVlTQjl2k4wolX9euRvd/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ey3Iq7uU; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-3014ae35534so7976919a91.0
        for <kvm@vger.kernel.org>; Mon, 24 Mar 2025 21:59:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742878785; x=1743483585; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZFUKmZL89sYZSB0AC07VWMO1RZJQlXSAYHwQi6w+77U=;
        b=ey3Iq7uUNzGDHXt1P8HdTvEbfmAXOyPlds3rHhfVv63g9QRSxcJHn4UjHnqaH5RQgG
         8lPVZDXvEtugMnCsl6BNNnQpxF2UkwKP3WT+CjxZGoiTPwNCK+1Z4MZMfwNyO82ki4Ix
         F8QuM60nnV18CVj2QfN0gCqREjdFGjK71Z+VGBi2UH7LvtazrsVbnKBZG4Dg6WrTYhIy
         6aZldGU1VZAv00vFzgjwYyrKEH0zt8YUT+B5X6J5VjEzhYMsiwtFqk7JDcyhiQA7trvZ
         ByhCScNMwwCCQGZTvs/a0IvxP8A8TlWIiVDSBPdkfqKm6A/+dQJvRYCNJU5cwLdktL/g
         JNTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742878785; x=1743483585;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZFUKmZL89sYZSB0AC07VWMO1RZJQlXSAYHwQi6w+77U=;
        b=NpWqyH0wNPETQmrMoavtq3C1QcAJLW6m6FhD7PBOCDLjjnQ7aRbYx9d+nFGEn47P9l
         QriYGWxu99w/4zvLFX6/F+CT+F5Km44m96tp7bTfc1ddGoRPwdCtpOSIE+UyiJUcSMTv
         tZu+aeRNF/80zY2C4nIRboiZ7jFhannzVf7hfgm0MpM/Fq0JQL7z0LEkLjK8gmBPAGHB
         ScVS2Omo3hcNhwwmnKeB6CMVMVHwsGyPIu5RpBIPNOT9TXOJ3PQNh1+c+tnzuok5PRLc
         V7kU3c4JXoYIyC+zi7IZ5qJVbDcGmz/pgLeqkcJCulWb25q/N0HA+OaegDxNOJjFXPR8
         3odA==
X-Forwarded-Encrypted: i=1; AJvYcCVOwlL4KgdT5P+ggkJlEe3ZHZhMr8V809W6qbGj0QLoOEsVQnmKcIxW2btNrCeJuio+vfk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzmYmfUIRN99mkHRn+wDK8DGODYtsQgmqBBV1/Wd3XaYMhte7SE
	Hw8zfZcLE5RXanVFPgBbjArhEh8bvoX6726JpohGsftrf3PhW9Qgs2ZGm4IPeg4=
X-Gm-Gg: ASbGncvREcNN9v7vKJpdQFugBm/8Ey6kUbVMjnm3zX7Y8TdVIi6i+DIjatbQiog8pce
	2QSGqvjl8AmSPnZMN9iPB4Fj6S8sfJ7lSk1tjxG0YD4LnDCtifA4yN0ezc3QKE8Yx8S7ErdbRR4
	ry0Cy1kvruAciwcctcVW5HpqG115l5nN1HW39R0sBY9R8VWjqrCyR/AzzNvKSZa4lqAXGGo/Sgq
	ZoSL3bMhnTaB/Lqf9Qb1igK34LmuaAl8kQKbvuekDZEB/Jmjn3+DTkPPG9mL7/eXncH8cf5n4rl
	fRL7x87+8D73XwUOtMC8tCI7+pEC374BPXzv66xPWcYF
X-Google-Smtp-Source: AGHT+IGzn0ZGA2yyhJM9CpgiHL9SBWuGcmvmqiHcbR5yuPfCRFgOow8H3weAwCmoy8McjCHWxqFWgA==
X-Received: by 2002:a17:90b:2747:b0:2fe:a336:fe63 with SMTP id 98e67ed59e1d1-3030ff10879mr26301744a91.24.1742878784581;
        Mon, 24 Mar 2025 21:59:44 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-301bf58b413sm14595120a91.13.2025.03.24.21.59.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Mar 2025 21:59:44 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	qemu-arm@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	kvm@vger.kernel.org,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v3 24/29] hw/arm/boot: make compilation unit hw common
Date: Mon, 24 Mar 2025 21:59:09 -0700
Message-Id: <20250325045915.994760-25-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250325045915.994760-1-pierrick.bouvier@linaro.org>
References: <20250325045915.994760-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Now we eliminated poisoned identifiers from headers, this file can now
be compiled once for all arm targets.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
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


