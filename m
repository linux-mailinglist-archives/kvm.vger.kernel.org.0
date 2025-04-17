Return-Path: <kvm+bounces-43573-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A40FDA91BF2
	for <lists+kvm@lfdr.de>; Thu, 17 Apr 2025 14:26:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AC149444774
	for <lists+kvm@lfdr.de>; Thu, 17 Apr 2025 12:26:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8012324BC1E;
	Thu, 17 Apr 2025 12:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="qiwDCHH9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36C1924BBF5
	for <kvm@vger.kernel.org>; Thu, 17 Apr 2025 12:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744892694; cv=none; b=SQ5fR1wPBoJjbxhbIgMKQ9tXGTPM2RxRDGNYPyZhLRaMvz1dpiK3ye96AGdikk+XYFOlXG8s1or0pxJsjsKCITXZPItvKCFscTzYumoLpvpMV3RZU+f+PNHeRM0wvSTzJzOS9oMF/cnf+kVBWv2BnmlLv86s6hq3UqNO1F5zF/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744892694; c=relaxed/simple;
	bh=bRiCyLVUVK7d4rz7Vi4ci6OEXpinPX3bNStrcUxvF1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jpJBnLl2eaDEWJotOEzcycH6gmIGxGius2FCBkPeDHwwFjQwMfbh08/fGrYcwXtznFQlvDgBHPgrexosNHUW69jCed2IG4CuoRvD3IPGL4hk1rQSaMWCT9nEuhhbo7NNJA8bFG4hIssCchMrOh+ZCSEwiXK2Vln4fY1I4O9ktTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=qiwDCHH9; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2255003f4c6so7775595ad.0
        for <kvm@vger.kernel.org>; Thu, 17 Apr 2025 05:24:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1744892692; x=1745497492; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UzbGeZkhDryHTbPMrJ1IX4plytmQ+QFf0x8BSly6zWo=;
        b=qiwDCHH9j/+kBo7QKWgWYzQx+FT/gH4a+/q5Mp2YLT9t+UpUxEmx3S+itJFsuY80ET
         92gT9rLZ6TjvFfYborp51BSMQwzveu5TUv+wHnC4W7cpzK6jWefSAKdnbWlwobzcdWWw
         xOyifAv4Txz5EOUdFiAGhPRjisUcwIMcHTloxF7/wh58shFpGBGbSRevXIap9NTDTJMs
         LXAXLimStKZ+sqNy6FJ1x43C4Upx8UDCMbpdsT5QbpGMrKhOq1kn09wN++EN8U6iTdjj
         zIzmgy+3b5KFanLAr0e4ac5X7sf+ZnRZlTR2mO/wFhqkyYqLkuVvqgR53XzL7bw/lPWJ
         PyAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744892692; x=1745497492;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UzbGeZkhDryHTbPMrJ1IX4plytmQ+QFf0x8BSly6zWo=;
        b=cMj3yCIi2IZ134rLF+skwW7wFfsglgWqwbCXOq18rohtycOdo4QJLRX1jPEMjaVu3q
         GvLZkM0pwpFgmHlcDSbAEK0DGjSI6ZEFACrPjwa2p9GpNUXYYILz/BeQ1uy8WYkqmVTs
         biWMqcXTzM0FQgbnKjYF5FWImgAI6PCGvfvpiAff4mQ+KNPGi/KEEp4hkHRC4MqgSEP8
         lP8zFJTIFPkbEko9BRju0kvC8UiJ2cm5GjbRFTfh83CRcsa73yvXWotNTVDg4Je/IZ+3
         YNW6Z9q5dkQSewxr0/NS4PbhVy27Jtr07hls04/eJhswghLvy1i8Z53bg/aPBBfClyjq
         2W4A==
X-Forwarded-Encrypted: i=1; AJvYcCXULaBfCvoVvvS+e9AxfBsZ4meV8TbdEPGgX0tPgEgDITCPfT6rZ9AOpwwkol3q2h3VVtE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzjiZzPmr4rOHzCtPTkCSqD1ko8ewTvPJgEGwxgiDAtiGPImwQo
	BXpho0YmQyd/K4RrzyEyjJEIAhc89WVtLPYDSI/UDBpTxAKHhJA0PMtWyudoPeg=
