Return-Path: <kvm+bounces-31870-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CEA659C90CA
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 18:28:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 33B5CB263C8
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 16:24:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE4181AE850;
	Thu, 14 Nov 2024 16:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="LQsagkWD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12F5D1AC88A
	for <kvm@vger.kernel.org>; Thu, 14 Nov 2024 16:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731601153; cv=none; b=AJ8OTxrjHhhjlpEO9KLndV5YH+NZOF01BpCtx6HRWN5/Ga0CKFT/V5L+B6e1xa24eAhLfV3vTP0FbBxu68/o9SU0JXlcg3T+h4aOH4P8WZgUP6NZi9R6NONVChSAfVZXfGP9MhWC05KkwEc+yZqC1oJu5NmJR8RPwBZKY8c1jBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731601153; c=relaxed/simple;
	bh=ES0TvAxz9/x2ptiDnzIz0eP+Ou6/i+zYJHVn+dCYtjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rOmOlweThrFJy6Tv+FcTlzpZ6b6Hpn5yHGtuWlTEgT46SKBYJaIVysVDWsAIUZ3j4wsx08gL4VJy/JjHoXLRCj5xbMthIWxdiAEWBEtygI36jI57OoR5lqv104hw+9Ue2k97IGm6hwitHxbT779RLjLWW8DJGeDbG938BWD0a3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=LQsagkWD; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4315e62afe0so7662455e9.1
        for <kvm@vger.kernel.org>; Thu, 14 Nov 2024 08:19:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1731601150; x=1732205950; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BmqNGe/T2iE9PlV9lB2/3K3MC1TQA7fI1NussKF1DE0=;
        b=LQsagkWDpQ09Orr95W2tYqbVr5m6ZwXuTCLazfrX6HiwLKpF0BBxavxZURIXdq/Wrs
         O/XIT6O+69q5zC8NXSVTiBpJ5lVkg/cT4qJm1wn9VRjDaa/1tN5blgJXCaH8fLWePHeE
         kta4aTjJqZNrE2H9Qsopq8q3PXcG3RvjVh2iBWi12Em5vOdykiEEIlNefwuuStFqwSv5
         D51jsaIiXgD3vKMuKI51T0lGlHsAxA8gdX/zXkgY2RIwj2XhmUdHSfw/WyvDS7YivgYH
         5vd9SiRpfyjJAyhf7/xwtIPW4FnmuVgIPu/uKlNnFPnIBPSpZ88wAHOpZZyjNTcHeA+N
         wqjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731601150; x=1732205950;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BmqNGe/T2iE9PlV9lB2/3K3MC1TQA7fI1NussKF1DE0=;
        b=TW6JMo2mudZIEaVQoKmRbov0iqLwhcllrUdzNOGwrQOThR5oW9rQBVkhidrSBC1Dax
         WQBVrmjQaR2ahRq05YwP9aDlEdtoYfQ/repnY4Ky+j1kdDIoBXQvWNTGBXY+XtPWnQeN
         8UW8ScTxGYjyx5XUQonmgrlnrUYMWeo8Q+PtGzbx4rfYNPlGo9G4SGe2fOy6XSO3c+ls
         RojmQECNEBVWOoznHGxxwSdsNWlCCi/4NKQhzPEBh20GXmw0q0xNXSZvrXbDwXSz52GS
         H6GD36keJ4dQFgsx1Gx01Ay/QzjwT4ZpZLiSsx4VqmaMhLgcySHAcZyUUiKRWq+mbndy
         uubA==
X-Forwarded-Encrypted: i=1; AJvYcCXJ4w1pcYNN0hZBJ2Y7ItoTXLO/yfRGRinmUkBXAI+zw0JFEA/uTB5Rm7KJnG3pZd6i1f4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yya9F0Fg9v/Lme7XNFLUbgbqEKAedZfN4WRxUY4+cysSj15vt9/
	yzkrM+kT5MHK8enH+8gMpXsCF5tQtVZUEj4ttUninYiVfn6EkbBV4CKpF8x2JHU=
X-Google-Smtp-Source: AGHT+IGMbtDDWmvKWsj/Ybdc9TgUB55aFH3ajhr0ZnMlCbsRayCj2n5LaLaeoDlbaJzuEn6VOd9B/g==
X-Received: by 2002:a05:600c:8715:b0:431:93d8:e1a1 with SMTP id 5b1f17b1804b1-432b751bcc2mr209410385e9.27.1731601150428;
        Thu, 14 Nov 2024 08:19:10 -0800 (PST)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3821adbe779sm1834550f8f.60.2024.11.14.08.19.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2024 08:19:09 -0800 (PST)
From: Andrew Jones <ajones@ventanamicro.com>
To: iommu@lists.linux.dev,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: tjeznach@rivosinc.com,
	zong.li@sifive.com,
	joro@8bytes.org,
	will@kernel.org,
	robin.murphy@arm.com,
	anup@brainfault.org,
	atishp@atishpatra.org,
	tglx@linutronix.de,
	alex.williamson@redhat.com,
	paul.walmsley@sifive.com,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu
Subject: [RFC PATCH 14/15] vfio: enable IOMMU_TYPE1 for RISC-V
Date: Thu, 14 Nov 2024 17:18:59 +0100
Message-ID: <20241114161845.502027-31-ajones@ventanamicro.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241114161845.502027-17-ajones@ventanamicro.com>
References: <20241114161845.502027-17-ajones@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Tomasz Jeznach <tjeznach@rivosinc.com>

Enable VFIO support on RISC-V architecture.

Signed-off-by: Tomasz Jeznach <tjeznach@rivosinc.com>
Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
---
 drivers/vfio/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
index ceae52fd7586..ad62205b4e45 100644
--- a/drivers/vfio/Kconfig
+++ b/drivers/vfio/Kconfig
@@ -39,7 +39,7 @@ config VFIO_GROUP
 
 config VFIO_CONTAINER
 	bool "Support for the VFIO container /dev/vfio/vfio"
-	select VFIO_IOMMU_TYPE1 if MMU && (X86 || S390 || ARM || ARM64)
+	select VFIO_IOMMU_TYPE1 if MMU && (X86 || S390 || ARM || ARM64 || RISCV)
 	depends on VFIO_GROUP
 	default y
 	help
-- 
2.47.0


