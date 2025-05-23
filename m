Return-Path: <kvm+bounces-47529-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 295F7AC1DF6
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 09:55:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DDE5F4E704E
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 07:55:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8277B28467A;
	Fri, 23 May 2025 07:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="LZ3GNq01"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04C2617A30F
	for <kvm@vger.kernel.org>; Fri, 23 May 2025 07:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747986909; cv=none; b=ZbasHcb9zNB1HHJPefBTghkxBD1m9o6V8plnWPwbB++icx4/lqOVyScEzv7TCU+LTjEtuc2SxFysZ1eMWmpjzlQSXIlto1AJcWR6eZpeG0M/qsu9//fV05ZBs3nOoCD76klzS3nDrJTsOKTJeiEkE3H6Jf9YWID9e7eluEbtEXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747986909; c=relaxed/simple;
	bh=v/eU5jGg9rZ8RkTAxtzmxVdLSHFuEH3fRJlu/EIrGL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Gd3uFf/MuwPOtGd9khwnSHCxuDfe6cqrQwPjhUqJZDuqXH0ZuQIS+Knm18yzw6Lu8DnV2wcSDsTTnbXkoyqzKWPGdVm0BSQqtDXJhwgIRSdLb9ZHn0S0EwZalZ2odkQ8z7K3oM2MrDm4ZPQZg7BZL3iJ1KNmiPPgf9TmBpQaHKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=LZ3GNq01; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-30e8feb1830so5870988a91.0
        for <kvm@vger.kernel.org>; Fri, 23 May 2025 00:55:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1747986907; x=1748591707; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Wkz5btPSakbSGWg9/hz+J+zFRiWVxpXranSpFqzg2V4=;
        b=LZ3GNq01G3KRnwlrkU1jCGN2/gbg/vs8dE2arXiN92GjhzQS+HmzqRoSIRjcRd7SlA
         f+R838+cqN7yssiL4gLBQwU3JBf34w5SR2ca2dHF3g7UYbh0HOJqBJBAukTkmNgkZwCM
         67obX3V2V2SPYMbtWOqNunkmAeZxSPNTaaYRo273CV21O062/oQiQqfXFZs0zPDt8hmd
         FFhz88vpOkSbfgWuMHltTOcEX0wuyu22pKhza6TfjHrOTTecVjq+YEhRX/zBotMy/QuJ
         KQcVTmD3Nf3mlpM+9jIVm2uGTVfKzFIAWrZKv9KPlJU4dsvU6sSUv+MN0RGB67XK6atG
         EnOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747986907; x=1748591707;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Wkz5btPSakbSGWg9/hz+J+zFRiWVxpXranSpFqzg2V4=;
        b=WQcMuar3ER0JH22wgZ84qGcwqfaJD2ESbPU9TWPrp0P6tStvrzB1syiAvL/7QNMu8b
         cT+JHbAZTpVrWTFCDCRtOfO8FcXz7Wfh/CmKEhMS9+4UGjlYZ65a2SEpc7XYMVQaIv3A
         DWCeOBbq8SkWmdkUnbLkYLYc8vfKztysjEFa9ntbxGyO6hBbATtrLt/1F8pC3EOWzvL5
         45rtW2jltnF68+4zL2IyLRDQFqXt7xeJRDMPYts4rQSCTwDAFsH0gasDml8e5ztc8oLR
         BiiGneRlVZHwT0greMOeKQ+tdE2eK4U7L/Kr10kC/LBvGjY1vI99tzlkpRdKW6xsJYdR
         XiLg==
X-Gm-Message-State: AOJu0YycmrfsrtZDSYG/oLefl3IBcEFBGBq9Sp67qN22XrbQ9U1g4KQp
	UNXMCFq3xQqQAyCCUGpRiU7tKPaE0kP6F/mgiXDo12HqguweUJ4ymctGhnJzffmmcZ0zAUS0LmU
	UO/NVym4=
