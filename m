Return-Path: <kvm+bounces-19968-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F3A390E9C1
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 13:39:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1CE4B1F2202C
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 11:39:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6689A1514E4;
	Wed, 19 Jun 2024 11:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="IORZRoHn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB87714F9EF
	for <kvm@vger.kernel.org>; Wed, 19 Jun 2024 11:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718796954; cv=none; b=rn7CSob0glPslziIAWCMxKUkDd/u467ncw+qGY6EIb54Jl9uYavLcwN9yrdIhD933dawTRinBNQQAZaaQMFl2DGKszjRAzbW30hOFKZMCPjtx3iF5RGAHFKfxW7fwV9FM/1hUJO73dgBcw5KvgYnU5AX+U6t6BrTU2A/fwDQLm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718796954; c=relaxed/simple;
	bh=wS0PfgYkz/9P/N4HO75l9Imx1hqqHj8YIr6P010xDZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jic3YYy/TzfxyfDRvvZN9PrcluQ3V50p9zyJ4cFlWuT0Unw148NbFsizDon24ghU/x1NKw4rBe8cNVHzPaVdIHbQ3zKuMgkllM3c59F7zPt3QpceDCZZiiN7MS0CJ0ozCtBhp4JaYe+e1q0o4yHxH2EZ54QvyK/9PO91Wy5gGqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=IORZRoHn; arc=none smtp.client-ip=209.85.208.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-2ec34f0110dso1516101fa.1
        for <kvm@vger.kernel.org>; Wed, 19 Jun 2024 04:35:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1718796951; x=1719401751; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8DCplyIcxOlnYOD05MVWPnelaWgV0jkCglAEoSEzjaM=;
        b=IORZRoHnOmQMJjr7+8f4hjH4FOaN9fjHzMYqEkp+UkTZFAcnmkRzCEXll5lxKwCy2p
         kIzI4mVMs4pgM+AC39C4zMZyp5Sk9XnigGJqWpZWbChmcr40xqz8tMnucoxF8SaHF48S
         Xp9gZAl0m+PRiCpYNVfeXHWNivTXoTNaN50oihOmWP37SnRTL6DVh+cuTQe3qOSwGyIa
         Tx97Va3Pa4dw4KfhwT1/JQHyVmsHWBeHywThhsXD67Er/Zf9bZR7gfUm0LjMMJ4rPMNc
         aaqpn1n5qMF1aPNjhdWVIz6SkOrstOMfbn8GHCW5Ri5zJrMQxhMp6240/RoXLihbSgMU
         vQTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718796951; x=1719401751;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8DCplyIcxOlnYOD05MVWPnelaWgV0jkCglAEoSEzjaM=;
        b=EY5cMc7uCnhnlqbmdVLtyeIcRXmBgb6F5QoGRs35kTGnjhl9A4bfMN899HZFyEP3Me
         iJKUgLYkwaRUOUTVNalij4U7RnMgibUOEGbnTiGU3NsBBSxbKeAiMzCf5qlQNyC5GDty
         MdwSyhidxRjQ6Ul9Oapdl+AqKwf5Z9ia/5928u4GJT9y4laKlNZnTVzZv1cwZyUJTJoT
         WXWD19Rm4gUjpphXsiSFtNyGDNm0HVNJvASnd+tPF9o8acbOiVF1jEAsjFz3sEZ3P6Fh
         MsSTxY0ccANtD8OLbmX1xQP2spLjAePBdrCxk8J8/GqBFzmwdPAPUciXe75NLBJHe/vt
         M9bw==
X-Forwarded-Encrypted: i=1; AJvYcCVBKH44P3BuRusgiz1UnuB/jMIe+P9uhvqAreuI8nqrmFbQ03dzrCdFGhVZ6LfFem4GeBdhzA9uRMhnrmBbkQADO4wd
X-Gm-Message-State: AOJu0YzLpGm/krqHcurC0OSBtMFskhBqVI8xahsLUCg/TRM7ByYDtBZu
	jvu14u1hy62ktwP/npv+ghynrKx9ChZlFugX4iFzBdSuS2uKNdr9Kdk5cnOdyL4=
