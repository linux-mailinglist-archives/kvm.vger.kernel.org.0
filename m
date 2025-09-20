Return-Path: <kvm+bounces-58337-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F2B6B8D137
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 22:44:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B5C7116A0FC
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 20:43:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 670AE2E8E0C;
	Sat, 20 Sep 2025 20:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="OtNloihb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B57152E7BA0
	for <kvm@vger.kernel.org>; Sat, 20 Sep 2025 20:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758400757; cv=none; b=fK2T50BJ+ijnu8vAdGL7AdM7ssFr+7G3KU3ptROblgPtyrENmSpnrT2/lulnad8r2GImroQgH55SCL2R2aL3FmDNX5s4xc0Q6udi6Lo/JT3X8cNZ++cOZVRILNRiybP3vkBmSv7ooyeItY5J0NxUXAHkSuKakivWfuN8V9khYcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758400757; c=relaxed/simple;
	bh=E+sSPT+kUSejcvl41Q1TeDzQ8VYDhNgMKLADnh8bTf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ai+0G2i+aiNQRK0oLe8ovZt883eFa9dTfYMpD4SvqS1lbevxAFcd8qe1BVwjLRZIK6dGDVE1JSj7gHuKW6cWsobk4ixAyJgFB9ZbLjw3Rx9VZ0mZtz9usNDBmtQfsUYapFUw56dTUdynySnxjWaGWR0Jan81s27yifciFiPvJxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=OtNloihb; arc=none smtp.client-ip=209.85.166.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-88432e29adcso101589239f.2
        for <kvm@vger.kernel.org>; Sat, 20 Sep 2025 13:39:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1758400755; x=1759005555; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fhgo805sVSiR0SJlmhLHBR/NhPzSwBuZgQ2sQCeXYLE=;
        b=OtNloihbqXsX22NyniNkWSaq26qpE4C4ptOgb9jMqrBTcAnhvNDZdy7O91fL6mVBaI
         wSp7sXRihmaLyA+N8p0hriJ3C0k7rfQbxmM75Be3pdrKlGMaqQk+vuFSjqjAArmWBJgR
         Ix2yVHVrIVtvFOc3HlcMQY0HbH5Y+XAv8mJaJCnrOCoZ5UhDL3laSs+Q8n1SRDIhlbiv
         ruzTOHP4sSQkSVa9RD6VOkRVnoSE0d+Sg7I3VUR/3sMPTfWxGH6H+hUIlJ2N0F+lOZ2L
         upruHfLSn1CjNYbqyC690BKiQ4K8FhmabgyFPvfDNZvxH3DuBNZd1bwVDQ0NPgGE0zGP
         4aDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758400755; x=1759005555;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fhgo805sVSiR0SJlmhLHBR/NhPzSwBuZgQ2sQCeXYLE=;
        b=oAhf7cc049H4cUWAwfq3tuhwy5hCaLH+/1/oOjEfpF1NH+kx2daLnQiB8c6mOcPWQP
         1fWKhvfLtaVYMJ/EzX/dzBp/A6O1A5fePlBl10jnjfmowcjTZjylna8tOX7pK3fgecQm
         fEze5Fxf2zwsf9Dp3GsOTIhjejML99nx8/mziqjb5BGTA0dMtgBxp6XFDlQgCVgwo8df
         Guk/7TI/bdlp/YIWZhPpWrabMxFTX0QTeyK3/VABhgHX0lSDOPRJornkO8dhinEoVVVb
         qKd/2o4Dl40X02xKv2u5dGxtvDaRG9PftG5SqtiUn9qyH2DRIGWJ2F7D123JAoWykqfd
         pwXQ==
X-Forwarded-Encrypted: i=1; AJvYcCVG/S8EEvmgyTZL7/kISRgs7RdqHmkO1Kadhk1rahm5jJeKrl5pUgDdw54AKzU/i3Fq5Xo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwA9o0uwsHGAE2z0eW20MREeigZH9d/EkWUmLwM08sbFbvfQApR
	JmNiUS+UiKAXnPJKCt3P2rvEv0tBM1K7GcIEA+f84JfckVy4hPKYjSWR1LuT17dRP+8=
X-Gm-Gg: ASbGncsl3SagG/IWetkKqWuJ9k1awyEhkcaZhkYAVPBIKmM2sMaikhdmxelrd/NeAFF
	aLRiqxN1zF3aR3gUJhXgb5UFwF/kR7xInhd1HzxYdhR1W73Dxx3KYM4iI2W1gYsWQ5fYsD5DQSK
	zDUfqkhy5Hve5qyTXg9Eajmu3StbYtqYPEt/onzdn5onvo6r6zKIyeD7rXKLaAayP3aJLSqJB5B
	Ln2FCTG0Km/fd6xsJKmkM8DSx7ADTzP0MFK3/ir0YHrvsVTsDfKY7H8HrRAgmOEFI0++XS+3r/I
	dTnRz13WzMDTccJ7SQu4FmSrDdeygV30PwDtRJhPugG6YoY9jTmsZ1zcbVbElMdAjlDcEcAeK7y
	RAhyRhmv+YAOyrecjWge4F5GksdnCYiGC9/0=
X-Google-Smtp-Source: AGHT+IFpmX9UAkdlqyKeAFy3AzOo21LtEJum96Rzv+8iJlkbfeuTwtEuWDKpDYd555ixOqfVlv44jw==
X-Received: by 2002:a5d:8791:0:b0:886:c53c:9175 with SMTP id ca18e2360f4ac-8ade08247f9mr1118249839f.16.1758400754919;
        Sat, 20 Sep 2025 13:39:14 -0700 (PDT)
Received: from localhost ([140.82.166.162])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-54cfd9b688esm2100997173.84.2025.09.20.13.39.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Sep 2025 13:39:14 -0700 (PDT)
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
Subject: [RFC PATCH v2 17/18] RISC-V: defconfig: Add VFIO modules
Date: Sat, 20 Sep 2025 15:39:07 -0500
Message-ID: <20250920203851.2205115-37-ajones@ventanamicro.com>
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

Add the VFIO modules to the defconfig to complement KVM now
that there is IOMMU support.

Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
---
 arch/riscv/configs/defconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/riscv/configs/defconfig b/arch/riscv/configs/defconfig
index 7b5eed17611a..633aed46064f 100644
--- a/arch/riscv/configs/defconfig
+++ b/arch/riscv/configs/defconfig
@@ -242,6 +242,8 @@ CONFIG_DMADEVICES=y
 CONFIG_DMA_SUN6I=m
 CONFIG_DW_AXI_DMAC=y
 CONFIG_DWMAC_THEAD=m
+CONFIG_VFIO=m
+CONFIG_VFIO_PCI=m
 CONFIG_VIRTIO_PCI=y
 CONFIG_VIRTIO_BALLOON=y
 CONFIG_VIRTIO_INPUT=y
-- 
2.49.0


