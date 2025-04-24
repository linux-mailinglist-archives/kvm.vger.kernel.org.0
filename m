Return-Path: <kvm+bounces-44155-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C6902A9B075
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 16:18:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 501307B3A6C
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 14:16:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 163C4288C89;
	Thu, 24 Apr 2025 14:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="j9+iKa4W"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F14262820B2
	for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 14:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745504042; cv=none; b=sKZOqLxtTFFKkMPnianMybHDJMXmcmvjY0Q3pLvbAc3jJrIm2yXBmg620r/pibwBhugu8KdV/t4GLQ+G8rvK4qm8SBJy8GfR+U14U6A3JpNGxPD3hyxj07knKxDlSrqFRi7qSPVNsA875cEQWZjPC2cNqTpeqLgOZZ5Fx0A7+3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745504042; c=relaxed/simple;
	bh=zpH5RWwn66pK/eMc3LSMNEkV/3yaevWoUA1/kvmrIcs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=AiEg1T9W95ZjjjIpmHj8yrdEDLTbxA5voMAWHdq0U+GZmSFx37f8B+M0xNh0p2VE4IVvSHBdL9ku7CHCdWL+yviWXewtfEI3jvPvypcchVWD63OZc/gRd8aZl7oSmDQe71jiKoNi2S8mpJXtTu+xXkmAOmjQaN22Gz1g7Phtvbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=j9+iKa4W; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-39ee623fe64so1026440f8f.1
        for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 07:13:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745504038; x=1746108838; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RusfJk/Wwgs+hfa3WlHRZBdqt7Zg7qYVP8LFIn+weQg=;
        b=j9+iKa4WCT/mz4U6jOuEjxqBAIM17fNBuPra7vwuEWL0QXoKe6DkDeChGdfSfN2jqZ
         uCaRbiExMKGx6vkJmOf6uDYYMezLzUdvO3PzNablg6nTHG7sKC5ygO7dxRWP12DQb/Lo
         ncNWWVX00LNc9y6vT9WTBjPdHkjhCEe1ppVdr+2tyhjPTJf7tIR0lHWwMgINoRHhtrzz
         KBZh7idT029V7GaVEdLIlUlagIvjMV72pL5JYshgff1oMFthqajbTK4j6rmb1Xy/vP62
         O6qovaWNGZ14gRNMMC0hn7jK7GW9RnF132Bax0dN4BK/6ziNhLy/woVUD4piL85of4bM
         P50g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745504038; x=1746108838;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RusfJk/Wwgs+hfa3WlHRZBdqt7Zg7qYVP8LFIn+weQg=;
        b=M6fhha29o69IOJKw87KOMsQH8NTlystGRCbHu0TCSdfuAHLQ/NVmEt9r8eYJM3e5G0
         +3SjHL2/3zZVgxuNTBNGhVghgbyjopK0WjMQ5yj789HU0H7cg1M7n5EykQQNb99Nya/p
         jX5F4zSKKAZeGnQS93XpZYP+ed7HXRLzQYIdaFOy8tHGo30jCfJ989XF1Is1EBWGtJxU
         iS2afUiMEhDhF0wqfrKl82mczNa1CeHQFqDHDrYp6iQbnrJaR4OTZwnk9IKYiq726toK
         eOEu6d43bAOhodr5rEjj27ghMhfxQtWu8v6Cwm8dsNpQeet2pL+wWThw+jHhWsmCjhFE
         xClg==
X-Forwarded-Encrypted: i=1; AJvYcCWLPMPDUeO9x918E55582Q+Dk9Lka8HTtlLycYAOadeKXcI6GNA1PqYqqHWSCiMn1FQ6II=@vger.kernel.org
X-Gm-Message-State: AOJu0YxXFSXzq31RC2WtBb3ML8AjAFvn56Ujhq9AWueHLNyBm+AVS+BK
	ww398Re4+WBSuKgEsivHSUIjX1RXByNj6SVsIBDk94XcG311BIBfTVy5lllt/NU=
