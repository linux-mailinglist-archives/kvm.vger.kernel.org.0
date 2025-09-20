Return-Path: <kvm+bounces-58321-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 264F9B8D0D7
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 22:39:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C693462155F
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 20:39:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 116322D7DE3;
	Sat, 20 Sep 2025 20:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="IZ5f8iuJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E0C22D46DC
	for <kvm@vger.kernel.org>; Sat, 20 Sep 2025 20:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758400737; cv=none; b=rupJNaUb8pbIyQ0L8Qv1XC0E2yocnlebNN+qy6E5BjgPxsBzBaORF/cxGcFHyuqzARIoFCZI9zLDDihdRqz4mB/pCDOKhUjSS0pjdUjfwoSH3Hm2Wrk7F4soUtbAyeVYoboEeLknpsPjsJ6IsQmK3otDFHhxFS51HjgHrINJjVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758400737; c=relaxed/simple;
	bh=pJK4i1P2/F+SaIV5Ypd6TZyTjZsa46FZIsC86e9sDFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oXZhmBLjBLasaKCEIB/kI7JqPgpxEFxU1yXm2NBGnMClfrwA28aD9rhhWMORe6QwEM6i4hWejXDuyEX+gaPCWbHKuK5JApSU5IS8QRbPI5ss+oToyfvvrXxnsKJ0y+dVIAVe8PEyfXdMUlvXztsl5W/LTfrw8ge0OWCXT4Jap6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=IZ5f8iuJ; arc=none smtp.client-ip=209.85.166.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-887745ee814so105351139f.3
        for <kvm@vger.kernel.org>; Sat, 20 Sep 2025 13:38:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1758400734; x=1759005534; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rfdnGB1sHNv96VJcVAg715QoFjcIQwVKNMZEvz9AAmU=;
        b=IZ5f8iuJnv943Cjyw+lNIIcS7Lsg1spdyhi38bhdwyjwRIP55Kio9dl3AxoBM8HF5E
         yMpeF5zFj07TBEr7aepJFVTEc3jeT99ynemnycfOzZxY5xe7/7wKcGIoWY+4w4ibAP6T
         m0Uc7CCXx0qYBwpVu9/0fZtJ0vI/fkwmBjZ0eRvx7/vIW6wrVSlfDxiRpTasS3Wn/xtv
         Qv+2jkyD+D2v1x5MbXbNHrjstFjOxVDygMRDw/kapTDcMVKpQH8Tfy9yD8JIY76lvVTj
         PFrXg9odoI94vJyeWsDHvHrv9CwPZoDaZG/wq0JIkTSZfc0LKtzN4BXNtAWJZLSIix4G
         XpNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758400734; x=1759005534;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rfdnGB1sHNv96VJcVAg715QoFjcIQwVKNMZEvz9AAmU=;
        b=RsY0DQ6mISeF4Be5IBmL69O5+Mq9yA5kYk1gS4zv1sf/q3ixWVUpeZcvb28CkjW2f6
         Sy/rAkr6/z/V+x/UqncEUC8FRYeEh8oVLMGeC8q7Ci5SYIG27v1iH/+2sT3nZn0N8aMR
         CwPAdxko/Eh9OfZqhWkq9Sk5/yy0yyfIMHAfT4rZ1zmu2PztulmfP5fmcqCDfPrDUvfR
         LFzwP9MGD6O5APPgr8kuhkDHNsLGstfJCtCVk1KuCEjqtUcouyQmviLouKc4tOA+ITTX
         NdhVzbUtGr3lxSqFzLR5zsODDr5958+hPxA7MiPBXfn6UtkwO0S7FTB2Bbf3KS+E/EQy
         olXw==
X-Forwarded-Encrypted: i=1; AJvYcCW6+hQAutbbJt+8cLm0uLlHGu6OC30fP/OOV/iRIrpz8ZjpV2fD0b/dtgNpIHuCWXAxAyc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw7Ibv4FTJ9hGHq92DxGuucgdD6xvzy9cFDxKibz2oTDneOkpOZ
	vU962XAz0FONT0SEQvEB9aYIqtSIhbxXOzLHKVKgxCblqUFcDgB/zaPIFdDNoBzgdks=
