Return-Path: <kvm+bounces-60642-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FB4FBF5529
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 10:44:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 679304E7998
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 08:44:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EADC931DDB9;
	Tue, 21 Oct 2025 08:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="pANCmaoF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 514763054CE
	for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 08:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761036251; cv=none; b=mVp/e/Co5ygpRh9Z8FM/Dviww8jTgik8loaG+PsmH9UqG1Cub2LOHZqFXk9G+rmNh3i8jScAS+Jm/WtY0thJGi8vem9dGk8LOGHpK1/ATffwHULucv8dLn1UNtWNfUwkeesZcgmEQtU9WypuZh5lGS/41nZxu5c7v75kwjsrwOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761036251; c=relaxed/simple;
	bh=YeTBLMdB1mASUZOBXaPqWCcR3AqyJpkVLibEf4fScyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=az/Xcc8Ea5OOUPZTGh7hp6WJwHkY1SHvHCGMd/IRHF6tYaF0N52nht93bnxNTf09K4Rx71+Njj2KjvI+qBsGpC5d9xzdu89ot7YLtpqvIxCWACUa4C1su5CmoAy4k9lLLn6hh5kzm7mbgbVJqsQ9jJLj1k8f3oL3CTyGfG3fhnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=pANCmaoF; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-426ed6f4db5so3312168f8f.0
        for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 01:44:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1761036247; x=1761641047; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t3K5y5Cy9vHhm90mgMJ5DoRZ8l6l8+H0Bizm6UlEWJA=;
        b=pANCmaoFWr8Ncpa1eXvnC14v1MRMQiTKCOQAK3jBIHwPG7TjfJAyZOVzhjmD68rreH
         AKRmXICWtLpjdBIBigt0wSREROBG3sJUtdKYKlVncU4stpG2PL83NRNkExI01ofgGHwb
         +uuIxXIg2HY0PEak0uE7zMv8T7eJcC9TNNGNiJh178Q3Loq/HxWwVNiumfyFcnuMaXWC
         /+Xb3f5lxtpJ/kEeP99pj7askts2gSPaSuLvVUbvIoC/nOKc7Oq6J05rZuJeayA4XJx6
         MU9JhxBAXc7yrQ4b6oXf+Lp9/tJvo/ui+Dy/eCitco8HwxLQefxr+HrN2kukB70JZ+4s
         OS0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761036247; x=1761641047;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=t3K5y5Cy9vHhm90mgMJ5DoRZ8l6l8+H0Bizm6UlEWJA=;
        b=S30FI64XBhIwcunXfghMcYXLwBjn2qEMXKrOkEnGc0eAnVsmhSfzGGgSVSLGYPZFc1
         hVHj6Gn/NyBF+EfMMcFIYIc1P35J+dJNWH2xH8C1djYt/gH+ow+HotR2U1AlN8s57ZLO
         l1cIsE3TPfpXR1++guBM1r1JdEmd0YLhRDKGX6ncUnGwN4I7H//6Oa2ar8srzh+ZCsle
         WsEioNjPCEZikOTChF0IGPPEikc6rAJn6i/9Btxo6r2hTpRqHT5AorA5jbAFllr0uU8i
         6EiwHG0lou7BoyloFcjFIhJ4teHCRfVYehzMbYPp/ojjujxXmB5AgJ9ptTSbIO4olI07
         fwKw==
X-Forwarded-Encrypted: i=1; AJvYcCXLOXCSw7wWHOyApT+mzQYHURSFecRmbW49K0AlION11zsAXMe6I80/GD/kgqlYLafoVbw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx2/BoVOP0vc6mXOYtMKkxPM8336Qq6B65AZLJYOj4IGPIWDyYo
	HyMdq6wPiFbd0rQ+S4nyb2r+l18GfEQwfuQRUlEM2BWs7Qp7PGFJMmPL8XzWsPtz3Ds=
X-Gm-Gg: ASbGncta286aWDpjLTHLRSWNaDmqyOFpt/GrEq+gp9Wjjlizz1x1weVfJ88qLTh6LY0
	gQzhUH/ONELmtfevsSk2TWqp0MWLaPKptaCoxzBGGYwur8PhO+ct1HgLNBfBqUdP1Dl8+WkL1Jx
	mbf3oaWiWijPkezU8pHYMxXryjgXIfrbmuZYcK3q2rGHg3z7sj2zYo9GbGgOqaG7NnT+aOoCns8
	cFQLu1pN204LvgDifBd60WyQR3lQtRbk5PqYXG4wCo/0MRujS+925P6MSGx99MLgmHdHDYDx9V4
	APv+F1OAYic1WRvyjwxaG/fSXiCOEPQ1zxFgg7mVXi9Bpj1/0fF7RZuTuYkvnmP7T2XgEGG7Qf1
	DXKIVdMhpPBXYnWVhz9bY9S9PxniIGe4PJ8BCMJtpSbQqN1oWPRq0zT/l/0VSMRtwyaaOZTYwlO
	Ders73gQOOZsREdF5vfsZFiV06j1zkTXbdZVnllwyhs97j7xiJbQ==
X-Google-Smtp-Source: AGHT+IFrUC44XvQIgOPF1oe6aZhOa3HgUHCNQaYkwG+BqMdOw9kgMknMuXUQUq9O++GPrdyZKrFphA==
X-Received: by 2002:a05:6000:240d:b0:427:7cd:bde7 with SMTP id ffacd0b85a97d-42707cdc0c2mr9949977f8f.5.1761036247544;
        Tue, 21 Oct 2025 01:44:07 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-427f00b9853sm19155987f8f.33.2025.10.21.01.44.06
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 21 Oct 2025 01:44:06 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Chinmay Rath <rathc@linux.ibm.com>,
	qemu-ppc@nongnu.org,
	Nicholas Piggin <npiggin@gmail.com>,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v2 04/11] hw/ppc/spapr: Inline spapr_dtb_needed()
Date: Tue, 21 Oct 2025 10:43:38 +0200
Message-ID: <20251021084346.73671-5-philmd@linaro.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251021084346.73671-1-philmd@linaro.org>
References: <20251021084346.73671-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 hw/ppc/spapr.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/hw/ppc/spapr.c b/hw/ppc/spapr.c
index 458d1c29b4d..ad9fc61c299 100644
--- a/hw/ppc/spapr.c
+++ b/hw/ppc/spapr.c
@@ -2053,11 +2053,6 @@ static const VMStateDescription vmstate_spapr_irq_map = {
     },
 };
 
-static bool spapr_dtb_needed(void *opaque)
-{
-    return true; /* backward migration compat */
-}
-
 static int spapr_dtb_pre_load(void *opaque)
 {
     SpaprMachineState *spapr = (SpaprMachineState *)opaque;
@@ -2073,7 +2068,6 @@ static const VMStateDescription vmstate_spapr_dtb = {
     .name = "spapr_dtb",
     .version_id = 1,
     .minimum_version_id = 1,
-    .needed = spapr_dtb_needed,
     .pre_load = spapr_dtb_pre_load,
     .fields = (const VMStateField[]) {
         VMSTATE_UINT32(fdt_initial_size, SpaprMachineState),
-- 
2.51.0


