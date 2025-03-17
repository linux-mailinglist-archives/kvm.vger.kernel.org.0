Return-Path: <kvm+bounces-41195-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 379A2A6499C
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 11:24:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 13CAC1692DB
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 10:24:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABDE92376FD;
	Mon, 17 Mar 2025 10:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="ZD8iWr2K"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD97238B
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 10:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742206815; cv=none; b=r8RI3pZ9CjU/9qKfDpy4oRIzBjf12rrx4m0BNBrGo/lg4HoLfwNH4EmTPALok9jTTpNA+pfdKDqKB9PECl6nw0yjdfvO4NlREthb2/sdUnNfn7OH6vHrWXdmC3xoVuDXbQXjeXo0T1HhQemy37fJDeSNGCZW6zqZLuEXETH1Xvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742206815; c=relaxed/simple;
	bh=DjyTf8rvGg+sxlrtrvr2LrWvnoCj1tzl8p+htzo4Khs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DGiSeh0OCJgzFHwbNZfNtIq0pV10RUrHSMlMPfh7ISiUXlTVs3Q2bPMMBDioN2EhtkasfPDWiQcB0QNWQpXfURVkXgo4fjJnLHNa4YI5MYPUkXCwl+gAzgqrj1YJmMjTOMyIcfSriTF6fPM0ZKDafuinqGzLDRbD2RsYW0vgMmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=ZD8iWr2K; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-38a25d4b9d4so2320976f8f.0
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 03:20:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1742206812; x=1742811612; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gp1/a4HJMNi1Mi5InH5hHHDY+xPb3C4W59LQWScL2LY=;
        b=ZD8iWr2KUh7m45RlpC8KEsuKs3Cki9ZkvTGKXS3q1HP3Ly0Lxje1VMn7ylWYCJIMVK
         0XHliYIDWJ+1kEn7JHc/bWqm4ey8unAUb7rp9dVyhaOo/E4vLZ/4/Y854pmNzSDnoHNl
         A0u2X0vgrJwBbLpM4++SMgdacFVomo9HwJ9SjImCNyIw7atyoaXIfb3kuVsE9cuZnbVh
         d/XxLrGhR96Yb4ZX+xPNckmHL2XwXnZO4wnwEN3s3I/32iDpwuPRDVuUx/Yi0b7Ohle7
         jcsdw10s1mcSPdk3aZnMLfjqd5YqqjNWKGWIvBexB9v4ExcD0t6MVGbzt5b3L31KvekI
         O4Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742206812; x=1742811612;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gp1/a4HJMNi1Mi5InH5hHHDY+xPb3C4W59LQWScL2LY=;
        b=QLVmfLs/DfnE7ETQ+7d4JdEVbuLsbF/BWt7L5zt0pf2Gk3tdiIMS4ZsDVtqgJUFrJ6
         aQ8bbar61Ohx18Xb1X80tEVgoIsnXWbatFmo5MnRrY/m+p3gyU8lAbs+i9redH72TgqA
         gJvr6qZI1+ns23ra+thMH0PLa1rKH4S487nzPxXkoaI7ffzxPUIvCdSf/xLhTQ9DREdT
         n51BFMh15L/IxtwhDbSU69oTLraLobJxbMcn4yb6S3iqh0kvdz44NpzRCHejJ0A4HN5p
         b1JFJBS+7haCqlNzfKWJU4u9ndAxcIXhlH/3yESiH746Re0SJR8bF/0pqKeNU8DN5rD5
         KxRg==
X-Gm-Message-State: AOJu0YwLBLKf5o7KbnvPkQ/Be3vqLzCGEpKJOnvttMaC097kQPVPlNlx
	sMjGXwrvB/qPGwPWzCEPREQff90i1uWs3h00hEk8my++uS4vbQTn0Cbui34d3nTYiF2I3NPSDck
	0nOM=
X-Gm-Gg: ASbGncvWz0tFDtiVNRNJaBDr//TO9BBi6+5x+nsi7jj5g5WRgvskkpIL84wFoPDgzQV
	DY6wOJmvVzFtvLjj8dlIqPVns3fel59uHRyiv2oC3G2SHoA8y1e2s8yTuO0X04OTAh4UG1E2YYa
	+ufDKT/uHNX+sJhpvgI0n+FhVYGL+0NKcU7EQ+4OUGtrcmPhsE2N0ttUcyR5BC2ZWbeL0eXs/al
	XK9VArq0LFUCRq3V0omiL76OxFczeXwOE+LqQUMWK1zyDdO+oN+95wvzddXvEMfeX4U5LNVstYe
	qp0Iii2fEsSVEq6MnMbAJM6ZepedRA4QTROrTa2xRPW1sQ==
X-Google-Smtp-Source: AGHT+IHWPJvKV9ztMSxyKCQmKirUBG/OWUKVDifeOoh2M0LJzrx61uMnqOH/Bois4cDB3Jj4J2ifnQ==
X-Received: by 2002:adf:a184:0:b0:391:39fc:6664 with SMTP id ffacd0b85a97d-3971ddd8fc0mr9391297f8f.6.1742206811939;
        Mon, 17 Mar 2025 03:20:11 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-395cb7ebe3csm14749824f8f.99.2025.03.17.03.20.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Mar 2025 03:20:11 -0700 (PDT)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <apatel@ventanamicro.com>,
	Atish Patra <atishp@rivosinc.com>,
	Andrew Jones <andrew.jones@linux.dev>
Subject: [kvm-unit-tests PATCH v10 2/8] riscv: Set .aux.o files as .PRECIOUS
Date: Mon, 17 Mar 2025 11:19:48 +0100
Message-ID: <20250317101956.526834-3-cleger@rivosinc.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250317101956.526834-1-cleger@rivosinc.com>
References: <20250317101956.526834-1-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

When compiling, we need to keep .aux.o file or they will be removed
after the compilation which leads to dependent files to be recompiled.
Set these files as .PRECIOUS to keep them.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
---
 riscv/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/riscv/Makefile b/riscv/Makefile
index 52718f3f..ae9cf02a 100644
--- a/riscv/Makefile
+++ b/riscv/Makefile
@@ -90,6 +90,7 @@ CFLAGS += -I $(SRCDIR)/lib -I $(SRCDIR)/lib/libfdt -I lib -I $(SRCDIR)/riscv
 asm-offsets = lib/riscv/asm-offsets.h
 include $(SRCDIR)/scripts/asm-offsets.mak
 
+.PRECIOUS: %.aux.o
 %.aux.o: $(SRCDIR)/lib/auxinfo.c
 	$(CC) $(CFLAGS) -c -o $@ $< \
 		-DPROGNAME=\"$(notdir $(@:.aux.o=.$(exe)))\" -DAUXFLAGS=$(AUXFLAGS)
-- 
2.47.2