X-Gm-Gg: ASbGncvQ7ZWLQCLxnnDfKu4rOB7MIo+xOS4/qxLuYSaXzulb/iVskxbmKVfYzq7uxAb
	70jhWcpVUM5cBfD+cdBxc1znYmVj7GzJFkGRyfLOAA+10yoqfVXtXOG2HfUELD43o7/ovxybEz1
	ei9CJQiojJEu/qIvtbinpeB2xpkBHAJuVHqmJgSjYsmTSJcnY66SpPIsLdR8V1V5CD4k9zcnZWg
	7tSAy/ebzxr3WMR6JqQHT65+/5KuCXP98UV2jbXjtMz43q//EOb7nDTX9zl/ZVKp9QaV4aP5G59
	4kphI+Wo3aWKCFb99RCh+EtYtmeily283MHbwRg6Jw==
X-Google-Smtp-Source: AGHT+IG6jlQ44pwh9wX1WCDRI6TvuxV3hUxEozeeET2dKmcHLpN+5Bivs6u3n/jRgCZSuvYV8jlCbA==
X-Received: by 2002:a17:902:f642:b0:224:26fd:82e5 with SMTP id d9443c01a7336-22c359a248emr91338345ad.48.1744892692486;
        Thu, 17 Apr 2025 05:24:52 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22c3ee1a78dsm18489415ad.253.2025.04.17.05.24.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Apr 2025 05:24:51 -0700 (PDT)
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
Subject: [PATCH v5 06/13] riscv: misaligned: use on_each_cpu() for scalar misaligned access probing
Date: Thu, 17 Apr 2025 14:19:53 +0200
Message-ID: <20250417122337.547969-7-cleger@rivosinc.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417122337.547969-1-cleger@rivosinc.com>
References: <20250417122337.547969-1-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

schedule_on_each_cpu() was used without any good reason while documented
as very slow. This call was in the boot path, so better use
on_each_cpu() for scalar misaligned checking. Vector misaligned check
still needs to use schedule_on_each_cpu() since it requires irqs to be
enabled but that's less of a problem since this code is ran in a kthread.
Add a comment to explicit that.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
---
 arch/riscv/kernel/traps_misaligned.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/kernel/traps_misaligned.c b/arch/riscv/kernel/traps_misaligned.c
index 058a69c30181..fbac0cf1fd30 100644
--- a/arch/riscv/kernel/traps_misaligned.c
+++ b/arch/riscv/kernel/traps_misaligned.c
@@ -610,6 +610,10 @@ bool __init check_vector_unaligned_access_emulated_all_cpus(void)
 {
 	int cpu;
 
+	/*
+	 * While being documented as very slow, schedule_on_each_cpu() is used since
+	 * kernel_vector_begin() expects irqs to be enabled or it will panic()
+	 */
 	schedule_on_each_cpu(check_vector_unaligned_access_emulated);
 
 	for_each_online_cpu(cpu)
@@ -630,7 +634,7 @@ bool __init check_vector_unaligned_access_emulated_all_cpus(void)
 
 static bool unaligned_ctl __read_mostly;
 
-static void check_unaligned_access_emulated(struct work_struct *work __always_unused)
+static void check_unaligned_access_emulated(void *arg __always_unused)
 {
 	int cpu = smp_processor_id();
 	long *mas_ptr = per_cpu_ptr(&misaligned_access_speed, cpu);
@@ -671,7 +675,7 @@ bool __init check_unaligned_access_emulated_all_cpus(void)
 	 * accesses emulated since tasks requesting such control can run on any
 	 * CPU.
 	 */
-	schedule_on_each_cpu(check_unaligned_access_emulated);
+	on_each_cpu(check_unaligned_access_emulated, NULL, 1);
 
 	for_each_online_cpu(cpu)
 		if (per_cpu(misaligned_access_speed, cpu)
-- 
2.49.0


