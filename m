Return-Path: <kvm+bounces-31856-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 460B99C8FF6
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 17:40:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 30EBBB305D0
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 16:19:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D82C181334;
	Thu, 14 Nov 2024 16:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="ZwYZ1I1g"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F015713AD39
	for <kvm@vger.kernel.org>; Thu, 14 Nov 2024 16:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731601131; cv=none; b=tPEA4zMho/YbtyNwsUBRLTnZjhn9Tpzj2yfmH9Dq0uW4vayEjqaKgMf1Rl6PjpR2riNbWG4RsL8kAmlfR9yOEbdpBltg/yJSl9VBRMlb3C1UTmN8Lb3LD/cCJHidUF/LaDCBtJ9tBdoqAkL8++GMMQ9+c0/BUAU5taSby5kIoeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731601131; c=relaxed/simple;
	bh=g+8C+bxaMal2sistKMy08AprWRr5v1lTzqnhoi4uxEc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qLmLlwgjvJZUrbL0sOhLgGylggVnnTCm4U1NNBMPEl6q7H6B6fSIkF2pH5ZjGcOvbirjUCz3xKrWALrT1kNU9hre20ntg4CZ85wRr1SG9mh+NmiEcwbLZ1jgtMfkJ6m8Bz20hITUqNQsC+yr0VtDHYHoknjCKRUUvsr1KO/sRAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=ZwYZ1I1g; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-432d86a3085so7716455e9.2
        for <kvm@vger.kernel.org>; Thu, 14 Nov 2024 08:18:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1731601128; x=1732205928; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D3ezq2WAE13GAqwSlX07T0LyNCWtPpuH6EoHFe0wCHg=;
        b=ZwYZ1I1gmsoZ3IIftmTQcKn4wpbAPoyKZs+CuAflG6frSJUbq5+jIATD/QqusKv58I
         LlY+g8jnnG4tTEs9vXXj5Mypr14WX9hRQUBVkuj+DpbaeES7fZ1hCKkEbDbLM4f3BsWQ
         X/kIRDf6TuzZ8ZPxjgMzLFPig3HqB49kch4p8d1YhlMzGaAyHDVXs6ZXSAf2p2YR5xsC
         2p28pjym0AXwwuWFYmANkp3hoMkGEfuKoHKg46wB+p1OPxXrILTupUN9W4HMyvHBeH+2
         bs8rVVHFuixDMZFmI58YyLqdB2mTXH5m2whnSOI4QUPjlm6M5pqS4JUZWVLucFYk28+B
         h6yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731601128; x=1732205928;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D3ezq2WAE13GAqwSlX07T0LyNCWtPpuH6EoHFe0wCHg=;
        b=DnQ+csFMalc1/WdIgJnCLc1Ows+g06kZp0z9UboG6itmIkdFePgH/Yv1R3Mdp6nnus
         zGCM5jsjfY3z3Z4BSdrGRADR5QDWTKXkMwi1nbOKAHbpNcuRD1qhS0iADQSsPolr7kpA
         ewUpD1NBS6aDL6HmQjwUl00eSs5ms9z7nfTah3xsDAO7d8RlMfzUeYUbexTHJoK6bbsr
         MW+otDmF9MURhcw5+sRnDkx++ic/O4IdtmENJp1pIbcSZH+Iuq3zb7xfkVePyCsvxzfA
         wP7x93RoQOPhLvsZZ9OJv8/IgFvN0xKK2fczE2BEc3oi4H57rUgzKjNJfTUB1V1rBHtu
         4Nqg==
X-Forwarded-Encrypted: i=1; AJvYcCXuYQRLLdSML8H6HaZ1wdWKzXQdDJeGnJvEnBNXl/vYfzpVui49bInmiqvd+L4vUT39xx4=@vger.kernel.org
X-Gm-Message-State: AOJu0YyCbeVjiB2Boclef5iB2udSBaP0rnPmWNcch3zVwPCDkP2BgD1V
	i9969YyVx9X6C0G/PsCdaBWxTUNyqWiVzDJZ5A7xqGBFM4skjcdahh1x+paZh+8=
