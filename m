Return-Path: <kvm+bounces-42386-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A48AA78123
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 19:09:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 77005188C84E
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 17:08:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 164F620E33A;
	Tue,  1 Apr 2025 17:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DQ7WbqjK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA1A820D51F
	for <kvm@vger.kernel.org>; Tue,  1 Apr 2025 17:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743527195; cv=none; b=nOCt+6uF6C8wMDqZ81Qd4md5FW8WSg6ho4lsTbwEDrnee9s4FIQrRexkq7wuGFY9P26GPk3c5UOOlUDtwZyz3XNvFPOysYntyTHmax0gogD5QH0Y9YObnT4P/Yd22LYPy5udSkuzTCy4K3c0AKPX/EYopFjXIjEJd2/vRASHz9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743527195; c=relaxed/simple;
	bh=J4D5P6ZuoPVhklxGsaD5HEAPeXTS8fvFnt2vhSIHhGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pNUn8nXkCdxql865z7c581elhBoXE1D2i4Hdzh+LSMSYZJwu1n46VbDbe2duEGlW/ns7Mufg+Sa3DYEskJfgP8EquEl31IaIpGW5zDVWu4YCunFK25bEzjPRMs4EH7sCV3r4SX/cjgcJdXB4ysiBw1ztQBdg9GnbAhRu4xGzIg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DQ7WbqjK; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-22435603572so109589655ad.1
        for <kvm@vger.kernel.org>; Tue, 01 Apr 2025 10:06:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743527193; x=1744131993; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kjGdFgC2uV3PZy5Dr2trZqpXgiw/hsN6NMeCx+sevq0=;
        b=DQ7WbqjKYThUlwDBu2u8CpdQpfERPu50Gqu+Suycto8npgY3WBheuzl1JzdAyk87RL
         zsomdxWNAYcil9MJ2fNFhsp1ZIzaYpvaG52Ki/FRt3VsJ1CVSElWQULUXwmFrvtG4oZr
         Hs8QYB6IoDA4De4KzQP8jdCnSI7rsaSkWi8H1nqeBB0If37uTJmudsIfEq3zBMIfr0+k
         2pAV3Cez2NB8naN0v96wvfmGXJcM+64Rd6tg1r9wXTBPehpjKO0bSfJwoEPPigzlvt6t
         ZF0/yeUeDjG59jg3+uX6sy60i+VmNkbjKgzQVYUDWQbY28q8Z2YXr0HCgMAXa8f/YK5+
         6+VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743527193; x=1744131993;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kjGdFgC2uV3PZy5Dr2trZqpXgiw/hsN6NMeCx+sevq0=;
        b=voOb9R/44idH+oTDAfI+IroSlTDOlaEcWy4z13yUYmETiwW4Wb6xsz1vlI0l99lOY9
         k6ua/7MyodMU1gcwK2R/MasTO18m/EDgMb1khotJfdceGVYE1ixiYzZYpo1bKtXU8ZDG
         GXbt+O/lzgAaQSbdH1/X7sOzTfr61ksCbyez5HUpNYU+TZ8f+k67c9YbykHiV9sGQCiv
         hD8jQC5cqnPjoJ4DQ6q35HEsTsHzawy3vXW9TsfHwkH4p+qoLGKvEEdmUOa0tZPBu0Mp
         QppYOr9jXYV5X8U9KHd7dlI43ikNzcFXdIM0/zK5Dj1zeiNM1LvPkimQE6GqS9aub1W3
         SGIw==
X-Forwarded-Encrypted: i=1; AJvYcCUR41WamunmVgwd60i3eYibSTz13YPYG1vZQXwRdCB9hegAHZ24P4dV+JmOeZl06295ts0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyEeE7HihjhYMTEHQqB5Uocj1P6cjtb+HuWKmZz6MBkIGcDa64l
	VeIVsC9sOlOl/F5RdVwWx76pzxd/DxIEFYHTX19Q2P7APovKCxyt
X-Gm-Gg: ASbGncsSk3wl22ficnPa8jO2uQiAa2EzrhSunyTk3SqKT5wJ7aPTBl4AYN5uzSMHjzz
	sdXs/kX0KvHPUA4Cd6QmxF1KbQXdNxfUOOEDDdt0nQ7foISegrKX/vnQnXnLYrrEsh225dm/GJi
	1/sJ6O9MkDr2Ncl/1mOVb6De+xG18Y2Gow4gxsXV2t5tQMJ4zd02f18FegVoRmZpkQIe3Jt/XLW
	v9cw6sQq9bQlifQZ18MbVxEGWhRJPNaekkOMlNZY0tBPnODQDCqQ7BuTrordjbAjJZgsFRw1ivl
	Nl9uVL40bPURfCRHx2c537T1UhXoMgIJwU6xwuj8
