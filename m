Return-Path: <kvm+bounces-19998-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1056490F295
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 17:45:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 264201C20D2C
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 15:45:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0F0515ADB8;
	Wed, 19 Jun 2024 15:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="ITXwbOxC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64F0D158D98
	for <kvm@vger.kernel.org>; Wed, 19 Jun 2024 15:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718811680; cv=none; b=b5QEPdcOP42d++QcarpUFb426NRCxA8m2MVe6mchOHdFYOMsa66NDNuntWs9sI0Fb9pda6dlRraYiPFgkd7KdUDK/R+0IM0K3ef6Ey9ln5RBMP4RnS29rbrs8r3upVKaCi7ke8wlYRml64yTBORQAC5HgEegsFiRwqiiQUIOu8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718811680; c=relaxed/simple;
	bh=PUHPKWr8I/6+131J+8evnCxuO40u+RR6EnTMsNxyuZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e4ggUZIWKcCipmSQmVARkUk/jnv8/vsdKmgLPmIhi4B6+RD2SqWkpNVzb2OTGknJCSA5IkwF8VI3cH2dhKdOxP1vO+HTAHj6SQQ1w8GsMYvHbI2VGloGxPbIT/JXzbIrxudyTyZ/Yzw/Ia6QxnLAw0qSA4xGR1Kp/Jv5QNcBK28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=ITXwbOxC; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4247ae93738so283655e9.2
        for <kvm@vger.kernel.org>; Wed, 19 Jun 2024 08:41:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1718811675; x=1719416475; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6obIhMCgJtCMV7DNAB1Eq7WrI+7/yuJDuJixMHQfyjs=;
        b=ITXwbOxC+NnuK/p5lBEBaSn/UosRKsEm3+R2jXM9GJ1bJ4AqGns/m45DaqUSNXWA7n
         vbe34os2CKzyPgUGr6iD1t60wgygSVaZEZZKGFbUhLSu1j6lVdBp9SY2u+3xkh8n0fKe
         FIMl5Y8+KK4bBpseWKXTD9b1+QvJAZ4XWpWsl7coDtFbBdl541ttJY5Gsrpce9yfGQee
         boLIbeUOsPqQfeBdfgt/1CkW3Cp4O1um4uB1pPRgzSPhJbutQLp7Hem203R/Ks4trG7Z
         sa4cZ7LHro2Z5yvUpZIsXOnwjHZvyZIRVXSHVKp6q7HTucXh70mCoKgK59T/0DJ9DrtM
         aYaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718811675; x=1719416475;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6obIhMCgJtCMV7DNAB1Eq7WrI+7/yuJDuJixMHQfyjs=;
        b=ov+r9iGkA+Ykyn7I81KgloBGlahitQ6jD4kHtWrhqSRehCGcVBS6OTuQEogbO1qYdT
         J4oz81EaiPegwKTT901w8uqbIuVJd2lfXGXYdOzsLfrWish7wl6S2uj9joq3fY47eNYO
         pNP24TJxNgCtNWijfcqZzM/2XcihPhQdHT7/txcaYKih1OSc9h3su4OUOYbmX589PueE
         oY0iXDJ+PBEXFWA2skw1SZr1dq3a//eMhyUQ9NIYHpEBGHci5V89RQkIqhWlxujFWz+n
         WVMQotAlESzXD9I5gLYAcWSLYtcLGRYyyHnWQpwHM51lnLj+AYeDx2H2m3s9AJs/MRfC
         EudA==
X-Forwarded-Encrypted: i=1; AJvYcCXXay2z7nE5DqALGGF4lu2dC4aIicdC5bxbgG5s3lMrl30Qe8rqgWXZUdWAC7UQol9FU9AhT15Zwlac6jaiFGKiAxH3
X-Gm-Message-State: AOJu0YyByMmf54Kq1iSFk9M68DXonyH2A0GwGSPw13kWl7ECBCHcPk4x
	X9Px7DleDP+C/FMYwuVMHG6FFV51frgnWkQyMiBTf9BL0pBlnMIfo6GO0frlo7c=
