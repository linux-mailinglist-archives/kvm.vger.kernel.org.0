Return-Path: <kvm+bounces-19972-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A73090E9DB
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 13:41:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B84A91F21537
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 11:41:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A10BD15623A;
	Wed, 19 Jun 2024 11:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="fBwX5wbx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15AAB15531B
	for <kvm@vger.kernel.org>; Wed, 19 Jun 2024 11:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718796961; cv=none; b=m6w/XPbgAVlkrUDZlQwArLbrnDpOG/mXRSZMIcV/2Ng/67vhvRQgtenDmJ3WCiEAnrNW7InK7GkGzq0fG+a0OYWMMAotUnv1O9WhUO2AcvGPiCi1rUfwersrErsNLhpCV3pqveORVQBH9xQeZHoHNuTF1DwWT1nWDqT0DzZptDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718796961; c=relaxed/simple;
	bh=WnNEKkdrHYQlROOz9roUB0YQVGv8HCSMskS6xIZl2yg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GmWWBMZCXcJM537HTfc1+Q5P/mNo3VKcjUkgvRY2HxZsfdc7d2UCycVRyvVASN3UpQ/YFI6BQ7G3jDUVku/Lrn/jbdG37gXRt52PGiUi+/a6IuNuZ9ilecjA5uK1gAAAKLUsKQkOM9z1OkjBwrOjMcPTU6Bw7UDmXfwH4TRoghg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=fBwX5wbx; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-35f0d49a9ebso404620f8f.1
        for <kvm@vger.kernel.org>; Wed, 19 Jun 2024 04:35:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1718796958; x=1719401758; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i8Rh9bxOXlaEjkse1t0jBu0yyoIMzROFmPw8GuSuwXc=;
        b=fBwX5wbxyALEPmpoP1xNcPZXfVDWUN4FYepZmDsiuqkvNg4+h1Ny8cL8hIqvDaU0nE
         Qujzyxq+kBmdtXb1jidt2nNjBaGqnSQMXBZU/1CiAKQRbI3kAeNhFukt9zsWR4mEHtKz
         ki0SyJ1nFZG1oEyEOzstwWB6RYo7/vKfQ3X7pYkSRcH8gDRpgkjZbqlv9Gbkb9YThcJ7
         F47eMJcUOgh5Ru55tJ7TwfFRG8bbMzrqRyYOOyo8Q3Vp8TLPyCf7FwII2ObbrtXvVSzO
         Sqs/DWg83goWY4cUDzkRdLLTG/TUJxibNqVum5qruyjoszVmEP6/SemkDkIpPLMHI3Wm
         RZMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718796958; x=1719401758;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=i8Rh9bxOXlaEjkse1t0jBu0yyoIMzROFmPw8GuSuwXc=;
        b=eYWUyROuO7nOYrEIaZtt6dmGT9VMH4Ho0pWJ0kHC5NnvcQYTlbtqpZAWSRnq0WC+NR
         I7I3yZshFqvQNOKchkSH6C0UnfkRNVkJwc/ZHJlc3OvhyVDA2LmGAGH/WV/7zVWqWn0C
         DVi5H6ZTQTu2w2IDsr3FCm+Q5ZqWr7Zr3bj99tH+SO8x90NQzxleF/FbiOPozfy7abNz
         jIamTO0krffDKTiUkwQgIlXeO0gTnPMpLg2x5ZSmcBcgpDRH0GNrLT+Pk9C350wLS+LV
         iVL3BDUvsvIofwRuLTefZ5cmJA6cAjNfxaXJDof2fDDlrUAWvG1YtJZfeKakWwYXulhL
         lFmA==
X-Forwarded-Encrypted: i=1; AJvYcCWvXG7HeWANPSV4mpQMxshNgtoKVyxxffnyk5kNsWxuEMXkEF3H4yBejBI+Tk/qUnYdwdwyLcIRf+FWnTChdV8PJk4Z
X-Gm-Message-State: AOJu0Ywbp+hIvSGhH9p+EmmwKmykaHkYyAvDieiAQdw9zb6tcodfEVIJ
	7fofBR3qE+wRMWMIY1SaKUsdEIX0hRfv0GhVuyeitPusOQP898Gp3QmY4OjIqr8=
X-Google-Smtp-Source: AGHT+IEdIFzdiJIRJF1/XDFYO2GbdEU/OO890HU6J5fGWsC49e+py363/GxyHm/Q6iewSJjUJ7bm3A==
X-Received: by 2002:a05:600c:4fc9:b0:421:bb51:d630 with SMTP id 5b1f17b1804b1-424752981b8mr15707025e9.2.1718796958528;
        Wed, 19 Jun 2024 04:35:58 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:999:a3a0:e67b:7ea9:5658:701a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-422870e9681sm266192075e9.28.2024.06.19.04.35.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jun 2024 04:35:58 -0700 (PDT)
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
Subject: [PATCH v7 15/16] RISC-V: KVM: Allow Zcmop extension for Guest/VM
Date: Wed, 19 Jun 2024 13:35:25 +0200
Message-ID: <20240619113529.676940-16-cleger@rivosinc.com>
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
to detect and enable Zcmop extension for Guest/VM.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
Reviewed-by: Anup Patel <anup@brainfault.org>
Acked-by: Anup Patel <anup@brainfault.org>
---
 arch/riscv/include/uapi/asm/kvm.h | 1 +
 arch/riscv/kvm/vcpu_onereg.c      | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
index 71b17a6799e6..a6215634df7c 100644
--- a/arch/riscv/include/uapi/asm/kvm.h
+++ b/arch/riscv/include/uapi/asm/kvm.h
@@ -173,6 +173,7 @@ enum KVM_RISCV_ISA_EXT_ID {
 	KVM_RISCV_ISA_EXT_ZCB,
 	KVM_RISCV_ISA_EXT_ZCD,
 	KVM_RISCV_ISA_EXT_ZCF,
+	KVM_RISCV_ISA_EXT_ZCMOP,
 	KVM_RISCV_ISA_EXT_MAX,
 };
 
diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
index f68b15b15f0e..fa5ee544bc69 100644
--- a/arch/riscv/kvm/vcpu_onereg.c
+++ b/arch/riscv/kvm/vcpu_onereg.c
@@ -53,6 +53,7 @@ static const unsigned long kvm_isa_ext_arr[] = {
 	KVM_ISA_EXT_ARR(ZCB),
 	KVM_ISA_EXT_ARR(ZCD),
 	KVM_ISA_EXT_ARR(ZCF),
+	KVM_ISA_EXT_ARR(ZCMOP),
 	KVM_ISA_EXT_ARR(ZFA),
 	KVM_ISA_EXT_ARR(ZFH),
 	KVM_ISA_EXT_ARR(ZFHMIN),
@@ -142,6 +143,7 @@ static bool kvm_riscv_vcpu_isa_disable_allowed(unsigned long ext)
 	case KVM_RISCV_ISA_EXT_ZCB:
 	case KVM_RISCV_ISA_EXT_ZCD:
 	case KVM_RISCV_ISA_EXT_ZCF:
+	case KVM_RISCV_ISA_EXT_ZCMOP:
 	case KVM_RISCV_ISA_EXT_ZFA:
 	case KVM_RISCV_ISA_EXT_ZFH:
 	case KVM_RISCV_ISA_EXT_ZFHMIN:
-- 
2.45.2