X-Google-Smtp-Source: AGHT+IGzsiDzmzvRlyG7rp+VISpZTasYl/d6ySBJOZLqYXTkt37/lYxy1qELEG9qXXRbOBNMnKz3yw==
X-Received: by 2002:a05:6a20:cfa1:b0:1f5:9330:2a18 with SMTP id adf61e73a8af0-2009f63227cmr20369442637.23.1743527193233;
        Tue, 01 Apr 2025 10:06:33 -0700 (PDT)
Received: from raj.. ([103.48.69.244])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7398cd1cc3dsm5902926b3a.80.2025.04.01.10.06.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Apr 2025 10:06:32 -0700 (PDT)
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
Subject: [RFC PATCH 7/7] tee: optee: Notify TEE Mediator on OP-TEE driver initialization and release
Date: Tue,  1 Apr 2025 22:35:27 +0530
Message-ID: <20250401170527.344092-8-yuvraj.kernel@gmail.com>
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

When host initializes or releases its OP-TEE driver through
optee_core_init()/optee_core_exit(), notify OP-TEE in the secure world
about this change.

If OP-TEE is built with NS-Virtualization support, it will treat SMCs coming
from the host as if it were coming from a VM (as OP-TEE does not understand
the KVM paradigm).

Hence, OPTEE_SMC_VM_CREATED and OPTEE_SMC_VM_DESTROYED SMCs have to be made
for its internal book-keeping.

Signed-off-by: Yuvraj Sakshith <yuvraj.kernel@gmail.com>
---
 drivers/tee/optee/core.c    | 13 ++++++++++++-
 drivers/tee/optee/smc_abi.c |  6 ++++++
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/tee/optee/core.c b/drivers/tee/optee/core.c
index c75fddc83576..5f2ab0ee0893 100644
--- a/drivers/tee/optee/core.c
+++ b/drivers/tee/optee/core.c
@@ -14,6 +14,7 @@
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/tee_core.h>
+#include <linux/tee_mediator.h>
 #include <linux/types.h>
 #include "optee_private.h"
 
@@ -195,7 +196,13 @@ static bool intf_is_regged;
 static int __init optee_core_init(void)
 {
 	int rc;
-
+#ifdef CONFIG_TEE_MEDIATOR
+	if (tee_mediator_is_active()) {
+		rc = tee_mediator_create_host();
+		if (rc < 0)
+			return rc;
+	}
+#endif
 	/*
 	 * The kernel may have crashed at the same time that all available
 	 * secure world threads were suspended and we cannot reschedule the
@@ -240,6 +247,10 @@ static void __exit optee_core_exit(void)
 		optee_smc_abi_unregister();
 	if (!ffa_abi_rc)
 		optee_ffa_abi_unregister();
+#ifdef CONFIG_TEE_MEDIATOR
+	if (tee_mediator_is_active())
+		tee_mediator_destroy_host();
+#endif
 }
 module_exit(optee_core_exit);
 
diff --git a/drivers/tee/optee/smc_abi.c b/drivers/tee/optee/smc_abi.c
index f0c3ac1103bb..a930ca8cde23 100644
--- a/drivers/tee/optee/smc_abi.c
+++ b/drivers/tee/optee/smc_abi.c
@@ -25,8 +25,10 @@
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/tee_core.h>
+#include <linux/tee_mediator.h>
 #include <linux/types.h>
 #include <linux/workqueue.h>
+#include "optee_mediator.h"
 #include "optee_private.h"
 #include "optee_smc.h"
 #include "optee_rpc_cmd.h"
@@ -1396,6 +1398,10 @@ static void optee_smccc_smc(unsigned long a0, unsigned long a1,
 			    unsigned long a6, unsigned long a7,
 			    struct arm_smccc_res *res)
 {
+#ifdef CONFIG_TEE_MEDIATOR
+	if (tee_mediator_is_active())
+		a7 = OPTEE_HOST_VMID;
+#endif
 	arm_smccc_smc(a0, a1, a2, a3, a4, a5, a6, a7, res);
 }
 
-- 
2.43.0


