Return-Path: <kvm+bounces-41267-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C5FFA65A1B
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 18:15:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2FDF519C4304
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 17:10:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D8DA1D934D;
	Mon, 17 Mar 2025 17:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="hy+pSBZe"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA68F1B0435
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 17:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742231295; cv=none; b=OnPpGsfPakqkFjhbidwkJyEDhOw69CG+5YnTHQOume4m1KnMzpEnucgwWqoD4sHRChLnUV2AKH2nBRXNCGTCO6LTT5oa2ZgALtoza2eO2EcC5qsr38prcYhgEHG8b7koWKJOjWjx8e4cs7D5igeMsQg6XmWLoJv+UdJ4Sw4F8Oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742231295; c=relaxed/simple;
	bh=U7CU6+Kbf4DBAxOi6Y/TkfLPplKtNBTWKEM0FEOVzX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aIoT9Kc+UmbPZjWgFxP+GZf+xk+ZFTx3g4jPRDlhducmeZXIfMPrON2XoUsLR6ZlVF1EmtfTdNeT5kOp5wkhAmsBCLoycUUHAI623sYVdTHzP1LYQfbQOClLhBt8s9agZdwkHTL6m0dywdKA2lAcdaxKJ7P69/lanGu5w+F/gpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=hy+pSBZe; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-43cf680d351so13283845e9.0
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 10:08:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1742231291; x=1742836091; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MnEzy7kWLGCaTTq9cfZB5uZycg5cp6OZgHd6PiXZO0Y=;
        b=hy+pSBZeNonnztefokC+XfKGDit/V16KT+Hq5dECtpRpGoHKBF4MkUPgRjcZ0VA4zN
         iaZi/WuHWE0+QMYllUt7u2XV5WvWPTWUFgQllCSSx3xOx862TAhjQRAI1xDwL24c1xLZ
         5HsfS7a/sPvcgcXaCBdHcdlQGOYqCmmefGYCoWiTjYPyWqFF2SX2IUFaPN9ZjoJtSobh
         7fLVkoTbPx6ZWWpgSzdypiWAjUNv6gwiT+cUd35svnVUd5G+gMzOsI9meinqhKywK6YN
         JTel8yxkoDqnfjhQ4zNZNPXSTiRVcoRMdqTfJlp6NCHw2Di3NSakQToCux27OUjkdh5X
         wxbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742231291; x=1742836091;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MnEzy7kWLGCaTTq9cfZB5uZycg5cp6OZgHd6PiXZO0Y=;
        b=Uzo3Qyc/UYIPazc97mv0vq/kiluT+KWLQ+2+Pn9G8+jmX/r3/CdRHtgsYCjIGcG1dx
         Cr2TfLdcFc/zcvpFVQ0eg0j4FBSfToyRmjva7dj/mTANX8FvtJNamVCkRoP7MCI3u217
         3MTNCHqDQg94SmBOx1wZ/20SDvndB3Btra8RpBa7Wf5cYK95vtITZZyOSJNY4guxtk8d
         8UuNy2kftkcfvasqZyhr0Vz4gHo8mOumHExZ4duh+wYDscbYWFaQsde68kgc0dnsVxTf
         OZYrzIhFIbKuH33BjK++MT2SpdqGMJ6gIZWVqelPHCmxXjjgoBKDDprLwUvwrJqHX1WJ
         BRIg==
X-Forwarded-Encrypted: i=1; AJvYcCUDoDYvtspKU18djdAyqy4UCD8z58fIvq55We7r/sehILXSca1khaaIFYn+4dys4tDZ4kM=@vger.kernel.org
X-Gm-Message-State: AOJu0YyY4qWaWtHT5C+MsikQUah+2sDxR6Jhx1NACJWjRLgX2El3cYdO
	fUMq+jzhuteKgz+NZqgKH8+NVt04fV3s593BcNjhza0dWid9SZQhhHM4zY8B2YM=
