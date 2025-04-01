Return-Path: <kvm+bounces-42381-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E8076A7811B
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 19:08:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 95AEE16C342
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 17:08:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D115620FABC;
	Tue,  1 Apr 2025 17:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ee2+zBTg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78B4C156C62
	for <kvm@vger.kernel.org>; Tue,  1 Apr 2025 17:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743527165; cv=none; b=AGLqH9KZS5luY9lYf8Cr0yoMFV7NCUO/3fwdKCCNOqO5XY6wxBKpUo+GO+3V6eZKrYOowDqGzYXHJxHs+nt75cViOa6hQEHiR8i4dyMRJh60BbeFbwEU9KgWhb8aWdzOwq3JvbkInyl8/Wa8VGut94AiJWbqGvLJ6ye/lTIuXI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743527165; c=relaxed/simple;
	bh=ZI/sEAhEFCu5lvxGAVZMXb5pyLBeXvdXqe60NbG+FmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HkPng3pYx9svcOq4/xks0vAt0bt5OANv5SZjb+Qdt+CHv6Hp0oL5Ay7ge/8ZvmYPi4atFmcpcbpJyEIEhthW4kpMFtWI+MRru+5HzswKwPJx72l4ZmcbWztTIn5Ypsf1PNPIKgb96Bf+DrUoSt5zZwNtaG8TI3cEH2rHXWBqcO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ee2+zBTg; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-225df540edcso933445ad.0
        for <kvm@vger.kernel.org>; Tue, 01 Apr 2025 10:06:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743527162; x=1744131962; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GA2kYs8wQSi+0j0jQaDO25e9tFK5hiSvEa3CXe/PxgU=;
        b=Ee2+zBTg0zvyfn2x8FRDMXQiRGcNRFqUfeWHwXdpu4fRqq8czYc7txo7A8Pp9voCVK
         4qqo14tIJnXMCBqb4OlaIiCt9NQzKyFpw/x1QfnrA5x3eTnQQEDsbfBnd0ndj3hBQqkb
         Fi34zrTliSTg9gm0kIlDf0gMwdwV/azWimVESiuai9KPhpPCn41dv6mmn3in1GDLf1r6
         V1WJ7+V+IENxGMv2lseNCuqggnLifOzPrx6qZgqdfGMS1C3dZ+Ro4CdBLUlKAbbiN/9t
         otqBKW4P8eSCWhAiv+r5EJxCpPdy2PGpbwKIaVZc0j827NgLHMmAVcts+O8r9kkr+CXS
         lzig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743527162; x=1744131962;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GA2kYs8wQSi+0j0jQaDO25e9tFK5hiSvEa3CXe/PxgU=;
        b=u0EitAYU0IKpY636SByaqrVhcg8zC1kOd4E0MZMcTZJZhCZXUwTe0jU9bK9jbga5kB
         CeryUXHg7R2nGXlH8piZ+d9MZERcBdU5RBFhAe+eZ70VDngac0IdSJn6KsXaK6HAVWKS
         vIBJ2KAi+lDMEHtYOxuHP1o8BewXsLqr89DYgMcHOEhf3yppJbHkBDP0h6tfhvdvHg2Z
         Xrao51n0vv/ZgpIbuyFLyUjDesFQ/Cn4Tl32GykJNDBC4QQiYiYoGc7Bj3JBVfonLGoR
         rtj1Xqd3lgRo0VtXZJboStHTnS0h/V5+znefK/CpSLDlsyLxQDw41GxOu/DP1KoZNA2R
         W8uw==
X-Forwarded-Encrypted: i=1; AJvYcCVlB3rcr2vjwl02zgaIT/ZhFy7qkltNnjJAI/fooMVbqe+eNsldH6eh8AoggbObqTiRfCY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyUzCsvq94GTkbUJi5GmN274hPigvXBWxror9pmpEPhYLFnPaJu
	t2rCeDBWknnCgxrGorKIS6mCRHOO5Ey2czuV8GpsqT9xbO9oJPNaDSJVTERD
X-Gm-Gg: ASbGncuoNnh4cefu17Oo2NXlW4tYhQitJSiTdNfLboi/fqC2Rvry9n7GaAowjNJ7iml
	k/J/AtHXapaldjQI0L4/YPuB/yEXzFHH2ilRMPQ7PmXE1t96dpGHMFEYYxrG68RhnSjQoSIzuFc
	/FsjTjmfJDwDTpZ0T7frT6KcrvlJw7ZpUW6hxMI3A8dJJT8fLaVV/IizDVfdO+uevc5ex4q7iMn
	y0RHwTzjJ3gWMyypVbXQC0HN1/ttrK76m8irxsmxA5QxhAeiOOdSSzzWX1Hj5cWUx8gL31YoRfX
	fDkU3vFqn4keP3ta8XN++Nw/hSOnLs3+LoLKV9t4Xil2TOyzcb4=
