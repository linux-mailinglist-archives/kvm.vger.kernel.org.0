Return-Path: <kvm+bounces-46814-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BFA6AB9E3C
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 16:09:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C2D903B0800
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 14:08:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E7F2145B3F;
	Fri, 16 May 2025 14:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="VcVClzVu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97609249EB
	for <kvm@vger.kernel.org>; Fri, 16 May 2025 14:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747404552; cv=none; b=FJBD2J0H6y3yXbUTOzHIar6RmX8/w8fCuHyHSM8ujhf4hIQZmfJNj0NCktFSedY3+pKCCm/ymXCrlgVKTgngbhCAtd1ykLSOUeu0Ky/P9OEec1Zy2qc9JDhkSAISXCFL92a6tnyEZ2oRBRF18swu8RWXkMKL9mzM8eU6Cu+djmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747404552; c=relaxed/simple;
	bh=euZ0Zj5ymVvdjh/3qOybPwtuZ+o3GzvdIi2/M+/nE94=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=N9kqGpABdOubZh98G6hObOdpqv/4cTHO7rosmysf79tP5rZOjdk4yjUoUoWVCo5K7KTpOAKpDq5KxSG+RHzaI/d6eeeqHEpv87hvjygtlWMF2OgjTX7o2N9qIw/D+l66PAMyCIDampf/vpMQU73dK1FXAbcCLU+FdoanQbObiJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=VcVClzVu; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-3a206845eadso1406732f8f.3
        for <kvm@vger.kernel.org>; Fri, 16 May 2025 07:09:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1747404549; x=1748009349; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vh7Nh/LNhUg5Xl+qiW1/QFk8dwafIYEiWF4enwv0UK4=;
        b=VcVClzVu/PMNjU6i2aiGwFpsAeEd6geVPtQHTiYnIi/XH4SdnAzdW4ZaoOQDy46dA+
         z/hqlqDKNTFHC+78/IomrC9lV7gpKizeIND0QYlBHBn6ghtLq94Q6wP+nB5ubXrN2Rnt
         25cE/DigxBYWuN55U1hIAblbJFoBKbNaSOnYpx7NwFu8gPsczUyRdFGWaOixVSHErG1J
         lpEfpx2/YxCJiQtPUGCqwA8YLPp7z2JjDiK4R87Elug4wHx2nS1tOSD+d+j8MDRFO49G
         BRKUo/r1V0T4k3iuCBAJr55Tr7bQrFdQqSSuz9evt0+QmQBJjcUygeivTMm9zOGnjkOI
         75dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747404549; x=1748009349;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vh7Nh/LNhUg5Xl+qiW1/QFk8dwafIYEiWF4enwv0UK4=;
        b=c4/IJFCby0ttnRoL9xCqxp7KMudDwg0jtoepTYIymOv3X6ukSQTLvjTcewnFbwvZ8G
         +y6CpLBRa+/pRArtzYTnJk4FHfPBPU2qrc/MIROcP1tu8nWcOnq2ARAwr6Ov5V/8+yxm
         jJHIahzWOy/knYNc08jj8sFYeghfLDeojHSBdNnGRruvE9LrafCTPaTJBYrcJxGTWY9/
         YF3LWGsx78jI6MwYwFeBOHrp2gP9iiSue8QEiJ/ga1HrPvgXq3909dC1cmM1PNHJlvpS
         WsOTRhcmvRxAIkj5AH8LFJvuZnW8ccE8PcVFOiJpMdXdSQDXTl4J4G0rj9CNcrMDC1yX
         HePw==
X-Forwarded-Encrypted: i=1; AJvYcCXPLP30D3E1I1gQ8QaFahfFi568YzNQe4xiRPOAMu5Kf23+6y4KIeWWeyziPokderbAni0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxovoRUWqJ5WCS5dMfPiS7DfxVD18bb6tebuldqElu0DqpO7AbO
	aH3spWvg1TIYiRnxjg33JlfOKpwm0EFYkPPp2gQMb5C+njsh6mcbMzTNCjfnIJgWYCHOgn8OVMO
	yy6HU
