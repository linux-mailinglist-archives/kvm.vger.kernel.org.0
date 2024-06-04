Return-Path: <kvm+bounces-18780-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CAB968FB315
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 15:01:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D595AB29130
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 12:52:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8709114A0B3;
	Tue,  4 Jun 2024 12:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="axCOSZJF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 754FA146A8C
	for <kvm@vger.kernel.org>; Tue,  4 Jun 2024 12:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717505336; cv=none; b=ack6HdX/PXAqyh/K6Y9IvGRVv5Iuglb62JXvYcXbMYNKU5y2YuphM32jKAcaM5KmG39WbyL66Qoj0tUFIVdVriZYc5Io9qBWnjKD8F6UNl1+elTIop8CL0QoHPwRY01NXWiu5JdvEp3iiubA6M8MCq3T1N6G1Mleq+n24a0pL7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717505336; c=relaxed/simple;
	bh=fbtxheV0cDi84/+JGvjHvPffIZlUo37W9TjstXw8xkA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b6EMTnerByUT296iIsZtTJ6egCRPPVjI5+aXwgmhWZZMricAwtBdmq2IiLlwWHdKr6HlzuV3DIFi3W4res7xLGvyJnWu7M0+M5AESeqQjEy2Uiw9G3VAUX5cCjhVycROlmQXw6PzBVZ9AQYFKveLfkA8ldje5Tw6BopW4xIUbZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=axCOSZJF; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1f2e3249d5eso4369185ad.3
        for <kvm@vger.kernel.org>; Tue, 04 Jun 2024 05:48:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1717505335; x=1718110135; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lMpkyLkaSRVaEO/feaH2dKMkG1i5I5KHxmVTKeHtvyc=;
        b=axCOSZJFHmZjalteAmh7GYUNwIxDRQwKx6ADb0cg5zObUGmFebB1jin8KgoYENJAO1
         6pEjOlK+mzbot4WC4K81x3/wWFG6wdSTngatm9iO8XqFyLrQsKsl1ykv+2Pq9h6QE05c
         L9NXKp+HY06yX5hNU3+6fTrfiXXqZoTVwAclfWQN+oXfJjICOCIllGIjKWddqct5S2Ku
         3Pt9jLlm5TB1PFHONc1DIq1sS5mVz+8YUIZvttDGbS+henAyhWK25UK0bhQV6v6GWcQb
         nhzt+dg+AOUaucCkneHeGkEeAaSrS8DP0ha1fwLadBn+rk4r43RdHK9knthwc8qEzzm3
         30RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717505335; x=1718110135;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lMpkyLkaSRVaEO/feaH2dKMkG1i5I5KHxmVTKeHtvyc=;
        b=Qj/mN6VJ0txz8atS6utpHAXuVK0IJW95kMOh6TxP9zFMVTl013303DQHdBxwALXD2F
         N9yG8RpXSmtLSQ3NLP8X4mF/unr4ug+nZk1Nu58hGFYcoRGi2AwnGcQz3tLEYtanpMZ5
         kyMNXpeyee+xeetMqYETeMIyVuICkuBuI7twz+arRUo7/noB4ffaWXPXaGKES0ISL/y1
         2dUuptDucVDccTI/+5Xh9LV+qzqoivBoF8goD12ZgrrMeYZJRrsSzlXIr0b7gHTHrBq0
         RIXSYWf7JGbDzVK74rqGIRTWjN6CQmH51PlaM/bNoeRuRQXEivNlJxNwBjrSGTmjyVW0
         FJJg==
X-Forwarded-Encrypted: i=1; AJvYcCXplUYWc1/EvAqvwTdW//YiEBhoAoiYU74LJYMTFraMIxtzM7oyU0k/PYv/Oq7GfeX54IBGBll0WRgeioPWhsVcY5U6
X-Gm-Message-State: AOJu0YztflJxt/MLMqbgBclEnwmIS5M/ZMRp8uiJlDAsJFts2tN2y5zh
	vKv7HWFLEgvxrMufj7qasRpET1aDyx9Q16avnYT51h68KiggiUurIWVLGtYosRU=