X-Gm-Gg: ASbGncsVAkNPq/XdRtBVwopk0GVK4F4BHki4qX8lDZWwskVgEDj+k7f3KncTOSWQ6Hz
	8hybrMqLSUkvDnZ4Ja9XmyPKdZ6UaiGifkpHKYeiVXC/32sZIGZW+ic3jNonywds7gh+YSltpUT
	9IHVfiah9GMVpum8K8dcmSw/KZ34Eo0yrh9aH5+2JFMw+7VRYosYXEEChs7GQHmeJQryJeGYCX8
	vdaI+pzHvVqpkC1mKIXNw1SF19dvYFezajYQv1AKV1Edqk5soN5ZB7I798q2suZiQgoIudqgPAm
	/DLPGweNDj1kxpmx2zhLN1HK1rm2fD5wkQaGGUFZFBnbGjfQShaNQbQrTVzwI+o=
X-Google-Smtp-Source: AGHT+IEPFnlMv+SphSbT2qlgzvzr5e4D7932gMeT71Z7fVhumTSN0YsgZG5uZjC/arGCx/5gT/nsCQ==
X-Received: by 2002:a17:90b:1ccc:b0:30e:823f:ef3a with SMTP id 98e67ed59e1d1-30e823ff012mr42546168a91.30.1747986906641;
        Fri, 23 May 2025 00:55:06 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30f36513bb7sm6767204a91.46.2025.05.23.00.55.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 May 2025 00:55:06 -0700 (PDT)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Ved Shanbhogue <ved@rivosinc.com>
Subject: [PATCH 2/3] lib/riscv: clear SDT when entering exception handling
Date: Fri, 23 May 2025 09:53:09 +0200
Message-ID: <20250523075341.1355755-3-cleger@rivosinc.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250523075341.1355755-1-cleger@rivosinc.com>
References: <20250523075341.1355755-1-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

In order to avoid taking double trap once we have entered a trap and
saved everything, clear SDT at the end of entry. This is not exactly
required when double trap is disabled (probably most of the time), but
that's not harmful.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
---
 riscv/cstart.S | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/riscv/cstart.S b/riscv/cstart.S
index 575f929b..a86f97f0 100644
--- a/riscv/cstart.S
+++ b/riscv/cstart.S
@@ -212,14 +212,15 @@ secondary_entry:
 	REG_S	t6, PT_T6(a0)			// x31
 	csrr	a1, CSR_SEPC
 	REG_S	a1, PT_EPC(a0)
-	csrr	a1, CSR_SSTATUS
-	REG_S	a1, PT_STATUS(a0)
 	csrr	a1, CSR_STVAL
 	REG_S	a1, PT_BADADDR(a0)
 	csrr	a1, CSR_SCAUSE
 	REG_S	a1, PT_CAUSE(a0)
 	REG_L	a1, PT_ORIG_A0(a0)
 	REG_S	a1, PT_A0(a0)
+	li t0, 	SR_SDT
+	csrrc 	a1, CSR_SSTATUS, t0
+	REG_S	a1, PT_STATUS(a0)
 .endm
 
 /*
@@ -227,6 +228,8 @@ secondary_entry:
  * Also restores a0.
  */
 .macro restore_context
+	REG_L	a1, PT_STATUS(a0)
+	csrw	CSR_SSTATUS, a1
 	REG_L	ra, PT_RA(a0)			// x1
 	REG_L	sp, PT_SP(a0)			// x2
 	REG_L	gp, PT_GP(a0)			// x3
@@ -260,8 +263,6 @@ secondary_entry:
 	REG_L	t6, PT_T6(a0)			// x31
 	REG_L	a1, PT_EPC(a0)
 	csrw	CSR_SEPC, a1
-	REG_L	a1, PT_STATUS(a0)
-	csrw	CSR_SSTATUS, a1
 	REG_L	a1, PT_BADADDR(a0)
 	csrw	CSR_STVAL, a1
 	REG_L	a1, PT_CAUSE(a0)
-- 
2.49.0