X-Google-Smtp-Source: AGHT+IGEHf7ivlGPdc+XvUBtzZ62oiMeiz87MJ8nWnqxYcGMsRisgl9JgQeZkopDQbtkvb1l7k8dXg==
X-Received: by 2002:a05:6a00:4512:b0:727:39a4:30cc with SMTP id d2e1a72fcca58-739c42f80d1mr1047495b3a.1.1743527162348;
        Tue, 01 Apr 2025 10:06:02 -0700 (PDT)
Received: from raj.. ([103.48.69.244])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7398cd1cc3dsm5902926b3a.80.2025.04.01.10.05.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Apr 2025 10:06:02 -0700 (PDT)
From: Yuvraj Sakshith <yuvraj.kernel@gmail.com>
To: kvmarm@lists.linux.dev,
	op-tee@lists.trustedfirmware.org,
	kvm@vger.kernel.org
Cc: maz@kernel.org,
	oliver.upton@linux.dev,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	jens.wiklander@linaro.org,
	sumit.garg@kernel.org,
	mark.rutland@arm.com,
	lpieralisi@kernel.org,
	sudeep.holla@arm.com,
	pbonzini@redhat.com,
	praan@google.com,
	Yuvraj Sakshith <yuvraj.kernel@gmail.com>
Subject: [RFC PATCH 2/7] tee: Add TEE Mediator module which aims to expose TEE to a KVM guest.
Date: Tue,  1 Apr 2025 22:35:22 +0530
Message-ID: <20250401170527.344092-3-yuvraj.kernel@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250401170527.344092-1-yuvraj.kernel@gmail.com>
References: <20250401170527.344092-1-yuvraj.kernel@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The TEE Mediator module is an upper abstraction layer which lets KVM guests
interact with a trusted execution environment.

TEE specific subsystems (such as OP-TEE, for example) can register a set of
handlers through tee_mediator_register_ops() with the TEE Mediator, which will
be called by the kernel when required.

Given this module, architecture specific TEE drivers can implement handler functions to work with these
events if necessary. In most implementations, a special instruction (such as SMC, in arm64) switches control
leading to the TEE. These instructions are usually trapped by the hypervisor when executed by the guest.

This module allows making use of these trapped instructions and mediating the request between guest and TEE.

Signed-off-by: Yuvraj Sakshith <yuvraj.kernel@gmail.com>
---
 drivers/tee/Kconfig          |   5 ++
 drivers/tee/Makefile         |   1 +
 drivers/tee/tee_mediator.c   | 145 +++++++++++++++++++++++++++++++++++
 include/linux/tee_mediator.h |  39 ++++++++++
 4 files changed, 190 insertions(+)
 create mode 100644 drivers/tee/tee_mediator.c
 create mode 100644 include/linux/tee_mediator.h

diff --git a/drivers/tee/Kconfig b/drivers/tee/Kconfig
index 61b507c18780..dc446c9746ee 100644
--- a/drivers/tee/Kconfig
+++ b/drivers/tee/Kconfig
@@ -11,6 +11,11 @@ menuconfig TEE
 	  This implements a generic interface towards a Trusted Execution
 	  Environment (TEE).
 
+config TEE_MEDIATOR
+	bool "Trusted Execution Environment Mediator support"
+	depends on KVM
+	help
+	  Provides an abstraction layer for TEE drivers to mediate KVM guest requests to the TEE.
 if TEE
 
 source "drivers/tee/optee/Kconfig"
diff --git a/drivers/tee/Makefile b/drivers/tee/Makefile
index 5488cba30bd2..46c44e59dd0b 100644
--- a/drivers/tee/Makefile
+++ b/drivers/tee/Makefile
@@ -1,5 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-$(CONFIG_TEE) += tee.o
+obj-$(CONFIG_TEE_MEDIATOR) += tee_mediator.o
 tee-objs += tee_core.o
 tee-objs += tee_shm.o
 tee-objs += tee_shm_pool.o