X-Gm-Gg: ASbGncu4cBoGsFDBh4eeofoV7o4NezO4VeXTObWd1bByWlWqLKXc4ainz2GaqE4yPSS
	p0Jv1Pp1jMheM7QIZritM7r5uRs8WrE8Us9BvwYWLnuzJvISfcNrTxjMp2ED3zoBZ2JXTuRWFtr
	TN8QBEMjAk/v2ZrIkfKsZNMCxVWIv9bvRqUChKbnkXN92Y0OGelBssnN1vtTmPS1+cDptZrrz5n
	0bzMR+wix/iWxzZMS6OMllJGAIuYm56w0PBnXfp8qHQ5NG+eg6UijgUTWuGT9a8tDEMlYQ/rWxz
	lwk8YocmW8o57aQQw10udm+/qNo6p2j8CsnRDxJw6G9ytnFM5T0U+s5qEhn+OYcRrN+Lu3KhI50
	y5ZUTlXYgntve50S5FoMUvNuT
X-Google-Smtp-Source: AGHT+IER7JqLT6oTfCQWU199+6p/3PvuPfDuYsKata5YQ6Fx68IZQQdwLhEBfg4EZlP9xJt6h7cJ2Q==
X-Received: by 2002:a05:6e02:d07:b0:424:8c2d:ca45 with SMTP id e9e14a558f8ab-4248c2dccf6mr34706195ab.31.1758400734326;
        Sat, 20 Sep 2025 13:38:54 -0700 (PDT)
Received: from localhost ([140.82.166.162])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-53d3e337de1sm3755155173.25.2025.09.20.13.38.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Sep 2025 13:38:54 -0700 (PDT)
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
Subject: [RFC PATCH v2 01/18] genirq/msi: Provide DOMAIN_BUS_MSI_REMAP
Date: Sat, 20 Sep 2025 15:38:51 -0500
Message-ID: <20250920203851.2205115-21-ajones@ventanamicro.com>
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

Provide a domain bus token for the upcoming support for the RISC-V
IOMMU interrupt remapping domain, which needs to be distinguished
from NEXUS domains. The new token name is generic, as the only
information that needs to be conveyed is that the IRQ domain will
remap MSIs, i.e. there's nothing RISC-V specific to convey.

Since the MSI_REMAP domain implements init_dev_msi_info() with
msi_parent_init_dev_msi_info(), which makes 'domain' point to
the NEXUS domain, while keeping 'msi_parent_domain' pointing to
itself, there's nothing to do in msi-lib to add support except
to accept the token.

Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
---
 drivers/irqchip/irq-msi-lib.c  | 8 ++++----
 include/linux/irqdomain_defs.h | 1 +
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/irqchip/irq-msi-lib.c b/drivers/irqchip/irq-msi-lib.c
index 908944009c21..90ef0af866eb 100644
--- a/drivers/irqchip/irq-msi-lib.c
+++ b/drivers/irqchip/irq-msi-lib.c
@@ -36,14 +36,14 @@ bool msi_lib_init_dev_msi_info(struct device *dev, struct irq_domain *domain,
 		return false;
 
 	/*
-	 * MSI parent domain specific settings. For now there is only the
-	 * root parent domain, e.g. NEXUS, acting as a MSI parent, but it is
-	 * possible to stack MSI parents. See x86 vector -> irq remapping
+	 * MSI parent domain specific settings. There may be only the root
+	 * parent domain, e.g. NEXUS, acting as a MSI parent, or there may
+	 * be stacked MSI parents, typically used for remapping.
 	 */
 	if (domain->bus_token == pops->bus_select_token) {
 		if (WARN_ON_ONCE(domain != real_parent))
 			return false;
-	} else {
+	} else if (real_parent->bus_token != DOMAIN_BUS_MSI_REMAP) {
 		WARN_ON_ONCE(1);
 		return false;
 	}
diff --git a/include/linux/irqdomain_defs.h b/include/linux/irqdomain_defs.h
index 36653e2ee1c9..676eca8147ae 100644
--- a/include/linux/irqdomain_defs.h
+++ b/include/linux/irqdomain_defs.h
@@ -27,6 +27,7 @@ enum irq_domain_bus_token {
 	DOMAIN_BUS_AMDVI,
 	DOMAIN_BUS_DEVICE_MSI,
 	DOMAIN_BUS_WIRED_TO_MSI,
+	DOMAIN_BUS_MSI_REMAP,
 };
 
 #endif /* _LINUX_IRQDOMAIN_DEFS_H */
-- 
2.49.0


