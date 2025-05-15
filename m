Return-Path: <kvm+bounces-46660-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DDEFAB8077
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 10:26:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CAD253A4BA0
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 08:26:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8CDE28B3E4;
	Thu, 15 May 2025 08:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="E4ToK4Fb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4687F28D841
	for <kvm@vger.kernel.org>; Thu, 15 May 2025 08:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747297434; cv=none; b=OBuc+jWi/Lh0ckFHpH7oC8mpm46CU2lYLrFdray3l6QLkYsDbabU9M3J74oo3Ic8qEpkc+JIPIwv+RCo+EEo2ozrt8B7RcoBOXRkvxCRfBSWTK0lQD6H3ilLP68jU4HVS7UHxQRLF8l2g+AVsgfpNRMz3cDpepf05N/n9+d9Ek8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747297434; c=relaxed/simple;
	bh=c4f/odBe1fiDkTMfaR/fNuZlpsRWRZtD8/pJ3r41/Zs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z0KrQtQ0EnTXVUyX7inEnMkxzfkLH/60daiff2OY6KpjgmZN8t8Oo3NSy3mwgq2KaJx6o+XJCFAsfKEltFUUW5xY3XDu7E54jEK23gw2fWQ0ni6UGuducUNX6YOeN0n6YYQfT4SeLbjn3nu24UmTyku9GTIuoYIBgMbyA2RqgP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=E4ToK4Fb; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-442ed8a275fso7112205e9.2
        for <kvm@vger.kernel.org>; Thu, 15 May 2025 01:23:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1747297431; x=1747902231; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zKzeirrOKR4aa1/jaJ0+BQzqdgTSTiQsfjIovf/XYis=;
        b=E4ToK4FbzOZfl1cU0NZVGL1Qfml4zKXdCXFbdfgqQeKPQZ8pu4y12qnplxs0kbE0RU
         YTyasQO8ejx1EM2FGdjJQUSiam93pw5GYpqS5o2lUAsoDpUpFEv4Wjkl5lEzeF7C9TGO
         KNhdT946+DvtC/WitJul8fvYVkgw949gdT8yDdcbXN0Wl0GxAomISIHphGyy8ubbc5JQ
         3edCkX3mFAdTw4QuadRsx6iChmkpKgc8fg95ckz9gDVbVqQbAfHfxMXWPAuR4zt7AwJb
         22KIDhj7b+pPk0rpkb3PSPbHYkqUpeDDel5FbUymgh8vduTIgww+rsjV1G4DPKLom6u6
         drRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747297431; x=1747902231;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zKzeirrOKR4aa1/jaJ0+BQzqdgTSTiQsfjIovf/XYis=;
        b=OeuQaVSQlJLKQ60rmHAL7colHGPdD93KoGA0VHP1ZT3/YqisGfbmRJ3f3xTdDHckKw
         MzexnwS8KVsrPX9dQN+adzfX5aUDhZi0BJIZ0r/GU0MzuHJFAI8Yalp4oszaK/8u6HAt
         hpbeTLD7f6Eqxj2mcydiiYoQyMf5bCM/q6b/XZdkT53HNZUeO0fgkqwa+CMAMXTowjoL
         ayKqh8HudgVnXB1obzh+dcNHWlSqsqEjrd3vodOCr3vUd5JNykv9FBcOTamaRYZBAc/z
         OxPvynaNct+7gGzy7Zma31Jl7sI1MPknbeGOPrhV3Z+26BRI/cy6je/ZsdAVNOBCLTuF
         P0lA==
X-Forwarded-Encrypted: i=1; AJvYcCXO7O+oyxBv1eDkQtKNW1Uv0D2L/7T0qiBKWPoGv6g2fxpG8J4U7TmwMegxJEkJOAgMjgE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxh7ifQESxztOzVys3l3Ed1uOGFBYCcHScOtzZkafAjy04XGJkT
	BBk/CzY/nKOlhViXl4bl7hHNB7cM0GhAyO/tvZUm1WzbLwQYzH6XrSon4uVBiI0=