diff --git a/drivers/tee/tee_mediator.c b/drivers/tee/tee_mediator.c
new file mode 100644
index 000000000000..d1ae7f4cb994
--- /dev/null
+++ b/drivers/tee/tee_mediator.c
@@ -0,0 +1,145 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * TEE Mediator for the Linux Kernel
+ *
+ * This module enables a KVM guest to interact with a
+ * Trusted Execution Environment in the secure processing
+ * state provided by the architecture.
+ *
+ * Author:
+ *   Yuvraj Sakshith <yuvraj.kernel@gmail.com>
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/tee_mediator.h>
+
+static struct tee_mediator *mediator;
+
+int tee_mediator_register_ops(struct tee_mediator_ops *ops)
+{
+
+	int ret = 0;
+
+	if (!ops) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if (!mediator) {
+		ret = -EOPNOTSUPP;
+		goto out;
+	}
+
+	mediator->ops = ops;
+
+out:
+	return ret;
+}
+
+int tee_mediator_is_active(void)
+{
+	return (mediator != NULL &&
+	 mediator->ops != NULL && mediator->ops->is_active());
+}
+
+int tee_mediator_create_host(void)
+{
+	int ret = 0;
+
+	if (!tee_mediator_is_active() || !mediator->ops->create_host) {
+		ret = -ENODEV;
+		goto out;
+	}
+
+	ret = mediator->ops->create_host();
+
+out:
+	return ret;
+}
+
+int tee_mediator_destroy_host(void)
+{
+	int ret = 0;
+
+	if (!tee_mediator_is_active() || !mediator->ops->destroy_host) {
+		ret = -ENODEV;
+		goto out;
+	}
+
+	ret = mediator->ops->destroy_host();
+out:
+	return ret;
+}
+
+int tee_mediator_create_vm(struct kvm *kvm)
+{
+	int ret = 0;
+
+	if (!kvm) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if (!tee_mediator_is_active() || !mediator->ops->create_vm) {
+		ret = -ENODEV;
+		goto out;
+	}
+
+	ret = mediator->ops->create_vm(kvm);
+
+out:
+	return ret;
+}
+
+int tee_mediator_destroy_vm(struct kvm *kvm)
+{
+	int ret = 0;
+
+	if (!kvm) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if (!tee_mediator_is_active() || !mediator->ops->destroy_vm) {
+		ret = -ENODEV;
+		goto out;
+	}
+
+	ret = mediator->ops->destroy_vm(kvm);
+
+out:
+	return ret;
+}
+
+void tee_mediator_forward_request(struct kvm_vcpu *vcpu)
+{
+	if (!vcpu || !tee_mediator_is_active() || !mediator->ops->forward_request)
+		return;
+
+	mediator->ops->forward_request(vcpu);
+}
+
+static int __init tee_mediator_init(void)
+{
+	int ret = 0;
+
+	mediator = kzalloc(sizeof(*mediator), GFP_KERNEL);
+	if (!mediator) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	pr_info("mediator initialised\n");
+out:
+	return ret;
+}
+module_init(tee_mediator_init);
+
+static void __exit tee_mediator_exit(void)
+{
+	kfree(mediator);
+
+	pr_info("mediator exiting\n");
+}
+module_exit(tee_mediator_exit);
diff --git a/include/linux/tee_mediator.h b/include/linux/tee_mediator.h
new file mode 100644
index 000000000000..4a971de158ec
--- /dev/null
+++ b/include/linux/tee_mediator.h
@@ -0,0 +1,39 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * TEE Mediator for the Linux Kernel
+ *
+ * This module enables a KVM guest to interact with a
+ * Trusted Execution Environment in the secure processing
+ * state provided by the architecture.
+ *
+ * Author:
+ *   Yuvraj Sakshith <yuvraj.kernel@gmail.com>
+ */
+
+#ifndef __TEE_MEDIATOR_H
+#define __TEE_MEDIATOR_H
+
+#include <linux/kvm_host.h>
+
+struct tee_mediator_ops {
+	int (*create_host)(void);
+	int (*destroy_host)(void);
+	int (*create_vm)(struct kvm *kvm);
+	int (*destroy_vm)(struct kvm *kvm);
+	void (*forward_request)(struct kvm_vcpu *vcpu);
+	int (*is_active)(void);
+};
+
+struct tee_mediator {
+	struct tee_mediator_ops *ops;
+};
+
+int tee_mediator_create_host(void);
+int tee_mediator_destroy_host(void);
+int tee_mediator_create_vm(struct kvm *kvm);
+int tee_mediator_destroy_vm(struct kvm *kvm);
+void tee_mediator_forward_request(struct kvm_vcpu *vcpu);
+int tee_mediator_is_active(void);
+int tee_mediator_register_ops(struct tee_mediator_ops *ops);
+
+#endif
-- 
2.43.0