X-Google-Smtp-Source: AGHT+IGL/aKw/LZ1JTJ7uKMa5kImPbRP3wDn7MPyUSWssqMaT5McjPD8vLFqR2fLEptCKYdvhP3z0A==
X-Received: by 2002:a05:600c:1d1c:b0:426:6308:e2f0 with SMTP id 5b1f17b1804b1-432da7cbcefmr23145865e9.26.1731601128138;
        Thu, 14 Nov 2024 08:18:48 -0800 (PST)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432da2800absm28573255e9.25.2024.11.14.08.18.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2024 08:18:47 -0800 (PST)
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
Subject: [RFC PATCH 01/15] irqchip/riscv-imsic: Use hierarchy to reach irq_set_affinity
Date: Thu, 14 Nov 2024 17:18:46 +0100
Message-ID: <20241114161845.502027-18-ajones@ventanamicro.com>
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

In order to support IRQ domains which reside between the leaf domains
and IMSIC, put the IMSIC implementation of irq_set_affinity into its
chip.

Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
---
 drivers/irqchip/irq-riscv-imsic-platform.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/irqchip/irq-riscv-imsic-platform.c b/drivers/irqchip/irq-riscv-imsic-platform.c
index c708780e8760..5d7c30ad8855 100644
--- a/drivers/irqchip/irq-riscv-imsic-platform.c
+++ b/drivers/irqchip/irq-riscv-imsic-platform.c
@@ -96,9 +96,8 @@ static int imsic_irq_set_affinity(struct irq_data *d, const struct cpumask *mask
 				  bool force)
 {
 	struct imsic_vector *old_vec, *new_vec;
-	struct irq_data *pd = d->parent_data;
 
-	old_vec = irq_data_get_irq_chip_data(pd);
+	old_vec = irq_data_get_irq_chip_data(d);
 	if (WARN_ON(!old_vec))
 		return -ENOENT;
 
@@ -116,13 +115,13 @@ static int imsic_irq_set_affinity(struct irq_data *d, const struct cpumask *mask
 		return -ENOSPC;
 
 	/* Point device to the new vector */
-	imsic_msi_update_msg(d, new_vec);
+	imsic_msi_update_msg(irq_get_irq_data(d->irq), new_vec);
 
 	/* Update irq descriptors with the new vector */
-	pd->chip_data = new_vec;
+	d->chip_data = new_vec;
 
-	/* Update effective affinity of parent irq data */
-	irq_data_update_effective_affinity(pd, cpumask_of(new_vec->cpu));
+	/* Update effective affinity */
+	irq_data_update_effective_affinity(d, cpumask_of(new_vec->cpu));
 
 	/* Move state of the old vector to the new vector */
 	imsic_vector_move(old_vec, new_vec);
@@ -135,6 +134,9 @@ static struct irq_chip imsic_irq_base_chip = {
 	.name			= "IMSIC",
 	.irq_mask		= imsic_irq_mask,
 	.irq_unmask		= imsic_irq_unmask,
+#ifdef CONFIG_SMP
+	.irq_set_affinity	= imsic_irq_set_affinity,
+#endif
 	.irq_retrigger		= imsic_irq_retrigger,
 	.irq_compose_msi_msg	= imsic_irq_compose_msg,
 	.flags			= IRQCHIP_SKIP_SET_WAKE |
@@ -245,7 +247,7 @@ static bool imsic_init_dev_msi_info(struct device *dev,
 		if (WARN_ON_ONCE(domain != real_parent))
 			return false;
 #ifdef CONFIG_SMP
-		info->chip->irq_set_affinity = imsic_irq_set_affinity;
+		info->chip->irq_set_affinity = irq_chip_set_affinity_parent;
 #endif
 		break;
 	default:
-- 
2.47.0


