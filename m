Return-Path: <kvm+bounces-44157-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E998A9B07A
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 16:18:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 095063BD373
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 14:18:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E236628A1E3;
	Thu, 24 Apr 2025 14:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="aH33Dmtg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEF7E284B36
	for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 14:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745504045; cv=none; b=I6MeZubFLJPDnffvdSZ80qUe5A+uOyITXurr+99ZVYHWFNeuqy0NZgi7Uq1OTuIwJ1LdQPGL9COJgEbQGFULDoxuxVDxX12VBRIAcJJAknNhr+787UtcBV663siGCFa57j+JVdlz0uydVzjwMGwh5J/kayGg1iUkp/3cdvAZVqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745504045; c=relaxed/simple;
	bh=sOc+WgCBKAU0O5bB7WH2YBqY9uNwSXL1/wb8/ZYbbhE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EyEH7+4gifGenPY/Yd6oYlQkNJLC7AMm6H5QziGoT+UeQEpPHNkCYN+eDavr5Pe03oyldAK00f9gWian3OuNXbMKeXdeADEl6D9vHWqMfYZWlMe2cKhedCYil/gR6PW4D5wK2Qj/TPBW3uyMjuDSRII0Hs6+K8FzNCz5v82AhC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=aH33Dmtg; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-43cf58eea0fso5047345e9.0
        for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 07:14:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745504041; x=1746108841; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OmKgb2P7k7ka3054x1IngydlF8noVj1FtGkMjW5J68k=;
        b=aH33DmtgkOHqP2hwtI+u07WChhA2Fulbri6fmZWxNnrjT9saYqe/QqBtRtVXhmy4mf
         Z5EXAZ1d8kblBZtjPBBu6of5eGkEaIx6RxIM9ZAoY2QreLBNLypaWtkE8SgCw+Wwy+Lq
         beDcf6VKK7dfLO+SfEVGqoj1kMDTW32GRytELD1r9HRvEyNagr0FTcQEYNenN8TqHsUG
         LFjBtao9OX7HlFxQGZdHxETlqI+oCLtPuZARLhzLK1ZCNKjga90rDDb1brJbUzGiqGbm
         T7SnEpgHWa6qYBz/iWUCC88dfhzIHxczzTlYdnXNwhGuJRDXB2Kp3M9orQuiHaRDkKCl
         QaZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745504041; x=1746108841;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OmKgb2P7k7ka3054x1IngydlF8noVj1FtGkMjW5J68k=;
        b=T84ZzMcrF4KyO1LVzdifb6sjvdUgaFKic6p7wfzhpRd4WIDD9fPqh1+5tzBcP3IA8M
         ukIVUT67syodjYbM+GzJE2F9Yo12BcDBCau0f5qoZW/0Nc8BmQIjhvHzhU8bqsDClxMu
         TtvqTahTGLBvxUMjKrLAwcCFKJFL0wEyDfUSkGPrvHLep4T7nl4RrekaQMtUJsNHWbGg
         DvgaXlEVXWH2OZ4P2VvLlJoMnBVdxVH1WfkjVkAUTY8b34l80TG9NW2xmcDUfUXNMMAS
         9EMtfBXPujKIfOSKAnt4Im6aUWlvqpaqxv+AsbRY5AiB0W5KBAWB0DL7AcGYvH3M0UoX
         Z+lA==
X-Forwarded-Encrypted: i=1; AJvYcCVIP/Nzr+ypfamwkTJcEWnGlXHKQstf0B9Gb7Ueod4bRp39gdA086h3zvVR1Kevx4XvwBg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyK28f9Kga1FZXL2nMppXD522IL3T0jKrYfgaQULNdTaPdjN5R+
	8+wTQ5nN6t+brAXNo6WNo9XoWLk1Z8tkxg/yUy4ZaEps/mOZ7eFlPPPKPJog40I=
X-Gm-Gg: ASbGncux9n4UcSPzyx8QecBgiZu/rNXz5eOQJ9/rIASmcAvFiCEVyNhX1dtSQRic/mU
	zPa4ImHt0HKUEeHNYbsNjonPSDWMOW6PIxH2QZ/VI1RUYj5QZD5cvCnf8JgvPFy/CR1DxB+CIVC
	Bq3ws7kqO9aB7HqXL35slHGGIuPBwG5IHYX9X5Ts7aFQleE/XHwcOb1RmN5h72dHKhP6Xiy27pc
	MJGHkxy30U4IivUHu7mbodGC5ODN4cIDbRpPA23Zy+s61enrMrpROMKA9xIosKDu/hltUktL3KT
	P+vIh49erzwIhrk6gddU+4EScHxtQzZK0YVDk9GCcqMcSbR7zeNVexvuwR8JTzzv+BvJdD2DA1U
	tWKWlVZ3whYQXtFdWZAbRiKZYq+8=
X-Google-Smtp-Source: AGHT+IGfkZ98OulZ0pJYU5c1ld+aBqoKjFuSpgzRjo7Jvo/4HTkJCAjHkRJEje6F6WXTnu8CxQELEw==
X-Received: by 2002:a05:600c:3b0c:b0:43c:e8ba:e166 with SMTP id 5b1f17b1804b1-4409bd83db4mr21261755e9.22.1745504040937;
        Thu, 24 Apr 2025 07:14:00 -0700 (PDT)