X-Gm-Gg: ASbGncsHPRnjzmTFLtENkd4UyfST6FFzKL73aOkWtQYwRFddszdeJ/yChu9Znfns/xh
	Lr29I8mfArbBimpMgXXzcRbNeBlk5+a/BbznygYbwY0h1/ZwYc9fVhM2hVkdyjYyaFM5j2FJgoB
	ZgIzUWVy8iiuEP9hYgmQbpVcXPz/Fug22wubJJDExYT/KJRXpKCCpRId/3t8DNvJxXUtAKPFjqA
	r10nJ2uZTL0g791/hJmWhCBmv+Wn52ZiDuDBYhvDYnY+v/lCgfof4ZuxTtF95BJa9U+Pe5wVq/W
	7LKqH9dOQxNNz+dE7O2CpmYj6q4GCvK0rHlrQ/NHR4ft8ggLt51ls4GuSB8Jrg==
X-Google-Smtp-Source: AGHT+IGcNulM7sZqj+PyskZzsBcL0kYBhlh4zFQiDSGNh6LWyJKYUr6QraGKOEQ7UWTVlqgDlJSF9A==
X-Received: by 2002:a05:6000:1866:b0:3a3:4a1a:de6f with SMTP id ffacd0b85a97d-3a35feab1bdmr2405504f8f.26.1747404548777;
        Fri, 16 May 2025 07:09:08 -0700 (PDT)
Received: from alex-rivos.lan ([2001:861:3382:ef90:b6d5:4f19:6a91:78f0])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a35ca4d1f9sm2911696f8f.1.2025.05.16.07.09.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 May 2025 07:09:08 -0700 (PDT)
From: Alexandre Ghiti <alexghiti@rivosinc.com>
To: Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: Alexandre Ghiti <alexghiti@rivosinc.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Andrew Jones <ajones@ventanamicro.com>
Subject: [PATCH v4 1/3] riscv: Fix typo EXRACT -> EXTRACT
Date: Fri, 16 May 2025 16:08:03 +0200
Message-Id: <20250516140805.282770-2-alexghiti@rivosinc.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250516140805.282770-1-alexghiti@rivosinc.com>
References: <20250516140805.282770-1-alexghiti@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Simply fix a typo.

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
---
 arch/riscv/include/asm/insn.h | 2 +-
 arch/riscv/kernel/vector.c    | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/include/asm/insn.h b/arch/riscv/include/asm/insn.h
index 09fde95a5e8f..2a589a58b291 100644
--- a/arch/riscv/include/asm/insn.h
+++ b/arch/riscv/include/asm/insn.h
@@ -352,7 +352,7 @@ static __always_inline bool riscv_insn_is_c_jalr(u32 code)
 	({typeof(x) x_ = (x); RV_X(x_, RVFDQ_FL_FS_WIDTH_OFF, \
 				   RVFDQ_FL_FS_WIDTH_MASK); })
 
-#define RVV_EXRACT_VL_VS_WIDTH(x) RVFDQ_EXTRACT_FL_FS_WIDTH(x)
+#define RVV_EXTRACT_VL_VS_WIDTH(x) RVFDQ_EXTRACT_FL_FS_WIDTH(x)
 
 /*
  * Get the immediate from a J-type instruction.
diff --git a/arch/riscv/kernel/vector.c b/arch/riscv/kernel/vector.c
index 184f780c932d..901e67adf576 100644
--- a/arch/riscv/kernel/vector.c
+++ b/arch/riscv/kernel/vector.c
@@ -93,7 +93,7 @@ bool insn_is_vector(u32 insn_buf)
 		return true;
 	case RVV_OPCODE_VL:
 	case RVV_OPCODE_VS:
-		width = RVV_EXRACT_VL_VS_WIDTH(insn_buf);
+		width = RVV_EXTRACT_VL_VS_WIDTH(insn_buf);
 		if (width == RVV_VL_VS_WIDTH_8 || width == RVV_VL_VS_WIDTH_16 ||
 		    width == RVV_VL_VS_WIDTH_32 || width == RVV_VL_VS_WIDTH_64)
 			return true;
-- 
2.39.2


