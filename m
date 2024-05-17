Return-Path: <kvm+bounces-17620-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0581B8C8890
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 16:54:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7CB571F289B0
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 14:54:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A378B6EB49;
	Fri, 17 May 2024 14:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="NPTy3bM6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 114B96BB45
	for <kvm@vger.kernel.org>; Fri, 17 May 2024 14:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715957602; cv=none; b=b9wrMz9AkcT0ZTCTnisTRvN9nHY36n15y62uruerr6C8cOGIcSfV+vDSFrAnJjrPkpPtT8FDZm+bZPmu6C20XDtqWB4sALNcUUwuALA0hZH0I1jCLnYjWp7y7820UvCNn4jLyaUyR8KXLEcex/czJWJlId7a0HyAdAflPNilhTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715957602; c=relaxed/simple;
	bh=LVrkH9IVUx7mgbMsu9uapm2fQaZPUX17Rdmp94is1Z0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tdgcslbqNJaa4HkZmxWguYk/Ahk5NV6zFmLScassQpn9T6VwvO34JRCe0HI07nQFb5EjbeQLsgus+4lq+lnCKbXVEUjl7LNlEog6GEh/tE+UHu5PZfU7e+U3sGXizBClraGcA7TQYNCw48/MUejfdu0ibTzUjNBr8lrMBzG2wb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=NPTy3bM6; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-351d30ade7fso38443f8f.2
        for <kvm@vger.kernel.org>; Fri, 17 May 2024 07:53:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1715957599; x=1716562399; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mlgURxZu8fG6RfbwOGV4+VYUtdkFAEEBFMEpVJI3jww=;
        b=NPTy3bM6E0lXq0jwhjb19JenvL/DJjvKD8ov/UI2AcOkO53aZQRz30qyEomcU8qSdc
         7HjTjof+erEhAsm/J9M6cnI6/Pko65vYIXJ1FtTq/mud6U8dd7yGTKd6HjUOGwgQMJQr
         HfTD4RFZR+w6hXu5UWvbDs4EQxhZMY0dhvVUQskcRFFvCbl+RA3ghA1uUZLrn5amvnGT
         fBHp4G21GlST7EdccGQc17NH6zqudGtBpU1gYf03B2DXjsbUS2CKYp7fw31IprQ3d+X+
         ymM+5lzvsikTy1o+bYz8uBZYmICHT1lBXOoV2bLbyus8zoJogrI9MF7F7ZF0/jmBWu3k
         CQlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715957599; x=1716562399;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mlgURxZu8fG6RfbwOGV4+VYUtdkFAEEBFMEpVJI3jww=;
        b=jVqT5USV0JOqWlJjcSTukff7acGKvCwqmWNxVfkz6Eqn3Y4dpVdoCBWvxKpbCSS/DP
         htDhdP1c/BJTFqbAAAiem4tT15+JoajnNwN+3u440UPj5lpp8zcma71/GS0PEEqzdOic
         dcmKZIsclqeVkswogv4zxpb2PhERDPizQr/zBy9n05R7/1cRqSCm1OuGkq4JS+4s43nD
         vZgaynqEUAWDZmyYr1FuU0My3X6GUUgGCuLEOE84Op6gUrLN1L13/rJlUsQbndbll83V
         D38Rd2CYyrCzIVoL00TigW0mBCe1VzawYMTdKfkDBVZypRLnOsIqB0u+CyFWj+gmLVot
         +iaA==
X-Forwarded-Encrypted: i=1; AJvYcCUZ5yhP3g/O0CmcKgAok2N9QRarIVTMXO06dzWbW7nwA+GSlhDZAJUhA5aJw8ObIjTAaIN8AuEuFsSFGFcrrbsirxw2
X-Gm-Message-State: AOJu0YxVJYjCHPP0lqg8+1w8HrLdvTy/Jj5mbetDkRd6jw36XhGQjonV
	yOLGMTtWLHO5XCtwmN8QwoIApDufl2kc3n5TuzVHxBy5An8AO9I85TpTZkTusnY=
X-Google-Smtp-Source: AGHT+IF+cFq0XlN1HQdJuEHOqwM1sBxbfnwqtGyG9WotzHLFqO6Kw2Bla6mFarFdrIDutFqb9Mbfrg==
X-Received: by 2002:a05:600c:3b86:b0:41a:c04a:8021 with SMTP id 5b1f17b1804b1-41fea52ed5bmr160325795e9.0.1715957599520;
        Fri, 17 May 2024 07:53:19 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:999:a3a0:46f0:3724:aa77:c1f8])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-41fccce9431sm301723695e9.28.2024.05.17.07.53.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 May 2024 07:53:19 -0700 (PDT)
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
Subject: [PATCH v5 03/16] riscv: hwprobe: export Zimop ISA extension
Date: Fri, 17 May 2024 16:52:43 +0200
Message-ID: <20240517145302.971019-4-cleger@rivosinc.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240517145302.971019-1-cleger@rivosinc.com>
References: <20240517145302.971019-1-cleger@rivosinc.com>
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
index 31c570cbd1c5..3b16a12204b1 100644
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
2.43.0


