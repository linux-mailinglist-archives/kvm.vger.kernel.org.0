Return-Path: <kvm+bounces-2370-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 070047F6646
	for <lists+kvm@lfdr.de>; Thu, 23 Nov 2023 19:35:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 89872B214B0
	for <lists+kvm@lfdr.de>; Thu, 23 Nov 2023 18:35:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E855C4D127;
	Thu, 23 Nov 2023 18:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="SKtrpCam"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F4A1D6C
	for <kvm@vger.kernel.org>; Thu, 23 Nov 2023 10:35:28 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id 5b1f17b1804b1-4083f61312eso8901405e9.3
        for <kvm@vger.kernel.org>; Thu, 23 Nov 2023 10:35:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1700764526; x=1701369326; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EggnDxiS3lb3CDYKGlg1a7WOxUSv7txLuyeSgPzo5Gg=;
        b=SKtrpCamdd1fKC6FcsHrqFmRgsCYr3lryf0X9TlczoLckiUIShfSYx1GsY7BqTG03Y
         mNoyAHCIDQDaM/yZji0uFwpvj00/t6mAT70PCAI7jobE0zNSQ3/qfULqOHkgcoXMzSqJ
         czwBZ4kxEf8l4RkSHSfcV8P3cGwRD82tdlDzh9topuglmOkWGzxel38MesgSEtjOCpAE
         P5RmTPBRW/51dS5Dh4W/LWJGkxx8hXCMcIQ+x4vsmaSatSM9h6H//XB2HCYq/rTSjopk
         iDWBUOcpgSVtKmAtER0mfYlStA6id3Arb2MnpbYSu+ShGWyL5J20L9VBhrGw9mWdV+d+
         ivMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700764526; x=1701369326;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EggnDxiS3lb3CDYKGlg1a7WOxUSv7txLuyeSgPzo5Gg=;
        b=NxuxoJW65USN+DQSyF+nTnbP+KGlHPpTGfiIUdkSoqVd/9EfoUseow3PQM8R2I9ubq
         l1ARZiXLdfUJgwYCTruDuMCLkT54vtvw13Cl10JIAtt4dGHqqajo/kl2vJ/LIF4BVWvT
         SMTZgHIJHPxZQUo1MGOL+0fCjpWfdt+gw2Gk9gSCdbTPI6lHDZ9xE9RcHMXBWxN4yp3m
         +BysTV5aIZQlrg/QCEn4gH8xzLHvK1DdXHHKjuqwOTl8gWlsPvaPMWFjoOqu4S+NBS//
         Fqjw/UIVSsEeyg86uJov009zWQkAio47vVlolC4E4sGFdIYsL4SBsObeGDYnTDPf1QzZ
         QXVQ==
X-Gm-Message-State: AOJu0YzEDJmllSs+wRaa61s6jYi1fr0xlxFqAvWH26/C1eIQHePfyvcA
	lBh1Y/fCb6jthqMbexLwdPknQQ==
X-Google-Smtp-Source: AGHT+IFvWOwOd7e1Y5lDPZTFF3Xq4nOUA9yN5q2GNMAzYiEapwPBFpCHPMn1UoTV4j1koXw+yTkL1A==
X-Received: by 2002:a7b:c8cc:0:b0:40b:346c:f3f5 with SMTP id f12-20020a7bc8cc000000b0040b346cf3f5mr345640wml.30.1700764526586;
        Thu, 23 Nov 2023 10:35:26 -0800 (PST)
Received: from m1x-phil.lan ([176.176.165.237])
        by smtp.gmail.com with ESMTPSA id t17-20020a05600c451100b0040b379e8526sm2034152wmo.25.2023.11.23.10.35.25
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 23 Nov 2023 10:35:26 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	qemu-arm@nongnu.org,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH-for-9.0 01/16] hw/intc/arm_gicv3: Include missing 'qemu/error-report.h' header
Date: Thu, 23 Nov 2023 19:35:02 +0100
Message-ID: <20231123183518.64569-2-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231123183518.64569-1-philmd@linaro.org>
References: <20231123183518.64569-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

kvm_arm_its_reset_hold() calls warn_report(), itself declared
in "qemu/error-report.h".

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 hw/intc/arm_gicv3_its_kvm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/hw/intc/arm_gicv3_its_kvm.c b/hw/intc/arm_gicv3_its_kvm.c
index f7df602cff..3befc960db 100644
--- a/hw/intc/arm_gicv3_its_kvm.c
+++ b/hw/intc/arm_gicv3_its_kvm.c
@@ -21,6 +21,7 @@
 #include "qemu/osdep.h"
 #include "qapi/error.h"
 #include "qemu/module.h"
+#include "qemu/error-report.h"
 #include "hw/intc/arm_gicv3_its_common.h"
 #include "hw/qdev-properties.h"
 #include "sysemu/runstate.h"
-- 
2.41.0