X-Gm-Gg: ASbGnctKr9Z+B7Tbj+jmHVgIDhzVNVkoZb3ixodd2ddrnrpnpNBDXrXtnxsl8sJqBDH
	fBHqeOyHgdOQAOj6sXpmWgQ5yQ10hxRe0xNsXtB0KADzDEn2qraLdBcCgi1QqczwfBRg4XhVC2h
	FVwCH6ApO0GYBy7R6L8Efi8JbbXGDmnXTFjgbXhmsn0bAA1YUGDyzQnuEkOMvVkABm3KsLkuM0a
	7F78EE4LKiEWWy0JTbse2k3EqMYoHbaEdurFepYkSAi8IiSTowQwKLjP3G8Enw87bGhrz9Q6pgT
	KiR1FyA/34WWegx09wBG2WmIn7N6KqDxQ/ov1j+fvSNbkJu2ZkXMxjj4k4cCUKSEb8AlebodbJz
	xMpEyAQiii+/1XZSLSpukcBuwHgY=
X-Google-Smtp-Source: AGHT+IFmkqrLYBA6pxT3bgHP40xSeHaZYwIrDUExxYU5PjMxiNNE1p1s+eiHaAutjdes9ZQldE7V0g==
X-Received: by 2002:a05:6000:188d:b0:39e:dbee:f644 with SMTP id ffacd0b85a97d-3a06cfa5a93mr2715557f8f.46.1745504038249;
        Thu, 24 Apr 2025 07:13:58 -0700 (PDT)
Received: from seksu.systems-nuts.com (stevens.inf.ed.ac.uk. [129.215.164.122])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a06d4a8150sm2199951f8f.7.2025.04.24.07.13.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 07:13:57 -0700 (PDT)
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
	Elliot Berman <quic_eberman@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Alex Elder <elder@linaro.org>
Subject: [RFC PATCH 10/34] gunyah: Common types and error codes for Gunyah hypercalls
Date: Thu, 24 Apr 2025 15:13:17 +0100
Message-Id: <20250424141341.841734-11-karim.manaouil@linaro.org>
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

Add architecture-independent standard error codes, types, and macros for
Gunyah hypercalls.

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Reviewed-by: Alex Elder <elder@linaro.org>
Signed-off-by: Elliot Berman <quic_eberman@quicinc.com>
Signed-off-by: Karim Manaouil <karim.manaouil@linaro.org>
---
 include/linux/gunyah.h | 106 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 106 insertions(+)
 create mode 100644 include/linux/gunyah.h