X-Google-Smtp-Source: AGHT+IFl03ofxCd9GRyKvjy/WzBtKYyK50aV8FZIus6pcW5Xx8qBswD4fqlYnwmmuxyZ9pdqNk8BJA==
X-Received: by 2002:a05:651c:1255:b0:2ec:31d9:16e1 with SMTP id 38308e7fff4ca-2ec3cff8f63mr10405361fa.5.1718796949125;
        Wed, 19 Jun 2024 04:35:49 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:999:a3a0:e67b:7ea9:5658:701a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-422870e9681sm266192075e9.28.2024.06.19.04.35.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jun 2024 04:35:48 -0700 (PDT)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: Jonathan Corbet <corbet@lwn.net>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Conor Dooley <conor@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Anup Patel <anup@brainfault.org>,
	Shuah Khan <shuah@kernel.org>
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Atish Patra <atishp@atishpatra.org>,
	linux-doc@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH v7 10/16] RISC-V: KVM: Allow Zca, Zcf, Zcd and Zcb extensions for Guest/VM
Date: Wed, 19 Jun 2024 13:35:20 +0200
Message-ID: <20240619113529.676940-11-cleger@rivosinc.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619113529.676940-1-cleger@rivosinc.com>
References: <20240619113529.676940-1-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Extend the KVM ISA extension ONE_REG interface to allow KVM user space
to detect and enable Zca, Zcf, Zcd and Zcb extensions for Guest/VM.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
Reviewed-by: Anup Patel <anup@brainfault.org>
Acked-by: Anup Patel <anup@brainfault.org>
---
 arch/riscv/include/uapi/asm/kvm.h | 4 ++++
 arch/riscv/kvm/vcpu_onereg.c      | 8 ++++++++
 2 files changed, 12 insertions(+)

diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
index db482ef0ae1e..71b17a6799e6 100644
--- a/arch/riscv/include/uapi/asm/kvm.h
+++ b/arch/riscv/include/uapi/asm/kvm.h
@@ -169,6 +169,10 @@ enum KVM_RISCV_ISA_EXT_ID {
 	KVM_RISCV_ISA_EXT_ZACAS,
 	KVM_RISCV_ISA_EXT_SSCOFPMF,
 	KVM_RISCV_ISA_EXT_ZIMOP,
+	KVM_RISCV_ISA_EXT_ZCA,
+	KVM_RISCV_ISA_EXT_ZCB,
+	KVM_RISCV_ISA_EXT_ZCD,
+	KVM_RISCV_ISA_EXT_ZCF,
 	KVM_RISCV_ISA_EXT_MAX,
 };
 
diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
index 09f0aa92a4da..f68b15b15f0e 100644
--- a/arch/riscv/kvm/vcpu_onereg.c
+++ b/arch/riscv/kvm/vcpu_onereg.c
@@ -49,6 +49,10 @@ static const unsigned long kvm_isa_ext_arr[] = {
 	KVM_ISA_EXT_ARR(ZBKC),
 	KVM_ISA_EXT_ARR(ZBKX),
 	KVM_ISA_EXT_ARR(ZBS),
+	KVM_ISA_EXT_ARR(ZCA),
+	KVM_ISA_EXT_ARR(ZCB),
+	KVM_ISA_EXT_ARR(ZCD),
+	KVM_ISA_EXT_ARR(ZCF),
 	KVM_ISA_EXT_ARR(ZFA),
 	KVM_ISA_EXT_ARR(ZFH),
 	KVM_ISA_EXT_ARR(ZFHMIN),
@@ -134,6 +138,10 @@ static bool kvm_riscv_vcpu_isa_disable_allowed(unsigned long ext)
 	case KVM_RISCV_ISA_EXT_ZBKC:
 	case KVM_RISCV_ISA_EXT_ZBKX:
 	case KVM_RISCV_ISA_EXT_ZBS:
+	case KVM_RISCV_ISA_EXT_ZCA:
+	case KVM_RISCV_ISA_EXT_ZCB:
+	case KVM_RISCV_ISA_EXT_ZCD:
+	case KVM_RISCV_ISA_EXT_ZCF:
 	case KVM_RISCV_ISA_EXT_ZFA:
 	case KVM_RISCV_ISA_EXT_ZFH:
 	case KVM_RISCV_ISA_EXT_ZFHMIN:
-- 
2.45.2