Received: from seksu.systems-nuts.com (stevens.inf.ed.ac.uk. [129.215.164.122])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a06d4a8150sm2199951f8f.7.2025.04.24.07.13.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 07:14:00 -0700 (PDT)
From: Karim Manaouil <karim.manaouil@linaro.org>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Karim Manaouil <karim.manaouil@linaro.org>,
	Alexander Graf <graf@amazon.com>,
	Alex Elder <elder@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Marc Zyngier <maz@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Prakruthi Deepak Heragu <quic_pheragu@quicinc.com>,
	Quentin Perret <qperret@google.com>,
	Rob Herring <robh@kernel.org>,
	Srinivas Kandagatla <srini@kernel.org>,
	Srivatsa Vaddagiri <quic_svaddagi@quicinc.com>,
	Will Deacon <will@kernel.org>,
	Haripranesh S <haripran@qti.qualcomm.com>,
	Carl van Schaik <cvanscha@qti.qualcomm.com>,
	Murali Nalajala <mnalajal@quicinc.com>,
	Sreenivasulu Chalamcharla <sreeniva@qti.qualcomm.com>,
	Trilok Soni <tsoni@quicinc.com>,
	Stefan Schmidt <stefan.schmidt@linaro.org>,
	Elliot Berman <quic_eberman@quicinc.com>
Subject: [RFC PATCH 12/34] gunyah: Add hypervisor driver
Date: Thu, 24 Apr 2025 15:13:19 +0100
Message-Id: <20250424141341.841734-13-karim.manaouil@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250424141341.841734-1-karim.manaouil@linaro.org>
References: <20250424141341.841734-1-karim.manaouil@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Elliot Berman <quic_eberman@quicinc.com>

Add driver to detect when running under Gunyah. It performs basic
identification hypercall and populates the platform bus for resource
manager to probe.

Signed-off-by: Elliot Berman <quic_eberman@quicinc.com>
Reviewed-by: Srivatsa Vaddagiri <quic_svaddagi@quicinc.com>
Signed-off-by: Karim Manaouil <karim.manaouil@linaro.org>
---
 drivers/virt/Makefile        |  1 +
 drivers/virt/gunyah/Makefile |  3 +++
 drivers/virt/gunyah/gunyah.c | 52 ++++++++++++++++++++++++++++++++++++
 3 files changed, 56 insertions(+)
 create mode 100644 drivers/virt/gunyah/Makefile
 create mode 100644 drivers/virt/gunyah/gunyah.c

diff --git a/drivers/virt/Makefile b/drivers/virt/Makefile
index f29901bd7820..ef6a3835d078 100644
--- a/drivers/virt/Makefile
+++ b/drivers/virt/Makefile
@@ -10,3 +10,4 @@ obj-y				+= vboxguest/
 obj-$(CONFIG_NITRO_ENCLAVES)	+= nitro_enclaves/
 obj-$(CONFIG_ACRN_HSM)		+= acrn/
 obj-y				+= coco/
+obj-y				+= gunyah/
diff --git a/drivers/virt/gunyah/Makefile b/drivers/virt/gunyah/Makefile
new file mode 100644
index 000000000000..34f32110faf9
--- /dev/null
+++ b/drivers/virt/gunyah/Makefile
@@ -0,0 +1,3 @@
+# SPDX-License-Identifier: GPL-2.0
+
+obj-$(CONFIG_GUNYAH) += gunyah.o
diff --git a/drivers/virt/gunyah/gunyah.c b/drivers/virt/gunyah/gunyah.c
new file mode 100644
index 000000000000..3e795e3ba881
--- /dev/null
+++ b/drivers/virt/gunyah/gunyah.c
@@ -0,0 +1,52 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2023-2024 Qualcomm Innovation Center, Inc. All rights reserved.
+ */
+
+#include <linux/gunyah.h>
+#include <linux/module.h>
+#include <linux/of_platform.h>
+#include <linux/platform_device.h>
+
+static int gunyah_probe(struct platform_device *pdev)
+{
+	struct gunyah_hypercall_hyp_identify_resp gunyah_api;
+
+	if (!arch_is_gunyah_guest())
+		return -ENODEV;
+
+	gunyah_hypercall_hyp_identify(&gunyah_api);
+
+	pr_info("Running under Gunyah hypervisor %llx/v%u\n",
+		FIELD_GET(GUNYAH_API_INFO_VARIANT_MASK, gunyah_api.api_info),
+		gunyah_api_version(&gunyah_api));
+
+	/* Might move this out to individual drivers if there's ever an API version bump */
+	if (gunyah_api_version(&gunyah_api) != GUNYAH_API_V1) {
+		pr_info("Unsupported Gunyah version: %u\n",
+			gunyah_api_version(&gunyah_api));
+		return -ENODEV;
+	}
+
+	return devm_of_platform_populate(&pdev->dev);
+}
+
+static const struct of_device_id gunyah_of_match[] = {
+	{ .compatible = "qcom,gunyah-hypervisor" },
+	{}
+};
+MODULE_DEVICE_TABLE(of, gunyah_of_match);
+
+/* clang-format off */
+static struct platform_driver gunyah_driver = {
+	.probe = gunyah_probe,
+	.driver = {
+		.name = "gunyah",
+		.of_match_table = gunyah_of_match,
+	}
+};
+/* clang-format on */
+module_platform_driver(gunyah_driver);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Gunyah Driver");
-- 
2.39.5