diff --git a/include/linux/gunyah.h b/include/linux/gunyah.h
new file mode 100644
index 000000000000..1eab631a49b6
--- /dev/null
+++ b/include/linux/gunyah.h
@@ -0,0 +1,106 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2022-2024 Qualcomm Innovation Center, Inc. All rights reserved.
+ */
+
+#ifndef _LINUX_GUNYAH_H
+#define _LINUX_GUNYAH_H
+
+#include <linux/errno.h>
+#include <linux/interrupt.h>
+#include <linux/limits.h>
+
+/* Matches resource manager's resource types for VM_GET_HYP_RESOURCES RPC */
+enum gunyah_resource_type {
+	/* clang-format off */
+	GUNYAH_RESOURCE_TYPE_BELL_TX	= 0,
+	GUNYAH_RESOURCE_TYPE_BELL_RX	= 1,
+	GUNYAH_RESOURCE_TYPE_MSGQ_TX	= 2,
+	GUNYAH_RESOURCE_TYPE_MSGQ_RX	= 3,
+	GUNYAH_RESOURCE_TYPE_VCPU	= 4,
+	GUNYAH_RESOURCE_TYPE_MEM_EXTENT	= 9,
+	GUNYAH_RESOURCE_TYPE_ADDR_SPACE	= 10,
+	/* clang-format on */
+};
+
+struct gunyah_resource {
+	enum gunyah_resource_type type;
+	u64 capid;
+	unsigned int irq;
+};
+
+/******************************************************************************/
+/* Common arch-independent definitions for Gunyah hypercalls                  */
+#define GUNYAH_CAPID_INVAL U64_MAX
+#define GUNYAH_VMID_ROOT_VM 0xff
+
+enum gunyah_error {
+	/* clang-format off */
+	GUNYAH_ERROR_OK				= 0,
+	GUNYAH_ERROR_UNIMPLEMENTED		= -1,
+	GUNYAH_ERROR_RETRY			= -2,
+
+	GUNYAH_ERROR_ARG_INVAL			= 1,
+	GUNYAH_ERROR_ARG_SIZE			= 2,
+	GUNYAH_ERROR_ARG_ALIGN			= 3,
+
+	GUNYAH_ERROR_NOMEM			= 10,
+
+	GUNYAH_ERROR_ADDR_OVFL			= 20,
+	GUNYAH_ERROR_ADDR_UNFL			= 21,
+	GUNYAH_ERROR_ADDR_INVAL			= 22,
+
+	GUNYAH_ERROR_DENIED			= 30,
+	GUNYAH_ERROR_BUSY			= 31,
+	GUNYAH_ERROR_IDLE			= 32,
+
+	GUNYAH_ERROR_IRQ_BOUND			= 40,
+	GUNYAH_ERROR_IRQ_UNBOUND		= 41,
+
+	GUNYAH_ERROR_CSPACE_CAP_NULL		= 50,
+	GUNYAH_ERROR_CSPACE_CAP_REVOKED		= 51,
+	GUNYAH_ERROR_CSPACE_WRONG_OBJ_TYPE	= 52,
+	GUNYAH_ERROR_CSPACE_INSUF_RIGHTS	= 53,
+	GUNYAH_ERROR_CSPACE_FULL		= 54,
+
+	GUNYAH_ERROR_MSGQUEUE_EMPTY		= 60,
+	GUNYAH_ERROR_MSGQUEUE_FULL		= 61,
+	/* clang-format on */
+};
+
+/**
+ * gunyah_error_remap() - Remap Gunyah hypervisor errors into a Linux error code
+ * @gunyah_error: Gunyah hypercall return value
+ */
+static inline int gunyah_error_remap(enum gunyah_error gunyah_error)
+{
+	switch (gunyah_error) {
+	case GUNYAH_ERROR_OK:
+		return 0;
+	case GUNYAH_ERROR_NOMEM:
+		return -ENOMEM;
+	case GUNYAH_ERROR_DENIED:
+	case GUNYAH_ERROR_CSPACE_CAP_NULL:
+	case GUNYAH_ERROR_CSPACE_CAP_REVOKED:
+	case GUNYAH_ERROR_CSPACE_WRONG_OBJ_TYPE:
+	case GUNYAH_ERROR_CSPACE_INSUF_RIGHTS:
+		return -EACCES;
+	case GUNYAH_ERROR_CSPACE_FULL:
+	case GUNYAH_ERROR_BUSY:
+	case GUNYAH_ERROR_IDLE:
+		return -EBUSY;
+	case GUNYAH_ERROR_IRQ_BOUND:
+	case GUNYAH_ERROR_IRQ_UNBOUND:
+	case GUNYAH_ERROR_MSGQUEUE_FULL:
+	case GUNYAH_ERROR_MSGQUEUE_EMPTY:
+		return -EIO;
+	case GUNYAH_ERROR_UNIMPLEMENTED:
+		return -EOPNOTSUPP;
+	case GUNYAH_ERROR_RETRY:
+		return -EAGAIN;
+	default:
+		return -EINVAL;
+	}
+}
+
+#endif
-- 
2.39.5


