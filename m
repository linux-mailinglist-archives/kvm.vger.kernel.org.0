Return-Path: <kvm+bounces-41360-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E7FFA668B1
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 05:52:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 69F6819A256E
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 04:52:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C3581C4A10;
	Tue, 18 Mar 2025 04:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="BjR55Psf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A4521D61B1
	for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 04:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742273508; cv=none; b=FTbJe/M4RkuljXHgcQyMgYJeii9R1JVJt2EDqwUmNt6KrbQfujg7PxeKZCr5M7AKG2BN8cpP/q5fbIqybQc7+CTeIMutdX+g/wrzn+jLKnLM27vo4OQM/oDyJERsbYU9tePm7rUrCrxVFLB+py9FCYGLBcMW+lVWedapYMw6/Fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742273508; c=relaxed/simple;
	bh=DjgwglxYYcpzDBf0XN7Ss+nVUJWqsY+d0AHb5OrQiuc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Om6ELlosHjk0R3P8QY1ov1oC7OXrPdMeqfMm+2yXzh9zH4XbSUjoBBSjROLm62VNclOOtWItgcy9PQccugHUTQxz3A8oukUftrKraSK8uGdsSz2Vc5hWTd3Ej2jjCa84NxAZJR0qEAT8e7ImEm3CMuhS6JTAaV6/kwZLMMhJRBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=BjR55Psf; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-2ff85fec403so4818613a91.1
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 21:51:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742273505; x=1742878305; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TJs8jpuU5VHY7crNqDB8k9WdWD2PL+VSpwoAKAzM9C8=;
        b=BjR55PsfaXkfiSmjje823UdU7VGUtjbIDQRlbvb9sOT7rnIukmhnJTpgCEFNAo5Ixn
         wCRF+Q8UflbXZsV5c9lmcTSQANFX2J4yGgebtnpd8ImWvo6j222pEv8cW8zsFFHMgST3
         a/Ez0RYpWmosVqNj4sVZ1+VDV4ik/6ok7dq8m8UuJ6V50PCbyDpAC7oi2fLsY4ZAb3nw
         +R2QhO6PhQRkIXz4n8/Ns/XdL7yYrvvbt6jv7qNQ0wiFutX+Lyt8vMl6lUgouHL8DDzA
         gH0SAjt8b/A6Z8Z4ApT8te4vflHEk/lp6RjgY5PC1TH+2LouRpShH3wMhaS0BKZgrDyq
         J10g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742273505; x=1742878305;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TJs8jpuU5VHY7crNqDB8k9WdWD2PL+VSpwoAKAzM9C8=;
        b=WhsY9zbB2SpvAmXYkJjyUTSzuOP9K2WSakTd4yylwjcVWufxAOcsMw5KDkW4QXNPHl
         6ybM77KhRrAO00toMEkceVaPxmx2/ncPBzrDD1Or6Z/0BD0STEuRk/F+0m7BQrTEL397
         LiTP50hN+re2v6M/opeZvILJAnJkc8GhTFfRwEpE97B7YwR5vTXYIBBheEa55I8PN60v
         SjbZriE4GP6wxQD1ZmHbofyCKM8AYM0VvGkt2a4b74zGt9QRTAYZLHNSBPlc7W6ZbVsx
         9o3Lf20BGnscGlzxfBGtr9Gj0kRo/ijHdf/uCsheS/zD+zR4YaQXlX6eCksBM7xfB6cI
         u6TQ==
X-Forwarded-Encrypted: i=1; AJvYcCV73eDe8mJxIUnLLquH6SjqjxoiVOa4sQSi8Ii7r1V7JvdC08lyZpELenI1lqYGMJC8iLY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwIjB/jWHP4qMpKX2sq36rh2Y5wWbhCXylbtq1ky0jc34wzF21R
	Wde7qOuLj58KrPQVPNSZZQfk63SvKLtA3VRqFNnnMXZ1lEMGEPcOLmhU94YO6qM=
X-Gm-Gg: ASbGncv7oXlUhk8c0jxhA9DOE3FKjS7gjPqz+fUrE1vrMu1HcR2v4nyYh+mLpN6HC/l
	0lMyZl40oE89ZtSRR/fInnB91hkhvptTbHQoO3t3zcISTVTsRncnhCkyvwWWrpRL3GpUcOJ7dqa
	/v/9zM+ZfwKmJ4EJNp2hcxRSJvhItDICJPlLqGId3a4sRIX0c4WsDbHBiwATGsjy1qRMqhvyy3e
	bL5HwkulAPMym/+G1PBzVQfbl/xIO5oRfSxxAC1cMr82Gz5Fz78/pzhsv2OtopxitlMGcjjmJt4
	RpkxaHCDI3dRdLOiGCP0UPbwlYDRRzWG9ywQJsq9fiD/Sx0R1sBzYd4=
X-Google-Smtp-Source: AGHT+IHEmBiDYdH8DpN4X2712XG3vEXoAh58XN6VBOwchF+ihZ4rs3b8Wb2Qrcz+iN/AtHC1fq47cw==
X-Received: by 2002:a05:6a21:1fc1:b0:1ee:a410:4aa5 with SMTP id adf61e73a8af0-1fa50bd891emr2581469637.17.1742273505380;
        Mon, 17 Mar 2025 21:51:45 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73711694b2csm8519195b3a.129.2025.03.17.21.51.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Mar 2025 21:51:44 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	qemu-arm@nongnu.org,
	alex.bennee@linaro.org,
	Peter Maydell <peter.maydell@linaro.org>,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH 13/13] hw/arm/boot: make compilation unit hw common
Date: Mon, 17 Mar 2025 21:51:25 -0700
Message-Id: <20250318045125.759259-14-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250318045125.759259-1-pierrick.bouvier@linaro.org>
References: <20250318045125.759259-1-pierrick.bouvier@linaro.org>
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
index e296b62fa12..639f737aefe 100644
--- a/hw/arm/boot.c
+++ b/hw/arm/boot.c
@@ -23,6 +23,7 @@
 #include "hw/loader.h"
 #include "elf.h"
 #include "system/device_tree.h"
+#include "target/arm/cpu.h"
 #include "qemu/config-file.h"
 #include "qemu/option.h"
 #include "qemu/units.h"
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


