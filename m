Return-Path: <kvm+bounces-40666-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C2210A5996F
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 16:14:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F2ED93A91CE
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 15:14:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9B7722D4C9;
	Mon, 10 Mar 2025 15:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="fi99kbZp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D27C522DF9A
	for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 15:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741619620; cv=none; b=no+tevvzvwPxkXMzUraElHU1Ke777FASlOOpDRy+8mtTt4hs6Ep4IFczmO/4HVt3cVlo+QoCFoyZ7XJVptCi+/p5Q6ZuDaMgpE8raE+7sRhH0I3+oNkshYkFCfbhVlDWzHTeL4jetjG2jqJdMm/XdbsX80OL3YBKt43BEfuMysE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741619620; c=relaxed/simple;
	bh=G0bMb29ZpgJV0/CkJZpzg+0z8//qkfB6ATS+lahL2BQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Fk0G/H6WjMyBJAYwhfzgL6THZ4rWkV0YxJzMauUiEA14NHfTkrT5PvB4Cnr+ET8SfKxH5HNt8FMyBMsxrr7EUWnN/TNKFW3bO+3LZRfAzEQlVRJL/LJyou2U4OLQ5lpQzlyn4U8riew2SOvix1/PxuZCbINZeE14JTMUmbSNUbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=fi99kbZp; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-223f4c06e9fso72941625ad.1
        for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 08:13:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1741619617; x=1742224417; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Radg/O1kYDcS8p0IZNGBH2Vna601zEl7dWErY3x7IKQ=;
        b=fi99kbZpHioLtGi82zxDgaCnhZ0CNWGyWwVuW/RajEZPlNGRK4ot6wphvsUusWBGFj
         iTnzUjn2YnQ5AzoepGwOY/BMI1eE/ihbWpPemAhi8g3tK8PCW7/V480KhZmvtAqXyRJW
         QDxhEoV4nMX8DtZq8+8/O3ErEDtDkKf+IbHy2V8SZ83NGd8tOesgL9o7YVJY+vhZSLq+
         YN9exj9JHUDH0I5PKAUQ69yPktuR+CuGVMTL227KLso44YD9git4DYZMdrL1lOPXiiTT
         hd4Z6y6OKDamDUF3Kdry+2LA16OF9C2/pBXDAW2Mch3d4k4ZkbNNsXLLh2tSkj5Nwn5B
         S80g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741619617; x=1742224417;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Radg/O1kYDcS8p0IZNGBH2Vna601zEl7dWErY3x7IKQ=;
        b=pHZ6ykICzwF0TlDyLI3DOCy37k2+kyt7XLzyjnhHTaIu04KiV6QWJ5wlqwE+/9o714
         LXjMPXSXFE2CvncKc1UoawzmRbzCyuclSc5tBdHFZRG90Yk3+KkIKoQIk/NGKJzKt0eX
         3F6J9mtUW5t3+qfbOuIlsVdx9M+n6mp42ZIUJOx9/Y4ld8UJgoRPPOwFeB2A9yafmqpi
         qjeC2fFHgYjT0nDJDtQqJdeWJNUX5/k3i0pRqpe99J0Lyerd61jak30evHl6gN5Fpz8u
         G1wEP3ng6ZLdveqKdvlaQ89O7i0wVyD4Sdy8SdzSRXQ00byV8iuS3cI9gKjwBv6sc1ru
         TaLA==
X-Forwarded-Encrypted: i=1; AJvYcCU4SoF785i9vPour+E4DOITum/9TeY/phedMphWSUgB+oLpU5lBTet81ABzsqYKvaHUYJg=@vger.kernel.org
X-Gm-Message-State: AOJu0YymhcRr2MCv2alPTravZ3nSNbr6gMMb+ruhv9ax3sRefblHwRTk
	8iiMejRrkNTNVUaEGrVyCYOkuMk1SoElvTDSAG6C2wgo8jl8y86MOmCJ3PASfwM=
X-Gm-Gg: ASbGncuy889NQxQIzC1+LBsnJH2RXYxSZSumIaeoh+4bjcbS8nVFTCWZI5H4oNlXR7M
	rz4ZoSHGgu4HQiFHhw/OEDyWbnHRIYOUAgB/WDfbHN8PrPv3IXv3kqqOUQDD0+hlKL+r05Kzdgu
	sb1FCMIpZEHDJ+KjSOHOdOcoqCLc/iCRUCV91Q1+XWz6bQC4wA2MmUoP5je98EmmKIBkrpvHSLF
	qWWwKWP4yFnwcQ87L5Hq7Hn7Nqo+fD72OFBJaTrB/ul30pQarhhPPtWuQwUr8IXxV6nyz/H7/1X
	JTmlmeasUOH7kr9wwGKZF5yoroD3QuWWuTIHg7UMlQ1jhA==
X-Google-Smtp-Source: AGHT+IFYtJx1zpZXoyRZ/KHJTP5G1HNeErNj7hP1Uj5JhhNtVjlp1IKO2nyoOwTegiQflbbotJG7Sw==
X-Received: by 2002:a17:903:2308:b0:215:58be:334e with SMTP id d9443c01a7336-224628603d2mr147459315ad.10.1741619617154;
        Mon, 10 Mar 2025 08:13:37 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-224109e99dfsm79230515ad.91.2025.03.10.08.13.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Mar 2025 08:13:36 -0700 (PDT)
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
Subject: [PATCH v3 06/17] riscv: misaligned: use correct CONFIG_ ifdef for misaligned_access_speed
Date: Mon, 10 Mar 2025 16:12:13 +0100
Message-ID: <20250310151229.2365992-7-cleger@rivosinc.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250310151229.2365992-1-cleger@rivosinc.com>
References: <20250310151229.2365992-1-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

misaligned_access_speed is defined under CONFIG_RISCV_SCALAR_MISALIGNED
but was used under CONFIG_RISCV_PROBE_UNALIGNED_ACCESS. Fix that by
using the correct config option.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
---
 arch/riscv/kernel/traps_misaligned.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/kernel/traps_misaligned.c b/arch/riscv/kernel/traps_misaligned.c
index ffac424faa88..7fe25adf2539 100644
--- a/arch/riscv/kernel/traps_misaligned.c
+++ b/arch/riscv/kernel/traps_misaligned.c
@@ -362,7 +362,7 @@ static int handle_scalar_misaligned_load(struct pt_regs *regs)
 
 	perf_sw_event(PERF_COUNT_SW_ALIGNMENT_FAULTS, 1, regs, addr);
 
-#ifdef CONFIG_RISCV_PROBE_UNALIGNED_ACCESS
+#ifdef CONFIG_RISCV_SCALAR_MISALIGNED
 	*this_cpu_ptr(&misaligned_access_speed) = RISCV_HWPROBE_MISALIGNED_SCALAR_EMULATED;
 #endif
 
-- 
2.47.2


