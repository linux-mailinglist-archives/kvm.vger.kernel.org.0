Return-Path: <kvm+bounces-36388-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 79347A1A6D0
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 16:14:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 16C913AD36A
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 15:13:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C42EE212FA4;
	Thu, 23 Jan 2025 15:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="N/7TgJXA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BCF1212B11
	for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 15:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737645224; cv=none; b=WAi35PA6DE8tdhh8PVqH2QfQSmcCYWKk8jtY6ouFbVFsdi6EOmoxLjIVeBHWht1ISys9WiAGo7QalcgA56p6lyLifIiJ1f/bqE9sZpMcSqaL3mySL45dQwcrZrASk3AjTU7wngfR/+x1l2xmMIPMLPJEmmaqptxFrhWYBbosea4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737645224; c=relaxed/simple;
	bh=1Xw7z1ezEsIqcX3ExF/Cy15kNP63RM4niGVqa5RRbwI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sxFoJS1zibVjNUpOTZPM/kqVnco31I8cnzhkr9gitdPsQsnN3eq1u3pZ0kwERUYSEspsUpeDmI9gZuejnn796JgRMn2ZbJC3JV0FYn5CvzGHjx8s8iFKeVI57maVO0dfNnt0swUDBK6Ny8Rw322Mi97BTXaZ2Q1DwG+hsjGsxHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=N/7TgJXA; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-ab2c9b8aecaso187111766b.0
        for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 07:13:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1737645221; x=1738250021; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qHqvyeIGaMhd+4sCu2HyPNjzGSFDyOvanlIwsvPW3QM=;
        b=N/7TgJXArYRChh2Y1NP92e7abYEGcPH/a2iidkZx8kdgpyTMj7EYix7v+bcnqVHn1y
         gWQSwfQgJeTbnSa9Ih9h2yh8Q0E4BgdFjXI0PU+vJdEgPc2y7AMyX73yRQfjZLA89RHa
         4VrnHcv5DwIQ0aAUqVtucudeBOrNMVEPvLRUgZK/y3xMaT170rLfkahy3WOiCg9adtKq
         wtcEHL6C112JzTTCjhRgaAyorinzLywhKmbLQ79GJB131MHdS7B56qCA4JYb0PomL9Ds
         RMxYtkBAkQNvBitVS/PS+9LL8Ip8tnWMYBfV1LDyveFV5HvOrUbGcfybBehnFFc9+S7s
         mwjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737645221; x=1738250021;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qHqvyeIGaMhd+4sCu2HyPNjzGSFDyOvanlIwsvPW3QM=;
        b=hpdv4b5pEUkRN3octwM5uVgJdIeMC08ZSS217si8/tvxFbs59AwJ8dlIPOHk/Rhoyc
         2Vldb25FJcLyiKYAl8t4Nu8LOtCtBk91vEEahka3pkvN8+XU4M0bVp/lm7TJY79zYqOY
         OlFm+6d4S8XRZljhB78HTXiiwclfShyX1nbPiehUHoEk/cu+/ctBxUSyNG5UQq+Sdadi
         EvOknWErLJpRkLFoHgeouljnU9xR4VC/azK7I12YZ7OEqDNXcwveVUiUQ5+IkmX/SOUx
         4NsEbNW8A/bCi5uAxwFVKnpgoj9opH24NvEJhyI0ibhi+wGevMtf/kucJaZoqJXmAkgi
         tZRw==
X-Gm-Message-State: AOJu0YymMwJstceh1ZeKAxy7UFDBKR1+nNWZDgfRRh+v1Q5yC6E7twnc
	c1/TYE2OFR88Nyk1zNKNg0PhLVq96mz6eUNEJNjbsIWA2CrXNzqt9uHYjTg6m1XbfD1YVOvAF+4
	c
X-Gm-Gg: ASbGncuuPF5Z4YgbCQwDvqY/UGLkmgRMPXKqiyvE8LuNmrDhuMwZPaYHMkCJcLJWZQU
	mG7tDXKZbf9dZPwEL/E11B5V5Dvozq79AMPE5RNT2JTf/FrpG57nRqGY7zjTvgvO1wgD/Vnm3tr
	yW+eb2A6Dxynov03EX0KoMOqkX6NbDxlme0h9ZK4ts5ylVIX7eE2VjdhVhgj88lyCtp14OkfVy0
	tRaMmBKuOZKBBxLXXSYk+cCsUjbzfNB2K80L/2mAEXYa4/wb+5RnHFvxBtOzvE9UjIAFgFsp2FV
	oYFrZU8PpG2vjoUosgLYun1Zp50O10WgiJfci9GB3HDLSoU/4tpIiD3mLEMiFNA+Sg==
X-Google-Smtp-Source: AGHT+IGigEydQrf4TxjmuIGB2jriHQEKQZUmk5+pAXO3TSAfnfeNk4Y+8Kj06SGLsmiqSBNcvQbBWw==
X-Received: by 2002:a17:907:989:b0:a9a:bbcc:5092 with SMTP id a640c23a62f3a-ab38b380857mr2393509566b.39.1737645221265;
        Thu, 23 Jan 2025 07:13:41 -0800 (PST)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab60d690232sm504698066b.37.2025.01.23.07.13.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jan 2025 07:13:40 -0800 (PST)
From: Andrew Jones <ajones@ventanamicro.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: Anup Patel <apatel@ventanamicro.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [kvmtool PATCH] riscv: Fix no params with nodefault segfault
Date: Thu, 23 Jan 2025 16:13:40 +0100
Message-ID: <20250123151339.185908-2-ajones@ventanamicro.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix segfault received when using --nodefault without --params.

Fixes: 7c9aac003925 ("riscv: Generate FDT at runtime for Guest/VM")
Suggested-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
---
 riscv/fdt.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/riscv/fdt.c b/riscv/fdt.c
index 85c8f95604f6..f6a702533258 100644
--- a/riscv/fdt.c
+++ b/riscv/fdt.c
@@ -256,9 +256,10 @@ static int setup_fdt(struct kvm *kvm)
 		if (kvm->cfg.kernel_cmdline)
 			_FDT(fdt_property_string(fdt, "bootargs",
 						 kvm->cfg.kernel_cmdline));
-	} else
+	} else if (kvm->cfg.real_cmdline) {
 		_FDT(fdt_property_string(fdt, "bootargs",
 					 kvm->cfg.real_cmdline));
+	}
 
 	_FDT(fdt_property_string(fdt, "stdout-path", "serial0"));
 
-- 
2.48.1