X-Gm-Gg: ASbGncvpdegtZwkikpWJkvYZmLNZ+md58DL5oABiq9YViJ4PDY8eqix7RX0zBYTruCX
	UVSnGFr7/3CAxEGj+u8ckz7sKndbbI/Kw0+jlWXuIk39GFOeqDjqZVsI0g6pyViLK0cP4njml4C
	pL04srFca+qCb/GMVqWtghu/RjeG+VL8JBwQhDps+DOfDRz4cVQq58ZXgWFr+16NWHJZYJy3SxB
	EAwXnH3WK35K8s7OLFlgZs2zAiX2MZVOtE5XZudlPXWC1bqmwvsyAzQrqIsIdy+3t09W8tw+gQt
	STcajdB+MYIq+BZO+eR+l5dif3LfvCtzSmGdhNFySAj7uYgoK88=
X-Google-Smtp-Source: AGHT+IHo18Wz0xfwowIAkjj7FGe8ulZGDuitOfmnOSRcK7rM7RV/Qat3DxuhXQ8uvVsICI2vUu48rQ==
X-Received: by 2002:a05:600c:8411:b0:442:faa3:fadb with SMTP id 5b1f17b1804b1-442faa3fbb1mr9904825e9.2.1747297430595;
        Thu, 15 May 2025 01:23:50 -0700 (PDT)
Received: from carbon-x1.. ([91.197.138.148])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-442f395166fsm59310785e9.18.2025.05.15.01.23.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 May 2025 01:23:49 -0700 (PDT)
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
	Deepak Gupta <debug@rivosinc.com>,
	Atish Patra <atishp@rivosinc.com>
Subject: [PATCH v7 05/14] riscv: sbi: add SBI FWFT extension calls
Date: Thu, 15 May 2025 10:22:06 +0200
Message-ID: <20250515082217.433227-6-cleger@rivosinc.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250515082217.433227-1-cleger@rivosinc.com>
References: <20250515082217.433227-1-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Add FWFT extension calls. This will be ratified in SBI V3.0 hence, it is
provided as a separate commit that can be left out if needed.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Reviewed-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/kernel/sbi.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/kernel/sbi.c b/arch/riscv/kernel/sbi.c
index 818efafdc8e9..53836a9235e3 100644
--- a/arch/riscv/kernel/sbi.c
+++ b/arch/riscv/kernel/sbi.c
@@ -299,6 +299,8 @@ static int __sbi_rfence_v02(int fid, const struct cpumask *cpu_mask,
 	return 0;
 }
 
+static bool sbi_fwft_supported;
+
 struct fwft_set_req {
 	u32 feature;
 	unsigned long value;
@@ -326,7 +328,15 @@ static void cpu_sbi_fwft_set(void *arg)
  */
 int sbi_fwft_set(u32 feature, unsigned long value, unsigned long flags)
 {
-	return -EOPNOTSUPP;
+	struct sbiret ret;
+
+	if (!sbi_fwft_supported)
+		return -EOPNOTSUPP;
+
+	ret = sbi_ecall(SBI_EXT_FWFT, SBI_EXT_FWFT_SET,
+			feature, value, flags, 0, 0, 0);
+
+	return sbi_err_map_linux_errno(ret.error);
 }
 
 /**
@@ -348,6 +358,9 @@ int sbi_fwft_set_cpumask(const cpumask_t *mask, u32 feature,
 		.error = ATOMIC_INIT(0),
 	};
 
+	if (!sbi_fwft_supported)
+		return -EOPNOTSUPP;
+
 	if (feature & SBI_FWFT_GLOBAL_FEATURE_BIT)
 		return -EINVAL;
 
@@ -679,6 +692,11 @@ void __init sbi_init(void)
 			pr_info("SBI DBCN extension detected\n");
 			sbi_debug_console_available = true;
 		}
+		if (sbi_spec_version >= sbi_mk_version(3, 0) &&
+		    sbi_probe_extension(SBI_EXT_FWFT)) {
+			pr_info("SBI FWFT extension detected\n");
+			sbi_fwft_supported = true;
+		}
 	} else {
 		__sbi_set_timer = __sbi_set_timer_v01;
 		__sbi_send_ipi	= __sbi_send_ipi_v01;
-- 
2.49.0