X-Google-Smtp-Source: AGHT+IEtbTTmo55M3xpRAMSX5FY5FOioHf0mp6/inxXLLycdHmKwuuvj+1pWBqBBB5zpqi2TeoLukg==
X-Received: by 2002:a17:902:ec8c:b0:1f2:ffbc:7156 with SMTP id d9443c01a7336-1f636fcf230mr130005385ad.1.1717505334634;
        Tue, 04 Jun 2024 05:48:54 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:999:a3a0:327b:5ba3:8154:37ed])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f6323ebc69sm83042885ad.211.2024.06.04.05.48.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jun 2024 05:48:54 -0700 (PDT)
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
Subject: [PATCH v6 14/16] riscv: hwprobe: export Zcmop ISA extension
Date: Tue,  4 Jun 2024 14:45:46 +0200
Message-ID: <20240604124550.3214710-15-cleger@rivosinc.com>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240604124550.3214710-1-cleger@rivosinc.com>
References: <20240604124550.3214710-1-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Export Zcmop ISA extension through hwprobe.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
---
 Documentation/arch/riscv/hwprobe.rst  | 4 ++++
 arch/riscv/include/uapi/asm/hwprobe.h | 1 +
 arch/riscv/kernel/sys_hwprobe.c       | 1 +
 3 files changed, 6 insertions(+)

diff --git a/Documentation/arch/riscv/hwprobe.rst b/Documentation/arch/riscv/hwprobe.rst
index cad84f51412d..9a77b7d14539 100644
--- a/Documentation/arch/riscv/hwprobe.rst
+++ b/Documentation/arch/riscv/hwprobe.rst
@@ -216,6 +216,10 @@ The following keys are defined:
        ("Zcf doesn't exist on RV64 as it contains no instructions") of
        riscv-code-size-reduction.
 
+  * :c:macro:`RISCV_HWPROBE_EXT_ZCMOP`: The Zcmop May-Be-Operations extension is
+       supported as defined in the RISC-V ISA manual starting from commit
+       c732a4f39a4 ("Zcmop is ratified/1.0").
+
 * :c:macro:`RISCV_HWPROBE_KEY_CPUPERF_0`: A bitmask that contains performance
   information about the selected set of processors.
 
diff --git a/arch/riscv/include/uapi/asm/hwprobe.h b/arch/riscv/include/uapi/asm/hwprobe.h
index fba3d74154b1..480d7bb01088 100644
--- a/arch/riscv/include/uapi/asm/hwprobe.h
+++ b/arch/riscv/include/uapi/asm/hwprobe.h
@@ -65,6 +65,7 @@ struct riscv_hwprobe {
 #define		RISCV_HWPROBE_EXT_ZCB		(1ULL << 39)
 #define		RISCV_HWPROBE_EXT_ZCD		(1ULL << 40)
 #define		RISCV_HWPROBE_EXT_ZCF		(1ULL << 41)
+#define		RISCV_HWPROBE_EXT_ZCMOP		(1ULL << 42)
 #define RISCV_HWPROBE_KEY_CPUPERF_0	5
 #define		RISCV_HWPROBE_MISALIGNED_UNKNOWN	(0 << 0)
 #define		RISCV_HWPROBE_MISALIGNED_EMULATED	(1 << 0)
diff --git a/arch/riscv/kernel/sys_hwprobe.c b/arch/riscv/kernel/sys_hwprobe.c
index 11def345a42d..34c95eaf8cd1 100644
--- a/arch/riscv/kernel/sys_hwprobe.c
+++ b/arch/riscv/kernel/sys_hwprobe.c
@@ -115,6 +115,7 @@ static void hwprobe_isa_ext0(struct riscv_hwprobe *pair,
 		EXT_KEY(ZIMOP);
 		EXT_KEY(ZCA);
 		EXT_KEY(ZCB);
+		EXT_KEY(ZCMOP);
 
 		if (has_vector()) {
 			EXT_KEY(ZVBB);
-- 
2.45.1


