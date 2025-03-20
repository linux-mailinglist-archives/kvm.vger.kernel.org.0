Return-Path: <kvm+bounces-41617-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 09AD4A6B0D7
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 23:32:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7712916D03E
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 22:31:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B88E422D4D4;
	Thu, 20 Mar 2025 22:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="KKOdtcuR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73E9322CBD5
	for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 22:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742509828; cv=none; b=cE0zMTDY4CesypBn154Mm20Vd2ky4656QCxpSf8meTYnSqfApsEU63ANWIzrKm59KxllQehLv3eAV/IcAoHRll2ysuNGgkF2dpnYJQtTKVGftDpBqYIOeIrShIn1n7ZNa/LG0jnwj/sHip7C2MrBFyM8OvORdH1oGX86F8WVG34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742509828; c=relaxed/simple;
	bh=KuR3P7dku+j4RJkQjcmMbQhWsF+ZTERAUSX8qarQPTo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Krv82aLyfpU6QGqHShAlvfHoqxHFJUziJiWFBIJLXdLzUy7KqjGUDuTx5d8/wievZWumWf0enjlRyYaOXTvRkNCp0/qw5c/xTYvDAV2WkIoRnRgPkMgFn7M7Up6xz7TAdYeYBFpKmxDGfnsBD0IgsFDScZZFsiyfJsid1IK7Iio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=KKOdtcuR; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-225a28a511eso29432605ad.1
        for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 15:30:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742509827; x=1743114627; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z/4XryTOWm6w/MZRVd6kifOMES+Py2IKRoyOKSLgV8g=;
        b=KKOdtcuRhZKL77R0twU8Fjbp69AiGVsFAlM9EEyu+7nufhp4qBD9Y2gnoTa/gPypWY
         AHNWiVlBEWd/kzJHxSwGAhA+vsMdJMs12vWuuQT6eBG7h0kRXd4amgHhVu5/HSBj1PCb
         v/eGnU0Kfmcn5my5NEGT90qetNv1bad28ZsW1VkgLr5zDWV9j9IQg/La+TBke/LHTRn8
         99TIGgH6AT/dlJw0Y6mIUzp15pGVrCGvboTScMcbQ0g07qv0WNhwwjSMKEHyTeaiWTRS
         4kdlIbcz5VefSYXM2v43S26G+nNnbjpWR+4ZI2JPUie5+yGKpmcXyQ/VoHsPdR+rCMkj
         j3TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742509827; x=1743114627;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z/4XryTOWm6w/MZRVd6kifOMES+Py2IKRoyOKSLgV8g=;
        b=ERQWAemQBbF0dDa41NJT28RCyjXPW8sWcHIgQyhbZTLSX8ofryegaXMj3kXUWNq4Vm
         VztY1TsmPu+axZqsooSo9d7cP3U1m+pX1yjWXoL3o4VJSDsHF+REkBZs7sfXTwTyjTRB
         zsE8DuO8MLSQQIFfj2Oz/9tCHKLH/J+mDHDTJ3O6pFwP2mpPMdRrC84X24ITbbht+58W
         p01DaSBy+dB28TJwBdUgZK74NdhPnPUEL01yo4WgBUCLoFs8ZVxlV9w/AVgJGgW/AGi0
         YCqkiAAjb8OoJ0O/JbxPAVb/cjNfmv1deuH0D/a57ErUiC1lcHFfBdx/rCsIC0psCsck
         wrBw==
X-Gm-Message-State: AOJu0Yzl8qafRanKUaucC9OXbg/oRCUKseivA1uzIEcTxduMNdb04TGD
	z4udm4sd1XF/CTL2kHWfzdkck9/BQVuC28lgTwTL1+Nmwtmz2bFfuLaWN84lMX4=
X-Gm-Gg: ASbGncvRmo8+eDHzEF9JTe5jPUH3or5JCfM7r0vCmYCFysGrpbgtb+KKjOTJR5GokYn
	8Zt8sDVhQs/57EtPf+hTe6aNP9Lko97YKILROeJFMr6ufhZv3DSDXBVB20tqwkN70wYYBHh5PxT
	InpJ2ykynwHUTRLQvR5hZZNRRMG+Zb8ySskrc+1zTDSbXJhk5wt8pcnQdms1pRuRGiImodrN8/3
	32ODjeXcWVc0kx2I8X7x7y3JsW/IEYO7CHuLc/ZTePK+K9ygPFloKm9H5xurwR+XGq2IMuGYCg7
	x3NOfewj1zTYhZ0MgQJlhG5K6pAj+IMHOSaoK9xEe0ce
X-Google-Smtp-Source: AGHT+IEsmAbnRKeqDLb8Obh57hU4D8dne9W2d0POjgz1H5aMyJvN3a79EMmmYiR7WIxM0NHx2HlH/A==
X-Received: by 2002:a17:903:41c6:b0:215:b1a3:4701 with SMTP id d9443c01a7336-22780c7ab87mr14047555ad.13.1742509826750;
        Thu, 20 Mar 2025 15:30:26 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22780f4581csm3370145ad.59.2025.03.20.15.30.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Mar 2025 15:30:26 -0700 (PDT)
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
Subject: [PATCH v2 14/30] exec/cpu-all: remove cpu include
Date: Thu, 20 Mar 2025 15:29:46 -0700
Message-Id: <20250320223002.2915728-15-pierrick.bouvier@linaro.org>
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

Now we made sure important defines are included using their direct
path, we can remove cpu.h from cpu-all.h.

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 include/exec/cpu-all.h | 2 --
 accel/tcg/cpu-exec.c   | 1 +
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/include/exec/cpu-all.h b/include/exec/cpu-all.h
index d4d05d82315..da8f5dd10c5 100644
--- a/include/exec/cpu-all.h
+++ b/include/exec/cpu-all.h
@@ -21,6 +21,4 @@
 
 #include "exec/cpu-common.h"
 
-#include "cpu.h"
-
 #endif /* CPU_ALL_H */
diff --git a/accel/tcg/cpu-exec.c b/accel/tcg/cpu-exec.c
index 207416e0212..813113c51ea 100644
--- a/accel/tcg/cpu-exec.c
+++ b/accel/tcg/cpu-exec.c
@@ -36,6 +36,7 @@
 #include "exec/log.h"
 #include "qemu/main-loop.h"
 #include "exec/cpu-all.h"
+#include "cpu.h"
 #include "exec/icount.h"
 #include "exec/replay-core.h"
 #include "system/tcg.h"
-- 
2.39.5


