Return-Path: <kvm+bounces-58335-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9213CB8D12B
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 22:43:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4CF283B3106
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 20:43:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03D5B2E7F2F;
	Sat, 20 Sep 2025 20:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="Ywy8Y5JG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 344A62E6CB5
	for <kvm@vger.kernel.org>; Sat, 20 Sep 2025 20:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758400756; cv=none; b=TieoovThExANnvG08tk+WeweZPUBbjQHF7zu61fJy6CFsSAy++xqcDcCSD1u8WUa24XklH0GXCzml5OuwUzUGjgEmcDrJX4a9Z6F9B4/q7e3Yl8OTr0ARM+QjjOSS3i3onjodEFYipP8Iq7OtmaiMzs4DPmaDraR0XQ6A/yYlZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758400756; c=relaxed/simple;
	bh=eR9yldP5I+tQHxNItj/BneVd8jk+wwPiVMth3Yu7eiE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jxouvcnwc6aylL6QUiwAxtFMLPFTGMJoaShdm4w2K7sjvR6dz7+VMOUgOQ4SL9cOHKb8gzIUsFQxgbNbiGTEbx33yQH42O7FtZzIlZ/tPZK+5KzW7I70X+ncAFHO4A1WNygD5y05vLB37Xt39BA4c5g+ZQiRjaIrR0pjgVe3Ofg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=Ywy8Y5JG; arc=none smtp.client-ip=209.85.166.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-42480cb42e9so11460985ab.0
        for <kvm@vger.kernel.org>; Sat, 20 Sep 2025 13:39:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1758400753; x=1759005553; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Lp5QAIgY+FjKQKHqRdWuauO9I56sIIxDetTr/Rl2SyY=;
        b=Ywy8Y5JG11NryemQxamVvupq97uv3J4fQGHUGERuTanZ/f8TB3R//clZ7r084F+KhL
         nd2y1lT/j4KAyQzrfvI3dVM9IEzn7UCtKnhA3Ej97sKVRBOeR/k/YIidwlNIRCOD4ko8
         h4LtIlU7uxMEHzNQaQtHwfgs8lBRd4YFHrcn1194A05FnflfkY4Xefcf68nZOLskdrMk
         +NK+fhlA5/Afrzs39VpjZlU9v9D/I0NlW+EjeMo7O9GRHxi5QTEzfix+6JFTMH3HwOaD
         Qck/MXNzS2JX5suaWFyOY7P1FKcbCrU0x3vfwMp3OzUyXWAFFCeLsTpi5Ei1qFO9Y8WT
         nbfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758400753; x=1759005553;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Lp5QAIgY+FjKQKHqRdWuauO9I56sIIxDetTr/Rl2SyY=;
        b=s3bpY2Rckfr2HWpOiFcUYwtamd01QhKaVXBEwSrr7f6QfN4hRmEDDvsarTmckA2+yk
         YLnyu+kbgmg88r/hkINmmmV0kJFi099C9Z3g88A6dyhxk+u1lL47esydGuF8QRZrpprp
         nGWmEfPTn3fM9tVM0EDQL/aNFjzU8LkK3jw8IlrF7hdpWg/qdlVbRSghWFLsEDoJpzry
         6sGBgLPHlcrMILhVLfdlJUO44wYb/dv+VYNJXoVhtzrmzlhbyoZsCCBUyxSBLrsMLkBf
         tYOLn/S0rYo/W70lOnFIxy7rE9Zg6a3AnSPoJ3O0YTBQ2+9G/ybHGQ1rj1nSmKiuOAsq
         qAnw==
X-Forwarded-Encrypted: i=1; AJvYcCUYsQHUGUiNsgpOQokUgxsF6J1EY7+479BxqOtYsz5IHGk8Y8FzsR/kGDkYCUiMYbsdRXg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw6kb0va59z7CNn+9F9UvubgFP5Sgd+OoXoWOpEa9TVuzO8OpFq
	znyyIQmMvzYfCPPUa9sl+1X6hFcmVgqk7DAuDPa5w7NKSuWW8GJTgzVxqxdID+JSeMw=
X-Gm-Gg: ASbGncvQKeKbgXwyMIAfe1HmsV9PqVKwTuZ2mACqjah77Y2HkA5+SsUy7E0MF49aGD+
	hj5ONGXQqtbINlHFzIytYN+cnNvNqaFTbiQe3mmwlEbbidVf5Ik36T6IGD/bqWsIOSgfVvJE+Kt
	Fg1TaAzlc2+eP3GU5hnTgiY6ujJ6+roEcr1/010avGtqBK5k9DjKz0L/9nbLgHQSEO+u+7crT2S
	e1y9rsihb6YUy/tKrhMbJpgdBWa2g1gDDlryWs2opYtSOQhe+4BCykkZyvWGpgrXML4PhAG9BrR
	bPNJmmGZdKROVdlkgQwVQ/+tgF7XOvABt7wIrlXjhOB1Bb1FSP2JWtN17jPKZB+ZL268Sgcarvk
	9VjRIocM+e3G4+Nt5734WVhg2yppQIj67fJw=
X-Google-Smtp-Source: AGHT+IEGRyXKIZhBuusMIimPhPuaP1RErmgLHhjZOiDaZM931WOu2VdkPLc6h5n6dwDp6Uc98U+7Ow==
X-Received: by 2002:a05:6e02:188d:b0:423:f924:c885 with SMTP id e9e14a558f8ab-42481938b95mr127031045ab.13.1758400753481;
        Sat, 20 Sep 2025 13:39:13 -0700 (PDT)
Received: from localhost ([140.82.166.162])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-555a288f097sm699084173.44.2025.09.20.13.39.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Sep 2025 13:39:13 -0700 (PDT)
From: Andrew Jones <ajones@ventanamicro.com>
To: iommu@lists.linux.dev,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: jgg@nvidia.com,
	zong.li@sifive.com,
	tjeznach@rivosinc.com,
	joro@8bytes.org,
	will@kernel.org,
	robin.murphy@arm.com,
	anup@brainfault.org,
	atish.patra@linux.dev,
	tglx@linutronix.de,
	alex.williamson@redhat.com,
	paul.walmsley@sifive.com,
	palmer@dabbelt.com,
	alex@ghiti.fr
Subject: [RFC PATCH v2 16/18] vfio: enable IOMMU_TYPE1 for RISC-V
Date: Sat, 20 Sep 2025 15:39:06 -0500
Message-ID: <20250920203851.2205115-36-ajones@ventanamicro.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250920203851.2205115-20-ajones@ventanamicro.com>
References: <20250920203851.2205115-20-ajones@ventanamicro.com>
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
2.49.0


