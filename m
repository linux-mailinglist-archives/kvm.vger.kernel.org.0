Return-Path: <kvm+bounces-37743-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D034AA2FC50
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 22:39:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7BB03164844
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 21:39:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A640257422;
	Mon, 10 Feb 2025 21:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="c2xebSJ3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BE8D253F03
	for <kvm@vger.kernel.org>; Mon, 10 Feb 2025 21:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739223379; cv=none; b=TOKnD4NE7ouWjYQ9Ovikc23MDY5SakBA9tk+eEoLO4YfCNGmAnvjfOc9ItFL6fqyRcHlOiU4UbIkj36zCmIwompGWxZh0CICEitlNY/d7O5a9tUAbqMR8DvXXeZXdzefd0gRXSl3+nbX75p0EZ9K5Zp0GaYNMhYyyEBV2HM6j74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739223379; c=relaxed/simple;
	bh=/j+ybqZeARPGCTJZl7exA3+V1IjrXZaSqccG31t9K7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cUq8l8cCeoDpVTF/I2vebJmyaEMO+aYPOkILF91PKhouZj/U8YhdSObKhdWI34Gf1u71TcJM1yWmklw2As/UxZcEO+jidGTtawtLCBBXwK7/shaNgncDecx//NAIwCTxRVLgHYyydNHoMCUHdItIc34bmS/Iy3ntgOkb4JxWNfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=c2xebSJ3; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-38dcb97e8a3so2878683f8f.3
        for <kvm@vger.kernel.org>; Mon, 10 Feb 2025 13:36:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1739223375; x=1739828175; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=19zTUPAue8uF+l31WbsHm7jesitbh6CalqtCN/NDhL4=;
        b=c2xebSJ3LPiHXsGsSjuRfbMFxZxgU8LpqFgZqy0nvxgKR/gnvOAzSE+gHUULgsWAQQ
         2b1QVMZmDY3xhs7aZuNjCmXS+0eTbsC9RirfpCpY8+xOi/3oljycbnbjSVQNHq5SImVJ
         H5T3vlT9bVxrMNhoSbKwk86zOxLYGyDfH/CgMbU7RB1KJGrZYOpf2XEjLJ24GkfMQYnN
         dkZ9A6XqYFM/EqZWF7i01+Jm0OfgxDWblLaUe2OMVx3sMjcgUEhEbADzsDte5OMzpMbr
         Wa+UHEpkAQFwNVsAbYk0C7+7Mra+qHdS8pJSvlKyKzqLQZKqVPkflGAwASmuWRJQnOYY
         KJGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739223375; x=1739828175;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=19zTUPAue8uF+l31WbsHm7jesitbh6CalqtCN/NDhL4=;
        b=b9XL9JMQYajg6z9bozQ/MhHF4FHwze79Su1hmGWQ5apz+cD6yMkPhRxeg3Wcv+22ms
         wM4qiA/08O45SBRIhIdPgkR3NmTfC8cPCxDETKs3LC7UJ4rbCstZnQUyICuFahsxRfGZ
         Vht2qvdFIfzC84hNdiQOLOSvHj6y8Z+g9h+rfbwIYjQYrGFa7elO9Q5JEtpo3I/gOacj
         gQGi4vR/uaec/D/xH4vNsYxPnE4B3EfcpYacxjLnuoAY59ZiMQ//6jRYWb8GEc08EI+c
         MvfzUMlG7suRtdTT1f6IgmB5BaFimTfjpG6JXG6o1W4KWx4aOroZdS4qbl3HOYoUUW/g
         b6fA==
X-Forwarded-Encrypted: i=1; AJvYcCVT9q1hOvdcaJGff24YffjU5ReIbDauEuSF8GFSBcRXWRhsIVrocKsTHyj6fEf1sRCDt4s=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx35NKGJrCc8ZfoRt5axglStUYW4CVirX6V97QC8DVJJydZze1M
	C1AK3fGVnHSPcsKBltFRSIxXh8PiSLtSBUf3aOadpToiyStMyBwHYQe2vayYTWg=
X-Gm-Gg: ASbGncsNkRT5SoMbNz6XE7CpB5V1N7MAN2LvXAOeviyFYhLeWSXkBh/k9nNJO09E2So
	Mu56rTYduV4bnU+ULpeBUJnt+1Fnu3QOKa22+6UdzcLXGpNmBt5dON5R1iHfE3a4T5YAagm6h4/
	EOcEcRmkLJf3wft6OabE2oCidmhh+cmvaLJkchvoF3M1GAnUtc5mw4Sm+jX6LGhtRJ35TUZXz31
	6zfNzg2V0NwXZzbd6VrxNdkjIQymFa8vWkVowjR30EzAeR7RsQ/zURfkTYarUC8reYYwoXtgzXq
	Oyd0FzscFcsP0llp
X-Google-Smtp-Source: AGHT+IH8mk3UTikqJq637e5ac58oAB2cwKutxDJwkgs3YdoxbObjCQef1GMenNM8qJokTGgudOE/eQ==
X-Received: by 2002:a5d:648d:0:b0:38d:d969:39b0 with SMTP id ffacd0b85a97d-38dd9693afbmr6558028f8f.2.1739223375424;
        Mon, 10 Feb 2025 13:36:15 -0800 (PST)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4394376118esm47541515e9.40.2025.02.10.13.36.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Feb 2025 13:36:14 -0800 (PST)
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
	Samuel Holland <samuel.holland@sifive.com>
Subject: [PATCH v2 09/15] riscv: misaligned: use get_user() instead of __get_user()
Date: Mon, 10 Feb 2025 22:35:42 +0100
Message-ID: <20250210213549.1867704-10-cleger@rivosinc.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250210213549.1867704-1-cleger@rivosinc.com>
References: <20250210213549.1867704-1-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Now that we can safely handle user memory accesses while in the
misaligned access handlers, use get_user() instead of __get_user() to
have user memory access checks.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
---
 arch/riscv/kernel/traps_misaligned.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/kernel/traps_misaligned.c b/arch/riscv/kernel/traps_misaligned.c
index 1d523cf96ff0..e6685db58bd1 100644
--- a/arch/riscv/kernel/traps_misaligned.c
+++ b/arch/riscv/kernel/traps_misaligned.c
@@ -269,7 +269,7 @@ static unsigned long get_f32_rs(unsigned long insn, u8 fp_reg_offset,
 	int __ret;					\
 							\
 	if (user_mode(regs)) {				\
-		__ret = __get_user(insn, (type __user *) insn_addr); \
+		__ret = get_user(insn, (type __user *) insn_addr); \
 	} else {					\
 		insn = *(type *)insn_addr;		\
 		__ret = 0;				\
-- 
2.47.2