X-Google-Smtp-Source: AGHT+IEsiGCR06DYSznwuNGZ/RtWasKc+Sn+mfD0wbhYFJwAh2e2fAjrUA7ukaEqVJFeFkb/5sRZzQ==
X-Received: by 2002:a05:6000:18a2:b0:360:872b:7e03 with SMTP id ffacd0b85a97d-36313fd733dmr2801721f8f.0.1718811674851;
        Wed, 19 Jun 2024 08:41:14 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:999:a3a0:819d:b9d2:9c2:3b7a])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3607509c785sm17392292f8f.34.2024.06.19.08.41.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jun 2024 08:41:14 -0700 (PDT)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: Jonathan Corbet <corbet@lwn.net>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Conor Dooley <conor@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Anup Patel <anup@brainfault.org>,
	Shuah Khan <shuah@kernel.org>,
	Atish Patra <atishp@atishpatra.org>
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	linux-doc@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH 4/5] RISC-V: KVM: Allow Zaamo/Zalrsc extensions for Guest/VM
Date: Wed, 19 Jun 2024 17:39:11 +0200
Message-ID: <20240619153913.867263-5-cleger@rivosinc.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619153913.867263-1-cleger@rivosinc.com>
References: <20240619153913.867263-1-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Extend the KVM ISA extension ONE_REG interface to allow KVM user space
to detect and enable Zaamo/Zalrsc extensions for Guest/VM.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
---
 arch/riscv/include/uapi/asm/kvm.h | 2 ++
 arch/riscv/kvm/vcpu_onereg.c      | 4 ++++
 2 files changed, 6 insertions(+)

diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
index a6215634df7c..f10c6e133d4d 100644
--- a/arch/riscv/include/uapi/asm/kvm.h
+++ b/arch/riscv/include/uapi/asm/kvm.h
@@ -174,6 +174,8 @@ enum KVM_RISCV_ISA_EXT_ID {
 	KVM_RISCV_ISA_EXT_ZCD,
 	KVM_RISCV_ISA_EXT_ZCF,
 	KVM_RISCV_ISA_EXT_ZCMOP,
+	KVM_RISCV_ISA_EXT_ZAAMO,
+	KVM_RISCV_ISA_EXT_ZALRSC,
 	KVM_RISCV_ISA_EXT_MAX,
 };
 
diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
index fa5ee544bc69..0972a997beca 100644
--- a/arch/riscv/kvm/vcpu_onereg.c
+++ b/arch/riscv/kvm/vcpu_onereg.c
@@ -41,7 +41,9 @@ static const unsigned long kvm_isa_ext_arr[] = {
 	KVM_ISA_EXT_ARR(SVINVAL),
 	KVM_ISA_EXT_ARR(SVNAPOT),
 	KVM_ISA_EXT_ARR(SVPBMT),
+	KVM_ISA_EXT_ARR(ZAAMO),
 	KVM_ISA_EXT_ARR(ZACAS),
+	KVM_ISA_EXT_ARR(ZALRSC),
 	KVM_ISA_EXT_ARR(ZBA),
 	KVM_ISA_EXT_ARR(ZBB),
 	KVM_ISA_EXT_ARR(ZBC),
@@ -131,7 +133,9 @@ static bool kvm_riscv_vcpu_isa_disable_allowed(unsigned long ext)
 	case KVM_RISCV_ISA_EXT_SSTC:
 	case KVM_RISCV_ISA_EXT_SVINVAL:
 	case KVM_RISCV_ISA_EXT_SVNAPOT:
+	case KVM_RISCV_ISA_EXT_ZAAMO:
 	case KVM_RISCV_ISA_EXT_ZACAS:
+	case KVM_RISCV_ISA_EXT_ZALRSC:
 	case KVM_RISCV_ISA_EXT_ZBA:
 	case KVM_RISCV_ISA_EXT_ZBB:
 	case KVM_RISCV_ISA_EXT_ZBC:
-- 
2.45.2


