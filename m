Return-Path: <kvm+bounces-31859-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1802E9C8F8A
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 17:20:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D06E228B0AB
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 16:20:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B81AB188708;
	Thu, 14 Nov 2024 16:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="h5B7kqKt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18B7A185B6D
	for <kvm@vger.kernel.org>; Thu, 14 Nov 2024 16:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731601134; cv=none; b=rM0Dplagbz1l8zrsv5jsqKxIVCOT8I/dQSENkaBPxESpn4rz1PlHHUREZ60ptSdmyCAnL/HGWhZNjBQeT64RQq8tqf12jSVt+bnxLDfOPPYNz+AIXfgrxnBUA/08+kxcSDkhWAmGjzjcFIGAJ1bmJzADEHdwvziFVAzicoZM9IA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731601134; c=relaxed/simple;
	bh=NzQJBoC/AMGjdcz5fUxYJHaJ2T5WgutxrlJ2H2gtLTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CPCPvBvIN0G0afEH1qNCQV1jfmPHlNBzKaKlJKrYHnD6qXgOtDg+ljwi5FhCXpOLH4LcqIyEtstAehIb/nhtIUdkPVGe4BPhmLtWS9y31sfs9y3ihtqQ6kCv1Xx7f9aChqZHYvaKKk9kE+/xkOAaWvQYw/vuakQLXB/Qnit5qUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=h5B7kqKt; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-53b34ed38easo822049e87.0
        for <kvm@vger.kernel.org>; Thu, 14 Nov 2024 08:18:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1731601131; x=1732205931; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EgkdpOYsLIOn0iKAKl5fgt6eXL8Mzl+XIucJ8fWc9TA=;
        b=h5B7kqKtNlz0keBSJ6L9z3uNVroLZMvCO7rHbNBSELLix0MPQeWidHSSHgtozh1Qxw
         rQPbbka2ZCerR68GE6loC6UUBnuJgjWC2dipbRo1u+d/+IbwTKwgPmK0C5patPP99VO7
         Jrx2i/dCcEN1+Lx9ZJyT+zXgmHNCmGIkdvqLS5U6PvnrW6/IVPYrPNhPMzSjMsaV1jHB
         lpfIsgIl/7trYNUNxGhyFshmWivhzB7PQl7jvxvzp1JJPBrOd1VbOORPLl3Bi1X0ENjm
         EujcdBFGfqLe9w3q1AO508CZz3eVRaW7WMhf3RtuTPUodQMDt0Rk3kQ/DQ+DseJVBTN5
         RdFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731601131; x=1732205931;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EgkdpOYsLIOn0iKAKl5fgt6eXL8Mzl+XIucJ8fWc9TA=;
        b=fnYgFwKHfQB6jEK5SjMtESWbqJAftiRK6snm8aDcgZsCVudwhr1saZL1M6Z5fvTkkA
         O3QNl/+P9Z/2YYJC5GSTbCyYexdiZgZFxuoYcOJ0g9dhVTWXTUpa1x/VEtpevCmhWPb1
         BmN54MIg92DKmZrDSjAJo3mep5sb6yU/uCjEctu+8CQnlmiXwxewFN7gFmoZw+w65R50
         Eni+3grRF9ayAZ0UYFwBX7DQkQLkRYEVT28JRdYOjU3dgGyh5jfvK1bwQpxl4wHzll/s
         W//rwQ7+dpL+LNu4FuYT1C0cPiZiHBnru3uSXFWZUuOJnPV87qii2/wFgX+WOR962STp
         xE6Q==
X-Forwarded-Encrypted: i=1; AJvYcCVMA3EjBzVEXKDKHTcqw6AMLUriZGPbNazU3imI78vpk5uABdtIvR31X9eyOA9KuYS/AJw=@vger.kernel.org
X-Gm-Message-State: AOJu0YyyYCYYoputNqItdHzn/nm9VGfFWI2EfgK9TyfgKvjXWmwx3uuX
	wYtV1u2cCgjzQ1xd1DbL8nau1UmIJ/lJ1p2xkYchfTRQlEowZWT6xn1o+mfNjYE=
X-Google-Smtp-Source: AGHT+IFd0CnkIMN5l0Pz4D+G0QBgRZi3KYTDXcb5xA9gQJqvW8wTertCqu9+xj4IWnW1G55hIkNGVw==
X-Received: by 2002:a05:6512:3ca5:b0:539:f607:1d2b with SMTP id 2adb3069b0e04-53d862b45e5mr14144215e87.7.1731601131046;
        Thu, 14 Nov 2024 08:18:51 -0800 (PST)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432dac1f409sm24906005e9.37.2024.11.14.08.18.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2024 08:18:50 -0800 (PST)
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
Subject: [RFC PATCH 03/15] irqchip/riscv-imsic: Add support for DOMAIN_BUS_MSI_REMAP
Date: Thu, 14 Nov 2024 17:18:48 +0100
Message-ID: <20241114161845.502027-20-ajones@ventanamicro.com>
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

Unlike a child of an MSI NEXUS domain, a child of an MSI_REMAP domain
will not invoke init_dev_msi_info() with 'domain' equal to
'msi_parent_domain'. This is because the MSI_REMAP domain implements
init_dev_msi_info() with msi_parent_init_dev_msi_info(), which makes
'domain' point to the NEXUS (IMSIC) domain, while keeping
'msi_parent_domain' pointing to itself. The rest of the IMSIC
init_dev_msi_info() implementation works for MSI_REMAP domains,
though, so there's nothing to do to add support except accept the
token.

Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
---
 drivers/irqchip/irq-riscv-imsic-platform.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/irqchip/irq-riscv-imsic-platform.c b/drivers/irqchip/irq-riscv-imsic-platform.c
index 5d7c30ad8855..6a7d7fefda6a 100644
--- a/drivers/irqchip/irq-riscv-imsic-platform.c
+++ b/drivers/irqchip/irq-riscv-imsic-platform.c
@@ -246,6 +246,8 @@ static bool imsic_init_dev_msi_info(struct device *dev,
 	case DOMAIN_BUS_NEXUS:
 		if (WARN_ON_ONCE(domain != real_parent))
 			return false;
+		fallthrough;
+	case DOMAIN_BUS_MSI_REMAP:
 #ifdef CONFIG_SMP
 		info->chip->irq_set_affinity = irq_chip_set_affinity_parent;
 #endif
-- 
2.47.0


