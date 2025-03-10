Return-Path: <kvm+bounces-40663-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D58EA59962
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 16:14:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2595516ADBA
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 15:13:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4A2422D79B;
	Mon, 10 Mar 2025 15:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="vtPsvtJv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE84922D78A
	for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 15:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741619594; cv=none; b=Yx0XzvwUdQK5YUOaZT3//gNmPnTzshxM1xr++92tFQW/WE2wVmhXX9OGlihFXL1lVtfqUWy+sty9pSa3fd4V1DYyv7mR0RNpYEdMrX3TuS9Ls1vO4wOtURSUR8Egaq5mgWv7UIQSNKSqGKR0qpnxiNa7rMyOesEU7xtmVLOwJUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741619594; c=relaxed/simple;
	bh=aVEe61tOXVLff3qc/cOHgfOndrydOzgcDh/F/Umx7y4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fspBn8R9z1lfSc/Ty7N8MrMJcpxHTFkpfBYU7XSHmMlOQWSIVlmUu5KXHsqRkxCIadaJimei/0gOmlqDWnaPcx1CHAGei9JJNxyF9KM2f95+iK/mScVQS+eabdRA7mRsxC+PBa7PVlVvGUfo57qI3/dgiYa6MzBGxxDjhToDeuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=vtPsvtJv; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2254e0b4b79so11951555ad.2
        for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 08:13:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1741619592; x=1742224392; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x8ehbEB4G2M6rMKgF63InF+3qW6jpnoI0lm2nt0Msdk=;
        b=vtPsvtJvFkUSdsSzgYc5yD3mkT13eqYS7KFK2pij5UMVP8SRQoVkn3qp5/v5rCePvp
         AMEy7BJLesq1YxJTyep4r70TF15mYcF57FxtSlO+b1LmKe89NW4DIR0ZrwXlbQA2/T89
         qrNaI/imM9qSYBu+WdW7O06/1HMPTaKp0gxRhRfvZRfFZolBdpbq1ALLkrUvC4HHQHHJ
         lQo8hEz5kYBGS5LESlzJtp5EUxJKiawJph0sYg7QLBiCLkmwkHUAytO8OIFYhNHawWSx
         O7dgNBL8UMQfaFTU6cGISU5l5+RIH/rsvfviTellS0ry6Yf8Hr1UpgI50WF370OsYLE1
         D3Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741619592; x=1742224392;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x8ehbEB4G2M6rMKgF63InF+3qW6jpnoI0lm2nt0Msdk=;
        b=JUZ4zonMN9cmxiCXApEcUUTwmxOO15QS6SQmcLZVx3M5ea2LTIKILi8c3dPYGDPBlC
         3rsqnGgaS80tgTnZYjMHEWuhEwvyl4o83EDUPt84hLNWSDUqiRa3KjdJL1yCyPhSjorG
         S3BPWGZyLyK5vQ6A0+ZXwA0gbz5lBLkz+MytONBHSGVdG+wLkPsL22rHmJKrLwFsDMNl
         n/MwH9ZnUDUVpxTzix0ybVXGiDwqLaszXZwBErPfihE76aVEfqilMdDriB6N7ZH54bfJ
         KPa9fw5NQCE6yyd4TOstgi0vRRLSaFMD7yy0QU0s82Xq53yGeNUyRkiisSdbTUEvbva2
         jtWw==
X-Forwarded-Encrypted: i=1; AJvYcCUV15AGARo3G1UGSfPX0HcJTJ1m46bjwI4lQP8b3gWoNRB4lqjfKJ8MFKt6sJ0yySx802I=@vger.kernel.org
X-Gm-Message-State: AOJu0YwlMUFmTiEj4z/mgSSCj6BTZ2MvX6WVEUABmGR3KT3TjtWRCh3D
	JKvOQbnJXqWuYshwEX/2EXcJWzK1zXNivAjG4rX2j/M97hxBLQpF9rg8hi1uTmY=
X-Gm-Gg: ASbGnctWzJafUmVDrKb7UNQyAQ3NSDu7I0UyfWacNl59WRSwOp0xuEmNUxrdcNuEh80
	zPJwggIXs983t0NfM9btMUmwtEDJetVG4A918ZuuUI8/fx1iywST8SH5D/yvXkcn0ffqVhn/Iz/
	ID9gL7hKhv8w7N85PJwGnwHigL/qkqxQLo7uniuWdtZjmCng60iv1YnwRMI7FlKgcC1+3V+CIaf
	Z+tW7I7OQ2ClEAcuynSemWT4w/j6jHUeGebT5Ra4b177imrLb6HthN+hCH9JckYd6JeQHw25ZJS
	MTFLNaQw0nbbnWkvhE3aWleh32gU6Us9xzVYHBWCJ92DLA==
X-Google-Smtp-Source: AGHT+IHx06QKyqqktCp5VtJUo5IN0vcBDSsl9L3/ywFUKF9aCYPEgmbUbCQl4AVArEAbrJmDgZ6oCQ==
X-Received: by 2002:a17:903:2405:b0:224:24d5:f20a with SMTP id d9443c01a7336-22428bfdba7mr268684275ad.48.1741619592004;
        Mon, 10 Mar 2025 08:13:12 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-224109e99dfsm79230515ad.91.2025.03.10.08.13.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Mar 2025 08:13:11 -0700 (PDT)
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
Subject: [PATCH v3 03/17] riscv: sbi: add SBI FWFT extension calls
Date: Mon, 10 Mar 2025 16:12:10 +0100
Message-ID: <20250310151229.2365992-4-cleger@rivosinc.com>
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

Add FWFT extension calls. This will be ratified in SBI V3.0 hence, it is
provided as a separate commit that can be left out if needed.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
---
 arch/riscv/kernel/sbi.c | 30 ++++++++++++++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/kernel/sbi.c b/arch/riscv/kernel/sbi.c
index 256910db1307..af8e2199e32d 100644
--- a/arch/riscv/kernel/sbi.c
+++ b/arch/riscv/kernel/sbi.c
@@ -299,9 +299,19 @@ static int __sbi_rfence_v02(int fid, const struct cpumask *cpu_mask,
 	return 0;
 }
 
+static bool sbi_fwft_supported;
+
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
@@ -314,7 +324,15 @@ int sbi_fwft_get(u32 feature, unsigned long *value)
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
@@ -389,6 +407,9 @@ static int sbi_fwft_feature_local_set(u32 feature, unsigned long value,
 int sbi_fwft_all_cpus_set(u32 feature, unsigned long value, unsigned long flags,
 			  bool revert_on_fail)
 {
+	if (!sbi_fwft_supported)
+		return -EOPNOTSUPP;
+
 	if (feature & SBI_FWFT_GLOBAL_FEATURE_BIT)
 		return sbi_fwft_set(feature, value, flags);
 
@@ -719,6 +740,11 @@ void __init sbi_init(void)
 			pr_info("SBI DBCN extension detected\n");
 			sbi_debug_console_available = true;
 		}
+		if ((sbi_spec_version >= sbi_mk_version(2, 0)) &&
+		    (sbi_probe_extension(SBI_EXT_FWFT) > 0)) {
+			pr_info("SBI FWFT extension detected\n");
+			sbi_fwft_supported = true;
+		}
 	} else {
 		__sbi_set_timer = __sbi_set_timer_v01;
 		__sbi_send_ipi	= __sbi_send_ipi_v01;
-- 
2.47.2


