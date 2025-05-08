Return-Path: <kvm+bounces-45847-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A7FFAAFA91
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 14:53:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8DBCD1897C83
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 12:53:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1DAE22A807;
	Thu,  8 May 2025 12:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="XuAPBInV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E30191F9ED2
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 12:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746708789; cv=none; b=rqlMyXArJR9JwUsY27rPbSBRGYg1BJo3G7Y/o6GUysri33kIj7W61lS+V6KB9y1LY348TsxFzanuctA/iaLyPiKf3PBR2XGHHDrvCgo42t+sCOkbgKCEivnDdhmpO3B3IO+0mvMnsvr/z6eTM+s0ctY4rrOoD/8PboMF2SuHVT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746708789; c=relaxed/simple;
	bh=euZ0Zj5ymVvdjh/3qOybPwtuZ+o3GzvdIi2/M+/nE94=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZgSMh22mjhh4YSNvVecb2vmOq84ksFBgXBAA/CWrnuFbCJ6JsrGSwe5yEDbc6vDabJrjxmO2V7NWyVGvVBR//JfStiNeG5UqYh8XFaj7vKMtwC6Q0B75b8+wDbRjzeD7V7UMU9YqrILEjh74BajJ7W9LKrxWkFasqQnnG98EwYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=XuAPBInV; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-43cfa7e7f54so6388575e9.1
        for <kvm@vger.kernel.org>; Thu, 08 May 2025 05:53:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1746708785; x=1747313585; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vh7Nh/LNhUg5Xl+qiW1/QFk8dwafIYEiWF4enwv0UK4=;
        b=XuAPBInVOh8vOZ0JoRbZlweRshl2MR0cgRDvj6kGUVJTDyPLyDgZ/3zFEj0Pk/royw
         LGvoPTO+kA0MYx5HLfbWbvmRr1OyDNAs12RmzD+Z95FZ8kmWievsmc/f1GlAK0iVypE5
         l79uwp6G7SGKfEpSfmzYj33v56kTnZE/TebigloazKh3G24PIuaaV/fVNn9HQxiYF3zy
         bd0weOcFncXSpAcnEx8owhvGkGq+o+TvAGQXbvZhAeSdAJc75ZNtd0CpTnNnm6JI6sP7
         NUiia3gqTfgt0zg1+EdR2vgiFZuwn0/9M44tpJAj3BB6cNPvmfwapnIOCANvfDQFLsbh
         XMpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746708785; x=1747313585;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vh7Nh/LNhUg5Xl+qiW1/QFk8dwafIYEiWF4enwv0UK4=;
        b=QsvKKqHKU+Z8wbatWyKQf4LSgklwUH0MhR+pM2HhIEsA7R0hXh07I5Qu8bALGjiVMU
         KfX2yJj1dLdoA3Uy46Ktlp5bur4K/HzT7EiPanu862qxE1FEDWx28yLYEPtX6Iq1HnVm
         2Gei3LCpdt1WUuCQIfe4UVKwKM8CLX//TBx0+fULDMv9+tQIsgLI/Y/MLSa7oaKy1IyV
         byzFAZD1rwt6yK0pvsWTr+QIHxVi/X0R0sztZXfsNQgudI64x+9YvcRpuk0t5jEjxrV9
         noD3AmaoOsIdtwrU3aOEvZGdt+NbmSIjJZP5LxuT1E1jH9QmrWUhmd0PV33hPNt5BCKs
         jWGQ==
X-Forwarded-Encrypted: i=1; AJvYcCUBdQmHGOSPhpbSwnxlm3hlqFfaZzPpx/GRXg7IxF8Kv3ZpBapimDV9bmGrToRzDIBBxnk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw+d5Dcs9OKrlnd7WhNZ2R5Qfpxl11mN5lRk3D6b3zISgsIn4MW
	6NSmaXLQsLvI8Dq49HZcIuaBctz68EQ1wyeYLKcKZUCIucs8NGnWi07ieCVPUEk=
X-Gm-Gg: ASbGncsTm86RKz6NImryfuY/hp4DH0pJ2OvKBrytEZVkjMNBadK9RcgJ8TeI1OoNz26
	17MlQAGJUSrKLxyqbgQB9ELut4KU7ZlsNNtTN2+znqKuWSjEBh1SUcIycpOsMHMHvFJoEipfyNM
	imHcwxEPfVdqMKgzUwidSZyBc9cYut7pl37IJ6N8KjxlIZxSZJpMrDTwZ3EMihV2mOCXmI4ZmfA
	PIn8rCkSjvV8stwnMTgXTXwPVg1R6SjbRx+s7twxeANfYH9FSFmFLYJvalUisnDr4TLgK0h9H30
	YAvxOZqugt9ESLLdkBcB4E8jayxU21mLxaAVUUshPPw9rdySG5g=
X-Google-Smtp-Source: AGHT+IFR8QCSoAU+f4KSrfc+O+GL0KH+EcLDchKk/zyNXpj2HtkBA6LUoeVtjpf2wnryhRhOk+2CgA==
X-Received: by 2002:a05:600c:3150:b0:439:5f04:4f8d with SMTP id 5b1f17b1804b1-442d02ef128mr29446975e9.12.1746708785138;
        Thu, 08 May 2025 05:53:05 -0700 (PDT)
Received: from alex-rivos.lan ([2001:861:3382:ef90:e3eb:2939:f761:f7f1])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-442cd32f238sm36021615e9.11.2025.05.08.05.53.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 May 2025 05:53:04 -0700 (PDT)
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
Subject: [PATCH v3 1/3] riscv: Fix typo EXRACT -> EXTRACT
Date: Thu,  8 May 2025 14:52:00 +0200
Message-Id: <20250508125202.108613-2-alexghiti@rivosinc.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250508125202.108613-1-alexghiti@rivosinc.com>
References: <20250508125202.108613-1-alexghiti@rivosinc.com>
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


