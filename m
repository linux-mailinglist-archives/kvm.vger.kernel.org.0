Return-Path: <kvm+bounces-18769-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C98DB8FB29C
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 14:47:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 05EF11C214FB
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 12:47:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2776E1474D3;
	Tue,  4 Jun 2024 12:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="wTwg3NIt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E45181465A0
	for <kvm@vger.kernel.org>; Tue,  4 Jun 2024 12:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717505207; cv=none; b=pU+oMjsXjzHfVwaD89yB0eMnprSpV/Er+WIgHbM04dXQxYvh7Uaof7gkdno1FJwfj9AI71Vq6kUUpFMZXdbvpeb6aSw0d3RX307GkEHe5GEpLn8oLctj6HTdPcY8v2z0KveV7q3+82s0c5lqzZE6nLfjylDG617OIzWJtM6cB1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717505207; c=relaxed/simple;
	bh=u3voDzK8CVxidyc2YL89EYzm/B6QMmSUx4PrrWzNx6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R4x2e7waSvieYgTKX71bMkcS5th2ncajCg5caStiQTl1KVxXo0Kuc9+fDIgIpR3NIfWGxKCyMSuxcR5jIJydAc4jgHL4pUm9mev2hQhwmziZ4YU7tfuj6iPEpQ5obx30JruwQILlgNq4B6O3XoTtbhlhKwMJqsI1HEZ1N3zGNFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=wTwg3NIt; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-64ecc2f111dso648529a12.2
        for <kvm@vger.kernel.org>; Tue, 04 Jun 2024 05:46:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1717505204; x=1718110004; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=degCLXX+XHlviO1qHS0Zal5T+84ciDG6Q4Lb35fjmT4=;
        b=wTwg3NIttiCuPs4s/xNU71lHdPlDPb4s3T/uxVhqUCGYeWZJEyjMcQ0qYuGprg5fFu
         iKOecg+YIFrdyGtzyME+oiudsmSUDG4Gps3twPwnRpSXPbztogy4QlAW6hC0DM5sBVSe
         4zAO7QgccZXvGjD2IGSnhn6Oncr9x2Ot8FZwZjXlmqdQLRNUQruWqvinJi+3Sprw/VNv
         kgTVwsypgA97K8GjH7djCsHlaffqpO3tH8em2h6aIhRF1otrqXasO2Rn8kyGXG4Aykij
         7LLkUyzOFwiQqNLnnM/RlW9J/Abj2LU8X3JRykmk+7d+LerAL5++Vc+bkAK1ZxpQCRmU
         SMWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717505204; x=1718110004;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=degCLXX+XHlviO1qHS0Zal5T+84ciDG6Q4Lb35fjmT4=;
        b=aGYKamNEn6XEUNyoAyEBtIAfBb29A2MlMPAdWUYvDvkmEltVT/3cCc0BzM75ZD5mBE
         QZbCc1f8h8jVED8/l625YzcmdXCjSASA1F0U2i+PBkSPhB1T0xh8ZHcsnWTjtJ0dL69c
         ZVfNCSNEYzFAI2PtVqqkB467R8hNuNSGOtH2niNuWhYkt9XIZoGMh3KcS5kBl9loU+e7
         4JEkV/cqwWkHnVYkVLE2pMZGH0nqeO+h5pvsy0u2nwSchc5Z7IIPNc/WIkr9KdA3ZK7k
         0vtxCer6CJZefv/ECqpACh4wSk8vLYtIb6+o0TsJ+5cQnvfxlTQLgEjML0i8jeZx525C
         1SUA==
X-Forwarded-Encrypted: i=1; AJvYcCW1S7NW0dfLK4Zel17UjvD9dh7zM2pFWNS9+7Y2i2cPReoZj/w3q65yklC9STaX+Fs5JdgF7raClw0Bqho/5oeMb4os
X-Gm-Message-State: AOJu0Yw+4+AjBOFY3PdmIj23Po82Lg7g19DFze8i5pEB/uXcD6hc+Y7R
	1JwOoXlPHYOPw3T4/0Qydk5gJGQDFRaCmx+IRw/rhm+ZpB80cxdbTNIeQzg7Bco=