X-Gm-Gg: ASbGncui4EW23yY7FkG8Lb4AEWYF//oai8ia/Zwu2ZUBPNK2aiYrzSoqqZnZ9oFUnxo
	UxOpWxdcqFKRuKS8VdUVtLjhb5hN5dc8lIyRqqzFMxU4dMXBKKvuH3IIa6CqwJM7mFKg6vAhSsS
	lHr5WfHAl6NpLvT4A6A7OznjZH9Ut0zWbvlbsf2RH09Ujtctg06I1jAb+Rheem+yEaT/LvLqYES
	IYy9mDrWaPAVDHHcPIJ3rf04O4cJlUZBT95NNUzPJWGqXTv82xZpPJv/EdvQtGecDUBl/QV+fAi
	dtWgpqGSAruAV3+lZPsky4OF0KgFWd6qPztXyyOsntXGSg==
X-Google-Smtp-Source: AGHT+IEhk9ILCkt1d4miwCrhVE7Pp8SXCLMrmpN073cNBxqpViWwe1YnhF1uSTy7oETuXKPGMPnacQ==
X-Received: by 2002:a05:600c:a53:b0:43d:b33:679c with SMTP id 5b1f17b1804b1-43d390976e7mr2112565e9.14.1742231291216;
        Mon, 17 Mar 2025 10:08:11 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d23cddb2asm96014505e9.39.2025.03.17.10.08.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Mar 2025 10:08:10 -0700 (PDT)
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
	Andrew Jones <ajones@ventanamicro.com>
Subject: [PATCH v4 04/18] riscv: sbi: add SBI FWFT extension calls
Date: Mon, 17 Mar 2025 18:06:10 +0100
Message-ID: <20250317170625.1142870-5-cleger@rivosinc.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250317170625.1142870-1-cleger@rivosinc.com>
References: <20250317170625.1142870-1-cleger@rivosinc.com>
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
---
 arch/riscv/kernel/sbi.c | 30 ++++++++++++++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/kernel/sbi.c b/arch/riscv/kernel/sbi.c
index d41a5642be24..54d9ceb7b723 100644
--- a/arch/riscv/kernel/sbi.c
+++ b/arch/riscv/kernel/sbi.c
@@ -299,6 +299,8 @@ static int __sbi_rfence_v02(int fid, const struct cpumask *cpu_mask,
 	return 0;
 }
 
+static bool sbi_fwft_supported;
+
 /**
  * sbi_fwft_get() - Get a feature for the local hart
  * @feature: The feature ID to be set
@@ -308,7 +310,15 @@ static int __sbi_rfence_v02(int fid, const struct cpumask *cpu_mask,
  */
 int sbi_fwft_get(u32 feature, unsigned long *value)
 {
-	return -EOPNOTSUPP;
+	struct sbiret ret;
+
+	if (!sbi_fwft_supported)
+		return -EOPNOTSUPP;
+
+	ret = sbi_ecall(SBI_EXT_FWFT, SBI_EXT_FWFT_GET,
+			feature, 0, 0, 0, 0, 0);
+
+	return sbi_err_map_linux_errno(ret.error);
 }
 
 /**
@@ -321,7 +331,15 @@ int sbi_fwft_get(u32 feature, unsigned long *value)
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
 
 struct fwft_set_req {
@@ -360,6 +378,9 @@ int sbi_fwft_local_set_cpumask(const cpumask_t *mask, u32 feature,
 		.error = ATOMIC_INIT(0),
 	};
 
+	if (!sbi_fwft_supported)
+		return -EOPNOTSUPP;
+
 	if (feature & SBI_FWFT_GLOBAL_FEATURE_BIT)
 		return -EINVAL;
 
@@ -691,6 +712,11 @@ void __init sbi_init(void)
 			pr_info("SBI DBCN extension detected\n");
 			sbi_debug_console_available = true;
 		}
+		if ((sbi_spec_version >= sbi_mk_version(3, 0)) &&
+		    (sbi_probe_extension(SBI_EXT_FWFT) > 0)) {
+			pr_info("SBI FWFT extension detected\n");
+			sbi_fwft_supported = true;
+		}
 	} else {
 		__sbi_set_timer = __sbi_set_timer_v01;
 		__sbi_send_ipi	= __sbi_send_ipi_v01;
-- 
2.47.2


