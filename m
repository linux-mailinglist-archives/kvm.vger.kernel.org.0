Return-Path: <kvm+bounces-43794-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A17AA96214
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 10:42:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 92A6517DEF4
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 08:36:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AF61290BB6;
	Tue, 22 Apr 2025 08:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="d/WXT1JI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC84D2900A2
	for <kvm@vger.kernel.org>; Tue, 22 Apr 2025 08:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745310440; cv=none; b=Fc2eBdlWzACbMy+/GKNcF1fH7/VUiaUJ46ZohFLaUoa4yFy9Cb56SE2TEWSBQDF1S910xS2Z85Yc8fVccVJ5XWCqX5fqvkZ86uCj7bWZL4QJLYN6DFySLOUIUX0xbbJ5IJmHi3J85TLDNfQWzmD1z1gTaosJeliR+dV2tspzCJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745310440; c=relaxed/simple;
	bh=RTx+HnoIXEQkRJd/nDQjtn2NnXrBxY1VcXeuIlhDK78=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nRJ4Kj6l82G9KuFEu6MJB8T/VqtsgoJnt/7RtRK4aVzmKsPdNUlwFHdlTRuokhKNoWm3kKnQfh49+Pgtkzsou93qM6GsytIFyZvMZ4olaFbu2Sm47rOOpvp2KN5n4wA0PJnhzbb8XvXratqxjQ2qleXoEWhAv7t2ZrokUY0ErHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=d/WXT1JI; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-43edecbfb94so50795695e9.1
        for <kvm@vger.kernel.org>; Tue, 22 Apr 2025 01:27:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1745310437; x=1745915237; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p2nnnGh2oXeC0IbaXY+fafQ44YKw6BKWItIZxE22UTc=;
        b=d/WXT1JIx/RiTcQsWEZaD0gUoHn6AT9f+rYczdPU+M19nNoQVkHtM639vSrrXQ4zbu
         sH6CYxINeqaMBksfay7LEBf/zYlSd60+CUTdcgRC6vbmAMh2eJTpAKYlRNegnwNiiRzl
         w7awPYhJaqyiaBFbFabp6dPpa4DwYUZ0745B2v//sj3gh56dPrNY/z6jqryUF9lyW12u
         oG2M1AKP5RY7qvu7i92Nz7UxGXjz/6NkKAsg7/7FiAkLQDQwRu76cH8ryMQlLHueLJS/
         a/IW4mzgCYI6koEQ5LS/Z0OYkJDEOiQBTWH2TFS9CKdesVt2P37ttTTuSy9FkFe2g3g1
         yEZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745310437; x=1745915237;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p2nnnGh2oXeC0IbaXY+fafQ44YKw6BKWItIZxE22UTc=;
        b=eUuWek8LnKhlzUFjbpnSJEbrYQkV+xUGQqyBl7UyDX06ndITgffBMIH0+rhzR0vh0f
         4Q3C+eO+uiteKPmqkPbBUDSrFdZGMJwvBc+2U/SL8lH3MqtxO0bcwGcTLmzgUTb9ZbDm
         Qr9TZwwrxEMr2D/4ZbkU+hqOy7fBkvSKwRyKiMe1IW1meUVuPvpSwyX4La1S+Gxt4l+g
         4GWMU1KN2xNR1/lmmkzddsd1O9R75fmSI9rkFq5loliPBPBRivblvbibC6DDkHZi8HBi
         BTarbVONuCUg4eOV6hm39+7yom52v4flZQ00GoLw17XfPdvA+lo8pLSIZbqd4Cy5dho/
         txoQ==
X-Forwarded-Encrypted: i=1; AJvYcCUtONX/YrXY26xTrHNA/LDWcEkc2CpHNJ/Z09hy3yVG6bcaWZ7KPhq/jmhLISOpOIr25+g=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy7eAQohNXKIAsM6wvzvsfO5WD3HpviJz1WAp/Asg8zZw1JCyjz
	9YnR0s17I/wRbLOVwmJMnZpDlYwxs3yAjLYkFP1PWBrm1/2GlMUMLCmrNK5WEPE=
X-Gm-Gg: ASbGncskOeg8AhJpzWgpYIBKCO9uI1rNsgL8o37VMGdKi9anrWhIPsC3C/BwusJq+dt
	fVRvAj51da0xfiTbvO2aMjhKWRh0CnRkk1yxyV4Zy/jIYQCYtr0VJbeKW/6eMcVVQuXWAexbiqc
	kKgidFrN6n1gCs62pbisZvsGNx4nR3mu51xSHYfg4gCUEkgy9joIn1ENw1poZuaU4D2cUa/h48a
	zpd7teft0flrR0y0daiBIjQzb7bQPTRYr9iKFBKQKWliMcXA+atiCOpY5oM1I/v/aB5aZkzoNnW
	OjxZp7GKAMu1c1cw9JZOHuFJTTyKgpZGtGkyf3cgtwl5j9dGNJUyclInRvPw
X-Google-Smtp-Source: AGHT+IEAXQjlvVXuUS+hvcD4d/xsSZzW3BjuYaxD4G0D6IJrYehsEjbaj37l5/daqRdzRScEtV0rfA==
X-Received: by 2002:a05:600c:5110:b0:43c:e70d:44f0 with SMTP id 5b1f17b1804b1-4406aba758cmr110202625e9.19.1745310437275;
        Tue, 22 Apr 2025 01:27:17 -0700 (PDT)
Received: from localhost.localdomain ([2001:861:3382:ef90:9fbe:20e3:2fc3:8d19])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4406d5bbd35sm163735605e9.22.2025.04.22.01.27.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Apr 2025 01:27:16 -0700 (PDT)
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
Cc: Alexandre Ghiti <alexghiti@rivosinc.com>
Subject: [PATCH 1/3] riscv: Fix typo EXRACT -> EXTRACT
Date: Tue, 22 Apr 2025 10:25:43 +0200
Message-Id: <20250422082545.450453-2-alexghiti@rivosinc.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250422082545.450453-1-alexghiti@rivosinc.com>
References: <20250422082545.450453-1-alexghiti@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Simply fix a typo.

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


