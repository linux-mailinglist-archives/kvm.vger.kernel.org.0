Return-Path: <kvm+bounces-44205-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E450A9B549
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 19:34:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ACAF3168BAD
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 17:34:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C7C428F53C;
	Thu, 24 Apr 2025 17:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="nOO22wwC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 326C828E5F7
	for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 17:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745516045; cv=none; b=NnAdS1bMhzlGIEA/734YxMYS1aPFtCdkq6/zAu68GKptcP1DJiKo4xgBt7Ha0AhzXaMp2NNidf3bIjLXEORJ+mQfA07jwd621btyiH1lZSgkHi3lgZEqwGAae7pRkrf6RkPbqn0Vg7PuuH1qgOJhmU5cvvg/113kuyytrQWmOXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745516045; c=relaxed/simple;
	bh=I8q3a/r8sIPwl9ULO4heNHCAxh6RA5hJvMvMHg5vqgk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ipBxxo2BJ451S//MC5xP4NoU3okIZcAwtpz9c7d7wv8CKQoKnEXG2UpvzaZdQOUFpkv6q+QoIGGhv9DCIjSJe8/NvYnh7I5FsS3muRugy2wvbZ1MtTfYioi81IK4H4o8qjlriQD8H/2i/mFA7xkVKkFcQ7za2YcruDedqN/VGik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=nOO22wwC; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2260c91576aso11729405ad.3
        for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 10:34:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1745516043; x=1746120843; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kJ5IZYf4f1NhGHvFycXXpF/34tAS76qwhFgvuPH97UQ=;
        b=nOO22wwCEeeCLRdveDX1XJoulJIftSH2Nt3zOLaUXbwhKvcj7lcqH87YEsPTBbZZVa
         DAZ92Bd8Qn0w/IXvr6KM2BLUODk+EeRU+BzFKu3J8g29wrEmXLW4zt8L/U+KtaqYVI1E
         1uVZ4y1fDi5d5ZdC40Rbt7iLF5i1i5LlbLDyP/24BqAHGGZ5l9ZyGFNaST9DcpVhflpv
         AfqL3xSYZe6wrmKxpIZImjsLgR6rYg5TWruM+xJmm7bN64PuspNEKe1mWR2TlFafaKnd
         xN1Xqs7d8jv6TDen0V0LTc3ynMr0xWKDV2TFI0PWiQKG/mraDPeHnKEyRGyF9fkw/HTA
         jPsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745516043; x=1746120843;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kJ5IZYf4f1NhGHvFycXXpF/34tAS76qwhFgvuPH97UQ=;
        b=PRWGFJOW8IxFKDBVQXJIAPZN1nu7+RZYnf7Ls57yy30bkCv8xYE2Tbv7c/Nc/3lpZT
         ILQBzKD9+rnhJM+43aiaLc6SKV3ky5sEMfDU5O7Ir8tNpQKyq9bwSwBmery8Ew/+wMgp
         7RT9BOepg0KdyW4xKwEtkg0TCM+61dQEDlYwAN5giC+E2GKEIqeqqZLVQyBGAzmwwcNk
         ctgrVKSly+r3/Mejy1jIs659aq/aQasRGWxMb9+EOxmVUqIxTDK/H/F33RWdBCdbKSD3
         b2jRzd4i5XSqJWoOAWupN6d3WbJnIELku7BVhoQ+y8PoeJ40EHPlWc+7VQWaXnKJvuad
         jQCw==
X-Forwarded-Encrypted: i=1; AJvYcCX7yOrVGdiDLh3XfwkAlF8cqZP1/mZgb0SZbi+HCQeasmKgQjHnp4qY4HQraYk4VuYfG28=@vger.kernel.org
X-Gm-Message-State: AOJu0YxfKeNY8Yl6fuHVj9maITdnyFV2JXETHnUXPTjDIUqBf4nAGGt4
	VZ4zT9qagBBkpIb8JijMigPf8Nk2lnc9oylgLyrplwAmQPm1/NSjXD3WoS1Nupo=
X-Gm-Gg: ASbGnctAhaFQUJPpFMabdaflw4Agb1jdI5ei0Rmawh8fdg0p5DJ4tVo3sFh4GaLsHSB
	QpEhI2pIRMOy5o2TojXNsFFhBpGYfbb2vlaXNH6BzHI71eZnmxbfNlAAJKAXSwGp4iKHTHXy9oY
	8BGd6+A/VusvYSpFvwRhiJnEGfquBIknzo3TEc4SXRrVh+Rv/PjNRh9smVvLcb3hc+d7u6PKSAf
	VHo0X1BiKf5kIvG42SnnyKN7qR/tn55Hik5V6AmgJGJ1aI1kCmyueA3v/S6GEdl2zN6wkn3+QpC
	MahRjQOqIJSRWPcBhKEulUWp5nrJz6NO4rkU636asQ==
X-Google-Smtp-Source: AGHT+IHzS5PXDP+Qy5Xmwwn0uCCNIK9/92EEG8lEAWpb5PTGOgGH/HAmRDTuUMHUdz3Q/hblJk8Z1w==
X-Received: by 2002:a17:903:234e:b0:223:67ac:8929 with SMTP id d9443c01a7336-22dbd35407bmr5533655ad.0.1745516043323;
        Thu, 24 Apr 2025 10:34:03 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22db5100c4esm16270255ad.173.2025.04.24.10.33.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 10:34:02 -0700 (PDT)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	Shuah Khan <shuah@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-kselftest@vger.kernel.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Samuel Holland <samuel.holland@sifive.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Deepak Gupta <debug@rivosinc.com>
Subject: [PATCH v6 03/14] riscv: sbi: add new SBI error mappings
Date: Thu, 24 Apr 2025 19:31:50 +0200
Message-ID: <20250424173204.1948385-4-cleger@rivosinc.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250424173204.1948385-1-cleger@rivosinc.com>
References: <20250424173204.1948385-1-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

A few new errors have been added with SBI V3.0, maps them as close as
possible to errno values.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
---
 arch/riscv/include/asm/sbi.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/riscv/include/asm/sbi.h b/arch/riscv/include/asm/sbi.h
index bb077d0c912f..7ec249fea880 100644
--- a/arch/riscv/include/asm/sbi.h
+++ b/arch/riscv/include/asm/sbi.h
@@ -536,11 +536,21 @@ static inline int sbi_err_map_linux_errno(int err)
 	case SBI_SUCCESS:
 		return 0;
 	case SBI_ERR_DENIED:
+	case SBI_ERR_DENIED_LOCKED:
 		return -EPERM;
 	case SBI_ERR_INVALID_PARAM:
+	case SBI_ERR_INVALID_STATE:
 		return -EINVAL;
+	case SBI_ERR_BAD_RANGE:
+		return -ERANGE;
 	case SBI_ERR_INVALID_ADDRESS:
 		return -EFAULT;
+	case SBI_ERR_NO_SHMEM:
+		return -ENOMEM;
+	case SBI_ERR_TIMEOUT:
+		return -ETIME;
+	case SBI_ERR_IO:
+		return -EIO;
 	case SBI_ERR_NOT_SUPPORTED:
 	case SBI_ERR_FAILURE:
 	default:
-- 
2.49.0


