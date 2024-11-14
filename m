Return-Path: <kvm+bounces-31871-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D3B1A9C909B
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 18:16:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 62EB0B3BF1F
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 16:25:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C9D71AF0D7;
	Thu, 14 Nov 2024 16:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="i/dm21c6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E986F1ADFEA
	for <kvm@vger.kernel.org>; Thu, 14 Nov 2024 16:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731601155; cv=none; b=Yyjt0T5ZUEtF31NdhOuIscVzDrxCXX26saKhTgrpc5epUV5jxN7Z6bhA662CFQ3uXczxdukaxVfXZEcZOma9xmcHrcl140FpHDn8GHjrNyisP9qSozTQ1yeZrWgFEpomGDXxaQG580BBP5dJfJUdHcY/3YE+dQ4ODZ0C41wAakQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731601155; c=relaxed/simple;
	bh=nPnauxX7TiBvZUSelznoj4ZrHIzLIbMVHtA1EyH4RVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bJm/ImB1izp2K2Bc5qBZVWAfB/pnBkNwYSG82aDSZUV81v1FBBFOQOTP6dHIs2nBTMXcAsfa46PVZVDIRrIQ4B0Dfz8+AnhsHsEY3eu1jhRwJslXlfXuSPKUTFVNg1AqFd1lOaV6tIk4QlAKlP8lsVUDFYqUxZzlQ8EtxoTD9gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=i/dm21c6; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4315e9e9642so7301125e9.0
        for <kvm@vger.kernel.org>; Thu, 14 Nov 2024 08:19:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1731601152; x=1732205952; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bLyjPEUjYy3GGHllbim/73zpVvmemz3R8H3vfZF+LqU=;
        b=i/dm21c6mHbPUh0kR2V+NaD9L4LdKkTk3mInd+TPeSVk7MDkqijGAwQrIB9Z+T1zJc
         xmfoA+ATnVC7IRs/FxWba3DRi/SGb+YLPbfDLxhAE3ccENfNOQA6fpzeA3CQlyJ0aOs5
         wboMSAFzZrIVvtHiYsvDar7j2RDk3qRxZpbmhPlnAeR34oS3U4jkMHMyJ1v/vKx7+j4P
         TLnqGL7KqozomSlKbuk8pOW6oKctTDeAza+O5PP0S3VJGnXumADG8H0T2sL/WT+XER1s
         Nff69oehon4dCrZ+XEi+GZ64a4nRuKatR39W/gcl3wV4YEiMqM3CdzpuKxGxpa9UT0Dg
         RbVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731601152; x=1732205952;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bLyjPEUjYy3GGHllbim/73zpVvmemz3R8H3vfZF+LqU=;
        b=fXtztU9sutkK3q4r/RrHGzbHcOQhsn895YxpV4fiHsuTzU2TPz9banr3gCfJeOelUB
         jbMOilxvHYVUuo/ekXIQRzMLCIDMq54HkU3FIZaMhA1nz0P398NukYHqltbIQ0rzo0W1
         B1MDhnrNL6/cQSZ+go97mB+7pZuQBo/3UbWaOj989lTqDYk2SMU9+/ujBRpN+qDm0HCM
         KJQHrgDuFHgZ960IbHlCQzsw/joHYVFSbx2TJdv4o5kwQxy/DG8oBshPOD8/b0Jy7m69
         eZj8psbvdaWdug7vfpo81YJ/7UvmniLIguYAzmIglWCm88DKT9ICSj2KH2D3SUnq7OmM
         p4MA==
X-Forwarded-Encrypted: i=1; AJvYcCXhtcj/a7nEjdY3P/+8XSy9MfOBo4kQx0cRFKNZFpgeNm4hevpugyGzpuH9NqEhlgkQ9y4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzWEOrPaJOXMqvqRCt9zGFDCRw/ls9sbF8Dlr5bwj4M0ljQzMp1
	H34gMxTpezvf5VdtkDOIx2kuYJ/NGlhg+bPjmsgcVx9AZDsD+JZF6GVi+HnH+jo=
X-Google-Smtp-Source: AGHT+IHKQidNVhwcm1UkvoSFM0iFKvguMA4Koj+yRoQBZD+zU91sO767fbB1E85gsh6vbgzv0SLQ3g==
X-Received: by 2002:a05:600c:c08:b0:42c:bd27:4c12 with SMTP id 5b1f17b1804b1-432d4aae6b7mr76573235e9.10.1731601152220;
        Thu, 14 Nov 2024 08:19:12 -0800 (PST)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432da298a41sm29066525e9.38.2024.11.14.08.19.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2024 08:19:11 -0800 (PST)
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
Subject: [RFC PATCH 15/15] RISC-V: defconfig: Add VFIO modules
Date: Thu, 14 Nov 2024 17:19:00 +0100
Message-ID: <20241114161845.502027-32-ajones@ventanamicro.com>
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

Add the VFIO modules to the defconfig to complement KVM now
that there is IOMMU support.

Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
---
 arch/riscv/configs/defconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/riscv/configs/defconfig b/arch/riscv/configs/defconfig
index b4a37345703e..10fc9d84a28c 100644
--- a/arch/riscv/configs/defconfig
+++ b/arch/riscv/configs/defconfig
@@ -242,6 +242,8 @@ CONFIG_RTC_DRV_SUN6I=y
 CONFIG_DMADEVICES=y
 CONFIG_DMA_SUN6I=m
 CONFIG_DW_AXI_DMAC=y
+CONFIG_VFIO=m
+CONFIG_VFIO_PCI=m
 CONFIG_VIRTIO_PCI=y
 CONFIG_VIRTIO_BALLOON=y
 CONFIG_VIRTIO_INPUT=y
-- 
2.47.0