X-Google-Smtp-Source: AGHT+IE7zjnoMPDLUunpx6Exg1+SZFG8SqiUAnSVY1fKx+9xoXFT3WVdqzkHkbK298PA0agj34W4eA==
X-Received: by 2002:a05:6a21:339e:b0:1af:d9a3:f3a3 with SMTP id adf61e73a8af0-1b26f327d1amr13632883637.4.1717505204132;
        Tue, 04 Jun 2024 05:46:44 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:999:a3a0:327b:5ba3:8154:37ed])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f6323ebc69sm83042885ad.211.2024.06.04.05.46.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jun 2024 05:46:43 -0700 (PDT)
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
	linux-kselftest@vger.kernel.org,
	Charlie Jenkins <charlie@rivosinc.com>
Subject: [PATCH v6 03/16] riscv: hwprobe: export Zimop ISA extension
Date: Tue,  4 Jun 2024 14:45:35 +0200
Message-ID: <20240604124550.3214710-4-cleger@rivosinc.com>
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

Export Zimop ISA extension through hwprobe.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
Reviewed-by: Charlie Jenkins <charlie@rivosinc.com>
---
 Documentation/arch/riscv/hwprobe.rst  | 4 ++++
 arch/riscv/include/uapi/asm/hwprobe.h | 1 +
 arch/riscv/kernel/sys_hwprobe.c       | 1 +
 3 files changed, 6 insertions(+)

diff --git a/Documentation/arch/riscv/hwprobe.rst b/Documentation/arch/riscv/hwprobe.rst
index 204cd4433af5..48be38e0b788 100644
--- a/Documentation/arch/riscv/hwprobe.rst
+++ b/Documentation/arch/riscv/hwprobe.rst
@@ -192,6 +192,10 @@ The following keys are defined:
        supported as defined in the RISC-V ISA manual starting from commit
        d8ab5c78c207 ("Zihintpause is ratified").
 
+  * :c:macro:`RISCV_HWPROBE_EXT_ZIMOP`: The Zimop May-Be-Operations extension is
+       supported as defined in the RISC-V ISA manual starting from commit
+       58220614a5f ("Zimop is ratified/1.0").
+
 * :c:macro:`RISCV_HWPROBE_KEY_CPUPERF_0`: A bitmask that contains performance
   information about the selected set of processors.
 
diff --git a/arch/riscv/include/uapi/asm/hwprobe.h b/arch/riscv/include/uapi/asm/hwprobe.h
index dda76a05420b..575b95744843 100644
--- a/arch/riscv/include/uapi/asm/hwprobe.h
+++ b/arch/riscv/include/uapi/asm/hwprobe.h
@@ -60,6 +60,7 @@ struct riscv_hwprobe {
 #define		RISCV_HWPROBE_EXT_ZACAS		(1ULL << 34)
 #define		RISCV_HWPROBE_EXT_ZICOND	(1ULL << 35)
 #define		RISCV_HWPROBE_EXT_ZIHINTPAUSE	(1ULL << 36)
+#define		RISCV_HWPROBE_EXT_ZIMOP		(1ULL << 37)
 #define RISCV_HWPROBE_KEY_CPUPERF_0	5
 #define		RISCV_HWPROBE_MISALIGNED_UNKNOWN	(0 << 0)
 #define		RISCV_HWPROBE_MISALIGNED_EMULATED	(1 << 0)
diff --git a/arch/riscv/kernel/sys_hwprobe.c b/arch/riscv/kernel/sys_hwprobe.c
index 969ef3d59dbe..fc6f4238f0b3 100644
--- a/arch/riscv/kernel/sys_hwprobe.c
+++ b/arch/riscv/kernel/sys_hwprobe.c
@@ -112,6 +112,7 @@ static void hwprobe_isa_ext0(struct riscv_hwprobe *pair,
 		EXT_KEY(ZACAS);
 		EXT_KEY(ZICOND);
 		EXT_KEY(ZIHINTPAUSE);
+		EXT_KEY(ZIMOP);
 
 		if (has_vector()) {
 			EXT_KEY(ZVBB);
-- 
2.45.1


