Return-Path: <kvm+bounces-10321-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C5BB386BDDA
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 02:05:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 038DC1C240BD
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 01:05:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3A3244375;
	Thu, 29 Feb 2024 01:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="IoK//gjw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EED01CD23
	for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 01:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709168505; cv=none; b=oaA+ul3Wkg2wdr7KoJP7brChpRiEI9qlkpOAli3lpn6TG03N5vEmVg1oj2VN/9RNUVCAOzxfhB8AWye3iU3TYEc0Hd5AOdeZuf4dZjpbzLGc+B4/CIXDvvzwPujeJOE6i3buWTLZfwqd4zdQaqaDbRJfFt3J8+L1Kkzk1ccDSeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709168505; c=relaxed/simple;
	bh=sofJnMZcl8hQjOX/gFTKlCCw6YYdT3jB7PUh6wxX4R8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mLkfpzbu0pKjUkZfpyhkyyXIRdUMb1bl0WJw2ZoczbFag/mKM5Rsm0tSMC4fSiDgLRFzADIoJOMSxgbve+GL9S2DigmqdmsiTtSwzYoPAC/aYar9168eN1OvcDgVzxfD6CcRpnP1aIZrIE2uL65i2iGKvBtUXhvg+thqK++db7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=IoK//gjw; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1d944e8f367so3144815ad.0
        for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 17:01:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1709168503; x=1709773303; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SchlyZ4UU3SdoafkJQBbnMQVK65WVY/e6Ayv+xuGpWo=;
        b=IoK//gjwUiOYb+Esw9RAZOx+xHR2i6F6M60HewrN4Y9wqUNIhItSeuomVlSMv5njr8
         xBCwfmj2MeMNjMwygSlWTcdPIQKwCw1pFBr/9hBIXS//Z9+k26vwEJiaDROnd9m8Mc1j
         xlQFM26aUOhs7Sm3c/vkTOtcx0WdxGQNgPzThhz7FnuUuc1/JecUSKYyKewVkEbZLW7C
         Y35p6IisI2y1GX4tMTLqktTCSqi9N7vhA6QO0QZsMFV+lqof5qFeLPhU5UtDwvTQGOG7
         ySg+bAxooi4via9On91x6aHO0EbY8CeLdpdMWgSKyygpNL1GiOynS8AvFtpcJSfFmbWy
         ITTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709168503; x=1709773303;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SchlyZ4UU3SdoafkJQBbnMQVK65WVY/e6Ayv+xuGpWo=;
        b=Le6G0Cm0olz4pNAuvDoyyfwOHKm9E/6qW2hZoYiqlzDOdaf9dcq3fFiQnMM0bp+93y
         j+qnh8mru3oxITPE8QMVFAwZ9Fzxk5I8cTqVKvn82flDVnr11AgNBpQH/4HgEpCVrr2T
         GzyffUaW/KPMmSVd7l2M9HsUTkmfPnVWD0od5UAm3ZNjcYPHZTMIPw+EudkZqY3v7lG6
         dqlvM11110gxZBpa/46+46tBNAh1Br59pm9NizSw16KLe9gVakwG72orJcUVZoCTWYAp
         EVV8UrENh/gmF4Nrporx1DK0Em3mhWm+NOqswgpJBXKJOWjzarCvhJ7bO+XfoMhJ/uhS
         is3A==
X-Forwarded-Encrypted: i=1; AJvYcCUsSWWktNchCoDrMqDpWJpRIa4esXmuCwrCTbf4czRvxmIT51ACMPq8PzUwD2eUMszDpFjc3x1yHKQNggrg/yC8J+zE
X-Gm-Message-State: AOJu0Yzwvq/OxktRZNUqCh4TblHq9uf0RrxW+hlMrx94B5JcuAnXC8K5
	D9Lv9816AGSvOOzAkLsIAj0zfwr+JmHHkBQHjfU+dHUowAFlCHUbm5+8XYi2ptc=
X-Google-Smtp-Source: AGHT+IF8AP5yy874viGgSFlHQ/GFryEr73kxAAM+WTYHUlwXxC8mSK1Ci2PYhqwM33S+1LfQNiTK8g==
X-Received: by 2002:a17:902:f54f:b0:1dc:cb84:d8d5 with SMTP id h15-20020a170902f54f00b001dccb84d8d5mr788795plf.50.1709168503594;
        Wed, 28 Feb 2024 17:01:43 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id j14-20020a170902da8e00b001dc8d6a9d40sm78043plx.144.2024.02.28.17.01.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Feb 2024 17:01:43 -0800 (PST)
From: Atish Patra <atishp@rivosinc.com>
To: linux-kernel@vger.kernel.org
Cc: Atish Patra <atishp@rivosinc.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Anup Patel <anup@brainfault.org>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Atish Patra <atishp@atishpatra.org>,
	Guo Ren <guoren@kernel.org>,
	Icenowy Zheng <uwu@icenowy.me>,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	Mark Rutland <mark.rutland@arm.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Shuah Khan <shuah@kernel.org>,
	Will Deacon <will@kernel.org>
Subject: [PATCH v4 01/15] RISC-V: Fix the typo in Scountovf CSR name
Date: Wed, 28 Feb 2024 17:01:16 -0800
Message-Id: <20240229010130.1380926-2-atishp@rivosinc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240229010130.1380926-1-atishp@rivosinc.com>
References: <20240229010130.1380926-1-atishp@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The counter overflow CSR name is "scountovf" not "sscountovf".

Fix the csr name.

Fixes: 4905ec2fb7e6 ("RISC-V: Add sscofpmf extension support")
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Reviewed-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/include/asm/csr.h         | 2 +-
 arch/riscv/include/asm/errata_list.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/include/asm/csr.h b/arch/riscv/include/asm/csr.h
index 510014051f5d..603e5a3c61f9 100644
--- a/arch/riscv/include/asm/csr.h
+++ b/arch/riscv/include/asm/csr.h
@@ -281,7 +281,7 @@
 #define CSR_HPMCOUNTER30H	0xc9e
 #define CSR_HPMCOUNTER31H	0xc9f
 
-#define CSR_SSCOUNTOVF		0xda0
+#define CSR_SCOUNTOVF		0xda0
 
 #define CSR_SSTATUS		0x100
 #define CSR_SIE			0x104
diff --git a/arch/riscv/include/asm/errata_list.h b/arch/riscv/include/asm/errata_list.h
index ea33288f8a25..cd49eb025ddf 100644
--- a/arch/riscv/include/asm/errata_list.h
+++ b/arch/riscv/include/asm/errata_list.h
@@ -114,7 +114,7 @@ asm volatile(ALTERNATIVE(						\
 
 #define ALT_SBI_PMU_OVERFLOW(__ovl)					\
 asm volatile(ALTERNATIVE(						\
-	"csrr %0, " __stringify(CSR_SSCOUNTOVF),			\
+	"csrr %0, " __stringify(CSR_SCOUNTOVF),				\
 	"csrr %0, " __stringify(THEAD_C9XX_CSR_SCOUNTEROF),		\
 		THEAD_VENDOR_ID, ERRATA_THEAD_PMU,			\
 		CONFIG_ERRATA_THEAD_PMU)				\
-- 
2.34.1


